CREATE TABLE `trade` (
  `ticker` varchar(5) NOT NULL,
  `trade_date` date NOT NULL,
  `qty` int(11) NOT NULL,
  `price` float DEFAULT NULL,
  `isopen` tinyint(1) DEFAULT 1 NOT NULL COMMENT 'isopen 1 = trade is active; 0=trade closed.',
  PRIMARY KEY (`ticker`,`trade_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
