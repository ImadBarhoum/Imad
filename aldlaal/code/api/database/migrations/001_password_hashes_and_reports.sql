-- Run this ONCE on the live database BEFORE uploading the new API code.
-- 1) Password hashes are 60+ characters, the old columns only hold 31.
ALTER TABLE `admin` MODIFY `pwd` varchar(255) NOT NULL DEFAULT '';
ALTER TABLE `users` MODIFY `pwd` varchar(255) NOT NULL DEFAULT '';

-- 2) The reports table is used by the API but was missing from the database dump.
CREATE TABLE IF NOT EXISTS `reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `agency_id` int(11) NOT NULL DEFAULT '0',
  `property_id` int(11) NOT NULL DEFAULT '0',
  `type` varchar(63) NOT NULL DEFAULT '',
  `note` text NOT NULL,
  `status` varchar(31) NOT NULL DEFAULT 'pending',
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3) Only if your properties table has no `video` column yet (the API uses it):
-- ALTER TABLE `properties` ADD `video` varchar(63) NOT NULL DEFAULT '' AFTER `plan_img`;
