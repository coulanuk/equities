CREATE TABLE `sp500_stk` (
  `idsp500_stk` int(11) NOT NULL AUTO_INCREMENT COMMENT '	',
  `ticker` varchar(20) NOT NULL,
  `name` varchar(40) NOT NULL COMMENT '	',
  `sector` varchar(60) NOT NULL,
  `date_joined` date DEFAULT '1990-01-01',
  `date_left` date DEFAULT NULL,
  `cusip` varchar(15) DEFAULT NULL,
  `yahoo_no_data` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`idsp500_stk`),
  UNIQUE KEY `ticker_UNIQUE` (`ticker`)
) ENGINE=InnoDB AUTO_INCREMENT=1084 DEFAULT CHARSET=latin1;

