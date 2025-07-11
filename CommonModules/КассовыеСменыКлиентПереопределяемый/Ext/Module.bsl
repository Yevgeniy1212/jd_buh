﻿#Область ПрограммныйИнтерфейс

// Обработчик события переопределяет произвольную команду формы списка Кассовая смена.
//
// Параметры:
//  Команда - команда формы
//
Процедура ФормаСпискаВыполнитьПереопределяемуюКоманду(Команда) Экспорт
	
КонецПроцедуры

// Обработчик события переопределяет произвольную команду формы документа Кассовая смена.
//
// Параметры:
//  Команда - команда формы
//
Процедура ФормаДокументаВыполнитьПереопределяемуюКоманду(Команда) Экспорт
	
КонецПроцедуры

// Обработчик события вызывается при получении имени кассира.
//
// Параметры:
//  Объект - Значение, которое используется как основание для заполнения,
//  ИмяКассира - Строка, Неопределено - Текст, используемый для заполнения документа
//  СтандартнаяОбработка - Булево
//
Процедура ОбработкаЗаполненияИмяКассира(Объект, ИмяКассира, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

Процедура УправлениеФУЗаполнитьДополнительныеПараметрыПередОткрытиемСмены(ФискальноеУстройство, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

#КонецОбласти
