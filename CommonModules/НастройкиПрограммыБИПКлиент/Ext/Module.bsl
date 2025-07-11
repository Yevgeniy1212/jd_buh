﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
// Подсистема "Настройки программы".
// ОбщийМодуль.НастройкиПрограммыБИПКлиент.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает настройку интернет-поддержки и сервисов БИП.
//
// Параметры:
//  ПараметрыВыполненияКоманды - ПараметрыВыполненияКоманды
//
Процедура ОткрытьНастройкиИнтернетПоддержкаИСервисы(ПараметрыВыполненияКоманды) Экспорт
	
	ОткрытьФорму(
		"Обработка.ПанельАдминистрированияБИП.Форма.ИнтернетПоддержкаИСервисы",
		,
		ПараметрыВыполненияКоманды.Источник,
		"Обработка.ПанельАдминистрированияБИП.Форма.ИнтернетПоддержкаИСервисы"
			+ ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти
