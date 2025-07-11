﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Документ из Параметры.ДокументыВыбора Цикл
		СписокДокументов.Добавить(Документ.Значение, Документ.Представление);
	КонецЦикла;	
	
	СобытияФормИСМПТКПереопределяемый.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СобытияФормИСМПТККлиентПереопределяемый.ПриОткрытии(ЭтаФорма, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбранныйДокумент = Элементы.СписокДокументов.ТекущиеДанные.Значение;
	ЭтаФорма.Закрыть(ВыбранныйДокумент);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормы

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
		
	ВыбранныйДокумент  = СписокДокументов.НайтиПоИдентификатору(ВыбраннаяСтрока).Значение;	
	ЭтаФорма.Закрыть(ВыбранныйДокумент);

КонецПроцедуры

#КонецОбласти

