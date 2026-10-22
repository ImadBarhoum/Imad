-- phpMyAdmin SQL Dump
-- version 4.9.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Mar 24, 2026 at 05:24 PM
-- Server version: 5.7.43-log
-- PHP Version: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Schema only (user data removed). Demo data kept for: citys, pages, settings
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `user` varchar(31) NOT NULL DEFAULT '',
  `pwd` varchar(255) NOT NULL DEFAULT '',
  `token` varchar(11) NOT NULL DEFAULT '',
  `valid` int(1) NOT NULL DEFAULT '1',
  `update_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- --------------------------------------------------------

--
-- Table structure for table `agencies`
--

CREATE TABLE `agencies` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(63) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `email` varchar(63) NOT NULL DEFAULT '',
  `phone` varchar(31) NOT NULL DEFAULT '',
  `address` varchar(127) NOT NULL DEFAULT '',
  `city` varchar(63) NOT NULL DEFAULT '',
  `state` varchar(63) NOT NULL DEFAULT '',
  `img` varchar(31) NOT NULL DEFAULT '',
  `cover` varchar(31) NOT NULL DEFAULT '',
  `reviews` int(11) NOT NULL DEFAULT '0',
  `rate` decimal(4,1) NOT NULL DEFAULT '5.0',
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `update_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- --------------------------------------------------------

--
-- Table structure for table `citys`
--

