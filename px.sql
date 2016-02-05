-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 05, 2016 at 03:08 PM
-- Server version: 10.1.9-MariaDB
-- PHP Version: 7.0.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `px`
--

-- --------------------------------------------------------

--
-- Table structure for table `gm_bans`
--

CREATE TABLE `gm_bans` (
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

CREATE TABLE `gm_servers` (
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

CREATE TABLE `gm_users` (
  `SteamID64` varchar(20) NOT NULL,
  `Money` bigint(20) NOT NULL DEFAULT '0',
  `Usergroup` text NOT NULL,
  `Inventory` longtext NOT NULL,
  `Achievements` longtext NOT NULL,
  `Model` tinytext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `gm_users`
--

INSERT INTO `gm_users` (`SteamID64`, `Money`, `Usergroup`, `Inventory`, `Achievements`, `Model`) VALUES
('0', 1200, 'developer', '[]', '[]', 'kleiner'),
('76561198006055559', 11600, 'developer', '[]', '[]', 'alyx');

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
