﻿&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Контейнер = СНТКлиентСервер.КонтейнерМетодов();
	Контейнер.ПриОткрытииФормы(ЭтаФорма, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = СНТКлиентСервер.ИмяСобытияЗаписьСНТ() Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры
