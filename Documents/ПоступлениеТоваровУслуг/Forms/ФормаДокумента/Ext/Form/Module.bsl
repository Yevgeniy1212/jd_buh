﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(Основание) И ВидОперацииПриОткрытии = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Услуги") Тогда
		ОткрытьДокументВида(ВидОперацииПриОткрытии);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПодготовитьФормуНаСервере();
	
	Если ЗначениеЗаполнено(Основание) И ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		Если Основание.ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Услуги Тогда
			ВидОперацииПриОткрытии = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Услуги;
		Иначе
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Нет данных для заполнения. Ввод на основании поступления ТМЗ и услуг доступен только для документов с видом операции ""%1""'"), 
																						Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Услуги);
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	
	СтрокаТаблицы = Элементы.СписокВидовОпераций.ТекущиеДанные;
	
	Если НЕ СтрокаТаблицы = Неопределено Тогда
		
		ОткрытьДокументВида(СтрокаТаблицы.Значение);
		
	КонецЕсли; 
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Если Параметры.Свойство("ЗначениеКопирования") Тогда
		ЗначениеКопирования = Параметры.ЗначениеКопирования;
	КонецЕсли;
	Если Параметры.Свойство("ЗначенияЗаполнения") Тогда
		ЗначенияЗаполнения  = Параметры.ЗначенияЗаполнения;
	КонецЕсли;
	Если Параметры.Свойство("Основание") Тогда
		Основание           = Параметры.Основание;
	КонецЕсли;
	Если Параметры.Свойство("Ключ") Тогда
		Ключ           		= Параметры.Ключ;
	КонецЕсли;
	Если Параметры.Свойство("ИзменитьВидОперации") Тогда
		ИзменитьВидОперации = Истина;
	КонецЕсли;
	Элементы.НадписьПредупреждение.Видимость = ИзменитьВидОперации;
	
	ФормыДокумента   = Новый ФиксированноеСоответствие(
		Документы.ПоступлениеТоваровУслуг.ПолучитьСоответствиеВидовОперацийФормам());
		
	ВидыОпераций = ПолучитьСписокВидовОпераций(Основание);
	Для Каждого ВидОперации Из ВидыОпераций Цикл
		НоваяОперация = СписокВидовОпераций.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяОперация, ВидОперации);
	КонецЦикла;
	
	Если Параметры.Свойство("ВидОперации") Тогда
		ВидОперацииПриОткрытии = Параметры.ВидОперации;
		ВыделенныйЭлементСписка = СписокВидовОпераций.НайтиПоЗначению(ВидОперацииПриОткрытии);
		Если ВыделенныйЭлементСписка <> Неопределено Тогда
			Элементы.СписокВидовОпераций.ТекущаяСтрока = ВыделенныйЭлементСписка.ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокВидовОпераций(Основание = Неопределено)

	СписокВидовОпераций = Новый СписокЗначений;
	
	ВсеВидыОпераций = Перечисления.ВидыОперацийПоступлениеТоваровУслуг;
	
	СписокВидовОпераций.Добавить(ВсеВидыОпераций.Товары, НСтр("ru = 'Товары (накладная)'"));
	Если ТипЗнч(Основание) <> Тип("ДокументСсылка.Доверенность") Тогда
		СписокВидовОпераций.Добавить(ВсеВидыОпераций.Услуги, НСтр("ru = 'Услуги (акт)'"));
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ВедетсяУчетОсновныхСредств") 
		И ТипЗнч(Основание) <> Тип("ДокументСсылка.Доверенность") Тогда
		СписокВидовОпераций.Добавить(ВсеВидыОпераций.ОсновныеСредства, ВсеВидыОпераций.ОсновныеСредства);
	КонецЕсли;
	СписокВидовОпераций.Добавить(ВсеВидыОпераций.ПокупкаКомисия, НСтр("ru = 'Товары, ОС, Услуги'"));
	Если ПолучитьФункциональнуюОпцию("ВедетсяПроизводственнаяДеятельность") Тогда
		СписокВидовОпераций.Добавить(ВсеВидыОпераций.ВПереработку, НСтр("ru = 'Материалы в переработку'"));
	КонецЕсли;
	СписокВидовОпераций.Добавить(ВсеВидыОпераций.Импорт, НСтр("ru = 'Импорт (Товары, ОС)'"));
	Если ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями") Тогда
		СписокВидовОпераций.Добавить(ВсеВидыОпераций.ОтСтруктурногоПодразделения, ВсеВидыОпераций.ОтСтруктурногоПодразделения);
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетНДСЗаНерезидента") Тогда
		СписокВидовОпераций.Добавить(ВсеВидыОпераций.ПоступлениеОтНерезидента, ВсеВидыОпераций.ПоступлениеОтНерезидента);
	КонецЕсли;
	
	Возврат СписокВидовОпераций;

КонецФункции

&НаКлиенте
Процедура СписокВидовОперацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТаблицы = СписокВидовОпераций.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	ОткрытьДокументВида(СтрокаТаблицы.Значение);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокументВида(ВыбранныйВидОперации)
	
	Если ТипЗнч(ЗначенияЗаполнения) <> Тип("Структура") Тогда
		ЗначенияЗаполнения = Новый Структура();
	КонецЕсли;

	ЗначенияЗаполнения.Вставить("ВидОперации", ВыбранныйВидОперации);
	Если ЗначениеЗаполнено(Основание) Тогда
		ЗначенияЗаполнения.Вставить("Основание", Основание);
		ЗначенияЗаполнения.Вставить("ВводНаОсновании", Истина);
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Ключ",                Ключ);
	Если ЗначениеЗаполнено(ЗначениеКопирования) Тогда
		СтруктураПараметров.Вставить("ЗначениеКопирования", ЗначениеКопирования);
	КонецЕсли;
	СтруктураПараметров.Вставить("ЗначенияЗаполнения",  ЗначенияЗаполнения);
	
	Если ИзменитьВидОперации И ВыбранныйВидОперации <> ВидОперацииПриОткрытии Тогда
		СтруктураПараметров.Вставить("ИзменитьВидОперации", ИзменитьВидОперации);
	КонецЕсли;
	
	Модифицированность = Ложь;
	Закрыть();
	
	Если ВыбранныйВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Товары") Тогда
		КлючеваяОперация = "СозданиеФормыПоступлениеТоваровУслугТовары";
	ИначеЕсли ВыбранныйВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Услуги") Тогда
		КлючеваяОперация = "СозданиеФормыПоступлениеТоваровУслугУслуги";
	ИначеЕсли ВыбранныйВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.ОсновныеСредства") Тогда
		КлючеваяОперация = "СозданиеФормыПоступлениеТоваровУслугОсновныеСредства";
	Иначе
		КлючеваяОперация = "СозданиеФормыПоступлениеТоваровУслугОбщая";
	КонецЕсли;
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.Форма." + ФормыДокумента[ВыбранныйВидОперации], СтруктураПараметров, ВладелецФормы);
	
КонецПроцедуры