CREATE TABLE `citys` (
  `id` int(11) NOT NULL,
  `country` varchar(4) NOT NULL DEFAULT 'SY',
  `state_ar` varchar(63) NOT NULL DEFAULT '',
  `state_en` varchar(63) NOT NULL DEFAULT '',
  `city_ar` varchar(63) NOT NULL DEFAULT '',
  `city_en` varchar(63) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `citys`
--

INSERT INTO `citys` (`id`, `country`, `state_ar`, `state_en`, `city_ar`, `city_en`) VALUES
(1, 'SY', 'ريف دمشق', 'Rif Dimashq', 'دوما', 'Douma'),
(2, 'SY', 'ريف دمشق', 'Rif Dimashq', 'الزبداني', 'Al-Zabadani'),
(3, 'SY', 'ريف دمشق', 'Rif Dimashq', 'القطيفة', 'Al-Qutayfah'),
(4, 'SY', 'ريف دمشق', 'Rif Dimashq', 'النبك', 'Al-Nabk'),
(5, 'SY', 'ريف دمشق', 'Rif Dimashq', 'يبرود', 'Yabroud'),
(6, 'SY', 'ريف دمشق', 'Rif Dimashq', 'قارة', 'Qarah'),
(7, 'SY', 'ريف دمشق', 'Rif Dimashq', 'التل', 'Al-Tall'),
(8, 'SY', 'ريف دمشق', 'Rif Dimashq', 'قدسيا', 'Qudsaya'),
(9, 'SY', 'ريف دمشق', 'Rif Dimashq', 'داريا', 'Darayya'),
(10, 'SY', 'ريف دمشق', 'Rif Dimashq', 'معضمية الشام', 'Muadamiyat al-Sham'),
(11, 'SY', 'ريف دمشق', 'Rif Dimashq', 'صحنايا', 'Sahnaya'),
(12, 'SY', 'ريف دمشق', 'Rif Dimashq', 'جديدة عرطوز', 'Jdeidat Artouz'),
(13, 'SY', 'ريف دمشق', 'Rif Dimashq', 'جرمانا', 'Jaramana'),
(14, 'SY', 'ريف دمشق', 'Rif Dimashq', 'الكسوة', 'Al-Kiswah'),
(15, 'SY', 'ريف دمشق', 'Rif Dimashq', 'السبينة', 'Al-Sabinah'),
(16, 'SY', 'طرطوس', 'Tartous', 'طرطوس', 'Tartous'),
(17, 'SY', 'طرطوس', 'Tartous', 'بانياس', 'Baniyas'),
(18, 'SY', 'طرطوس', 'Tartous', 'الشيخ بدر', 'Al-Shaykh Badr'),
(19, 'SY', 'طرطوس', 'Tartous', 'صافيتا', 'Safita'),
(20, 'SY', 'طرطوس', 'Tartous', 'الدريكيش', 'Al-Duraykish'),
(21, 'SY', 'طرطوس', 'Tartous', 'القدموس', 'Al-Qadmus'),
(22, 'SY', 'إدلب', 'Idlib', 'إدلب المدينة', 'Idlib City'),
(23, 'SY', 'إدلب', 'Idlib', 'معرة النعمان', 'Maarrat al-Nu\'man'),
(24, 'SY', 'إدلب', 'Idlib', 'جسر الشغور', 'Jisr al-Shughur'),
(25, 'SY', 'إدلب', 'Idlib', 'أريحا', 'Ariha'),
(26, 'SY', 'إدلب', 'Idlib', 'خان شيخون', 'Khan Shaykhun'),
(27, 'SY', 'إدلب', 'Idlib', 'سراقب', 'Saraqib'),
(28, 'SY', 'إدلب', 'Idlib', 'حارم', 'Harem'),
(29, 'SY', 'درعا', 'Daraa', 'درعا', 'Daraa'),
(30, 'SY', 'درعا', 'Daraa', 'نوى', 'Nawa'),
(31, 'SY', 'درعا', 'Daraa', 'ازرع', 'Izra'),
(32, 'SY', 'درعا', 'Daraa', 'الصنمين', 'Al-Sanamayn'),
(33, 'SY', 'درعا', 'Daraa', 'بصرى الشام', 'Busra al-Sham'),
(34, 'SY', 'درعا', 'Daraa', 'جاسم', 'Jassim'),
(35, 'SY', 'القنيطرة', 'Quneitra', 'القنيطرة', 'Quneitra'),
(36, 'SY', 'القنيطرة', 'Quneitra', 'خان أرنبة', 'Khan Arnabah'),
(37, 'SY', 'القنيطرة', 'Quneitra', 'فيق (في الجوالن المحتل)', 'Fayiq (occupied Golan)'),
(38, 'SY', 'القنيطرة', 'Quneitra', 'الحميدية', 'Al-Hamidiyah'),
(39, 'SY', 'السويداء', 'As-Suwayda', 'السويداء', 'As-Suwayda'),
(40, 'SY', 'السويداء', 'As-Suwayda', 'صلخد', 'Salkhad'),
(41, 'SY', 'السويداء', 'As-Suwayda', 'شهبا', 'Shahba'),
(42, 'SY', 'دير الزور', 'Deir ez-Zor', 'دير الزور', 'Deir ez-Zor'),
(43, 'SY', 'دير الزور', 'Deir ez-Zor', 'البوكمال', 'Al-Bukamal'),
(44, 'SY', 'دير الزور', 'Deir ez-Zor', 'الميادين', 'Al-Mayadin'),
(45, 'SY', 'دير الزور', 'Deir ez-Zor', 'الكسرة', 'Al-Kasrah'),
(46, 'SY', 'دير الزور', 'Deir ez-Zor', 'التبني', 'Al-Tibni'),
(47, 'SY', 'الحسكة', 'Al-Hasakah', 'الحسكة', 'Al-Hasakah'),
(48, 'SY', 'الحسكة', 'Al-Hasakah', 'القامشلي', 'Al-Qamishli'),
(49, 'SY', 'الحسكة', 'Al-Hasakah', 'رأس العين', 'Ras al-Ayn'),
(50, 'SY', 'الحسكة', 'Al-Hasakah', 'المالكية (ديريك)', 'Al-Malikiyah (Dayrik)'),
(51, 'SY', 'الحسكة', 'Al-Hasakah', 'تل تمر', 'Tell Tamer'),
(52, 'SY', 'الحسكة', 'Al-Hasakah', 'تل براك', 'Tell Brak'),
(53, 'SY', 'الحسكة', 'Al-Hasakah', 'تل حميس', 'Tell Hamis'),
(54, 'SY', 'الحسكة', 'Al-Hasakah', 'معبدة', 'Ma\'badah'),
(55, 'SY', 'الحسكة', 'Al-Hasakah', 'الشدادي', 'Al-Shaddadah'),
(56, 'SY', 'الحسكة', 'Al-Hasakah', 'مركدة', 'Markada'),
(57, 'SY', 'الرقة', 'Ar-Raqqah', 'الرقة', 'Ar-Raqqah'),
(58, 'SY', 'الرقة', 'Ar-Raqqah', 'الطبقة', 'Al-Thawrah'),
(59, 'SY', 'الرقة', 'Ar-Raqqah', 'تل أبيض', 'Tell Abyad'),
(60, 'SY', 'الرقة', 'Ar-Raqqah', 'الكرامة', 'Al-Karamah'),
(61, 'SY', 'الرقة', 'Ar-Raqqah', 'السبخة', 'Al-Sabkhah'),
(62, 'SY', 'الرقة', 'Ar-Raqqah', 'معدان', 'Maadan'),
(63, 'SY', 'دمشق', 'Damascus', 'دمشق', 'Damascus'),
(64, 'SY', 'دمشق', 'Damascus', 'المزة', 'Al-Mezzeh'),
(65, 'SY', 'دمشق', 'Damascus', 'أبو رمانة', 'Abu Rummaneh'),
(66, 'SY', 'دمشق', 'Damascus', 'المالكي', 'Al-Maliki'),
(67, 'SY', 'دمشق', 'Damascus', 'الصالحية', 'Al-Salihiyah'),
(68, 'SY', 'دمشق', 'Damascus', 'مشروع دمر', 'Mashrou Dummar'),
(69, 'SY', 'دمشق', 'Damascus', 'كفرسوسة', 'Kafr Sousa'),
(70, 'SY', 'دمشق', 'Damascus', 'الميدان', 'Al-Midan'),
(71, 'SY', 'دمشق', 'Damascus', 'القنوات', 'Al-Qanawat'),
(72, 'SY', 'دمشق', 'Damascus', 'باب توما', 'Bab Touma'),
(73, 'SY', 'دمشق', 'Damascus', 'ركن الدين', 'Rukn al-Din'),
(74, 'SY', 'دمشق', 'Damascus', 'برزة', 'Barzeh'),
(75, 'SY', 'دمشق', 'Damascus', 'مساكن برزة', 'Masakin Barzeh'),
(76, 'SY', 'دمشق', 'Damascus', 'الزاهرة', 'Al-Zahira'),
(77, 'SY', 'دمشق', 'Damascus', 'الزبلطاني', 'Al-Zablatani'),
(78, 'SY', 'دمشق', 'Damascus', 'باب شرقي', 'Bab Sharqi'),
(79, 'SY', 'دمشق', 'Damascus', 'الشاغور', 'Al-Shaghour'),
(80, 'SY', 'دمشق', 'Damascus', 'التضامن', 'Al-Tadamon'),
(81, 'SY', 'دمشق', 'Damascus', 'القدم', 'Al-Qadam'),
(82, 'SY', 'دمشق', 'Damascus', 'الحجر الأسود', 'Al-Hajar al-Aswad'),
(83, 'SY', 'حلب', 'Aleppo', 'حلب المدينة', 'Aleppo City'),
(84, 'SY', 'حلب', 'Aleppo', 'منطقة اعزاز', 'Azaz District'),
(85, 'SY', 'حلب', 'Aleppo', 'منطقة الباب', 'Al-Bab District'),
(86, 'SY', 'حلب', 'Aleppo', 'منطقة منبج', 'Manbij District'),
(87, 'SY', 'حلب', 'Aleppo', 'منطقة جرابلس', 'Jarabulus District'),
(88, 'SY', 'حلب', 'Aleppo', 'منطقة عفرين', 'Afrin District'),
(89, 'SY', 'حلب', 'Aleppo', 'منطقة عين العرب (كوباني)', 'Ayn al-Arab District (Kobani)'),
(90, 'SY', 'حلب', 'Aleppo', 'منطقة السفيرة', 'Al-Safira District'),
(91, 'SY', 'حلب', 'Aleppo', 'منطقة الأتارب', 'Atarib District'),
(92, 'SY', 'حلب', 'Aleppo', 'منطقة دير حافر', 'Dayr Hafir District'),
(93, 'SY', 'حلب', 'Aleppo', 'منطقة جبل سمعان', 'Mount Simeon District'),
(94, 'SY', 'حلب', 'Aleppo', 'منطقة نبل', 'Nubl District'),
(95, 'SY', 'حمص', 'Homs', 'حمص', 'Homs'),
(96, 'SY', 'حمص', 'Homs', 'منطقة الرستن', 'Al-Rastan District'),
(97, 'SY', 'حمص', 'Homs', 'منطقة تلبيسة', 'Talbiseh District'),
(98, 'SY', 'حمص', 'Homs', 'منطقة تدمر', 'Palmyra District'),
(99, 'SY', 'حمص', 'Homs', 'منطقة القصير', 'Al-Qusayr District'),
(100, 'SY', 'حمص', 'Homs', 'منطقة القصير الجديدة', 'Al-Qusayr Al-Jadidah District'),
(101, 'SY', 'حمص', 'Homs', 'منطقة المخرم', 'Al-Mukharram District'),
(102, 'SY', 'حمص', 'Homs', 'منطقة تلكلخ', 'Talkalakh District'),
(103, 'SY', 'حمص', 'Homs', 'منطقة السخنة', 'Al-Sukhna District'),
(104, 'SY', 'حمص', 'Homs', 'منطقة مهين', 'Mahin District'),
(105, 'SY', 'حمص', 'Homs', 'منطقة القريتين', 'Al-Qaryatayn District'),
(106, 'SY', 'اللاذقية', 'Latakia', 'اللاذقية', 'Latakia'),
(107, 'SY', 'اللاذقية', 'Latakia', 'منطقة جبلة', 'Jableh District'),
(108, 'SY', 'اللاذقية', 'Latakia', 'منطقة القرداحة', 'Al-Qardaha District'),
(109, 'SY', 'اللاذقية', 'Latakia', 'منطقة الحفة', 'Al-Haffah District'),
(110, 'SY', 'اللاذقية', 'Latakia', 'منطقة رأس البسيط / كسب', 'Ras al-Bassit / Kasab District'),
(111, 'SY', 'حماة', 'Hama', 'حماة', 'Hama'),
(112, 'SY', 'حماة', 'Hama', 'محردة', 'Mhardeh'),
(113, 'SY', 'حماة', 'Hama', 'السلمية', 'Salamiyah'),
(114, 'SY', 'حماة', 'Hama', 'مصياف', 'Masyaf'),
(115, 'SY', 'حماة', 'Hama', 'صوران', 'Soran'),
(116, 'SY', 'حماة', 'Hama', 'الحمرا', 'Al-Hamra'),
(117, 'SY', 'حماة', 'Hama', 'الغاب', 'Al-Ghab'),
(118, 'SY', 'حماة', 'Hama', 'كفر زيتا', 'Kafr Zita'),
(119, 'SY', 'حماة', 'Hama', 'الطيبة', 'Al-Taybah');

-- --------------------------------------------------------

--
-- Table structure for table `favorites`
--

CREATE TABLE `favorites` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `property_id` int(11) NOT NULL DEFAULT '0',
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- --------------------------------------------------------

--
-- Table structure for table `logs_agencies`
--

CREATE TABLE `logs_agencies` (
  `id` int(11) NOT NULL,
  `agency_id` int(11) NOT NULL DEFAULT '0',
  `content` text NOT NULL,
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL DEFAULT '0',
  `receiver_id` int(11) NOT NULL DEFAULT '0',
  `ads_id` int(11) NOT NULL DEFAULT '0',
  `owner_id` int(11) NOT NULL DEFAULT '0',
  `msg` text NOT NULL,
  `img` varchar(31) NOT NULL DEFAULT '',
  `is_read` int(1) NOT NULL DEFAULT '0',
  `update_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `title_ar` varchar(127) NOT NULL DEFAULT '',
  `title_en` varchar(127) NOT NULL DEFAULT '',
  `body_ar` varchar(255) NOT NULL,
  `body_en` varchar(255) NOT NULL,
  `route` varchar(31) NOT NULL DEFAULT '',
  `route_id` int(11) NOT NULL DEFAULT '0',
  `is_read` int(1) NOT NULL DEFAULT '0',
  `is_fcm_send` int(1) NOT NULL DEFAULT '0',
  `update_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `otp_temp`
--

CREATE TABLE `otp_temp` (
  `id` int(11) NOT NULL,
  `email` varchar(63) NOT NULL DEFAULT '',
  `otp` int(11) NOT NULL DEFAULT '0',
  `attempts` int(4) NOT NULL DEFAULT '0',
  `update_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- --------------------------------------------------------

--
-- Table structure for table `pages`
--

CREATE TABLE `pages` (
  `id` int(11) NOT NULL,
  `slug` varchar(31) NOT NULL DEFAULT '',
  `title` varchar(127) NOT NULL DEFAULT '',
  `content` text,
  `update_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `pages`
--

INSERT INTO `pages` (`id`, `slug`, `title`, `content`, `update_date`, `create_date`) VALUES
(1, 'privacy', 'Privacy Policy', '<p><strong>Effective date:</strong> 2025-09-09</p>\n    <p>\n      This Privacy Policy explains how <strong>Aldlaal</strong> (“<strong>we</strong>”, “<strong>us</strong>”, “<strong>our</strong>”) collects, uses, and shares information about you when you use our website <strong>aldlaal.com</strong> and our services for selling and renting real estate (collectively, the “<strong>Service</strong>”).\n    </p>\n    <p>\n      By using the Service, you agree to the collection and use of information in accordance with this Policy. If you do not agree, please do not use the Service.\n    </p>\n\n    <h2>1) Who We Are</h2>\n    <p>\n      Controller/Operator: <strong>aldlaal</strong><br>\n      Address: <strong>Syria</strong><br>\n      Email: <strong>info@aldlaal.com</strong>\n    </p>\n\n    <h2>2) Information We Collect</h2>\n    <h3>a) Information You Provide</h3>\n    <ul>\n      <li><strong>Account data:</strong> name, email, phone number, password.</li>\n      <li><strong>Profile & verification:</strong> profile photo, identity documents if you choose to verify, business/license information for agencies.</li>\n      <li><strong>Listings & content:</strong> property details, prices, addresses or approximate locations, descriptions, photos/videos, floor plans, documents, and messages you send via the Service.</li>\n      <li><strong>Payments & billing:</strong> billing address and transaction records when applicable. Card data is handled by our payment processor if you use payment features.</li>\n      <li><strong>Support & communications:</strong> inquiries, feedback, and survey responses you provide.</li>\n    </ul>\n\n    <h3>b) Information Collected Automatically</h3>\n    <ul>\n      <li><strong>Usage data:</strong> interactions with pages, features, and listings; referring pages; timestamps.</li>\n      <li><strong>Device & log data:</strong> IP address, browser type, operating system, device identifiers, and error logs.</li>\n      <li><strong>Cookies & similar technologies:</strong> small files to keep you signed in, remember preferences, and measure performance. See “Cookies” below.</li>\n      <li><strong>Location data (if enabled):</strong> approximate or precise location to show nearby listings or improve search relevance.</li>\n    </ul>\n\n    <h3>c) Information from Third Parties</h3>\n    <ul>\n      <li><strong>Sign-in providers:</strong> basic profile details if you sign in with a third-party account.</li>\n      <li><strong>Payment processors:</strong> payment confirmation and limited billing details.</li>\n      <li><strong>Partners & public sources:</strong> agency or agent details, property records, and market data when used to enrich listings.</li>\n    </ul>\n\n    <h2>3) How We Use Information</h2>\n    <ul>\n      <li>Provide, operate, and improve the Service and its features.</li>\n      <li>Create and manage your account; authenticate and secure access.</li>\n      <li>Publish, promote, and manage property listings; enable search and recommendations.</li>\n      <li>Facilitate communications between buyers, renters, sellers, landlords, and agents.</li>\n      <li>Process payments, subscriptions, promotions, and invoices (when applicable).</li>\n      <li>Customize content, show relevant listings, and measure performance.</li>\n      <li>Detect, prevent, and respond to fraud, abuse, and security incidents.</li>\n      <li>Comply with legal obligations and enforce our Terms of Use.</li>\n      <li>Communicate with you about updates, security alerts, and service notices (you can opt out of non-essential marketing communications).</li>\n    </ul>\n\n    <h2>4) Legal Bases for Processing (where applicable)</h2>\n    <ul>\n      <li><strong>Contract:</strong> to provide the Service you request.</li>\n      <li><strong>Legitimate interests:</strong> to secure, improve, and market the Service, balanced with your rights.</li>\n      <li><strong>Consent:</strong> for certain features (e.g., precise location, marketing emails, certain cookies). You can withdraw consent at any time.</li>\n      <li><strong>Legal obligation:</strong> to comply with laws, tax, accounting, and regulatory requirements.</li>\n    </ul>\n\n    <h2>5) How We Share Information</h2>\n    <ul>\n      <li><strong>With other users:</strong> information in your listings and profile becomes visible to other users and visitors of the Service.</li>\n      <li><strong>Service providers:</strong> hosting, analytics, customer support, marketing, payment processing, verification, and security vendors bound by confidentiality.</li>\n      <li><strong>Business partners:</strong> agencies, developers, and listing networks when you choose to syndicate or collaborate.</li>\n      <li><strong>Legal & safety:</strong> to courts, law enforcement, or regulators if required by law or to protect rights, property, or safety.</li>\n      <li><strong>Business transfers:</strong> as part of a merger, acquisition, or asset sale, subject to this Policy.</li>\n    </ul>\n\n    <h2>6) Cookies and Similar Technologies</h2>\n    <p>\n      We use cookies and similar technologies to enable core functionality (e.g., login), remember preferences, and analyze traffic and performance. You can control cookies in your browser settings; disabling some cookies may affect functionality.\n    </p>\n\n    <h2>7) Data Retention</h2>\n    <p>\n      We keep personal data only as long as necessary for the purposes described here, including providing the Service, complying with legal obligations, resolving disputes, and enforcing agreements. Retention periods vary by data type. We may retain anonymized information for analytics and performance measurement.\n    </p>\n\n    <h2>8) Your Rights</h2>\n    <p>\n      Depending on your location, you may have rights to access, correct, delete, restrict, or object to processing of your personal data, as well as the right to data portability and to withdraw consent. To exercise these rights, contact us at <strong>info@aldlaal.com</strong>. We may need to verify your identity before responding.\n    </p>\n\n    <h2>9) Communications Preferences</h2>\n    <p>\n      You can manage marketing emails by using the unsubscribe link in those emails. We may still send you transactional or service-related messages about your account or listings.\n    </p>\n\n    <h2>10) User-Generated Content and Messaging</h2>\n    <p>\n      Listings, photos, descriptions, reviews, and messages you submit may be processed to prevent fraud and abuse and to improve the Service. Do not share confidential or sensitive information in listings or messages.\n    </p>\n\n    <h2>11) Children’s Privacy</h2>\n    <p>\n      The Service is not directed to children. We do not knowingly collect personal data from anyone below the age required by applicable law. If you believe a child has provided us personal data, contact us and we will take steps to delete it.\n    </p>\n\n    <h2>12) Security</h2>\n    <p>\n      We use reasonable technical and organizational measures to protect personal data. However, no system is completely secure. Please use strong passwords and keep your account details confidential.\n    </p>\n\n    <h2>13) International Data Transfers</h2>\n    <p>\n      If we transfer personal data across borders, we will take appropriate measures to ensure an adequate level of protection in accordance with applicable law.\n    </p>\n\n    <h2>14) Third-Party Links</h2>\n    <p>\n      The Service may link to third-party websites or services. We are not responsible for their privacy practices. Please review their policies before sharing personal information.\n    </p>\n\n    <h2>15) Changes to This Policy</h2>\n    <p>\n      We may update this Policy from time to time. The “Effective date” indicates when it was last updated. Continued use of the Service after changes means you accept the updated Policy.\n    </p>\n\n    <h2>16) How to Contact Us</h2>\n    <p>\n      If you have questions or requests about this Policy or your personal data, contact:<br>\n      <strong>aldlaal</strong><br>\n      <strong>Syria</strong><br>\n      <strong>info@aldlaal.com</strong>\n    </p>\n\n    <hr>\n\n    <h2>Jurisdiction-Specific Notices (Optional)</h2>\n    <h3>A) European Economic Area/UK</h3>\n    <ul>\n      <li>Where applicable, you have rights under GDPR/UK GDPR as described above.</li>\n      <li>Lawful bases for processing include contract, legitimate interests, consent, and legal obligation.</li>\n      <li>You may lodge a complaint with your local supervisory authority if you believe your rights have been violated.</li>\n    </ul>\n\n    <h3>B) California (CCPA/CPRA)</h3>\n    <ul>\n      <li>We may collect and disclose categories of personal information as described above.</li>\n      <li>California residents can request access, deletion, and correction, and can opt out of certain sharing for cross-context behavioral advertising.</li>\n      <li>We do not knowingly sell personal information of minors.</li>\n    </ul>\n\n    <h3>C) Syria</h3>\n    <p>\n      We strive to comply with applicable Syrian data protection and privacy requirements. Contact us at <strong>info@aldlaal.com</strong> to access, correct, or delete your personal data or to raise questions about local compliance.\n    </p>\n\n    <h2>Summary of Key Points</h2>\n    <ul>\n      <li>We collect account, listing, usage, and communications data to run Aldlaal.</li>\n      <li>We share data with other users (for listings), service providers, partners you choose, and when required by law.</li>\n      <li>You can request access, correction, deletion, or object to certain uses by contacting <strong>info@aldlaal.com</strong>.</li>\n      <li>Manage cookies via your browser and marketing preferences via email links.</li>\n    </ul>', '2025-09-09 03:47:02', '2024-10-04 13:49:19'),
(2, 'terms', 'Terms and Conditions', '<p><strong>Effective date:</strong> 2025-09-09</p>\n    <p>\n      These Terms and Conditions (“Terms”) govern your access to and use of <strong>aldlaal.com</strong> and related services for selling and renting real estate (the “Service”) operated by <strong>aldlaal</strong> (“we”, “us”, “our”).\n    </p>\n    <p>\n      By accessing or using the Service, you agree to be bound by these Terms. If you do not agree, you must not use the Service.\n    </p>\n\n    <h2>1) Eligibility</h2>\n    <p>\n      You must be at least 18 years old or the age of majority in your jurisdiction to use the Service. By using the Service, you confirm you meet this requirement.\n    </p>\n\n    <h2>2) Accounts</h2>\n    <ul>\n      <li>You are responsible for maintaining the confidentiality of your login credentials.</li>\n      <li>You are responsible for all activities under your account.</li>\n      <li>You must provide accurate, complete, and current information.</li>\n      <li>We reserve the right to suspend or terminate accounts that violate these Terms.</li>\n    </ul>\n\n    <h2>3) Listings and Content</h2>\n    <ul>\n      <li>You may post property listings, photos, videos, and descriptions that comply with applicable law.</li>\n      <li>You must not post misleading, false, or fraudulent information.</li>\n      <li>You must have the right to use and publish any content you provide.</li>\n      <li>By submitting content, you grant us a worldwide, non-exclusive, royalty-free license to display, distribute, and promote it through the Service.</li>\n    </ul>\n\n    <h2>4) Prohibited Activities</h2>\n    <p>You agree not to:</p>\n    <ul>\n      <li>Use the Service for unlawful purposes or to promote illegal activity.</li>\n      <li>Post spam, unsolicited advertisements, or harmful code.</li>\n      <li>Interfere with or disrupt the Service, servers, or networks.</li>\n      <li>Copy, modify, or distribute content without authorization.</li>\n      <li>Infringe the rights of others, including intellectual property or privacy rights.</li>\n    </ul>\n\n    <h2>5) Payments and Subscriptions</h2>\n    <ul>\n      <li>Some features may require payment or subscription.</li>\n      <li>All fees are non-refundable unless required by law.</li>\n      <li>Payment processing is handled by third-party providers subject to their terms.</li>\n    </ul>\n\n    <h2>6) Intellectual Property</h2>\n    <p>\n      The Service, including its name, logo, design, software, and content (excluding user content), are the property of <strong>aldlaal</strong> and protected by applicable intellectual property laws. You may not copy, distribute, or create derivative works without prior written consent.\n    </p>\n\n    <h2>7) Termination</h2>\n    <p>\n      We may suspend or terminate your access to the Service at any time, with or without notice, if you breach these Terms or engage in harmful conduct. You may stop using the Service at any time by closing your account.\n    </p>\n\n    <h2>8) Disclaimers</h2>\n    <ul>\n      <li>The Service is provided “as is” and “as available.”</li>\n      <li>We do not guarantee uninterrupted or error-free operation.</li>\n      <li>We do not endorse, guarantee, or verify the accuracy of property listings or user content.</li>\n      <li>Your interactions with other users are solely your responsibility.</li>\n    </ul>\n\n    <h2>9) Limitation of Liability</h2>\n    <p>\n      To the fullest extent permitted by law, <strong>aldlaal</strong> shall not be liable for any indirect, incidental, consequential, or punitive damages, including loss of profits, data, or goodwill, arising from your use of the Service.\n    </p>\n\n    <h2>10) Indemnification</h2>\n    <p>\n      You agree to indemnify and hold harmless <strong>aldlaal</strong>, its officers, employees, and partners from any claims, damages, losses, or expenses arising out of your use of the Service, your content, or your violation of these Terms.\n    </p>\n\n    <h2>11) Third-Party Services</h2>\n    <p>\n      The Service may include links or integrations with third-party services. We are not responsible for their content, terms, or practices.\n    </p>\n\n    <h2>12) Changes to Terms</h2>\n    <p>\n      We may update these Terms from time to time. The “Effective date” at the top indicates when the Terms were last revised. Continued use of the Service means you accept the updated Terms.\n    </p>\n\n    <h2>13) Governing Law</h2>\n    <p>\n      These Terms are governed by the laws of Syria, without regard to conflict of law principles. Any disputes shall be resolved in the courts located in Syria, unless otherwise required by applicable law.\n    </p>\n\n    <h2>14) Contact Us</h2>\n    <p>\n      If you have questions about these Terms, please contact us:<br>\n      <strong>aldlaal</strong><br>\n      <strong>Syria</strong><br>\n      <strong>info@aldlaal.com</strong>\n    </p>\n\n    <hr>\n\n    <h2>Summary of Key Points</h2>\n    <ul>\n      <li>You must be at least 18 years old to use Aldlaal.</li>\n      <li>Post only accurate property information you have the right to share.</li>\n      <li>Some features may require paid subscriptions, which are non-refundable.</li>\n      <li>We are not responsible for user content or interactions.</li>\n      <li>Disputes are governed by Syrian law.</li>\n    </ul>\n  </main>', '2025-09-09 04:17:21', '2024-10-04 13:56:58'),
(3, 'about', 'About Us', '<div dir=\"rtl\">\r\n<h2><strong>الدلال سوريا</strong></h2>\r\n<p>الدلال سوریا ھو التطبیق العقاري الأول في سوریا الذي یقّدم تجربة موثوقة وشفافة للبحث عن العقارات.</p>\r\n<p>نحن نعمل حصرًیا مع مكاتب عقاریة معتمدة وموثوقة لضمان أن كل إعلان تراه ھو إعلان حقیقي وآمن.</p>\r\n<p>رؤیتنا أن یكون الدلال سوریا المنصة الرقمیة الرائدة التي تربط السوریین داخل الوطن وخارجھ بعقاراتھم، من خلال تجربة سھلة، حدیثة، وموثوقة.</p>\r\n<p><strong>قیمنا الأساسیة</strong><strong>:</strong></p>\r\n<ul>\r\n<li>واضح: شفافیة في المعلومات والأسعار.</li>\r\n<li>موثوق: تعامل مع مكاتب معتمدة.</li>\r\n<li>لكل سوریا: تغطیة تدریجیة شاملة لكل المحافظات السوریة.</li>\r\n</ul>\r\n</div>', '2025-10-25 15:02:45', '2025-02-09 16:49:18');

-- --------------------------------------------------------

--
-- Table structure for table `properties`
--

CREATE TABLE `properties` (
  `id` int(11) NOT NULL,
  `agency_id` int(11) NOT NULL DEFAULT '0',
  `title` varchar(127) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `purpose` enum('sale','rent') NOT NULL,
  `type` enum('apartment','house','building','villa','land','office','shop','warehouse','farm','restaurant','clinic','block') NOT NULL,
  `is_furnished` enum('furnished','unfurnished','semi_furnished') NOT NULL DEFAULT 'unfurnished',
  `is_new` enum('yes','no') NOT NULL DEFAULT 'yes',
  `price` decimal(15,2) NOT NULL DEFAULT '0.00',
  `curr` varchar(11) NOT NULL DEFAULT 'SYP',
  `bedrooms` varchar(11) NOT NULL DEFAULT '',
  `bathrooms` varchar(11) NOT NULL DEFAULT '',
  `garages` varchar(11) NOT NULL DEFAULT '',
  `area_m2` int(11) NOT NULL DEFAULT '0',
  `address` varchar(127) NOT NULL DEFAULT '',
  `city` varchar(63) NOT NULL DEFAULT '',
  `state` varchar(63) NOT NULL DEFAULT '',
  `location` varchar(255) NOT NULL DEFAULT '[]',
  `img` varchar(31) NOT NULL DEFAULT '',
  `imgs` text NOT NULL,
  `plan_img` varchar(31) NOT NULL DEFAULT '',
  `video` varchar(63) NOT NULL DEFAULT '',
  `is_owner` varchar(63) NOT NULL DEFAULT '',
  `property_nature` varchar(63) NOT NULL DEFAULT '',
  `floor` varchar(63) NOT NULL DEFAULT '',
  `area_unit` varchar(11) NOT NULL DEFAULT '',
  `building_age` varchar(63) NOT NULL DEFAULT '',
  `is_mortgaged` varchar(63) NOT NULL DEFAULT '',
  `property_status` varchar(63) NOT NULL DEFAULT '',
  `designated_for` varchar(63) NOT NULL DEFAULT '',
  `facade` varchar(63) NOT NULL DEFAULT '',
  `rent_duration` varchar(63) NOT NULL DEFAULT '',
  `payment_method` varchar(63) NOT NULL DEFAULT '',
  `main_features` text NOT NULL,
  `internal_features` text NOT NULL,
  `appliances` text NOT NULL,
  `extra_features` text NOT NULL,
  `nearby_places` text NOT NULL,
  `reviews` int(11) NOT NULL DEFAULT '0',
  `rate` decimal(4,1) NOT NULL DEFAULT '5.0',
  `estate_status` enum('available','sold','rented') NOT NULL DEFAULT 'available',
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `admin_review` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `update_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `agency_id` int(11) NOT NULL DEFAULT '0',
  `ads_id` int(11) NOT NULL DEFAULT '0',
  `rate` decimal(10,2) NOT NULL DEFAULT '0.00',
  `update_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- --------------------------------------------------------

--
-- Table structure for table `search_favorites`
--

CREATE TABLE `search_favorites` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `title` text NOT NULL,
  `count` int(11) NOT NULL DEFAULT '0',
  `search_query` text NOT NULL,
  `search_json` text NOT NULL,
  `notification_email` int(1) NOT NULL DEFAULT '0',
  `notification_app` int(1) NOT NULL DEFAULT '0',
  `rnd` int(4) NOT NULL DEFAULT '0',
  `update_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- --------------------------------------------------------

--
-- Table structure for table `search_recent`
--

CREATE TABLE `search_recent` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `uuid` varchar(31) NOT NULL DEFAULT '',
  `ads_id` int(11) NOT NULL DEFAULT '0',
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` int(11) NOT NULL,
  `site_name` varchar(63) NOT NULL DEFAULT '',
  `site_description` varchar(255) NOT NULL DEFAULT '',
  `site_email` varchar(63) NOT NULL DEFAULT '',
  `site_phone` varchar(31) NOT NULL DEFAULT '',
  `sociel_fb` varchar(127) NOT NULL DEFAULT '',
  `sociel_insta` varchar(127) NOT NULL DEFAULT '',
  `sociel_whats` varchar(127) NOT NULL DEFAULT '',
  `sociel_youtube` varchar(127) NOT NULL DEFAULT '',
  `sociel_tiktok` varchar(127) NOT NULL DEFAULT '',
  `sociel_x` varchar(127) NOT NULL DEFAULT '',
  `usd_value` decimal(15,2) NOT NULL DEFAULT '0.00',
  `auto_publish` enum('auto','manual','only_verify') NOT NULL DEFAULT 'manual',
  `mini_version_apk` decimal(6,2) NOT NULL DEFAULT '1.00',
  `mini_version_ios` decimal(6,2) NOT NULL DEFAULT '1.00',
  `maintenance_mode` int(1) NOT NULL DEFAULT '0',
  `update_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `site_name`, `site_description`, `site_email`, `site_phone`, `sociel_fb`, `sociel_insta`, `sociel_whats`, `sociel_youtube`, `sociel_tiktok`, `sociel_x`, `usd_value`, `auto_publish`, `mini_version_apk`, `mini_version_ios`, `maintenance_mode`, `update_date`, `create_date`) VALUES
(1, 'Aldlaal', '', 'info@aldlaal.com', '', 'https://www.facebook.com/share/1PH94z1YjP/?mibextid=wwXIfr', 'https://www.instagram.com/aldlaal_syria_app', 'message/D2OSOO7PWDTHO1', '', 'https://www.tiktok.com/@al.dlaal.syria', '', '13005.00', 'manual', '1.22', '1.09', 0, '2026-03-15 05:57:12', '2024-09-09 06:07:40');

-- --------------------------------------------------------

--
-- Table structure for table `sliders`
--

CREATE TABLE `sliders` (
  `id` int(11) NOT NULL,
  `slug` varchar(15) NOT NULL DEFAULT '',
  `img` varchar(31) NOT NULL DEFAULT '',
  `route` varchar(15) NOT NULL DEFAULT '',
  `route_id` int(11) NOT NULL DEFAULT '0',
  `valid` int(11) NOT NULL DEFAULT '1',
  `update_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(63) NOT NULL DEFAULT '',
  `img` varchar(31) NOT NULL DEFAULT '',
  `email` varchar(63) NOT NULL DEFAULT '',
  `pwd` varchar(255) NOT NULL DEFAULT '',
  `phone` varchar(31) NOT NULL DEFAULT '',
  `city` varchar(31) NOT NULL DEFAULT '',
  `state` varchar(31) NOT NULL DEFAULT '',
  `notification_status` enum('active','inactive') NOT NULL DEFAULT 'inactive',
  `fcm` varchar(255) NOT NULL DEFAULT '',
  `lang` enum('ar','en') NOT NULL DEFAULT 'ar',
  `verify` enum('yes','no') NOT NULL DEFAULT 'no',
  `role` enum('agency','user') NOT NULL DEFAULT 'user',
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `login_token` varchar(11) NOT NULL DEFAULT '',
  `update_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- --------------------------------------------------------

--
-- Table structure for table `user_docs`
--

CREATE TABLE `user_docs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `doc_type` varchar(15) NOT NULL DEFAULT '',
  `img` varchar(31) NOT NULL,
  `active` int(1) NOT NULL DEFAULT '2',
  `update_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user` (`user`);

--
-- Indexes for table `agencies`
--
ALTER TABLE `agencies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `owner_id` (`owner_id`),
  ADD KEY `name` (`name`);

--
-- Indexes for table `citys`
--
ALTER TABLE `citys`
  ADD PRIMARY KEY (`id`),
  ADD KEY `country` (`country`),
  ADD KEY `state_ar` (`state_ar`),
  ADD KEY `state_en` (`state_en`);

--
-- Indexes for table `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `logs_agencies`
--
ALTER TABLE `logs_agencies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `agency_id` (`agency_id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `receiver_id` (`receiver_id`),
  ADD KEY `property_id` (`ads_id`),
  ADD KEY `is_read` (`is_read`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `is_read` (`is_read`);

--
-- Indexes for table `otp_temp`
--
ALTER TABLE `otp_temp`
  ADD PRIMARY KEY (`id`),
  ADD KEY `email` (`email`);

--
-- Indexes for table `pages`
--
ALTER TABLE `pages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `properties`
--
ALTER TABLE `properties`
  ADD PRIMARY KEY (`id`),
  ADD KEY `agency_id` (`agency_id`),
  ADD KEY `title` (`title`),
  ADD KEY `purpose` (`purpose`),
  ADD KEY `type` (`type`),
  ADD KEY `price` (`price`),
  ADD KEY `bedrooms` (`bedrooms`),
  ADD KEY `bathrooms` (`bathrooms`),
  ADD KEY `garages` (`garages`),
  ADD KEY `city` (`city`),
  ADD KEY `state` (`state`),
  ADD KEY `estate_status` (`estate_status`),
  ADD KEY `status` (`status`),
  ADD KEY `admin_review` (`admin_review`),
  ADD KEY `area_m2` (`area_m2`),
  ADD KEY `is_new` (`is_new`),
  ADD KEY `is_furnished` (`is_furnished`),
  ADD KEY `create_at` (`create_at`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `agency_id` (`agency_id`),
  ADD KEY `ads_id` (`ads_id`);

--
-- Indexes for table `search_favorites`
--
ALTER TABLE `search_favorites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `notification_email` (`notification_email`),
  ADD KEY `notification_app` (`notification_app`),
  ADD KEY `update_at` (`update_at`);

--
-- Indexes for table `search_recent`
--
ALTER TABLE `search_recent`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sliders`
--
ALTER TABLE `sliders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `slug` (`slug`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `email` (`email`),
  ADD KEY `phone` (`phone`),
  ADD KEY `status` (`status`),
  ADD KEY `role` (`role`),
  ADD KEY `notification_status` (`notification_status`),
  ADD KEY `verify` (`verify`);

--
-- Indexes for table `user_docs`
--
ALTER TABLE `user_docs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `agencies`
--
ALTER TABLE `agencies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `citys`
--
ALTER TABLE `citys`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `favorites`
--
ALTER TABLE `favorites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `logs_agencies`
--
ALTER TABLE `logs_agencies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `otp_temp`
--
ALTER TABLE `otp_temp`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pages`
--
ALTER TABLE `pages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `properties`
--
ALTER TABLE `properties`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `search_favorites`
--
ALTER TABLE `search_favorites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `search_recent`
--
ALTER TABLE `search_recent`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sliders`
--
ALTER TABLE `sliders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_docs`
--
ALTER TABLE `user_docs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
