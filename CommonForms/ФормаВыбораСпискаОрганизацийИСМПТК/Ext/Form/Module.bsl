﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СобытияФормИСМПТКПереопределяемый.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	ЗаполнитьСписокОрганизаций();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СобытияФормИСМПТККлиентПереопределяемый.ПриОткрытии(ЭтаФорма, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Настройки.Очистить();
	
	СохраненнаяТаблицаОрганизаций = Настройки.Получить("ТаблицаОрганизации");
	Если СохраненнаяТаблицаОрганизаций = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(СохраненнаяТаблицаОрганизаций) <> Тип("ТаблицаЗначений") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из ТаблицаОрганизации Цикл
		НайденнаяСтрока = СохраненнаяТаблицаОрганизаций.Найти(СтрокаТЧ.Организация, "Организация");
		Если НайденнаяСтрока = Неопределено Тогда
			СтрокаТЧ.Выбрана = Ложь;
		Иначе
			СтрокаТЧ.Выбрана = НайденнаяСтрока.Выбрана;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	
	Для Каждого СтрокаТЧ Из ТаблицаОрганизации Цикл
		СтрокаТЧ.Выбрана = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьВсе(Команда)
	
	Для Каждого СтрокаТЧ Из ТаблицаОрганизации Цикл
		СтрокаТЧ.Выбрана = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Организациии    = Новый Массив;
	РезультатВыбора = Новый Структура("Организации, СохраненыНастройки", Организациии, СохраненыНастройки);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Выбрана", Истина);
	НайденныеСтроки = ТаблицаОрганизации.НайтиСтроки(ПараметрыОтбора);
	
	Для Каждого СтрокаТЧ Из НайденныеСтроки Цикл
		РезультатВыбора.Организации.Добавить(СтрокаТЧ.Организация);
	КонецЦикла;
	
	Закрыть(РезультатВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСписокОрганизаций()
	
	ШаблонЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка       КАК Ссылка,
	|	Организации.Наименование КАК Наименование
	|ИЗ
	|	%1 КАК Организации
	|";
	
	Объединение = "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|";

	Порядок = "
	|УПОРЯДОЧИТЬ ПО
	|	Организации.Наименование";
	
	ТекстЗапроса = "";
	ТипыОрганизаций = Метаданные.ОпределяемыеТипы.ОрганизацияИСМПТК.Тип.Типы();
	ПерваяИтерация = Истина;
	Для Каждого Тип Из ТипыОрганизаций Цикл
		
		ПолноеИмя = Метаданные.НайтиПоТипу(Тип).ПолноеИмя();
		ТекстЗапроса = ТекстЗапроса + СтрШаблон(ШаблонЗапроса, ПолноеИмя) + ?(Не ПерваяИтерация, Объединение, "");
		ПерваяИтерация = Ложь;
		
	КонецЦикла;
	ТекстЗапроса = ТекстЗапроса + Порядок;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ТаблицаОрганизации.Добавить();
		НоваяСтрока.Организация = Выборка.Ссылка;
		НоваяСтрока.Выбрана 	= Параметры.Организации.Найти(Выборка.Ссылка) <> Неопределено;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	СохраненыНастройки = Истина;
	
КонецПроцедуры

#КонецОбласти

