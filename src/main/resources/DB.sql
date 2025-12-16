CREATE DATABASE  IF NOT EXISTS `tecnodeposit` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `tecnodeposit`;
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: tecnodeposit
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `articolo`
--

DROP TABLE IF EXISTS `articolo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `articolo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `matricola` varchar(120) DEFAULT NULL,
  `nome` varchar(150) DEFAULT NULL,
  `marca` varchar(120) DEFAULT NULL,
  `compatibilita` varchar(150) DEFAULT NULL,
  `ddt` int DEFAULT NULL,
  `ddtSpedizione` int DEFAULT NULL,
  `tecnico` varchar(120) DEFAULT NULL,
  `pv` varchar(120) DEFAULT NULL,
  `provenienza` varchar(150) DEFAULT NULL,
  `fornitore` varchar(150) DEFAULT NULL,
  `data_ricezione` date DEFAULT NULL,
  `data_spedizione` date DEFAULT NULL,
  `data_garanzia` date DEFAULT NULL,
  `note` text,
  `stato` enum('Riparato','In magazzino','Installato','Destinato','Assegnato','In attesa','Guasto','Non riparato','Non riparabile') DEFAULT NULL,
  `immagine` varchar(255) DEFAULT NULL,
  `richiesta_garanzia` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `articolo`
--

