-- MySQL dump 10.11
--
-- Host: localhost    Database: galleon2
-- ------------------------------------------------------
-- Server version	5.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `galleon_conferences`
--

DROP TABLE IF EXISTS `galleon_conferences`;
CREATE TABLE `galleon_conferences` (
  `Id` varchar(35) NOT NULL default '',
  `name` varchar(255) NOT NULL default '',
  `description` varchar(255) NOT NULL default '',
  `active` tinyint(1) default NULL,
  `messages` int(11) default NULL,
  `lastpost` varchar(35) default NULL,
  `lastpostuseridfk` varchar(35) default NULL,
  `lastpostcreated` timestamp NULL default NULL,
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `galleon_conferences`
--

LOCK TABLES `galleon_conferences` WRITE;
/*!40000 ALTER TABLE `galleon_conferences` DISABLE KEYS */;
INSERT INTO `galleon_conferences` VALUES ('1904BAEA-0FF2-0E2F-1A62FD05B82B77B4','Test','Test',1,5,'19062540-FB97-A65B-1E67D7B89DF805BD','C189C5AC-7E9B-AEC8-1DAEEEA03A562CF0','2007-09-18 15:57:32'),('190719BA-F5C3-E0D8-FA798250811561F1','Test 2','Test 2',1,0,NULL,NULL,NULL);
/*!40000 ALTER TABLE `galleon_conferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `galleon_forums`
--

DROP TABLE IF EXISTS `galleon_forums`;
CREATE TABLE `galleon_forums` (
  `id` varchar(35) NOT NULL default '',
  `name` varchar(255) NOT NULL default '',
  `description` varchar(255) NOT NULL default '',
  `active` tinyint(1) NOT NULL default '0',
  `attachments` tinyint(1) NOT NULL default '0',
  `conferenceidfk` varchar(35) NOT NULL default '',
  `messages` int(11) default NULL,
  `lastpost` varchar(35) default NULL,
  `lastpostuseridfk` varchar(35) default NULL,
  `lastpostcreated` timestamp NULL default NULL,
  PRIMARY KEY  (`id`),
  KEY `galleon_forums_conferenceidfk` (`conferenceidfk`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Table structure for table `galleon_groups`
--

DROP TABLE IF EXISTS `galleon_groups`;
CREATE TABLE `galleon_groups` (
  `Id` varchar(35) NOT NULL default '',
  `group` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `galleon_groups`
--

LOCK TABLES `galleon_groups` WRITE;
/*!40000 ALTER TABLE `galleon_groups` DISABLE KEYS */;
INSERT INTO `galleon_groups` VALUES ('AD0F29B5-BEED-B8BD-CAA9379711EBF168','forumsmember'),('AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2','forumsmoderator'),('C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D','forumsadmin');
/*!40000 ALTER TABLE `galleon_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `galleon_messages`
--

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



--
-- Table structure for table `galleon_permissions`
--

DROP TABLE IF EXISTS `galleon_permissions`;
CREATE TABLE `galleon_permissions` (
  `id` varchar(35) NOT NULL,
  `rightidfk` varchar(35) NOT NULL,
  `resourceidfk` varchar(35) NOT NULL,
  `groupidfk` varchar(35) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



--
-- Table structure for table `galleon_ranks`
--

DROP TABLE IF EXISTS `galleon_ranks`;
CREATE TABLE `galleon_ranks` (
  `Id` varchar(35) NOT NULL default '',
  `name` varchar(50) NOT NULL default '',
  `minposts` int(11) NOT NULL default '0',
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Table structure for table `galleon_rights`
--

DROP TABLE IF EXISTS `galleon_rights`;
CREATE TABLE `galleon_rights` (
  `id` varchar(35) NOT NULL,
  `right` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `galleon_rights`
--

LOCK TABLES `galleon_rights` WRITE;
/*!40000 ALTER TABLE `galleon_rights` DISABLE KEYS */;
INSERT INTO `galleon_rights` VALUES ('7EA5070B-9774-E11E-96E727122408C03C','CanView'),('7EA5070C-E788-7378-8930FA15EF58BBD2','CanPost'),('7EA5070D-CB58-72BA-2E4A3DFC0AE35F35','CanEdit');
/*!40000 ALTER TABLE `galleon_rights` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `galleon_search_log`
--

DROP TABLE IF EXISTS `galleon_search_log`;
CREATE TABLE `galleon_search_log` (
  `searchterms` varchar(255) NOT NULL default '',
  `datesearched` datetime NOT NULL default '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Table structure for table `galleon_subscriptions`
--

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



--
-- Table structure for table `galleon_threads`
--

DROP TABLE IF EXISTS `galleon_threads`;
CREATE TABLE `galleon_threads` (
  `Id` varchar(35) NOT NULL default '',
  `name` varchar(255) NOT NULL default '',
  `active` tinyint(1) NOT NULL default '0',
  `useridfk` varchar(35) NOT NULL default '',
  `forumidfk` varchar(35) NOT NULL default '',
  `datecreated` datetime NOT NULL default '0000-00-00 00:00:00',
  `sticky` tinyint(1) NOT NULL default '0',
  `messages` int(11) default NULL,
  `lastpostuseridfk` varchar(35) default NULL,
  `lastpostcreated` timestamp NULL default NULL,
  PRIMARY KEY  (`Id`),
  KEY `galleon_threads_useridfk` (`useridfk`),
  KEY `galleon_threads_forumidfk` (`forumidfk`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Table structure for table `galleon_users`
--

DROP TABLE IF EXISTS `galleon_users`;
CREATE TABLE `galleon_users` (
  `Id` varchar(35) NOT NULL default '',
  `username` varchar(50) NOT NULL default '',
  `password` varchar(50) NOT NULL default '',
  `emailaddress` varchar(255) NOT NULL default '',
  `signature` text NOT NULL,
  `datecreated` datetime NOT NULL default '0000-00-00 00:00:00',
  `confirmed` tinyint(1) NOT NULL default '0',
  `avatar` varchar(255) default NULL,
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `galleon_users`
--

LOCK TABLES `galleon_users` WRITE;
/*!40000 ALTER TABLE `galleon_users` DISABLE KEYS */;
INSERT INTO `galleon_users` VALUES ('C189C5AC-7E9B-AEC8-1DAEEEA03A562CF0','admin','admin','admin@localhost.com','','2005-01-29 12:00:00',1,'');
/*!40000 ALTER TABLE `galleon_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `galleon_users_groups`
--

DROP TABLE IF EXISTS `galleon_users_groups`;
CREATE TABLE `galleon_users_groups` (
  `useridfk` varchar(35) NOT NULL default '',
  `groupidfk` varchar(35) NOT NULL default ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `galleon_users_groups`
--

LOCK TABLES `galleon_users_groups` WRITE;
/*!40000 ALTER TABLE `galleon_users_groups` DISABLE KEYS */;
INSERT INTO `galleon_users_groups` VALUES ('C189C5AC-7E9B-AEC8-1DAEEEA03A562CF0','C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
/*!40000 ALTER TABLE `galleon_users_groups` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2007-09-27 13:55:52
