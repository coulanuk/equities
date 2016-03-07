-- event table, records entries and departure events from SP500 index
-- event 1 : entered
-- event 0 : left
CREATE TABLE `sp500_evt` (
  `idsp500_evt` int(11) NOT NULL AUTO_INCREMENT,
  `ticker` varchar(20) NOT NULL,
  `date` date NOT NULL,
  `event` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`idsp500_evt`)
) ENGINE=InnoDB AUTO_INCREMENT=2716 DEFAULT CHARSET=latin1;
SELECT ticker FROM stocks.sp500_stk;
