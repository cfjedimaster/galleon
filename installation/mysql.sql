/*
SQLyog Community Edition- MySQL GUI v5.22a
Host - 5.0.24-community-nt : Database - galleon
*********************************************************************
Server version : 5.0.24-community-nt
*/


/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

create database if not exists `galleon`;

USE `galleon`;

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

/*Table structure for table `galleon_conferences` */

DROP TABLE IF EXISTS `galleon_conferences`;

CREATE TABLE `galleon_conferences` (
  `Id` varchar(35) NOT NULL default '',
  `name` varchar(255) NOT NULL default '',
  `description` varchar(255) NOT NULL default '',
  `active` tinyint(1) default NULL,
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



/*Table structure for table `galleon_forums` */

DROP TABLE IF EXISTS `galleon_forums`;

CREATE TABLE `galleon_forums` (
  `id` varchar(35) NOT NULL default '',
  `name` varchar(255) NOT NULL default '',
  `description` varchar(255) NOT NULL default '',
  `readonly` tinyint(1) NOT NULL default '0',
  `active` tinyint(1) NOT NULL default '0',
  `attachments` tinyint(1) NOT NULL default '0',
  `conferenceidfk` varchar(35) NOT NULL default '',
  PRIMARY KEY  (`id`),
  KEY `galleon_forums_conferenceidfk` (`conferenceidfk`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


/*Table structure for table `galleon_groups` */

DROP TABLE IF EXISTS `galleon_groups`;

CREATE TABLE `galleon_groups` (
  `Id` varchar(35) NOT NULL default '',
  `group` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `galleon_groups` */

insert  into `galleon_groups`(`Id`,`group`) values ('AD0F29B5-BEED-B8BD-CAA9379711EBF168','forumsmember'),('AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2','forumsmoderator'),('C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D','forumsadmin');

/*Table structure for table `galleon_messages` */

DROP TABLE IF EXISTS `galleon_messages`;

CREATE TABLE `galleon_messages` (
  `Id` varchar(35) NOT NULL default '',
  `title` varchar(255) NOT NULL default '',
  `body` text NOT NULL,
  `posted` datetime NOT NULL default '0000-00-00 00:00:00',
  `useridfk` varchar(35) NOT NULL default '',
  `threadidfk` varchar(35) NOT NULL default '',
  `attachment` varchar(255) NOT NULL default '',
  `filename` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`Id`),
  KEY `galleon_messages_useridfk` (`useridfk`),
  KEY `galleon_messages_threadidfk` (`threadidfk`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



/*Table structure for table `galleon_ranks` */

DROP TABLE IF EXISTS `galleon_ranks`;

CREATE TABLE `galleon_ranks` (
  `Id` varchar(35) NOT NULL default '',
  `name` varchar(50) NOT NULL default '',
  `minposts` int(11) NOT NULL default '0',
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `galleon_ranks` */

/*Table structure for table `galleon_search_log` */

DROP TABLE IF EXISTS `galleon_search_log`;

CREATE TABLE `galleon_search_log` (
  `searchterms` varchar(255) NOT NULL default '',
  `datesearched` datetime NOT NULL default '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `galleon_search_log` */

/*Table structure for table `galleon_subscriptions` */

DROP TABLE IF EXISTS `galleon_subscriptions`;

CREATE TABLE `galleon_subscriptions` (
  `Id` varchar(35) NOT NULL default '',
  `useridfk` varchar(35) default NULL,
  `threadidfk` varchar(35) default NULL,
  `forumidfk` varchar(35) default NULL,
  `conferenceidfk` varchar(35) default NULL,
  PRIMARY KEY  (`Id`),
  KEY `galleon_subscriptions_useridfk` (`useridfk`),
  KEY `galleon_subscriptions_threadidfk` (`threadidfk`),
  KEY `galleon_subscriptions_forumidfk` (`forumidfk`),
  KEY `galleon_subscriptions_conferenceidfk` (`conferenceidfk`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `galleon_subscriptions` */


/*Table structure for table `galleon_threads` */

DROP TABLE IF EXISTS `galleon_threads`;

CREATE TABLE `galleon_threads` (
  `Id` varchar(35) NOT NULL default '',
  `name` varchar(255) NOT NULL default '',
  `active` tinyint(1) NOT NULL default '0',
  `readonly` tinyint(1) NOT NULL default '0',
  `useridfk` varchar(35) NOT NULL default '',
  `forumidfk` varchar(35) NOT NULL default '',
  `datecreated` datetime NOT NULL default '0000-00-00 00:00:00',
  `sticky` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`Id`),
  KEY `galleon_threads_useridfk` (`useridfk`),
  KEY `galleon_threads_forumidfk` (`forumidfk`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `galleon_threads` */


/*Table structure for table `galleon_users` */

DROP TABLE IF EXISTS `galleon_users`;

CREATE TABLE `galleon_users` (
  `Id` varchar(35) NOT NULL default '',
  `username` varchar(50) NOT NULL default '',
  `password` varchar(50) NOT NULL default '',
  `emailaddress` varchar(255) NOT NULL default '',
  `signature` text NOT NULL,
  `datecreated` datetime NOT NULL default '0000-00-00 00:00:00',
  `confirmed` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `galleon_users` */

insert  into `galleon_users`(`Id`,`username`,`password`,`emailaddress`,`signature`,`datecreated`,`confirmed`) values ('C189C5AC-7E9B-AEC8-1DAEEEA03A562CF0','admin','admin','admin@localhost.com','','2005-01-29 12:00:00',1);

/*Table structure for table `galleon_users_groups` */

DROP TABLE IF EXISTS `galleon_users_groups`;

CREATE TABLE `galleon_users_groups` (
  `useridfk` varchar(35) NOT NULL default '',
  `groupidfk` varchar(35) NOT NULL default ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `galleon_users_groups` */

insert  into `galleon_users_groups`(`useridfk`,`groupidfk`) values ('C189C5AC-7E9B-AEC8-1DAEEEA03A562CF0','C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
