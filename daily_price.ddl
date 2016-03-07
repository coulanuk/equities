CREATE TABLE `daily_price` (
  `ticker` varchar(5) NOT NULL,
  `price_date` date NOT NULL,
  `adj_close` float NOT NULL
  PRIMARY KEY (`ticker','price_date'),
) ENGINE=InnoDB CHARSET=latin1;

