﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
        КодыСтрок.Отбор, 
        "ВидОперации", 
        Объект.Ссылка, 
        ВидСравненияКомпоновкиДанных.Равно, 
        "Вид поступления ТМЗ", 
        Истина ,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный
    );
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ФормаВыбораИзКлассификатора") Тогда
		
		Если ВРег(ИсточникВыбора.ИмяМакета) = ВРег("КодыВидовОблагаемогоОборотаНДС") Тогда
			
			Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда 
				Объект.КодВидаОблагаемогоОборота = ВыбранноеЗначение;
			Иначе 
				Объект.КодВидаОблагаемогоОборота = ВыбранноеЗначение.КодСтроки;
			КонецЕсли;
				
		КонецЕсли;
		
		Модифицированность = Истина;

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УстановитьОтборВОтражениеВДекларацииПоНДС()

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ  ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура КодыСтрокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
						
		ТекстВопроса = НСтр("ru = 'Перед редактированием данных по Декларации необходимо записать элемент.
		|Записать?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаЗаписатьВФорме", ЭтотОбъект, Параметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
		Отказ = Истина;

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КодыСтрокПриАктивизацииСтроки(Элемент)
	
	КодСтроки = "";
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		КодСтроки = Строка(Элемент.ТекущиеДанные.КодСтроки);
	КонецЕсли;
	
	ОбновитьПредставлениеЭлемента("КодСтрокиДекларации",КодСтроки);

КонецПроцедуры

&НаКлиенте
Процедура КодВидаОблагаемогоОборотаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
    ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяМакета"  , "КодыВидовОблагаемогоОборотаНДС");
	ПараметрыФормы.Вставить("ИмяСекции"  , "Классификатор");
	ПараметрыФормы.Вставить("ПолучатьПолныеДанные", Истина);
	ПараметрыФормы.Вставить("ТекущийКодСтроки", Объект.КодВидаОблагаемогоОборота);
	ПараметрыФормы.Вставить("ЯзыкМакета", ОбщегоНазначенияКлиент.КодОсновногоЯзыка());
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораИзКлассификатора", ПараметрыФормы, ЭтаФорма, Истина);
		
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	Если НЕ ЗначениеЗаполнено(Объект.ПолноеНаименование) Тогда
		Объект.ПолноеНаименование = Объект.Наименование;
	КонецЕсли;
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПослеЗакрытияВопросаЗаписатьВФорме(Результат, Параметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		// записываем объет
		Если Записать() Тогда
			УстановитьОтборВОтражениеВДекларацииПоНДС();        
			ЗначенияЗаполнения = Новый Структура("ВидОперации", Объект.Ссылка);
			ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
			ОткрытьФорму("РегистрСведений.КодыСтрокДекларацииПоНДСКЗачету.ФормаЗаписи", ПараметрыФормы, ЭтаФорма);
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Процедура ОбновитьПредставлениеЭлемента(ИмяОбновляемогоЭлемента, КодСтроки)
	
	Если ИмяОбновляемогоЭлемента = "КодСтрокиДекларации" Тогда
				
		Если ПустаяСтрока(СтрЗаменить(КодСтроки, ".", "")) Тогда
			Элементы.ДекорацияРасшифровкаКодСтроки.Заголовок = НСтр("ru ='<не указано>'");
		Иначе
			
			Если мМакетКодовСтрок.ВысотаТаблицы = 0 Тогда
				
				мМакетКодовСтрок = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_КодыСтрокНалоговыхДеклараций");
				мМакетКодовСтрок.КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
				
			КонецЕсли;
			
			мОбластьСтрок = мМакетКодовСтрок.Области.Найти("НДС_Зачет");
			
			
			КодОсновнойСтроки = Лев(КодСтроки,10);
			ИмяОбластиМакета = "НДС_Зачет_" + СтрЗаменить(КодОсновнойСтроки, ".", "_");
			ОбластьДополнительныхСтрок = мМакетКодовСтрок.Области.Найти(ИмяОбластиМакета);
			
			Если ОбластьДополнительныхСтрок = Неопределено Тогда
				НаименованиеСтроки = РегламентированнаяОтчетность.ПолучитьНаименованиеСтрокиКлассификатораПоКоду(мМакетКодовСтрок, мОбластьСтрок, КодСтроки);
			Иначе	
				КодДополнительнойСтроки = Прав(КодСтроки, СтрДлина(КодСтроки) - 11);
				НаименованиеСтроки = РегламентированнаяОтчетность.ПолучитьНаименованиеСтрокиКлассификатораПоКоду(мМакетКодовСтрок, ОбластьДополнительныхСтрок, КодДополнительнойСтроки);
			КонецЕсли;
			
			Если ПустаяСтрока(НаименованиеСтроки) Тогда
				Элементы.ДекорацияРасшифровкаКодСтроки.Заголовок = СтрШаблон(НСтр("ru ='строка с кодом %1 не найдена.'"), СокрЛП(КодСтроки));
			Иначе
				Элементы.ДекорацияРасшифровкаКодСтроки.Заголовок = НаименованиеСтроки;
			КонецЕсли;
			
		КонецЕсли;
	
	КонецЕсли;
	       
КонецПроцедуры // ОбновитьПредставлениеЭлемента()


&НаКлиенте
Процедура УстановитьОтборВОтражениеВДекларацииПоНДС()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
        КодыСтрок.Отбор, 
        "ВидОперации", 
        Объект.Ссылка, 
        ВидСравненияКомпоновкиДанных.Равно, 
        "Вид поступления ТМЗ", 
        Истина
    )	
КонецПроцедуры
