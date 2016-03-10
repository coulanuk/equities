CREATE TABLE `trade` (
  `ticker` varchar(5) NOT NULL,
  `trade_date` date NOT NULL COMMENT '	',
  `qty` int(11) NOT NULL COMMENT '	',
  `price` float DEFAULT NULL,
  PRIMARY KEY (`ticker`,`trade_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
