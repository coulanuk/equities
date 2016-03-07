-- staging table for SP 500 movements
CREATE TABLE `mv_stage` (
  `idmv_stage` int(11) NOT NULL AUTO_INCREMENT,
  `company_add` varchar(40) DEFAULT NULL,
  `ticker_add` varchar(20) DEFAULT NULL,
  `oldcompany_add` varchar(80) DEFAULT NULL,
  `company_del` varchar(40) DEFAULT NULL,
  `ticker_del` varchar(20) DEFAULT NULL,
  `oldcompany_del` varchar(80) DEFAULT NULL,
  `mv_date` date DEFAULT NULL,
  PRIMARY KEY (`idmv_stage`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

