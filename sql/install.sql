-- phpMyAdmin SQL Dump
-- Server version: 10.4.32-MariaDB

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
SET NAMES utf8mb4;

USE ugeiopolis;
SET FOREIGN_KEY_CHECKS = 0;

-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 03, 2026 at 04:24 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: ugeiopolis
--

-- --------------------------------------------------------

--
-- Table structure for table allergia
--

CREATE TABLE allergia (
  AMKA_astheni char(11) NOT NULL,
  ousia_id int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table asthenis
--

CREATE TABLE asthenis (
  AMKA char(11) NOT NULL,
  onoma varchar(50) NOT NULL,
  eponymo varchar(50) NOT NULL,
  patronymo varchar(50) NOT NULL,
  ilikia tinyint(3) UNSIGNED NOT NULL,
  fylo enum('ANDRAS','GYNAIKA','ALLO') NOT NULL,
  varos decimal(5,2) DEFAULT NULL CHECK (varos > 0),
  ypsos decimal(4,2) DEFAULT NULL CHECK (ypsos > 0),
  dieuthinsi varchar(200) DEFAULT NULL,
  tilefono varchar(15) DEFAULT NULL,
  email varchar(100) DEFAULT NULL,
  epaggelma varchar(100) DEFAULT NULL,
  ypikootita varchar(50) DEFAULT NULL,
  asfalistikos_foreas varchar(100) NOT NULL
) ;

--
--


-- --------------------------------------------------------

--
-- Table structure for table axiologisi_iatrou
--

CREATE TABLE axiologisi_iatrou (
  axiologisi_id int(11) NOT NULL,
  nosileia_id int(11) NOT NULL,
  AMKA_iatrou char(11) NOT NULL,
  poiotita_iatrикis_frontidas tinyint(4) NOT NULL CHECK (poiotita_iatrикis_frontidas between 1 and 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table axiologisi_nosilias
--

CREATE TABLE axiologisi_nosilias (
  axiologisi_id int(11) NOT NULL,
  nosileia_id int(11) NOT NULL,
  poiotita_nosileytikis_frontidas tinyint(4) NOT NULL CHECK (poiotita_nosileytikis_frontidas between 1 and 5),
  kathariotita tinyint(4) NOT NULL CHECK (kathariotita between 1 and 5),
  fagito tinyint(4) NOT NULL CHECK (fagito between 1 and 5),
  synoliki_empeiria tinyint(4) NOT NULL CHECK (synoliki_empeiria between 1 and 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table dialogi
--

CREATE TABLE dialogi (
  dialogi_id int(11) NOT NULL,
  AMKA_astheni char(11) NOT NULL,
  AMKA_nosileutis char(11) NOT NULL,
  nosileia_id int(11) DEFAULT NULL,
  wra_afiksis datetime NOT NULL,
  wra_exiperetisis datetime DEFAULT NULL,
  symptomata text DEFAULT NULL,
  epipedo_epeigotos tinyint(4) NOT NULL CHECK (epipedo_epeigotos between 1 and 5),
  apotelesma enum('APOXWRISE','PAREPEMPTHIKE') NOT NULL
) ;

--
--


-- --------------------------------------------------------

--
-- Table structure for table dioikitiko_proswpiko
--

CREATE TABLE dioikitiko_proswpiko (
  AMKA char(11) NOT NULL,
  AMKA_proswpikou char(11) NOT NULL,
  tmima_id int(11) NOT NULL,
  rolos varchar(50) NOT NULL,
  grafeio varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table drastiki_ousia
--

CREATE TABLE drastiki_ousia (
  ousia_id int(11) NOT NULL,
  onoma varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table eikona
--

CREATE TABLE eikona (
  eikona_id int(11) NOT NULL,
  entity_type varchar(50) NOT NULL,
  entity_id int(11) NOT NULL,
  url varchar(500) NOT NULL,
  perigrafh text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table ergastiiriaki_exetasi
--

CREATE TABLE ergastiiriaki_exetasi (
  exetasi_id int(11) NOT NULL,
  nosileia_id int(11) NOT NULL,
  AMKA_iatrou char(11) NOT NULL,
  kwdikos varchar(20) NOT NULL,
  typos varchar(100) NOT NULL,
  imerominia date NOT NULL,
  apotelesma_keimeno text DEFAULT NULL,
  apotelesma_arithmitiko decimal(10,4) DEFAULT NULL,
  monada_metrisis varchar(30) DEFAULT NULL,
  kostos decimal(8,2) NOT NULL CHECK (kostos >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table farmako
--

CREATE TABLE farmako (
  farmako_id int(11) NOT NULL,
  onoma varchar(200) NOT NULL,
  kwdikos_EMA varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table farmako_ousia
--

CREATE TABLE farmako_ousia (
  farmako_id int(11) NOT NULL,
  ousia_id int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table iatriki_praxi
--

CREATE TABLE iatriki_praxi (
  praxi_id int(11) NOT NULL,
  nosileia_id int(11) NOT NULL,
  xwros_id int(11) NOT NULL,
  AMKA_kyriou_xeirourgou char(11) NOT NULL,
  kwdikos varchar(20) NOT NULL,
  onoma varchar(200) NOT NULL,
  katigoria enum('XEIROURGIKI','DIAGNOASTIKI','THERAPEUTIKI') NOT NULL,
  diarkeia_lepta int(11) NOT NULL CHECK (diarkeia_lepta > 0),
  kostos decimal(10,2) NOT NULL CHECK (kostos >= 0),
  im_wra_enarxis datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table iatros
--

CREATE TABLE iatros (
  AMKA char(11) NOT NULL,
  AMKA_proswpikou char(11) NOT NULL,
  AMKA_epopti char(11) DEFAULT NULL,
  ar_adeias_iatrikou_sullogou varchar(20) NOT NULL,
  eidikotita varchar(50) NOT NULL,
  vathmida enum('EIDIKEUOMENOS','EPIMELETIS_B','EPIMELETIS_A','DIEUTHETIS') NOT NULL
) ;

--
--


--
-- Triggers iatros
--
DELIMITER $$
CREATE TRIGGER `trg_no_circular_supervision` BEFORE INSERT ON `iatros` FOR EACH ROW BEGIN
    DECLARE epoptis_id CHAR(11);
    DECLARE depth INT DEFAULT 0;
    SET epoptis_id = NEW.AMKA_epopti;
    WHILE epoptis_id IS NOT NULL AND depth < 100 DO
        IF epoptis_id = NEW.AMKA THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Κυκλική αλυσίδα εποπτείας δεν επιτρέπεται';
        END IF;
        SELECT AMKA_epopti INTO epoptis_id FROM Iatros WHERE AMKA = epoptis_id;
        SET depth = depth + 1;
    END WHILE;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table iatros_tmima
--

CREATE TABLE iatros_tmima (
  AMKA_iatrou char(11) NOT NULL,
  tmima_id int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table icd10
--

CREATE TABLE icd10 (
  kwdikos varchar(10) NOT NULL,
  perigrafh varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table ken
--

CREATE TABLE ken (
  kwdikos_KEN varchar(20) NOT NULL,
  perigrafh text DEFAULT NULL,
  vasiko_kostos decimal(10,2) NOT NULL CHECK (vasiko_kostos >= 0),
  MDN decimal(5,2) NOT NULL CHECK (MDN > 0),
  imerisia_xrewsi_ypervasis decimal(8,2) NOT NULL CHECK (imerisia_xrewsi_ypervasis >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table klini
--

CREATE TABLE klini (
  klini_id int(11) NOT NULL,
  tmima_id int(11) NOT NULL,
  monadikos_arithmos varchar(20) NOT NULL,
  typos enum('MEΘ','MONOKLINΟ','POLYKLINΟ','ALLOS') NOT NULL,
  katastasi enum('DIATHESIMI','KATEILIMMENI','YPO_SINTHIRIXI') NOT NULL DEFAULT 'DIATHESIMI'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table nosileia
--

CREATE TABLE nosileia (
  nosileia_id int(11) NOT NULL,
  AMKA_astheni char(11) NOT NULL,
  klini_id int(11) NOT NULL,
  tmima_id int(11) NOT NULL,
  kwdikos_KEN varchar(20) NOT NULL,
  im_eisagogis date NOT NULL,
  im_exodou date DEFAULT NULL,
  diagnosi_eisagogis_kwdikos varchar(10) NOT NULL,
  diagnosi_eisagogis_perigrafh text DEFAULT NULL,
  diagnosi_exodou_kwdikos varchar(10) DEFAULT NULL,
  diagnosi_exodou_perigrafh text DEFAULT NULL,
  synoliko_kostos decimal(10,2) DEFAULT NULL CHECK (synoliko_kostos >= 0)
) ;

--
--


-- --------------------------------------------------------

--
-- Table structure for table nosileutis
--

CREATE TABLE nosileutis (
  AMKA char(11) NOT NULL,
  AMKA_proswpikou char(11) NOT NULL,
  tmima_id int(11) NOT NULL,
  vathmida enum('VOITHOS_NOSILEUTIS','NOSILEUTIS','PROISTAMENOS') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table oikeios
--

CREATE TABLE oikeios (
  oikeios_id int(11) NOT NULL,
  AMKA_astheni char(11) NOT NULL,
  onoma varchar(100) NOT NULL,
  tilefono varchar(15) NOT NULL,
  schesi varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table proswpiko
--

CREATE TABLE proswpiko (
  AMKA char(11) NOT NULL,
  onoma varchar(50) NOT NULL,
  eponymo varchar(50) NOT NULL,
  ilikia tinyint(3) UNSIGNED NOT NULL CHECK (ilikia >= 18 and ilikia <= 80),
  email varchar(100) NOT NULL,
  tilefono varchar(15) NOT NULL,
  im_proslipsis date NOT NULL,
  typos enum('IATROS','NOSILEUTIS','DIOIKITIKO') NOT NULL
) ;

--
--


-- --------------------------------------------------------

--
-- Table structure for table symmetoxi_vardias
--

CREATE TABLE symmetoxi_vardias (
  vardia_id int(11) NOT NULL,
  AMKA_proswpikou char(11) NOT NULL,
  rolos_vardias varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table syntagografisi
--

CREATE TABLE syntagografisi (
  syntagografisi_id int(11) NOT NULL,
  AMKA_iatrou char(11) NOT NULL,
  AMKA_astheni char(11) NOT NULL,
  farmako_id int(11) NOT NULL,
  nosileia_id int(11) NOT NULL,
  dosologia varchar(200) NOT NULL,
  syxnotita varchar(100) NOT NULL,
  im_enarxis date NOT NULL,
  im_lixis date DEFAULT NULL
) ;

--
--


-- --------------------------------------------------------

--
-- Table structure for table tmima
--

CREATE TABLE tmima (
  tmima_id int(11) NOT NULL,
  AMKA_dieutinti char(11) DEFAULT NULL,
  onoma varchar(100) NOT NULL,
  perigrafh text DEFAULT NULL,
  ar_klinwn smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  oros_ktiriο varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table vardia
--

CREATE TABLE vardia (
  vardia_id int(11) NOT NULL,
  tmima_id int(11) NOT NULL,
  imerominia date NOT NULL,
  typos enum('PRWINI','APOGEUMATINI','NYXTERINI') NOT NULL,
  wra_enarxis time NOT NULL,
  wra_lixis time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table voithos_praxis
--

CREATE TABLE voithos_praxis (
  praxi_id int(11) NOT NULL,
  AMKA_voithou char(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table xwros_epemvasis
--

CREATE TABLE xwros_epemvasis (
  xwros_id int(11) NOT NULL,
  onoma varchar(100) NOT NULL,
  typos enum('XEIROURGEIΟ','AΙTHOUSA_EPEMVASIS') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


--
-- Indexes for dumped tables
--

--
-- Indexes for table allergia
--
ALTER TABLE allergia
  ADD PRIMARY KEY (AMKA_astheni,ousia_id),
  ADD KEY fk_all_ousia (ousia_id);

--
-- Indexes for table asthenis
--
ALTER TABLE asthenis
  ADD PRIMARY KEY (AMKA);

--
-- Indexes for table axiologisi_iatrou
--
ALTER TABLE axiologisi_iatrou
  ADD PRIMARY KEY (axiologisi_id),
  ADD UNIQUE KEY uq_axiolog_iat (nosileia_id,AMKA_iatrou),
  ADD KEY fk_axi_iatros (AMKA_iatrou);

--
-- Indexes for table axiologisi_nosilias
--
ALTER TABLE axiologisi_nosilias
  ADD PRIMARY KEY (axiologisi_id),
  ADD UNIQUE KEY nosileia_id (nosileia_id);

--
-- Indexes for table dialogi
--
ALTER TABLE dialogi
  ADD PRIMARY KEY (dialogi_id),
  ADD KEY fk_dial_asthenis (AMKA_astheni),
  ADD KEY fk_dial_nosileutis (AMKA_nosileutis),
  ADD KEY fk_dial_nosileia (nosileia_id);

--
-- Indexes for table dioikitiko_proswpiko
--
ALTER TABLE dioikitiko_proswpiko
  ADD PRIMARY KEY (AMKA),
  ADD KEY fk_dioikitiko_proswpiko (AMKA_proswpikou),
  ADD KEY fk_dioikitiko_tmima (tmima_id);

--
-- Indexes for table drastiki_ousia
--
ALTER TABLE drastiki_ousia
  ADD PRIMARY KEY (ousia_id),
  ADD UNIQUE KEY onoma (onoma);

--
-- Indexes for table eikona
--
ALTER TABLE eikona
  ADD PRIMARY KEY (eikona_id);

--
-- Indexes for table ergastiiriaki_exetasi
--
ALTER TABLE ergastiiriaki_exetasi
  ADD PRIMARY KEY (exetasi_id),
  ADD KEY fk_ex_nosileia (nosileia_id),
  ADD KEY fk_ex_iatros (AMKA_iatrou);

--
-- Indexes for table farmako
--
ALTER TABLE farmako
  ADD PRIMARY KEY (farmako_id),
  ADD UNIQUE KEY kwdikos_EMA (kwdikos_EMA);

--
-- Indexes for table farmako_ousia
--
ALTER TABLE farmako_ousia
  ADD PRIMARY KEY (farmako_id,ousia_id),
  ADD KEY fk_fo_ousia (ousia_id);

--
-- Indexes for table iatriki_praxi
--
ALTER TABLE iatriki_praxi
  ADD PRIMARY KEY (praxi_id),
  ADD KEY fk_praxi_nosileia (nosileia_id),
  ADD KEY fk_praxi_xwros (xwros_id),
  ADD KEY fk_praxi_xeirourgos (AMKA_kyriou_xeirourgou);

--
-- Indexes for table iatros
--
ALTER TABLE iatros
  ADD PRIMARY KEY (AMKA),
  ADD UNIQUE KEY ar_adeias_iatrikou_sullogou (ar_adeias_iatrikou_sullogou),
  ADD KEY fk_iatros_proswpiko (AMKA_proswpikou),
  ADD KEY fk_iatros_epoptis (AMKA_epopti);

--
-- Indexes for table iatros_tmima
--
ALTER TABLE iatros_tmima
  ADD PRIMARY KEY (AMKA_iatrou,tmima_id),
  ADD KEY fk_it_tmima (tmima_id);

--
-- Indexes for table icd10
--
ALTER TABLE icd10
  ADD PRIMARY KEY (kwdikos);

--
-- Indexes for table ken
--
ALTER TABLE ken
  ADD PRIMARY KEY (kwdikos_KEN);

--
-- Indexes for table klini
--
ALTER TABLE klini
  ADD PRIMARY KEY (klini_id),
  ADD UNIQUE KEY uq_klini_tmima (tmima_id,monadikos_arithmos);

--
-- Indexes for table nosileia
--
ALTER TABLE nosileia
  ADD PRIMARY KEY (nosileia_id),
  ADD KEY fk_nos_asthenis (AMKA_astheni),
  ADD KEY fk_nos_klini (klini_id),
  ADD KEY fk_nos_tmima (tmima_id),
  ADD KEY fk_nos_ken (kwdikos_KEN);

--
-- Indexes for table nosileutis
--
ALTER TABLE nosileutis
  ADD PRIMARY KEY (AMKA),
  ADD KEY fk_nosileutis_proswpiko (AMKA_proswpikou),
  ADD KEY fk_nosileutis_tmima (tmima_id);

--
-- Indexes for table oikeios
--
ALTER TABLE oikeios
  ADD PRIMARY KEY (oikeios_id),
  ADD KEY fk_oikeios_asthenis (AMKA_astheni);

--
-- Indexes for table proswpiko
--
ALTER TABLE proswpiko
  ADD PRIMARY KEY (AMKA),
  ADD UNIQUE KEY email (email);

--
-- Indexes for table symmetoxi_vardias
--
ALTER TABLE symmetoxi_vardias
  ADD PRIMARY KEY (vardia_id,AMKA_proswpikou),
  ADD KEY fk_sv_proswpiko (AMKA_proswpikou);

--
-- Indexes for table syntagografisi
--
ALTER TABLE syntagografisi
  ADD PRIMARY KEY (syntagografisi_id),
  ADD UNIQUE KEY uq_syntag (AMKA_iatrou,AMKA_astheni,farmako_id,im_enarxis),
  ADD KEY fk_syn_asthenis (AMKA_astheni),
  ADD KEY fk_syn_farmako (farmako_id),
  ADD KEY fk_syn_nosileia (nosileia_id);

--
-- Indexes for table tmima
--
ALTER TABLE tmima
  ADD PRIMARY KEY (tmima_id),
  ADD UNIQUE KEY onoma (onoma),
  ADD KEY fk_tmima_dieutintis (AMKA_dieutinti);

--
-- Indexes for table vardia
--
ALTER TABLE vardia
  ADD PRIMARY KEY (vardia_id),
  ADD UNIQUE KEY uq_vardia (tmima_id,imerominia,typos);

--
-- Indexes for table voithos_praxis
--
ALTER TABLE voithos_praxis
  ADD PRIMARY KEY (praxi_id,AMKA_voithou),
  ADD KEY fk_vp_proswpiko (AMKA_voithou);

--
-- Indexes for table xwros_epemvasis
--
ALTER TABLE xwros_epemvasis
  ADD PRIMARY KEY (xwros_id),
  ADD UNIQUE KEY onoma (onoma);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table axiologisi_iatrou
--
ALTER TABLE axiologisi_iatrou
  MODIFY axiologisi_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table axiologisi_nosilias
--
ALTER TABLE axiologisi_nosilias
  MODIFY axiologisi_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table dialogi
--
ALTER TABLE dialogi
  MODIFY dialogi_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table drastiki_ousia
--
ALTER TABLE drastiki_ousia
  MODIFY ousia_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table eikona
--
ALTER TABLE eikona
  MODIFY eikona_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table ergastiiriaki_exetasi
--
ALTER TABLE ergastiiriaki_exetasi
  MODIFY exetasi_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table farmako
--
ALTER TABLE farmako
  MODIFY farmako_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table iatriki_praxi
--
ALTER TABLE iatriki_praxi
  MODIFY praxi_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table klini
--
ALTER TABLE klini
  MODIFY klini_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table nosileia
--
ALTER TABLE nosileia
  MODIFY nosileia_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table oikeios
--
ALTER TABLE oikeios
  MODIFY oikeios_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table syntagografisi
--
ALTER TABLE syntagografisi
  MODIFY syntagografisi_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table tmima
--
ALTER TABLE tmima
  MODIFY tmima_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table vardia
--
ALTER TABLE vardia
  MODIFY vardia_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table xwros_epemvasis
--
ALTER TABLE xwros_epemvasis
  MODIFY xwros_id int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table allergia
--
ALTER TABLE allergia
  ADD CONSTRAINT fk_all_asthenis FOREIGN KEY (AMKA_astheni) REFERENCES asthenis (AMKA) ON DELETE CASCADE,
  ADD CONSTRAINT fk_all_ousia FOREIGN KEY (ousia_id) REFERENCES drastiki_ousia (ousia_id) ON DELETE CASCADE;

--
-- Constraints for table axiologisi_iatrou
--
ALTER TABLE axiologisi_iatrou
  ADD CONSTRAINT fk_axi_iatros FOREIGN KEY (AMKA_iatrou) REFERENCES iatros (AMKA),
  ADD CONSTRAINT fk_axi_nosileia FOREIGN KEY (nosileia_id) REFERENCES nosileia (nosileia_id) ON DELETE CASCADE;

--
-- Constraints for table axiologisi_nosilias
--
ALTER TABLE axiologisi_nosilias
  ADD CONSTRAINT fk_axn_nosileia FOREIGN KEY (nosileia_id) REFERENCES nosileia (nosileia_id) ON DELETE CASCADE;

--
-- Constraints for table dialogi
--
ALTER TABLE dialogi
  ADD CONSTRAINT fk_dial_asthenis FOREIGN KEY (AMKA_astheni) REFERENCES asthenis (AMKA),
  ADD CONSTRAINT fk_dial_nosileia FOREIGN KEY (nosileia_id) REFERENCES nosileia (nosileia_id) ON DELETE SET NULL,
  ADD CONSTRAINT fk_dial_nosileutis FOREIGN KEY (AMKA_nosileutis) REFERENCES nosileutis (AMKA);

--
-- Constraints for table dioikitiko_proswpiko
--
ALTER TABLE dioikitiko_proswpiko
  ADD CONSTRAINT fk_dioikitiko_proswpiko FOREIGN KEY (AMKA_proswpikou) REFERENCES proswpiko (AMKA) ON DELETE CASCADE,
  ADD CONSTRAINT fk_dioikitiko_tmima FOREIGN KEY (tmima_id) REFERENCES tmima (tmima_id);

--
-- Constraints for table ergastiiriaki_exetasi
--
ALTER TABLE ergastiiriaki_exetasi
  ADD CONSTRAINT fk_ex_iatros FOREIGN KEY (AMKA_iatrou) REFERENCES iatros (AMKA),
  ADD CONSTRAINT fk_ex_nosileia FOREIGN KEY (nosileia_id) REFERENCES nosileia (nosileia_id);

--
-- Constraints for table farmako_ousia
--
ALTER TABLE farmako_ousia
  ADD CONSTRAINT fk_fo_farmako FOREIGN KEY (farmako_id) REFERENCES farmako (farmako_id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_fo_ousia FOREIGN KEY (ousia_id) REFERENCES drastiki_ousia (ousia_id) ON DELETE CASCADE;

--
-- Constraints for table iatriki_praxi
--
ALTER TABLE iatriki_praxi
  ADD CONSTRAINT fk_praxi_nosileia FOREIGN KEY (nosileia_id) REFERENCES nosileia (nosileia_id),
  ADD CONSTRAINT fk_praxi_xeirourgos FOREIGN KEY (AMKA_kyriou_xeirourgou) REFERENCES iatros (AMKA),
  ADD CONSTRAINT fk_praxi_xwros FOREIGN KEY (xwros_id) REFERENCES xwros_epemvasis (xwros_id);

--
-- Constraints for table iatros
--
ALTER TABLE iatros
  ADD CONSTRAINT fk_iatros_epoptis FOREIGN KEY (AMKA_epopti) REFERENCES iatros (AMKA) ON DELETE SET NULL,
  ADD CONSTRAINT fk_iatros_proswpiko FOREIGN KEY (AMKA_proswpikou) REFERENCES proswpiko (AMKA) ON DELETE CASCADE;

--
-- Constraints for table iatros_tmima
--
ALTER TABLE iatros_tmima
  ADD CONSTRAINT fk_it_iatros FOREIGN KEY (AMKA_iatrou) REFERENCES iatros (AMKA) ON DELETE CASCADE,
  ADD CONSTRAINT fk_it_tmima FOREIGN KEY (tmima_id) REFERENCES tmima (tmima_id) ON DELETE CASCADE;

--
-- Constraints for table klini
--
ALTER TABLE klini
  ADD CONSTRAINT fk_klini_tmima FOREIGN KEY (tmima_id) REFERENCES tmima (tmima_id) ON DELETE CASCADE;

--
-- Constraints for table nosileia
--
ALTER TABLE nosileia
  ADD CONSTRAINT fk_nos_asthenis FOREIGN KEY (AMKA_astheni) REFERENCES asthenis (AMKA),
  ADD CONSTRAINT fk_nos_ken FOREIGN KEY (kwdikos_KEN) REFERENCES ken (kwdikos_KEN),
  ADD CONSTRAINT fk_nos_klini FOREIGN KEY (klini_id) REFERENCES klini (klini_id),
  ADD CONSTRAINT fk_nos_tmima FOREIGN KEY (tmima_id) REFERENCES tmima (tmima_id);

--
-- Constraints for table nosileutis
--
ALTER TABLE nosileutis
  ADD CONSTRAINT fk_nosileutis_proswpiko FOREIGN KEY (AMKA_proswpikou) REFERENCES proswpiko (AMKA) ON DELETE CASCADE,
  ADD CONSTRAINT fk_nosileutis_tmima FOREIGN KEY (tmima_id) REFERENCES tmima (tmima_id);

--
-- Constraints for table oikeios
--
ALTER TABLE oikeios
  ADD CONSTRAINT fk_oikeios_asthenis FOREIGN KEY (AMKA_astheni) REFERENCES asthenis (AMKA) ON DELETE CASCADE;

--
-- Constraints for table symmetoxi_vardias
--
ALTER TABLE symmetoxi_vardias
  ADD CONSTRAINT fk_sv_proswpiko FOREIGN KEY (AMKA_proswpikou) REFERENCES proswpiko (AMKA) ON DELETE CASCADE,
  ADD CONSTRAINT fk_sv_vardia FOREIGN KEY (vardia_id) REFERENCES vardia (vardia_id) ON DELETE CASCADE;

--
-- Constraints for table syntagografisi
--
ALTER TABLE syntagografisi
  ADD CONSTRAINT fk_syn_asthenis FOREIGN KEY (AMKA_astheni) REFERENCES asthenis (AMKA),
  ADD CONSTRAINT fk_syn_farmako FOREIGN KEY (farmako_id) REFERENCES farmako (farmako_id),
  ADD CONSTRAINT fk_syn_iatros FOREIGN KEY (AMKA_iatrou) REFERENCES iatros (AMKA),
  ADD CONSTRAINT fk_syn_nosileia FOREIGN KEY (nosileia_id) REFERENCES nosileia (nosileia_id);

--
-- Constraints for table tmima
--
ALTER TABLE tmima
  ADD CONSTRAINT fk_tmima_dieutintis FOREIGN KEY (AMKA_dieutinti) REFERENCES iatros (AMKA) ON DELETE SET NULL;

--
-- Constraints for table vardia
--
ALTER TABLE vardia
  ADD CONSTRAINT fk_vardia_tmima FOREIGN KEY (tmima_id) REFERENCES tmima (tmima_id);

--
-- Constraints for table voithos_praxis
--
ALTER TABLE voithos_praxis
  ADD CONSTRAINT fk_vp_praxi FOREIGN KEY (praxi_id) REFERENCES iatriki_praxi (praxi_id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_vp_proswpiko FOREIGN KEY (AMKA_voithou) REFERENCES proswpiko (AMKA);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;
