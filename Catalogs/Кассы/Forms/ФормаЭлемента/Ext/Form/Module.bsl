﻿&НаКлиенте
Перем ОрганизацияДоИзменения;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ПрочитатьОтветственноеЛицо();
	
	Если ЗначениеЗаполнено(Объект.Владелец) Тогда
		ОрганизацияДоИзменения = Объект.Владелец;
	Иначе
		ОрганизацияДоИзменения = Справочники.Организации.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "Запись_ОтветственныеЛица" 
	   И (Источник = Объект.Ссылка ИЛИ (ТипЗнч(Источник) = Тип("СправочникСсылка.Кассы") И Источник.Пустая())) Тогда
		ИмяОбновляемогоЭлемента = Параметр.ИмяЭлемента;

		Если ИмяОбновляемогоЭлемента = "ОтветственноеЛицо" Тогда
			ПрочитатьОтветственноеЛицо();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	ЗаписатьОтветственноеЛицо();
	ПрочитатьОтветственноеЛицо();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если Объект.Владелец <> ОрганизацияДоИзменения Тогда
		
		СтруктураПараметров = Новый Структура();
		СтруктураПараметров.Вставить("КонтрагентОрганизация",  Объект.Владелец);
		СтруктураПараметров.Вставить("Касса", Объект.Ссылка);
		
		Оповестить("Запись_ОрганизацияИзменилась_Касса", СтруктураПараметров, ЭтотОбъект);
	КонецЕсли;
	
	Оповестить("Запись_Касса", Объект.Ссылка, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура История(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Режим = РежимДиалогаВопрос.ДаНет;	
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОЗаписиЭлемента", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Перед просмотром истории необходимо записать элемент. Записать?'"), Режим, 0);
		
	Иначе
		
		ПослеЗакрытияВопросаОЗаписиЭлемента(КодВозвратаДиалога.Пропустить, Неопределено);
		
	КонецЕсли;
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПрочитатьОтветственноеЛицо()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("Ссылка", 	 Объект.Ссылка);
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ФизическоеЛицо
	               |ИЗ
	               |	РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(&ТекущаяДата, СтруктурнаяЕдиница = &Ссылка И ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.Кассир)) КАК ОтветственныеЛицаОрганизацийСрезПоследних";
	
	Результат = Запрос.Выполнить();
	СрезПоследних = Результат.Выгрузить();
	
	Если СрезПоследних.Количество() < 1 Тогда
		ОтветственноеЛицо = Неопределено;
	Иначе
		ОтветственноеЛицо = СрезПоследних[0].ФизическоеЛицо;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаОЗаписиЭлемента(Результат, Параметры) Экспорт

	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;

	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Если НЕ ПроверитьЗаполнение() Тогда
			Возврат
		КонецЕсли;
		
		Попытка
			Записать();
		Исключение
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не удалось записать элемент!'"));
			Возврат;
		КонецПопытки;
		
	КонецЕсли;
	
	Отбор = Новый Структура("СтруктурнаяЕдиница", Объект.Ссылка);
	ОткрытьФорму(
		"РегистрСведений.ОтветственныеЛицаОрганизаций.ФормаСписка", 
		Новый Структура("Отбор", Отбор), 
		ЭтотОбъект, 
		УникальныйИдентификатор, 
		,
		,
		,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаСервере
Процедура ЗаписатьОтветственноеЛицо()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", Объект.Ссылка);
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СтруктурнаяЕдиница,
		|	ОтветственноеЛицо,
		|	ФизическоеЛицо,
		|	Должность
		|ИЗ
		|	РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(&Дата, СтруктурнаяЕдиница = &СтруктурнаяЕдиница) КАК ОтветственныеЛицаОрганизацийСрезПоследних";
	
	СрезПоследних = Запрос.Выполнить().Выгрузить();

	Если СрезПоследних.Количество() < 1 Тогда
		Если НЕ ЗначениеЗаполнено(ОтветственноеЛицо) Тогда
			Возврат;
		Иначе
			ПериодЗаписи = '19000101';
		КонецЕсли;
	Иначе
		Если (ОтветственноеЛицо = СрезПоследних[0].ФизическоеЛицо) ИЛИ НЕ ЗначениеЗаполнено(ОтветственноеЛицо) Тогда
			Возврат;
		Иначе
			ПериодЗаписи = ТекущаяДатаСеанса();
		КонецЕсли;
	КонецЕсли;

	НаборЗаписей = РегистрыСведений.ОтветственныеЛицаОрганизаций.СоздатьНаборЗаписей();
	НаборЗаписей.ДополнительныеСвойства.Вставить("ПропуститьПроверкуЗапретаИзменения");
	НаборЗаписей.Отбор.СтруктурнаяЕдиница.Установить(Объект.Ссылка);
	НаборЗаписей.Прочитать();

	Запись = НаборЗаписей.Добавить();

	Запись.Период             = ПериодЗаписи;
	Запись.СтруктурнаяЕдиница = Объект.Ссылка;
	Запись.ОтветственноеЛицо  = Перечисления.ОтветственныеЛицаОрганизаций.Кассир;
	Запись.ФизическоеЛицо     = ОтветственноеЛицо;

	Попытка
		НаборЗаписей.Записать();
	Исключение
		ТекстСообщения = НСтр("ru = 'Не удалось записать данные об ответственном лице: %1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, 
			ОписаниеОшибки());
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	КонецПопытки;

КонецПроцедуры
