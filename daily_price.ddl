CREATE TABLE `daily_price` (
  `ticker` varchar(5) NOT NULL,
  `price_date` date NOT NULL,
  `open` float NOT NULL,
  `high` float NOT NULL,
  `low` float NOT NULL,
  `close` float NOT NULL,
  `adj_close` float NOT NULL,
  PRIMARY KEY (`ticker`, `price_date`)
) ENGINE=InnoDB CHARSET=latin1;
