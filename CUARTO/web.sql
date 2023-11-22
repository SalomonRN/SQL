-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 11-09-2023 a las 02:44:29
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `web`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `datos`
--

CREATE TABLE `datos` (
  `Nombre` varchar(45) NOT NULL,
  `Apellido` varchar(45) NOT NULL,
  `Telefono` int(10) NOT NULL,
  `Direccion` varchar(45) NOT NULL,
  `CC` int(20) NOT NULL,
  `Edad` int(2) NOT NULL,
  `Correo` varchar(45) NOT NULL,
  `Password` varchar(45) NOT NULL,
  `Usuario` varchar(45) NOT NULL,
  `Cancion Favorita` varchar(45) NOT NULL,
  `Libro Favorito` varchar(45) NOT NULL,
  `Lugar Favorito` varchar(45) NOT NULL,
  `Carrera` varchar(45) NOT NULL,
  `Semestre` int(2) NOT NULL,
  `Colegio Egresado` varchar(45) NOT NULL,
  `Color Favorito` varchar(45) NOT NULL,
  `Marca del celular` varchar(45) NOT NULL,
  `Cantidad de hermanos` int(2) NOT NULL,
  `Jornada` varchar(45) NOT NULL,
  `Codigo Estudiantil` int(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
