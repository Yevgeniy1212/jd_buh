﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ИнтернетПоддержкаПользователейВызовСервера.
//
// Серверные процедуры и функции Интернет-поддержки пользователей:
//  - определение доступности подключения;
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет, доступно ли текущему пользователю выполнение подключения
// Интернет-поддержки: авторизация/регистрация пользователя, регистрация
// программного продукта в соответствии с текущим режимом работы
// и правами пользователя.
//
// Возвращаемое значение:
//  Булево - Истина - подключение Интернет-поддержки доступно,
//           Ложь - в противном случае.
//
Функция ДоступноПодключениеИнтернетПоддержки() Экспорт
	
	Возврат ИнтернетПоддержкаПользователей.ДоступноПодключениеИнтернетПоддержки();
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область НастройкиПрограммы

// Обработка события отключения Интернет-поддержки пользователей.
//
Процедура ВыйтиИзИПП() Экспорт
	
	// Проверка права записи данных
	Если Не ИнтернетПоддержкаПользователей.ПравоЗаписиПараметровИПП() Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для записи данных аутентификации Интернет-поддержки.'");
	КонецЕсли;
	
	// Запись данных
	УстановитьПривилегированныйРежим(Истина);
	ИнтернетПоддержкаПользователей.СлужебнаяСохранитьДанныеАутентификации(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область Тарификация

// См. ИнтернетПоддержкаПользователей.УслугаПодключена.
//
Функция УслугаПодключена(Знач ИдентификаторУслуги, Знач ЗначениеРазделителя = Неопределено) Экспорт
	
	Возврат ИнтернетПоддержкаПользователей.УслугаПодключена(ИдентификаторУслуги, ЗначениеРазделителя);
	
КонецФункции

#КонецОбласти

#Область НастройкиПрограммы

// Возвращает значение функциональной опции "ОтправлятьПисьмаВФорматеHTML"
//
// Возвращаемое значение:
//  Булево - признак использования функциональной опции "ОтправлятьПисьмаВФорматеHTML".
//
Функция ОтправлятьПисьмаВФорматеHTML() Экспорт
	
	Возврат ИнтернетПоддержкаПользователей.ОтправлятьПисьмаВФорматеHTML();
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПрочиеСлужебныеПроцедурыИФункции

// См. ИнтернетПоддержкаПользователей.СлужебнаяURLДляПереходаНаСтраницуИнтегрированногоСайта.
//
Функция СлужебнаяURLДляПереходаНаСтраницуИнтегрированногоСайта(Знач URLСтраницыСайта) Экспорт
	
	Возврат ИнтернетПоддержкаПользователей.СлужебнаяURLДляПереходаНаСтраницуИнтегрированногоСайта(URLСтраницыСайта);
	
КонецФункции

// См. ИнтернетПоддержкаПользователейКлиентСервер.ФорматированнаяСтрокаИзHTML
//
Функция ФорматированнаяСтрокаИзHTML(Знач ТекстСообщения) Экспорт
	
	Возврат ИнтернетПоддержкаПользователейКлиентСервер.ФорматированнаяСтрокаИзHTML(
		ТекстСообщения);
	
КонецФункции

#КонецОбласти

#КонецОбласти