LOCK TABLES `articolo` WRITE;
/*!40000 ALTER TABLE `articolo` DISABLE KEYS */;
INSERT INTO `articolo` VALUES (1,'01491040419','Articolo Riparato','Marca 1','Articolo 7',166,155,'Mario Rossi','Punto Vendita 145','Magazzino 1','Centro Revisione 1','2025-12-24','2025-12-12','2025-12-24','note articolo','Riparato','img/Icon.png',0),(2,'012234235','Articolo In Magazzino','Marca 1','Articolo 7',NULL,NULL,'Mario Rossi','Punto Vendita 145','Magazzino 1','Centro Revisione 1',NULL,NULL,NULL,' ','In magazzino','img/Icon.png',0),(3,'','Articolo Installato','Marca 1','',NULL,NULL,'','','','',NULL,NULL,NULL,' ','Installato','img/Icon.png',0);
/*!40000 ALTER TABLE `articolo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fornitore`
--

DROP TABLE IF EXISTS `fornitore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fornitore` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(40) DEFAULT NULL,
  `mail` varchar(40) DEFAULT NULL,
  `partita_iva` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `indirizzo` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fornitore`
--

LOCK TABLES `fornitore` WRITE;
/*!40000 ALTER TABLE `fornitore` DISABLE KEYS */;
INSERT INTO `fornitore` VALUES (9,'Centro Revisione 2','info@centrorevisione2.it','','','Via Fittizia, 13'),(10,'Centro Revisione 1','info@centrorevisione1.it','','0000 111222','Via Fittizia, 14');
/*!40000 ALTER TABLE `fornitore` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `message` varchar(255) NOT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `scadenza` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=216 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,6,'Questa è una notifica di test.',1,'2025-07-21 10:22:25',NULL),(2,6,'Questa è un altrta notifica di test.',1,'2025-07-21 10:38:06',NULL),(3,6,'Questa è un altrta notifica di test.',1,'2025-07-21 10:45:19',NULL),(4,6,'Questa è un altrta notifica di test.',1,'2025-07-21 10:50:30',NULL),(5,6,'Questa è un altrta notifica di test.',1,'2025-07-21 10:50:31',NULL),(6,6,'Questa è un altrta notifica di test.',1,'2025-07-21 10:50:31',NULL),(7,6,'Questa è un altrta notifica di test.',1,'2025-07-21 10:50:31',NULL),(8,6,'Questa è un altrta notifica di test.',1,'2025-07-21 10:50:32',NULL),(9,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:10:22',NULL),(10,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:10:22',NULL),(11,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:10:22',NULL),(12,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:10:22',NULL),(13,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:10:22',NULL),(14,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:10:23',NULL),(15,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:10:23',NULL),(16,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:10:23',NULL),(17,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:10:23',NULL),(18,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:10:23',NULL),(19,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:10:23',NULL),(20,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:10:23',NULL),(21,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:13:01',NULL),(22,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:13:01',NULL),(23,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:13:01',NULL),(24,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:13:02',NULL),(25,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:13:02',NULL),(26,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:13:02',NULL),(27,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:13:02',NULL),(28,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:14:51',NULL),(29,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:14:51',NULL),(30,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:14:51',NULL),(31,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:14:51',NULL),(32,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:14:51',NULL),(33,6,'Questa è un altrta notifica di test.',1,'2025-07-21 11:14:51',NULL),(34,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:52:55',NULL),(35,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:34',NULL),(36,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:34',NULL),(37,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:34',NULL),(38,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:34',NULL),(39,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:34',NULL),(40,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:35',NULL),(41,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:35',NULL),(42,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:35',NULL),(43,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:35',NULL),(44,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:35',NULL),(45,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:35',NULL),(46,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:37',NULL),(47,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:37',NULL),(48,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:37',NULL),(49,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:38',NULL),(50,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:38',NULL),(51,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:38',NULL),(52,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:38',NULL),(53,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:38',NULL),(54,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:38',NULL),(55,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:39',NULL),(56,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:39',NULL),(57,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:39',NULL),(58,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:39',NULL),(59,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:39',NULL),(60,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:40',NULL),(61,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:40',NULL),(62,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:40',NULL),(63,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:40',NULL),(64,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:40',NULL),(65,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:40',NULL),(66,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:43',NULL),(67,6,'un utente ha inserito un nuovo articolo nel magazzino --------------------------',1,'2025-07-21 12:53:43',NULL),(68,6,'un utente ha inserito un nuovo articolo nel magazzino ',1,'2025-07-21 17:21:19',NULL),(110,4,'Nuova Richiesta Materiale Da giuseppe',1,'2025-08-29 23:25:09',NULL),(111,4,'Nuova Richiesta Materiale Da giuseppe',1,'2025-08-29 23:26:21',NULL),(112,2,'La Tua Richiesta Materiale è stata approvata',1,'2025-08-29 23:26:57',NULL),(113,2,'La Tua Richiesta Materiale è stata rifiutata',1,'2025-08-29 23:27:07',NULL),(114,2,'La Tua Richiesta Materiale è stata rifiutata',1,'2025-08-29 23:27:12',NULL),(115,4,'Nuova Richiesta Materiale Da giuseppe',1,'2025-08-29 23:35:12',NULL),(116,6,'Nuova Richiesta Materiale Da giuseppe',1,'2025-08-29 23:35:12',NULL),(117,4,'Nuova Richiesta Materiale Da giuseppe',1,'2025-08-29 23:38:09',NULL),(118,6,'Nuova Richiesta Materiale Da giuseppe',1,'2025-08-29 23:38:09',NULL),(119,2,'La Tua Richiesta Materiale è stata rifiutata',1,'2025-08-29 23:38:27',NULL),(120,2,'La Tua Richiesta Materiale è stata approvata',1,'2025-08-29 23:38:28',NULL),(121,4,'Nuova richiesta materiale da giuseppe',1,'2025-08-30 12:45:14',NULL),(122,6,'Nuova richiesta materiale da giuseppe',1,'2025-08-30 12:45:14',NULL),(123,4,'Nuova richiesta materiale da giuseppe',1,'2025-08-30 12:45:48',NULL),(124,6,'Nuova richiesta materiale da giuseppe',1,'2025-08-30 12:45:48',NULL),(125,4,'Nuova richiesta materiale da giuseppe',1,'2025-08-30 12:46:17',NULL),(126,6,'Nuova richiesta materiale da giuseppe',1,'2025-08-30 12:46:17',NULL),(127,2,'La tua richiesta materiale è stata approvata',1,'2025-08-30 12:47:04',NULL),(128,4,'Nuova richiesta materiale da giuseppe',1,'2025-08-30 12:47:54',NULL),(129,6,'Nuova richiesta materiale da giuseppe',1,'2025-08-30 12:47:54',NULL),(130,2,'La tua richiesta materiale è stata rifiutata',1,'2025-08-30 12:48:22',NULL),(131,4,'Nuova richiesta materiale da giuseppe',1,'2025-08-30 12:52:49',NULL),(132,6,'Nuova richiesta materiale da giuseppe',1,'2025-08-30 12:52:49',NULL),(133,2,'La tua richiesta materiale è stata approvata',1,'2025-08-30 12:53:13',NULL),(134,2,'La tua richiesta materiale è stata rifiutata',1,'2025-08-30 12:53:57',NULL),(135,2,'La tua richiesta materiale è stata approvata',1,'2025-09-04 17:53:24',NULL),(136,2,'La tua richiesta materiale è stata rifiutata',1,'2025-09-04 17:53:27',NULL),(137,4,'Nuova richiesta materiale da giuseppe',1,'2025-09-04 18:57:46',NULL),(138,6,'Nuova richiesta materiale da giuseppe',1,'2025-09-04 18:57:46',NULL),(139,2,'La tua richiesta materiale è stata approvata',1,'2025-09-04 18:57:58',NULL),(140,2,'La tua richiesta materiale è stata rifiutata',1,'2025-09-04 19:24:06',NULL),(141,2,'La tua richiesta materiale è stata approvata',1,'2025-09-04 19:24:13',NULL),(142,2,'La tua richiesta materiale è stata rifiutata',1,'2025-09-04 19:24:16',NULL),(143,2,'La tua richiesta materiale è stata approvata',1,'2025-09-04 19:26:22',NULL),(144,2,'La tua richiesta materiale è stata rifiutata',1,'2025-09-04 19:27:19',NULL),(145,2,'La tua richiesta materiale è stata approvata',1,'2025-09-04 19:27:20',NULL),(146,2,'La tua richiesta materiale è stata approvata',1,'2025-09-04 19:30:00',NULL),(147,2,'La tua richiesta materiale è stata rifiutata',1,'2025-09-04 19:33:14',NULL),(148,2,'La tua richiesta materiale è stata approvata',1,'2025-09-04 19:33:20',NULL),(152,2,'La tua richiesta materiale è stata rifiutata',1,'2025-09-04 19:33:35',NULL),(153,2,'La tua richiesta materiale è stata approvata',1,'2025-09-04 19:33:36',NULL),(155,2,'La tua richiesta materiale è stata rifiutata',1,'2025-09-04 19:35:59',NULL),(159,2,'La tua richiesta materiale è stata rifiutata',1,'2025-09-04 19:36:01',NULL),(161,4,'Nuova richiesta materiale da giuseppe',1,'2025-09-04 19:37:38',NULL),(162,6,'Nuova richiesta materiale da giuseppe',1,'2025-09-04 19:37:38',NULL),(163,2,'La tua richiesta materiale è stata approvata',1,'2025-09-04 19:38:36',NULL),(166,2,'La tua richiesta materiale è stata rifiutata',1,'2025-09-04 19:42:49',NULL),(169,4,'Nuova richiesta materiale da giuseppe',1,'2025-09-04 19:44:58',NULL),(170,6,'Nuova richiesta materiale da giuseppe',1,'2025-09-04 19:44:58',NULL),(171,2,'La tua richiesta materiale è stata rifiutata',1,'2025-09-04 19:45:52',NULL),(182,4,'Nuova richiesta materiale da giuseppe',0,'2025-09-04 23:03:17',NULL),(183,6,'Nuova richiesta materiale da giuseppe',1,'2025-09-04 23:03:17',NULL),(184,2,'La tua richiesta materiale è stata rifiutata',1,'2025-09-04 23:06:20',NULL),(186,4,'Nuova richiesta materiale da giuseppe',0,'2025-09-04 23:06:29',NULL),(187,6,'Nuova richiesta materiale da giuseppe',1,'2025-09-04 23:06:29',NULL),(188,2,'La tua richiesta materiale è stata rifiutata',1,'2025-09-04 23:07:09',NULL),(189,2,'La tua richiesta materiale è stata rifiutata',1,'2025-09-04 23:07:10',NULL),(192,2,'La tua richiesta materiale è stata approvata',1,'2025-09-04 23:19:02',NULL),(194,2,'La tua richiesta materiale è stata rifiutata',1,'2025-09-04 23:19:05',NULL),(196,4,'Nuova richiesta materiale da giuseppe',0,'2025-09-04 23:27:27',NULL),(197,6,'Nuova richiesta materiale da giuseppe',1,'2025-09-04 23:27:27',NULL),(198,2,'La tua richiesta materiale è stata rifiutata',1,'2025-09-04 23:28:00',NULL),(207,4,'Nuova richiesta materiale da giuseppe',0,'2025-10-04 10:37:24',NULL),(208,6,'Nuova richiesta materiale da giuseppe',1,'2025-10-04 10:37:24',NULL),(209,33,'Nuova richiesta materiale da giuseppe',0,'2025-10-04 10:37:24',NULL),(210,4,'Nuova richiesta materiale da giuseppe',0,'2025-10-04 10:37:37',NULL),(211,6,'Nuova richiesta materiale da giuseppe',1,'2025-10-04 10:37:37',NULL),(212,33,'Nuova richiesta materiale da giuseppe',0,'2025-10-04 10:37:37',NULL),(214,2,'La tua richiesta materiale è stata rifiutata',0,'2025-12-16 21:27:42',NULL),(215,2,'La tua richiesta materiale è stata rifiutata',0,'2025-12-16 21:27:44',NULL);
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `richiesta`
--

DROP TABLE IF EXISTS `richiesta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `richiesta` (
  `id` int NOT NULL AUTO_INCREMENT,
  `richiedente_id` int NOT NULL,
  `stato` enum('in_attesa','approvata','rifiutata','evasa') DEFAULT 'in_attesa',
  `data_richiesta` datetime DEFAULT CURRENT_TIMESTAMP,
  `urgenza` enum('bassa','media','alta') DEFAULT 'media',
  `motivo` enum('Reintegro','Fornitura') DEFAULT 'Reintegro',
  `commento` text,
  `note` text,
  PRIMARY KEY (`id`),
  KEY `richiedente_id` (`richiedente_id`),
  CONSTRAINT `richiesta_ibfk_1` FOREIGN KEY (`richiedente_id`) REFERENCES `utenti` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `richiesta`
--

LOCK TABLES `richiesta` WRITE;
/*!40000 ALTER TABLE `richiesta` DISABLE KEYS */;
/*!40000 ALTER TABLE `richiesta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `richiesta_riga`
--

DROP TABLE IF EXISTS `richiesta_riga`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `richiesta_riga` (
  `id` int NOT NULL AUTO_INCREMENT,
  `richiesta_id` int NOT NULL,
  `articolo_id` int NOT NULL,
  `quantita` int NOT NULL DEFAULT '1',
  `note` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `richiesta_id` (`richiesta_id`),
  KEY `articolo_id` (`articolo_id`),
  CONSTRAINT `richiesta_riga_ibfk_1` FOREIGN KEY (`richiesta_id`) REFERENCES `richiesta` (`id`) ON DELETE CASCADE,
  CONSTRAINT `richiesta_riga_ibfk_2` FOREIGN KEY (`articolo_id`) REFERENCES `articolo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `richiesta_riga`
--

LOCK TABLES `richiesta_riga` WRITE;
/*!40000 ALTER TABLE `richiesta_riga` DISABLE KEYS */;
/*!40000 ALTER TABLE `richiesta_riga` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `storico_articolo`
--

DROP TABLE IF EXISTS `storico_articolo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `storico_articolo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_articolo` int NOT NULL,
  `matricola` varchar(50) DEFAULT NULL,
  `nome` varchar(40) DEFAULT NULL,
  `marca` varchar(40) DEFAULT NULL,
  `compatibilita` varchar(40) DEFAULT NULL,
  `ddt` int DEFAULT NULL,
  `ddtSpedizione` int DEFAULT NULL,
  `tecnico` varchar(80) DEFAULT NULL,
  `pv` varchar(80) DEFAULT NULL,
  `provenienza` varchar(80) DEFAULT NULL,
  `fornitore` varchar(80) DEFAULT NULL,
  `data_ricezione` date DEFAULT NULL,
  `data_spedizione` date DEFAULT NULL,
  `data_garanzia` date DEFAULT NULL,
  `note` text,
  `stato` enum('Riparato','In magazzino','Installato','Destinato','Assegnato','In attesa','Guasto','Non riparato','Non riparabile') DEFAULT NULL,
  `immagine` varchar(255) DEFAULT NULL,
  `data_modifica` datetime DEFAULT CURRENT_TIMESTAMP,
  `utente_modifica` varchar(80) DEFAULT NULL,
  `motivazione` text,
  PRIMARY KEY (`id`),
  KEY `id_articolo` (`id_articolo`),
  CONSTRAINT `storico_articolo_ibfk_1` FOREIGN KEY (`id_articolo`) REFERENCES `articolo` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=215 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `storico_articolo`
--

LOCK TABLES `storico_articolo` WRITE;
/*!40000 ALTER TABLE `storico_articolo` DISABLE KEYS */;
INSERT INTO `storico_articolo` VALUES (181,590,'12','prova','prova','prova',556,55,'2\'1403','PrOVA','PROVA','INGENICO','2025-09-18','2025-09-04','2025-09-05','7844152','In magazzino','img/Icon.png','2025-09-20 15:37:24','admin',''),(182,590,'12','prova','prova','prova',556,55,'','PrOVA','PROVA','INGENICO','2025-09-18','2025-09-04','2025-09-05','7844152','In magazzino','img/Icon.png','2025-09-20 15:37:24','admin',''),(183,590,'12','prova','prova','prova',556,55,'','PrOVA','PROVA','INGENICO','2025-09-18','2025-09-04','2025-09-05','7844152','In magazzino','img/Icon.png','2025-09-20 15:37:34','admin',''),(184,590,'12','prova','prova','prova',556,55,'Giuseppe Coppola','PrOVA','PROVA','INGENICO','2025-09-18','2025-09-04','2025-09-05','7844152','In magazzino','img/Icon.png','2025-09-20 15:37:34','admin',''),(185,591,'412','prova','31','4231',0,0,'','','','',NULL,NULL,NULL,' ','Guasto','img/Icon.png','2025-09-20 18:25:43','admin',''),(186,591,'412','prova','31','4231',0,0,'','','','',NULL,NULL,NULL,' ','Guasto','img/Icon.png','2025-09-20 18:25:43','admin',''),(187,591,'412','prova','31','4231',0,0,'','','','',NULL,NULL,NULL,' ','Guasto','img/Icon.png','2025-09-20 18:25:43','admin',''),(188,591,'412','prova','31','4231',0,0,'Developer Figo','','','',NULL,NULL,NULL,' ','Assegnato','img/Icon.png','2025-09-20 18:25:43','admin',''),(189,591,'412','prova','31','4231',0,0,'Developer Figo','','','',NULL,NULL,NULL,' ','Assegnato','img/Icon.png','2025-09-20 18:25:54','admin',''),(190,591,'412','prova','31','4231',0,0,'','','','',NULL,NULL,NULL,' ','Assegnato','img/Icon.png','2025-09-20 18:25:54','admin',''),(191,591,'412','prova','31','4231',0,0,'','','','',NULL,NULL,NULL,' ','Assegnato','img/Icon.png','2025-09-20 18:25:58','admin',''),(192,591,'412','prova','31','4231',0,0,'Giuseppe Coppola','','','',NULL,NULL,NULL,' ','Assegnato','img/Icon.png','2025-09-20 18:25:58','admin',''),(193,614,'SI23094099','DISPLAY PCAP 12\"1','KF MODENA','FORTECH',0,0,NULL,'','',NULL,NULL,NULL,NULL,'CON IMPRONTA DIGITALE','In magazzino',NULL,'2025-09-20 18:49:17','admin',''),(194,614,'SI23094099','DISPLAY PCAP 12','KF MODENA','FORTECH',0,0,'','','','',NULL,NULL,NULL,'CON IMPRONTA DIGITALE','In magazzino',NULL,'2025-09-20 18:49:17','admin',''),(195,614,'SI23094099','DISPLAY PCAP 12','KF MODENA','FORTECH',0,0,'','','','',NULL,NULL,NULL,'CON IMPRONTA DIGITALE','In magazzino',NULL,'2025-09-20 18:49:17','admin',''),(196,614,'SI23094099','DISPLAY PCAP 12','KF MODENA','FORTECH',0,0,'Developer Figo','','','',NULL,NULL,NULL,'CON IMPRONTA DIGITALE','Assegnato',NULL,'2025-09-20 18:49:17','admin',''),(201,590,'12','prova','prova','prova',556,55,'Giuseppe Coppola','PrOVA','PROVA','INGENICO','2025-09-18','2025-09-04','2025-09-05','7844152','In magazzino','img/Icon.png','2025-12-11 20:38:25','giuseppe',''),(202,590,'12','prova','prova','prova',556,55,'Giuseppe Coppola','PrOVA','PROVA','INGENICO','2025-09-18','2025-09-04','2025-09-05','7844152','In magazzino','img/Icon.png','2025-12-11 20:38:25','giuseppe',''),(203,590,'12','prova','prova','prova',556,55,'Giuseppe Coppola','PrOVA','PROVA','INGENICO','2025-09-18','2025-09-04','2025-09-05','7844152','In magazzino','img/Icon.png','2025-12-11 20:38:25','giuseppe',''),(204,590,'12','prova','prova','prova',556,55,'Giuseppe Coppola','PrOVA','PROVA','INGENICO','2025-09-18','2025-09-04','2025-09-05','7844152','Assegnato','img/Icon.png','2025-12-11 20:38:25','giuseppe',''),(205,591,'412','prova','31','4231',0,0,'Giuseppe Coppola','','','',NULL,NULL,NULL,' ','Assegnato','img/Icon.png','2025-12-11 20:44:07','admin',''),(206,591,'412','prova','31','',0,0,'Giuseppe Coppola','','','',NULL,NULL,NULL,' ','Assegnato','img/Icon.png','2025-12-11 20:44:07','admin',''),(213,1,'01491040419','Articolo Riparato','Marca 1','Articolo 7',166,155,'Mario Rossi','Punto Vendita 145','Magazzino 1','Centro Revisione 2','2025-12-24','2025-12-12','2025-12-24','note articolo','Riparato','img/Icon.png','2025-12-16 22:26:35','admintest',''),(214,1,'01491040419','Articolo Riparato','Marca 1','Articolo 7',166,155,'Mario Rossi','Punto Vendita 145','Magazzino 1','Centro Revisione 1','2025-12-24','2025-12-12','2025-12-24','note articolo','Riparato','img/Icon.png','2025-12-16 22:26:35','admintest','');
/*!40000 ALTER TABLE `storico_articolo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_token`
--

DROP TABLE IF EXISTS `user_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_token` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `token` char(64) NOT NULL,
  `purpose` enum('REVEAL_PWD') NOT NULL,
  `payload` varbinary(512) DEFAULT NULL,
  `expires_at` datetime NOT NULL,
  `used` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `token_2` (`token`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `fk_user_token_user` FOREIGN KEY (`user_id`) REFERENCES `utenti` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_token`
--

LOCK TABLES `user_token` WRITE;
/*!40000 ALTER TABLE `user_token` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utenti`
--

DROP TABLE IF EXISTS `utenti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utenti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(20) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `mail` varchar(80) DEFAULT NULL,
  `nomeCognome` varchar(80) DEFAULT NULL,
  `ruolo` enum('Tecnico','Amministratore','Magazziniere') DEFAULT NULL,
  `stato` enum('attivo','inattivo') NOT NULL DEFAULT 'attivo',
  `ultimo_accesso` datetime DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utenti`
--

LOCK TABLES `utenti` WRITE;
/*!40000 ALTER TABLE `utenti` DISABLE KEYS */;
INSERT INTO `utenti` VALUES (2,'tecnico','$2a$10$aAmQE6wm5F6RQAyuXsNPiOlym4bmM4HAyeRiozmsNQKXzffuOGmpm','tecnico@tecnodeposit.it','Mario Rossi','Tecnico','inattivo','2025-12-16 22:28:53',''),(4,'magazziniere','$2a$10$O3CxWMUWI/inIRe2ZSjsCOMFcDZgPIgWeSyry08d1Byu3W2hJLQC2','magazziniere@tecnodeposit.it','Luca Bianchi','Magazziniere','inattivo','2025-09-05 01:18:41',''),(6,'admin','$2a$10$sZfDkguMSO4VxJzLrMoUv.nV5ZZ5BjzReKp/UxNLPqA5vkkmWXcK.','assistenza@tecnodeposit.it','Francesco Coppola','Amministratore','attivo','2025-12-16 22:29:18','');
/*!40000 ALTER TABLE `utenti` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-16 22:30:43
