﻿
// бит_MZyubin Процедура - обработчик события "ПриСозданииНаСервере" формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МетаданныеОбъекта = Объект.Ссылка.Метаданные();
	
	// вызов механизма защиты
	бит_МодульЗащиты.ПроверитьВозможностьРаботы(ЭтаФорма,МетаданныеОбъекта.ПолноеИмя(),Отказ); 
	
КонецПроцедуры
