-- phpMyAdmin SQL Dump
-- version 4.2.11
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Aug 02, 2015 at 04:03 PM
-- Server version: 5.6.21
-- PHP Version: 5.6.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `px`
--

-- --------------------------------------------------------

--
-- Table structure for table `gm_bans`
--

CREATE TABLE IF NOT EXISTS `gm_bans` (
  `SteamID64` varchar(45) NOT NULL,
  `Start` int(32) NOT NULL,
  `Length` int(11) NOT NULL,
  `Reason` varchar(255) NOT NULL,
  `Admin64` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `gm_servers`
--

CREATE TABLE IF NOT EXISTS `gm_servers` (
  `ID` int(11) NOT NULL,
  `Players` int(11) NOT NULL,
  `Message` varchar(45) NOT NULL,
  `Map` varchar(45) NOT NULL,
  `Status` int(11) NOT NULL,
  `LastUpdate` bigint(20) NOT NULL,
  `Password` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `gm_users`
--

CREATE TABLE IF NOT EXISTS `gm_users` (
  `SteamID64` varchar(20) NOT NULL,
  `Money` bigint(20) NOT NULL DEFAULT '0',
  `Usergroup` text NOT NULL,
  `Inventory` longtext NOT NULL,
  `Achievements` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `gm_users`
--

INSERT INTO `gm_users` (`SteamID64`, `Money`, `Usergroup`, `Inventory`, `Achievements`) VALUES
('0', 0, 'respected', '', ''),
('76561198006055559', 200, 'developer', '', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `gm_servers`
--
ALTER TABLE `gm_servers`
 ADD UNIQUE KEY `ID` (`ID`);

--
-- Indexes for table `gm_users`
--
ALTER TABLE `gm_users`
 ADD UNIQUE KEY `SteamID64` (`SteamID64`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
