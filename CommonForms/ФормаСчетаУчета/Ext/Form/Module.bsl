﻿
#Область ОбработчикиСобытийФормы   

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УсловияОтбораСчетов = Неопределено;
	ПризнакЗабалансовый = Неопределено;
	ПризнакСчетГруппа   = Ложь; // по умолчанию исключаются запрещенные для использования в проводках счета
	ПризнакВалютный     = Неопределено;
	
	Параметры.Свойство("УсловияОтбораСчетов", УсловияОтбораСчетов);
	
	Если УсловияОтбораСчетов <> Неопределено И ТипЗнч(УсловияОтбораСчетов) = Тип("Структура") Тогда
		
		УсловияОтбораСчетов.Свойство("Забалансовый", ПризнакЗабалансовый);
		УсловияОтбораСчетов.Свойство("Валютный"    , ПризнакВалютный);
		Если УсловияОтбораСчетов.Свойство("ЗапретитьИспользоватьВПроводках") Тогда
			ПризнакСчетГруппа = УсловияОтбораСчетов.ЗапретитьИспользоватьВПроводках;
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры,, "ЗакрыватьПриВыборе, ЗакрыватьПриЗакрытииВладельца");
	ЗначенияПриОткрытии = Новый Структура();
	
	Если Параметры.Свойство("СчетУчетаРасчетовПоАвансам") Тогда
		
		ОбщегоНазначенияБККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СчетУчетаРасчетовПоВозвратам", "Видимость", Ложь);
		ЗначенияПриОткрытии.Вставить("СчетУчетаРасчетовСКонтрагентом", 	  СчетУчетаРасчетовСКонтрагентом);
		ЗначенияПриОткрытии.Вставить("СчетУчетаРасчетовПоАвансам",        СчетУчетаРасчетовПоАвансам);
		ПроцедурыБухгалтерскогоУчетаКлиентСервер.ИзменитьПараметрыВыбораСчета(Элементы.СчетУчетаРасчетовПоАвансам,, ПризнакВалютный, ПризнакЗабалансовый, ПризнакСчетГруппа);
		ПроцедурыБухгалтерскогоУчетаКлиентСервер.ИзменитьПараметрыВыбораСчета(Элементы.СчетУчетаРасчетовСКонтрагентом,, ПризнакВалютный, ПризнакЗабалансовый, ПризнакСчетГруппа);
		
	ИначеЕсли Параметры.Свойство("СчетУчетаРасчетовПоВозвратам") Тогда
		
		ОбщегоНазначенияБККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СчетУчетаРасчетовПоАвансам", "Видимость", Ложь);
		ЗначенияПриОткрытии.Вставить("СчетУчетаРасчетовСКонтрагентом", 	  СчетУчетаРасчетовСКонтрагентом);
		ЗначенияПриОткрытии.Вставить("СчетУчетаРасчетовПоВозвратам",      СчетУчетаРасчетовПоВозвратам);
		ПроцедурыБухгалтерскогоУчетаКлиентСервер.ИзменитьПараметрыВыбораСчета(Элементы.СчетУчетаРасчетовПоВозвратам,, ПризнакВалютный, ПризнакЗабалансовый, ПризнакСчетГруппа);
		ПроцедурыБухгалтерскогоУчетаКлиентСервер.ИзменитьПараметрыВыбораСчета(Элементы.СчетУчетаРасчетовСКонтрагентом,, ПризнакВалютный, ПризнакЗабалансовый, ПризнакСчетГруппа);
		
	Иначе
		ОбщегоНазначенияБККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СчетУчетаРасчетовСКонтрагентом", "Видимость", Ложь);
	КонецЕсли;
	
	Если Параметры.Свойство("СчетОтнесенияСебестоимостиБУ") Или Параметры.Свойство("СчетОтнесенияСебестоимостиНУ") Тогда
		
		ЗначенияПриОткрытии.Вставить("СчетОтнесенияСебестоимостиБУ", 	  СчетОтнесенияСебестоимостиБУ);
		ЗначенияПриОткрытии.Вставить("СубконтоОтнесенияСебестоимостиБУ1", СубконтоОтнесенияСебестоимостиБУ1);
		ЗначенияПриОткрытии.Вставить("СубконтоОтнесенияСебестоимостиБУ2", СубконтоОтнесенияСебестоимостиБУ2);
		ЗначенияПриОткрытии.Вставить("СубконтоОтнесенияСебестоимостиБУ3", СубконтоОтнесенияСебестоимостиБУ3);
		
		ЗначенияПриОткрытии.Вставить("СчетОтнесенияСебестоимостиНУ", 	  СчетОтнесенияСебестоимостиНУ);
		ЗначенияПриОткрытии.Вставить("СубконтоОтнесенияСебестоимостиНУ1", СубконтоОтнесенияСебестоимостиНУ1);
		ЗначенияПриОткрытии.Вставить("СубконтоОтнесенияСебестоимостиНУ2", СубконтоОтнесенияСебестоимостиНУ2);
		ЗначенияПриОткрытии.Вставить("СубконтоОтнесенияСебестоимостиНУ3", СубконтоОтнесенияСебестоимостиНУ3);
		
		ПроцедурыБухгалтерскогоУчетаКлиентСервер.ИзменитьПараметрыВыбораСчета(Элементы.СчетОтнесенияСебестоимостиБУ,, ПризнакВалютный, ПризнакЗабалансовый, ПризнакСчетГруппа);
		ПроцедурыБухгалтерскогоУчетаКлиентСервер.ИзменитьПараметрыВыбораСчета(Элементы.СчетОтнесенияСебестоимостиНУ,,, ПризнакЗабалансовый, ПризнакСчетГруппа);
		
		ПоляФормы      = Новый Структура("Субконто1, Субконто2, Субконто3",
		"СубконтоОтнесенияСебестоимостиБУ1", "СубконтоОтнесенияСебестоимостиБУ2", "СубконтоОтнесенияСебестоимостиБУ3");
		
		ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконтоОтнесенияСебестоимостиБУ1", "ЗаголовокСубконтоОтнесенияСебестоимостиБУ2", "ЗаголовокСубконтоОтнесенияСебестоимостиБУ3"); 
		
		УстановитьЗаголовкиИДоступностьСубконто(СчетОтнесенияСебестоимостиБУ, ПоляФормы, ЗаголовкиПолей, СчетОтнесенияСебестоимостиНУ);
		
	Иначе
		Элементы.ГруппаРазницыСтоимостиТоваров.Видимость = Ложь;
	КонецЕсли;
	
	МассивЭлементов = Новый Массив();
	
	Для Каждого ЭлементСтруктуры Из ЗначенияПриОткрытии Цикл
		МассивЭлементов.Добавить(ЭлементСтруктуры.Ключ);
	КонецЦикла;
	
	Если ТолькоПросмотр Тогда 	
				
		ОбщегоНазначенияБККлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "ТолькоПросмотр", Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы   

