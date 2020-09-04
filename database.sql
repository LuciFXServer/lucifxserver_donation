CREATE TABLE IF NOT EXISTS `donator` (
  `ident` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `level` int(11) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `notification` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;

INSERT INTO `donator` (`ident`, `level`, `priority`, `notification`, `id`) VALUES
('steam:1100001405835b3', 3, 1, 1, 2);