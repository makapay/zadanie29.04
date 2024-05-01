-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Апр 30 2024 г., 19:36
-- Версия сервера: 8.0.30
-- Версия PHP: 7.4.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `TestDB`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`%` PROCEDURE `change_sname` (IN `oldName` VARCHAR(30), IN `oldSurname` VARCHAR(30), IN `newSurname` VARCHAR(30), OUT `message` VARCHAR(100))   BEGIN
    DECLARE employeeId INT;
 -- Найти сотрудника с указанной фамилией
    SELECT id INTO employeeId FROM employees WHERE name = oldName AND surname = oldSurname;
    
    IF employeeId IS NOT NULL THEN
        -- Если сотрудник найден, меняем его фамилию
        UPDATE employee SET surname = newSurname WHERE id = employeeId;
        SET message = CONCAT('Фамилия ', oldSurname, ' успешно изменена на ', newSurname);
    ELSE
        -- Если сотрудник не найден, сообщаем об этом
        SET message = CONCAT('Сотрудник ', oldName,' с фамилией ',oldSurname,' не найден');
    END IF;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `change_surname` (IN `oldName` VARCHAR(30), IN `oldSurname` VARCHAR(30), IN `newSurname` VARCHAR(30), OUT `message` VARCHAR(100))   BEGIN
    DECLARE employeeId INT;
    -- Найти сотрудника с указанной фамилией
    SELECT id FROM employees WHERE name = oldName AND surname = oldSurname;

    IF id IS NOT NULL THEN
        -- Если сотрудник найден, меняем его фамилию
        UPDATE employees SET surname = newSurname WHERE id = id;
        SET message = CONCAT('Фамилия ', oldSurname, ' успешно изменена на ', newSurname);
    ELSE
        -- Если сотрудник не найден, сообщаем об этом
        SET message = CONCAT('Сотрудник ', oldName,' с фамилией ',oldSurname,' не найден');
    END IF;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `sale_tour_price` (IN `id` INT)   BEGIN
    DECLARE oldPrice DECIMAL(10, 2);
    DECLARE newPrice DECIMAL(10, 2);
    
    SELECT price INTO oldPrice FROM tours WHERE id = id;
    
    IF oldPrice IS NOT NULL THEN
        SET newPrice = oldPrice / 2;
        
        UPDATE tours SET price = newPrice WHERE id = id;
        
        SELECT 'Цена тура уменьшена в два раза' AS message;
    ELSE
        SELECT 'Такой тур не найден' AS message;
    END IF;
    
END$$

--
-- Функции
--
CREATE DEFINER=`root`@`%` FUNCTION `Hotel_des_func` (`des` VARCHAR(100)) RETURNS VARCHAR(100) CHARSET utf8mb4  BEGIN
    IF hotels.rating = 4 THEN
        SET des = CONCAT('Отель четыре звезды');
    ELSEIF hotels.rating = 5 THEN
    	SET des = CONCAT('Отель пять звезд');
    END IF;
RETURN des;
END$$

CREATE DEFINER=`root`@`%` FUNCTION `med_vacation` (`salary` DECIMAL(8,2), `start_date` DATE, `end_date` DATE) RETURNS DECIMAL(8,2)  BEGIN
DECLARE day_in_month decimal(6,2);
DECLARE days int;
SET days = DATEDIFF(end_date, start_date) + 1;
SET day_in_month = 29.3;
RETURN (salary / day_in_month) * days;
END$$

CREATE DEFINER=`root`@`%` FUNCTION `sale_price` (`pr` INT) RETURNS INT  BEGIN
	DECLARE SALE INT;
		IF pr >= 15000 THEN
			SET SALE = (price*0,95);
		ELSEIF pr > 20000 THEN
			SET SALE = (price*0,90);
    	END IF;
	RETURN SALE;
END$$

CREATE DEFINER=`root`@`%` FUNCTION `sale_price_func` (`pr` INT) RETURNS INT  BEGIN
	DECLARE SALE INT;
		IF pr >= 15000 THEN
			SET SALE = (tours.price*0,95);
		ELSEIF pr > 20000 THEN
			SET SALE = (tours.price*0,90);
    	END IF;
	RETURN SALE;
