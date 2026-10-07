-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Oct 07, 2026 at 11:16 AM
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
(746, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-26 20:52:18'),
(747, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-27 06:03:10'),
(748, 1, 'update', 'production', 'Etapa actualizada para orden #21', '177.239.83.23', '2026-09-27 06:18:07'),
(749, 1, 'delete', 'web_quote_requests', 'Solicitud web CPQ-000022 eliminada', '177.239.83.23', '2026-09-27 07:09:51'),
(750, 1, 'delete', 'web_quote_requests', 'Solicitud web CPQ-000021 eliminada', '177.239.83.23', '2026-09-27 07:09:53'),
(751, 1, 'delete', 'web_quote_requests', 'Solicitud web CPQ-000020 eliminada', '177.239.83.23', '2026-09-27 07:09:55'),
(752, 1, 'delete', 'web_quote_requests', 'Solicitud web CPQ-000019 eliminada', '177.239.83.23', '2026-09-27 07:09:56'),
(753, 1, 'delete', 'web_quote_requests', 'Solicitud web CPQ-000018 eliminada', '177.239.83.23', '2026-09-27 07:09:58'),
(754, 1, 'delete', 'web_quote_requests', 'Solicitud web CPQ-000017 eliminada', '177.239.83.23', '2026-09-27 07:09:59'),
(755, 1, 'delete', 'web_quote_requests', 'Solicitud web CPQ-000008 eliminada', '177.239.83.23', '2026-09-27 07:10:00'),
(756, 1, 'delete', 'print_pricing', 'Catálogo de impresión eliminado: material #3', '177.239.83.23', '2026-09-27 07:38:03'),
(757, 1, 'update', 'print_pricing', 'Catálogo de impresión actualizado: finish #3', '177.239.83.23', '2026-09-27 07:38:20'),
(758, 1, 'delete', 'quotes', 'Cotización eliminada #55', '177.239.83.23', '2026-09-27 08:48:20'),
(759, 1, 'approve', 'quotes', 'Cotización CP-2026-00036 autorizada administrativamente.', '177.239.83.23', '2026-09-27 08:51:51'),
(760, 1, 'delete', 'quotes', 'Cotización eliminada #56', '177.239.83.23', '2026-09-27 08:52:46'),
(761, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-27 11:11:39'),
(762, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-27 18:14:59'),
(763, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-27 18:47:00'),
(764, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-27 19:15:16'),
(765, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-27 20:13:58'),
(766, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-27 23:24:44'),
(767, 1, 'update', 'production', 'Etapa actualizada para orden #32', '177.239.83.23', '2026-09-28 02:06:48'),
(768, 1, 'update', 'production', 'Etapa actualizada para orden #32', '177.239.83.23', '2026-09-28 02:06:51'),
(769, 1, 'update', 'production', 'Etapa actualizada para orden #32', '177.239.83.23', '2026-09-28 02:06:54'),
(770, 1, 'update', 'production', 'Etapa actualizada para orden #32', '177.239.83.23', '2026-09-28 02:06:57'),
(771, 1, 'update', 'production', 'Etapa actualizada para orden #32', '177.239.83.23', '2026-09-28 02:07:00'),
(772, 1, 'update', 'production', 'Etapa actualizada para orden #32', '177.239.83.23', '2026-09-28 02:07:05'),
(773, 1, 'update', 'production', 'Etapa actualizada para orden #32', '177.239.83.23', '2026-09-28 02:07:20'),
(774, 1, 'update', 'production', 'Etapa actualizada para orden #39', '177.239.83.23', '2026-09-28 02:07:31'),
(775, 1, 'update', 'production', 'Etapa actualizada para orden #39', '177.239.83.23', '2026-09-28 02:07:34'),
(776, 1, 'update', 'production', 'Etapa actualizada para orden #39', '177.239.83.23', '2026-09-28 02:07:37'),
(777, 1, 'update', 'production', 'Etapa actualizada para orden #39', '177.239.83.23', '2026-09-28 02:07:39'),
(778, 1, 'update', 'production', 'Etapa actualizada para orden #39', '177.239.83.23', '2026-09-28 02:07:42'),
(779, 1, 'update', 'production', 'Etapa actualizada para orden #39', '177.239.83.23', '2026-09-28 02:07:45'),
(780, 1, 'update', 'production', 'Etapa actualizada para orden #39', '177.239.83.23', '2026-09-28 02:07:50'),
(781, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-28 02:34:26'),
(782, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-28 02:34:31'),
(783, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-28 07:39:28'),
(784, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-28 08:24:26'),
(785, 1, 'delete', 'web_quote_requests', 'Solicitud web CPQ-000023 eliminada', '177.239.83.23', '2026-09-28 08:25:12'),
(786, 1, 'delete', 'quotes', 'Cotización eliminada #57', '177.239.83.23', '2026-09-28 08:25:50'),
(787, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-28 08:39:35'),
(788, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-28 09:14:25'),
(789, 1, 'delete', 'web_quote_requests', 'Solicitud web CPQ-000024 eliminada', '177.239.83.23', '2026-09-28 09:14:46'),
(790, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.14', '2026-09-28 10:03:03'),
(791, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-28 10:09:22'),
(792, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.14', '2026-09-28 11:17:51'),
(793, 1, 'create', 'quotes', 'Cotización creada #58', '200.68.164.14', '2026-09-28 11:24:00'),
(794, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-28 11:24:25'),
(795, 1, 'update', 'quotes', 'Cotización actualizada #58', '200.68.164.14', '2026-09-28 11:34:17'),
(796, 1, 'update', 'quotes', 'Estado de cotización actualizado #58 a approved', '200.68.164.14', '2026-09-28 11:34:26'),
(797, 1, 'update', 'quotes', 'Cotización actualizada #58', '200.68.164.14', '2026-09-28 11:35:24'),
(798, 1, 'update', 'quotes', 'Estado de cotización actualizado #58 a approved', '200.68.164.14', '2026-09-28 11:36:43'),
(799, 1, 'update', 'production', 'Etapa actualizada para orden #29', '177.239.83.23', '2026-09-28 12:13:42'),
(800, 1, 'update', 'production', 'Etapa actualizada para orden #29', '177.239.83.23', '2026-09-28 12:13:45'),
(801, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.14', '2026-09-28 12:15:16'),
(802, 1, 'update', 'quotes', 'Cotización actualizada #58', '200.68.164.14', '2026-09-28 12:16:08'),
(803, 1, 'create', 'orders', 'Orden creada OS-2026-00030 desde cotización #58', '200.68.164.14', '2026-09-28 12:19:22'),
(804, 1, 'create', 'orders', 'Archivo agregado a orden #40', '200.68.164.14', '2026-09-28 12:20:07'),
(805, 1, 'create', 'orders', 'Archivo agregado a orden #40', '200.68.164.14', '2026-09-28 12:20:28'),
(806, 1, 'create', 'orders', 'Archivo agregado a orden #40', '200.68.164.14', '2026-09-28 12:20:42'),
(807, 1, 'create', 'orders', 'Archivo agregado a orden #40', '200.68.164.14', '2026-09-28 12:21:05'),
(808, 1, 'delete', 'orders', 'Foto eliminada de orden #40', '200.68.164.14', '2026-09-28 12:21:12'),
(809, 1, 'create', 'orders', 'Archivo agregado a orden #40', '200.68.164.14', '2026-09-28 12:21:40'),
(810, 1, 'create', 'orders', 'Archivo agregado a orden #40', '200.68.164.14', '2026-09-28 12:22:22'),
(811, 1, 'create', 'invoices', 'Factura + CFDI registrados #4 · UUID 25D3DBFB-7B9C-4766-A824-C6BFE0A39ADE', '177.239.83.23', '2026-09-28 12:30:15'),
(812, 1, 'create', 'invoices', 'Factura + CFDI registrados #5 · UUID 586C8953-C9AB-434C-B469-59D815817DAF', '177.239.83.23', '2026-09-28 12:34:42'),
(813, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-28 12:58:14'),
(814, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.14', '2026-09-28 13:49:03'),
(815, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.14', '2026-09-28 13:49:07'),
(816, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-28 14:59:25'),
(817, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-28 15:57:47'),
(818, 1, 'update', 'invoices', 'Factura actualizada #5', '177.239.83.23', '2026-09-28 16:06:11'),
(819, 1, 'update', 'invoices', 'Factura actualizada #4', '177.239.83.23', '2026-09-28 16:06:15'),
(820, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-28 16:09:12'),
(821, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-28 16:59:56'),
(822, 1, 'update', 'quotes', 'Cotización actualizada #51', '177.239.83.23', '2026-09-28 17:00:48'),
(823, 1, 'create', 'orders', 'Orden creada OS-2026-00031 desde cotización #51', '177.239.83.23', '2026-09-28 17:01:07'),
(824, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-28 17:08:27'),
(825, 1, 'update', 'quotes', 'Cotización actualizada #51', '177.239.83.23', '2026-09-28 17:12:32'),
(826, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-28 18:12:12'),
(827, 1, 'update', 'quotes', 'Estado de cotización actualizado #45 a approved', '177.239.83.23', '2026-09-28 18:14:42'),
(828, 1, 'create', 'orders', 'Orden creada OS-2026-00032 desde cotización #45', '177.239.83.23', '2026-09-28 18:14:57'),
(829, 1, 'update', 'production', 'Etapa actualizada para orden #42', '177.239.83.23', '2026-09-28 18:15:33'),
(830, 1, 'update', 'production', 'Etapa actualizada para orden #42', '177.239.83.23', '2026-09-28 18:15:36'),
(831, 1, 'update', 'production', 'Etapa actualizada para orden #42', '177.239.83.23', '2026-09-28 18:15:38'),
(832, 1, 'update', 'production', 'Etapa actualizada para orden #42', '177.239.83.23', '2026-09-28 18:15:40'),
(833, 1, 'update', 'production', 'Etapa actualizada para orden #42', '177.239.83.23', '2026-09-28 18:15:42'),
(834, 1, 'update', 'production', 'Etapa actualizada para orden #42', '177.239.83.23', '2026-09-28 18:15:44'),
(835, 1, 'update', 'production', 'Etapa actualizada para orden #42', '177.239.83.23', '2026-09-28 18:15:46'),
(836, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-28 18:25:50'),
(837, 1, 'create', 'customers', 'Cliente #1283 creado', '177.239.83.23', '2026-09-28 18:26:50'),
(838, 1, 'create', 'quotes', 'Cotización creada #59', '177.239.83.23', '2026-09-28 18:30:12'),
(839, 1, 'update', 'quotes', 'Cotización actualizada #59', '177.239.83.23', '2026-09-28 18:31:26'),
(840, 1, 'update', 'quotes', 'Estado de cotización actualizado #59 a approved', '177.239.83.23', '2026-09-28 18:37:59'),
(841, 1, 'create', 'orders', 'Orden creada OS-2026-00033 desde cotización #59', '177.239.83.23', '2026-09-28 18:38:08'),
(842, 1, 'create', 'orders', 'Archivo agregado a orden #43', '177.239.83.23', '2026-09-28 18:39:25'),
(843, 1, 'create', 'orders', 'Archivo agregado a orden #43', '177.239.83.23', '2026-09-28 18:39:47'),
(844, 1, 'update', 'production', 'Etapa actualizada para orden #41', '177.239.83.23', '2026-09-28 18:39:50'),
(845, 1, 'create', 'orders', 'Archivo agregado a orden #43', '177.239.83.23', '2026-09-28 18:39:51'),
(846, 1, 'update', 'production', 'Etapa actualizada para orden #41', '177.239.83.23', '2026-09-28 18:39:53'),
(847, 1, 'delete', 'orders', 'Foto eliminada de orden #43', '177.239.83.23', '2026-09-28 18:40:01'),
(848, 1, 'create', 'invoices', 'Factura + CFDI registrados #6 · UUID F6855A9B-598F-4EE2-B1A9-906549FF36B3', '177.239.83.23', '2026-09-28 19:02:46'),
(849, 1, 'create', 'payments', 'Pago registrado #29', '177.239.83.23', '2026-09-28 19:25:35'),
(850, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.19', '2026-09-28 19:44:01'),
(851, 1, 'update', 'production', 'Etapa actualizada para orden #17', '200.68.164.19', '2026-09-28 19:45:52'),
(852, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-28 20:35:58'),
(853, 1, 'update', 'customers', 'Cliente #1209 actualizado', '177.239.83.23', '2026-09-28 20:46:12'),
(854, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-28 22:09:44'),
(855, 1, 'update', 'production', 'Etapa actualizada para orden #27', '177.239.83.23', '2026-09-28 22:18:41'),
(856, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-28 23:30:26'),
(857, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-29 07:45:22'),
(858, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.1', '2026-09-29 08:43:47'),
(859, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-29 08:44:19'),
(860, 1, 'update', 'production', 'Etapa actualizada para orden #18', '177.239.83.23', '2026-09-29 09:03:10'),
(861, 1, 'create', 'quotes', 'Cotización creada #60', '200.68.164.1', '2026-09-29 09:06:59'),
(862, 1, 'create', 'payments', 'Anticipo registrado para orden #40 por $1000.00', '177.239.83.23', '2026-09-29 09:25:38'),
(863, 1, 'update', 'production', 'Etapa actualizada para orden #40', '177.239.83.23', '2026-09-29 09:25:57'),
(864, 1, 'update', 'production', 'Etapa actualizada para orden #40', '177.239.83.23', '2026-09-29 09:28:06'),
(865, 1, 'update', 'production', 'Etapa actualizada para orden #40', '177.239.83.23', '2026-09-29 09:29:25'),
(866, 1, 'update', 'production', 'Etapa actualizada para orden #40', '177.239.83.23', '2026-09-29 09:29:28'),
(867, 1, 'update', 'production', 'Etapa actualizada para orden #40', '177.239.83.23', '2026-09-29 09:29:30'),
(868, 1, 'update', 'production', 'Etapa actualizada para orden #40', '177.239.83.23', '2026-09-29 09:29:33'),
(869, 1, 'update', 'production', 'Etapa actualizada para orden #40', '177.239.83.23', '2026-09-29 09:29:36'),
(870, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.1', '2026-09-29 09:44:43'),
(871, 1, 'update', 'quotes', 'Cotización actualizada #60', '200.68.164.1', '2026-09-29 09:46:10'),
(872, 1, 'delete', 'web_quote_requests', 'Solicitud web CPQ-000025 eliminada', '177.239.83.23', '2026-09-29 09:46:55'),
(873, 1, 'create', 'customers', 'Cliente #1284 creado', '200.68.164.1', '2026-09-29 09:48:43'),
(874, 1, 'create', 'quotes', 'Cotización creada #61', '200.68.164.1', '2026-09-29 09:51:11'),
(875, 1, 'create', 'customers', 'Cliente #1285 creado', '200.68.164.1', '2026-09-29 10:19:09'),
(876, 1, 'create', 'quotes', 'Cotización creada #62', '200.68.164.1', '2026-09-29 10:20:35'),
(877, 1, 'update', 'quotes', 'Estado de cotización actualizado #62 a approved', '200.68.164.1', '2026-09-29 10:20:48'),
(878, 1, 'create', 'customers', 'Cliente #1286 creado', '200.68.164.1', '2026-09-29 10:58:21'),
(879, 1, 'create', 'quotes', 'Cotización creada #63', '200.68.164.1', '2026-09-29 10:59:36'),
(880, 1, 'update', 'quotes', 'Estado de cotización actualizado #63 a approved', '200.68.164.1', '2026-09-29 10:59:45'),
(881, 1, 'update', 'quotes', 'Estado de cotización actualizado #63 a approved', '200.68.164.1', '2026-09-29 10:59:46'),
(882, 1, 'create', 'orders', 'Orden creada OS-2026-00034 desde cotización #63', '200.68.164.1', '2026-09-29 11:00:42'),
(883, 1, 'create', 'orders', 'Archivo agregado a orden #44', '200.68.164.1', '2026-09-29 11:01:24'),
(884, 1, 'create', 'payments', 'Anticipo registrado para orden #44 por $220.00', '200.68.164.1', '2026-09-29 11:01:49'),
(885, 1, 'create', 'customers', 'Cliente #1287 creado', '200.68.164.1', '2026-09-29 11:06:08'),
(886, 1, 'create', 'quotes', 'Cotización creada #64', '200.68.164.1', '2026-09-29 11:06:57'),
(887, 1, 'update', 'quotes', 'Estado de cotización actualizado #64 a approved', '200.68.164.1', '2026-09-29 11:07:07'),
(888, 1, 'create', 'orders', 'Orden creada OS-2026-00035 desde cotización #64', '200.68.164.1', '2026-09-29 11:07:57'),
(889, 1, 'create', 'orders', 'Archivo agregado a orden #45', '200.68.164.1', '2026-09-29 11:08:22'),
(890, 1, 'create', 'orders', 'Archivo agregado a orden #45', '200.68.164.1', '2026-09-29 11:08:30'),
(891, 1, 'delete', 'orders', 'Foto eliminada de orden #45', '200.68.164.1', '2026-09-29 11:08:40'),
(892, 1, 'create', 'orders', 'Archivo agregado a orden #45', '200.68.164.1', '2026-09-29 11:09:49'),
(893, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-29 11:17:21'),
(894, 1, 'update', 'quotes', 'Cotización actualizada #61', '200.68.164.1', '2026-09-29 11:17:49'),
(895, 1, 'create', 'payments', 'Anticipo registrado para orden #45 por $200.00', '200.68.164.1', '2026-09-29 11:21:36'),
(896, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.1', '2026-09-29 12:18:27'),
(897, 1, 'create', 'customers', 'Cliente #1288 creado', '200.68.164.1', '2026-09-29 12:19:19'),
(898, 1, 'create', 'quotes', 'Cotización creada #65', '200.68.164.1', '2026-09-29 12:20:19'),
(899, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.1', '2026-09-29 13:12:30'),
(900, 1, 'create', 'quotes', 'Cotización creada #66', '200.68.164.1', '2026-09-29 13:18:48'),
(901, 1, 'update', 'quotes', 'Estado de cotización actualizado #66 a approved', '200.68.164.1', '2026-09-29 13:19:04'),
(902, 1, 'create', 'orders', 'Orden creada OS-2026-00036 desde cotización #66', '200.68.164.1', '2026-09-29 13:19:13'),
(903, 1, 'create', 'orders', 'Archivo agregado a orden #46', '200.68.164.1', '2026-09-29 13:19:51'),
(904, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-29 16:20:56'),
(905, 1, 'update', 'production', 'Etapa actualizada para orden #43', '177.239.83.23', '2026-09-29 16:45:27'),
(906, 1, 'create', 'payments', 'Pago registrado #33', '177.239.83.23', '2026-09-29 16:46:15'),
(907, 1, 'update', 'quotes', 'Cotización actualizada #59', '177.239.83.23', '2026-09-29 16:58:51'),
(908, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-29 19:02:01'),
(909, 1, 'create', 'payments', 'Pago registrado #34', '177.239.83.23', '2026-09-29 19:04:33'),
(910, 1, 'update', 'orders', 'Comprobante de pago revisado para orden #46', '177.239.83.23', '2026-09-29 19:04:50'),
(911, 1, 'update', 'quotes', 'Estado de cotización actualizado #61 a approved', '177.239.83.23', '2026-09-29 19:06:46'),
(912, 1, 'create', 'orders', 'Orden creada OS-2026-00037 desde cotización #61', '177.239.83.23', '2026-09-29 19:07:16'),
(913, 1, 'create', 'payments', 'Pago registrado #35', '177.239.83.23', '2026-09-29 19:07:30'),
(914, 1, 'update', 'orders', 'Comprobante de pago revisado para orden #47', '177.239.83.23', '2026-09-29 19:08:49'),
(915, 1, 'update', 'production', 'Etapa actualizada para orden #47', '177.239.83.23', '2026-09-29 19:09:31'),
(916, 1, 'update', 'production', 'Etapa actualizada para orden #46', '177.239.83.23', '2026-09-29 19:09:37'),
(917, 1, 'update', 'production', 'Etapa actualizada para orden #44', '177.239.83.23', '2026-09-29 19:10:13'),
(918, 1, 'update', 'production', 'Etapa actualizada para orden #45', '177.239.83.23', '2026-09-29 19:10:24'),
(919, 1, 'login', 'auth', 'Inicio de sesión', '200.68.165.3', '2026-09-29 21:57:59'),
(920, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-29 23:01:59'),
(921, 1, 'create', 'quotes', 'Cotización creada #67', '177.239.83.23', '2026-09-29 23:03:33'),
(922, 1, 'update', 'quotes', 'Cotización actualizada #67', '177.239.83.23', '2026-09-29 23:04:24'),
(923, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-29 23:04:32'),
(924, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-30 10:53:17'),
(925, 1, 'update', 'production', 'Etapa actualizada para orden #47', '177.239.83.23', '2026-09-30 11:15:52'),
(926, 1, 'update', 'production', 'Etapa actualizada para orden #47', '177.239.83.23', '2026-09-30 11:15:54'),
(927, 1, 'update', 'production', 'Etapa actualizada para orden #47', '177.239.83.23', '2026-09-30 11:15:57'),
(928, 1, 'update', 'production', 'Etapa actualizada para orden #47', '177.239.83.23', '2026-09-30 11:16:00'),
(929, 1, 'login', 'auth', 'Inicio de sesión', '200.68.165.22', '2026-09-30 11:21:16'),
(930, 1, 'update', 'quotes', 'Cotización actualizada #62', '200.68.165.22', '2026-09-30 11:23:09'),
(931, 1, 'create', 'orders', 'Orden creada OS-2026-00038 desde cotización #62', '200.68.165.22', '2026-09-30 11:23:20'),
(932, 1, 'create', 'orders', 'Archivo agregado a orden #48', '200.68.165.22', '2026-09-30 11:23:59'),
(933, 1, 'create', 'payments', 'Anticipo registrado para orden #48 por $1000.00', '200.68.165.22', '2026-09-30 11:24:29'),
(934, 1, 'update', 'production', 'Etapa actualizada para orden #34', '177.239.83.23', '2026-09-30 11:51:35'),
(935, 1, 'update', 'production', 'Etapa actualizada para orden #34', '177.239.83.23', '2026-09-30 12:06:53'),
(936, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-30 15:15:59'),
(937, 1, 'update', 'production', 'Etapa actualizada para orden #24', '177.239.83.23', '2026-09-30 15:34:03'),
(938, 1, 'update', 'production', 'Etapa actualizada para orden #26', '177.239.83.23', '2026-09-30 15:34:19'),
(939, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-30 15:55:21'),
(940, 1, 'create', 'customers', 'Cliente #1289 creado', '177.239.83.23', '2026-09-30 15:56:37'),
(941, 1, 'create', 'quotes', 'Cotización creada #68', '177.239.83.23', '2026-09-30 16:02:19'),
(942, 1, 'update', 'quotes', 'Estado de cotización actualizado #68 a approved', '177.239.83.23', '2026-09-30 16:05:49'),
(943, 1, 'create', 'orders', 'Orden creada OS-2026-00039 desde cotización #68', '177.239.83.23', '2026-09-30 16:06:03'),
(944, 1, 'update', 'production', 'Etapa actualizada para orden #49', '177.239.83.23', '2026-09-30 16:10:35'),
(945, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-30 16:25:41'),
(946, 1, 'update', 'production', 'Etapa actualizada para orden #26', '177.239.83.23', '2026-09-30 16:25:49'),
(947, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-09-30 16:43:51'),
(948, 1, 'create', 'customers', 'Cliente #1290 creado', '177.239.83.23', '2026-09-30 16:47:36'),
(949, 1, 'create', 'quotes', 'Cotización creada #69', '177.239.83.23', '2026-09-30 16:49:44'),
(950, 1, 'update', 'quotes', 'Estado de cotización actualizado #69 a approved', '177.239.83.23', '2026-09-30 16:49:52'),
(951, 1, 'create', 'orders', 'Orden creada OS-2026-00040 desde cotización #69', '177.239.83.23', '2026-09-30 16:49:57'),
(952, 1, 'update', 'quotes', 'Cotización actualizada #69', '177.239.83.23', '2026-09-30 16:51:36'),
(953, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-01 05:43:02'),
(954, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-01 07:09:33'),
(955, 1, 'logout', 'auth', 'Cierre de sesión', '177.239.83.23', '2026-10-01 08:41:37'),
(956, 1, 'login', 'auth', 'Inicio de sesión', '2806:370:3198:9b13:8c26:9eff:fe9e:d4ba', '2026-10-01 08:43:21'),
(957, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-01 08:43:40'),
(958, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-01 14:08:13'),
(959, 1, 'create', 'customers', 'Cliente #1291 creado', '177.239.83.23', '2026-10-01 14:09:02'),
(960, 1, 'create', 'quotes', 'Cotización creada #70', '177.239.83.23', '2026-10-01 14:13:27'),
(961, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-01 14:42:12'),
(962, 1, 'update', 'quotes', 'Cotización actualizada #70', '177.239.83.23', '2026-10-01 14:43:44'),
(963, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-01 14:43:47'),
(964, 1, 'update', 'production', 'Etapa actualizada para orden #22', '177.239.83.23', '2026-10-01 14:54:26'),
(965, 1, 'update', 'production', 'Etapa actualizada para orden #22', '177.239.83.23', '2026-10-01 14:54:35'),
(966, 1, 'update', 'production', 'Etapa actualizada para orden #23', '177.239.83.23', '2026-10-01 14:54:59'),
(967, 1, 'update', 'production', 'Etapa actualizada para orden #47', '177.239.83.23', '2026-10-01 14:55:16'),
(968, 1, 'update', 'production', 'Etapa actualizada para orden #23', '177.239.83.23', '2026-10-01 14:55:56'),
(969, 1, 'update', 'production', 'Etapa actualizada para orden #22', '177.239.83.23', '2026-10-01 14:56:02'),
(970, 1, 'update', 'production', 'Etapa actualizada para orden #50', '177.239.83.23', '2026-10-01 15:04:04'),
(971, 1, 'update', 'production', 'Etapa actualizada para orden #50', '177.239.83.23', '2026-10-01 15:04:07'),
(972, 1, 'update', 'production', 'Etapa actualizada para orden #50', '177.239.83.23', '2026-10-01 15:04:08'),
(973, 1, 'update', 'production', 'Etapa actualizada para orden #50', '177.239.83.23', '2026-10-01 15:04:13'),
(974, 1, 'update', 'production', 'Etapa actualizada para orden #50', '177.239.83.23', '2026-10-01 15:04:35'),
(975, 1, 'update', 'production', 'Etapa actualizada para orden #50', '177.239.83.23', '2026-10-01 15:04:37'),
(976, 1, 'update', 'production', 'Etapa actualizada para orden #50', '177.239.83.23', '2026-10-01 15:04:39'),
(977, 1, 'update', 'production', 'Etapa actualizada para orden #50', '177.239.83.23', '2026-10-01 15:04:42'),
(978, 1, 'update', 'production', 'Etapa actualizada para orden #50', '177.239.83.23', '2026-10-01 15:04:43'),
(979, 1, 'update', 'production', 'Etapa actualizada para orden #50', '177.239.83.23', '2026-10-01 15:04:47'),
(980, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-01 17:07:56'),
(981, 1, 'update', 'production', 'Etapa actualizada para orden #41', '177.239.83.23', '2026-10-01 17:08:04'),
(982, 1, 'update', 'production', 'Etapa actualizada para orden #41', '177.239.83.23', '2026-10-01 17:08:08'),
(983, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-01 17:25:47'),
(984, 1, 'create', 'quotes', 'Cotización creada #71', '177.239.83.23', '2026-10-01 17:30:12'),
(985, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-01 17:46:44'),
(986, 1, 'update', 'quotes', 'Estado de cotización actualizado #71 a approved', '177.239.83.23', '2026-10-01 17:49:38'),
(987, 1, 'create', 'orders', 'Orden creada OS-2026-00041 desde cotización #71', '177.239.83.23', '2026-10-01 17:49:44'),
(988, 1, 'update', 'production', 'Etapa actualizada para orden #51', '177.239.83.23', '2026-10-01 17:50:36'),
(989, 1, 'create', 'customers', 'Cliente #1292 creado', '177.239.83.23', '2026-10-01 17:51:00'),
(990, 1, 'create', 'quotes', 'Cotización creada #72', '177.239.83.23', '2026-10-01 17:52:09'),
(991, 1, 'update', 'quotes', 'Estado de cotización actualizado #72 a approved', '177.239.83.23', '2026-10-01 17:52:20'),
(992, 1, 'create', 'orders', 'Orden creada OS-2026-00042 desde cotización #72', '177.239.83.23', '2026-10-01 17:52:26'),
(993, 1, 'update', 'production', 'Etapa actualizada para orden #52', '177.239.83.23', '2026-10-01 17:53:50'),
(994, 1, 'update', 'production', 'Etapa actualizada para orden #52', '177.239.83.23', '2026-10-01 17:55:37'),
(995, 1, 'update', 'production', 'Etapa actualizada para orden #52', '177.239.83.23', '2026-10-01 17:55:40'),
(996, 1, 'update', 'production', 'Etapa actualizada para orden #52', '177.239.83.23', '2026-10-01 17:55:42'),
(997, 1, 'update', 'production', 'Etapa actualizada para orden #52', '177.239.83.23', '2026-10-01 17:55:44'),
(998, 1, 'update', 'production', 'Etapa actualizada para orden #52', '177.239.83.23', '2026-10-01 17:55:46'),
(999, 1, 'update', 'production', 'Etapa actualizada para orden #52', '177.239.83.23', '2026-10-01 17:55:48'),
(1000, 1, 'update', 'production', 'Etapa actualizada para orden #52', '177.239.83.23', '2026-10-01 17:55:50'),
(1001, 1, 'create', 'customers', 'Cliente #1293 creado', '177.239.83.23', '2026-10-01 18:14:49'),
(1002, 1, 'login', 'auth', 'Inicio de sesión', '200.68.165.55', '2026-10-02 09:53:27'),
(1003, 1, 'create', 'quotes', 'Cotización creada #73', '200.68.165.55', '2026-10-02 09:55:45'),
(1004, 1, 'create', 'quotes', 'Cotización creada #74', '2806:108e:d:6a78:52d1:f725:afe:9811', '2026-10-02 10:16:25'),
(1005, 1, 'update', 'quotes', 'Estado de cotización actualizado #74 a approved', '2806:108e:d:6a78:52d1:f725:afe:9811', '2026-10-02 10:16:40'),
(1006, 1, 'create', 'orders', 'Orden creada OS-2026-00043 desde cotización #74', '2806:108e:d:6a78:52d1:f725:afe:9811', '2026-10-02 10:16:45'),
(1007, 1, 'create', 'orders', 'Archivo agregado a orden #53', '200.68.165.55', '2026-10-02 10:18:12'),
(1008, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-02 16:30:04'),
(1009, 1, 'update', 'quotes', 'Cotización actualizada #73', '177.239.83.23', '2026-10-02 16:31:22'),
(1010, 1, 'update', 'quotes', 'Cotización actualizada #73', '177.239.83.23', '2026-10-02 16:31:38'),
(1011, 1, 'update', 'quotes', 'Estado de cotización actualizado #73 a approved', '177.239.83.23', '2026-10-02 16:31:56'),
(1012, 1, 'update', 'quotes', 'Estado de cotización actualizado #73 a approved', '177.239.83.23', '2026-10-02 16:31:59'),
(1013, 1, 'create', 'orders', 'Orden creada OS-2026-00044 desde cotización #73', '177.239.83.23', '2026-10-02 16:32:22'),
(1014, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-02 18:04:31'),
(1015, 1, 'create', 'quotes', 'Cotización creada #75', '177.239.83.23', '2026-10-02 18:08:12'),
(1016, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-03 12:29:57'),
(1017, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-03 13:48:17'),
(1018, 1, 'create', 'customers', 'Cliente #1294 creado', '177.239.83.23', '2026-10-03 13:48:52'),
(1019, 1, 'create', 'quotes', 'Cotización creada #76', '177.239.83.23', '2026-10-03 13:50:10'),
(1020, 1, 'update', 'quotes', 'Estado de cotización actualizado #76 a approved', '177.239.83.23', '2026-10-03 13:50:20'),
(1021, 1, 'create', 'orders', 'Orden creada OS-2026-00045 desde cotización #76', '177.239.83.23', '2026-10-03 13:50:26'),
(1022, 1, 'create', 'customers', 'Cliente #1295 creado', '177.239.83.23', '2026-10-03 13:52:41'),
(1023, 1, 'create', 'quotes', 'Cotización creada #77', '177.239.83.23', '2026-10-03 13:53:15'),
(1024, 1, 'update', 'quotes', 'Estado de cotización actualizado #77 a approved', '177.239.83.23', '2026-10-03 13:53:24'),
(1025, 1, 'create', 'orders', 'Orden creada OS-2026-00046 desde cotización #77', '177.239.83.23', '2026-10-03 13:53:34'),
(1026, 1, 'create', 'orders', 'Archivo agregado a orden #56', '177.239.83.23', '2026-10-03 13:53:48'),
(1027, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-03 15:07:03'),
(1028, 1, 'create', 'quotes', 'Cotización creada #78', '177.239.83.23', '2026-10-03 15:28:34'),
(1029, 1, 'update', 'quotes', 'Estado de cotización actualizado #78 a approved', '177.239.83.23', '2026-10-03 15:28:43'),
(1030, 1, 'create', 'orders', 'Orden creada OS-2026-00047 desde cotización #78', '177.239.83.23', '2026-10-03 15:29:03'),
(1031, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-03 19:53:29'),
(1032, 1, 'update', 'production', 'Etapa actualizada para orden #43', '177.239.83.23', '2026-10-03 19:55:06'),
(1033, 1, 'update', 'production', 'Etapa actualizada para orden #43', '177.239.83.23', '2026-10-03 19:55:09'),
(1034, 1, 'update', 'production', 'Etapa actualizada para orden #43', '177.239.83.23', '2026-10-03 19:55:11'),
(1035, 1, 'update', 'production', 'Etapa actualizada para orden #43', '177.239.83.23', '2026-10-03 19:55:13'),
(1036, 1, 'update', 'production', 'Etapa actualizada para orden #43', '177.239.83.23', '2026-10-03 19:55:15'),
(1037, 1, 'update', 'production', 'Etapa actualizada para orden #34', '177.239.83.23', '2026-10-03 20:04:24'),
(1038, 1, 'update', 'production', 'Etapa actualizada para orden #34', '177.239.83.23', '2026-10-03 20:04:27'),
(1039, 1, 'update', 'production', 'Etapa actualizada para orden #34', '177.239.83.23', '2026-10-03 20:04:29'),
(1040, 1, 'update', 'production', 'Etapa actualizada para orden #22', '177.239.83.23', '2026-10-03 20:12:20'),
(1041, 1, 'update', 'production', 'Etapa actualizada para orden #46', '177.239.83.23', '2026-10-03 20:12:31'),
(1042, 1, 'update', 'production', 'Etapa actualizada para orden #46', '177.239.83.23', '2026-10-03 20:12:34'),
(1043, 1, 'update', 'production', 'Etapa actualizada para orden #46', '177.239.83.23', '2026-10-03 20:12:36'),
(1044, 1, 'update', 'production', 'Etapa actualizada para orden #46', '177.239.83.23', '2026-10-03 20:12:38'),
(1045, 1, 'update', 'production', 'Etapa actualizada para orden #46', '177.239.83.23', '2026-10-03 20:12:40'),
(1046, 1, 'update', 'production', 'Etapa actualizada para orden #50', '177.239.83.23', '2026-10-03 20:30:50'),
(1047, 1, 'create', 'payments', 'Anticipo registrado para orden #50 por $700.00', '177.239.83.23', '2026-10-03 20:30:59'),
(1048, 1, 'update', 'production', 'Etapa actualizada para orden #57', '177.239.83.23', '2026-10-03 20:33:29'),
(1049, 1, 'update', 'production', 'Etapa actualizada para orden #57', '177.239.83.23', '2026-10-03 20:33:32'),
(1050, 1, 'update', 'production', 'Etapa actualizada para orden #57', '177.239.83.23', '2026-10-03 20:33:35'),
(1051, 1, 'update', 'production', 'Etapa actualizada para orden #57', '177.239.83.23', '2026-10-03 20:33:37'),
(1052, 1, 'update', 'production', 'Etapa actualizada para orden #57', '177.239.83.23', '2026-10-03 20:33:44'),
(1053, 1, 'update', 'production', 'Etapa actualizada para orden #57', '177.239.83.23', '2026-10-03 20:33:47'),
(1054, 1, 'login', 'auth', 'Inicio de sesión', '200.68.164.26', '2026-10-03 23:34:50'),
(1055, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-04 08:42:57'),
(1056, 1, 'update', 'production', 'Etapa actualizada para orden #53', '177.239.83.23', '2026-10-04 08:43:32'),
(1057, 1, 'update', 'production', 'Etapa actualizada para orden #53', '177.239.83.23', '2026-10-04 08:43:34'),
(1058, 1, 'update', 'production', 'Etapa actualizada para orden #53', '177.239.83.23', '2026-10-04 08:43:37'),
(1059, 1, 'update', 'production', 'Etapa actualizada para orden #53', '177.239.83.23', '2026-10-04 08:43:39'),
(1060, 1, 'update', 'production', 'Etapa actualizada para orden #53', '177.239.83.23', '2026-10-04 08:43:41'),
(1061, 1, 'update', 'production', 'Etapa actualizada para orden #53', '177.239.83.23', '2026-10-04 08:43:43'),
(1062, 1, 'update', 'production', 'Etapa actualizada para orden #53', '177.239.83.23', '2026-10-04 08:43:46'),
(1063, 1, 'update', 'production', 'Etapa actualizada para orden #53', '177.239.83.23', '2026-10-04 08:43:49'),
(1064, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-04 09:10:09'),
(1065, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-04 11:49:23'),
(1066, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-04 13:18:22'),
(1067, 1, 'update', 'promotions', 'Promoción #3 guardada', '177.239.83.23', '2026-10-04 13:19:04'),
(1068, 1, 'update', 'promotions', 'Promoción #2 guardada', '177.239.83.23', '2026-10-04 13:19:31'),
(1069, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-04 13:24:39'),
(1070, 1, 'create', 'categories', 'Categoría #9 creada', '177.239.83.23', '2026-10-04 13:24:55'),
(1071, 1, 'create', 'products', 'Producto #4 creado', '177.239.83.23', '2026-10-04 13:25:48'),
(1072, 1, 'create', 'promotions', 'Promoción #4 guardada', '177.239.83.23', '2026-10-04 13:26:05'),
(1073, 1, 'update', 'products', 'Producto #4 actualizado', '177.239.83.23', '2026-10-04 13:32:38'),
(1074, 1, 'update', 'products', 'Producto #4 actualizado', '177.239.83.23', '2026-10-04 13:32:46'),
(1075, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-04 14:10:02'),
(1076, 1, 'update', 'production', 'Etapa actualizada para orden #51', '177.239.83.23', '2026-10-04 14:22:51'),
(1077, 1, 'update', 'production', 'Etapa actualizada para orden #51', '177.239.83.23', '2026-10-04 14:22:54'),
(1078, 1, 'update', 'production', 'Etapa actualizada para orden #51', '177.239.83.23', '2026-10-04 14:23:41'),
(1079, 1, 'update', 'production', 'Etapa actualizada para orden #51', '177.239.83.23', '2026-10-04 14:23:48'),
(1080, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-04 14:42:47'),
(1081, 1, 'create', 'customers', 'Cliente #1296 creado', '177.239.83.23', '2026-10-04 14:43:37'),
(1082, 1, 'create', 'quotes', 'Cotización creada #79', '177.239.83.23', '2026-10-04 14:45:11'),
(1083, 1, 'update', 'quotes', 'Estado de cotización actualizado #79 a approved', '177.239.83.23', '2026-10-04 14:45:25'),
(1084, 1, 'create', 'orders', 'Orden creada OS-2026-00048 desde cotización #79', '177.239.83.23', '2026-10-04 14:45:32'),
(1085, 1, 'create', 'orders', 'Archivo agregado a orden #58', '200.68.165.27', '2026-10-04 14:47:32'),
(1086, 1, 'create', 'orders', 'Archivo agregado a orden #58', '200.68.165.27', '2026-10-04 14:49:58'),
(1087, 1, 'update', 'production', 'Etapa actualizada para orden #58', '177.239.83.23', '2026-10-04 14:54:11'),
(1088, 1, 'update', 'production', 'Etapa actualizada para orden #58', '177.239.83.23', '2026-10-04 14:54:14'),
(1089, 1, 'update', 'production', 'Etapa actualizada para orden #58', '177.239.83.23', '2026-10-04 14:54:16'),
(1090, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-04 16:00:26'),
(1091, 1, 'create', 'payments', 'Anticipo registrado para orden #58 por $240.00', '177.239.83.23', '2026-10-04 16:00:52'),
(1092, 1, 'login', 'auth', 'Inicio de sesión', '200.68.165.35', '2026-10-05 09:54:54'),
(1093, 1, 'create', 'quotes', 'Cotización creada #80', '200.68.165.35', '2026-10-05 09:57:39'),
(1094, 1, 'update', 'quotes', 'Estado de cotización actualizado #80 a approved', '200.68.165.35', '2026-10-05 09:57:50'),
(1095, 1, 'create', 'orders', 'Orden creada OS-2026-00049 desde cotización #80', '200.68.165.35', '2026-10-05 09:57:55'),
(1096, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-05 16:31:05'),
(1097, 1, 'create', 'customers', 'Cliente #1297 creado', '177.239.83.23', '2026-10-05 16:32:06'),
(1098, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-05 16:33:30'),
(1099, 1, 'create', 'quotes', 'Cotización creada #81', '177.239.83.23', '2026-10-05 16:33:41'),
(1100, 1, 'update', 'quotes', 'Estado de cotización actualizado #81 a approved', '177.239.83.23', '2026-10-05 16:33:53'),
(1101, 1, 'create', 'orders', 'Orden creada OS-2026-00050 desde cotización #81', '177.239.83.23', '2026-10-05 16:34:04'),
(1102, 1, 'update', 'quotes', 'Estado de cotización actualizado #81 a approved', '177.239.83.23', '2026-10-05 16:34:21'),
(1103, 1, 'create', 'payments', 'Anticipo registrado para orden #60 por $1000.00', '177.239.83.23', '2026-10-05 16:34:43'),
(1104, 1, 'update', 'production', 'Etapa actualizada para orden #43', '177.239.83.23', '2026-10-05 16:44:56'),
(1105, 1, 'create', 'payments', 'Pago registrado #40', '177.239.83.23', '2026-10-05 16:45:11'),
(1106, 1, 'update', 'production', 'Etapa actualizada para orden #47', '177.239.83.23', '2026-10-05 16:45:23'),
(1107, 1, 'update', 'production', 'Etapa actualizada para orden #47', '177.239.83.23', '2026-10-05 16:45:23'),
(1108, 1, 'update', 'production', 'Etapa actualizada para orden #46', '177.239.83.23', '2026-10-05 16:45:39'),
(1109, 1, 'update', 'production', 'Etapa actualizada para orden #51', '177.239.83.23', '2026-10-05 16:46:07'),
(1110, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-05 17:52:12'),
(1111, 1, 'create', 'customers', 'Cliente #1298 creado', '177.239.83.23', '2026-10-05 17:53:11'),
(1112, 1, 'create', 'quotes', 'Cotización creada #82', '177.239.83.23', '2026-10-05 17:55:40'),
(1113, 1, 'update', 'quotes', 'Estado de cotización actualizado #82 a approved', '177.239.83.23', '2026-10-05 17:56:01'),
(1114, 1, 'create', 'orders', 'Orden creada OS-2026-00051 desde cotización #82', '177.239.83.23', '2026-10-05 17:56:27'),
(1115, 1, 'create', 'orders', 'Archivo agregado a orden #61', '177.239.83.23', '2026-10-05 17:57:11'),
(1116, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-05 18:00:11'),
(1117, 1, 'create', 'payments', 'Anticipo registrado para orden #61 por $395.00', '177.239.83.23', '2026-10-05 18:00:34'),
(1118, 1, 'create', 'quotes', 'Cotización creada #83', '177.239.83.23', '2026-10-05 18:30:36'),
(1119, 1, 'update', 'quotes', 'Estado de cotización actualizado #83 a approved', '177.239.83.23', '2026-10-05 18:31:24'),
(1120, 1, 'update', 'quotes', 'Estado de cotización actualizado #83 a approved', '177.239.83.23', '2026-10-05 18:31:32'),
(1121, 1, 'create', 'orders', 'Orden creada OS-2026-00052 desde cotización #83', '177.239.83.23', '2026-10-05 18:33:42'),
(1122, 1, 'create', 'orders', 'Archivo agregado a orden #62', '177.239.83.23', '2026-10-05 18:36:19'),
(1123, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-06 09:49:08'),
(1124, 1, 'update', 'production', 'Etapa actualizada para orden #41', '177.239.83.23', '2026-10-06 09:49:18'),
(1125, 1, 'update', 'production', 'Etapa actualizada para orden #54', '177.239.83.23', '2026-10-06 09:57:27'),
(1126, 1, 'login', 'auth', 'Inicio de sesión', '200.68.165.179', '2026-10-06 10:06:53'),
(1127, 1, 'create', 'customers', 'Cliente #1299 creado', '200.68.165.179', '2026-10-06 10:07:39'),
(1128, 1, 'create', 'quotes', 'Cotización creada #84', '200.68.165.179', '2026-10-06 10:09:25'),
(1129, 1, 'update', 'quotes', 'Cotización actualizada #84', '200.68.165.179', '2026-10-06 10:15:14'),
(1130, 1, 'login', 'auth', 'Inicio de sesión', '189.154.0.223', '2026-10-06 11:12:14'),
(1131, 1, 'create', 'quotes', 'Cotización creada #85', '189.154.0.223', '2026-10-06 11:15:35'),
(1132, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-06 12:07:50'),
(1133, 1, 'update', 'production', 'Etapa actualizada para orden #59', '177.239.83.23', '2026-10-06 12:08:09'),
(1134, 1, 'update', 'production', 'Etapa actualizada para orden #59', '177.239.83.23', '2026-10-06 12:08:12'),
(1135, 1, 'update', 'production', 'Etapa actualizada para orden #59', '177.239.83.23', '2026-10-06 12:08:14'),
(1136, 1, 'update', 'production', 'Etapa actualizada para orden #59', '177.239.83.23', '2026-10-06 12:08:16'),
(1137, 1, 'update', 'production', 'Etapa actualizada para orden #59', '177.239.83.23', '2026-10-06 12:08:18'),
(1138, 1, 'update', 'production', 'Etapa actualizada para orden #59', '177.239.83.23', '2026-10-06 12:08:20'),
(1139, 1, 'update', 'production', 'Etapa actualizada para orden #59', '177.239.83.23', '2026-10-06 12:08:22'),
(1140, 1, 'update', 'production', 'Etapa actualizada para orden #59', '177.239.83.23', '2026-10-06 12:08:24'),
(1141, 1, 'update', 'production', 'Etapa actualizada para orden #33', '177.239.83.23', '2026-10-06 12:09:28'),
(1142, 1, 'login', 'auth', 'Inicio de sesión', '2806:108e:d:1271:c894:dd0f:9d12:122e', '2026-10-06 13:14:43'),
(1143, 1, 'create', 'customers', 'Cliente #1300 creado', '2806:108e:d:1271:c894:dd0f:9d12:122e', '2026-10-06 13:15:49'),
(1144, 1, 'create', 'quotes', 'Cotización creada #86', '200.68.165.179', '2026-10-06 13:21:03'),
(1145, 1, 'login', 'auth', 'Inicio de sesión', '200.68.165.179', '2026-10-06 14:30:14'),
(1146, 1, 'create', 'quotes', 'Cotización creada #87', '200.68.165.179', '2026-10-06 14:33:08'),
(1147, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-06 15:35:50'),
(1148, 1, 'update', 'production', 'Etapa actualizada para orden #54', '177.239.83.23', '2026-10-06 15:36:07'),
(1149, 1, 'update', 'production', 'Etapa actualizada para orden #54', '177.239.83.23', '2026-10-06 15:36:07'),
(1150, 1, 'update', 'production', 'Etapa actualizada para orden #54', '177.239.83.23', '2026-10-06 15:36:10'),
(1151, 1, 'update', 'production', 'Etapa actualizada para orden #54', '177.239.83.23', '2026-10-06 15:36:13'),
(1152, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-06 15:58:04'),
(1153, 1, 'create', 'quotes', 'Cotización creada #88', '177.239.83.23', '2026-10-06 16:02:27'),
(1154, 1, 'update', 'quotes', 'Estado de cotización actualizado #88 a approved', '177.239.83.23', '2026-10-06 16:02:38'),
(1155, 1, 'create', 'orders', 'Orden creada OS-2026-00053 desde cotización #88', '177.239.83.23', '2026-10-06 16:03:22'),
(1156, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-06 18:22:03');
INSERT INTO `cp_activity_log` (`id`, `user_id`, `action`, `module`, `description`, `ip_address`, `created_at`) VALUES
(1157, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-06 19:08:46'),
(1158, 1, 'create', 'customers', 'Cliente #1301 creado', '177.239.83.23', '2026-10-06 19:12:57'),
(1159, 1, 'create', 'quotes', 'Cotización creada #89', '177.239.83.23', '2026-10-06 19:13:51'),
(1160, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-06 21:12:27'),
(1161, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-07 00:21:15'),
(1162, 1, 'update', 'production', 'Etapa actualizada para orden #61', '177.239.83.23', '2026-10-07 00:21:29'),
(1163, 1, 'update', 'production', 'Etapa actualizada para orden #61', '177.239.83.23', '2026-10-07 00:21:29'),
(1164, 1, 'update', 'production', 'Etapa actualizada para orden #63', '177.239.83.23', '2026-10-07 00:22:13'),
(1165, 1, 'update', 'production', 'Etapa actualizada para orden #63', '177.239.83.23', '2026-10-07 00:22:16'),
(1166, 1, 'update', 'production', 'Etapa actualizada para orden #63', '177.239.83.23', '2026-10-07 00:22:20'),
(1167, 1, 'update', 'production', 'Etapa actualizada para orden #63', '177.239.83.23', '2026-10-07 00:22:22'),
(1168, 1, 'update', 'production', 'Etapa actualizada para orden #63', '177.239.83.23', '2026-10-07 00:22:26'),
(1169, 1, 'update', 'production', 'Etapa actualizada para orden #26', '177.239.83.23', '2026-10-07 00:22:51'),
(1170, 1, 'update', 'production', 'Etapa actualizada para orden #26', '177.239.83.23', '2026-10-07 00:22:55'),
(1171, 1, 'update', 'production', 'Etapa actualizada para orden #26', '177.239.83.23', '2026-10-07 00:22:57'),
(1172, 1, 'update', 'production', 'Etapa actualizada para orden #22', '177.239.83.23', '2026-10-07 00:25:08'),
(1173, 1, 'update', 'production', 'Etapa actualizada para orden #23', '177.239.83.23', '2026-10-07 00:25:24'),
(1174, 1, 'update', 'production', 'Etapa actualizada para orden #23', '177.239.83.23', '2026-10-07 00:25:27'),
(1175, 1, 'update', 'quotes', 'Estado de cotización actualizado #87 a approved', '177.239.83.23', '2026-10-07 00:28:54'),
(1176, 1, 'update', 'quotes', 'Cotización actualizada #87', '177.239.83.23', '2026-10-07 00:30:16'),
(1177, 1, 'create', 'orders', 'Orden creada OS-2026-00054 desde cotización #87', '177.239.83.23', '2026-10-07 00:30:34'),
(1178, 1, 'login', 'auth', 'Inicio de sesión', '177.239.83.23', '2026-10-07 09:25:04'),
(1179, 1, 'update', 'production', 'Etapa actualizada para orden #22', '177.239.83.23', '2026-10-07 09:53:41'),
(1180, 1, 'update', 'production', 'Etapa actualizada para orden #23', '177.239.83.23', '2026-10-07 09:54:22'),
(1181, 1, 'create', 'payments', 'Pago registrado #42', '177.239.83.23', '2026-10-07 09:55:21'),
(1182, 1, 'create', 'payments', 'Pago registrado #43', '177.239.83.23', '2026-10-07 09:55:37'),
(1183, 1, 'update', 'production', 'Etapa actualizada para orden #58', '177.239.83.23', '2026-10-07 10:00:52'),
(1184, 1, 'update', 'production', 'Etapa actualizada para orden #58', '177.239.83.23', '2026-10-07 10:00:55'),
(1185, 1, 'update', 'production', 'Etapa actualizada para orden #58', '177.239.83.23', '2026-10-07 10:00:58'),
(1186, 1, 'login', 'auth', 'Inicio de sesión', '200.68.165.114', '2026-10-07 10:51:17'),
(1187, 1, 'create', 'customers', 'Cliente #1302 creado', '200.68.165.114', '2026-10-07 10:52:56'),
(1188, 1, 'create', 'quotes', 'Cotización creada #90', '200.68.165.114', '2026-10-07 10:54:17');

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
(8, 'SELLOS DE GOMA', 'product', 1, 0, '2026-09-22 12:04:20', '2026-09-22 12:04:20'),
(9, 'VINILO', 'product', 1, 0, '2026-10-04 13:24:55', '2026-10-04 13:24:55');

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
(1, 'local', NULL, 'LUIS GARDEA', 'Yogardea@outlook.com', 'GARL301182BBM6', '6271074512', 'C Alemania\r\n87', 'Hidalgo del Parral José López Portillo', '33820', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(2, 'local', NULL, 'Beatriz Chávez', NULL, NULL, '6271354103', NULL, 'Hidalgo del Parral', '33820', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(3, 'local', NULL, 'Itzel Dariana', NULL, NULL, '649 197 3143', 'Col. 20 de Noviembre', 'Guachochi', NULL, 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(4, 'local', NULL, 'Leticia Yazmin Salazar serrano', NULL, NULL, '6271171876', NULL, 'Hidalgo del Parral', '33820', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(5, 'local', NULL, 'Guadalupe Silva  Rueda', NULL, NULL, '627 111 4191', NULL, 'Hidalgo del Parral', '33820', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(6, 'local', NULL, 'CARSO INFRAESTRUCTURA Y CONSTRUCCION', 'mvadillo@condumex.com.mx', 'CIC991214L94', '6142327529', 'CALLE LAGO ZURICH\r\n245 EDIFICIO FRISCO\r\nAMPLIACION GRANADA', 'MIGUEL HIDALGO', '11529', 'CIUDAD DE MEXICO', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(7, 'local', NULL, 'Marely Ontiveros', NULL, NULL, '6271774403', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(8, 'local', NULL, 'LILIANA ORTIZ', 'ortiz-liliana@hotmail.com', NULL, '5545006497', 'C. SENDERO DE LA ALAMEDA No. 9\r\nCASA 4', 'MEXICO', '52934', 'ESTADO DE MEXICO', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(9, 'local', NULL, 'Marisela Mora Moreno', NULL, NULL, '6271509385', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(10, 'local', NULL, 'Rodrigo Chávez', NULL, NULL, '6275241520', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(11, 'local', NULL, 'Karmin Martìnez', NULL, NULL, '6275177922', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(12, 'local', NULL, 'Esc. Prim. María de la Cruz  Profr. Erick', NULL, NULL, '6567870958', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(13, 'local', NULL, 'Julia Varela', NULL, NULL, '627 279 6844', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(14, 'local', NULL, 'DIANA TORRES', NULL, NULL, '6271038001', NULL, 'HIDALGO DEL PARRAL', '33800', 'CHIHUAHUA', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(15, 'local', NULL, 'Clara Hernández', NULL, NULL, '627 150 7728', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(16, 'local', NULL, 'Ashley Martínez Rodríguez', NULL, NULL, '6271036390', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(17, 'local', NULL, 'Gonzalo Guerra', NULL, NULL, '6271745454', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(18, 'local', NULL, 'Benito Carrera', NULL, NULL, '627 114 4291', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(19, 'local', NULL, 'Flor', NULL, NULL, '639 147 1965', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(20, 'local', NULL, 'Miriam Villarreal', NULL, NULL, '627 133 1966', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(21, 'local', NULL, 'Carmen Lugo', NULL, NULL, '6271080194', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(22, 'local', NULL, 'Daniela Jiménez', NULL, NULL, '627 116 1150', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(23, 'local', NULL, 'Pamela RM MINERIA', NULL, NULL, '627 142 9155', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(24, 'local', NULL, 'Enrique Silva', NULL, NULL, '627 133 3310', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(25, 'local', NULL, 'Ana de la Cuz', NULL, NULL, '627 121 7220', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(26, 'local', NULL, 'Marìa Josè', NULL, NULL, '5545856421', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(28, 'local', NULL, 'ESCUELA SEC TEC 31', NULL, NULL, '6141252977', 'Anillo Periférico Luis Donaldo Colosio', 'Hidalgo del Parral', '33880', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(29, 'local', NULL, 'Edwin Iván Cervantes', 'edwin.cervantes@radarholding.com', NULL, '5527324354', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(30, 'local', NULL, 'Esc. Prim. Josef Solís de Lozoya 2156  Profr. José Luis', NULL, NULL, '6141639871', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(31, 'local', NULL, 'Marily Corral Irigoyen', NULL, NULL, '627 135 8100', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(32, 'local', NULL, 'Araceli Luna', NULL, NULL, '6271485877', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(33, 'local', NULL, 'Lluvia Villalobos', NULL, NULL, '614 494 8008', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(34, 'local', NULL, 'MAQUINADOS Y SOLDADURAS INDUSTRIALES MAYEROS S.A. DE C.V.', NULL, NULL, '922 212 4746', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(35, 'local', NULL, 'YAREMI VILLALOBOS', 'ventas@colibriprint.com.mx', NULL, '656 777 8597', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(36, 'local', NULL, 'MAQUINADOS Y SOLDADURAS INDUMAQUINADOS Y SOLDADURAS INDUSTRIALES MAYEROS S.A. DE C.V.STRIALES MAYEROS S.A. DE C.V.', NULL, NULL, '922 212 4746', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(37, 'local', NULL, 'María Guadalupe Bustillos Aguirre', 'mariedtorrs84@gmail.com', 'BUAG841115MCHIZ3', '6271489033', 'Real de Valladolid #7', 'Hidalgo del Parral', '33815', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(38, 'local', NULL, 'Esc. Prim. Est. Josefa Solís de Lozoya 2156', NULL, NULL, '6275221771', 'Calle Primera y  Juan Rangel #12\r\nCol. Altavista', 'Hidalgo del Parral, Chih.', '33860', 'Chih.', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(39, 'local', NULL, 'Miguel Ángel Rodríguez', NULL, NULL, '6275179105', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(40, 'local', NULL, 'Esteicy Barrón López', NULL, NULL, '656 167 3729', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(41, 'local', NULL, 'Araceli Barai', NULL, NULL, '6491960804', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(42, 'local', NULL, 'María de Jesús Sánchez Baca', NULL, NULL, '6271234990', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(43, 'local', NULL, 'Yolanda Monje', NULL, NULL, '627 150 4472', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(44, 'local', NULL, 'Alma Villalobos', NULL, NULL, '6566690976', 'Calle Alfareña #10\r\nCol. Centro', 'Parral', NULL, 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(45, 'local', NULL, 'Vianney Portillo', NULL, NULL, '6141258583', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(46, 'local', NULL, 'Escuela Primaria Felipe Ángeles', NULL, NULL, '656 595 9999', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(47, 'local', NULL, 'ELIZABETH TENIENTE', NULL, NULL, '6271159409', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(48, 'local', NULL, 'Esc. María de la Cruz Reyes Profr. Erik', NULL, NULL, '6567870958', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(49, 'local', NULL, 'Sección 20', NULL, NULL, '6271779282', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(50, 'local', NULL, 'Alondra González', NULL, NULL, '6271025569', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(51, 'local', NULL, 'Alejandra Meza', NULL, NULL, '6271321620', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(52, 'local', NULL, 'Allitzel A. Primero Valenzuela', NULL, NULL, '627 140 0862', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(53, 'local', NULL, 'Yaritzel Molina', NULL, NULL, '649 114 6862', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(54, 'local', NULL, 'Karmin', NULL, NULL, '627 517 7922', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(55, 'local', NULL, 'Daniel Castillo', NULL, NULL, '6271747551', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(56, 'local', NULL, 'Jorge Luis Bustillos Aguirre', NULL, NULL, '627 110 2567', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(57, 'local', NULL, 'GEOTEST Geotecnia y Supervisión Tècnica S.A. de C.V. Haidee Estefanía Contreras Pérez', NULL, NULL, '2281371713', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(58, 'local', NULL, 'A.P.F. J.N. Gabriel García Márquez', NULL, NULL, NULL, 'Municipio de Parral s/n', 'Parral', NULL, 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(59, 'local', NULL, 'María Salazar', NULL, NULL, '627 177 2826', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(60, 'local', NULL, 'Zulema Baeza', NULL, NULL, '627 144 9467', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(61, 'local', NULL, 'Yajaira Flores', NULL, NULL, '614 122 4022', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(62, 'local', NULL, 'Raquel Carrera', NULL, NULL, '6271237205', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(63, 'local', NULL, 'Eva Villegas', NULL, NULL, '627 122 2934', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(64, 'local', NULL, 'Karla Granados', NULL, NULL, '627 103 3929', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(65, 'local', NULL, 'Cinthia López', NULL, NULL, '627 142 9218', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(66, 'local', NULL, 'Lizbeth Canchola', NULL, NULL, '6271730702', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(67, 'local', NULL, 'Raúl Méndez', NULL, NULL, '6271130196', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(68, 'local', NULL, 'Yorlett', NULL, NULL, '627 143 2776', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(69, 'local', NULL, 'Claudia María Cervantes Villalobos', NULL, NULL, '627 139 5548', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(70, 'local', NULL, 'Nicol Valenzuela', 'fred.guillermo@gmail.com', NULL, '6563735317', 'Alemania 87\r\nLOMALINDA', 'Hidalgo del Parral', '33820', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(71, 'local', NULL, 'Yanet Chávez', NULL, NULL, '614 495 1415', NULL, 'Hidalgo del Parral', '33800', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(72, 'local', NULL, 'Glorisel Madrigal', 'gloriselmadrigal96@gmail.com', NULL, '6271037053', NULL, 'Hidalgo del Parral', NULL, 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(73, 'local', NULL, 'Ahylin Gutiérrez', NULL, NULL, '6271736233', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(74, 'local', NULL, 'Pepe Pichardo', 'delfin810321@hotmail.com', NULL, '6271506406', NULL, 'Hidalgo del Parral', NULL, 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(75, 'local', NULL, 'Flor Hernández', NULL, NULL, '627 131 9486', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(76, 'local', NULL, 'SERGIO SALVADOR MARTHA ARREDONDO', NULL, NULL, '6271782236', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(77, 'local', NULL, 'Cristina Monarrez', NULL, NULL, '6272790484', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(78, 'local', NULL, 'Janeth Monarrez', NULL, NULL, '627 517 6543', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(79, 'local', NULL, 'Berny Marquez', NULL, NULL, '627 521 5556', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(80, 'local', NULL, 'Cindy Domínguez Alonso', NULL, NULL, '614 444 9463', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(81, 'local', NULL, 'Ana Hernández', NULL, NULL, '627 139 3944', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(82, 'local', NULL, 'Verónica Madrigal', NULL, NULL, '627 115 1599', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(83, 'local', NULL, 'Karla Hernández', NULL, NULL, '627 148 7448', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(84, 'local', NULL, 'Sandra Cigarroa Olivas', NULL, NULL, '649 392 9561', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(85, 'local', NULL, 'José Amilano', NULL, NULL, '648 132 1566', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(86, 'local', NULL, 'Comercializadora de Refacciones y Mantenimiento', NULL, NULL, '627 121 4527', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(87, 'local', NULL, 'Yazmin Acosta', NULL, NULL, '6271043317', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(88, 'local', NULL, 'Marilu Carrón', NULL, NULL, '871 156 6321', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(90, 'local', NULL, 'Dora', NULL, NULL, '627 107 964', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(91, 'local', NULL, 'Claudia Mesta', NULL, NULL, '627 149 6907', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(92, 'local', NULL, 'Eneida Saenz', NULL, NULL, '6271476374', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(93, 'local', NULL, 'Gabriela Gardea', NULL, NULL, '627 106 9167', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(94, 'local', NULL, 'Angelli Rosas', NULL, NULL, '55 6063 0880', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(95, 'local', NULL, 'Mónica Martínez', NULL, NULL, '6271500984', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(98, 'local', NULL, 'Guillermo', NULL, NULL, '627 142 1834', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(99, 'local', NULL, 'Juan Fernando Ochoa', NULL, NULL, '656 626 5248', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(100, 'local', NULL, 'Angélica (Municipio Santa Bárbara)', NULL, NULL, '627 108 4172', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(101, 'local', NULL, 'Erika', NULL, NULL, '6271037867', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(102, 'local', NULL, 'Erika Samanta Guerrero Guerrero', NULL, NULL, '6271067179 y 6275233654', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(103, 'local', NULL, 'Mario Orquiz', NULL, NULL, '6271743497', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(104, 'local', NULL, 'Esc. Prim. Fed. Emiliano Zapata', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(105, 'local', NULL, 'Ana María Juárez Díaz', 'anamariajuarezdiaz@hotmail.com', NULL, '5518942250', 'Calle 6#106 ED.9 DEP.101 COL. AGRICOLA PANTITLAN DELG.', 'IZTACALCO', '08100', 'Ciudad de México', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(106, 'local', NULL, 'Judith Molina', NULL, NULL, '627 173 0714', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(107, 'local', NULL, 'Itzel', NULL, NULL, '6181565396', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(108, 'local', NULL, 'Berenice', NULL, NULL, '6271027767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(109, 'local', NULL, 'Lizbeth Ramos', NULL, NULL, '649 107 6610', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(110, 'local', NULL, 'Oscar', NULL, NULL, '6271128688', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(111, 'local', NULL, 'Sandra', NULL, NULL, '649 103 1800', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(112, 'local', NULL, 'Esc. Prim. Centenario del Ejército Mexicano', NULL, NULL, '6271213207', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(113, 'local', NULL, 'Yaneth Reyes', NULL, NULL, '6271211790', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(114, 'local', NULL, 'Sandra Cigarroa', NULL, NULL, '6491031800', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(115, 'local', NULL, 'Alma', NULL, NULL, '627 112 6118', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(116, 'local', NULL, 'Eden Méndez', NULL, NULL, '871 786 2350', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(117, 'local', NULL, 'Reyna Balbuena', NULL, NULL, '6271125152', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(118, 'local', NULL, 'Mónica Leticia Malanco Gutiérrez', 'lilith_monika@hotmail.com', NULL, '7226480311', 'Ejército de Oriente 123\r\nCol. Héroes del 5 de Mayo', 'Toluca', '5017', 'México', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(120, 'local', NULL, 'Guadalupe Chavez', NULL, NULL, '6271105090', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(121, 'local', NULL, 'Instituto Bostón Gabriela Gardea', NULL, NULL, '871 568 4148', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(122, 'local', NULL, 'Martín Humberto Aguirre Arzola', NULL, NULL, '6271216504', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(123, 'local', NULL, 'José Méndez', NULL, NULL, '6144623590', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(124, 'local', NULL, 'José Guadalupe Méncez', NULL, NULL, '614 462 3590', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(125, 'local', NULL, 'Brenda Ontiveros', NULL, NULL, '6271034334', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(126, 'local', NULL, 'Elizabeth Morales', NULL, NULL, '6271064484', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(127, 'local', NULL, 'Pao (Bubble Bar)', NULL, NULL, '6271400840', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(128, 'local', NULL, 'Edeèn Varela', NULL, NULL, '6271313272', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(129, 'local', NULL, 'Angélica Holguín', NULL, NULL, '6291063459', NULL, 'Jiménez', NULL, 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(130, 'local', NULL, 'Flor Guzmán', NULL, NULL, '6275171410', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(131, 'local', NULL, 'CARLOS GALVAN', 'carlosenriquegg30@gmail.com', NULL, '6271030748', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(132, 'local', NULL, 'Carolina Ramírez', NULL, NULL, '6271082626', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(133, 'local', NULL, 'Sarah', NULL, NULL, '6271047289', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(134, 'local', NULL, 'Movimiento Familiar Cristiano Diocesis Parral', NULL, NULL, '627 104 6620', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(135, 'local', NULL, 'Amilcar Nava Bailón', NULL, NULL, '6143343182', 'Calle 20 de noviembre #18\r\nreferencia a un lado de dulcería', 'Parral', NULL, 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(136, 'local', NULL, 'Patricia Moreno', NULL, NULL, '6271086591', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(137, 'local', NULL, 'Rocio Rubio', 'Shiorubio2424@gmail.com', NULL, '627 113 9802', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(138, 'local', NULL, 'Carlos Garcia', NULL, NULL, '627 177 4253', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(139, 'local', NULL, 'Soledad Aguirre', NULL, NULL, '627 139 3171', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(140, 'local', NULL, 'Carmen Verónica Hernández', NULL, NULL, '6271475545', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(141, 'local', NULL, 'Merlisa', NULL, NULL, '8711091892', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(142, 'local', NULL, 'Diana Núñez', NULL, NULL, '627 123 1389', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(143, 'local', NULL, 'Elizabeth Chávez Del Toro', NULL, NULL, '6271488209', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(144, 'local', NULL, 'Marcela Vazque Gomez', NULL, NULL, '6271123525', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(145, 'local', NULL, 'Sandra Muñoz', NULL, NULL, '6143634347', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(146, 'local', NULL, 'Esc. Prim. Ignacio Allende', 'hugoivanurangaavalos@gmial.com', NULL, '6565858937', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(147, 'local', NULL, 'Dania García', NULL, NULL, '6143457138', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(148, 'local', NULL, 'Samanta Holguin', NULL, NULL, '627 133 7779', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(149, 'local', NULL, 'Claudia María Cervantes', NULL, NULL, '6271395548', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(150, 'local', NULL, 'Alejandra Duarte', NULL, NULL, '627 115 7512', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(151, 'local', NULL, 'Marily Corral', NULL, NULL, '627 135 8100', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(153, 'local', NULL, 'MIREYA RODRIGUEZ', NULL, NULL, '6271040573', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(154, 'local', NULL, 'Homero Nava', NULL, NULL, '6491033922', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(155, 'local', NULL, 'Eva', NULL, NULL, '627 111 9600', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(156, 'local', NULL, 'Diana Rodríguez Salas', NULL, NULL, '6275172150', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(157, 'local', NULL, 'Ivon', NULL, NULL, '6271177192', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(158, 'local', NULL, 'Adriana Hernández', NULL, NULL, '627 139 2846', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(159, 'local', NULL, 'Nubia Alondra Chávez', NULL, NULL, '627 112 8408', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(160, 'local', NULL, 'Ivette', NULL, NULL, '627 113 4993', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(161, 'local', NULL, 'Yaretzi', NULL, NULL, '627 104 1826', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(162, 'local', NULL, 'Jessica Lizeth Vicente Garcia', NULL, NULL, '664 362 2156', 'Calle de las fuentes #12462 col. 20 de noviembre,', 'Tijuana B.C.', '22100', 'Baja California', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(163, 'local', NULL, 'Irvin Esparza', NULL, NULL, '6272799391', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(164, 'local', NULL, 'Omar Gómez', NULL, NULL, '627 150 7675', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(165, 'local', NULL, 'Esc. Prim. Ma. Brisia Rodríguez', NULL, NULL, '627 113 3333', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(166, 'local', NULL, 'Rocio', NULL, NULL, '614 373 4701', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(167, 'local', NULL, 'Laura Hernández', NULL, NULL, '6271117298', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(168, 'local', NULL, 'Esc. Prim. Centenario del Ejército Mexicano', NULL, NULL, '6271049835', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(169, 'local', NULL, 'Andrea Soto', NULL, NULL, '6271144483', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(170, 'local', NULL, 'Lore Coronado', NULL, NULL, '627 279 8826', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(171, 'local', NULL, 'Ana Rodríguez', NULL, NULL, '6271443005', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(172, 'local', NULL, 'J.N. Jesús Lozoya Solís #1127', NULL, NULL, '627 113 7667', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(173, 'local', NULL, 'Luis Payan', NULL, NULL, '656 704 2713', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(174, 'local', NULL, 'Carolina García Gutiérrez', NULL, NULL, '6271213331', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(175, 'local', NULL, 'Marilú', NULL, NULL, '627 139 9730', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(176, 'local', NULL, 'Esc. Sec. Tec. #70', NULL, NULL, '6271543973', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(177, 'local', NULL, 'Javier', NULL, NULL, '6271779051', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(178, 'local', NULL, 'Jonathan', NULL, NULL, '6271780925', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(179, 'local', NULL, 'Perla Nallely Saenz Bustillos', NULL, NULL, '6271437936', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(180, 'local', NULL, 'Esc. Prim. Jesús González Ortega', NULL, NULL, '6271507728', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(181, 'local', NULL, 'Ervey Rubio', NULL, NULL, '627 517 0287', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(182, 'local', NULL, 'Enedina Pérez', NULL, NULL, '627 143 5122', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(183, 'local', NULL, 'Esc. Profa Carmen Tarín Ibarra', NULL, NULL, '627 104 9311', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(184, 'local', NULL, 'Barbadoa IAN', NULL, NULL, '6272797834', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(185, 'local', NULL, 'Jesús Carbajal', NULL, NULL, '6271219050', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(186, 'local', NULL, 'Geisa Saenz', NULL, NULL, '6141155681', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(187, 'local', NULL, 'CENTRO DE INTERVENCION EN CRISIS ALMA CALMA AC', NULL, NULL, '614 523 0454', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(188, 'local', NULL, 'Fernando', NULL, NULL, '627 147 1916', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(189, 'local', NULL, 'Yuridia Gastelum', NULL, NULL, '627 132 9497', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(190, 'local', NULL, 'Liliana Cañez', NULL, NULL, '627 177 4144', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(191, 'local', NULL, 'EZEQUIEL ORQUIZ', NULL, NULL, '6271216554', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(192, 'local', NULL, 'Ana Flores', NULL, NULL, '6271125178', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(193, 'local', NULL, 'Primaria Emiliano Zapata', NULL, NULL, '6141020760', 'Venceremos y Che Guevara s/n Col. Tierra y Libertad', 'Jiménez', NULL, 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(194, 'local', NULL, 'Noemi', NULL, NULL, '6278895844', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(195, 'local', NULL, 'Kevin valverde', NULL, NULL, '6271398651', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(196, 'local', NULL, 'Lourdes Chávez', NULL, NULL, '627 103 5309', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(197, 'local', NULL, 'Eden Varela', NULL, NULL, '6271313272', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(198, 'local', NULL, 'Amparo', NULL, NULL, '2283231767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(199, 'local', NULL, 'Luz del Carmen', NULL, NULL, '627 111 3652', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(200, 'local', NULL, 'Mercedes Solís', NULL, NULL, '627 517 8693', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(201, 'local', NULL, 'María Guzmán  Grupo Abreu', NULL, NULL, '55 3888 7332', NULL, 'México Delegación Coyoacán', NULL, 'México', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(202, 'local', NULL, 'Alexis Rodríguez', NULL, NULL, '627 119 5317', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(203, 'local', NULL, 'Elsa Tarin', NULL, NULL, '6271231891', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(204, 'local', NULL, 'Leslie Hernandez', NULL, NULL, '6291092461', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(205, 'local', NULL, 'Pedro Corral', NULL, NULL, '6291091302', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(206, 'local', NULL, 'Susana Gardea', NULL, NULL, '6271107702', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(207, 'local', NULL, 'Eloy', NULL, NULL, '4421390936', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(208, 'local', NULL, 'Brenda Molina', NULL, NULL, '6275215615', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(209, 'local', NULL, 'Anai Carbajal Morales', NULL, NULL, '656 222 3483', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(210, 'local', NULL, 'Hospital de ginecoobstetricia Parral', NULL, NULL, '614 607 6259', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(211, 'local', NULL, 'Andrea Granados', NULL, NULL, '6271033929', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(212, 'local', NULL, 'Alondra', NULL, NULL, '6271335817', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(213, 'local', NULL, 'Guadalupe Salgado', NULL, NULL, '627 521 2651', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(214, 'local', NULL, 'Misael Ramos', NULL, NULL, '6271354980', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(215, 'local', NULL, 'Elizabeth Arciniega', NULL, NULL, '627 521 2974', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(216, 'local', NULL, 'Jaquelin Montes', NULL, NULL, '6271025522', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(217, 'local', NULL, 'Paty chavira', NULL, NULL, '627 174 9665', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(218, 'local', NULL, 'Irais Domínguez', 'irais@onetoonegroup.mx', NULL, '+52 1 55 2363 1974', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(219, 'local', NULL, 'Ana Gabriela Toledo Hernández', NULL, NULL, '+52 1 777 218 7839', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(220, 'local', NULL, 'Francisco Javier', NULL, NULL, '6271323455', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(222, 'local', NULL, 'Cosme Baca', NULL, NULL, '6271138696', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(223, 'local', NULL, 'Thelma Ogaz', NULL, NULL, '6271057210', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(224, 'local', NULL, 'Tecnológico de Parral  Con atención al Ing. Juan José Mora  Jefe de recursos materiales', NULL, NULL, '627 123 6857', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(225, 'local', NULL, 'Oscar Solís', NULL, NULL, '+1 (720) 988-9476', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(226, 'local', NULL, 'Lizeth Barajas', NULL, NULL, '6271053943', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(227, 'local', NULL, 'Yazmin Carreon', NULL, NULL, '627 131 1654', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(228, 'local', NULL, 'Leticia Palomares', NULL, NULL, '6271089648', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(229, 'local', NULL, 'Arely Martínez', NULL, NULL, '656 329 8971', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(230, 'local', NULL, 'Fedra Teniente', NULL, NULL, '6271159409', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(231, 'local', NULL, 'Alondra Lazos', NULL, NULL, '6271136398', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(232, 'local', NULL, 'Guadalupe Alberto', NULL, NULL, '5564462208', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(233, 'local', NULL, 'Indian motorcycle Agencia cdmx', NULL, NULL, '+52 55 6565 7058', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(234, 'local', NULL, 'Esly', NULL, NULL, '6562142405', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(235, 'local', NULL, 'Mayra Vargas', NULL, NULL, '627 106 7938', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(236, 'local', NULL, 'Josue Arellanes', NULL, NULL, '627 889 6997', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(237, 'local', NULL, 'Nancy Méndez', NULL, NULL, '627 113 7667', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(238, 'local', NULL, 'Judith Gardea', NULL, NULL, '627 119 4507', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(239, 'local', NULL, 'Ana Gonzalez Loera', NULL, NULL, '6271087730', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(240, 'local', NULL, 'Daniela', NULL, NULL, '627 107 9334', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(241, 'local', NULL, 'Yaneth', NULL, NULL, '627 111 0073', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(242, 'local', NULL, 'Carolina', NULL, NULL, '5541920292', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(243, 'local', NULL, 'Jorge', NULL, NULL, '55 1333 5864', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(244, 'local', NULL, 'Esc. Prim. Vicente Guerrero', NULL, NULL, '627 102 0723', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(245, 'local', NULL, 'Esc. Prim. Jesùs González Ortega', NULL, NULL, '6271234990', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(246, 'local', NULL, 'Ma. Jesùs Sánchez', NULL, NULL, '6271234990', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(247, 'local', NULL, 'Ervey Rubio', NULL, NULL, '6275170287', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(248, 'local', NULL, 'Erika Bustillos', 'erikamitzy@gmail.com', 'BUAE8208274R5', '+526271470053', 'ALEMANIA 87', 'HIDALGO DEL PARRAL', '33820', 'CHIHUAHUA', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(249, 'local', NULL, 'luis gardea', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(250, 'local', NULL, 'Diana', NULL, NULL, '6271060146', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(251, 'local', NULL, 'Alfredo Tortillería Dan y Omar', NULL, NULL, '6271237907', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(252, 'local', NULL, 'Esc. Prim. Ma. Brisia Rodriguez', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(253, 'local', NULL, 'María José Fonseca García', NULL, NULL, '5554312535', 'C. Tiburcio Sánchez de la Barquera ·116 interior 508\r\nBenito Juárez. Colonia Merced Juárez', 'Ciudad de México', '03930', 'Mèxico', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(254, 'local', NULL, 'Yuli Ramirez', NULL, NULL, '433 105 3847', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(255, 'local', NULL, 'JOAQUIN MEDINA', NULL, NULL, '+1 480 650 7926', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(256, 'local', NULL, 'Salma', NULL, NULL, '6275209949', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(257, 'local', NULL, 'CLAUDIA', NULL, NULL, '627 108 2209', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(258, 'local', NULL, 'VIOLETA RUIZ', NULL, NULL, '627 114 2818', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(259, 'local', NULL, 'Melida', NULL, NULL, '627 110 4468', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(260, 'local', NULL, 'Jorge Tamayo Bustillos', NULL, NULL, '6271192730', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(261, 'local', NULL, 'Susana Silva (Jardín de niños Miguel Hidalgo)', NULL, NULL, '627 139 9489', 'Guadalupe y Calvo', NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(262, 'local', NULL, 'Sergio', NULL, NULL, '627 104 6620', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(263, 'local', NULL, 'Angel Silva', NULL, NULL, '6275218294', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(264, 'local', NULL, 'Gabriel Urbina', NULL, NULL, '627 142 6793', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(265, 'local', NULL, 'Jhony', NULL, NULL, '6271234108', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(266, 'local', NULL, 'Cecilia Frías', NULL, NULL, '6271151801', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(267, 'local', NULL, 'Faviola Rodriguez', NULL, NULL, '+52 1 55 3462 6933', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(268, 'local', NULL, 'Julieta Carrillo', NULL, NULL, '6271396611', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(269, 'local', NULL, 'Jazmin Tarin Soto', NULL, NULL, '6272791739', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(270, 'local', NULL, 'Jazmín Tarin Soto (tesorera)', NULL, NULL, '627 279 1739', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(271, 'local', NULL, 'Lizbett Cereceres', NULL, NULL, '6271034971', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(272, 'local', NULL, 'Rocio Luna Gardea', NULL, NULL, '6143734701', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(273, 'local', NULL, 'Carniceria Carrillo', NULL, NULL, '6741013745', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(274, 'local', NULL, 'Tejidos locales Agroalimentarios en Red', NULL, NULL, '55 5963 7661', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(275, 'local', NULL, 'Jenni', NULL, NULL, '6271215465', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(276, 'local', NULL, 'Merced Gutiérrez', NULL, NULL, '6271238632', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(277, 'local', NULL, 'Yaritza', NULL, NULL, '6271446225', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(278, 'local', NULL, 'Edgar Rosas', NULL, NULL, '6563125423', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(279, 'local', NULL, 'Ocote Premium', NULL, NULL, '6271330947', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(280, 'local', NULL, 'Karla Mendez', NULL, NULL, '6271200642', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(281, 'local', NULL, 'Alexa Escarcega', NULL, NULL, '6271153453', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(282, 'local', NULL, 'Adriana Medina', NULL, NULL, '6272790093', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(283, 'local', NULL, 'Rocio Garcia', NULL, NULL, '6271030748', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(284, 'local', NULL, 'Mariana (TEXA)', NULL, NULL, '8715070367', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(285, 'local', NULL, 'Telesecundaria', NULL, NULL, '6271494978', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(286, 'local', NULL, 'Esmeralda Anahi Carrillo Ramos', NULL, NULL, '6741013745', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(287, 'local', NULL, 'Janeth Saenz', NULL, NULL, '6271110073', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(288, 'local', NULL, 'Laura Ríos', NULL, NULL, '627 144 1521', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(289, 'local', NULL, 'Daniela Sotelo', NULL, NULL, '627 111 8390', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(290, 'local', NULL, 'Daniela', NULL, NULL, '627 111 8390', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(291, 'local', NULL, 'Gloria Herrera', NULL, NULL, '6271176103', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(292, 'local', NULL, 'Veronica de la O', NULL, NULL, '627 114 6399', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(293, 'local', NULL, 'Lia Lee', NULL, NULL, '614 289 7217', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(294, 'local', NULL, 'Chantal Gutierréz', NULL, NULL, '627 143 7440', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(295, 'local', NULL, 'Johana Guzman', NULL, NULL, '627 139 7669', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(296, 'local', NULL, 'Dulce Armendariz', NULL, NULL, '6271029959', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(297, 'local', NULL, 'Carla Chávez', NULL, NULL, '627 108 8429', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(298, 'local', NULL, 'Julieta Morales', NULL, NULL, '629 103 6794', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(299, 'local', NULL, 'Celeste Ochoa', NULL, NULL, '6271065774', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(300, 'local', NULL, 'Brenda', NULL, NULL, '627 131 0473', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(301, 'local', NULL, 'Claudia Yesenia Arreola Rodriguez', NULL, NULL, '6271429987', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(302, 'local', NULL, 'Nayib', NULL, NULL, '627 105 2926', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(303, 'local', NULL, 'Ervey Rubio', NULL, NULL, '627 517 0287', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(304, 'local', NULL, 'Itzel', NULL, NULL, '627 102 0723', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(305, 'local', NULL, 'Mario', NULL, NULL, '627 115 9920', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(306, 'local', NULL, 'Fernando', NULL, NULL, '627 108 8346', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(307, 'local', NULL, 'Itzel Carrera', NULL, NULL, '6271484084', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(308, 'local', NULL, 'Alex', NULL, NULL, '627 143 9025', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(309, 'local', NULL, 'Sandra', NULL, NULL, '627 279 5634', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(310, 'local', NULL, 'Alejandra', NULL, NULL, '627 173 2636', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(311, 'local', NULL, 'Vanely', NULL, NULL, '627 143 8180', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(312, 'local', NULL, 'Sol', NULL, NULL, '627 113 2340', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(313, 'local', NULL, 'Elisa Chàvez', NULL, NULL, '6491037422', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(314, 'local', NULL, 'Elizabeth', NULL, NULL, '6271488209', NULL, 'Jiménez', NULL, 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(315, 'local', NULL, 'Perla Aracely Villezcas Ramos', NULL, NULL, '614 2775 353', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(316, 'local', NULL, 'Lorenzo Antonio', NULL, NULL, '6271130903', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(317, 'local', NULL, 'Alma Moya', NULL, NULL, '6271235656', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(318, 'local', NULL, 'Erika Valenzuela', NULL, NULL, '6271038712', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(319, 'local', NULL, 'Suhey Mata Publicidad', NULL, NULL, '871 523 7508', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(320, 'local', NULL, 'Alondra Tarin', NULL, NULL, '627 133 5817', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(321, 'local', NULL, 'Erika Elizabeth Bustillos Aguirre', NULL, NULL, '627 147 0053', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24');
INSERT INTO `cp_customers` (`id`, `source_type`, `source_id`, `name`, `email`, `tax_number`, `phone`, `address`, `city`, `zip_code`, `state`, `country`, `notes`, `enabled`, `created_at`, `updated_at`) VALUES
(322, 'local', NULL, 'Karla Jazmin Martinez Torres', NULL, NULL, '627 149 7077', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(323, 'local', NULL, 'Crece con Vales', NULL, NULL, '6271120983', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(324, 'local', NULL, 'Profesora Delil Aguirre', NULL, NULL, '6271154064', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(325, 'local', NULL, 'Profr. Gerardo Rodriguez', NULL, NULL, '627 117 0819', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(326, 'local', NULL, 'Luz', NULL, NULL, '614 123 2399', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(327, 'local', NULL, 'Rocio Escalante', NULL, NULL, '627 279 6767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(328, 'local', NULL, 'Sergio', NULL, NULL, '6271332582', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(329, 'local', NULL, 'Diosmar', NULL, NULL, '6341108391', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(330, 'local', NULL, 'Analy Valenzuela', NULL, NULL, '627 107 4848', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(331, 'local', NULL, 'Enrique Carrera', NULL, NULL, '6271125767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(332, 'local', NULL, 'ARIZONA el estado del gran cañon', NULL, NULL, '2222388764', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(333, 'local', NULL, 'Anahi Lozano', NULL, NULL, '6271021195', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(334, 'local', NULL, 'Laura Peinado', NULL, NULL, '6565734434', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(335, 'local', NULL, 'Reyna', NULL, NULL, '6271331122', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(336, 'local', NULL, 'Christian Galan', NULL, NULL, '52 1 55 9190 3512', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(337, 'local', NULL, 'Aaron Bustillos', NULL, NULL, '627 111 5366', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(338, 'local', NULL, 'Suhey Mata', NULL, NULL, '8715237508', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(339, 'local', NULL, 'Myrna Sáenz', NULL, NULL, '6272794894', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(340, 'local', NULL, 'MacLean Mèxico /  Eloy', NULL, NULL, '+52 1 442 139 0936', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(341, 'local', NULL, 'Fundación Dondé  / Dannyel Jamin Morales Bonilla', 'demorales.bec@frd.org.mx', NULL, '9999707550 ext 1437', 'Av. Independencia #310 \r\nCol. Centro', 'Hidalgo del Parral', '33800', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(342, 'local', NULL, 'Mayra Brito', NULL, NULL, '627 117 2239', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(343, 'local', NULL, 'Rosendo Carrilo', NULL, NULL, '627 150 9182', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(344, 'local', NULL, 'Ayled Castillo Lazos', NULL, NULL, '627 177 1568', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(345, 'local', NULL, 'Claudia Prieto', NULL, NULL, '614 216 3745', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(346, 'local', NULL, 'Edith Núñez', NULL, NULL, '6271046644', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(347, 'local', NULL, 'Iván Rodríguez', NULL, NULL, '614 209 8597', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(348, 'local', NULL, 'Diana Quintana', NULL, NULL, '6145467930', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(349, 'local', NULL, 'María de la Luz Sevares', NULL, NULL, '55 5401 0805', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(350, 'local', NULL, 'Claudia Karina Vargas campos', NULL, NULL, '627 133 2600', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(351, 'local', NULL, 'Gabriel López Chávez', NULL, NULL, '627 133 2600', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(352, 'local', NULL, 'Alondra Suarez', NULL, NULL, '627 131 4436', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(353, 'local', NULL, 'Vanesa Chaparro', NULL, NULL, '6271437270', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(354, 'local', NULL, 'Angel Ramos', NULL, NULL, '627 177 7421', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(355, 'local', NULL, 'Jorge', NULL, NULL, '627 151 9139', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(356, 'local', NULL, 'Georgina Chávez', NULL, NULL, '627 524 1176', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(357, 'local', NULL, 'Rebeca', NULL, NULL, '627 115 6284', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(358, 'local', NULL, 'Omilba Duarte', NULL, NULL, '627 148 8821', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(359, 'local', NULL, 'Christian Giovanny', NULL, NULL, '52 1 951 231 4196', 'Escuela Naval 407, esquina amapolas, Colina Reforma\r\nNegocio de comida D´Villatortas', 'Oaxaca', '68050', 'Oaxaca de Juárez', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(360, 'local', NULL, 'Selene Molina', NULL, NULL, '6672684614', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(361, 'local', NULL, 'Adriana Lozano Reyes', NULL, NULL, '656 551 1843', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(362, 'local', NULL, 'Olga Auday', NULL, NULL, '5626448317', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(363, 'local', NULL, 'José Manuel Bosquez Alarcón', NULL, NULL, '6271178615', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(364, 'local', NULL, 'Gobierno del Estado de Chihuahua', NULL, NULL, '656 777 8597', 'Venustiano Carranza 601', 'Chihuahua', '31350', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(366, 'local', NULL, 'Elotes San Ángel', NULL, NULL, '627 120 5242', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(367, 'local', NULL, 'Zenet Pineda', NULL, NULL, '6271399643', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(368, 'local', NULL, 'Zulema Saldaña', NULL, NULL, '6271023023', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(369, 'local', NULL, 'Fabiola Gamboa', NULL, NULL, '999 194 8787', 'CALLE 46 #488 POR 57 Y 59 CENTRO , \r\n\r\nOFICINA MUEBLES ANTEA  , EDIFICIO AZUL CON GRIS HORARIO DE 10 A 4', 'MERIDA', '97000', 'YUCATÁN', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(370, 'local', NULL, 'Jesús Armando Pacheco', NULL, NULL, '614 192 9840', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(371, 'local', NULL, 'Perla Peña', NULL, NULL, '6275177886', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(372, 'local', NULL, 'Betty', NULL, NULL, '627 102 1023', 'Esc. Prim. Club de Leones', NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(373, 'local', NULL, 'Mari Soto', NULL, NULL, '627 521 6737', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(374, 'local', NULL, 'Patricia Salgado', NULL, NULL, '627 147 3670', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(375, 'local', NULL, 'Julián Ibarra López', NULL, NULL, '6561903168', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(376, 'local', NULL, 'Sec. 34', NULL, NULL, '6271066922', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(377, 'local', NULL, 'Esc. Ma Brisia Rodríguez', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(378, 'local', NULL, 'Miryam Muñoz', NULL, NULL, '6271484402', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(379, 'local', NULL, 'Anahi', NULL, NULL, '6271120971', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(380, 'local', NULL, 'Lina Delgado', NULL, NULL, '6271471074', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(381, 'local', NULL, 'Brenda Bailon', NULL, NULL, '627 113 1802', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(382, 'local', NULL, 'ELYMSA', NULL, NULL, '+52 649 104 3888', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(383, 'local', NULL, 'Wilma Josselyn Ayala Lazos', NULL, NULL, '6271047955', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(384, 'local', NULL, 'Wilma J Ayala Lazos', NULL, NULL, '6271775490', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(385, 'local', NULL, 'Diego Díaz', NULL, NULL, '+52 1 442 833 6203', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(386, 'local', NULL, 'Vianey Dominguez Delgado', NULL, NULL, '6271122872', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(387, 'local', NULL, 'Guillermina Guzmán', NULL, NULL, '5512881014', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(388, 'local', NULL, 'Daiana Loya', NULL, NULL, '627 108 6944', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(389, 'local', NULL, 'Armando Cobos', NULL, NULL, '627 174 7548', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(390, 'local', NULL, 'Anabel Gutiérrez', NULL, NULL, '6271338171', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(391, 'local', NULL, 'Teresita', NULL, NULL, '6271317924', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(392, 'local', NULL, 'Blanca Estela Olivas Trujillo', NULL, NULL, '627 123 6511', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(393, 'local', NULL, 'CARO', NULL, NULL, '5582049341', 'HAMBURGO 213\r\nPISO 10\r\nCOL. JUAREZ', 'DELEGACION CUAHUTEMOC', '06600', 'CDMX', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(394, 'local', NULL, 'BLANCA RODRIGUEZ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(395, 'local', NULL, 'Alejandra Corona Hernández', NULL, NULL, '6491049222', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(396, 'local', NULL, 'Alely Jazmín', NULL, NULL, '6271126108', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(397, 'local', NULL, 'Irasema Barrón', NULL, NULL, '6271444471', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(398, 'local', NULL, 'BLANCA RODRIGUEZ', NULL, NULL, '6275245961', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(399, 'local', NULL, 'Myrna Nájera', NULL, NULL, '6271491096', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(400, 'local', NULL, 'Alicia', NULL, NULL, '6271035813', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(401, 'local', NULL, 'Yanira Ramos', NULL, NULL, '6271488821', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(402, 'local', NULL, 'Alonso', NULL, NULL, '627 212 8970', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(403, 'local', NULL, 'Isis Muñoz', NULL, NULL, '6271423136', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(404, 'local', NULL, 'Marcos Saenz', NULL, NULL, '+52 618 260 3414', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(405, 'local', NULL, 'Mtra Gaby', NULL, NULL, '+52 627 517 8208', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(406, 'local', NULL, 'Ana Carolina Valles Duarte', NULL, NULL, '+52 627 104 1005', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(407, 'local', NULL, 'COMERCIALIZADORA ROCAS SA DE CV', NULL, NULL, '+52 833 311 9089', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(408, 'local', NULL, 'Claudia Figueroa', NULL, NULL, '+52 55 3273 3995', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(409, 'local', NULL, 'Leonardo Olmeda', NULL, NULL, '6491132206', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(411, 'local', NULL, 'Laura Zamarton', NULL, NULL, '6271041484', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(412, 'local', NULL, 'Yadhira Abigail Loya flores', NULL, NULL, '+52 627 131 4236', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(413, 'local', NULL, 'Angel', NULL, NULL, '+52 627 135 3550', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(414, 'local', NULL, 'Felix', NULL, NULL, '+52 614 403 4942', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(415, 'local', NULL, 'Abraham Soveranis', NULL, NULL, '99994079251', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(416, 'local', NULL, 'Kasey Chavira', NULL, NULL, '925 272 8082', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(417, 'local', NULL, 'Jessica Puerto Cardeña', 'Jpuerto.bec@frd.org.mx', NULL, '(999) 9407550 ext 1432', 'Calle 60 x 35 #346 Edificio Paseo 60 Col. Centro', 'Mérida', '97000', 'Yucatán', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(418, 'local', NULL, 'RUTILO ROMAN LÓPEZ', 'roman_uaaan@hotmail.com', NULL, '523329721523', 'CRUCERO JOJOTEPEC', 'JALISCO', NULL, 'GUADALAJARA', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(419, 'local', NULL, 'Adriana Pèrez', NULL, NULL, '6271152175', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(420, 'local', NULL, 'Diana Sifuentes', NULL, NULL, '6271494793', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(421, 'local', NULL, 'Ilse Luna', NULL, NULL, '6275210739', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(422, 'local', NULL, 'Anahí Frausto', NULL, NULL, '6291230068', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(423, 'local', NULL, 'Gladys Muniz', NULL, NULL, '6271137055', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(424, 'local', NULL, 'Laura Escobar', NULL, NULL, '+52 627 144 0120', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(425, 'local', NULL, 'ALEJANDRA ONTIVEROS CANO', NULL, NULL, '6271483799', 'OJITO DURANGO', 'DURANGO', NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(426, 'local', NULL, 'Esc, Prim. Ignaco Allende', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(427, 'local', NULL, 'Esc. Prim, Vicente Guerrero', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(428, 'local', NULL, 'Luisito Gardea', 'luisgardea2311@gmail.com', NULL, '6271074548', 'CIRCUITO MONTE GOLGOTA, FRACC. TERRANOVA SUR', 'JUÁREZ', '32576', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(429, 'local', NULL, 'Maribel Medina', NULL, NULL, '+52 998 705 6777', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(430, 'local', NULL, 'Escuela Primaria Ford 190 T.M', NULL, NULL, '627 150 0140', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(431, 'local', NULL, 'INNOVA PROMOCIONALES', NULL, 'IPR970219NE1', '+52 1 55 1256 8422', 'ALFONSO ESPARZA OTEO\r\nPRIMER PISO', 'ALVARO OBREGON', '01020', 'ALVARO OBREGON', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(432, 'local', NULL, 'Efrain', NULL, NULL, '6271024615', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(433, 'local', NULL, 'Margarita Arrieta', NULL, NULL, '+52 627 149 4152', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(434, 'local', NULL, 'Tania Ramírez', NULL, NULL, '6391149077', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(435, 'local', NULL, 'Ashley', NULL, NULL, '+52 627 103 6390', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(436, 'local', NULL, 'Brenda Rodriguez', NULL, NULL, '6271124607', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(437, 'local', NULL, 'Abdiel Sandoval', NULL, NULL, '52 1 33 1147 6361', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(438, 'local', NULL, 'Lusito', 'luisgardeabustillos1@gmail.com', NULL, '6271074512', 'ALEMANIA #87, PROLONGACIÓN PARÍS, PROLONGACIÓN PARÍS', 'HIDALGO DEL PARRAL', '33820', 'CHIHUAHUA', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(439, 'local', NULL, 'Jardín de Niños Bertha Aguilera Baca', NULL, NULL, '6271239559', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(440, 'local', NULL, 'Luis Baca', NULL, NULL, '627173003', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(441, 'local', NULL, 'Esc Centenario del Ejército Mexicano', NULL, NULL, '+52 627 113 7005', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(442, 'local', NULL, 'Esmeralda Loera', NULL, NULL, '6271235303', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(443, 'local', NULL, 'Victor Vázquez', NULL, NULL, '6271117298', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(444, 'local', NULL, 'Andrea Holguin', NULL, NULL, '6271324670', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(445, 'local', NULL, 'MINPRO', NULL, NULL, '+52 614 190 5176', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(446, 'local', NULL, 'Melissa Minerva Murillo Morín', NULL, NULL, '+52 1 844 122 6677', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(447, 'local', NULL, 'Isamar Cervantes', NULL, NULL, '6491137119', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(448, 'local', NULL, 'Alessia Frisoni', NULL, NULL, '4427327936', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(449, 'local', NULL, 'Nayeli Almanza', NULL, NULL, '627 174 9290', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(450, 'local', NULL, 'Jessica', NULL, NULL, '5565280381', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(451, 'local', NULL, 'Jazmin', NULL, NULL, '6271171876', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(452, 'local', NULL, 'Jorge', NULL, NULL, '6271519139', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(453, 'local', NULL, 'Multiservicios RR', NULL, NULL, '+52 627 147 3810', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(454, 'local', NULL, 'Saira Ayala', NULL, NULL, '+52 627 112 6301', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(455, 'local', NULL, 'Yancarlo', NULL, NULL, '+52 627 177 9565', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(456, 'local', NULL, 'Adriana Nuñez', NULL, NULL, '+52 627 119 2148', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(457, 'local', NULL, 'Abril García', NULL, NULL, '6271041466', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(458, 'local', NULL, 'Jassel Nuñez', NULL, NULL, '6271331507', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(459, 'local', NULL, 'Marisol', NULL, NULL, '+52 649 110 7188', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(460, 'local', NULL, 'Ivan Fabela', NULL, NULL, '+52 627 143 3164', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(461, 'local', NULL, 'Isamar Juárez Atonal', 'especialista.compras8@ciudadmaderas.com', NULL, '+52 442 320 5528', 'Desarrollo CMQRO:\r\nANILLO VIAL III OTE,  EL MARQUES, QUERÉTARO, C.P. 76246\r\n\r\nDesarrollo CDMSLP:\r\nW383+W9 Jesús María, 79530 S.L.P.', NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(462, 'local', NULL, 'Alejandra', NULL, NULL, '+52 649 104 9222', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(463, 'local', NULL, 'Abraham HOLGUIN', NULL, NULL, '614 313 0597', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(464, 'local', NULL, 'Alinka Zaragoza', NULL, NULL, '+52 627 133 1873', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(465, 'local', NULL, 'Arely', NULL, NULL, '+52 627 521 3324', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(466, 'local', NULL, 'Farmacias Similares', NULL, NULL, '+52 627 279 5070', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(467, 'local', NULL, 'Berenice Aguirre', NULL, NULL, '6271087040', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(468, 'local', NULL, 'Laura Fraire', NULL, NULL, '+52 627 112 9658', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(469, 'local', NULL, 'Escuela Josefa Solís de Lozoya', NULL, NULL, '627 112 6760', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(470, 'local', NULL, 'ADRIANA', 'auxventas1@mlmproductos.com', NULL, '6565795622', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(471, 'local', NULL, 'Georgina Unda', NULL, NULL, '6271488352', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(472, 'local', NULL, 'Ivanna Meza', NULL, NULL, '6271170295', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(473, 'local', NULL, 'Ángel Gutierrez Burciaga', NULL, NULL, '6271212420', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(474, 'local', NULL, 'Lizbeth Chaparro', NULL, NULL, '6272795942', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(475, 'local', NULL, 'Uriel Sánchez', NULL, NULL, '6181136054', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(476, 'local', NULL, 'Lizeth Monarrez', NULL, NULL, '6271335921', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(477, 'local', NULL, 'Laura Aguilera', NULL, NULL, '6271778352', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(478, 'local', NULL, 'Angela Gamez Aguirre', NULL, NULL, '5271236825', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(479, 'local', NULL, 'Nicole Martinez', NULL, NULL, '6271492038', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(480, 'local', NULL, 'Araceli Arzola', NULL, NULL, '+52 627 112 2758', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(481, 'local', NULL, 'Francia Lomeli', NULL, NULL, '6271319833', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(482, 'local', NULL, 'Juan Carlos Lomeli', NULL, NULL, '3414196479', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(483, 'local', NULL, 'Angelly', NULL, NULL, '6271023674', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(484, 'local', NULL, 'Judith Medina', NULL, NULL, '627 117 7074', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(485, 'local', NULL, 'Estefania', NULL, NULL, '+52 627 110 3947', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(486, 'local', NULL, 'Alejandra Martinez', NULL, NULL, '6271068169', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(487, 'local', NULL, 'Jazmin Armendariz', NULL, NULL, '6271421545', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(488, 'local', NULL, 'Erik Olvera', NULL, NULL, '6271020586', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(489, 'local', NULL, 'Autocristales y Refacciones', NULL, NULL, '6271192685', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(491, 'local', NULL, 'Jonathan Rodriguez', NULL, NULL, '+52 1 686 161 1134', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(492, 'local', NULL, 'Regina', NULL, NULL, '+1 531 3339355', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(493, 'local', NULL, 'Nancy etchechury', NULL, NULL, '+52 627 131 9148', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(494, 'local', NULL, 'Martin Soto', NULL, NULL, '+52 627 110 0918', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(495, 'local', NULL, 'Carmen Morales', NULL, NULL, '6275211926', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(496, 'local', NULL, 'Cristina MARTINEZ', NULL, NULL, '+52 649 105 2360', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(497, 'local', NULL, 'Rocío Nava', NULL, NULL, '+52 627 106 6922', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(498, 'local', NULL, 'Izamar Nuñez', NULL, NULL, '+52 627 148 6193', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(499, 'local', NULL, 'Soledad Aguirre', NULL, NULL, '+52 627 139 3171', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(500, 'local', NULL, 'Minpro ING. Vannesa Aleman', 'vannesa.aleman@minpro.com.mx', NULL, '+52 871 219 8091', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(501, 'local', NULL, 'Amanda Martínez TRENDSETERA', NULL, NULL, '+52 777 463 7283', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(502, 'local', NULL, 'Jonathan Ibarra', NULL, NULL, '+52 418 110 4109', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(503, 'local', NULL, 'Diana Rueda Jurado', NULL, NULL, '+52 627 131 6001', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(504, 'local', NULL, 'Abril', NULL, NULL, '+52 627 148 1305', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(505, 'local', NULL, 'Lupita Lozoya', NULL, NULL, '+52 627 121 0938', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(506, 'local', NULL, 'Cindy', NULL, NULL, '+52 627 104 5069', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(507, 'local', NULL, 'Sol Aguirre', 'wmaster1ro@gmail.com', NULL, '+52 627 139 3171', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(508, 'local', NULL, 'Asociación de padres de familia esc. prim. Jesús González O.', NULL, NULL, '627 117 0819', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(509, 'local', NULL, 'Carniceria Meza', NULL, NULL, '+52 627 174 8295', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(510, 'local', NULL, 'Esc. Prim Fed. Gustavo Diaz Ordaz', NULL, NULL, '+52 649 196 1075', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(511, 'local', NULL, 'Carole Azaincot', NULL, NULL, '+52 55 5217 5493', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(512, 'local', NULL, 'Oscar Giovanni Rivera', NULL, NULL, '+52 229 250 0171', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(513, 'local', NULL, 'Esmeralda Herrera', NULL, NULL, '+52 627 148 4803', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(514, 'local', NULL, 'Escuela Carmen Tarín Ibarra', NULL, NULL, '+52 627 106 0840', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(515, 'local', NULL, 'AILYN LOPEZ', NULL, NULL, '6271212922', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(516, 'local', NULL, 'Flor García', NULL, NULL, '6275171435', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(517, 'local', NULL, 'ABTSA', NULL, NULL, '5516513909', 'Águilas int 1 ext 18A\r\nCol.Lago de Guadalupe', 'Cuautitlán Izcalli', '54760', 'México', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(518, 'local', NULL, 'Emy', NULL, NULL, '+52 649 196 1636', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(519, 'local', NULL, 'Jovana Rodríguez', NULL, NULL, '6271499611', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(520, 'local', NULL, 'Elizabeth Chaparro', NULL, NULL, '+52 627 151 4372', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(521, 'local', NULL, 'Rocío Rocha', NULL, NULL, '+52 614 253 2134', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(522, 'local', NULL, 'José Miranda', NULL, NULL, '+52 444 215 4167', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(523, 'local', NULL, 'LAURA ESTRADA', NULL, NULL, '6271432812', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(524, 'local', NULL, 'Patricio Rubio', NULL, NULL, '+52 656 167 3729', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(525, 'local', NULL, 'Laura Yesenia Salazar', NULL, NULL, '+52 627 520 4842', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(526, 'local', NULL, 'Alyson Pacheco', NULL, NULL, '+52 627 106 8726', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(527, 'local', NULL, 'Saúl Papás Leo', NULL, NULL, '+52 639 117 2204', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(528, 'local', NULL, 'Andrés', NULL, NULL, '+52 649 197 5603', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(529, 'local', NULL, 'Miguel', NULL, NULL, '+52 627 517 8466', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(530, 'local', NULL, 'Ferretería Regional', NULL, NULL, '6271585061', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(531, 'local', NULL, 'Gabriela Soto', NULL, NULL, '+52 627 116 4484', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(532, 'local', NULL, 'Yeimi ortega', NULL, NULL, '+52 627 111 1134', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(533, 'local', NULL, 'ITZEL ARCINIEGA', NULL, NULL, '+52 627 132 4235', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(534, 'local', NULL, 'Pedro Lerma', NULL, NULL, '6271424947', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(535, 'local', NULL, 'Villalobos Tile LLC', NULL, NULL, '6024734792', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(536, 'local', NULL, 'María Medrano', NULL, NULL, '+52 627 150 4059', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(537, 'local', NULL, 'Turismos Parral', NULL, NULL, '+52 627 117 6770', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(538, 'local', NULL, 'Fernanda Cazares', NULL, NULL, '6361239690', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(539, 'local', NULL, 'Yazmin Aguilar', NULL, NULL, '627 148 9782', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(540, 'local', NULL, 'Brenda Gonzales', NULL, NULL, '+52 627 117 0111', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(541, 'local', NULL, 'Esc. Primo. Lazara Quintana', NULL, NULL, '6271076981', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(542, 'local', NULL, 'Marisol Núñez', NULL, NULL, '+52 667 244 5784', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(543, 'local', NULL, 'Teresa Delgado', NULL, NULL, '+52 627 147 1074', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(544, 'local', NULL, 'Industrial Minera México', NULL, 'IMM8505281U0', '+52 656 311 6402', 'Campos Eliseos 400 ofic. 1102\r\nCol. Lomas de Chapultepec', 'CD. MÉXICO', '11000', 'Miguel Hidalgo', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(545, 'local', NULL, 'Félix Ruiz Gonzalez', NULL, NULL, '649 1010807. 6495326091', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(546, 'local', NULL, 'Araceli', NULL, NULL, '+52 627 133 0594', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(547, 'local', NULL, 'Cristian Sánchez  LA TREMENDA', NULL, NULL, '6271144189', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(548, 'local', NULL, 'Julia Gardea', NULL, NULL, '+52 627 104 7693', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(549, 'local', NULL, 'Rodolfo Guitierrez', NULL, NULL, '6681831600', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(550, 'local', NULL, 'Laura Prieto', NULL, NULL, '6271113706', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(551, 'local', NULL, 'Karen', NULL, NULL, '+52 627 114 8614', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(552, 'local', NULL, 'Esequiel Villalobos', NULL, NULL, '+52 614 154 3433', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(553, 'local', NULL, 'Villa Bonita', NULL, NULL, '+52 627 119 3915', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(554, 'local', NULL, 'Anabel Moreno', NULL, NULL, '+52 627 102 8194', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(555, 'local', NULL, 'Miriam Gallarzo', NULL, NULL, '+52 627 143 9199', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(556, 'local', NULL, 'Linda', NULL, NULL, '6271733449', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(557, 'local', NULL, 'Lucy Abril Meza Paniagua', NULL, NULL, '6271141522', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(558, 'local', NULL, 'Instituto Nacional Electoral', NULL, NULL, '+52 627 139 9643', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(559, 'local', NULL, 'Dania Luna', NULL, NULL, '+52 627 113 0652', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(560, 'local', NULL, 'Saúl Ochoa', NULL, NULL, '+52 639 117 2204', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(561, 'local', NULL, 'Luis Enrique Urbina', NULL, NULL, '6271315105', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(562, 'local', NULL, 'CREI año internacional del niño', NULL, NULL, '6271113706', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(563, 'local', NULL, 'Ingrid Chávez', NULL, NULL, '+52 56 1555 5291', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(564, 'local', NULL, 'Paty posada', NULL, NULL, '6271149619', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(565, 'local', NULL, 'Cindy Fernandez', NULL, NULL, '+52 627 111 0759', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(566, 'local', NULL, 'Jonathan Valdez', NULL, NULL, '6271234108', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(567, 'local', NULL, 'Yajaira Almazan', NULL, NULL, '+52 627 517 2761', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(568, 'local', NULL, 'Sandra Carbajal Álvarez', NULL, NULL, '+52 627 104 7056', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(569, 'local', NULL, 'Angélica Primero', NULL, 'Angélica Primero', '+52 627 140 0862', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(570, 'local', NULL, 'Esc Leona Vicario', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(571, 'local', NULL, 'Entidad de Limpieza y Mantenimiento', NULL, NULL, '+52 649 104 3888', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(572, 'local', NULL, 'Gisselle Rodriguez', NULL, NULL, '+52 627 112 6345', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(573, 'local', NULL, 'Karla', NULL, NULL, '+52 627 102 2258', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(574, 'local', NULL, 'Lina Macias', NULL, NULL, '+52 627 147 0892', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(575, 'local', NULL, 'Be Sweet Belem Bautista', NULL, NULL, '6275172040', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(576, 'local', NULL, 'Jorge', NULL, NULL, '6271519139', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(577, 'local', NULL, 'Alondra Rodriguez', NULL, NULL, '+52 627 103 3862', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(578, 'local', NULL, 'Lucybet', NULL, NULL, '+52 627 142 6620', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(579, 'local', NULL, 'Mtra Lorely Ávila', NULL, NULL, '+52 627 114 6670', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(580, 'local', NULL, 'Nancy Mendez', NULL, NULL, '+52 627 147 4075', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(581, 'local', NULL, 'JN Lázaro Cárdenas del Río', NULL, NULL, '+52 627 142 1545', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(582, 'local', NULL, 'Jesús Manuel Carbajal Múñoz', NULL, NULL, '6271219050', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(584, 'local', NULL, 'Rafael Ponce', NULL, NULL, '6276217403', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(585, 'local', NULL, 'Nallely', NULL, NULL, '6271216715', 'Agustín Melgar #3\r\ncol centro', 'Parral', '33800', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(586, 'local', NULL, 'Nancy Cano', NULL, NULL, '+52 627 112 8561', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(587, 'local', NULL, 'Esc prim 5 de Febrero 2127', NULL, NULL, '+52 627 279 3722', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(588, 'local', NULL, 'Perla Yaneth Jurado Luna', NULL, NULL, '+52 649 392 1875', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(589, 'local', NULL, 'Luci Chavira', NULL, NULL, '+1 (915) 272-8082', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(590, 'local', NULL, 'Rocío Holguín', NULL, NULL, '+52 627 110 1063', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(591, 'local', NULL, 'Denis', NULL, NULL, '+52 627 150 1009', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(592, 'local', NULL, 'Adriana Payan', NULL, NULL, '+52 627 117 4001', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(593, 'local', NULL, 'Ana Velia Flores', NULL, NULL, '+52 627 112 5178', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(594, 'local', NULL, 'Mary Soto', NULL, NULL, '6275216737', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(595, 'local', NULL, 'Esc. Prim. Club Rotario', NULL, NULL, '+52 627 279 8908', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(596, 'local', NULL, 'Jorge', NULL, NULL, '+52 627 151 9139', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(598, 'local', NULL, 'Verónica Estrada', NULL, NULL, '6275209283', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(599, 'local', NULL, 'Jorge Gutiérrrez', NULL, NULL, '6271113526', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(600, 'local', NULL, 'Adriana Montes', NULL, NULL, '6271041459', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(601, 'local', NULL, 'Jovany Alberto', NULL, NULL, '6491961075', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(602, 'local', NULL, 'Lety', NULL, NULL, '+52 627 106 3458', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(603, 'local', NULL, 'Karla Chàvez', NULL, NULL, '6271088429', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(604, 'local', NULL, 'Esc. Prim. Centenario de Ejército Mexicano profr. Edgar', NULL, NULL, '6271104468', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(605, 'local', NULL, 'Ruth Gamboa', NULL, NULL, '6271236279', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(606, 'local', NULL, 'Esc. Prim. Leona Vicario', NULL, NULL, '6272798908', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(608, 'local', NULL, 'Cinthia Teresa Lopez Galvan', NULL, NULL, '+52 627 142 9218', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(609, 'local', NULL, 'Mostrador', NULL, NULL, '+52 627 1034971', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(610, 'local', NULL, 'Blanca Prieto', NULL, NULL, '6271495993', 'Mártires 3 de mayo #68 Col. Emiliano Zapata', NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(611, 'local', NULL, 'Adriana Hernández', NULL, NULL, '6271420506', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(612, 'local', NULL, 'Jonathan Reyes', NULL, NULL, '6271780925', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(613, 'local', NULL, 'Gissel', NULL, NULL, '6271239902', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(614, 'local', NULL, 'Esc. Prim. Ma. Brisia Rodríguez/ Sociedad de padres', NULL, NULL, '6275213324', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(615, 'local', NULL, 'Laura Franco', NULL, NULL, '6271157673', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(616, 'local', NULL, 'Anaclaret Mata', NULL, NULL, '627 131 4757', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(617, 'local', NULL, 'Timoteo Montalvo', NULL, NULL, '6271050554', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(618, 'local', NULL, 'Raymundo Pineda', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(619, 'local', NULL, 'Anabel Vargas', NULL, NULL, '+52 627 117 1494', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(620, 'local', NULL, 'ISABEL LOYA', NULL, NULL, '+52 627 117 0207', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(621, 'local', NULL, 'Belém Holguín', NULL, NULL, '+52 627 148 1493', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(622, 'local', NULL, 'Dulce Mariana Castillo', NULL, NULL, '993 459 6475', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(623, 'local', NULL, 'Esc. Prim Ma Brisia Rodriguez', NULL, NULL, '6271730881', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(624, 'local', NULL, 'Don Ángel', NULL, NULL, '+52 627 150 0579', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(625, 'local', NULL, 'Guillermina Barraza', NULL, NULL, '+52 627 104 6589', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(626, 'local', NULL, 'Avril Ontiveros', NULL, NULL, '+52 614 368 1077', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(627, 'local', NULL, 'Sirelda Beltrán', NULL, NULL, '+52 627 517 0375', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(628, 'local', NULL, 'Karla', NULL, NULL, '6271126331', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(629, 'local', NULL, 'Hazel Pizarro', NULL, NULL, '+52 627 147 7106', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(630, 'local', NULL, 'Gamaliel García', NULL, NULL, '+52 55 7324 9207', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(632, 'local', NULL, 'Kevin Rodriguez', NULL, NULL, '6271733497', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(633, 'local', NULL, 'Janeth Villalobos', NULL, NULL, '+52 649 101 5465', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(634, 'local', NULL, 'Jannett', NULL, NULL, '+52 627 279 3509', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(635, 'local', NULL, 'Maria de Jesús Molina', NULL, NULL, '5551807927', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(636, 'local', NULL, 'Diana Torres', NULL, NULL, '8123514971', 'Mty NL', NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(637, 'local', NULL, 'Katia González', NULL, NULL, '627 517 2358', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(638, 'local', NULL, 'Secundaria Federal José Revueltas', NULL, NULL, '+52 627 106 6922', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(639, 'local', NULL, 'Mariana Meza Cano', NULL, NULL, '6271081182', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(640, 'local', NULL, 'Dra. Jaqueline Chávez León', NULL, NULL, '6271152554', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(641, 'local', NULL, 'Mariana', NULL, NULL, '6271081182', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(642, 'local', NULL, 'Lucy', NULL, NULL, '6271426620', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(643, 'local', NULL, 'Christian Cano', NULL, NULL, '+52 614 665 5523', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(644, 'local', NULL, 'Ricardo Nava Herrera', NULL, NULL, '+52 627 111 9362', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24');
INSERT INTO `cp_customers` (`id`, `source_type`, `source_id`, `name`, `email`, `tax_number`, `phone`, `address`, `city`, `zip_code`, `state`, `country`, `notes`, `enabled`, `created_at`, `updated_at`) VALUES
(645, 'local', NULL, 'Betty Vazquez', NULL, NULL, '+52 627 889 7313', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(646, 'local', NULL, 'Everardo', NULL, NULL, '6145041414', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(648, 'local', NULL, 'Yazmin García', NULL, NULL, '6271129013', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(649, 'local', NULL, 'Edith Holguín', NULL, NULL, '6271427679', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(650, 'local', NULL, 'Ricardo Chávez', NULL, NULL, '6271039257', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(652, 'local', NULL, 'Alicia', NULL, NULL, '627 150 7197', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(653, 'local', NULL, 'CLINICA HOSPITAL ISSSTE PARRAL Ing. Dulce  Ma. García Soto.', 'dulce.garcia@issste.gob.mx', NULL, '+52 627 889 7145', 'Francisco Miranda y, Rep. de Cuba NO. 8', 'Hidalgo del Parral', NULL, 'CHIHUAHUA', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(654, 'local', NULL, 'José Ceballos', NULL, NULL, '6271236513', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(655, 'local', NULL, 'Sol', NULL, NULL, '+52 667 244 5784', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(656, 'local', NULL, 'Fernanda Herrera', NULL, NULL, '+52 627 143 1641', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(657, 'local', NULL, 'Sandra Hernandez', NULL, NULL, '+52 627 133 7786', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(658, 'local', NULL, 'Mary Martínez', NULL, NULL, '+52 627 105 4853', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(659, 'local', NULL, 'Marlon Mendieta', NULL, NULL, '+52 951 548 3021', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(660, 'local', NULL, 'Luis Arzola', NULL, NULL, '+52 627 279 8068', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(661, 'local', NULL, 'Yaneth Calles', NULL, NULL, '627110947', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(662, 'local', NULL, 'Michelle García', NULL, NULL, '+52 627 142 2370', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(663, 'local', NULL, 'Yazmin Palacio', NULL, NULL, '+52 639 147 2778', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(664, 'local', NULL, 'Marlen Muñiz', NULL, NULL, '+52 627 132 4342', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(665, 'local', NULL, 'Mtra. Berenice García', NULL, NULL, '+52 627 102 7767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(666, 'local', NULL, 'Laura', NULL, NULL, '627 144 1521', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(667, 'local', NULL, 'Melida Margarita Chávez', NULL, NULL, '6271104468', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(668, 'local', NULL, 'Rocio', NULL, NULL, '6271032891', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(669, 'local', NULL, 'Brenda Martínez', NULL, NULL, '6271128936', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(670, 'local', NULL, 'Evelyn Rodríguez', NULL, NULL, '6271156464', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(671, 'local', NULL, 'Noemi Rodriguez', NULL, NULL, '+52 627 889 5844', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(673, 'local', NULL, 'Guadalupe Hernández', NULL, NULL, '+52 627 173 6258', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(674, 'local', NULL, 'Hotelera Queretana', NULL, NULL, '52 4428780208', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(675, 'local', NULL, 'Elizabeth Baca', NULL, NULL, '+52 627 121 3628', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(676, 'local', NULL, 'Angela', NULL, NULL, '+52 627 133 6714', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(677, 'local', NULL, 'Yara Sotelo', NULL, NULL, '+52 649 107 0392', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(678, 'local', NULL, 'Esc. Prim. Felipe Ángeles Álvarez #2426', NULL, NULL, '6271027767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(679, 'local', NULL, 'Firma Rosa Meza Guerrero', NULL, NULL, '6271039808', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(680, 'local', NULL, 'Ramona Terrazas Solis', NULL, NULL, '+52 667 326 9525', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(681, 'local', NULL, 'Esc. Melchor Gándara 2056', NULL, NULL, '627 117 1494', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(682, 'local', NULL, 'Esc. Telesecundaria Agua Amarilla', NULL, NULL, '6271121052', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(683, 'local', NULL, 'Lourdes Gardea', NULL, NULL, '+52 627 123 9569', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(684, 'local', NULL, 'Mary', NULL, NULL, '+52 627 105 4293', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(685, 'local', NULL, 'Edgar Martinez', NULL, NULL, '6261049059', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(686, 'local', NULL, 'Jonathan Villicaña Cobra Music', 'jonathan@cobramusicmanagement.com', NULL, '+52 55 3905 2954', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(687, 'local', NULL, 'Fernando Carbajal', NULL, NULL, '+52 669 101 3227', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(688, 'local', NULL, 'Martha Muro', NULL, NULL, '+52 627 123 3804', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(689, 'local', NULL, 'publico general', NULL, NULL, '6271501216', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(690, 'local', NULL, 'Blas Zapien Soto', NULL, NULL, '6491061824', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(691, 'local', NULL, 'Raúl Herrera', NULL, NULL, '6271195852', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(692, 'local', NULL, 'Janeth Luna. \"Nana Detalles hechos a mano\"', NULL, NULL, '6271436748', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(693, 'local', NULL, 'Keny Sandoval', NULL, NULL, '+52 627 112 7030', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(694, 'local', NULL, 'Yosi', NULL, NULL, '+52 686 353 2815', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(695, 'local', NULL, 'Mayra Galindo', NULL, NULL, '6271431064', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(696, 'local', NULL, 'Adriana Lozano', NULL, NULL, '6565511843', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(697, 'local', NULL, 'Profra Rocío', NULL, NULL, '+52 627 102 5075', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(698, 'local', NULL, 'Manuel Carmona', NULL, NULL, '+52 627 517 2204', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(699, 'local', NULL, 'Esc. Prim. Melchor Gándara 2056', NULL, NULL, '+52 627 106 3237', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(700, 'local', NULL, 'Sujey Hinojos', NULL, NULL, '+52 1 627 174 4654', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(701, 'local', NULL, 'Martha Sandoval', NULL, NULL, '627 103 5717', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(702, 'local', NULL, 'Mercedes Moreno', NULL, NULL, '6491038565', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(703, 'local', NULL, 'Elizabeth', NULL, NULL, '+52 649 197 4152', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(704, 'local', NULL, 'Perla Yaritza', NULL, NULL, '+52 627 150 8576', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(705, 'local', NULL, 'Martín Villanueva', NULL, NULL, '6271236091', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(706, 'local', NULL, 'Gloria García', NULL, NULL, '+52 627 112 5928', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(707, 'local', NULL, 'Sarahi Torres', NULL, NULL, '+52 627 132 7910', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(708, 'local', NULL, 'Supervisión Escolar Zona 146', NULL, NULL, '6271119351', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(709, 'local', NULL, 'Nuvia García Holguín', NULL, NULL, '6295216667', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(710, 'local', NULL, 'Isabel Negrete', NULL, NULL, '+52 627 148 5678', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(711, 'local', NULL, 'Esc. Ángel Trias Álvarez', NULL, NULL, '6271231361', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(712, 'local', NULL, 'USAER 142', NULL, NULL, '+52 627 123 4990', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(713, 'local', NULL, 'Flor Salas', NULL, NULL, '+52 627 142 8638', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(714, 'local', NULL, 'Fredy', NULL, NULL, '+52 627 177 9377', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(715, 'local', NULL, 'Elizabeth Zamora', NULL, NULL, '6271238307', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(716, 'local', NULL, 'Flor', NULL, NULL, '+52 656 296 8357', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(717, 'local', NULL, 'Sergio Saenz', NULL, NULL, '+52 614 105 8212', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(718, 'local', NULL, 'Romina', NULL, NULL, '+52 627 142 0957', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(719, 'local', NULL, 'Oly', NULL, NULL, '+52 649 106 1524', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(720, 'local', NULL, 'Alexa', NULL, NULL, '+52 627 121 0906', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(721, 'local', NULL, 'Margarita chaparro', NULL, NULL, '6271070846', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(722, 'local', NULL, 'Aracely Gutierrez', NULL, NULL, '6271122192', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(723, 'local', NULL, 'Margarita Shaccid', NULL, NULL, '+52 627 121 0337', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(724, 'local', NULL, 'Vianey Gamez Rodriguez', NULL, NULL, '+52 449 151 4042', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(725, 'local', NULL, 'Yosamara Pantoja', NULL, NULL, '6863532815', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(726, 'local', NULL, 'Erika Delgado', NULL, NULL, '6271112755', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(727, 'local', NULL, 'Myriam Baca Rodríguez', NULL, NULL, '6271193707', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(728, 'local', NULL, 'Ferretería Yavireza S.A. de C,V,', NULL, NULL, '6491964868', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(729, 'local', NULL, 'María Guadalupe Zavala López', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(730, 'local', NULL, 'Lorena Martinez', NULL, '|', '6271033929', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(731, 'local', NULL, 'Reina Martínez', NULL, NULL, '6271434053', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(732, 'local', NULL, 'Yazmin Chávez', NULL, NULL, '6271773303', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(733, 'local', NULL, 'Paulina Navarro', NULL, NULL, '6271048292', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(734, 'local', NULL, 'María Elena Rodríguez', NULL, NULL, '6271352317', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(736, 'local', NULL, 'Yanira Ramos', NULL, NULL, '6271130864', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(737, 'local', NULL, 'Mostrador', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(739, 'local', NULL, 'Patricia Palacios', NULL, NULL, '+52 627 112 3200', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(740, 'local', NULL, 'Esmeralda Carrillo', NULL, NULL, '6271021110', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(741, 'local', NULL, 'Jennifer Paloma Lopez Galvan', NULL, NULL, '6271429218', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(742, 'local', NULL, 'SECRETARIA DE LA DEFENSA NACIONAL RFC SDN8501014D2', NULL, NULL, NULL, 'BLVD. MANUEL AVILA CAMACHO S/N LOMAS DE SOTELO', 'CD. DE MEXICO, MX', '33825', 'MX', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(743, 'local', NULL, 'Yolanda', NULL, NULL, '6275211901', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(744, 'local', NULL, 'Gabriela Cabrera', NULL, NULL, '6271131665', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(745, 'local', NULL, 'Ale', NULL, NULL, '6563601311', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(746, 'local', NULL, 'Jonathan', NULL, NULL, '6271158049', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(747, 'local', NULL, 'Alejandra Portilloi', NULL, NULL, '6563601311', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(748, 'local', NULL, 'Escuela Primaria Emiliano Zapata', 'erikabustillos@colibriprint.com.mx', 'XAXX010101000', '6141020760', 'Jimenez', 'Jiménez', NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(749, 'local', NULL, 'Luisa Caro', NULL, NULL, '6271199802', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(750, 'local', NULL, 'Adán Quezada', NULL, NULL, '6271060784', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(751, 'local', NULL, 'Uride Parral', NULL, NULL, '+52 669 101 3227', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(752, 'local', NULL, 'Naydelin Fragoso', NULL, NULL, '6271483596', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(753, 'local', NULL, 'Yazmin', NULL, NULL, '6271210428', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(754, 'local', NULL, 'Sara, Gonzalez', NULL, NULL, '+52 627 521 9388', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(755, 'local', NULL, 'Omar Valenzuela', NULL, NULL, '6143784370', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(756, 'local', NULL, 'JOSUE SANCHEZ', NULL, NULL, '6271121988', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(757, 'local', NULL, 'Elizabeth Armendariz', NULL, NULL, '+52 627 524 1886', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(758, 'local', NULL, 'Rosa Janeth Gutierrez', NULL, NULL, '+52 627 889 9594', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(759, 'local', NULL, 'Alejandra Ruiz', NULL, NULL, '+52 614 513 0673', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(760, 'local', NULL, 'Karla Dimas', NULL, NULL, '6271088471', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(761, 'local', NULL, 'Fumigaciones P&P', NULL, NULL, '+52 669 274 6143', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(762, 'local', NULL, 'Erika Cisneros', NULL, NULL, '6271037867', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(763, 'local', NULL, 'Karina salón de eventos Alexa', NULL, NULL, '+52 627 106 4807', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(764, 'local', NULL, 'Míriam Payan', NULL, NULL, '6251090665', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(765, 'local', NULL, 'Esc. Club Rotario', NULL, NULL, '6271177945', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(766, 'local', NULL, 'Esc. Prim. Niños Héroes', NULL, NULL, '6491061524', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(768, 'local', NULL, 'Diana Rodriguez', NULL, NULL, '+52 627 517 2150', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(769, 'local', NULL, 'mostrador', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(770, 'local', NULL, 'TELESECUNDARIA 6100', NULL, NULL, '6271118788', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(771, 'local', NULL, 'Esc Josefa Solis y Esc Felipe Angeles', NULL, NULL, '+52 627 117 0535', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(772, 'local', NULL, 'Karla Reyes', NULL, NULL, '+52 627 111 3054', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(773, 'local', NULL, 'Escuela Lazara Quintana', NULL, NULL, '6271076981', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(774, 'local', NULL, 'Mtra Gris', NULL, NULL, '+52 627 147 8586', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(775, 'local', NULL, 'Brisa Gutierrez', NULL, NULL, '6271126593', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(776, 'local', NULL, 'Yolanda Estrada', NULL, NULL, '+52 627 149 5297', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(777, 'local', NULL, 'Profr. Carlos', NULL, NULL, '6271023701', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(778, 'local', NULL, 'Martin Pinedo', NULL, NULL, '6271173773', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(779, 'local', NULL, 'Sergio y Reina', NULL, NULL, '+52 627 111 9268', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(780, 'local', NULL, 'Prof. David Rubio', NULL, NULL, '6271086276', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(781, 'local', NULL, 'Quinta Zona Escolar', NULL, NULL, '6271045449', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(782, 'local', NULL, 'Belem Gutierrez', NULL, NULL, '6271233824', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(783, 'local', NULL, 'Yazmín Montes Contreras', NULL, NULL, '+52 649 114 4071', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(784, 'local', NULL, 'Irving Arrieta', NULL, NULL, '6271024288', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(785, 'local', NULL, 'Héctor Borjas', NULL, NULL, '6271771100', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(786, 'local', NULL, 'Zona 27', NULL, NULL, '6271045449', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(787, 'local', NULL, 'Lorena Zambrano', NULL, NULL, '6271144963', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(788, 'local', NULL, 'Blanca Alonso', NULL, NULL, '6275172602', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(789, 'local', NULL, 'Karla Rojas', NULL, '+52 627 521 8846', NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(790, 'local', NULL, 'Esc. 5 de Febrero 2127', NULL, NULL, NULL, 'Ejido San Rafael', 'Mpio. de Santa Bárbara', NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(791, 'local', NULL, 'Macky Jurado', NULL, NULL, '+52 614 198 6988', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(792, 'local', NULL, 'Karmina Bautista', NULL, '+52 627 173 7898', NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(793, 'local', NULL, 'Inspección Escolar Zona 67 Telesecundaria', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(794, 'local', NULL, 'July Gonzalez', NULL, NULL, '6272869282', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(795, 'local', NULL, 'Paola Jacobo', NULL, NULL, '6271234441', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(796, 'local', NULL, 'Yaneth Fernández', NULL, NULL, '+52 1 311 746 2653', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(797, 'local', NULL, 'esc. Nicolás Bravo', NULL, NULL, '6491100443', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(798, 'local', NULL, 'Judith', NULL, NULL, '627 117 7074', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(799, 'local', NULL, 'María de Jesús', NULL, NULL, '+52 627 123 4990', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(800, 'local', NULL, 'Enriqueta Villalobos', NULL, NULL, '6271327225', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(802, 'local', NULL, 'Nayar Club Campestre', NULL, NULL, '3111070607', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(803, 'local', NULL, 'Maestra Eneida', NULL, NULL, '6271476374', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(804, 'local', NULL, 'Ultra Protección', NULL, NULL, '6271111297', 'Camino Viejo a San José', 'Chihuahua', '32459', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(805, 'local', NULL, 'Miguel A. Soto', NULL, NULL, '6491960398', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(806, 'local', NULL, 'MOSTRADOR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(808, 'local', NULL, 'Cinthia Torres', NULL, NULL, '6141734112', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(809, 'local', NULL, 'Armando Pro', NULL, NULL, '6291525491', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(810, 'local', NULL, 'Prof. Julio Espinoza', NULL, NULL, '+52 627 150 0079', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(811, 'local', NULL, 'YADIRA CARRILLO', NULL, NULL, '6271234906', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(812, 'local', NULL, 'Maestra Maribel Guerra', NULL, NULL, '6493924391', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(813, 'local', NULL, 'Yaretzy Berenice', NULL, NULL, '+52 649 111 7637', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(814, 'local', NULL, 'Elizabeth', NULL, NULL, '+52 649 197 4152', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(815, 'local', NULL, 'Esc prim Miguel Alemán N° 2412', NULL, NULL, '+52 627 102 5075', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(816, 'local', NULL, 'Miranda', NULL, NULL, '+52 627 106 5339', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(817, 'local', NULL, 'Preescolar Lázaro Cárdenas del Río 1267', NULL, NULL, '6391022834', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(818, 'local', NULL, 'Saboria', NULL, NULL, '6271437151', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(819, 'local', NULL, 'Alonso', NULL, NULL, '+525610759779', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(820, 'local', NULL, 'Bianey Vargas', NULL, NULL, '6491042467', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(821, 'local', NULL, 'Esc. Ángel Trías', NULL, NULL, '6271231361', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(822, 'local', NULL, 'Liliana Muñoz', NULL, NULL, '6271239551', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(823, 'local', NULL, 'Mtra Itzel', NULL, NULL, '6271733506', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(824, 'local', NULL, 'Esc Ma Brisia', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(825, 'local', NULL, 'Damaris Chaparro', NULL, NULL, '214 477 4425', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(826, 'local', NULL, 'Dulce Mtz.', NULL, NULL, '6271122176', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(827, 'local', NULL, 'Omar Gómez', NULL, NULL, '6275245961', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(828, 'local', NULL, 'Jazmín Pedroza', NULL, NULL, '5959518357', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(829, 'local', NULL, 'Esc, Carmen Tarin Ibarra', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(830, 'local', NULL, 'Karla Torres', NULL, NULL, '6275213399', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(831, 'local', NULL, 'Ángel Gutiérrez', NULL, NULL, '6271212420', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(832, 'local', NULL, 'María del Carmen Payan', NULL, NULL, '6491964556', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(833, 'local', NULL, 'Esc. Prim. Lázaro Cárdenas', NULL, NULL, '+52 627 132 1361', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(834, 'local', NULL, 'Ángel Loya', NULL, NULL, '+52 627 524 6976', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(835, 'local', NULL, 'Maquinaria y equipo de Parral', NULL, NULL, '+52 614 138 2306', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(836, 'local', NULL, 'YAZMIN', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(837, 'local', NULL, 'Brenda', NULL, NULL, '+52 627 112 8936', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(838, 'local', NULL, 'Andres', NULL, NULL, '+52 627 149 1080', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(839, 'local', NULL, 'Mariela Mariscal', NULL, NULL, '6674187117', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(840, 'local', NULL, 'Cuartel militar', NULL, NULL, '+52 342 101 4689', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(841, 'local', NULL, 'Edelmira Flores', NULL, NULL, '6271493751', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(842, 'local', NULL, 'Victor', NULL, NULL, '+52 627 117 3889', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(843, 'local', NULL, 'Sonia', NULL, NULL, '6272796473', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(844, 'local', NULL, 'Rocío Saldaña', NULL, NULL, '+52 627 111 8107', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(845, 'local', NULL, 'Erika Yudith Chávez', NULL, NULL, '+52 627 150 4484', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(846, 'local', NULL, 'Malú Sevares', NULL, NULL, '+52 55 5401 0805', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(847, 'local', NULL, 'Iván', NULL, NULL, '+52 614 209 8597', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(848, 'local', NULL, 'Dime empresa', 'servicio.mist@gmail.com', NULL, '+52 878 788 9550', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(849, 'local', NULL, 'Mtra Soco', NULL, NULL, '+52 627 106 8751', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(850, 'local', NULL, 'Ricardo Lerma', NULL, NULL, '+52 627 119 4167', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(851, 'local', NULL, 'Alejandra Horta', NULL, NULL, '+52 627 143 4776', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(852, 'local', NULL, 'Alberca Semiolìmpica INMUNODEPA', NULL, NULL, '6271230333', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(853, 'local', NULL, 'Miranda', NULL, NULL, '6491130587', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(854, 'local', NULL, 'Yoana Villar', NULL, NULL, '627 148 9435', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(855, 'local', NULL, 'Ximena', NULL, NULL, '6272875707', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(856, 'local', NULL, 'Ana Ríos', NULL, NULL, '+1 (575) 312-7619', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(857, 'local', NULL, 'Adriana', NULL, NULL, '+52 627 115 2175', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(858, 'local', NULL, 'Alejandra Soto', NULL, NULL, '627 131 3895', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(859, 'local', NULL, 'Departamento de bomberos', NULL, NULL, '6271162255', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(860, 'local', NULL, 'Mostrador', NULL, NULL, '+52 649 115 5302', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(861, 'local', NULL, 'Alberto Moreno', NULL, NULL, '6491155302', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(862, 'local', NULL, 'Jazmin Lugo', NULL, NULL, '6271067389', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(863, 'local', NULL, 'Rubí Campos Gallardo', NULL, NULL, '656 298 9351', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(864, 'local', NULL, 'Elizabeth Caldera', NULL, NULL, '+52 627 123 9176', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(865, 'local', NULL, 'Karely', NULL, NULL, '+52 627 113 2106', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(866, 'local', NULL, 'Anel', NULL, NULL, '+52 627 144 6222', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(867, 'local', NULL, 'Janeth', NULL, NULL, '+52 627 143 1168', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(868, 'local', NULL, 'Mtra Moni', NULL, NULL, '+52 627 147 4312', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(870, 'local', NULL, 'Dpto. Médico Cerca de Ti', NULL, NULL, '+52 627 889 6997', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(871, 'local', NULL, 'Selene Rocha', NULL, NULL, '+52 614 253 2134', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(872, 'local', NULL, 'Esc. Prim. Victor Hugo Rascón Banda', NULL, NULL, NULL, '08DPR2610D', NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(873, 'local', NULL, 'Karla Rico', NULL, NULL, '+52 649 103 1194', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(874, 'local', NULL, 'UACH', NULL, NULL, '6271052926', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(875, 'local', NULL, 'Sandra Holguín', NULL, NULL, '6271110978', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(876, 'local', NULL, 'Roberto Caballero', NULL, NULL, '627 123 8276', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(877, 'local', NULL, 'Nidia', NULL, NULL, '627113338464', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(878, 'local', NULL, 'Patricio Rubio Lopez', NULL, NULL, '+1 (983) 777-9011', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(879, 'local', NULL, 'Mostrador', NULL, NULL, '+52 1 649 104 2467', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(880, 'local', NULL, 'Socorrito', NULL, NULL, '627 106 8751', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(881, 'local', NULL, 'Paola Solís', NULL, NULL, '6271170591', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(882, 'local', NULL, 'Jonathan', NULL, NULL, '+52 627 123 4108', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(883, 'local', NULL, 'Energy Industrial & Mining', NULL, NULL, '+52 627 1137573', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(884, 'local', NULL, 'Exploraciones Mineras Rodríguez   Lizbeth Escobar', NULL, NULL, '6271022767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(885, 'local', NULL, 'Janeth', NULL, NULL, '6271211790', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(886, 'local', NULL, 'Adrian', NULL, NULL, '627 279 8083', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(887, 'local', NULL, 'Gabriela', NULL, NULL, '6271069167', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(889, 'local', NULL, 'Alejandra Rodriguez', NULL, NULL, '+52 627 104 9835', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(890, 'local', NULL, 'Georgia Unda', NULL, NULL, '+52 627 148 8352', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(891, 'local', NULL, 'Leinad Cano', NULL, NULL, '+52 627 517 2607', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(892, 'local', NULL, 'Alejandra saldivar', NULL, NULL, '6271143867', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(893, 'local', NULL, 'VALE MAS Leticia Palomares', NULL, NULL, '+52 627 108 9648', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(895, 'local', NULL, 'Lizeth Avilene Terrazas Chávez', NULL, NULL, '6271849321', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(896, 'local', NULL, 'Oscar Luis de León González', NULL, NULL, '6143553662', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(897, 'local', NULL, 'Escuela 2101', NULL, NULL, '+52 627 142 0506', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(898, 'local', NULL, 'Paola', NULL, NULL, '6141266165', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(899, 'local', NULL, 'Ana Almeida', NULL, NULL, '+52 627 132 7449', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(900, 'local', NULL, 'Departamento de Bomberos', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(901, 'local', NULL, 'Cristina', NULL, NULL, '+52 627 108 1222', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(902, 'local', NULL, 'Liza Herrera', NULL, NULL, '+52 627 149 7157', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(903, 'local', NULL, 'Arcadio Peregrinos de Fe', NULL, NULL, '+1 (708) 770-0607', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(904, 'local', NULL, 'Esc. Prim. Jesús González Ortega', NULL, NULL, '627 117 0819', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(905, 'local', NULL, 'Energy Industrial & Mining', 'nogalerosdejimenez01@outlook.com', NULL, '+52 627 173 5178', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(906, 'local', NULL, 'Wiwynn Auttecs /Margarita Shaccid', NULL, NULL, '+52 627 121 0337', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(907, 'local', NULL, 'Sugey Acosta', NULL, NULL, '+52 627 103 4883', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(908, 'local', NULL, 'Samuel', NULL, NULL, '+52 627 149 9450', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(909, 'local', NULL, 'Delma', NULL, NULL, '+52 627 135 7934', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(910, 'local', NULL, 'Hazael Javier Serrano Peinado', NULL, NULL, '6271143161', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(911, 'local', NULL, 'Leti', NULL, NULL, '6271171876', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(912, 'local', NULL, 'Raúl', NULL, NULL, '+52 627 119 5852', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(913, 'local', NULL, 'Jardín de Niños \"Miguel Hidalgo\" 1046', NULL, NULL, '6271067389', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(914, 'local', NULL, 'Crece con Vales', NULL, NULL, '+52 871 709 9256', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(915, 'local', NULL, 'Delma Duarte', NULL, NULL, '6271357934', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(916, 'local', NULL, 'TALLER MAYEPSA', NULL, NULL, '6141382306', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(917, 'local', NULL, 'Marcial, Escobedo', NULL, NULL, '+52 649 116 5267', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(918, 'local', NULL, 'Esc. Constituyentes', NULL, NULL, '6143945046', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(919, 'local', NULL, 'Carlos Iván Martínez Chávez', NULL, NULL, '+52 627 889 8687', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(920, 'local', NULL, 'Guadalupe Flores', NULL, NULL, '+52 627 106 4113', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(924, 'local', NULL, 'Marìa Eugenia Cervantes Flores', NULL, NULL, NULL, 'calle Playa Guayabitos 123\r\ncol Desarrollo San Pablo', 'Querétaro.', '76125', NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(925, 'local', NULL, 'Patricia Núñez', NULL, NULL, '+52 55 2112 0915', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(926, 'local', NULL, 'Eva Villalobos', NULL, NULL, '+52 627 111 9600', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(927, 'local', NULL, 'Diana Villanueva', NULL, NULL, '+52 627 112 3704', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(928, 'local', NULL, 'Jonathan Portillo', NULL, NULL, '+52 627 114 7105', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(929, 'local', NULL, 'Martha Elena Méndez', NULL, NULL, '+52 627 524 5620', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(930, 'local', NULL, 'Ariana Denisse Ramirez Sánchez', NULL, NULL, '+52 627 521 7596', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(931, 'local', NULL, 'Lázaro Cárdenas', NULL, NULL, '+52 656 551 1843', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(932, 'local', NULL, 'Griselda, Hinojos', NULL, NULL, '6271060311', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(933, 'local', NULL, 'Kenia Astorga', NULL, NULL, '+52 627 139 4938', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(934, 'local', NULL, 'Nancy Vazquez', NULL, NULL, '6271313345', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(935, 'local', NULL, 'Joaquin Olivas Ramírez', NULL, NULL, '6271310124', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(936, 'local', NULL, 'American  Style Boutique', NULL, NULL, '4491843569', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(937, 'local', NULL, 'Rosa Rodríguez', NULL, NULL, '6271553000', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(938, 'local', NULL, 'Paola Armendariz', NULL, NULL, '6278899257', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(939, 'local', NULL, 'Flor Lerma', NULL, NULL, '6271194167', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(940, 'local', NULL, 'Mtra Eneida', NULL, NULL, '+52 627 279 8449', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(941, 'local', NULL, 'Dianq', NULL, NULL, '6271515200', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(942, 'local', NULL, 'Yazmin Meza', NULL, NULL, '6271230249', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(943, 'local', NULL, 'Sociedad de Padres de familia Esc. Ma. Brisia Rodriguez', NULL, NULL, '+52 627 108 4473', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(944, 'local', NULL, 'Soledad Morales', NULL, NULL, '+52 627 103 9685', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(945, 'local', NULL, 'Rebeca Olivas', NULL, NULL, '6275173138', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(946, 'local', NULL, 'Etna Maciel', NULL, NULL, '5533437810', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(947, 'local', NULL, 'Jardín de niños Miguel Hidalgo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(948, 'local', NULL, 'Alexia Márquez', NULL, NULL, '6291111099', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(949, 'local', NULL, 'X-POOLS PISCINAS DE FIBRA DE VIDRIO', NULL, NULL, '6491964935', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(950, 'local', NULL, 'Diana', NULL, NULL, '+52 627 106 9781', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(951, 'local', NULL, 'Erika Aldana', NULL, NULL, '627528402', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(952, 'local', NULL, 'MACLEAN ENGINEERING MEXICANA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(953, 'local', NULL, 'HG Carpintería', NULL, NULL, '627 119 4344', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(954, 'local', NULL, 'Daniel Rivera', NULL, NULL, '+52 627 174 1088', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(956, 'local', NULL, 'Daysi', NULL, NULL, '6271324953', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(957, 'local', NULL, 'DIF Municipal Parral', NULL, NULL, '+52 627 114 0510', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(958, 'local', NULL, 'Sonia Hernández,', NULL, NULL, '+52 627 108 9993', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(959, 'local', NULL, 'Ana', NULL, NULL, '+52 614 284 8733', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(960, 'local', NULL, 'Lizeth Betancourt', NULL, NULL, '6181686565', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(961, 'local', NULL, 'Jardín de niños Miguel Hidalgo', NULL, NULL, '+52 627 106 7389', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(962, 'local', NULL, 'Ana Ochoa / Lupita Rico', NULL, NULL, '+52 627 114 1023', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(963, 'local', NULL, 'Brenda Holguín', NULL, NULL, '+52 627 524 7539', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(964, 'local', NULL, 'Ricardo Jacobo', NULL, NULL, '+52 627 108 6296', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(965, 'local', NULL, 'Aracely Montes porfas', NULL, NULL, '+52 627 119 0312', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(966, 'local', NULL, 'Karla Sotelo', NULL, NULL, '6271022258', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(967, 'local', NULL, 'Karla Jurado', NULL, NULL, '+52 627 119 3658', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(968, 'local', NULL, 'Lucero Rodriguez', NULL, NULL, '+52 627 150 6708', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(969, 'local', NULL, 'Cristian Carbajal', NULL, NULL, '+52 627 131 7553', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(970, 'local', NULL, 'América Núñez', NULL, NULL, '+52 627 102 1095', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(971, 'local', NULL, 'Gustavo Zapien', NULL, NULL, '6272031650', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(972, 'local', NULL, 'Esc. Prim. Emiliano Zapata', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(973, 'local', NULL, 'Esc. Prim. Ford 80', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(974, 'local', NULL, 'Ing Marco DG PUBLICIDAD', NULL, NULL, '6271031075', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(975, 'local', NULL, 'Tere Uribe', NULL, NULL, '+52 627 114 5212', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(976, 'local', NULL, 'Mayra', NULL, NULL, '6271746889', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(977, 'local', NULL, 'Adriana Piña', NULL, NULL, '6143541623', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(978, 'local', NULL, 'Elizabeth', NULL, NULL, '6271064484', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(979, 'local', NULL, 'Mtra Lore', NULL, NULL, '6272798826', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(981, 'local', NULL, 'Rosy', NULL, NULL, '6271331129', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(982, 'local', NULL, 'Alejandra Pérez', NULL, NULL, '+52 625 589 8787', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24');
INSERT INTO `cp_customers` (`id`, `source_type`, `source_id`, `name`, `email`, `tax_number`, `phone`, `address`, `city`, `zip_code`, `state`, `country`, `notes`, `enabled`, `created_at`, `updated_at`) VALUES
(983, 'local', NULL, 'Jorge Bilbao', NULL, NULL, '6278895424', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(984, 'local', NULL, 'Carniceria Arredondo', NULL, NULL, '+52 649 101 4135', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(985, 'local', NULL, 'Marisol Armendariz', NULL, NULL, '+52 627 117 9955', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(986, 'local', NULL, 'Elena', NULL, NULL, '+52 627 133 0368', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(987, 'local', NULL, 'Samantha González', NULL, NULL, '+52 627 521 0215', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(988, 'local', NULL, 'Leticia García Imagen Arquitectónica Luferab', NULL, NULL, '+52 55 5453 6079', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(989, 'local', NULL, 'Fernando Chávez', NULL, NULL, '+52 627 139 6316', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(990, 'local', NULL, 'Agustina Chavez', NULL, NULL, '+52 627 103 8861', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(991, 'local', NULL, 'Norberto Hernández Alvarado', NULL, NULL, '+52 627 111 9414', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(992, 'local', NULL, 'Omar Sáenz', NULL, NULL, '6271321705', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(993, 'local', NULL, 'Carlos Villezcas', NULL, NULL, '+52 627 120 5139', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(994, 'local', NULL, 'Yenni Escárcega', NULL, NULL, '6271132974', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(995, 'local', NULL, 'Carolina Moreno', NULL, NULL, '+52 627 121 3207', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(996, 'local', NULL, 'Naomi', NULL, NULL, '+52 627 178 2092', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(997, 'local', NULL, 'Karla Lugo', NULL, NULL, '+52 627 173 9313', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(998, 'local', NULL, 'Juana Maria Hernández Hernández', NULL, NULL, '+52 627 103 9587', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(999, 'local', NULL, 'Perla', NULL, NULL, '+52 627 112 4562', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1000, 'local', NULL, 'Antonio Rodriguez Rodriguez', NULL, NULL, '6271039530', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1001, 'local', NULL, 'Escuela Telesecundaria Agua amarilla', NULL, NULL, '6271121052', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1002, 'local', NULL, 'Mario', NULL, NULL, '+52 614 196 8919', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1003, 'local', NULL, 'Mario Aguirre', NULL, NULL, '+52 614 196 8919', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1005, 'local', NULL, 'Marely Sotelo', NULL, NULL, '+52 627 150 7107', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1006, 'local', NULL, 'Santiago Loya', NULL, NULL, '+52 614 124 9738', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1007, 'local', NULL, 'Yajaira Bailon', NULL, NULL, '+52 627 521 6258', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1008, 'local', NULL, 'Yazmin Jacobo', NULL, NULL, '6272797834', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1009, 'local', NULL, 'Nayeli Galarza', NULL, NULL, '+52 871 572 7865', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1010, 'local', NULL, 'Alberto Silva', NULL, NULL, '+52 627 112 0927', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1011, 'local', NULL, 'Vianey', NULL, NULL, '+52 627 102 0301', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1012, 'local', NULL, 'Martín Villanueva', NULL, NULL, '+52 627 103 6964', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1013, 'local', NULL, 'Escuela: Carlos Pacheco  DPR: 08DPR00S5', NULL, NULL, '+52 614 604 1414', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1014, 'local', NULL, 'Carniceria Baez', NULL, NULL, '+52 627 117 5152', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1015, 'local', NULL, 'Bertha', NULL, NULL, '6271041649', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1016, 'local', NULL, 'Tania Portillo Núñez', NULL, NULL, '+52 627 143 0545', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1017, 'local', NULL, 'Lorena Gallardo', NULL, NULL, '6271500702', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1018, 'local', NULL, 'José Ramírez', NULL, NULL, '+52 627 102 0530', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1019, 'local', NULL, 'Marcel a Martínez OPTIMA IMPRESION', 'admin@optimaimpresion.net', NULL, '5555889562', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1020, 'local', NULL, 'Adriana', NULL, NULL, '+52 627 115 2543', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1021, 'local', NULL, 'Dra Maria Reyna Hernández', NULL, NULL, '+52 627 102 6829', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1022, 'local', NULL, 'Nallely Escápita', NULL, NULL, '6141198804', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1023, 'local', NULL, 'Cinthya Gonzalez', NULL, NULL, '6271475050', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1024, 'local', NULL, 'Genesis', NULL, NULL, '+52 627 112 1418', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1025, 'local', NULL, 'Taco Tacos', NULL, NULL, '+52 627 133 0955', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1026, 'local', NULL, 'Colegio de Bachilleres del Estado de Chihuahua', NULL, NULL, '6271170535', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1027, 'local', NULL, 'Marissa Torres', NULL, NULL, '6271114140', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1028, 'local', NULL, 'Salma jamileth Hernández Banderas', NULL, NULL, '+52 627 173 5363', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1029, 'local', NULL, 'Vitoria Molina', NULL, NULL, '+52 627 142 4690', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1030, 'local', NULL, 'Esc Prim. Josefa Salís De Lozoya', NULL, NULL, '+52 627 889 7324', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1031, 'local', NULL, 'Estrella Pérez', NULL, NULL, '+52 627 133 1315', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1032, 'local', NULL, 'Edwin Sotelo', NULL, NULL, '+52 627 139 7424', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1033, 'local', NULL, 'Adriana Troncoso', NULL, NULL, '+52 618 804 9903', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1034, 'local', NULL, 'Melissa Cañas', NULL, NULL, '+52 627 120 8440', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1035, 'local', NULL, 'Tele bachillerato 8650', NULL, NULL, '+52 627 111 7298', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1036, 'local', NULL, 'Esc Prim Jesús González Ortega', NULL, NULL, '+52 627 117 0819', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1037, 'local', NULL, 'Juan Hernández', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1038, 'local', NULL, 'Ana', NULL, NULL, '+52 614 284 8733', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1039, 'local', NULL, 'GRUPO COMERCIAL BUJAIDAR', NULL, NULL, '+52 614 173 4112', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1040, 'local', NULL, 'Jardín de Niños Malintzin', NULL, NULL, '+52 627 113 6616', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1041, 'local', NULL, 'Rita', NULL, NULL, '+52 627 113 2380', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1042, 'local', NULL, 'Esc Prim Ford 190 TM', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1043, 'local', NULL, 'Karla Mireles', NULL, NULL, '6271231883', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1044, 'local', NULL, 'Guadalupe Ramos', NULL, NULL, '6272795371', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1045, 'local', NULL, 'Gerardo Nájera', NULL, NULL, '6271776570', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1046, 'local', NULL, 'Norma Aracely', NULL, NULL, '6271337267', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1047, 'local', NULL, 'Ivan Palacios', NULL, NULL, '+52 55 6476 6784', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1048, 'local', NULL, 'Arlet', NULL, NULL, '6271501216', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1049, 'local', NULL, 'Lina Vargas', NULL, NULL, '+52 627 133 0947', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1050, 'local', NULL, 'Vivero El pequeño Paraíso', NULL, NULL, '+52 627 102 0659', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1051, 'local', NULL, 'Daniel Sandoval', NULL, NULL, '+52 627 133 6340', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1052, 'local', NULL, 'Cindy Roacho', NULL, NULL, '+52 627 133 4837', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1053, 'local', NULL, 'Asael Chávez', NULL, NULL, '+52 627 113 4489', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1054, 'local', NULL, 'Pastoral Penitenciaria Católica', NULL, NULL, '+52 627 112 8871', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1055, 'local', NULL, 'Pauliana Lerma', NULL, NULL, '+52 627 117 7658', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1056, 'local', NULL, 'Esc Prim 20 de Noviembre', NULL, NULL, '+52 649 196 1075', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1057, 'local', NULL, 'Damaris Baca', NULL, NULL, '+52 627 524 5708', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1058, 'local', NULL, 'Verónica Arras', NULL, NULL, '+52 627 123 9341', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1059, 'local', NULL, 'Esc. Prim. Álvaro Obregón', NULL, NULL, '6271499450', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1060, 'local', NULL, 'Esc Prim Josefa Solis de Lozoya', NULL, NULL, '+52 627 889 7324', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1061, 'local', NULL, 'Esc Prim Club Rotario', NULL, '+52 627 117 7945', NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1062, 'local', NULL, 'Lizbeth Escobar', NULL, NULL, '+52 627 102 2767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1063, 'local', NULL, 'Rolando Carrasco', NULL, NULL, '6271737348', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1064, 'local', NULL, 'Dennysse Favela', NULL, NULL, '+52 627 106 9320', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1065, 'local', NULL, 'Pollo Reinaga', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1066, 'local', NULL, 'Idalia', NULL, NULL, '6141608826', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1067, 'local', NULL, 'Juan Rocha', NULL, NULL, '+52 627 119 6525', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1068, 'local', NULL, 'Fernanda Holguín', NULL, NULL, '+52 627 114 0825', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1069, 'local', NULL, 'Supervisión Zona #67', NULL, NULL, '+52 627 106 6414', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1070, 'local', NULL, 'Cynthia Barragán', NULL, NULL, '+52 656 360 7135', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1071, 'local', NULL, 'Alejandra Hernández', NULL, NULL, '+52 627 150 6920', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1072, 'local', NULL, 'Esc Prim Guillermo Baca', NULL, NULL, '+52 627 119 3778', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1073, 'local', NULL, 'Mtra Rocio', NULL, NULL, '+52 627 102 5075', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1074, 'local', NULL, 'Sol Rivas', NULL, NULL, '+52 627 115 7453', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1075, 'local', NULL, 'Erik Orpineda', NULL, NULL, '6271426574', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1076, 'local', NULL, 'Kevin González', NULL, NULL, '+52 627 150 3372', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1077, 'local', NULL, 'Jazmin Rodríguez', NULL, NULL, '+52 627 131 2966', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1078, 'local', NULL, 'Jonathan Molina', NULL, NULL, '+52 649 196 5631', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1079, 'local', NULL, 'SERVICIOS Y DESTILERIA SR', NULL, NULL, '+52 627 102 2767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1080, 'local', NULL, 'Georgina Escapita', NULL, NULL, '+52 627 148 2590', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1081, 'local', NULL, 'Colegio de Bachilleres del Estado de Chihuaha Plantel 12', NULL, NULL, '6271049290', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1082, 'local', NULL, 'Riquelme Pizarro', NULL, NULL, '+52 649 110 4507', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1083, 'local', NULL, 'Naomi Guevara', 'mktdpso@gmail.com', 'DPS190123PX6', '+524424744504', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1084, 'local', NULL, 'Elder Esduardo Bojorquez Loya', NULL, NULL, '6491147133', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1085, 'local', NULL, 'Sarahí Blanco', NULL, NULL, '+52 627 104 7289', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1086, 'local', NULL, 'Silvia Nañez', NULL, NULL, '6271080335', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1087, 'local', NULL, 'Yazmin', NULL, NULL, '+52 627 117 1876', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1088, 'local', NULL, 'Brenda Rocio Ponce', NULL, NULL, '6271733497', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1089, 'local', NULL, 'Mayra Villalobos', NULL, NULL, '+52 627 108 4627', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1090, 'local', NULL, 'Bety', NULL, NULL, '6275241886', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1091, 'local', NULL, 'María Campuzano', NULL, NULL, '627 110 5062', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1092, 'local', NULL, 'Felix Pedroza', NULL, NULL, '+52 614 279 7909', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1093, 'local', NULL, 'Blanca Soto', NULL, NULL, '6271063116', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1094, 'local', NULL, 'Comedores Industriales de México', NULL, NULL, '+52 662 307 9112', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1095, 'local', NULL, 'Uriel Pérez', NULL, NULL, '+52 627 279 8712', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1096, 'local', NULL, 'Transportes El Oro Durango / Bere', NULL, NULL, '+52 627 521 3324', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1097, 'local', NULL, 'Karina Bravo', NULL, NULL, '6275172866', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1098, 'local', NULL, 'Perla Corral', NULL, NULL, '+52 627 103 6204', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1099, 'local', NULL, 'Nallely Ontiveros', NULL, NULL, '+52 627 107 8719', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1100, 'local', NULL, 'Comisariado Ejidal \"Ejido El Toro\"', NULL, NULL, '+52 627 113 9323', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1101, 'local', NULL, 'Quinta Zona Escolar', NULL, NULL, '+52 627 119 3778', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1102, 'local', NULL, 'Gamaliel Morúa Chávez', NULL, NULL, '+52 649 111 2139', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1103, 'local', NULL, 'Itzel Rivas', NULL, NULL, '+52 627 139 1091', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1104, 'local', NULL, 'Aron', NULL, NULL, '627 121 9783', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1105, 'local', NULL, 'Celeste Villa', NULL, NULL, '6271741116', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1106, 'local', NULL, 'Héctor Ivan Aguilera', NULL, NULL, '+52 627 117 2756', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1108, 'local', NULL, 'Lucia Sandoval', NULL, NULL, '6271140441', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1109, 'local', NULL, 'Josué Arellanes', NULL, NULL, '+52 614 684 3614', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1110, 'local', NULL, 'Ruth Ramirez', NULL, NULL, '627 889 8316', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1111, 'local', NULL, 'Kimberly Molina', NULL, NULL, '+52 627 111 3099', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1112, 'local', NULL, 'María del Carmen Gamez Torres', NULL, NULL, '+52 614 184 4269', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1113, 'local', NULL, 'Nallely  Sáenz', NULL, NULL, '6371039661', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1114, 'local', NULL, 'Primaria Felipe Ángeles Álvarez #2426', NULL, NULL, '+52 627 102 7767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1115, 'local', NULL, 'Jorge   Venegas', NULL, NULL, '6144632485', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1116, 'local', NULL, 'Sarahy Castillo', NULL, NULL, '+52 627 149 7877', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1117, 'local', NULL, 'Silvana', NULL, NULL, '+52 627 123 3454', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1119, 'local', NULL, 'URN PARRAL', NULL, NULL, '6271027893', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1120, 'local', NULL, 'Yolanda Guadalupe', NULL, NULL, '+52 627 113 0465', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1121, 'local', NULL, 'Esc prim Jesús Gonzalez Ortega', NULL, NULL, '+52 627 117 0819', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1123, 'local', NULL, 'Paty', NULL, NULL, '+52 627 524 5228', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1124, 'local', NULL, 'Jesus Holguín Coordinador Diocesano PF', NULL, NULL, '+52 627 132 7232', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1125, 'local', NULL, 'Susana Martinez', NULL, NULL, '+52 627 106 7142', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1126, 'local', NULL, 'Idalia Olivas', NULL, NULL, '6271507476', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1127, 'local', NULL, 'Eimee Padrón', NULL, NULL, '+52 627 123 3976', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1128, 'local', NULL, 'Neyry Gutiérrez', NULL, NULL, '6271496448', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1129, 'local', NULL, 'Profe Carlos', NULL, NULL, '6271023701', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1130, 'local', NULL, 'Vianey Gamez Rodríguez', NULL, NULL, '+52 618 110 6540', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1131, 'local', NULL, 'Dany Chávez', NULL, NULL, '627 148 2650', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1132, 'local', NULL, 'Jazmin Bustillos', NULL, NULL, '627 173 8644', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1133, 'local', NULL, 'Axel Gutièrrez', NULL, NULL, '6271515200', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1134, 'local', NULL, 'Multiservicios el Granillo', NULL, NULL, '6272799567', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1135, 'local', NULL, 'Alberto de la Garza', NULL, NULL, '+52 614 231 1298', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1136, 'local', NULL, 'Esc Prim Ford 190', NULL, NULL, '+52 627 150 0140', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1137, 'local', NULL, 'Esc Prim Ford 190 TV', NULL, NULL, '+52 656 148 9842', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1138, 'local', NULL, 'Rocío Sáenz', NULL, NULL, '+52 627 119 3778', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1139, 'local', NULL, 'Gloria Verónica Garcia Herrera', NULL, NULL, '614 151 1101', NULL, 'Hidalgo del Parral', '33800', 'Chihuahua', 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1140, 'local', NULL, 'Esc. Prim. Vicente Guerrero', NULL, NULL, '+52 627 173 3506', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1141, 'local', NULL, 'Escuela primaria Insurgentes', NULL, NULL, '+52 627 279 7834', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1142, 'local', NULL, 'Supervisión General del Sector 29', NULL, NULL, '6275212311', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1143, 'local', NULL, 'Esc Prim Carlos Pacheco', NULL, NULL, '6561138279', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1144, 'local', NULL, 'Marisol Holguín', NULL, NULL, '+52 627 121 1632', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1145, 'local', NULL, 'Karely Muñoz', NULL, NULL, '+52 627 143 1846', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1146, 'local', NULL, 'Meny', NULL, NULL, '+52 627 521 5958', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1147, 'local', NULL, 'Luis David Gardea', NULL, NULL, '+52 627 104 8788', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1148, 'local', NULL, 'Silvia', NULL, NULL, '627 108 0335', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1149, 'local', NULL, 'Sra Licha', NULL, NULL, '+52 627 177 9766', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1150, 'local', NULL, 'Sociedad de padres de familia esc Ma Brisia', NULL, NULL, '6271112877', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1151, 'local', NULL, 'Fernanda', NULL, NULL, '6271134989', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1152, 'local', NULL, 'Arq. Vivian', NULL, NULL, '+52 627 123 6928', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1153, 'local', NULL, 'Qualitas Compañía de Seguros', NULL, NULL, '+52 627 889 1998', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1154, 'local', NULL, 'Comité de Graduación  XX', NULL, NULL, '6271052926', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1155, 'local', NULL, 'Ana', NULL, NULL, '+52 614 284 8733', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1156, 'local', NULL, 'Kevin Frausto', NULL, NULL, '+52 629 521 2000', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1157, 'local', NULL, 'Verónica Acosta', NULL, NULL, '+52 629 101 0396', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1158, 'local', NULL, 'Martha', NULL, NULL, '6563182829', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1160, 'local', NULL, 'Olga Aurora Rubio Rubio', NULL, NULL, '614 593 8517', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1161, 'local', NULL, 'La villita', NULL, NULL, '627 123 6091', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1162, 'local', NULL, 'Esc prim Lázaro cárdenas', NULL, NULL, '6271035080', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1163, 'local', NULL, 'JN MIGUEL HIDALGO 1046', NULL, NULL, '+52 627 106 7389', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1164, 'local', NULL, 'Juan Rodríguez', NULL, NULL, '+52 627 114 7398', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1165, 'local', NULL, 'Lupita', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1166, 'local', NULL, 'MITZY ANAHI', NULL, NULL, '627147085', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1167, 'local', NULL, 'mitzy', NULL, NULL, '62774', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1168, 'local', NULL, 'Autopartes San Vicente', NULL, NULL, '+52 627 119 5317', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1169, 'local', NULL, 'Selina', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1170, 'local', NULL, 'Shantal Dominguez', NULL, NULL, '+1 (970) 980-8355', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1171, 'local', NULL, 'María Fernanda Holguín', NULL, NULL, '+52 627 114 0825', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1172, 'local', NULL, 'ZONA ESCOLAR 142', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1173, 'local', NULL, 'Luis Ituare', NULL, NULL, '+52 649 104 3735', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1174, 'local', NULL, 'Esc 5 de febrero 2127', NULL, NULL, '+52 627 279 3722', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1175, 'local', NULL, 'Lupita Loya', NULL, NULL, '+52 649 196 5488', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1176, 'local', NULL, 'Myriam Fernández', NULL, NULL, '+52 627 150 0275', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1177, 'local', NULL, 'Ana Cristina Martinez Arrieta', NULL, NULL, '+52 844 808 8223', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1178, 'local', NULL, 'Giselle', NULL, NULL, '+52 627 158 4746', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1179, 'local', NULL, 'Transformacion y Servicios Metalúrgicos', NULL, NULL, '+52 627 174 0590', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1180, 'local', NULL, 'aneth nuñez', NULL, NULL, '627 177 5757', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1181, 'local', NULL, 'Erazu Heredia', NULL, NULL, '6271049951', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1183, 'local', NULL, 'Rosa María García', NULL, NULL, '6275203040', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1184, 'local', NULL, 'Sec Tec No. 36', NULL, NULL, '+52 627 106 3595', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1185, 'local', NULL, 'Fátima Reynaga', NULL, NULL, '+52 81 4583 5712', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1186, 'local', NULL, 'Nancy Corral', NULL, NULL, '6271117779', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1187, 'local', NULL, 'Jesus Grado', NULL, NULL, '+52 649 116 7684', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1188, 'local', NULL, 'Colegio Vida con Futuro', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1189, 'local', NULL, 'Michel', NULL, NULL, '+52 627 279 1508', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1190, 'local', NULL, 'Esc Prim Álvaro Obregón', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1191, 'local', NULL, 'Diana Cortez', NULL, NULL, '6271230324', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1192, 'local', NULL, 'Ignacio Soto', NULL, NULL, '+52 55 3493 3988', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1193, 'local', NULL, 'Profr. Isamar', NULL, NULL, '+52 649 113 7119', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1194, 'local', NULL, 'Emili Gutiérrez', NULL, NULL, '6271443406', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1195, 'local', NULL, 'Santiago', NULL, NULL, '6271328321', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1196, 'local', NULL, 'Municipio Valle de Zaragoza /Nayeli', NULL, NULL, '+52 627 150 1804', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1197, 'local', NULL, 'Jenifer Karina Arzola Corral', NULL, NULL, '+52 674 112 3901', 'Guanacevi Durango', NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1198, 'local', NULL, 'Andrea Rodríguez', NULL, NULL, '+52 648 102 4662', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1199, 'local', NULL, 'Jessica Rodríguez', NULL, NULL, '+52 627 123 4286', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1200, 'local', NULL, 'Celia Corral', NULL, NULL, '+52 627 139 3388', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1201, 'local', NULL, 'Raquel', NULL, NULL, '+52 627 147 8317', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1202, 'local', NULL, 'UNIMEX', NULL, NULL, '+52 870 148 1685', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1203, 'local', NULL, 'David Remedios Ramirez López', NULL, NULL, '+52 614 314 3809', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1204, 'local', NULL, 'Mtra Alejandra', NULL, NULL, '+52 649 104 9222', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1205, 'local', NULL, 'Danna Paola Ortega Hernández', 'dannapaola.oh@justbetter.mx', NULL, '81 4592 8410 / 222 818 58 99', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1206, 'local', NULL, 'César García', NULL, NULL, '+52 627 119 1794', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1207, 'local', NULL, 'Jazmin Ortega', NULL, NULL, '+52 627 112 0213', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1208, 'local', NULL, 'Rmz Shop / Ramses Márquez', NULL, NULL, '+52 627 158 2828', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1209, 'local', NULL, 'Instituto Municipal de la Juventud', 'imjuve.parral2427@gmail.com', 'IMJ140327H50', '+52 627 119 5419', 'REPÚBLICA DE CUBA Y FRANCISCO MIRANDA S/N COL. AMÉRICAS', 'HIDALGO DEL PARRAL', '33880', 'CHIHUAHUA', 'MX', 'FAVOR DE FACTURAR A:\r\nINSTITUTO MUNICIPAL DE LA JUVENTUD\r\nRÉGIMEN: Personas morales con fines NO lucrativos\r\nRFC: IMJ140327H50\r\nREPÚBLICA DE CUBA Y FRANCISCO MIRANDA S/N\r\nCOL. AMÉRICAS C.P. 33880\r\nCORREO ELECTRÓNICO: imjuve.parral2427@gmail.com\r\nTEL. 627 522 0259\r\nUSO DE CFDI: Gastos en general', 1, '2026-09-16 22:56:13', '2026-09-28 20:46:12'),
(1210, 'local', NULL, 'Javier Huereque Parral', NULL, NULL, '6271153181', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1211, 'local', NULL, 'Francisco Calleros', NULL, NULL, '6271120647', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1212, 'local', NULL, 'Kiara Casteñeda', NULL, NULL, '+52 627 144 4315', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1213, 'local', NULL, 'Mauro Vega', NULL, NULL, '+52 627 123 4976', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1214, 'local', NULL, 'Karina García', NULL, NULL, '+52 627 112 9013', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1216, 'local', NULL, 'Gisselle Rodríguez', NULL, NULL, '+52 276 136 1625', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1217, 'local', NULL, 'José Ángel Luna', NULL, NULL, '6271139323', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1218, 'local', NULL, 'Teresa González', NULL, NULL, '627 132 1631', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1219, 'local', NULL, 'Soledad Aguirre', NULL, NULL, '+52 627 139 3171', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1220, 'local', NULL, 'Julio César Arroyo', NULL, NULL, '+52 627 123 5682', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1221, 'local', NULL, 'Brenda Sáenz', NULL, NULL, '+52 627 131 0473', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1222, 'local', NULL, 'Leonel Alvidrez', NULL, NULL, '+52 627 173 3702', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1223, 'local', NULL, 'Elena Rodríguez', NULL, NULL, '+52 627 301 0550', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1224, 'local', NULL, 'Constructora Coesmi', NULL, NULL, '+52 627 121 0832', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1225, 'local', NULL, 'Edgar', NULL, NULL, '6601267809', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1226, 'local', NULL, 'Esc Prim 5 de Febrero', NULL, NULL, '+52 627 103 4971', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1227, 'local', NULL, 'Blanca Díaz', NULL, NULL, '+52 614 523 4371', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1228, 'local', NULL, 'Juanito Cobos', NULL, NULL, '+52 627 147 5954', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1229, 'local', NULL, 'Marianela Lopez', NULL, NULL, '+52 649 197 5105', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1230, 'local', NULL, 'Emiliano', NULL, NULL, '+52 627 103 4971', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1231, 'local', NULL, 'Cecilia Valverde', NULL, NULL, '+52 627 149 3838', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1232, 'local', NULL, 'Jorge Silvas', NULL, NULL, '+52 627 103 1293', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1233, 'local', NULL, 'Edith Holguin', NULL, NULL, '6291011058', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1234, 'local', NULL, 'Elizabeth', NULL, NULL, '+52 649 197 4152', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1235, 'local', NULL, 'Laura Núñez', NULL, NULL, '+52 627 115 8697', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1236, 'local', NULL, 'Nancy Campuzano', NULL, NULL, '+52 656 113 8279', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1237, 'local', NULL, 'Alondra Espinoza', NULL, NULL, '+52 627 119 4960', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1238, 'local', NULL, 'Grupo Minero Lozoya', NULL, NULL, '+52 627 123 3864', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1239, 'local', NULL, 'Aracely Olivas', NULL, NULL, '+52 627 112 4607', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1240, 'local', NULL, 'Ivette Villanueva', NULL, NULL, '+52 627 114 8646', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1241, 'local', NULL, 'Jardín de niños Rosaura Zapata 1006', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1242, 'local', NULL, 'Abril Alejandra Espinoza Ch.', NULL, NULL, '+52 614 495 7331', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1244, 'local', NULL, 'Dariel Alexa', NULL, NULL, '+52 627 144 9467', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1245, 'local', NULL, 'Mtra Berenice', NULL, NULL, '+52 627 102 7767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1246, 'local', NULL, 'Alan Loera', NULL, NULL, '+52 627 147 2390', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1247, 'local', NULL, 'Marta Chávez', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1248, 'local', NULL, 'Janeth González', NULL, NULL, '+52 627 113 7458', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1249, 'local', NULL, 'Laura', NULL, NULL, '+52 627 150 2142', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1250, 'local', NULL, 'Edwin Huerta', NULL, NULL, '+52 639 154 9750', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1251, 'local', NULL, 'Nubia Mendias', NULL, NULL, '+52 627 115 5810', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1252, 'local', NULL, 'ILAP Ana Ruth', NULL, NULL, '+52 627 120 5614', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1253, 'local', NULL, 'Nidia Chávez', NULL, NULL, '+52 627 123 5444', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1254, 'local', NULL, 'Rafael', NULL, NULL, '+52 871 395 0211', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1255, 'local', NULL, 'Elia Elizabeth Baca Corral', NULL, NULL, '+52 627 112 1482', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1256, 'local', NULL, 'María José', NULL, NULL, '+52 613 111 9137', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1257, 'local', NULL, 'Brenda', NULL, NULL, '+52 614 528 0365', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1258, 'local', NULL, 'Nery Molina', NULL, NULL, '+52 627 150 6881', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1259, 'local', NULL, 'Julieta Medrano', NULL, NULL, '+52 627 112 1482', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1260, 'local', NULL, 'Karmina Bautista', NULL, NULL, '+52 627 173 7898', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1261, 'local', NULL, 'Alejandro Salcido', NULL, NULL, '+52 656 358 3966', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1262, 'local', NULL, 'HG CARPINTERIA', NULL, NULL, '+52 1 627 114 8973', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1263, 'local', NULL, 'El Favorichis', NULL, NULL, '+52 627 173 4528', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
(1264, 'local', NULL, 'Perla Herrera', NULL, NULL, '+52 627 143 5330', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-27 07:04:24'),
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
(1282, 'local', NULL, 'Dayvasos Parral', NULL, NULL, '+52 614 177 0826', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-25 19:41:15', '2026-09-25 19:42:18'),
(1283, 'local', NULL, 'Adry', NULL, NULL, '+52 627 104 3588', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-28 18:26:50', '2026-09-28 18:26:50'),
(1284, 'local', NULL, 'Miranda Buhaya', NULL, NULL, '+52 629 106 5121', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-29 09:48:43', '2026-09-29 09:48:43'),
(1285, 'local', NULL, 'Deyna Molina', NULL, NULL, '+52 627 131 2510', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-29 10:19:09', '2026-09-29 10:19:09'),
(1286, 'local', NULL, 'Ximena Hernández', NULL, NULL, '+52 627 149 9395', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-29 10:58:21', '2026-09-29 10:58:21'),
(1287, 'local', NULL, 'Aurora Hernández', NULL, NULL, '+52 627 517 5858', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-29 11:06:08', '2026-09-29 11:06:08'),
(1288, 'local', NULL, 'Patricia Quintero Márquez', NULL, NULL, '+52 627 147 6713', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-29 12:19:19', '2026-09-29 12:19:19'),
(1289, 'local', NULL, 'Brenda Piñon', NULL, NULL, '6271737160', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-30 15:56:37', '2026-09-30 15:56:37'),
(1290, 'local', NULL, 'MFC', NULL, NULL, '6271148973', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-30 16:47:36', '2026-09-30 16:47:36'),
(1291, 'local', NULL, 'Rocío Saldaña', NULL, NULL, '6271118107', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-10-01 14:09:02', '2026-10-01 14:09:02'),
(1292, 'local', NULL, 'Mabel', NULL, NULL, '+52 614 494 9218', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-10-01 17:51:00', '2026-10-01 17:51:00'),
(1293, 'local', NULL, 'Salma', NULL, NULL, '+52 627 173 5363', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-10-01 18:14:49', '2026-10-01 18:14:49'),
(1294, 'local', NULL, 'Mtra Betty', NULL, NULL, '+52 627 114 2023', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-10-03 13:48:52', '2026-10-03 13:48:52'),
(1295, 'local', NULL, 'Mtra Gaby', NULL, NULL, '+52 627 279 4682', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-10-03 13:52:41', '2026-10-03 13:52:41'),
(1296, 'local', NULL, 'Alba Ramirez', NULL, NULL, '+52 449 184 3569', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-10-04 14:43:37', '2026-10-04 14:43:37'),
(1297, 'local', NULL, 'María Guadalupe Villar Saenz', NULL, NULL, '6591012696', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-10-05 16:32:06', '2026-10-05 16:32:06'),
(1298, 'local', NULL, 'Luis Angel', NULL, NULL, '+52 627 107 1349', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-10-05 17:53:11', '2026-10-05 17:53:11'),
(1299, 'local', NULL, 'Marisol Polanco', NULL, NULL, '+52 627 105 8566', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-10-06 10:07:39', '2026-10-06 10:07:39'),
(1300, 'local', NULL, 'Luis Ariel Domínguez Sáenz', NULL, NULL, '+52 649 107 0392', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-10-06 13:15:49', '2026-10-06 13:15:49'),
(1301, 'local', NULL, 'ODIN LEDEZMA', NULL, NULL, '+52 627 123 3824', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-10-06 19:12:57', '2026-10-06 19:12:57'),
(1302, 'local', NULL, 'Presidencia Municipal de Parral', 'wmaster1ro@gmail.com', NULL, '6275274700', 'Francisco Miranda y República de Cuba s/n, América, 33880', 'HIDALGO DEL PARRAL', '33820', 'CHIHUAHUA', 'MX', NULL, 1, '2026-10-07 10:52:56', '2026-10-07 10:52:56');

-- --------------------------------------------------------

--
-- Table structure for table `cp_customers_backup_20260927_070420`
--

CREATE TABLE `cp_customers_backup_20260927_070420` (
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
-- Dumping data for table `cp_customers_backup_20260927_070420`
--

INSERT INTO `cp_customers_backup_20260927_070420` (`id`, `source_type`, `source_id`, `name`, `email`, `tax_number`, `phone`, `address`, `city`, `zip_code`, `state`, `country`, `notes`, `enabled`, `created_at`, `updated_at`) VALUES
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
(308, 'akaunting', 314, 'Alex', NULL, NULL, '627 143 9025', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13');
INSERT INTO `cp_customers_backup_20260927_070420` (`id`, `source_type`, `source_id`, `name`, `email`, `tax_number`, `phone`, `address`, `city`, `zip_code`, `state`, `country`, `notes`, `enabled`, `created_at`, `updated_at`) VALUES
(309, 'akaunting', 315, 'Sandra', NULL, NULL, '627 279 5634', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
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
(618, 'akaunting', 624, 'Raymundo Pineda', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13');
INSERT INTO `cp_customers_backup_20260927_070420` (`id`, `source_type`, `source_id`, `name`, `email`, `tax_number`, `phone`, `address`, `city`, `zip_code`, `state`, `country`, `notes`, `enabled`, `created_at`, `updated_at`) VALUES
(619, 'akaunting', 625, 'Anabel Vargas', NULL, NULL, '+52 627 117 1494', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
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
(934, 'akaunting', 942, 'Nancy Vazquez', NULL, NULL, '6271313345', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13');
INSERT INTO `cp_customers_backup_20260927_070420` (`id`, `source_type`, `source_id`, `name`, `email`, `tax_number`, `phone`, `address`, `city`, `zip_code`, `state`, `country`, `notes`, `enabled`, `created_at`, `updated_at`) VALUES
(935, 'akaunting', 943, 'Joaquin Olivas Ramírez', NULL, NULL, '6271310124', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
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
(1244, 'akaunting', 1252, 'Dariel Alexa', NULL, NULL, '+52 627 144 9467', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13');
INSERT INTO `cp_customers_backup_20260927_070420` (`id`, `source_type`, `source_id`, `name`, `email`, `tax_number`, `phone`, `address`, `city`, `zip_code`, `state`, `country`, `notes`, `enabled`, `created_at`, `updated_at`) VALUES
(1245, 'akaunting', 1253, 'Mtra Berenice', NULL, NULL, '+52 627 102 7767', NULL, NULL, NULL, NULL, 'MX', NULL, 1, '2026-09-16 22:56:13', '2026-09-16 22:56:13'),
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
-- Table structure for table `cp_customer_merge_map`
--

CREATE TABLE `cp_customer_merge_map` (
  `old_customer_id` int(10) UNSIGNED NOT NULL,
  `canonical_customer_id` int(10) UNSIGNED NOT NULL,
  `confidence` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_customer_merge_map`
--

INSERT INTO `cp_customer_merge_map` (`old_customer_id`, `canonical_customer_id`, `confidence`, `reason`, `created_at`) VALUES
(27, 26, 'high', 'lower_id', '2026-09-27 07:04:20'),
(89, 35, 'high', 'lower_id', '2026-09-27 07:04:20'),
(96, 95, 'high', 'lower_id', '2026-09-27 07:04:21'),
(97, 13, 'high', 'lower_id', '2026-09-27 07:04:20'),
(119, 118, 'high', 'lower_id', '2026-09-27 07:04:21'),
(152, 151, 'high', 'lower_id', '2026-09-27 07:04:21'),
(221, 219, 'high', 'lower_id', '2026-09-27 07:04:21'),
(365, 320, 'high', 'lower_id', '2026-09-27 07:04:21'),
(410, 291, 'high', 'lower_id', '2026-09-27 07:04:21'),
(490, 237, 'high', 'lower_id', '2026-09-27 07:04:21'),
(583, 582, 'high', 'lower_id', '2026-09-27 07:04:22'),
(597, 300, 'high', 'lower_id', '2026-09-27 07:04:21'),
(607, 590, 'high', 'lower_id', '2026-09-27 07:04:22'),
(631, 585, 'high', 'lower_id', '2026-09-27 07:04:22'),
(647, 116, 'high', 'lower_id', '2026-09-27 07:04:21'),
(651, 615, 'high', 'lower_id', '2026-09-27 07:04:22'),
(672, 166, 'high', 'lower_id', '2026-09-27 07:04:21'),
(735, 62, 'high', 'lower_id', '2026-09-27 07:04:21'),
(738, 250, 'high', 'lower_id', '2026-09-27 07:04:21'),
(767, 756, 'high', 'lower_id', '2026-09-27 07:04:23'),
(801, 732, 'high', 'lower_id', '2026-09-27 07:04:23'),
(807, 701, 'high', 'lower_id', '2026-09-27 07:04:22'),
(869, 628, 'high', 'lower_id', '2026-09-27 07:04:22'),
(888, 93, 'high', 'lower_id', '2026-09-27 07:04:21'),
(894, 893, 'high', 'lower_id', '2026-09-27 07:04:23'),
(921, 158, 'high', 'lower_id', '2026-09-27 07:04:21'),
(922, 111, 'high', 'lower_id', '2026-09-27 07:04:21'),
(923, 705, 'high', 'lower_id', '2026-09-27 07:04:22'),
(955, 292, 'high', 'lower_id', '2026-09-27 07:04:21'),
(980, 953, 'high', 'lower_id', '2026-09-27 07:04:23'),
(1004, 1003, 'high', 'lower_id', '2026-09-27 07:04:23'),
(1107, 454, 'high', 'lower_id', '2026-09-27 07:04:22'),
(1118, 1117, 'high', 'lower_id', '2026-09-27 07:04:24'),
(1122, 708, 'high', 'lower_id', '2026-09-27 07:04:22'),
(1159, 1071, 'high', 'lower_id', '2026-09-27 07:04:24'),
(1182, 1056, 'high', 'lower_id', '2026-09-27 07:04:24'),
(1215, 926, 'high', 'lower_id', '2026-09-27 07:04:23'),
(1243, 912, 'high', 'lower_id', '2026-09-27 07:04:23');

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

--
-- Dumping data for table `cp_invoices`
--

INSERT INTO `cp_invoices` (`id`, `order_id`, `customer_id`, `invoice_number`, `invoice_date`, `subtotal`, `tax`, `total`, `status`, `cfdi_uuid`, `notes`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(4, 29, 1039, '25D3DBFB-7B9C-4766-A824-C6BFE0A39ADE', '2026-09-28', 3019.50, 483.12, 3502.62, 'issued', '25D3DBFB-7B9C-4766-A824-C6BFE0A39ADE', NULL, 1, 1, '2026-09-28 12:30:15', '2026-09-28 16:06:15'),
(5, 29, 1039, '586C8953-C9AB-434C-B469-59D815817DAF', '2026-09-28', 2689.50, 430.32, 3119.82, 'issued', '586C8953-C9AB-434C-B469-59D815817DAF', NULL, 1, 1, '2026-09-28 12:34:42', '2026-09-28 16:06:11'),
(6, 42, 1209, 'F6855A9B-598F-4EE2-B1A9-906549FF36B3', '2026-09-28', 819.00, 131.04, 950.04, 'issued', 'F6855A9B-598F-4EE2-B1A9-906549FF36B3', NULL, 1, 1, '2026-09-28 19:02:46', '2026-09-28 19:02:46');

-- --------------------------------------------------------

--
-- Table structure for table `cp_invoice_documents`
--

CREATE TABLE `cp_invoice_documents` (
  `id` int(10) UNSIGNED NOT NULL,
  `invoice_id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `uuid` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `version` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '4.0',
  `serie` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `folio` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `issued_at` datetime DEFAULT NULL,
  `moneda` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `emisor_rfc` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `emisor_nombre` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `receptor_rfc` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `receptor_nombre` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subtotal` decimal(15,2) NOT NULL DEFAULT '0.00',
  `tax` decimal(15,2) NOT NULL DEFAULT '0.00',
  `total` decimal(15,2) NOT NULL DEFAULT '0.00',
  `forma_pago` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `metodo_pago` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `certificado_sat` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `no_certificado_sat` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sello_cfdi` longtext COLLATE utf8mb4_unicode_ci,
  `sello_sat` longtext COLLATE utf8mb4_unicode_ci,
  `xml_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pdf_path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `xml_sha256` char(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_invoice_documents`
--

INSERT INTO `cp_invoice_documents` (`id`, `invoice_id`, `order_id`, `uuid`, `version`, `serie`, `folio`, `issued_at`, `moneda`, `emisor_rfc`, `emisor_nombre`, `receptor_rfc`, `receptor_nombre`, `subtotal`, `tax`, `total`, `forma_pago`, `metodo_pago`, `certificado_sat`, `no_certificado_sat`, `sello_cfdi`, `sello_sat`, `xml_path`, `pdf_path`, `xml_sha256`, `created_by`, `created_at`) VALUES
(1, 4, 29, '25D3DBFB-7B9C-4766-A824-C6BFE0A39ADE', '4.0', NULL, NULL, '2026-09-28 11:21:11', 'MXN', 'BUAE8208274R5', 'ERIKA ELIZABETH BUSTILLOS AGUIRRE', 'GCB990825J58', 'GRUPO COMERCIAL BUJAIDAR', 3019.50, 483.12, 3502.62, '03', 'PUE', '00001000000705250068', '00001000000713224032', 'FVlac0oRwcvk8OkyeOZQANDUz103AAvNKUnZfCzvn5JFQ0oU6mLK3+DOVlSF7xXkio8z8O1bSE9AF1BZmqzlC8+lpBg6wIcySNmmL7P332SxeeQ53z58ghtRArHjofxMSJYvx+coXnCQwfVKga8FvGsGlyyW94MuWnuYC6P7ldnP70rAakTi1kJO71DfgeRFZchhoOiazGCpxK/1XIGN32hIolwZa0ngigN4KgTXH+4zex/M5dbouAJa29jW2bvy0n46Fs2neteM04GIDvCWFDsHdtxC84/IhlsXuYawl9odD3ymECE9mIWHWSm+0+xYCSmOWEI+h5KIHGxIWMlvNA==', 'E5mk5lZCim650zhBd4KD4jmztD6+7Jxx7VRBGSmE223D3Z+BxSxdr9tjzTCEoeu1o9kQgj0BBknr/HIhNas/mbYsdc/O7dh5pxrj6KgC27lsnxdns1mxJ2K2ylOyhpgSa0Ncvth1J8PuAFBwns/cUaN7fLiCqfizDq5HfnobMR35e/JqRN6KT7UAneh7/kwO33KWBI651pU7EZdqY+8sq+qOA/KnPVevM0z+ITmZYzWpxULLrTo7d2vmz7paLPfQSddHdFRONR351HNT0w/1FfBs2f+6iTi7Kl2TtcxiSVjGHbiYkfDcgCQiGoEOEdGYw2sfQwDTjtOVtQN2p5TlEQ==', 'storage/cfdi/2026/25D3DBFB-7B9C-4766-A824-C6BFE0A39ADE.xml', 'storage/cfdi/2026/25D3DBFB-7B9C-4766-A824-C6BFE0A39ADE.pdf', '4790cae90f34613111e0e6fd456ef095f92caa5e2cc3132e6386b2b8198f508f', 1, '2026-09-28 12:30:15'),
(2, 5, 29, '586C8953-C9AB-434C-B469-59D815817DAF', '4.0', NULL, NULL, '2026-09-28 11:25:23', 'MXN', 'BUAE8208274R5', 'ERIKA ELIZABETH BUSTILLOS AGUIRRE', 'CZS841128NH0', 'COMERCIAL ZAPATERA SAN FELIPE EL REAL', 2689.50, 430.32, 3119.82, '03', 'PUE', '00001000000705250068', '00001000000713224032', 'w3wj5uLWS4CtZwtPP3iVLS/2sUXLqE72PX2Qvo5u4Kj/m63l8qPBRsSc/j22flfTUmyxClbn/Kwsu3QPDC3NQHK+GL+Oel29hd/pVNKJ24AeKb0cmjt4vHKm3NOga6NhzQro2ubJSqngTvh5WKqlqK99ou9bcc9GVF6caRngWf6LZmFou7nE34oFFK5Ggfi6El60jmmamA2YxdfP7NEcP4u8/gWM+6bfOUjcAv8POutTFZiSgZZl9BDfE2P483O2J84xykQ0KnLAbwzC35EpIghkm4w32z4y8VPbSeHd9pVs5ULV5sF5Wbki71K31Cs5/dcZkdzeTN63DoWfdsRjMQ==', 'cxHFIeDh6gNMawm1Lz+mLNgei6UURML89YqxyYj35QdRmYGPa+Png3AMm2eOaRAPQ7T0CDgnJTfSrkVOFBR7XdC7REJpBP0+U7jdGz/Xu7gDGyrNYL7O0csUgvniscjE9uqpMmQXUkuylq59QvkrbT+OhH0rlw8qW11KZu5IbJABRBr7OHj8wxRWn4AUFEK3aDtBHiivn6R2sJyAs1AV55Ng4M8IJkvkRU27keDTmwftl04531UaoathzhFkpUM8/XvAc5bG5w+fwRz9y2nfzyqz6u5tf3FC9V9RLgAlUcuu0WjIuntb5gZbAL+3gxbWF495X3Zc3fNwOQ+epCoEgg==', 'storage/cfdi/2026/586C8953-C9AB-434C-B469-59D815817DAF.xml', 'storage/cfdi/2026/586C8953-C9AB-434C-B469-59D815817DAF.pdf', '5d02ba814a4c6fac6ec28d644cf156e9995eb3f1e90fc674a0a2080e0dab84e4', 1, '2026-09-28 12:34:42'),
(3, 6, 42, 'F6855A9B-598F-4EE2-B1A9-906549FF36B3', '4.0', NULL, NULL, '2026-09-28 19:00:44', 'MXN', 'BUAE8208274R5', 'ERIKA ELIZABETH BUSTILLOS AGUIRRE', 'IMJ140327H50', 'INSTITUTO MUNICIPAL DE LA JUVENTUD', 819.00, 131.04, 950.04, '03', 'PUE', '00001000000705250068', '00001000000713224032', 'TWvO0mN4zdBjBWwSDfbJu6aT6kOntckb9pddIUoGNUa1iS7Kt2WEfc7jVpgf0WJC/elAKaweQWTAaAh/QT5Q1myg/x9+4nirAO06QMqejkZbxYa05diVtJPzOWxbn7ZEBgNL2/UfvPFQ/Y1NM4Jj2KSpymaYGLSJ6zyc6+bpcYFpqwSYqMJCd5B9l+OXs2f6P9SkGvdsXwnE3Jj3oZ8f0rxAOM54mGV4IUh8DvhUPBNLR5pXheLkkPbQPNHX/405cMZxJw3hyuxuqa0pb2ysQzlbvbI4wVkvG1CQXAcndc+AlL/TsiVCIJa6hwVJbbGUdDdq60RtxDGYKl+5egKmVA==', 'hPPn6vAMPSLwrtu+b24ymb9bFvTEjK9m2oiZ44CJ35T2tNQXBzCTz2i0pxbKI5Btsy0Dg3lvC0A2ExvEEiRlSe8ohxA2mtIznFR8PmKtzDr1MgjrBBExi1/kvv00fxE7qRaFbfRrbiDcU5f0d9sy+x65MdZpMd4LLeVDze9sZeTZKWwvsKAcsTzi69SmHRE4hhsLUawYaK3k+qrrlTNyWg01i12aKNyxZzuFAVljm5B/wLlTis0KRuFr5gfvD6vkDNwb1Zvcd6OHsnV2fTrBqTA319OEv5d5Tzxcmv0D+DapPyXdGBilAAhC4YnY9hGxJ3E5iBc+spsUxjKt2r3u0w==', 'storage/cfdi/2026/F6855A9B-598F-4EE2-B1A9-906549FF36B3.xml', 'storage/cfdi/2026/F6855A9B-598F-4EE2-B1A9-906549FF36B3.pdf', 'a4baa0be8ae721bbb2bcf62f5d668ddc7edc042941207dc5b0ed62498af1ac22', 1, '2026-09-28 19:02:46');

-- --------------------------------------------------------

--
-- Table structure for table `cp_invoice_items`
--

CREATE TABLE `cp_invoice_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `document_id` int(10) UNSIGNED NOT NULL,
  `clave_prod_serv` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `no_identificacion` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cantidad` decimal(15,6) NOT NULL DEFAULT '0.000000',
  `clave_unidad` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unidad` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `valor_unitario` decimal(15,6) NOT NULL DEFAULT '0.000000',
  `importe` decimal(15,2) NOT NULL DEFAULT '0.00',
  `objeto_imp` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cp_invoice_items`
--

INSERT INTO `cp_invoice_items` (`id`, `document_id`, `clave_prod_serv`, `no_identificacion`, `cantidad`, `clave_unidad`, `unidad`, `descripcion`, `valor_unitario`, `importe`, `objeto_imp`, `created_at`) VALUES
(1, 1, '82101500', NULL, 32.000000, 'E48', 'Unidad de servicio', 'IMPRESION Y SUAJE 32 HOJAS OTOÑO', 35.000000, 1120.00, '02', '2026-09-28 12:30:15'),
(2, 1, '82121500', NULL, 8.000000, 'E48', 'Unidad de servicio', 'FRASES DE VINILO', 190.000000, 1520.00, '02', '2026-09-28 12:30:15'),
(3, 1, '60121015', NULL, 1.000000, 'E48', 'Unidad de servicio', 'MATERIAL TRANSFER PARA ROTULOS', 379.500000, 379.50, '02', '2026-09-28 12:30:15'),
(4, 2, '82121500', NULL, 28.000000, 'E48', 'Unidad de servicio', 'IMPREISON Y SUAJE HOJAS DE OTOÑO', 35.000000, 980.00, '02', '2026-09-28 12:34:42'),
(5, 2, '82121500', NULL, 7.000000, 'E48', 'Unidad de servicio', 'IMPRESION FRASES VINILO', 190.000000, 1330.00, '02', '2026-09-28 12:34:42'),
(6, 2, '60121015', NULL, 1.000000, 'E48', 'Unidad de servicio', 'MATERIAL TRANSFER PARA ROTULOS', 379.500000, 379.50, '02', '2026-09-28 12:34:42'),
(7, 3, '82121500', NULL, 21.000000, 'E48', 'Unidad de servicio', 'IMPRESION DE TARJETAS PVC', 39.000000, 819.00, '02', '2026-09-28 19:02:46');

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
(16, 'OS-2026-00006', 18, 544, 'in_progress', '2026-09-19', '2026-09-25', 1, 13456.00, '', '', 1, 1, '2026-09-19 17:17:34', '2026-10-03 20:25:17'),
(17, 'OS-2026-00007', 19, 930, 'delivered', '2026-09-19', '2026-09-22', 1, 730.00, '', '', 1, 1, '2026-09-19 17:26:26', '2026-09-28 19:45:52'),
(18, 'OS-2026-00008', 20, 340, 'in_progress', '2026-09-19', '2026-09-26', 1, 14360.80, '', '', 1, 1, '2026-09-19 18:35:39', '2026-09-29 09:03:10'),
(19, 'OS-2026-00009', 28, 1, 'cancelled', '2026-09-20', '2026-09-27', 1, 210.00, '', '', 1, 1, '2026-09-20 00:12:05', '2026-09-20 00:37:13'),
(20, 'OS-2026-00010', 29, 1, 'cancelled', '2026-09-20', '2026-09-27', 1, 150.00, '', '', 1, 1, '2026-09-20 00:23:51', '2026-09-20 00:37:16'),
(21, 'OS-2026-00011', 30, 763, 'delivered', '2026-09-22', '2026-09-25', 1, 750.00, '', '', 1, 1, '2026-09-22 08:38:51', '2026-09-27 06:18:07'),
(22, 'OS-2026-00012', 31, 1270, 'delivered', '2026-09-22', '2026-10-05', 1, 4374.00, '', '', 1, 1, '2026-09-22 10:38:56', '2026-10-07 09:53:41'),
(23, 'OS-2026-00013', 32, 1270, 'delivered', '2026-09-22', '2026-10-05', 1, 1782.00, '', '', 1, 1, '2026-09-22 10:54:15', '2026-10-07 09:54:22'),
(24, 'OS-2026-00014', 34, 908, 'delivered', '2026-09-22', '2026-09-23', 1, 390.00, '', '', 1, 1, '2026-09-22 14:19:56', '2026-09-30 15:34:03'),
(25, 'OS-2026-00015', 36, 769, 'delivered', '2026-09-22', '2026-09-29', 1, 100.00, '', '', 1, 1, '2026-09-22 20:46:45', '2026-09-22 20:47:36'),
(26, 'OS-2026-00016', 37, 571, 'in_progress', '2026-09-23', '2026-10-07', 1, 260.00, '', '', 1, 1, '2026-09-23 09:07:11', '2026-10-07 00:22:57'),
(27, 'OS-2026-00017', 35, 1204, 'in_progress', '2026-09-23', '2026-09-25', 1, 4550.00, '', '', 1, 1, '2026-09-23 09:58:04', '2026-09-28 22:18:41'),
(28, 'OS-2026-00018', 38, 1271, 'delivered', '2026-09-23', '2026-09-24', 1, 490.00, '', '', 1, 1, '2026-09-23 10:46:01', '2026-09-24 18:33:56'),
(29, 'OS-2026-00019', 33, 1039, 'delivered', '2026-09-23', '2026-09-26', 1, 6622.44, '', '', 1, 1, '2026-09-23 11:08:54', '2026-09-28 12:13:45'),
(30, 'OS-2026-00020', 39, 746, 'in_progress', '2026-09-23', '2026-09-30', 1, 850.20, '', '', 1, 1, '2026-09-23 20:22:53', '2026-09-25 11:19:05'),
(31, 'OS-2026-00021', 40, 1272, 'cancelled', '2026-09-24', '2026-09-26', 1, 299.00, '', '', 1, 1, '2026-09-24 10:00:07', '2026-09-27 06:37:38'),
(32, 'OS-2026-00022', 42, 1197, 'delivered', '2026-09-24', '2026-09-25', 1, 780.00, '', '', 1, 1, '2026-09-24 12:36:11', '2026-09-28 02:07:20'),
(33, 'OS-2026-00023', 43, 207, 'in_progress', '2026-09-24', '2026-09-25', 1, 640.00, '', '', 1, 1, '2026-09-24 17:37:36', '2026-10-06 12:09:28'),
(34, 'OS-2026-00024', 41, 1273, 'delivered', '2026-09-24', '2026-10-09', 1, 580.00, '', '', 1, 1, '2026-09-24 18:28:30', '2026-10-03 20:04:29'),
(35, 'OS-2026-00025', 46, 1275, 'delivered', '2026-09-25', '2026-09-26', 1, 240.00, '', '', 1, 1, '2026-09-25 04:51:18', '2026-09-25 07:41:43'),
(36, 'OS-2026-00026', 47, 1276, 'delivered', '2026-09-25', '2026-10-09', 1, 880.00, '', '', 1, 1, '2026-09-25 07:45:03', '2026-09-25 08:32:37'),
(37, 'OS-2026-00027', 48, 1277, 'delivered', '2026-09-25', '2026-09-25', 1, 240.00, '', '', 1, 1, '2026-09-25 08:15:26', '2026-09-25 08:42:40'),
(38, 'OS-2026-00028', 49, 1279, 'delivered', '2026-09-25', '2026-10-10', 1, 320.00, '', '', 1, 1, '2026-09-25 10:22:29', '2026-09-25 10:23:13'),
(39, 'OS-2026-00029', 54, 1223, 'delivered', '2026-09-25', '2026-09-26', 1, 350.00, 'Serían esos nombres \r\nGERA\r\nIAN\r\nADRIAN\r\nCHUMA Y DOÑA CONCHA\r\ny otra con el nombre de: Luis Pablo \"ñaca ñaca\"', '', 1, 1, '2026-09-25 20:37:16', '2026-09-28 02:07:50'),
(40, 'OS-2026-00030', 58, 1233, 'cancelled', '2026-09-28', '2026-10-03', 1, 1630.00, '', '', 1, 1, '2026-09-28 12:19:22', '2026-10-07 00:28:14'),
(41, 'OS-2026-00031', 51, 1280, 'in_progress', '2026-09-28', '2026-09-26', 1, 7161.84, 'Unión a mitad de lienzo', 'UNIDAS COMO CADENA', 1, 1, '2026-09-28 17:01:07', '2026-10-06 09:49:18'),
(42, 'OS-2026-00032', 45, 1209, 'delivered', '2026-09-28', '2026-09-25', 1, 950.04, '', '', 1, 1, '2026-09-28 18:14:57', '2026-09-28 18:15:46'),
(43, 'OS-2026-00033', 59, 1283, 'delivered', '2026-09-28', '2026-09-30', 1, 900.00, '', '', 1, 1, '2026-09-28 18:38:08', '2026-10-05 16:44:56'),
(44, 'OS-2026-00034', 63, 1286, 'in_progress', '2026-10-06', '2026-10-14', 1, 420.00, '', '', 1, 1, '2026-09-29 11:00:42', '2026-09-29 19:10:13'),
(45, 'OS-2026-00035', 64, 1287, 'in_progress', '2026-09-29', '2026-10-07', 1, 290.00, '', '', 1, 1, '2026-09-29 11:07:57', '2026-09-29 19:10:24'),
(46, 'OS-2026-00036', 66, 654, 'delivered', '2026-09-29', '2026-10-03', 1, 270.00, '', '', 1, 1, '2026-09-29 13:19:13', '2026-10-05 16:45:39'),
(47, 'OS-2026-00037', 61, 1284, 'delivered', '2026-09-29', '2026-10-03', 1, 560.00, '', '', 1, 1, '2026-09-29 19:07:16', '2026-10-05 16:45:23'),
(48, 'OS-2026-00038', 62, 1285, 'delivered', '2026-09-30', '2026-09-30', 1, 2496.00, '', '', 1, 1, '2026-09-30 11:23:20', '2026-09-30 15:32:10'),
(49, 'OS-2026-00039', 68, 1289, 'in_progress', '2026-09-30', '2026-10-15', 1, 1516.50, '', '', 1, 1, '2026-09-30 16:06:03', '2026-09-30 16:10:35'),
(50, 'OS-2026-00040', 69, 1290, 'delivered', '2026-09-30', '2026-09-30', 1, 700.00, '', '', 1, 1, '2026-09-30 16:49:57', '2026-10-03 20:30:50'),
(51, 'OS-2026-00041', 71, 459, 'in_progress', '2026-10-01', '2026-10-08', 1, 640.00, '', '', 1, 1, '2026-10-01 17:49:44', '2026-10-05 16:46:07'),
(52, 'OS-2026-00042', 72, 1292, 'delivered', '2026-10-01', '2026-10-01', 1, 80.00, '', '', 1, 1, '2026-10-01 17:52:26', '2026-10-01 17:55:50'),
(53, 'OS-2026-00043', 74, 227, 'delivered', '2026-10-02', '2026-10-02', 1, 150.00, '', '', 1, 1, '2026-10-02 10:16:45', '2026-10-04 08:43:49'),
(54, 'OS-2026-00044', 73, 1280, 'in_progress', '2026-10-02', '2026-10-10', 1, 2046.24, '', '', 1, 1, '2026-10-02 16:32:22', '2026-10-06 15:36:13'),
(55, 'OS-2026-00045', 76, 1294, 'pending', '2026-10-03', '2026-10-05', 1, 391.00, '', '', 1, 1, '2026-10-03 13:50:26', '2026-10-03 13:51:28'),
(56, 'OS-2026-00046', 77, 1295, 'pending', '2026-10-03', '2026-10-18', 1, 391.00, '', '', 1, 1, '2026-10-03 13:53:34', '2026-10-03 13:53:57'),
(57, 'OS-2026-00047', 78, 544, 'in_progress', '2026-10-03', '2026-10-17', 1, 6020.40, '', '', 1, 1, '2026-10-03 15:29:03', '2026-10-03 20:33:47'),
(58, 'OS-2026-00048', 79, 1296, 'in_progress', '2026-10-04', '2026-10-19', 1, 240.00, '', '', 1, 1, '2026-10-04 14:45:32', '2026-10-07 10:00:58'),
(59, 'OS-2026-00049', 80, 1284, 'delivered', '2026-10-05', '2026-10-05', 1, 290.00, '', '', 1, 1, '2026-10-05 09:57:55', '2026-10-06 12:08:24'),
(60, 'OS-2026-00050', 81, 1297, 'in_progress', '2026-10-05', '2026-10-20', 1, 1925.00, '', '', 1, 1, '2026-10-05 16:34:04', '2026-10-05 16:35:36'),
(61, 'OS-2026-00051', 82, 1298, 'delivered', '2026-10-05', '2026-10-06', 1, 395.00, '', '', 1, 1, '2026-10-05 17:56:27', '2026-10-07 00:21:29'),
(62, 'OS-2026-00052', 83, 726, 'pending', '2026-10-05', '2026-10-09', 1, 290.00, '', '', 1, 1, '2026-10-05 18:33:42', '2026-10-05 18:36:26'),
(63, 'OS-2026-00053', 88, 1280, 'in_progress', '2026-10-02', '2026-10-09', 1, 1193.64, 'impresión con union a mitad de lienzo', '', 1, 1, '2026-10-06 16:03:22', '2026-10-07 00:22:26'),
(64, 'OS-2026-00054', 87, 890, 'in_progress', '2026-10-07', '2026-10-10', 1, 440.00, '', '', 1, 1, '2026-10-07 00:30:34', '2026-10-07 00:30:37');

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
(250, 21, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-26 10:39:49'),
(251, 21, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-27 06:18:07'),
(252, 39, 'pending', 'in_progress', '', 1, '2026-09-27 06:19:41'),
(253, 31, 'in_progress', 'cancelled', '', 1, '2026-09-27 06:37:38'),
(254, 32, 'pending', 'completed', '', 1, '2026-09-28 02:06:23'),
(255, 32, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-28 02:06:48'),
(256, 32, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-28 02:06:51'),
(257, 32, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-28 02:06:54'),
(258, 32, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-28 02:06:57'),
(259, 32, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-28 02:07:00'),
(260, 32, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-28 02:07:05'),
(261, 32, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-28 02:07:20'),
(262, 39, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-28 02:07:31'),
(263, 39, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-28 02:07:34'),
(264, 39, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-28 02:07:37'),
(265, 39, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-28 02:07:39'),
(266, 39, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-28 02:07:42'),
(267, 39, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-28 02:07:45'),
(268, 39, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-28 02:07:50'),
(269, 29, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-28 12:13:42'),
(270, 29, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-28 12:13:45'),
(271, 40, NULL, 'pending', 'Orden creada desde CP-2026-00036', 1, '2026-09-28 12:19:22'),
(272, 41, NULL, 'pending', 'Orden creada desde CP-2026-00032', 1, '2026-09-28 17:01:07'),
(273, 41, 'pending', 'pending', 'Actualización automática desde cotización 51', 1, '2026-09-28 17:12:32'),
(274, 42, NULL, 'pending', 'Orden creada desde CP-2026-00026', 1, '2026-09-28 18:14:57'),
(275, 42, 'pending', 'in_progress', '', 1, '2026-09-28 18:15:12'),
(276, 42, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-28 18:15:33'),
(277, 42, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-28 18:15:36'),
(278, 42, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-28 18:15:38'),
(279, 42, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-28 18:15:40'),
(280, 42, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-28 18:15:42'),
(281, 42, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-28 18:15:44'),
(282, 42, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-28 18:15:46'),
(283, 43, NULL, 'pending', 'Orden creada desde CP-2026-00037', 1, '2026-09-28 18:38:08'),
(284, 41, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-28 18:39:50'),
(285, 41, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-28 18:39:53'),
(286, 17, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-28 19:45:52'),
(287, 27, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-28 22:18:41'),
(288, 18, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-29 09:03:10'),
(289, 40, 'pending', 'in_progress', '', 1, '2026-09-29 09:25:42'),
(290, 40, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-29 09:25:57'),
(291, 40, 'design', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-29 09:28:06'),
(292, 40, 'printing', 'pending', 'Hemos recibido tu pedido y se encuentra en espera de iniciar el proceso. Te informaremos cuando avance a la siguiente etapa.', 1, '2026-09-29 09:29:25'),
(293, 40, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-29 09:29:28'),
(294, 40, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-29 09:29:30'),
(295, 40, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-29 09:29:33'),
(296, 40, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-29 09:29:36'),
(297, 44, NULL, 'pending', 'Orden creada desde CP-2026-00041', 1, '2026-09-29 11:00:42'),
(298, 45, NULL, 'pending', 'Orden creada desde CP-2026-00042', 1, '2026-09-29 11:07:57'),
(299, 46, NULL, 'pending', 'Orden creada desde CP-2026-00044', 1, '2026-09-29 13:19:13'),
(300, 43, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-29 16:45:27'),
(301, 43, 'in_progress', 'in_progress', 'Actualización automática desde cotización 59', 1, '2026-09-29 16:58:51'),
(302, 47, NULL, 'pending', 'Orden creada desde CP-2026-00039', 1, '2026-09-29 19:07:16'),
(303, 47, 'pending', 'in_progress', '', 1, '2026-09-29 19:08:36'),
(304, 47, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-29 19:09:31'),
(305, 46, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-29 19:09:37'),
(306, 44, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-29 19:10:13'),
(307, 45, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-29 19:10:24'),
(308, 47, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-09-30 11:15:52'),
(309, 47, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-30 11:15:54'),
(310, 47, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-30 11:15:57'),
(311, 47, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-30 11:16:00'),
(312, 48, NULL, 'pending', 'Orden creada desde CP-2026-00040', 1, '2026-09-30 11:23:20'),
(313, 34, 'design', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-30 11:51:35'),
(314, 34, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-30 12:06:53'),
(315, 48, 'pending', 'delivered', '', 1, '2026-09-30 15:32:10'),
(316, 24, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-30 15:34:03'),
(317, 26, 'ready', 'pending', 'Hemos recibido tu pedido y se encuentra en espera de iniciar el proceso. Te informaremos cuando avance a la siguiente etapa.', 1, '2026-09-30 15:34:19'),
(318, 49, NULL, 'pending', 'Orden creada desde CP-2026-00046', 1, '2026-09-30 16:06:03'),
(319, 49, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-30 16:10:35'),
(320, 26, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-30 16:25:49'),
(321, 50, NULL, 'pending', 'Orden creada desde CP-2026-00047', 1, '2026-09-30 16:49:57'),
(322, 50, 'pending', 'pending', 'Actualización automática desde cotización 69', 1, '2026-09-30 16:51:36'),
(323, 22, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-10-01 14:54:26'),
(324, 22, 'printing', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-10-01 14:54:35'),
(325, 23, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-10-01 14:54:59'),
(326, 47, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-10-01 14:55:16'),
(327, 23, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-10-01 14:55:56'),
(328, 22, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-10-01 14:56:02'),
(329, 50, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-10-01 15:04:04'),
(330, 50, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-10-01 15:04:07'),
(331, 50, 'approval', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-10-01 15:04:08'),
(332, 50, 'approval', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-10-01 15:04:13'),
(333, 50, 'ready', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-10-01 15:04:35'),
(334, 50, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-10-01 15:04:37'),
(335, 50, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-10-01 15:04:39'),
(336, 50, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-10-01 15:04:42'),
(337, 50, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-10-01 15:04:43'),
(338, 50, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-10-01 15:04:47'),
(339, 41, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-10-01 17:08:04'),
(340, 41, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-10-01 17:08:08'),
(341, 51, NULL, 'pending', 'Orden creada desde CP-2026-00049', 1, '2026-10-01 17:49:44'),
(342, 51, 'pending', 'in_progress', '', 1, '2026-10-01 17:50:27'),
(343, 51, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-10-01 17:50:36'),
(344, 52, NULL, 'pending', 'Orden creada desde CP-2026-00050', 1, '2026-10-01 17:52:26'),
(345, 52, 'pending', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-10-01 17:53:50'),
(346, 52, 'delivered', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-10-01 17:55:37'),
(347, 52, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-10-01 17:55:40'),
(348, 52, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-10-01 17:55:42'),
(349, 52, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-10-01 17:55:44'),
(350, 52, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-10-01 17:55:46'),
(351, 52, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-10-01 17:55:48'),
(352, 52, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-10-01 17:55:50'),
(353, 53, NULL, 'pending', 'Orden creada desde CP-2026-00052', 1, '2026-10-02 10:16:45'),
(354, 54, NULL, 'pending', 'Orden creada desde CP-2026-00051', 1, '2026-10-02 16:32:22'),
(355, 55, NULL, 'pending', 'Orden creada desde CP-2026-00054', 1, '2026-10-03 13:50:26'),
(356, 56, NULL, 'pending', 'Orden creada desde CP-2026-00055', 1, '2026-10-03 13:53:34'),
(357, 57, NULL, 'pending', 'Orden creada desde CP-2026-00056', 1, '2026-10-03 15:29:03'),
(358, 43, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-10-03 19:55:06'),
(359, 43, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-10-03 19:55:09'),
(360, 43, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-10-03 19:55:11'),
(361, 43, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-10-03 19:55:13'),
(362, 43, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-10-03 19:55:15'),
(363, 34, 'in_progress', 'completed', '', 1, '2026-10-03 20:04:11'),
(364, 34, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-10-03 20:04:24'),
(365, 34, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-10-03 20:04:27'),
(366, 34, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-10-03 20:04:29'),
(367, 22, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-10-03 20:12:20'),
(368, 46, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-10-03 20:12:31'),
(369, 46, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-10-03 20:12:34'),
(370, 46, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-10-03 20:12:36'),
(371, 46, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-10-03 20:12:38'),
(372, 46, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-10-03 20:12:40'),
(373, 16, 'in_progress', 'in_progress', 'Sincronización manual desde cotización CP-2026-00006', 1, '2026-10-03 20:25:17'),
(374, 50, 'in_progress', 'completed', '', 1, '2026-10-03 20:30:41'),
(375, 50, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-10-03 20:30:50'),
(376, 57, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-10-03 20:33:29'),
(377, 57, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-10-03 20:33:32'),
(378, 57, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-10-03 20:33:35'),
(379, 57, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-10-03 20:33:37'),
(380, 57, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-10-03 20:33:44'),
(381, 57, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-10-03 20:33:47'),
(382, 53, 'pending', 'in_progress', '', 1, '2026-10-04 08:43:16'),
(383, 53, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-10-04 08:43:32'),
(384, 53, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-10-04 08:43:34');
INSERT INTO `cp_order_history` (`id`, `order_id`, `old_status`, `new_status`, `note`, `changed_by`, `created_at`) VALUES
(385, 53, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-10-04 08:43:37'),
(386, 53, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-10-04 08:43:39'),
(387, 53, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-10-04 08:43:41'),
(388, 53, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-10-04 08:43:43'),
(389, 53, 'ready', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-10-04 08:43:46'),
(390, 53, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-10-04 08:43:49'),
(391, 51, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-10-04 14:22:51'),
(392, 51, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-10-04 14:22:54'),
(393, 51, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-10-04 14:23:41'),
(394, 51, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-10-04 14:23:48'),
(395, 58, NULL, 'pending', 'Orden creada desde CP-2026-00057', 1, '2026-10-04 14:45:32'),
(396, 58, 'pending', 'in_progress', '', 1, '2026-10-04 14:53:09'),
(397, 58, 'in_progress', 'in_progress', 'Sincronización manual desde cotización CP-2026-00057', 1, '2026-10-04 14:53:11'),
(398, 58, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-10-04 14:54:11'),
(399, 58, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-10-04 14:54:14'),
(400, 58, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-10-04 14:54:16'),
(401, 59, NULL, 'pending', 'Orden creada desde CP-2026-00058', 1, '2026-10-05 09:57:55'),
(402, 60, NULL, 'pending', 'Orden creada desde CP-2026-00059', 1, '2026-10-05 16:34:04'),
(403, 60, 'pending', 'in_progress', '', 1, '2026-10-05 16:35:36'),
(404, 43, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-10-05 16:44:56'),
(405, 47, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-10-05 16:45:23'),
(406, 47, 'delivered', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-10-05 16:45:23'),
(407, 46, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-10-05 16:45:39'),
(408, 51, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-10-05 16:46:07'),
(409, 61, NULL, 'pending', 'Orden creada desde CP-2026-00060', 1, '2026-10-05 17:56:27'),
(410, 61, 'pending', 'in_progress', '', 1, '2026-10-05 18:00:47'),
(411, 62, NULL, 'pending', 'Orden creada desde CP-2026-00061', 1, '2026-10-05 18:33:42'),
(412, 41, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-10-06 09:49:18'),
(413, 54, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-10-06 09:57:27'),
(414, 59, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-10-06 12:08:09'),
(415, 59, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-10-06 12:08:12'),
(416, 59, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-10-06 12:08:14'),
(417, 59, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-10-06 12:08:16'),
(418, 59, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-10-06 12:08:18'),
(419, 59, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-10-06 12:08:20'),
(420, 59, 'ready', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-10-06 12:08:22'),
(421, 59, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-10-06 12:08:24'),
(422, 33, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-10-06 12:09:28'),
(423, 54, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-10-06 15:36:07'),
(424, 54, 'approval', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-10-06 15:36:07'),
(425, 54, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-10-06 15:36:10'),
(426, 54, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-10-06 15:36:13'),
(427, 63, NULL, 'pending', 'Orden creada desde CP-2026-00066', 1, '2026-10-06 16:03:22'),
(428, 61, 'pending', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-10-07 00:21:29'),
(429, 61, 'delivered', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-10-07 00:21:29'),
(430, 63, 'pending', 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-10-07 00:22:13'),
(431, 63, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-10-07 00:22:16'),
(432, 63, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-10-07 00:22:20'),
(433, 63, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-10-07 00:22:22'),
(434, 63, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-10-07 00:22:26'),
(435, 26, 'design', 'approval', 'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.', 1, '2026-10-07 00:22:51'),
(436, 26, 'approval', 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-10-07 00:22:55'),
(437, 26, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-10-07 00:22:57'),
(438, 22, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-10-07 00:25:08'),
(439, 23, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-10-07 00:25:24'),
(440, 23, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-10-07 00:25:27'),
(441, 40, 'in_progress', 'cancelled', '', 1, '2026-10-07 00:28:14'),
(442, 64, NULL, 'pending', 'Orden creada desde CP-2026-00065', 1, '2026-10-07 00:30:34'),
(443, 64, 'pending', 'in_progress', '', 1, '2026-10-07 00:30:37'),
(444, 22, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-10-07 09:53:41'),
(445, 23, 'ready', 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-10-07 09:54:22'),
(446, 58, 'printing', 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-10-07 10:00:52'),
(447, 58, 'production', 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-10-07 10:00:55'),
(448, 58, 'quality', 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-10-07 10:00:58');

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
(90, 39, 151, 'Taza personalizada Radiorama', 5.000, 70.00, 350.00, 0, '2026-09-25 20:37:16', '2026-09-25 20:37:16'),
(91, 40, 164, 'Etiqueta impresa medida 15x12cm (45pz) 1m x 1.5m', 1.000, 150.00, 150.00, 0, '2026-09-28 12:19:22', '2026-09-28 12:19:22'),
(92, 40, 165, 'Etiqueta impresa medida 10x8cm (110pz) 1m x 1.5m', 8.000, 150.00, 1200.00, 1, '2026-09-28 12:19:22', '2026-09-28 12:19:22'),
(93, 40, 166, 'Suaje de etiquetas', 4.000, 70.00, 280.00, 2, '2026-09-28 12:19:22', '2026-09-28 12:19:22'),
(95, 41, 168, 'Impresión de lona medida 390cm x 240cm incluye 10cm de rebase para tensado', 6.000, 1029.00, 6174.00, 0, '2026-09-28 17:12:32', '2026-09-28 17:12:32'),
(96, 42, 99, 'IMPRESION DE CREDENCIALES PVC', 21.000, 39.00, 819.00, 0, '2026-09-28 18:14:57', '2026-09-28 18:14:57'),
(99, 44, 178, 'Sudadera capucha y cangurera personalizada con fotos', 1.000, 420.00, 420.00, 0, '2026-09-29 11:00:42', '2026-09-29 11:00:42'),
(100, 45, 179, 'Cojín personalizado un solo lado medida 40x40cm', 1.000, 290.00, 290.00, 0, '2026-09-29 11:07:57', '2026-09-29 11:07:57'),
(101, 46, 183, 'Paq 100 tarjetas de presentación impresas un solo lado', 1.000, 200.00, 200.00, 0, '2026-09-29 13:19:13', '2026-09-29 13:19:13'),
(102, 46, 184, 'Elaboración de diseño', 1.000, 70.00, 70.00, 1, '2026-09-29 13:19:13', '2026-09-29 13:19:13'),
(103, 43, 185, 'Diseño y elaboración de trailer MDF grabado personalizado', 20.000, 30.00, 600.00, 0, '2026-09-29 16:58:51', '2026-09-29 16:58:51'),
(104, 43, 186, 'Diseño e impresión tarjetas Anticruda 100pz', 1.000, 200.00, 200.00, 1, '2026-09-29 16:58:51', '2026-09-29 16:58:51'),
(105, 43, 187, 'Fabricación de bases mdf para trailer', 10.000, 10.00, 100.00, 2, '2026-09-29 16:58:51', '2026-09-29 16:58:51'),
(106, 47, 180, 'Decorativo Vinil impreso y coroplast medida 80cm alto corte contorno', 1.000, 290.00, 290.00, 0, '2026-09-29 19:07:16', '2026-09-29 19:07:16'),
(107, 47, 181, 'Impresión Papel poster medida doble carta', 6.000, 45.00, 270.00, 1, '2026-09-29 19:07:16', '2026-09-29 19:07:16'),
(108, 48, 190, 'Circulo Dilatación personalizado medida 30cm. Color natural', 26.000, 120.00, 3120.00, 0, '2026-09-30 11:23:20', '2026-09-30 11:23:20'),
(109, 49, 191, 'Diseño e impresión lona medida 1.25 x .86', 5.000, 199.00, 995.00, 0, '2026-09-30 16:06:03', '2026-09-30 16:06:03'),
(110, 49, 192, 'Diseño e impresión de lona medida 2.36 x .60', 1.000, 260.00, 260.00, 1, '2026-09-30 16:06:03', '2026-09-30 16:06:03'),
(111, 49, 193, 'Diseño e impresión 100 tarjetas de presentación un solo lado', 1.000, 200.00, 200.00, 2, '2026-09-30 16:06:03', '2026-09-30 16:06:03'),
(112, 49, 194, 'Elaboración de diseños publicidas', 1.000, 230.00, 230.00, 3, '2026-09-30 16:06:03', '2026-09-30 16:06:03'),
(114, 50, 196, ', impresión de lona medida 60x80 cm', 7.000, 100.00, 700.00, 0, '2026-09-30 16:51:36', '2026-09-30 16:51:36'),
(115, 51, 206, 'Diseño e impresión Block 100 notas solo original tamaño carta', 1.000, 250.00, 250.00, 0, '2026-10-01 17:49:44', '2026-10-01 17:49:44'),
(116, 51, 207, 'Sello autoentintable personalizado', 1.000, 390.00, 390.00, 1, '2026-10-01 17:49:44', '2026-10-01 17:49:44'),
(117, 52, 208, 'Impresión sublimación 4 plantillas carta', 1.000, 80.00, 80.00, 0, '2026-10-01 17:52:26', '2026-10-01 17:52:26'),
(118, 53, 212, 'Impresión digital vinil 15cm', 6.000, 25.00, 150.00, 0, '2026-10-02 10:16:45', '2026-10-02 10:16:45'),
(119, 54, 214, 'Trofeo Modelo Vaquero', 4.000, 490.00, 1960.00, 0, '2026-10-02 16:32:22', '2026-10-02 16:32:22'),
(120, 55, 217, 'Sello autoentintable personalizado', 1.000, 460.00, 460.00, 0, '2026-10-03 13:50:26', '2026-10-03 13:50:26'),
(121, 56, 218, 'Sello autoentintable personalizado', 1.000, 460.00, 460.00, 0, '2026-10-03 13:53:34', '2026-10-03 13:53:34'),
(122, 57, 219, 'Impresión de lona medida 2m x 80cm incluye porta banner roll up', 5.000, 750.00, 3750.00, 0, '2026-10-03 15:29:03', '2026-10-03 15:29:03'),
(123, 57, 220, 'Impresión de lona medida 3m x 2m (no incluye instalación)', 2.000, 720.00, 1440.00, 1, '2026-10-03 15:29:03', '2026-10-03 15:29:03'),
(124, 16, 29, 'Impresión vinil adhesivo tamaño tabloide', 100.000, 37.00, 3700.00, 0, '2026-10-03 20:25:17', '2026-10-03 20:25:17'),
(125, 16, 30, 'Rotulación de Camiones medida 140cm x 70cm', 10.000, 790.00, 7900.00, 1, '2026-10-03 20:25:17', '2026-10-03 20:25:17'),
(128, 58, 221, 'Lona 80x80cm', 1.000, 140.00, 140.00, 0, '2026-10-04 14:53:11', '2026-10-04 14:53:11'),
(129, 58, 222, '100 impresiones 5x8cm', 1.000, 100.00, 100.00, 1, '2026-10-04 14:53:11', '2026-10-04 14:53:11'),
(130, 59, 223, '100 stiker 2\"', 1.000, 150.00, 150.00, 0, '2026-10-05 09:57:55', '2026-10-05 09:57:55'),
(131, 59, 224, '50 Trípticos papel Bond a color', 1.000, 140.00, 140.00, 1, '2026-10-05 09:57:55', '2026-10-05 09:57:55'),
(132, 60, 225, 'Cajita madera/mdf personalizada', 35.000, 55.00, 1925.00, 0, '2026-10-05 16:34:04', '2026-10-05 16:34:04'),
(133, 61, 226, '400 Stiker personalizado 2\"', 1.000, 395.00, 395.00, 0, '2026-10-05 17:56:27', '2026-10-05 17:56:27'),
(134, 62, 227, 'Vaso termico personalizado con diseño de gatito', 1.000, 290.00, 290.00, 0, '2026-10-05 18:33:42', '2026-10-05 18:33:42'),
(135, 63, 236, 'Impresión de lona medida 390cm x 240cm incluye 10cm de rebase para tensado', 1.000, 1029.00, 1029.00, 0, '2026-10-06 16:03:22', '2026-10-06 16:03:22'),
(136, 64, 238, 'Centro de mesa 18cm', 12.000, 20.00, 240.00, 0, '2026-10-07 00:30:34', '2026-10-07 00:30:34'),
(137, 64, 239, 'Figura decorativa vinil y coroplast  con base 50cm', 1.000, 200.00, 200.00, 1, '2026-10-07 00:30:34', '2026-10-07 00:30:34');

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
(35, 39, '/uploads/orders/39/b3e882b4d3564590b0c0cef58526515eb1d7.jpg', 'IMG-20260925-WA0084.jpg', 'image/jpeg', 90703, 'client_file', 'Anticipo', 1, '2026-09-25 21:14:27', '2026-09-25 21:14:27'),
(36, 40, '/uploads/orders/40/a89ca21307752fbf95f22cccb5397109e4c1.jpg', 'Screenshot_20260928-121641~2.jpg', 'image/jpeg', 196338, 'client_file', '10x8cm (220pz)', 1, '2026-09-28 12:20:07', '2026-09-28 12:20:07'),
(37, 40, '/uploads/orders/40/efe8288058b1a3f00f662846b93c1b813e2d.jpg', 'Screenshot_20260928-121645~2.jpg', 'image/jpeg', 198141, 'client_file', '10x8cm (220pz)', 1, '2026-09-28 12:20:28', '2026-09-28 12:20:28'),
(39, 40, '/uploads/orders/40/311639d9591354515fc6be619a7674ed7165.jpg', 'Screenshot_20260928-121653~2.jpg', 'image/jpeg', 174946, 'client_file', '10x8cm (220pz)', 1, '2026-09-28 12:21:05', '2026-09-28 12:21:05'),
(40, 40, '/uploads/orders/40/bf1db2e544e102a8230af4da6fd076adbdaf.jpg', 'Screenshot_20260928-121653~3.jpg', 'image/jpeg', 207815, 'client_file', '10x8cm (220pz)', 1, '2026-09-28 12:21:40', '2026-09-28 12:21:40'),
(41, 40, '/uploads/orders/40/d4580e3260559b7635ac48b293e19888a159.jpg', 'Screenshot_20260928-121645~2.jpg', 'image/jpeg', 198141, 'client_file', '12x15cm (45pz)', 1, '2026-09-28 12:22:22', '2026-09-28 12:22:22'),
(42, 43, '/uploads/orders/43/8b749e1fabc4d1b0a05d8db573c0b9fd0537.png', 'Screenshot_20260928-183900.png', 'image/png', 1794415, 'client_file', '10 servilleteros', 1, '2026-09-28 18:39:25', '2026-09-28 18:39:25'),
(43, 43, '/uploads/orders/43/a09c95e86216faf59c0e841f2c87daa350db.png', 'Screenshot_20260928-183844.png', 'image/png', 825169, 'client_file', 'Tamaño tarjeta presentación', 1, '2026-09-28 18:39:47', '2026-09-28 18:39:47'),
(45, 44, '/uploads/orders/44/843d1d807327689eabbcebf88127720fbba4.png', 'Screenshot_20260929-110005.png', 'image/png', 1011771, 'client_file', 'Fotos en WhatsApp 4512', 1, '2026-09-29 11:01:24', '2026-09-29 11:01:24'),
(46, 45, '/uploads/orders/45/a694428e012353b8e46430c3a214d118893c.png', 'Screenshot_20260929-110733.png', 'image/png', 2841840, 'client_file', NULL, 1, '2026-09-29 11:08:22', '2026-09-29 11:08:22'),
(48, 45, '/uploads/orders/45/d3ea0f310805dd04adff51b39a028689d203.png', 'Screenshot_20260929-110727.png', 'image/png', 1856419, 'client_file', 'Y con unas letras q digan  !Que eres china o que!', 1, '2026-09-29 11:09:49', '2026-09-29 11:09:49'),
(49, 46, '/uploads/orders/46/e7c432a308453777b96a82884d387c21a292.jpg', 'IMG-20260929-WA0055.jpg', 'image/jpeg', 150615, 'client_file', NULL, 1, '2026-09-29 13:19:51', '2026-09-29 13:19:51'),
(50, 48, '/uploads/orders/48/e52ac4f8e4527f3ed7e29aa4877aecf7e551.jpg', 'IMG-20260929-WA0086.jpg', 'image/jpeg', 116634, 'client_file', '20 con nombre y 6 sin nada', 1, '2026-09-30 11:23:59', '2026-09-30 11:23:59'),
(51, 53, '/uploads/orders/53/1d33c13c9c853996a4191f4281657be14bcf.jpg', 'IMG-20261002-WA0049.jpg', 'image/jpeg', 165499, 'client_file', '15cm alto vinil', 1, '2026-10-02 10:18:12', '2026-10-02 10:18:12'),
(52, 56, '/uploads/orders/56/860957b671fc5df4ccebd910f12628ad03cd.png', 'Screenshot_20261003-135104.png', 'image/png', 463853, 'client_file', NULL, 1, '2026-10-03 13:53:48', '2026-10-03 13:53:48'),
(53, 58, '/uploads/orders/58/49afe24cf8201ac933bfdbb74865937da283.png', 'Screenshot_20261004-144553.png', 'image/png', 1553577, 'client_file', 'Lona 80x80cm', 1, '2026-10-04 14:47:32', '2026-10-04 14:47:32'),
(54, 58, '/uploads/orders/58/2e856f6e655afac1733292a59edaed65bb25.png', 'Screenshot_20261004-144543.png', 'image/png', 2463823, 'client_file', 'Papel 5x8cm', 1, '2026-10-04 14:49:58', '2026-10-04 14:49:58'),
(55, 61, '/uploads/orders/61/56e95bc809cc0bcb0ad0933912d363aa8688.jpg', 'IMG-20261005-WA0121.jpg', 'image/jpeg', 223646, 'client_file', 'Agregarle teléfono 627 518 6199', 1, '2026-10-05 17:57:11', '2026-10-05 17:57:11'),
(56, 62, '/uploads/orders/62/f7a3a2baba54b965f5c0da73c2a79a8fd8ac.jpg', 'IMG-20261005-WA0150.jpg', 'image/jpeg', 257112, 'client_file', 'Mila', 1, '2026-10-05 18:36:19', '2026-10-05 18:36:19');

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
(17, 17, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-22 08:08:53', '2026-09-28 19:45:52'),
(18, 25, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-22 20:47:18', '2026-09-22 20:47:36'),
(19, 24, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-23 09:15:17', '2026-09-30 15:34:03'),
(20, 18, 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-23 09:16:49', '2026-09-29 09:03:10'),
(21, 16, 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-23 09:17:14', '2026-09-23 09:17:21'),
(22, 23, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-23 09:19:14', '2026-10-07 09:54:22'),
(23, 22, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-23 09:20:07', '2026-10-07 09:53:41'),
(24, 26, 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-23 09:21:05', '2026-10-07 00:22:57'),
(25, 21, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-23 09:22:23', '2026-09-27 06:18:07'),
(26, 27, 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-23 10:07:47', '2026-09-28 22:18:41'),
(27, 28, 'delivered', '', 1, '2026-09-23 10:52:08', '2026-09-24 18:33:56'),
(28, 29, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-23 17:43:12', '2026-09-28 12:13:45'),
(29, 30, 'printing', 'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.', 1, '2026-09-23 20:23:05', '2026-09-25 11:19:05'),
(30, 31, 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-24 10:13:18', '2026-09-24 10:13:18'),
(31, 34, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-24 21:56:12', '2026-10-03 20:04:29'),
(32, 35, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-25 04:51:56', '2026-09-25 07:41:43'),
(33, 36, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-25 07:45:19', '2026-09-25 08:32:37'),
(34, 37, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-25 08:26:46', '2026-09-25 08:42:40'),
(35, 38, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-25 10:22:57', '2026-09-25 10:23:13'),
(36, 33, 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-09-26 10:34:55', '2026-10-06 12:09:28'),
(37, 32, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-28 02:06:48', '2026-09-28 02:07:20'),
(38, 39, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-28 02:07:31', '2026-09-28 02:07:50'),
(39, 42, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-28 18:15:33', '2026-09-28 18:15:46'),
(40, 41, 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-09-28 18:39:50', '2026-10-06 09:49:18'),
(41, 40, 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-09-29 09:25:57', '2026-09-29 09:29:36'),
(42, 43, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-29 16:45:27', '2026-10-05 16:44:56'),
(43, 47, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-29 19:09:31', '2026-10-05 16:45:23'),
(44, 46, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-09-29 19:09:37', '2026-10-05 16:45:39'),
(45, 44, 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-29 19:10:13', '2026-09-29 19:10:13'),
(46, 45, 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-29 19:10:24', '2026-09-29 19:10:24'),
(47, 48, 'delivered', '', 1, '2026-09-30 15:32:10', '2026-09-30 15:32:10'),
(48, 49, 'design', 'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.', 1, '2026-09-30 16:10:35', '2026-09-30 16:10:35'),
(49, 50, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-10-01 15:04:04', '2026-10-03 20:30:50'),
(50, 51, 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-10-01 17:50:36', '2026-10-05 16:46:07'),
(51, 52, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-10-01 17:53:50', '2026-10-01 17:55:50'),
(52, 57, 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-10-03 20:33:29', '2026-10-03 20:33:47'),
(53, 53, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-10-04 08:43:32', '2026-10-04 08:43:49'),
(54, 58, 'ready', 'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.', 1, '2026-10-04 14:54:11', '2026-10-07 10:00:58'),
(55, 54, 'production', 'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.', 1, '2026-10-06 09:57:27', '2026-10-06 15:36:13'),
(56, 59, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-10-06 12:08:09', '2026-10-06 12:08:24'),
(57, 61, 'delivered', 'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.', 1, '2026-10-07 00:21:29', '2026-10-07 00:21:29'),
(58, 63, 'quality', 'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.', 1, '2026-10-07 00:22:13', '2026-10-07 00:22:26');

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
(28, 39, 1223, 200.00, '2026-09-25', 'cash', NULL, 'ANTICIPO', 'confirmed', 1, 1, '2026-09-25 21:14:47', '2026-09-25 21:14:47'),
(29, 42, 1209, 950.04, '2026-09-28', 'transfer', NULL, NULL, 'confirmed', 1, 1, '2026-09-28 19:25:35', '2026-09-28 19:25:35'),
(30, 40, 1233, 1000.00, '2026-09-29', 'transfer', '280926', 'ANTICIPO', 'confirmed', 1, 1, '2026-09-29 09:25:38', '2026-09-29 09:25:38'),
(31, 44, 1286, 220.00, '2026-09-29', 'cash', NULL, 'ANTICIPO · Efectivo a Denisse', 'confirmed', 1, 1, '2026-09-29 11:01:49', '2026-09-29 11:01:49'),
(32, 45, 1287, 200.00, '2026-09-29', 'cash', NULL, 'ANTICIPO', 'confirmed', 1, 1, '2026-09-29 11:21:36', '2026-09-29 11:21:36'),
(33, 43, 1283, 600.00, '2026-09-29', 'cash', NULL, NULL, 'confirmed', 1, 1, '2026-09-29 16:46:15', '2026-09-29 16:46:15'),
(34, 46, 654, 270.00, '2026-09-29', 'transfer', NULL, NULL, 'confirmed', 1, 1, '2026-09-29 19:04:33', '2026-09-29 19:04:33'),
(35, 47, 1284, 560.00, '2026-09-29', 'transfer', NULL, NULL, 'confirmed', 1, 1, '2026-09-29 19:07:30', '2026-09-29 19:07:30'),
(36, 48, 1285, 1000.00, '2026-09-30', 'cash', NULL, 'ANTICIPO', 'confirmed', 1, 1, '2026-09-30 11:24:29', '2026-09-30 11:24:29'),
(37, 50, 1290, 700.00, '2026-10-03', 'cash', NULL, 'ANTICIPO', 'confirmed', 1, 1, '2026-10-03 20:30:59', '2026-10-03 20:30:59'),
(38, 58, 1296, 240.00, '2026-10-04', 'cash', NULL, 'ANTICIPO', 'confirmed', 1, 1, '2026-10-04 16:00:52', '2026-10-04 16:00:52'),
(39, 60, 1297, 1000.00, '2026-10-05', 'cash', NULL, 'ANTICIPO', 'confirmed', 1, 1, '2026-10-05 16:34:43', '2026-10-05 16:34:43'),
(40, 43, 1283, 300.00, '2026-10-05', 'cash', NULL, NULL, 'confirmed', 1, 1, '2026-10-05 16:45:11', '2026-10-05 16:45:11'),
(41, 61, 1298, 395.00, '2026-10-05', 'cash', NULL, 'ANTICIPO', 'confirmed', 1, 1, '2026-10-05 18:00:34', '2026-10-05 18:00:34'),
(42, 23, 1270, 1782.00, '2026-10-07', 'transfer', NULL, NULL, 'confirmed', 1, 1, '2026-10-07 09:55:21', '2026-10-07 09:55:21'),
(43, 22, 1270, 2457.00, '2026-10-07', 'transfer', NULL, NULL, 'confirmed', 1, 1, '2026-10-07 09:55:37', '2026-10-07 09:55:37');

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
(14, 21, NULL, '8e160aff0399a1d4b8ebabd3356049bdcbcb1c8a06cec04fb22b55b0f274b581', 'WhatsApp Image 2026-09-22 at 8.46.35 AM.jpeg', '/uploads/payment-receipts/21/8e160aff0399a1d4b8ebabd3356049bdcbcb1c8a06cec04fb22b55b0f274b581.jpg', 'image/jpeg', 60844, 'pending', '', NULL, NULL, '2026-09-26 10:46:11', '2026-09-26 10:46:11'),
(15, 42, NULL, '9c3cb730d0052e8e297c4ae5bb74d844dabb30b482d2427496000acd8d5ff400', 'comprobante_bbva-nc instituto de la juventud 21.pdf', '/uploads/payment-receipts/42/9c3cb730d0052e8e297c4ae5bb74d844dabb30b482d2427496000acd8d5ff400.pdf', 'application/pdf', 2971503, 'pending', '', NULL, NULL, '2026-09-28 18:17:55', '2026-09-28 18:17:55'),
(16, 40, NULL, '72a35e067388da46ac877e72dc3516c8fe4d21428f418b3adbfd8e29705bdc37', 'd6d8094c-b048-4922-85dd-12bf565b9f0d.jpg', '/uploads/payment-receipts/40/72a35e067388da46ac877e72dc3516c8fe4d21428f418b3adbfd8e29705bdc37.jpg', 'image/jpeg', 77893, 'pending', 'Anticipo para procesar la orden', NULL, NULL, '2026-09-29 09:24:45', '2026-09-29 09:24:45'),
(17, 40, NULL, 'b7f13ba6607d4c80c6a3b288374185f469c629478df1c500ed7f3c5a630925b9', 'solicitud de cliente.png', '/uploads/payment-receipts/40/b7f13ba6607d4c80c6a3b288374185f469c629478df1c500ed7f3c5a630925b9.png', 'image/png', 76612, 'pending', '', NULL, NULL, '2026-09-29 09:41:41', '2026-09-29 09:41:41'),
(18, 45, NULL, '781e91ddc7823d9e026452f98578cdadf9828114d85a7fa771b977657afdbfe7', 'IMG-20260928-WA0066.jpg', '/uploads/payment-receipts/45/781e91ddc7823d9e026452f98578cdadf9828114d85a7fa771b977657afdbfe7.jpg', 'image/jpeg', 75327, 'pending', '', NULL, NULL, '2026-09-29 11:20:42', '2026-09-29 11:20:42'),
(19, 41, NULL, 'eb226d4dad1ca8448ddc610a0e376b2616f5e02879ab3aad42d802e52a3de943', '29-09-2026 ERIKA ELIZABETH BUSTILLOS AGUIRRE.pdf', '/uploads/payment-receipts/41/eb226d4dad1ca8448ddc610a0e376b2616f5e02879ab3aad42d802e52a3de943.pdf', 'application/pdf', 75250, 'pending', 'Pago de la Orden', NULL, NULL, '2026-09-29 16:24:17', '2026-09-29 16:24:17'),
(20, 46, 34, 'd0966719e859c3b97abff0876c177688418dfce4c62d77191be758c55e1a92e6', 'WhatsApp Image 2026-09-29 at 6.06.54 PM.jpeg', '/uploads/payment-receipts/46/d0966719e859c3b97abff0876c177688418dfce4c62d77191be758c55e1a92e6.jpg', 'image/jpeg', 59022, 'confirmed', NULL, 1, '2026-09-29 19:04:50', '2026-09-29 18:29:57', '2026-09-29 19:04:50'),
(21, 47, 35, '209741af785ae2d01772bdfa095018bf9a68caf27208ea5169ebbdf6c8d8fd28', 'WhatsApp Image 2026-09-29 at 5.43.11 PM.jpeg', '/uploads/payment-receipts/47/209741af785ae2d01772bdfa095018bf9a68caf27208ea5169ebbdf6c8d8fd28.jpg', 'image/jpeg', 70904, 'confirmed', NULL, 1, '2026-09-29 19:08:49', '2026-09-29 19:08:21', '2026-09-29 19:08:49'),
(22, 51, NULL, '67ea9f7b86ba9f6a0268656c584c1c64ea9fdbac9800bbe97474fd2f433ec775', 'fa856ca2-75fe-4af5-aa04-0af2d3d31c3f.jpg', '/uploads/payment-receipts/51/67ea9f7b86ba9f6a0268656c584c1c64ea9fdbac9800bbe97474fd2f433ec775.jpg', 'image/jpeg', 112297, 'pending', '', NULL, NULL, '2026-10-01 17:50:19', '2026-10-01 17:50:19'),
(23, 52, NULL, '909a1ff74e308eae26b42d1c3010ff5d7888457b7b9fb07521b453910d2a1bc2', 'WhatsApp Image 2026-10-01 at 5.39.29 PM.jpeg', '/uploads/payment-receipts/52/909a1ff74e308eae26b42d1c3010ff5d7888457b7b9fb07521b453910d2a1bc2.jpg', 'image/jpeg', 60809, 'pending', '', NULL, NULL, '2026-10-01 17:54:33', '2026-10-01 17:54:33'),
(24, 58, NULL, 'c530022d00569ef37b15eff0e6ded7fa8ad67f2d8688e2aa27f9461498dc7baf', 'a3284d83-48f8-4dfb-8104-b2728c479ebb.jpg', '/uploads/payment-receipts/58/c530022d00569ef37b15eff0e6ded7fa8ad67f2d8688e2aa27f9461498dc7baf.jpg', 'image/jpeg', 65361, 'pending', '', NULL, NULL, '2026-10-04 15:49:48', '2026-10-04 15:49:48'),
(25, 22, NULL, '8e5e57eb157537639ee40004a55a9b26b22669b2eac0fa60e4672d916f491a69', 'WhatsApp Image 2026-10-07 at 9.50.53 AM.jpeg', '/uploads/payment-receipts/22/8e5e57eb157537639ee40004a55a9b26b22669b2eac0fa60e4672d916f491a69.jpg', 'image/jpeg', 47557, 'pending', '', NULL, NULL, '2026-10-07 09:54:09', '2026-10-07 09:54:09'),
(26, 23, NULL, '415755c497d6c46c7ea59ce460f77ae7d9bf77f6bd0eb87e3b50bcd05ef9f830', 'WhatsApp Image 2026-10-07 at 9.50.53 AM.jpeg', '/uploads/payment-receipts/23/415755c497d6c46c7ea59ce460f77ae7d9bf77f6bd0eb87e3b50bcd05ef9f830.jpg', 'image/jpeg', 47557, 'pending', 'Transferencia realizada para pago en orden de servicio \r\nOS-2026-00012\r\nOS-2026-00013', NULL, NULL, '2026-10-07 09:55:00', '2026-10-07 09:55:00');

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
(2, 'Laminado mate', 'mate', 0, 0, '2026-09-26 03:15:10', '2026-09-28 02:23:56'),
(3, 'Laminado brillante', 'brillante', 0, 0, '2026-09-26 03:15:10', '2026-09-28 02:23:33'),
(4, 'Laminado', 'laminado', 0, 0, '2026-09-26 03:15:10', '2026-09-28 02:23:47'),
(5, 'Engargolado', 'engargolado', 1, 40, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(13, 'Con Ojillos', 'col001', 1, 0, '2026-09-28 09:34:09', '2026-09-28 09:34:09'),
(14, 'SIN OJILLOS', 'cl002', 1, 0, '2026-09-28 09:34:23', '2026-09-28 09:34:23');

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
(1, 'Papel bond', 'bond', 1, 0, '2026-09-26 03:15:10', '2026-09-29 07:49:32', 'hoja'),
(2, 'Opalina', 'opalina', 1, 20, '2026-09-26 03:15:10', '2026-09-26 03:15:10', 'hoja'),
(4, 'Fotográfico', 'fotografico', 1, 40, '2026-09-26 03:15:10', '2026-09-26 03:15:10', 'hoja'),
(5, 'Adhesivo', 'adhesivo', 1, 50, '2026-09-26 03:15:10', '2026-09-26 03:15:10', 'hoja'),
(6, 'Cartulina', 'cartulina', 1, 20, '0000-00-00 00:00:00', '0000-00-00 00:00:00', 'hoja'),
(7, 'Vinil', 'vinil', 1, 40, '0000-00-00 00:00:00', '0000-00-00 00:00:00', 'pieza'),
(14, 'Lona 13oz', 'ln13oz', 1, 0, '2026-09-28 09:32:01', '2026-09-29 07:50:18', '1');

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
(3, 1, 1, 1, 'color', 'per_page', 5.00, 1, 1, '2026-09-26 05:19:33', '2026-09-28 01:45:19'),
(4, 2, 1, 1, 'color', 'per_page', 6.00, 1, 1, '2026-09-26 05:19:33', '2026-09-29 07:48:45'),
(8, 4, 1, 1, 'bw', 'per_page', 12.00, 1, 1, '2026-09-26 05:19:33', '2026-09-28 02:35:57'),
(9, 3, 1, 1, 'bw', 'per_page', 1.00, 1, 1, '2026-09-26 05:19:33', '2026-09-26 05:19:33'),
(10, 1, 1, 1, 'bw', 'per_page', 1.00, 1, 1, '2026-09-26 05:19:33', '2026-09-26 05:19:33'),
(11, 2, 1, 1, 'bw', 'per_page', 3.00, 1, 1, '2026-09-26 05:19:33', '2026-09-29 07:48:37'),
(18, 6, 1, 1, 'color', 'per_page', 80.00, 1, 0, '2026-09-26 05:31:31', '2026-09-26 16:32:49'),
(20, 9, 1, 1, 'color', 'per_page', 80.00, 1, 1, '2026-09-26 08:39:06', '2026-09-26 11:39:52'),
(23, 9, 1, 1, 'bw', 'per_page', 80.00, 1, 1, '2026-09-28 00:52:15', '2026-09-28 00:52:15'),
(24, 31, 14, 13, 'color', 'per_page', 140.00, 1, 1, '2026-09-28 10:03:29', '2026-09-28 10:03:29');

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
  `archive_status` enum('active','archived') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'active',
  `archived_at` datetime DEFAULT NULL,
  `archived_by` int(10) UNSIGNED DEFAULT NULL,
  `total_estimate` decimal(12,2) NOT NULL DEFAULT '0.00',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `cp_print_requests`
--

INSERT INTO `cp_print_requests` (`id`, `customer_name`, `customer_email`, `customer_phone`, `status`, `archive_status`, `archived_at`, `archived_by`, `total_estimate`, `created_at`, `updated_at`) VALUES
(14, 'ERIKA BUSTILLOS', 'wmaster1ro@gmail.com', '+526271074512', 'new', 'active', NULL, NULL, 80.00, '2026-09-26 17:07:58', '2026-09-26 17:07:58'),
(15, 'ERIKA BUSTILLOS', 'wmaster1ro@gmail.com', '+526271074512', 'new', 'active', NULL, NULL, 160.00, '2026-09-26 17:08:15', '2026-09-26 17:08:15'),
(16, 'ERIKA BUSTILLOS', 'wmaster1ro@gmail.com', '+526271074512', 'new', 'active', NULL, NULL, 160.00, '2026-09-26 17:10:04', '2026-09-26 17:10:04'),
(17, 'ERIKA BUSTILLOS', 'wmaster1ro@gmail.com', '+526271074512', 'new', 'active', NULL, NULL, 80.00, '2026-09-26 19:25:44', '2026-09-26 19:25:44'),
(18, 'ERIKA BUSTILLOS', 'wmaster1ro@gmail.com', '+526271074512', 'new', 'active', NULL, NULL, 80.00, '2026-09-27 05:58:42', '2026-09-27 05:58:42'),
(19, 'ERIKA BUSTILLOS', 'wmaster1ro@gmail.com', '+526271074512', 'new', 'active', NULL, NULL, 80.00, '2026-09-27 06:25:16', '2026-09-27 06:25:16'),
(20, 'ERIKA BUSTILLOS', 'wmaster1ro@gmail.com', '+526271074512', 'new', 'active', NULL, NULL, 800.00, '2026-09-27 08:47:23', '2026-09-27 08:47:23'),
(21, 'ERIKA BUSTILLOS', 'wmaster1ro@gmail.com', '+526271074512', 'new', 'active', NULL, NULL, 5.00, '2026-09-28 08:24:20', '2026-09-28 08:24:20'),
(22, 'LUIS MIGUEL GARDEA RODRIGUEZ', 'wmaster1ro@gmail.com', '+526271074512', 'new', 'active', NULL, NULL, 80.00, '2026-09-29 09:00:44', '2026-09-29 09:00:44');

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
(5, 'A2', 'a2', 420.00, 594.00, 'portrait', 0, 0, 0, '2026-09-26 03:15:10', '2026-09-28 01:44:18'),
(6, 'A1', 'a1', 594.00, 841.00, 'portrait', 0, 1, 60, '2026-09-26 03:15:10', '2026-09-26 03:15:10'),
(7, '10 × 15 cm', '10x15', 100.00, 150.00, 'portrait', 0, 1, 70, '2026-09-26 03:15:10', '2026-09-26 03:15:10'),
(8, '13 × 18 cm', '13x18', 130.00, 180.00, 'portrait', 0, 1, 80, '2026-09-26 03:15:10', '2026-09-26 03:15:10'),
(9, '60 × 90 cm', '60x90', 600.00, 900.00, 'portrait', 0, 1, 90, '2026-09-26 03:15:10', '2026-09-26 03:15:10'),
(10, 'Personalizado', 'custom', 0.00, 0.00, 'portrait', 1, 1, 999, '2026-09-26 03:15:10', '2026-09-26 03:15:10'),
(31, '1 Metro', '1x1', 1000.00, 1000.00, 'portrait', 0, 1, 0, '2026-09-28 09:32:48', '2026-09-28 09:40:37'),
(32, '1X1.5M', '1.5m', 1500.00, 1000.00, 'portrait', 0, 1, 0, '2026-09-28 09:33:16', '2026-09-28 09:41:59');

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
(3, 'local', NULL, 8, 'SELLO AUTOENTINTABLE', NULL, 'Sello autoentintable de 5.8x2.2 cm tinta negra.\r\nPodemos hacer tu propio diseño 100% personalizado.\r\nLos sellos ilustrados hacen que los papeles de clasificación sean rápidos y fáciles.\r\nAlienta a los estudiantes a seguir aprendiendo con mensajes positivos.\r\n\r\n*SÍ FACTURAMOS, PRECIO INCLUYE IVA Y ENVIO GRATIS A TODO MEXICO*\r\n\r\n***TU COMPRA INCLUYE 1 SELLO TRODAT MODELO 4913***\r\n\r\nLas imágenes de diseños mostradas son ejemplos/ideas para que puedas elegir el que más te guste o puedes enviarnos el tuyo. Se puede personalizar con tu nombre o los datos que indiques.\r\n\r\nCaracterísticas:\r\n-Sello automático\r\n-Pequeño y ligero\r\n-Personalizado\r\n-Limpio\r\n-Mecanismo con giro de 90°\r\n-Tinta negra\r\n-Medida: 52X22MM\r\n-Marca Trodat\r\n\r\nNOTA: Una vez realizada la compra favor de enviar los datos que desea agregar a tu sello personalizado en caso de no recibir la información se enviará sin personalizar.\r\n\r\nSi desea que la tinta de su sello sea de otro color se debe comprar el cojín de repuesto por separado, puede adquirirlo en el siguiente link es muy fácil de hacer el cambio de tinta:\r\n\r\nVersión para maestros:\r\nhttps://articulo.mercadolibre.com.mx/MLM-1840658797-sello-maestros-y-educadores-personalizado-58-x-22-cm-_JM\r\n\r\nKit de 5 sellos personalizados de madera (incluye cojín)\r\n\r\nhttps://articulo.mercadolibre.com.mx/MLM-2029360613-sellos-para-maestros-escolares-personalizados-de-madera-5-pz-_JM\r\n\r\nDISTRIBUIDORES TRODAT MÉXICO AUTORIZADOS.\r\n\r\nEstamos a tus ordenes en la sección de preguntas.', 490.00, 0.00, 'fixed', 1, 1, '2026-09-22 12:05:14', '2026-09-22 12:05:14'),
(4, 'local', NULL, 9, 'VINILO DECORATIVO JUNGLA KAWAII', NULL, 'Incluye todos los elementos que se muestran en la imagen', 490.00, NULL, 'fixed', 1, 1, '2026-10-04 13:25:48', '2026-10-04 13:32:46');

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
(3, 3, '/uploads/products/d4bf622a226cfa33081dd635f6c93ea3.webp', 'SELLO AUTOENTINTABLE', 0, 1, '2026-09-22 12:05:14'),
(6, 4, '/uploads/products/cd3207ab0d0a39f526b5107d13a156ca.jpg', 'VINILO DECORATIVO JUNGLA KAWAII', 0, 1, '2026-10-04 13:32:46');

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
(2, 'Taza Personalizada de Oferta', 'taza-personalizada-de-oferta', 'OFERTA', '☕🔥 **¡TU TAZA, TU ESTILO!** 🔥☕\r\n\r\n¿Quieres una taza que sea realmente tuya? 😍\r\nEn **Colibrí Print** personalizamos tus tazas con:\r\n\r\n❤️ Fotos ✨ Nombres 😂 Frases 🎨 Diseños 🏢 Logos para negocios\r\n\r\n🎁 **Ideal para regalar o consentirte.**\r\n📲 **WhatsApp: 627 147 0053**\r\n📍 **Colibrí Print | Personalizamos tus ideas**\r\n👉 Mándanos tu diseño o dinos qué quieres y **te cotizamos rápido.**\r\n#TazasPersonalizadas #TazasPersonalizadasMexico #RegalosPersonalizados #ColibriPrint #TazasConFoto', 'fixed', 100.00, 50.00, 50.00, 15, '2026-10-01', '2026-10-31', '/uploads/promotions/3079517b95132ffd7432ebf5cf485a45.png', NULL, 'active', 1, 1, 1, 1, 1, '2026-09-19 21:51:35', '2026-10-04 13:19:31'),
(3, 'Sello Escolar Autoentintable', 'sello-escolar-autoentintable', 'OFERTA', NULL, 'fixed', 490.00, 390.00, 20.41, NULL, '2026-10-01', '2026-10-31', '/uploads/promotions/fa0e361d7d1c8fe7d60ce39600780ddf.png', NULL, 'active', 1, 1, 0, 1, 1, '2026-09-22 12:04:02', '2026-10-04 13:19:04'),
(4, 'Vinilo Decorativo Kawaii', 'vinilo-decorativo-kawaii', 'OFERTA', 'Incluye todos los elementos que se muestran en la imagen promocional', 'fixed', 490.00, 350.00, 28.57, 10, '2026-10-04', NULL, NULL, NULL, 'active', 1, 1, 0, 1, 1, '2026-10-04 13:26:05', '2026-10-04 13:26:05');

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
(4, 2, 1, NULL, 'error', '667900884988501', NULL, 'https://colibriprint.com.mx/uploads/promotions/3079517b95132ffd7432ebf5cf485a45.png', 'Invalid OAuth access token - Cannot parse access token', '{\"error\":{\"message\":\"Invalid OAuth access token - Cannot parse access token\",\"type\":\"OAuthException\",\"code\":190,\"fbtrace_id\":\"AbBYa_o--ZO5fLaE-xqqREx\"}}', 6, '2026-10-04 13:19:31', NULL, '2026-09-19 21:51:35', '2026-10-04 13:19:31'),
(9, 3, 1, NULL, 'error', '667900884988501', NULL, 'https://colibriprint.com.mx/uploads/promotions/fa0e361d7d1c8fe7d60ce39600780ddf.png', 'Invalid OAuth access token - Cannot parse access token', '{\"error\":{\"message\":\"Invalid OAuth access token - Cannot parse access token\",\"type\":\"OAuthException\",\"code\":190,\"fbtrace_id\":\"A6fG24hJbeNazAMS2jVPVJC\"}}', 6, '2026-10-04 13:19:04', NULL, '2026-09-22 12:04:02', '2026-10-04 13:19:04'),
(19, 4, 1, NULL, 'error', '667900884988501', NULL, 'https://colibriprint.com.mx/uploads/products/2950acfded6b6c8b678397f0bdbf4ac1.jpg', 'Invalid OAuth access token - Cannot parse access token', '{\"error\":{\"message\":\"Invalid OAuth access token - Cannot parse access token\",\"type\":\"OAuthException\",\"code\":190,\"fbtrace_id\":\"AciF8JWWXyT0SLfGv5LtEeJ\"}}', 1, '2026-10-04 13:26:05', NULL, '2026-10-04 13:26:05', '2026-10-04 13:26:05');

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
(16, 1, 1, 0, '2026-09-22 19:31:40'),
(19, 3, 3, 0, '2026-10-04 13:19:04'),
(20, 2, 2, 0, '2026-10-04 13:19:31'),
(21, 4, 4, 0, '2026-10-04 13:26:05');

-- --------------------------------------------------------

--
-- Table structure for table `cp_quotes`
--

CREATE TABLE `cp_quotes` (
  `id` int(10) UNSIGNED NOT NULL,
  `quote_number` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_id` int(10) UNSIGNED DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `client_approved_at` datetime DEFAULT NULL,
  `client_approval_ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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

INSERT INTO `cp_quotes` (`id`, `quote_number`, `customer_id`, `status`, `client_approved_at`, `client_approval_ip`, `issue_date`, `valid_until`, `client_reference`, `payment_terms`, `delivery_time`, `delivery_place`, `notes`, `terms`, `internal_notes`, `source_calculator`, `source_data`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(13, 'CP-2026-00001', 1207, 'approved', NULL, NULL, '2026-09-08', '2026-09-16', '11 trofeos y 2 libros de firmas', NULL, NULL, 'Colibrí Print México', '', 'Cotización sujeta a disponibilidad de materiales y aprobación del cliente.', 'Pedido Retrasado desde el día 16 de septiembre', NULL, NULL, 1, 1, '2026-09-19 10:50:15', '2026-09-21 10:14:31'),
(14, 'CP-2026-00002', 856, 'approved', NULL, NULL, '2026-07-30', '2026-08-27', NULL, NULL, NULL, NULL, '', 'Cotización sujeta a disponibilidad de materiales y aprobación del cliente.', '', NULL, NULL, 1, 1, '2026-09-19 10:56:30', '2026-09-19 10:56:46'),
(15, 'CP-2026-00003', 1263, 'approved', NULL, NULL, '2026-09-12', '2026-09-17', NULL, NULL, NULL, 'Colibrí Print México', '', '', 'Enviar diseño primero\r\nLa troca Morada va en medio del diseño\r\n\r\nCliente adeuda 90 pesos', NULL, NULL, 1, 1, '2026-09-19 11:13:45', '2026-09-22 09:10:03'),
(16, 'CP-2026-00004', 640, 'approved', NULL, NULL, '2026-09-17', '2026-09-20', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', 'dirección\r\nCalle arbol de hierro no.20306\r\nColonia fraccionamiento parque industrial \r\nChihuahua, Chih.\r\nY en numero de teléfono que diga 5655484613 el mismo número que viene en las tarjetas fe presentación\r\n\r\nhttps://chatgpt.com/s/p_62e5de6cbbfc8191aa38300bbafa1de3', NULL, NULL, 1, 1, '2026-09-19 11:40:58', '2026-09-19 16:40:54'),
(17, 'CP-2026-00005', 1266, 'approved', NULL, NULL, '2026-09-18', '2026-09-21', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', 'Dio $100 de anticipo', NULL, NULL, 1, 1, '2026-09-19 17:05:47', '2026-09-19 17:21:24'),
(18, 'CP-2026-00006', 544, 'approved', NULL, NULL, '2026-09-17', '2026-09-25', 'Rotulación de Camiones', '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Antes de finalizar mes', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', 'Se factura a inicios de Octubre y paga a mediados de Octubre', NULL, NULL, 1, 1, '2026-09-19 17:15:41', '2026-09-19 17:16:23'),
(19, 'CP-2026-00007', 930, 'approved', NULL, NULL, '2026-09-18', '2026-09-22', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-19 17:26:00', '2026-09-19 20:24:06'),
(20, 'CP-2026-00008', 340, 'approved', NULL, NULL, '2026-09-14', '2026-09-23', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', 'Las libretas son con tres imágenes en la portada y todas las 50 iguales\r\n\r\nLogo en mouse Pad lo más arriba para que no se dañe con uso de mano o mouse', NULL, NULL, 1, 1, '2026-09-19 18:35:05', '2026-09-19 19:20:42'),
(28, 'CP-2026-00009', 1, 'approved', NULL, NULL, '2026-09-20', '2026-10-05', 'Solicitud web CPQ-000006', '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Entrega local', 'Solicitud recibida desde la web: CPQ-000006.\r\nFecha solicitada: 2026-09-21.\r\nForma de entrega: Entrega local.\r\nlo quiero para el tanque de una moto', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', 'ORIGEN: Solicitud web CPQ-000006\r\nSolicitud web ID: 6\r\nServicio: Vinil de corte (vinil)\r\nCliente capturado: PANCHITO\r\nWhatsApp: 6271074512\r\nCorreo: No indicado\r\nFecha solicitada: 2026-09-21\r\nDETALLES: Quantity: 1 · Surface: Vehículo · Size: 20x20cm · Color: negro\r\nPRODUCCIÓN: Design Status: Tengo el diseño final · Application: No lo sé todavía · Notes: lo quiero para el tanque de una moto\r\nENTREGA: Method: Entrega local · Desired Date: 2026-09-21\r\nARCHIVO: ChatGPT Image Aug 12, 2026, 11_51_30 AM.png\r\nPAYLOAD WEB: {\"version\":3,\"service\":{\"key\":\"vinil\",\"name\":\"Vinil de corte\"},\"details\":{\"quantity\":\"1\",\"surface\":\"Vehículo\",\"size\":\"20x20cm\",\"color\":\"negro\"},\"production\":{\"design_status\":\"Tengo el diseño final\",\"application\":\"No lo sé todavía\",\"notes\":\"lo quiero para el tanque de una moto\"},\"delivery\":{\"method\":\"Entrega local\",\"desired_date\":\"2026-09-21\"},\"attachments\":[{\"original_name\":\"ChatGPT Image Aug 12, 2026, 11_51_30 AM.png\",\"relative_path\":\"/uploads/cotizador/dc16a9fa614f0081ce52617ea2e2eec6abee67c5f6d9e9c9ce66aa67c5a4ce89/f3528e00ad7ef942d24613dfb69c4439.png\",\"mime\":\"image/png\",\"size\":865581,\"extension\":\"png\",\"sha256\":\"bd6c3534c3578c81f4de2f65eee01f7b6bac566a1f20d0c271d26f3dfb816317\"}],\"attachment\":{\"original_name\":\"ChatGPT Image Aug 12, 2026, 11_51_30 AM.png\",\"relative_path\":\"/uploads/cotizador/dc16a9fa614f0081ce52617ea2e2eec6abee67c5f6d9e9c9ce66aa67c5a4ce89/f3528e00ad7ef942d24613dfb69c4439.png\",\"mime\":\"image/png\",\"size\":865581,\"extension\":\"png\",\"sha256\":\"bd6c3534c3578c81f4de2f65eee01f7b6bac566a1f20d0c271d26f3dfb816317\"},\"submitted_at\":\"2026-09-20T00:05:17-06:00\",\"source\":\"public_quote_wizard\",\"ip_hash\":\"6e2f47d9c108c37106dd6710e224743a86073951dc4827e3c29f8e7bb6e662c9\"}', 'web', '{\"source\":\"web\",\"title\":\"Vinil de corte\",\"input\":{\"quantity\":\"1\",\"surface\":\"Vehículo\",\"size\":\"20x20cm\",\"color\":\"negro\"},\"result\":[],\"web_request_id\":6,\"request_token\":\"dc16a9fa614f0081ce52617ea2e2eec6abee67c5f6d9e9c9ce66aa67c5a4ce89\",\"payload\":{\"version\":3,\"service\":{\"key\":\"vinil\",\"name\":\"Vinil de corte\"},\"details\":{\"quantity\":\"1\",\"surface\":\"Vehículo\",\"size\":\"20x20cm\",\"color\":\"negro\"},\"production\":{\"design_status\":\"Tengo el diseño final\",\"application\":\"No lo sé todavía\",\"notes\":\"lo quiero para el tanque de una moto\"},\"delivery\":{\"method\":\"Entrega local\",\"desired_date\":\"2026-09-21\"},\"attachments\":[{\"original_name\":\"ChatGPT Image Aug 12, 2026, 11_51_30 AM.png\",\"relative_path\":\"/uploads/cotizador/dc16a9fa614f0081ce52617ea2e2eec6abee67c5f6d9e9c9ce66aa67c5a4ce89/f3528e00ad7ef942d24613dfb69c4439.png\",\"mime\":\"image/png\",\"size\":865581,\"extension\":\"png\",\"sha256\":\"bd6c3534c3578c81f4de2f65eee01f7b6bac566a1f20d0c271d26f3dfb816317\"}],\"attachment\":{\"original_name\":\"ChatGPT Image Aug 12, 2026, 11_51_30 AM.png\",\"relative_path\":\"/uploads/cotizador/dc16a9fa614f0081ce52617ea2e2eec6abee67c5f6d9e9c9ce66aa67c5a4ce89/f3528e00ad7ef942d24613dfb69c4439.png\",\"mime\":\"image/png\",\"size\":865581,\"extension\":\"png\",\"sha256\":\"bd6c3534c3578c81f4de2f65eee01f7b6bac566a1f20d0c271d26f3dfb816317\"},\"submitted_at\":\"2026-09-20T00:05:17-06:00\",\"source\":\"public_quote_wizard\",\"ip_hash\":\"6e2f47d9c108c37106dd6710e224743a86073951dc4827e3c29f8e7bb6e662c9\"},\"attachment\":{\"original_name\":\"ChatGPT Image Aug 12, 2026, 11_51_30 AM.png\",\"relative_path\":\"/uploads/cotizador/dc16a9fa614f0081ce52617ea2e2eec6abee67c5f6d9e9c9ce66aa67c5a4ce89/f3528e00ad7ef942d24613dfb69c4439.png\",\"mime\":\"image/png\",\"size\":865581,\"extension\":\"png\",\"sha256\":\"bd6c3534c3578c81f4de2f65eee01f7b6bac566a1f20d0c271d26f3dfb816317\"},\"created_at\":\"2026-09-20T00:07:09-06:00\"}', 1, 1, '2026-09-20 00:07:09', '2026-09-20 00:10:30'),
(29, 'CP-2026-00010', 1, 'approved', NULL, NULL, '2026-09-20', '2026-10-05', 'Solicitud web CPQ-000007', '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Entrega local', 'Solicitud recibida desde la web: CPQ-000007.\r\nFecha solicitada: 2026-09-26.\r\nForma de entrega: Entrega local.\r\nQUIERO GRABAR UN LOGO EN EL YETI', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', 'ORIGEN: Solicitud web CPQ-000007\r\nSolicitud web ID: 7\r\nServicio: Grabado láser (laser)\r\nCliente capturado: MIGUEL\r\nWhatsApp: 6271074512\r\nCorreo: No indicado\r\nFecha solicitada: 2026-09-26\r\nDETALLES: Quantity: 1 · Material: YETI · Detail: LOGO\r\nPRODUCCIÓN: Design Status: Solo tengo la idea · Application: No lo sé todavía · Notes: QUIERO GRABAR UN LOGO EN EL YETI\r\nENTREGA: Method: Entrega local · Desired Date: 2026-09-26\r\nARCHIVO: Logo 2027.png\r\nPAYLOAD WEB: {\"version\":3,\"service\":{\"key\":\"laser\",\"name\":\"Grabado láser\"},\"details\":{\"quantity\":\"1\",\"material\":\"YETI\",\"size\":\"\",\"detail\":\"LOGO\"},\"production\":{\"design_status\":\"Solo tengo la idea\",\"application\":\"No lo sé todavía\",\"notes\":\"QUIERO GRABAR UN LOGO EN EL YETI\"},\"delivery\":{\"method\":\"Entrega local\",\"desired_date\":\"2026-09-26\"},\"attachments\":[{\"original_name\":\"Logo 2027.png\",\"relative_path\":\"/uploads/cotizador/a378b7984cc574c69e83c15d69bb71d687063bf794d6b9f0d96df7712cb0c4d6/dc8c622bcedc99bca185c706a292f25f.png\",\"mime\":\"image/png\",\"size\":1222567,\"extension\":\"png\",\"sha256\":\"9dccdc6bdbaa3c9c84bcde4280249629f42032dc2144b11c3804199c2899b506\"}],\"attachment\":{\"original_name\":\"Logo 2027.png\",\"relative_path\":\"/uploads/cotizador/a378b7984cc574c69e83c15d69bb71d687063bf794d6b9f0d96df7712cb0c4d6/dc8c622bcedc99bca185c706a292f25f.png\",\"mime\":\"image/png\",\"size\":1222567,\"extension\":\"png\",\"sha256\":\"9dccdc6bdbaa3c9c84bcde4280249629f42032dc2144b11c3804199c2899b506\"},\"submitted_at\":\"2026-09-20T00:21:07-06:00\",\"source\":\"public_quote_wizard\",\"ip_hash\":\"6e2f47d9c108c37106dd6710e224743a86073951dc4827e3c29f8e7bb6e662c9\"}', 'web', '{\"source\":\"web\",\"title\":\"Grabado láser\",\"input\":{\"quantity\":\"1\",\"material\":\"YETI\",\"size\":\"\",\"detail\":\"LOGO\"},\"result\":[],\"web_request_id\":7,\"request_token\":\"a378b7984cc574c69e83c15d69bb71d687063bf794d6b9f0d96df7712cb0c4d6\",\"payload\":{\"version\":3,\"service\":{\"key\":\"laser\",\"name\":\"Grabado láser\"},\"details\":{\"quantity\":\"1\",\"material\":\"YETI\",\"size\":\"\",\"detail\":\"LOGO\"},\"production\":{\"design_status\":\"Solo tengo la idea\",\"application\":\"No lo sé todavía\",\"notes\":\"QUIERO GRABAR UN LOGO EN EL YETI\"},\"delivery\":{\"method\":\"Entrega local\",\"desired_date\":\"2026-09-26\"},\"attachments\":[{\"original_name\":\"Logo 2027.png\",\"relative_path\":\"/uploads/cotizador/a378b7984cc574c69e83c15d69bb71d687063bf794d6b9f0d96df7712cb0c4d6/dc8c622bcedc99bca185c706a292f25f.png\",\"mime\":\"image/png\",\"size\":1222567,\"extension\":\"png\",\"sha256\":\"9dccdc6bdbaa3c9c84bcde4280249629f42032dc2144b11c3804199c2899b506\"}],\"attachment\":{\"original_name\":\"Logo 2027.png\",\"relative_path\":\"/uploads/cotizador/a378b7984cc574c69e83c15d69bb71d687063bf794d6b9f0d96df7712cb0c4d6/dc8c622bcedc99bca185c706a292f25f.png\",\"mime\":\"image/png\",\"size\":1222567,\"extension\":\"png\",\"sha256\":\"9dccdc6bdbaa3c9c84bcde4280249629f42032dc2144b11c3804199c2899b506\"},\"submitted_at\":\"2026-09-20T00:21:07-06:00\",\"source\":\"public_quote_wizard\",\"ip_hash\":\"6e2f47d9c108c37106dd6710e224743a86073951dc4827e3c29f8e7bb6e662c9\"},\"attachment\":{\"original_name\":\"Logo 2027.png\",\"relative_path\":\"/uploads/cotizador/a378b7984cc574c69e83c15d69bb71d687063bf794d6b9f0d96df7712cb0c4d6/dc8c622bcedc99bca185c706a292f25f.png\",\"mime\":\"image/png\",\"size\":1222567,\"extension\":\"png\",\"sha256\":\"9dccdc6bdbaa3c9c84bcde4280249629f42032dc2144b11c3804199c2899b506\"},\"created_at\":\"2026-09-20T00:21:58-06:00\"}', 1, 1, '2026-09-20 00:21:58', '2026-09-20 00:23:17'),
(30, 'CP-2026-00011', 763, 'approved', NULL, NULL, '2026-09-22', '2026-09-25', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / Colibrí Print', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-22 08:38:12', '2026-09-22 08:38:30'),
(31, 'CP-2026-00012', 1270, 'approved', NULL, NULL, '2026-09-21', '2026-10-05', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', NULL, 'Hidalgo del Parral, Chihuahua /', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-22 10:38:27', '2026-09-25 13:24:49'),
(32, 'CP-2026-00013', 1270, 'approved', NULL, NULL, '2026-09-21', '2026-10-05', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-22 10:53:47', '2026-09-22 10:54:06'),
(33, 'CP-2026-00014', 1039, 'approved', NULL, NULL, '2026-09-22', '2026-09-24', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', 'Ya revisé los números con la Señora Bujaidar , los 2 colores en las hojas serán Shedton y mostaza y la frase en shedron así como la imagen', 'París:\r\n16 hojas shedron\r\n16 hojas mostaza \r\n8 frases\r\n\r\nRoma:\r\n14 hojas shedron\r\n14 hojas mostaza \r\n7 frases', '', NULL, NULL, 1, 1, '2026-09-22 11:05:30', '2026-09-25 11:20:29'),
(34, 'CP-2026-00015', 908, 'approved', NULL, NULL, '2026-09-22', '2026-09-23', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-22 14:18:56', '2026-09-22 14:19:11'),
(35, 'CP-2026-00016', 1204, 'approved', NULL, NULL, '2026-09-22', '2026-09-25', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-22 14:29:17', '2026-09-23 09:57:45'),
(36, 'CP-2026-00017', 769, 'approved', NULL, NULL, '2026-09-22', '2026-10-07', 'CALCA VINILO VENTA DE AUTO', '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-22 20:46:26', '2026-09-22 20:46:32'),
(37, 'CP-2026-00018', 571, 'approved', NULL, NULL, '2026-09-23', '2026-09-25', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', '', '', NULL, NULL, 1, 1, '2026-09-23 09:06:41', '2026-09-23 09:06:52'),
(38, 'CP-2026-00019', 1271, 'approved', NULL, NULL, '2026-09-23', '2026-09-24', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-23 10:44:17', '2026-09-23 10:44:56'),
(39, 'CP-2026-00020', 746, 'approved', NULL, NULL, '2026-09-23', '2026-09-30', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-23 20:02:07', '2026-09-24 10:36:10'),
(40, 'CP-2026-00021', 1272, 'approved', NULL, NULL, '2026-09-24', '2026-09-26', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-24 09:58:55', '2026-09-24 09:59:48'),
(41, 'CP-2026-00022', 1273, 'approved', NULL, NULL, '2026-09-24', '2026-10-09', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-24 10:59:02', '2026-09-24 18:27:41'),
(42, 'CP-2026-00023', 1197, 'approved', NULL, NULL, '2026-09-24', '2026-09-26', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-24 12:35:53', '2026-09-24 12:36:02'),
(43, 'CP-2026-00024', 207, 'approved', NULL, NULL, '2026-09-24', '2026-09-25', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-24 17:37:06', '2026-09-24 17:37:14'),
(44, 'CP-2026-00025', 1274, 'sent', NULL, NULL, '2026-09-24', '2026-10-09', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', 'en la compra del paquete completo, las sudaderas de los docentes titulares son Gratis', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-24 18:23:55', '2026-09-24 18:24:30'),
(45, 'CP-2026-00026', 1209, 'approved', NULL, NULL, '2026-09-24', '2026-09-25', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-24 21:15:24', '2026-09-28 18:14:42'),
(46, 'CP-2026-00027', 1275, 'approved', NULL, NULL, '2026-09-25', '2026-09-26', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-25 04:50:42', '2026-09-25 04:51:44'),
(47, 'CP-2026-00028', 1276, 'approved', NULL, NULL, '2026-09-25', '2026-10-09', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-25 07:44:10', '2026-09-25 07:44:28'),
(48, 'CP-2026-00029', 1277, 'approved', NULL, NULL, '2026-09-25', '2026-09-25', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-25 08:14:22', '2026-09-25 08:15:20'),
(49, 'CP-2026-00030', 1279, 'approved', NULL, NULL, '2026-09-25', '2026-10-10', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-25 10:00:16', '2026-09-25 10:00:19'),
(50, 'CP-2026-00031', 1209, 'approved', NULL, NULL, '2026-09-25', '2026-10-10', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-25 12:14:52', '2026-09-25 12:15:02'),
(51, 'CP-2026-00032', 1280, 'approved', NULL, NULL, '2026-09-25', '2026-09-26', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto (1-2 días hábiles)', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', 'Impresión con unión a mitad de lienzo', 'Impresión con unión a mitad de lienzo', 'Impresión con unión a mitad de lienzo', NULL, NULL, 1, 1, '2026-09-25 17:08:33', '2026-09-28 17:12:32'),
(52, 'CP-2026-00033', 1281, 'draft', NULL, NULL, '2026-09-25', '2026-10-10', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', 'Saily Yanira Herrera Vargas\r\n\r\nChambelán Aldo orpineda\r\n\r\nPadres \r\nRefugio Herrera Gutiérrez \r\nNereida Vargas Macías\r\n\r\nCeremonia \r\n2:30 pm\r\n\r\nCalle de la cava \r\nNúmero 5\r\nColonia las parras', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-25 19:28:54', '2026-09-25 19:31:07'),
(53, 'CP-2026-00034', 1282, 'draft', NULL, NULL, '2026-09-25', '2026-10-10', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-25 19:53:45', '2026-09-25 20:00:27'),
(54, 'CP-2026-00035', 1223, 'approved', NULL, NULL, '2026-09-25', '2026-09-26', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-25 20:36:20', '2026-09-25 20:36:49'),
(58, 'CP-2026-00036', 1233, 'approved', NULL, NULL, '2026-09-28', '2026-10-03', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-28 11:24:00', '2026-09-28 12:16:08'),
(59, 'CP-2026-00037', 1283, 'approved', NULL, NULL, '2026-09-28', '2026-09-30', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', 'Grabado personalizado de piezas', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-28 18:30:12', '2026-09-29 16:58:51'),
(60, 'CP-2026-00038', 1053, 'draft', NULL, NULL, '2026-09-29', '2026-10-03', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-29 09:06:59', '2026-09-29 09:46:10'),
(61, 'CP-2026-00039', 1284, 'approved', NULL, NULL, '2026-09-29', '2026-10-03', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-29 09:51:11', '2026-09-29 19:06:46'),
(62, 'CP-2026-00040', 1285, 'approved', NULL, NULL, '2026-09-29', '2026-09-30', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-29 10:20:35', '2026-09-30 11:23:09'),
(63, 'CP-2026-00041', 1286, 'approved', NULL, NULL, '2026-09-29', '2026-10-14', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-29 10:59:36', '2026-09-29 10:59:46'),
(64, 'CP-2026-00042', 1287, 'approved', NULL, NULL, '2026-09-29', '2026-10-07', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-29 11:06:57', '2026-09-29 11:07:07'),
(65, 'CP-2026-00043', 1288, 'draft', NULL, NULL, '2026-09-29', '2026-10-14', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-29 12:20:19', '2026-09-29 12:20:19'),
(66, 'CP-2026-00044', 654, 'approved', NULL, NULL, '2026-09-29', '2026-10-03', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-29 13:18:48', '2026-09-29 13:19:04'),
(67, 'CP-2026-00045', 908, 'draft', NULL, NULL, '2026-09-29', '2026-10-14', 'LEERFLIX Quién Lee hoy?', '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-29 23:03:33', '2026-09-29 23:04:24'),
(68, 'CP-2026-00046', 1289, 'approved', NULL, NULL, '2026-09-30', '2026-10-15', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-30 16:02:19', '2026-09-30 16:05:49'),
(69, 'CP-2026-00047', 1290, 'approved', NULL, NULL, '2026-09-30', '2026-09-30', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-09-30 16:49:44', '2026-09-30 16:51:36'),
(70, 'CP-2026-00048', 1291, 'draft', NULL, NULL, '2026-10-01', '2026-10-16', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-10-01 14:13:27', '2026-10-01 14:43:44'),
(71, 'CP-2026-00049', 459, 'approved', NULL, NULL, '2026-10-01', '2026-10-08', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-10-01 17:30:12', '2026-10-01 17:49:38'),
(72, 'CP-2026-00050', 1292, 'approved', NULL, NULL, '2026-10-01', '2026-10-01', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-10-01 17:52:09', '2026-10-01 17:52:20'),
(73, 'CP-2026-00051', 1280, 'approved', NULL, NULL, '2026-10-02', '2026-10-09', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-10-02 09:55:45', '2026-10-02 16:31:59'),
(74, 'CP-2026-00052', 227, 'approved', NULL, NULL, '2026-10-02', '2026-10-02', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-10-02 10:16:25', '2026-10-02 10:16:40'),
(75, 'CP-2026-00053', 1130, 'draft', NULL, NULL, '2026-10-02', '2026-10-08', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-10-02 18:08:12', '2026-10-02 18:08:12'),
(76, 'CP-2026-00054', 1294, 'approved', NULL, NULL, '2026-10-03', '2026-10-05', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-10-03 13:50:10', '2026-10-03 13:50:20'),
(77, 'CP-2026-00055', 1295, 'approved', NULL, NULL, '2026-10-03', '2026-10-18', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-10-03 13:53:15', '2026-10-03 13:53:24'),
(78, 'CP-2026-00056', 544, 'approved', NULL, NULL, '2026-10-02', '2026-10-17', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-10-03 15:28:34', '2026-10-03 15:28:43'),
(79, 'CP-2026-00057', 1296, 'approved', NULL, NULL, '2026-10-04', '2026-10-19', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-10-04 14:45:11', '2026-10-04 14:45:25'),
(80, 'CP-2026-00058', 1284, 'approved', NULL, NULL, '2026-10-04', '2026-10-05', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-10-05 09:57:39', '2026-10-05 09:57:50'),
(81, 'CP-2026-00059', 1297, 'approved', NULL, NULL, '2026-10-05', '2026-10-20', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-10-05 16:33:41', '2026-10-05 16:34:21'),
(82, 'CP-2026-00060', 1298, 'approved', NULL, NULL, '2026-10-05', '2026-10-06', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-10-05 17:55:40', '2026-10-05 17:56:01'),
(83, 'CP-2026-00061', 726, 'approved', NULL, NULL, '2026-10-05', '2026-10-09', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-10-05 18:30:36', '2026-10-05 18:31:32'),
(84, 'CP-2026-00062', 1299, 'draft', NULL, NULL, '2026-10-06', '2026-10-21', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-10-06 10:09:25', '2026-10-06 10:15:14'),
(85, 'CP-2026-00063', 1082, 'draft', NULL, NULL, '2026-10-06', '2026-10-21', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-10-06 11:15:35', '2026-10-06 11:15:35'),
(86, 'CP-2026-00064', 1300, 'draft', NULL, NULL, '2026-10-06', '2026-10-21', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-10-06 13:21:03', '2026-10-06 13:21:03'),
(87, 'CP-2026-00065', 890, 'approved', NULL, NULL, '2026-10-06', '2026-10-10', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-10-06 14:33:08', '2026-10-07 00:30:16'),
(88, 'CP-2026-00066', 1280, 'approved', NULL, NULL, '2026-10-02', '2026-10-09', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-10-06 16:02:27', '2026-10-06 16:02:38'),
(89, 'CP-2026-00067', 1301, 'draft', NULL, NULL, '2026-10-06', '2026-10-09', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-10-06 19:13:51', '2026-10-06 19:13:51'),
(90, 'CP-2026-00068', 1302, 'draft', NULL, NULL, '2026-10-07', '2026-10-12', NULL, '50% de anticipo y 50% contra entrega, salvo acuerdo distinto por escrito.', 'Tiempo estimado según proyecto y disponibilidad de materiales.', 'Hidalgo del Parral, Chihuahua / domicilio acordado con el cliente.', '', 'Cotización sujeta a disponibilidad de materiales, aprobación del cliente y cambios de alcance. Los tiempos pueden variar según materiales, producción y carga de trabajo. Cualquier modificación al proyecto puede generar ajustes de precio y entrega.', '', NULL, NULL, 1, 1, '2026-10-07 10:54:17', '2026-10-07 10:54:17');

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
(151, 54, 'Taza personalizada Radiorama', 5.000, 70.00, 350.00, NULL, 0, '2026-09-25 20:36:20', '2026-09-25 20:36:20'),
(164, 58, 'Etiqueta impresa medida 15x12cm (45pz) 1m x 1.5m', 1.000, 150.00, 150.00, NULL, 0, '2026-09-28 12:16:08', '2026-09-28 12:16:08'),
(165, 58, 'Etiqueta impresa medida 10x8cm (110pz) 1m x 1.5m', 8.000, 150.00, 1200.00, NULL, 1, '2026-09-28 12:16:08', '2026-09-28 12:16:08'),
(166, 58, 'Suaje de etiquetas', 4.000, 70.00, 280.00, NULL, 2, '2026-09-28 12:16:08', '2026-09-28 12:16:08'),
(168, 51, 'Impresión de lona medida 390cm x 240cm incluye 10cm de rebase para tensado', 6.000, 1029.00, 6174.00, NULL, 0, '2026-09-28 17:12:32', '2026-09-28 17:12:32'),
(174, 60, 'Cartel vinil impreso y coroplast medida 120 x 90 cm', 6.000, 450.00, 2700.00, NULL, 0, '2026-09-29 09:46:10', '2026-09-29 09:46:10'),
(178, 63, 'Sudadera capucha y cangurera personalizada con fotos', 1.000, 420.00, 420.00, NULL, 0, '2026-09-29 10:59:36', '2026-09-29 10:59:36'),
(179, 64, 'Cojín personalizado un solo lado medida 40x40cm', 1.000, 290.00, 290.00, NULL, 0, '2026-09-29 11:06:57', '2026-09-29 11:06:57'),
(180, 61, 'Decorativo Vinil impreso y coroplast medida 80cm alto corte contorno', 1.000, 290.00, 290.00, NULL, 0, '2026-09-29 11:17:49', '2026-09-29 11:17:49'),
(181, 61, 'Impresión Papel poster medida doble carta', 6.000, 45.00, 270.00, NULL, 1, '2026-09-29 11:17:49', '2026-09-29 11:17:49'),
(182, 65, 'Servilletero con imagen ambos lados, MDF natural', 30.000, 45.00, 1350.00, NULL, 0, '2026-09-29 12:20:19', '2026-09-29 12:20:19'),
(183, 66, 'Paq 100 tarjetas de presentación impresas un solo lado', 1.000, 200.00, 200.00, NULL, 0, '2026-09-29 13:18:48', '2026-09-29 13:18:48'),
(184, 66, 'Elaboración de diseño', 1.000, 70.00, 70.00, NULL, 1, '2026-09-29 13:18:48', '2026-09-29 13:18:48'),
(185, 59, 'Diseño y elaboración de trailer MDF grabado personalizado', 20.000, 30.00, 600.00, NULL, 0, '2026-09-29 16:58:51', '2026-09-29 16:58:51'),
(186, 59, 'Diseño e impresión tarjetas Anticruda 100pz', 1.000, 200.00, 200.00, NULL, 1, '2026-09-29 16:58:51', '2026-09-29 16:58:51'),
(187, 59, 'Fabricación de bases mdf para trailer', 10.000, 10.00, 100.00, NULL, 2, '2026-09-29 16:58:51', '2026-09-29 16:58:51'),
(189, 67, 'Letrero vinil y coroplast, letras por separado para formar frase', 1.000, 450.00, 450.00, NULL, 0, '2026-09-29 23:04:24', '2026-09-29 23:04:24'),
(190, 62, 'Circulo Dilatación personalizado medida 30cm. Color natural', 26.000, 120.00, 3120.00, NULL, 0, '2026-09-30 11:23:09', '2026-09-30 11:23:09'),
(191, 68, 'Diseño e impresión lona medida 1.25 x .86', 5.000, 199.00, 995.00, NULL, 0, '2026-09-30 16:02:19', '2026-09-30 16:02:19'),
(192, 68, 'Diseño e impresión de lona medida 2.36 x .60', 1.000, 260.00, 260.00, NULL, 1, '2026-09-30 16:02:19', '2026-09-30 16:02:19'),
(193, 68, 'Diseño e impresión 100 tarjetas de presentación un solo lado', 1.000, 200.00, 200.00, NULL, 2, '2026-09-30 16:02:19', '2026-09-30 16:02:19'),
(194, 68, 'Elaboración de diseños publicidas', 1.000, 230.00, 230.00, NULL, 3, '2026-09-30 16:02:19', '2026-09-30 16:02:19'),
(196, 69, ', impresión de lona medida 60x80 cm', 7.000, 100.00, 700.00, NULL, 0, '2026-09-30 16:51:36', '2026-09-30 16:51:36'),
(201, 70, 'Llavero madera personalizado', 50.000, 35.00, 1750.00, NULL, 0, '2026-10-01 14:43:44', '2026-10-01 14:43:44'),
(202, 70, 'recuerdo madera medida 4cm modelo 2', 50.000, 18.00, 900.00, NULL, 1, '2026-10-01 14:43:44', '2026-10-01 14:43:44'),
(203, 70, 'recuerdo madera medida 4cm modelo 3', 50.000, 18.00, 900.00, NULL, 2, '2026-10-01 14:43:44', '2026-10-01 14:43:44'),
(204, 70, 'Pin madera personalizado modelo 4', 50.000, 18.00, 900.00, NULL, 3, '2026-10-01 14:43:44', '2026-10-01 14:43:44'),
(205, 70, 'Pin fotoboton plástico', 50.000, 12.00, 600.00, NULL, 4, '2026-10-01 14:43:44', '2026-10-01 14:43:44'),
(206, 71, 'Diseño e impresión Block 100 notas solo original tamaño carta', 1.000, 250.00, 250.00, NULL, 0, '2026-10-01 17:30:12', '2026-10-01 17:30:12'),
(207, 71, 'Sello autoentintable personalizado', 1.000, 390.00, 390.00, NULL, 1, '2026-10-01 17:30:12', '2026-10-01 17:30:12'),
(208, 72, 'Impresión sublimación 4 plantillas carta', 1.000, 80.00, 80.00, NULL, 0, '2026-10-01 17:52:09', '2026-10-01 17:52:09'),
(212, 74, 'Impresión digital vinil 15cm', 6.000, 25.00, 150.00, NULL, 0, '2026-10-02 10:16:25', '2026-10-02 10:16:25'),
(214, 73, 'Trofeo Modelo Vaquero', 4.000, 490.00, 1960.00, NULL, 0, '2026-10-02 16:31:38', '2026-10-02 16:31:38'),
(215, 75, 'Sello autoentintable personalizado', 4.000, 390.00, 1560.00, NULL, 0, '2026-10-02 18:08:12', '2026-10-02 18:08:12'),
(216, 75, 'Sello autoentintable personalizado profesor Josué', 1.000, 450.00, 450.00, NULL, 1, '2026-10-02 18:08:12', '2026-10-02 18:08:12'),
(217, 76, 'Sello autoentintable personalizado', 1.000, 460.00, 460.00, NULL, 0, '2026-10-03 13:50:10', '2026-10-03 13:50:10'),
(218, 77, 'Sello autoentintable personalizado', 1.000, 460.00, 460.00, NULL, 0, '2026-10-03 13:53:15', '2026-10-03 13:53:15'),
(219, 78, 'Impresión de lona medida 2m x 80cm incluye porta banner roll up', 5.000, 750.00, 3750.00, NULL, 0, '2026-10-03 15:28:34', '2026-10-03 15:28:34'),
(220, 78, 'Impresión de lona medida 3m x 2m (no incluye instalación)', 2.000, 720.00, 1440.00, NULL, 1, '2026-10-03 15:28:34', '2026-10-03 15:28:34'),
(221, 79, 'Lona 80x80cm', 1.000, 140.00, 140.00, NULL, 0, '2026-10-04 14:45:11', '2026-10-04 14:45:11'),
(222, 79, '100 impresiones 5x8cm', 1.000, 100.00, 100.00, NULL, 1, '2026-10-04 14:45:11', '2026-10-04 14:45:11'),
(223, 80, '100 stiker 2\"', 1.000, 150.00, 150.00, NULL, 0, '2026-10-05 09:57:39', '2026-10-05 09:57:39'),
(224, 80, '50 Trípticos papel Bond a color', 1.000, 140.00, 140.00, NULL, 1, '2026-10-05 09:57:39', '2026-10-05 09:57:39'),
(225, 81, 'Cajita madera/mdf personalizada', 35.000, 55.00, 1925.00, NULL, 0, '2026-10-05 16:33:41', '2026-10-05 16:33:41'),
(226, 82, '400 Stiker personalizado 2\"', 1.000, 395.00, 395.00, NULL, 0, '2026-10-05 17:55:40', '2026-10-05 17:55:40'),
(227, 83, 'Vaso termico personalizado con diseño de gatito', 1.000, 290.00, 290.00, NULL, 0, '2026-10-05 18:30:36', '2026-10-05 18:30:36'),
(230, 84, 'Personaje vinil impreso y coroplast 1.70', 1.000, 590.00, 590.00, NULL, 0, '2026-10-06 10:15:14', '2026-10-06 10:15:14'),
(231, 84, 'Personaje vinil impreso y coroplast 1.60', 1.000, 590.00, 590.00, NULL, 1, '2026-10-06 10:15:14', '2026-10-06 10:15:14'),
(232, 85, 'Impresión de vinil medida 1?20x2.40 + coroplast', 5.000, 1150.00, 5750.00, NULL, 0, '2026-10-06 11:15:35', '2026-10-06 11:15:35'),
(233, 86, 'Vaso termico personalizado 20oz (tipo Yeti genérico)', 50.000, 290.00, 14500.00, NULL, 0, '2026-10-06 13:21:03', '2026-10-06 13:21:03'),
(236, 88, 'Impresión de lona medida 390cm x 240cm incluye 10cm de rebase para tensado', 1.000, 1029.00, 1029.00, NULL, 0, '2026-10-06 16:02:27', '2026-10-06 16:02:27'),
(237, 89, 'Impresión de lona 1.50m x 1m', 9.000, 200.00, 1800.00, NULL, 0, '2026-10-06 19:13:51', '2026-10-06 19:13:51'),
(238, 87, 'Centro de mesa 18cm', 12.000, 20.00, 240.00, NULL, 0, '2026-10-07 00:30:16', '2026-10-07 00:30:16'),
(239, 87, 'Figura decorativa vinil y coroplast  con base 50cm', 1.000, 200.00, 200.00, NULL, 1, '2026-10-07 00:30:16', '2026-10-07 00:30:16'),
(240, 90, 'IMPRESION DE CREDENCIALES PVC', 127.000, 39.00, 4953.00, NULL, 0, '2026-10-07 10:54:17', '2026-10-07 10:54:17');

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
(15, 45, 'e4e37764bf1fffc3d32d70e76eb520aada86690b364e13cc0b0b022c663389cb', 1, '2026-09-24 21:16:48', '2026-10-07 10:53:37'),
(16, 48, '6f5ac43c0fd1f9b04227eb16987e1ba499f916919f98c20ce55d5e9709065d5e', 1, '2026-09-25 08:14:29', '2026-09-25 08:17:26'),
(17, 50, '441c99c479a9509ecbf77a94021cb78e4d466352ba26e421c22bbfc2b6cbc2be', 1, '2026-09-25 12:15:17', '2026-10-07 11:07:53'),
(18, 31, 'ddb29e87d431885c5a0ee5f2f1cf25d0777c4bb5cc0698b96ff8fd8bad6a822d', 1, '2026-09-25 13:22:24', NULL),
(19, 51, 'c55d61d766108fd12919c47fb086292a4cfe7e9e9565d448317ad99fd1ccd5fa', 1, '2026-09-25 17:09:51', '2026-09-28 10:19:57'),
(20, 52, '74ac7f6a7349ad9b1a60dfee52af11d186c4c986b42284616f90918d997e4957', 1, '2026-09-25 19:31:49', '2026-09-25 19:44:41'),
(21, 53, '366c897123d130f7d2e2ea04bc43a22548a63a3021f2ffde4276f7fdc2febb3d', 1, '2026-09-25 20:32:18', '2026-09-28 10:04:24'),
(22, 54, '2bef9fbf2233baf5288fc5dd164be044e3676f8cb1cfe8fc870af93d7cd402c7', 1, '2026-09-25 20:47:31', '2026-09-25 21:16:23'),
(26, 58, 'c9e477c6832f036ac2e238d7bff622fc39155f6247cb7288ed3dd99f63d07592', 1, '2026-09-28 11:24:18', '2026-09-28 12:11:30'),
(27, 59, '8d474546489508cbc001ae503795b20c224efe138cd8ae01d43db757eb7b6c76', 1, '2026-09-28 18:30:23', '2026-09-28 18:31:37'),
(28, 60, 'ce089e01f3c7adb0cded3c359ac4adcd33d78df6bde0499dc2b17853ffa4da26', 1, '2026-09-29 09:46:14', '2026-10-04 00:14:24'),
(29, 62, '9d125c7b7ed0f9bea51687aa77dc398d053f61b7b8dd1f009ad5d820ec24e4ca', 1, '2026-09-29 10:20:59', '2026-09-30 09:42:08'),
(30, 63, '2d36ad3cdadc13b95c8fc68c97e1d549254f13c1e6d919f4c4ef1c9512bdc86d', 1, '2026-09-29 10:59:48', NULL),
(31, 61, '52d8295a15b26259672eb80eda7dcc36e4f671e01814c96a3b1d7a7ecaafdfb8', 1, '2026-09-29 11:17:53', '2026-09-30 11:14:46'),
(32, 65, '20e58e3fa4281cf5cf9eb3db389559fb7f6ef1eac40a9471812a101d520e2953', 1, '2026-09-29 12:20:24', '2026-09-29 12:21:09'),
(33, 69, 'b209ce5801e1f88df6a983682901792537b53d0de01e25ead40610a7a348c0da', 1, '2026-09-30 16:51:39', '2026-10-01 08:07:02'),
(34, 70, '04bf2cd271d085a1a4b005ab2194ab65bf1141c965fcac95fdf09d1e4f108d5d', 1, '2026-10-01 14:13:30', '2026-10-06 20:29:20'),
(35, 71, '6ecd44a52e5bce88e6b6b479dcaa6b2f16fa3c6e39e9e3b6a0849fcb603c5983', 1, '2026-10-01 17:30:14', '2026-10-04 14:33:17'),
(36, 73, '35ac6709458cc3cd9397c3d2edfa74c2d489d69869c2f88b422cfca92bffe50c', 1, '2026-10-02 09:55:47', '2026-10-06 15:56:54'),
(37, 75, 'f6b80c4a2c204bcd15e2ec8f19fb269dc13903c36309a5c1007755a3a1a16187', 1, '2026-10-02 18:08:14', '2026-10-04 13:35:26'),
(38, 84, '39b1e42fde7f3015793098949d013c7d9d6d8df2fa1cb49a5386ab70e7ea1ac1', 1, '2026-10-06 10:09:30', '2026-10-06 10:22:29'),
(39, 85, '826eb65d6f515ffd5827b710ac85d5e95ff17cb0ac4e5385ea60f7991e6e5d3d', 1, '2026-10-06 11:16:00', '2026-10-06 11:16:47'),
(40, 86, '4b5dd4296f87f205f52a1a497d0760598763f4fa755e3fcbac1240b624e420e6', 1, '2026-10-06 13:21:19', '2026-10-06 13:26:45'),
(41, 87, '3a7da2221d610f76066805a4837a87f835fe5df1cdd9794fccea5d680dbf8a94', 1, '2026-10-06 14:33:09', '2026-10-06 19:10:16'),
(42, 89, '01e3bab241e09c8f241919316a71eecf3cea3affc729cc2e7e512cdde2537381', 1, '2026-10-06 19:13:53', '2026-10-06 19:14:08'),
(43, 90, '96f22fc36674f4e8af233fae944038eb42a0cce5e482590a4f1a380f93acc1ce', 1, '2026-10-07 10:54:25', '2026-10-07 11:01:28');

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
(84, 52, 2700.00, 0.00, 0.00, 2700.00, 0.00, 2700.00, 100.000, '2026-09-25 19:31:07', '2026-09-25 19:31:07'),
(87, 53, 13456.00, 0.00, 0.00, 13456.00, 0.00, 13456.00, 100.000, '2026-09-25 20:00:27', '2026-09-25 20:00:27'),
(88, 54, 350.00, 0.00, 0.00, 350.00, 0.00, 350.00, 100.000, '2026-09-25 20:36:20', '2026-09-25 20:36:20'),
(95, 58, 1630.00, 0.00, 0.00, 1630.00, 0.00, 1630.00, 100.000, '2026-09-28 12:16:08', '2026-09-28 12:16:08'),
(97, 51, 6174.00, 0.00, 987.84, 7161.84, 0.00, 7161.84, 100.000, '2026-09-28 17:12:32', '2026-09-28 17:12:32'),
(101, 60, 2700.00, 540.00, 0.00, 2160.00, 0.00, 2160.00, 100.000, '2026-09-29 09:46:10', '2026-09-29 09:46:10'),
(104, 63, 420.00, 0.00, 0.00, 420.00, 0.00, 420.00, 100.000, '2026-09-29 10:59:36', '2026-09-29 10:59:36'),
(105, 64, 290.00, 0.00, 0.00, 290.00, 0.00, 290.00, 100.000, '2026-09-29 11:06:57', '2026-09-29 11:06:57'),
(106, 61, 560.00, 0.00, 0.00, 560.00, 0.00, 560.00, 100.000, '2026-09-29 11:17:49', '2026-09-29 11:17:49'),
(107, 65, 1350.00, 0.00, 0.00, 1350.00, 0.00, 1350.00, 100.000, '2026-09-29 12:20:19', '2026-09-29 12:20:19'),
(108, 66, 270.00, 0.00, 0.00, 270.00, 0.00, 270.00, 100.000, '2026-09-29 13:18:48', '2026-09-29 13:18:48'),
(109, 59, 900.00, 0.00, 0.00, 900.00, 0.00, 900.00, 100.000, '2026-09-29 16:58:51', '2026-09-29 16:58:51'),
(111, 67, 450.00, 0.00, 0.00, 450.00, 0.00, 450.00, 100.000, '2026-09-29 23:04:24', '2026-09-29 23:04:24'),
(112, 62, 3120.00, 624.00, 0.00, 2496.00, 0.00, 2496.00, 100.000, '2026-09-30 11:23:09', '2026-09-30 11:23:09'),
(113, 68, 1685.00, 168.50, 0.00, 1516.50, 0.00, 1516.50, 100.000, '2026-09-30 16:02:19', '2026-09-30 16:02:19'),
(115, 69, 700.00, 0.00, 0.00, 700.00, 0.00, 700.00, 100.000, '2026-09-30 16:51:36', '2026-09-30 16:51:36'),
(117, 70, 5050.00, 0.00, 0.00, 5050.00, 0.00, 5050.00, 100.000, '2026-10-01 14:43:44', '2026-10-01 14:43:44'),
(118, 71, 640.00, 0.00, 0.00, 640.00, 0.00, 640.00, 100.000, '2026-10-01 17:30:12', '2026-10-01 17:30:12'),
(119, 72, 80.00, 0.00, 0.00, 80.00, 0.00, 80.00, 100.000, '2026-10-01 17:52:09', '2026-10-01 17:52:09'),
(121, 74, 150.00, 0.00, 0.00, 150.00, 0.00, 150.00, 100.000, '2026-10-02 10:16:25', '2026-10-02 10:16:25'),
(123, 73, 1960.00, 196.00, 282.24, 2046.24, 0.00, 2046.24, 100.000, '2026-10-02 16:31:38', '2026-10-02 16:31:38'),
(124, 75, 2010.00, 0.00, 0.00, 2010.00, 0.00, 2010.00, 100.000, '2026-10-02 18:08:12', '2026-10-02 18:08:12'),
(125, 76, 460.00, 69.00, 0.00, 391.00, 0.00, 391.00, 100.000, '2026-10-03 13:50:10', '2026-10-03 13:50:10'),
(126, 77, 460.00, 69.00, 0.00, 391.00, 0.00, 391.00, 100.000, '2026-10-03 13:53:15', '2026-10-03 13:53:15'),
(127, 78, 5190.00, 0.00, 830.40, 6020.40, 0.00, 6020.40, 100.000, '2026-10-03 15:28:34', '2026-10-03 15:28:34'),
(128, 79, 240.00, 0.00, 0.00, 240.00, 0.00, 240.00, 100.000, '2026-10-04 14:45:11', '2026-10-04 14:45:11'),
(129, 80, 290.00, 0.00, 0.00, 290.00, 0.00, 290.00, 100.000, '2026-10-05 09:57:39', '2026-10-05 09:57:39'),
(130, 81, 1925.00, 0.00, 0.00, 1925.00, 0.00, 1925.00, 100.000, '2026-10-05 16:33:41', '2026-10-05 16:33:41'),
(131, 82, 395.00, 0.00, 0.00, 395.00, 0.00, 395.00, 100.000, '2026-10-05 17:55:40', '2026-10-05 17:55:40'),
(132, 83, 290.00, 0.00, 0.00, 290.00, 0.00, 290.00, 100.000, '2026-10-05 18:30:36', '2026-10-05 18:30:36'),
(134, 84, 1180.00, 0.00, 0.00, 1180.00, 0.00, 1180.00, 100.000, '2026-10-06 10:15:14', '2026-10-06 10:15:14'),
(135, 85, 5750.00, 0.00, 0.00, 5750.00, 0.00, 5750.00, 100.000, '2026-10-06 11:15:35', '2026-10-06 11:15:35'),
(136, 86, 14500.00, 2175.00, 0.00, 12325.00, 0.00, 12325.00, 100.000, '2026-10-06 13:21:03', '2026-10-06 13:21:03'),
(138, 88, 1029.00, 0.00, 164.64, 1193.64, 0.00, 1193.64, 100.000, '2026-10-06 16:02:27', '2026-10-06 16:02:27'),
(139, 89, 1800.00, 450.00, 0.00, 1350.00, 0.00, 1350.00, 100.000, '2026-10-06 19:13:51', '2026-10-06 19:13:51'),
(140, 87, 440.00, 0.00, 0.00, 440.00, 0.00, 440.00, 100.000, '2026-10-07 00:30:16', '2026-10-07 00:30:16'),
(141, 90, 4953.00, 0.00, 792.48, 5745.48, 0.00, 5745.48, 100.000, '2026-10-07 10:54:17', '2026-10-07 10:54:17');

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
(11, 12, 'd3571b9e61fe1eb79ccac3c40530eb24c82b9d1a7859a203a7e0fc5e2cc4f895', 1, '2026-09-19 11:06:45', '2026-09-28 10:10:15'),
(12, 13, '2424ce9cb4dc8c820dd79ba5c289618f457db728cd814a1af26c3aee57106039', 1, '2026-09-19 11:15:57', '2026-09-22 09:10:17'),
(13, 14, 'e1aaa7201cafc780182f1694b6de836ad4e3d91029b9ef99d9c68cd03fc34fa4', 1, '2026-09-19 11:41:28', '2026-09-22 09:40:01'),
(14, 15, '0f4102ddb74192ddb833baa8011fcd497cdee24976197d17005c963fe8a60b2f', 1, '2026-09-19 17:07:32', '2026-09-21 10:08:43'),
(15, 16, '04e767cdf16a6c1c32af4982c1b8b435ccbe5527e3ef0e2b5df0e2ae4d486887', 1, '2026-09-19 17:17:35', '2026-09-24 22:25:07'),
(16, 17, 'ecf23513e472f8100ff636f246978ea6e45c1ce679aa8ef3d5a9448092b298c3', 1, '2026-09-19 17:26:26', '2026-09-26 10:32:03'),
(17, 18, 'a611409ce4547822fdb2f55c748e1ac8df1c0fe5cfe1155208d32d95cb77cb06', 1, '2026-09-19 18:35:39', '2026-10-06 21:14:19'),
(18, 19, '830d1c4d133caf46207fa80832cdb8c4b143609fd232332291598787e5bb2b29', 1, '2026-09-20 00:12:06', NULL),
(19, 20, '3a6a5b5b8d7727b2d549b75b2bbfb545394e8c5252f09296724abf5ecd04a274', 1, '2026-09-20 00:23:51', '2026-09-20 00:37:21'),
(20, 21, '7deea835a5e29ef2b181616405cfc9cc4f07bdb77e8c58ba05f454e0e2e55bea', 1, '2026-09-22 08:38:51', '2026-10-05 11:07:45'),
(21, 22, '2246dd4dbafcc76b294c72d7d53c8adf4f986149b4f230a5716f4add191272a3', 1, '2026-09-22 10:38:56', '2026-10-07 10:20:55'),
(22, 23, '18b4398fa9980d1123e5caf5d0d622d812644fd6f6893ae4554c149a2c34b667', 1, '2026-09-22 10:54:16', '2026-10-07 09:55:01'),
(23, 24, '7d76622dd78293c669b62efbf22de2f422300f125505064866331c3091645ddd', 1, '2026-09-22 14:19:56', '2026-09-24 18:35:04'),
(24, 25, '39d5c22caef2c1b33051d8e8460dd4b2f332c73e3ae1822349255a2f4a46ae86', 1, '2026-09-22 20:46:46', '2026-09-23 01:57:52'),
(25, 26, '515cdf55445a28732169f6336a37c15b2b216610cfe8c1e0e10c308fbb345f35', 1, '2026-09-23 09:07:11', '2026-09-28 15:47:28'),
(26, 27, 'd55c92443a92698b7bfa39228936ce8bf37d3df47e5a8a3f2371af2b7de9dfd4', 1, '2026-09-23 09:58:04', '2026-09-28 22:18:45'),
(27, 28, '13b26f22bc1b66dfa1e4932537d71451bc6d7b615a9012b7591767b59d0af3f5', 1, '2026-09-23 10:46:01', '2026-09-27 11:09:21'),
(28, 29, '01f16c4de2a8bfd4acc2ed53d41f42cc58f306078223b3ca50181f1145b6eb76', 1, '2026-09-23 11:08:54', '2026-09-28 17:26:12'),
(29, 30, '972066b330ab9711374d92a87d026bb03c3e1fa622767cab4255b818693a5e19', 1, '2026-09-23 20:22:53', '2026-10-06 18:45:51'),
(30, 31, 'd663b7d962c6fa8addf2a4f860ddab715e03cef353562a7a6ce13af0cf0dd269', 1, '2026-09-24 10:00:08', '2026-09-27 15:59:55'),
(31, 32, '9f111790d54b2be5ef49f3a752437e854500e209da46760eaf9a907368fd3004', 1, '2026-09-24 12:36:12', '2026-09-29 08:30:25'),
(32, 33, '0f501e36088ee9a1df4608a86e31bc39504939acb65ebd3363952fb9a6d9888f', 1, '2026-09-24 17:37:36', '2026-10-06 21:13:58'),
(33, 34, '05650f98f918b4982444e91bd5e217df6a3c45b16f60d649379da216ab354cf3', 1, '2026-09-24 18:28:31', '2026-09-30 12:03:18'),
(34, 35, '3b7b8af3ef711f0b5fb4e5bf7094486b3fd561c9a6323389582c8ac210720ab0', 1, '2026-09-25 04:51:18', '2026-09-25 07:41:21'),
(35, 36, '463c69368d8e664ba66e45ff5a8f9768fb79fcb4fa1a7b86a828c3cb2b7bbfc9', 1, '2026-09-25 07:45:03', '2026-09-25 09:42:00'),
(36, 37, '281b4101965960fe1d09112eaad6407b2db67a58d3922a076a145c2a25dbc121', 1, '2026-09-25 08:15:26', '2026-10-05 14:41:48'),
(37, 38, '7142ff66acb07a106eb75246e3a0ed14e1e170cf7bedbd100756a6bbc89960f6', 1, '2026-09-25 10:22:29', '2026-09-25 10:46:46'),
(38, 39, '699baf6b7c6394592529b12f469e66a5f86a51bffc6f2691fa85545154b29088', 1, '2026-09-25 20:37:16', '2026-09-27 06:41:18'),
(39, 40, '0e164e01131faf810d59e7d5f8d1e1c86aac91fc7689f77680fe795e8d24fd87', 1, '2026-09-28 12:19:23', '2026-10-05 12:17:12'),
(40, 41, 'c96e0453192ec6132a3d2b1b2c154cd1dbf6513266167cd1c3e74504d4742809', 1, '2026-09-28 17:01:07', '2026-10-06 16:01:23'),
(41, 42, '9ed200bc56e3be5bee24d768c9dac8ec4b24d6419e988e1c89b1a2956977490d', 1, '2026-09-28 18:14:59', '2026-10-07 10:49:11'),
(42, 43, 'd73534bfbc0e44565d538c89a3800cd2544fc0a90dba4cdd8d3593505cfb7936', 1, '2026-09-28 18:38:08', '2026-10-03 15:06:40'),
(43, 44, '5787c67cfc5b780829d237323f7051b4f1167947877aefd321b5fc7b231a4f70', 1, '2026-09-29 11:00:43', '2026-10-05 16:11:42'),
(44, 45, 'acd43f03d14a6c2c79d1edf2d495d76719003a8d572738062d45cfdab7774a2f', 1, '2026-09-29 11:07:58', '2026-09-29 19:10:56'),
(45, 46, 'd01498a28ee702d696a995dfa66788fa6c851aafd516ec2d031b02ed8f8ad833', 1, '2026-09-29 13:19:13', '2026-10-03 20:48:48'),
(46, 47, '717c106515267242a49ce13968f191446f587312f86a6ed0a8b31769bcb2f210', 1, '2026-09-29 19:07:16', '2026-09-30 16:24:47'),
(47, 48, '82bbab31fcc24f115894ac0cd17c33b1067329c4f67ee32e44cac3d748bdd21a', 1, '2026-09-30 11:23:21', '2026-09-30 15:16:10'),
(48, 49, '66267d02f31c048d474aa6e6dc734baf360553e726e646021d13ff9ae9ab0cca', 1, '2026-09-30 16:06:04', '2026-09-30 16:06:41'),
(49, 50, '549e299d7d880ccdea5af6dee6763c53168546ea971a9ba37068fb63a4b738ce', 1, '2026-09-30 16:49:58', '2026-10-01 15:45:27'),
(50, 51, '3f4638657dff3aac4b8b5b138cab0b8591e8805b2caebd04f8a55e8ffbbe9ff9', 1, '2026-10-01 17:49:44', '2026-10-05 16:46:34'),
(51, 52, '4774c4ddc87d1aacf297d01e8ad3eb43550f9bb82c11da6fe300db7812a1df57', 1, '2026-10-01 17:52:26', '2026-10-01 18:38:38'),
(52, 53, '7ec0a2517e8dd3e96a5940cf740a0dc3ebb2c0b6c6a26652862dbf4721dacc4f', 1, '2026-10-02 10:16:45', '2026-10-06 17:23:09'),
(53, 54, '1bd3b96989e1d28b2a4430c196dbc1225562f6602c259b5722907ac7f86e355a', 1, '2026-10-02 16:32:22', '2026-10-06 15:38:07'),
(54, 55, '39496ab201b5b614b770d357603f98a4bc66b64035665c81ce8858e22d560eee', 1, '2026-10-03 13:50:26', '2026-10-03 14:17:55'),
(55, 56, 'ef26f1d4a6d1e2c799a21e37c2b7912a9725058f4b8599a5f6b2dff903f39bef', 1, '2026-10-03 13:53:34', '2026-10-03 13:55:36'),
(56, 57, '71deb5151ca602ced0f5ca0abd9ddefe5be9f056385f666339ed959edbe79627', 1, '2026-10-03 15:29:03', '2026-10-03 18:08:46'),
(57, 58, '540733ea0044fe2fbe9919bae375509023a235283496dae79928c6505e410e35', 1, '2026-10-04 14:45:33', '2026-10-07 10:26:28'),
(58, 59, 'd117191a6495b0a78ca35418209e6919d72b1d4c4314972790f76b8a358998bd', 1, '2026-10-05 09:57:55', NULL),
(59, 60, '72e7550ab116c5da3426042fe7c83e7b68084bcc71d069bb86b5eed791c36efb', 1, '2026-10-05 16:34:04', '2026-10-05 18:05:54'),
(60, 61, '5a709a118cbce8768e81580c05a0208dcfe5b441db46a47ea809913fe20b211b', 1, '2026-10-05 17:56:27', '2026-10-07 09:00:22'),
(61, 62, 'b5010a67a8a9bf71af045f666a7789f6ab2014f59638ff4a6e712e74e27f465a', 1, '2026-10-05 18:33:42', '2026-10-06 22:41:59'),
(62, 63, '5ba77d829dca3494fd24b4530d857431623fa0aa28bc5e7551639b4b70acf624', 1, '2026-10-06 16:03:23', '2026-10-06 18:30:36'),
(63, 64, '0758084791c8252f461bc700734702b86147fdcde822b537f0a27242fa3bbcb1', 1, '2026-10-07 00:30:34', NULL);

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
(1, 1, 'Administrador', 'ventas@colibriprint.com.mx', '$2y$10$exXwwyuOSJwdgJYWHR3tDO.C.BtOprMV5iLIhonCJsWI4AZGgLqk2', 1, '2026-10-07 10:51:17', '2026-09-16 22:35:58', '2026-09-16 22:35:58');

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
(16, 20, 'Concepto_plano.pdf', '/uploads/cotizador/impresiones/20/c38c8951371988f5_Concepto_plano.pdf', 'application/pdf', 'pdf', 10971049, '1309e8cbee0a15b842bb13caad5f35084bbcedb66a1841f7b17b9ab9d38e373b', 'public', NULL, NULL, NULL, '2026-09-26 19:25:44', 1),
(17, 21, 'CASA_HABITACION_60_x_90_cm__20260925_084827_0000.pdf', '/uploads/cotizador/impresiones/21/1d01161cffdf9705_CASA_HABITACION_60_x_90_cm__20260925_084827_0000.pdf', 'application/pdf', 'pdf', 2922077, '77d709625dbdb928be3d5b313bc4a9fca542c4ccf3b93c2dd605cbc6fd9465c6', 'public', NULL, NULL, NULL, '2026-09-27 05:58:42', 1),
(18, 22, 'capple.jpg', '/uploads/cotizador/impresiones/22/d65df8e656cc7806_capple.jpg', 'image/jpeg', 'jpg', 11525387, '8533bf072614b7b4dfe38280e291d666f353553b26a1ee913e92d4ce02e99383', 'public', NULL, NULL, NULL, '2026-09-27 06:25:16', 1),
(19, 23, 'repentina.1.pdf', '/uploads/cotizador/impresiones/23/89313261ead9bdfc_repentina.1.pdf', 'application/pdf', 'pdf', 12627230, 'db2ef3d62c3b31a20a861e4b94e26cfe7a43bbcd967246d1f36ea289a38b5dda', 'public', NULL, NULL, NULL, '2026-09-27 08:47:23', 1),
(20, 24, 'ChatGPT_Image_Aug_31_2026_01_15_25_AM.png', '/uploads/cotizador/impresiones/24/f0be941fe10ac660_ChatGPT_Image_Aug_31_2026_01_15_25_AM.png', 'image/png', 'png', 2066946, 'b98b08d59166bce3827cfe38841917455cfec3b32a1ca6030a6a519a60d9b728', 'public', NULL, NULL, NULL, '2026-09-28 08:24:20', 1),
(21, 25, 'ChatGPT_Image_Sep_20_2026_05_10_35_PM.png', '/uploads/cotizador/impresiones/25/3edc86b25ec01682_ChatGPT_Image_Sep_20_2026_05_10_35_PM.png', 'image/png', 'png', 2233855, 'cb8dda4065a288f75aa09250a53593f7249a17b8da19e65632cd7757104b64f3', 'public', NULL, NULL, NULL, '2026-09-29 09:00:44', 1);

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
(9, 20, 'new_request', 'CPQ-000020 · ERIKA BUSTILLOS', 'Impresión · +526271074512 · 1 archivo(s) · $80.00 MXN', NULL, '2026-09-26 19:25:44'),
(10, 21, 'new_request', 'CPQ-000021 · ERIKA BUSTILLOS', 'Impresión · +526271074512 · 1 archivo(s) · $80.00 MXN', NULL, '2026-09-27 05:58:42'),
(11, 22, 'new_request', 'CPQ-000022 · ERIKA BUSTILLOS', 'Impresión · +526271074512 · 1 archivo(s) · $80.00 MXN', NULL, '2026-09-27 06:25:16'),
(12, 23, 'new_request', 'CPQ-000023 · ERIKA BUSTILLOS', 'Impresión · +526271074512 · 1 archivo(s) · $800.00 MXN', NULL, '2026-09-27 08:47:23'),
(13, 24, 'new_request', 'CPQ-000024 · ERIKA BUSTILLOS', 'Impresión · +526271074512 · 1 archivo(s) · $5.00 MXN', NULL, '2026-09-28 08:24:20'),
(14, 25, 'new_request', 'CPQ-000025 · LUIS MIGUEL GARDEA RODRIGUEZ', 'Impresión · +526271074512 · 1 archivo(s) · $80.00 MXN', NULL, '2026-09-29 09:00:44');

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
(7, 'a378b7984cc574c69e83c15d69bb71d687063bf794d6b9f0d96df7712cb0c4d6', 529, 'laser', 'MIGUEL', NULL, '6271074512', 'Servicio: Grabado láser\nquantity: 1\nmaterial: YETI\nsize: \ndetail: LOGO\nDiseño: Solo tengo la idea\nAplicación/instalación: No lo sé todavía\nEntrega: Entrega local\nFecha solicitada: 2026-09-26\nNotas: QUIERO GRABAR UN LOGO EN EL YETI\nArchivos recibidos: 1\n\n[CPQ_JSON]\n{\"version\":3,\"service\":{\"key\":\"laser\",\"name\":\"Grabado láser\"},\"details\":{\"quantity\":\"1\",\"material\":\"YETI\",\"size\":\"\",\"detail\":\"LOGO\"},\"production\":{\"design_status\":\"Solo tengo la idea\",\"application\":\"No lo sé todavía\",\"notes\":\"QUIERO GRABAR UN LOGO EN EL YETI\"},\"delivery\":{\"method\":\"Entrega local\",\"desired_date\":\"2026-09-26\"},\"attachments\":[{\"original_name\":\"Logo 2027.png\",\"relative_path\":\"/uploads/cotizador/a378b7984cc574c69e83c15d69bb71d687063bf794d6b9f0d96df7712cb0c4d6/dc8c622bcedc99bca185c706a292f25f.png\",\"mime\":\"image/png\",\"size\":1222567,\"extension\":\"png\",\"sha256\":\"9dccdc6bdbaa3c9c84bcde4280249629f42032dc2144b11c3804199c2899b506\"}],\"attachment\":{\"original_name\":\"Logo 2027.png\",\"relative_path\":\"/uploads/cotizador/a378b7984cc574c69e83c15d69bb71d687063bf794d6b9f0d96df7712cb0c4d6/dc8c622bcedc99bca185c706a292f25f.png\",\"mime\":\"image/png\",\"size\":1222567,\"extension\":\"png\",\"sha256\":\"9dccdc6bdbaa3c9c84bcde4280249629f42032dc2144b11c3804199c2899b506\"},\"submitted_at\":\"2026-09-20T00:21:07-06:00\",\"source\":\"public_quote_wizard\",\"ip_hash\":\"6e2f47d9c108c37106dd6710e224743a86073951dc4827e3c29f8e7bb6e662c9\"}', '1', '2026-09-26', 'Logo 2027.png', 'closed', 29, '2026-09-20 00:21:58', '2026-09-20 00:21:07', '2026-09-27 07:04:20');

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
(83, 'ready_delivery', 21, NULL, 763, '526271064807', 'Hola Karina salón de eventos Alexa 👋\n\n🚚 ¡Tu pedido OS-2026-00011 ya está listo para entrega!\n\n📅 Fecha compromiso: 25/09/2026\n\n🔎 Consulta los detalles aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=7deea835a5e29ef2b181616405cfc9cc4f07bdb77e8c58ba05f454e0e2e55bea\n\nGracias por confiar en Colibrí Print.', 'prepared', 1, '2026-09-26 10:39:53'),
(84, 'design_approval', 41, NULL, 1280, '526271478306', 'Hola Ferretería Amaya 👋\n\n🎨 El diseño de tu pedido OS-2026-00031 está listo para aprobación.\n\nPara autorizar la producción, responde a este mensaje con *APROBADO*. Si necesitas cambios, indícanos cuáles para revisarlos contigo.\n\n🔎 Seguimiento del pedido:\nhttps://colibriprint.com.mx/seguimiento.php?t=c96e0453192ec6132a3d2b1b2c154cd1dbf6513266167cd1c3e74504d4742809\n\nColibrí Print\n\nEste es un mensaje automático y no es necesario responder', 'prepared', 1, '2026-09-28 18:40:13'),
(85, 'order_confirmed', 40, NULL, 1233, '526291011058', 'Hola Edith Holguin 👋\n\nTu pedido OS-2026-00030 ya fue registrado y comenzamos a trabajar en él.\n\n💰 Total de la orden: $1,630.00\n📅 Fecha compromiso: 03/10/2026\n\n🔎 Consulta el avance de tu pedido:\nhttps://colibriprint.com.mx/seguimiento.php?t=0e164e01131faf810d59e7d5f8d1e1c86aac91fc7689f77680fe795e8d24fd87\n\nGracias por confiar en Colibrí Print.\n\nEste es un mensaje automático y no es necesario responder', 'prepared', 1, '2026-09-29 09:28:18'),
(86, 'design_ready', 45, NULL, 1287, '526275175858', 'Hola Aurora Hernández 👋\n\n🎨 El diseño de tu pedido OS-2026-00035 ya está listo para revisión.\n\nPuedes consultar el avance de tu pedido aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=acd43f03d14a6c2c79d1edf2d495d76719003a8d572738062d45cfdab7774a2f\n\nSi necesitas algún ajuste, respóndenos por este mismo medio.\n\nColibrí Print\n\nEste es un mensaje automático y no es necesario responder', 'prepared', 1, '2026-09-29 19:10:30'),
(87, 'quote_sent', NULL, 63, 1286, '526271499395', 'Hola Ximena Hernández 👋\n\nGracias por confiar en Colibrí Print. Te compartimos la cotización CP-2026-00041.\n\n💰 Total cotizado: $420.00\n📅 Vigencia: 14/10/2026\n\n📄 Ver y descargar tu cotización en PDF:\nhttps://colibriprint.com.mx/cotizacion_pdf_publica.php?t=2d36ad3cdadc13b95c8fc68c97e1d549254f13c1e6d919f4c4ef1c9512bdc86d\n\nQuedamos atentos a cualquier duda o ajuste que necesites.\n\nSaludos,\nColibrí Print\n\nEste es un mensaje automático y no es necesario responder', 'prepared', 1, '2026-09-29 22:01:13'),
(88, 'quality_review', 47, NULL, 1284, '526291065121', 'Hola Miranda Buhaya 👋\n\n✅ Tu pedido OS-2026-00037 está en revisión final de calidad antes de pasar a entrega.\n\n🔎 Consulta el avance aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=717c106515267242a49ce13968f191446f587312f86a6ed0a8b31769bcb2f210\n\nTe avisaremos en cuanto esté listo.\n\nColibrí Print\n\nEste es un mensaje automático y no es necesario responder', 'prepared', 1, '2026-09-30 11:16:05'),
(89, 'order_confirmed', 49, NULL, 1289, '526271737160', 'Hola Brenda Piñon 👋\n\nTu pedido OS-2026-00039 ya fue registrado y comenzamos a trabajar en él.\n\n💰 Total de la orden: $1,516.50\n📅 Fecha compromiso: 15/10/2026\n\n🔎 Consulta el avance de tu pedido:\nhttps://colibriprint.com.mx/seguimiento.php?t=66267d02f31c048d474aa6e6dc734baf360553e726e646021d13ff9ae9ab0cca\n\nGracias por confiar en Colibrí Print.\n\nEste es un mensaje automático y no es necesario responder', 'prepared', 1, '2026-09-30 16:06:12'),
(90, 'ready_delivery', 50, NULL, 1290, '526271148973', 'Hola MFC 👋\n\n🚚 ¡Tu pedido OS-2026-00040 ya está listo para entrega!\n\n📅 Fecha compromiso: 30/09/2026\n\n🔎 Consulta los detalles aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=549e299d7d880ccdea5af6dee6763c53168546ea971a9ba37068fb63a4b738ce\n\nGracias por confiar en Colibrí Print.\n\nEste es un mensaje automático y no es necesario responder', 'prepared', 1, '2026-10-01 15:04:52'),
(91, 'in_production', 41, NULL, 1280, '526271478306', 'Hola Ferretería Amaya 👋\n\n🔧 Tu pedido OS-2026-00031 ya se encuentra en producción. Nuestro equipo está trabajando en los detalles de tu trabajo.\n\n🔎 Consulta el avance aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=c96e0453192ec6132a3d2b1b2c154cd1dbf6513266167cd1c3e74504d4742809\n\nEste es un mensaje automático y no es necesario responder\n\nColibrí Print\n\nEste es un mensaje automático y no es necesario responder', 'prepared', 1, '2026-10-01 17:08:13'),
(92, 'design_ready', 51, NULL, 459, '526491107188', 'Hola Marisol 👋\n\n🎨 El diseño de tu pedido OS-2026-00041 ya está listo para revisión.\n\nPuedes consultar el avance de tu pedido aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=3f4638657dff3aac4b8b5b138cab0b8591e8805b2caebd04f8a55e8ffbbe9ff9\n\nSi necesitas algún ajuste, respóndenos por este mismo medio.\n\nColibrí Print\n\nEste es un mensaje automático y no es necesario responder', 'prepared', 1, '2026-10-01 17:50:40'),
(93, 'order_confirmed', 52, NULL, 1292, '526144949218', 'Hola Mabel 👋\n\nTu pedido OS-2026-00042 ya fue registrado y comenzamos a trabajar en él.\n\n💰 Total de la orden: $80.00\n📅 Fecha compromiso: 01/10/2026\n\n🔎 Consulta el avance de tu pedido:\nhttps://colibriprint.com.mx/seguimiento.php?t=4774c4ddc87d1aacf297d01e8ad3eb43550f9bb82c11da6fe300db7812a1df57\n\nGracias por confiar en Colibrí Print.\n\nEste es un mensaje automático y no es necesario responder', 'prepared', 1, '2026-10-01 17:54:41'),
(94, 'ready_delivery', 46, NULL, 654, '526271236513', 'Hola José Ceballos 👋\n\n🚚 ¡Tu pedido OS-2026-00036 ya está listo para entrega!\n\n📅 Fecha compromiso: 03/10/2026\n\n🔎 Consulta los detalles aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=d01498a28ee702d696a995dfa66788fa6c851aafd516ec2d031b02ed8f8ad833\n\nGracias por confiar en Colibrí Print.\n\nEste es un mensaje automático y no es necesario responder', 'prepared', 1, '2026-10-03 20:12:50'),
(95, 'printing', 51, NULL, 459, '526491107188', 'Hola Marisol 👋\n\n🖨️ Tu pedido OS-2026-00041 ya se encuentra en impresión. Estamos avanzando con tu trabajo.\n\n🔎 Consulta el avance aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=3f4638657dff3aac4b8b5b138cab0b8591e8805b2caebd04f8a55e8ffbbe9ff9\n\nColibrí Print', 'prepared', 1, '2026-10-04 14:22:59'),
(96, 'printing', 58, NULL, 1296, '524491843569', 'Hola Alba Ramirez 👋\n\n🖨️ Tu pedido OS-2026-00048 ya se encuentra en impresión. Estamos avanzando con tu trabajo.\n\n🔎 Consulta el avance aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=540733ea0044fe2fbe9919bae375509023a235283496dae79928c6505e410e35\n\nColibrí Print', 'prepared', 1, '2026-10-04 14:54:26'),
(97, 'order_confirmed', 60, NULL, 1297, '526591012696', 'Hola María Guadalupe Villar Saenz 👋\n\nTu pedido OS-2026-00050 ya fue registrado y comenzamos a trabajar en él.\n\n💰 Total de la orden: $1,925.00\n📅 Fecha compromiso: 20/10/2026\n\n🔎 Consulta el avance de tu pedido:\nhttps://colibriprint.com.mx/seguimiento.php?t=72e7550ab116c5da3426042fe7c83e7b68084bcc71d069bb86b5eed791c36efb\n\nGracias por confiar en Colibrí Print.\n\nEste es un mensaje automático y no es necesario responder', 'prepared', 1, '2026-10-05 16:35:46'),
(98, 'ready_delivery', 51, NULL, 459, '526491107188', 'Hola Marisol 👋\n\n🚚 ¡Tu pedido OS-2026-00041 ya está listo para entrega!\n\n📅 Fecha compromiso: 08/10/2026\n\n🔎 Consulta los detalles aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=3f4638657dff3aac4b8b5b138cab0b8591e8805b2caebd04f8a55e8ffbbe9ff9\n\nGracias por confiar en Colibrí Print.\n\nEste es un mensaje automático y no es necesario responder', 'prepared', 1, '2026-10-05 16:46:12'),
(99, 'design_ready', 54, NULL, 1280, '526271478306', 'Hola Ferretería Amaya 👋\n\n🎨 El diseño de tu pedido OS-2026-00044 ya está listo para revisión.\n\nPuedes consultar el avance de tu pedido aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=1bd3b96989e1d28b2a4430c196dbc1225562f6602c259b5722907ac7f86e355a\n\nSi necesitas algún ajuste, respóndenos por este mismo medio.\n\nColibrí Print\n\nEste es un mensaje automático y no es necesario responder', 'prepared', 1, '2026-10-06 09:58:25'),
(100, 'in_production', 54, NULL, 1280, '526271478306', 'Hola Ferretería Amaya 👋\n\n🔧 Tu pedido OS-2026-00044 ya se encuentra en producción. Nuestro equipo está trabajando en los detalles de tu trabajo.\n\n🔎 Consulta el avance aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=1bd3b96989e1d28b2a4430c196dbc1225562f6602c259b5722907ac7f86e355a\n\nEste es un mensaje automático y no es necesario responder\n\nColibrí Print\n\nEste es un mensaje automático y no es necesario responder', 'prepared', 1, '2026-10-06 15:36:29'),
(101, 'order_confirmed', 61, NULL, 1298, '526271071349', 'Hola Luis Angel 👋\n\nTu pedido OS-2026-00051 ya fue registrado y comenzamos a trabajar en él.\n\n💰 Total de la orden: $395.00\n📅 Fecha compromiso: 06/10/2026\n\n🔎 Consulta el avance de tu pedido:\nhttps://colibriprint.com.mx/seguimiento.php?t=5a709a118cbce8768e81580c05a0208dcfe5b441db46a47ea809913fe20b211b\n\nGracias por confiar en Colibrí Print.\n\nEste es un mensaje automático y no es necesario responder', 'prepared', 1, '2026-10-06 18:30:48'),
(102, 'ready_delivery', 58, NULL, 1296, '524491843569', 'Hola Alba Ramirez 👋\n\n🚚 ¡Tu pedido OS-2026-00048 ya está listo para entrega!\n\n📅 Fecha compromiso: 19/10/2026\n\n🔎 Consulta los detalles aquí:\nhttps://colibriprint.com.mx/seguimiento.php?t=540733ea0044fe2fbe9919bae375509023a235283496dae79928c6505e410e35\n\nGracias por confiar en Colibrí Print.\n\nEste es un mensaje automático y no es necesario responder', 'prepared', 1, '2026-10-07 10:01:04');

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
-- Indexes for table `cp_customers_backup_20260927_070420`
--
ALTER TABLE `cp_customers_backup_20260927_070420`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cp_customers_source` (`source_type`,`source_id`),
  ADD KEY `idx_cp_customers_name` (`name`),
  ADD KEY `idx_cp_customers_phone` (`phone`);

--
-- Indexes for table `cp_customer_merge_map`
--
ALTER TABLE `cp_customer_merge_map`
  ADD PRIMARY KEY (`old_customer_id`),
  ADD KEY `idx_cp_customer_merge_canonical` (`canonical_customer_id`);

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
-- Indexes for table `cp_invoice_documents`
--
ALTER TABLE `cp_invoice_documents`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cp_invoice_documents_uuid` (`uuid`),
  ADD KEY `idx_cp_invoice_documents_invoice` (`invoice_id`),
  ADD KEY `idx_cp_invoice_documents_order` (`order_id`),
  ADD KEY `idx_cp_invoice_documents_date` (`issued_at`),
  ADD KEY `idx_cp_invoice_documents_sha` (`xml_sha256`);

--
-- Indexes for table `cp_invoice_items`
--
ALTER TABLE `cp_invoice_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cp_invoice_items_document` (`document_id`);

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
  ADD PRIMARY KEY (`id`),
  ADD KEY `ix_cp_print_requests_archive_status` (`archive_status`,`status`);

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
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1189;

--
-- AUTO_INCREMENT for table `cp_categories`
--
ALTER TABLE `cp_categories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `cp_customers`
--
ALTER TABLE `cp_customers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1303;

--
-- AUTO_INCREMENT for table `cp_customers_backup_20260927_070420`
--
ALTER TABLE `cp_customers_backup_20260927_070420`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1283;

--
-- AUTO_INCREMENT for table `cp_invoices`
--
ALTER TABLE `cp_invoices`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `cp_invoice_documents`
--
ALTER TABLE `cp_invoice_documents`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `cp_invoice_items`
--
ALTER TABLE `cp_invoice_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `cp_orders`
--
ALTER TABLE `cp_orders`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT for table `cp_order_history`
--
ALTER TABLE `cp_order_history`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=449;

--
-- AUTO_INCREMENT for table `cp_order_items`
--
ALTER TABLE `cp_order_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=138;

--
-- AUTO_INCREMENT for table `cp_order_photos`
--
ALTER TABLE `cp_order_photos`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT for table `cp_payments`
--
ALTER TABLE `cp_payments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `cp_payment_receipts`
--
ALTER TABLE `cp_payment_receipts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `cp_print_finishes`
--
ALTER TABLE `cp_print_finishes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `cp_print_jobs`
--
ALTER TABLE `cp_print_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cp_print_materials`
--
ALTER TABLE `cp_print_materials`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `cp_print_meter_logs`
--
ALTER TABLE `cp_print_meter_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `cp_print_prices`
--
ALTER TABLE `cp_print_prices`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `cp_print_price_rules`
--
ALTER TABLE `cp_print_price_rules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `cp_print_requests`
--
ALTER TABLE `cp_print_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `cp_print_request_items`
--
ALTER TABLE `cp_print_request_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cp_print_rolls`
--
ALTER TABLE `cp_print_rolls`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `cp_print_sizes`
--
ALTER TABLE `cp_print_sizes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `cp_products`
--
ALTER TABLE `cp_products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `cp_product_images`
--
ALTER TABLE `cp_product_images`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `cp_promotion_facebook`
--
ALTER TABLE `cp_promotion_facebook`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `cp_promotion_products`
--
ALTER TABLE `cp_promotion_products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `cp_quotes`
--
ALTER TABLE `cp_quotes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91;

--
-- AUTO_INCREMENT for table `cp_quote_condition_templates`
--
ALTER TABLE `cp_quote_condition_templates`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cp_quote_costs`
--
ALTER TABLE `cp_quote_costs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cp_quote_items`
--
ALTER TABLE `cp_quote_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=241;

--
-- AUTO_INCREMENT for table `cp_quote_public_tokens`
--
ALTER TABLE `cp_quote_public_tokens`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `cp_quote_totals`
--
ALTER TABLE `cp_quote_totals`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=142;

--
-- AUTO_INCREMENT for table `cp_roles`
--
ALTER TABLE `cp_roles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cp_settings`
--
ALTER TABLE `cp_settings`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=168;

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

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
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `cp_web_quote_notifications`
--
ALTER TABLE `cp_web_quote_notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `cp_web_quote_requests`
--
ALTER TABLE `cp_web_quote_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `cp_whatsapp_chats`
--
ALTER TABLE `cp_whatsapp_chats`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `cp_whatsapp_log`
--
ALTER TABLE `cp_whatsapp_log`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=103;

--
-- AUTO_INCREMENT for table `cp_whatsapp_messages`
--
ALTER TABLE `cp_whatsapp_messages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `cp_whatsapp_templates`
--
ALTER TABLE `cp_whatsapp_templates`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

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
-- Constraints for table `cp_invoice_documents`
--
ALTER TABLE `cp_invoice_documents`
  ADD CONSTRAINT `fk_cp_invoice_documents_invoice` FOREIGN KEY (`invoice_id`) REFERENCES `cp_invoices` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cp_invoice_documents_order` FOREIGN KEY (`order_id`) REFERENCES `cp_orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cp_invoice_items`
--
ALTER TABLE `cp_invoice_items`
  ADD CONSTRAINT `fk_cp_invoice_items_document` FOREIGN KEY (`document_id`) REFERENCES `cp_invoice_documents` (`id`) ON DELETE CASCADE;

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