&НаКлиенте
Процедура СчетОтнесенияСебестоимостиБУПриИзменении(Элемент)
	
	ЭтотОбъект.СчетОтнесенияСебестоимостиНУ = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПреобразоватьСчетаБУвСчетНУ(Новый Структура("СчетБУ", СчетОтнесенияСебестоимостиБУ));
	
	ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
	"СубконтоОтнесенияСебестоимостиБУ1", "СубконтоОтнесенияСебестоимостиБУ2", "СубконтоОтнесенияСебестоимостиБУ3");
	
	ЗаголовкиПолей	= Новый Структура("Субконто1, Субконто2, Субконто3",
	"ЗаголовокСубконтоОтнесенияСебестоимостиБУ1", "ЗаголовокСубконтоОтнесенияСебестоимостиБУ2", "ЗаголовокСубконтоОтнесенияСебестоимостиБУ3"); 
	
	УстановитьЗаголовкиИДоступностьСубконто(СчетОтнесенияСебестоимостиБУ, ПоляФормы, ЗаголовкиПолей, СчетОтнесенияСебестоимостиНУ);
		
	ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
	"СубконтоОтнесенияСебестоимостиНУ1", "СубконтоОтнесенияСебестоимостиНУ2", "СубконтоОтнесенияСебестоимостиНУ3");
	
	ПроцедурыБухгалтерскогоУчетаКлиентСервер.ПриИзмененииСчета(СчетОтнесенияСебестоимостиНУ, ЭтотОбъект, ПоляФормы);
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ОтнесенияСебестоимостиБУ", "СчетОтнесенияСебестоимостиБУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ОтнесенияСебестоимостиНУ", "СчетОтнесенияСебестоимостиНУ");
	
	ДанныеОбъекта = Новый Структура("Организация, СубконтоОтнесенияСебестоимостиБУ1, СубконтоОтнесенияСебестоимостиБУ2, СубконтоОтнесенияСебестоимостиБУ3,
	|СубконтоОтнесенияСебестоимостиНУ1, СубконтоОтнесенияСебестоимостиНУ2, СубконтоОтнесенияСебестоимостиНУ3");
	
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, ЭтотОбъект);
	
	СчетОтнесенияСебестоимостиБУПриИзмененииНаСервере(ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеОбъекта);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетОтнесенияСебестоимостиНУПриИзменении(Элемент)
	
	ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
	"СубконтоОтнесенияСебестоимостиНУ1", "СубконтоОтнесенияСебестоимостиНУ2", "СубконтоОтнесенияСебестоимостиНУ3");
	
	ЗаголовкиПолей	= Новый Структура("Субконто1, Субконто2, Субконто3",
	"ЗаголовокСубконтоОтнесенияСебестоимостиНУ1", "ЗаголовокСубконтоОтнесенияСебестоимостиНУ2", "ЗаголовокСубконтоОтнесенияСебестоимостиНУ3"); 
	
	УстановитьЗаголовкиИДоступностьСубконто(СчетОтнесенияСебестоимостиНУ, ПоляФормы, ЗаголовкиПолей);
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ОтнесенияСебестоимостиНУ", "СчетОтнесенияСебестоимостиНУ");
	
	ДанныеОбъекта = Новый Структура("Организация, СубконтоОтнесенияСебестоимостиНУ1, СубконтоОтнесенияСебестоимостиНУ2, СубконтоОтнесенияСебестоимостиНУ3");
	
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, ЭтотОбъект);
	
	СчетОтнесенияСебестоимостиНУПриИзмененииНаСервере(ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеОбъекта);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоОтнесенияСебестоимостиБУ1ПриИзменении(Элемент)
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(ЭтотОбъект, СчетОтнесенияСебестоимостиБУ, СчетОтнесенияСебестоимостиНУ, 1, СубконтоОтнесенияСебестоимостиБУ1, "СубконтоОтнесенияСебестоимостиНУ");		
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ОтнесенияСебестоимостиБУ", "СчетОтнесенияСебестоимостиБУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ОтнесенияСебестоимостиНУ", "СчетОтнесенияСебестоимостиНУ",,Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоОтнесенияСебестоимостиБУ2ПриИзменении(Элемент)
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(ЭтотОбъект, СчетОтнесенияСебестоимостиБУ, СчетОтнесенияСебестоимостиНУ, 2, СубконтоОтнесенияСебестоимостиБУ2, "СубконтоОтнесенияСебестоимостиНУ");		
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ОтнесенияСебестоимостиБУ", "СчетОтнесенияСебестоимостиБУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ОтнесенияСебестоимостиНУ", "СчетОтнесенияСебестоимостиНУ",,Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоОтнесенияСебестоимостиБУ3ПриИзменении(Элемент)
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(ЭтотОбъект, СчетОтнесенияСебестоимостиБУ, СчетОтнесенияСебестоимостиНУ, 3, СубконтоОтнесенияСебестоимостиБУ3, "СубконтоОтнесенияСебестоимостиНУ");		
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ОтнесенияСебестоимостиБУ", "СчетОтнесенияСебестоимостиБУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ОтнесенияСебестоимостиНУ", "СчетОтнесенияСебестоимостиНУ",,Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоОтнесенияСебестоимостиБУ1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоОтнесенияСебестоимостиБУ", 1, "СчетОтнесенияСебестоимостиБУ", ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоОтнесенияСебестоимостиБУ2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоОтнесенияСебестоимостиБУ", 2, "СчетОтнесенияСебестоимостиБУ", ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоОтнесенияСебестоимостиБУ3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоОтнесенияСебестоимостиБУ", 3, "СчетОтнесенияСебестоимостиБУ", ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоОтнесенияСебестоимостиНУПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ОтнесенияСебестоимостиНУ", "СчетОтнесенияСебестоимостиНУ");
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоОтнесенияСебестоимостиНУ1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоОтнесенияСебестоимостиНУ", 1, "СчетОтнесенияСебестоимостиНУ", ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоОтнесенияСебестоимостиНУ2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоОтнесенияСебестоимостиНУ", 2, "СчетОтнесенияСебестоимостиНУ", ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоОтнесенияСебестоимостиНУ3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоОтнесенияСебестоимостиНУ", 3, "СчетОтнесенияСебестоимостиНУ", ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы   