END$$

CREATE DEFINER=`root`@`%` FUNCTION `vacation` (`salary` DECIMAL(8,2), `start_date` DATE, `end_date` DATE) RETURNS DECIMAL(8,2)  BEGIN 
DECLARE days int;
DECLARE day_in_month decimal(6,2);
SET day_in_month = 29.3;set days = datediff(end_date, start_date) + 1;
RETURN (salary / day_in_month) * days;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `agency`
--

CREATE TABLE `agency` (
  `client_id` int DEFAULT NULL,
  `employees_id` int DEFAULT NULL,
  `comleted_payment_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `category`
--

CREATE TABLE `category` (
  `id` int NOT NULL,
  `title` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `category`
--

INSERT INTO `category` (`id`, `title`) VALUES
(1, 'Эконом'),
(2, 'Стандарт'),
(3, 'Все включено');

-- --------------------------------------------------------

--
-- Структура таблицы `cities`
--

CREATE TABLE `cities` (
  `id` int NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `country_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `cities`
--

INSERT INTO `cities` (`id`, `name`, `country_id`) VALUES
(1, 'Казань', 1),
(2, 'Москва', 1),
(3, 'Стамбул', 2),
(4, 'Сочи', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `Clients`
--

CREATE TABLE `Clients` (
  `id` int NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `surname` varchar(50) DEFAULT NULL,
  `phone_number` int DEFAULT NULL,
  `e_mail` varchar(50) DEFAULT NULL,
  `login` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `visa` int DEFAULT NULL,
  `passport_series` int DEFAULT NULL,
  `passport_num` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `Clients`
--

INSERT INTO `Clients` (`id`, `name`, `surname`, `phone_number`, `e_mail`, `login`, `password`, `visa`, `passport_series`, `passport_num`) VALUES
(1, 'Виктор', 'Антонов', 809478, 'vik.ant@gmail.com', 'vik1', 'vik1', 123, 2233, 123456),
(2, 'Елена', 'Фролова', 345876, 'ellen.fr@mail.ru', 'log', 'pass', 4567, 9876, 456123),
(3, 'Виктор', 'Пименов', 820475, 'Alexx.Pim@gmail.com', 'alex', 'alex1', 890, 1358, 447915),
(4, 'Александр', 'Пименов', 650873, 'Alexx.Pim@gmail.com', 'alex', 'alex1', 7934, 2581, 360379),
(5, 'Виктория', 'Ковалева', 869295, 'ViKoval.gmail.com', 'vikoval', 'vikoval', 4975, 4967, 305837);

--
-- Триггеры `Clients`
--
DELIMITER $$
CREATE TRIGGER `Delete_Client` AFTER DELETE ON `Clients` FOR EACH ROW INSERT INTO Histiry_Client(client_id, client_name, client_surname, client_number, cliente_mail, client_login, client_password, client_visa, client_passport_series, client_passport_num)
VALUES(OLD.id, concat('Удален клиент', OLD.name, OLD.surname, OLD.phone_number, OLD.e_mail, OLD.login, OLD.password, OLD.visa, OLD.passport_series, OLD.passport_num))
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Insert_Client` AFTER INSERT ON `Clients` FOR EACH ROW INSERT INTO Histiry_Client(id, name, surname, phone_number, e_mail, login, password, visa, passport_series, _passport_num)
VALUES(NEW.id, concat('Добавлен клиент', NEW.name, NEW.surname, NEW.phone_number, NEW.e_mail, NEW.login, NEW.password, NEW.visa, NEW.passport_series, NEW.passport_num))
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Update_Client` AFTER UPDATE ON `Clients` FOR EACH ROW INSERT INTO Histiry_Client(client_id, client_name, 				client_surname, client_number, cliente_mail, client_login, 		client_password, client_visa, client_passport_series, 			client_passport_num)
-- триггер отслеживающий изменение данных о клиентах
VALUES(OLD.id, concat('Обновлены данные о клиенте', OLD.name, OLD.surname, OLD.phone_number, OLD.e_mail, OLD.login, OLD.password, OLD.visa, OLD.passport_series, OLD.passport_num))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `comleted_payment`
--

CREATE TABLE `comleted_payment` (
  `id` int NOT NULL,
  `client_id` int DEFAULT NULL,
  `date` date DEFAULT NULL,
  `payment_method_id` int DEFAULT NULL,
  `payment_status` varchar(50) DEFAULT NULL,
  `summa` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `countries`
--

CREATE TABLE `countries` (
  `id` int NOT NULL,
  `name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `countries`
--

INSERT INTO `countries` (`id`, `name`) VALUES
(1, 'Россия'),
(2, 'Турция');

-- --------------------------------------------------------

--
-- Структура таблицы `direction`
--

CREATE TABLE `direction` (
  `id` int NOT NULL,
  `title` varchar(50) DEFAULT NULL,
  `city_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `direction`
--

INSERT INTO `direction` (`id`, `title`, `city_id`) VALUES
(1, 'Москва-Казань', 1),
(2, 'Москва-Стамбул', 3),
(3, 'Москва-Сочи', 4),
(4, 'Москва', 2);

-- --------------------------------------------------------

--
-- Структура таблицы `duration`
--

CREATE TABLE `duration` (
  `id` int NOT NULL,
  `duration` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `duration`
--

INSERT INTO `duration` (`id`, `duration`) VALUES
(1, 5),
(2, 7),
(3, 10),
(4, 14);

-- --------------------------------------------------------

--
-- Структура таблицы `employees`
--

CREATE TABLE `employees` (
  `id` int NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `surname` varchar(50) DEFAULT NULL,
  `patronymic` varchar(50) DEFAULT NULL,
  `job_title` varchar(100) DEFAULT NULL,
  `phone_number` int DEFAULT NULL,
  `e_mail` varchar(50) DEFAULT NULL,
  `login` char(10) DEFAULT NULL,
  `password` char(10) DEFAULT NULL,
  `salary` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `employees`
--

INSERT INTO `employees` (`id`, `name`, `surname`, `patronymic`, `job_title`, `phone_number`, `e_mail`, `login`, `password`, `salary`) VALUES
(1, 'Василий', 'Васельков', 'Антонович', 'Туристический менеджер', 796946, 'Vasiliy.@mail.ru', 'log', 'pas', 30000),
(2, 'Марина', 'Васнецова', 'Анатоьевна', 'Гид', 820475, 'marina@gmail.com', 'mar', 'mar1', 34000),
(3, 'Андрей', 'Маев', 'Павлович', 'Менеджер по работе с клиентами', 83456, 'AndrMaev@mail.ru', 'log', 'pass1', 49000);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `employees_med_vacation`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `employees_med_vacation` (
`name` varchar(50)
,`surname` varchar(50)
,`patronymic` varchar(50)
,`salary` int
,`Больничный` decimal(8,2)
);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `employees_vacation`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `employees_vacation` (
`name` varchar(50)
,`surname` varchar(50)
,`patronymic` varchar(50)
,`salary` int
,`Отпускные` decimal(8,2)
);

-- --------------------------------------------------------

--
-- Структура таблицы `excursions`
--

CREATE TABLE `excursions` (
  `id` int NOT NULL,
  `title` varchar(50) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `excursions`
--

INSERT INTO `excursions` (`id`, `title`, `description`) VALUES
(1, 'Турецкая ночь', 'Круиз на теплоходе по Босфорскому проливу'),
(2, 'Огни Казани', 'Экскурсия по ночному городу'),
(3, 'Солнце Москвы', 'экскурсия по городу с посещение колеса обозрения');

-- --------------------------------------------------------

--
-- Структура таблицы `Histiry_Client`
--

CREATE TABLE `Histiry_Client` (
  `client_id` int NOT NULL,
  `client_name` varchar(20) DEFAULT NULL,
  `client_surname` varchar(20) DEFAULT NULL,
  `client_number` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `hotels`
--

CREATE TABLE `hotels` (
  `id` int NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `rating` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `hotels`
--

INSERT INTO `hotels` (`id`, `name`, `rating`) VALUES
(1, 'Луксор Лас-Вегас', 4),
(2, 'Circus circus', 5),
(3, 'Akra Kemer', 5),
(4, 'Вояж Соргун', 4);

-- --------------------------------------------------------

--
-- Структура таблицы `med_vacation`
--

CREATE TABLE `med_vacation` (
  `id` int NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `id_emplyee` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `med_vacation`
--

INSERT INTO `med_vacation` (`id`, `start_date`, `end_date`, `id_emplyee`) VALUES
(1, '2023-09-12', '2023-09-26', 1),
(2, '2024-03-01', '2024-03-19', 3);

-- --------------------------------------------------------

--
-- Структура таблицы `nutription`
--

CREATE TABLE `nutription` (
  `id` int NOT NULL,
  `number_of_meals` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `nutription`
--

INSERT INTO `nutription` (`id`, `number_of_meals`) VALUES
(1, 1),
(2, 3);

-- --------------------------------------------------------

--
-- Структура таблицы `payment`
--

CREATE TABLE `payment` (
  `id` int NOT NULL,
  `client_id` int DEFAULT NULL,
  `tour_id` int DEFAULT NULL,
  `payment_summa` decimal(10,2) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `payment_method_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `payment_method`
--

CREATE TABLE `payment_method` (
  `id` int NOT NULL,
  `name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `promotion`
--

CREATE TABLE `promotion` (
  `id` int NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `validity` int DEFAULT NULL,
  `payment` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `promotion`
--

INSERT INTO `promotion` (`id`, `name`, `validity`, `payment`) VALUES
(1, 'Скидка ко дню рождения', 10, 10),
(2, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `reservation`
--

CREATE TABLE `reservation` (
  `id` int NOT NULL,
  `client_id` int DEFAULT NULL,
  `tour_id` int DEFAULT NULL,
  `date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `reviews`
--

CREATE TABLE `reviews` (
  `id` int NOT NULL,
  `client_id` int DEFAULT NULL,
  `text` varchar(200) DEFAULT NULL,
  `rating` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `servises`
--

CREATE TABLE `servises` (
  `id` int NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `tour_id` int DEFAULT NULL,
  `visa_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `tours`
--

CREATE TABLE `tours` (
  `id` int NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `duration_id` int DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `promotion_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `tours`
--

INSERT INTO `tours` (`id`, `name`, `description`, `duration_id`, `price`, `promotion_id`) VALUES
(1, 'Тур по Стамбулу', 'Обзорный тур по городу Стамбул', 2, '20000.00', NULL),
(2, 'Туо по Казани', 'тур по прекрасному городу Казань', 1, '15000.00', NULL),
(3, 'Тур по Сочи', 'Прекрасный отдых в солнечном городе Сочи', 4, '28000.00', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `tour_description`
--

CREATE TABLE `tour_description` (
  `id` int NOT NULL,
  `category_id` int DEFAULT NULL,
  `hotel_id` int DEFAULT NULL,
  `nutription_id` int DEFAULT NULL,
  `excursion_id` int DEFAULT NULL,
  `direction_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `tour_description`
--

INSERT INTO `tour_description` (`id`, `category_id`, `hotel_id`, `nutription_id`, `excursion_id`, `direction_id`) VALUES
(1, 1, 2, 1, 2, 1),
(2, 3, 3, 2, 1, 2),
(3, 2, 1, 2, 3, 4);

-- --------------------------------------------------------

--
-- Структура таблицы `vacation`
--

CREATE TABLE `vacation` (
  `id` int NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `id_emplyee` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `vacation`
--

INSERT INTO `vacation` (`id`, `start_date`, `end_date`, `id_emplyee`) VALUES
(1, '2024-01-09', '2024-01-25', 1),
(2, '2024-03-01', '2024-01-17', 2);

-- --------------------------------------------------------

--
-- Структура таблицы `vises`
--

CREATE TABLE `vises` (
  `id` int NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `code` int DEFAULT NULL,
  `validity` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура для представления `employees_med_vacation`
--
DROP TABLE IF EXISTS `employees_med_vacation`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `employees_med_vacation`  AS SELECT `employees`.`name` AS `name`, `employees`.`surname` AS `surname`, `employees`.`patronymic` AS `patronymic`, `employees`.`salary` AS `salary`, `med_vacation`(`employees`.`salary`,`med_vacation`.`start_date`,`med_vacation`.`end_date`) AS `Больничный` FROM (`employees` join `med_vacation` on((`employees`.`id` = `med_vacation`.`id_emplyee`)))  ;

-- --------------------------------------------------------

--
-- Структура для представления `employees_vacation`
--
DROP TABLE IF EXISTS `employees_vacation`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `employees_vacation`  AS SELECT `employees`.`name` AS `name`, `employees`.`surname` AS `surname`, `employees`.`patronymic` AS `patronymic`, `employees`.`salary` AS `salary`, `vacation`(`employees`.`salary`,`vacation`.`start_date`,`vacation`.`end_date`) AS `Отпускные` FROM (`employees` join `vacation` on((`employees`.`id` = `vacation`.`id_emplyee`)))  ;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `agency`
--
ALTER TABLE `agency`
  ADD KEY `client_id` (`client_id`),
  ADD KEY `employees_id` (`employees_id`),
  ADD KEY `comleted_payment_id` (`comleted_payment_id`);

--
-- Индексы таблицы `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `cities`
--
ALTER TABLE `cities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `country_id` (`country_id`);

--
-- Индексы таблицы `Clients`
--
ALTER TABLE `Clients`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `comleted_payment`
--
ALTER TABLE `comleted_payment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id` (`client_id`);

--
-- Индексы таблицы `countries`
--
ALTER TABLE `countries`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `direction`
--
ALTER TABLE `direction`
  ADD PRIMARY KEY (`id`),
  ADD KEY `city_id` (`city_id`);

--
-- Индексы таблицы `duration`
--
ALTER TABLE `duration`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `excursions`
--
ALTER TABLE `excursions`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `Histiry_Client`
--
ALTER TABLE `Histiry_Client`
  ADD PRIMARY KEY (`client_id`);

--
-- Индексы таблицы `hotels`
--
ALTER TABLE `hotels`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `med_vacation`
--
ALTER TABLE `med_vacation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_emplyee` (`id_emplyee`);

--
-- Индексы таблицы `nutription`
--
ALTER TABLE `nutription`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id` (`client_id`),
  ADD KEY `tour_id` (`tour_id`),
  ADD KEY `payment_method_id` (`payment_method_id`);

--
-- Индексы таблицы `payment_method`
--
ALTER TABLE `payment_method`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `promotion`
--
ALTER TABLE `promotion`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `reservation`
--
ALTER TABLE `reservation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id` (`client_id`),
  ADD KEY `tour_id` (`tour_id`);

--
-- Индексы таблицы `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `servises`
--
ALTER TABLE `servises`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tour_id` (`tour_id`),
  ADD KEY `visa_id` (`visa_id`);

--
-- Индексы таблицы `tours`
--
ALTER TABLE `tours`
  ADD PRIMARY KEY (`id`),
  ADD KEY `duration_id` (`duration_id`),
  ADD KEY `promotion_id` (`promotion_id`);

--
-- Индексы таблицы `tour_description`
--
ALTER TABLE `tour_description`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `hotel_id` (`hotel_id`),
  ADD KEY `nutription_id` (`nutription_id`),
  ADD KEY `excursion_id` (`excursion_id`),
  ADD KEY `direction_id` (`direction_id`);

--
-- Индексы таблицы `vacation`
--
ALTER TABLE `vacation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_emplyee` (`id_emplyee`);

--
-- Индексы таблицы `vises`
--
ALTER TABLE `vises`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `category`
--
ALTER TABLE `category`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `cities`
--
ALTER TABLE `cities`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `Clients`
--
ALTER TABLE `Clients`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `comleted_payment`
--
ALTER TABLE `comleted_payment`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `countries`
--
ALTER TABLE `countries`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `direction`
--
ALTER TABLE `direction`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `duration`
--
ALTER TABLE `duration`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `employees`
--
ALTER TABLE `employees`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `excursions`
--
ALTER TABLE `excursions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `Histiry_Client`
--
ALTER TABLE `Histiry_Client`
  MODIFY `client_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `hotels`
--
ALTER TABLE `hotels`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `nutription`
--
ALTER TABLE `nutription`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `payment`
--
ALTER TABLE `payment`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `payment_method`
--
ALTER TABLE `payment_method`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `promotion`
--
ALTER TABLE `promotion`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `reservation`
--
ALTER TABLE `reservation`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `servises`
--
ALTER TABLE `servises`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `tours`
--
ALTER TABLE `tours`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `tour_description`
--
ALTER TABLE `tour_description`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `vises`
--
ALTER TABLE `vises`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `agency`
--
ALTER TABLE `agency`
  ADD CONSTRAINT `agency_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `Clients` (`id`),
  ADD CONSTRAINT `agency_ibfk_2` FOREIGN KEY (`employees_id`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `agency_ibfk_3` FOREIGN KEY (`comleted_payment_id`) REFERENCES `comleted_payment` (`id`);

--
-- Ограничения внешнего ключа таблицы `cities`
--
ALTER TABLE `cities`
  ADD CONSTRAINT `cities_ibfk_1` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`);

--
-- Ограничения внешнего ключа таблицы `comleted_payment`
--
ALTER TABLE `comleted_payment`
  ADD CONSTRAINT `comleted_payment_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `Clients` (`id`);

--
-- Ограничения внешнего ключа таблицы `direction`
--
ALTER TABLE `direction`
  ADD CONSTRAINT `direction_ibfk_1` FOREIGN KEY (`city_id`) REFERENCES `cities` (`id`);

--
-- Ограничения внешнего ключа таблицы `med_vacation`
--
ALTER TABLE `med_vacation`
  ADD CONSTRAINT `med_vacation_ibfk_1` FOREIGN KEY (`id_emplyee`) REFERENCES `employees` (`id`);

--
-- Ограничения внешнего ключа таблицы `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `Clients` (`id`),
  ADD CONSTRAINT `payment_ibfk_2` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`),
  ADD CONSTRAINT `payment_ibfk_3` FOREIGN KEY (`payment_method_id`) REFERENCES `payment_method` (`id`);

--
-- Ограничения внешнего ключа таблицы `reservation`
--
ALTER TABLE `reservation`
  ADD CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `Clients` (`id`),
  ADD CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`);

--
-- Ограничения внешнего ключа таблицы `servises`
--
ALTER TABLE `servises`
  ADD CONSTRAINT `servises_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`),
  ADD CONSTRAINT `servises_ibfk_2` FOREIGN KEY (`visa_id`) REFERENCES `vises` (`id`);

--
-- Ограничения внешнего ключа таблицы `tours`
--
ALTER TABLE `tours`
  ADD CONSTRAINT `tours_ibfk_1` FOREIGN KEY (`duration_id`) REFERENCES `duration` (`id`),
  ADD CONSTRAINT `tours_ibfk_2` FOREIGN KEY (`promotion_id`) REFERENCES `promotion` (`id`);

--
-- Ограничения внешнего ключа таблицы `tour_description`
--
ALTER TABLE `tour_description`
  ADD CONSTRAINT `tour_description_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`),
  ADD CONSTRAINT `tour_description_ibfk_2` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`),
  ADD CONSTRAINT `tour_description_ibfk_3` FOREIGN KEY (`nutription_id`) REFERENCES `nutription` (`id`),
  ADD CONSTRAINT `tour_description_ibfk_4` FOREIGN KEY (`excursion_id`) REFERENCES `excursions` (`id`),
  ADD CONSTRAINT `tour_description_ibfk_5` FOREIGN KEY (`direction_id`) REFERENCES `direction` (`id`);

--
-- Ограничения внешнего ключа таблицы `vacation`
--
ALTER TABLE `vacation`
  ADD CONSTRAINT `vacation_ibfk_1` FOREIGN KEY (`id_emplyee`) REFERENCES `employees` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
