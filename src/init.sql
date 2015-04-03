CREATE SCHEMA IF NOT EXISTS `sample` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `sample`;

CREATE TABLE IF NOT EXISTS `sample`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

INSERT INTO `sample`.`users` (`id`, `name`) VALUES (1, 'name A'), (2, 'name B'), (3, 'name C'), (4, 'name D'), (5, 'name E');