&НаКлиенте
Процедура ОК(Команда)
	
	ЗначенияИзменились = ПроверитьЗначения();
	
	Отказ = ПроверитьЗаполнениеПередЗакрытием();
	
	Если ЗначенияИзменились Тогда
		
		Результат = Новый Структура();
		Результат.Вставить("ЗначенияПриОткрытии",              ЗначенияПриОткрытии);
		Результат.Вставить("ЗначенияПриЗакрытии",              ЗначенияПриЗакрытии());
			
		Если Не Отказ Тогда
			Закрыть(Результат);
		Иначе
			СообщитьОПустомСчете();
		КонецЕсли;
		
	Иначе
		
		Если Не Отказ Тогда
			ЗакрытьБезСохраненияИзменений();
		Иначе
			СообщитьОПустомСчете();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьБезСохраненияИзменений()
	
	Закрыть(Неопределено);	
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ЗначенияИзменились = ПроверитьЗначения();
	
	Если ЗначенияИзменились Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтаФорма);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Данные были изменены. Сохранить изменения?'"), РежимДиалогаВопрос.ДаНетОтмена);
	Иначе
		ЗакрытьБезСохраненияИзменений();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		РезультатЗакрытия = Новый Структура();
		РезультатЗакрытия.Вставить("ЗначенияПриОткрытии",              ЗначенияПриОткрытии);
		РезультатЗакрытия.Вставить("ЗначенияПриЗакрытии",              ЗначенияПриЗакрытии());
		
		Отказ = ПроверитьЗаполнениеПередЗакрытием();
		Если Не Отказ Тогда
			Закрыть(РезультатЗакрытия);
		Иначе
			СообщитьОПустомСчете();
		КонецЕсли;
		
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		ЗакрытьБезСохраненияИзменений();	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗначения()
	
	Для Каждого Реквизит Из ЗначенияПриОткрытии Цикл
		ИмяРеквизита = Реквизит.Ключ;
		Если ЭтаФорма[ИмяРеквизита] <> Реквизит.Значение Тогда
			Возврат Истина
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
				
