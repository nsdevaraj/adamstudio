/*
SQLyog Enterprise - MySQL GUI v7.02 
MySQL - 5.1.30-community : Database - lang
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

CREATE DATABASE /*!32312 IF NOT EXISTS*/`lang` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `lang`;

/*Table structure for table `group_persons` */

DROP TABLE IF EXISTS `group_persons`;

CREATE TABLE `group_persons` (
  `group_person_ID` int(11) NOT NULL AUTO_INCREMENT,
  `group_FK` int(11) DEFAULT NULL,
  `person_FK` int(11) DEFAULT NULL,
  PRIMARY KEY (`group_person_ID`),
  KEY `FKDA9D7DFEE0F2A07C` (`group_FK`),
  KEY `FKDA9D7DFE8EAE1DEA` (`person_FK`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

/*Data for the table `group_persons` */

insert  into `group_persons`(`group_person_ID`,`group_FK`,`person_FK`) values (1,2,1);

/*Table structure for table `groups` */

DROP TABLE IF EXISTS `groups`;

CREATE TABLE `groups` (
  `group_ID` int(11) NOT NULL AUTO_INCREMENT,
  `group_label` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`group_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

/*Data for the table `groups` */

insert  into `groups`(`group_ID`,`group_label`) values (1,'ROLE_USER'),(2,'ROLE_ADMIN');

/*Table structure for table `languages` */

DROP TABLE IF EXISTS `languages`;

CREATE TABLE `languages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `formid` varchar(100) DEFAULT NULL,
  `english_label` varchar(256) DEFAULT NULL,
  `french_label` blob,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=52 DEFAULT CHARSET=latin1;

/*Data for the table `languages` */

insert  into `languages`(`id`,`formid`,`english_label`,`french_label`) values (1,'username','Username:','Nom d\'utilisateur:'),(2,'password','Password:','Mot de passe:'),(3,'login','Login','Connexion'),(4,'select','Select Language:','Sélection de la langue:'),(51,'loggedin','Logged In','connecté');

/*Table structure for table `persons` */

DROP TABLE IF EXISTS `persons`;

CREATE TABLE `persons` (
  `Person_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Person_Firstname` varchar(255) DEFAULT NULL,
  `Person_Lastname` varchar(255) DEFAULT NULL,
  `Person_Email` varchar(255) DEFAULT NULL,
  `Person_Login` varchar(20) DEFAULT NULL,
  `Person_Password` varchar(20) DEFAULT NULL,
  `Activated` smallint(1) DEFAULT '1',
  `Person_LoginStatus` varchar(255) DEFAULT 'Offline',
  PRIMARY KEY (`Person_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;

/*Data for the table `persons` */

insert  into `persons`(`Person_ID`,`Person_Firstname`,`Person_Lastname`,`Person_Email`,`Person_Login`,`Person_Password`,`Activated`,`Person_LoginStatus`) values (1,'Deva','Raj','devaraj@wp.pl','deva','raj',1,NULL);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
