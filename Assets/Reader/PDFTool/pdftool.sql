/*
SQLyog Enterprise - MySQL GUI v7.02 
MySQL - 5.1.30-community : Database - pdftool
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

CREATE DATABASE /*!32312 IF NOT EXISTS*/`pdftool` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `pdftool`;

/*Table structure for table `file_details` */

DROP TABLE IF EXISTS `file_details`;

CREATE TABLE `file_details` (
  `File_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Filename` varchar(250) DEFAULT NULL,
  `Filepath` varchar(250) DEFAULT NULL,
  `Filedate` datetime DEFAULT NULL,
  `Type` varchar(12) DEFAULT NULL,
  `StoredFileName` varchar(255) DEFAULT NULL,
  `visible` tinyint(1) DEFAULT NULL,
  `release_Status` int(20) DEFAULT NULL,
  `miscellaneous` varchar(255) DEFAULT NULL,
  `File_Category` varchar(255) DEFAULT NULL,
  `page` int(11) DEFAULT NULL,
  PRIMARY KEY (`File_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=866 DEFAULT CHARSET=latin1;

/*Data for the table `file_details` */

insert  into `file_details`(`File_ID`,`Filename`,`Filepath`,`Filedate`,`Type`,`StoredFileName`,`visible`,`release_Status`,`miscellaneous`,`File_Category`,`page`) values (3,'34 Essential Tutorials.pdf','c://temp/Basic/34 Essential Tutorials.pdf','2011-09-09 12:21:58','Basic','34 Essential Tutorials.pdf',1,0,'57DF2D40-4A04-A4F7-69E0-4CF50D3F7237',NULL,0),(4,'34 Essential Tutorials-1.swf','c://temp/Basic/34EssentialTutorials-1.swf','2011-09-09 12:22:01','Basic','34 Essential Tutorials-1.swf',0,0,'57DF2D40-4A04-A4F7-69E0-4CF50D3F7237',NULL,1),(5,'34 Essential Tutorials-2.swf','c://temp/Basic/34EssentialTutorials-2.swf','2011-09-09 12:22:01','Basic','34 Essential Tutorials-2.swf',0,0,'57DF2D40-4A04-A4F7-69E0-4CF50D3F7237',NULL,2),(6,'34 Essential Tutorials-3.swf','c://temp/Basic/34EssentialTutorials-3.swf','2011-09-09 12:22:01','Basic','34 Essential Tutorials-3.swf',0,0,'57DF2D40-4A04-A4F7-69E0-4CF50D3F7237',NULL,3),(7,'Test0011.pdf','c://temp/Basic/Test0011.pdf','2011-09-19 16:31:40','Basic','Test0011.pdf',1,0,'1CA1755D-8FAE-2A2C-F888-81594D6B29A9',NULL,0),(8,'Test0011-1.swf','c://temp/Basic/Test0011-1.swf','2011-09-19 16:31:47','Basic','Test0011-1.swf',0,0,'1CA1755D-8FAE-2A2C-F888-81594D6B29A9',NULL,1),(1,'Test0001.pdf','c://temp/Basic/Test0001.pdf','2011-09-09 12:20:52','Basic','Test0001.pdf',1,0,'1A6FBCF6-A741-307D-133A-4CF42AA165A7',NULL,0),(2,'Test0001-1.swf','c://temp/Basic/Test0001-1.swf','2011-09-09 12:21:04','Basic','Test0001-1.swf',0,0,'1A6FBCF6-A741-307D-133A-4CF42AA165A7',NULL,1);

/*Table structure for table `notes` */

DROP TABLE IF EXISTS `notes`;

CREATE TABLE `notes` (
  `comment_ID` int(11) NOT NULL AUTO_INCREMENT,
  `comment_Title` varchar(250) DEFAULT NULL,
  `comment_X` int(11) DEFAULT NULL,
  `comment_Y` int(11) DEFAULT NULL,
  `comment_Width` int(11) DEFAULT NULL,
  `comment_Height` int(11) DEFAULT NULL,
  `comment_Color` varchar(250) DEFAULT NULL,
  `comment_Description` blob,
  `creation_Date` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `file_fk` int(11) DEFAULT NULL,
  `comment_Type` int(11) DEFAULT NULL,
  `commentBox_X` int(11) DEFAULT NULL,
  `CommentBox_Y` int(11) DEFAULT NULL,
  `comment_Maximize` tinyint(1) DEFAULT NULL,
  `comment_Status` varchar(250) DEFAULT NULL,
  `misc` varchar(250) DEFAULT NULL,
  `history_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`comment_ID`),
  KEY `FK6424EC1AD772D09` (`created_by`),
  KEY `FK6424EC1C41DACCA` (`file_fk`)
) ENGINE=MyISAM AUTO_INCREMENT=267 DEFAULT CHARSET=latin1;