КонецФункции

&НаСервере
Функция ЗначенияПриЗакрытии()
	
	ЗначенияПриЗакрытии = Новый Структура;
	
	Для Каждого НачальноеЗначение Из ЗначенияПриОткрытии Цикл
		ИмяРеквизита = НачальноеЗначение.Ключ;
		ЗначенияПриЗакрытии.Вставить(ИмяРеквизита, ЭтаФорма[ИмяРеквизита]);	
	КонецЦикла;
	
	Возврат ЗначенияПриЗакрытии;
	
КонецФункции

#КонецОбласти

#Область ГруппаРазницыСтоимостиТоваров

&НаСервереБезКонтекста
Процедура СчетОтнесенияСебестоимостиБУПриИзмененииНаСервере(ДанныеОбъекта)
	
	ПроцедурыБухгалтерскогоУчета.ПроверитьВладельцаСубконтоПодразделение(ДанныеОбъекта, 
	ДанныеОбъекта.Организация, 
	Новый Структура("НазваниеСубконтоБУ1, НазваниеСубконтоБУ2, НазваниеСубконтоБУ3, 
	|СубконтоБУ1, СубконтоБУ2, СубконтоБУ3",
	"СубконтоОтнесенияСебестоимостиБУ1", "СубконтоОтнесенияСебестоимостиБУ2", "СубконтоОтнесенияСебестоимостиБУ3", 
	ДанныеОбъекта.СубконтоОтнесенияСебестоимостиБУ1, ДанныеОбъекта.СубконтоОтнесенияСебестоимостиБУ2, ДанныеОбъекта.СубконтоОтнесенияСебестоимостиБУ3));
	
	ПроцедурыБухгалтерскогоУчета.ПроверитьВладельцаСубконтоПодразделение(ДанныеОбъекта, 
	ДанныеОбъекта.Организация, 
	Новый Структура("НазваниеСубконтоБУ1, НазваниеСубконтоБУ2, НазваниеСубконтоБУ3, 
	|СубконтоБУ1, СубконтоБУ2, СубконтоБУ3",
	"СубконтоОтнесенияСебестоимостиНУ1", "СубконтоОтнесенияСебестоимостиНУ2", "СубконтоОтнесенияСебестоимостиНУ3", 
	ДанныеОбъекта.СубконтоОтнесенияСебестоимостиНУ1, ДанныеОбъекта.СубконтоОтнесенияСебестоимостиНУ2, ДанныеОбъекта.СубконтоОтнесенияСебестоимостиНУ3));
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СчетОтнесенияСебестоимостиНУПриИзмененииНаСервере(ДанныеОбъекта)
	
	ПроцедурыБухгалтерскогоУчета.ПроверитьВладельцаСубконтоПодразделение(ДанныеОбъекта, 
	ДанныеОбъекта.Организация, 
	Новый Структура("НазваниеСубконтоБУ1, НазваниеСубконтоБУ2, НазваниеСубконтоБУ3, 
	|СубконтоБУ1, СубконтоБУ2, СубконтоБУ3",
	"СубконтоОтнесенияСебестоимостиНУ1", "СубконтоОтнесенияСебестоимостиНУ2", "СубконтоОтнесенияСебестоимостиНУ3", 
	ДанныеОбъекта.СубконтоОтнесенияСебестоимостиНУ1, ДанныеОбъекта.СубконтоОтнесенияСебестоимостиНУ2, ДанныеОбъекта.СубконтоОтнесенияСебестоимостиНУ3));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовкиИДоступностьСубконто(СчетУчета, ПоляФормы, ЗаголовкиПолей, СчетУчетаНУ = Неопределено)
	
	ДанныеСчета = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(СчетУчета);
	ПроцедурыБухгалтерскогоУчетаКлиентСервер.ПриВыбореСчета(СчетУчета, ЭтаФорма, ПоляФормы, ЗаголовкиПолей);
		
	СубконтоНоменклатура         = ПланыВидовХарактеристик.ВидыСубконтоТиповые.Номенклатура;
	СубконтоНоменклатурнаяГруппа = ПланыВидовХарактеристик.ВидыСубконтоТиповые.НоменклатурныеГруппы;
	
	Для Каждого ПолеФормы Из ПоляФормы Цикл
		
		ВидСубконто = ДанныеСчета["Вид" + ПолеФормы.Ключ];
		
		Если ВидСубконто = СубконтоНоменклатура ИЛИ ВидСубконто = СубконтоНоменклатурнаяГруппа Тогда
			ОбщегоНазначенияБККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, ПолеФормы.Значение, "Видимость", Ложь);
			ОбщегоНазначенияБККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Декорация" + ПолеФормы.Значение, "Видимость", Истина);
		Иначе
			ОбщегоНазначенияБККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Декорация" + ПолеФормы.Значение, "Видимость", Ложь);
		КонецЕсли;
		
	КонецЦикла;
	
	Если НЕ СчетУчетаНУ = Неопределено Тогда
		
		Для Каждого ПолеФормы Из ПоляФормы Цикл
			ПоляФормы.Вставить(ПолеФормы.Ключ, СтрЗаменить(ПолеФормы.Значение, "БУ", "НУ"));
		КонецЦикла;
		
		Для Каждого ЗаголовоеПоля Из ЗаголовкиПолей Цикл
			ЗаголовкиПолей.Вставить(ЗаголовоеПоля.Ключ, СтрЗаменить(ЗаголовоеПоля.Значение, "БУ", "НУ"));
		КонецЦикла;
		
		ДанныеСчета = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(СчетУчетаНУ);
		ПроцедурыБухгалтерскогоУчетаКлиентСервер.ПриВыбореСчета(СчетУчетаНУ, ЭтаФорма, ПоляФормы, ЗаголовкиПолей);
		
		Для Каждого ПолеФормы Из ПоляФормы Цикл
			
			ВидСубконто = ДанныеСчета["Вид" + ПолеФормы.Ключ];
			
			Если ВидСубконто = СубконтоНоменклатура ИЛИ ВидСубконто = СубконтоНоменклатурнаяГруппа Тогда
				ОбщегоНазначенияБККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, ПолеФормы.Значение, "Видимость", Ложь);
				ОбщегоНазначенияБККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Декорация" + ПолеФормы.Значение, "Видимость", Истина);
			Иначе
				ОбщегоНазначенияБККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Декорация" + ПолеФормы.Значение, "Видимость", Ложь);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПараметрыВыбораПолейСубконто(Форма, Суффикс, ИмяСчета, ИмяТабличнойЧасти = "", ЗаменаСубконтоНУ = Ложь)
	
	Если Не Форма.ПоказыватьВДокументахСчетаУчета Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяТабличнойЧасти = "" Тогда
		// Обработка полей Субконто для счетов СчетОтнесенияСебестоимости
		ПараметрыДокумента = СписокПараметровВыбораСубконто(Форма, Форма, "Субконто" + Суффикс + "%Индекс%", ИмяСчета);
		ПроцедурыБухгалтерскогоУчетаКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(Форма, Форма, "Субконто" + Суффикс + "%Индекс%", "Субконто" + Суффикс + "%Индекс%", ПараметрыДокумента, ЗаменаСубконтоНУ);	
		
	Иначе
		// Обработка полей Субконто в ТЧ "Услуги"
		Если Форма.Элементы[ИмяТабличнойЧасти].ТекущаяСтрока <> Неопределено Тогда
			СтрокаТаблицы = Форма[ИмяТабличнойЧасти].НайтиПоИдентификатору(Форма.Элементы[ИмяТабличнойЧасти].ТекущаяСтрока);
			
			ПараметрыДокумента = СписокПараметровВыбораСубконто(Форма, СтрокаТаблицы, "Субконто" + Суффикс + "%Индекс%", ИмяСчета);
			ПроцедурыБухгалтерскогоУчетаКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(Форма, СтрокаТаблицы, "Субконто" + Суффикс + "%Индекс%", ИмяТабличнойЧасти + "Субконто" + Суффикс + "%Индекс%", ПараметрыДокумента,ЗаменаСубконтоНУ);	
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СписокПараметровВыбораСубконто(ДанныеОбъекта, ПараметрыОбъекта, ШаблонИмяПоляОбъекта, ИмяСчета)
	
	СписокПараметров = Новый Структура;
	Для Индекс = 1 По 3 Цикл
		ИмяПоля = СтрЗаменить(ШаблонИмяПоляОбъекта, "%Индекс%", Индекс);
		Если ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Контрагенты") Тогда
			СписокПараметров.Вставить("Контрагент", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
			СписокПараметров.Вставить("ДоговорКонтрагента", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Номенклатура") Тогда
			СписокПараметров.Вставить("Номенклатура", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Склады") Тогда
			СписокПараметров.Вставить("Склад", ПараметрыОбъекта[ИмяПоля]);
		КонецЕсли;
	КонецЦикла;
	СписокПараметров.Вставить("СчетУчета", 				  ПараметрыОбъекта[ИмяСчета]);	
	СписокПараметров.Вставить("Организация", 			  ДанныеОбъекта.Организация);
	СписокПараметров.Вставить("СтруктурноеПодразделение", ДанныеОбъекта.СтруктурноеПодразделение);
	СписокПараметров.Вставить("ВыбиратьПодразделенияОрганизации", Истина);

	Возврат СписокПараметров; 

КонецФункции

&НаКлиенте
Процедура СубконтоНачалоВыбора(Элемент, ИмяЭлементаСубконто, ИндексСубконто, ИмяЭлементаСчета, СтрокаТаблицы, СтандартнаяОбработка)	
	
	ПараметрыДокумента = СписокПараметровВыбораСубконтоПрочее(ЭтотОбъект, СтрокаТаблицы, ИмяЭлементаСубконто + "%Индекс%", ИмяЭлементаСчета);
	ПроцедурыБухгалтерскогоУчетаКлиент.НачалоВыбораЗначенияСубконто(ЭтотОбъект, Элемент, ИндексСубконто, СтандартнаяОбработка, ПараметрыДокумента);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СписокПараметровВыбораСубконтоПрочее(ДанныеОбъекта, ПараметрыОбъекта, ШаблонИмяПоляОбъекта, ИмяСчета)
	
	СписокПараметров = Новый Структура;
	Для Индекс = 1 По 3 Цикл
		ИмяПоля = СтрЗаменить(ШаблонИмяПоляОбъекта, "%Индекс%", Индекс);
		Если ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Контрагенты") Тогда
			СписокПараметров.Вставить("Контрагент", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
			СписокПараметров.Вставить("ДоговорКонтрагента", ПараметрыОбъекта[ИмяПоля]);
		КонецЕсли;
	КонецЦикла;
	СписокПараметров.Вставить("СчетУчета", 				  ПараметрыОбъекта[ИмяСчета]);	
	СписокПараметров.Вставить("Организация", 			  ДанныеОбъекта.Организация);
	СписокПараметров.Вставить("СтруктурноеПодразделение", ДанныеОбъекта.СтруктурноеПодразделениеОтправитель);
	СписокПараметров.Вставить("ВыбиратьПодразделенияОрганизации", Истина);
	
	Возврат СписокПараметров; 
	
КонецФункции

&НаКлиенте
Процедура СообщитьОПустомСчете()
	
	Если Элементы.СчетУчетаРасчетовСКонтрагентом.Видимость И Не ЗначениеЗаполнено(СчетУчетаРасчетовСКонтрагентом) Тогда
		Текст = НСтр("ru='Поле ""Счет учета расчетов с контрагентом"" не заполнено.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(Текст,,Элементы.СчетУчетаРасчетовСКонтрагентом, "СчетУчетаРасчетовСКонтрагентом", Истина);
	КонецЕсли;
	
	Если Элементы.ГруппаРазницыСтоимостиТоваров.Видимость И Не ЗначениеЗаполнено(СчетОтнесенияСебестоимостиБУ) Тогда
		Текст = НСтр("ru='Поле ""Счет списания разницы в себестоимости (БУ):"" не заполнено.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(Текст,,Элементы.СчетОтнесенияСебестоимостиБУ, "СчетОтнесенияСебестоимостиБУ", Истина);
	КонецЕсли;
	
	Если Элементы.ГруппаРазницыСтоимостиТоваров.Видимость И Не ЗначениеЗаполнено(СчетОтнесенияСебестоимостиНУ) Тогда
		Текст = НСтр("ru='Поле ""Счет списания разницы в себестоимости (НУ):"" не заполнено.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(Текст,,Элементы.СчетОтнесенияСебестоимостиНУ, "СчетОтнесенияСебестоимостиНУ", Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполнениеПередЗакрытием()
	
	Если Элементы.СчетУчетаРасчетовСКонтрагентом.Видимость И Не ЗначениеЗаполнено(СчетУчетаРасчетовСКонтрагентом) Тогда
		Возврат Истина;
	ИначеЕсли Элементы.ГруппаРазницыСтоимостиТоваров.Видимость И Не ЗначениеЗаполнено(СчетОтнесенияСебестоимостиБУ) Тогда
		Возврат Истина;
	ИначеЕсли Элементы.ГруппаРазницыСтоимостиТоваров.Видимость И Не ЗначениеЗаполнено(СчетОтнесенияСебестоимостиНУ) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

