-- loads membership movements data into mv_stage table
LOAD DATA INFILE '/home/coulan/temp/SP500Changes2.csv' INTO TABLE mv_stage
FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@CompanyAdd,@TickerAdd,@OldCompanyAdd,@CompanyDel,@TickerDel,@OldCompanyDel,@MV_Date,@Year)
set company_add=@CompanyAdd, ticker_add=@TickerAdd, oldcompany_add=@OldCompanyAdd, company_del=@CompanyDel, ticker_del=@TickerDel, oldcompany_del=@OldcompanyDel, mv_date=STR_TO_DATE(@MV_Date,'%d/%m/%Y');


Update recent 2016 changes
    -- Leaving
    INSERT INTO stocks.sp500_evt (ticker, date, event) VALUES ('PCL', '2016-02-22', 0);
    INSERT INTO stocks.sp500_evt (ticker, date, event) VALUES ('PCP', '2016-02-01', 0);
    INSERT INTO stocks.sp500_evt (ticker, date, event) VALUES ('BRCM', '2016-02-01', 0);
    INSERT INTO stocks.sp500_evt (ticker, date, event) VALUES ('CB', '2016-01-19', 0);
    INSERT INTO stocks.sp500_evt (ticker, date, event) VALUES ('ACE', '2016-01-19', 0);
    INSERT INTO stocks.sp500_evt (ticker, date, event) VALUES ('FOSL', '2016-01-05', 0);

    -- entries
    INSERT INTO stocks.sp500_evt (ticker, date, event) VALUES ('WLTW', '2016-01-05', 1);
    INSERT INTO stocks.sp500_evt (ticker, date, event) VALUES ('CB', '2016-01-19', 1);
    INSERT INTO stocks.sp500_evt (ticker, date, event) VALUES ('EXR', '2016-01-19', 1);
    INSERT INTO stocks.sp500_evt (ticker, date, event) VALUES ('FRT', '2016-02-01', 1);
    INSERT INTO stocks.sp500_evt (ticker, date, event) VALUES ('CFG', '2016-02-01', 1);
    INSERT INTO stocks.sp500_evt (ticker, date, event) VALUES ('CXO', '2016-02-22', 1);

1.  Insert clean Additions to sp500_evt
    insert into stocks.sp500_evt (ticker, date, event)
    select ticker_add, mv_date, 1 from stocks.mv_stage where ticker_add != '-' and ticker_add not like '%(%';
    nos = 617

2.  Apply clean deletions to sp500_evt

    insert into stocks.sp500_evt (ticker, date, event)
    select ticker_del, mv_date, 0 from stocks.mv_stage where ticker_del != '-' and ticker_del not like '%(%';
    nos = 595

    total in sp500_evt = 1212

3.  Insert all current members, default startdate is 1 Jan 1990
    done : script SP500Current.py


4.  Merge complete table of all SP companies into SP500_stk from mv_stage:

    -- get distinct add and del companies from mv_stage
    create table mv_stage2 as
    (SELECT ticker_add as ticker, substring_index(company_add, '.', 1) as company FROM stocks.mv_stage 
    where ticker_add != '-' and ticker_add not like '%(%' and ticker_add != '' )
    union distinct
    (SELECT ticker_del as ticker, substring_index(company_del, '.', 1) as company FROM stocks.mv_stage
    where ticker_del != '-' and ticker_del not like '%(%' and ticker_del != ''  )
    order by ticker, company

    957 rows

    606 entries need to be added to SP500_stk:

    SELECT a.ticker, a.company, b.ticker
	FROM stocks.mv_stage2 a
	LEFT JOIN
		 stocks.sp500_stk b
	ON b.ticker = a.ticker
	where b.ticker is null;

    -- remove duplicates having slightly different names
    set session old_alter_table=1;  
    alter ignore table stocks.mv_stage2 add unique (ticker);
    set session old_alter_table=0;

    -- insert missing cleaned entries
    insert into stocks.sp500_stk (ticker, name, sector)
    (
    SELECT a.ticker, a.company, 'UNK' as sector
	    FROM stocks.mv_stage2 a
	    LEFT JOIN
		     stocks.sp500_stk b
	    ON b.ticker = a.ticker
	    where b.ticker is null
     );

5.  Populate start dates for all companies in sp500_evt

    -- 158 companies with no start date in sp500_evt
    insert into stocks.sp500_evt (ticker, date, event)
    SELECT ticker, date_joined, 1
    FROM stocks.sp500_stk 
    where ticker in 
    (
    SELECT distinct a.ticker
	    FROM stocks.sp500_stk a
	    LEFT JOIN
		     stocks.sp500_evt b
	    ON b.ticker = a.ticker
	    where b.ticker is null
    )
    ;

    insert into stocks.sp500_evt (ticker, date, event)
    select lv.ticker, '1990-01-01', 1
    from
    (
    select distinct ticker
    from stocks.sp500_evt
    where event = 0
    ) as lv
    left join (select distinct ticker
    from stocks.sp500_evt
    where event = 1) as en
    on lv.ticker = en.ticker
    where en.ticker is null;
    -- adds 309 entries

    1679 entries now in sp500_evt: all entries have a start date.



Size one table 

    SELECT 
        CONCAT(FORMAT(DAT/POWER(1024,pw1),2),' ',SUBSTR(units,pw1*2+1,2)) DATSIZE,
        CONCAT(FORMAT(NDX/POWER(1024,pw2),2),' ',SUBSTR(units,pw2*2+1,2)) NDXSIZE,
        CONCAT(FORMAT(TBL/POWER(1024,pw3),2),' ',SUBSTR(units,pw3*2+1,2)) TBLSIZE
    FROM
    (
        SELECT DAT,NDX,TBL,IF(px>4,4,px) pw1,IF(py>4,4,py) pw2,IF(pz>4,4,pz) pw3
        FROM 
        (
            SELECT data_length DAT,index_length NDX,data_length+index_length TBL,
            FLOOR(LOG(IF(data_length=0,1,data_length))/LOG(1024)) px,
            FLOOR(LOG(IF(index_length=0,1,index_length))/LOG(1024)) py,
            FLOOR(LOG(data_length+index_length)/LOG(1024)) pz
            FROM information_schema.tables
            WHERE table_schema='stocks'
            AND table_name='daily_price'
        ) AA
    ) A,(SELECT 'B KBMBGBTB' units) B;