/*Data for the table `notes` */

/*Table structure for table `persons` */

DROP TABLE IF EXISTS `persons`;

CREATE TABLE `persons` (
  `Person_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Person_Firstname` varchar(255) DEFAULT NULL,
  `Person_Lastname` varchar(255) DEFAULT NULL,
  `Person_Email` varchar(255) DEFAULT NULL,
  `Person_Login` varchar(20) DEFAULT NULL,
  `Person_Password` varchar(20) DEFAULT NULL,
  `Person_Position` varchar(255) DEFAULT NULL,
  `Person_Phone` varchar(20) DEFAULT '',
  `Person_Mobile` varchar(20) DEFAULT NULL,
  `Person_Address` varchar(255) DEFAULT NULL,
  `Person_Postal_Code` varchar(50) DEFAULT NULL,
  `Person_City` varchar(50) DEFAULT NULL,
  `Person_Country` varchar(50) DEFAULT NULL,
  `Person_Pict` blob,
  `Person_DateEntry` date DEFAULT NULL,
  `Activated` smallint(1) DEFAULT '1',
  `Person_ActiveChatid` varchar(255) DEFAULT NULL,
  `Person_LoginStatus` varchar(255) DEFAULT 'Offline',
  PRIMARY KEY (`Person_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=147 DEFAULT CHARSET=latin1;

/*Data for the table `persons` */

insert  into `persons`(`Person_ID`,`Person_Firstname`,`Person_Lastname`,`Person_Email`,`Person_Login`,`Person_Password`,`Person_Position`,`Person_Phone`,`Person_Mobile`,`Person_Address`,`Person_Postal_Code`,`Person_City`,`Person_Country`,`Person_Pict`,`Person_DateEntry`,`Activated`,`Person_ActiveChatid`,`Person_LoginStatus`) values (1,'Philippe','Moreau','kutti.kumar@gmail.com','pm2','bre','ROLE_ADMIN','0389745657','',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,'Offline'),(2,'STEPHANE ','MARGERIE ','kutti.kumar@gmail.com','stephane','stephane','ROLE_ADMIN','0389745657','',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,'Offline'),(3,'CELINE ','TAVARES ','kutti.kumar@gmail.com','celine','celine','ROLE_ADMIN','','',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,'Offline'),(4,'MICHEL ','DEMANGE ','kutti.kumar@gmail.com','michel','michel','ROLE_ADMIN','','',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,'Offline'),(5,'Henry','Henry','kutti.kumar@gmail.com','henry','test','ROLE_ADMIN','','',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,'Offline'),(6,'ROSELYNE ','LIMIN ','kutti.kumar@gmail.com','roselyne','roselyne','ROLE_ADMIN','','',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,'Offline'),(7,'JEAN-FRANCOIS ','FLOCH ','kutti.kumar@gmail.com','jeanfrancois','jeanfrancoi','ROLE_ADMIN','','',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,'Offline'),(8,'ANNE ','CHALLOY-TRONTIN ','kutti.kumar@gmail.com','anne','anne','ROLE_ADMIN','','',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,'Offline'),(9,'Sandrine','Badel','kutti.kumar@gmail.com','casino2','test','ROLE_ADMIN','',NULL,NULL,NULL,NULL,'FR',NULL,NULL,1,NULL,'Offline');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
