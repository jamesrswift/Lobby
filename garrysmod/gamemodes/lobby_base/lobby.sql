-- phpMyAdmin SQL Dump
-- version 4.2.11
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Apr 12, 2015 at 01:56 PM
-- Server version: 5.6.21
-- PHP Version: 5.6.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `lobby`
--

-- --------------------------------------------------------

--
-- Table structure for table `gm_bans`
--

CREATE TABLE IF NOT EXISTS `gm_bans` (
`INDEX` int(11) NOT NULL,
  `SteamID` text NOT NULL,
  `Name` text NOT NULL,
  `Unban` bigint(20) NOT NULL,
  `Reason` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `gm_chat`
--

CREATE TABLE IF NOT EXISTS `gm_chat` (
`INDEX` int(11) NOT NULL,
  `ServerID` int(11) NOT NULL DEFAULT '99',
  `Timestamp` bigint(20) NOT NULL,
  `User` varchar(128) NOT NULL DEFAULT 'SERVER',
  `ID` int(11) NOT NULL,
  `Entry` varchar(512) NOT NULL DEFAULT 'NULL'
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `gm_chat`
--

INSERT INTO `gm_chat` (`INDEX`, `ServerID`, `Timestamp`, `User`, `ID`, `Entry`) VALUES
(5, 99, 1428244480, 'James', 2147483647, 'Hey'),
(6, 99, 1428245248, 'James', 2147483647, 'Hey'),
(7, 99, 1428245254, 'James', 2147483647, 'I''m a trusted user'),
(8, 99, 1428245628, 'James', 2147483647, 'y'),
(9, 99, 1428246933, 'James', 2147483647, 'Hey'),
(10, 99, 1428362560, 'James', 1, 'Hey'),
(11, 99, 1428362571, 'James', 1, 'blah'),
(12, 99, 1428362736, 'James', 1, 'Hello world'),
(13, 99, 1428362928, 'James', 1, 'Hey'),
(14, 99, 1428413227, 'James', 1, 'Blargh :red: This is red'),
(15, 99, 1428431180, 'James', 1, 'Chatbox'),
(16, 99, 1428431191, 'James', 1, 'Supports :red:Colors:white: and other stuffs'),
(17, 99, 1428431245, 'James', 1, 'I''m going to change the hud'),
(18, 99, 1428431265, 'James', 1, 'test'),
(19, 99, 1428431273, 'James', 1, 'test'),
(20, 99, 1428504910, 'James', 1, 'Nice chatbox'),
(21, 99, 1428788898, 'James', 1, 'Arf!');

-- --------------------------------------------------------

--
-- Table structure for table `gm_server`
--

CREATE TABLE IF NOT EXISTS `gm_server` (
  `ID` int(11) NOT NULL,
  `Players` int(11) NOT NULL,
  `Msg` text,
  `Map` text,
  `Status` int(11) DEFAULT NULL,
  `LastUpdate` bigint(20) DEFAULT NULL,
  `Pass` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `gm_server`
--

INSERT INTO `gm_server` (`ID`, `Players`, `Msg`, `Map`, `Status`, `LastUpdate`, `Pass`) VALUES
(5, 0, 'Dimension', 'inc_duo', 0, 1428408125, 'mqxib9pi'),
(6, 1, 'Incoming', 'inc_duo', 0, 1428839732, '90jpxr52'),
(99, 1, 'Lobby', 'lobby_b1', 2, 1428839354, '');

-- --------------------------------------------------------

--
-- Table structure for table `gm_user`
--

CREATE TABLE IF NOT EXISTS `gm_user` (
  `ID` bigint(20) NOT NULL,
  `Money` bigint(20) NOT NULL,
  `LastJoined` bigint(20) NOT NULL,
  `Name` text NOT NULL,
  `SteamID` text NOT NULL,
  `Achievement` varchar(1024) NOT NULL,
  `Inventory` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `gm_user`
--

INSERT INTO `gm_user` (`ID`, `Money`, `LastJoined`, `Name`, `SteamID`, `Achievement`, `Inventory`) VALUES
(1, 0, 1428839586, 'James', 'STEAM_0:0:0', 'b1', '{''AlyxPlayerModel"''"}{''BlackPlayerColour"''"}{''WeaponPhysgun"''"}{''AwesomeHalo"''"}'),
(3254386260, 0, 1428780754, 'James', 'STEAM_0:1:22894915', 'b1', '{''AlyxPlayerModel"''"}');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `gm_bans`
--
ALTER TABLE `gm_bans`
 ADD PRIMARY KEY (`INDEX`), ADD KEY `INDEX` (`INDEX`);

--
-- Indexes for table `gm_chat`
--
ALTER TABLE `gm_chat`
 ADD PRIMARY KEY (`INDEX`), ADD UNIQUE KEY `INDEX` (`INDEX`);

--
-- Indexes for table `gm_server`
--
ALTER TABLE `gm_server`
 ADD UNIQUE KEY `ID` (`ID`);

--
-- Indexes for table `gm_user`
--
ALTER TABLE `gm_user`
 ADD UNIQUE KEY `ID` (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `gm_bans`
--
ALTER TABLE `gm_bans`
MODIFY `INDEX` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `gm_chat`
--
ALTER TABLE `gm_chat`
MODIFY `INDEX` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=22;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
