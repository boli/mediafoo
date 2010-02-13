-- MySQL dump 10.11
--
-- Host: localhost    Database: medialib
-- ------------------------------------------------------
-- Server version	5.0.70-log

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
-- Table structure for table `castandcrew`
--

DROP TABLE IF EXISTS `castandcrew`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `castandcrew` (
  `ccid` int(10) unsigned NOT NULL auto_increment,
  `charname` varchar(200) default NULL,
  `personid` int(10) unsigned NOT NULL,
  `movieid` int(10) unsigned NOT NULL,
  `job` varchar(90) default NULL,
  `datasource` varchar(45) NOT NULL,
  PRIMARY KEY  USING BTREE (`ccid`)
) ENGINE=InnoDB AUTO_INCREMENT=29327 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ep_files`
--

DROP TABLE IF EXISTS `ep_files`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ep_files` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `path` varchar(250) NOT NULL default '',
  `tagged` smallint(5) unsigned NOT NULL default '0',
  `seriesid` int(10) unsigned NOT NULL,
  `major` int(10) unsigned NOT NULL,
  `minor` int(10) unsigned NOT NULL,
  `sub` int(10) unsigned NOT NULL,
  `datasource` varchar(8) NOT NULL,
  PRIMARY KEY  USING BTREE (`id`,`seriesid`)
) ENGINE=InnoDB AUTO_INCREMENT=44514 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `episodes`
--

DROP TABLE IF EXISTS `episodes`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `episodes` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `seriesid` varchar(45) NOT NULL,
  `season` int(10) unsigned NOT NULL,
  `episode` int(10) unsigned NOT NULL,
  `overview` varchar(4096) default NULL,
  `banner` varchar(128) default NULL,
  `episodename` varchar(256) default NULL,
  `lastupdated` varchar(45) NOT NULL,
  PRIMARY KEY  USING BTREE (`id`,`seriesid`)
) ENGINE=InnoDB AUTO_INCREMENT=6005 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `mov_files`
--

DROP TABLE IF EXISTS `mov_files`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `mov_files` (
  `movfileid` int(10) unsigned NOT NULL auto_increment,
  `path` varchar(250) NOT NULL,
  `datasource` varchar(8) NOT NULL,
  `tagged` smallint(5) unsigned NOT NULL default '0',
  `movieid` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`movfileid`)
) ENGINE=InnoDB AUTO_INCREMENT=2342 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `movieart`
--

DROP TABLE IF EXISTS `movieart`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `movieart` (
  `artid` int(10) unsigned NOT NULL auto_increment,
  `movieid` int(10) unsigned NOT NULL,
  `url` varchar(256) NOT NULL,
  `type` varchar(45) NOT NULL,
  `size` varchar(45) NOT NULL,
  `datasource` varchar(8) NOT NULL,
  `localname` varchar(128) NOT NULL,
  PRIMARY KEY  (`artid`)
) ENGINE=InnoDB AUTO_INCREMENT=41019 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `movies`
--

DROP TABLE IF EXISTS `movies`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `movies` (
  `movieid` int(10) unsigned NOT NULL auto_increment,
  `remoteid` varchar(45) NOT NULL,
  `releasedate` varchar(20) default NULL,
  `rating` varchar(10) default NULL,
  `datasource` varchar(8) NOT NULL,
  `overview` varchar(4096) default NULL,
  `name` varchar(128) NOT NULL,
  `altname` varchar(128) default NULL,
  `imdb_id` varchar(15) default NULL,
  `trailer` varchar(128) default NULL,
  PRIMARY KEY  USING BTREE (`movieid`)
) ENGINE=InnoDB AUTO_INCREMENT=3651 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `moviesgenres`
--

DROP TABLE IF EXISTS `moviesgenres`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `moviesgenres` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `movieid` int(10) unsigned NOT NULL,
  `genre` varchar(64) NOT NULL,
  PRIMARY KEY  USING BTREE (`id`,`movieid`),
  KEY `Index_2` USING BTREE (`genre`)
) ENGINE=InnoDB AUTO_INCREMENT=3351 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `series`
--

DROP TABLE IF EXISTS `series`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `series` (
  `seriesid` int(10) unsigned NOT NULL auto_increment,
  `banner` varchar(128) default NULL,
  `language` varchar(45) default NULL,
  `zap2it_id` varchar(45) default NULL,
  `IMDB_ID` varchar(45) default NULL,
  `FirstAired` varchar(45) default NULL,
  `remoteseriesid` varchar(45) NOT NULL,
  `SeriesName` varchar(128) NOT NULL,
  `Overview` varchar(2048) default NULL,
  `LocalName` varchar(128) NOT NULL,
  `datasource` varchar(45) NOT NULL,
  PRIMARY KEY  USING BTREE (`seriesid`)
) ENGINE=InnoDB AUTO_INCREMENT=117554 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-02-13 10:46:48
