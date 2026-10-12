-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Sep 27, 2026 at 05:39 AM
-- Server version: 5.7.44-48
-- PHP Version: 8.4.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `colibrip_abcsistema`
--

-- --------------------------------------------------------

--
-- Table structure for table `cp_activity_log`
--

CREATE TABLE `cp_activity_log` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `action` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `module` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_activity_log`
--

INSERT INTO `cp_activity_log` (`id`, `user_id`, `action`, `module`, `description`, `ip_address`, `created_at`) VALUES
(195, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-19 00:42:06'),
(196, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-19 09:58:15'),
(197, 1, 'update', 'facebook', 'Configuración de publicación automática de Facebook actualizada', '177.239.83.23', '2026-09-19 10:42:36'),
(198, 1, 'update', 'facebook', 'Configuración de publicación automática de Facebook actualizada', '177.239.83.23', '2026-09-19 10:42:50'),
(199, 1, 'update', 'facebook', 'Configuración de publicación automática de Facebook actualizada', '177.239.83.23', '2026-09-19 10:42:53'),
(200, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-19 10:43:22'),
(201, 1, 'update', 'facebook', 'Configuración de publicación automática de Facebook actualizada', '177.239.83.23', '2026-09-19 10:44:29'),
(202, 1, 'update', 'promotions', 'Promoción #1 guardada', '177.239.83.23', '2026-09-19 10:45:45'),
(203, 1, 'create', 'facebook', 'Promoción #1 publicada automáticamente en Facebook. Post: 110268670793730_1495277692620142', '177.239.83.23', '2026-09-19 10:47:11'),
(204, 1, 'update', 'promotions', 'Promoción #1 guardada', '177.239.83.23', '2026-09-19 10:47:11'),
(205, 1, 'create', 'quotes', 'Cotización creada #13', '177.239.83.23', '2026-09-19 10:50:15'),
(206, 1, 'update', 'quotes', 'Estado de cotización actualizado #13 a approved', '177.239.83.23', '2026-09-19 10:54:10'),
(207, 1, 'create', 'quotes', 'Cotización creada #14', '177.239.83.23', '2026-09-19 10:56:30'),
(208, 1, 'update', 'quotes', 'Estado de cotización actualizado #14 a approved', '177.239.83.23', '2026-09-19 10:56:46'),
(209, 1, 'create', 'orders', 'Orden creada OS-2026-00001 desde cotización #14', '177.239.83.23', '2026-09-19 10:58:01'),
(210, 1, 'update', 'production', 'Etapa actualizada para orden #11', '177.239.83.23', '2026-09-19 10:58:43'),
(211, 1, 'create', 'payments', 'Pago registrado #3', '177.239.83.23', '2026-09-19 11:00:33'),
(212, 1, 'update', 'payments', 'Pago actualizado #3', '177.239.83.23', '2026-09-19 11:02:36'),
(213, 1, 'update', 'production', 'Etapa actualizada para orden #11', '177.239.83.23', '2026-09-19 11:04:34'),
(214, 1, 'update', 'production', 'Etapa actualizada para orden #11', '177.239.83.23', '2026-09-19 11:05:06'),
(215, 1, 'update', 'production', 'Etapa actualizada para orden #11', '177.239.83.23', '2026-09-19 11:05:31'),
(216, 1, 'update', 'production', 'Etapa actualizada para orden #11', '177.239.83.23', '2026-09-19 11:06:05'),
(217, 1, 'update', 'quotes', 'Estado de cotización actualizado #13 a approved', '177.239.83.23', '2026-09-19 11:06:16'),
(218, 1, 'create', 'orders', 'Orden creada OS-2026-00002 desde cotización #13', '177.239.83.23', '2026-09-19 11:06:45'),
(219, 1, 'update', 'production', 'Etapa actualizada para orden #12', '177.239.83.23', '2026-09-19 11:10:57'),
(220, 1, 'create', 'quotes', 'Cotización creada #15', '177.239.83.23', '2026-09-19 11:13:45'),
(221, 1, 'update', 'quotes', 'Estado de cotización actualizado #15 a approved', '177.239.83.23', '2026-09-19 11:14:00'),
(222, 1, 'create', 'orders', 'Orden creada OS-2026-00003 desde cotización #15', '177.239.83.23', '2026-09-19 11:15:57'),
(223, 1, 'update', 'production', 'Etapa actualizada para orden #12', '177.239.83.23', '2026-09-19 11:19:20'),
(224, 1, 'create', 'payments', 'Pago registrado #4', '177.239.83.23', '2026-09-19 11:23:56'),
(225, 1, 'create', 'payments', 'Pago registrado #5', '177.239.83.23', '2026-09-19 11:25:16'),
(226, 1, 'create', 'quotes', 'Cotización creada #16', '177.239.83.23', '2026-09-19 11:40:58'),
(227, 1, 'update', 'quotes', 'Estado de cotización actualizado #16 a approved', '177.239.83.23', '2026-09-19 11:41:10'),
(228, 1, 'create', 'orders', 'Orden creada OS-2026-00004 desde cotización #16', '177.239.83.23', '2026-09-19 11:41:28'),
(229, 1, 'update', 'quotes', 'Cotización actualizada #16', '177.239.83.23', '2026-09-19 11:44:12'),
(230, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-19 13:11:46'),
(231, 1, 'update', 'quotes', 'Cotización actualizada #16', '177.239.83.23', '2026-09-19 13:12:24'),
(232, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-19 14:19:59'),
(233, 1, 'create', 'payments', 'Anticipo registrado para orden #14 por $100.00', '177.239.83.23', '2026-09-19 14:36:50'),
(234, 1, 'update', 'settings', 'Datos de empresa actualizados', '177.239.83.23', '2026-09-19 15:05:40'),
(235, 1, 'update', 'settings', 'Datos de empresa actualizados', '177.239.83.23', '2026-09-19 15:06:48'),
(236, 1, 'update', 'settings', 'Datos de empresa actualizados', '177.239.83.23', '2026-09-19 15:42:53'),
(237, 1, 'update', 'production', 'Etapa actualizada para orden #12', '177.239.83.23', '2026-09-19 16:34:59'),
(238, 1, 'update', 'quotes', 'Cotización actualizada #16', '177.239.83.23', '2026-09-19 16:40:54'),
(239, 1, 'update', 'payments', 'Pago actualizado #6', '177.239.83.23', '2026-09-19 16:41:41'),
(240, 1, 'update', 'production', 'Etapa actualizada para orden #14', '177.239.83.23', '2026-09-19 16:42:18'),
(241, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-19 16:59:40'),
(242, 1, 'create', 'customers', 'Cliente #1266 creado', '177.239.83.23', '2026-09-19 17:04:05'),
(243, 1, 'create', 'quotes', 'Cotización creada #17', '177.239.83.23', '2026-09-19 17:05:47'),
(244, 1, 'update', 'quotes', 'Estado de cotización actualizado #17 a approved', '177.239.83.23', '2026-09-19 17:06:29'),
(245, 1, 'create', 'orders', 'Orden creada OS-2026-00005 desde cotización #17', '177.239.83.23', '2026-09-19 17:07:32'),
(246, 1, 'update', 'payments', 'Pago actualizado #6', '177.239.83.23', '2026-09-19 17:15:25'),
(247, 1, 'create', 'quotes', 'Cotización creada #18', '177.239.83.23', '2026-09-19 17:15:41'),
(248, 1, 'update', 'payments', 'Pago actualizado #6', '177.239.83.23', '2026-09-19 17:15:57'),
(249, 1, 'update', 'quotes', 'Estado de cotización actualizado #18 a approved', '177.239.83.23', '2026-09-19 17:16:23'),
(250, 1, 'create', 'orders', 'Orden creada OS-2026-00006 desde cotización #18', '177.239.83.23', '2026-09-19 17:17:34'),
(251, 1, 'update', 'quotes', 'Cotización actualizada #17', '177.239.83.23', '2026-09-19 17:21:24'),
(252, 1, 'create', 'quotes', 'Cotización creada #19', '177.239.83.23', '2026-09-19 17:26:00'),
(253, 1, 'update', 'quotes', 'Estado de cotización actualizado #19 a approved', '177.239.83.23', '2026-09-19 17:26:13'),
(254, 1, 'create', 'orders', 'Orden creada OS-2026-00007 desde cotización #19', '177.239.83.23', '2026-09-19 17:26:26'),
(255, 1, 'update', 'orders', 'Comprobante de pago revisado para orden #14', '177.239.83.23', '2026-09-19 17:50:08'),
(256, 1, 'update', 'payments', 'Pago actualizado #6', '177.239.83.23', '2026-09-19 17:53:41'),
(257, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-19 18:03:45'),
(258, 1, 'create', 'orders', 'Foto agregada a orden #15', '177.239.83.23', '2026-09-19 18:13:21'),
(259, 1, 'create', 'orders', 'Foto agregada a orden #15', '177.239.83.23', '2026-09-19 18:13:46'),
(260, 1, 'create', 'print_meter_logs', 'Trabajo impreso #4 · LONA U uva mtra · 0.39 m', '177.239.83.23', '2026-09-19 18:31:57'),
(261, 1, 'create', 'print_meter_logs', 'Trabajo impreso #5 · LONA U uva mtra · 0.39 m', '177.239.83.23', '2026-09-19 18:33:18'),
(262, 1, 'create', 'print_meter_logs', 'Trabajo impreso #6 · LONA U uva mtra · 0.39 m', '177.239.83.23', '2026-09-19 18:33:33'),
(263, 1, 'create', 'print_meter_logs', 'Trabajo impreso #7 · NUMEROS MTRA ADRIANA · 0.6 m', '177.239.83.23', '2026-09-19 18:34:34'),
(264, 1, 'create', 'quotes', 'Cotización creada #20', '177.239.83.23', '2026-09-19 18:35:05'),
(265, 1, 'create', 'print_meter_logs', 'Trabajo impreso #8 · ETIQUETAS NOMBRES SANTIAGO · 0.25 m', '177.239.83.23', '2026-09-19 18:35:14'),
(266, 1, 'update', 'quotes', 'Estado de cotización actualizado #20 a approved', '177.239.83.23', '2026-09-19 18:35:25'),
(267, 1, 'create', 'orders', 'Orden creada OS-2026-00008 desde cotización #20', '177.239.83.23', '2026-09-19 18:35:39'),
(268, 1, 'create', 'print_meter_logs', 'Trabajo impreso #9 · caryolas y nombre santiago · 0.415 m', '177.239.83.23', '2026-09-19 18:35:39'),
(269, 1, 'create', 'print_meter_logs', 'Trabajo impreso #10 · NEVERA LAS ARTESANALES · 1.258 m', '177.239.83.23', '2026-09-19 18:36:14'),
(270, 1, 'create', 'orders', 'Foto agregada a orden #18', '177.239.83.23', '2026-09-19 18:37:24'),
(271, 1, 'create', 'orders', 'Foto agregada a orden #18', '177.239.83.23', '2026-09-19 18:38:15'),
(272, 1, 'create', 'orders', 'Foto agregada a orden #18', '177.239.83.23', '2026-09-19 18:38:46'),
(273, 1, 'create', 'orders', 'Foto agregada a orden #18', '177.239.83.23', '2026-09-19 18:39:18'),
(274, 1, 'create', 'orders', 'Foto agregada a orden #18', '177.239.83.23', '2026-09-19 18:41:30'),
(275, 1, 'update', 'production', 'Etapa actualizada para orden #11', '177.239.83.23', '2026-09-19 18:43:00'),
(276, 1, 'delete', 'orders', 'Foto eliminada de orden #18', '177.239.83.23', '2026-09-19 18:47:42'),
(277, 1, 'delete', 'orders', 'Foto eliminada de orden #18', '177.239.83.23', '2026-09-19 18:47:50'),
(278, 1, 'delete', 'orders', 'Foto eliminada de orden #18', '177.239.83.23', '2026-09-19 18:47:58'),
(279, 1, 'create', 'orders', 'Foto agregada a orden #18', '177.239.83.23', '2026-09-19 18:50:13'),
(280, 1, 'create', 'orders', 'Foto agregada a orden #18', '177.239.83.23', '2026-09-19 18:50:45'),
(281, 1, 'create', 'orders', 'Foto agregada a orden #18', '177.239.83.23', '2026-09-19 18:53:38'),
(282, 1, 'create', 'orders', 'Archivo agregado a orden #18', '177.239.83.23', '2026-09-19 19:04:02'),
(283, 1, 'delete', 'orders', 'Foto eliminada de orden #18', '177.239.83.23', '2026-09-19 19:04:15'),
(284, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-19 19:07:13'),
(285, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-19 19:19:12'),
(286, 1, 'update', 'quotes', 'Cotización actualizada #20', '177.239.83.23', '2026-09-19 19:20:42'),
(287, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-19 19:38:46'),
(288, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-19 20:18:02'),
(289, 1, 'update', 'quotes', 'Cotización actualizada #19', '177.239.83.23', '2026-09-19 20:24:06'),
(290, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-19 21:32:53'),
(291, 1, 'create', 'promotions', 'Promoción #2 guardada', '177.239.83.23', '2026-09-19 21:51:35'),
(292, 1, 'update', 'promotions', 'Promoción #2 guardada', '177.239.83.23', '2026-09-19 21:52:22'),
(293, 1, 'update', 'facebook', 'Configuración de publicación automática de Facebook actualizada', '177.239.83.23', '2026-09-19 22:00:15'),
(294, 1, 'update', 'facebook', 'Configuración de publicación automática de Facebook actualizada', '177.239.83.23', '2026-09-19 22:00:17'),
(295, 1, 'update', 'promotions', 'Promoción #2 guardada', '177.239.83.23', '2026-09-19 22:02:32'),
(296, 1, 'update', 'promotions', 'Promoción #2 guardada', '177.239.83.23', '2026-09-19 22:05:09'),
(297, 1, 'update', 'promotions', 'Promoción #2 guardada', '177.239.83.23', '2026-09-19 22:18:45'),
(298, 1, 'create', 'quotes', 'Cotización CP-2026-00011 creada desde solicitud web CPQ-000004', '177.239.83.23', '2026-09-19 22:32:25'),
(299, 1, 'delete', 'quotes', 'Cotización eliminada #23', '177.239.83.23', '2026-09-19 22:36:13'),
(300, 1, 'delete', 'quotes', 'Cotización eliminada #22', '177.239.83.23', '2026-09-19 22:36:15'),
(301, 1, 'delete', 'quotes', 'Cotización eliminada #21', '177.239.83.23', '2026-09-19 22:36:18'),
(302, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-19 22:56:06'),
(303, 1, 'create', 'quotes', 'Cotización CP-2026-00009 creada desde solicitud web CPQ-000005', '177.239.83.23', '2026-09-19 22:56:43'),
(304, 1, 'update', 'quotes', 'Cotización actualizada #24', '177.239.83.23', '2026-09-19 22:58:05'),
(305, 1, 'delete', 'quotes', 'Cotización eliminada #24', '177.239.83.23', '2026-09-19 22:59:10'),
(306, 1, 'delete', 'quotes', 'Cotización eliminada #27', '177.239.83.23', '2026-09-20 00:01:22'),
(307, 1, 'delete', 'quotes', 'Cotización eliminada #26', '177.239.83.23', '2026-09-20 00:01:23'),
(308, 1, 'delete', 'quotes', 'Cotización eliminada #25', '177.239.83.23', '2026-09-20 00:01:26'),
(309, 1, 'delete', 'web_quote_requests', 'Solicitud web CPQ-000001 eliminada', '177.239.83.23', '2026-09-20 00:01:34'),
(310, 1, 'delete', 'web_quote_requests', 'Solicitud web CPQ-000002 eliminada', '177.239.83.23', '2026-09-20 00:01:38'),
(311, 1, 'delete', 'web_quote_requests', 'Solicitud web CPQ-000003 eliminada', '177.239.83.23', '2026-09-20 00:01:42'),
(312, 1, 'delete', 'web_quote_requests', 'Solicitud web CPQ-000004 eliminada', '177.239.83.23', '2026-09-20 00:01:45'),
(313, 1, 'update', 'quotes', 'Estado de cotización actualizado #28 a sent', '177.239.83.23', '2026-09-20 00:07:27'),
(314, 1, 'update', 'quotes', 'Cotización actualizada #28', '177.239.83.23', '2026-09-20 00:09:28'),
(315, 1, 'update', 'quotes', 'Cotización actualizada #28', '177.239.83.23', '2026-09-20 00:10:25'),
(316, 1, 'update', 'quotes', 'Estado de cotización actualizado #28 a approved', '177.239.83.23', '2026-09-20 00:10:30'),
(317, 1, 'create', 'orders', 'Orden creada OS-2026-00009 desde cotización #28', '177.239.83.23', '2026-09-20 00:12:05'),
(318, 1, 'create', 'payments', 'Anticipo registrado para orden #19 por $50.00', '177.239.83.23', '2026-09-20 00:12:30'),
(319, 1, 'update', 'quotes', 'Estado de cotización actualizado #29 a sent', '177.239.83.23', '2026-09-20 00:22:03'),
(320, 1, 'update', 'quotes', 'Cotización actualizada #29', '177.239.83.23', '2026-09-20 00:22:37'),
(321, 1, 'update', 'quotes', 'Estado de cotización actualizado #29 a approved', '177.239.83.23', '2026-09-20 00:23:17'),
(322, 1, 'create', 'orders', 'Orden creada OS-2026-00010 desde cotización #29', '177.239.83.23', '2026-09-20 00:23:51'),
(323, 1, 'create', 'payments', 'Anticipo registrado para orden #20 por $100.00', '177.239.83.23', '2026-09-20 00:24:37'),
(324, 1, 'update', 'production', 'Etapa actualizada para orden #20', '177.239.83.23', '2026-09-20 00:26:12'),
(325, 1, 'update', 'production', 'Etapa actualizada para orden #20', '177.239.83.23', '2026-09-20 00:26:15'),
(326, 1, 'update', 'production', 'Etapa actualizada para orden #20', '177.239.83.23', '2026-09-20 00:26:17'),
(327, 1, 'update', 'production', 'Etapa actualizada para orden #20', '177.239.83.23', '2026-09-20 00:26:20'),
(328, 1, 'update', 'production', 'Etapa actualizada para orden #20', '177.239.83.23', '2026-09-20 00:26:22'),
(329, 1, 'update', 'production', 'Etapa actualizada para orden #20', '177.239.83.23', '2026-09-20 00:26:25'),
(330, 1, 'update', 'orders', 'Comprobante de pago revisado para orden #20', '177.239.83.23', '2026-09-20 00:30:39'),
(331, 1, 'update', 'orders', 'Comprobante de pago revisado para orden #20', '177.239.83.23', '2026-09-20 00:31:18'),
(332, 1, 'create', 'print_meter_logs', 'Trabajo impreso #11 · IMPRESION DE PELOTAS DE BASEBALL · 0.159 m', '177.239.83.23', '2026-09-20 00:34:52'),
(333, 1, 'update', 'orders', 'Orden cancelada OS-2026-00009', '177.239.83.23', '2026-09-20 00:37:13'),
(334, 1, 'update', 'orders', 'Orden cancelada OS-2026-00010', '177.239.83.23', '2026-09-20 00:37:16'),
(335, 1, 'delete', 'web_quote_requests', 'Solicitud web CPQ-000005 eliminada', '177.239.83.23', '2026-09-20 00:38:20'),
(336, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-20 00:56:51'),
(337, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-20 08:51:37'),
(338, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-20 12:15:13'),
(339, 1, 'update', 'production', 'Etapa actualizada para orden #14', '177.239.83.23', '2026-09-20 12:15:57'),
(340, 1, 'update', 'production', 'Etapa actualizada para orden #14', '177.239.83.23', '2026-09-20 13:51:58'),
(341, 1, 'update', 'production', 'Etapa actualizada para orden #14', '177.239.83.23', '2026-09-20 13:52:38'),
(342, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-20 15:08:27'),
(343, 1, 'update', 'production', 'Etapa actualizada para orden #14', '177.239.83.23', '2026-09-20 15:36:07'),
(344, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-20 17:32:57'),
(345, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-20 21:02:50'),
(346, 1, 'logout', 'auth', 'Cierre de sesión', '177.239.83.23', '2026-09-20 21:02:54'),
(347, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-20 21:36:46'),
(348, 1, 'update', 'tiktok', 'Configuración de TikTok actualizada', '177.239.83.23', '2026-09-20 23:13:21'),
(349, 1, 'update', 'tiktok', 'Configuración de TikTok actualizada', '177.239.83.23', '2026-09-20 23:15:53'),
(350, 1, 'update', 'tiktok', 'Configuración de TikTok actualizada', '177.239.83.23', '2026-09-20 23:16:55'),
(351, 1, 'update', 'tiktok', 'Configuración de TikTok actualizada', '177.239.83.23', '2026-09-20 23:17:30'),
(352, 1, 'update', 'tiktok', 'Configuración de TikTok actualizada', '177.239.83.23', '2026-09-20 23:19:51'),
(353, 1, 'update', 'tiktok', 'Configuración de TikTok actualizada', '177.239.83.23', '2026-09-20 23:26:53'),
(354, 1, 'update', 'tiktok', 'Configuración de TikTok actualizada', '177.239.83.23', '2026-09-20 23:30:19'),
(355, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.4', '2026-09-21 08:28:46'),
(356, 1, 'create', 'customers', 'Cliente #1270 creado', '200.68.164.4', '2026-09-21 08:29:27'),
(357, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-21 08:39:02'),
(358, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.4', '2026-09-21 08:39:21'),
(359, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.4', '2026-09-21 08:39:35'),
(360, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.4', '2026-09-21 09:30:50'),
(361, 1, 'update', 'customers', 'Cliente #1270 actualizado', '200.68.164.4', '2026-09-21 09:32:50'),
(362, 1, 'update', 'production', 'Etapa actualizada para orden #15', '177.239.83.23', '2026-09-21 09:59:23'),
(363, 1, 'update', 'production', 'Etapa actualizada para orden #15', '177.239.83.23', '2026-09-21 09:59:27'),
(364, 1, 'update', 'production', 'Etapa actualizada para orden #15', '177.239.83.23', '2026-09-21 09:59:29'),
(365, 1, 'update', 'production', 'Etapa actualizada para orden #15', '177.239.83.23', '2026-09-21 09:59:32'),
(366, 1, 'update', 'production', 'Etapa actualizada para orden #15', '177.239.83.23', '2026-09-21 09:59:35'),
(367, 1, 'update', 'production', 'Etapa actualizada para orden #15', '177.239.83.23', '2026-09-21 09:59:37'),
(368, 1, 'update', 'production', 'Etapa actualizada para orden #15', '177.239.83.23', '2026-09-21 09:59:40'),
(369, 1, 'update', 'production', 'Etapa actualizada para orden #12', '177.239.83.23', '2026-09-21 10:11:32'),
(370, 1, 'update', 'production', 'Etapa actualizada para orden #12', '177.239.83.23', '2026-09-21 10:11:35'),
(371, 1, 'update', 'production', 'Etapa actualizada para orden #12', '177.239.83.23', '2026-09-21 10:11:38'),
(372, 1, 'update', 'production', 'Etapa actualizada para orden #12', '177.239.83.23', '2026-09-21 10:11:40'),
(373, 1, 'update', 'production', 'Etapa actualizada para orden #12', '177.239.83.23', '2026-09-21 10:11:42'),
(374, 1, 'update', 'quotes', 'Cotización actualizada #13', '177.239.83.23', '2026-09-21 10:14:31'),
(375, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.4', '2026-09-21 10:15:10'),
(376, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-21 12:28:06'),
(377, 1, 'update', 'production', 'Etapa actualizada para orden #12', '177.239.83.23', '2026-09-21 12:28:29'),
(378, 1, 'create', 'payments', 'Anticipo registrado para orden #12 por $2895.00', '177.239.83.23', '2026-09-21 12:29:35'),
(379, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.4', '2026-09-21 12:46:45'),
(380, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.4', '2026-09-21 12:46:56'),
(381, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.4', '2026-09-21 14:16:48'),
(382, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-21 14:31:42'),
(383, 1, 'calculate', 'calculators', 'Cálculo interno Bastidor + Lona', '177.239.83.23', '2026-09-21 14:37:56'),
(384, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-21 15:28:04'),
(385, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-21 16:33:19'),
(386, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-21 18:11:52'),
(387, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-21 22:26:01'),
(388, 1, 'update', 'production', 'Etapa actualizada para orden #13', '177.239.83.23', '2026-09-21 22:26:24'),
(389, 1, 'update', 'production', 'Etapa actualizada para orden #13', '177.239.83.23', '2026-09-21 22:26:27'),
(390, 1, 'update', 'production', 'Etapa actualizada para orden #13', '177.239.83.23', '2026-09-21 22:26:30'),
(391, 1, 'update', 'production', 'Etapa actualizada para orden #13', '177.239.83.23', '2026-09-21 22:26:35'),
(392, 1, 'update', 'production', 'Etapa actualizada para orden #13', '177.239.83.23', '2026-09-21 22:26:37'),
(393, 1, 'update', 'production', 'Etapa actualizada para orden #13', '177.239.83.23', '2026-09-21 22:26:42'),
(394, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-21 23:11:11'),
(395, 1, 'login', 'auth', 'Inicio de sesión', '2806:108e:d:2013:2871:17f4:c555:7852', '2026-09-22 07:45:59'),
(396, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-22 08:08:26'),
(397, 1, 'update', 'production', 'Etapa actualizada para orden #17', '177.239.83.23', '2026-09-22 08:08:53'),
(398, 1, 'update', 'production', 'Etapa actualizada para orden #17', '177.239.83.23', '2026-09-22 08:08:56'),
(399, 1, 'update', 'production', 'Etapa actualizada para orden #17', '177.239.83.23', '2026-09-22 08:09:00'),
(400, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.7', '2026-09-22 08:35:43'),
(401, 1, 'create', 'quotes', 'Cotización creada #30', '200.68.164.7', '2026-09-22 08:38:12'),
(402, 1, 'update', 'quotes', 'Estado de cotización actualizado #30 a approved', '200.68.164.7', '2026-09-22 08:38:30'),
(403, 1, 'create', 'orders', 'Orden creada OS-2026-00011 desde cotización #30', '200.68.164.7', '2026-09-22 08:38:51'),
(404, 1, 'create', 'orders', 'Archivo agregado a orden #21', '200.68.164.7', '2026-09-22 08:39:33'),
(405, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-22 09:09:23'),
(406, 1, 'update', 'production', 'Etapa actualizada para orden #13', '177.239.83.23', '2026-09-22 09:09:30'),
(407, 1, 'update', 'quotes', 'Cotización actualizada #15', '177.239.83.23', '2026-09-22 09:10:03'),
(408, 1, 'create', 'payments', 'Anticipo registrado para orden #21 por $750.00', '200.68.164.7', '2026-09-22 09:10:28'),
(409, 1, 'create', 'orders', 'Archivo agregado a orden #21', '200.68.164.7', '2026-09-22 09:13:01'),
(410, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.7', '2026-09-22 09:21:48'),
(411, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.7', '2026-09-22 10:27:00'),
(412, 1, 'create', 'quotes', 'Cotización creada #31', '200.68.164.7', '2026-09-22 10:38:27'),
(413, 1, 'update', 'quotes', 'Estado de cotización actualizado #31 a approved', '200.68.164.7', '2026-09-22 10:38:39'),
(414, 1, 'create', 'orders', 'Orden creada OS-2026-00012 desde cotización #31', '200.68.164.7', '2026-09-22 10:38:56'),
(415, 1, 'create', 'orders', 'Archivo agregado a orden #22', '200.68.164.7', '2026-09-22 10:39:43'),
(416, 1, 'create', 'payments', 'Anticipo registrado para orden #22 por $1917.00', '200.68.164.7', '2026-09-22 10:40:08'),
(417, 1, 'create', 'orders', 'Archivo agregado a orden #22', '200.68.164.7', '2026-09-22 10:41:01'),
(418, 1, 'create', 'quotes', 'Cotización creada #32', '200.68.164.7', '2026-09-22 10:53:47'),
(419, 1, 'update', 'quotes', 'Estado de cotización actualizado #32 a approved', '200.68.164.7', '2026-09-22 10:54:06'),
(420, 1, 'create', 'orders', 'Orden creada OS-2026-00013 desde cotización #32', '200.68.164.7', '2026-09-22 10:54:15'),
(421, 1, 'create', 'orders', 'Archivo agregado a orden #23', '200.68.164.7', '2026-09-22 10:54:53'),
(422, 1, 'create', 'quotes', 'Cotización creada #33', '200.68.164.7', '2026-09-22 11:05:30'),
(423, 1, 'update', 'quotes', 'Cotización actualizada #33', '200.68.164.7', '2026-09-22 11:07:47'),
(424, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-22 12:01:25'),
(425, 1, 'create', 'promotions', 'Promoción #3 guardada', '177.239.83.23', '2026-09-22 12:04:02'),
(426, 1, 'create', 'categories', 'Categoría #8 creada', '177.239.83.23', '2026-09-22 12:04:20'),
(427, 1, 'create', 'products', 'Producto #3 creado', '177.239.83.23', '2026-09-22 12:05:14'),
(428, 1, 'update', 'promotions', 'Promoción #3 guardada', '177.239.83.23', '2026-09-22 12:05:34'),
(429, 1, 'update', 'promotions', 'Promoción #2 guardada', '177.239.83.23', '2026-09-22 12:15:05'),
(430, 1, 'update', 'promotions', 'Promoción #1 guardada', '177.239.83.23', '2026-09-22 12:15:18'),
(431, 1, 'update', 'promotions', 'Promoción #3 guardada', '177.239.83.23', '2026-09-22 12:45:41'),
(432, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.7', '2026-09-22 13:34:00'),
(433, 1, 'update', 'quotes', 'Cotización actualizada #33', '200.68.164.7', '2026-09-22 13:40:01'),
(434, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.7', '2026-09-22 14:16:37'),
(435, 1, 'create', 'quotes', 'Cotización creada #34', '200.68.164.7', '2026-09-22 14:18:56'),
(436, 1, 'update', 'quotes', 'Estado de cotización actualizado #34 a approved', '200.68.164.7', '2026-09-22 14:19:11'),
(437, 1, 'create', 'orders', 'Orden creada OS-2026-00014 desde cotización #34', '200.68.164.7', '2026-09-22 14:19:56'),
(438, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-22 14:27:47'),
(439, 1, 'create', 'quotes', 'Cotización creada #35', '177.239.83.23', '2026-09-22 14:29:17'),
(440, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-22 15:04:38'),
(441, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-22 17:25:46'),
(442, 1, 'update', 'promotions', 'Promoción #1 guardada', '177.239.83.23', '2026-09-22 19:31:40'),
(443, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-22 20:45:30'),
(444, 1, 'create', 'quotes', 'Cotización creada #36', '177.239.83.23', '2026-09-22 20:46:26'),
(445, 1, 'update', 'quotes', 'Estado de cotización actualizado #36 a approved', '177.239.83.23', '2026-09-22 20:46:32'),
(446, 1, 'create', 'orders', 'Orden creada OS-2026-00015 desde cotización #36', '177.239.83.23', '2026-09-22 20:46:45'),
(447, 1, 'create', 'payments', 'Anticipo registrado para orden #25 por $50.00', '177.239.83.23', '2026-09-22 20:46:57'),
(448, 1, 'update', 'production', 'Etapa actualizada para orden #25', '177.239.83.23', '2026-09-22 20:47:18'),
(449, 1, 'update', 'production', 'Etapa actualizada para orden #25', '177.239.83.23', '2026-09-22 20:47:20'),
(450, 1, 'update', 'production', 'Etapa actualizada para orden #25', '177.239.83.23', '2026-09-22 20:47:23'),
(451, 1, 'update', 'production', 'Etapa actualizada para orden #25', '177.239.83.23', '2026-09-22 20:47:26'),
(452, 1, 'update', 'production', 'Etapa actualizada para orden #25', '177.239.83.23', '2026-09-22 20:47:30'),
(453, 1, 'update', 'production', 'Etapa actualizada para orden #25', '177.239.83.23', '2026-09-22 20:47:34'),
(454, 1, 'update', 'production', 'Etapa actualizada para orden #25', '177.239.83.23', '2026-09-22 20:47:36'),
(455, 1, 'create', 'payments', 'Pago registrado #13', '177.239.83.23', '2026-09-22 20:48:15'),
(456, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-23 08:32:46'),
(457, 1, 'update', 'production', 'Etapa actualizada para orden #11', '177.239.83.23', '2026-09-23 08:33:25'),
(458, 1, 'update', 'production', 'Etapa actualizada para orden #11', '177.239.83.23', '2026-09-23 08:33:29'),
(459, 1, 'update', 'production', 'Etapa actualizada para orden #11', '177.239.83.23', '2026-09-23 08:33:32'),
(460, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.33', '2026-09-23 09:01:04'),
(461, 1, 'create', 'quotes', 'Cotización creada #37', '200.68.164.33', '2026-09-23 09:06:41'),
(462, 1, 'update', 'quotes', 'Estado de cotización actualizado #37 a approved', '200.68.164.33', '2026-09-23 09:06:52'),
(463, 1, 'create', 'orders', 'Orden creada OS-2026-00016 desde cotización #37', '200.68.164.33', '2026-09-23 09:07:11'),
(464, 1, 'create', 'orders', 'Archivo agregado a orden #26', '200.68.164.33', '2026-09-23 09:08:34'),
(465, 1, 'update', 'production', 'Etapa actualizada para orden #24', '177.239.83.23', '2026-09-23 09:15:17'),
(466, 1, 'update', 'production', 'Etapa actualizada para orden #24', '177.239.83.23', '2026-09-23 09:15:20'),
(467, 1, 'update', 'production', 'Etapa actualizada para orden #24', '177.239.83.23', '2026-09-23 09:15:22'),
(468, 1, 'update', 'production', 'Etapa actualizada para orden #24', '177.239.83.23', '2026-09-23 09:15:24'),
(469, 1, 'update', 'production', 'Etapa actualizada para orden #24', '177.239.83.23', '2026-09-23 09:16:38'),
(470, 1, 'update', 'production', 'Etapa actualizada para orden #18', '177.239.83.23', '2026-09-23 09:16:49'),
(471, 1, 'update', 'production', 'Etapa actualizada para orden #18', '177.239.83.23', '2026-09-23 09:16:52'),
(472, 1, 'update', 'production', 'Etapa actualizada para orden #18', '177.239.83.23', '2026-09-23 09:16:54'),
(473, 1, 'update', 'production', 'Etapa actualizada para orden #18', '177.239.83.23', '2026-09-23 09:16:57'),
(474, 1, 'update', 'production', 'Etapa actualizada para orden #16', '177.239.83.23', '2026-09-23 09:17:14'),
(475, 1, 'update', 'production', 'Etapa actualizada para orden #16', '177.239.83.23', '2026-09-23 09:17:16'),
(476, 1, 'update', 'production', 'Etapa actualizada para orden #16', '177.239.83.23', '2026-09-23 09:17:17'),
(477, 1, 'update', 'production', 'Etapa actualizada para orden #16', '177.239.83.23', '2026-09-23 09:17:21'),
(478, 1, 'update', 'production', 'Etapa actualizada para orden #18', '177.239.83.23', '2026-09-23 09:18:21'),
(479, 1, 'update', 'production', 'Etapa actualizada para orden #23', '177.239.83.23', '2026-09-23 09:19:14'),
(480, 1, 'update', 'production', 'Etapa actualizada para orden #22', '177.239.83.23', '2026-09-23 09:20:07'),
(481, 1, 'update', 'production', 'Etapa actualizada para orden #22', '177.239.83.23', '2026-09-23 09:20:11'),
(482, 1, 'update', 'production', 'Etapa actualizada para orden #26', '177.239.83.23', '2026-09-23 09:21:05'),
(483, 1, 'update', 'production', 'Etapa actualizada para orden #26', '177.239.83.23', '2026-09-23 09:21:12'),
(484, 1, 'update', 'production', 'Etapa actualizada para orden #26', '177.239.83.23', '2026-09-23 09:21:16'),
(485, 1, 'update', 'production', 'Etapa actualizada para orden #22', '177.239.83.23', '2026-09-23 09:22:15'),
(486, 1, 'update', 'production', 'Etapa actualizada para orden #21', '177.239.83.23', '2026-09-23 09:22:23'),
(487, 1, 'update', 'quotes', 'Estado de cotización actualizado #35 a approved', '200.68.165.22', '2026-09-23 09:57:45'),
(488, 1, 'create', 'orders', 'Orden creada OS-2026-00017 desde cotización #35', '200.68.165.22', '2026-09-23 09:58:04'),
(489, 1, 'create', 'payments', 'Anticipo registrado para orden #27 por $4550.00', '200.68.165.22', '2026-09-23 09:58:50'),
(490, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-23 10:07:06'),
(491, 1, 'update', 'production', 'Etapa actualizada para orden #27', '177.239.83.23', '2026-09-23 10:07:47'),
(492, 1, 'update', 'production', 'Etapa actualizada para orden #27', '177.239.83.23', '2026-09-23 10:07:50'),
(493, 1, 'login', 'auth', 'Inicio de sesión', '200.68.165.22', '2026-09-23 10:36:56'),
(494, 1, 'create', 'customers', 'Cliente #1271 creado', '200.68.165.22', '2026-09-23 10:42:49'),
(495, 1, 'create', 'quotes', 'Cotización creada #38', '200.68.165.22', '2026-09-23 10:44:17'),
(496, 1, 'update', 'quotes', 'Estado de cotización actualizado #38 a sent', '200.68.165.22', '2026-09-23 10:44:32'),
(497, 1, 'update', 'quotes', 'Estado de cotización actualizado #38 a approved', '200.68.165.22', '2026-09-23 10:44:56'),
(498, 1, 'create', 'orders', 'Orden creada OS-2026-00018 desde cotización #38', '200.68.165.22', '2026-09-23 10:46:01'),
(499, 1, 'create', 'orders', 'Archivo agregado a orden #28', '200.68.165.22', '2026-09-23 10:46:24'),
(500, 1, 'create', 'orders', 'Archivo agregado a orden #28', '200.68.165.22', '2026-09-23 10:46:43'),
(501, 1, 'update', 'production', 'Etapa actualizada para orden #28', '177.239.83.23', '2026-09-23 10:52:08'),
(502, 1, 'update', 'quotes', 'Cotización actualizada #33', '200.68.165.22', '2026-09-23 11:08:24'),
(503, 1, 'update', 'quotes', 'Estado de cotización actualizado #33 a approved', '200.68.165.22', '2026-09-23 11:08:34'),
(504, 1, 'create', 'orders', 'Orden creada OS-2026-00019 desde cotización #33', '200.68.165.22', '2026-09-23 11:08:54'),
(505, 1, 'create', 'orders', 'Archivo agregado a orden #29', '200.68.165.22', '2026-09-23 11:09:59'),
(506, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-23 12:38:17'),
(507, 1, 'login', 'auth', 'Inicio de sesión', '200.68.165.212', '2026-09-23 13:46:19'),
(508, 1, 'update', 'production', 'Etapa actualizada para orden #23', '200.68.165.212', '2026-09-23 13:49:28'),
(509, 1, 'create', 'payments', 'Anticipo registrado para orden #28 por $280.00', '200.68.165.212', '2026-09-23 14:01:48'),
(510, 1, 'login', 'auth', 'Inicio de sesión', '200.68.165.212', '2026-09-23 14:02:31'),
(511, 1, 'create', 'orders', 'Archivo agregado a orden #28', '200.68.165.212', '2026-09-23 14:04:41'),
(512, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-23 14:44:27'),
(513, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-23 15:50:30'),
(514, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-23 17:42:52'),
(515, 1, 'update', 'production', 'Etapa actualizada para orden #29', '177.239.83.23', '2026-09-23 17:43:12'),
(516, 1, 'update', 'quotes', 'Cotización actualizada #33', '177.239.83.23', '2026-09-23 17:44:11'),
(517, 1, 'update', 'production', 'Etapa actualizada para orden #29', '177.239.83.23', '2026-09-23 17:48:15'),
(518, 1, 'update', 'production', 'Etapa actualizada para orden #29', '177.239.83.23', '2026-09-23 17:48:17'),
(519, 1, 'update', 'production', 'Etapa actualizada para orden #29', '177.239.83.23', '2026-09-23 17:48:21'),
(520, 1, 'update', 'production', 'Etapa actualizada para orden #29', '177.239.83.23', '2026-09-23 17:48:23'),
(521, 1, 'update', 'production', 'Etapa actualizada para orden #29', '177.239.83.23', '2026-09-23 17:48:25'),
(522, 1, 'update', 'quotes', 'Cotización actualizada #33', '177.239.83.23', '2026-09-23 17:48:51'),
(523, 1, 'update', 'production', 'Etapa actualizada para orden #24', '177.239.83.23', '2026-09-23 18:15:48'),
(524, 1, 'update', 'production', 'Etapa actualizada para orden #24', '177.239.83.23', '2026-09-23 18:15:52'),
(525, 1, 'update', 'production', 'Etapa actualizada para orden #24', '177.239.83.23', '2026-09-23 18:15:54'),
(526, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-23 18:45:34'),
(527, 1, 'update', 'production', 'Etapa actualizada para orden #28', '177.239.83.23', '2026-09-23 18:46:30'),
(528, 1, 'update', 'production', 'Etapa actualizada para orden #28', '177.239.83.23', '2026-09-23 18:46:34'),
(529, 1, 'update', 'production', 'Etapa actualizada para orden #28', '177.239.83.23', '2026-09-23 18:46:36'),
(530, 1, 'update', 'production', 'Etapa actualizada para orden #28', '177.239.83.23', '2026-09-23 18:46:40'),
(531, 1, 'update', 'quotes', 'Estado de cotización actualizado #33 a approved', '177.239.83.23', '2026-09-23 19:37:55'),
(532, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-23 19:55:17'),
(533, 1, 'create', 'quotes', 'Cotización creada #39', '177.239.83.23', '2026-09-23 20:02:07'),
(534, 1, 'update', 'quotes', 'Estado de cotización actualizado #39 a approved', '177.239.83.23', '2026-09-23 20:02:22'),
(535, 1, 'create', 'orders', 'Orden creada OS-2026-00020 desde cotización #39', '177.239.83.23', '2026-09-23 20:22:53'),
(536, 1, 'update', 'production', 'Etapa actualizada para orden #30', '177.239.83.23', '2026-09-23 20:23:05'),
(537, 1, 'update', 'payments', 'Pago actualizado #15', '177.239.83.23', '2026-09-23 20:30:20'),
(538, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-23 21:37:43'),
(539, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-23 23:04:05'),
(540, 1, 'update', 'production', 'Etapa actualizada para orden #30', '177.239.83.23', '2026-09-23 23:46:47'),
(541, 1, 'login', 'auth', 'Inicio de sesión', '200.68.165.98', '2026-09-24 00:47:19'),
(542, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-24 07:17:11'),
(543, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.66', '2026-09-24 09:53:03'),
(544, 1, 'create', 'customers', 'Cliente #1272 creado', '200.68.164.66', '2026-09-24 09:55:14'),
(545, 1, 'create', 'quotes', 'Cotización creada #40', '200.68.164.66', '2026-09-24 09:58:55'),
(546, 1, 'update', 'quotes', 'Estado de cotización actualizado #40 a approved', '200.68.164.66', '2026-09-24 09:59:48'),
(547, 1, 'create', 'orders', 'Orden creada OS-2026-00021 desde cotización #40', '200.68.164.66', '2026-09-24 10:00:07'),
(548, 1, 'create', 'orders', 'Archivo agregado a orden #31', '200.68.164.66', '2026-09-24 10:00:26'),
(549, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-24 10:05:20'),
(550, 1, 'update', 'production', 'Etapa actualizada para orden #31', '177.239.83.23', '2026-09-24 10:13:18'),
(551, 1, 'create', 'payments', 'Anticipo registrado para orden #31 por $150.00', '200.68.164.66', '2026-09-24 10:14:34'),
(552, 1, 'update', 'quotes', 'Cotización actualizada #39', '177.239.83.23', '2026-09-24 10:36:10'),
(553, 1, 'create', 'payments', 'Anticipo registrado para orden #30 por $850.00', '177.239.83.23', '2026-09-24 10:42:26'),
(554, 1, 'update', 'production', 'Etapa actualizada para orden #30', '177.239.83.23', '2026-09-24 10:42:53'),
(555, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.66', '2026-09-24 10:44:28'),
(556, 1, 'create', 'customers', 'Cliente #1273 creado', '200.68.164.66', '2026-09-24 10:53:40'),
(557, 1, 'create', 'quotes', 'Cotización creada #41', '200.68.164.66', '2026-09-24 10:59:02'),
(558, 1, 'update', 'quotes', 'Estado de cotización actualizado #41 a approved', '200.68.164.66', '2026-09-24 11:00:05'),
(559, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-24 11:16:15'),
(560, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.66', '2026-09-24 11:48:55'),
(561, 1, 'create', 'orders', 'Archivo agregado a orden #30', '200.68.164.66', '2026-09-24 11:51:00'),
(562, 1, 'create', 'orders', 'Archivo agregado a orden #30', '200.68.164.66', '2026-09-24 11:51:35'),
(563, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-24 12:28:58'),
(564, 1, 'login', 'auth', 'Inicio de sesión', '2806:108e:d:e4e0:9805:1f10:5b4f:7a91', '2026-09-24 12:34:53'),
(565, 1, 'create', 'quotes', 'Cotización creada #42', '2806:108e:d:e4e0:9805:1f10:5b4f:7a91', '2026-09-24 12:35:53'),
(566, 1, 'update', 'quotes', 'Estado de cotización actualizado #42 a approved', '2806:108e:d:e4e0:9805:1f10:5b4f:7a91', '2026-09-24 12:36:02'),
(567, 1, 'create', 'orders', 'Orden creada OS-2026-00022 desde cotización #42', '2806:108e:d:e4e0:9805:1f10:5b4f:7a91', '2026-09-24 12:36:11'),
(568, 1, 'create', 'orders', 'Archivo agregado a orden #32', '2806:108e:d:e4e0:9805:1f10:5b4f:7a91', '2026-09-24 12:36:34'),
(569, 1, 'create', 'orders', 'Archivo agregado a orden #32', '2806:108e:d:e4e0:9805:1f10:5b4f:7a91', '2026-09-24 12:37:01'),
(570, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.66', '2026-09-24 12:48:43'),
(571, 1, 'create', 'orders', 'Archivo agregado a orden #32', '200.68.164.66', '2026-09-24 12:49:56'),
(572, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-24 16:14:23'),
(573, 1, 'create', 'payments', 'Anticipo registrado para orden #32 por $780.00', '177.239.83.23', '2026-09-24 16:15:27'),
(574, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-24 16:35:52'),
(575, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-24 17:34:00'),
(576, 1, 'create', 'quotes', 'Cotización creada #43', '177.239.83.23', '2026-09-24 17:37:06'),
(577, 1, 'update', 'quotes', 'Estado de cotización actualizado #43 a approved', '177.239.83.23', '2026-09-24 17:37:14'),
(578, 1, 'create', 'orders', 'Orden creada OS-2026-00023 desde cotización #43', '177.239.83.23', '2026-09-24 17:37:36'),
(579, 1, 'create', 'orders', 'Archivo agregado a orden #33', '177.239.83.23', '2026-09-24 17:38:20'),
(580, 1, 'create', 'orders', 'Archivo agregado a orden #33', '177.239.83.23', '2026-09-24 17:38:35'),
(581, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-24 18:12:04'),
(582, 1, 'create', 'customers', 'Cliente #1274 creado', '177.239.83.23', '2026-09-24 18:20:56'),
(583, 1, 'create', 'quotes', 'Cotización creada #44', '177.239.83.23', '2026-09-24 18:23:55'),
(584, 1, 'update', 'quotes', 'Estado de cotización actualizado #44 a sent', '177.239.83.23', '2026-09-24 18:24:30'),
(585, 1, 'update', 'quotes', 'Estado de cotización actualizado #41 a approved', '177.239.83.23', '2026-09-24 18:27:41'),
(586, 1, 'create', 'orders', 'Orden creada OS-2026-00024 desde cotización #41', '177.239.83.23', '2026-09-24 18:28:30'),
(587, 1, 'create', 'orders', 'Archivo agregado a orden #34', '177.239.83.23', '2026-09-24 18:30:53'),
(588, 1, 'delete', 'orders', 'Foto eliminada de orden #34', '177.239.83.23', '2026-09-24 18:31:27'),
(589, 1, 'create', 'orders', 'Archivo agregado a orden #34', '177.239.83.23', '2026-09-24 18:31:40'),
(590, 1, 'create', 'orders', 'Archivo agregado a orden #34', '177.239.83.23', '2026-09-24 18:31:57'),
(591, 1, 'create', 'orders', 'Archivo agregado a orden #34', '177.239.83.23', '2026-09-24 18:32:13'),
(592, 1, 'create', 'payments', 'Anticipo registrado para orden #34 por $240.00', '177.239.83.23', '2026-09-24 18:32:49'),
(593, 1, 'create', 'payments', 'Anticipo registrado para orden #28 por $245.00', '177.239.83.23', '2026-09-24 18:33:38'),
(594, 1, 'create', 'payments', 'Anticipo registrado para orden #24 por $390.00', '177.239.83.23', '2026-09-24 18:34:55'),
(595, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-24 20:55:14'),
(596, 1, 'create', 'payments', 'Anticipo registrado para orden #18 por $7516.80', '177.239.83.23', '2026-09-24 21:07:45'),
(597, 1, 'create', 'quotes', 'Cotización creada #45', '177.239.83.23', '2026-09-24 21:15:24'),
(598, 1, 'update', 'customers', 'Cliente #1209 actualizado', '177.239.83.23', '2026-09-24 21:31:43'),
(599, 1, 'update', 'quotes', 'Cotización actualizada #45', '177.239.83.23', '2026-09-24 21:32:14'),
(600, 1, 'update', 'production', 'Etapa actualizada para orden #34', '177.239.83.23', '2026-09-24 21:56:12'),
(601, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-24 23:39:14'),
(602, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-25 00:19:11'),
(603, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-25 03:30:16'),
(604, 1, 'update', 'production', 'Etapa actualizada para orden #30', '177.239.83.23', '2026-09-25 03:57:14'),
(605, 1, 'update', 'production', 'Etapa actualizada para orden #30', '177.239.83.23', '2026-09-25 03:58:04'),
(606, 1, 'create', 'customers', 'Cliente #1275 creado', '177.239.83.23', '2026-09-25 04:49:56'),
(607, 1, 'create', 'quotes', 'Cotización creada #46', '177.239.83.23', '2026-09-25 04:50:42'),
(608, 1, 'update', 'quotes', 'Estado de cotización actualizado #46 a approved', '177.239.83.23', '2026-09-25 04:50:45'),
(609, 1, 'create', 'orders', 'Orden creada OS-2026-00025 desde cotización #46', '177.239.83.23', '2026-09-25 04:51:18'),
(610, 1, 'update', 'quotes', 'Cotización actualizada #46', '177.239.83.23', '2026-09-25 04:51:44'),
(611, 1, 'update', 'production', 'Etapa actualizada para orden #35', '177.239.83.23', '2026-09-25 04:51:56'),
(612, 1, 'update', 'production', 'Etapa actualizada para orden #35', '177.239.83.23', '2026-09-25 04:51:59'),
(613, 1, 'update', 'production', 'Etapa actualizada para orden #35', '177.239.83.23', '2026-09-25 04:52:01'),
(614, 1, 'update', 'production', 'Etapa actualizada para orden #35', '177.239.83.23', '2026-09-25 04:52:03'),
(615, 1, 'update', 'production', 'Etapa actualizada para orden #35', '177.239.83.23', '2026-09-25 04:52:06'),
(616, 1, 'update', 'production', 'Etapa actualizada para orden #35', '177.239.83.23', '2026-09-25 04:52:08'),
(617, 1, 'create', 'payments', 'Anticipo registrado para orden #35 por $160.00', '177.239.83.23', '2026-09-25 04:54:46'),
(618, 1, 'update', 'orders', 'Comprobante de pago revisado para orden #35', '177.239.83.23', '2026-09-25 05:08:47'),
(619, 1, 'update', 'orders', 'Comprobante de pago revisado para orden #35', '177.239.83.23', '2026-09-25 05:08:48'),
(620, 1, 'update', 'orders', 'Comprobante de pago revisado para orden #35', '177.239.83.23', '2026-09-25 05:08:51'),
(621, 1, 'update', 'orders', 'Comprobante de pago revisado para orden #35', '177.239.83.23', '2026-09-25 05:08:58'),
(622, 1, 'create', 'payments', 'Pago registrado #24', '177.239.83.23', '2026-09-25 05:09:16'),
(623, 1, 'update', 'orders', 'Comprobante de pago revisado para orden #35', '177.239.83.23', '2026-09-25 05:09:46'),
(624, 1, 'update', 'orders', 'Comprobante de pago revisado para orden #35', '177.239.83.23', '2026-09-25 05:09:48'),
(625, 1, 'update', 'orders', 'Comprobante de pago revisado para orden #35', '177.239.83.23', '2026-09-25 05:09:53'),
(626, 1, 'update', 'orders', 'Comprobante de pago revisado para orden #35', '177.239.83.23', '2026-09-25 05:10:06'),
(627, 1, 'update', 'orders', 'Comprobante de pago revisado para orden #35', '177.239.83.23', '2026-09-25 05:10:09'),
(628, 1, 'update', 'orders', 'Comprobante de pago revisado para orden #35', '177.239.83.23', '2026-09-25 05:11:36'),
(629, 1, 'update', 'orders', 'Comprobante de pago revisado para orden #35', '177.239.83.23', '2026-09-25 05:11:39'),
(630, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-25 07:41:34'),
(631, 1, 'update', 'production', 'Etapa actualizada para orden #35', '177.239.83.23', '2026-09-25 07:41:43'),
(632, 1, 'create', 'customers', 'Cliente #1276 creado', '177.239.83.23', '2026-09-25 07:42:39'),
(633, 1, 'create', 'quotes', 'Cotización creada #47', '177.239.83.23', '2026-09-25 07:44:10'),
(634, 1, 'update', 'quotes', 'Cotización actualizada #47', '177.239.83.23', '2026-09-25 07:44:20'),
(635, 1, 'update', 'quotes', 'Estado de cotización actualizado #47 a approved', '177.239.83.23', '2026-09-25 07:44:28'),
(636, 1, 'create', 'orders', 'Orden creada OS-2026-00026 desde cotización #47', '177.239.83.23', '2026-09-25 07:45:03'),
(637, 1, 'update', 'production', 'Etapa actualizada para orden #36', '177.239.83.23', '2026-09-25 07:45:19'),
(638, 1, 'update', 'production', 'Etapa actualizada para orden #36', '177.239.83.23', '2026-09-25 07:45:22'),
(639, 1, 'update', 'production', 'Etapa actualizada para orden #36', '177.239.83.23', '2026-09-25 07:45:25'),
(640, 1, 'update', 'production', 'Etapa actualizada para orden #36', '177.239.83.23', '2026-09-25 07:45:27'),
(641, 1, 'update', 'production', 'Etapa actualizada para orden #36', '177.239.83.23', '2026-09-25 07:45:29'),
(642, 1, 'create', 'payments', 'Anticipo registrado para orden #36 por $880.00', '177.239.83.23', '2026-09-25 08:06:30'),
(643, 1, 'update', 'production', 'Etapa actualizada para orden #36', '177.239.83.23', '2026-09-25 08:07:16'),
(644, 1, 'create', 'customers', 'Cliente #1277 creado', '177.239.83.23', '2026-09-25 08:09:36'),
(645, 1, 'create', 'quotes', 'Cotización creada #48', '177.239.83.23', '2026-09-25 08:14:22'),
(646, 1, 'update', 'quotes', 'Estado de cotización actualizado #48 a sent', '177.239.83.23', '2026-09-25 08:14:26'),
(647, 1, 'update', 'quotes', 'Estado de cotización actualizado #48 a approved', '177.239.83.23', '2026-09-25 08:15:20'),
(648, 1, 'create', 'orders', 'Orden creada OS-2026-00027 desde cotización #48', '177.239.83.23', '2026-09-25 08:15:26'),
(649, 1, 'create', 'payments', 'Anticipo registrado para orden #37 por $240.00', '177.239.83.23', '2026-09-25 08:24:54'),
(650, 1, 'update', 'orders', 'Comprobante de pago revisado para orden #37', '177.239.83.23', '2026-09-25 08:25:01'),
(651, 1, 'update', 'production', 'Etapa actualizada para orden #37', '177.239.83.23', '2026-09-25 08:26:46'),
(652, 1, 'update', 'production', 'Etapa actualizada para orden #37', '177.239.83.23', '2026-09-25 08:26:49'),
(653, 1, 'update', 'production', 'Etapa actualizada para orden #37', '177.239.83.23', '2026-09-25 08:26:51'),
(654, 1, 'update', 'production', 'Etapa actualizada para orden #37', '177.239.83.23', '2026-09-25 08:26:54'),
(655, 1, 'update', 'production', 'Etapa actualizada para orden #37', '177.239.83.23', '2026-09-25 08:26:56'),
(656, 1, 'update', 'production', 'Etapa actualizada para orden #36', '177.239.83.23', '2026-09-25 08:32:37'),
(657, 1, 'update', 'production', 'Etapa actualizada para orden #37', '177.239.83.23', '2026-09-25 08:32:49'),
(658, 1, 'update', 'production', 'Etapa actualizada para orden #37', '177.239.83.23', '2026-09-25 08:42:40'),
(659, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-25 09:59:14'),
(660, 1, 'create', 'customers', 'Cliente #1278 creado', '177.239.83.23', '2026-09-25 09:59:39'),
(661, 1, 'create', 'customers', 'Cliente #1279 creado', '177.239.83.23', '2026-09-25 10:00:02'),
(662, 1, 'create', 'quotes', 'Cotización creada #49', '177.239.83.23', '2026-09-25 10:00:16'),
(663, 1, 'update', 'quotes', 'Estado de cotización actualizado #49 a approved', '177.239.83.23', '2026-09-25 10:00:19'),
(664, 1, 'create', 'orders', 'Orden creada OS-2026-00028 desde cotización #49', '177.239.83.23', '2026-09-25 10:22:29'),
(665, 1, 'update', 'production', 'Etapa actualizada para orden #38', '177.239.83.23', '2026-09-25 10:22:57'),
(666, 1, 'update', 'production', 'Etapa actualizada para orden #38', '177.239.83.23', '2026-09-25 10:23:00'),
(667, 1, 'update', 'production', 'Etapa actualizada para orden #38', '177.239.83.23', '2026-09-25 10:23:03'),
(668, 1, 'update', 'production', 'Etapa actualizada para orden #38', '177.239.83.23', '2026-09-25 10:23:05'),
(669, 1, 'update', 'production', 'Etapa actualizada para orden #38', '177.239.83.23', '2026-09-25 10:23:07'),
(670, 1, 'update', 'production', 'Etapa actualizada para orden #38', '177.239.83.23', '2026-09-25 10:23:11'),
(671, 1, 'update', 'production', 'Etapa actualizada para orden #38', '177.239.83.23', '2026-09-25 10:23:13'),
(672, 1, 'create', 'payments', 'Anticipo registrado para orden #38 por $320.00', '177.239.83.23', '2026-09-25 10:46:30');
INSERT INTO `cp_activity_log` (`id`, `user_id`, `action`, `module`, `description`, `ip_address`, `created_at`) VALUES
(673, 1, 'update', 'orders', 'Comprobante de pago revisado para orden #38', '177.239.83.23', '2026-09-25 10:46:38'),
(674, 1, 'login', 'auth', 'Inicio de sesión', '200.68.165.28', '2026-09-25 11:01:41'),
(675, 1, 'update', 'production', 'Etapa actualizada para orden #30', '177.239.83.23', '2026-09-25 11:19:05'),
(676, 1, 'update', 'quotes', 'Cotización actualizada #33', '2806:108e:d:eb6b:12b3:4277:5eb0:a629', '2026-09-25 11:19:27'),
(677, 1, 'update', 'quotes', 'Estado de cotización actualizado #33 a approved', '2806:108e:d:eb6b:12b3:4277:5eb0:a629', '2026-09-25 11:20:29'),
(678, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-25 11:27:27'),
(679, 1, 'update', 'production', 'Etapa actualizada para orden #29', '177.239.83.23', '2026-09-25 11:29:18'),
(680, 1, 'update', 'production', 'Etapa actualizada para orden #21', '177.239.83.23', '2026-09-25 11:30:11'),
(681, 1, 'update', 'production', 'Etapa actualizada para orden #21', '177.239.83.23', '2026-09-25 11:30:56'),
(682, 1, 'update', 'production', 'Etapa actualizada para orden #26', '177.239.83.23', '2026-09-25 12:02:56'),
(683, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-25 12:03:55'),
(684, 1, 'create', 'quotes', 'Cotización creada #50', '2806:108e:d:eb6b:26a8:a905:28e4:4375', '2026-09-25 12:14:52'),
(685, 1, 'update', 'quotes', 'Estado de cotización actualizado #50 a approved', '2806:108e:d:eb6b:26a8:a905:28e4:4375', '2026-09-25 12:15:02'),
(686, 1, 'update', 'production', 'Etapa actualizada para orden #26', '177.239.83.23', '2026-09-25 12:32:43'),
(687, 1, 'update', 'quotes', 'Cotización actualizada #31', '200.68.165.16', '2026-09-25 13:22:17'),
(688, 1, 'update', 'quotes', 'Cotización actualizada #31', '200.68.165.16', '2026-09-25 13:24:49'),
(689, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-25 15:18:07'),
(690, 1, 'update', 'production', 'Etapa actualizada para orden #17', '177.239.83.23', '2026-09-25 15:18:23'),
(691, 1, 'update', 'production', 'Etapa actualizada para orden #17', '177.239.83.23', '2026-09-25 15:18:26'),
(692, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.46', '2026-09-25 17:02:27'),
(693, 1, 'create', 'customers', 'Cliente #1280 creado', '200.68.164.46', '2026-09-25 17:03:55'),
(694, 1, 'create', 'quotes', 'Cotización creada #51', '200.68.164.46', '2026-09-25 17:08:33'),
(695, 1, 'update', 'quotes', 'Estado de cotización actualizado #51 a approved', '200.68.164.46', '2026-09-25 17:09:29'),
(696, 1, 'update', 'quotes', 'Cotización actualizada #51', '200.68.164.46', '2026-09-25 17:11:41'),
(697, 1, 'update', 'quotes', 'Cotización actualizada #51', '200.68.164.46', '2026-09-25 17:15:17'),
(698, 1, 'update', 'quotes', 'Cotización actualizada #51', '200.68.164.46', '2026-09-25 17:19:07'),
(699, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-25 18:47:03'),
(700, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-25 19:24:04'),
(701, 1, 'create', 'customers', 'Cliente #1281 creado', '177.239.83.23', '2026-09-25 19:25:07'),
(702, 1, 'update', 'customers', 'Cliente #1281 actualizado', '177.239.83.23', '2026-09-25 19:26:50'),
(703, 1, 'create', 'quotes', 'Cotización creada #52', '177.239.83.23', '2026-09-25 19:28:54'),
(704, 1, 'update', 'quotes', 'Cotización actualizada #52', '177.239.83.23', '2026-09-25 19:31:07'),
(705, 1, 'create', 'customers', 'Cliente #1282 creado', '177.239.83.23', '2026-09-25 19:41:15'),
(706, 1, 'update', 'customers', 'Cliente #1282 actualizado', '177.239.83.23', '2026-09-25 19:42:18'),
(707, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-25 19:42:56'),
(708, 1, 'create', 'quotes', 'Cotización creada #53', '177.239.83.23', '2026-09-25 19:53:45'),
(709, 1, 'update', 'quotes', 'Cotización actualizada #53', '177.239.83.23', '2026-09-25 19:58:35'),
(710, 1, 'update', 'quotes', 'Cotización actualizada #53', '177.239.83.23', '2026-09-25 20:00:27'),
(711, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-25 20:17:35'),
(712, 1, 'create', 'quotes', 'Cotización creada #54', '177.239.83.23', '2026-09-25 20:36:20'),
(713, 1, 'update', 'quotes', 'Estado de cotización actualizado #54 a approved', '177.239.83.23', '2026-09-25 20:36:49'),
(714, 1, 'create', 'orders', 'Orden creada OS-2026-00029 desde cotización #54', '177.239.83.23', '2026-09-25 20:37:16'),
(715, 1, 'create', 'orders', 'Archivo agregado a orden #39', '177.239.83.23', '2026-09-25 20:39:53'),
(716, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-25 21:08:19'),
(717, 1, 'create', 'orders', 'Archivo agregado a orden #39', '177.239.83.23', '2026-09-25 21:14:27'),
(718, 1, 'create', 'payments', 'Anticipo registrado para orden #39 por $200.00', '177.239.83.23', '2026-09-25 21:14:47'),
(719, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-25 22:53:50'),
(720, 1, 'update', 'facebook', 'Configuración de publicación automática de Facebook actualizada', '177.239.83.23', '2026-09-25 22:54:54'),
(721, 1, 'update', 'facebook', 'Configuración de publicación automática de Facebook actualizada', '177.239.83.23', '2026-09-25 22:56:21'),
(722, 1, 'update', 'facebook', 'Configuración de publicación automática de Facebook actualizada', '177.239.83.23', '2026-09-25 22:59:25'),
(723, 1, 'update', 'promotions', 'Promoción #3 guardada', '177.239.83.23', '2026-09-25 22:59:45'),
(724, 1, 'update', 'facebook', 'Configuración de publicación automática de Facebook actualizada', '177.239.83.23', '2026-09-25 23:16:23'),
(725, 1, 'update', 'promotions', 'Promoción #3 guardada', '177.239.83.23', '2026-09-25 23:17:21'),
(726, 1, 'update', 'facebook', 'Configuración de publicación automática de Facebook actualizada', '177.239.83.23', '2026-09-25 23:36:48'),
(727, 1, 'update', 'facebook', 'Configuración de publicación automática de Facebook actualizada', '177.239.83.23', '2026-09-25 23:37:16'),
(728, 1, 'update', 'facebook', 'Configuración de publicación automática de Facebook actualizada', '177.239.83.23', '2026-09-25 23:42:01'),
(729, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-26 02:38:45'),
(730, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-26 03:15:26'),
(731, 1, 'create', 'print_pricing', 'Nueva tarifa de impresión', '177.239.83.23', '2026-09-26 03:58:47'),
(732, 1, 'create', 'print_pricing', 'Nueva tarifa de impresión', '177.239.83.23', '2026-09-26 03:59:55'),
(733, 1, 'update', 'print_pricing', 'Catálogo de impresión actualizado', '177.239.83.23', '2026-09-26 04:20:55'),
(734, 1, 'create', 'print_pricing', 'Tarifa de impresión guardada', '177.239.83.23', '2026-09-26 04:57:53'),
(735, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-26 08:55:46'),
(736, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-26 10:31:32'),
(737, 1, 'update', 'production', 'Etapa actualizada para orden #17', '177.239.83.23', '2026-09-26 10:31:43'),
(738, 1, 'update', 'production', 'Etapa actualizada para orden #33', '177.239.83.23', '2026-09-26 10:34:55'),
(739, 1, 'update', 'production', 'Etapa actualizada para orden #33', '177.239.83.23', '2026-09-26 10:34:58'),
(740, 1, 'update', 'production', 'Etapa actualizada para orden #33', '177.239.83.23', '2026-09-26 10:35:01'),
(741, 1, 'update', 'production', 'Etapa actualizada para orden #33', '177.239.83.23', '2026-09-26 10:35:04'),
(742, 1, 'update', 'production', 'Etapa actualizada para orden #33', '177.239.83.23', '2026-09-26 10:35:06'),
(743, 1, 'update', 'production', 'Etapa actualizada para orden #21', '177.239.83.23', '2026-09-26 10:39:49'),
(744, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-26 16:48:16'),
(745, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-26 17:55:18'),
(746, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-26 20:52:18');

-- --------------------------------------------------------

--
-- Table structure for table `cp_categories`
--

CREATE TABLE `cp_categories` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'product',
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_categories`
--

INSERT INTO `cp_categories` (`id`, `name`, `type`, `enabled`, `sort_order`, `created_at`, `updated_at`) VALUES
(1, 'PLAYERAS', 'product', 1, 0, '2026-09-16 23:58:13', '2026-09-17 00:35:38'),
(3, 'TAZAS', 'product', 1, 0, '2026-09-17 00:34:06', '2026-09-17 00:34:06'),
(4, 'LLAVEROS', 'product', 1, 0, '2026-09-17 00:34:12', '2026-09-17 00:34:12'),
(5, 'YETIS', 'product', 1, 0, '2026-09-17 00:34:18', '2026-09-17 00:34:18'),
(6, 'GRABADO LÁSER', 'product', 1, 0, '2026-09-17 00:34:28', '2026-09-17 00:34:28'),
(7, 'IMPRESIÓN', 'product', 1, 0, '2026-09-17 13:53:07', '2026-09-17 13:53:07'),
(8, 'SELLOS DE GOMA', 'product', 1, 0, '2026-09-22 12:04:20', '2026-09-22 12:04:20');

-- --------------------------------------------------------

--
-- Table structure for table `cp_customers`
--

CREATE TABLE `cp_customers` (
  `id` int(10) UNSIGNED NOT NULL,
  `source_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'local',
  `source_id` int(10) UNSIGNED DEFAULT NULL,
  `name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tax_number` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `city` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zip_code` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT 'MX',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_customers`
--

INSERT INTO `cp_customers` (`id`, `source_type`, `source_id`, `name`, `email`, `tax_number`, `phone`, `address`, `city`, `zip_code`, `state`, `country`, `notes`, `enabled`, `created_at`, `updated_at`) VALUES
(1, 'akaunting', 1, 'LUIS GARDEA', 'Yogardea@outlook.com', 'GARL301182BBM6', '6271074512', 'C Alemania\r\n87', 'Hidalgo del Parral José López Portillo', '33820', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(2, 'akaunting', 6, 'Beatriz Chávez', NULL, NULL, '6271354103', NULL, 'Hidalgo del Parral', '33820', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(3, 'akaunting', 7, 'Itzel Dariana', NULL, NULL, '649 197 3143', 'Col. 20 de Noviembre', 'Guachochi', NULL, 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(4, 'akaunting', 8, 'Leticia Yazmin Salazar serrano', NULL, NULL, '6271171876', NULL, 'Hidalgo del Parral', '33820', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(5, 'akaunting', 9, 'Guadalupe Silva  Rueda', NULL, NULL, '627 111 4191', NULL, 'Hidalgo del Parral', '33820', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(6, 'akaunting', 10, 'CARSO INFRAESTRUCTURA Y CONSTRUCCION', 'mvadillo@condumex.com.mx', 'CIC991214L94', '6142327529', 'CALLE LAGO ZURICH\r\n245 EDIFICIO FRISCO\r\nAMPLIACION GRANADA', 'MIGUEL HIDALGO', '11529', 'CIUDAD DE MEXICO', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(7, 'akaunting', 13, 'Marely Ontiveros', NULL, NULL, '6271774403', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(8, 'akaunting', 14, 'LILIANA ORTIZ', 'ortiz-liliana@hotmail.com', NULL, '5545006497', 'C. SENDERO DE LA ALAMEDA No. 9\r\nCASA 4', 'MEXICO', '52934', 'ESTADO DE MEXICO', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(9, 'akaunting', 15, 'Marisela Mora Moreno', NULL, NULL, '6271509385', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(10, 'akaunting', 16, 'Rodrigo Chávez', NULL, NULL, '6275241520', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(11, 'akaunting', 17, 'Karmin Martìnez', NULL, NULL, '6275177922', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(12, 'akaunting', 18, 'Esc. Prim. María de la Cruz  Profr. Erick', NULL, NULL, '6567870958', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(13, 'akaunting', 19, 'Julia Varela', NULL, NULL, '627 279 6844', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(14, 'akaunting', 20, 'DIANA TORRES', NULL, NULL, '6271038001', NULL, 'HIDALGO DEL PARRAL', '33800', 'CHIHUAHUA', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(15, 'akaunting', 21, 'Clara Hernández', NULL, NULL, '627 150 7728', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(16, 'akaunting', 22, 'Ashley Martínez Rodríguez', NULL, NULL, '6271036390', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(17, 'akaunting', 23, 'Gonzalo Guerra', NULL, NULL, '6271745454', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(18, 'akaunting', 24, 'Benito Carrera', NULL, NULL, '627 114 4291', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(19, 'akaunting', 25, 'Flor', NULL, NULL, '639 147 1965', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(20, 'akaunting', 26, 'Miriam Villarreal', NULL, NULL, '627 133 1966', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(21, 'akaunting', 27, 'Carmen Lugo', NULL, NULL, '6271080194', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(22, 'akaunting', 28, 'Daniela Jiménez', NULL, NULL, '627 116 1150', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(23, 'akaunting', 29, 'Pamela RM MINERIA', NULL, NULL, '627 142 9155', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(24, 'akaunting', 30, 'Enrique Silva', NULL, NULL, '627 133 3310', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(25, 'akaunting', 31, 'Ana de la Cuz', NULL, NULL, '627 121 7220', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(26, 'akaunting', 32, 'Marìa Josè', NULL, NULL, '5545856421', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(27, 'akaunting', 33, 'María José', NULL, NULL, '55 4585 6421', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(28, 'akaunting', 34, 'ESCUELA SEC TEC 31', NULL, NULL, '6141252977', 'Anillo Periférico Luis Donaldo Colosio', 'Hidalgo del Parral', '33880', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(29, 'akaunting', 35, 'Edwin Iván Cervantes', 'edwin.cervantes@radarholding.com', NULL, '5527324354', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(30, 'akaunting', 36, 'Esc. Prim. Josef Solís de Lozoya 2156  Profr. José Luis', NULL, NULL, '6141639871', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(31, 'akaunting', 37, 'Marily Corral Irigoyen', NULL, NULL, '627 135 8100', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(32, 'akaunting', 38, 'Araceli Luna', NULL, NULL, '6271485877', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(33, 'akaunting', 39, 'Lluvia Villalobos', NULL, NULL, '614 494 8008', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(34, 'akaunting', 40, 'MAQUINADOS Y SOLDADURAS INDUSTRIALES MAYEROS S.A. DE C.V.', NULL, NULL, '922 212 4746', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(35, 'akaunting', 41, 'YAREMI VILLALOBOS', 'ventas@colibriprint.com.mx', NULL, '656 777 8597', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(36, 'akaunting', 42, 'MAQUINADOS Y SOLDADURAS INDUMAQUINADOS Y SOLDADURAS INDUSTRIALES MAYEROS S.A. DE C.V.STRIALES MAYEROS S.A. DE C.V.', NULL, NULL, '922 212 4746', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(37, 'akaunting', 43, 'María Guadalupe Bustillos Aguirre', 'mariedtorrs84@gmail.com', 'BUAG841115MCHIZ3', '6271489033', 'Real de Valladolid #7', 'Hidalgo del Parral', '33815', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(38, 'akaunting', 44, 'Esc. Prim. Est. Josefa Solís de Lozoya 2156', NULL, NULL, '6275221771', 'Calle Primera y  Juan Rangel #12\r\nCol. Altavista', 'Hidalgo del Parral, Chih.', '33860', 'Chih.', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(39, 'akaunting', 45, 'Miguel Ángel Rodríguez', NULL, NULL, '6275179105', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(40, 'akaunting', 46, 'Esteicy Barrón López', NULL, NULL, '656 167 3729', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(41, 'akaunting', 47, 'Araceli Barai', NULL, NULL, '6491960804', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(42, 'akaunting', 48, 'María de Jesús Sánchez Baca', NULL, NULL, '6271234990', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(43, 'akaunting', 49, 'Yolanda Monje', NULL, NULL, '627 150 4472', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(44, 'akaunting', 50, 'Alma Villalobos', NULL, NULL, '6566690976', 'Calle Alfareña #10\r\nCol. Centro', 'Parral', NULL, 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(45, 'akaunting', 51, 'Vianney Portillo', NULL, NULL, '6141258583', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(46, 'akaunting', 52, 'Escuela Primaria Felipe Ángeles', NULL, NULL, '656 595 9999', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(47, 'akaunting', 53, 'ELIZABETH TENIENTE', NULL, NULL, '6271159409', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(48, 'akaunting', 54, 'Esc. María de la Cruz Reyes Profr. Erik', NULL, NULL, '6567870958', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(49, 'akaunting', 55, 'Sección 20', NULL, NULL, '6271779282', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(50, 'akaunting', 56, 'Alondra González', NULL, NULL, '6271025569', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(51, 'akaunting', 57, 'Alejandra Meza', NULL, NULL, '6271321620', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(52, 'akaunting', 58, 'Allitzel A. Primero Valenzuela', NULL, NULL, '627 140 0862', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(53, 'akaunting', 59, 'Yaritzel Molina', NULL, NULL, '649 114 6862', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(54, 'akaunting', 60, 'Karmin', NULL, NULL, '627 517 7922', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(55, 'akaunting', 61, 'Daniel Castillo', NULL, NULL, '6271747551', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(56, 'akaunting', 62, 'Jorge Luis Bustillos Aguirre', NULL, NULL, '627 110 2567', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(57, 'akaunting', 63, 'GEOTEST Geotecnia y Supervisión Tècnica S.A. de C.V. Haidee Estefanía Contreras Pérez', NULL, NULL, '2281371713', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(58, 'akaunting', 64, 'A.P.F. J.N. Gabriel García Márquez', NULL, NULL, NULL, 'Municipio de Parral s/n', 'Parral', NULL, 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(59, 'akaunting', 65, 'María Salazar', NULL, NULL, '627 177 2826', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(60, 'akaunting', 66, 'Zulema Baeza', NULL, NULL, '627 144 9467', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(61, 'akaunting', 67, 'Yajaira Flores', NULL, NULL, '614 122 4022', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(62, 'akaunting', 68, 'Raquel Carrera', NULL, NULL, '6271237205', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(63, 'akaunting', 69, 'Eva Villegas', NULL, NULL, '627 122 2934', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(64, 'akaunting', 70, 'Karla Granados', NULL, NULL, '627 103 3929', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(65, 'akaunting', 71, 'Cinthia López', NULL, NULL, '627 142 9218', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(66, 'akaunting', 72, 'Lizbeth Canchola', NULL, NULL, '6271730702', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(67, 'akaunting', 73, 'Raúl Méndez', NULL, NULL, '6271130196', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(68, 'akaunting', 74, 'Yorlett', NULL, NULL, '627 143 2776', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(69, 'akaunting', 75, 'Claudia María Cervantes Villalobos', NULL, NULL, '627 139 5548', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(70, 'akaunting', 76, 'Nicol Valenzuela', 'fred.guillermo@gmail.com', NULL, '6563735317', 'Alemania 87\r\nLOMALINDA', 'Hidalgo del Parral', '33820', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(71, 'akaunting', 77, 'Yanet Chávez', NULL, NULL, '614 495 1415', NULL, 'Hidalgo del Parral', '33800', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(72, 'akaunting', 78, 'Glorisel Madrigal', 'gloriselmadrigal96@gmail.com', NULL, '6271037053', NULL, 'Hidalgo del Parral', NULL, 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(73, 'akaunting', 79, 'Ahylin Gutiérrez', NULL, NULL, '6271736233', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(74, 'akaunting', 80, 'Pepe Pichardo', 'delfin810321@hotmail.com', NULL, '6271506406', NULL, 'Hidalgo del Parral', NULL, 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(75, 'akaunting', 81, 'Flor Hernández', NULL, NULL, '627 131 9486', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(76, 'akaunting', 82, 'SERGIO SALVADOR MARTHA ARREDONDO', NULL, NULL, '6271782236', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(77, 'akaunting', 83, 'Cristina Monarrez', NULL, NULL, '6272790484', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(78, 'akaunting', 84, 'Janeth Monarrez', NULL, NULL, '627 517 6543', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(79, 'akaunting', 85, 'Berny Marquez', NULL, NULL, '627 521 5556', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(80, 'akaunting', 86, 'Cindy Domínguez Alonso', NULL, NULL, '614 444 9463', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(81, 'akaunting', 87, 'Ana Hernández', NULL, NULL, '627 139 3944', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(82, 'akaunting', 88, 'Verónica Madrigal', NULL, NULL, '627 115 1599', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(83, 'akaunting', 89, 'Karla Hernández', NULL, NULL, '627 148 7448', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(84, 'akaunting', 90, 'Sandra Cigarroa Olivas', NULL, NULL, '649 392 9561', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(85, 'akaunting', 91, 'José Amilano', NULL, NULL, '648 132 1566', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(86, 'akaunting', 92, 'Comercializadora de Refacciones y Mantenimiento', NULL, NULL, '627 121 4527', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(87, 'akaunting', 93, 'Yazmin Acosta', NULL, NULL, '6271043317', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(88, 'akaunting', 94, 'Marilu Carrón', NULL, NULL, '871 156 6321', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(89, 'akaunting', 95, 'YAREMI VILLALOBOS', NULL, NULL, '6567778597', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(90, 'akaunting', 96, 'Dora', NULL, NULL, '627 107 964', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(91, 'akaunting', 97, 'Claudia Mesta', NULL, NULL, '627 149 6907', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(92, 'akaunting', 98, 'Eneida Saenz', NULL, NULL, '6271476374', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(93, 'akaunting', 99, 'Gabriela Gardea', NULL, NULL, '627 106 9167', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(94, 'akaunting', 100, 'Angelli Rosas', NULL, NULL, '55 6063 0880', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(95, 'akaunting', 101, 'Mónica Martínez', NULL, NULL, '6271500984', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(96, 'akaunting', 102, 'Mónica Martínez', NULL, NULL, '627 150 0984', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(97, 'akaunting', 103, 'Julia Varela', NULL, NULL, '6272796844', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(98, 'akaunting', 104, 'Guillermo', NULL, NULL, '627 142 1834', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(99, 'akaunting', 105, 'Juan Fernando Ochoa', NULL, NULL, '656 626 5248', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(100, 'akaunting', 106, 'Angélica (Municipio Santa Bárbara)', NULL, NULL, '627 108 4172', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(101, 'akaunting', 107, 'Erika', NULL, NULL, '6271037867', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(102, 'akaunting', 108, 'Erika Samanta Guerrero Guerrero', NULL, NULL, '6271067179 y 6275233654', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(103, 'akaunting', 109, 'Mario Orquiz', NULL, NULL, '6271743497', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(104, 'akaunting', 110, 'Esc. Prim. Fed. Emiliano Zapata', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(105, 'akaunting', 111, 'Ana María Juárez Díaz', 'anamariajuarezdiaz@hotmail.com', NULL, '5518942250', 'Calle 6#106 ED.9 DEP.101 COL. AGRICOLA PANTITLAN DELG.', 'IZTACALCO', '08100', 'Ciudad de México', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(106, 'akaunting', 112, 'Judith Molina', NULL, NULL, '627 173 0714', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(107, 'akaunting', 113, 'Itzel', NULL, NULL, '6181565396', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(108, 'akaunting', 114, 'Berenice', NULL, NULL, '6271027767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(109, 'akaunting', 115, 'Lizbeth Ramos', NULL, NULL, '649 107 6610', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(110, 'akaunting', 116, 'Oscar', NULL, NULL, '6271128688', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(111, 'akaunting', 117, 'Sandra', NULL, NULL, '649 103 1800', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(112, 'akaunting', 118, 'Esc. Prim. Centenario del Ejército Mexicano', NULL, NULL, '6271213207', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(113, 'akaunting', 119, 'Yaneth Reyes', NULL, NULL, '6271211790', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(114, 'akaunting', 120, 'Sandra Cigarroa', NULL, NULL, '6491031800', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(115, 'akaunting', 121, 'Alma', NULL, NULL, '627 112 6118', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(116, 'akaunting', 122, 'Eden Méndez', NULL, NULL, '871 786 2350', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(117, 'akaunting', 123, 'Reyna Balbuena', NULL, NULL, '6271125152', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(118, 'akaunting', 124, 'Mónica Leticia Malanco Gutiérrez', 'lilith_monika@hotmail.com', NULL, '7226480311', 'Ejército de Oriente 123\r\nCol. Héroes del 5 de Mayo', 'Toluca', '5017', 'México', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(119, 'akaunting', 125, 'Mónica Leticia Malanco Gutiérrez', NULL, NULL, '7226480311', 'Ejército de Oriente 123\r\nCol. Héroes del 5 de Mayo', 'Toluca', '50170', 'México', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(120, 'akaunting', 126, 'Guadalupe Chavez', NULL, NULL, '6271105090', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(121, 'akaunting', 127, 'Instituto Bostón Gabriela Gardea', NULL, NULL, '871 568 4148', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(122, 'akaunting', 128, 'Martín Humberto Aguirre Arzola', NULL, NULL, '6271216504', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(123, 'akaunting', 129, 'José Méndez', NULL, NULL, '6144623590', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(124, 'akaunting', 130, 'José Guadalupe Méncez', NULL, NULL, '614 462 3590', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(125, 'akaunting', 131, 'Brenda Ontiveros', NULL, NULL, '6271034334', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(126, 'akaunting', 132, 'Elizabeth Morales', NULL, NULL, '6271064484', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(127, 'akaunting', 133, 'Pao (Bubble Bar)', NULL, NULL, '6271400840', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(128, 'akaunting', 134, 'Edeèn Varela', NULL, NULL, '6271313272', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(129, 'akaunting', 135, 'Angélica Holguín', NULL, NULL, '6291063459', NULL, 'Jiménez', NULL, 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(130, 'akaunting', 136, 'Flor Guzmán', NULL, NULL, '6275171410', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(131, 'akaunting', 137, 'CARLOS GALVAN', 'carlosenriquegg30@gmail.com', NULL, '6271030748', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(132, 'akaunting', 138, 'Carolina Ramírez', NULL, NULL, '6271082626', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(133, 'akaunting', 139, 'Sarah', NULL, NULL, '6271047289', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(134, 'akaunting', 140, 'Movimiento Familiar Cristiano Diocesis Parral', NULL, NULL, '627 104 6620', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(135, 'akaunting', 141, 'Amilcar Nava Bailón', NULL, NULL, '6143343182', 'Calle 20 de noviembre #18\r\nreferencia a un lado de dulcería', 'Parral', NULL, 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(136, 'akaunting', 142, 'Patricia Moreno', NULL, NULL, '6271086591', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(137, 'akaunting', 143, 'Rocio Rubio', 'Shiorubio2424@gmail.com', NULL, '627 113 9802', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(138, 'akaunting', 144, 'Carlos Garcia', NULL, NULL, '627 177 4253', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(139, 'akaunting', 145, 'Soledad Aguirre', NULL, NULL, '627 139 3171', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(140, 'akaunting', 146, 'Carmen Verónica Hernández', NULL, NULL, '6271475545', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(141, 'akaunting', 147, 'Merlisa', NULL, NULL, '8711091892', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(142, 'akaunting', 148, 'Diana Núñez', NULL, NULL, '627 123 1389', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(143, 'akaunting', 149, 'Elizabeth Chávez Del Toro', NULL, NULL, '6271488209', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(144, 'akaunting', 150, 'Marcela Vazque Gomez', NULL, NULL, '6271123525', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(145, 'akaunting', 151, 'Sandra Muñoz', NULL, NULL, '6143634347', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(146, 'akaunting', 152, 'Esc. Prim. Ignacio Allende', 'hugoivanurangaavalos@gmial.com', NULL, '6565858937', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(147, 'akaunting', 153, 'Dania García', NULL, NULL, '6143457138', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(148, 'akaunting', 154, 'Samanta Holguin', NULL, NULL, '627 133 7779', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(149, 'akaunting', 155, 'Claudia María Cervantes', NULL, NULL, '6271395548', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(150, 'akaunting', 156, 'Alejandra Duarte', NULL, NULL, '627 115 7512', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(151, 'akaunting', 157, 'Marily Corral', NULL, NULL, '627 135 8100', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(152, 'akaunting', 158, 'Marily Corral', NULL, NULL, '627 135 8100', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(153, 'akaunting', 159, 'MIREYA RODRIGUEZ', NULL, NULL, '6271040573', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(154, 'akaunting', 160, 'Homero Nava', NULL, NULL, '6491033922', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(155, 'akaunting', 161, 'Eva', NULL, NULL, '627 111 9600', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(156, 'akaunting', 162, 'Diana Rodríguez Salas', NULL, NULL, '6275172150', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(157, 'akaunting', 163, 'Ivon', NULL, NULL, '6271177192', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(158, 'akaunting', 164, 'Adriana Hernández', NULL, NULL, '627 139 2846', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(159, 'akaunting', 165, 'Nubia Alondra Chávez', NULL, NULL, '627 112 8408', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(160, 'akaunting', 166, 'Ivette', NULL, NULL, '627 113 4993', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(161, 'akaunting', 167, 'Yaretzi', NULL, NULL, '627 104 1826', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(162, 'akaunting', 168, 'Jessica Lizeth Vicente Garcia', NULL, NULL, '664 362 2156', 'Calle de las fuentes #12462 col. 20 de noviembre,', 'Tijuana B.C.', '22100', 'Baja California', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(163, 'akaunting', 169, 'Irvin Esparza', NULL, NULL, '6272799391', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(164, 'akaunting', 170, 'Omar Gómez', NULL, NULL, '627 150 7675', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(165, 'akaunting', 171, 'Esc. Prim. Ma. Brisia Rodríguez', NULL, NULL, '627 113 3333', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(166, 'akaunting', 172, 'Rocio', NULL, NULL, '614 373 4701', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(167, 'akaunting', 173, 'Laura Hernández', NULL, NULL, '6271117298', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(168, 'akaunting', 174, 'Esc. Prim. Centenario del Ejército Mexicano', NULL, NULL, '6271049835', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(169, 'akaunting', 175, 'Andrea Soto', NULL, NULL, '6271144483', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(170, 'akaunting', 176, 'Lore Coronado', NULL, NULL, '627 279 8826', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(171, 'akaunting', 177, 'Ana Rodríguez', NULL, NULL, '6271443005', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(172, 'akaunting', 178, 'J.N. Jesús Lozoya Solís #1127', NULL, NULL, '627 113 7667', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(173, 'akaunting', 179, 'Luis Payan', NULL, NULL, '656 704 2713', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(174, 'akaunting', 180, 'Carolina García Gutiérrez', NULL, NULL, '6271213331', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(175, 'akaunting', 181, 'Marilú', NULL, NULL, '627 139 9730', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(176, 'akaunting', 182, 'Esc. Sec. Tec. #70', NULL, NULL, '6271543973', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(177, 'akaunting', 183, 'Javier', NULL, NULL, '6271779051', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(178, 'akaunting', 184, 'Jonathan', NULL, NULL, '6271780925', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(179, 'akaunting', 185, 'Perla Nallely Saenz Bustillos', NULL, NULL, '6271437936', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(180, 'akaunting', 186, 'Esc. Prim. Jesús González Ortega', NULL, NULL, '6271507728', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(181, 'akaunting', 187, 'Ervey Rubio', NULL, NULL, '627 517 0287', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(182, 'akaunting', 188, 'Enedina Pérez', NULL, NULL, '627 143 5122', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(183, 'akaunting', 189, 'Esc. Profa Carmen Tarín Ibarra', NULL, NULL, '627 104 9311', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(184, 'akaunting', 190, 'Barbadoa IAN', NULL, NULL, '6272797834', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(185, 'akaunting', 191, 'Jesús Carbajal', NULL, NULL, '6271219050', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(186, 'akaunting', 192, 'Geisa Saenz', NULL, NULL, '6141155681', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(187, 'akaunting', 193, 'CENTRO DE INTERVENCION EN CRISIS ALMA CALMA AC', NULL, NULL, '614 523 0454', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(188, 'akaunting', 194, 'Fernando', NULL, NULL, '627 147 1916', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(189, 'akaunting', 195, 'Yuridia Gastelum', NULL, NULL, '627 132 9497', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(190, 'akaunting', 196, 'Liliana Cañez', NULL, NULL, '627 177 4144', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(191, 'akaunting', 197, 'EZEQUIEL ORQUIZ', NULL, NULL, '6271216554', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(192, 'akaunting', 198, 'Ana Flores', NULL, NULL, '6271125178', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(193, 'akaunting', 199, 'Primaria Emiliano Zapata', NULL, NULL, '6141020760', 'Venceremos y Che Guevara s/n Col. Tierra y Libertad', 'Jiménez', NULL, 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(194, 'akaunting', 200, 'Noemi', NULL, NULL, '6278895844', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(195, 'akaunting', 201, 'Kevin valverde', NULL, NULL, '6271398651', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(196, 'akaunting', 202, 'Lourdes Chávez', NULL, NULL, '627 103 5309', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(197, 'akaunting', 203, 'Eden Varela', NULL, NULL, '6271313272', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(198, 'akaunting', 204, 'Amparo', NULL, NULL, '2283231767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(199, 'akaunting', 205, 'Luz del Carmen', NULL, NULL, '627 111 3652', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(200, 'akaunting', 206, 'Mercedes Solís', NULL, NULL, '627 517 8693', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(201, 'akaunting', 207, 'María Guzmán  Grupo Abreu', NULL, NULL, '55 3888 7332', NULL, 'México Delegación Coyoacán', NULL, 'México', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(202, 'akaunting', 208, 'Alexis Rodríguez', NULL, NULL, '627 119 5317', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(203, 'akaunting', 209, 'Elsa Tarin', NULL, NULL, '6271231891', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(204, 'akaunting', 210, 'Leslie Hernandez', NULL, NULL, '6291092461', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(205, 'akaunting', 211, 'Pedro Corral', NULL, NULL, '6291091302', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(206, 'akaunting', 212, 'Susana Gardea', NULL, NULL, '6271107702', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(207, 'akaunting', 213, 'Eloy', NULL, NULL, '4421390936', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(208, 'akaunting', 214, 'Brenda Molina', NULL, NULL, '6275215615', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(209, 'akaunting', 215, 'Anai Carbajal Morales', NULL, NULL, '656 222 3483', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(210, 'akaunting', 216, 'Hospital de ginecoobstetricia Parral', NULL, NULL, '614 607 6259', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(211, 'akaunting', 217, 'Andrea Granados', NULL, NULL, '6271033929', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(212, 'akaunting', 218, 'Alondra', NULL, NULL, '6271335817', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(213, 'akaunting', 219, 'Guadalupe Salgado', NULL, NULL, '627 521 2651', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(214, 'akaunting', 220, 'Misael Ramos', NULL, NULL, '6271354980', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(215, 'akaunting', 221, 'Elizabeth Arciniega', NULL, NULL, '627 521 2974', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(216, 'akaunting', 222, 'Jaquelin Montes', NULL, NULL, '6271025522', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(217, 'akaunting', 223, 'Paty chavira', NULL, NULL, '627 174 9665', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(218, 'akaunting', 224, 'Irais Domínguez', 'irais@onetoonegroup.mx', NULL, '+52 1 55 2363 1974', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(219, 'akaunting', 225, 'Ana Gabriela Toledo Hernández', NULL, NULL, '+52 1 777 218 7839', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(220, 'akaunting', 226, 'Francisco Javier', NULL, NULL, '6271323455', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(221, 'akaunting', 227, 'Ana Gabriela Toledo Hernández', NULL, NULL, '+52 1 777 218 7839', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(222, 'akaunting', 228, 'Cosme Baca', NULL, NULL, '6271138696', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(223, 'akaunting', 229, 'Thelma Ogaz', NULL, NULL, '6271057210', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(224, 'akaunting', 230, 'Tecnológico de Parral  Con atención al Ing. Juan José Mora  Jefe de recursos materiales', NULL, NULL, '627 123 6857', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(225, 'akaunting', 231, 'Oscar Solís', NULL, NULL, '+1 (720) 988-9476', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(226, 'akaunting', 232, 'Lizeth Barajas', NULL, NULL, '6271053943', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(227, 'akaunting', 233, 'Yazmin Carreon', NULL, NULL, '627 131 1654', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(228, 'akaunting', 234, 'Leticia Palomares', NULL, NULL, '6271089648', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(229, 'akaunting', 235, 'Arely Martínez', NULL, NULL, '656 329 8971', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(230, 'akaunting', 236, 'Fedra Teniente', NULL, NULL, '6271159409', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(231, 'akaunting', 237, 'Alondra Lazos', NULL, NULL, '6271136398', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(232, 'akaunting', 238, 'Guadalupe Alberto', NULL, NULL, '5564462208', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(233, 'akaunting', 239, 'Indian motorcycle Agencia cdmx', NULL, NULL, '+52 55 6565 7058', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(234, 'akaunting', 240, 'Esly', NULL, NULL, '6562142405', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(235, 'akaunting', 241, 'Mayra Vargas', NULL, NULL, '627 106 7938', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(236, 'akaunting', 242, 'Josue Arellanes', NULL, NULL, '627 889 6997', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(237, 'akaunting', 243, 'Nancy Méndez', NULL, NULL, '627 113 7667', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(238, 'akaunting', 244, 'Judith Gardea', NULL, NULL, '627 119 4507', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(239, 'akaunting', 245, 'Ana Gonzalez Loera', NULL, NULL, '6271087730', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(240, 'akaunting', 246, 'Daniela', NULL, NULL, '627 107 9334', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(241, 'akaunting', 247, 'Yaneth', NULL, NULL, '627 111 0073', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(242, 'akaunting', 248, 'Carolina', NULL, NULL, '5541920292', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(243, 'akaunting', 249, 'Jorge', NULL, NULL, '55 1333 5864', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(244, 'akaunting', 250, 'Esc. Prim. Vicente Guerrero', NULL, NULL, '627 102 0723', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(245, 'akaunting', 251, 'Esc. Prim. Jesùs González Ortega', NULL, NULL, '6271234990', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(246, 'akaunting', 252, 'Ma. Jesùs Sánchez', NULL, NULL, '6271234990', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(247, 'akaunting', 253, 'Ervey Rubio', NULL, NULL, '6275170287', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(248, 'akaunting', 254, 'Erika Bustillos', 'erikamitzy@gmail.com', 'BUAE8208274R5', '+526271470053', 'ALEMANIA 87', 'HIDALGO DEL PARRAL', '33820', 'CHIHUAHUA', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(249, 'akaunting', 255, 'luis gardea', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(250, 'akaunting', 256, 'Diana', NULL, NULL, '6271060146', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(251, 'akaunting', 257, 'Alfredo Tortillería Dan y Omar', NULL, NULL, '6271237907', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(252, 'akaunting', 258, 'Esc. Prim. Ma. Brisia Rodriguez', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(253, 'akaunting', 259, 'María José Fonseca García', NULL, NULL, '5554312535', 'C. Tiburcio Sánchez de la Barquera ·116 interior 508\r\nBenito Juárez. Colonia Merced Juárez', 'Ciudad de México', '03930', 'Mèxico', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(254, 'akaunting', 260, 'Yuli Ramirez', NULL, NULL, '433 105 3847', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(255, 'akaunting', 261, 'JOAQUIN MEDINA', NULL, NULL, '+1 480 650 7926', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(256, 'akaunting', 262, 'Salma', NULL, NULL, '6275209949', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(257, 'akaunting', 263, 'CLAUDIA', NULL, NULL, '627 108 2209', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(258, 'akaunting', 264, 'VIOLETA RUIZ', NULL, NULL, '627 114 2818', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(259, 'akaunting', 265, 'Melida', NULL, NULL, '627 110 4468', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(260, 'akaunting', 266, 'Jorge Tamayo Bustillos', NULL, NULL, '6271192730', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(261, 'akaunting', 267, 'Susana Silva (Jardín de niños Miguel Hidalgo)', NULL, NULL, '627 139 9489', 'Guadalupe y Calvo', NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(262, 'akaunting', 268, 'Sergio', NULL, NULL, '627 104 6620', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(263, 'akaunting', 269, 'Angel Silva', NULL, NULL, '6275218294', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(264, 'akaunting', 270, 'Gabriel Urbina', NULL, NULL, '627 142 6793', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(265, 'akaunting', 271, 'Jhony', NULL, NULL, '6271234108', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(266, 'akaunting', 272, 'Cecilia Frías', NULL, NULL, '6271151801', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(267, 'akaunting', 273, 'Faviola Rodriguez', NULL, NULL, '+52 1 55 3462 6933', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(268, 'akaunting', 274, 'Julieta Carrillo', NULL, NULL, '6271396611', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(269, 'akaunting', 275, 'Jazmin Tarin Soto', NULL, NULL, '6272791739', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(270, 'akaunting', 276, 'Jazmín Tarin Soto (tesorera)', NULL, NULL, '627 279 1739', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(271, 'akaunting', 277, 'Lizbett Cereceres', NULL, NULL, '6271034971', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(272, 'akaunting', 278, 'Rocio Luna Gardea', NULL, NULL, '6143734701', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(273, 'akaunting', 279, 'Carniceria Carrillo', NULL, NULL, '6741013745', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(274, 'akaunting', 280, 'Tejidos locales Agroalimentarios en Red', NULL, NULL, '55 5963 7661', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(275, 'akaunting', 281, 'Jenni', NULL, NULL, '6271215465', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(276, 'akaunting', 282, 'Merced Gutiérrez', NULL, NULL, '6271238632', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(277, 'akaunting', 283, 'Yaritza', NULL, NULL, '6271446225', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(278, 'akaunting', 284, 'Edgar Rosas', NULL, NULL, '6563125423', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(279, 'akaunting', 285, 'Ocote Premium', NULL, NULL, '6271330947', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(280, 'akaunting', 286, 'Karla Mendez', NULL, NULL, '6271200642', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(281, 'akaunting', 287, 'Alexa Escarcega', NULL, NULL, '6271153453', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(282, 'akaunting', 288, 'Adriana Medina', NULL, NULL, '6272790093', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(283, 'akaunting', 289, 'Rocio Garcia', NULL, NULL, '6271030748', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(284, 'akaunting', 290, 'Mariana (TEXA)', NULL, NULL, '8715070367', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(285, 'akaunting', 291, 'Telesecundaria', NULL, NULL, '6271494978', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(286, 'akaunting', 292, 'Esmeralda Anahi Carrillo Ramos', NULL, NULL, '6741013745', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(287, 'akaunting', 293, 'Janeth Saenz', NULL, NULL, '6271110073', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(288, 'akaunting', 294, 'Laura Ríos', NULL, NULL, '627 144 1521', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(289, 'akaunting', 295, 'Daniela Sotelo', NULL, NULL, '627 111 8390', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(290, 'akaunting', 296, 'Daniela', NULL, NULL, '627 111 8390', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(291, 'akaunting', 297, 'Gloria Herrera', NULL, NULL, '6271176103', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(292, 'akaunting', 298, 'Veronica de la O', NULL, NULL, '627 114 6399', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(293, 'akaunting', 299, 'Lia Lee', NULL, NULL, '614 289 7217', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(294, 'akaunting', 300, 'Chantal Gutierréz', NULL, NULL, '627 143 7440', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(295, 'akaunting', 301, 'Johana Guzman', NULL, NULL, '627 139 7669', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(296, 'akaunting', 302, 'Dulce Armendariz', NULL, NULL, '6271029959', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(297, 'akaunting', 303, 'Carla Chávez', NULL, NULL, '627 108 8429', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(298, 'akaunting', 304, 'Julieta Morales', NULL, NULL, '629 103 6794', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(299, 'akaunting', 305, 'Celeste Ochoa', NULL, NULL, '6271065774', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(300, 'akaunting', 306, 'Brenda', NULL, NULL, '627 131 0473', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(301, 'akaunting', 307, 'Claudia Yesenia Arreola Rodriguez', NULL, NULL, '6271429987', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(302, 'akaunting', 308, 'Nayib', NULL, NULL, '627 105 2926', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(303, 'akaunting', 309, 'Ervey Rubio', NULL, NULL, '627 517 0287', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(304, 'akaunting', 310, 'Itzel', NULL, NULL, '627 102 0723', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(305, 'akaunting', 311, 'Mario', NULL, NULL, '627 115 9920', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(306, 'akaunting', 312, 'Fernando', NULL, NULL, '627 108 8346', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(307, 'akaunting', 313, 'Itzel Carrera', NULL, NULL, '6271484084', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(308, 'akaunting', 314, 'Alex', NULL, NULL, '627 143 9025', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(309, 'akaunting', 315, 'Sandra', NULL, NULL, '627 279 5634', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13');
INSERT INTO `cp_customers` (`id`, `source_type`, `source_id`, `name`, `email`, `tax_number`, `phone`, `address`, `city`, `zip_code`, `state`, `country`, `notes`, `enabled`, `created_at`, `updated_at`) VALUES
(310, 'akaunting', 316, 'Alejandra', NULL, NULL, '627 173 2636', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(311, 'akaunting', 317, 'Vanely', NULL, NULL, '627 143 8180', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(312, 'akaunting', 318, 'Sol', NULL, NULL, '627 113 2340', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(313, 'akaunting', 319, 'Elisa Chàvez', NULL, NULL, '6491037422', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(314, 'akaunting', 320, 'Elizabeth', NULL, NULL, '6271488209', NULL, 'Jiménez', NULL, 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(315, 'akaunting', 321, 'Perla Aracely Villezcas Ramos', NULL, NULL, '614 2775 353', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(316, 'akaunting', 322, 'Lorenzo Antonio', NULL, NULL, '6271130903', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(317, 'akaunting', 323, 'Alma Moya', NULL, NULL, '6271235656', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(318, 'akaunting', 324, 'Erika Valenzuela', NULL, NULL, '6271038712', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(319, 'akaunting', 325, 'Suhey Mata Publicidad', NULL, NULL, '871 523 7508', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(320, 'akaunting', 326, 'Alondra Tarin', NULL, NULL, '627 133 5817', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(321, 'akaunting', 327, 'Erika Elizabeth Bustillos Aguirre', NULL, NULL, '627 147 0053', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(322, 'akaunting', 328, 'Karla Jazmin Martinez Torres', NULL, NULL, '627 149 7077', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(323, 'akaunting', 329, 'Crece con Vales', NULL, NULL, '6271120983', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(324, 'akaunting', 330, 'Profesora Delil Aguirre', NULL, NULL, '6271154064', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(325, 'akaunting', 331, 'Profr. Gerardo Rodriguez', NULL, NULL, '627 117 0819', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(326, 'akaunting', 332, 'Luz', NULL, NULL, '614 123 2399', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(327, 'akaunting', 333, 'Rocio Escalante', NULL, NULL, '627 279 6767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(328, 'akaunting', 334, 'Sergio', NULL, NULL, '6271332582', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(329, 'akaunting', 335, 'Diosmar', NULL, NULL, '6341108391', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(330, 'akaunting', 336, 'Analy Valenzuela', NULL, NULL, '627 107 4848', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(331, 'akaunting', 337, 'Enrique Carrera', NULL, NULL, '6271125767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(332, 'akaunting', 338, 'ARIZONA el estado del gran cañon', NULL, NULL, '2222388764', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(333, 'akaunting', 339, 'Anahi Lozano', NULL, NULL, '6271021195', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(334, 'akaunting', 340, 'Laura Peinado', NULL, NULL, '6565734434', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(335, 'akaunting', 341, 'Reyna', NULL, NULL, '6271331122', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(336, 'akaunting', 342, 'Christian Galan', NULL, NULL, '52 1 55 9190 3512', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(337, 'akaunting', 343, 'Aaron Bustillos', NULL, NULL, '627 111 5366', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(338, 'akaunting', 344, 'Suhey Mata', NULL, NULL, '8715237508', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(339, 'akaunting', 345, 'Myrna Sáenz', NULL, NULL, '6272794894', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(340, 'akaunting', 346, 'MacLean Mèxico /  Eloy', NULL, NULL, '+52 1 442 139 0936', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(341, 'akaunting', 347, 'Fundación Dondé  / Dannyel Jamin Morales Bonilla', 'demorales.bec@frd.org.mx', NULL, '9999707550 ext 1437', 'Av. Independencia #310 \r\nCol. Centro', 'Hidalgo del Parral', '33800', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(342, 'akaunting', 348, 'Mayra Brito', NULL, NULL, '627 117 2239', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(343, 'akaunting', 349, 'Rosendo Carrilo', NULL, NULL, '627 150 9182', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(344, 'akaunting', 350, 'Ayled Castillo Lazos', NULL, NULL, '627 177 1568', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(345, 'akaunting', 351, 'Claudia Prieto', NULL, NULL, '614 216 3745', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(346, 'akaunting', 352, 'Edith Núñez', NULL, NULL, '6271046644', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(347, 'akaunting', 353, 'Iván Rodríguez', NULL, NULL, '614 209 8597', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(348, 'akaunting', 354, 'Diana Quintana', NULL, NULL, '6145467930', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(349, 'akaunting', 355, 'María de la Luz Sevares', NULL, NULL, '55 5401 0805', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(350, 'akaunting', 356, 'Claudia Karina Vargas campos', NULL, NULL, '627 133 2600', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(351, 'akaunting', 357, 'Gabriel López Chávez', NULL, NULL, '627 133 2600', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(352, 'akaunting', 358, 'Alondra Suarez', NULL, NULL, '627 131 4436', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(353, 'akaunting', 359, 'Vanesa Chaparro', NULL, NULL, '6271437270', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(354, 'akaunting', 360, 'Angel Ramos', NULL, NULL, '627 177 7421', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(355, 'akaunting', 361, 'Jorge', NULL, NULL, '627 151 9139', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(356, 'akaunting', 362, 'Georgina Chávez', NULL, NULL, '627 524 1176', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(357, 'akaunting', 363, 'Rebeca', NULL, NULL, '627 115 6284', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(358, 'akaunting', 364, 'Omilba Duarte', NULL, NULL, '627 148 8821', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(359, 'akaunting', 365, 'Christian Giovanny', NULL, NULL, '52 1 951 231 4196', 'Escuela Naval 407, esquina amapolas, Colina Reforma\r\nNegocio de comida D´Villatortas', 'Oaxaca', '68050', 'Oaxaca de Juárez', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(360, 'akaunting', 366, 'Selene Molina', NULL, NULL, '6672684614', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(361, 'akaunting', 367, 'Adriana Lozano Reyes', NULL, NULL, '656 551 1843', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(362, 'akaunting', 368, 'Olga Auday', NULL, NULL, '5626448317', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(363, 'akaunting', 369, 'José Manuel Bosquez Alarcón', NULL, NULL, '6271178615', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(364, 'akaunting', 370, 'Gobierno del Estado de Chihuahua', NULL, NULL, '656 777 8597', 'Venustiano Carranza 601', 'Chihuahua', '31350', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(365, 'akaunting', 371, 'Alondra Tarín', NULL, NULL, '627 133 5817', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(366, 'akaunting', 372, 'Elotes San Ángel', NULL, NULL, '627 120 5242', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(367, 'akaunting', 373, 'Zenet Pineda', NULL, NULL, '6271399643', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(368, 'akaunting', 374, 'Zulema Saldaña', NULL, NULL, '6271023023', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(369, 'akaunting', 375, 'Fabiola Gamboa', NULL, NULL, '999 194 8787', 'CALLE 46 #488 POR 57 Y 59 CENTRO , \r\n\r\nOFICINA MUEBLES ANTEA  , EDIFICIO AZUL CON GRIS HORARIO DE 10 A 4', 'MERIDA', '97000', 'YUCATÁN', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(370, 'akaunting', 376, 'Jesús Armando Pacheco', NULL, NULL, '614 192 9840', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(371, 'akaunting', 377, 'Perla Peña', NULL, NULL, '6275177886', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(372, 'akaunting', 378, 'Betty', NULL, NULL, '627 102 1023', 'Esc. Prim. Club de Leones', NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(373, 'akaunting', 379, 'Mari Soto', NULL, NULL, '627 521 6737', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(374, 'akaunting', 380, 'Patricia Salgado', NULL, NULL, '627 147 3670', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(375, 'akaunting', 381, 'Julián Ibarra López', NULL, NULL, '6561903168', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(376, 'akaunting', 382, 'Sec. 34', NULL, NULL, '6271066922', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(377, 'akaunting', 383, 'Esc. Ma Brisia Rodríguez', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(378, 'akaunting', 384, 'Miryam Muñoz', NULL, NULL, '6271484402', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(379, 'akaunting', 385, 'Anahi', NULL, NULL, '6271120971', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(380, 'akaunting', 386, 'Lina Delgado', NULL, NULL, '6271471074', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(381, 'akaunting', 387, 'Brenda Bailon', NULL, NULL, '627 113 1802', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(382, 'akaunting', 388, 'ELYMSA', NULL, NULL, '+52 649 104 3888', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(383, 'akaunting', 389, 'Wilma Josselyn Ayala Lazos', NULL, NULL, '6271047955', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(384, 'akaunting', 390, 'Wilma J Ayala Lazos', NULL, NULL, '6271775490', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(385, 'akaunting', 391, 'Diego Díaz', NULL, NULL, '+52 1 442 833 6203', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(386, 'akaunting', 392, 'Vianey Dominguez Delgado', NULL, NULL, '6271122872', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(387, 'akaunting', 393, 'Guillermina Guzmán', NULL, NULL, '5512881014', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(388, 'akaunting', 394, 'Daiana Loya', NULL, NULL, '627 108 6944', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(389, 'akaunting', 395, 'Armando Cobos', NULL, NULL, '627 174 7548', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(390, 'akaunting', 396, 'Anabel Gutiérrez', NULL, NULL, '6271338171', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(391, 'akaunting', 397, 'Teresita', NULL, NULL, '6271317924', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(392, 'akaunting', 398, 'Blanca Estela Olivas Trujillo', NULL, NULL, '627 123 6511', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(393, 'akaunting', 399, 'CARO', NULL, NULL, '5582049341', 'HAMBURGO 213\r\nPISO 10\r\nCOL. JUAREZ', 'DELEGACION CUAHUTEMOC', '06600', 'CDMX', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(394, 'akaunting', 400, 'BLANCA RODRIGUEZ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(395, 'akaunting', 401, 'Alejandra Corona Hernández', NULL, NULL, '6491049222', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(396, 'akaunting', 402, 'Alely Jazmín', NULL, NULL, '6271126108', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(397, 'akaunting', 403, 'Irasema Barrón', NULL, NULL, '6271444471', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(398, 'akaunting', 404, 'BLANCA RODRIGUEZ', NULL, NULL, '6275245961', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(399, 'akaunting', 405, 'Myrna Nájera', NULL, NULL, '6271491096', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(400, 'akaunting', 406, 'Alicia', NULL, NULL, '6271035813', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(401, 'akaunting', 407, 'Yanira Ramos', NULL, NULL, '6271488821', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(402, 'akaunting', 408, 'Alonso', NULL, NULL, '627 212 8970', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(403, 'akaunting', 409, 'Isis Muñoz', NULL, NULL, '6271423136', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(404, 'akaunting', 410, 'Marcos Saenz', NULL, NULL, '+52 618 260 3414', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(405, 'akaunting', 411, 'Mtra Gaby', NULL, NULL, '+52 627 517 8208', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(406, 'akaunting', 412, 'Ana Carolina Valles Duarte', NULL, NULL, '+52 627 104 1005', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(407, 'akaunting', 413, 'COMERCIALIZADORA ROCAS SA DE CV', NULL, NULL, '+52 833 311 9089', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(408, 'akaunting', 414, 'Claudia Figueroa', NULL, NULL, '+52 55 3273 3995', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(409, 'akaunting', 415, 'Leonardo Olmeda', NULL, NULL, '6491132206', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(410, 'akaunting', 416, 'Gloria Herrera', NULL, NULL, '627 117 6103', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(411, 'akaunting', 417, 'Laura Zamarton', NULL, NULL, '6271041484', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(412, 'akaunting', 418, 'Yadhira Abigail Loya flores', NULL, NULL, '+52 627 131 4236', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(413, 'akaunting', 419, 'Angel', NULL, NULL, '+52 627 135 3550', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(414, 'akaunting', 420, 'Felix', NULL, NULL, '+52 614 403 4942', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(415, 'akaunting', 421, 'Abraham Soveranis', NULL, NULL, '99994079251', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(416, 'akaunting', 422, 'Kasey Chavira', NULL, NULL, '925 272 8082', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(417, 'akaunting', 423, 'Jessica Puerto Cardeña', 'Jpuerto.bec@frd.org.mx', NULL, '(999) 9407550 ext 1432', 'Calle 60 x 35 #346 Edificio Paseo 60 Col. Centro', 'Mérida', '97000', 'Yucatán', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(418, 'akaunting', 424, 'RUTILO ROMAN LÓPEZ', 'roman_uaaan@hotmail.com', NULL, '523329721523', 'CRUCERO JOJOTEPEC', 'JALISCO', NULL, 'GUADALAJARA', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(419, 'akaunting', 425, 'Adriana Pèrez', NULL, NULL, '6271152175', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(420, 'akaunting', 426, 'Diana Sifuentes', NULL, NULL, '6271494793', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(421, 'akaunting', 427, 'Ilse Luna', NULL, NULL, '6275210739', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(422, 'akaunting', 428, 'Anahí Frausto', NULL, NULL, '6291230068', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(423, 'akaunting', 429, 'Gladys Muniz', NULL, NULL, '6271137055', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(424, 'akaunting', 430, 'Laura Escobar', NULL, NULL, '+52 627 144 0120', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(425, 'akaunting', 431, 'ALEJANDRA ONTIVEROS CANO', NULL, NULL, '6271483799', 'OJITO DURANGO', 'DURANGO', NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(426, 'akaunting', 432, 'Esc, Prim. Ignaco Allende', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(427, 'akaunting', 433, 'Esc. Prim, Vicente Guerrero', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(428, 'akaunting', 434, 'Luisito Gardea', 'luisgardea2311@gmail.com', NULL, '6271074548', 'CIRCUITO MONTE GOLGOTA, FRACC. TERRANOVA SUR', 'JUÁREZ', '32576', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(429, 'akaunting', 435, 'Maribel Medina', NULL, NULL, '+52 998 705 6777', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(430, 'akaunting', 436, 'Escuela Primaria Ford 190 T.M', NULL, NULL, '627 150 0140', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(431, 'akaunting', 437, 'INNOVA PROMOCIONALES', NULL, 'IPR970219NE1', '+52 1 55 1256 8422', 'ALFONSO ESPARZA OTEO\r\nPRIMER PISO', 'ALVARO OBREGON', '01020', 'ALVARO OBREGON', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(432, 'akaunting', 438, 'Efrain', NULL, NULL, '6271024615', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(433, 'akaunting', 439, 'Margarita Arrieta', NULL, NULL, '+52 627 149 4152', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(434, 'akaunting', 440, 'Tania Ramírez', NULL, NULL, '6391149077', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(435, 'akaunting', 441, 'Ashley', NULL, NULL, '+52 627 103 6390', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(436, 'akaunting', 442, 'Brenda Rodriguez', NULL, NULL, '6271124607', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(437, 'akaunting', 443, 'Abdiel Sandoval', NULL, NULL, '52 1 33 1147 6361', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(438, 'akaunting', 444, 'Lusito', 'luisgardeabustillos1@gmail.com', NULL, '6271074512', 'ALEMANIA #87, PROLONGACIÓN PARÍS, PROLONGACIÓN PARÍS', 'HIDALGO DEL PARRAL', '33820', 'CHIHUAHUA', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(439, 'akaunting', 445, 'Jardín de Niños Bertha Aguilera Baca', NULL, NULL, '6271239559', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(440, 'akaunting', 446, 'Luis Baca', NULL, NULL, '627173003', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(441, 'akaunting', 447, 'Esc Centenario del Ejército Mexicano', NULL, NULL, '+52 627 113 7005', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(442, 'akaunting', 448, 'Esmeralda Loera', NULL, NULL, '6271235303', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(443, 'akaunting', 449, 'Victor Vázquez', NULL, NULL, '6271117298', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(444, 'akaunting', 450, 'Andrea Holguin', NULL, NULL, '6271324670', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(445, 'akaunting', 451, 'MINPRO', NULL, NULL, '+52 614 190 5176', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(446, 'akaunting', 452, 'Melissa Minerva Murillo Morín', NULL, NULL, '+52 1 844 122 6677', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(447, 'akaunting', 453, 'Isamar Cervantes', NULL, NULL, '6491137119', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(448, 'akaunting', 454, 'Alessia Frisoni', NULL, NULL, '4427327936', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(449, 'akaunting', 455, 'Nayeli Almanza', NULL, NULL, '627 174 9290', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(450, 'akaunting', 456, 'Jessica', NULL, NULL, '5565280381', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(451, 'akaunting', 457, 'Jazmin', NULL, NULL, '6271171876', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(452, 'akaunting', 458, 'Jorge', NULL, NULL, '6271519139', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(453, 'akaunting', 459, 'Multiservicios RR', NULL, NULL, '+52 627 147 3810', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(454, 'akaunting', 460, 'Saira Ayala', NULL, NULL, '+52 627 112 6301', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(455, 'akaunting', 461, 'Yancarlo', NULL, NULL, '+52 627 177 9565', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(456, 'akaunting', 462, 'Adriana Nuñez', NULL, NULL, '+52 627 119 2148', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(457, 'akaunting', 463, 'Abril García', NULL, NULL, '6271041466', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(458, 'akaunting', 464, 'Jassel Nuñez', NULL, NULL, '6271331507', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(459, 'akaunting', 465, 'Marisol', NULL, NULL, '+52 649 110 7188', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(460, 'akaunting', 466, 'Ivan Fabela', NULL, NULL, '+52 627 143 3164', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(461, 'akaunting', 467, 'Isamar Juárez Atonal', 'especialista.compras8@ciudadmaderas.com', NULL, '+52 442 320 5528', 'Desarrollo CMQRO:\r\nANILLO VIAL III OTE,  EL MARQUES, QUERÉTARO, C.P. 76246\r\n\r\nDesarrollo CDMSLP:\r\nW383+W9 Jesús María, 79530 S.L.P.', NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(462, 'akaunting', 468, 'Alejandra', NULL, NULL, '+52 649 104 9222', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(463, 'akaunting', 469, 'Abraham HOLGUIN', NULL, NULL, '614 313 0597', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(464, 'akaunting', 470, 'Alinka Zaragoza', NULL, NULL, '+52 627 133 1873', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(465, 'akaunting', 471, 'Arely', NULL, NULL, '+52 627 521 3324', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(466, 'akaunting', 472, 'Farmacias Similares', NULL, NULL, '+52 627 279 5070', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(467, 'akaunting', 473, 'Berenice Aguirre', NULL, NULL, '6271087040', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(468, 'akaunting', 474, 'Laura Fraire', NULL, NULL, '+52 627 112 9658', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(469, 'akaunting', 475, 'Escuela Josefa Solís de Lozoya', NULL, NULL, '627 112 6760', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(470, 'akaunting', 476, 'ADRIANA', 'auxventas1@mlmproductos.com', NULL, '6565795622', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(471, 'akaunting', 477, 'Georgina Unda', NULL, NULL, '6271488352', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(472, 'akaunting', 478, 'Ivanna Meza', NULL, NULL, '6271170295', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(473, 'akaunting', 479, 'Ángel Gutierrez Burciaga', NULL, NULL, '6271212420', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(474, 'akaunting', 480, 'Lizbeth Chaparro', NULL, NULL, '6272795942', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(475, 'akaunting', 481, 'Uriel Sánchez', NULL, NULL, '6181136054', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(476, 'akaunting', 482, 'Lizeth Monarrez', NULL, NULL, '6271335921', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(477, 'akaunting', 483, 'Laura Aguilera', NULL, NULL, '6271778352', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(478, 'akaunting', 484, 'Angela Gamez Aguirre', NULL, NULL, '5271236825', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(479, 'akaunting', 485, 'Nicole Martinez', NULL, NULL, '6271492038', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(480, 'akaunting', 486, 'Araceli Arzola', NULL, NULL, '+52 627 112 2758', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(481, 'akaunting', 487, 'Francia Lomeli', NULL, NULL, '6271319833', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(482, 'akaunting', 488, 'Juan Carlos Lomeli', NULL, NULL, '3414196479', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(483, 'akaunting', 489, 'Angelly', NULL, NULL, '6271023674', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(484, 'akaunting', 490, 'Judith Medina', NULL, NULL, '627 117 7074', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(485, 'akaunting', 491, 'Estefania', NULL, NULL, '+52 627 110 3947', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(486, 'akaunting', 492, 'Alejandra Martinez', NULL, NULL, '6271068169', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(487, 'akaunting', 493, 'Jazmin Armendariz', NULL, NULL, '6271421545', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(488, 'akaunting', 494, 'Erik Olvera', NULL, NULL, '6271020586', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(489, 'akaunting', 495, 'Autocristales y Refacciones', NULL, NULL, '6271192685', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(490, 'akaunting', 496, 'Nancy Mendez', NULL, NULL, '+52 627 113 7667', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(491, 'akaunting', 497, 'Jonathan Rodriguez', NULL, NULL, '+52 1 686 161 1134', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(492, 'akaunting', 498, 'Regina', NULL, NULL, '+1 531 3339355', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(493, 'akaunting', 499, 'Nancy etchechury', NULL, NULL, '+52 627 131 9148', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(494, 'akaunting', 500, 'Martin Soto', NULL, NULL, '+52 627 110 0918', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(495, 'akaunting', 501, 'Carmen Morales', NULL, NULL, '6275211926', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(496, 'akaunting', 502, 'Cristina MARTINEZ', NULL, NULL, '+52 649 105 2360', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(497, 'akaunting', 503, 'Rocío Nava', NULL, NULL, '+52 627 106 6922', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(498, 'akaunting', 504, 'Izamar Nuñez', NULL, NULL, '+52 627 148 6193', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(499, 'akaunting', 505, 'Soledad Aguirre', NULL, NULL, '+52 627 139 3171', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(500, 'akaunting', 506, 'Minpro ING. Vannesa Aleman', 'vannesa.aleman@minpro.com.mx', NULL, '+52 871 219 8091', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(501, 'akaunting', 507, 'Amanda Martínez TRENDSETERA', NULL, NULL, '+52 777 463 7283', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(502, 'akaunting', 508, 'Jonathan Ibarra', NULL, NULL, '+52 418 110 4109', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(503, 'akaunting', 509, 'Diana Rueda Jurado', NULL, NULL, '+52 627 131 6001', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(504, 'akaunting', 510, 'Abril', NULL, NULL, '+52 627 148 1305', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(505, 'akaunting', 511, 'Lupita Lozoya', NULL, NULL, '+52 627 121 0938', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(506, 'akaunting', 512, 'Cindy', NULL, NULL, '+52 627 104 5069', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(507, 'akaunting', 513, 'Sol Aguirre', 'wmaster1ro@gmail.com', NULL, '+52 627 139 3171', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(508, 'akaunting', 514, 'Asociación de padres de familia esc. prim. Jesús González O.', NULL, NULL, '627 117 0819', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(509, 'akaunting', 515, 'Carniceria Meza', NULL, NULL, '+52 627 174 8295', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(510, 'akaunting', 516, 'Esc. Prim Fed. Gustavo Diaz Ordaz', NULL, NULL, '+52 649 196 1075', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(511, 'akaunting', 517, 'Carole Azaincot', NULL, NULL, '+52 55 5217 5493', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(512, 'akaunting', 518, 'Oscar Giovanni Rivera', NULL, NULL, '+52 229 250 0171', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(513, 'akaunting', 519, 'Esmeralda Herrera', NULL, NULL, '+52 627 148 4803', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(514, 'akaunting', 520, 'Escuela Carmen Tarín Ibarra', NULL, NULL, '+52 627 106 0840', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(515, 'akaunting', 521, 'AILYN LOPEZ', NULL, NULL, '6271212922', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(516, 'akaunting', 522, 'Flor García', NULL, NULL, '6275171435', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(517, 'akaunting', 523, 'ABTSA', NULL, NULL, '5516513909', 'Águilas int 1 ext 18A\r\nCol.Lago de Guadalupe', 'Cuautitlán Izcalli', '54760', 'México', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(518, 'akaunting', 524, 'Emy', NULL, NULL, '+52 649 196 1636', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(519, 'akaunting', 525, 'Jovana Rodríguez', NULL, NULL, '6271499611', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(520, 'akaunting', 526, 'Elizabeth Chaparro', NULL, NULL, '+52 627 151 4372', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(521, 'akaunting', 527, 'Rocío Rocha', NULL, NULL, '+52 614 253 2134', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(522, 'akaunting', 528, 'José Miranda', NULL, NULL, '+52 444 215 4167', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(523, 'akaunting', 529, 'LAURA ESTRADA', NULL, NULL, '6271432812', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(524, 'akaunting', 530, 'Patricio Rubio', NULL, NULL, '+52 656 167 3729', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(525, 'akaunting', 531, 'Laura Yesenia Salazar', NULL, NULL, '+52 627 520 4842', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(526, 'akaunting', 532, 'Alyson Pacheco', NULL, NULL, '+52 627 106 8726', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(527, 'akaunting', 533, 'Saúl Papás Leo', NULL, NULL, '+52 639 117 2204', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(528, 'akaunting', 534, 'Andrés', NULL, NULL, '+52 649 197 5603', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(529, 'akaunting', 535, 'Miguel', NULL, NULL, '+52 627 517 8466', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(530, 'akaunting', 536, 'Ferretería Regional', NULL, NULL, '6271585061', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(531, 'akaunting', 537, 'Gabriela Soto', NULL, NULL, '+52 627 116 4484', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(532, 'akaunting', 538, 'Yeimi ortega', NULL, NULL, '+52 627 111 1134', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(533, 'akaunting', 539, 'ITZEL ARCINIEGA', NULL, NULL, '+52 627 132 4235', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(534, 'akaunting', 540, 'Pedro Lerma', NULL, NULL, '6271424947', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(535, 'akaunting', 541, 'Villalobos Tile LLC', NULL, NULL, '6024734792', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(536, 'akaunting', 542, 'María Medrano', NULL, NULL, '+52 627 150 4059', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(537, 'akaunting', 543, 'Turismos Parral', NULL, NULL, '+52 627 117 6770', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(538, 'akaunting', 544, 'Fernanda Cazares', NULL, NULL, '6361239690', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(539, 'akaunting', 545, 'Yazmin Aguilar', NULL, NULL, '627 148 9782', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(540, 'akaunting', 546, 'Brenda Gonzales', NULL, NULL, '+52 627 117 0111', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(541, 'akaunting', 547, 'Esc. Primo. Lazara Quintana', NULL, NULL, '6271076981', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(542, 'akaunting', 548, 'Marisol Núñez', NULL, NULL, '+52 667 244 5784', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(543, 'akaunting', 549, 'Teresa Delgado', NULL, NULL, '+52 627 147 1074', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(544, 'akaunting', 550, 'Industrial Minera México', NULL, 'IMM8505281U0', '+52 656 311 6402', 'Campos Eliseos 400 ofic. 1102\r\nCol. Lomas de Chapultepec', 'CD. MÉXICO', '11000', 'Miguel Hidalgo', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(545, 'akaunting', 551, 'Félix Ruiz Gonzalez', NULL, NULL, '649 1010807. 6495326091', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(546, 'akaunting', 552, 'Araceli', NULL, NULL, '+52 627 133 0594', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(547, 'akaunting', 553, 'Cristian Sánchez  LA TREMENDA', NULL, NULL, '6271144189', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(548, 'akaunting', 554, 'Julia Gardea', NULL, NULL, '+52 627 104 7693', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(549, 'akaunting', 555, 'Rodolfo Guitierrez', NULL, NULL, '6681831600', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(550, 'akaunting', 556, 'Laura Prieto', NULL, NULL, '6271113706', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(551, 'akaunting', 557, 'Karen', NULL, NULL, '+52 627 114 8614', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(552, 'akaunting', 558, 'Esequiel Villalobos', NULL, NULL, '+52 614 154 3433', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(553, 'akaunting', 559, 'Villa Bonita', NULL, NULL, '+52 627 119 3915', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(554, 'akaunting', 560, 'Anabel Moreno', NULL, NULL, '+52 627 102 8194', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(555, 'akaunting', 561, 'Miriam Gallarzo', NULL, NULL, '+52 627 143 9199', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(556, 'akaunting', 562, 'Linda', NULL, NULL, '6271733449', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(557, 'akaunting', 563, 'Lucy Abril Meza Paniagua', NULL, NULL, '6271141522', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(558, 'akaunting', 564, 'Instituto Nacional Electoral', NULL, NULL, '+52 627 139 9643', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(559, 'akaunting', 565, 'Dania Luna', NULL, NULL, '+52 627 113 0652', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(560, 'akaunting', 566, 'Saúl Ochoa', NULL, NULL, '+52 639 117 2204', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(561, 'akaunting', 567, 'Luis Enrique Urbina', NULL, NULL, '6271315105', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(562, 'akaunting', 568, 'CREI año internacional del niño', NULL, NULL, '6271113706', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(563, 'akaunting', 569, 'Ingrid Chávez', NULL, NULL, '+52 56 1555 5291', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(564, 'akaunting', 570, 'Paty posada', NULL, NULL, '6271149619', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(565, 'akaunting', 571, 'Cindy Fernandez', NULL, NULL, '+52 627 111 0759', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(566, 'akaunting', 572, 'Jonathan Valdez', NULL, NULL, '6271234108', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(567, 'akaunting', 573, 'Yajaira Almazan', NULL, NULL, '+52 627 517 2761', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(568, 'akaunting', 574, 'Sandra Carbajal Álvarez', NULL, NULL, '+52 627 104 7056', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(569, 'akaunting', 575, 'Angélica Primero', NULL, 'Angélica Primero', '+52 627 140 0862', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(570, 'akaunting', 576, 'Esc Leona Vicario', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(571, 'akaunting', 577, 'Entidad de Limpieza y Mantenimiento', NULL, NULL, '+52 649 104 3888', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(572, 'akaunting', 578, 'Gisselle Rodriguez', NULL, NULL, '+52 627 112 6345', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(573, 'akaunting', 579, 'Karla', NULL, NULL, '+52 627 102 2258', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(574, 'akaunting', 580, 'Lina Macias', NULL, NULL, '+52 627 147 0892', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(575, 'akaunting', 581, 'Be Sweet Belem Bautista', NULL, NULL, '6275172040', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(576, 'akaunting', 582, 'Jorge', NULL, NULL, '6271519139', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(577, 'akaunting', 583, 'Alondra Rodriguez', NULL, NULL, '+52 627 103 3862', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(578, 'akaunting', 584, 'Lucybet', NULL, NULL, '+52 627 142 6620', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(579, 'akaunting', 585, 'Mtra Lorely Ávila', NULL, NULL, '+52 627 114 6670', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(580, 'akaunting', 586, 'Nancy Mendez', NULL, NULL, '+52 627 147 4075', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(581, 'akaunting', 587, 'JN Lázaro Cárdenas del Río', NULL, NULL, '+52 627 142 1545', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(582, 'akaunting', 588, 'Jesús Manuel Carbajal Múñoz', NULL, NULL, '6271219050', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(583, 'akaunting', 589, 'Jesús Manuel Carbajal Múñoz', NULL, NULL, '6271219050', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(584, 'akaunting', 590, 'Rafael Ponce', NULL, NULL, '6276217403', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(585, 'akaunting', 591, 'Nallely', NULL, NULL, '6271216715', 'Agustín Melgar #3\r\ncol centro', 'Parral', '33800', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(586, 'akaunting', 592, 'Nancy Cano', NULL, NULL, '+52 627 112 8561', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(587, 'akaunting', 593, 'Esc prim 5 de Febrero 2127', NULL, NULL, '+52 627 279 3722', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(588, 'akaunting', 594, 'Perla Yaneth Jurado Luna', NULL, NULL, '+52 649 392 1875', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(589, 'akaunting', 595, 'Luci Chavira', NULL, NULL, '+1 (915) 272-8082', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(590, 'akaunting', 596, 'Rocío Holguín', NULL, NULL, '+52 627 110 1063', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(591, 'akaunting', 597, 'Denis', NULL, NULL, '+52 627 150 1009', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(592, 'akaunting', 598, 'Adriana Payan', NULL, NULL, '+52 627 117 4001', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(593, 'akaunting', 599, 'Ana Velia Flores', NULL, NULL, '+52 627 112 5178', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(594, 'akaunting', 600, 'Mary Soto', NULL, NULL, '6275216737', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(595, 'akaunting', 601, 'Esc. Prim. Club Rotario', NULL, NULL, '+52 627 279 8908', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(596, 'akaunting', 602, 'Jorge', NULL, NULL, '+52 627 151 9139', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(597, 'akaunting', 603, 'Brenda', NULL, NULL, '+52 627 131 0473', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(598, 'akaunting', 604, 'Verónica Estrada', NULL, NULL, '6275209283', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(599, 'akaunting', 605, 'Jorge Gutiérrrez', NULL, NULL, '6271113526', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(600, 'akaunting', 606, 'Adriana Montes', NULL, NULL, '6271041459', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(601, 'akaunting', 607, 'Jovany Alberto', NULL, NULL, '6491961075', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(602, 'akaunting', 608, 'Lety', NULL, NULL, '+52 627 106 3458', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(603, 'akaunting', 609, 'Karla Chàvez', NULL, NULL, '6271088429', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(604, 'akaunting', 610, 'Esc. Prim. Centenario de Ejército Mexicano profr. Edgar', NULL, NULL, '6271104468', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(605, 'akaunting', 611, 'Ruth Gamboa', NULL, NULL, '6271236279', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(606, 'akaunting', 612, 'Esc. Prim. Leona Vicario', NULL, NULL, '6272798908', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(607, 'akaunting', 613, 'Rocio Holguin', NULL, NULL, '6271101063', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(608, 'akaunting', 614, 'Cinthia Teresa Lopez Galvan', NULL, NULL, '+52 627 142 9218', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(609, 'akaunting', 615, 'Mostrador', NULL, NULL, '+52 627 1034971', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(610, 'akaunting', 616, 'Blanca Prieto', NULL, NULL, '6271495993', 'Mártires 3 de mayo #68 Col. Emiliano Zapata', NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(611, 'akaunting', 617, 'Adriana Hernández', NULL, NULL, '6271420506', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(612, 'akaunting', 618, 'Jonathan Reyes', NULL, NULL, '6271780925', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(613, 'akaunting', 619, 'Gissel', NULL, NULL, '6271239902', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(614, 'akaunting', 620, 'Esc. Prim. Ma. Brisia Rodríguez/ Sociedad de padres', NULL, NULL, '6275213324', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(615, 'akaunting', 621, 'Laura Franco', NULL, NULL, '6271157673', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(616, 'akaunting', 622, 'Anaclaret Mata', NULL, NULL, '627 131 4757', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(617, 'akaunting', 623, 'Timoteo Montalvo', NULL, NULL, '6271050554', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(618, 'akaunting', 624, 'Raymundo Pineda', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(619, 'akaunting', 625, 'Anabel Vargas', NULL, NULL, '+52 627 117 1494', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13');
INSERT INTO `cp_customers` (`id`, `source_type`, `source_id`, `name`, `email`, `tax_number`, `phone`, `address`, `city`, `zip_code`, `state`, `country`, `notes`, `enabled`, `created_at`, `updated_at`) VALUES
(620, 'akaunting', 626, 'ISABEL LOYA', NULL, NULL, '+52 627 117 0207', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(621, 'akaunting', 627, 'Belém Holguín', NULL, NULL, '+52 627 148 1493', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(622, 'akaunting', 628, 'Dulce Mariana Castillo', NULL, NULL, '993 459 6475', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(623, 'akaunting', 629, 'Esc. Prim Ma Brisia Rodriguez', NULL, NULL, '6271730881', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(624, 'akaunting', 630, 'Don Ángel', NULL, NULL, '+52 627 150 0579', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(625, 'akaunting', 631, 'Guillermina Barraza', NULL, NULL, '+52 627 104 6589', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(626, 'akaunting', 632, 'Avril Ontiveros', NULL, NULL, '+52 614 368 1077', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(627, 'akaunting', 633, 'Sirelda Beltrán', NULL, NULL, '+52 627 517 0375', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(628, 'akaunting', 634, 'Karla', NULL, NULL, '6271126331', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(629, 'akaunting', 635, 'Hazel Pizarro', NULL, NULL, '+52 627 147 7106', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(630, 'akaunting', 636, 'Gamaliel García', NULL, NULL, '+52 55 7324 9207', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(631, 'akaunting', 637, 'Nallely', NULL, NULL, '+52 627 121 6715', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(632, 'akaunting', 638, 'Kevin Rodriguez', NULL, NULL, '6271733497', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(633, 'akaunting', 639, 'Janeth Villalobos', NULL, NULL, '+52 649 101 5465', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(634, 'akaunting', 640, 'Jannett', NULL, NULL, '+52 627 279 3509', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(635, 'akaunting', 641, 'Maria de Jesús Molina', NULL, NULL, '5551807927', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(636, 'akaunting', 642, 'Diana Torres', NULL, NULL, '8123514971', 'Mty NL', NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(637, 'akaunting', 643, 'Katia González', NULL, NULL, '627 517 2358', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(638, 'akaunting', 644, 'Secundaria Federal José Revueltas', NULL, NULL, '+52 627 106 6922', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(639, 'akaunting', 645, 'Mariana Meza Cano', NULL, NULL, '6271081182', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(640, 'akaunting', 646, 'Dra. Jaqueline Chávez León', NULL, NULL, '6271152554', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(641, 'akaunting', 647, 'Mariana', NULL, NULL, '6271081182', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(642, 'akaunting', 648, 'Lucy', NULL, NULL, '6271426620', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(643, 'akaunting', 649, 'Christian Cano', NULL, NULL, '+52 614 665 5523', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(644, 'akaunting', 650, 'Ricardo Nava Herrera', NULL, NULL, '+52 627 111 9362', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(645, 'akaunting', 651, 'Betty Vazquez', NULL, NULL, '+52 627 889 7313', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(646, 'akaunting', 652, 'Everardo', NULL, NULL, '6145041414', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(647, 'akaunting', 653, 'Edén Méndez', NULL, NULL, '8717862350', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(648, 'akaunting', 654, 'Yazmin García', NULL, NULL, '6271129013', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(649, 'akaunting', 655, 'Edith Holguín', NULL, NULL, '6271427679', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(650, 'akaunting', 656, 'Ricardo Chávez', NULL, NULL, '6271039257', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(651, 'akaunting', 657, 'Laura Franco', NULL, NULL, '+52 627 115 7673', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(652, 'akaunting', 658, 'Alicia', NULL, NULL, '627 150 7197', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(653, 'akaunting', 659, 'CLINICA HOSPITAL ISSSTE PARRAL Ing. Dulce  Ma. García Soto.', 'dulce.garcia@issste.gob.mx', NULL, '+52 627 889 7145', 'Francisco Miranda y, Rep. de Cuba NO. 8', 'Hidalgo del Parral', NULL, 'CHIHUAHUA', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(654, 'akaunting', 660, 'José Ceballos', NULL, NULL, '6271236513', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(655, 'akaunting', 661, 'Sol', NULL, NULL, '+52 667 244 5784', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(656, 'akaunting', 662, 'Fernanda Herrera', NULL, NULL, '+52 627 143 1641', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(657, 'akaunting', 663, 'Sandra Hernandez', NULL, NULL, '+52 627 133 7786', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(658, 'akaunting', 664, 'Mary Martínez', NULL, NULL, '+52 627 105 4853', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(659, 'akaunting', 665, 'Marlon Mendieta', NULL, NULL, '+52 951 548 3021', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(660, 'akaunting', 666, 'Luis Arzola', NULL, NULL, '+52 627 279 8068', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(661, 'akaunting', 667, 'Yaneth Calles', NULL, NULL, '627110947', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(662, 'akaunting', 668, 'Michelle García', NULL, NULL, '+52 627 142 2370', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(663, 'akaunting', 669, 'Yazmin Palacio', NULL, NULL, '+52 639 147 2778', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(664, 'akaunting', 670, 'Marlen Muñiz', NULL, NULL, '+52 627 132 4342', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(665, 'akaunting', 671, 'Mtra. Berenice García', NULL, NULL, '+52 627 102 7767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(666, 'akaunting', 672, 'Laura', NULL, NULL, '627 144 1521', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(667, 'akaunting', 673, 'Melida Margarita Chávez', NULL, NULL, '6271104468', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(668, 'akaunting', 674, 'Rocio', NULL, NULL, '6271032891', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(669, 'akaunting', 675, 'Brenda Martínez', NULL, NULL, '6271128936', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(670, 'akaunting', 676, 'Evelyn Rodríguez', NULL, NULL, '6271156464', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(671, 'akaunting', 677, 'Noemi Rodriguez', NULL, NULL, '+52 627 889 5844', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(672, 'akaunting', 678, 'Rocío', NULL, NULL, '+52 614 373 4701', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(673, 'akaunting', 679, 'Guadalupe Hernández', NULL, NULL, '+52 627 173 6258', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(674, 'akaunting', 680, 'Hotelera Queretana', NULL, NULL, '52 4428780208', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(675, 'akaunting', 681, 'Elizabeth Baca', NULL, NULL, '+52 627 121 3628', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(676, 'akaunting', 682, 'Angela', NULL, NULL, '+52 627 133 6714', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(677, 'akaunting', 683, 'Yara Sotelo', NULL, NULL, '+52 649 107 0392', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(678, 'akaunting', 684, 'Esc. Prim. Felipe Ángeles Álvarez #2426', NULL, NULL, '6271027767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(679, 'akaunting', 685, 'Firma Rosa Meza Guerrero', NULL, NULL, '6271039808', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(680, 'akaunting', 686, 'Ramona Terrazas Solis', NULL, NULL, '+52 667 326 9525', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(681, 'akaunting', 687, 'Esc. Melchor Gándara 2056', NULL, NULL, '627 117 1494', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(682, 'akaunting', 688, 'Esc. Telesecundaria Agua Amarilla', NULL, NULL, '6271121052', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(683, 'akaunting', 689, 'Lourdes Gardea', NULL, NULL, '+52 627 123 9569', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(684, 'akaunting', 690, 'Mary', NULL, NULL, '+52 627 105 4293', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(685, 'akaunting', 691, 'Edgar Martinez', NULL, NULL, '6261049059', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(686, 'akaunting', 692, 'Jonathan Villicaña Cobra Music', 'jonathan@cobramusicmanagement.com', NULL, '+52 55 3905 2954', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(687, 'akaunting', 693, 'Fernando Carbajal', NULL, NULL, '+52 669 101 3227', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(688, 'akaunting', 694, 'Martha Muro', NULL, NULL, '+52 627 123 3804', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(689, 'akaunting', 695, 'publico general', NULL, NULL, '6271501216', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(690, 'akaunting', 696, 'Blas Zapien Soto', NULL, NULL, '6491061824', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(691, 'akaunting', 697, 'Raúl Herrera', NULL, NULL, '6271195852', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(692, 'akaunting', 698, 'Janeth Luna. \"Nana Detalles hechos a mano\"', NULL, NULL, '6271436748', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(693, 'akaunting', 699, 'Keny Sandoval', NULL, NULL, '+52 627 112 7030', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(694, 'akaunting', 700, 'Yosi', NULL, NULL, '+52 686 353 2815', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(695, 'akaunting', 701, 'Mayra Galindo', NULL, NULL, '6271431064', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(696, 'akaunting', 702, 'Adriana Lozano', NULL, NULL, '6565511843', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(697, 'akaunting', 703, 'Profra Rocío', NULL, NULL, '+52 627 102 5075', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(698, 'akaunting', 704, 'Manuel Carmona', NULL, NULL, '+52 627 517 2204', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(699, 'akaunting', 705, 'Esc. Prim. Melchor Gándara 2056', NULL, NULL, '+52 627 106 3237', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(700, 'akaunting', 706, 'Sujey Hinojos', NULL, NULL, '+52 1 627 174 4654', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(701, 'akaunting', 707, 'Martha Sandoval', NULL, NULL, '627 103 5717', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(702, 'akaunting', 708, 'Mercedes Moreno', NULL, NULL, '6491038565', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(703, 'akaunting', 709, 'Elizabeth', NULL, NULL, '+52 649 197 4152', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(704, 'akaunting', 710, 'Perla Yaritza', NULL, NULL, '+52 627 150 8576', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(705, 'akaunting', 711, 'Martín Villanueva', NULL, NULL, '6271236091', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(706, 'akaunting', 712, 'Gloria García', NULL, NULL, '+52 627 112 5928', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(707, 'akaunting', 713, 'Sarahi Torres', NULL, NULL, '+52 627 132 7910', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(708, 'akaunting', 714, 'Supervisión Escolar Zona 146', NULL, NULL, '6271119351', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(709, 'akaunting', 715, 'Nuvia García Holguín', NULL, NULL, '6295216667', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(710, 'akaunting', 716, 'Isabel Negrete', NULL, NULL, '+52 627 148 5678', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(711, 'akaunting', 717, 'Esc. Ángel Trias Álvarez', NULL, NULL, '6271231361', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(712, 'akaunting', 718, 'USAER 142', NULL, NULL, '+52 627 123 4990', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(713, 'akaunting', 719, 'Flor Salas', NULL, NULL, '+52 627 142 8638', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(714, 'akaunting', 720, 'Fredy', NULL, NULL, '+52 627 177 9377', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(715, 'akaunting', 721, 'Elizabeth Zamora', NULL, NULL, '6271238307', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(716, 'akaunting', 722, 'Flor', NULL, NULL, '+52 656 296 8357', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(717, 'akaunting', 723, 'Sergio Saenz', NULL, NULL, '+52 614 105 8212', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(718, 'akaunting', 724, 'Romina', NULL, NULL, '+52 627 142 0957', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(719, 'akaunting', 725, 'Oly', NULL, NULL, '+52 649 106 1524', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(720, 'akaunting', 726, 'Alexa', NULL, NULL, '+52 627 121 0906', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(721, 'akaunting', 727, 'Margarita chaparro', NULL, NULL, '6271070846', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(722, 'akaunting', 728, 'Aracely Gutierrez', NULL, NULL, '6271122192', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(723, 'akaunting', 729, 'Margarita Shaccid', NULL, NULL, '+52 627 121 0337', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(724, 'akaunting', 730, 'Vianey Gamez Rodriguez', NULL, NULL, '+52 449 151 4042', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(725, 'akaunting', 731, 'Yosamara Pantoja', NULL, NULL, '6863532815', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(726, 'akaunting', 732, 'Erika Delgado', NULL, NULL, '6271112755', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(727, 'akaunting', 733, 'Myriam Baca Rodríguez', NULL, NULL, '6271193707', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(728, 'akaunting', 734, 'Ferretería Yavireza S.A. de C,V,', NULL, NULL, '6491964868', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(729, 'akaunting', 735, 'María Guadalupe Zavala López', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(730, 'akaunting', 736, 'Lorena Martinez', NULL, '|', '6271033929', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(731, 'akaunting', 737, 'Reina Martínez', NULL, NULL, '6271434053', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(732, 'akaunting', 738, 'Yazmin Chávez', NULL, NULL, '6271773303', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(733, 'akaunting', 739, 'Paulina Navarro', NULL, NULL, '6271048292', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(734, 'akaunting', 740, 'María Elena Rodríguez', NULL, NULL, '6271352317', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(735, 'akaunting', 741, 'Raquel Carrera', NULL, NULL, '6271237205', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(736, 'akaunting', 742, 'Yanira Ramos', NULL, NULL, '6271130864', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(737, 'akaunting', 743, 'Mostrador', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(738, 'akaunting', 744, 'Diana', NULL, NULL, '+52 627 106 0146', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(739, 'akaunting', 745, 'Patricia Palacios', NULL, NULL, '+52 627 112 3200', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(740, 'akaunting', 746, 'Esmeralda Carrillo', NULL, NULL, '6271021110', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(741, 'akaunting', 747, 'Jennifer Paloma Lopez Galvan', NULL, NULL, '6271429218', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(742, 'akaunting', 748, 'SECRETARIA DE LA DEFENSA NACIONAL RFC SDN8501014D2', NULL, NULL, NULL, 'BLVD. MANUEL AVILA CAMACHO S/N LOMAS DE SOTELO', 'CD. DE MEXICO, MX', '33825', 'MX', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(743, 'akaunting', 749, 'Yolanda', NULL, NULL, '6275211901', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(744, 'akaunting', 750, 'Gabriela Cabrera', NULL, NULL, '6271131665', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(745, 'akaunting', 751, 'Ale', NULL, NULL, '6563601311', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(746, 'akaunting', 752, 'Jonathan', NULL, NULL, '6271158049', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(747, 'akaunting', 754, 'Alejandra Portilloi', NULL, NULL, '6563601311', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(748, 'akaunting', 755, 'Escuela Primaria Emiliano Zapata', 'erikabustillos@colibriprint.com.mx', 'XAXX010101000', '6141020760', 'Jimenez', 'Jiménez', NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(749, 'akaunting', 756, 'Luisa Caro', NULL, NULL, '6271199802', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(750, 'akaunting', 757, 'Adán Quezada', NULL, NULL, '6271060784', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(751, 'akaunting', 758, 'Uride Parral', NULL, NULL, '+52 669 101 3227', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(752, 'akaunting', 759, 'Naydelin Fragoso', NULL, NULL, '6271483596', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(753, 'akaunting', 760, 'Yazmin', NULL, NULL, '6271210428', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(754, 'akaunting', 761, 'Sara, Gonzalez', NULL, NULL, '+52 627 521 9388', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(755, 'akaunting', 762, 'Omar Valenzuela', NULL, NULL, '6143784370', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(756, 'akaunting', 763, 'JOSUE SANCHEZ', NULL, NULL, '6271121988', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(757, 'akaunting', 764, 'Elizabeth Armendariz', NULL, NULL, '+52 627 524 1886', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(758, 'akaunting', 765, 'Rosa Janeth Gutierrez', NULL, NULL, '+52 627 889 9594', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(759, 'akaunting', 766, 'Alejandra Ruiz', NULL, NULL, '+52 614 513 0673', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(760, 'akaunting', 767, 'Karla Dimas', NULL, NULL, '6271088471', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(761, 'akaunting', 768, 'Fumigaciones P&P', NULL, NULL, '+52 669 274 6143', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(762, 'akaunting', 769, 'Erika Cisneros', NULL, NULL, '6271037867', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(763, 'akaunting', 770, 'Karina salón de eventos Alexa', NULL, NULL, '+52 627 106 4807', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(764, 'akaunting', 771, 'Míriam Payan', NULL, NULL, '6251090665', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(765, 'akaunting', 772, 'Esc. Club Rotario', NULL, NULL, '6271177945', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(766, 'akaunting', 773, 'Esc. Prim. Niños Héroes', NULL, NULL, '6491061524', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(767, 'akaunting', 774, 'Josue Sanchez', NULL, NULL, '6271121988', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(768, 'akaunting', 775, 'Diana Rodriguez', NULL, NULL, '+52 627 517 2150', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(769, 'akaunting', 776, 'mostrador', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(770, 'akaunting', 777, 'TELESECUNDARIA 6100', NULL, NULL, '6271118788', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(771, 'akaunting', 778, 'Esc Josefa Solis y Esc Felipe Angeles', NULL, NULL, '+52 627 117 0535', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(772, 'akaunting', 779, 'Karla Reyes', NULL, NULL, '+52 627 111 3054', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(773, 'akaunting', 780, 'Escuela Lazara Quintana', NULL, NULL, '6271076981', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(774, 'akaunting', 781, 'Mtra Gris', NULL, NULL, '+52 627 147 8586', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(775, 'akaunting', 782, 'Brisa Gutierrez', NULL, NULL, '6271126593', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(776, 'akaunting', 783, 'Yolanda Estrada', NULL, NULL, '+52 627 149 5297', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(777, 'akaunting', 784, 'Profr. Carlos', NULL, NULL, '6271023701', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(778, 'akaunting', 785, 'Martin Pinedo', NULL, NULL, '6271173773', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(779, 'akaunting', 786, 'Sergio y Reina', NULL, NULL, '+52 627 111 9268', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(780, 'akaunting', 787, 'Prof. David Rubio', NULL, NULL, '6271086276', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(781, 'akaunting', 788, 'Quinta Zona Escolar', NULL, NULL, '6271045449', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(782, 'akaunting', 789, 'Belem Gutierrez', NULL, NULL, '6271233824', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(783, 'akaunting', 790, 'Yazmín Montes Contreras', NULL, NULL, '+52 649 114 4071', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(784, 'akaunting', 791, 'Irving Arrieta', NULL, NULL, '6271024288', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(785, 'akaunting', 792, 'Héctor Borjas', NULL, NULL, '6271771100', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(786, 'akaunting', 793, 'Zona 27', NULL, NULL, '6271045449', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(787, 'akaunting', 794, 'Lorena Zambrano', NULL, NULL, '6271144963', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(788, 'akaunting', 795, 'Blanca Alonso', NULL, NULL, '6275172602', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(789, 'akaunting', 796, 'Karla Rojas', NULL, '+52 627 521 8846', NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(790, 'akaunting', 797, 'Esc. 5 de Febrero 2127', NULL, NULL, NULL, 'Ejido San Rafael', 'Mpio. de Santa Bárbara', NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(791, 'akaunting', 798, 'Macky Jurado', NULL, NULL, '+52 614 198 6988', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(792, 'akaunting', 799, 'Karmina Bautista', NULL, '+52 627 173 7898', NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(793, 'akaunting', 800, 'Inspección Escolar Zona 67 Telesecundaria', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(794, 'akaunting', 801, 'July Gonzalez', NULL, NULL, '6272869282', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(795, 'akaunting', 802, 'Paola Jacobo', NULL, NULL, '6271234441', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(796, 'akaunting', 803, 'Yaneth Fernández', NULL, NULL, '+52 1 311 746 2653', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(797, 'akaunting', 804, 'esc. Nicolás Bravo', NULL, NULL, '6491100443', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(798, 'akaunting', 805, 'Judith', NULL, NULL, '627 117 7074', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(799, 'akaunting', 806, 'María de Jesús', NULL, NULL, '+52 627 123 4990', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(800, 'akaunting', 807, 'Enriqueta Villalobos', NULL, NULL, '6271327225', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(801, 'akaunting', 808, 'Yazmín Chavez', NULL, NULL, '+52 627 177 3303', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(802, 'akaunting', 809, 'Nayar Club Campestre', NULL, NULL, '3111070607', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(803, 'akaunting', 810, 'Maestra Eneida', NULL, NULL, '6271476374', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(804, 'akaunting', 811, 'Ultra Protección', NULL, NULL, '6271111297', 'Camino Viejo a San José', 'Chihuahua', '32459', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(805, 'akaunting', 812, 'Miguel A. Soto', NULL, NULL, '6491960398', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(806, 'akaunting', 813, 'MOSTRADOR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(807, 'akaunting', 814, 'Martha Sandoval', NULL, NULL, '6271035717', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(808, 'akaunting', 815, 'Cinthia Torres', NULL, NULL, '6141734112', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(809, 'akaunting', 816, 'Armando Pro', NULL, NULL, '6291525491', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(810, 'akaunting', 817, 'Prof. Julio Espinoza', NULL, NULL, '+52 627 150 0079', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(811, 'akaunting', 818, 'YADIRA CARRILLO', NULL, NULL, '6271234906', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(812, 'akaunting', 819, 'Maestra Maribel Guerra', NULL, NULL, '6493924391', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(813, 'akaunting', 820, 'Yaretzy Berenice', NULL, NULL, '+52 649 111 7637', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(814, 'akaunting', 821, 'Elizabeth', NULL, NULL, '+52 649 197 4152', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(815, 'akaunting', 822, 'Esc prim Miguel Alemán N° 2412', NULL, NULL, '+52 627 102 5075', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(816, 'akaunting', 823, 'Miranda', NULL, NULL, '+52 627 106 5339', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(817, 'akaunting', 824, 'Preescolar Lázaro Cárdenas del Río 1267', NULL, NULL, '6391022834', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(818, 'akaunting', 825, 'Saboria', NULL, NULL, '6271437151', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(819, 'akaunting', 826, 'Alonso', NULL, NULL, '+525610759779', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(820, 'akaunting', 827, 'Bianey Vargas', NULL, NULL, '6491042467', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(821, 'akaunting', 828, 'Esc. Ángel Trías', NULL, NULL, '6271231361', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(822, 'akaunting', 829, 'Liliana Muñoz', NULL, NULL, '6271239551', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(823, 'akaunting', 830, 'Mtra Itzel', NULL, NULL, '6271733506', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(824, 'akaunting', 831, 'Esc Ma Brisia', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(825, 'akaunting', 832, 'Damaris Chaparro', NULL, NULL, '214 477 4425', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(826, 'akaunting', 833, 'Dulce Mtz.', NULL, NULL, '6271122176', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(827, 'akaunting', 834, 'Omar Gómez', NULL, NULL, '6275245961', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(828, 'akaunting', 835, 'Jazmín Pedroza', NULL, NULL, '5959518357', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(829, 'akaunting', 836, 'Esc, Carmen Tarin Ibarra', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(830, 'akaunting', 837, 'Karla Torres', NULL, NULL, '6275213399', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(831, 'akaunting', 838, 'Ángel Gutiérrez', NULL, NULL, '6271212420', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(832, 'akaunting', 839, 'María del Carmen Payan', NULL, NULL, '6491964556', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(833, 'akaunting', 840, 'Esc. Prim. Lázaro Cárdenas', NULL, NULL, '+52 627 132 1361', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(834, 'akaunting', 841, 'Ángel Loya', NULL, NULL, '+52 627 524 6976', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(835, 'akaunting', 842, 'Maquinaria y equipo de Parral', NULL, NULL, '+52 614 138 2306', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(836, 'akaunting', 843, 'YAZMIN', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(837, 'akaunting', 844, 'Brenda', NULL, NULL, '+52 627 112 8936', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(838, 'akaunting', 845, 'Andres', NULL, NULL, '+52 627 149 1080', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(839, 'akaunting', 846, 'Mariela Mariscal', NULL, NULL, '6674187117', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(840, 'akaunting', 847, 'Cuartel militar', NULL, NULL, '+52 342 101 4689', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(841, 'akaunting', 848, 'Edelmira Flores', NULL, NULL, '6271493751', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(842, 'akaunting', 849, 'Victor', NULL, NULL, '+52 627 117 3889', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(843, 'akaunting', 850, 'Sonia', NULL, NULL, '6272796473', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(844, 'akaunting', 851, 'Rocío Saldaña', NULL, NULL, '+52 627 111 8107', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(845, 'akaunting', 852, 'Erika Yudith Chávez', NULL, NULL, '+52 627 150 4484', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(846, 'akaunting', 853, 'Malú Sevares', NULL, NULL, '+52 55 5401 0805', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(847, 'akaunting', 854, 'Iván', NULL, NULL, '+52 614 209 8597', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(848, 'akaunting', 855, 'Dime empresa', 'servicio.mist@gmail.com', NULL, '+52 878 788 9550', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(849, 'akaunting', 856, 'Mtra Soco', NULL, NULL, '+52 627 106 8751', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(850, 'akaunting', 857, 'Ricardo Lerma', NULL, NULL, '+52 627 119 4167', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(851, 'akaunting', 858, 'Alejandra Horta', NULL, NULL, '+52 627 143 4776', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(852, 'akaunting', 859, 'Alberca Semiolìmpica INMUNODEPA', NULL, NULL, '6271230333', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(853, 'akaunting', 860, 'Miranda', NULL, NULL, '6491130587', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(854, 'akaunting', 861, 'Yoana Villar', NULL, NULL, '627 148 9435', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(855, 'akaunting', 862, 'Ximena', NULL, NULL, '6272875707', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(856, 'akaunting', 863, 'Ana Ríos', NULL, NULL, '+1 (575) 312-7619', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(857, 'akaunting', 864, 'Adriana', NULL, NULL, '+52 627 115 2175', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(858, 'akaunting', 865, 'Alejandra Soto', NULL, NULL, '627 131 3895', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(859, 'akaunting', 866, 'Departamento de bomberos', NULL, NULL, '6271162255', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(860, 'akaunting', 867, 'Mostrador', NULL, NULL, '+52 649 115 5302', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(861, 'akaunting', 868, 'Alberto Moreno', NULL, NULL, '6491155302', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(862, 'akaunting', 869, 'Jazmin Lugo', NULL, NULL, '6271067389', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(863, 'akaunting', 870, 'Rubí Campos Gallardo', NULL, NULL, '656 298 9351', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(864, 'akaunting', 871, 'Elizabeth Caldera', NULL, NULL, '+52 627 123 9176', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(865, 'akaunting', 872, 'Karely', NULL, NULL, '+52 627 113 2106', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(866, 'akaunting', 873, 'Anel', NULL, NULL, '+52 627 144 6222', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(867, 'akaunting', 874, 'Janeth', NULL, NULL, '+52 627 143 1168', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(868, 'akaunting', 875, 'Mtra Moni', NULL, NULL, '+52 627 147 4312', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(869, 'akaunting', 876, 'Karla', NULL, NULL, '6271126331', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(870, 'akaunting', 877, 'Dpto. Médico Cerca de Ti', NULL, NULL, '+52 627 889 6997', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(871, 'akaunting', 878, 'Selene Rocha', NULL, NULL, '+52 614 253 2134', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(872, 'akaunting', 879, 'Esc. Prim. Victor Hugo Rascón Banda', NULL, NULL, NULL, '08DPR2610D', NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(873, 'akaunting', 880, 'Karla Rico', NULL, NULL, '+52 649 103 1194', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(874, 'akaunting', 881, 'UACH', NULL, NULL, '6271052926', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(875, 'akaunting', 882, 'Sandra Holguín', NULL, NULL, '6271110978', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(876, 'akaunting', 883, 'Roberto Caballero', NULL, NULL, '627 123 8276', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(877, 'akaunting', 884, 'Nidia', NULL, NULL, '627113338464', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(878, 'akaunting', 885, 'Patricio Rubio Lopez', NULL, NULL, '+1 (983) 777-9011', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(879, 'akaunting', 886, 'Mostrador', NULL, NULL, '+52 1 649 104 2467', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(880, 'akaunting', 887, 'Socorrito', NULL, NULL, '627 106 8751', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(881, 'akaunting', 888, 'Paola Solís', NULL, NULL, '6271170591', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(882, 'akaunting', 889, 'Jonathan', NULL, NULL, '+52 627 123 4108', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(883, 'akaunting', 890, 'Energy Industrial & Mining', NULL, NULL, '+52 627 1137573', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(884, 'akaunting', 891, 'Exploraciones Mineras Rodríguez   Lizbeth Escobar', NULL, NULL, '6271022767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(885, 'akaunting', 892, 'Janeth', NULL, NULL, '6271211790', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(886, 'akaunting', 893, 'Adrian', NULL, NULL, '627 279 8083', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(887, 'akaunting', 894, 'Gabriela', NULL, NULL, '6271069167', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(888, 'akaunting', 895, 'Gabriela Gardea', NULL, NULL, '+52 627 106 9167', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(889, 'akaunting', 896, 'Alejandra Rodriguez', NULL, NULL, '+52 627 104 9835', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(890, 'akaunting', 897, 'Georgia Unda', NULL, NULL, '+52 627 148 8352', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(891, 'akaunting', 898, 'Leinad Cano', NULL, NULL, '+52 627 517 2607', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(892, 'akaunting', 899, 'Alejandra saldivar', NULL, NULL, '6271143867', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(893, 'akaunting', 900, 'VALE MAS Leticia Palomares', NULL, NULL, '+52 627 108 9648', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(894, 'akaunting', 901, 'VALE MAS Leticia Palomares', NULL, NULL, '6271089648', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(895, 'akaunting', 902, 'Lizeth Avilene Terrazas Chávez', NULL, NULL, '6271849321', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(896, 'akaunting', 903, 'Oscar Luis de León González', NULL, NULL, '6143553662', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(897, 'akaunting', 904, 'Escuela 2101', NULL, NULL, '+52 627 142 0506', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(898, 'akaunting', 905, 'Paola', NULL, NULL, '6141266165', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(899, 'akaunting', 906, 'Ana Almeida', NULL, NULL, '+52 627 132 7449', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(900, 'akaunting', 907, 'Departamento de Bomberos', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(901, 'akaunting', 908, 'Cristina', NULL, NULL, '+52 627 108 1222', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(902, 'akaunting', 909, 'Liza Herrera', NULL, NULL, '+52 627 149 7157', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(903, 'akaunting', 910, 'Arcadio Peregrinos de Fe', NULL, NULL, '+1 (708) 770-0607', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(904, 'akaunting', 911, 'Esc. Prim. Jesús González Ortega', NULL, NULL, '627 117 0819', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(905, 'akaunting', 912, 'Energy Industrial & Mining', 'nogalerosdejimenez01@outlook.com', NULL, '+52 627 173 5178', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(906, 'akaunting', 913, 'Wiwynn Auttecs /Margarita Shaccid', NULL, NULL, '+52 627 121 0337', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(907, 'akaunting', 914, 'Sugey Acosta', NULL, NULL, '+52 627 103 4883', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(908, 'akaunting', 915, 'Samuel', NULL, NULL, '+52 627 149 9450', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(909, 'akaunting', 916, 'Delma', NULL, NULL, '+52 627 135 7934', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(910, 'akaunting', 917, 'Hazael Javier Serrano Peinado', NULL, NULL, '6271143161', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(911, 'akaunting', 918, 'Leti', NULL, NULL, '6271171876', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(912, 'akaunting', 919, 'Raúl', NULL, NULL, '+52 627 119 5852', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(913, 'akaunting', 920, 'Jardín de Niños \"Miguel Hidalgo\" 1046', NULL, NULL, '6271067389', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(914, 'akaunting', 922, 'Crece con Vales', NULL, NULL, '+52 871 709 9256', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(915, 'akaunting', 923, 'Delma Duarte', NULL, NULL, '6271357934', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(916, 'akaunting', 924, 'TALLER MAYEPSA', NULL, NULL, '6141382306', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(917, 'akaunting', 925, 'Marcial, Escobedo', NULL, NULL, '+52 649 116 5267', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(918, 'akaunting', 926, 'Esc. Constituyentes', NULL, NULL, '6143945046', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(919, 'akaunting', 927, 'Carlos Iván Martínez Chávez', NULL, NULL, '+52 627 889 8687', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(920, 'akaunting', 928, 'Guadalupe Flores', NULL, NULL, '+52 627 106 4113', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(921, 'akaunting', 929, 'Adriana Hernández', NULL, NULL, '+52 627 139 2846', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(922, 'akaunting', 930, 'Sandra', NULL, NULL, '+52 649 103 1800', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(923, 'akaunting', 931, 'MARTIN VILLANUEVA', NULL, NULL, '6271236091', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(924, 'akaunting', 932, 'Marìa Eugenia Cervantes Flores', NULL, NULL, NULL, 'calle Playa Guayabitos 123\r\ncol Desarrollo San Pablo', 'Querétaro.', '76125', NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(925, 'akaunting', 933, 'Patricia Núñez', NULL, NULL, '+52 55 2112 0915', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(926, 'akaunting', 934, 'Eva Villalobos', NULL, NULL, '+52 627 111 9600', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(927, 'akaunting', 935, 'Diana Villanueva', NULL, NULL, '+52 627 112 3704', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(928, 'akaunting', 936, 'Jonathan Portillo', NULL, NULL, '+52 627 114 7105', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(929, 'akaunting', 937, 'Martha Elena Méndez', NULL, NULL, '+52 627 524 5620', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(930, 'akaunting', 938, 'Ariana Denisse Ramirez Sánchez', NULL, NULL, '+52 627 521 7596', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(931, 'akaunting', 939, 'Lázaro Cárdenas', NULL, NULL, '+52 656 551 1843', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(932, 'akaunting', 940, 'Griselda, Hinojos', NULL, NULL, '6271060311', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(933, 'akaunting', 941, 'Kenia Astorga', NULL, NULL, '+52 627 139 4938', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(934, 'akaunting', 942, 'Nancy Vazquez', NULL, NULL, '6271313345', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(935, 'akaunting', 943, 'Joaquin Olivas Ramírez', NULL, NULL, '6271310124', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13');
INSERT INTO `cp_customers` (`id`, `source_type`, `source_id`, `name`, `email`, `tax_number`, `phone`, `address`, `city`, `zip_code`, `state`, `country`, `notes`, `enabled`, `created_at`, `updated_at`) VALUES
(936, 'akaunting', 944, 'American  Style Boutique', NULL, NULL, '4491843569', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(937, 'akaunting', 945, 'Rosa Rodríguez', NULL, NULL, '6271553000', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(938, 'akaunting', 946, 'Paola Armendariz', NULL, NULL, '6278899257', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(939, 'akaunting', 947, 'Flor Lerma', NULL, NULL, '6271194167', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(940, 'akaunting', 948, 'Mtra Eneida', NULL, NULL, '+52 627 279 8449', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(941, 'akaunting', 949, 'Dianq', NULL, NULL, '6271515200', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(942, 'akaunting', 950, 'Yazmin Meza', NULL, NULL, '6271230249', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(943, 'akaunting', 951, 'Sociedad de Padres de familia Esc. Ma. Brisia Rodriguez', NULL, NULL, '+52 627 108 4473', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(944, 'akaunting', 952, 'Soledad Morales', NULL, NULL, '+52 627 103 9685', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(945, 'akaunting', 953, 'Rebeca Olivas', NULL, NULL, '6275173138', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(946, 'akaunting', 954, 'Etna Maciel', NULL, NULL, '5533437810', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(947, 'akaunting', 955, 'Jardín de niños Miguel Hidalgo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(948, 'akaunting', 956, 'Alexia Márquez', NULL, NULL, '6291111099', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(949, 'akaunting', 957, 'X-POOLS PISCINAS DE FIBRA DE VIDRIO', NULL, NULL, '6491964935', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(950, 'akaunting', 958, 'Diana', NULL, NULL, '+52 627 106 9781', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(951, 'akaunting', 959, 'Erika Aldana', NULL, NULL, '627528402', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(952, 'akaunting', 960, 'MACLEAN ENGINEERING MEXICANA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(953, 'akaunting', 961, 'HG Carpintería', NULL, NULL, '627 119 4344', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(954, 'akaunting', 962, 'Daniel Rivera', NULL, NULL, '+52 627 174 1088', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(955, 'akaunting', 963, 'Verónica de la O', NULL, NULL, '+52 627 114 6399', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(956, 'akaunting', 964, 'Daysi', NULL, NULL, '6271324953', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(957, 'akaunting', 965, 'DIF Municipal Parral', NULL, NULL, '+52 627 114 0510', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(958, 'akaunting', 966, 'Sonia Hernández,', NULL, NULL, '+52 627 108 9993', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(959, 'akaunting', 967, 'Ana', NULL, NULL, '+52 614 284 8733', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(960, 'akaunting', 968, 'Lizeth Betancourt', NULL, NULL, '6181686565', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(961, 'akaunting', 969, 'Jardín de niños Miguel Hidalgo', NULL, NULL, '+52 627 106 7389', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(962, 'akaunting', 970, 'Ana Ochoa / Lupita Rico', NULL, NULL, '+52 627 114 1023', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(963, 'akaunting', 971, 'Brenda Holguín', NULL, NULL, '+52 627 524 7539', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(964, 'akaunting', 972, 'Ricardo Jacobo', NULL, NULL, '+52 627 108 6296', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(965, 'akaunting', 973, 'Aracely Montes porfas', NULL, NULL, '+52 627 119 0312', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(966, 'akaunting', 974, 'Karla Sotelo', NULL, NULL, '6271022258', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(967, 'akaunting', 975, 'Karla Jurado', NULL, NULL, '+52 627 119 3658', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(968, 'akaunting', 976, 'Lucero Rodriguez', NULL, NULL, '+52 627 150 6708', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(969, 'akaunting', 977, 'Cristian Carbajal', NULL, NULL, '+52 627 131 7553', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(970, 'akaunting', 978, 'América Núñez', NULL, NULL, '+52 627 102 1095', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(971, 'akaunting', 979, 'Gustavo Zapien', NULL, NULL, '6272031650', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(972, 'akaunting', 980, 'Esc. Prim. Emiliano Zapata', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(973, 'akaunting', 981, 'Esc. Prim. Ford 80', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(974, 'akaunting', 982, 'Ing Marco DG PUBLICIDAD', NULL, NULL, '6271031075', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(975, 'akaunting', 983, 'Tere Uribe', NULL, NULL, '+52 627 114 5212', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(976, 'akaunting', 984, 'Mayra', NULL, NULL, '6271746889', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(977, 'akaunting', 985, 'Adriana Piña', NULL, NULL, '6143541623', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(978, 'akaunting', 986, 'Elizabeth', NULL, NULL, '6271064484', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(979, 'akaunting', 987, 'Mtra Lore', NULL, NULL, '6272798826', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(980, 'akaunting', 988, 'Hg carpinteria', NULL, NULL, '6271194344', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(981, 'akaunting', 989, 'Rosy', NULL, NULL, '6271331129', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(982, 'akaunting', 990, 'Alejandra Pérez', NULL, NULL, '+52 625 589 8787', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(983, 'akaunting', 991, 'Jorge Bilbao', NULL, NULL, '6278895424', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(984, 'akaunting', 992, 'Carniceria Arredondo', NULL, NULL, '+52 649 101 4135', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(985, 'akaunting', 993, 'Marisol Armendariz', NULL, NULL, '+52 627 117 9955', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(986, 'akaunting', 994, 'Elena', NULL, NULL, '+52 627 133 0368', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(987, 'akaunting', 995, 'Samantha González', NULL, NULL, '+52 627 521 0215', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(988, 'akaunting', 996, 'Leticia García Imagen Arquitectónica Luferab', NULL, NULL, '+52 55 5453 6079', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(989, 'akaunting', 997, 'Fernando Chávez', NULL, NULL, '+52 627 139 6316', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(990, 'akaunting', 998, 'Agustina Chavez', NULL, NULL, '+52 627 103 8861', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(991, 'akaunting', 999, 'Norberto Hernández Alvarado', NULL, NULL, '+52 627 111 9414', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(992, 'akaunting', 1000, 'Omar Sáenz', NULL, NULL, '6271321705', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(993, 'akaunting', 1001, 'Carlos Villezcas', NULL, NULL, '+52 627 120 5139', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(994, 'akaunting', 1002, 'Yenni Escárcega', NULL, NULL, '6271132974', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(995, 'akaunting', 1003, 'Carolina Moreno', NULL, NULL, '+52 627 121 3207', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(996, 'akaunting', 1004, 'Naomi', NULL, NULL, '+52 627 178 2092', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(997, 'akaunting', 1005, 'Karla Lugo', NULL, NULL, '+52 627 173 9313', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(998, 'akaunting', 1006, 'Juana Maria Hernández Hernández', NULL, NULL, '+52 627 103 9587', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(999, 'akaunting', 1007, 'Perla', NULL, NULL, '+52 627 112 4562', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1000, 'akaunting', 1008, 'Antonio Rodriguez Rodriguez', NULL, NULL, '6271039530', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1001, 'akaunting', 1009, 'Escuela Telesecundaria Agua amarilla', NULL, NULL, '6271121052', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1002, 'akaunting', 1010, 'Mario', NULL, NULL, '+52 614 196 8919', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1003, 'akaunting', 1011, 'Mario Aguirre', NULL, NULL, '+52 614 196 8919', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1004, 'akaunting', 1012, 'MARIO AGUIRRE', NULL, NULL, '6141968919', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1005, 'akaunting', 1013, 'Marely Sotelo', NULL, NULL, '+52 627 150 7107', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1006, 'akaunting', 1014, 'Santiago Loya', NULL, NULL, '+52 614 124 9738', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1007, 'akaunting', 1015, 'Yajaira Bailon', NULL, NULL, '+52 627 521 6258', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1008, 'akaunting', 1016, 'Yazmin Jacobo', NULL, NULL, '6272797834', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1009, 'akaunting', 1017, 'Nayeli Galarza', NULL, NULL, '+52 871 572 7865', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1010, 'akaunting', 1018, 'Alberto Silva', NULL, NULL, '+52 627 112 0927', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1011, 'akaunting', 1019, 'Vianey', NULL, NULL, '+52 627 102 0301', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1012, 'akaunting', 1020, 'Martín Villanueva', NULL, NULL, '+52 627 103 6964', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1013, 'akaunting', 1021, 'Escuela: Carlos Pacheco  DPR: 08DPR00S5', NULL, NULL, '+52 614 604 1414', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1014, 'akaunting', 1022, 'Carniceria Baez', NULL, NULL, '+52 627 117 5152', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1015, 'akaunting', 1023, 'Bertha', NULL, NULL, '6271041649', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1016, 'akaunting', 1024, 'Tania Portillo Núñez', NULL, NULL, '+52 627 143 0545', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1017, 'akaunting', 1025, 'Lorena Gallardo', NULL, NULL, '6271500702', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1018, 'akaunting', 1026, 'José Ramírez', NULL, NULL, '+52 627 102 0530', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1019, 'akaunting', 1027, 'Marcel a Martínez OPTIMA IMPRESION', 'admin@optimaimpresion.net', NULL, '5555889562', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1020, 'akaunting', 1028, 'Adriana', NULL, NULL, '+52 627 115 2543', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1021, 'akaunting', 1029, 'Dra Maria Reyna Hernández', NULL, NULL, '+52 627 102 6829', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1022, 'akaunting', 1030, 'Nallely Escápita', NULL, NULL, '6141198804', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1023, 'akaunting', 1031, 'Cinthya Gonzalez', NULL, NULL, '6271475050', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1024, 'akaunting', 1032, 'Genesis', NULL, NULL, '+52 627 112 1418', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1025, 'akaunting', 1033, 'Taco Tacos', NULL, NULL, '+52 627 133 0955', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1026, 'akaunting', 1034, 'Colegio de Bachilleres del Estado de Chihuahua', NULL, NULL, '6271170535', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1027, 'akaunting', 1035, 'Marissa Torres', NULL, NULL, '6271114140', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1028, 'akaunting', 1036, 'Salma jamileth Hernández Banderas', NULL, NULL, '+52 627 173 5363', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1029, 'akaunting', 1037, 'Vitoria Molina', NULL, NULL, '+52 627 142 4690', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1030, 'akaunting', 1038, 'Esc Prim. Josefa Salís De Lozoya', NULL, NULL, '+52 627 889 7324', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1031, 'akaunting', 1039, 'Estrella Pérez', NULL, NULL, '+52 627 133 1315', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1032, 'akaunting', 1040, 'Edwin Sotelo', NULL, NULL, '+52 627 139 7424', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1033, 'akaunting', 1041, 'Adriana Troncoso', NULL, NULL, '+52 618 804 9903', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1034, 'akaunting', 1042, 'Melissa Cañas', NULL, NULL, '+52 627 120 8440', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1035, 'akaunting', 1043, 'Tele bachillerato 8650', NULL, NULL, '+52 627 111 7298', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1036, 'akaunting', 1044, 'Esc Prim Jesús González Ortega', NULL, NULL, '+52 627 117 0819', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1037, 'akaunting', 1045, 'Juan Hernández', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1038, 'akaunting', 1046, 'Ana', NULL, NULL, '+52 614 284 8733', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1039, 'akaunting', 1047, 'GRUPO COMERCIAL BUJAIDAR', NULL, NULL, '+52 614 173 4112', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1040, 'akaunting', 1048, 'Jardín de Niños Malintzin', NULL, NULL, '+52 627 113 6616', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1041, 'akaunting', 1049, 'Rita', NULL, NULL, '+52 627 113 2380', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1042, 'akaunting', 1050, 'Esc Prim Ford 190 TM', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1043, 'akaunting', 1051, 'Karla Mireles', NULL, NULL, '6271231883', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1044, 'akaunting', 1052, 'Guadalupe Ramos', NULL, NULL, '6272795371', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1045, 'akaunting', 1053, 'Gerardo Nájera', NULL, NULL, '6271776570', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1046, 'akaunting', 1054, 'Norma Aracely', NULL, NULL, '6271337267', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1047, 'akaunting', 1055, 'Ivan Palacios', NULL, NULL, '+52 55 6476 6784', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1048, 'akaunting', 1056, 'Arlet', NULL, NULL, '6271501216', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1049, 'akaunting', 1057, 'Lina Vargas', NULL, NULL, '+52 627 133 0947', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1050, 'akaunting', 1058, 'Vivero El pequeño Paraíso', NULL, NULL, '+52 627 102 0659', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1051, 'akaunting', 1059, 'Daniel Sandoval', NULL, NULL, '+52 627 133 6340', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1052, 'akaunting', 1060, 'Cindy Roacho', NULL, NULL, '+52 627 133 4837', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1053, 'akaunting', 1061, 'Asael Chávez', NULL, NULL, '+52 627 113 4489', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1054, 'akaunting', 1062, 'Pastoral Penitenciaria Católica', NULL, NULL, '+52 627 112 8871', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1055, 'akaunting', 1063, 'Pauliana Lerma', NULL, NULL, '+52 627 117 7658', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1056, 'akaunting', 1064, 'Esc Prim 20 de Noviembre', NULL, NULL, '+52 649 196 1075', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1057, 'akaunting', 1065, 'Damaris Baca', NULL, NULL, '+52 627 524 5708', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1058, 'akaunting', 1066, 'Verónica Arras', NULL, NULL, '+52 627 123 9341', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1059, 'akaunting', 1067, 'Esc. Prim. Álvaro Obregón', NULL, NULL, '6271499450', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1060, 'akaunting', 1068, 'Esc Prim Josefa Solis de Lozoya', NULL, NULL, '+52 627 889 7324', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1061, 'akaunting', 1069, 'Esc Prim Club Rotario', NULL, '+52 627 117 7945', NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1062, 'akaunting', 1070, 'Lizbeth Escobar', NULL, NULL, '+52 627 102 2767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1063, 'akaunting', 1071, 'Rolando Carrasco', NULL, NULL, '6271737348', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1064, 'akaunting', 1072, 'Dennysse Favela', NULL, NULL, '+52 627 106 9320', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1065, 'akaunting', 1073, 'Pollo Reinaga', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1066, 'akaunting', 1074, 'Idalia', NULL, NULL, '6141608826', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1067, 'akaunting', 1075, 'Juan Rocha', NULL, NULL, '+52 627 119 6525', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1068, 'akaunting', 1076, 'Fernanda Holguín', NULL, NULL, '+52 627 114 0825', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1069, 'akaunting', 1077, 'Supervisión Zona #67', NULL, NULL, '+52 627 106 6414', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1070, 'akaunting', 1078, 'Cynthia Barragán', NULL, NULL, '+52 656 360 7135', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1071, 'akaunting', 1079, 'Alejandra Hernández', NULL, NULL, '+52 627 150 6920', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1072, 'akaunting', 1080, 'Esc Prim Guillermo Baca', NULL, NULL, '+52 627 119 3778', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1073, 'akaunting', 1081, 'Mtra Rocio', NULL, NULL, '+52 627 102 5075', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1074, 'akaunting', 1082, 'Sol Rivas', NULL, NULL, '+52 627 115 7453', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1075, 'akaunting', 1083, 'Erik Orpineda', NULL, NULL, '6271426574', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1076, 'akaunting', 1084, 'Kevin González', NULL, NULL, '+52 627 150 3372', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1077, 'akaunting', 1085, 'Jazmin Rodríguez', NULL, NULL, '+52 627 131 2966', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1078, 'akaunting', 1086, 'Jonathan Molina', NULL, NULL, '+52 649 196 5631', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1079, 'akaunting', 1087, 'SERVICIOS Y DESTILERIA SR', NULL, NULL, '+52 627 102 2767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1080, 'akaunting', 1088, 'Georgina Escapita', NULL, NULL, '+52 627 148 2590', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1081, 'akaunting', 1089, 'Colegio de Bachilleres del Estado de Chihuaha Plantel 12', NULL, NULL, '6271049290', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1082, 'akaunting', 1090, 'Riquelme Pizarro', NULL, NULL, '+52 649 110 4507', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1083, 'akaunting', 1091, 'Naomi Guevara', 'mktdpso@gmail.com', 'DPS190123PX6', '+524424744504', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1084, 'akaunting', 1092, 'Elder Esduardo Bojorquez Loya', NULL, NULL, '6491147133', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1085, 'akaunting', 1093, 'Sarahí Blanco', NULL, NULL, '+52 627 104 7289', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1086, 'akaunting', 1094, 'Silvia Nañez', NULL, NULL, '6271080335', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1087, 'akaunting', 1095, 'Yazmin', NULL, NULL, '+52 627 117 1876', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1088, 'akaunting', 1096, 'Brenda Rocio Ponce', NULL, NULL, '6271733497', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1089, 'akaunting', 1097, 'Mayra Villalobos', NULL, NULL, '+52 627 108 4627', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1090, 'akaunting', 1098, 'Bety', NULL, NULL, '6275241886', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1091, 'akaunting', 1099, 'María Campuzano', NULL, NULL, '627 110 5062', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1092, 'akaunting', 1100, 'Felix Pedroza', NULL, NULL, '+52 614 279 7909', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1093, 'akaunting', 1101, 'Blanca Soto', NULL, NULL, '6271063116', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1094, 'akaunting', 1102, 'Comedores Industriales de México', NULL, NULL, '+52 662 307 9112', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1095, 'akaunting', 1103, 'Uriel Pérez', NULL, NULL, '+52 627 279 8712', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1096, 'akaunting', 1104, 'Transportes El Oro Durango / Bere', NULL, NULL, '+52 627 521 3324', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1097, 'akaunting', 1105, 'Karina Bravo', NULL, NULL, '6275172866', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1098, 'akaunting', 1106, 'Perla Corral', NULL, NULL, '+52 627 103 6204', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1099, 'akaunting', 1107, 'Nallely Ontiveros', NULL, NULL, '+52 627 107 8719', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1100, 'akaunting', 1108, 'Comisariado Ejidal \"Ejido El Toro\"', NULL, NULL, '+52 627 113 9323', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1101, 'akaunting', 1109, 'Quinta Zona Escolar', NULL, NULL, '+52 627 119 3778', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1102, 'akaunting', 1110, 'Gamaliel Morúa Chávez', NULL, NULL, '+52 649 111 2139', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1103, 'akaunting', 1111, 'Itzel Rivas', NULL, NULL, '+52 627 139 1091', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1104, 'akaunting', 1112, 'Aron', NULL, NULL, '627 121 9783', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1105, 'akaunting', 1113, 'Celeste Villa', NULL, NULL, '6271741116', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1106, 'akaunting', 1114, 'Héctor Ivan Aguilera', NULL, NULL, '+52 627 117 2756', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1107, 'akaunting', 1115, 'Saira Ayala', NULL, NULL, '+52 627 112 6301', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1108, 'akaunting', 1116, 'Lucia Sandoval', NULL, NULL, '6271140441', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1109, 'akaunting', 1117, 'Josué Arellanes', NULL, NULL, '+52 614 684 3614', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1110, 'akaunting', 1118, 'Ruth Ramirez', NULL, NULL, '627 889 8316', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1111, 'akaunting', 1119, 'Kimberly Molina', NULL, NULL, '+52 627 111 3099', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1112, 'akaunting', 1120, 'María del Carmen Gamez Torres', NULL, NULL, '+52 614 184 4269', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1113, 'akaunting', 1121, 'Nallely  Sáenz', NULL, NULL, '6371039661', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1114, 'akaunting', 1122, 'Primaria Felipe Ángeles Álvarez #2426', NULL, NULL, '+52 627 102 7767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1115, 'akaunting', 1123, 'Jorge   Venegas', NULL, NULL, '6144632485', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1116, 'akaunting', 1124, 'Sarahy Castillo', NULL, NULL, '+52 627 149 7877', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1117, 'akaunting', 1125, 'Silvana', NULL, NULL, '+52 627 123 3454', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1118, 'akaunting', 1126, 'Silvana', NULL, NULL, '+52 627 123 3454', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1119, 'akaunting', 1127, 'URN PARRAL', NULL, NULL, '6271027893', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1120, 'akaunting', 1128, 'Yolanda Guadalupe', NULL, NULL, '+52 627 113 0465', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1121, 'akaunting', 1129, 'Esc prim Jesús Gonzalez Ortega', NULL, NULL, '+52 627 117 0819', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1122, 'akaunting', 1130, 'Supervisión Escolar Zona 146', NULL, NULL, '+52 627 111 9351', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1123, 'akaunting', 1131, 'Paty', NULL, NULL, '+52 627 524 5228', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1124, 'akaunting', 1132, 'Jesus Holguín Coordinador Diocesano PF', NULL, NULL, '+52 627 132 7232', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1125, 'akaunting', 1133, 'Susana Martinez', NULL, NULL, '+52 627 106 7142', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1126, 'akaunting', 1134, 'Idalia Olivas', NULL, NULL, '6271507476', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1127, 'akaunting', 1135, 'Eimee Padrón', NULL, NULL, '+52 627 123 3976', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1128, 'akaunting', 1136, 'Neyry Gutiérrez', NULL, NULL, '6271496448', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1129, 'akaunting', 1137, 'Profe Carlos', NULL, NULL, '6271023701', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1130, 'akaunting', 1138, 'Vianey Gamez Rodríguez', NULL, NULL, '+52 618 110 6540', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1131, 'akaunting', 1139, 'Dany Chávez', NULL, NULL, '627 148 2650', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1132, 'akaunting', 1140, 'Jazmin Bustillos', NULL, NULL, '627 173 8644', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1133, 'akaunting', 1141, 'Axel Gutièrrez', NULL, NULL, '6271515200', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1134, 'akaunting', 1142, 'Multiservicios el Granillo', NULL, NULL, '6272799567', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1135, 'akaunting', 1143, 'Alberto de la Garza', NULL, NULL, '+52 614 231 1298', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1136, 'akaunting', 1144, 'Esc Prim Ford 190', NULL, NULL, '+52 627 150 0140', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1137, 'akaunting', 1145, 'Esc Prim Ford 190 TV', NULL, NULL, '+52 656 148 9842', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1138, 'akaunting', 1146, 'Rocío Sáenz', NULL, NULL, '+52 627 119 3778', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1139, 'akaunting', 1147, 'Gloria Verónica Garcia Herrera', NULL, NULL, '614 151 1101', NULL, 'Hidalgo del Parral', '33800', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1140, 'akaunting', 1148, 'Esc. Prim. Vicente Guerrero', NULL, NULL, '+52 627 173 3506', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1141, 'akaunting', 1149, 'Escuela primaria Insurgentes', NULL, NULL, '+52 627 279 7834', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1142, 'akaunting', 1150, 'Supervisión General del Sector 29', NULL, NULL, '6275212311', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1143, 'akaunting', 1151, 'Esc Prim Carlos Pacheco', NULL, NULL, '6561138279', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1144, 'akaunting', 1152, 'Marisol Holguín', NULL, NULL, '+52 627 121 1632', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1145, 'akaunting', 1153, 'Karely Muñoz', NULL, NULL, '+52 627 143 1846', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1146, 'akaunting', 1154, 'Meny', NULL, NULL, '+52 627 521 5958', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1147, 'akaunting', 1155, 'Luis David Gardea', NULL, NULL, '+52 627 104 8788', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1148, 'akaunting', 1156, 'Silvia', NULL, NULL, '627 108 0335', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1149, 'akaunting', 1157, 'Sra Licha', NULL, NULL, '+52 627 177 9766', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1150, 'akaunting', 1158, 'Sociedad de padres de familia esc Ma Brisia', NULL, NULL, '6271112877', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1151, 'akaunting', 1159, 'Fernanda', NULL, NULL, '6271134989', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1152, 'akaunting', 1160, 'Arq. Vivian', NULL, NULL, '+52 627 123 6928', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1153, 'akaunting', 1161, 'Qualitas Compañía de Seguros', NULL, NULL, '+52 627 889 1998', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1154, 'akaunting', 1162, 'Comité de Graduación  XX', NULL, NULL, '6271052926', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1155, 'akaunting', 1163, 'Ana', NULL, NULL, '+52 614 284 8733', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1156, 'akaunting', 1164, 'Kevin Frausto', NULL, NULL, '+52 629 521 2000', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1157, 'akaunting', 1165, 'Verónica Acosta', NULL, NULL, '+52 629 101 0396', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1158, 'akaunting', 1166, 'Martha', NULL, NULL, '6563182829', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1159, 'akaunting', 1167, 'Alejandra Hernández', NULL, NULL, '627 150 6920', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1160, 'akaunting', 1168, 'Olga Aurora Rubio Rubio', NULL, NULL, '614 593 8517', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1161, 'akaunting', 1169, 'La villita', NULL, NULL, '627 123 6091', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1162, 'akaunting', 1170, 'Esc prim Lázaro cárdenas', NULL, NULL, '6271035080', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1163, 'akaunting', 1171, 'JN MIGUEL HIDALGO 1046', NULL, NULL, '+52 627 106 7389', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1164, 'akaunting', 1172, 'Juan Rodríguez', NULL, NULL, '+52 627 114 7398', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1165, 'akaunting', 1173, 'Lupita', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1166, 'akaunting', 1174, 'MITZY ANAHI', NULL, NULL, '627147085', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1167, 'akaunting', 1175, 'mitzy', NULL, NULL, '62774', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1168, 'akaunting', 1176, 'Autopartes San Vicente', NULL, NULL, '+52 627 119 5317', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1169, 'akaunting', 1177, 'Selina', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1170, 'akaunting', 1178, 'Shantal Dominguez', NULL, NULL, '+1 (970) 980-8355', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1171, 'akaunting', 1179, 'María Fernanda Holguín', NULL, NULL, '+52 627 114 0825', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1172, 'akaunting', 1180, 'ZONA ESCOLAR 142', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1173, 'akaunting', 1181, 'Luis Ituare', NULL, NULL, '+52 649 104 3735', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1174, 'akaunting', 1182, 'Esc 5 de febrero 2127', NULL, NULL, '+52 627 279 3722', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1175, 'akaunting', 1183, 'Lupita Loya', NULL, NULL, '+52 649 196 5488', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1176, 'akaunting', 1184, 'Myriam Fernández', NULL, NULL, '+52 627 150 0275', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1177, 'akaunting', 1185, 'Ana Cristina Martinez Arrieta', NULL, NULL, '+52 844 808 8223', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1178, 'akaunting', 1186, 'Giselle', NULL, NULL, '+52 627 158 4746', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1179, 'akaunting', 1187, 'Transformacion y Servicios Metalúrgicos', NULL, NULL, '+52 627 174 0590', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1180, 'akaunting', 1188, 'aneth nuñez', NULL, NULL, '627 177 5757', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1181, 'akaunting', 1189, 'Erazu Heredia', NULL, NULL, '6271049951', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1182, 'akaunting', 1190, 'Esc Prim 20 de Noviembre', NULL, NULL, '+52 649 196 1075', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1183, 'akaunting', 1191, 'Rosa María García', NULL, NULL, '6275203040', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1184, 'akaunting', 1192, 'Sec Tec No. 36', NULL, NULL, '+52 627 106 3595', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1185, 'akaunting', 1193, 'Fátima Reynaga', NULL, NULL, '+52 81 4583 5712', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1186, 'akaunting', 1194, 'Nancy Corral', NULL, NULL, '6271117779', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1187, 'akaunting', 1195, 'Jesus Grado', NULL, NULL, '+52 649 116 7684', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1188, 'akaunting', 1196, 'Colegio Vida con Futuro', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1189, 'akaunting', 1197, 'Michel', NULL, NULL, '+52 627 279 1508', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1190, 'akaunting', 1198, 'Esc Prim Álvaro Obregón', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1191, 'akaunting', 1199, 'Diana Cortez', NULL, NULL, '6271230324', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1192, 'akaunting', 1200, 'Ignacio Soto', NULL, NULL, '+52 55 3493 3988', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1193, 'akaunting', 1201, 'Profr. Isamar', NULL, NULL, '+52 649 113 7119', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1194, 'akaunting', 1202, 'Emili Gutiérrez', NULL, NULL, '6271443406', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1195, 'akaunting', 1203, 'Santiago', NULL, NULL, '6271328321', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1196, 'akaunting', 1204, 'Municipio Valle de Zaragoza /Nayeli', NULL, NULL, '+52 627 150 1804', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1197, 'akaunting', 1205, 'Jenifer Karina Arzola Corral', NULL, NULL, '+52 674 112 3901', 'Guanacevi Durango', NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1198, 'akaunting', 1206, 'Andrea Rodríguez', NULL, NULL, '+52 648 102 4662', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1199, 'akaunting', 1207, 'Jessica Rodríguez', NULL, NULL, '+52 627 123 4286', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1200, 'akaunting', 1208, 'Celia Corral', NULL, NULL, '+52 627 139 3388', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1201, 'akaunting', 1209, 'Raquel', NULL, NULL, '+52 627 147 8317', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1202, 'akaunting', 1210, 'UNIMEX', NULL, NULL, '+52 870 148 1685', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1203, 'akaunting', 1211, 'David Remedios Ramirez López', NULL, NULL, '+52 614 314 3809', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1204, 'akaunting', 1212, 'Mtra Alejandra', NULL, NULL, '+52 649 104 9222', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1205, 'akaunting', 1213, 'Danna Paola Ortega Hernández', 'dannapaola.oh@justbetter.mx', NULL, '81 4592 8410 / 222 818 58 99', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1206, 'akaunting', 1214, 'César García', NULL, NULL, '+52 627 119 1794', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1207, 'akaunting', 1215, 'Jazmin Ortega', NULL, NULL, '+52 627 112 0213', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1208, 'akaunting', 1216, 'Rmz Shop / Ramses Márquez', NULL, NULL, '+52 627 158 2828', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1209, 'akaunting', 1217, 'Instituto Municipal de la Juventud', NULL, 'IMJ140327H50', '+52 627 119 5419', NULL, 'HIDALGO DEL PARRAL', '33880', 'CHIHUAHUA', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-24 21:31:43'),
(1210, 'akaunting', 1218, 'Javier Huereque Parral', NULL, NULL, '6271153181', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1211, 'akaunting', 1219, 'Francisco Calleros', NULL, NULL, '6271120647', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1212, 'akaunting', 1220, 'Kiara Casteñeda', NULL, NULL, '+52 627 144 4315', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1213, 'akaunting', 1221, 'Mauro Vega', NULL, NULL, '+52 627 123 4976', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1214, 'akaunting', 1222, 'Karina García', NULL, NULL, '+52 627 112 9013', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1215, 'akaunting', 1223, 'Eva Villalobos', NULL, NULL, '+52 627 111 9600', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1216, 'akaunting', 1224, 'Gisselle Rodríguez', NULL, NULL, '+52 276 136 1625', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1217, 'akaunting', 1225, 'José Ángel Luna', NULL, NULL, '6271139323', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1218, 'akaunting', 1226, 'Teresa González', NULL, NULL, '627 132 1631', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1219, 'akaunting', 1227, 'Soledad Aguirre', NULL, NULL, '+52 627 139 3171', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1220, 'akaunting', 1228, 'Julio César Arroyo', NULL, NULL, '+52 627 123 5682', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1221, 'akaunting', 1229, 'Brenda Sáenz', NULL, NULL, '+52 627 131 0473', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1222, 'akaunting', 1230, 'Leonel Alvidrez', NULL, NULL, '+52 627 173 3702', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1223, 'akaunting', 1231, 'Elena Rodríguez', NULL, NULL, '+52 627 301 0550', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1224, 'akaunting', 1232, 'Constructora Coesmi', NULL, NULL, '+52 627 121 0832', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1225, 'akaunting', 1233, 'Edgar', NULL, NULL, '6601267809', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1226, 'akaunting', 1234, 'Esc Prim 5 de Febrero', NULL, NULL, '+52 627 103 4971', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1227, 'akaunting', 1235, 'Blanca Díaz', NULL, NULL, '+52 614 523 4371', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1228, 'akaunting', 1236, 'Juanito Cobos', NULL, NULL, '+52 627 147 5954', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1229, 'akaunting', 1237, 'Marianela Lopez', NULL, NULL, '+52 649 197 5105', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1230, 'akaunting', 1238, 'Emiliano', NULL, NULL, '+52 627 103 4971', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1231, 'akaunting', 1239, 'Cecilia Valverde', NULL, NULL, '+52 627 149 3838', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1232, 'akaunting', 1240, 'Jorge Silvas', NULL, NULL, '+52 627 103 1293', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1233, 'akaunting', 1241, 'Edith Holguin', NULL, NULL, '6291011058', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1234, 'akaunting', 1242, 'Elizabeth', NULL, NULL, '+52 649 197 4152', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1235, 'akaunting', 1243, 'Laura Núñez', NULL, NULL, '+52 627 115 8697', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1236, 'akaunting', 1244, 'Nancy Campuzano', NULL, NULL, '+52 656 113 8279', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1237, 'akaunting', 1245, 'Alondra Espinoza', NULL, NULL, '+52 627 119 4960', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1238, 'akaunting', 1246, 'Grupo Minero Lozoya', NULL, NULL, '+52 627 123 3864', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1239, 'akaunting', 1247, 'Aracely Olivas', NULL, NULL, '+52 627 112 4607', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1240, 'akaunting', 1248, 'Ivette Villanueva', NULL, NULL, '+52 627 114 8646', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1241, 'akaunting', 1249, 'Jardín de niños Rosaura Zapata 1006', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1242, 'akaunting', 1250, 'Abril Alejandra Espinoza Ch.', NULL, NULL, '+52 614 495 7331', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1243, 'akaunting', 1251, 'Raúl', NULL, NULL, '+52 627 119 5852', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1244, 'akaunting', 1252, 'Dariel Alexa', NULL, NULL, '+52 627 144 9467', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1245, 'akaunting', 1253, 'Mtra Berenice', NULL, NULL, '+52 627 102 7767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13');
INSERT INTO `cp_customers` (`id`, `source_type`, `source_id`, `name`, `email`, `tax_number`, `phone`, `address`, `city`, `zip_code`, `state`, `country`, `notes`, `enabled`, `created_at`, `updated_at`) VALUES
(1246, 'akaunting', 1254, 'Alan Loera', NULL, NULL, '+52 627 147 2390', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1247, 'akaunting', 1255, 'Marta Chávez', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1248, 'akaunting', 1256, 'Janeth González', NULL, NULL, '+52 627 113 7458', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1249, 'akaunting', 1257, 'Laura', NULL, NULL, '+52 627 150 2142', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1250, 'akaunting', 1258, 'Edwin Huerta', NULL, NULL, '+52 639 154 9750', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1251, 'akaunting', 1259, 'Nubia Mendias', NULL, NULL, '+52 627 115 5810', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1252, 'akaunting', 1260, 'ILAP Ana Ruth', NULL, NULL, '+52 627 120 5614', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1253, 'akaunting', 1261, 'Nidia Chávez', NULL, NULL, '+52 627 123 5444', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1254, 'akaunting', 1262, 'Rafael', NULL, NULL, '+52 871 395 0211', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1255, 'akaunting', 1263, 'Elia Elizabeth Baca Corral', NULL, NULL, '+52 627 112 1482', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1256, 'akaunting', 1264, 'María José', NULL, NULL, '+52 613 111 9137', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1257, 'akaunting', 1265, 'Brenda', NULL, NULL, '+52 614 528 0365', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1258, 'akaunting', 1266, 'Nery Molina', NULL, NULL, '+52 627 150 6881', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1259, 'akaunting', 1267, 'Julieta Medrano', NULL, NULL, '+52 627 112 1482', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1260, 'akaunting', 1268, 'Karmina Bautista', NULL, NULL, '+52 627 173 7898', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1261, 'akaunting', 1269, 'Alejandro Salcido', NULL, NULL, '+52 656 358 3966', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1262, 'akaunting', 1270, 'HG CARPINTERIA', NULL, NULL, '+52 1 627 114 8973', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1263, 'akaunting', 1271, 'El Favorichis', NULL, NULL, '+52 627 173 4528', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1264, 'akaunting', 1272, 'Perla Herrera', NULL, NULL, '+52 627 143 5330', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
(1265, 'local', NULL, 'UACH', 'COMPRAS@UACH.COM', 'UACH8251452UD', '6271074512', 'C. ABELARDO RODRIGUEZ 22', 'PARRAL', '33815', 'CHIHUAHUA', 'MX', NULL, 1, '2026-09-17 11:42:10', '2026-09-17 11:42:10'),
(1266, 'local', NULL, 'Rocio Zapien', NULL, NULL, '+52 627 106 3168', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-19 17:04:05', '2026-09-19 17:04:05'),
(1267, 'web', NULL, 'a', NULL, NULL, '6271475889', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-19 22:27:15', '2026-09-19 22:27:15'),
(1268, 'web', NULL, 'juanita', NULL, NULL, '6271471155', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-19 22:56:42', '2026-09-19 22:56:42'),
(1269, 'web', NULL, 'denisse', NULL, NULL, '6275292647', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-20 00:01:11', '2026-09-20 00:01:11'),
(1270, 'local', NULL, 'Erika Escárcega', NULL, NULL, '+52 627 142 6277', NULL, 'Parral', NULL, 'Chih', 'MX', NULL, 1, '2026-09-21 08:29:27', '2026-09-21 09:32:50'),
(1271, 'local', NULL, 'Yaritzel', NULL, NULL, '+52 667 360 7333', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-23 10:42:49', '2026-09-23 10:42:49'),
(1272, 'local', NULL, 'Ana Karen Torres', NULL, NULL, '+52 627 119 6277', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-24 09:55:14', '2026-09-24 09:55:14'),
(1273, 'local', NULL, 'Majo Ríos', NULL, NULL, '+52 627 147 2865', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-24 10:53:40', '2026-09-24 10:53:40'),
(1274, 'local', NULL, 'Esc Primaria Leona Vicario / Mtra. Martha', NULL, NULL, '627 111 8536', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-24 18:20:56', '2026-09-24 18:20:56'),
(1275, 'local', NULL, 'Elizabeth Hinojos', NULL, NULL, '6291180402', NULL, 'HIDALGO DEL PARRAL', '33820', 'Chih.', 'MX', NULL, 1, '2026-09-25 04:49:56', '2026-09-25 04:49:56'),
(1276, 'local', NULL, 'Jesús Tec Parral', NULL, NULL, '627 120 5039', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-25 07:42:39', '2026-09-25 07:42:39'),
(1277, 'local', NULL, 'Hector Sanchez', NULL, NULL, '627 133 5870', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-25 08:09:36', '2026-09-25 08:09:36'),
(1278, 'local', NULL, 'Jesus', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-25 09:59:39', '2026-09-25 09:59:39'),
(1279, 'local', NULL, 'Jesus Planos', NULL, NULL, '627 112 1169', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-25 10:00:02', '2026-09-25 10:00:02'),
(1280, 'local', NULL, 'Ferretería Amaya', NULL, 'FAM850125G44', '6271478306', NULL, 'Hidalgo del Parral', NULL, 'Chihuahua', 'MX', NULL, 1, '2026-09-25 17:03:55', '2026-09-25 17:03:55'),
(1281, 'local', NULL, 'Celina Escárcega Ruiz', NULL, NULL, '+52 667 475 6820', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-25 19:25:07', '2026-09-25 19:26:50'),
(1282, 'local', NULL, 'Dayvasos Parral', NULL, NULL, '+52 614 177 0826', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-25 19:41:15', '2026-09-25 19:42:18');

-- --------------------------------------------------------

--
-- Table structure for table `cp_invoices`
--

CREATE TABLE `cp_invoices` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `customer_id` int(10) UNSIGNED DEFAULT NULL,
  `invoice_number` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `invoice_date` date NOT NULL,
  `subtotal` decimal(15,2) NOT NULL DEFAULT '0.00',
  `tax` decimal(15,2) NOT NULL DEFAULT '0.00',
  `total` decimal(15,2) NOT NULL DEFAULT '0.00',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `cfdi_uuid` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `updated_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cp_orders`
--

CREATE TABLE `cp_orders` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_number` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quote_id` int(10) UNSIGNED NOT NULL,
  `customer_id` int(10) UNSIGNED DEFAULT NULL,
  `status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `order_date` date NOT NULL,
  `due_date` date DEFAULT NULL,
  `responsible_user_id` int(10) UNSIGNED DEFAULT NULL,
  `total` decimal(15,2) NOT NULL DEFAULT '0.00',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `internal_notes` text COLLATE utf8mb4_unicode_ci,
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `updated_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_orders`
--

INSERT INTO `cp_orders` (`id`, `order_number`, `quote_id`, `customer_id`, `status`, `order_date`, `due_date`, `responsible_user_id`, `total`, `notes`, `internal_notes`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(11, 'OS-2026-00001', 14, 856, 'delivered', '2026-09-19', '2026-09-18', 1, 2520.00, '', '', 1, 1, '2026-09-19 10:58:01', '2026-09-23 08:33:32'),
(12, 'OS-2026-00002', 13, 1207, 'delivered', '2026-09-19', '2026-09-16', 1, 6895.00, '', '', 1, 1, '2026-09-19 11:06:45', '2026-09-21 12:28:29'),
(13, 'OS-2026-00003', 15, 1263, 'delivered', '2026-09-12', '2026-09-17', 1, 720.00, '', '', 1, 1, '2026-09-19 11:15:57', '2026-09-22 09:09:30'),
(14, 'OS-2026-00004', 16, 640, 'cancelled', '2026-09-19', '2026-09-20', 1, 620.00, '', '', 1, 1, '2026-09-19 11:41:28', '2026-09-20 15:58:30'),
(15, 'OS-2026-00005', 17, 1266, 'delivered', '2026-09-19', '2026-09-21', 1, 160.00, '', '', 1, 1, '2026-09-19 17:07:32', '2026-09-21 09:59:40'),
(16, 'OS-2026-00006', 18, 544, 'in_progress', '2026-09-19', '2026-09-26', 1, 13456.00, '', '', 1, 1, '2026-09-19 17:17:34', '2026-09-23 09:17:21'),
(17, 'OS-2026-00007', 19, 930, 'in_progress', '2026-09-19', '2026-09-22', 1, 730.00, '', '', 1, 1, '2026-09-19 17:26:26', '2026-09-26 10:31:43'),
(18, 'OS-2026-00008', 20, 340, 'in_progress', '2026-09-19', '2026-09-26', 1, 14360.80, '', '', 1, 1, '2026-09-19 18:35:39', '2026-09-23 09:23:34'),
(19, 'OS-2026-00009', 28, 1, 'cancelled', '2026-09-20', '2026-09-27', 1, 210.00, '', '', 1, 1, '2026-09-20 00:12:05', '2026-09-20 00:37:13'),
(20, 'OS-2026-00010', 29, 1, 'cancelled', '2026-09-20', '2026-09-27', 1, 150.00, '', '', 1, 1, '2026-09-20 00:23:51', '2026-09-20 00:37:16'),
(21, 'OS-2026-00011', 30, 763, 'in_progress', '2026-09-22', '2026-09-25', 1, 750.00, '', '', 1, 1, '2026-09-22 08:38:51', '2026-09-26 10:39:49'),
(22, 'OS-2026-00012', 31, 1270, 'in_progress', '2026-09-22', '2026-10-05', 1, 4374.00, '', '', 1, 1, '2026-09-22 10:38:56', '2026-09-25 13:24:49'),
(23, 'OS-2026-00013', 32, 1270, 'in_progress', '2026-09-22', '2026-09-29', 1, 1782.00, '', '', 1, 1, '2026-09-22 10:54:15', '2026-09-23 13:49:28'),
(24, 'OS-2026-00014', 34, 908, 'completed', '2026-09-22', '2026-09-23', 1, 390.00, '', '', 1, 1, '2026-09-22 14:19:56', '2026-09-24 18:34:28'),
(25, 'OS-2026-00015', 36, 769, 'delivered', '2026-09-22', '2026-09-29', 1, 100.00, '', '', 1, 1, '2026-09-22 20:46:45', '2026-09-22 20:47:36'),
(26, 'OS-2026-00016', 37, 571, 'in_progress', '2026-09-23', '2026-09-25', 1, 260.00, '', '', 1, 1, '2026-09-23 09:07:11', '2026-09-25 12:32:43'),
(27, 'OS-2026-00017', 35, 1204, 'in_progress', '2026-09-23', '2026-09-25', 1, 4550.00, '', '', 1, 1, '2026-09-23 09:58:04', '2026-09-25 00:53:48'),
(28, 'OS-2026-00018', 38, 1271, 'delivered', '2026-09-23', '2026-09-24', 1, 490.00, '', '', 1, 1, '2026-09-23 10:46:01', '2026-09-24 18:33:56'),
(29, 'OS-2026-00019', 33, 1039, 'in_progress', '2026-09-23', '2026-09-26', 1, 6622.44, '', '', 1, 1, '2026-09-23 11:08:54', '2026-09-25 11:29:18'),
(30, 'OS-2026-00020', 39, 746, 'in_progress', '2026-09-23', '2026-09-30', 1, 850.20, '', '', 1, 1, '2026-09-23 20:22:53', '2026-09-25 11:19:05'),
(31, 'OS-2026-00021', 40, 1272, 'in_progress', '2026-09-24', '2026-09-26', 1, 299.00, '', '', 1, 1, '2026-09-24 10:00:07', '2026-09-24 10:13:18'),
(32, 'OS-2026-00022', 42, 1197, 'pending', '2026-09-24', '2026-09-25', 1, 780.00, '', '', 1, 1, '2026-09-24 12:36:11', '2026-09-24 16:15:47'),
(33, 'OS-2026-00023', 43, 207, 'in_progress', '2026-09-24', '2026-09-25', 1, 640.00, '', '', 1, 1, '2026-09-24 17:37:36', '2026-09-26 10:35:06'),
(34, 'OS-2026-00024', 41, 1273, 'in_progress', '2026-09-24', '2026-10-09', 1, 580.00, '', '', 1, 1, '2026-09-24 18:28:30', '2026-09-24 21:56:12'),
(35, 'OS-2026-00025', 46, 1275, 'delivered', '2026-09-25', '2026-09-26', 1, 240.00, '', '', 1, 1, '2026-09-25 04:51:18', '2026-09-25 07:41:43'),
(36, 'OS-2026-00026', 47, 1276, 'delivered', '2026-09-25', '2026-10-09', 1, 880.00, '', '', 1, 1, '2026-09-25 07:45:03', '2026-09-25 08:32:37'),
(37, 'OS-2026-00027', 48, 1277, 'delivered', '2026-09-25', '2026-09-25', 1, 240.00, '', '', 1, 1, '2026-09-25 08:15:26', '2026-09-25 08:42:40'),
(38, 'OS-2026-00028', 49, 1279, 'delivered', '2026-09-25', '2026-10-10', 1, 320.00, '', '', 1, 1, '2026-09-25 10:22:29', '2026-09-25 10:23:13'),
(39, 'OS-2026-00029', 54, 1223, 'pending', '2026-09-25', '2026-09-26', 1, 350.00, 'Serían esos nombres \r\nGERA\r\nIAN\r\nADRIAN\r\nCHUMA Y DOÑA CONCHA\r\ny otra con el nombre de: Luis Pablo \"ñaca ñaca\"', '', 1, 1, '2026-09-25 20:37:16', '2026-09-25 21:15:02');

-- --------------------------------------------------------

--
-- Table structure for table `cp_order_history`
--

CREATE TABLE `cp_order_history` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `old_status` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `new_status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `note` text COLLATE utf8mb4_unicode_ci,
  `changed_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_order_history`
--

INSERT INTO `cp_order_history` (`id`, `order_id`, `old_status`, `new_status`, `note`, `changed_by`, `created_at`) VALUES
(45, 11, NULL, 'pending', 'Orden creada desde CP-2026-00002', 1, '2026-09-19 10:58:01'),
(46, 11, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-19 10:58:43'),
(47, 11, 'design', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-19 11:04:34'),
(48, 11, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-19 11:05:06'),
(49, 11, 'delivered', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-19 11:05:31'),
(50, 11, 'production', 'pending', 'Hemos recibido tu pedido y se encuentra en espera de iniciar el proceso. Te informaremos cuando avance a la siguiente etapa.', 1, '2026-09-19 11:06:05'),
(51, 12, NULL, 'pending', 'Orden creada desde CP-2026-00001', 1, '2026-09-19 11:06:45'),
(52, 12, 'pending', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-19 11:10:57'),
(53, 13, NULL, 'pending', 'Orden creada desde CP-2026-00003', 1, '2026-09-19 11:15:57'),
(54, 12, 'quality', 'pending', 'Hemos recibido tu pedido y se encuentra en espera de iniciar el proceso. Te informaremos cuando avance a la siguiente etapa.', 1, '2026-09-19 11:19:20'),
(55, 14, NULL, 'pending', 'Orden creada desde CP-2026-00004', 1, '2026-09-19 11:41:28'),
(56, 14, 'pending', 'pending', 'Sincronización manual desde cotización CP-2026-00004', 1, '2026-09-19 14:35:54'),
(57, 14, 'pending', 'in_progress', '', 1, '2026-09-19 14:36:01'),
(58, 12, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-19 16:34:59'),
(59, 14, 'in_progress', 'in_progress', 'Actualización automática desde cotización 16', 1, '2026-09-19 16:40:54'),
(60, 14, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-19 16:42:18'),
(61, 15, NULL, 'pending', 'Orden creada desde CP-2026-00005', 1, '2026-09-19 17:07:32'),
(62, 16, NULL, 'pending', 'Orden creada desde CP-2026-00006', 1, '2026-09-19 17:17:34'),
(63, 15, 'pending', 'pending', 'Actualización automática desde cotización 17', 1, '2026-09-19 17:21:24'),
(64, 17, NULL, 'pending', 'Orden creada desde CP-2026-00007', 1, '2026-09-19 17:26:26'),
(65, 18, NULL, 'pending', 'Orden creada desde CP-2026-00008', 1, '2026-09-19 18:35:39'),
(66, 11, 'pending', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-19 18:43:00'),
(67, 17, 'pending', 'pending', 'Actualización automática desde cotización 19', 1, '2026-09-19 20:24:06'),
(68, 19, NULL, 'pending', 'Orden creada desde CP-2026-00009', 1, '2026-09-20 00:12:05'),
(69, 19, 'pending', 'in_progress', '', 1, '2026-09-20 00:12:36'),
(70, 20, NULL, 'pending', 'Orden creada desde CP-2026-00010', 1, '2026-09-20 00:23:51'),
(71, 20, 'pending', 'in_progress', '', 1, '2026-09-20 00:23:57'),
(72, 20, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-20 00:26:12'),
(73, 20, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-20 00:26:15'),
(74, 20, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-20 00:26:17'),
(75, 20, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-20 00:26:20'),
(76, 20, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-20 00:26:22'),
(77, 20, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-20 00:26:25'),
(78, 19, 'in_progress', 'cancelled', 'Orden cancelada desde gestión', 1, '2026-09-20 00:37:13'),
(79, 20, 'in_progress', 'cancelled', 'Orden cancelada desde gestión', 1, '2026-09-20 00:37:16'),
(80, 14, 'design', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-20 12:15:57'),
(81, 14, 'printing', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-20 13:51:58'),
(82, 14, 'quality', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-20 13:52:38'),
(83, 14, 'printing', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-20 15:36:07'),
(84, 14, 'delivered', 'cancelled', '', 1, '2026-09-20 15:58:30'),
(85, 15, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-21 09:59:23'),
(86, 15, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-21 09:59:27'),
(87, 15, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-21 09:59:29'),
(88, 15, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-21 09:59:32'),
(89, 15, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-21 09:59:35'),
(90, 15, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-21 09:59:37'),
(91, 15, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-21 09:59:40'),
(92, 12, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-21 10:11:32'),
(93, 12, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-21 10:11:35'),
(94, 12, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-21 10:11:38'),
(95, 12, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-21 10:11:40'),
(96, 12, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-21 10:11:42'),
(97, 12, 'in_progress', 'in_progress', 'Actualización automática desde cotización 13', 1, '2026-09-21 10:14:31'),
(98, 12, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-21 12:28:29'),
(99, 13, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-21 22:26:24'),
(100, 13, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-21 22:26:27'),
(101, 13, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-21 22:26:30'),
(102, 13, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-21 22:26:35'),
(103, 13, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-21 22:26:37'),
(104, 13, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-21 22:26:42'),
(105, 17, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-22 08:08:53'),
(106, 17, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-22 08:08:56'),
(107, 17, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-22 08:09:00'),
(108, 21, NULL, 'pending', 'Orden creada desde CP-2026-00011', 1, '2026-09-22 08:38:51'),
(109, 13, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-22 09:09:30'),
(110, 22, NULL, 'pending', 'Orden creada desde CP-2026-00012', 1, '2026-09-22 10:38:56'),
(111, 23, NULL, 'pending', 'Orden creada desde CP-2026-00013', 1, '2026-09-22 10:54:15'),
(112, 24, NULL, 'pending', 'Orden creada desde CP-2026-00015', 1, '2026-09-22 14:19:56'),
(113, 24, 'pending', 'in_progress', '', 1, '2026-09-22 17:48:12'),
(114, 25, NULL, 'pending', 'Orden creada desde CP-2026-00017', 1, '2026-09-22 20:46:45'),
(115, 25, 'pending', 'in_progress', '', 1, '2026-09-22 20:46:51'),
(116, 25, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-22 20:47:18'),
(117, 25, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-22 20:47:20'),
(118, 25, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-22 20:47:23'),
(119, 25, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-22 20:47:26'),
(120, 25, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-22 20:47:30'),
(121, 25, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-22 20:47:34'),
(122, 25, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-22 20:47:36'),
(123, 11, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-23 08:33:25'),
(124, 11, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-23 08:33:29'),
(125, 11, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-23 08:33:32'),
(126, 26, NULL, 'pending', 'Orden creada desde CP-2026-00018', 1, '2026-09-23 09:07:11'),
(127, 24, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-23 09:15:17'),
(128, 24, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-23 09:15:20'),
(129, 24, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-23 09:15:22'),
(130, 24, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-23 09:15:24'),
(131, 24, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-23 09:16:38'),
(132, 18, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-23 09:16:49'),
(133, 18, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-23 09:16:52'),
(134, 18, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-23 09:16:54'),
(135, 18, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-23 09:16:57'),
(136, 16, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-23 09:17:14'),
(137, 16, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-23 09:17:16'),
(138, 16, 'approval', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-23 09:17:17'),
(139, 16, 'approval', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-23 09:17:21'),
(140, 18, 'production', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-23 09:18:21'),
(141, 23, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-23 09:19:14'),
(142, 22, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-23 09:20:07'),
(143, 22, 'design', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-23 09:20:11'),
(144, 26, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-23 09:21:05'),
(145, 26, 'design', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-23 09:21:12'),
(146, 26, 'production', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-23 09:21:16'),
(147, 22, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-23 09:22:15'),
(148, 21, 'pending', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-23 09:22:23'),
(149, 27, NULL, 'pending', 'Orden creada desde CP-2026-00016', 1, '2026-09-23 09:58:04'),
(150, 27, 'pending', 'in_progress', '', 1, '2026-09-23 09:59:49'),
(151, 27, 'pending', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-23 10:07:47'),
(152, 27, 'production', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-23 10:07:50'),
(153, 28, NULL, 'pending', 'Orden creada desde CP-2026-00019', 1, '2026-09-23 10:46:01'),
(154, 28, 'pending', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-23 10:52:08'),
(155, 29, NULL, 'pending', 'Orden creada desde CP-2026-00014', 1, '2026-09-23 11:08:54'),
(156, 29, 'pending', 'in_progress', '', 1, '2026-09-23 13:48:21'),
(157, 23, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-23 13:49:28'),
(158, 29, 'pending', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-23 17:43:12'),
(159, 29, 'in_progress', 'in_progress', 'Actualización automática desde cotización 33', 1, '2026-09-23 17:44:11'),
(160, 29, 'printing', 'pending', 'Hemos recibido tu pedido y se encuentra en espera de iniciar el proceso. Te informaremos cuando avance a la siguiente etapa.', 1, '2026-09-23 17:48:15'),
(161, 29, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-23 17:48:17'),
(162, 29, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-23 17:48:21'),
(163, 29, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-23 17:48:23'),
(164, 29, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-23 17:48:25'),
(165, 29, 'in_progress', 'in_progress', 'Actualización automática desde cotización 33', 1, '2026-09-23 17:48:51'),
(166, 24, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-23 18:15:48'),
(167, 24, 'ready', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-23 18:15:52'),
(168, 24, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-23 18:15:54'),
(169, 28, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-23 18:46:30'),
(170, 28, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-23 18:46:34'),
(171, 28, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-23 18:46:36'),
(172, 28, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-23 18:46:40'),
(173, 29, 'in_progress', 'in_progress', 'Sincronización manual desde cotización CP-2026-00014', 1, '2026-09-23 19:38:05'),
(174, 30, NULL, 'pending', 'Orden creada desde CP-2026-00020', 1, '2026-09-23 20:22:53'),
(175, 30, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-23 20:23:05'),
(176, 30, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-23 23:46:47'),
(177, 31, NULL, 'pending', 'Orden creada desde CP-2026-00021', 1, '2026-09-24 10:00:07'),
(178, 31, 'pending', 'in_progress', '', 1, '2026-09-24 10:13:01'),
(179, 31, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-24 10:13:18'),
(180, 30, 'in_progress', 'in_progress', 'Actualización automática desde cotización 39', 1, '2026-09-24 10:36:10'),
(181, 30, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-24 10:42:53'),
(182, 32, NULL, 'pending', 'Orden creada desde CP-2026-00023', 1, '2026-09-24 12:36:11'),
(183, 33, NULL, 'pending', 'Orden creada desde CP-2026-00024', 1, '2026-09-24 17:37:36'),
(184, 34, NULL, 'pending', 'Orden creada desde CP-2026-00022', 1, '2026-09-24 18:28:30'),
(185, 28, 'in_progress', 'completed', '', 1, '2026-09-24 18:33:51'),
(186, 28, 'ready', 'delivered', '', 1, '2026-09-24 18:33:56'),
(187, 24, 'in_progress', 'completed', '', 1, '2026-09-24 18:34:28'),
(188, 34, 'pending', 'in_progress', '', 1, '2026-09-24 18:37:39'),
(189, 34, 'in_progress', 'completed', '', 1, '2026-09-24 18:38:05'),
(190, 34, 'completed', 'in_progress', '', 1, '2026-09-24 18:38:33'),
(191, 34, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-24 21:56:12'),
(192, 27, 'in_progress', 'in_progress', 'Sincronización manual desde cotización CP-2026-00016', 1, '2026-09-25 00:53:48'),
(193, 30, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-25 03:57:14'),
(194, 30, 'production', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-25 03:58:04'),
(195, 35, NULL, 'pending', 'Orden creada desde CP-2026-00027', 1, '2026-09-25 04:51:18'),
(196, 35, 'pending', 'pending', 'Actualización automática desde cotización 46', 1, '2026-09-25 04:51:44'),
(197, 35, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-25 04:51:56'),
(198, 35, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-25 04:51:59'),
(199, 35, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-25 04:52:01'),
(200, 35, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-25 04:52:03'),
(201, 35, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-25 04:52:06'),
(202, 35, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-25 04:52:08'),
(203, 35, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-25 07:41:43'),
(204, 36, NULL, 'pending', 'Orden creada desde CP-2026-00028', 1, '2026-09-25 07:45:03'),
(205, 36, 'pending', 'in_progress', '', 1, '2026-09-25 07:45:11'),
(206, 36, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-25 07:45:19'),
(207, 36, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-25 07:45:22'),
(208, 36, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-25 07:45:24'),
(209, 36, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-25 07:45:27'),
(210, 36, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-25 07:45:29'),
(211, 36, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-25 08:07:16'),
(212, 37, NULL, 'pending', 'Orden creada desde CP-2026-00029', 1, '2026-09-25 08:15:26'),
(213, 37, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-25 08:26:46'),
(214, 37, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-25 08:26:49'),
(215, 37, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-25 08:26:51'),
(216, 37, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-25 08:26:54'),
(217, 37, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-25 08:26:56'),
(218, 36, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-25 08:32:37'),
(219, 37, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-25 08:32:49'),
(220, 37, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-25 08:42:40'),
(221, 38, NULL, 'pending', 'Orden creada desde CP-2026-00030', 1, '2026-09-25 10:22:29'),
(222, 38, 'pending', 'in_progress', '', 1, '2026-09-25 10:22:49'),
(223, 38, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-25 10:22:57'),
(224, 38, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-25 10:23:00'),
(225, 38, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-25 10:23:03'),
(226, 38, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-25 10:23:05'),
(227, 38, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-25 10:23:07'),
(228, 38, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-25 10:23:11'),
(229, 38, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-25 10:23:13'),
(230, 30, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-25 11:19:05'),
(231, 29, 'in_progress', 'in_progress', 'Actualización automática desde cotización 33', 1, '2026-09-25 11:19:27'),
(232, 29, 'in_progress', 'completed', '', 1, '2026-09-25 11:21:08'),
(233, 29, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-25 11:29:18'),
(234, 21, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-25 11:30:11'),
(235, 21, 'quality', 'quality', 'Ya solo nos faltan los soportes para que se detenga la princesa.\r\nSeguimos trabajando y le notificamos en cuanto pueda venir por ellos', 1, '2026-09-25 11:30:56'),
(236, 26, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-25 12:02:56'),
(237, 26, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-25 12:32:43'),
(238, 22, 'in_progress', 'in_progress', 'Actualización automática desde cotización 31', 1, '2026-09-25 13:22:17'),
(239, 22, 'in_progress', 'in_progress', 'Actualización automática desde cotización 31', 1, '2026-09-25 13:24:49'),
(240, 17, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-25 15:18:23'),
(241, 17, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-25 15:18:26'),
(242, 17, 'in_progress', 'in_progress', 'Sincronización manual desde cotización CP-2026-00007', 1, '2026-09-25 15:18:48'),
(243, 39, NULL, 'pending', 'Orden creada desde CP-2026-00035', 1, '2026-09-25 20:37:16'),
(244, 17, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-26 10:31:43'),
(245, 33, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-26 10:34:55'),
(246, 33, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-26 10:34:58'),
(247, 33, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-26 10:35:01'),
(248, 33, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-26 10:35:04'),
(249, 33, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-26 10:35:06'),
(250, 21, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-26 10:39:49');

-- --------------------------------------------------------

--
-- Table structure for table `cp_order_items`
--

CREATE TABLE `cp_order_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `quote_item_id` int(10) UNSIGNED DEFAULT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` decimal(12,3) NOT NULL DEFAULT '1.000',
  `unit_price` decimal(15,2) NOT NULL DEFAULT '0.00',
  `subtotal` decimal(15,2) NOT NULL DEFAULT '0.00',
  `sort_order` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_order_items`
--

INSERT INTO `cp_order_items` (`id`, `order_id`, `quote_item_id`, `description`, `quantity`, `unit_price`, `subtotal`, `sort_order`, `created_at`, `updated_at`) VALUES
(11, 11, 20, 'Sudadera Mickey Mouse', 6.000, 420.00, 2520.00, 0, '2026-09-19 10:58:01', '2026-09-19 10:58:01'),
(13, 13, NULL, 'Lona 3m x 1.20m', 1.000, 720.00, 720.00, 0, '2026-09-19 11:15:57', '2026-09-19 11:15:57'),
(17, 14, 26, 'Block 100 recetas de seguridad', 1.000, 350.00, 350.00, 0, '2026-09-19 16:40:54', '2026-09-19 16:40:54'),
(18, 14, 27, '100 tarjetas de presentación', 1.000, 270.00, 270.00, 1, '2026-09-19 16:40:54', '2026-09-19 16:40:54'),
(20, 16, 29, 'Impresión vinil adhesivo tamaño tabloide', 100.000, 37.00, 3700.00, 0, '2026-09-19 17:17:34', '2026-09-19 17:17:34'),
(21, 16, 30, 'Rotulación de Camiones medida 140cm x 70cm', 10.000, 790.00, 7900.00, 1, '2026-09-19 17:17:34', '2026-09-19 17:17:34'),
(22, 15, 31, 'Impresión Papel Bond 50x70cm', 2.000, 80.00, 160.00, 0, '2026-09-19 17:21:24', '2026-09-19 17:21:24'),
(25, 18, NULL, 'Diseño e impresión de block 100 Vales salida de almacén Tamaño media carta, original y copia, foliado', 20.000, 295.00, 5900.00, 0, '2026-09-19 18:35:39', '2026-09-19 18:35:39'),
(26, 18, NULL, 'Pluma negra personalizada grabado láser', 50.000, 45.00, 2250.00, 1, '2026-09-19 18:35:39', '2026-09-19 18:35:39'),
(27, 18, NULL, 'Mouse Pad ergonómico  personalizado', 12.000, 65.00, 780.00, 2, '2026-09-19 18:35:39', '2026-09-19 18:35:39'),
(28, 18, NULL, 'Libreta personalizada tamaño media carta', 50.000, 69.00, 3450.00, 3, '2026-09-19 18:35:39', '2026-09-19 18:35:39'),
(31, 19, 50, 'Vinil de corte | Quantity: 1 · Surface: Vehículo · Size: 20x20cm · Color: negro', 2.000, 80.00, 160.00, 0, '2026-09-20 00:12:05', '2026-09-20 00:12:05'),
(32, 19, 51, 'COSTO POR INSTALACION 50 PESOS', 1.000, 50.00, 50.00, 1, '2026-09-20 00:12:05', '2026-09-20 00:12:05'),
(33, 20, 53, 'Grabado láser | Quantity: 1 · Material: YETI · Detail: LOGO', 1.000, 150.00, 150.00, 0, '2026-09-20 00:23:51', '2026-09-20 00:23:51'),
(34, 12, 54, 'Trofeo Trofeo Reconocimiento Materiales acrílico transparente, fondo y base de madera, grabado láser, medida 20x20cm aprox', 11.000, 545.00, 5995.00, 0, '2026-09-21 10:14:31', '2026-09-21 10:14:31'),
(35, 12, 55, 'Reconocimiento Libro de firmas temática Basebol Tamaño 9x11\", incluye 13 pelotas. Fabricado en madera y acrílico grabado láser', 2.000, 450.00, 900.00, 1, '2026-09-21 10:14:31', '2026-09-21 10:14:31'),
(36, 21, 56, 'Decorativo vinil impreso y coroplast Princesa 1.20 , personaje verde  150x60cm, logotipo 40x50cm', 1.000, 750.00, 750.00, 0, '2026-09-22 08:38:51', '2026-09-22 08:38:51'),
(39, 23, 60, 'Playera algodón personalizada tamaño corazón 4S, 5M, 2L', 11.000, 180.00, 1980.00, 0, '2026-09-22 10:54:15', '2026-09-22 10:54:15'),
(40, 24, 67, 'Sello personalizado', 1.000, 490.00, 490.00, 0, '2026-09-22 14:19:56', '2026-09-22 14:19:56'),
(41, 25, 69, 'CALCA VINILO VENTA DE AUTO 90CM X 25CM', 1.000, 100.00, 100.00, 0, '2026-09-22 20:46:45', '2026-09-22 20:46:45'),
(42, 26, 70, 'Diseño e impresión de block 100 notas tamaño un cuarto de carta original y copia', 1.000, 260.00, 260.00, 0, '2026-09-23 09:07:11', '2026-09-23 09:07:11'),
(44, 28, 71, 'Paquete Fiesta 80 etiquetas para botella agua 500ml 60 calcas 10cm 60 calcas 6cm', 1.000, 490.00, 490.00, 0, '2026-09-23 10:46:01', '2026-09-23 10:46:01'),
(59, 31, 84, 'Paquete 10 cajas cartón 35x26x8cm', 1.000, 299.00, 299.00, 0, '2026-09-24 10:00:07', '2026-09-24 10:00:07'),
(60, 30, 85, 'Agenda personalizada tamaño media carta incluyecpluma', 1.000, 270.00, 270.00, 0, '2026-09-24 10:36:10', '2026-09-24 10:36:10'),
(61, 30, 86, 'Llavero corazón partido, dos piezas', 1.000, 100.00, 100.00, 1, '2026-09-24 10:36:10', '2026-09-24 10:36:10'),
(62, 30, 87, 'Cuadro decorativo para tela medida 40x30cm', 1.000, 190.00, 190.00, 2, '2026-09-24 10:36:10', '2026-09-24 10:36:10'),
(63, 30, 88, 'Cuadro canvas notas musicales 20x30cm', 1.000, 290.00, 290.00, 3, '2026-09-24 10:36:10', '2026-09-24 10:36:10'),
(64, 30, 89, 'Cuadro decorativo tipo piano, piezas en relieve medida 9\"x12\" 250.00', 1.000, 0.10, 0.10, 4, '2026-09-24 10:36:10', '2026-09-24 10:36:10'),
(65, 30, 90, 'Circulo arte con hilos medida 11\" 190.00', 1.000, 0.10, 0.10, 5, '2026-09-24 10:36:10', '2026-09-24 10:36:10'),
(66, 32, 93, 'Sello personalizado', 1.000, 390.00, 390.00, 0, '2026-09-24 12:36:11', '2026-09-24 12:36:11'),
(67, 32, 94, 'Impresión 2 piezas de vinil 60cm', 1.000, 390.00, 390.00, 1, '2026-09-24 12:36:11', '2026-09-24 12:36:11'),
(68, 33, 95, 'Impresión e instalación de lona medida 3m x 75cm', 1.000, 450.00, 450.00, 0, '2026-09-24 17:37:36', '2026-09-24 17:37:36'),
(69, 33, 96, 'Acrílico horario, grabado láser medida 30x40cm', 1.000, 190.00, 190.00, 1, '2026-09-24 17:37:36', '2026-09-24 17:37:36'),
(70, 34, 91, 'Playera personalizada caballero sin mangas personalizado frente y posterior   talla Mtallas', 1.000, 290.00, 290.00, 0, '2026-09-24 18:28:30', '2026-09-24 18:28:30'),
(71, 34, 92, 'Playera personalizada mujer, corte Unisex personalizado frente y posterior', 1.000, 290.00, 290.00, 1, '2026-09-24 18:28:30', '2026-09-24 18:28:30'),
(72, 27, 68, 'Diseño e impresión de tarjetas 11x28 (340) palabras 28x28cm (54)abecedario mayúscula y minúscula', 7.000, 650.00, 4550.00, 0, '2026-09-25 00:53:48', '2026-09-25 00:53:48'),
(74, 35, 101, 'IMPRESION EN PAPEL BOND 90X60CM', 3.000, 80.00, 240.00, 0, '2026-09-25 04:51:44', '2026-09-25 04:51:44'),
(75, 36, 106, 'IMPRESION EN PAPEL BOND 90X60CM', 3.000, 80.00, 240.00, 0, '2026-09-25 07:45:03', '2026-09-25 07:45:03'),
(76, 36, 107, 'IMPRESION EN PAPEL BOND A3', 11.000, 20.00, 220.00, 1, '2026-09-25 07:45:03', '2026-09-25 07:45:03'),
(77, 36, 108, 'IMPRESION EN PAPEL BOND A3', 13.000, 20.00, 260.00, 2, '2026-09-25 07:45:03', '2026-09-25 07:45:03'),
(78, 36, 109, 'IMPRESION EN PAPEL BOND A3', 8.000, 20.00, 160.00, 3, '2026-09-25 07:45:03', '2026-09-25 07:45:03'),
(79, 37, 110, 'IMPRESION EN PAPEL BOND 90X60CM', 3.000, 80.00, 240.00, 0, '2026-09-25 08:15:26', '2026-09-25 08:15:26'),
(80, 38, 111, 'IMPRESION EN PAPEL BOND 90X60CM', 4.000, 80.00, 320.00, 0, '2026-09-25 10:22:29', '2026-09-25 10:22:29'),
(81, 29, 112, 'Vinil impreso decoración  hojas de otoño 40x50cm aprox cada una con suaje', 60.000, 35.00, 2100.00, 0, '2026-09-25 11:19:27', '2026-09-25 11:19:27'),
(82, 29, 113, 'Frase decorativa vinil medida 1.55m x 54cm', 15.000, 190.00, 2850.00, 1, '2026-09-25 11:19:27', '2026-09-25 11:19:27'),
(83, 29, 114, 'Papel de Transferencia para vinilo decorativo (15 frases 1.55 x 54cm', 1.000, 759.00, 759.00, 2, '2026-09-25 11:19:27', '2026-09-25 11:19:27'),
(86, 22, 118, 'Playera negra algodón corte caballero  5S, 13M, 4L', 22.000, 200.00, 4400.00, 0, '2026-09-25 13:24:49', '2026-09-25 13:24:49'),
(87, 22, 119, 'Playera negra algodón corte caballero  1XL, 1XXL', 2.000, 230.00, 460.00, 1, '2026-09-25 13:24:49', '2026-09-25 13:24:49'),
(88, 17, 39, 'Impresión Certificados de Servicio, incluye hojas', 100.000, 3.50, 350.00, 0, '2026-09-25 15:18:48', '2026-09-25 15:18:48'),
(89, 17, 40, '100 Tarjetas de presentación un solo lado', 2.000, 190.00, 380.00, 1, '2026-09-25 15:18:48', '2026-09-25 15:18:48'),
(90, 39, 151, 'Taza personalizada Radiorama', 5.000, 70.00, 350.00, 0, '2026-09-25 20:37:16', '2026-09-25 20:37:16');

-- --------------------------------------------------------

--
-- Table structure for table `cp_order_photos`
--

CREATE TABLE `cp_order_photos` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `file_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `original_name` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mime_type` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_size` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `photo_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'reference',
  `caption` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_order_photos`
--

INSERT INTO `cp_order_photos` (`id`, `order_id`, `file_path`, `original_name`, `mime_type`, `file_size`, `photo_type`, `caption`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 15, '/uploads/orders/15/927c157e6a460606e01dac935f567871fcdf.jpg', '1002102041.jpg', 'image/jpeg', 81099, 'reference', NULL, 1, '2026-09-19 18:13:21', '2026-09-19 18:13:21'),
(2, 15, '/uploads/orders/15/aeac7f5778984d430df4b36fd4bfded4fab1.jpg', '1002102043.jpg', 'image/jpeg', 82411, 'reference', NULL, 1, '2026-09-19 18:13:46', '2026-09-19 18:13:46'),
(3, 18, '/uploads/orders/18/840f1794c791fd240ea8467aba6d2ffd2427.jpg', '1002080977.jpg', 'image/jpeg', 96703, 'reference', NULL, 1, '2026-09-19 18:37:24', '2026-09-19 18:37:24'),
(7, 18, '/uploads/orders/18/675d62576ff1843cca2d9544dbbae2550a88.png', '1002104924.png', 'image/png', 1213603, 'reference', 'Los logos se cambian por los de Mac Lean', 1, '2026-09-19 18:41:30', '2026-09-19 18:41:30'),
(8, 18, '/uploads/orders/18/4dbc534f4cee1c4062a0bef0d7a007af318a.png', '1002104942.png', 'image/png', 991003, 'reference', 'GR5 MACLEAN', 1, '2026-09-19 18:50:13', '2026-09-19 18:50:13'),
(9, 18, '/uploads/orders/18/acfa5fb3edaafd95c29e1b45cd143178b4a6.png', '1002104943.png', 'image/png', 505218, 'reference', 'SS5 MACLEAN', 1, '2026-09-19 18:50:45', '2026-09-19 18:50:45'),
(10, 18, '/uploads/orders/18/146e984b3522ab36c635afadb69b9b1c0657.png', '1002104944.png', 'image/png', 696618, 'reference', 'ML5 MACLEAN', 1, '2026-09-19 18:53:38', '2026-09-19 18:53:38'),
(12, 21, '/uploads/orders/21/7d19b68eaf93266e9b3a6643a4060c0f4daf.jpg', 'IMG-20260921-WA0079.jpg', 'image/jpeg', 175193, 'client_file', NULL, 1, '2026-09-22 08:39:33', '2026-09-22 08:39:33'),
(13, 21, '/uploads/orders/21/cb5287fcbfb333dea8561759a6c184bca6ea.jpg', 'IMG-20260922-WA0007.jpg', 'image/jpeg', 60844, 'client_file', NULL, 1, '2026-09-22 09:13:01', '2026-09-22 09:13:01'),
(14, 22, '/uploads/orders/22/0cf07f89381c740efc3ce32f26aa9ec1e40a.jpg', 'IMG-20260921-WA0006.jpg', 'image/jpeg', 46405, 'client_file', 'Vinil textil blanco o reflejante', 1, '2026-09-22 10:39:43', '2026-09-22 10:39:43'),
(15, 22, '/uploads/orders/22/c0340ec13ba86b590df089608e4070ad47ab.png', 'Screenshot_20260922-104043.png', 'image/png', 504437, 'client_file', NULL, 1, '2026-09-22 10:41:01', '2026-09-22 10:41:01'),
(16, 23, '/uploads/orders/23/6954936374b6db041971bb64023981d6c2a5.jpg', 'IMG-20260921-WA0037.jpg', 'image/jpeg', 56905, 'client_file', 'Logotipo para personalizar, tamaño corazón', 1, '2026-09-22 10:54:53', '2026-09-22 10:54:53'),
(17, 26, '/uploads/orders/26/9ba60025c03a4d7f381e517be0646f2f126a.jpg', 'IMG-20260923-WA0007.jpg', 'image/jpeg', 139223, 'client_file', NULL, 1, '2026-09-23 09:08:34', '2026-09-23 09:08:34'),
(18, 28, '/uploads/orders/28/12592b8c831a05f40b23d349b96cad078198.png', 'Screenshot_20260923-104517.png', 'image/png', 827101, 'client_file', NULL, 1, '2026-09-23 10:46:24', '2026-09-23 10:46:24'),
(19, 28, '/uploads/orders/28/40b7d0f33639b7da666e0a9e4f53d68baaba.png', 'Screenshot_20260923-104526.png', 'image/png', 1224416, 'client_file', NULL, 1, '2026-09-23 10:46:43', '2026-09-23 10:46:43'),
(20, 29, '/uploads/orders/29/3af44d38c22fe9dfde74e6eb343cf6061dcc.png', 'Screenshot_20260923-110918.png', 'image/png', 860809, 'client_file', 'Cada hoja 40x50cm aprox', 1, '2026-09-23 11:09:59', '2026-09-23 11:09:59'),
(21, 28, '/uploads/orders/28/39207d81577329f1843c3a2592ba725ffebb.jpg', 'IMG-20260923-WA0039.jpg', 'image/jpeg', 42186, 'client_file', NULL, 1, '2026-09-23 14:04:41', '2026-09-23 14:04:41'),
(22, 31, '/uploads/orders/31/52ed355c3d63224f1dd941653fe01a18a48d.jpg', 'IMG-20260924-WA0019.jpg', 'image/jpeg', 35909, 'client_file', NULL, 1, '2026-09-24 10:00:26', '2026-09-24 10:00:26'),
(23, 30, '/uploads/orders/30/270eb164ac58c7c3befe371cd6be5344883c.png', 'Screenshot_20260924-114825.png', 'image/png', 1456228, 'client_file', 'Poner frase: La música une lo que la vida separa', 1, '2026-09-24 11:51:00', '2026-09-24 11:51:00'),
(24, 30, '/uploads/orders/30/9ff39998f41eddea0e9bdc6308a7304a3ac0.png', 'Screenshot_20260924-114820.png', 'image/png', 2015273, 'client_file', 'Diseño agenda', 1, '2026-09-24 11:51:35', '2026-09-24 11:51:35'),
(25, 32, '/uploads/orders/32/16aa270f29b64d8b08e518552f9c2b9d17aa.jpg', 'IMG-20260924-WA0073.jpg', 'image/jpeg', 153163, 'client_file', 'Sello', 1, '2026-09-24 12:36:34', '2026-09-24 12:36:34'),
(26, 32, '/uploads/orders/32/7d77abd17ab0575cd075e4d8e71ec71d691a.jpg', 'IMG-20260924-WA0045.jpg', 'image/jpeg', 198766, 'client_file', '2 piezas 60cm', 1, '2026-09-24 12:37:01', '2026-09-24 12:37:01'),
(27, 32, '/uploads/orders/32/6bfe7b0ff3f99ef3507f59b76bcea7009544.jpg', 'IMG-20260924-WA0081.jpg', 'image/jpeg', 151201, 'client_file', '20 calcas 6cm', 1, '2026-09-24 12:49:56', '2026-09-24 12:49:56'),
(28, 33, '/uploads/orders/33/39d497702c0f7b36dd6497645b5d3068df7a.jpg', 'IMG-20260924-WA0094.jpg', 'image/jpeg', 109787, 'client_file', 'Datos acrílico', 1, '2026-09-24 17:38:20', '2026-09-24 17:38:20'),
(29, 33, '/uploads/orders/33/35a85d21cd097598571abaf2ae1ac98722cb.jpg', 'IMG-20260924-WA0095.jpg', 'image/jpeg', 74686, 'client_file', 'Lona', 1, '2026-09-24 17:38:35', '2026-09-24 17:38:35'),
(31, 34, '/uploads/orders/34/626ff764d605c5c3863d689d380225f3f1c3.jpg', 'caifanes frente.jpg', 'image/jpeg', 36638, 'client_file', 'frente aambas playeras', 1, '2026-09-24 18:31:40', '2026-09-24 18:31:40'),
(32, 34, '/uploads/orders/34/61669b5aa4b64cad16d6631f0f24fa02585a.jpg', 'hombre espalda.jpg', 'image/jpeg', 45345, 'client_file', 'espalda hombre', 1, '2026-09-24 18:31:57', '2026-09-24 18:31:57'),
(33, 34, '/uploads/orders/34/297fef3db610311059bb678a510289ba5762.jpg', 'espalda mujer.jpg', 'image/jpeg', 61005, 'client_file', 'espalda mujer', 1, '2026-09-24 18:32:13', '2026-09-24 18:32:13'),
(34, 39, '/uploads/orders/39/2b5fa1cb8b151a145a7933602112ee9c2517.png', 'Screenshot_20260925-203903.png', 'image/png', 789332, 'client_file', NULL, 1, '2026-09-25 20:39:53', '2026-09-25 20:39:53'),
(35, 39, '/uploads/orders/39/b3e882b4d3564590b0c0cef58526515eb1d7.jpg', 'IMG-20260925-WA0084.jpg', 'image/jpeg', 90703, 'client_file', 'Anticipo', 1, '2026-09-25 21:14:27', '2026-09-25 21:14:27');

-- --------------------------------------------------------

--
-- Table structure for table `cp_order_production_briefs`
--

CREATE TABLE `cp_order_production_briefs` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `service_type` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'otro',
  `product` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dimensions` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `material` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `thickness` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `technique` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `finish` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sizes` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_request` text COLLATE utf8mb4_unicode_ci,
  `design_status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `design_version` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `design_approved_by` int(10) UNSIGNED DEFAULT NULL,
  `design_approved_at` datetime DEFAULT NULL,
  `priority` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'normal',
  `instructions` text COLLATE utf8mb4_unicode_ci,
  `critical_instructions` text COLLATE utf8mb4_unicode_ci,
  `packaging` text COLLATE utf8mb4_unicode_ci,
  `delivery_internal` text COLLATE utf8mb4_unicode_ci,
  `extra_data` text COLLATE utf8mb4_unicode_ci,
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `updated_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cp_order_production_checklist`
--

CREATE TABLE `cp_order_production_checklist` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `area` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `item_key` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `is_blocking` tinyint(1) NOT NULL DEFAULT '0',
  `completed_by` int(10) UNSIGNED DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cp_order_status`
--

CREATE TABLE `cp_order_status` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `stage` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `note` text COLLATE utf8mb4_unicode_ci,
  `updated_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_order_status`
--

INSERT INTO `cp_order_status` (`id`, `order_id`, `stage`, `note`, `updated_by`, `created_at`, `updated_at`) VALUES
(11, 11, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-19 10:58:43', '2026-09-23 08:33:32'),
(12, 12, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-19 11:10:57', '2026-09-21 12:28:29'),
(13, 14, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-19 16:42:18', '2026-09-20 15:36:07'),
(14, 20, 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-20 00:26:12', '2026-09-20 00:26:25'),
(15, 15, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-21 09:59:23', '2026-09-21 09:59:40'),
(16, 13, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-21 22:26:24', '2026-09-22 09:09:30'),
(17, 17, 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-22 08:08:53', '2026-09-26 10:31:43'),
(18, 25, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-22 20:47:18', '2026-09-22 20:47:36'),
(19, 24, 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-23 09:15:17', '2026-09-23 18:15:54'),
(20, 18, 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-23 09:16:49', '2026-09-23 09:18:21'),
(21, 16, 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-23 09:17:14', '2026-09-23 09:17:21'),
(22, 23, 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-23 09:19:14', '2026-09-23 13:49:28'),
(23, 22, 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-23 09:20:07', '2026-09-23 09:22:15'),
(24, 26, 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-23 09:21:05', '2026-09-25 12:32:43'),
(25, 21, 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-23 09:22:23', '2026-09-26 10:39:49'),
(26, 27, 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-23 10:07:47', '2026-09-23 10:07:50'),
(27, 28, 'delivered', '', 1, '2026-09-23 10:52:08', '2026-09-24 18:33:56'),
(28, 29, 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-23 17:43:12', '2026-09-25 11:29:18'),
(29, 30, 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-23 20:23:05', '2026-09-25 11:19:05'),
(30, 31, 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-24 10:13:18', '2026-09-24 10:13:18'),
(31, 34, 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-24 21:56:12', '2026-09-24 21:56:12'),
(32, 35, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-25 04:51:56', '2026-09-25 07:41:43'),
(33, 36, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-25 07:45:19', '2026-09-25 08:32:37'),
(34, 37, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-25 08:26:46', '2026-09-25 08:42:40'),
(35, 38, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-25 10:22:57', '2026-09-25 10:23:13'),
(36, 33, 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-26 10:34:55', '2026-09-26 10:35:06');

-- --------------------------------------------------------

--
-- Table structure for table `cp_payments`
--

CREATE TABLE `cp_payments` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `customer_id` int(10) UNSIGNED DEFAULT NULL,
  `amount` decimal(15,2) NOT NULL DEFAULT '0.00',
  `payment_date` date NOT NULL,
  `method` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'other',
  `reference` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `note` text COLLATE utf8mb4_unicode_ci,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'confirmed',
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `updated_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_payments`
--

INSERT INTO `cp_payments` (`id`, `order_id`, `customer_id`, `amount`, `payment_date`, `method`, `reference`, `note`, `status`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(3, 11, 856, 2000.00, '2026-09-19', 'transfer', NULL, NULL, 'confirmed', 1, 1, '2026-09-19 11:00:33', '2026-09-19 11:02:36'),
(4, 12, 1207, 4000.00, '2026-09-04', 'transfer', NULL, NULL, 'confirmed', 1, 1, '2026-09-19 11:23:56', '2026-09-19 11:23:56'),
(5, 13, 1263, 500.00, '2026-09-12', 'transfer', NULL, NULL, 'confirmed', 1, 1, '2026-09-19 11:25:16', '2026-09-19 11:25:16'),
(6, 14, 640, 350.00, '2026-09-19', 'transfer', '0007432732', 'ANTICIPO', 'confirmed', 1, 1, '2026-09-19 14:36:50', '2026-09-19 17:53:41'),
(7, 19, 1, 50.00, '2026-09-20', 'cash', NULL, 'ANTICIPO · PAGO EN EFECTIVO DIRECTO LOCAL', 'confirmed', 1, 1, '2026-09-20 00:12:30', '2026-09-20 00:12:30'),
(8, 20, 1, 100.00, '2026-09-20', 'transfer', NULL, 'ANTICIPO', 'confirmed', 1, 1, '2026-09-20 00:24:37', '2026-09-20 00:24:37'),
(9, 12, 1207, 2895.00, '2026-09-21', 'cash', 'Efectivo 2000 y 935 trasnferencia', 'ANTICIPO', 'confirmed', 1, 1, '2026-09-21 12:29:35', '2026-09-21 12:29:35'),
(10, 21, 763, 750.00, '2026-09-22', 'transfer', NULL, 'ANTICIPO', 'confirmed', 1, 1, '2026-09-22 09:10:28', '2026-09-22 09:10:28'),
(11, 22, 1270, 1917.00, '2026-09-22', 'cash', NULL, 'ANTICIPO', 'confirmed', 1, 1, '2026-09-22 10:40:08', '2026-09-22 10:40:08'),
(12, 25, 769, 50.00, '2026-09-22', 'cash', NULL, 'ANTICIPO', 'confirmed', 1, 1, '2026-09-22 20:46:57', '2026-09-22 20:46:57'),
(13, 25, 769, 50.00, '2026-09-22', 'cash', NULL, NULL, 'confirmed', 1, 1, '2026-09-22 20:48:15', '2026-09-22 20:48:15'),
(14, 27, 1204, 4550.00, '2026-09-23', 'cash', NULL, 'ANTICIPO', 'confirmed', 1, 1, '2026-09-23 09:58:50', '2026-09-23 09:58:50'),
(15, 28, 1271, 245.00, '2026-09-24', 'cash', NULL, 'ANTICIPO', 'confirmed', 1, 1, '2026-09-23 14:01:48', '2026-09-23 20:30:20'),
(16, 31, 1272, 150.00, '2026-09-24', 'transfer', NULL, 'ANTICIPO', 'confirmed', 1, 1, '2026-09-24 10:14:34', '2026-09-24 10:14:34'),
(17, 30, 746, 850.00, '2026-09-24', 'cash', 'PAGO CON TARJETA TERMINAL BBVA', 'ANTICIPO · PAGO COMPLETO', 'confirmed', 1, 1, '2026-09-24 10:42:26', '2026-09-24 10:42:26'),
(18, 32, 1197, 780.00, '2026-09-24', 'cash', NULL, 'ANTICIPO', 'confirmed', 1, 1, '2026-09-24 16:15:27', '2026-09-24 16:15:27'),
(19, 34, 1273, 240.00, '2026-09-24', 'transfer', NULL, 'ANTICIPO', 'confirmed', 1, 1, '2026-09-24 18:32:49', '2026-09-24 18:32:49'),
(20, 28, 1271, 245.00, '2026-09-24', 'transfer', NULL, 'ANTICIPO', 'confirmed', 1, 1, '2026-09-24 18:33:38', '2026-09-24 18:33:38'),
(21, 24, 908, 390.00, '2026-09-24', 'transfer', NULL, 'ANTICIPO', 'confirmed', 1, 1, '2026-09-24 18:34:55', '2026-09-24 18:34:55'),
(22, 18, 340, 7516.80, '2026-09-24', 'card', NULL, 'ANTICIPO · PAGO EN TERMINAL BBVA', 'confirmed', 1, 1, '2026-09-24 21:07:45', '2026-09-24 21:07:45'),
(23, 35, 1275, 160.00, '2026-09-24', 'transfer', NULL, 'ANTICIPO', 'confirmed', 1, 1, '2026-09-25 04:54:46', '2026-09-25 04:54:46'),
(24, 35, 1275, 80.00, '2026-09-25', 'transfer', NULL, NULL, 'confirmed', 1, 1, '2026-09-25 05:09:16', '2026-09-25 05:09:16'),
(25, 36, 1276, 880.00, '2026-09-25', 'other', NULL, 'ANTICIPO · 300 transferencia 580 en tarjeta', 'confirmed', 1, 1, '2026-09-25 08:06:30', '2026-09-25 08:06:30'),
(26, 37, 1277, 240.00, '2026-09-25', 'transfer', NULL, 'ANTICIPO', 'confirmed', 1, 1, '2026-09-25 08:24:54', '2026-09-25 08:24:54'),
(27, 38, 1279, 320.00, '2026-09-25', 'transfer', NULL, 'ANTICIPO · MERCADO LIBRE', 'confirmed', 1, 1, '2026-09-25 10:46:30', '2026-09-25 10:46:30'),
(28, 39, 1223, 200.00, '2026-09-25', 'cash', NULL, 'ANTICIPO', 'confirmed', 1, 1, '2026-09-25 21:14:47', '2026-09-25 21:14:47');

-- --------------------------------------------------------

--
-- Table structure for table `cp_payment_receipts`
--

CREATE TABLE `cp_payment_receipts` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `payment_id` int(10) UNSIGNED DEFAULT NULL,
  `access_token` char(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `original_name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mime_type` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_size` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `note` text COLLATE utf8mb4_unicode_ci,
  `reviewed_by` int(10) UNSIGNED DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_payment_receipts`
--

INSERT INTO `cp_payment_receipts` (`id`, `order_id`, `payment_id`, `access_token`, `original_name`, `file_path`, `mime_type`, `file_size`, `status`, `note`, `reviewed_by`, `reviewed_at`, `created_at`, `updated_at`) VALUES
(1, 14, 6, '3fe0dc4ee761ca20989a2c31b7badf85874a5c00f902566b125c66e11265e78a', 'dra jaqueline.jpeg', '/uploads/payment-receipts/14/3fe0dc4ee761ca20989a2c31b7badf85874a5c00f902566b125c66e11265e78a.jpg', 'image/jpeg', 51296, 'confirmed', NULL, 1, '2026-09-19 17:50:08', '2026-09-19 17:48:26', '2026-09-19 17:50:08'),
(2, 20, NULL, '12023ff11809ffa392d648c5d8afa98589fd79d7a0a320e5eab939fddd2d17a6', '220dfef5-4553-4de1-9db2-7869fd75fc61.jpg', '/uploads/payment-receipts/20/12023ff11809ffa392d648c5d8afa98589fd79d7a0a320e5eab939fddd2d17a6.jpg', 'image/jpeg', 51296, 'confirmed', NULL, 1, '2026-09-20 00:31:18', '2026-09-20 00:28:36', '2026-09-20 00:31:18'),
(3, 12, NULL, '2673d298961a62e3e341d973a378821813e4e0e6d8d3cfbe4e3790b377db7a0e', 'Comprobante de pago.jpeg', '/uploads/payment-receipts/12/2673d298961a62e3e341d973a378821813e4e0e6d8d3cfbe4e3790b377db7a0e.jpg', 'image/jpeg', 38104, 'pending', '', NULL, NULL, '2026-09-21 10:15:29', '2026-09-21 10:15:29'),
(4, 12, NULL, 'dc2e121515de4a06979dfde66334d2e04c6b873e222ab363ae33239a1311041d', 'c1057943-951d-43d6-b6fa-9d161f295cbb.jpg', '/uploads/payment-receipts/12/dc2e121515de4a06979dfde66334d2e04c6b873e222ab363ae33239a1311041d.jpg', 'image/jpeg', 38028, 'pending', '2000 efectivo y el resto en transferencia', NULL, NULL, '2026-09-21 12:30:44', '2026-09-21 12:30:44'),
(5, 11, NULL, 'bb72055bf9c2cf9bf9de960bf45f47822528997db79123fcbdaa6c69a770a366', 'GUIA ESTAFETA CD JUÁREZ.pdf', '/uploads/payment-receipts/11/bb72055bf9c2cf9bf9de960bf45f47822528997db79123fcbdaa6c69a770a366.pdf', 'application/pdf', 24777, 'pending', 'PAQUETE ENVIADO POR ESTAFETA TERRESTRE', NULL, NULL, '2026-09-23 08:34:24', '2026-09-23 08:34:24'),
(6, 30, NULL, 'e30b6273a93fde75a838d90bd26e2255aa1bae36f8e79b9be83dc63b49da8e04', 'image.jpg', '/uploads/payment-receipts/30/e30b6273a93fde75a838d90bd26e2255aa1bae36f8e79b9be83dc63b49da8e04.jpg', 'image/jpeg', 3571828, 'pending', '', NULL, NULL, '2026-09-24 10:41:09', '2026-09-24 10:41:09'),
(7, 32, NULL, 'e3ee5be6127b3a57d844c2b5bc2c74c3fa8fc16996e6d9f57deafc2dbdc6e634', 'IMG-20260924-WA0090.jpg', '/uploads/payment-receipts/32/e3ee5be6127b3a57d844c2b5bc2c74c3fa8fc16996e6d9f57deafc2dbdc6e634.jpg', 'image/jpeg', 85448, 'pending', '', NULL, NULL, '2026-09-24 16:12:14', '2026-09-24 16:12:14'),
(8, 34, NULL, '9b77d30f06169a2713d18fafa5ae594093cce89d32a0fa0fb87d54a511dd7220', 'IMG-20260924-WA0112.jpg', '/uploads/payment-receipts/34/9b77d30f06169a2713d18fafa5ae594093cce89d32a0fa0fb87d54a511dd7220.jpg', 'image/jpeg', 51380, 'pending', '', NULL, NULL, '2026-09-24 23:21:38', '2026-09-24 23:21:38'),
(9, 35, 23, '1b347944a929a06cbd689f870c97f6b05bcf3a0ac075a7040da891e2a5cbd5db', '0ca356df-d8b4-4ab1-be0a-435f4efc5bbd.jpg', '/uploads/payment-receipts/35/1b347944a929a06cbd689f870c97f6b05bcf3a0ac075a7040da891e2a5cbd5db.jpg', 'image/jpeg', 40650, 'confirmed', NULL, 1, '2026-09-25 05:11:36', '2026-09-25 04:53:05', '2026-09-25 05:11:36'),
(10, 35, 24, 'bedf4e46788277dd310684e9732ee697285f85fe7c5acffb5a9856bc6247b728', 'WhatsApp Image 2026-09-25 at 5.07.03 AM.jpeg', '/uploads/payment-receipts/35/bedf4e46788277dd310684e9732ee697285f85fe7c5acffb5a9856bc6247b728.jpg', 'image/jpeg', 43559, 'confirmed', NULL, 1, '2026-09-25 05:11:39', '2026-09-25 05:07:55', '2026-09-25 05:11:39'),
(11, 37, 26, 'c5c375fb6854ab641f21fdcfb95ec523c77a30dd42c8bcb5f5beb9b133e117b7', 'WhatsApp Image 2026-09-25 at 8.23.36 AM.jpeg', '/uploads/payment-receipts/37/c5c375fb6854ab641f21fdcfb95ec523c77a30dd42c8bcb5f5beb9b133e117b7.jpg', 'image/jpeg', 97348, 'confirmed', NULL, 1, '2026-09-25 08:25:01', '2026-09-25 08:24:34', '2026-09-25 08:25:01'),
(12, 38, 27, '763c48b1fe1d8685e271d80a58d79be8e30c236fdb74f10e678ff87bbf865ec3', 'IMG-20260925-WA0013.jpg', '/uploads/payment-receipts/38/763c48b1fe1d8685e271d80a58d79be8e30c236fdb74f10e678ff87bbf865ec3.jpg', 'image/jpeg', 57959, 'confirmed', 'A la orden el pago', 1, '2026-09-25 10:46:38', '2026-09-25 10:26:53', '2026-09-25 10:46:38'),
(13, 39, NULL, 'd22c82b5fd8200f7a54cc87aab126c4f5fc47afb34bf09e069b091b2ef4140a4', 'IMG-20260925-WA0084.jpg', '/uploads/payment-receipts/39/d22c82b5fd8200f7a54cc87aab126c4f5fc47afb34bf09e069b091b2ef4140a4.jpg', 'image/jpeg', 90703, 'pending', '', NULL, NULL, '2026-09-25 21:16:04', '2026-09-25 21:16:04'),
(14, 21, NULL, '8e160aff0399a1d4b8ebabd3356049bdcbcb1c8a06cec04fb22b55b0f274b581', 'WhatsApp Image 2026-09-22 at 8.46.35 AM.jpeg', '/uploads/payment-receipts/21/8e160aff0399a1d4b8ebabd3356049bdcbcb1c8a06cec04fb22b55b0f274b581.jpg', 'image/jpeg', 60844, 'pending', '', NULL, NULL, '2026-09-26 10:46:11', '2026-09-26 10:46:11');

-- --------------------------------------------------------

--
-- Table structure for table `cp_print_finishes`
--

CREATE TABLE `cp_print_finishes` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_print_finishes`
--

INSERT INTO `cp_print_finishes` (`id`, `name`, `code`, `enabled`, `sort_order`, `created_at`, `updated_at`) VALUES
(1, 'Sin acabado', 'none', 1, 10, '2026-09-26 03:15:10', '2026-09-26 03:15:10'),
(2, 'Laminado mate', 'mate', 0, 20, '2026-09-26 03:15:10', '2026-09-26 03:15:10'),
(3, 'Laminado brillante', 'brillante', 0, 30, '2026-09-26 03:15:10', '2026-09-26 03:15:10'),
(4, 'Laminado', 'laminado', 1, 40, '2026-09-26 03:15:10', '2026-09-26 03:15:10'),
(5, 'Engargolado', 'engargolado', 1, 40, '0000-00-00 00:00:00', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `cp_print_jobs`
--

CREATE TABLE `cp_print_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED DEFAULT NULL,
  `quote_id` int(10) UNSIGNED DEFAULT NULL,
  `printer_name` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `material_name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Lona',
  `printexp_job` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `printed_at` datetime NOT NULL,
  `dpi_x` smallint(5) UNSIGNED DEFAULT NULL,
  `dpi_y` smallint(5) UNSIGNED DEFAULT NULL,
  `print_program_pct` decimal(6,2) DEFAULT NULL,
  `print_speed_m2_h` decimal(10,3) DEFAULT NULL,
  `print_speed_m_h` decimal(10,3) DEFAULT NULL,
  `print_mode` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `print_time_seconds` int(10) UNSIGNED DEFAULT NULL,
  `copy_number` smallint(5) UNSIGNED DEFAULT NULL,
  `copy_total` smallint(5) UNSIGNED DEFAULT NULL,
  `job_width_mm` decimal(10,2) NOT NULL DEFAULT '0.00',
  `job_length_mm` decimal(10,2) NOT NULL DEFAULT '0.00',
  `print_length_m` decimal(12,3) NOT NULL DEFAULT '0.000',
  `gross_m2` decimal(12,3) NOT NULL DEFAULT '0.000',
  `result_status` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'good',
  `waste_reason` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `waste_m2` decimal(12,3) NOT NULL DEFAULT '0.000',
  `good_m2` decimal(12,3) NOT NULL DEFAULT '0.000',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cp_print_materials`
--

CREATE TABLE `cp_print_materials` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `unit_label` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'hoja'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_print_materials`
--

INSERT INTO `cp_print_materials` (`id`, `name`, `code`, `enabled`, `sort_order`, `created_at`, `updated_at`, `unit_label`) VALUES
(1, 'Papel bond', 'bond', 1, 10, '2026-09-26 03:15:10', '2026-09-26 03:15:10', 'hoja'),
(2, 'Opalina', 'opalina', 1, 20, '2026-09-26 03:15:10', '2026-09-26 03:15:10', 'hoja'),
(3, 'Couché', 'couche', 0, 0, '2026-09-26 03:15:10', '2026-09-26 04:20:55', 'hoja'),
(4, 'Fotográfico', 'fotografico', 1, 40, '2026-09-26 03:15:10', '2026-09-26 03:15:10', 'hoja'),
(5, 'Adhesivo', 'adhesivo', 1, 50, '2026-09-26 03:15:10', '2026-09-26 03:15:10', 'hoja'),
(6, 'Cartulina', 'cartulina', 1, 20, '0000-00-00 00:00:00', '0000-00-00 00:00:00', 'hoja'),
(7, 'Vinil', 'vinil', 1, 40, '0000-00-00 00:00:00', '0000-00-00 00:00:00', 'pieza');

-- --------------------------------------------------------

--
-- Table structure for table `cp_print_meter_logs`
--

CREATE TABLE `cp_print_meter_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `roll_id` bigint(20) UNSIGNED NOT NULL,
  `printed_at` datetime NOT NULL,
  `job_name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `job_length_mm` decimal(12,2) NOT NULL DEFAULT '0.00',
  `linear_m` decimal(12,3) NOT NULL DEFAULT '0.000',
  `result_status` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'good',
  `waste_m` decimal(12,3) NOT NULL DEFAULT '0.000',
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_print_meter_logs`
--

INSERT INTO `cp_print_meter_logs` (`id`, `roll_id`, `printed_at`, `job_name`, `job_length_mm`, `linear_m`, `result_status`, `waste_m`, `created_by`, `created_at`) VALUES
(1, 1, '2026-09-17 22:11:00', 'Dibujos fiesta y lona maestra cobach', 3810.00, 3.810, 'good', 0.000, 1, '2026-09-17 22:12:12'),
(2, 2, '2026-09-17 22:12:00', 'Figuras calavera', 794.17, 0.794, 'good', 0.000, 1, '2026-09-17 22:13:20'),
(3, 1, '2026-09-18 14:29:00', 'Impresion cuadros', 1542.03, 1.542, 'good', 0.000, 1, '2026-09-18 14:29:53'),
(4, 1, '2026-09-19 18:30:00', 'LONA U uva mtra', 390.00, 0.390, 'good', 0.000, 1, '2026-09-19 18:31:57'),
(5, 1, '2026-09-19 18:31:00', 'LONA U uva mtra', 390.00, 0.390, 'good', 0.000, 1, '2026-09-19 18:33:18'),
(6, 1, '2026-09-19 18:33:00', 'LONA U uva mtra', 390.00, 0.390, 'good', 0.000, 1, '2026-09-19 18:33:33'),
(7, 1, '2026-09-19 18:33:00', 'NUMEROS MTRA ADRIANA', 600.46, 0.600, 'good', 0.000, 1, '2026-09-19 18:34:34'),
(8, 2, '2026-09-19 18:34:00', 'ETIQUETAS NOMBRES SANTIAGO', 249.51, 0.250, 'good', 0.000, 1, '2026-09-19 18:35:14'),
(9, 2, '2026-09-19 18:35:00', 'caryolas y nombre santiago', 414.87, 0.415, 'good', 0.000, 1, '2026-09-19 18:35:39'),
(10, 2, '2026-09-19 18:35:00', 'NEVERA LAS ARTESANALES', 1258.49, 1.258, 'good', 0.000, 1, '2026-09-19 18:36:14'),
(11, 2, '2026-09-20 00:32:00', 'IMPRESION DE PELOTAS DE BASEBALL', 159.43, 0.159, 'good', 0.000, 1, '2026-09-20 00:34:52');

-- --------------------------------------------------------

--
-- Table structure for table `cp_print_prices`
--

CREATE TABLE `cp_print_prices` (
  `id` int(10) UNSIGNED NOT NULL,
  `size_id` int(10) UNSIGNED NOT NULL,
  `material_id` int(10) UNSIGNED NOT NULL,
  `finish_id` int(10) UNSIGNED NOT NULL,
  `color_mode` enum('color','bw') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'color',
  `pricing_mode` enum('per_page','per_sheet') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'per_page',
  `unit_price` decimal(12,2) NOT NULL DEFAULT '0.00',
  `min_qty` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `cp_print_prices`
--

INSERT INTO `cp_print_prices` (`id`, `size_id`, `material_id`, `finish_id`, `color_mode`, `pricing_mode`, `unit_price`, `min_qty`, `enabled`, `created_at`, `updated_at`) VALUES
(1, 4, 1, 1, 'color', 'per_page', 25.00, 1, 1, '2026-09-26 05:19:33', '2026-09-26 12:01:47'),
(2, 3, 1, 1, 'color', 'per_page', 3.00, 1, 1, '2026-09-26 05:19:33', '2026-09-26 05:19:33'),
(3, 1, 1, 1, 'color', 'per_page', 8.00, 1, 1, '2026-09-26 05:19:33', '2026-09-26 05:31:15'),
(4, 2, 1, 1, 'color', 'per_page', 4.00, 1, 1, '2026-09-26 05:19:33', '2026-09-26 05:19:33'),
(8, 4, 1, 1, 'bw', 'per_page', 4.00, 1, 1, '2026-09-26 05:19:33', '2026-09-26 05:19:33'),
(9, 3, 1, 1, 'bw', 'per_page', 1.00, 1, 1, '2026-09-26 05:19:33', '2026-09-26 05:19:33'),
(10, 1, 1, 1, 'bw', 'per_page', 1.00, 1, 1, '2026-09-26 05:19:33', '2026-09-26 05:19:33'),
(11, 2, 1, 1, 'bw', 'per_page', 1.50, 1, 1, '2026-09-26 05:19:33', '2026-09-26 05:19:33'),
(18, 6, 1, 1, 'color', 'per_page', 80.00, 1, 0, '2026-09-26 05:31:31', '2026-09-26 16:32:49'),
(20, 9, 1, 1, 'color', 'per_page', 80.00, 1, 1, '2026-09-26 08:39:06', '2026-09-26 11:39:52');

-- --------------------------------------------------------

--
-- Table structure for table `cp_print_price_rules`
--

CREATE TABLE `cp_print_price_rules` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `service_key` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'document',
  `size_id` int(10) UNSIGNED DEFAULT NULL,
  `material_id` int(10) UNSIGNED DEFAULT NULL,
  `color_mode` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'color',
  `finish_id` int(10) UNSIGNED DEFAULT NULL,
  `price_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unit',
  `unit_price` decimal(15,2) NOT NULL DEFAULT '0.00',
  `min_quantity` decimal(12,3) NOT NULL DEFAULT '1.000',
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `service_type` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'impresion',
  `pricing_mode` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'page'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_print_price_rules`
--

INSERT INTO `cp_print_price_rules` (`id`, `name`, `service_key`, `size_id`, `material_id`, `color_mode`, `finish_id`, `price_type`, `unit_price`, `min_quantity`, `enabled`, `sort_order`, `created_at`, `updated_at`, `service_type`, `pricing_mode`) VALUES
(1, '', 'document', 1, 1, 'both', NULL, 'unit', 5.00, 1.000, 1, 0, '2026-09-26 03:58:47', '2026-09-26 03:58:47', 'impresion', 'page'),
(2, '', 'document', 6, 1, 'both', 1, 'unit', 80.00, 1.000, 1, 0, '2026-09-26 03:59:55', '2026-09-26 03:59:55', 'impresion', 'page'),
(3, 'Impresión · Carta · Papel bond · Sin acabado · both', 'impresion', 1, 1, 'both', 1, 'page', 8.99, 1.000, 1, 0, '2026-09-26 04:57:53', '2026-09-26 04:57:53', 'impresion', 'page');

-- --------------------------------------------------------

--
-- Table structure for table `cp_print_requests`
--

CREATE TABLE `cp_print_requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `customer_name` varchar(180) COLLATE utf8_unicode_ci NOT NULL,
  `customer_email` varchar(180) COLLATE utf8_unicode_ci NOT NULL,
  `customer_phone` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `status` enum('new','reviewing','quoted','production','completed','cancelled') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'new',
  `total_estimate` decimal(12,2) NOT NULL DEFAULT '0.00',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `cp_print_requests`
--

INSERT INTO `cp_print_requests` (`id`, `customer_name`, `customer_email`, `customer_phone`, `status`, `total_estimate`, `created_at`, `updated_at`) VALUES
(14, 'ERIKA BUSTILLOS', 'wmaster1ro@gmail.com', '+526271074512', 'new', 80.00, '2026-09-26 17:07:58', '2026-09-26 17:07:58'),
(15, 'ERIKA BUSTILLOS', 'wmaster1ro@gmail.com', '+526271074512', 'new', 160.00, '2026-09-26 17:08:15', '2026-09-26 17:08:15'),
(16, 'ERIKA BUSTILLOS', 'wmaster1ro@gmail.com', '+526271074512', 'new', 160.00, '2026-09-26 17:10:04', '2026-09-26 17:10:04'),
(17, 'ERIKA BUSTILLOS', 'wmaster1ro@gmail.com', '+526271074512', 'new', 80.00, '2026-09-26 19:25:44', '2026-09-26 19:25:44');

-- --------------------------------------------------------

--
-- Table structure for table `cp_print_request_items`
--

CREATE TABLE `cp_print_request_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `request_id` bigint(20) UNSIGNED NOT NULL,
  `file_id` bigint(20) UNSIGNED DEFAULT NULL,
  `service_key` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'document',
  `size_id` int(10) UNSIGNED DEFAULT NULL,
  `size_name` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `width_mm` decimal(10,2) DEFAULT NULL,
  `height_mm` decimal(10,2) DEFAULT NULL,
  `orientation` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `material_id` int(10) UNSIGNED DEFAULT NULL,
  `material_name` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color_mode` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'color',
  `finish_id` int(10) UNSIGNED DEFAULT NULL,
  `finish_name` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `copies` decimal(12,3) NOT NULL DEFAULT '1.000',
  `pages` decimal(12,3) NOT NULL DEFAULT '1.000',
  `price_rule_id` bigint(20) UNSIGNED DEFAULT NULL,
  `unit_price` decimal(15,2) NOT NULL DEFAULT '0.00',
  `subtotal` decimal(15,2) NOT NULL DEFAULT '0.00',
  `pricing_status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'calculated',
  `notes` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `page_count` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `print_sides` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'single',
  `sheet_count` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `billable_units` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `service_type` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'impresion',
  `pricing_mode` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT 'page',
  `quantity` int(10) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_print_request_items`
--

INSERT INTO `cp_print_request_items` (`id`, `request_id`, `file_id`, `service_key`, `size_id`, `size_name`, `width_mm`, `height_mm`, `orientation`, `material_id`, `material_name`, `color_mode`, `finish_id`, `finish_name`, `copies`, `pages`, `price_rule_id`, `unit_price`, `subtotal`, `pricing_status`, `notes`, `created_at`, `updated_at`, `page_count`, `print_sides`, `sheet_count`, `billable_units`, `service_type`, `pricing_mode`, `quantity`) VALUES
(1, 8, 5, 'document', 6, NULL, 594.00, 841.00, NULL, 1, NULL, 'color', 1, NULL, 1.000, 1.000, 2, 80.00, 80.00, 'calculated', '', '2026-09-26 04:00:34', '2026-09-26 04:00:34', 1, 'single', 1, 1, 'impresion', 'page', 1),
(5, 17, 13, 'document', 9, '60 × 90 cm', 600.00, 900.00, 'portrait', 1, 'Papel bond', 'color', 1, 'Sin acabado', 1.000, 1.000, NULL, 80.00, 80.00, 'calculated', '', '2026-09-26 17:07:58', '2026-09-26 17:07:58', 1, 'single', 1, 1, 'impresion', 'per_page', 1),
(6, 18, 14, 'document', 9, '60 × 90 cm', 600.00, 900.00, 'portrait', 1, 'Papel bond', 'color', 1, 'Sin acabado', 2.000, 1.000, NULL, 80.00, 160.00, 'calculated', '', '2026-09-26 17:08:15', '2026-09-26 17:08:15', 1, 'single', 2, 2, 'impresion', 'per_page', 2),
(7, 19, 15, 'document', 9, '60 × 90 cm', 600.00, 900.00, 'portrait', 1, 'Papel bond', 'color', 1, 'Sin acabado', 2.000, 1.000, NULL, 80.00, 160.00, 'calculated', '', '2026-09-26 17:10:04', '2026-09-26 17:10:04', 1, 'single', 2, 2, 'impresion', 'per_page', 2),
(8, 20, 16, 'document', 9, '60 × 90 cm', 600.00, 900.00, 'portrait', 1, 'Papel bond', 'color', 1, 'Sin acabado', 1.000, 1.000, NULL, 80.00, 80.00, 'calculated', '', '2026-09-26 19:25:44', '2026-09-26 19:25:44', 1, 'single', 1, 1, 'impresion', 'per_page', 1);

-- --------------------------------------------------------

--
-- Table structure for table `cp_print_rolls`
--

CREATE TABLE `cp_print_rolls` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `roll_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `initial_m` decimal(12,3) NOT NULL DEFAULT '0.000',
  `remaining_m` decimal(12,3) NOT NULL DEFAULT '0.000',
  `opened_at` datetime NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_print_rolls`
--

INSERT INTO `cp_print_rolls` (`id`, `roll_name`, `initial_m`, `remaining_m`, `opened_at`, `status`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 'Rollo Lona promodigital pro max 50', 50.000, 42.878, '2026-09-17 22:11:35', 'active', 1, '2026-09-17 22:11:35', '2026-09-19 18:34:34'),
(2, 'Rollo de vinil ahdesivo', 50.000, 47.124, '2026-09-17 22:12:35', 'active', 1, '2026-09-17 22:12:35', '2026-09-20 00:34:52');

-- --------------------------------------------------------

--
-- Table structure for table `cp_print_sizes`
--

CREATE TABLE `cp_print_sizes` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `width_mm` decimal(10,2) NOT NULL,
  `height_mm` decimal(10,2) NOT NULL,
  `orientation` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'portrait',
  `is_custom` tinyint(1) NOT NULL DEFAULT '0',
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_print_sizes`
--

INSERT INTO `cp_print_sizes` (`id`, `name`, `code`, `width_mm`, `height_mm`, `orientation`, `is_custom`, `enabled`, `sort_order`, `created_at`, `updated_at`) VALUES
(1, 'Carta', 'carta', 216.00, 279.00, 'portrait', 0, 1, 10, '2026-09-26 03:15:10', '2026-09-26 03:15:10'),
(2, 'Oficio', 'oficio', 216.00, 356.00, 'portrait', 0, 1, 20, '2026-09-26 03:15:10', '2026-09-26 03:15:10'),
(3, 'A4', 'a4', 210.00, 297.00, 'portrait', 0, 1, 30, '2026-09-26 03:15:10', '2026-09-26 03:15:10'),
(4, 'A3', 'a3', 297.00, 420.00, 'portrait', 0, 1, 40, '2026-09-26 03:15:10', '2026-09-26 03:15:10'),
(5, 'A2', 'a2', 420.00, 594.00, 'portrait', 0, 1, 50, '2026-09-26 03:15:10', '2026-09-26 03:15:10'),
(6, 'A1', 'a1', 594.00, 841.00, 'portrait', 0, 1, 60, '2026-09-26 03:15:10', '2026-09-26 03:15:10'),
(7, '10 × 15 cm', '10x15', 100.00, 150.00, 'portrait', 0, 1, 70, '2026-09-26 03:15:10', '2026-09-26 03:15:10'),
(8, '13 × 18 cm', '13x18', 130.00, 180.00, 'portrait', 0, 1, 80, '2026-09-26 03:15:10', '2026-09-26 03:15:10'),
(9, '60 × 90 cm', '60x90', 600.00, 900.00, 'portrait', 0, 1, 90, '2026-09-26 03:15:10', '2026-09-26 03:15:10'),
(10, 'Personalizado', 'custom', 0.00, 0.00, 'portrait', 1, 1, 999, '2026-09-26 03:15:10', '2026-09-26 03:15:10');

-- --------------------------------------------------------

--
-- Table structure for table `cp_products`
--

CREATE TABLE `cp_products` (
  `id` int(10) UNSIGNED NOT NULL,
  `source_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'local',
  `source_id` int(10) UNSIGNED DEFAULT NULL,
  `category_id` int(10) UNSIGNED DEFAULT NULL,
  `name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sku` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `sale_price` decimal(15,2) DEFAULT NULL,
  `purchase_price` decimal(15,2) DEFAULT NULL,
  `pricing_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'fixed',
  `visible_web` tinyint(1) NOT NULL DEFAULT '0',
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_products`
--

INSERT INTO `cp_products` (`id`, `source_type`, `source_id`, `category_id`, `name`, `sku`, `description`, `sale_price`, `purchase_price`, `pricing_type`, `visible_web`, `enabled`, `created_at`, `updated_at`) VALUES
(1, 'local', NULL, 1, 'Playera tipo polo, negra', NULL, NULL, 290.00, NULL, 'variable', 1, 1, '2026-09-17 00:00:10', '2026-09-17 00:35:51'),
(2, 'local', NULL, 3, 'Taza 11oz personalizada', NULL, 'Taza blanca 11oz persoonalizable', 100.00, 20.00, 'variable', 1, 1, '2026-09-17 13:51:28', '2026-09-17 13:52:18'),
(3, 'local', NULL, 8, 'SELLO AUTOENTINTABLE', NULL, 'Sello autoentintable de 5.8x2.2 cm tinta negra.\r\nPodemos hacer tu propio diseño 100% personalizado.\r\nLos sellos ilustrados hacen que los papeles de clasificación sean rápidos y fáciles.\r\nAlienta a los estudiantes a seguir aprendiendo con mensajes positivos.\r\n\r\n*SÍ FACTURAMOS, PRECIO INCLUYE IVA Y ENVIO GRATIS A TODO MEXICO*\r\n\r\n***TU COMPRA INCLUYE 1 SELLO TRODAT MODELO 4913***\r\n\r\nLas imágenes de diseños mostradas son ejemplos/ideas para que puedas elegir el que más te guste o puedes enviarnos el tuyo. Se puede personalizar con tu nombre o los datos que indiques.\r\n\r\nCaracterísticas:\r\n-Sello automático\r\n-Pequeño y ligero\r\n-Personalizado\r\n-Limpio\r\n-Mecanismo con giro de 90°\r\n-Tinta negra\r\n-Medida: 52X22MM\r\n-Marca Trodat\r\n\r\nNOTA: Una vez realizada la compra favor de enviar los datos que desea agregar a tu sello personalizado en caso de no recibir la información se enviará sin personalizar.\r\n\r\nSi desea que la tinta de su sello sea de otro color se debe comprar el cojín de repuesto por separado, puede adquirirlo en el siguiente link es muy fácil de hacer el cambio de tinta:\r\n\r\nVersión para maestros:\r\nhttps://articulo.mercadolibre.com.mx/MLM-1840658797-sello-maestros-y-educadores-personalizado-58-x-22-cm-_JM\r\n\r\nKit de 5 sellos personalizados de madera (incluye cojín)\r\n\r\nhttps://articulo.mercadolibre.com.mx/MLM-2029360613-sellos-para-maestros-escolares-personalizados-de-madera-5-pz-_JM\r\n\r\nDISTRIBUIDORES TRODAT MÉXICO AUTORIZADOS.\r\n\r\nEstamos a tus ordenes en la sección de preguntas.', 490.00, 0.00, 'fixed', 1, 1, '2026-09-22 12:05:14', '2026-09-22 12:05:14');

-- --------------------------------------------------------

--
-- Table structure for table `cp_product_images`
--

CREATE TABLE `cp_product_images` (
  `id` int(10) UNSIGNED NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `alt_text` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT '0',
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_product_images`
--

INSERT INTO `cp_product_images` (`id`, `product_id`, `path`, `alt_text`, `sort_order`, `enabled`, `created_at`) VALUES
(1, 1, '/uploads/products/8accefa041193dee33cbe8a0e20bef55.webp', 'Playera tipo polo, negra', 0, 1, '2026-09-17 00:00:10'),
(2, 2, '/uploads/products/14243a403a6c6046796330059f21a53e.jpg', 'Taza 11oz personalizada', 0, 1, '2026-09-17 13:51:28'),
(3, 3, '/uploads/products/d4bf622a226cfa33081dd635f6c93ea3.webp', 'SELLO AUTOENTINTABLE', 0, 1, '2026-09-22 12:05:14');

-- --------------------------------------------------------

--
-- Table structure for table `cp_product_inventory`
--

CREATE TABLE `cp_product_inventory` (
  `id` int(10) UNSIGNED NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `stock_mode` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unlimited',
  `quantity` decimal(12,3) NOT NULL DEFAULT '0.000',
  `reserved_quantity` decimal(12,3) NOT NULL DEFAULT '0.000',
  `low_stock_threshold` decimal(12,3) NOT NULL DEFAULT '0.000',
  `backorder_allowed` tinyint(1) NOT NULL DEFAULT '0',
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cp_projects`
--

CREATE TABLE `cp_projects` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `excerpt` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `image_path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `project_date` date DEFAULT NULL,
  `client_label` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `visible_web` tinyint(1) NOT NULL DEFAULT '1',
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cp_promotions`
--

CREATE TABLE `cp_promotions` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'OFERTA',
  `description` text COLLATE utf8mb4_unicode_ci,
  `promo_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'fixed',
  `normal_price` decimal(15,2) DEFAULT NULL,
  `promo_price` decimal(15,2) DEFAULT NULL,
  `discount_percent` decimal(6,2) DEFAULT NULL,
  `quantity_available` int(10) UNSIGNED DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `image_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `whatsapp_text` text COLLATE utf8mb4_unicode_ci,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `show_web` tinyint(1) NOT NULL DEFAULT '1',
  `show_catalog` tinyint(1) NOT NULL DEFAULT '1',
  `show_whatsapp` tinyint(1) NOT NULL DEFAULT '0',
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `updated_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_promotions`
--

INSERT INTO `cp_promotions` (`id`, `title`, `slug`, `label`, `description`, `promo_type`, `normal_price`, `promo_price`, `discount_percent`, `quantity_available`, `start_date`, `end_date`, `image_path`, `whatsapp_text`, `status`, `show_web`, `show_catalog`, `show_whatsapp`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(1, 'Playera tipo polo bordada | OFERTA DEL MES', 'playera-tipo-polo-bordada-oferta-del-mes', 'OFERTA', NULL, 'fixed', 290.00, 200.00, 31.03, 11, '2026-09-17', '2026-09-21', '/uploads/promotions/669089c7657ab6d0f9ec1193b5a64d2d.png', NULL, 'active', 1, 1, 1, 1, 1, '2026-09-17 15:38:08', '2026-09-22 19:31:40'),
(2, 'Taza Personalizada de Oferta', 'taza-personalizada-de-oferta', 'OFERTA', '☕🔥 **¡TU TAZA, TU ESTILO!** 🔥☕\r\n\r\n¿Quieres una taza que sea realmente tuya? 😍\r\nEn **Colibrí Print** personalizamos tus tazas con:\r\n\r\n❤️ Fotos ✨ Nombres 😂 Frases 🎨 Diseños 🏢 Logos para negocios\r\n\r\n🎁 **Ideal para regalar o consentirte.**\r\n📲 **WhatsApp: 627 147 0053**\r\n📍 **Colibrí Print | Personalizamos tus ideas**\r\n👉 Mándanos tu diseño o dinos qué quieres y **te cotizamos rápido.**\r\n#TazasPersonalizadas #TazasPersonalizadasMexico #RegalosPersonalizados #ColibriPrint #TazasConFoto', 'fixed', 100.00, 50.00, 50.00, 15, '2026-09-19', '2026-09-30', '/uploads/promotions/3079517b95132ffd7432ebf5cf485a45.png', NULL, 'active', 1, 1, 1, 1, 1, '2026-09-19 21:51:35', '2026-09-22 12:15:05'),
(3, 'Sello Escolar Autoentintable', 'sello-escolar-autoentintable', 'OFERTA', NULL, 'fixed', 490.00, 390.00, 20.41, NULL, '2026-09-22', '2026-09-30', '/uploads/promotions/fa0e361d7d1c8fe7d60ce39600780ddf.png', NULL, 'active', 1, 1, 0, 1, 1, '2026-09-22 12:04:02', '2026-09-25 23:17:21');

-- --------------------------------------------------------

--
-- Table structure for table `cp_promotion_facebook`
--

CREATE TABLE `cp_promotion_facebook` (
  `id` int(10) UNSIGNED NOT NULL,
  `promotion_id` int(10) UNSIGNED NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `custom_message` text COLLATE utf8mb4_unicode_ci,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `facebook_page_id` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `facebook_post_id` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_url` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_error` text COLLATE utf8mb4_unicode_ci,
  `response_json` longtext COLLATE utf8mb4_unicode_ci,
  `attempts` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `last_attempt_at` datetime DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_promotion_facebook`
--

INSERT INTO `cp_promotion_facebook` (`id`, `promotion_id`, `enabled`, `custom_message`, `status`, `facebook_page_id`, `facebook_post_id`, `image_url`, `last_error`, `response_json`, `attempts`, `last_attempt_at`, `published_at`, `created_at`, `updated_at`) VALUES
(1, 1, 1, NULL, 'published', '110268670793730', '110268670793730_1495277692620142', 'https://colibriprint.com.mx/uploads/promotions/669089c7657ab6d0f9ec1193b5a64d2d.png', NULL, '{\"id\":\"1495277655953479\",\"post_id\":\"110268670793730_1495277692620142\"}', 1, '2026-09-19 10:47:06', '2026-09-19 10:47:11', '2026-09-19 10:28:46', '2026-09-22 19:31:40'),
(4, 2, 1, NULL, 'error', '110268670793730', NULL, 'https://colibriprint.com.mx/uploads/promotions/3079517b95132ffd7432ebf5cf485a45.png', 'Error validating access token: The session is invalid because the user logged out.', '{\"error\":{\"message\":\"Error validating access token: The session is invalid because the user logged out.\",\"type\":\"OAuthException\",\"code\":190,\"error_subcode\":467,\"fbtrace_id\":\"AR6O_itk_lkl4vVUzF2B6hU\"}}', 5, '2026-09-22 12:15:05', NULL, '2026-09-19 21:51:35', '2026-09-22 12:15:05'),
(9, 3, 1, NULL, 'error', '100064137755184', NULL, 'https://colibriprint.com.mx/uploads/promotions/fa0e361d7d1c8fe7d60ce39600780ddf.png', 'Error validating application. Application has been deleted.', '{\"error\":{\"message\":\"Error validating application. Application has been deleted.\",\"type\":\"OAuthException\",\"code\":190,\"fbtrace_id\":\"AtOxfEeGxWPAGDHnqGZiIsm\"}}', 5, '2026-09-25 23:17:21', NULL, '2026-09-22 12:04:02', '2026-09-25 23:17:21');

-- --------------------------------------------------------

--
-- Table structure for table `cp_promotion_products`
--

CREATE TABLE `cp_promotion_products` (
  `id` int(10) UNSIGNED NOT NULL,
  `promotion_id` int(10) UNSIGNED NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_promotion_products`
--

INSERT INTO `cp_promotion_products` (`id`, `promotion_id`, `product_id`, `sort_order`, `created_at`) VALUES
(13, 2, 2, 0, '2026-09-22 12:15:05'),
(16, 1, 1, 0, '2026-09-22 19:31:40'),
(18, 3, 3, 0, '2026-09-25 23:17:21');

-- --------------------------------------------------------

--
-- Table structure for table `cp_quotes`
--

CREATE TABLE `cp_quotes` (
  `id` int(10) UNSIGNED NOT NULL,
  `quote_number` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_id` int(10) UNSIGNED DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `issue_date` date NOT NULL,
  `valid_until` date DEFAULT NULL,
  `client_reference` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_terms` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_time` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_place` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `terms` text COLLATE utf8mb4_unicode_ci,
  `internal_notes` text COLLATE utf8mb4_unicode_ci,
  `source_calculator` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `source_data` longtext COLLATE utf8mb4_unicode_ci,
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `updated_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_quotes`
--

INSERT INTO `cp_quotes` (`id`, `quote_number`, `customer_id`, `status`, `issue_date`, `valid_until`, `client_reference`, `payment_terms`, `delivery_time`, `delivery_place`, `notes`, `terms`, `internal_notes`, `source_calculator`, `source_data`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(13, 'CP-2026-00001', 1207, 'approved', '2026-09-08', '2026-09-16', '11 trofeos y 2 libros de firmas', NULL, NULL, 'Colibrí Print México', '', 'Cotización sujeta a disponibilidad de materiales y aprobación del cliente.', 'Pedido Retrasado desde el día 16 de septiembre', NULL, NULL, 1, 1, '2026-09-19 10:50:15', '2026-09-21 10:14:31'),
(14, 'CP-2026-00002', 856, 'approved', '2026-07-30', '2026-08-27', NULL, NULL, NULL, NULL, '', 'Cotización sujeta a disponibilidad de materiales y aprobación del cliente.', '', NULL, NULL, 1, 1, '2026-09-19 10:56:30', '2026-09-19 10:56:46'),
(15, 'CP-2026-00003', 1263, 'approved', '2026-09-12', '2026-09-17', NULL, NULL, NULL, 'Colibrí Print México', '', '', 'Enviar diseño primero\r\nLa troca Morada va en medio del diseño\r\n\r\nCliente adeuda 90 pesos', NULL, NULL, 1, 1, '2026-09-19 11:13:45', '2026-09-22 09:10:03'),
(16, 'CP-2026-00004', 640, 'approved', '2026-09-17', '2026-09-20', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', 'dirección\r\nCalle arbol de hierro no.20306\r\nColonia fraccionamiento parque industrial \r\nChihuahua, Chih.\r\nY en numero de teléfono que diga 5655484613 el mismo número que viene en las tarjetas fe presentación\r\n\r\nhttps://chatgpt.com/s/p_62e5de6cbbfc8191aa38300bbafa1de3', NULL, NULL, 1, 1, '2026-09-19 11:40:58', '2026-09-19 16:40:54'),
(17, 'CP-2026-00005', 1266, 'approved', '2026-09-18', '2026-09-21', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', 'Dio $100 de anticipo', NULL, NULL, 1, 1, '2026-09-19 17:05:47', '2026-09-19 17:21:24'),
(18, 'CP-2026-00006', 544, 'approved', '2026-09-17', '2026-09-25', 'Rotulación de Camiones', '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Antes de finalizar mes', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', 'Se factura a inicios de Octubre y paga a mediados de Octubre', NULL, NULL, 1, 1, '2026-09-19 17:15:41', '2026-09-19 17:16:23'),
(19, 'CP-2026-00007', 930, 'approved', '2026-09-18', '2026-09-22', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-19 17:26:00', '2026-09-19 20:24:06'),
(20, 'CP-2026-00008', 340, 'approved', '2026-09-14', '2026-09-23', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', 'Las libretas son con tres imágenes en la portada y todas las 50 iguales\r\n\r\nLogo en mouse Pad lo más arriba para que no se dañe con uso de mano o mouse', NULL, NULL, 1, 1, '2026-09-19 18:35:05', '2026-09-19 19:20:42'),
(28, 'CP-2026-00009', 1, 'approved', '2026-09-20', '2026-10-05', 'Solicitud web CPQ-000006', '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Entrega local', 'Solicitud recibida desde la web: CPQ-000006.\r\nFecha solicitada: 2026-09-21.\r\nForma de entrega: Entrega local.\r\nlo quiero para el tanque de una moto', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', 'ORIGEN: Solicitud web CPQ-000006\r\nSolicitud web ID: 6\r\nServicio: Vinil de corte (vinil)\r\nCliente capturado: PANCHITO\r\nWhatsApp: 6271074512\r\nCorreo: No indicado\r\nFecha solicitada: 2026-09-21\r\nDETALLES: Quantity: 1 · Surface: Vehículo · Size: 20x20cm · Color: negro\r\nPRODUCCIÓN: Design Status: Tengo el diseño final · Application: No lo sé todavía · Notes: lo quiero para el tanque de una moto\r\nENTREGA: Method: Entrega local · Desired Date: 2026-09-21\r\nARCHIVO: ChatGPT Image Aug 12, 2026, 11_51_30 AM.png\r\nPAYLOAD WEB: {\"version\":3,\"service\":{\"key\":\"vinil\",\"name\":\"Vinil de corte\"},\"details\":{\"quantity\":\"1\",\"surface\":\"Vehículo\",\"size\":\"20x20cm\",\"color\":\"negro\"},\"production\":{\"design_status\":\"Tengo el diseño final\",\"application\":\"No lo sé todavía\",\"notes\":\"lo quiero para el tanque de una moto\"},\"delivery\":{\"method\":\"Entrega local\",\"desired_date\":\"2026-09-21\"},\"attachments\":[{\"original_name\":\"ChatGPT Image Aug 12, 2026, 11_51_30 AM.png\",\"relative_path\":\"/uploads/cotizador/dc16a9fa614f0081ce52617ea2e2eec6abee67c5f6d9e9c9ce66aa67c5a4ce89/f3528e00ad7ef942d24613dfb69c4439.png\",\"mime\":\"image/png\",\"size\":865581,\"extension\":\"png\",\"sha256\":\"bd6c3534c3578c81f4de2f65eee01f7b6bac566a1f20d0c271d26f3dfb816317\"}],\"attachment\":{\"original_name\":\"ChatGPT Image Aug 12, 2026, 11_51_30 AM.png\",\"relative_path\":\"/uploads/cotizador/dc16a9fa614f0081ce52617ea2e2eec6abee67c5f6d9e9c9ce66aa67c5a4ce89/f3528e00ad7ef942d24613dfb69c4439.png\",\"mime\":\"image/png\",\"size\":865581,\"extension\":\"png\",\"sha256\":\"bd6c3534c3578c81f4de2f65eee01f7b6bac566a1f20d0c271d26f3dfb816317\"},\"submitted_at\":\"2026-09-20T00:05:17-06:00\",\"source\":\"public_quote_wizard\",\"ip_hash\":\"6e2f47d9c108c37106dd6710e224743a86073951dc4827e3c29f8e7bb6e662c9\"}', 'web', '{\"source\":\"web\",\"title\":\"Vinil de corte\",\"input\":{\"quantity\":\"1\",\"surface\":\"Vehículo\",\"size\":\"20x20cm\",\"color\":\"negro\"},\"result\":[],\"web_request_id\":6,\"request_token\":\"dc16a9fa614f0081ce52617ea2e2eec6abee67c5f6d9e9c9ce66aa67c5a4ce89\",\"payload\":{\"version\":3,\"service\":{\"key\":\"vinil\",\"name\":\"Vinil de corte\"},\"details\":{\"quantity\":\"1\",\"surface\":\"Vehículo\",\"size\":\"20x20cm\",\"color\":\"negro\"},\"production\":{\"design_status\":\"Tengo el diseño final\",\"application\":\"No lo sé todavía\",\"notes\":\"lo quiero para el tanque de una moto\"},\"delivery\":{\"method\":\"Entrega local\",\"desired_date\":\"2026-09-21\"},\"attachments\":[{\"original_name\":\"ChatGPT Image Aug 12, 2026, 11_51_30 AM.png\",\"relative_path\":\"/uploads/cotizador/dc16a9fa614f0081ce52617ea2e2eec6abee67c5f6d9e9c9ce66aa67c5a4ce89/f3528e00ad7ef942d24613dfb69c4439.png\",\"mime\":\"image/png\",\"size\":865581,\"extension\":\"png\",\"sha256\":\"bd6c3534c3578c81f4de2f65eee01f7b6bac566a1f20d0c271d26f3dfb816317\"}],\"attachment\":{\"original_name\":\"ChatGPT Image Aug 12, 2026, 11_51_30 AM.png\",\"relative_path\":\"/uploads/cotizador/dc16a9fa614f0081ce52617ea2e2eec6abee67c5f6d9e9c9ce66aa67c5a4ce89/f3528e00ad7ef942d24613dfb69c4439.png\",\"mime\":\"image/png\",\"size\":865581,\"extension\":\"png\",\"sha256\":\"bd6c3534c3578c81f4de2f65eee01f7b6bac566a1f20d0c271d26f3dfb816317\"},\"submitted_at\":\"2026-09-20T00:05:17-06:00\",\"source\":\"public_quote_wizard\",\"ip_hash\":\"6e2f47d9c108c37106dd6710e224743a86073951dc4827e3c29f8e7bb6e662c9\"},\"attachment\":{\"original_name\":\"ChatGPT Image Aug 12, 2026, 11_51_30 AM.png\",\"relative_path\":\"/uploads/cotizador/dc16a9fa614f0081ce52617ea2e2eec6abee67c5f6d9e9c9ce66aa67c5a4ce89/f3528e00ad7ef942d24613dfb69c4439.png\",\"mime\":\"image/png\",\"size\":865581,\"extension\":\"png\",\"sha256\":\"bd6c3534c3578c81f4de2f65eee01f7b6bac566a1f20d0c271d26f3dfb816317\"},\"created_at\":\"2026-09-20T00:07:09-06:00\"}', 1, 1, '2026-09-20 00:07:09', '2026-09-20 00:10:30'),
(29, 'CP-2026-00010', 1, 'approved', '2026-09-20', '2026-10-05', 'Solicitud web CPQ-000007', '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Entrega local', 'Solicitud recibida desde la web: CPQ-000007.\r\nFecha solicitada: 2026-09-26.\r\nForma de entrega: Entrega local.\r\nQUIERO GRABAR UN LOGO EN EL YETI', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', 'ORIGEN: Solicitud web CPQ-000007\r\nSolicitud web ID: 7\r\nServicio: Grabado láser (laser)\r\nCliente capturado: MIGUEL\r\nWhatsApp: 6271074512\r\nCorreo: No indicado\r\nFecha solicitada: 2026-09-26\r\nDETALLES: Quantity: 1 · Material: YETI · Detail: LOGO\r\nPRODUCCIÓN: Design Status: Solo tengo la idea · Application: No lo sé todavía · Notes: QUIERO GRABAR UN LOGO EN EL YETI\r\nENTREGA: Method: Entrega local · Desired Date: 2026-09-26\r\nARCHIVO: Logo 2027.png\r\nPAYLOAD WEB: {\"version\":3,\"service\":{\"key\":\"laser\",\"name\":\"Grabado láser\"},\"details\":{\"quantity\":\"1\",\"material\":\"YETI\",\"size\":\"\",\"detail\":\"LOGO\"},\"production\":{\"design_status\":\"Solo tengo la idea\",\"application\":\"No lo sé todavía\",\"notes\":\"QUIERO GRABAR UN LOGO EN EL YETI\"},\"delivery\":{\"method\":\"Entrega local\",\"desired_date\":\"2026-09-26\"},\"attachments\":[{\"original_name\":\"Logo 2027.png\",\"relative_path\":\"/uploads/cotizador/a378b7984cc574c69e83c15d69bb71d687063bf794d6b9f0d96df7712cb0c4d6/dc8c622bcedc99bca185c706a292f25f.png\",\"mime\":\"image/png\",\"size\":1222567,\"extension\":\"png\",\"sha256\":\"9dccdc6bdbaa3c9c84bcde4280249629f42032dc2144b11c3804199c2899b506\"}],\"attachment\":{\"original_name\":\"Logo 2027.png\",\"relative_path\":\"/uploads/cotizador/a378b7984cc574c69e83c15d69bb71d687063bf794d6b9f0d96df7712cb0c4d6/dc8c622bcedc99bca185c706a292f25f.png\",\"mime\":\"image/png\",\"size\":1222567,\"extension\":\"png\",\"sha256\":\"9dccdc6bdbaa3c9c84bcde4280249629f42032dc2144b11c3804199c2899b506\"},\"submitted_at\":\"2026-09-20T00:21:07-06:00\",\"source\":\"public_quote_wizard\",\"ip_hash\":\"6e2f47d9c108c37106dd6710e224743a86073951dc4827e3c29f8e7bb6e662c9\"}', 'web', '{\"source\":\"web\",\"title\":\"Grabado láser\",\"input\":{\"quantity\":\"1\",\"material\":\"YETI\",\"size\":\"\",\"detail\":\"LOGO\"},\"result\":[],\"web_request_id\":7,\"request_token\":\"a378b7984cc574c69e83c15d69bb71d687063bf794d6b9f0d96df7712cb0c4d6\",\"payload\":{\"version\":3,\"service\":{\"key\":\"laser\",\"name\":\"Grabado láser\"},\"details\":{\"quantity\":\"1\",\"material\":\"YETI\",\"size\":\"\",\"detail\":\"LOGO\"},\"production\":{\"design_status\":\"Solo tengo la idea\",\"application\":\"No lo sé todavía\",\"notes\":\"QUIERO GRABAR UN LOGO EN EL YETI\"},\"delivery\":{\"method\":\"Entrega local\",\"desired_date\":\"2026-09-26\"},\"attachments\":[{\"original_name\":\"Logo 2027.png\",\"relative_path\":\"/uploads/cotizador/a378b7984cc574c69e83c15d69bb71d687063bf794d6b9f0d96df7712cb0c4d6/dc8c622bcedc99bca185c706a292f25f.png\",\"mime\":\"image/png\",\"size\":1222567,\"extension\":\"png\",\"sha256\":\"9dccdc6bdbaa3c9c84bcde4280249629f42032dc2144b11c3804199c2899b506\"}],\"attachment\":{\"original_name\":\"Logo 2027.png\",\"relative_path\":\"/uploads/cotizador/a378b7984cc574c69e83c15d69bb71d687063bf794d6b9f0d96df7712cb0c4d6/dc8c622bcedc99bca185c706a292f25f.png\",\"mime\":\"image/png\",\"size\":1222567,\"extension\":\"png\",\"sha256\":\"9dccdc6bdbaa3c9c84bcde4280249629f42032dc2144b11c3804199c2899b506\"},\"submitted_at\":\"2026-09-20T00:21:07-06:00\",\"source\":\"public_quote_wizard\",\"ip_hash\":\"6e2f47d9c108c37106dd6710e224743a86073951dc4827e3c29f8e7bb6e662c9\"},\"attachment\":{\"original_name\":\"Logo 2027.png\",\"relative_path\":\"/uploads/cotizador/a378b7984cc574c69e83c15d69bb71d687063bf794d6b9f0d96df7712cb0c4d6/dc8c622bcedc99bca185c706a292f25f.png\",\"mime\":\"image/png\",\"size\":1222567,\"extension\":\"png\",\"sha256\":\"9dccdc6bdbaa3c9c84bcde4280249629f42032dc2144b11c3804199c2899b506\"},\"created_at\":\"2026-09-20T00:21:58-06:00\"}', 1, 1, '2026-09-20 00:21:58', '2026-09-20 00:23:17'),
(30, 'CP-2026-00011', 763, 'approved', '2026-09-22', '2026-09-25', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / Colibrí Print', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-22 08:38:12', '2026-09-22 08:38:30'),
(31, 'CP-2026-00012', 1270, 'approved', '2026-09-21', '2026-10-05', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', NULL, 'Hidalgo del Parral, Chihuahua /', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-22 10:38:27', '2026-09-25 13:24:49'),
(32, 'CP-2026-00013', 1270, 'approved', '2026-09-21', '2026-10-05', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-22 10:53:47', '2026-09-22 10:54:06'),
(33, 'CP-2026-00014', 1039, 'approved', '2026-09-22', '2026-09-24', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', 'Ya revisé los números con la Señora Bujaidar , los 2 colores en las hojas serán Shedton y mostaza y la frase en shedron así como la imagen', 'París:\r\n16 hojas shedron\r\n16 hojas mostaza \r\n8 frases\r\n\r\nRoma:\r\n14 hojas shedron\r\n14 hojas mostaza \r\n7 frases', '', NULL, NULL, 1, 1, '2026-09-22 11:05:30', '2026-09-25 11:20:29'),
(34, 'CP-2026-00015', 908, 'approved', '2026-09-22', '2026-09-23', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-22 14:18:56', '2026-09-22 14:19:11'),
(35, 'CP-2026-00016', 1204, 'approved', '2026-09-22', '2026-09-25', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-22 14:29:17', '2026-09-23 09:57:45'),
(36, 'CP-2026-00017', 769, 'approved', '2026-09-22', '2026-10-07', 'CALCA VINILO VENTA DE AUTO', '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-22 20:46:26', '2026-09-22 20:46:32'),
(37, 'CP-2026-00018', 571, 'approved', '2026-09-23', '2026-09-25', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', '', '', NULL, NULL, 1, 1, '2026-09-23 09:06:41', '2026-09-23 09:06:52'),
(38, 'CP-2026-00019', 1271, 'approved', '2026-09-23', '2026-09-24', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-23 10:44:17', '2026-09-23 10:44:56'),
(39, 'CP-2026-00020', 746, 'approved', '2026-09-23', '2026-09-30', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-23 20:02:07', '2026-09-24 10:36:10'),
(40, 'CP-2026-00021', 1272, 'approved', '2026-09-24', '2026-09-26', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-24 09:58:55', '2026-09-24 09:59:48'),
(41, 'CP-2026-00022', 1273, 'approved', '2026-09-24', '2026-10-09', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-24 10:59:02', '2026-09-24 18:27:41'),
(42, 'CP-2026-00023', 1197, 'approved', '2026-09-24', '2026-09-26', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-24 12:35:53', '2026-09-24 12:36:02'),
(43, 'CP-2026-00024', 207, 'approved', '2026-09-24', '2026-09-25', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-24 17:37:06', '2026-09-24 17:37:14'),
(44, 'CP-2026-00025', 1274, 'sent', '2026-09-24', '2026-10-09', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', 'en la compra del paquete completo, las sudaderas de los docentes titulares son Gratis', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-24 18:23:55', '2026-09-24 18:24:30'),
(45, 'CP-2026-00026', 1209, 'draft', '2026-09-24', '2026-09-25', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-24 21:15:24', '2026-09-24 21:32:14'),
(46, 'CP-2026-00027', 1275, 'approved', '2026-09-25', '2026-09-26', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-25 04:50:42', '2026-09-25 04:51:44'),
(47, 'CP-2026-00028', 1276, 'approved', '2026-09-25', '2026-10-09', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-25 07:44:10', '2026-09-25 07:44:28'),
(48, 'CP-2026-00029', 1277, 'approved', '2026-09-25', '2026-09-25', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-25 08:14:22', '2026-09-25 08:15:20'),
(49, 'CP-2026-00030', 1279, 'approved', '2026-09-25', '2026-10-10', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-25 10:00:16', '2026-09-25 10:00:19'),
(50, 'CP-2026-00031', 1209, 'approved', '2026-09-25', '2026-10-10', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-25 12:14:52', '2026-09-25 12:15:02'),
(51, 'CP-2026-00032', 1280, 'approved', '2026-09-25', '2026-09-26', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto (1-2 días hábiles)', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', 'Impresión con unión', '', '', NULL, NULL, 1, 1, '2026-09-25 17:08:33', '2026-09-25 17:19:07'),
(52, 'CP-2026-00033', 1281, 'draft', '2026-09-25', '2026-10-10', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', 'Saily Yanira Herrera Vargas\r\n\r\nChambelán Aldo orpineda\r\n\r\nPadres \r\nRefugio Herrera Gutiérrez \r\nNereida Vargas Macías\r\n\r\nCeremonia \r\n2:30 pm\r\n\r\nCalle de la cava \r\nNúmero 5\r\nColonia las parras', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-25 19:28:54', '2026-09-25 19:31:07'),
(53, 'CP-2026-00034', 1282, 'draft', '2026-09-25', '2026-10-10', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-25 19:53:45', '2026-09-25 20:00:27'),
(54, 'CP-2026-00035', 1223, 'approved', '2026-09-25', '2026-09-26', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-25 20:36:20', '2026-09-25 20:36:49');

-- --------------------------------------------------------

--
-- Table structure for table `cp_quote_condition_templates`
--

CREATE TABLE `cp_quote_condition_templates` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_terms` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_time` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_place` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `terms` text COLLATE utf8mb4_unicode_ci,
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int(11) NOT NULL DEFAULT '0',
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `updated_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_quote_condition_templates`
--

INSERT INTO `cp_quote_condition_templates` (`id`, `name`, `payment_terms`, `delivery_time`, `delivery_place`, `terms`, `is_default`, `enabled`, `sort_order`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(1, 'Condición general Colibrí Print', '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', 1, 1, 0, NULL, NULL, '2026-09-19 12:25:09', '2026-09-19 12:25:09');

-- --------------------------------------------------------

--
-- Table structure for table `cp_quote_costs`
--

CREATE TABLE `cp_quote_costs` (
  `id` int(10) UNSIGNED NOT NULL,
  `quote_id` int(10) UNSIGNED NOT NULL,
  `concept` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(15,2) NOT NULL DEFAULT '0.00',
  `details` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cp_quote_items`
--

CREATE TABLE `cp_quote_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `quote_id` int(10) UNSIGNED NOT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` decimal(12,3) NOT NULL DEFAULT '1.000',
  `unit_price` decimal(15,2) NOT NULL DEFAULT '0.00',
  `subtotal` decimal(15,2) NOT NULL DEFAULT '0.00',
  `calculator_source` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_quote_items`
--

INSERT INTO `cp_quote_items` (`id`, `quote_id`, `description`, `quantity`, `unit_price`, `subtotal`, `calculator_source`, `sort_order`, `created_at`, `updated_at`) VALUES
(20, 14, 'Sudadera Mickey Mouse', 6.000, 420.00, 2520.00, NULL, 0, '2026-09-19 10:56:30', '2026-09-19 10:56:30'),
(26, 16, 'Block 100 recetas de seguridad', 1.000, 350.00, 350.00, NULL, 0, '2026-09-19 16:40:54', '2026-09-19 16:40:54'),
(27, 16, '100 tarjetas de presentación', 1.000, 270.00, 270.00, NULL, 1, '2026-09-19 16:40:54', '2026-09-19 16:40:54'),
(29, 18, 'Impresión vinil adhesivo tamaño tabloide', 100.000, 37.00, 3700.00, NULL, 0, '2026-09-19 17:15:41', '2026-09-19 17:15:41'),
(30, 18, 'Rotulación de Camiones medida 140cm x 70cm', 10.000, 790.00, 7900.00, NULL, 1, '2026-09-19 17:15:41', '2026-09-19 17:15:41'),
(31, 17, 'Impresión Papel Bond 50x70cm', 2.000, 80.00, 160.00, NULL, 0, '2026-09-19 17:21:24', '2026-09-19 17:21:24'),
(38, 20, 'Diseño e impresión de block 100 Vales salida de almacén Tamaño media carta, original y copia, foliado', 20.000, 295.00, 5900.00, '', 0, '2026-09-19 19:20:42', '2026-09-19 19:20:42'),
(39, 19, 'Impresión Certificados de Servicio, incluye hojas', 100.000, 3.50, 350.00, NULL, 0, '2026-09-19 20:24:06', '2026-09-19 20:24:06'),
(40, 19, '100 Tarjetas de presentación un solo lado', 2.000, 190.00, 380.00, NULL, 1, '2026-09-19 20:24:06', '2026-09-19 20:24:06'),
(50, 28, 'Vinil de corte | Quantity: 1 · Surface: Vehículo · Size: 20x20cm · Color: negro', 2.000, 80.00, 160.00, 'web', 0, '2026-09-20 00:10:25', '2026-09-20 00:10:25'),
(51, 28, 'COSTO POR INSTALACION 50 PESOS', 1.000, 50.00, 50.00, NULL, 1, '2026-09-20 00:10:25', '2026-09-20 00:10:25'),
(53, 29, 'Grabado láser | Quantity: 1 · Material: YETI · Detail: LOGO', 1.000, 150.00, 150.00, 'web', 0, '2026-09-20 00:22:37', '2026-09-20 00:22:37'),
(54, 13, 'Trofeo Trofeo Reconocimiento Materiales acrílico transparente, fondo y base de madera, grabado láser, medida 20x20cm aprox', 11.000, 545.00, 5995.00, NULL, 0, '2026-09-21 10:14:31', '2026-09-21 10:14:31'),
(55, 13, 'Reconocimiento Libro de firmas temática Basebol Tamaño 9x11\", incluye 13 pelotas. Fabricado en madera y acrílico grabado láser', 2.000, 450.00, 900.00, NULL, 1, '2026-09-21 10:14:31', '2026-09-21 10:14:31'),
(56, 30, 'Decorativo vinil impreso y coroplast Princesa 1.20 , personaje verde  150x60cm, logotipo 40x50cm', 1.000, 750.00, 750.00, NULL, 0, '2026-09-22 08:38:12', '2026-09-22 08:38:12'),
(57, 15, 'Lona 3m x 1.20m', 1.000, 720.00, 720.00, NULL, 0, '2026-09-22 09:10:03', '2026-09-22 09:10:03'),
(60, 32, 'Playera algodón personalizada tamaño corazón 4S, 5M, 2L', 11.000, 180.00, 1980.00, NULL, 0, '2026-09-22 10:53:47', '2026-09-22 10:53:47'),
(67, 34, 'Sello personalizado', 1.000, 490.00, 490.00, NULL, 0, '2026-09-22 14:18:56', '2026-09-22 14:18:56'),
(68, 35, 'Diseño e impresión de tarjetas 11x28 (340) palabras 28x28cm (54)abecedario mayúscula y minúscula', 7.000, 650.00, 4550.00, NULL, 0, '2026-09-22 14:29:17', '2026-09-22 14:29:17'),
(69, 36, 'CALCA VINILO VENTA DE AUTO 90CM X 25CM', 1.000, 100.00, 100.00, NULL, 0, '2026-09-22 20:46:26', '2026-09-22 20:46:26'),
(70, 37, 'Diseño e impresión de block 100 notas tamaño un cuarto de carta original y copia', 1.000, 260.00, 260.00, NULL, 0, '2026-09-23 09:06:41', '2026-09-23 09:06:41'),
(71, 38, 'Paquete Fiesta 80 etiquetas para botella agua 500ml 60 calcas 10cm 60 calcas 6cm', 1.000, 490.00, 490.00, NULL, 0, '2026-09-23 10:44:17', '2026-09-23 10:44:17'),
(84, 40, 'Paquete 10 cajas cartón 35x26x8cm', 1.000, 299.00, 299.00, NULL, 0, '2026-09-24 09:58:55', '2026-09-24 09:58:55'),
(85, 39, 'Agenda personalizada tamaño media carta incluyecpluma', 1.000, 270.00, 270.00, NULL, 0, '2026-09-24 10:36:10', '2026-09-24 10:36:10'),
(86, 39, 'Llavero corazón partido, dos piezas', 1.000, 100.00, 100.00, NULL, 1, '2026-09-24 10:36:10', '2026-09-24 10:36:10'),
(87, 39, 'Cuadro decorativo para tela medida 40x30cm', 1.000, 190.00, 190.00, NULL, 2, '2026-09-24 10:36:10', '2026-09-24 10:36:10'),
(88, 39, 'Cuadro canvas notas musicales 20x30cm', 1.000, 290.00, 290.00, NULL, 3, '2026-09-24 10:36:10', '2026-09-24 10:36:10'),
(89, 39, 'Cuadro decorativo tipo piano, piezas en relieve medida 9\"x12\" 250.00', 1.000, 0.10, 0.10, NULL, 4, '2026-09-24 10:36:10', '2026-09-24 10:36:10'),
(90, 39, 'Circulo arte con hilos medida 11\" 190.00', 1.000, 0.10, 0.10, NULL, 5, '2026-09-24 10:36:10', '2026-09-24 10:36:10'),
(91, 41, 'Playera personalizada caballero sin mangas personalizado frente y posterior   talla Mtallas', 1.000, 290.00, 290.00, NULL, 0, '2026-09-24 10:59:02', '2026-09-24 10:59:02'),
(92, 41, 'Playera personalizada mujer, corte Unisex personalizado frente y posterior', 1.000, 290.00, 290.00, NULL, 1, '2026-09-24 10:59:02', '2026-09-24 10:59:02'),
(93, 42, 'Sello personalizado', 1.000, 390.00, 390.00, NULL, 0, '2026-09-24 12:35:53', '2026-09-24 12:35:53'),
(94, 42, 'Impresión 2 piezas de vinil 60cm', 1.000, 390.00, 390.00, NULL, 1, '2026-09-24 12:35:53', '2026-09-24 12:35:53'),
(95, 43, 'Impresión e instalación de lona medida 3m x 75cm', 1.000, 450.00, 450.00, NULL, 0, '2026-09-24 17:37:06', '2026-09-24 17:37:06'),
(96, 43, 'Acrílico horario, grabado láser medida 30x40cm', 1.000, 190.00, 190.00, NULL, 1, '2026-09-24 17:37:06', '2026-09-24 17:37:06'),
(97, 44, 'Sudadera capucha cangurera personalizada frente y espalda generación primaria', 68.000, 419.99, 28559.32, NULL, 0, '2026-09-24 18:23:55', '2026-09-24 18:23:55'),
(99, 45, 'IMPRESION DE CREDENCIALES PVC', 21.000, 39.00, 819.00, NULL, 0, '2026-09-24 21:32:14', '2026-09-24 21:32:14'),
(101, 46, 'IMPRESION EN PAPEL BOND 90X60CM', 3.000, 80.00, 240.00, NULL, 0, '2026-09-25 04:51:44', '2026-09-25 04:51:44'),
(106, 47, 'IMPRESION EN PAPEL BOND 90X60CM', 3.000, 80.00, 240.00, NULL, 0, '2026-09-25 07:44:20', '2026-09-25 07:44:20'),
(107, 47, 'IMPRESION EN PAPEL BOND A3', 11.000, 20.00, 220.00, NULL, 1, '2026-09-25 07:44:20', '2026-09-25 07:44:20'),
(108, 47, 'IMPRESION EN PAPEL BOND A3', 13.000, 20.00, 260.00, NULL, 2, '2026-09-25 07:44:20', '2026-09-25 07:44:20'),
(109, 47, 'IMPRESION EN PAPEL BOND A3', 8.000, 20.00, 160.00, NULL, 3, '2026-09-25 07:44:20', '2026-09-25 07:44:20'),
(110, 48, 'IMPRESION EN PAPEL BOND 90X60CM', 3.000, 80.00, 240.00, NULL, 0, '2026-09-25 08:14:22', '2026-09-25 08:14:22'),
(111, 49, 'IMPRESION EN PAPEL BOND 90X60CM', 4.000, 80.00, 320.00, NULL, 0, '2026-09-25 10:00:16', '2026-09-25 10:00:16'),
(112, 33, 'Vinil impreso decoración  hojas de otoño 40x50cm aprox cada una con suaje', 60.000, 35.00, 2100.00, NULL, 0, '2026-09-25 11:19:27', '2026-09-25 11:19:27'),
(113, 33, 'Frase decorativa vinil medida 1.55m x 54cm', 15.000, 190.00, 2850.00, NULL, 1, '2026-09-25 11:19:27', '2026-09-25 11:19:27'),
(114, 33, 'Papel de Transferencia para vinilo decorativo (15 frases 1.55 x 54cm', 1.000, 759.00, 759.00, NULL, 2, '2026-09-25 11:19:27', '2026-09-25 11:19:27'),
(115, 50, 'IMPRESION DE CREDENCIALES PVC', 100.000, 39.00, 3900.00, NULL, 0, '2026-09-25 12:14:52', '2026-09-25 12:14:52'),
(118, 31, 'Playera negra algodón corte caballero  5S, 13M, 4L', 22.000, 200.00, 4400.00, NULL, 0, '2026-09-25 13:24:49', '2026-09-25 13:24:49'),
(119, 31, 'Playera negra algodón corte caballero  1XL, 1XXL', 2.000, 230.00, 460.00, NULL, 1, '2026-09-25 13:24:49', '2026-09-25 13:24:49'),
(123, 51, 'Impresión de lona medida 390cm x 240cm incluye 10cm de rebase para tensado', 8.000, 1029.00, 8232.00, NULL, 0, '2026-09-25 17:19:07', '2026-09-25 17:19:07'),
(126, 52, 'Diseño e impresión de invitación para XV', 50.000, 45.00, 2250.00, NULL, 0, '2026-09-25 19:31:07', '2026-09-25 19:31:07'),
(127, 52, 'Invitación digital', 1.000, 450.00, 450.00, NULL, 1, '2026-09-25 19:31:07', '2026-09-25 19:31:07'),
(141, 53, 'Impresión de vinil microperforado puertas', 4.000, 450.00, 1800.00, NULL, 0, '2026-09-25 20:00:27', '2026-09-25 20:00:27'),
(142, 53, 'Impresión de vinil microperforado 2 ventanales pasillo', 1.000, 2810.00, 2810.00, NULL, 1, '2026-09-25 20:00:27', '2026-09-25 20:00:27'),
(143, 53, 'Impresión de vinil microperforado 2 ventanales frente', 1.000, 2115.00, 2115.00, NULL, 2, '2026-09-25 20:00:27', '2026-09-25 20:00:27'),
(144, 53, 'Impresión lona mostrador principal', 1.000, 613.00, 613.00, NULL, 3, '2026-09-25 20:00:27', '2026-09-25 20:00:27'),
(145, 53, 'Impresión lona mostrador lateral', 1.000, 525.00, 525.00, NULL, 4, '2026-09-25 20:00:27', '2026-09-25 20:00:27'),
(146, 53, 'Impresión Menú Pared', 1.000, 480.00, 480.00, NULL, 5, '2026-09-25 20:00:27', '2026-09-25 20:00:27'),
(147, 53, 'Impresión lona interior', 1.000, 203.00, 203.00, NULL, 6, '2026-09-25 20:00:27', '2026-09-25 20:00:27'),
(148, 53, 'Impresión Menú PVC y vinil', 1.000, 890.00, 890.00, NULL, 7, '2026-09-25 20:00:27', '2026-09-25 20:00:27'),
(149, 53, 'Vinil impreso y coroplast Dayvaso 1.20m con QR', 1.000, 450.00, 450.00, NULL, 8, '2026-09-25 20:00:27', '2026-09-25 20:00:27'),
(150, 53, 'Instalación/mano de obra revestimiento de publicidad', 1.000, 3570.00, 3570.00, NULL, 9, '2026-09-25 20:00:27', '2026-09-25 20:00:27'),
(151, 54, 'Taza personalizada Radiorama', 5.000, 70.00, 350.00, NULL, 0, '2026-09-25 20:36:20', '2026-09-25 20:36:20');

-- --------------------------------------------------------

--
-- Table structure for table `cp_quote_public_tokens`
--

CREATE TABLE `cp_quote_public_tokens` (
  `id` int(10) UNSIGNED NOT NULL,
  `quote_id` int(10) UNSIGNED NOT NULL,
  `token` char(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL,
  `last_access_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_quote_public_tokens`
--

INSERT INTO `cp_quote_public_tokens` (`id`, `quote_id`, `token`, `active`, `created_at`, `last_access_at`) VALUES
(9, 16, 'c97c7e05fe2bbe3da6aca189a174628452a1264c75e93dfbf925bee3026feb5f', 1, '2026-09-19 17:07:21', '2026-09-20 15:47:21'),
(10, 33, '84ea9650747124f8a2f43c703a63879a653e2726d2cb4193b1fed56b421a3933', 1, '2026-09-22 15:05:42', '2026-09-25 11:05:01'),
(11, 29, '284ed6f22f3a889ea9ee841d62d76a87620e69e906e4bd3c403b246b73e6dcc7', 1, '2026-09-23 22:15:33', '2026-09-23 23:44:26'),
(12, 39, 'a2891f7b1573c47c946bff21abab3a51a1e9d0765ee5c7559e626fd1800640b2', 1, '2026-09-23 23:10:48', NULL),
(13, 41, 'be858aa914a0455819bf6ad814aab000ac3c1b408bd8ad73b1e7ee8dc0958e9f', 1, '2026-09-24 11:00:18', '2026-09-25 17:30:37'),
(14, 44, '35ab5b9ae3f7cf83956db2690f0d841513cf0679ea1f85d99a36e7f7869a6230', 1, '2026-09-24 18:24:38', '2026-09-25 10:46:36'),
(15, 45, 'e4e37764bf1fffc3d32d70e76eb520aada86690b364e13cc0b0b022c663389cb', 1, '2026-09-24 21:16:48', '2026-09-25 14:15:46'),
(16, 48, '6f5ac43c0fd1f9b04227eb16987e1ba499f916919f98c20ce55d5e9709065d5e', 1, '2026-09-25 08:14:29', '2026-09-25 08:17:26'),
(17, 50, '441c99c479a9509ecbf77a94021cb78e4d466352ba26e421c22bbfc2b6cbc2be', 1, '2026-09-25 12:15:17', '2026-09-25 13:52:21'),
(18, 31, 'ddb29e87d431885c5a0ee5f2f1cf25d0777c4bb5cc0698b96ff8fd8bad6a822d', 1, '2026-09-25 13:22:24', NULL),
(19, 51, 'c55d61d766108fd12919c47fb086292a4cfe7e9e9565d448317ad99fd1ccd5fa', 1, '2026-09-25 17:09:51', '2026-09-26 08:37:18'),
(20, 52, '74ac7f6a7349ad9b1a60dfee52af11d186c4c986b42284616f90918d997e4957', 1, '2026-09-25 19:31:49', '2026-09-25 19:44:41'),
(21, 53, '366c897123d130f7d2e2ea04bc43a22548a63a3021f2ffde4276f7fdc2febb3d', 1, '2026-09-25 20:32:18', NULL),
(22, 54, '2bef9fbf2233baf5288fc5dd164be044e3676f8cb1cfe8fc870af93d7cd402c7', 1, '2026-09-25 20:47:31', '2026-09-25 21:16:23');

-- --------------------------------------------------------

--
-- Table structure for table `cp_quote_totals`
--

CREATE TABLE `cp_quote_totals` (
  `id` int(10) UNSIGNED NOT NULL,
  `quote_id` int(10) UNSIGNED NOT NULL,
  `subtotal` decimal(15,2) NOT NULL DEFAULT '0.00',
  `discount` decimal(15,2) NOT NULL DEFAULT '0.00',
  `tax` decimal(15,2) NOT NULL DEFAULT '0.00',
  `total` decimal(15,2) NOT NULL DEFAULT '0.00',
  `internal_cost` decimal(15,2) NOT NULL DEFAULT '0.00',
  `profit` decimal(15,2) NOT NULL DEFAULT '0.00',
  `margin_pct` decimal(7,3) NOT NULL DEFAULT '0.000',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_quote_totals`
--

INSERT INTO `cp_quote_totals` (`id`, `quote_id`, `subtotal`, `discount`, `tax`, `total`, `internal_cost`, `profit`, `margin_pct`, `created_at`, `updated_at`) VALUES
(20, 14, 2520.00, 0.00, 0.00, 2520.00, 0.00, 2520.00, 100.000, '2026-09-19 10:56:30', '2026-09-19 10:56:30'),
(25, 16, 620.00, 0.00, 0.00, 620.00, 0.00, 620.00, 100.000, '2026-09-19 16:40:54', '2026-09-19 16:40:54'),
(27, 18, 11600.00, 0.00, 1856.00, 13456.00, 0.00, 13456.00, 100.000, '2026-09-19 17:15:41', '2026-09-19 17:15:41'),
(28, 17, 160.00, 0.00, 0.00, 160.00, 0.00, 160.00, 100.000, '2026-09-19 17:21:24', '2026-09-19 17:21:24'),
(31, 20, 5900.00, 0.00, 944.00, 6844.00, 0.00, 5900.00, 100.000, '2026-09-19 19:20:42', '2026-09-19 19:20:42'),
(32, 19, 730.00, 0.00, 0.00, 730.00, 0.00, 730.00, 100.000, '2026-09-19 20:24:06', '2026-09-19 20:24:06'),
(41, 28, 210.00, 0.00, 0.00, 210.00, 0.00, 210.00, 100.000, '2026-09-20 00:10:25', '2026-09-20 00:10:25'),
(43, 29, 150.00, 0.00, 0.00, 150.00, 0.00, 150.00, 100.000, '2026-09-20 00:22:37', '2026-09-20 00:22:37'),
(44, 13, 6895.00, 0.00, 0.00, 6895.00, 0.00, 6895.00, 100.000, '2026-09-21 10:14:31', '2026-09-21 10:14:31'),
(45, 30, 750.00, 0.00, 0.00, 750.00, 0.00, 750.00, 100.000, '2026-09-22 08:38:12', '2026-09-22 08:38:12'),
(46, 15, 720.00, 0.00, 0.00, 720.00, 0.00, 720.00, 100.000, '2026-09-22 09:10:03', '2026-09-22 09:10:03'),
(48, 32, 1980.00, 198.00, 0.00, 1782.00, 0.00, 1782.00, 100.000, '2026-09-22 10:53:47', '2026-09-22 10:53:47'),
(52, 34, 490.00, 100.00, 0.00, 390.00, 0.00, 390.00, 100.000, '2026-09-22 14:18:56', '2026-09-22 14:18:56'),
(53, 35, 4550.00, 0.00, 0.00, 4550.00, 0.00, 4550.00, 100.000, '2026-09-22 14:29:17', '2026-09-22 14:29:17'),
(54, 36, 100.00, 0.00, 0.00, 100.00, 0.00, 100.00, 100.000, '2026-09-22 20:46:26', '2026-09-22 20:46:26'),
(55, 37, 260.00, 0.00, 0.00, 260.00, 0.00, 260.00, 100.000, '2026-09-23 09:06:41', '2026-09-23 09:06:41'),
(56, 38, 490.00, 0.00, 0.00, 490.00, 0.00, 490.00, 100.000, '2026-09-23 10:44:17', '2026-09-23 10:44:17'),
(61, 40, 299.00, 0.00, 0.00, 299.00, 0.00, 299.00, 100.000, '2026-09-24 09:58:55', '2026-09-24 09:58:55'),
(62, 39, 850.20, 0.00, 0.00, 850.20, 0.00, 850.20, 100.000, '2026-09-24 10:36:10', '2026-09-24 10:36:10'),
(63, 41, 580.00, 0.00, 0.00, 580.00, 0.00, 580.00, 100.000, '2026-09-24 10:59:02', '2026-09-24 10:59:02'),
(64, 42, 780.00, 0.00, 0.00, 780.00, 0.00, 780.00, 100.000, '2026-09-24 12:35:53', '2026-09-24 12:35:53'),
(65, 43, 640.00, 0.00, 0.00, 640.00, 0.00, 640.00, 100.000, '2026-09-24 17:37:06', '2026-09-24 17:37:06'),
(66, 44, 28559.32, 4283.90, 0.00, 24275.42, 0.00, 24275.42, 100.000, '2026-09-24 18:23:55', '2026-09-24 18:23:55'),
(68, 45, 819.00, 0.00, 131.04, 950.04, 0.00, 950.04, 100.000, '2026-09-24 21:32:14', '2026-09-24 21:32:14'),
(70, 46, 240.00, 0.00, 0.00, 240.00, 0.00, 240.00, 100.000, '2026-09-25 04:51:44', '2026-09-25 04:51:44'),
(72, 47, 880.00, 0.00, 0.00, 880.00, 0.00, 880.00, 100.000, '2026-09-25 07:44:20', '2026-09-25 07:44:20'),
(73, 48, 240.00, 0.00, 0.00, 240.00, 0.00, 240.00, 100.000, '2026-09-25 08:14:22', '2026-09-25 08:14:22'),
(74, 49, 320.00, 0.00, 0.00, 320.00, 0.00, 320.00, 100.000, '2026-09-25 10:00:16', '2026-09-25 10:00:16'),
(75, 33, 5709.00, 0.00, 913.44, 6622.44, 0.00, 6622.44, 100.000, '2026-09-25 11:19:27', '2026-09-25 11:19:27'),
(76, 50, 3900.00, 0.00, 624.00, 4524.00, 0.00, 4524.00, 100.000, '2026-09-25 12:14:52', '2026-09-25 12:14:52'),
(78, 31, 4860.00, 486.00, 0.00, 4374.00, 0.00, 4374.00, 100.000, '2026-09-25 13:24:49', '2026-09-25 13:24:49'),
(82, 51, 8232.00, 0.00, 1317.12, 9549.12, 0.00, 9549.12, 100.000, '2026-09-25 17:19:07', '2026-09-25 17:19:07'),
(84, 52, 2700.00, 0.00, 0.00, 2700.00, 0.00, 2700.00, 100.000, '2026-09-25 19:31:07', '2026-09-25 19:31:07'),
(87, 53, 13456.00, 0.00, 0.00, 13456.00, 0.00, 13456.00, 100.000, '2026-09-25 20:00:27', '2026-09-25 20:00:27'),
(88, 54, 350.00, 0.00, 0.00, 350.00, 0.00, 350.00, 100.000, '2026-09-25 20:36:20', '2026-09-25 20:36:20');

-- --------------------------------------------------------

--
-- Table structure for table `cp_roles`
--

CREATE TABLE `cp_roles` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_roles`
--

INSERT INTO `cp_roles` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Administrador', 'Acceso completo a la plataforma.', '2026-09-16 22:35:58', '2026-09-16 22:35:58');

-- --------------------------------------------------------

--
-- Table structure for table `cp_settings`
--

CREATE TABLE `cp_settings` (
  `id` int(10) UNSIGNED NOT NULL,
  `setting_key` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `setting_value` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_settings`
--

INSERT INTO `cp_settings` (`id`, `setting_key`, `setting_value`, `created_at`, `updated_at`) VALUES
(1, 'app.name', 'Colibrí Print México', '2026-09-16 22:35:58', '2026-09-16 22:35:58'),
(2, 'company.name', 'Colibrí Print México', '2026-09-16 22:35:58', '2026-09-16 22:35:58'),
(3, 'company.country', 'MX', '2026-09-16 22:35:58', '2026-09-19 15:42:53'),
(4, 'company.currency', 'MXN', '2026-09-16 22:35:58', '2026-09-16 22:35:58'),
(5, 'akaunting.database', 'colibrip_akau488', '2026-09-16 22:35:58', '2026-09-16 22:35:58'),
(6, 'setup.version', '1.0.0', '2026-09-16 22:35:58', '2026-09-16 22:35:58'),
(7, 'calculator.bastidor.ptr_m', '70.0000', '2026-09-17 00:11:27', '2026-09-17 00:30:36'),
(8, 'calculator.bastidor.canvas_m2', '50.0000', '2026-09-17 00:11:27', '2026-09-17 00:30:36'),
(9, 'calculator.bastidor.print_m2', '140.0000', '2026-09-17 00:11:27', '2026-09-17 00:30:36'),
(10, 'calculator.bastidor.labor_hour', '0.0000', '2026-09-17 00:11:27', '2026-09-17 00:30:36'),
(11, 'calculator.bastidor.waste_pct', '10.0000', '2026-09-17 00:11:27', '2026-09-17 00:30:36'),
(12, 'calculator.bastidor.margin_pct', '35.0000', '2026-09-17 00:11:27', '2026-09-17 00:30:36'),
(13, 'calculator.cnc.material_m2', '450.0000', '2026-09-17 00:11:27', '2026-09-17 00:30:36'),
(14, 'calculator.cnc.machine_hour', '250.0000', '2026-09-17 00:11:27', '2026-09-17 00:30:36'),
(15, 'calculator.cnc.labor_hour', '120.0000', '2026-09-17 00:11:27', '2026-09-17 00:30:36'),
(16, 'calculator.cnc.consumption_pct', '10.0000', '2026-09-17 00:11:27', '2026-09-17 00:30:36'),
(17, 'calculator.cnc.margin_pct', '35.0000', '2026-09-17 00:11:27', '2026-09-17 00:30:36'),
(40, 'company.legal_name', 'Colibrí Print México', '2026-09-17 11:40:28', '2026-09-19 15:42:53'),
(41, 'company.trade_name', 'Colibrí Print', '2026-09-17 11:40:28', '2026-09-19 15:42:53'),
(42, 'company.rfc', 'BUAE8208274R5', '2026-09-17 11:40:28', '2026-09-19 15:42:53'),
(43, 'company.tax_regime', 'Régimen Simplificado de Confianza', '2026-09-17 11:40:28', '2026-09-19 15:42:53'),
(44, 'company.address', 'Calle Alemania 87', '2026-09-17 11:40:28', '2026-09-19 15:42:53'),
(45, 'company.neighborhood', 'LOMA LINDA', '2026-09-17 11:40:28', '2026-09-19 15:42:53'),
(46, 'company.city', 'HIDALGO DEL PARRAL', '2026-09-17 11:40:28', '2026-09-19 15:42:53'),
(47, 'company.state', 'CHIHUAHUA', '2026-09-17 11:40:28', '2026-09-19 15:42:53'),
(48, 'company.postal_code', '33820', '2026-09-17 11:40:28', '2026-09-19 15:42:53'),
(50, 'company.phone', '6271074512', '2026-09-17 11:40:28', '2026-09-19 15:42:53'),
(51, 'company.email', 'ventas@colibriprint.com.mx', '2026-09-17 11:40:28', '2026-09-19 15:42:53'),
(52, 'company.website', 'https://colibriprint.com.mx', '2026-09-17 11:40:28', '2026-09-19 15:42:53'),
(53, 'company.logo_path', '/assets/img/company/logo-20260919150648-7ed8a8e2.png', '2026-09-17 11:40:28', '2026-09-19 15:42:53'),
(54, 'company.quote_footer', 'Este documento es una cotización comercial y no sustituye un comprobante fiscal digital (CFDI).', '2026-09-17 11:40:28', '2026-09-19 15:42:53'),
(55, 'company.payment_info', '012162004867143744\r\n BANCOMER\r\n\r\nErika Elizabeth Bustillos Aguirre \r\nColibrí Print México \r\nC. Alemania #87\r\n Col. Loma Linda\r\n\r\nEn el concepto  poner su nombre', '2026-09-17 11:40:28', '2026-09-19 15:42:53'),
(56, 'analytics.ga4_measurement_id', '', '2026-09-19 08:06:31', '2026-09-19 08:06:31'),
(57, 'facebook.enabled', '1', '2026-09-19 10:28:46', '2026-09-25 23:42:01'),
(58, 'facebook.auto_publish', '1', '2026-09-19 10:28:46', '2026-09-25 23:42:01'),
(59, 'facebook.page_id', '667900884988501', '2026-09-19 10:28:46', '2026-09-25 23:42:01'),
(60, 'facebook.page_access_token', '5aafdc902e5317173bea0fc62c1cec76', '2026-09-19 10:28:46', '2026-09-25 23:42:01'),
(61, 'facebook.graph_version', 'v26.0', '2026-09-19 10:28:46', '2026-09-25 23:42:01'),
(62, 'facebook.public_base_url', 'https://colibriprint.com.mx', '2026-09-19 10:28:46', '2026-09-25 23:42:01'),
(155, 'tiktok.enabled', '0', '2026-09-20 23:11:32', '2026-09-20 23:30:19'),
(156, 'tiktok.client_key', 'sbawjd2mfh91nif35r', '2026-09-20 23:11:32', '2026-09-20 23:30:19'),
(157, 'tiktok.client_secret', 'K25rRkxBdQwTd77eQhoQ4XppgNiionF8', '2026-09-20 23:11:32', '2026-09-20 23:30:19'),
(158, 'tiktok.redirect_uri', 'https://colibriprint.com.mx/api/tiktok/callback.php', '2026-09-20 23:11:32', '2026-09-20 23:30:19'),
(159, 'tiktok.scopes', 'user.info.basic', '2026-09-20 23:11:32', '2026-09-20 23:30:19'),
(160, 'tiktok.access_token', '', '2026-09-20 23:11:32', '2026-09-20 23:11:32'),
(161, 'tiktok.refresh_token', '', '2026-09-20 23:11:32', '2026-09-20 23:11:32'),
(162, 'tiktok.open_id', '', '2026-09-20 23:11:32', '2026-09-20 23:11:32'),
(163, 'tiktok.username', '', '2026-09-20 23:11:32', '2026-09-20 23:11:32'),
(164, 'tiktok.display_name', '', '2026-09-20 23:11:32', '2026-09-20 23:11:32'),
(165, 'tiktok.avatar_url', '', '2026-09-20 23:11:32', '2026-09-20 23:11:32'),
(166, 'tiktok.token_expires_at', '', '2026-09-20 23:11:32', '2026-09-20 23:11:32'),
(167, 'tiktok.refresh_token_expires_at', '', '2026-09-20 23:11:32', '2026-09-20 23:11:32');

-- --------------------------------------------------------

--
-- Table structure for table `cp_shipping_methods`
--

CREATE TABLE `cp_shipping_methods` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(15,2) NOT NULL DEFAULT '0.00',
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cp_shipping_rules`
--

CREATE TABLE `cp_shipping_rules` (
  `id` int(10) UNSIGNED NOT NULL,
  `shipping_method_id` int(10) UNSIGNED NOT NULL,
  `rule_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'flat',
  `min_subtotal` decimal(15,2) DEFAULT NULL,
  `max_subtotal` decimal(15,2) DEFAULT NULL,
  `amount` decimal(15,2) NOT NULL DEFAULT '0.00',
  `enabled` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cp_tiktok_posts`
--

CREATE TABLE `cp_tiktok_posts` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `video_path` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `video_url` varchar(1200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title` text COLLATE utf8mb4_unicode_ci,
  `privacy_level` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `publish_mode` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'direct',
  `publish_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `post_id` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `error_message` text COLLATE utf8mb4_unicode_ci,
  `response_json` longtext COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `published_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cp_tracking_tokens`
--

CREATE TABLE `cp_tracking_tokens` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `token` char(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL,
  `last_access_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_tracking_tokens`
--

INSERT INTO `cp_tracking_tokens` (`id`, `order_id`, `token`, `active`, `created_at`, `last_access_at`) VALUES
(10, 11, '8c82f32105ad34cdb146c8d72f8c24b5580136f93b32b9829de1a347e42bd293', 1, '2026-09-19 10:58:01', '2026-09-23 08:34:24'),
(11, 12, 'd3571b9e61fe1eb79ccac3c40530eb24c82b9d1a7859a203a7e0fc5e2cc4f895', 1, '2026-09-19 11:06:45', '2026-09-25 04:19:12'),
(12, 13, '2424ce9cb4dc8c820dd79ba5c289618f457db728cd814a1af26c3aee57106039', 1, '2026-09-19 11:15:57', '2026-09-22 09:10:17'),
(13, 14, 'e1aaa7201cafc780182f1694b6de836ad4e3d91029b9ef99d9c68cd03fc34fa4', 1, '2026-09-19 11:41:28', '2026-09-22 09:40:01'),
(14, 15, '0f4102ddb74192ddb833baa8011fcd497cdee24976197d17005c963fe8a60b2f', 1, '2026-09-19 17:07:32', '2026-09-21 10:08:43'),
(15, 16, '04e767cdf16a6c1c32af4982c1b8b435ccbe5527e3ef0e2b5df0e2ae4d486887', 1, '2026-09-19 17:17:35', '2026-09-24 22:25:07'),
(16, 17, 'ecf23513e472f8100ff636f246978ea6e45c1ce679aa8ef3d5a9448092b298c3', 1, '2026-09-19 17:26:26', '2026-09-26 10:32:03'),
(17, 18, 'a611409ce4547822fdb2f55c748e1ac8df1c0fe5cfe1155208d32d95cb77cb06', 1, '2026-09-19 18:35:39', '2026-09-23 09:17:58'),
(18, 19, '830d1c4d133caf46207fa80832cdb8c4b143609fd232332291598787e5bb2b29', 1, '2026-09-20 00:12:06', NULL),
(19, 20, '3a6a5b5b8d7727b2d549b75b2bbfb545394e8c5252f09296724abf5ecd04a274', 1, '2026-09-20 00:23:51', '2026-09-20 00:37:21'),
(20, 21, '7deea835a5e29ef2b181616405cfc9cc4f07bdb77e8c58ba05f454e0e2e55bea', 1, '2026-09-22 08:38:51', '2026-09-26 16:32:15'),
(21, 22, '2246dd4dbafcc76b294c72d7d53c8adf4f986149b4f230a5716f4add191272a3', 1, '2026-09-22 10:38:56', '2026-09-23 09:24:11'),
(22, 23, '18b4398fa9980d1123e5caf5d0d622d812644fd6f6893ae4554c149a2c34b667', 1, '2026-09-22 10:54:16', '2026-09-23 09:23:29'),
(23, 24, '7d76622dd78293c669b62efbf22de2f422300f125505064866331c3091645ddd', 1, '2026-09-22 14:19:56', '2026-09-24 18:35:04'),
(24, 25, '39d5c22caef2c1b33051d8e8460dd4b2f332c73e3ae1822349255a2f4a46ae86', 1, '2026-09-22 20:46:46', '2026-09-23 01:57:52'),
(25, 26, '515cdf55445a28732169f6336a37c15b2b216610cfe8c1e0e10c308fbb345f35', 1, '2026-09-23 09:07:11', '2026-09-25 12:03:29'),
(26, 27, 'd55c92443a92698b7bfa39228936ce8bf37d3df47e5a8a3f2371af2b7de9dfd4', 1, '2026-09-23 09:58:04', '2026-09-25 18:12:44'),
(27, 28, '13b26f22bc1b66dfa1e4932537d71451bc6d7b615a9012b7591767b59d0af3f5', 1, '2026-09-23 10:46:01', '2026-09-24 20:32:05'),
(28, 29, '01f16c4de2a8bfd4acc2ed53d41f42cc58f306078223b3ca50181f1145b6eb76', 1, '2026-09-23 11:08:54', '2026-09-25 15:05:43'),
(29, 30, '972066b330ab9711374d92a87d026bb03c3e1fa622767cab4255b818693a5e19', 1, '2026-09-23 20:22:53', '2026-09-25 23:21:19'),
(30, 31, 'd663b7d962c6fa8addf2a4f860ddab715e03cef353562a7a6ce13af0cf0dd269', 1, '2026-09-24 10:00:08', '2026-09-25 21:11:08'),
(31, 32, '9f111790d54b2be5ef49f3a752437e854500e209da46760eaf9a907368fd3004', 1, '2026-09-24 12:36:12', '2026-09-26 12:13:01'),
(32, 33, '0f501e36088ee9a1df4608a86e31bc39504939acb65ebd3363952fb9a6d9888f', 1, '2026-09-24 17:37:36', '2026-09-25 14:56:17'),
(33, 34, '05650f98f918b4982444e91bd5e217df6a3c45b16f60d649379da216ab354cf3', 1, '2026-09-24 18:28:31', '2026-09-25 09:42:38'),
(34, 35, '3b7b8af3ef711f0b5fb4e5bf7094486b3fd561c9a6323389582c8ac210720ab0', 1, '2026-09-25 04:51:18', '2026-09-25 07:41:21'),
(35, 36, '463c69368d8e664ba66e45ff5a8f9768fb79fcb4fa1a7b86a828c3cb2b7bbfc9', 1, '2026-09-25 07:45:03', '2026-09-25 09:42:00'),
(36, 37, '281b4101965960fe1d09112eaad6407b2db67a58d3922a076a145c2a25dbc121', 1, '2026-09-25 08:15:26', '2026-09-25 08:32:19'),
(37, 38, '7142ff66acb07a106eb75246e3a0ed14e1e170cf7bedbd100756a6bbc89960f6', 1, '2026-09-25 10:22:29', '2026-09-25 10:46:46'),
(38, 39, '699baf6b7c6394592529b12f469e66a5f86a51bffc6f2691fa85545154b29088', 1, '2026-09-25 20:37:16', '2026-09-26 16:54:31');

-- --------------------------------------------------------

--
-- Table structure for table `cp_users`
--

CREATE TABLE `cp_users` (
  `id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `last_login_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_users`
--

INSERT INTO `cp_users` (`id`, `role_id`, `name`, `email`, `password_hash`, `enabled`, `last_login_at`, `created_at`, `updated_at`) VALUES
(1, 1, 'Administrador', 'ventas@colibriprint.com.mx', '$2y$10$exXwwyuOSJwdgJYWHR3tDO.C.BtOprMV5iLIhonCJsWI4AZGgLqk2', 1, '2026-09-26 20:52:18', '2026-09-16 22:35:58', '2026-09-16 22:35:58');

-- --------------------------------------------------------

--
-- Table structure for table `cp_web_checkout_sessions`
--

CREATE TABLE `cp_web_checkout_sessions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `session_token` char(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_id` int(10) UNSIGNED DEFAULT NULL,
  `quote_id` int(10) UNSIGNED DEFAULT NULL,
  `status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'started',
  `customer_name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `city` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zip_code` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT 'MX',
  `delivery_method` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `cart_json` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `currency` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MXN',
  `subtotal` decimal(15,2) NOT NULL DEFAULT '0.00',
  `shipping` decimal(15,2) NOT NULL DEFAULT '0.00',
  `total` decimal(15,2) NOT NULL DEFAULT '0.00',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cp_web_quote_files`
--

CREATE TABLE `cp_web_quote_files` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `request_id` bigint(20) UNSIGNED NOT NULL,
  `original_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `stored_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mime_type` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `extension` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `size_bytes` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `sha256` char(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `source` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public',
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quote_id` bigint(20) UNSIGNED DEFAULT NULL,
  `order_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `page_count` int(10) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_web_quote_files`
--

INSERT INTO `cp_web_quote_files` (`id`, `request_id`, `original_name`, `stored_path`, `mime_type`, `extension`, `size_bytes`, `sha256`, `source`, `description`, `quote_id`, `order_id`, `created_at`, `page_count`) VALUES
(1, 4, 'ChatGPT Image Aug 12, 2026, 11_51_30 AM.png', '/uploads/cotizador/db4c2eb77e1028eeeff7a57fbe19dc4f3e9e84f2a4d4401abe1ca82419e982df/8a10bd2ee6bb538ba21c71de109e5826.png', 'image/png', 'png', 865581, 'bd6c3534c3578c81f4de2f65eee01f7b6bac566a1f20d0c271d26f3dfb816317', 'public', NULL, NULL, NULL, '2026-09-19 22:15:38', 1),
(2, 5, 'biberon.png', '/uploads/cotizador/7e8000eaa8e08ffd71645a6b4d4b05466c23a70d3915927f511dfeec2fa08bab/2dae790fee1e18797993a4f3cd7baaf0.png', 'image/png', 'png', 1527708, 'cfa787b5728a8cf4b57987d91f5d2a41429119140d3b8cd730c207a1688c1dbe', 'public', NULL, NULL, NULL, '2026-09-19 22:50:51', 1),
(3, 6, 'ChatGPT Image Aug 12, 2026, 11_51_30 AM.png', '/uploads/cotizador/dc16a9fa614f0081ce52617ea2e2eec6abee67c5f6d9e9c9ce66aa67c5a4ce89/f3528e00ad7ef942d24613dfb69c4439.png', 'image/png', 'png', 865581, 'bd6c3534c3578c81f4de2f65eee01f7b6bac566a1f20d0c271d26f3dfb816317', 'public', NULL, NULL, NULL, '2026-09-20 00:05:17', 1),
(4, 7, 'Logo 2027.png', '/uploads/cotizador/a378b7984cc574c69e83c15d69bb71d687063bf794d6b9f0d96df7712cb0c4d6/dc8c622bcedc99bca185c706a292f25f.png', 'image/png', 'png', 1222567, '9dccdc6bdbaa3c9c84bcde4280249629f42032dc2144b11c3804199c2899b506', 'public', NULL, NULL, NULL, '2026-09-20 00:21:07', 1),
(5, 8, 'CASA HABITACION (60 x 90 cm)_20260925_084827_0000.pdf', 'uploads/print_requests/8/6131fdc5f4b1169a_CASA_HABITACION__60_x_90_cm__20260925_084827_0000.pdf', 'application/pdf', 'pdf', 2922077, '77d709625dbdb928be3d5b313bc4a9fca542c4ccf3b93c2dd605cbc6fd9465c6', 'public', NULL, NULL, NULL, '2026-09-26 04:00:34', 1),
(13, 17, 'PRESENTACION.pdf', '/uploads/cotizador/impresiones/17/0e554cfa8a9e12ae_PRESENTACION.pdf', 'application/pdf', 'pdf', 18140165, '009ddffc56e5ecfd87db92412860c052a6a3091ef597ec2adcfca771123984d3', 'public', NULL, NULL, NULL, '2026-09-26 17:07:58', 1),
(14, 18, 'vale_salida_almacen_maclean_logo_oficial.pdf', '/uploads/cotizador/impresiones/18/0301d00af6125c8a_vale_salida_almacen_maclean_logo_oficial.pdf', 'application/pdf', 'pdf', 85973, '7ae575585b5e12748809abd241c83f0c499a06bbd51759c14d6b0c8c29c9427e', 'public', NULL, NULL, NULL, '2026-09-26 17:08:15', 1),
(15, 19, 'CASA_HABITACION_60_x_90_cm__20260925_084827_0000.pdf', '/uploads/cotizador/impresiones/19/02401f8f1f9f034a_CASA_HABITACION_60_x_90_cm__20260925_084827_0000.pdf', 'application/pdf', 'pdf', 2922077, '77d709625dbdb928be3d5b313bc4a9fca542c4ccf3b93c2dd605cbc6fd9465c6', 'public', NULL, NULL, NULL, '2026-09-26 17:10:04', 1),
(16, 20, 'Concepto_plano.pdf', '/uploads/cotizador/impresiones/20/c38c8951371988f5_Concepto_plano.pdf', 'application/pdf', 'pdf', 10971049, '1309e8cbee0a15b842bb13caad5f35084bbcedb66a1841f7b17b9ab9d38e373b', 'public', NULL, NULL, NULL, '2026-09-26 19:25:44', 1);

-- --------------------------------------------------------

--
-- Table structure for table `cp_web_quote_notifications`
--

CREATE TABLE `cp_web_quote_notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `request_id` bigint(20) UNSIGNED NOT NULL,
  `event_type` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'new_request',
  `title` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `read_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_web_quote_notifications`
--

INSERT INTO `cp_web_quote_notifications` (`id`, `request_id`, `event_type`, `title`, `message`, `read_at`, `created_at`) VALUES
(1, 3, 'new_request', 'CPQ-000003 · denisse', 'Bordado · 6275292647', NULL, '2026-09-19 20:49:44'),
(2, 4, 'new_request', 'CPQ-000004 · a', 'Artículos promocionales · 6271475889 · 1 archivo(s)', '2026-09-19 22:16:33', '2026-09-19 22:15:38'),
(3, 5, 'new_request', 'CPQ-000005 · juanita', 'Artículos promocionales · 6271471155 · 1 archivo(s)', NULL, '2026-09-19 22:50:51'),
(4, 6, 'new_request', 'CPQ-000006 · PANCHITO', 'Vinil de corte · 6271074512 · 1 archivo(s)', NULL, '2026-09-20 00:05:17'),
(5, 7, 'new_request', 'CPQ-000007 · MIGUEL', 'Grabado láser · 6271074512 · 1 archivo(s)', NULL, '2026-09-20 00:21:07'),
(6, 17, 'new_request', 'CPQ-000017 · ERIKA BUSTILLOS', 'Impresión · +526271074512 · 1 archivo(s) · $80.00 MXN', NULL, '2026-09-26 17:07:58'),
(7, 18, 'new_request', 'CPQ-000018 · ERIKA BUSTILLOS', 'Impresión · +526271074512 · 1 archivo(s) · $160.00 MXN', NULL, '2026-09-26 17:08:15'),
(8, 19, 'new_request', 'CPQ-000019 · ERIKA BUSTILLOS', 'Impresión · +526271074512 · 1 archivo(s) · $160.00 MXN', NULL, '2026-09-26 17:10:04'),
(9, 20, 'new_request', 'CPQ-000020 · ERIKA BUSTILLOS', 'Impresión · +526271074512 · 1 archivo(s) · $80.00 MXN', NULL, '2026-09-26 19:25:44');

-- --------------------------------------------------------

--
-- Table structure for table `cp_web_quote_requests`
--

CREATE TABLE `cp_web_quote_requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `request_token` char(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_id` int(10) UNSIGNED DEFAULT NULL,
  `service_key` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `request_text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `desired_date` date DEFAULT NULL,
  `attachment_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'new',
  `converted_quote_id` int(10) UNSIGNED DEFAULT NULL,
  `converted_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_web_quote_requests`
--

INSERT INTO `cp_web_quote_requests` (`id`, `request_token`, `customer_id`, `service_key`, `customer_name`, `email`, `phone`, `request_text`, `quantity`, `desired_date`, `attachment_name`, `status`, `converted_quote_id`, `converted_at`, `created_at`, `updated_at`) VALUES
(6, 'dc16a9fa614f0081ce52617ea2e2eec6abee67c5f6d9e9c9ce66aa67c5a4ce89', NULL, 'vinil', 'PANCHITO', NULL, '6271074512', 'Servicio: Vinil de corte\nquantity: 1\nsurface: Vehículo\nsize: 20x20cm\ncolor: negro\nDiseño: Tengo el diseño final\nAplicación/instalación: No lo sé todavía\nEntrega: Entrega local\nFecha solicitada: 2026-09-21\nNotas: lo quiero para el tanque de una moto\nArchivos recibidos: 1\n\n[CPQ_JSON]\n{\"version\":3,\"service\":{\"key\":\"vinil\",\"name\":\"Vinil de corte\"},\"details\":{\"quantity\":\"1\",\"surface\":\"Vehículo\",\"size\":\"20x20cm\",\"color\":\"negro\"},\"production\":{\"design_status\":\"Tengo el diseño final\",\"application\":\"No lo sé todavía\",\"notes\":\"lo quiero para el tanque de una moto\"},\"delivery\":{\"method\":\"Entrega local\",\"desired_date\":\"2026-09-21\"},\"attachments\":[{\"original_name\":\"ChatGPT Image Aug 12, 2026, 11_51_30 AM.png\",\"relative_path\":\"/uploads/cotizador/dc16a9fa614f0081ce52617ea2e2eec6abee67c5f6d9e9c9ce66aa67c5a4ce89/f3528e00ad7ef942d24613dfb69c4439.png\",\"mime\":\"image/png\",\"size\":865581,\"extension\":\"png\",\"sha256\":\"bd6c3534c3578c81f4de2f65eee01f7b6bac566a1f20d0c271d26f3dfb816317\"}],\"attachment\":{\"original_name\":\"ChatGPT Image Aug 12, 2026, 11_51_30 AM.png\",\"relative_path\":\"/uploads/cotizador/dc16a9fa614f0081ce52617ea2e2eec6abee67c5f6d9e9c9ce66aa67c5a4ce89/f3528e00ad7ef942d24613dfb69c4439.png\",\"mime\":\"image/png\",\"size\":865581,\"extension\":\"png\",\"sha256\":\"bd6c3534c3578c81f4de2f65eee01f7b6bac566a1f20d0c271d26f3dfb816317\"},\"submitted_at\":\"2026-09-20T00:05:17-06:00\",\"source\":\"public_quote_wizard\",\"ip_hash\":\"6e2f47d9c108c37106dd6710e224743a86073951dc4827e3c29f8e7bb6e662c9\"}', '1', '2026-09-21', 'ChatGPT Image Aug 12, 2026, 11_51_30 AM.png', 'reviewing', 28, '2026-09-20 00:07:09', '2026-09-20 00:05:17', '2026-09-20 00:07:09'),
(7, 'a378b7984cc574c69e83c15d69bb71d687063bf794d6b9f0d96df7712cb0c4d6', NULL, 'laser', 'MIGUEL', NULL, '6271074512', 'Servicio: Grabado láser\nquantity: 1\nmaterial: YETI\nsize: \ndetail: LOGO\nDiseño: Solo tengo la idea\nAplicación/instalación: No lo sé todavía\nEntrega: Entrega local\nFecha solicitada: 2026-09-26\nNotas: QUIERO GRABAR UN LOGO EN EL YETI\nArchivos recibidos: 1\n\n[CPQ_JSON]\n{\"version\":3,\"service\":{\"key\":\"laser\",\"name\":\"Grabado láser\"},\"details\":{\"quantity\":\"1\",\"material\":\"YETI\",\"size\":\"\",\"detail\":\"LOGO\"},\"production\":{\"design_status\":\"Solo tengo la idea\",\"application\":\"No lo sé todavía\",\"notes\":\"QUIERO GRABAR UN LOGO EN EL YETI\"},\"delivery\":{\"method\":\"Entrega local\",\"desired_date\":\"2026-09-26\"},\"attachments\":[{\"original_name\":\"Logo 2027.png\",\"relative_path\":\"/uploads/cotizador/a378b7984cc574c69e83c15d69bb71d687063bf794d6b9f0d96df7712cb0c4d6/dc8c622bcedc99bca185c706a292f25f.png\",\"mime\":\"image/png\",\"size\":1222567,\"extension\":\"png\",\"sha256\":\"9dccdc6bdbaa3c9c84bcde4280249629f42032dc2144b11c3804199c2899b506\"}],\"attachment\":{\"original_name\":\"Logo 2027.png\",\"relative_path\":\"/uploads/cotizador/a378b7984cc574c69e83c15d69bb71d687063bf794d6b9f0d96df7712cb0c4d6/dc8c622bcedc99bca185c706a292f25f.png\",\"mime\":\"image/png\",\"size\":1222567,\"extension\":\"png\",\"sha256\":\"9dccdc6bdbaa3c9c84bcde4280249629f42032dc2144b11c3804199c2899b506\"},\"submitted_at\":\"2026-09-20T00:21:07-06:00\",\"source\":\"public_quote_wizard\",\"ip_hash\":\"6e2f47d9c108c37106dd6710e224743a86073951dc4827e3c29f8e7bb6e662c9\"}', '1', '2026-09-26', 'Logo 2027.png', 'closed', 29, '2026-09-20 00:21:58', '2026-09-20 00:21:07', '2026-09-20 00:38:30'),
(8, '2c6d70ef7639b69e454b9315877b0b9473cb7672d98d043d7dadb38dfd4d3d47', 1265, 'impresion', 'ERIKA BUSTILLOS', 'wmaster1ro@gmail.com', '6271074512', 'Solicitud de impresión desde formulario público', '1', NULL, NULL, 'new', NULL, NULL, '2026-09-26 04:00:34', '2026-09-26 04:00:34'),
(17, '9cf95d864da38189d1868f71d651299f6fca9c7006b9961e345e2d3c5f282931', 507, 'impresion', 'ERIKA BUSTILLOS', 'wmaster1ro@gmail.com', '+526271074512', 'Solicitud de impresión desde la página web\n{\"version\":2,\"service\":\"impresion\",\"items\":[{\"file\":\"PRESENTACION.pdf\",\"pages\":1,\"copies\":1,\"size\":\"60 × 90 cm\",\"material\":\"Papel bond\",\"finish\":\"Sin acabado\",\"color_mode\":\"color\",\"unit_price\":80,\"subtotal\":80}],\"total\":80}', '1', NULL, 'PRESENTACION.pdf', 'new', NULL, NULL, '2026-09-26 17:07:58', '2026-09-26 17:07:58'),
(18, '8ebd0b5b4634648f28cd47caca6b6c869f15772fef58777791efa36ab29ed8d5', 507, 'impresion', 'ERIKA BUSTILLOS', 'wmaster1ro@gmail.com', '+526271074512', 'Solicitud de impresión desde la página web\n{\"version\":2,\"service\":\"impresion\",\"items\":[{\"file\":\"vale_salida_almacen_maclean_logo_oficial.pdf\",\"pages\":1,\"copies\":2,\"size\":\"60 × 90 cm\",\"material\":\"Papel bond\",\"finish\":\"Sin acabado\",\"color_mode\":\"color\",\"unit_price\":80,\"subtotal\":160}],\"total\":160}', '1', NULL, 'vale_salida_almacen_maclean_logo_oficial.pdf', 'new', NULL, NULL, '2026-09-26 17:08:15', '2026-09-26 17:08:15'),
(19, '5bf70476b0f4890f973e03c63c21b5009db8f046c6e648a838c9fa564f1fba20', 507, 'impresion', 'ERIKA BUSTILLOS', 'wmaster1ro@gmail.com', '+526271074512', 'Solicitud de impresión desde la página web\n{\"version\":2,\"service\":\"impresion\",\"items\":[{\"file\":\"CASA_HABITACION_60_x_90_cm__20260925_084827_0000.pdf\",\"pages\":1,\"copies\":2,\"size\":\"60 × 90 cm\",\"material\":\"Papel bond\",\"finish\":\"Sin acabado\",\"color_mode\":\"color\",\"unit_price\":80,\"subtotal\":160}],\"total\":160}', '1', NULL, 'CASA_HABITACION_60_x_90_cm__20260925_084827_0000.pdf', 'new', NULL, NULL, '2026-09-26 17:10:04', '2026-09-26 17:10:04'),
(20, '435b1463722f2f2abb7cf7f1f639b3c1f245edb22dc35a8dd2327489e1a90600', 507, 'impresion', 'ERIKA BUSTILLOS', 'wmaster1ro@gmail.com', '+526271074512', 'Solicitud de impresión desde la página web\n{\"version\":2,\"service\":\"impresion\",\"items\":[{\"file\":\"Concepto_plano.pdf\",\"pages\":1,\"copies\":1,\"size\":\"60 × 90 cm\",\"material\":\"Papel bond\",\"finish\":\"Sin acabado\",\"color_mode\":\"color\",\"unit_price\":80,\"subtotal\":80}],\"total\":80}', '1', NULL, 'Concepto_plano.pdf', 'new', NULL, NULL, '2026-09-26 19:25:44', '2026-09-26 19:25:44');

-- --------------------------------------------------------

--
-- Table structure for table `cp_whatsapp_chats`
--

CREATE TABLE `cp_whatsapp_chats` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `chat_id` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_name` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_id` int(10) UNSIGNED DEFAULT NULL,
  `status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'open',
  `assigned_user_id` int(10) UNSIGNED DEFAULT NULL,
  `last_message` text COLLATE utf8mb4_unicode_ci,
  `last_message_at` datetime DEFAULT NULL,
  `unread_count` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_whatsapp_chats`
--

INSERT INTO `cp_whatsapp_chats` (`id`, `chat_id`, `phone`, `contact_name`, `customer_id`, `status`, `assigned_user_id`, `last_message`, `last_message_at`, `unread_count`, `created_at`, `updated_at`) VALUES
(1, '13135555657@s.whatsapp.net', '13135555657', 'Sender', NULL, 'open', NULL, '...', '2024-09-10 03:00:05', 1, '2026-09-23 21:52:28', '2026-09-23 21:52:28'),
(2, '120363369135083660@g.us', '5216271470053', 'Colibrí Print México', NULL, 'open', NULL, NULL, '2026-09-23 22:52:05', 0, '2026-09-23 22:35:49', '2026-09-23 22:52:06'),
(3, '5215610256460@s.whatsapp.net', '5215610256460', 'J', NULL, 'open', NULL, NULL, '2026-09-23 22:40:04', 1, '2026-09-23 22:40:06', '2026-09-23 22:40:06'),
(4, '5216271052926@s.whatsapp.net', '5216271052926', 'Mitzy Anahí G.', NULL, 'open', NULL, 'Ei las cucharas negras desechables te las llevaste', '2026-09-23 23:07:00', 2, '2026-09-23 22:44:53', '2026-09-23 23:07:02'),
(5, '5216271074512@s.whatsapp.net', '5216271074512', 'Colibrí Print', NULL, 'open', NULL, '…', '2026-09-23 23:40:45', 3, '2026-09-23 23:28:13', '2026-09-23 23:28:13'),
(6, '5216271112122@s.whatsapp.net', '5216271112122', '.', NULL, 'open', NULL, '…', '2026-09-23 23:39:49', 1, '2026-09-23 23:39:51', '2026-09-23 23:39:51');

-- --------------------------------------------------------

--
-- Table structure for table `cp_whatsapp_log`
--

CREATE TABLE `cp_whatsapp_log` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `template_key` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order_id` int(10) UNSIGNED DEFAULT NULL,
  `quote_id` int(10) UNSIGNED DEFAULT NULL,
  `customer_id` int(10) UNSIGNED DEFAULT NULL,
  `phone` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` text COLLATE utf8mb4_unicode_ci,
  `status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'prepared',
  `prepared_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_whatsapp_log`
--

INSERT INTO `cp_whatsapp_log` (`id`, `template_key`, `order_id`, `quote_id`, `customer_id`, `phone`, `message`, `status`, `prepared_by`, `created_at`) VALUES
(30, 'promotion_offer', NULL, NULL, NULL, '', '✨ OFERTA: Playera tipo polo bordada | OFERTA DEL MES\n\n💥 Precio promocional: $200.00\n🏷️ Precio normal: $290.00\n🎯 Descuento: 31.03 %\n📅 Vigencia: 17/09/2026 al 19/09/2026\n📦 Disponibilidad: 11\n\n🌐 https://colibriprint.com.mx\n\nColibrí Print', 'prepared', 1, '2026-09-18 20:20:06'),
(31, 'design_ready', 12, NULL, 1207, '526271120213', 'Hola Jazmin Ortega 👋\n\n🎨 El diseño de tu pedido OS-2026-00002 ya está listo para revisión.\n\nPuedes consultar el avance de tu pedido aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=d3571b9e61fe1eb79ccac3c40530eb24c82b9d1a7859a203a7e0fc5e2cc4f895\n\nSi necesitas algún ajuste, respóndenos por este mismo medio.\n\nColibrí Print', 'prepared', 1, '2026-09-19 16:35:12'),
(32, 'order_confirmed', 14, NULL, 640, '526271152554', 'Hola Dra. Jaqueline Chávez León 👋\n\nTu pedido OS-2026-00004 ya fue registrado y comenzamos a trabajar en él.\n\n💰 Total de la orden: $620.00\n📅 Fecha compromiso: 20/09/2026\n\n🔎 Consulta el avance de tu pedido:\nhttps://colibriprint.com.mx/seguimiento.php?t=e1aaa7201cafc780182f1694b6de836ad4e3d91029b9ef99d9c68cd03fc34fa4\n\nGracias por confiar en Colibrí Print.', 'prepared', 1, '2026-09-19 16:38:12'),
(33, 'order_confirmed', 14, NULL, 640, '526271152554', 'Hola Dra. Jaqueline Chávez León 👋\n\nTu pedido OS-2026-00004 ya fue registrado y comenzamos a trabajar en él.\n\n💰 Total de la orden: $620.00\n📅 Fecha compromiso: 20/09/2026\n\n🔎 Consulta el avance de tu pedido:\nhttps://colibriprint.com.mx/seguimiento.php?t=e1aaa7201cafc780182f1694b6de836ad4e3d91029b9ef99d9c68cd03fc34fa4\n\nGracias por confiar en Colibrí Print.', 'prepared', 1, '2026-09-19 16:42:04'),
(34, 'design_ready', 14, NULL, 640, '526271152554', 'Hola Dra. Jaqueline Chávez León 👋\n\n🎨 El diseño de tu pedido OS-2026-00004 ya está listo para revisión.\n\nPuedes consultar el avance de tu pedido aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=e1aaa7201cafc780182f1694b6de836ad4e3d91029b9ef99d9c68cd03fc34fa4\n\nSi necesitas algún ajuste, respóndenos por este mismo medio.\n\nColibrí Print', 'prepared', 1, '2026-09-19 16:42:26'),
(35, 'promotion_offer', NULL, NULL, NULL, '', '✨ OFERTA: Taza Personalizada de Oferta\n\n☕🔥 **¡TU TAZA, TU ESTILO!** 🔥☕\r\n\r\n¿Quieres una taza que sea realmente tuya? 😍\r\nEn **Colibrí Print** personalizamos tus tazas con:\r\n\r\n❤️ Fotos ✨ Nombres 😂 Frases 🎨 Diseños 🏢 Logos para negocios\r\n\r\n🎁 **Ideal para regalar o consentirte.**\r\n📲 **WhatsApp: 627 147 0053**\r\n📍 **Colibrí Print | Personalizamos tus ideas**\r\n👉 Mándanos tu diseño o dinos qué quieres y **te cotizamos rápido.**\r\n#TazasPersonalizadas #TazasPersonalizadasMexico #RegalosPersonalizados #ColibriPrint #TazasConFoto\n\n💥 Precio promocional: $50.00\n🏷️ Precio normal: $100.00\n🎯 Descuento: 50.00 %\n📅 Vigencia: 19/09/2026 al 21/09/2026\n📦 Disponibilidad: 15\n\n🌐 https://colibriprint.com.mx\n\nColibrí Print', 'prepared', 1, '2026-09-19 22:05:26'),
(36, 'in_production', 24, NULL, 908, '526271499450', 'Hola Samuel 👋\n\n🔧 Tu pedido OS-2026-00014 ya se encuentra en producción. Nuestro equipo está trabajando en los detalles de tu trabajo.\n\n🔎 Consulta el avance aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=7d76622dd78293c669b62efbf22de2f422300f125505064866331c3091645ddd\n\nColibrí Print', 'prepared', 1, '2026-09-23 09:15:36'),
(37, 'in_production', 18, NULL, 340, '5214421390936', 'Hola MacLean Mèxico /  Eloy 👋\n\n🔧 Tu pedido OS-2026-00008 ya se encuentra en producción. Nuestro equipo está trabajando en los detalles de tu trabajo.\n\n🔎 Consulta el avance aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=a611409ce4547822fdb2f55c748e1ac8df1c0fe5cfe1155208d32d95cb77cb06\n\nColibrí Print', 'prepared', 1, '2026-09-23 09:17:02'),
(38, 'quality_review', 16, NULL, 544, '526563116402', 'Hola Industrial Minera México 👋\n\n✅ Tu pedido OS-2026-00006 está en revisión final de calidad antes de pasar a entrega.\n\n🔎 Consulta el avance aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=04e767cdf16a6c1c32af4982c1b8b435ccbe5527e3ef0e2b5df0e2ae4d486887\n\nTe avisaremos en cuanto esté listo.\n\nColibrí Print', 'prepared', 1, '2026-09-23 09:17:26'),
(39, 'quality_review', 16, NULL, 544, '526563116402', 'Hola Industrial Minera México 👋\n\n✅ Tu pedido OS-2026-00006 está en revisión final de calidad antes de pasar a entrega.\n\n🔎 Consulta el avance aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=04e767cdf16a6c1c32af4982c1b8b435ccbe5527e3ef0e2b5df0e2ae4d486887\n\nTe avisaremos en cuanto esté listo.\n\nColibrí Print', 'prepared', 1, '2026-09-23 09:18:11'),
(40, 'design_ready', 23, NULL, 1270, '526271426277', 'Hola Erika Escárcega 👋\n\n🎨 El diseño de tu pedido OS-2026-00013 ya está listo para revisión.\n\nPuedes consultar el avance de tu pedido aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=18b4398fa9980d1123e5caf5d0d622d812644fd6f6893ae4554c149a2c34b667\n\nSi necesitas algún ajuste, respóndenos por este mismo medio.\n\nColibrí Print', 'prepared', 1, '2026-09-23 09:19:22'),
(41, 'design_ready', 22, NULL, 1270, '526271426277', 'Hola Erika Escárcega 👋\n\n🎨 El diseño de tu pedido OS-2026-00012 ya está listo para revisión.\n\nPuedes consultar el avance de tu pedido aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=2246dd4dbafcc76b294c72d7d53c8adf4f986149b4f230a5716f4add191272a3\n\nSi necesitas algún ajuste, respóndenos por este mismo medio.\n\nColibrí Print', 'prepared', 1, '2026-09-23 09:20:23'),
(42, 'in_production', 26, NULL, 571, '526491043888', 'Hola Entidad de Limpieza y Mantenimiento 👋\n\n🔧 Tu pedido OS-2026-00016 ya se encuentra en producción. Nuestro equipo está trabajando en los detalles de tu trabajo.\n\n🔎 Consulta el avance aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=515cdf55445a28732169f6336a37c15b2b216610cfe8c1e0e10c308fbb345f35\n\nColibrí Print', 'prepared', 1, '2026-09-23 09:21:22'),
(43, 'in_production', 21, NULL, 763, '526271064807', 'Hola Karina salón de eventos Alexa 👋\n\n🔧 Tu pedido OS-2026-00011 ya se encuentra en producción. Nuestro equipo está trabajando en los detalles de tu trabajo.\n\n🔎 Consulta el avance aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=7deea835a5e29ef2b181616405cfc9cc4f07bdb77e8c58ba05f454e0e2e55bea\n\nColibrí Print', 'prepared', 1, '2026-09-23 09:22:31'),
(44, 'in_production', 27, NULL, 1204, '526491049222', 'Hola Mtra Alejandra 👋\n\n🔧 Tu pedido OS-2026-00017 ya se encuentra en producción. Nuestro equipo está trabajando en los detalles de tu trabajo.\n\n🔎 Consulta el avance aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=d55c92443a92698b7bfa39228936ce8bf37d3df47e5a8a3f2371af2b7de9dfd4\n\nColibrí Print', 'prepared', 1, '2026-09-23 10:07:55'),
(45, 'order_confirmed', 29, NULL, 1039, '526141734112', 'Hola GRUPO COMERCIAL BUJAIDAR 👋\n\nTu pedido OS-2026-00019 ya fue registrado y comenzamos a trabajar en él.\n\n💰 Total de la orden: $5,742.00\n📅 Fecha compromiso: 30/09/2026\n\n🔎 Consulta el avance de tu pedido:\nhttps://colibriprint.com.mx/seguimiento.php?t=01f16c4de2a8bfd4acc2ed53d41f42cc58f306078223b3ca50181f1145b6eb76\n\nGracias por confiar en Colibrí Print.', 'prepared', 1, '2026-09-23 17:44:28'),
(46, 'ready_delivery', 24, NULL, 908, '526271499450', 'Hola Samuel 👋\n\n🚚 ¡Tu pedido OS-2026-00014 ya está listo para entrega!\n\n📅 Fecha compromiso: 23/09/2026\n\n🔎 Consulta los detalles aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=7d76622dd78293c669b62efbf22de2f422300f125505064866331c3091645ddd\n\nGracias por confiar en Colibrí Print.', 'prepared', 1, '2026-09-23 18:16:01'),
(47, 'ready_delivery', 28, NULL, 1271, '526673607333', 'Hola Yaritzel 👋\n\n🚚 ¡Tu pedido OS-2026-00018 ya está listo para entrega!\n\n📅 Fecha compromiso: 24/09/2026\n\n🔎 Consulta los detalles aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=13b26f22bc1b66dfa1e4932537d71451bc6d7b615a9012b7591767b59d0af3f5\n\nGracias por confiar en Colibrí Print.', 'prepared', 1, '2026-09-23 18:46:46'),
(48, 'ready_delivery', 28, NULL, 1271, '526673607333', 'Hola Yaritzel 👋\n\n🚚 ¡Tu pedido OS-2026-00018 ya está listo para entrega!\n\n📅 Fecha compromiso: 24/09/2026\n\n🔎 Consulta los detalles aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=13b26f22bc1b66dfa1e4932537d71451bc6d7b615a9012b7591767b59d0af3f5\n\nGracias por confiar en Colibrí Print.', 'prepared', 1, '2026-09-23 18:51:53'),
(49, 'design_ready', 30, NULL, 746, '526271158049', 'Hola Jonathan 👋\n\n🎨 El diseño de tu pedido OS-2026-00020 ya está listo para revisión.\n\nPuedes consultar el avance de tu pedido aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=972066b330ab9711374d92a87d026bb03c3e1fa622767cab4255b818693a5e19\n\nSi necesitas algún ajuste, respóndenos por este mismo medio.\n\nColibrí Print', 'prepared', 1, '2026-09-23 20:23:10'),
(50, 'quote_sent', NULL, 29, 1, '526271074512', 'Hola LUIS GARDEA 👋\n\nGracias por confiar en Colibrí Print. Te compartimos la cotización CP-2026-00010.\n\n💰 Total cotizado: $150.00\n📅 Vigencia: 05/10/2026\n\n📄 Ver y descargar tu cotización en PDF:\nhttps://colibriprint.com.mx/cotizacion_pdf_publica.php?t=284ed6f22f3a889ea9ee841d62d76a87620e69e906e4bd3c403b246b73e6dcc7\n\nQuedamos atentos a cualquier duda o ajuste que necesites.\n\nSaludos,\nColibrí Print', 'prepared', 1, '2026-09-23 23:18:43'),
(51, 'ready_delivery', 24, NULL, 908, '526271499450', 'Hola Samuel 👋\n\n🚚 ¡Tu pedido OS-2026-00014 ya está listo para entrega!\n\n📅 Fecha compromiso: 23/09/2026\n\n🔎 Consulta los detalles aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=7d76622dd78293c669b62efbf22de2f422300f125505064866331c3091645ddd\n\nGracias por confiar en Colibrí Print.', 'prepared', 1, '2026-09-24 00:10:54'),
(52, 'ready_delivery', 28, NULL, 1271, '526673607333', 'Hola Yaritzel 👋\n\n🚚 ¡Tu pedido OS-2026-00018 ya está listo para entrega!\n\n📅 Fecha compromiso: 24/09/2026\n\n🔎 Consulta los detalles aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=13b26f22bc1b66dfa1e4932537d71451bc6d7b615a9012b7591767b59d0af3f5\n\nGracias por confiar en Colibrí Print.', 'prepared', 1, '2026-09-24 08:17:47'),
(53, 'quote_sent', NULL, 41, 1273, '526271472865', 'Hola Majo Ríos 👋\n\nGracias por confiar en Colibrí Print. Te compartimos la cotización CP-2026-00022.\n\n💰 Total cotizado: $580.00\n📅 Vigencia: 09/10/2026\n\n📄 Ver y descargar tu cotización en PDF:\nhttps://colibriprint.com.mx/cotizacion_pdf_publica.php?t=be858aa914a0455819bf6ad814aab000ac3c1b408bd8ad73b1e7ee8dc0958e9f\n\nQuedamos atentos a cualquier duda o ajuste que necesites.\n\nSaludos,\nColibrí Print', 'prepared', 1, '2026-09-24 11:02:46'),
(54, 'quote_sent', NULL, 45, 1209, '526271397831', 'Hola Instituto Municipal de la Juventud 👋\n\nGracias por confiar en Colibrí Print. Te compartimos la cotización CP-2026-00026.\n\n💰 Total cotizado: $950.04\n📅 Vigencia: 25/09/2026\n\n📄 Ver y descargar tu cotización en PDF:\nhttps://colibriprint.com.mx/cotizacion_pdf_publica.php?t=e4e37764bf1fffc3d32d70e76eb520aada86690b364e13cc0b0b022c663389cb\n\nQuedamos atentos a cualquier duda o ajuste que necesites.\n\nSaludos,\nColibrí Print', 'prepared', 1, '2026-09-24 21:21:35'),
(55, 'quote_sent', NULL, 45, 1209, '526271195419', 'Hola Instituto Municipal de la Juventud 👋\n\nGracias por confiar en Colibrí Print. Te compartimos la cotización CP-2026-00026.\n\n💰 Total cotizado: $950.04\n📅 Vigencia: 25/09/2026\n\n📄 Ver y descargar tu cotización en PDF:\nhttps://colibriprint.com.mx/cotizacion_pdf_publica.php?t=e4e37764bf1fffc3d32d70e76eb520aada86690b364e13cc0b0b022c663389cb\n\nQuedamos atentos a cualquier duda o ajuste que necesites.\n\nSaludos,\nColibrí Print', 'prepared', 1, '2026-09-24 21:32:19'),
(56, 'design_ready', 34, NULL, 1273, '526271472865', 'Hola Majo Ríos 👋\n\n🎨 El diseño de tu pedido OS-2026-00024 ya está listo para revisión.\n\nPuedes consultar el avance de tu pedido aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=05650f98f918b4982444e91bd5e217df6a3c45b16f60d649379da216ab354cf3\n\nSi necesitas algún ajuste, respóndenos por este mismo medio.\n\nColibrí Print', 'prepared', 1, '2026-09-24 21:56:20'),
(57, 'ready_delivery', 35, NULL, 1275, '526291180402', 'Hola Elizabeth Hinojos 👋\n\n🚚 ¡Tu pedido OS-2026-00025 ya está listo para entrega!\n\n📅 Fecha compromiso: 26/09/2026\n\n🔎 Consulta los detalles aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=3b7b8af3ef711f0b5fb4e5bf7094486b3fd561c9a6323389582c8ac210720ab0\n\nGracias por confiar en Colibrí Print.', 'prepared', 1, '2026-09-25 04:52:14'),
(58, 'order_confirmed', 36, NULL, 1276, '526271205039', 'Hola Jesús Tec Parral 👋\n\nTu pedido OS-2026-00026 ya fue registrado y comenzamos a trabajar en él.\n\n💰 Total de la orden: $880.00\n📅 Fecha compromiso: 09/10/2026\n\n🔎 Consulta el avance de tu pedido:\nhttps://colibriprint.com.mx/seguimiento.php?t=463c69368d8e664ba66e45ff5a8f9768fb79fcb4fa1a7b86a828c3cb2b7bbfc9\n\nGracias por confiar en Colibrí Print.', 'prepared', 1, '2026-09-25 07:45:49'),
(59, 'quote_sent', NULL, 48, 1277, '526271335870', 'Hola Hector Sanchez 👋\n\nGracias por confiar en Colibrí Print. Te compartimos la cotización CP-2026-00029.\n\n💰 Total cotizado: $240.00\n📅 Vigencia: 25/09/2026\n\n📄 Ver y descargar tu cotización en PDF:\nhttps://colibriprint.com.mx/cotizacion_pdf_publica.php?t=6f5ac43c0fd1f9b04227eb16987e1ba499f916919f98c20ce55d5e9709065d5e\n\nQuedamos atentos a cualquier duda o ajuste que necesites.\n\nSaludos,\nColibrí Print', 'prepared', 1, '2026-09-25 08:14:37'),
(60, 'quality_review', 37, NULL, 1277, '526271335870', 'Hola Hector Sanchez 👋\n\n✅ Tu pedido OS-2026-00027 está en revisión final de calidad antes de pasar a entrega.\n\n🔎 Consulta el avance aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=281b4101965960fe1d09112eaad6407b2db67a58d3922a076a145c2a25dbc121\n\nTe avisaremos en cuanto esté listo.\n\nColibrí Print', 'prepared', 1, '2026-09-25 08:27:06'),
(61, 'printing', 30, NULL, 746, '526271158049', 'Hola Jonathan 👋\n\n🖨️ Tu pedido OS-2026-00020 ya se encuentra en impresión. Estamos avanzando con tu trabajo.\n\n🔎 Consulta el avance aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=972066b330ab9711374d92a87d026bb03c3e1fa622767cab4255b818693a5e19\n\nColibrí Print', 'prepared', 1, '2026-09-25 11:19:12'),
(62, 'quality_review', 29, NULL, 1039, '526141734112', 'Hola GRUPO COMERCIAL BUJAIDAR 👋\n\n✅ Tu pedido OS-2026-00019 está en revisión final de calidad antes de pasar a entrega.\n\n🔎 Consulta el avance aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=01f16c4de2a8bfd4acc2ed53d41f42cc58f306078223b3ca50181f1145b6eb76\n\nTe avisaremos en cuanto esté listo.\n\nColibrí Print', 'prepared', 1, '2026-09-25 11:36:46'),
(63, 'quality_review', 26, NULL, 571, '526491043888', 'Hola Entidad de Limpieza y Mantenimiento 👋\n\n✅ Tu pedido OS-2026-00016 está en revisión final de calidad antes de pasar a entrega.\n\n🔎 Consulta el avance aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=515cdf55445a28732169f6336a37c15b2b216610cfe8c1e0e10c308fbb345f35\n\nTe avisaremos en cuanto esté listo.\n\nColibrí Print', 'prepared', 1, '2026-09-25 12:03:07'),
(64, 'quote_sent', NULL, 31, 1270, '526271426277', 'Hola Erika Escárcega 👋\n\nGracias por confiar en Colibrí Print. Te compartimos la cotización CP-2026-00012.\n\n💰 Total cotizado: $4,374.00\n📅 Vigencia: 05/10/2026\n\n📄 Ver y descargar tu cotización en PDF:\nhttps://colibriprint.com.mx/cotizacion_pdf_publica.php?t=ddb29e87d431885c5a0ee5f2f1cf25d0777c4bb5cc0698b96ff8fd8bad6a822d\n\nQuedamos atentos a cualquier duda o ajuste que necesites.\n\nSaludos,\nColibrí Print', 'prepared', 1, '2026-09-25 13:22:57'),
(65, 'quote_sent', NULL, 52, 1281, '526674756820', 'Hola Celina Escárcega Ruiz 👋\n\nGracias por confiar en Colibrí Print. Te compartimos la cotización CP-2026-00033.\n\n💰 Total cotizado: $2,700.00\n📅 Vigencia: 10/10/2026\n\n📄 Ver y descargar tu cotización en PDF:\nhttps://colibriprint.com.mx/cotizacion_pdf_publica.php?t=74ac7f6a7349ad9b1a60dfee52af11d186c4c986b42284616f90918d997e4957\n\nQuedamos atentos a cualquier duda o ajuste que necesites.\n\nSaludos,\nColibrí Print', 'prepared', 1, '2026-09-25 19:32:55'),
(66, 'quote_sent', NULL, 52, 1281, '526674756820', 'Hola Celina Escárcega Ruiz 👋\n\nGracias por confiar en Colibrí Print. Te compartimos la cotización CP-2026-00033.\n\n💰 Total cotizado: $2,700.00\n📅 Vigencia: 10/10/2026\n\n📄 Ver y descargar tu cotización en PDF:\nhttps://colibriprint.com.mx/cotizacion_pdf_publica.php?t=74ac7f6a7349ad9b1a60dfee52af11d186c4c986b42284616f90918d997e4957\n\nQuedamos atentos a cualquier duda o ajuste que necesites.\n\nSaludos,\nColibrí Print', 'prepared', 1, '2026-09-25 19:34:08'),
(67, 'quote_sent', NULL, 54, 1223, '526273010550', 'Hola Elena Rodríguez 👋\n\nGracias por confiar en Colibrí Print. Te compartimos la cotización CP-2026-00035.\n\n💰 Total cotizado: $350.00\n📅 Vigencia: 26/09/2026\n\n📄 Ver y descargar tu cotización en PDF:\nhttps://colibriprint.com.mx/cotizacion_pdf_publica.php?t=2bef9fbf2233baf5288fc5dd164be044e3676f8cb1cfe8fc870af93d7cd402c7\n\nQuedamos atentos a cualquier duda o ajuste que necesites.\n\nSaludos,\nColibrí Print', 'prepared', 1, '2026-09-25 20:47:35'),
(68, 'order_confirmed', 39, NULL, 1223, '526273010550', 'Hola Elena Rodríguez 👋\n\nTu pedido OS-2026-00029 ya fue registrado y comenzamos a trabajar en él.\n\n💰 Total de la orden: $350.00\n📅 Fecha compromiso: 26/09/2026\n\n🔎 Consulta el avance de tu pedido:\nhttps://colibriprint.com.mx/seguimiento.php?t=699baf6b7c6394592529b12f469e66a5f86a51bffc6f2691fa85545154b29088\n\nGracias por confiar en Colibrí Print.', 'prepared', 1, '2026-09-25 20:49:01'),
(69, 'quote_sent', NULL, 54, 1223, '526273010550', 'Hola Elena Rodríguez 👋\n\nGracias por confiar en Colibrí Print. Te compartimos la cotización CP-2026-00035.\n\n💰 Total cotizado: $350.00\n📅 Vigencia: 26/09/2026\n\n📄 Ver y descargar tu cotización en PDF:\nhttps://colibriprint.com.mx/cotizacion_pdf_publica.php?t=2bef9fbf2233baf5288fc5dd164be044e3676f8cb1cfe8fc870af93d7cd402c7\n\nQuedamos atentos a cualquier duda o ajuste que necesites.\n\nSaludos,\nColibrí Print', 'prepared', 1, '2026-09-25 20:58:47'),
(70, 'quote_sent', NULL, 54, 1223, '526273010550', 'Hola Elena Rodríguez 👋\n\nGracias por confiar en Colibrí Print. Te compartimos la cotización CP-2026-00035.\n\n💰 Total cotizado: $350.00\n📅 Vigencia: 26/09/2026\n\n📄 Ver y descargar tu cotización en PDF:\nhttps://colibriprint.com.mx/cotizacion_pdf_publica.php?t=2bef9fbf2233baf5288fc5dd164be044e3676f8cb1cfe8fc870af93d7cd402c7\n\nQuedamos atentos a cualquier duda o ajuste que necesites.\n\nSaludos,\nColibrí Print', 'prepared', 1, '2026-09-25 20:59:30'),
(71, 'quote_sent', NULL, 54, 1223, '526273010550', 'Hola Elena Rodríguez 👋\n\nGracias por confiar en Colibrí Print. Te compartimos la cotización CP-2026-00035.\n\n💰 Total cotizado: $350.00\n📅 Vigencia: 26/09/2026\n\n📄 Ver y descargar tu cotización en PDF:\nhttps://colibriprint.com.mx/cotizacion_pdf_publica.php?t=2bef9fbf2233baf5288fc5dd164be044e3676f8cb1cfe8fc870af93d7cd402c7\n\nQuedamos atentos a cualquier duda o ajuste que necesites.\n\nSaludos,\nColibrí Print', 'prepared', 1, '2026-09-25 21:00:11'),
(72, 'quote_sent', NULL, 54, 1223, '526273010550', 'Hola Elena Rodríguez 👋\n\nGracias por confiar en Colibrí Print. Te compartimos la cotización CP-2026-00035.\n\n💰 Total cotizado: $350.00\n📅 Vigencia: 26/09/2026\n\n📄 Ver y descargar tu cotización en PDF:\nhttps://colibriprint.com.mx/cotizacion_pdf_publica.php?t=2bef9fbf2233baf5288fc5dd164be044e3676f8cb1cfe8fc870af93d7cd402c7\n\nQuedamos atentos a cualquier duda o ajuste que necesites.\n\nSaludos,\nColibrí Print', 'prepared', 1, '2026-09-25 21:00:29'),
(73, 'quote_sent', NULL, 54, 1223, '526273010550', 'Hola Elena Rodríguez 👋\n\nGracias por confiar en Colibrí Print. Te compartimos la cotización CP-2026-00035.\n\n💰 Total cotizado: $350.00\n📅 Vigencia: 26/09/2026\n\n📄 Ver y descargar tu cotización en PDF:\nhttps://colibriprint.com.mx/cotizacion_pdf_publica.php?t=2bef9fbf2233baf5288fc5dd164be044e3676f8cb1cfe8fc870af93d7cd402c7\n\nQuedamos atentos a cualquier duda o ajuste que necesites.\n\nSaludos,\nColibrí Print', 'prepared', 1, '2026-09-25 21:04:03'),
(74, 'quote_sent', NULL, 54, 1223, '526273010550', 'Hola Elena Rodríguez 👋\n\nGracias por confiar en Colibrí Print. Te compartimos la cotización CP-2026-00035.\n\n💰 Total cotizado: $350.00\n📅 Vigencia: 26/09/2026\n\n📄 Ver y descargar tu cotización en PDF:\nhttps://colibriprint.com.mx/cotizacion_pdf_publica.php?t=2bef9fbf2233baf5288fc5dd164be044e3676f8cb1cfe8fc870af93d7cd402c7\n\nQuedamos atentos a cualquier duda o ajuste que necesites.\n\nSaludos,\nColibrí Print', 'prepared', 1, '2026-09-25 21:04:29'),
(75, 'design_ready', 31, NULL, 1272, '526271196277', 'Hola Ana Karen Torres 👋\n\n🎨 El diseño de tu pedido OS-2026-00021 ya está listo para revisión.\n\nPuedes consultar el avance de tu pedido aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=d663b7d962c6fa8addf2a4f860ddab715e03cef353562a7a6ce13af0cf0dd269\n\nSi necesitas algún ajuste, respóndenos por este mismo medio.\n\nColibrí Print', 'prepared', 1, '2026-09-25 21:10:56'),
(76, 'quote_sent', NULL, 54, 1223, '526273010550', 'Hola Elena Rodríguez 👋\n\nGracias por confiar en Colibrí Print. Te compartimos la cotización CP-2026-00035.\n\n💰 Total cotizado: $350.00\n📅 Vigencia: 26/09/2026\n\n📄 Ver y descargar tu cotización en PDF:\nhttps://colibriprint.com.mx/cotizacion_pdf_publica.php?t=2bef9fbf2233baf5288fc5dd164be044e3676f8cb1cfe8fc870af93d7cd402c7\n\nQuedamos atentos a cualquier duda o ajuste que necesites.\n\nSaludos,\nColibrí Print', 'prepared', 1, '2026-09-25 21:12:42'),
(77, 'quote_sent', NULL, 54, 1223, '526273010550', 'Hola Elena Rodríguez 👋\n\nGracias por confiar en Colibrí Print. Te compartimos la cotización CP-2026-00035.\n\n💰 Total cotizado: $350.00\n📅 Vigencia: 26/09/2026\n\n📄 Ver y descargar tu cotización en PDF:\nhttps://colibriprint.com.mx/cotizacion_pdf_publica.php?t=2bef9fbf2233baf5288fc5dd164be044e3676f8cb1cfe8fc870af93d7cd402c7\n\nQuedamos atentos a cualquier duda o ajuste que necesites.\n\nSaludos,\nColibrí Print', 'prepared', 1, '2026-09-25 21:13:13'),
(78, 'order_confirmed', 39, NULL, 1223, '526273010550', 'Hola Elena Rodríguez 👋\n\nTu pedido OS-2026-00029 ya fue registrado y comenzamos a trabajar en él.\n\n💰 Total de la orden: $350.00\n📅 Fecha compromiso: 26/09/2026\n\n🔎 Consulta el avance de tu pedido:\nhttps://colibriprint.com.mx/seguimiento.php?t=699baf6b7c6394592529b12f469e66a5f86a51bffc6f2691fa85545154b29088\n\nGracias por confiar en Colibrí Print.', 'prepared', 1, '2026-09-25 21:15:14'),
(79, 'order_confirmed', 39, NULL, 1223, '526273010550', 'Hola Elena Rodríguez 👋\n\nTu pedido OS-2026-00029 ya fue registrado y comenzamos a trabajar en él.\n\n💰 Total de la orden: $350.00\n📅 Fecha compromiso: 26/09/2026\n\n🔎 Consulta el avance de tu pedido:\nhttps://colibriprint.com.mx/seguimiento.php?t=699baf6b7c6394592529b12f469e66a5f86a51bffc6f2691fa85545154b29088\n\nGracias por confiar en Colibrí Print.', 'prepared', 1, '2026-09-25 21:15:18'),
(80, 'order_confirmed', 39, NULL, 1223, '526273010550', 'Hola Elena Rodríguez 👋\n\nTu pedido OS-2026-00029 ya fue registrado y comenzamos a trabajar en él.\n\n💰 Total de la orden: $350.00\n📅 Fecha compromiso: 26/09/2026\n\n🔎 Consulta el avance de tu pedido:\nhttps://colibriprint.com.mx/seguimiento.php?t=699baf6b7c6394592529b12f469e66a5f86a51bffc6f2691fa85545154b29088\n\nGracias por confiar en Colibrí Print.', 'prepared', 1, '2026-09-25 21:15:23'),
(81, 'order_confirmed', 39, NULL, 1223, '526273010550', 'Hola Elena Rodríguez 👋\n\nTu pedido OS-2026-00029 ya fue registrado y comenzamos a trabajar en él.\n\n💰 Total de la orden: $350.00\n📅 Fecha compromiso: 26/09/2026\n\n🔎 Consulta el avance de tu pedido:\nhttps://colibriprint.com.mx/seguimiento.php?t=699baf6b7c6394592529b12f469e66a5f86a51bffc6f2691fa85545154b29088\n\nGracias por confiar en Colibrí Print.', 'prepared', 1, '2026-09-25 21:16:34'),
(82, 'ready_delivery', 17, NULL, 930, '526275217596', 'Hola Ariana Denisse Ramirez Sánchez 👋\n\n🚚 ¡Tu pedido OS-2026-00007 ya está listo para entrega!\n\n📅 Fecha compromiso: 22/09/2026\n\n🔎 Consulta los detalles aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=ecf23513e472f8100ff636f246978ea6e45c1ce679aa8ef3d5a9448092b298c3\n\nGracias por confiar en Colibrí Print.', 'prepared', 1, '2026-09-26 10:31:48'),
(83, 'ready_delivery', 21, NULL, 763, '526271064807', 'Hola Karina salón de eventos Alexa 👋\n\n🚚 ¡Tu pedido OS-2026-00011 ya está listo para entrega!\n\n📅 Fecha compromiso: 25/09/2026\n\n🔎 Consulta los detalles aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=7deea835a5e29ef2b181616405cfc9cc4f07bdb77e8c58ba05f454e0e2e55bea\n\nGracias por confiar en Colibrí Print.', 'prepared', 1, '2026-09-26 10:39:53');

-- --------------------------------------------------------

--
-- Table structure for table `cp_whatsapp_messages`
--

CREATE TABLE `cp_whatsapp_messages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `chat_id` bigint(20) UNSIGNED NOT NULL,
  `whatsapp_message_id` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `direction` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'incoming',
  `message_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'text',
  `body` text COLLATE utf8mb4_unicode_ci,
  `sender_phone` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sender_name` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `from_me` tinyint(1) NOT NULL DEFAULT '0',
  `whatsapp_timestamp` bigint(20) UNSIGNED DEFAULT NULL,
  `message_at` datetime DEFAULT NULL,
  `status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'received',
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_whatsapp_messages`
--

INSERT INTO `cp_whatsapp_messages` (`id`, `chat_id`, `whatsapp_message_id`, `direction`, `message_type`, `body`, `sender_phone`, `sender_name`, `from_me`, `whatsapp_timestamp`, `message_at`, `status`, `created_at`) VALUES
(1, 1, 'PrCrjNSSH73XgIY-wCESb8Ya2w', 'incoming', 'text', '...', '13135555657', 'Sender', 0, 1725958805, '2024-09-10 03:00:05', 'received', '2026-09-23 21:52:28'),
(2, 2, 'paZ2K9QirVMJgmCsJvzadQ-ws8Bq53YtUQQjA', 'outgoing', 'album', NULL, '5216271470053', 'Colibrí Print México', 1, 1790224548, '2026-09-23 22:35:48', 'received', '2026-09-23 22:35:49'),
(3, 2, 'pQ3lM4YMy64643bfO.Eszg-wvIBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790224548, '2026-09-23 22:35:48', 'received', '2026-09-23 22:35:50'),
(4, 2, 'pSoG1pdjEq8ntJek5VKo_Q-wqEBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790224549, '2026-09-23 22:35:49', 'received', '2026-09-23 22:35:50'),
(5, 2, 'pQhVjLJHxJyQS9wibHoUBw-wpIBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790224549, '2026-09-23 22:35:49', 'received', '2026-09-23 22:35:50'),
(6, 2, 'pYblm9FqpENf0R2D1aoQKA-whsBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790224549, '2026-09-23 22:35:49', 'received', '2026-09-23 22:35:50'),
(7, 2, 'pYbJWVN7PLBQ3Vz347CDVQ-ws0Bq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790224549, '2026-09-23 22:35:49', 'received', '2026-09-23 22:35:50'),
(8, 2, 'pf_HyMDkrcklLrx6i1O.Og-wnEBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790224550, '2026-09-23 22:35:50', 'received', '2026-09-23 22:35:50'),
(9, 2, 'pcyFWT70bj9m9UE3uW4vnQ-wpYBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790224550, '2026-09-23 22:35:50', 'received', '2026-09-23 22:35:51'),
(10, 2, 'pQkKLhQzIp6up7uviANQPQ-woABq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790224550, '2026-09-23 22:35:50', 'received', '2026-09-23 22:35:51'),
(11, 2, 'pRxup2qZK0rYPS2mif_D4A-wgkBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790224550, '2026-09-23 22:35:50', 'received', '2026-09-23 22:35:51'),
(12, 2, 'pakeOOYU5vIupsbYohlMQA-wp0Bq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790224551, '2026-09-23 22:35:51', 'received', '2026-09-23 22:35:51'),
(13, 2, 'pWpw2SZFda4zwNN8..g7qg-whABq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790224551, '2026-09-23 22:35:51', 'received', '2026-09-23 22:35:51'),
(14, 2, 'pSnQ02Lralj_rU67CUxWag-wm0Bq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790224551, '2026-09-23 22:35:51', 'received', '2026-09-23 22:35:52'),
(15, 2, 'pQCfPLzR_VZ70bBv6z9SIg-wjYBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790224551, '2026-09-23 22:35:51', 'received', '2026-09-23 22:35:52'),
(16, 3, 'OrBLx1UNVNiDQw-hR3XJRsAYJg', 'incoming', 'unknown', NULL, '5215610256460', 'J', 0, 1790224804, '2026-09-23 22:40:04', 'received', '2026-09-23 22:40:06'),
(17, 4, 'rOFc1lsF9gYYGOV5TEtP.w-hSrQ0wsA8Ko', 'incoming', 'text', 'Oyeee', '5216271052926', 'Mitzy Anahí G.', 0, 1790225091, '2026-09-23 22:44:51', 'received', '2026-09-23 22:44:53'),
(18, 4, 'rPRcye7vs4RlLO1O_6TUeQ-hX_Q0wsA8Ko', 'incoming', 'text', 'In favor', '5216271052926', 'Mitzy Anahí G.', 0, 1790225092, '2026-09-23 22:44:52', 'received', '2026-09-23 22:44:53'),
(19, 4, 'pTz6I27EqmUsm.JczCNDxQ-xR3Q0wsA8Ko', 'outgoing', 'text', 'Eu', '5216271470053', 'Colibrí Print México', 1, 1790225465, '2026-09-23 22:51:05', 'received', '2026-09-23 22:51:06'),
(20, 2, 'pTAtU.P8qfjS6a7P8N7kKQ-whABq53YtUQQjA', 'outgoing', 'album', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225511, '2026-09-23 22:51:51', 'received', '2026-09-23 22:51:52'),
(21, 2, 'pcVhw.ciCwMv5c_CNOlsuQ-whwBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225511, '2026-09-23 22:51:51', 'received', '2026-09-23 22:51:52'),
(22, 2, 'pWl6sNfAg2Spn1Jn8gmM1g-wnMBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225512, '2026-09-23 22:51:52', 'received', '2026-09-23 22:51:53'),
(23, 2, 'pfM6JWhJcq3tcoLY2ak9XQ-wj8Bq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225512, '2026-09-23 22:51:52', 'received', '2026-09-23 22:51:53'),
(24, 2, 'pWn_BQlY_DXjZtrHRsjW8w-wuABq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225512, '2026-09-23 22:51:52', 'received', '2026-09-23 22:51:53'),
(25, 2, 'pdTMPP9LIaHMhTC3K42rew-wuABq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225513, '2026-09-23 22:51:53', 'received', '2026-09-23 22:51:53'),
(26, 2, 'pQFrC95Zla7_Kyuqh6OHTw-wlcBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225521, '2026-09-23 22:52:01', 'received', '2026-09-23 22:52:02'),
(27, 2, 'pWH3AX.d_ZwNjbTz29_HvQ-wuEBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225522, '2026-09-23 22:52:02', 'received', '2026-09-23 22:52:02'),
(28, 2, 'pbTn5x98HvCsVIujXrgzYQ-wl4Bq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225521, '2026-09-23 22:52:01', 'received', '2026-09-23 22:52:02'),
(29, 2, 'pTMIGoln8fzS0_yCyNNtaw-wt8Bq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225522, '2026-09-23 22:52:02', 'received', '2026-09-23 22:52:03'),
(30, 2, 'pRUvHwV_csHkXmg_QCRzwA-wqgBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225522, '2026-09-23 22:52:02', 'received', '2026-09-23 22:52:03'),
(31, 2, 'pReSJDcq8VmJKoKdySo9Cg-wpcBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225522, '2026-09-23 22:52:02', 'received', '2026-09-23 22:52:03'),
(32, 2, 'pVQ_S1eMJulruQwcdN1YSA-wqQBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225523, '2026-09-23 22:52:03', 'received', '2026-09-23 22:52:03'),
(33, 2, 'pU1C2fA74fCfsu3yHsX.yQ-wgYBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225522, '2026-09-23 22:52:02', 'received', '2026-09-23 22:52:03'),
(34, 2, 'pTnx4APsPI7Hv9czsIaPpg-ws0Bq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225523, '2026-09-23 22:52:03', 'received', '2026-09-23 22:52:03'),
(35, 2, 'pebYkCMDHMYFkFE_omJkDA-wuwBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225522, '2026-09-23 22:52:02', 'received', '2026-09-23 22:52:03'),
(36, 2, 'pROJMSXx5R3MOXGqsRC2EA-wlgBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225523, '2026-09-23 22:52:03', 'received', '2026-09-23 22:52:03'),
(37, 2, 'pR3mt92BVHFQtEBAS3QSag-wukBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225523, '2026-09-23 22:52:03', 'received', '2026-09-23 22:52:04'),
(38, 2, 'pby71Nl0GCdvGkADIllIbw-wg0Bq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225523, '2026-09-23 22:52:03', 'received', '2026-09-23 22:52:04'),
(39, 2, 'peiPJUcfw9HmD15Vdryrzw-wiMBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225523, '2026-09-23 22:52:03', 'received', '2026-09-23 22:52:04'),
(40, 2, 'peQiFqV8oMqV.VvqHNjDaw-wgQBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225524, '2026-09-23 22:52:04', 'received', '2026-09-23 22:52:04'),
(41, 2, 'pfHSvzL.feIw.eSjHfe6OA-wvkBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225524, '2026-09-23 22:52:04', 'received', '2026-09-23 22:52:04'),
(42, 2, 'pccIZcXMi4vhlSY0Umn4Kg-wpMBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225524, '2026-09-23 22:52:04', 'received', '2026-09-23 22:52:04'),
(43, 2, 'pQecTlILLN_3yIYYhZKyUg-wnABq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225524, '2026-09-23 22:52:04', 'received', '2026-09-23 22:52:05'),
(44, 2, 'pUT8KhX0nfIwJIhaagpwIw-wskBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225524, '2026-09-23 22:52:04', 'received', '2026-09-23 22:52:05'),
(45, 2, 'pcA.CQc9IQYmwrut6vPhfA-wtwBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225524, '2026-09-23 22:52:04', 'received', '2026-09-23 22:52:05'),
(46, 2, 'pXAIuZVqFXGxTcpgWFquWw-wkcBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225524, '2026-09-23 22:52:04', 'received', '2026-09-23 22:52:05'),
(47, 2, 'pTtHPGIVCbtM8o2PO1XrNw-wvIBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225525, '2026-09-23 22:52:05', 'received', '2026-09-23 22:52:05'),
(48, 2, 'pWebyzMTB6n1tBgjjxgJWA-whgBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225525, '2026-09-23 22:52:05', 'received', '2026-09-23 22:52:05'),
(49, 2, 'pWA5VwdPy4dgSQsRlNxdvw-wuUBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225525, '2026-09-23 22:52:05', 'received', '2026-09-23 22:52:05'),
(50, 2, 'pUkMArr1vOP2N9ciIznHNw-wksBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225525, '2026-09-23 22:52:05', 'received', '2026-09-23 22:52:05'),
(51, 2, 'peVK2pYkddOSISkWDts.Zg-wuUBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225525, '2026-09-23 22:52:05', 'received', '2026-09-23 22:52:06'),
(52, 2, 'pYaTfYM8DE.SfahC6epE2Q-whkBq53YtUQQjA', 'outgoing', 'image', NULL, '5216271470053', 'Colibrí Print México', 1, 1790225525, '2026-09-23 22:52:05', 'received', '2026-09-23 22:52:06'),
(53, 4, 'pasreNfLZjE8l2mH7eZATw-xfbQ0wsA8Ko', 'outgoing', 'text', 'Oye aquí tengo los 200 míos y de Luis para que ahorita que llegues te lo de y mañana temprano transfieras', '5216271470053', 'Colibrí Print México', 1, 1790226212, '2026-09-23 23:03:32', 'received', '2026-09-23 23:03:34'),
(54, 4, 'pVkXgV2tA_kwCjAUNrImyQ-xQrQ0wsA8Ko', 'outgoing', 'sticker', NULL, '5216271470053', 'Colibrí Print México', 1, 1790226217, '2026-09-23 23:03:37', 'received', '2026-09-23 23:03:38'),
(55, 4, 'pYivisTn3UeYgPNsRqicyQ-xZjQ0wsA8Ko', 'outgoing', 'text', 'Y mañana antes de que hagas la transf le dices a mi mamá para que te los transfiera también', '5216271470053', 'Colibrí Print México', 1, 1790226246, '2026-09-23 23:04:06', 'received', '2026-09-23 23:04:07'),
(56, 4, 'pcH4bKRGb3RyX3vLuTKJCw-xZDQ0wsA8Ko', 'outgoing', 'sticker', NULL, '5216271470053', 'Colibrí Print México', 1, 1790226251, '2026-09-23 23:04:11', 'received', '2026-09-23 23:04:12'),
(57, 4, 'pZGD5lGceI5qKMhj1eRrkQ-xVzQ0wsA8Ko', 'outgoing', 'text', 'Ei las cucharas negras desechables te las llevaste', '5216271470053', 'Colibrí Print México', 1, 1790226420, '2026-09-23 23:07:00', 'received', '2026-09-23 23:07:02'),
(58, 5, 'pfesXfRtfK78MvtXA9t3RA-heD_fQEAYK8', 'incoming', 'text', '¿Qué oportunidades existen en el entorno que podrían impulsar mi carrera profesional?\n¿Qué circunstancias externas están favoreciendo que me desarrolle personalmente?\n¿Qué acciones van a permitirme que mejore mi adaptación al entorno?', '5216271074512', 'Colibrí Print', 0, 1790227692, '2026-09-23 23:28:12', 'received', '2026-09-23 23:28:13'),
(59, 5, 'pZcnb6fvboqpGtVUgyyOIw-hZ7_fQEAYK8', 'incoming', 'text', '¿Qué obstáculos externos pueden dificultar que alcance mis objetivos?\n¿Qué hacen mis competidores?\n¿Qué problemas puedo encontrar en mi sector o en mi ámbito de actuación?\n¿Cuáles son los problemas que puedo encontrar a la hora de desarrollar mis objetivos?', '5216271074512', 'Colibrí Print', 0, 1790227703, '2026-09-23 23:28:23', 'received', '2026-09-23 23:28:24'),
(60, 6, 'rKha.mzlX1M0jnrhIgNHqg-hcHcpyAAEAs', 'incoming', 'image', NULL, '5216271112122', '.', 0, 1790228389, '2026-09-23 23:39:49', 'received', '2026-09-23 23:39:51'),
(61, 5, 'PrBk_WqBOYRsARE-heb_fQEAYK8', 'incoming', 'document', NULL, '5216271074512', 'Colibrí Print', 0, 1790228445, '2026-09-23 23:40:45', 'received', '2026-09-23 23:40:47');

-- --------------------------------------------------------

--
-- Table structure for table `cp_whatsapp_templates`
--

CREATE TABLE `cp_whatsapp_templates` (
  `id` int(10) UNSIGNED NOT NULL,
  `template_key` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'service',
  `body` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_whatsapp_templates`
--

INSERT INTO `cp_whatsapp_templates` (`id`, `template_key`, `name`, `category`, `body`, `active`, `created_at`, `updated_at`) VALUES
(1, 'quote_sent', 'Cotización enviada', 'service', 'Hola {cliente} 👋\r\n\r\nGracias por confiar en {empresa}. Te compartimos la cotización {folio}.\r\n\r\n💰 Total cotizado: {total}\r\n📅 Vigencia: {vigencia}\r\n\r\n📄 Ver y descargar tu cotización en PDF:\r\n{pdf_url}\r\n\r\nQuedamos atentos a cualquier duda o ajuste que necesites.\r\n\r\nSaludos,\r\n{empresa}\r\n\r\nEste es un mensaje automático y no es necesario responder', 1, '2026-09-17 15:11:10', '2026-09-26 10:41:43'),
(3, 'order_confirmed', 'Pedido confirmado', 'service', 'Hola {cliente} 👋\r\n\r\nTu pedido {orden} ya fue registrado y comenzamos a trabajar en él.\r\n\r\n💰 Total de la orden: {total}\r\n📅 Fecha compromiso: {fecha_entrega}\r\n\r\n🔎 Consulta el avance de tu pedido:\r\n{seguimiento}\r\n\r\nGracias por confiar en {empresa}.\r\n\r\nEste es un mensaje automático y no es necesario responder', 1, '2026-09-17 21:16:52', '2026-09-26 10:41:50'),
(4, 'design_ready', 'Diseño listo', 'service', 'Hola {cliente} 👋\r\n\r\n🎨 El diseño de tu pedido {orden} ya está listo para revisión.\r\n\r\nPuedes consultar el avance de tu pedido aquí:\r\n{seguimiento}\r\n\r\nSi necesitas algún ajuste, respóndenos por este mismo medio.\r\n\r\n{empresa}\r\n\r\nEste es un mensaje automático y no es necesario responder', 1, '2026-09-17 21:16:52', '2026-09-26 10:41:57'),
(5, 'design_approval', 'Aprobación de diseño', 'service', 'Hola {cliente} 👋\r\n\r\n🎨 El diseño de tu pedido {orden} está listo para aprobación.\r\n\r\nPara autorizar la producción, responde a este mensaje con *APROBADO*. Si necesitas cambios, indícanos cuáles para revisarlos contigo.\r\n\r\n🔎 Seguimiento del pedido:\r\n{seguimiento}\r\n\r\n{empresa}\r\n\r\nEste es un mensaje automático y no es necesario responder', 1, '2026-09-17 21:16:52', '2026-09-26 10:42:31'),
(6, 'printing', 'En impresión', 'service', 'Hola {cliente} 👋\n\n🖨️ Tu pedido {orden} ya se encuentra en impresión. Estamos avanzando con tu trabajo.\n\n🔎 Consulta el avance aquí:\n{seguimiento}\n\n{empresa}', 1, '2026-09-17 21:16:52', '2026-09-17 21:16:52'),
(7, 'in_production', 'En producción', 'service', 'Hola {cliente} 👋\r\n\r\n🔧 Tu pedido {orden} ya se encuentra en producción. Nuestro equipo está trabajando en los detalles de tu trabajo.\r\n\r\n🔎 Consulta el avance aquí:\r\n{seguimiento}\r\n\r\nEste es un mensaje automático y no es necesario responder\r\n\r\n{empresa}\r\n\r\nEste es un mensaje automático y no es necesario responder', 1, '2026-09-17 21:16:52', '2026-09-26 10:42:41'),
(8, 'quality_review', 'Control de calidad', 'service', 'Hola {cliente} 👋\r\n\r\n✅ Tu pedido {orden} está en revisión final de calidad antes de pasar a entrega.\r\n\r\n🔎 Consulta el avance aquí:\r\n{seguimiento}\r\n\r\nTe avisaremos en cuanto esté listo.\r\n\r\n{empresa}\r\n\r\nEste es un mensaje automático y no es necesario responder', 1, '2026-09-17 21:16:52', '2026-09-26 10:42:53'),
(9, 'finished', 'Trabajo terminado', 'service', 'Hola {cliente} 👋\r\n\r\n✅ Tu pedido {orden} terminó su proceso de producción.\r\n\r\nEstamos preparando la entrega y te avisaremos cuando esté listo para recoger o entregar.\r\n\r\n🔎 Seguimiento:\r\n{seguimiento}\r\n\r\n{empresa}\r\n\r\nEste es un mensaje automático y no es necesario responder', 1, '2026-09-17 21:16:52', '2026-09-26 10:43:29'),
(10, 'ready_delivery', 'Listo para entrega', 'service', 'Hola {cliente} 👋\r\n\r\n🚚 ¡Tu pedido {orden} ya está listo para entrega!\r\n\r\n📅 Fecha compromiso: {fecha_entrega}\r\n\r\n🔎 Consulta los detalles aquí:\r\n{seguimiento}\r\n\r\nGracias por confiar en {empresa}.\r\n\r\nEste es un mensaje automático y no es necesario responder', 1, '2026-09-17 21:16:52', '2026-09-26 10:43:08'),
(11, 'delivered', 'Entregado', 'service', 'Hola {cliente} 👋\r\n\r\n🎉 Tu pedido {orden} ha sido entregado correctamente.\r\n\r\nGracias por confiar en {empresa}. Esperamos seguir trabajando contigo.\r\n\r\nEste es un mensaje automático y no es necesario responder', 1, '2026-09-17 21:16:52', '2026-09-26 10:42:59'),
(12, 'promotion_offer', 'Promoción comercial', 'commercial', '✨ {label}: {promotion_title}\r\n\r\n{promotion_description}\r\n\r\n💥 Precio promocional: {promo_price}\r\n🏷️ Precio normal: {normal_price}\r\n🎯 Descuento: {discount}\r\n📅 Vigencia: {vigencia_promocion}\r\n📦 Disponibilidad: {availability}\r\n\r\n🌐 {website}\r\n\r\n{empresa}\r\n\r\nEste es un mensaje automático y no es necesario responder', 1, '2026-09-17 21:16:52', '2026-09-26 10:42:23');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cp_activity_log`
--
ALTER TABLE `cp_activity_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cp_activity_user` (`user_id`),
  ADD KEY `idx_cp_activity_created` (`created_at`);

--
-- Indexes for table `cp_categories`
--
ALTER TABLE `cp_categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cp_categories_type` (`type`),
  ADD KEY `idx_cp_categories_enabled` (`enabled`);

--
-- Indexes for table `cp_customers`
--
ALTER TABLE `cp_customers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cp_customers_source` (`source_type`,`source_id`),
  ADD KEY `idx_cp_customers_name` (`name`),
  ADD KEY `idx_cp_customers_phone` (`phone`);

--
-- Indexes for table `cp_invoices`
--
ALTER TABLE `cp_invoices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_invoices_number` (`invoice_number`),
  ADD KEY `idx_cp_invoices_order` (`order_id`),
  ADD KEY `idx_cp_invoices_customer` (`customer_id`),
  ADD KEY `idx_cp_invoices_date` (`invoice_date`),
  ADD KEY `idx_cp_invoices_status` (`status`),
  ADD KEY `fk_cp_invoices_created_by` (`created_by`),
  ADD KEY `fk_cp_invoices_updated_by` (`updated_by`);

--
-- Indexes for table `cp_orders`
--
ALTER TABLE `cp_orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_orders_number` (`order_number`),
  ADD UNIQUE KEY `uq_cp_orders_quote` (`quote_id`),
  ADD KEY `idx_cp_orders_customer` (`customer_id`),
  ADD KEY `idx_cp_orders_status` (`status`),
  ADD KEY `idx_cp_orders_due_date` (`due_date`),
  ADD KEY `fk_cp_orders_responsible` (`responsible_user_id`),
  ADD KEY `fk_cp_orders_created_by` (`created_by`),
  ADD KEY `fk_cp_orders_updated_by` (`updated_by`);

--
-- Indexes for table `cp_order_history`
--
ALTER TABLE `cp_order_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cp_order_history_order` (`order_id`),
  ADD KEY `fk_cp_order_history_user` (`changed_by`),
  ADD KEY `idx_cp_order_history_new_status` (`new_status`);

--
-- Indexes for table `cp_order_items`
--
ALTER TABLE `cp_order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cp_order_items_order` (`order_id`),
  ADD KEY `fk_cp_order_items_quote_item` (`quote_item_id`);

--
-- Indexes for table `cp_order_photos`
--
ALTER TABLE `cp_order_photos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cp_order_photos_order` (`order_id`),
  ADD KEY `idx_cp_order_photos_type` (`photo_type`),
  ADD KEY `fk_cp_order_photos_created_by` (`created_by`);

--
-- Indexes for table `cp_order_production_briefs`
--
ALTER TABLE `cp_order_production_briefs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_order_production_brief_order` (`order_id`),
  ADD KEY `idx_cp_order_production_briefs_service` (`service_type`),
  ADD KEY `idx_cp_order_production_briefs_priority` (`priority`),
  ADD KEY `fk_cp_order_production_briefs_updated_by` (`updated_by`),
  ADD KEY `fk_cp_order_production_briefs_created_by` (`created_by`),
  ADD KEY `fk_cp_order_production_briefs_approved_by` (`design_approved_by`);

--
-- Indexes for table `cp_order_production_checklist`
--
ALTER TABLE `cp_order_production_checklist`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_order_production_checklist_item` (`order_id`,`item_key`),
  ADD KEY `idx_cp_order_production_checklist_order` (`order_id`),
  ADD KEY `idx_cp_order_production_checklist_area` (`area`),
  ADD KEY `fk_cp_order_production_checklist_completed_by` (`completed_by`);

--
-- Indexes for table `cp_order_status`
--
ALTER TABLE `cp_order_status`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_order_status_order` (`order_id`),
  ADD KEY `idx_cp_order_status_stage` (`stage`),
  ADD KEY `fk_cp_order_status_user` (`updated_by`),
  ADD KEY `idx_cp_order_status_updated_at` (`updated_at`);

--
-- Indexes for table `cp_payments`
--
ALTER TABLE `cp_payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cp_payments_order` (`order_id`),
  ADD KEY `idx_cp_payments_customer` (`customer_id`),
  ADD KEY `idx_cp_payments_date` (`payment_date`),
  ADD KEY `idx_cp_payments_status` (`status`),
  ADD KEY `fk_cp_payments_created_by` (`created_by`),
  ADD KEY `fk_cp_payments_updated_by` (`updated_by`);

--
-- Indexes for table `cp_payment_receipts`
--
ALTER TABLE `cp_payment_receipts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_payment_receipt_token` (`access_token`),
  ADD KEY `idx_cp_payment_receipts_order` (`order_id`),
  ADD KEY `idx_cp_payment_receipts_payment` (`payment_id`),
  ADD KEY `idx_cp_payment_receipts_status` (`status`),
  ADD KEY `fk_cp_payment_receipts_reviewed_by` (`reviewed_by`);

--
-- Indexes for table `cp_print_finishes`
--
ALTER TABLE `cp_print_finishes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_print_finishes_code` (`code`),
  ADD KEY `ix_cp_print_finishes_enabled` (`enabled`,`sort_order`);

--
-- Indexes for table `cp_print_jobs`
--
ALTER TABLE `cp_print_jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cp_print_jobs_printed_at` (`printed_at`),
  ADD KEY `idx_cp_print_jobs_result_status` (`result_status`),
  ADD KEY `idx_cp_print_jobs_order_id` (`order_id`),
  ADD KEY `idx_cp_print_jobs_quote_id` (`quote_id`),
  ADD KEY `idx_cp_print_jobs_printer` (`printer_name`),
  ADD KEY `idx_cp_print_jobs_material` (`material_name`);

--
-- Indexes for table `cp_print_materials`
--
ALTER TABLE `cp_print_materials`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_print_materials_code` (`code`),
  ADD KEY `ix_cp_print_materials_enabled` (`enabled`,`sort_order`);

--
-- Indexes for table `cp_print_meter_logs`
--
ALTER TABLE `cp_print_meter_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cp_print_meter_roll` (`roll_id`),
  ADD KEY `idx_cp_print_meter_date` (`printed_at`),
  ADD KEY `idx_cp_print_meter_result` (`result_status`);

--
-- Indexes for table `cp_print_prices`
--
ALTER TABLE `cp_print_prices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_price` (`size_id`,`material_id`,`finish_id`,`color_mode`,`pricing_mode`),
  ADD KEY `fk_cp_price_material` (`material_id`),
  ADD KEY `fk_cp_price_finish` (`finish_id`);

--
-- Indexes for table `cp_print_price_rules`
--
ALTER TABLE `cp_print_price_rules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ix_cp_print_price_rules_match` (`enabled`,`service_key`,`size_id`,`material_id`,`color_mode`,`finish_id`),
  ADD KEY `fk_cp_print_price_rules_size` (`size_id`),
  ADD KEY `fk_cp_print_price_rules_material` (`material_id`),
  ADD KEY `fk_cp_print_price_rules_finish` (`finish_id`);

--
-- Indexes for table `cp_print_requests`
--
ALTER TABLE `cp_print_requests`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cp_print_request_items`
--
ALTER TABLE `cp_print_request_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ix_cp_print_request_items_request` (`request_id`),
  ADD KEY `ix_cp_print_request_items_file` (`file_id`),
  ADD KEY `fk_cp_print_request_items_size` (`size_id`),
  ADD KEY `fk_cp_print_request_items_material` (`material_id`),
  ADD KEY `fk_cp_print_request_items_finish` (`finish_id`),
  ADD KEY `fk_cp_print_request_items_rule` (`price_rule_id`);

--
-- Indexes for table `cp_print_rolls`
--
ALTER TABLE `cp_print_rolls`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cp_print_rolls_status` (`status`),
  ADD KEY `idx_cp_print_rolls_opened_at` (`opened_at`);

--
-- Indexes for table `cp_print_sizes`
--
ALTER TABLE `cp_print_sizes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_print_sizes_code` (`code`),
  ADD KEY `ix_cp_print_sizes_enabled` (`enabled`,`sort_order`);

--
-- Indexes for table `cp_products`
--
ALTER TABLE `cp_products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cp_products_source` (`source_type`,`source_id`),
  ADD KEY `idx_cp_products_category` (`category_id`),
  ADD KEY `idx_cp_products_name` (`name`),
  ADD KEY `idx_cp_products_web` (`visible_web`,`enabled`);

--
-- Indexes for table `cp_product_images`
--
ALTER TABLE `cp_product_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cp_product_images_product` (`product_id`);

--
-- Indexes for table `cp_product_inventory`
--
ALTER TABLE `cp_product_inventory`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_product_inventory_product` (`product_id`);

--
-- Indexes for table `cp_projects`
--
ALTER TABLE `cp_projects`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_projects_slug` (`slug`);

--
-- Indexes for table `cp_promotions`
--
ALTER TABLE `cp_promotions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_promotions_slug` (`slug`),
  ADD KEY `idx_cp_promotions_status_dates` (`status`,`start_date`,`end_date`),
  ADD KEY `idx_cp_promotions_web` (`show_web`,`status`),
  ADD KEY `idx_cp_promotions_catalog` (`show_catalog`,`status`),
  ADD KEY `idx_cp_promotions_whatsapp` (`show_whatsapp`,`status`),
  ADD KEY `fk_cp_promotions_created_by` (`created_by`),
  ADD KEY `fk_cp_promotions_updated_by` (`updated_by`);

--
-- Indexes for table `cp_promotion_facebook`
--
ALTER TABLE `cp_promotion_facebook`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_promotion_facebook_promotion` (`promotion_id`),
  ADD KEY `idx_cp_promotion_facebook_status` (`status`);

--
-- Indexes for table `cp_promotion_products`
--
ALTER TABLE `cp_promotion_products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_promotion_product` (`promotion_id`,`product_id`),
  ADD KEY `idx_cp_promotion_products_product` (`product_id`);

--
-- Indexes for table `cp_quotes`
--
ALTER TABLE `cp_quotes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_quotes_number` (`quote_number`),
  ADD KEY `idx_cp_quotes_customer` (`customer_id`),
  ADD KEY `idx_cp_quotes_status` (`status`),
  ADD KEY `idx_cp_quotes_issue_date` (`issue_date`),
  ADD KEY `fk_cp_quotes_created_by` (`created_by`),
  ADD KEY `fk_cp_quotes_updated_by` (`updated_by`);

--
-- Indexes for table `cp_quote_condition_templates`
--
ALTER TABLE `cp_quote_condition_templates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cpct_enabled` (`enabled`,`sort_order`,`id`),
  ADD KEY `idx_cpct_default` (`is_default`,`enabled`);

--
-- Indexes for table `cp_quote_costs`
--
ALTER TABLE `cp_quote_costs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cp_quote_costs_quote` (`quote_id`);

--
-- Indexes for table `cp_quote_items`
--
ALTER TABLE `cp_quote_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cp_quote_items_quote` (`quote_id`);

--
-- Indexes for table `cp_quote_public_tokens`
--
ALTER TABLE `cp_quote_public_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_quote_public_quote` (`quote_id`),
  ADD UNIQUE KEY `uq_cp_quote_public_token` (`token`),
  ADD KEY `idx_cp_quote_public_active` (`active`);

--
-- Indexes for table `cp_quote_totals`
--
ALTER TABLE `cp_quote_totals`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_quote_totals_quote` (`quote_id`);

--
-- Indexes for table `cp_roles`
--
ALTER TABLE `cp_roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_roles_name` (`name`);

--
-- Indexes for table `cp_settings`
--
ALTER TABLE `cp_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_settings_key` (`setting_key`);

--
-- Indexes for table `cp_shipping_methods`
--
ALTER TABLE `cp_shipping_methods`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_shipping_methods_code` (`code`);

--
-- Indexes for table `cp_shipping_rules`
--
ALTER TABLE `cp_shipping_rules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cp_shipping_rules_method` (`shipping_method_id`);

--
-- Indexes for table `cp_tiktok_posts`
--
ALTER TABLE `cp_tiktok_posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cp_tiktok_posts_publish_id` (`publish_id`),
  ADD KEY `idx_cp_tiktok_posts_status` (`status`),
  ADD KEY `idx_cp_tiktok_posts_created_at` (`created_at`);

--
-- Indexes for table `cp_tracking_tokens`
--
ALTER TABLE `cp_tracking_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_tracking_order` (`order_id`),
  ADD UNIQUE KEY `uq_cp_tracking_token` (`token`),
  ADD KEY `idx_cp_tracking_active` (`active`);

--
-- Indexes for table `cp_users`
--
ALTER TABLE `cp_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_users_email` (`email`),
  ADD KEY `idx_cp_users_role_id` (`role_id`);

--
-- Indexes for table `cp_web_checkout_sessions`
--
ALTER TABLE `cp_web_checkout_sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_web_checkout_token` (`session_token`),
  ADD KEY `idx_cp_web_checkout_status` (`status`),
  ADD KEY `idx_cp_web_checkout_quote` (`quote_id`);

--
-- Indexes for table `cp_web_quote_files`
--
ALTER TABLE `cp_web_quote_files`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cpq_files_request` (`request_id`,`created_at`),
  ADD KEY `idx_cpq_files_quote` (`quote_id`),
  ADD KEY `idx_cpq_files_order` (`order_id`),
  ADD KEY `idx_cpq_files_hash` (`sha256`);

--
-- Indexes for table `cp_web_quote_notifications`
--
ALTER TABLE `cp_web_quote_notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cpq_notif_request` (`request_id`),
  ADD KEY `idx_cpq_notif_unread` (`read_at`,`created_at`),
  ADD KEY `idx_cpq_notif_created` (`created_at`);

--
-- Indexes for table `cp_web_quote_requests`
--
ALTER TABLE `cp_web_quote_requests`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_web_quote_request_token` (`request_token`),
  ADD KEY `idx_cp_web_quote_request_status` (`status`),
  ADD KEY `idx_cp_web_quote_converted_quote` (`converted_quote_id`);

--
-- Indexes for table `cp_whatsapp_chats`
--
ALTER TABLE `cp_whatsapp_chats`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_cp_whatsapp_chats_chat_id` (`chat_id`),
  ADD KEY `idx_cp_whatsapp_chats_phone` (`phone`),
  ADD KEY `idx_cp_whatsapp_chats_customer` (`customer_id`),
  ADD KEY `idx_cp_whatsapp_chats_assigned` (`assigned_user_id`),
  ADD KEY `idx_cp_whatsapp_chats_status` (`status`),
  ADD KEY `idx_cp_whatsapp_chats_last_message` (`last_message_at`);

--
-- Indexes for table `cp_whatsapp_log`
--
ALTER TABLE `cp_whatsapp_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cp_whatsapp_log_order` (`order_id`),
  ADD KEY `idx_cp_whatsapp_log_quote` (`quote_id`),
  ADD KEY `idx_cp_whatsapp_log_customer` (`customer_id`),
  ADD KEY `idx_cp_whatsapp_log_created` (`created_at`),
  ADD KEY `fk_cp_whatsapp_log_user` (`prepared_by`);

--
-- Indexes for table `cp_whatsapp_messages`
--
ALTER TABLE `cp_whatsapp_messages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_cp_whatsapp_messages_whatsapp_id` (`whatsapp_message_id`),
  ADD KEY `idx_cp_whatsapp_messages_chat` (`chat_id`),
  ADD KEY `idx_cp_whatsapp_messages_date` (`message_at`),
  ADD KEY `idx_cp_whatsapp_messages_direction` (`direction`);

--
-- Indexes for table `cp_whatsapp_templates`
--
ALTER TABLE `cp_whatsapp_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_whatsapp_template_key` (`template_key`),
  ADD KEY `idx_cp_whatsapp_template_category` (`category`),
  ADD KEY `idx_cp_whatsapp_template_active` (`active`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cp_activity_log`
--
ALTER TABLE `cp_activity_log`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=747;

--
-- AUTO_INCREMENT for table `cp_categories`
--
ALTER TABLE `cp_categories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `cp_customers`
--
ALTER TABLE `cp_customers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1283;

--
-- AUTO_INCREMENT for table `cp_invoices`
--
ALTER TABLE `cp_invoices`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `cp_orders`
--
ALTER TABLE `cp_orders`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `cp_order_history`
--
ALTER TABLE `cp_order_history`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=251;

--
-- AUTO_INCREMENT for table `cp_order_items`
--
ALTER TABLE `cp_order_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91;

--
-- AUTO_INCREMENT for table `cp_order_photos`
--
ALTER TABLE `cp_order_photos`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `cp_order_production_briefs`
--
ALTER TABLE `cp_order_production_briefs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cp_order_production_checklist`
--
ALTER TABLE `cp_order_production_checklist`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cp_order_status`
--
ALTER TABLE `cp_order_status`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `cp_payments`
--
ALTER TABLE `cp_payments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `cp_payment_receipts`
--
ALTER TABLE `cp_payment_receipts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `cp_print_finishes`
--
ALTER TABLE `cp_print_finishes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `cp_print_jobs`
--
ALTER TABLE `cp_print_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cp_print_materials`
--
ALTER TABLE `cp_print_materials`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `cp_print_meter_logs`
--
ALTER TABLE `cp_print_meter_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `cp_print_prices`
--
ALTER TABLE `cp_print_prices`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `cp_print_price_rules`
--
ALTER TABLE `cp_print_price_rules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `cp_print_requests`
--
ALTER TABLE `cp_print_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `cp_print_request_items`
--
ALTER TABLE `cp_print_request_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `cp_print_rolls`
--
ALTER TABLE `cp_print_rolls`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `cp_print_sizes`
--
ALTER TABLE `cp_print_sizes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `cp_products`
--
ALTER TABLE `cp_products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `cp_product_images`
--
ALTER TABLE `cp_product_images`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `cp_product_inventory`
--
ALTER TABLE `cp_product_inventory`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cp_projects`
--
ALTER TABLE `cp_projects`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cp_promotions`
--
ALTER TABLE `cp_promotions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `cp_promotion_facebook`
--
ALTER TABLE `cp_promotion_facebook`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `cp_promotion_products`
--
ALTER TABLE `cp_promotion_products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `cp_quotes`
--
ALTER TABLE `cp_quotes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `cp_quote_condition_templates`
--
ALTER TABLE `cp_quote_condition_templates`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cp_quote_costs`
--
ALTER TABLE `cp_quote_costs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `cp_quote_items`
--
ALTER TABLE `cp_quote_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=152;

--
-- AUTO_INCREMENT for table `cp_quote_public_tokens`
--
ALTER TABLE `cp_quote_public_tokens`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `cp_quote_totals`
--
ALTER TABLE `cp_quote_totals`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;

--
-- AUTO_INCREMENT for table `cp_roles`
--
ALTER TABLE `cp_roles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cp_settings`
--
ALTER TABLE `cp_settings`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=244;

--
-- AUTO_INCREMENT for table `cp_shipping_methods`
--
ALTER TABLE `cp_shipping_methods`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cp_shipping_rules`
--
ALTER TABLE `cp_shipping_rules`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cp_tiktok_posts`
--
ALTER TABLE `cp_tiktok_posts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cp_tracking_tokens`
--
ALTER TABLE `cp_tracking_tokens`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `cp_users`
--
ALTER TABLE `cp_users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cp_web_checkout_sessions`
--
ALTER TABLE `cp_web_checkout_sessions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cp_web_quote_files`
--
ALTER TABLE `cp_web_quote_files`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `cp_web_quote_notifications`
--
ALTER TABLE `cp_web_quote_notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `cp_web_quote_requests`
--
ALTER TABLE `cp_web_quote_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `cp_whatsapp_chats`
--
ALTER TABLE `cp_whatsapp_chats`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `cp_whatsapp_log`
--
ALTER TABLE `cp_whatsapp_log`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

--
-- AUTO_INCREMENT for table `cp_whatsapp_messages`
--
ALTER TABLE `cp_whatsapp_messages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `cp_whatsapp_templates`
--
ALTER TABLE `cp_whatsapp_templates`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cp_invoices`
--
ALTER TABLE `cp_invoices`
  ADD CONSTRAINT `fk_cp_invoices_created_by` FOREIGN KEY (`created_by`) REFERENCES `cp_users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_invoices_customer` FOREIGN KEY (`customer_id`) REFERENCES `cp_customers` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_invoices_order` FOREIGN KEY (`order_id`) REFERENCES `cp_orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cp_invoices_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `cp_users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `cp_orders`
--
ALTER TABLE `cp_orders`
  ADD CONSTRAINT `fk_cp_orders_created_by` FOREIGN KEY (`created_by`) REFERENCES `cp_users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_orders_customer` FOREIGN KEY (`customer_id`) REFERENCES `cp_customers` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_orders_quote` FOREIGN KEY (`quote_id`) REFERENCES `cp_quotes` (`id`),
  ADD CONSTRAINT `fk_cp_orders_responsible` FOREIGN KEY (`responsible_user_id`) REFERENCES `cp_users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_orders_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `cp_users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `cp_order_history`
--
ALTER TABLE `cp_order_history`
  ADD CONSTRAINT `fk_cp_order_history_order` FOREIGN KEY (`order_id`) REFERENCES `cp_orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cp_order_history_user` FOREIGN KEY (`changed_by`) REFERENCES `cp_users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `cp_order_items`
--
ALTER TABLE `cp_order_items`
  ADD CONSTRAINT `fk_cp_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `cp_orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cp_order_items_quote_item` FOREIGN KEY (`quote_item_id`) REFERENCES `cp_quote_items` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `cp_order_photos`
--
ALTER TABLE `cp_order_photos`
  ADD CONSTRAINT `fk_cp_order_photos_created_by` FOREIGN KEY (`created_by`) REFERENCES `cp_users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_order_photos_order` FOREIGN KEY (`order_id`) REFERENCES `cp_orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cp_order_production_briefs`
--
ALTER TABLE `cp_order_production_briefs`
  ADD CONSTRAINT `fk_cp_order_production_briefs_approved_by` FOREIGN KEY (`design_approved_by`) REFERENCES `cp_users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_order_production_briefs_created_by` FOREIGN KEY (`created_by`) REFERENCES `cp_users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_order_production_briefs_order` FOREIGN KEY (`order_id`) REFERENCES `cp_orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cp_order_production_briefs_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `cp_users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `cp_order_production_checklist`
--
ALTER TABLE `cp_order_production_checklist`
  ADD CONSTRAINT `fk_cp_order_production_checklist_completed_by` FOREIGN KEY (`completed_by`) REFERENCES `cp_users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_order_production_checklist_order` FOREIGN KEY (`order_id`) REFERENCES `cp_orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cp_order_status`
--
ALTER TABLE `cp_order_status`
  ADD CONSTRAINT `fk_cp_order_status_order` FOREIGN KEY (`order_id`) REFERENCES `cp_orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cp_order_status_user` FOREIGN KEY (`updated_by`) REFERENCES `cp_users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `cp_payments`
--
ALTER TABLE `cp_payments`
  ADD CONSTRAINT `fk_cp_payments_created_by` FOREIGN KEY (`created_by`) REFERENCES `cp_users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_payments_customer` FOREIGN KEY (`customer_id`) REFERENCES `cp_customers` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_payments_order` FOREIGN KEY (`order_id`) REFERENCES `cp_orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cp_payments_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `cp_users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `cp_payment_receipts`
--
ALTER TABLE `cp_payment_receipts`
  ADD CONSTRAINT `fk_cp_payment_receipts_order` FOREIGN KEY (`order_id`) REFERENCES `cp_orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cp_payment_receipts_payment` FOREIGN KEY (`payment_id`) REFERENCES `cp_payments` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_payment_receipts_reviewed_by` FOREIGN KEY (`reviewed_by`) REFERENCES `cp_users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `cp_print_meter_logs`
--
ALTER TABLE `cp_print_meter_logs`
  ADD CONSTRAINT `fk_cp_print_meter_roll` FOREIGN KEY (`roll_id`) REFERENCES `cp_print_rolls` (`id`);

--
-- Constraints for table `cp_print_prices`
--
ALTER TABLE `cp_print_prices`
  ADD CONSTRAINT `fk_cp_price_finish` FOREIGN KEY (`finish_id`) REFERENCES `cp_print_finishes` (`id`),
  ADD CONSTRAINT `fk_cp_price_material` FOREIGN KEY (`material_id`) REFERENCES `cp_print_materials` (`id`),
  ADD CONSTRAINT `fk_cp_price_size` FOREIGN KEY (`size_id`) REFERENCES `cp_print_sizes` (`id`);

--
-- Constraints for table `cp_print_price_rules`
--
ALTER TABLE `cp_print_price_rules`
  ADD CONSTRAINT `fk_cp_print_price_rules_finish` FOREIGN KEY (`finish_id`) REFERENCES `cp_print_finishes` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_print_price_rules_material` FOREIGN KEY (`material_id`) REFERENCES `cp_print_materials` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_print_price_rules_size` FOREIGN KEY (`size_id`) REFERENCES `cp_print_sizes` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `cp_print_request_items`
--
ALTER TABLE `cp_print_request_items`
  ADD CONSTRAINT `fk_cp_print_request_items_file` FOREIGN KEY (`file_id`) REFERENCES `cp_web_quote_files` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_print_request_items_finish` FOREIGN KEY (`finish_id`) REFERENCES `cp_print_finishes` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_print_request_items_material` FOREIGN KEY (`material_id`) REFERENCES `cp_print_materials` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_print_request_items_request` FOREIGN KEY (`request_id`) REFERENCES `cp_web_quote_requests` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cp_print_request_items_rule` FOREIGN KEY (`price_rule_id`) REFERENCES `cp_print_price_rules` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_print_request_items_size` FOREIGN KEY (`size_id`) REFERENCES `cp_print_sizes` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `cp_product_images`
--
ALTER TABLE `cp_product_images`
  ADD CONSTRAINT `fk_cp_product_images_product` FOREIGN KEY (`product_id`) REFERENCES `cp_products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cp_product_inventory`
--
ALTER TABLE `cp_product_inventory`
  ADD CONSTRAINT `fk_cp_product_inventory_product` FOREIGN KEY (`product_id`) REFERENCES `cp_products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cp_promotions`
--
ALTER TABLE `cp_promotions`
  ADD CONSTRAINT `fk_cp_promotions_created_by` FOREIGN KEY (`created_by`) REFERENCES `cp_users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_promotions_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `cp_users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `cp_promotion_facebook`
--
ALTER TABLE `cp_promotion_facebook`
  ADD CONSTRAINT `fk_cp_promotion_facebook_promotion` FOREIGN KEY (`promotion_id`) REFERENCES `cp_promotions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cp_promotion_products`
--
ALTER TABLE `cp_promotion_products`
  ADD CONSTRAINT `fk_cp_promotion_products_product` FOREIGN KEY (`product_id`) REFERENCES `cp_products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cp_promotion_products_promotion` FOREIGN KEY (`promotion_id`) REFERENCES `cp_promotions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cp_quotes`
--
ALTER TABLE `cp_quotes`
  ADD CONSTRAINT `fk_cp_quotes_created_by` FOREIGN KEY (`created_by`) REFERENCES `cp_users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_quotes_customer` FOREIGN KEY (`customer_id`) REFERENCES `cp_customers` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_quotes_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `cp_users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `cp_quote_costs`
--
ALTER TABLE `cp_quote_costs`
  ADD CONSTRAINT `fk_cp_quote_costs_quote` FOREIGN KEY (`quote_id`) REFERENCES `cp_quotes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cp_quote_items`
--
ALTER TABLE `cp_quote_items`
  ADD CONSTRAINT `fk_cp_quote_items_quote` FOREIGN KEY (`quote_id`) REFERENCES `cp_quotes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cp_quote_public_tokens`
--
ALTER TABLE `cp_quote_public_tokens`
  ADD CONSTRAINT `fk_cp_quote_public_quote` FOREIGN KEY (`quote_id`) REFERENCES `cp_quotes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cp_quote_totals`
--
ALTER TABLE `cp_quote_totals`
  ADD CONSTRAINT `fk_cp_quote_totals_quote` FOREIGN KEY (`quote_id`) REFERENCES `cp_quotes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cp_shipping_rules`
--
ALTER TABLE `cp_shipping_rules`
  ADD CONSTRAINT `fk_cp_shipping_rules_method` FOREIGN KEY (`shipping_method_id`) REFERENCES `cp_shipping_methods` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cp_tracking_tokens`
--
ALTER TABLE `cp_tracking_tokens`
  ADD CONSTRAINT `fk_cp_tracking_order` FOREIGN KEY (`order_id`) REFERENCES `cp_orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cp_users`
--
ALTER TABLE `cp_users`
  ADD CONSTRAINT `fk_cp_users_role` FOREIGN KEY (`role_id`) REFERENCES `cp_roles` (`id`);

--
-- Constraints for table `cp_web_quote_requests`
--
ALTER TABLE `cp_web_quote_requests`
  ADD CONSTRAINT `fk_cp_web_quote_converted_quote` FOREIGN KEY (`converted_quote_id`) REFERENCES `cp_quotes` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `cp_whatsapp_chats`
--
ALTER TABLE `cp_whatsapp_chats`
  ADD CONSTRAINT `fk_cp_whatsapp_chats_assigned` FOREIGN KEY (`assigned_user_id`) REFERENCES `cp_users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_whatsapp_chats_customer` FOREIGN KEY (`customer_id`) REFERENCES `cp_customers` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `cp_whatsapp_log`
--
ALTER TABLE `cp_whatsapp_log`
  ADD CONSTRAINT `fk_cp_whatsapp_log_customer` FOREIGN KEY (`customer_id`) REFERENCES `cp_customers` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_whatsapp_log_order` FOREIGN KEY (`order_id`) REFERENCES `cp_orders` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_whatsapp_log_quote` FOREIGN KEY (`quote_id`) REFERENCES `cp_quotes` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cp_whatsapp_log_user` FOREIGN KEY (`prepared_by`) REFERENCES `cp_users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `cp_whatsapp_messages`
--
ALTER TABLE `cp_whatsapp_messages`
  ADD CONSTRAINT `fk_cp_whatsapp_messages_chat` FOREIGN KEY (`chat_id`) REFERENCES `cp_whatsapp_chats` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
