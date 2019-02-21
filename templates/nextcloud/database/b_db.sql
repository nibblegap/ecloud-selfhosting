-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: mariadb
-- Erstellungszeit: 03. Jan 2019 um 12:44
-- Server-Version: 10.2.20-MariaDB-1:10.2.20+maria~bionic
-- PHP-Version: 7.2.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `@@@DBNAME@@@`
--
CREATE DATABASE IF NOT EXISTS `@@@DBNAME@@@` DEFAULT CHARACTER SET utf16 COLLATE utf16_general_ci;
USE `@@@DBNAME@@@`;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `accounts`
--

DROP TABLE IF EXISTS `accounts`;
CREATE TABLE `accounts` (
  `uid` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `data` longtext COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `activity`
--

DROP TABLE IF EXISTS `activity`;
CREATE TABLE `activity` (
  `activity_id` bigint(20) NOT NULL,
  `timestamp` int(11) NOT NULL DEFAULT 0,
  `priority` int(11) NOT NULL DEFAULT 0,
  `type` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `user` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `affecteduser` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `app` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `subjectparams` longtext COLLATE utf8mb4_bin NOT NULL,
  `message` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `messageparams` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `file` varchar(4000) COLLATE utf8mb4_bin DEFAULT NULL,
  `link` varchar(4000) COLLATE utf8mb4_bin DEFAULT NULL,
  `object_type` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `object_id` bigint(20) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `activity_mq`
--

DROP TABLE IF EXISTS `activity_mq`;
CREATE TABLE `activity_mq` (
  `mail_id` bigint(20) NOT NULL,
  `amq_timestamp` int(11) NOT NULL DEFAULT 0,
  `amq_latest_send` int(11) NOT NULL DEFAULT 0,
  `amq_type` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `amq_affecteduser` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `amq_appid` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `amq_subject` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `amq_subjectparams` varchar(4000) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `addressbookchanges`
--

DROP TABLE IF EXISTS `addressbookchanges`;
CREATE TABLE `addressbookchanges` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uri` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `synctoken` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `addressbookid` bigint(20) NOT NULL,
  `operation` smallint(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `addressbooks`
--

DROP TABLE IF EXISTS `addressbooks`;
CREATE TABLE `addressbooks` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `principaluri` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `displayname` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `uri` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `synctoken` int(10) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `appconfig`
--

DROP TABLE IF EXISTS `appconfig`;
CREATE TABLE `appconfig` (
  `appid` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `configkey` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `configvalue` longtext COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

--
-- Daten für Tabelle `appconfig`
--

INSERT INTO `appconfig` (`appid`, `configkey`, `configvalue`) VALUES
('accessibility', 'enabled', 'yes'),
('accessibility', 'installed_version', '1.0.1'),
('accessibility', 'types', ''),
('activity', 'enabled', 'yes'),
('activity', 'installed_version', '2.7.0'),
('activity', 'types', 'filesystem'),
('backgroundjob', 'lastjob', '2'),
('bruteforcesettings', 'enabled', 'yes'),
('bruteforcesettings', 'installed_version', '1.3.0'),
('bruteforcesettings', 'types', ''),
('cloud_federation_api', 'enabled', 'yes'),
('cloud_federation_api', 'installed_version', '0.0.1'),
('cloud_federation_api', 'types', 'filesystem'),
('comments', 'enabled', 'yes'),
('comments', 'installed_version', '1.4.0'),
('comments', 'types', 'logging'),
('core', 'installed.bundles', '[\"CoreBundle\"]'),
('core', 'installedat', '1546519299.3598'),
('core', 'lastcron', '1546519348'),
('core', 'lastupdatedat', '1546519299.3624'),
('core', 'oc.integritycheck.checker', '[]'),
('core', 'public_files', 'files_sharing/public.php'),
('core', 'public_webdav', 'dav/appinfo/v1/publicwebdav.php'),
('core', 'scss.variables', '7a173342cb0e112d3b11053e87e64a8e'),
('core', 'vendor', 'nextcloud'),
('dav', 'enabled', 'yes'),
('dav', 'installed_version', '1.6.0'),
('dav', 'types', 'filesystem'),
('federatedfilesharing', 'enabled', 'yes'),
('federatedfilesharing', 'installed_version', '1.4.0'),
('federatedfilesharing', 'types', ''),
('federation', 'enabled', 'yes'),
('federation', 'installed_version', '1.4.0'),
('federation', 'types', 'authentication'),
('files', 'enabled', 'yes'),
('files', 'installed_version', '1.9.0'),
('files', 'types', 'filesystem'),
('files_pdfviewer', 'enabled', 'yes'),
('files_pdfviewer', 'installed_version', '1.3.2'),
('files_pdfviewer', 'types', ''),
('files_sharing', 'enabled', 'yes'),
('files_sharing', 'installed_version', '1.6.2'),
('files_sharing', 'types', 'filesystem'),
('files_texteditor', 'enabled', 'yes'),
('files_texteditor', 'installed_version', '2.6.0'),
('files_texteditor', 'types', ''),
('files_trashbin', 'enabled', 'yes'),
('files_trashbin', 'installed_version', '1.4.1'),
('files_trashbin', 'types', 'filesystem,dav'),
('files_versions', 'enabled', 'yes'),
('files_versions', 'installed_version', '1.7.1'),
('files_versions', 'types', 'filesystem,dav'),
('files_videoplayer', 'enabled', 'yes'),
('files_videoplayer', 'installed_version', '1.3.0'),
('files_videoplayer', 'types', ''),
('firstrunwizard', 'enabled', 'yes'),
('firstrunwizard', 'installed_version', '2.3.0'),
('firstrunwizard', 'types', 'logging'),
('gallery', 'enabled', 'yes'),
('gallery', 'installed_version', '18.1.0'),
('gallery', 'types', ''),
('logreader', 'enabled', 'yes'),
('logreader', 'installed_version', '2.0.0'),
('logreader', 'ocsid', '170871'),
('logreader', 'types', ''),
('lookup_server_connector', 'enabled', 'yes'),
('lookup_server_connector', 'installed_version', '1.2.0'),
('lookup_server_connector', 'types', 'authentication'),
('nextcloud_announcements', 'enabled', 'yes'),
('nextcloud_announcements', 'installed_version', '1.3.0'),
('nextcloud_announcements', 'types', 'logging'),
('notifications', 'enabled', 'yes'),
('notifications', 'installed_version', '2.2.1'),
('notifications', 'types', 'logging'),
('oauth2', 'enabled', 'yes'),
('oauth2', 'installed_version', '1.2.1'),
('oauth2', 'types', 'authentication'),
('password_policy', 'enabled', 'yes'),
('password_policy', 'installed_version', '1.4.0'),
('password_policy', 'types', ''),
('provisioning_api', 'enabled', 'yes'),
('provisioning_api', 'installed_version', '1.4.0'),
('provisioning_api', 'types', 'prevent_group_restriction'),
('serverinfo', 'enabled', 'yes'),
('serverinfo', 'installed_version', '1.4.0'),
('serverinfo', 'types', ''),
('sharebymail', 'enabled', 'yes'),
('sharebymail', 'installed_version', '1.4.0'),
('sharebymail', 'types', 'filesystem'),
('support', 'enabled', 'yes'),
('support', 'installed_version', '1.0.0'),
('support', 'types', ''),
('survey_client', 'enabled', 'yes'),
('survey_client', 'installed_version', '1.2.0'),
('survey_client', 'types', ''),
('systemtags', 'enabled', 'yes'),
('systemtags', 'installed_version', '1.4.0'),
('systemtags', 'types', 'logging'),
('theming', 'enabled', 'yes'),
('theming', 'installed_version', '1.5.0'),
('theming', 'types', 'logging'),
('twofactor_backupcodes', 'enabled', 'yes'),
('twofactor_backupcodes', 'installed_version', '1.3.1'),
('twofactor_backupcodes', 'types', ''),
('updatenotification', 'enabled', 'yes'),
('updatenotification', 'installed_version', '1.4.1'),
('updatenotification', 'types', ''),
('workflowengine', 'enabled', 'yes'),
('workflowengine', 'installed_version', '1.4.0'),
('workflowengine', 'types', 'filesystem');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `authtoken`
--

DROP TABLE IF EXISTS `authtoken`;
CREATE TABLE `authtoken` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uid` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `login_name` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `password` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `name` longtext COLLATE utf8mb4_bin NOT NULL,
  `token` varchar(200) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `type` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `remember` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `last_activity` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `last_check` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `scope` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `expires` int(10) UNSIGNED DEFAULT NULL,
  `private_key` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `public_key` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `version` smallint(5) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bruteforce_attempts`
--

DROP TABLE IF EXISTS `bruteforce_attempts`;
CREATE TABLE `bruteforce_attempts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `action` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `occurred` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `ip` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `subnet` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `metadata` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `calendarchanges`
--

DROP TABLE IF EXISTS `calendarchanges`;
CREATE TABLE `calendarchanges` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uri` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `synctoken` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `calendarid` bigint(20) NOT NULL,
  `operation` smallint(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `calendarobjects`
--

DROP TABLE IF EXISTS `calendarobjects`;
CREATE TABLE `calendarobjects` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `calendardata` longblob DEFAULT NULL,
  `uri` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `calendarid` bigint(20) UNSIGNED NOT NULL,
  `lastmodified` int(10) UNSIGNED DEFAULT NULL,
  `etag` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `size` bigint(20) UNSIGNED NOT NULL,
  `componenttype` varchar(8) COLLATE utf8mb4_bin DEFAULT NULL,
  `firstoccurence` bigint(20) UNSIGNED DEFAULT NULL,
  `lastoccurence` bigint(20) UNSIGNED DEFAULT NULL,
  `uid` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `classification` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `calendarobjects_props`
--

DROP TABLE IF EXISTS `calendarobjects_props`;
CREATE TABLE `calendarobjects_props` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `calendarid` bigint(20) NOT NULL DEFAULT 0,
  `objectid` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `name` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `parameter` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `value` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `calendars`
--

DROP TABLE IF EXISTS `calendars`;
CREATE TABLE `calendars` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `principaluri` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `displayname` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `uri` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `synctoken` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `description` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `calendarorder` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `calendarcolor` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `timezone` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `components` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `transparent` smallint(6) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `calendarsubscriptions`
--

DROP TABLE IF EXISTS `calendarsubscriptions`;
CREATE TABLE `calendarsubscriptions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uri` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `principaluri` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `source` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `displayname` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL,
  `refreshrate` varchar(10) COLLATE utf8mb4_bin DEFAULT NULL,
  `calendarorder` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `calendarcolor` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `striptodos` smallint(6) DEFAULT NULL,
  `stripalarms` smallint(6) DEFAULT NULL,
  `stripattachments` smallint(6) DEFAULT NULL,
  `lastmodified` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `calendar_invitations`
--

DROP TABLE IF EXISTS `calendar_invitations`;
CREATE TABLE `calendar_invitations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uid` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `recurrenceid` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `attendee` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `organizer` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `sequence` bigint(20) UNSIGNED DEFAULT NULL,
  `token` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  `expiration` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `calendar_resources`
--

DROP TABLE IF EXISTS `calendar_resources`;
CREATE TABLE `calendar_resources` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `backend_id` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `resource_id` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `displayname` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `group_restrictions` varchar(4000) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `calendar_rooms`
--

DROP TABLE IF EXISTS `calendar_rooms`;
CREATE TABLE `calendar_rooms` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `backend_id` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `resource_id` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `displayname` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `group_restrictions` varchar(4000) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `cards`
--

DROP TABLE IF EXISTS `cards`;
CREATE TABLE `cards` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `addressbookid` bigint(20) NOT NULL DEFAULT 0,
  `carddata` longblob DEFAULT NULL,
  `uri` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `lastmodified` bigint(20) UNSIGNED DEFAULT NULL,
  `etag` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `size` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `cards_properties`
--

DROP TABLE IF EXISTS `cards_properties`;
CREATE TABLE `cards_properties` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `addressbookid` bigint(20) NOT NULL DEFAULT 0,
  `cardid` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `name` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `value` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `preferred` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `comments`
--

DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `parent_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `topmost_parent_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `children_count` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `actor_type` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `actor_id` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `message` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `verb` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `creation_timestamp` datetime DEFAULT NULL,
  `latest_child_timestamp` datetime DEFAULT NULL,
  `object_type` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `object_id` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `comments_read_markers`
--

DROP TABLE IF EXISTS `comments_read_markers`;
CREATE TABLE `comments_read_markers` (
  `user_id` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `marker_datetime` datetime DEFAULT NULL,
  `object_type` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `object_id` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `credentials`
--

DROP TABLE IF EXISTS `credentials`;
CREATE TABLE `credentials` (
  `user` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `identifier` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `credentials` longtext COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `dav_shares`
--

DROP TABLE IF EXISTS `dav_shares`;
CREATE TABLE `dav_shares` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `principaluri` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `type` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `access` smallint(6) DEFAULT NULL,
  `resourceid` bigint(20) UNSIGNED NOT NULL,
  `publicuri` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `directlink`
--

DROP TABLE IF EXISTS `directlink`;
CREATE TABLE `directlink` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `file_id` bigint(20) UNSIGNED NOT NULL,
  `token` varchar(60) COLLATE utf8mb4_bin DEFAULT NULL,
  `expiration` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `federated_reshares`
--

DROP TABLE IF EXISTS `federated_reshares`;
CREATE TABLE `federated_reshares` (
  `share_id` int(11) NOT NULL,
  `remote_id` int(11) NOT NULL COMMENT 'share ID at the remote server'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `filecache`
--

DROP TABLE IF EXISTS `filecache`;
CREATE TABLE `filecache` (
  `fileid` bigint(20) NOT NULL,
  `storage` bigint(20) NOT NULL DEFAULT 0,
  `path` varchar(4000) COLLATE utf8mb4_bin DEFAULT NULL,
  `path_hash` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `parent` bigint(20) NOT NULL DEFAULT 0,
  `name` varchar(250) COLLATE utf8mb4_bin DEFAULT NULL,
  `mimetype` bigint(20) NOT NULL DEFAULT 0,
  `mimepart` bigint(20) NOT NULL DEFAULT 0,
  `size` bigint(20) NOT NULL DEFAULT 0,
  `mtime` int(11) NOT NULL DEFAULT 0,
  `storage_mtime` int(11) NOT NULL DEFAULT 0,
  `encrypted` int(11) NOT NULL DEFAULT 0,
  `unencrypted_size` bigint(20) NOT NULL DEFAULT 0,
  `etag` varchar(40) COLLATE utf8mb4_bin DEFAULT NULL,
  `permissions` int(11) DEFAULT 0,
  `checksum` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

--
-- Daten für Tabelle `filecache`
--

INSERT INTO `filecache` (`fileid`, `storage`, `path`, `path_hash`, `parent`, `name`, `mimetype`, `mimepart`, `size`, `mtime`, `storage_mtime`, `encrypted`, `unencrypted_size`, `etag`, `permissions`, `checksum`) VALUES
(1, 1, '', 'd41d8cd98f00b204e9800998ecf8427e', -1, '', 2, 1, -1, 1546519346, 1546519303, 0, 0, '5c2e0332bb158', 23, ''),
(2, 1, 'appdata_ocu2rsyyk8v2', '95eb7393b9a4bc2d7f0a90b180584f5b', 1, 'appdata_ocu2rsyyk8v2', 2, 1, 3629532, 1546519346, 1546519309, 0, 0, '5c2e0332bb158', 31, ''),
(3, 1, 'appdata_ocu2rsyyk8v2/appstore', '6f5913718ce0cc3b9535bfdd90e31b80', 2, 'appstore', 2, 1, 537303, 1546519303, 1546519303, 0, 0, '5c2e0307b7c0e', 31, ''),
(4, 1, 'appdata_ocu2rsyyk8v2/appstore/apps.json', '5910c7c5fefb1eab2dad39a9640bfe61', 3, 'apps.json', 4, 3, 537303, 1546519303, 1546519303, 0, 0, 'ac4aae916a58babd8e65daf7092c799e', 27, ''),
(5, 1, 'appdata_ocu2rsyyk8v2/preview', '00f1b7a9689c16468b8e95b4edb8d053', 2, 'preview', 2, 1, 727154, 1546519318, 1546519317, 0, 0, '5c2e03161d419', 31, ''),
(6, 2, '', 'd41d8cd98f00b204e9800998ecf8427e', -1, '', 2, 1, 10610755, 1546519305, 1546519305, 0, 0, '5c2e0309ae1c2', 23, ''),
(7, 2, 'files', '45b963397aa40d4a0063e0d85e4fe7a1', 6, 'files', 2, 1, 10610755, 1546519305, 1546519305, 0, 0, '5c2e0309ae1c2', 31, ''),
(8, 2, 'files/Photos', 'd01bb67e7b71dd49fd06bad922f521c9', 7, 'Photos', 2, 1, 2360011, 1546519305, 1546519305, 0, 0, '5c2e03097df7f', 31, ''),
(9, 2, 'files/Photos/Nut.jpg', 'aa8daeb975e1d39412954fd5cd41adb4', 8, 'Nut.jpg', 6, 5, 955026, 1546519305, 1546519305, 0, 0, 'cbe4955658bbf1d233e19e7257dc2718', 27, ''),
(10, 2, 'files/Photos/Hummingbird.jpg', 'e077463269c404ae0f6f8ea7f2d7a326', 8, 'Hummingbird.jpg', 6, 5, 585219, 1546519305, 1546519305, 0, 0, '78f2a4c69609aea543302423b08a86c2', 27, ''),
(11, 2, 'files/Photos/Coast.jpg', 'a6fe87299d78b207e9b7aba0f0cb8a0a', 8, 'Coast.jpg', 6, 5, 819766, 1546519305, 1546519305, 0, 0, '372e35e0ff55ad039c95c0bcb23c3730', 27, ''),
(12, 2, 'files/Documents', '0ad78ba05b6961d92f7970b2b3922eca', 7, 'Documents', 2, 1, 2607827, 1546519305, 1546519305, 0, 0, '5c2e03098f43b', 31, ''),
(13, 2, 'files/Documents/About.odt', 'b2ee7d56df9f34a0195d4b611376e885', 12, 'About.odt', 7, 3, 77422, 1546519305, 1546519305, 0, 0, '5a7559a96293fce55cb9b48980df9e53', 27, ''),
(14, 2, 'files/Documents/About.txt', '9da7b739e7a65d74793b2881da521169', 12, 'About.txt', 9, 8, 1074, 1546519305, 1546519305, 0, 0, '88ff7d7d34bbb0219ceedfb52944f307', 27, ''),
(15, 2, 'files/Documents/Nextcloud Flyer.pdf', 'dda5bc1db7ea6619926b0dac54e69262', 12, 'Nextcloud Flyer.pdf', 10, 3, 2529331, 1546519305, 1546519305, 0, 0, '25304dce94246e1555743a58a0315541', 27, ''),
(16, 2, 'files/Nextcloud Manual.pdf', '2bc58a43566a8edde804a4a97a9c7469', 7, 'Nextcloud Manual.pdf', 10, 3, 4544585, 1546519305, 1546519305, 0, 0, '36de4ceb2a9ed2caf70796efd703db33', 27, ''),
(17, 2, 'files/Nextcloud.png', '2bcc0ff06465ef1bfc4a868efde1e485', 7, 'Nextcloud.png', 11, 5, 37042, 1546519305, 1546519305, 0, 0, 'aeb60db0a2b3c13454e93c749ad1cb16', 27, ''),
(18, 2, 'files/Nextcloud.mp4', '77a79c09b93e57cba23c11eb0e6048a6', 7, 'Nextcloud.mp4', 13, 12, 462413, 1546519305, 1546519305, 0, 0, '3496665c4f4611eb27735ccfe28acf04', 27, ''),
(19, 2, 'files/Nextcloud Community.jpeg', '30af45e46d4496087af49ca556429ef3', 7, 'Nextcloud Community.jpeg', 6, 5, 598877, 1546519305, 1546519305, 0, 0, 'a479db5dc6f65247374f633e9cf947a5', 27, ''),
(20, 1, 'appdata_ocu2rsyyk8v2/theming', 'e741018d2076509da308942f168fae63', 2, 'theming', 2, 1, 1560, 1546519318, 1546519318, 0, 0, '5c2e031638a30', 31, ''),
(21, 1, 'appdata_ocu2rsyyk8v2/avatar', '0cbc8dd269d849dbaa434de05c45381e', 2, 'avatar', 2, 1, 0, 1546519308, 1546519308, 0, 0, '5c2e030c6f00b', 31, ''),
(23, 1, 'appdata_ocu2rsyyk8v2/js', '00a53eac4e2352c54973159addf139e2', 2, 'js', 2, 1, 2134184, 1546519346, 1546519309, 0, 0, '5c2e0332bb158', 31, ''),
(24, 1, 'appdata_ocu2rsyyk8v2/js/core', '229dd9642b63d2c24b1c0fc5a02d8197', 23, 'core', 2, 1, 391449, 1546519346, 1546519346, 0, 0, '5c2e0332bb158', 31, ''),
(25, 1, 'appdata_ocu2rsyyk8v2/js/core/merged-template-prepend.js', 'da0aec0678b8323684dfebf65fe2631f', 24, 'merged-template-prepend.js', 14, 3, 156088, 1546519308, 1546519308, 0, 0, 'f83f5e96144598a84837bb8818786131', 27, ''),
(26, 1, 'appdata_ocu2rsyyk8v2/js/core/merged-template-prepend.js.deps', '234dadb267410e94062fcd7cc7ed0325', 24, 'merged-template-prepend.js.deps', 15, 3, 1146, 1546519308, 1546519308, 0, 0, 'a48e50816a28e551e5d13c99f6669131', 27, ''),
(27, 1, 'appdata_ocu2rsyyk8v2/js/core/merged-template-prepend.js.gzip', 'bc5ff91f5b4e8f1a08cb930765f9f2f2', 24, 'merged-template-prepend.js.gzip', 16, 3, 42432, 1546519308, 1546519308, 0, 0, '6b55793b784ea296d708cf0dab1375b4', 27, ''),
(28, 1, 'appdata_ocu2rsyyk8v2/js/core/merged-share-backend.js', 'aa45e317fe46ebd7b4fb96e00cbe558b', 24, 'merged-share-backend.js', 14, 3, 128594, 1546519308, 1546519308, 0, 0, '150771368654398063e16accb1a2873e', 27, ''),
(29, 1, 'appdata_ocu2rsyyk8v2/js/core/merged-share-backend.js.deps', 'a8ab90cf7da51d5e63011b2237162817', 24, 'merged-share-backend.js.deps', 15, 3, 572, 1546519308, 1546519308, 0, 0, '36e96ce664e4bc0eee3c4f29dfce38d9', 27, ''),
(30, 1, 'appdata_ocu2rsyyk8v2/js/core/merged-share-backend.js.gzip', '4012ef32951fb8358399b37195a64953', 24, 'merged-share-backend.js.gzip', 16, 3, 26536, 1546519308, 1546519308, 0, 0, '79949d4f4469e479eb84c91247f105d1', 27, ''),
(31, 1, 'appdata_ocu2rsyyk8v2/js/files', '14e3b8ff8bd748bcd5d0040685a148d8', 23, 'files', 2, 1, 440947, 1546519308, 1546519308, 0, 0, '5c2e030cb2c9f', 31, ''),
(32, 1, 'appdata_ocu2rsyyk8v2/js/files/merged-index.js', '5e199643209325a557991c57868e50cf', 31, 'merged-index.js', 14, 3, 354526, 1546519308, 1546519308, 0, 0, '3d3c7e4fcbfb25ffbded9a16ec827a2d', 27, ''),
(33, 1, 'appdata_ocu2rsyyk8v2/js/files/merged-index.js.deps', 'ac5ce531963185772180e0f92696aced', 31, 'merged-index.js.deps', 15, 3, 1888, 1546519308, 1546519308, 0, 0, 'cfd8a2f8eff4e2eb25f1c3b4bbdba0e8', 27, ''),
(34, 1, 'appdata_ocu2rsyyk8v2/js/files/merged-index.js.gzip', '9214400ddb68d48c1921e06f91f22b9b', 31, 'merged-index.js.gzip', 16, 3, 84533, 1546519308, 1546519308, 0, 0, '4ea0ebb5e14b68e95de4c8ceaeceb26b', 27, ''),
(35, 1, 'appdata_ocu2rsyyk8v2/js/activity', 'f0eaf5ddf8a3bdf8c1d0b1d15e9ffe39', 23, 'activity', 2, 1, 21159, 1546519308, 1546519308, 0, 0, '5c2e030cc2549', 31, ''),
(36, 1, 'appdata_ocu2rsyyk8v2/js/activity/activity-sidebar.js', 'dd5e7d5bac1265ccea3aa0b5f9510e83', 35, 'activity-sidebar.js', 14, 3, 16380, 1546519308, 1546519308, 0, 0, 'a0d670e4c5f4eb3452d61500681c579c', 27, ''),
(37, 1, 'appdata_ocu2rsyyk8v2/js/activity/activity-sidebar.js.deps', '0a64466f3bc953a15113c47d0e3a8e70', 35, 'activity-sidebar.js.deps', 15, 3, 428, 1546519308, 1546519308, 0, 0, '85af7a3fe5aabccdfd956cf5240017a3', 27, ''),
(38, 1, 'appdata_ocu2rsyyk8v2/js/activity/activity-sidebar.js.gzip', '2485899c9cc8ba9df3c9508a3f773aab', 35, 'activity-sidebar.js.gzip', 16, 3, 4351, 1546519308, 1546519308, 0, 0, '2500bf0414d32ced2472b93416ee7691', 27, ''),
(39, 1, 'appdata_ocu2rsyyk8v2/js/comments', 'e43205bf0d6f9bf22ce8e0f56611c092', 23, 'comments', 2, 1, 90357, 1546519308, 1546519308, 0, 0, '5c2e030cd2b6d', 31, ''),
(40, 1, 'appdata_ocu2rsyyk8v2/js/comments/merged.js', '44dcc7d3542d00c345de9e41957fced2', 39, 'merged.js', 14, 3, 70233, 1546519308, 1546519308, 0, 0, '0c4dc50ea436be5363f0e213a67d2b99', 27, ''),
(41, 1, 'appdata_ocu2rsyyk8v2/js/comments/merged.js.deps', 'e9454b020a8b11ce240f532c5fd41355', 39, 'merged.js.deps', 15, 3, 872, 1546519308, 1546519308, 0, 0, '51d292d1e31b4bc973981f953ac63347', 27, ''),
(42, 1, 'appdata_ocu2rsyyk8v2/js/comments/merged.js.gzip', 'f30790d8ca721fb1c7e25d458f58e0d5', 39, 'merged.js.gzip', 16, 3, 19252, 1546519308, 1546519308, 0, 0, 'e8df2f73fd0fe1b7274b13468cad4d96', 27, ''),
(43, 1, 'appdata_ocu2rsyyk8v2/js/files_sharing', '137d46f866715b6971e8b2fd003539f2', 23, 'files_sharing', 2, 1, 19444, 1546519308, 1546519308, 0, 0, '5c2e030ce1c8d', 31, ''),
(44, 1, 'appdata_ocu2rsyyk8v2/js/files_sharing/additionalScripts.js', 'b0d51f79ebcbd3c3d40223a72a49c061', 43, 'additionalScripts.js', 14, 3, 14644, 1546519308, 1546519308, 0, 0, '54a901a08f5de0b50f431699c07d795b', 27, ''),
(45, 1, 'appdata_ocu2rsyyk8v2/js/files_sharing/additionalScripts.js.deps', 'c2c6e1ee1a101576ab6289f13b13424f', 43, 'additionalScripts.js.deps', 15, 3, 296, 1546519308, 1546519308, 0, 0, '7ae5f676ed6fa47e6c20b100f2ae774a', 27, ''),
(46, 1, 'appdata_ocu2rsyyk8v2/js/files_sharing/additionalScripts.js.gzip', '32f9ca0614c90a1437046367bd93cea2', 43, 'additionalScripts.js.gzip', 16, 3, 4504, 1546519308, 1546519308, 0, 0, '6dfc04e2897e8f55defa33e86434356d', 27, ''),
(47, 1, 'appdata_ocu2rsyyk8v2/js/files_texteditor', 'e660e93eb3b62ea605f009c2a431408a', 23, 'files_texteditor', 2, 1, 839405, 1546519309, 1546519308, 0, 0, '5c2e030d1702a', 31, ''),
(48, 1, 'appdata_ocu2rsyyk8v2/js/files_texteditor/merged.js', '3e766a5f7c46035b56d8a0acf3cc4be9', 47, 'merged.js', 14, 3, 699916, 1546519308, 1546519308, 0, 0, '7d9e47b0d91e17d0a7cbbeb1c795f667', 27, ''),
(49, 1, 'appdata_ocu2rsyyk8v2/js/files_texteditor/merged.js.deps', 'e0392074ff99f4df9b451aa8b49af971', 47, 'merged.js.deps', 15, 3, 326, 1546519308, 1546519308, 0, 0, 'ccc5988af5707729d45f6b11ee0e2455', 27, ''),
(50, 1, 'appdata_ocu2rsyyk8v2/js/files_texteditor/merged.js.gzip', '0e8d67d31f961d47fbf5283034682986', 47, 'merged.js.gzip', 16, 3, 139163, 1546519309, 1546519309, 0, 0, '269902153ea3eecc0d21a40a03c17313', 27, ''),
(51, 1, 'appdata_ocu2rsyyk8v2/js/files_versions', '198585f9aeeb799c11d3f6c291219def', 23, 'files_versions', 2, 1, 16670, 1546519309, 1546519309, 0, 0, '5c2e030d28988', 31, ''),
(52, 1, 'appdata_ocu2rsyyk8v2/js/files_versions/merged.js', 'd6f8a0df21f8c5b43144d3e6d14a547c', 51, 'merged.js', 14, 3, 12719, 1546519309, 1546519309, 0, 0, 'f721e2eace8357a260585350e8b1fe63', 27, ''),
(53, 1, 'appdata_ocu2rsyyk8v2/js/files_versions/merged.js.deps', '403aa018aff50fd2043d3622f1ea62df', 51, 'merged.js.deps', 15, 3, 369, 1546519309, 1546519309, 0, 0, '645c4b9b13a913541b71853bf8ec7fc9', 27, ''),
(54, 1, 'appdata_ocu2rsyyk8v2/js/files_versions/merged.js.gzip', 'ec11174b047c2b596bb82c7c3cbf062a', 51, 'merged.js.gzip', 16, 3, 3582, 1546519309, 1546519309, 0, 0, '7a795dc2bfe4570994ffba08bb1c31a5', 27, ''),
(55, 1, 'appdata_ocu2rsyyk8v2/js/gallery', 'f23a6dede5a87efa5e16b6187042c7ee', 23, 'gallery', 2, 1, 290511, 1546519309, 1546519309, 0, 0, '5c2e030d42bf9', 31, ''),
(56, 1, 'appdata_ocu2rsyyk8v2/js/gallery/scripts-for-file-app.js', '062b5b0b6120e06e3e854dd5a01bfd71', 55, 'scripts-for-file-app.js', 14, 3, 233816, 1546519309, 1546519309, 0, 0, 'bb2fecbb856e0f719cc0a4676763971e', 27, ''),
(57, 1, 'appdata_ocu2rsyyk8v2/js/gallery/scripts-for-file-app.js.deps', 'c26e393c3aec5101a82b726d980245b3', 55, 'scripts-for-file-app.js.deps', 15, 3, 746, 1546519309, 1546519309, 0, 0, '03ea5b4805305db1b07f329eb5f96ea8', 27, ''),
(58, 1, 'appdata_ocu2rsyyk8v2/js/gallery/scripts-for-file-app.js.gzip', '50571d79dfe78e89862812948d539522', 55, 'scripts-for-file-app.js.gzip', 16, 3, 55949, 1546519309, 1546519309, 0, 0, '5f60ec0127087069a8c5ae36398d989b', 27, ''),
(59, 1, 'appdata_ocu2rsyyk8v2/js/core/merged.js', '7ce8a78a39e9e4c777e1967c78c996e7', 24, 'merged.js', 14, 3, 20224, 1546519309, 1546519309, 0, 0, 'ce90dd311ad755938fd68f15c51f4c58', 27, ''),
(60, 1, 'appdata_ocu2rsyyk8v2/js/core/merged.js.deps', '8bb09c085d5da15bf181b6a299f43f78', 24, 'merged.js.deps', 15, 3, 442, 1546519309, 1546519309, 0, 0, 'c8ae20528d3de210dcd30a8d0d7482bb', 27, ''),
(61, 1, 'appdata_ocu2rsyyk8v2/js/core/merged.js.gzip', 'f6d612a627b0754cef1c1d7e6be8c918', 24, 'merged.js.gzip', 16, 3, 5365, 1546519309, 1546519309, 0, 0, 'fc94e36347fa699286400ac2ee138054', 27, ''),
(62, 1, 'appdata_ocu2rsyyk8v2/js/systemtags', '375ea7d816cf327ee33095cce0622b67', 23, 'systemtags', 2, 1, 24242, 1546519309, 1546519309, 0, 0, '5c2e030d66679', 31, ''),
(63, 1, 'appdata_ocu2rsyyk8v2/js/systemtags/merged.js', '9b5f904c95fec3300b921e48e6da1c32', 62, 'merged.js', 14, 3, 18410, 1546519309, 1546519309, 0, 0, '48995e8d7d4e5d7a3110d02b0bebba8e', 27, ''),
(64, 1, 'appdata_ocu2rsyyk8v2/js/systemtags/merged.js.deps', 'bbb0e2f371997bfb4600766e7d4c9cbb', 62, 'merged.js.deps', 15, 3, 429, 1546519309, 1546519309, 0, 0, 'c102ddead80ea473a9b125ec38d87b4c', 27, ''),
(65, 1, 'appdata_ocu2rsyyk8v2/js/systemtags/merged.js.gzip', 'c7d8ee426d495e2d081b617acb2d7ade', 62, 'merged.js.gzip', 16, 3, 5403, 1546519309, 1546519309, 0, 0, '875bcc685aeb8b79a8939e3602a8aaac', 27, ''),
(66, 1, 'appdata_ocu2rsyyk8v2/css', '50f16dc09fcf8eb22711e893349284eb', 2, 'css', 2, 1, 229331, 1546519314, 1546519314, 0, 0, '5c2e031281bf9', 31, ''),
(67, 1, 'appdata_ocu2rsyyk8v2/css/icons', 'c69849ee8b7a111708d211e01c0bc3f9', 66, 'icons', 2, 1, 10495, 1546519314, 1546519310, 0, 0, '5c2e0312760a6', 31, ''),
(68, 1, 'appdata_ocu2rsyyk8v2/css/core', 'a18e54c2be2863be045998d64e82c90c', 66, 'core', 2, 1, 159923, 1546519312, 1546519312, 0, 0, '5c2e03107f5f1', 31, ''),
(69, 1, 'appdata_ocu2rsyyk8v2/css/core/4f30-2477-jquery-ui-fixes.css', 'a5fb1e91924c72037e8ef0a6cfd91a3d', 68, '4f30-2477-jquery-ui-fixes.css', 17, 8, 4792, 1546519309, 1546519309, 0, 0, '23b197505645edf12a0312730c968da7', 27, ''),
(70, 1, 'appdata_ocu2rsyyk8v2/css/core/4f30-2477-jquery-ui-fixes.css.deps', '353446467bd0b8e4e35aa3f66e45cbed', 68, '4f30-2477-jquery-ui-fixes.css.deps', 15, 3, 178, 1546519309, 1546519309, 0, 0, '693d0e299926d333c389a872699c1de1', 27, ''),
(71, 1, 'appdata_ocu2rsyyk8v2/css/core/4f30-2477-jquery-ui-fixes.css.gzip', '95ea49845529ff95a03a2b489ce407ca', 68, '4f30-2477-jquery-ui-fixes.css.gzip', 16, 3, 906, 1546519309, 1546519309, 0, 0, '60a7004c14d309284a7102d9d877366a', 27, ''),
(72, 1, 'appdata_ocu2rsyyk8v2/css/core/4f30-2477-server.css', 'a91a3b39c0031cb24f913f64b491fdd4', 68, '4f30-2477-server.css', 17, 8, 127370, 1546519310, 1546519310, 0, 0, 'c6939688e4da1fae646c170e2c4e726b', 27, ''),
(73, 1, 'appdata_ocu2rsyyk8v2/css/core/4f30-2477-server.css.deps', '3d77bf4fed1e2999fb2d9e5b13088166', 68, '4f30-2477-server.css.deps', 15, 3, 818, 1546519310, 1546519310, 0, 0, '7d349827e7c643cec90440c12bd6dde7', 27, ''),
(74, 1, 'appdata_ocu2rsyyk8v2/css/icons/icons-vars.css', '3eb87facc89d3c80ae25e549e07b1593', 67, 'icons-vars.css', 17, 8, 10495, 1546519314, 1546519314, 0, 0, 'a9e40fafcc1a740c4a282b35ead7f062', 27, ''),
(75, 1, 'appdata_ocu2rsyyk8v2/css/core/4f30-2477-server.css.gzip', '9da9879cd2190e1cc95a305e93fb4c92', 68, '4f30-2477-server.css.gzip', 16, 3, 18547, 1546519310, 1546519310, 0, 0, '01905a58449cfb65c5f180f200b672da', 27, ''),
(76, 1, 'appdata_ocu2rsyyk8v2/css/core/4f30-2477-css-variables.css', '381ea2e26f2afb878d1ed2c80aa9fe93', 68, '4f30-2477-css-variables.css', 17, 8, 784, 1546519311, 1546519311, 0, 0, '55baa5bbbf97a7da45d9ad8f8f8fdab1', 27, ''),
(77, 1, 'appdata_ocu2rsyyk8v2/css/core/4f30-2477-css-variables.css.deps', '70baacb70c51af34d0b3fb8a53ab7439', 68, '4f30-2477-css-variables.css.deps', 15, 3, 176, 1546519311, 1546519311, 0, 0, '74193ebcb654b36cc463e2e08288f910', 27, ''),
(78, 1, 'appdata_ocu2rsyyk8v2/css/core/4f30-2477-css-variables.css.gzip', '2ff48dbac905cc3afd3b0179199eef29', 68, '4f30-2477-css-variables.css.gzip', 16, 3, 365, 1546519311, 1546519311, 0, 0, 'a76238247c88652e3bd4bb65b16e17c6', 27, ''),
(79, 1, 'appdata_ocu2rsyyk8v2/css/firstrunwizard', 'c9f7519bb14b33abce76e44e8a93fa58', 66, 'firstrunwizard', 2, 1, 8026, 1546519311, 1546519311, 0, 0, '5c2e030f3e565', 31, ''),
(80, 1, 'appdata_ocu2rsyyk8v2/css/firstrunwizard/70e2-2477-firstrunwizard.css', 'e567ac66f632e874def499513648f760', 79, '70e2-2477-firstrunwizard.css', 17, 8, 6115, 1546519311, 1546519311, 0, 0, '4ae09f38e4580b2219346715ff233161', 27, ''),
(81, 1, 'appdata_ocu2rsyyk8v2/css/firstrunwizard/70e2-2477-firstrunwizard.css.deps', 'a6472abb9fdba5f6c7b06d6769fefaa1', 79, '70e2-2477-firstrunwizard.css.deps', 15, 3, 265, 1546519311, 1546519311, 0, 0, '295fa40ddce92fba0c95f7a0b3b2c335', 27, ''),
(82, 1, 'appdata_ocu2rsyyk8v2/css/firstrunwizard/70e2-2477-firstrunwizard.css.gzip', '8bee1071adade02a8de57222f95b4192', 79, '70e2-2477-firstrunwizard.css.gzip', 16, 3, 1646, 1546519311, 1546519311, 0, 0, 'c9d4f464868829be0714da491fb886a5', 27, ''),
(83, 1, 'appdata_ocu2rsyyk8v2/css/notifications', 'a6729fdce41c7abb141e8d78bee8df90', 66, 'notifications', 2, 1, 3806, 1546519311, 1546519311, 0, 0, '5c2e030f58048', 31, ''),
(84, 1, 'appdata_ocu2rsyyk8v2/css/notifications/2c83-2477-styles.css', '9d36b4d61027640c9b14b83d954c866c', 83, '2c83-2477-styles.css', 17, 8, 2871, 1546519311, 1546519311, 0, 0, 'ffa907d3e27dbb7539d54307a05c6ef4', 27, ''),
(85, 1, 'appdata_ocu2rsyyk8v2/css/notifications/2c83-2477-styles.css.deps', 'cca23628ec9763855720408e1d6a6d5d', 83, '2c83-2477-styles.css.deps', 15, 3, 184, 1546519311, 1546519311, 0, 0, 'fc816b03331b18beffbc21d579539f6b', 27, ''),
(86, 1, 'appdata_ocu2rsyyk8v2/css/notifications/2c83-2477-styles.css.gzip', 'ead0586ebed43ffc184aa823c2e43e9f', 83, '2c83-2477-styles.css.gzip', 16, 3, 751, 1546519311, 1546519311, 0, 0, 'dd84a816c2803a378c936263fa1ce90f', 27, ''),
(87, 1, 'appdata_ocu2rsyyk8v2/css/core/4f30-2477-jquery.ocdialog.css', '05e268b722499eadc2fc9edbc1a9b2d6', 68, '4f30-2477-jquery.ocdialog.css', 17, 8, 1397, 1546519311, 1546519311, 0, 0, '36619b1529cce5cec973ee2066aa7841', 27, ''),
(88, 1, 'appdata_ocu2rsyyk8v2/css/core/4f30-2477-jquery.ocdialog.css.deps', '725c9323761a9070dffb40c6a5c4d9a6', 68, '4f30-2477-jquery.ocdialog.css.deps', 15, 3, 178, 1546519311, 1546519311, 0, 0, 'b5682d1ada6825d04eb8ba5c1f7c6e17', 27, ''),
(89, 1, 'appdata_ocu2rsyyk8v2/css/core/4f30-2477-jquery.ocdialog.css.gzip', '133cd923fca83b1029ad9801552e96e0', 68, '4f30-2477-jquery.ocdialog.css.gzip', 16, 3, 580, 1546519311, 1546519311, 0, 0, '1545041a56e13291b773d6ab9e3e2b9e', 27, ''),
(90, 1, 'appdata_ocu2rsyyk8v2/css/core/4f30-2477-results.css', 'e362b5ea36e58d0b13ece62c90743401', 68, '4f30-2477-results.css', 17, 8, 1189, 1546519311, 1546519311, 0, 0, '702c682bf793346fe3d26c10a8b38f4a', 27, ''),
(91, 1, 'appdata_ocu2rsyyk8v2/css/core/4f30-2477-results.css.deps', '48a39bceb898f54ad4842e06f2dcceb6', 68, '4f30-2477-results.css.deps', 15, 3, 178, 1546519311, 1546519311, 0, 0, 'd620d9b14b486b89314d86def662a856', 27, ''),
(92, 1, 'appdata_ocu2rsyyk8v2/css/core/4f30-2477-results.css.gzip', '3c8e5c62d69e98120a86144f3d111d60', 68, '4f30-2477-results.css.gzip', 16, 3, 504, 1546519311, 1546519311, 0, 0, '36ec3020f3c610b9c0353770e1ee6909', 27, ''),
(93, 1, 'appdata_ocu2rsyyk8v2/css/files', 'b2ccda6551b42cb7219bda1e555b4a3b', 66, 'files', 2, 1, 23750, 1546519311, 1546519311, 0, 0, '5c2e030fe2209', 31, ''),
(94, 1, 'appdata_ocu2rsyyk8v2/css/files/d16b-2477-merged.css', 'cf9e215b8f6eba621c63bcd626da9732', 93, 'd16b-2477-merged.css', 17, 8, 18949, 1546519311, 1546519311, 0, 0, 'e2f3e939eb5d38edd7a91373bda4621b', 27, ''),
(95, 1, 'appdata_ocu2rsyyk8v2/css/files/d16b-2477-merged.css.deps', '285df40d03091a672f5da46ca1954a13', 93, 'd16b-2477-merged.css.deps', 15, 3, 480, 1546519311, 1546519311, 0, 0, 'ce163bce049c26743b6f332fe3184060', 27, ''),
(96, 1, 'appdata_ocu2rsyyk8v2/css/files/d16b-2477-merged.css.gzip', '4cd56ca059bf64d5cb2f93348dfc28cd', 93, 'd16b-2477-merged.css.gzip', 16, 3, 4321, 1546519311, 1546519311, 0, 0, '41063dd8ba2f835560e070763160bf0c', 27, ''),
(97, 1, 'appdata_ocu2rsyyk8v2/css/files_trashbin', '1d2e8857bb721eb4fca1910ce2fe3e95', 66, 'files_trashbin', 2, 1, 689, 1546519312, 1546519312, 0, 0, '5c2e03100d9ae', 31, ''),
(98, 1, 'appdata_ocu2rsyyk8v2/css/files_trashbin/1e6d-2477-trash.css', '5bf1316212f29016db379135f4b76df4', 97, '1e6d-2477-trash.css', 17, 8, 344, 1546519312, 1546519312, 0, 0, '461300f1c2b243cfe3ae5631a3e57b5b', 27, ''),
(99, 1, 'appdata_ocu2rsyyk8v2/css/files_trashbin/1e6d-2477-trash.css.deps', '82b7402bc718c30a1092b52850a6a882', 97, '1e6d-2477-trash.css.deps', 15, 3, 184, 1546519312, 1546519312, 0, 0, '6e666f8b745608131eaf94f3105bfa72', 27, ''),
(100, 1, 'appdata_ocu2rsyyk8v2/css/files_trashbin/1e6d-2477-trash.css.gzip', '37fe93a369c50456db805a3ac140de60', 97, '1e6d-2477-trash.css.gzip', 16, 3, 161, 1546519312, 1546519312, 0, 0, '514644dffd5e0973c047774d2220b963', 27, ''),
(101, 1, 'appdata_ocu2rsyyk8v2/css/comments', '78bfbf156c08e763599dddc526297af4', 66, 'comments', 2, 1, 8501, 1546519312, 1546519312, 0, 0, '5c2e03103989d', 31, ''),
(102, 1, 'appdata_ocu2rsyyk8v2/css/comments/1bf6-2477-autocomplete.css', 'b7d4d6e24e01dd8f1abe16b77e615235', 101, '1bf6-2477-autocomplete.css', 17, 8, 1211, 1546519312, 1546519312, 0, 0, '7c0d074d6b00d7d2d148b5b9e8ea3537', 27, ''),
(103, 1, 'appdata_ocu2rsyyk8v2/css/comments/1bf6-2477-autocomplete.css.deps', 'cee8d33e4fce7eb8935822c1ebee3a8e', 101, '1bf6-2477-autocomplete.css.deps', 15, 3, 185, 1546519312, 1546519312, 0, 0, 'b5a8b52925244692fa001f9ef3c38c4d', 27, ''),
(104, 1, 'appdata_ocu2rsyyk8v2/css/comments/1bf6-2477-autocomplete.css.gzip', '564365ff207bba0a2df862d5038b7bfd', 101, '1bf6-2477-autocomplete.css.gzip', 16, 3, 434, 1546519312, 1546519312, 0, 0, '5a3e2fafbbd9d58d4b43ea1554253cc2', 27, ''),
(105, 1, 'appdata_ocu2rsyyk8v2/css/comments/1bf6-2477-comments.css', '795c47abd5a12474a7678ba380ef88d9', 101, '1bf6-2477-comments.css', 17, 8, 5299, 1546519312, 1546519312, 0, 0, '9a78ac00d69d02c4f4b829ea77077c32', 27, ''),
(106, 1, 'appdata_ocu2rsyyk8v2/css/comments/1bf6-2477-comments.css.deps', 'dac18bb833e8c3e3bc3942db56577764', 101, '1bf6-2477-comments.css.deps', 15, 3, 181, 1546519312, 1546519312, 0, 0, '6a5ec7783019aba4fcd406cb659ef139', 27, ''),
(107, 1, 'appdata_ocu2rsyyk8v2/css/comments/1bf6-2477-comments.css.gzip', '3ee3c361d4e56a17c703c0a14581afdd', 101, '1bf6-2477-comments.css.gzip', 16, 3, 1191, 1546519312, 1546519312, 0, 0, '32c7bb518d7925635e598df1a9dd3406', 27, ''),
(108, 1, 'appdata_ocu2rsyyk8v2/css/files_sharing', 'c63967e926c42fa88114ed1d44388a3a', 66, 'files_sharing', 2, 1, 6175, 1546519312, 1546519312, 0, 0, '5c2e031050c25', 31, ''),
(109, 1, 'appdata_ocu2rsyyk8v2/css/files_sharing/861d-2477-mergedAdditionalStyles.css', 'ddd8a87588148b98a87dc7bf69fdf513', 108, '861d-2477-mergedAdditionalStyles.css', 17, 8, 4541, 1546519312, 1546519312, 0, 0, 'edbe0b90778f6e9b14d34d714b339480', 27, ''),
(110, 1, 'appdata_ocu2rsyyk8v2/css/files_sharing/861d-2477-mergedAdditionalStyles.css.deps', '609b6c88d90dfe186d5b5ba18ab428ea', 108, '861d-2477-mergedAdditionalStyles.css.deps', 15, 3, 353, 1546519312, 1546519312, 0, 0, '3028b85cde89cbedd91398e6a5511cf5', 27, ''),
(111, 1, 'appdata_ocu2rsyyk8v2/css/files_sharing/861d-2477-mergedAdditionalStyles.css.gzip', '4a2ea01d4dac16952dfbca3ad06adb5e', 108, '861d-2477-mergedAdditionalStyles.css.gzip', 16, 3, 1281, 1546519312, 1546519312, 0, 0, 'e1b169c1d0b7e3c35a15c513056d1b04', 27, ''),
(112, 1, 'appdata_ocu2rsyyk8v2/css/files_texteditor', 'e1da9ea5a89beecefc5e8e211b750ec6', 66, 'files_texteditor', 2, 1, 5831, 1546519312, 1546519312, 0, 0, '5c2e03106d28b', 31, ''),
(113, 1, 'appdata_ocu2rsyyk8v2/css/files_texteditor/783c-2477-merged.css', '3d33c67f0a764bc1f024fd3a2ab25338', 112, '783c-2477-merged.css', 17, 8, 4148, 1546519312, 1546519312, 0, 0, 'fea806a5f3a8fed01073d19f15f6cd9d', 27, ''),
(114, 1, 'appdata_ocu2rsyyk8v2/css/files_texteditor/783c-2477-merged.css.deps', '7626124ec56a0ce388fa8cb6f098c070', 112, '783c-2477-merged.css.deps', 15, 3, 421, 1546519312, 1546519312, 0, 0, 'c4b2af26e1f655fdc2d8ed8b6bed25b5', 27, ''),
(115, 1, 'appdata_ocu2rsyyk8v2/css/files_texteditor/783c-2477-merged.css.gzip', 'a8656671048475055cd22ff9f1a5645d', 112, '783c-2477-merged.css.gzip', 16, 3, 1262, 1546519312, 1546519312, 0, 0, '849d8ca4327fb51f0c47420de08a50b5', 27, ''),
(116, 1, 'appdata_ocu2rsyyk8v2/css/core/4f30-2477-systemtags.css', 'ca95fc073e37eba3fb50753c39b52bbe', 68, '4f30-2477-systemtags.css', 17, 8, 1403, 1546519312, 1546519312, 0, 0, '36c4d8c01d7aeafc80a3f8ea45ddf528', 27, ''),
(117, 1, 'appdata_ocu2rsyyk8v2/css/core/4f30-2477-systemtags.css.deps', '05efb8ecb31f890701fc637d8a8989e6', 68, '4f30-2477-systemtags.css.deps', 15, 3, 173, 1546519312, 1546519312, 0, 0, '92498e322f566080cec0e4e0fe8030f8', 27, ''),
(118, 1, 'appdata_ocu2rsyyk8v2/css/core/4f30-2477-systemtags.css.gzip', 'bd12f5f7828a79a031a9931f03c2418d', 68, '4f30-2477-systemtags.css.gzip', 16, 3, 385, 1546519312, 1546519312, 0, 0, 'a6120ab7650efbc2d0564c194a28e23f', 27, ''),
(119, 1, 'appdata_ocu2rsyyk8v2/css/systemtags', '437907f357df0199ad731f82edd63ab7', 66, 'systemtags', 2, 1, 684, 1546519312, 1546519312, 0, 0, '5c2e031093d55', 31, ''),
(120, 1, 'appdata_ocu2rsyyk8v2/css/systemtags/1bf6-2477-systemtagsfilelist.css', '85f7997f0ad3aa20e532349067c196a9', 119, '1bf6-2477-systemtagsfilelist.css', 17, 8, 285, 1546519312, 1546519312, 0, 0, '61b8eb4b447e7138f1a15a68c702998f', 27, ''),
(121, 1, 'appdata_ocu2rsyyk8v2/css/systemtags/1bf6-2477-systemtagsfilelist.css.deps', 'db09897386740b35f2ab94f365e0eeda', 119, '1bf6-2477-systemtagsfilelist.css.deps', 15, 3, 193, 1546519312, 1546519312, 0, 0, '5fb73049a34019ff26cb8c2b2e23acc5', 27, ''),
(122, 1, 'appdata_ocu2rsyyk8v2/css/systemtags/1bf6-2477-systemtagsfilelist.css.gzip', '643e342328dfb832c8d279188bfe76bc', 119, '1bf6-2477-systemtagsfilelist.css.gzip', 16, 3, 206, 1546519312, 1546519312, 0, 0, '0ee7fda2a343d856033f12821649e493', 27, ''),
(123, 1, 'appdata_ocu2rsyyk8v2/css/theming', 'f9172da65641e42f358a7056b1ae69f3', 66, 'theming', 2, 1, 1451, 1546519314, 1546519314, 0, 0, '5c2e031281bf9', 31, ''),
(124, 1, 'appdata_ocu2rsyyk8v2/css/theming/35c3-2477-theming.css', '58a6127d4439ddb0ba73bd32421dc659', 123, '35c3-2477-theming.css', 17, 8, 932, 1546519314, 1546519314, 0, 0, 'e34b30676069e2f4a25364676ac37a63', 27, ''),
(125, 1, 'appdata_ocu2rsyyk8v2/css/theming/35c3-2477-theming.css.deps', '5031f6f0d8ae4a9e98cb335b38549c78', 123, '35c3-2477-theming.css.deps', 15, 3, 179, 1546519314, 1546519314, 0, 0, '437d7a90d69731841f7a24131245d155', 27, ''),
(126, 1, 'appdata_ocu2rsyyk8v2/css/theming/35c3-2477-theming.css.gzip', '49b7e7a61b58109a4384b5794c2bf0c2', 123, '35c3-2477-theming.css.gzip', 16, 3, 340, 1546519314, 1546519314, 0, 0, 'e0d37a1152c93838e04286d064e79c88', 27, ''),
(127, 1, 'appdata_ocu2rsyyk8v2/preview/17', 'c579dfbb01da131873e5bb13c03b11b0', 5, '17', 2, 1, 68985, 1546519317, 1546519317, 0, 0, '5c2e0315c4275', 31, ''),
(128, 1, 'appdata_ocu2rsyyk8v2/preview/17/500-500-max.png', '13293081550d040f0b74356e443ac232', 127, '500-500-max.png', 11, 5, 64951, 1546519317, 1546519317, 0, 0, '59d8309b20b9d56985edeb4aa8b84b41', 27, ''),
(129, 1, 'appdata_ocu2rsyyk8v2/preview/17/64-64-crop.png', '4a97445141c9b24a9cf51cc4cd8975a8', 127, '64-64-crop.png', 11, 5, 4034, 1546519317, 1546519317, 0, 0, '2b22c74aca85bbd15e7a14e83f40424e', 27, ''),
(130, 1, 'appdata_ocu2rsyyk8v2/preview/19', '2e91e04c69f597ebd32f934876ff64f5', 5, '19', 2, 1, 658169, 1546519318, 1546519318, 0, 0, '5c2e03161d419', 31, ''),
(131, 1, 'appdata_ocu2rsyyk8v2/preview/19/1600-1268-max.jpg', 'b8b70050ad064dbbcfeae7f7b69c9a2c', 130, '1600-1268-max.jpg', 6, 5, 655152, 1546519317, 1546519317, 0, 0, '7327c571b19dc14437c2e0e355b6651b', 27, ''),
(132, 1, 'appdata_ocu2rsyyk8v2/theming/0', '63b54e2c2962c2d27fc15bc21fc91ddd', 20, '0', 2, 1, 1560, 1546519318, 1546519318, 0, 0, '5c2e031638a30', 31, ''),
(133, 1, 'appdata_ocu2rsyyk8v2/theming/0/icon-core-filetypes_folder.svg', '348fb2e5506c1f7d846dabee0fca5e7a', 132, 'icon-core-filetypes_folder.svg', 18, 5, 255, 1546519318, 1546519318, 0, 0, '115ca7f69a98160a3d04057d272399e5', 27, ''),
(134, 1, 'appdata_ocu2rsyyk8v2/preview/19/64-64-crop.jpg', 'fdcb363d8faaf8d247dfa3a0f60b8c97', 130, '64-64-crop.jpg', 6, 5, 3017, 1546519318, 1546519318, 0, 0, 'b0ef3d740b60b58712e2fd24a4bbba3e', 27, ''),
(135, 1, 'appdata_ocu2rsyyk8v2/theming/0/icon-core-filetypes_application-pdf.svg', '9dacd04d2b9da8c405a0a5a4315e4004', 132, 'icon-core-filetypes_application-pdf.svg', 18, 5, 676, 1546519318, 1546519318, 0, 0, '3b5dbd44f058dd0adc3de6afa0e7712d', 27, ''),
(136, 1, 'appdata_ocu2rsyyk8v2/theming/0/icon-core-filetypes_image.svg', '9aa273ce5d08642d42d464ad8e085433', 132, 'icon-core-filetypes_image.svg', 18, 5, 352, 1546519318, 1546519318, 0, 0, 'caafcab8b108ea09081ad31cd4c58a28', 27, ''),
(137, 1, 'appdata_ocu2rsyyk8v2/theming/0/icon-core-filetypes_video.svg', '2db391acb6ebe09e1721f600a924eae6', 132, 'icon-core-filetypes_video.svg', 18, 5, 277, 1546519318, 1546519318, 0, 0, '8906550f6bd9ca831b445c2e6f3a7ee0', 27, ''),
(138, 1, 'appdata_ocu2rsyyk8v2/js/core/merged-login.js', 'b641fef54557060fa9bdaf18f4b4f187', 24, 'merged-login.js', 14, 3, 7541, 1546519346, 1546519346, 0, 0, '611e74d84ae3f1d2e25801cd3f77d3c6', 27, ''),
(139, 1, 'appdata_ocu2rsyyk8v2/js/core/merged-login.js.deps', 'eade14307b60b3c41b95135926c1ca7a', 24, 'merged-login.js.deps', 15, 3, 227, 1546519346, 1546519346, 0, 0, 'b0a2744511c8494b17e7849de28ad727', 27, ''),
(140, 1, 'appdata_ocu2rsyyk8v2/js/core/merged-login.js.gzip', 'bdaaa4607d1cf9230c62995909d0b4c3', 24, 'merged-login.js.gzip', 16, 3, 2282, 1546519346, 1546519346, 0, 0, 'a61d7a2afc298095b054b162bcd7c99e', 27, '');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `files_trash`
--

DROP TABLE IF EXISTS `files_trash`;
CREATE TABLE `files_trash` (
  `auto_id` int(11) NOT NULL,
  `id` varchar(250) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `user` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `timestamp` varchar(12) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `location` varchar(512) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `type` varchar(4) COLLATE utf8mb4_bin DEFAULT NULL,
  `mime` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `file_locks`
--

DROP TABLE IF EXISTS `file_locks`;
CREATE TABLE `file_locks` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `lock` int(11) NOT NULL DEFAULT 0,
  `key` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `ttl` int(11) NOT NULL DEFAULT -1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `flow_checks`
--

DROP TABLE IF EXISTS `flow_checks`;
CREATE TABLE `flow_checks` (
  `id` int(11) NOT NULL,
  `class` varchar(256) COLLATE utf8mb4_bin NOT NULL,
  `operator` varchar(16) COLLATE utf8mb4_bin NOT NULL,
  `value` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `hash` varchar(32) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `flow_operations`
--

DROP TABLE IF EXISTS `flow_operations`;
CREATE TABLE `flow_operations` (
  `id` int(11) NOT NULL,
  `class` varchar(256) COLLATE utf8mb4_bin NOT NULL,
  `name` varchar(256) COLLATE utf8mb4_bin NOT NULL,
  `checks` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `operation` longtext COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `groups`
--

DROP TABLE IF EXISTS `groups`;
CREATE TABLE `groups` (
  `gid` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

--
-- Daten für Tabelle `groups`
--

INSERT INTO `groups` (`gid`) VALUES
('admin');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `group_admin`
--

DROP TABLE IF EXISTS `group_admin`;
CREATE TABLE `group_admin` (
  `gid` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `uid` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `group_user`
--

DROP TABLE IF EXISTS `group_user`;
CREATE TABLE `group_user` (
  `gid` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `uid` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `jobs`
--

DROP TABLE IF EXISTS `jobs`;
CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `class` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `argument` varchar(4000) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `last_run` int(11) DEFAULT 0,
  `last_checked` int(11) DEFAULT 0,
  `reserved_at` int(11) DEFAULT 0,
  `execution_duration` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

--
-- Daten für Tabelle `jobs`
--

INSERT INTO `jobs` (`id`, `class`, `argument`, `last_run`, `last_checked`, `reserved_at`, `execution_duration`) VALUES
(1, 'OCA\\UpdateNotification\\Notification\\BackgroundJob', 'null', 1546519315, 1546519315, 0, 0),
(2, 'OCA\\Files_Trashbin\\BackgroundJob\\ExpireTrash', 'null', 1546519348, 1546519348, 0, 0),
(3, 'OCA\\Files\\BackgroundJob\\ScanFiles', 'null', 0, 1546519300, 0, 0),
(4, 'OCA\\Files\\BackgroundJob\\DeleteOrphanedItems', 'null', 0, 1546519300, 0, 0),
(5, 'OCA\\Files\\BackgroundJob\\CleanupFileLocks', 'null', 0, 1546519300, 0, 0),
(6, 'OCA\\Federation\\SyncJob', 'null', 0, 1546519300, 0, 0),
(7, 'OCA\\NextcloudAnnouncements\\Cron\\Crawler', 'null', 0, 1546519300, 0, 0),
(8, 'OCA\\Activity\\BackgroundJob\\EmailNotification', 'null', 0, 1546519301, 0, 0),
(9, 'OCA\\Activity\\BackgroundJob\\ExpireActivities', 'null', 0, 1546519301, 0, 0),
(10, 'OCA\\DAV\\BackgroundJob\\CleanupDirectLinksJob', 'null', 0, 1546519302, 0, 0),
(11, 'OCA\\DAV\\BackgroundJob\\UpdateCalendarResourcesRoomsBackgroundJob', 'null', 0, 1546519302, 0, 0),
(12, 'OCA\\DAV\\BackgroundJob\\CleanupInvitationTokenJob', 'null', 0, 1546519302, 0, 0),
(13, 'OCA\\Files_Versions\\BackgroundJob\\ExpireVersions', 'null', 0, 1546519302, 0, 0),
(14, 'OCA\\Survey_Client\\BackgroundJobs\\AdminNotification', 'null', 0, 1546519303, 0, 0),
(15, 'OCA\\Files_Sharing\\DeleteOrphanedSharesJob', 'null', 0, 1546519303, 0, 0),
(16, 'OCA\\Files_Sharing\\ExpireSharesJob', 'null', 0, 1546519303, 0, 0),
(17, 'OCA\\Files_Sharing\\BackgroundJob\\FederatedSharesDiscoverJob', 'null', 0, 1546519303, 0, 0),
(18, 'OCA\\Support\\BackgroundJobs\\CheckSubscription', 'null', 0, 1546519303, 0, 0),
(19, 'OC\\Authentication\\Token\\DefaultTokenCleanupJob', 'null', 0, 1546519305, 0, 0),
(20, 'OC\\Log\\Rotate', 'null', 0, 1546519305, 0, 0),
(21, 'OC\\Preview\\BackgroundCleanupJob', 'null', 0, 1546519305, 0, 0);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `migrations`
--

DROP TABLE IF EXISTS `migrations`;
CREATE TABLE `migrations` (
  `app` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `version` varchar(255) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

--
-- Daten für Tabelle `migrations`
--

INSERT INTO `migrations` (`app`, `version`) VALUES
('activity', '2006Date20170808154933'),
('activity', '2006Date20170808155040'),
('activity', '2006Date20170919095939'),
('core', '13000Date20170705121758'),
('core', '13000Date20170718121200'),
('core', '13000Date20170814074715'),
('core', '13000Date20170919121250'),
('core', '13000Date20170926101637'),
('core', '14000Date20180129121024'),
('core', '14000Date20180404140050'),
('core', '14000Date20180516101403'),
('core', '14000Date20180518120534'),
('core', '14000Date20180522074438'),
('core', '14000Date20180626223656'),
('core', '14000Date20180710092004'),
('core', '14000Date20180712153140'),
('dav', '1004Date20170825134824'),
('dav', '1004Date20170919104507'),
('dav', '1004Date20170924124212'),
('dav', '1004Date20170926103422'),
('dav', '1005Date20180413093149'),
('dav', '1005Date20180530124431'),
('dav', '1006Date20180619154313'),
('twofactor_backupcodes', '1002Date20170607104347'),
('twofactor_backupcodes', '1002Date20170607113030'),
('twofactor_backupcodes', '1002Date20170919123342'),
('twofactor_backupcodes', '1002Date20170926101419'),
('twofactor_backupcodes', '1002Date20180821043638');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `mimetypes`
--

DROP TABLE IF EXISTS `mimetypes`;
CREATE TABLE `mimetypes` (
  `id` bigint(20) NOT NULL,
  `mimetype` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

--
-- Daten für Tabelle `mimetypes`
--

INSERT INTO `mimetypes` (`id`, `mimetype`) VALUES
(3, 'application'),
(14, 'application/javascript'),
(4, 'application/json'),
(15, 'application/octet-stream'),
(10, 'application/pdf'),
(7, 'application/vnd.oasis.opendocument.text'),
(16, 'application/x-gzip'),
(1, 'httpd'),
(2, 'httpd/unix-directory'),
(5, 'image'),
(6, 'image/jpeg'),
(11, 'image/png'),
(18, 'image/svg+xml'),
(8, 'text'),
(17, 'text/css'),
(9, 'text/plain'),
(12, 'video'),
(13, 'video/mp4');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `mounts`
--

DROP TABLE IF EXISTS `mounts`;
CREATE TABLE `mounts` (
  `id` bigint(20) NOT NULL,
  `storage_id` int(11) NOT NULL,
  `root_id` int(11) NOT NULL,
  `user_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `mount_point` varchar(4000) COLLATE utf8mb4_bin NOT NULL,
  `mount_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;


-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `notifications`
--

DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL,
  `app` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `user` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `timestamp` int(11) NOT NULL DEFAULT 0,
  `object_type` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `object_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `subject` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `subject_parameters` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `message` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `message_parameters` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `link` varchar(4000) COLLATE utf8mb4_bin DEFAULT NULL,
  `icon` varchar(4000) COLLATE utf8mb4_bin DEFAULT NULL,
  `actions` longtext COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `notifications_pushtokens`
--

DROP TABLE IF EXISTS `notifications_pushtokens`;
CREATE TABLE `notifications_pushtokens` (
  `uid` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `token` int(11) NOT NULL DEFAULT 0,
  `deviceidentifier` varchar(128) COLLATE utf8mb4_bin NOT NULL,
  `devicepublickey` varchar(512) COLLATE utf8mb4_bin NOT NULL,
  `devicepublickeyhash` varchar(128) COLLATE utf8mb4_bin NOT NULL,
  `pushtokenhash` varchar(128) COLLATE utf8mb4_bin NOT NULL,
  `proxyserver` varchar(256) COLLATE utf8mb4_bin NOT NULL,
  `apptype` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT 'unknown'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `oauth2_access_tokens`
--

DROP TABLE IF EXISTS `oauth2_access_tokens`;
CREATE TABLE `oauth2_access_tokens` (
  `id` int(10) UNSIGNED NOT NULL,
  `token_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `hashed_code` varchar(128) COLLATE utf8mb4_bin NOT NULL,
  `encrypted_token` varchar(786) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `oauth2_clients`
--

DROP TABLE IF EXISTS `oauth2_clients`;
CREATE TABLE `oauth2_clients` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `redirect_uri` varchar(2000) COLLATE utf8mb4_bin NOT NULL,
  `client_identifier` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `secret` varchar(64) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `preferences`
--

DROP TABLE IF EXISTS `preferences`;
CREATE TABLE `preferences` (
  `userid` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `appid` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `configkey` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `configvalue` longtext COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;
-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `properties`
--

DROP TABLE IF EXISTS `properties`;
CREATE TABLE `properties` (
  `id` bigint(20) NOT NULL,
  `userid` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `propertypath` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `propertyname` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `propertyvalue` longtext COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `schedulingobjects`
--

DROP TABLE IF EXISTS `schedulingobjects`;
CREATE TABLE `schedulingobjects` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `principaluri` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `calendardata` longblob DEFAULT NULL,
  `uri` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `lastmodified` int(10) UNSIGNED DEFAULT NULL,
  `etag` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `size` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `share`
--

DROP TABLE IF EXISTS `share`;
CREATE TABLE `share` (
  `id` bigint(20) NOT NULL,
  `share_type` smallint(6) NOT NULL DEFAULT 0,
  `share_with` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `uid_owner` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `uid_initiator` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `parent` bigint(20) DEFAULT NULL,
  `item_type` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `item_source` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `item_target` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `file_source` bigint(20) DEFAULT NULL,
  `file_target` varchar(512) COLLATE utf8mb4_bin DEFAULT NULL,
  `permissions` smallint(6) NOT NULL DEFAULT 0,
  `stime` bigint(20) NOT NULL DEFAULT 0,
  `accepted` smallint(6) NOT NULL DEFAULT 0,
  `expiration` datetime DEFAULT NULL,
  `token` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `mail_send` smallint(6) NOT NULL DEFAULT 0,
  `share_name` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `password_by_talk` tinyint(1) NOT NULL DEFAULT 0,
  `note` longtext COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `share_external`
--

DROP TABLE IF EXISTS `share_external`;
CREATE TABLE `share_external` (
  `id` int(11) NOT NULL,
  `parent` int(11) DEFAULT -1,
  `share_type` int(11) DEFAULT NULL,
  `remote` varchar(512) COLLATE utf8mb4_bin NOT NULL COMMENT 'Url of the remove owncloud instance',
  `remote_id` int(11) NOT NULL DEFAULT -1,
  `share_token` varchar(64) COLLATE utf8mb4_bin NOT NULL COMMENT 'Public share token',
  `password` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Optional password for the public share',
  `name` varchar(64) COLLATE utf8mb4_bin NOT NULL COMMENT 'Original name on the remote server',
  `owner` varchar(64) COLLATE utf8mb4_bin NOT NULL COMMENT 'User that owns the public share on the remote server',
  `user` varchar(64) COLLATE utf8mb4_bin NOT NULL COMMENT 'Local user which added the external share',
  `mountpoint` varchar(4000) COLLATE utf8mb4_bin NOT NULL COMMENT 'Full path where the share is mounted',
  `mountpoint_hash` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT 'md5 hash of the mountpoint',
  `accepted` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `storages`
--

DROP TABLE IF EXISTS `storages`;
CREATE TABLE `storages` (
  `numeric_id` bigint(20) NOT NULL,
  `id` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `available` int(11) NOT NULL DEFAULT 1,
  `last_checked` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

--
-- Daten für Tabelle `storages`
--

INSERT INTO `storages` (`numeric_id`, `id`, `available`, `last_checked`) VALUES
(1, 'local::/var/www/html/data/', 1, NULL);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `systemtag`
--

DROP TABLE IF EXISTS `systemtag`;
CREATE TABLE `systemtag` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `visibility` smallint(6) NOT NULL DEFAULT 1,
  `editable` smallint(6) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `systemtag_group`
--

DROP TABLE IF EXISTS `systemtag_group`;
CREATE TABLE `systemtag_group` (
  `gid` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `systemtagid` bigint(20) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `systemtag_object_mapping`
--

DROP TABLE IF EXISTS `systemtag_object_mapping`;
CREATE TABLE `systemtag_object_mapping` (
  `objectid` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `objecttype` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `systemtagid` bigint(20) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `trusted_servers`
--

DROP TABLE IF EXISTS `trusted_servers`;
CREATE TABLE `trusted_servers` (
  `id` int(11) NOT NULL,
  `url` varchar(512) COLLATE utf8mb4_bin NOT NULL COMMENT 'Url of trusted server',
  `url_hash` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT 'sha1 hash of the url without the protocol',
  `token` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'token used to exchange the shared secret',
  `shared_secret` varchar(256) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'shared secret used to authenticate',
  `status` int(11) NOT NULL DEFAULT 2 COMMENT 'current status of the connection',
  `sync_token` varchar(512) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'cardDav sync token'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `twofactor_backupcodes`
--

DROP TABLE IF EXISTS `twofactor_backupcodes`;
CREATE TABLE `twofactor_backupcodes` (
  `id` bigint(20) NOT NULL,
  `user_id` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `code` varchar(128) COLLATE utf8mb4_bin NOT NULL,
  `used` smallint(6) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `twofactor_providers`
--

DROP TABLE IF EXISTS `twofactor_providers`;
CREATE TABLE `twofactor_providers` (
  `provider_id` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `uid` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `enabled` smallint(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `uid` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `displayname` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `uid_lower` varchar(64) COLLATE utf8mb4_bin DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `vcategory`
--

DROP TABLE IF EXISTS `vcategory`;
CREATE TABLE `vcategory` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uid` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `type` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `category` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `vcategory_to_object`
--

DROP TABLE IF EXISTS `vcategory_to_object`;
CREATE TABLE `vcategory_to_object` (
  `categoryid` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `objid` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `type` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `whats_new`
--

DROP TABLE IF EXISTS `whats_new`;
CREATE TABLE `whats_new` (
  `id` int(10) UNSIGNED NOT NULL,
  `version` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '11',
  `etag` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `last_check` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `data` longtext COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED;

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`uid`);

--
-- Indizes für die Tabelle `activity`
--
ALTER TABLE `activity`
  ADD PRIMARY KEY (`activity_id`),
  ADD KEY `activity_time` (`timestamp`),
  ADD KEY `activity_user_time` (`affecteduser`,`timestamp`),
  ADD KEY `activity_filter_by` (`affecteduser`,`user`,`timestamp`),
  ADD KEY `activity_filter` (`affecteduser`,`type`,`app`,`timestamp`),
  ADD KEY `activity_object` (`object_type`,`object_id`);

--
-- Indizes für die Tabelle `activity_mq`
--
ALTER TABLE `activity_mq`
  ADD PRIMARY KEY (`mail_id`),
  ADD KEY `amp_user` (`amq_affecteduser`),
  ADD KEY `amp_latest_send_time` (`amq_latest_send`),
  ADD KEY `amp_timestamp_time` (`amq_timestamp`);

--
-- Indizes für die Tabelle `addressbookchanges`
--
ALTER TABLE `addressbookchanges`
  ADD PRIMARY KEY (`id`),
  ADD KEY `addressbookid_synctoken` (`addressbookid`,`synctoken`);

--
-- Indizes für die Tabelle `addressbooks`
--
ALTER TABLE `addressbooks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `addressbook_index` (`principaluri`,`uri`);

--
-- Indizes für die Tabelle `appconfig`
--
ALTER TABLE `appconfig`
  ADD PRIMARY KEY (`appid`,`configkey`),
  ADD KEY `appconfig_config_key_index` (`configkey`),
  ADD KEY `appconfig_appid_key` (`appid`);

--
-- Indizes für die Tabelle `authtoken`
--
ALTER TABLE `authtoken`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `authtoken_token_index` (`token`),
  ADD KEY `authtoken_last_activity_index` (`last_activity`),
  ADD KEY `authtoken_uid_index` (`uid`),
  ADD KEY `authtoken_version_index` (`version`);

--
-- Indizes für die Tabelle `bruteforce_attempts`
--
ALTER TABLE `bruteforce_attempts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bruteforce_attempts_ip` (`ip`),
  ADD KEY `bruteforce_attempts_subnet` (`subnet`);

--
-- Indizes für die Tabelle `calendarchanges`
--
ALTER TABLE `calendarchanges`
  ADD PRIMARY KEY (`id`),
  ADD KEY `calendarid_synctoken` (`calendarid`,`synctoken`);

--
-- Indizes für die Tabelle `calendarobjects`
--
ALTER TABLE `calendarobjects`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `calobjects_index` (`calendarid`,`uri`);

--
-- Indizes für die Tabelle `calendarobjects_props`
--
ALTER TABLE `calendarobjects_props`
  ADD PRIMARY KEY (`id`),
  ADD KEY `calendarobject_index` (`objectid`),
  ADD KEY `calendarobject_name_index` (`name`),
  ADD KEY `calendarobject_value_index` (`value`);

--
-- Indizes für die Tabelle `calendars`
--
ALTER TABLE `calendars`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `calendars_index` (`principaluri`,`uri`);

--
-- Indizes für die Tabelle `calendarsubscriptions`
--
ALTER TABLE `calendarsubscriptions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `calsub_index` (`principaluri`,`uri`);

--
-- Indizes für die Tabelle `calendar_invitations`
--
ALTER TABLE `calendar_invitations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `calendar_invitation_tokens` (`token`);

--
-- Indizes für die Tabelle `calendar_resources`
--
ALTER TABLE `calendar_resources`
  ADD PRIMARY KEY (`id`),
  ADD KEY `calendar_resources_bkdrsc` (`backend_id`,`resource_id`),
  ADD KEY `calendar_resources_email` (`email`),
  ADD KEY `calendar_resources_name` (`displayname`);

--
-- Indizes für die Tabelle `calendar_rooms`
--
ALTER TABLE `calendar_rooms`
  ADD PRIMARY KEY (`id`),
  ADD KEY `calendar_rooms_bkdrsc` (`backend_id`,`resource_id`),
  ADD KEY `calendar_rooms_email` (`email`),
  ADD KEY `calendar_rooms_name` (`displayname`);

--
-- Indizes für die Tabelle `cards`
--
ALTER TABLE `cards`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_4C258FD8B26C2E9` (`addressbookid`);

--
-- Indizes für die Tabelle `cards_properties`
--
ALTER TABLE `cards_properties`
  ADD PRIMARY KEY (`id`),
  ADD KEY `card_contactid_index` (`cardid`),
  ADD KEY `card_name_index` (`name`),
  ADD KEY `card_value_index` (`value`),
  ADD KEY `IDX_1E67085C8B26C2E9` (`addressbookid`);

--
-- Indizes für die Tabelle `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `comments_parent_id_index` (`parent_id`),
  ADD KEY `comments_topmost_parent_id_idx` (`topmost_parent_id`),
  ADD KEY `comments_object_index` (`object_type`,`object_id`,`creation_timestamp`),
  ADD KEY `comments_actor_index` (`actor_type`,`actor_id`);

--
-- Indizes für die Tabelle `comments_read_markers`
--
ALTER TABLE `comments_read_markers`
  ADD UNIQUE KEY `comments_marker_index` (`user_id`,`object_type`,`object_id`),
  ADD KEY `comments_marker_object_index` (`object_type`,`object_id`);

--
-- Indizes für die Tabelle `credentials`
--
ALTER TABLE `credentials`
  ADD PRIMARY KEY (`user`,`identifier`),
  ADD KEY `credentials_user` (`user`);

--
-- Indizes für die Tabelle `dav_shares`
--
ALTER TABLE `dav_shares`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `dav_shares_index` (`principaluri`,`resourceid`,`type`,`publicuri`);

--
-- Indizes für die Tabelle `directlink`
--
ALTER TABLE `directlink`
  ADD PRIMARY KEY (`id`),
  ADD KEY `directlink_token_idx` (`token`),
  ADD KEY `directlink_expiration_idx` (`expiration`);

--
-- Indizes für die Tabelle `federated_reshares`
--
ALTER TABLE `federated_reshares`
  ADD UNIQUE KEY `share_id_index` (`share_id`);

--
-- Indizes für die Tabelle `filecache`
--
ALTER TABLE `filecache`
  ADD PRIMARY KEY (`fileid`),
  ADD UNIQUE KEY `fs_storage_path_hash` (`storage`,`path_hash`),
  ADD KEY `fs_parent_name_hash` (`parent`,`name`),
  ADD KEY `fs_storage_mimetype` (`storage`,`mimetype`),
  ADD KEY `fs_storage_mimepart` (`storage`,`mimepart`),
  ADD KEY `fs_storage_size` (`storage`,`size`,`fileid`),
  ADD KEY `fs_mtime` (`mtime`);

--
-- Indizes für die Tabelle `files_trash`
--
ALTER TABLE `files_trash`
  ADD PRIMARY KEY (`auto_id`),
  ADD KEY `id_index` (`id`),
  ADD KEY `timestamp_index` (`timestamp`),
  ADD KEY `user_index` (`user`);

--
-- Indizes für die Tabelle `file_locks`
--
ALTER TABLE `file_locks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `lock_key_index` (`key`),
  ADD KEY `lock_ttl_index` (`ttl`);

--
-- Indizes für die Tabelle `flow_checks`
--
ALTER TABLE `flow_checks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `flow_unique_hash` (`hash`);

--
-- Indizes für die Tabelle `flow_operations`
--
ALTER TABLE `flow_operations`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `groups`
--
ALTER TABLE `groups`
  ADD PRIMARY KEY (`gid`);

--
-- Indizes für die Tabelle `group_admin`
--
ALTER TABLE `group_admin`
  ADD PRIMARY KEY (`gid`,`uid`),
  ADD KEY `group_admin_uid` (`uid`);

--
-- Indizes für die Tabelle `group_user`
--
ALTER TABLE `group_user`
  ADD PRIMARY KEY (`gid`,`uid`),
  ADD KEY `gu_uid_index` (`uid`);

--
-- Indizes für die Tabelle `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `job_class_index` (`class`);

--
-- Indizes für die Tabelle `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`app`,`version`);

--
-- Indizes für die Tabelle `mimetypes`
--
ALTER TABLE `mimetypes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `mimetype_id_index` (`mimetype`);

--
-- Indizes für die Tabelle `mounts`
--
ALTER TABLE `mounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `mounts_user_root_index` (`user_id`,`root_id`),
  ADD KEY `mounts_user_index` (`user_id`),
  ADD KEY `mounts_storage_index` (`storage_id`),
  ADD KEY `mounts_root_index` (`root_id`),
  ADD KEY `mounts_mount_id_index` (`mount_id`);

--
-- Indizes für die Tabelle `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `oc_notifications_app` (`app`),
  ADD KEY `oc_notifications_user` (`user`),
  ADD KEY `oc_notifications_timestamp` (`timestamp`),
  ADD KEY `oc_notifications_object` (`object_type`,`object_id`);

--
-- Indizes für die Tabelle `notifications_pushtokens`
--
ALTER TABLE `notifications_pushtokens`
  ADD UNIQUE KEY `oc_notifpushtoken` (`uid`,`token`);

--
-- Indizes für die Tabelle `oauth2_access_tokens`
--
ALTER TABLE `oauth2_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `oauth2_access_hash_idx` (`hashed_code`),
  ADD KEY `oauth2_access_client_id_idx` (`client_id`);

--
-- Indizes für die Tabelle `oauth2_clients`
--
ALTER TABLE `oauth2_clients`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth2_client_id_idx` (`client_identifier`);

--
-- Indizes für die Tabelle `preferences`
--
ALTER TABLE `preferences`
  ADD PRIMARY KEY (`userid`,`appid`,`configkey`);

--
-- Indizes für die Tabelle `properties`
--
ALTER TABLE `properties`
  ADD PRIMARY KEY (`id`),
  ADD KEY `property_index` (`userid`);

--
-- Indizes für die Tabelle `schedulingobjects`
--
ALTER TABLE `schedulingobjects`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `share`
--
ALTER TABLE `share`
  ADD PRIMARY KEY (`id`),
  ADD KEY `item_share_type_index` (`item_type`,`share_type`),
  ADD KEY `file_source_index` (`file_source`),
  ADD KEY `token_index` (`token`),
  ADD KEY `share_with_index` (`share_with`),
  ADD KEY `parent_index` (`parent`);

--
-- Indizes für die Tabelle `share_external`
--
ALTER TABLE `share_external`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sh_external_mp` (`user`,`mountpoint_hash`),
  ADD KEY `sh_external_user` (`user`);

--
-- Indizes für die Tabelle `storages`
--
ALTER TABLE `storages`
  ADD PRIMARY KEY (`numeric_id`),
  ADD UNIQUE KEY `storages_id_index` (`id`);

--
-- Indizes für die Tabelle `systemtag`
--
ALTER TABLE `systemtag`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tag_ident` (`name`,`visibility`,`editable`);

--
-- Indizes für die Tabelle `systemtag_group`
--
ALTER TABLE `systemtag_group`
  ADD PRIMARY KEY (`gid`,`systemtagid`);

--
-- Indizes für die Tabelle `systemtag_object_mapping`
--
ALTER TABLE `systemtag_object_mapping`
  ADD UNIQUE KEY `mapping` (`objecttype`,`objectid`,`systemtagid`);

--
-- Indizes für die Tabelle `trusted_servers`
--
ALTER TABLE `trusted_servers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `url_hash` (`url_hash`);

--
-- Indizes für die Tabelle `twofactor_backupcodes`
--
ALTER TABLE `twofactor_backupcodes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `twofactor_backupcodes_uid` (`user_id`);

--
-- Indizes für die Tabelle `twofactor_providers`
--
ALTER TABLE `twofactor_providers`
  ADD PRIMARY KEY (`provider_id`,`uid`);

--
-- Indizes für die Tabelle `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`uid`),
  ADD KEY `user_uid_lower` (`uid_lower`);

--
-- Indizes für die Tabelle `vcategory`
--
ALTER TABLE `vcategory`
  ADD PRIMARY KEY (`id`),
  ADD KEY `uid_index` (`uid`),
  ADD KEY `type_index` (`type`),
  ADD KEY `category_index` (`category`);

--
-- Indizes für die Tabelle `vcategory_to_object`
--
ALTER TABLE `vcategory_to_object`
  ADD PRIMARY KEY (`categoryid`,`objid`,`type`),
  ADD KEY `vcategory_objectd_index` (`objid`,`type`);

--
-- Indizes für die Tabelle `whats_new`
--
ALTER TABLE `whats_new`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_75091186BF1CD3C3` (`version`),
  ADD KEY `version_etag_idx` (`version`,`etag`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `activity`
--
ALTER TABLE `activity`
  MODIFY `activity_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `activity_mq`
--
ALTER TABLE `activity_mq`
  MODIFY `mail_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `addressbookchanges`
--
ALTER TABLE `addressbookchanges`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `addressbooks`
--
ALTER TABLE `addressbooks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `authtoken`
--
ALTER TABLE `authtoken`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT für Tabelle `bruteforce_attempts`
--
ALTER TABLE `bruteforce_attempts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `calendarchanges`
--
ALTER TABLE `calendarchanges`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `calendarobjects`
--
ALTER TABLE `calendarobjects`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `calendarobjects_props`
--
ALTER TABLE `calendarobjects_props`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `calendars`
--
ALTER TABLE `calendars`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `calendarsubscriptions`
--
ALTER TABLE `calendarsubscriptions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `calendar_invitations`
--
ALTER TABLE `calendar_invitations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `calendar_resources`
--
ALTER TABLE `calendar_resources`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `calendar_rooms`
--
ALTER TABLE `calendar_rooms`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `cards`
--
ALTER TABLE `cards`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `cards_properties`
--
ALTER TABLE `cards_properties`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `comments`
--
ALTER TABLE `comments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `dav_shares`
--
ALTER TABLE `dav_shares`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `directlink`
--
ALTER TABLE `directlink`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `filecache`
--
ALTER TABLE `filecache`
  MODIFY `fileid` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=141;

--
-- AUTO_INCREMENT für Tabelle `files_trash`
--
ALTER TABLE `files_trash`
  MODIFY `auto_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `file_locks`
--
ALTER TABLE `file_locks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `flow_checks`
--
ALTER TABLE `flow_checks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `flow_operations`
--
ALTER TABLE `flow_operations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT für Tabelle `mimetypes`
--
ALTER TABLE `mimetypes`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT für Tabelle `mounts`
--
ALTER TABLE `mounts`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT für Tabelle `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `oauth2_access_tokens`
--
ALTER TABLE `oauth2_access_tokens`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `oauth2_clients`
--
ALTER TABLE `oauth2_clients`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `properties`
--
ALTER TABLE `properties`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `schedulingobjects`
--
ALTER TABLE `schedulingobjects`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `share`
--
ALTER TABLE `share`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `share_external`
--
ALTER TABLE `share_external`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `storages`
--
ALTER TABLE `storages`
  MODIFY `numeric_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT für Tabelle `systemtag`
--
ALTER TABLE `systemtag`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `trusted_servers`
--
ALTER TABLE `trusted_servers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `twofactor_backupcodes`
--
ALTER TABLE `twofactor_backupcodes`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `vcategory`
--
ALTER TABLE `vcategory`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `whats_new`
--
ALTER TABLE `whats_new`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
