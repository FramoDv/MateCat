-- Database: `matecat`
-- 

SET SESSION sql_mode='NO_AUTO_VALUE_ON_ZERO';

CREATE DATABASE `matecat` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE matecat;

-- --------------------------------------------------------

-- 
-- Table structure for table `converters`
-- 

CREATE TABLE IF NOT EXISTS `converters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip_converter` varchar(45) NOT NULL,
  `ip_storage` varchar(45) NOT NULL,
  `ip_machine_host` varchar(45) NOT NULL,
  `machine_host_user` varchar(45) NOT NULL,
  `machine_host_pass` varchar(45) NOT NULL,
  `instance_name` varchar(45) NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status_active` tinyint(4) NOT NULL DEFAULT '1',
  `status_offline` tinyint(4) NOT NULL DEFAULT '0',
  `status_reboot` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `ip_converter_UNIQUE` (`ip_converter`),
  UNIQUE KEY `ip_storage_UNIQUE` (`ip_storage`),
  KEY `status_active` (`status_active`),
  KEY `status_offline` (`status_offline`),
  KEY `status_reboot` (`status_reboot`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 AUTO_INCREMENT=0 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `converters_log`
-- 

CREATE TABLE IF NOT EXISTS `converters_log` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `id_converter` int(11) NOT NULL,
  `check_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `test_passed` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_log`),
  KEY `timestamp_idx` (`check_time`),
  KEY `outcome_idx` (`test_passed`),
  KEY `id_converter_idx` (`id_converter`)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 AUTO_INCREMENT=0 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `engines`
-- 

CREATE TABLE IF NOT EXISTS `engines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT 'no_name_engine',
  `type` varchar(45) NOT NULL DEFAULT 'MT',
  `description` text,
  `base_url` varchar(200) NOT NULL,
  `translate_relative_url` varchar(100) DEFAULT 'get',
  `contribute_relative_url` varchar(100) DEFAULT NULL,
  `delete_relative_url` varchar(100) DEFAULT NULL,
  `gloss_get_relative_url` varchar(100) DEFAULT NULL,
  `gloss_set_relative_url` varchar(100) DEFAULT NULL,
  `gloss_update_relative_url` varchar(100) DEFAULT NULL,
  `gloss_delete_relative_url` varchar(100) DEFAULT NULL,
  `tmx_import_relative_url` varchar(100) DEFAULT NULL,
  `tmx_status_relative_url` varchar(100) DEFAULT NULL,
  `extra_parameters` text,
  `google_api_compliant_version` varchar(45) DEFAULT NULL COMMENT 'credo sia superfluo',
  `penalty` int(11) DEFAULT '0',
  `active` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `type` (`type`),
  KEY `active_idx` (`active`) USING BTREE,
  FULLTEXT KEY `name` (`name`),
  FULLTEXT KEY `description` (`description`),
  FULLTEXT KEY `base_url` (`base_url`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

LOCK TABLES `engines` WRITE;
/*!40000 ALTER TABLE `engines` DISABLE KEYS */;
INSERT INTO `engines` (`id`, `name`, `type`, `description`, `base_url`, `translate_relative_url`, `contribute_relative_url`, `delete_relative_url`, `gloss_get_relative_url`, `gloss_set_relative_url`, `gloss_update_relative_url`, `gloss_delete_relative_url`, `tmx_import_relative_url`, `tmx_status_relative_url`, `extra_parameters`, `google_api_compliant_version`, `penalty`, `active`) VALUES
(0, 'NONE - PLACEHOLDER', 'NONE', 'No MT', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100, 1),
(1, 'MyMemory (All Pairs)', 'TM', 'MyMemory: next generation Translation Memory technology', 'http://api-proxied.mymemory.translated.net', 'get', 'set', 'delete', 'glossary/get', 'glossary/set', 'glossary/update', 'glossary/delete', 'tmx/import', 'tmx/status', NULL, '1', 0, 1),
(2, 'FBK Legal (EN->IT) - Ad.', 'MT', 'FBK (EN->IT) Moses Legal engine', 'http://hlt-services2.fbk.eu:8888', 'translate', 'update', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', 14, 1),
(3, 'LIUM-IT (EN->DE)', 'MT', 'Lium (EN->FR) Moses Information Technology engine', 'http://193.52.29.52:8001', 'translate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', 14, 1),
(4, 'FBK Legal (EN>FR) - Ad.', 'MT', 'FBK (EN->FR) Moses Legal engine', 'http://hlt-services2.fbk.eu:8988', 'translate', 'update', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', 14, 1),
(5, 'LIUM-LEGAL (EN->DE)', 'MT', 'Lium (EN->FR) Moses Legal engine', 'http://193.52.29.52:8002', 'translate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14, 1),
(6, 'FBK TED (IT>EN)', 'MT', 'FBK (IT->EN) Moses Information Technology engine', 'http://hlt-services2.fbk.eu:8788', 'translate', 'update', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2', 14, 1);
/*!40000 ALTER TABLE `engines` ENABLE KEYS */;
UNLOCK TABLES;

-- --------------------------------------------------------

-- 
-- Table structure for table `file_references`
-- 

CREATE TABLE IF NOT EXISTS `file_references` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_project` bigint(20) NOT NULL,
  `id_file` bigint(20) NOT NULL,
  `part_filename` varchar(1024) NOT NULL,
  `serialized_reference_meta` varchar(1024) DEFAULT NULL,
  `serialized_reference_binaries` longblob,
  PRIMARY KEY (`id`),
  KEY `id_file` (`id_file`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 AUTO_INCREMENT=0 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `files`
-- 

CREATE TABLE IF NOT EXISTS `files` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_project` int(11) NOT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `source_language` varchar(45) NOT NULL,
  `mime_type` varchar(45) DEFAULT NULL,
  `xliff_file` longblob,
  `sha1_original_file` varchar(100) DEFAULT NULL,
  `original_file` longblob,
  PRIMARY KEY (`id`),
  KEY `id_project` (`id_project`),
  KEY `sha1` (`sha1_original_file`) USING HASH,
  KEY `filename` (`filename`)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 AUTO_INCREMENT=0 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `files_job`
-- 

CREATE TABLE IF NOT EXISTS `files_job` (
  `id_job` int(11) NOT NULL,
  `id_file` int(11) NOT NULL,
  `assign_date` datetime DEFAULT NULL,
  `t_delivery_date` datetime DEFAULT NULL,
  `t_a_delivery_date` datetime DEFAULT NULL,
  `id_segment_start` int(11) DEFAULT NULL,
  `id_segment_end` int(11) DEFAULT NULL,
  `status_analisys` varchar(50) DEFAULT 'NEW' COMMENT 'NEW\nIN PROGRESS\nDONE',
  PRIMARY KEY (`id_job`,`id_file`),
  KEY `id_file` (`id_file`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `jobs`
-- 

CREATE TABLE IF NOT EXISTS `jobs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `password` varchar(45) NOT NULL,
  `id_project` int(11) NOT NULL,
  `job_first_segment` bigint(20) unsigned NOT NULL,
  `job_last_segment` bigint(20) unsigned NOT NULL,
  `id_translator` varchar(100) NOT NULL DEFAULT 'generic_translator',
  `job_type` varchar(45) DEFAULT NULL,
  `source` varchar(45) DEFAULT NULL,
  `target` varchar(45) DEFAULT NULL,
  `c_delivery_date` datetime DEFAULT NULL,
  `c_a_delivery_date` datetime DEFAULT NULL,
  `id_job_to_revise` int(11) DEFAULT NULL,
  `last_opened_segment` int(11) DEFAULT NULL,
  `id_tms` int(11) DEFAULT '1',
  `id_mt_engine` int(11) DEFAULT '1',
  `create_date` datetime NOT NULL,
  `disabled` tinyint(4) NOT NULL,
  `owner` varchar(100) DEFAULT NULL,
  `status_owner` varchar(100) NOT NULL DEFAULT 'active',
  `status_translator` varchar(100) DEFAULT NULL,
  `status` varchar(15) NOT NULL DEFAULT 'active',
  `completed` bit(1) NOT NULL DEFAULT b'0',
  `new_words` float(10,2) NOT NULL DEFAULT '0.00',
  `draft_words` float(10,2) NOT NULL DEFAULT '0.00',
  `translated_words` float(10,2) NOT NULL DEFAULT '0.00',
  `approved_words` float(10,2) NOT NULL DEFAULT '0.00',
  `rejected_words` float(10,2) NOT NULL DEFAULT '0.00',
  UNIQUE KEY `primary_id_pass` (`id`,`password`),
  KEY `id_job_to_revise` (`id_job_to_revise`),
  KEY `id_project` (`id_project`) USING BTREE,
  KEY `owner` (`owner`),
  KEY `id_translator` (`id_translator`),
  KEY `first_last_segment_idx` (`job_first_segment`,`job_last_segment`),
  KEY `id` (`id`) USING BTREE,
  KEY `password` (`password`)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 AUTO_INCREMENT=0 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `notifications`
-- 

CREATE TABLE IF NOT EXISTS `notifications` (
  `id` int(11) NOT NULL,
  `id_comment` int(11) NOT NULL,
  `id_translator` varchar(100) CHARACTER SET latin1 NOT NULL,
  `status` varchar(45) CHARACTER SET latin1 DEFAULT 'UNREAD',
  PRIMARY KEY (`id`),
  KEY `id_comment` (`id_comment`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `original_files_map`
-- 

CREATE TABLE IF NOT EXISTS `original_files_map` (
  `sha1` varchar(100) NOT NULL,
  `source` varchar(50) NOT NULL,
  `target` varchar(50) NOT NULL,
  `deflated_file` longblob,
  `deflated_xliff` longblob,
  `creation_date` date DEFAULT NULL,
  PRIMARY KEY (`sha1`,`source`,`target`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `projects`
-- 

CREATE TABLE IF NOT EXISTS `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(45) DEFAULT NULL,
  `id_customer` varchar(45) NOT NULL,
  `name` varchar(200) DEFAULT 'project',
  `create_date` datetime NOT NULL,
  `id_engine_tm` int(11) DEFAULT NULL,
  `id_engine_mt` int(11) DEFAULT NULL,
  `status_analysis` varchar(50) DEFAULT 'NOT_READY_TO_ANALYZE',
  `fast_analysis_wc` double(20,2) DEFAULT '0.00',
  `tm_analysis_wc` double(20,2) DEFAULT '0.00',
  `standard_analysis_wc` double(20,2) DEFAULT '0.00',
  `remote_ip_address` varchar(45) DEFAULT 'UNKNOWN',
  `for_debug` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id_customer` (`id_customer`),
  KEY `status_analysis` (`status_analysis`),
  KEY `for_debug` (`for_debug`)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 AUTO_INCREMENT=0 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `segment_translations`
-- 

CREATE TABLE IF NOT EXISTS `segment_translations` (
  `id_segment` bigint(20) NOT NULL,
  `id_job` bigint(20) NOT NULL,
  `status` varchar(45) DEFAULT 'NEW',
  `translation` text,
  `translation_date` datetime DEFAULT NULL,
  `time_to_edit` int(11) DEFAULT '0',
  `match_type` varchar(45) DEFAULT 'NEW',
  `context_hash` blob,
  `eq_word_count` double(20,2) DEFAULT NULL,
  `standard_word_count` double(20,2) DEFAULT NULL,
  `suggestions_array` text,
  `suggestion` text,
  `suggestion_match` int(11) DEFAULT NULL,
  `suggestion_source` varchar(45) DEFAULT NULL,
  `suggestion_position` int(11) DEFAULT NULL,
  `mt_qe` float(19,14) NOT NULL DEFAULT '0.00000000000000',
  `tm_analysis_status` varchar(50) DEFAULT 'UNDONE',
  `locked` tinyint(4) DEFAULT '0',
  `warning` tinyint(4) NOT NULL DEFAULT '0',
  `serialized_errors_list` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id_segment`,`id_job`),
  KEY `status` (`status`),
  KEY `id_job` (`id_job`),
  KEY `translation_date` (`translation_date`) USING BTREE,
  KEY `tm_analysis_status` (`tm_analysis_status`) USING BTREE,
  KEY `locked` (`locked`) USING BTREE,
  KEY `id_segment` (`id_segment`) USING BTREE,
  KEY `warning` (`warning`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `segment_translations_analysis_queue`
-- 

CREATE TABLE IF NOT EXISTS `segment_translations_analysis_queue` (
  `id_segment` int(11) NOT NULL,
  `id_job` int(11) NOT NULL,
  `locked` int(11) DEFAULT '0',
  `pid` int(11) DEFAULT NULL,
  `date_insert` datetime DEFAULT NULL,
  PRIMARY KEY (`id_segment`,`id_job`),
  KEY `locked` (`locked`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `segments`
-- 

CREATE TABLE IF NOT EXISTS `segments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_file` bigint(20) NOT NULL,
  `id_file_part` bigint(20) DEFAULT NULL,
  `internal_id` varchar(100) DEFAULT NULL,
  `xliff_mrk_id` varchar(70) DEFAULT NULL,
  `xliff_ext_prec_tags` text,
  `xliff_mrk_ext_prec_tags` text,
  `segment` text,
  `xliff_mrk_ext_succ_tags` text,
  `xliff_ext_succ_tags` text,
  `raw_word_count` double(20,2) DEFAULT NULL,
  `show_in_cattool` tinyint(4) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `id_file` (`id_file`) USING BTREE,
  KEY `internal_id` (`internal_id`) USING BTREE,
  KEY `mrk_id` (`xliff_mrk_id`) USING BTREE,
  KEY `show_in_cat` (`show_in_cattool`) USING BTREE,
  KEY `raw_word_count` (`raw_word_count`) USING BTREE,
  KEY `id_file_part_idx` (`id_file_part`),
  FULLTEXT KEY `segment` (`segment`)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 AUTO_INCREMENT=0 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `segments_comments`
-- 

CREATE TABLE IF NOT EXISTS `segments_comments` (
  `id` int(11) NOT NULL,
  `id_segment` int(11) NOT NULL,
  `comment` text,
  `create_date` datetime DEFAULT NULL,
  `created_by` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_segment` (`id_segment`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `translators`
-- 

CREATE TABLE IF NOT EXISTS `translators` (
  `username` varchar(100) NOT NULL,
  `email` varchar(45) DEFAULT NULL,
  `password` varchar(45) DEFAULT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `mymemory_api_key` varchar(50) NOT NULL,
  PRIMARY KEY (`username`),
  KEY `email` (`email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- 
-- Table structure for table `users`
-- 

CREATE TABLE IF NOT EXISTS `users` (
  `email` varchar(50) NOT NULL,
  `salt` varchar(50) NOT NULL,
  `pass` varchar(50) NOT NULL,
  `create_date` datetime NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `api_key` varchar(100) NOT NULL,
  PRIMARY KEY (`email`),
  KEY `api_key` (`api_key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

