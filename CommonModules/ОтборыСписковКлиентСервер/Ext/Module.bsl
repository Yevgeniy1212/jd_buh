﻿////////////////////////////////////////////////////////////////////////////////
// ОтборыСписковКлиентСервер: 
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Процедура УстановитьЭлементОтбораКоллекции(КоллекцияЭлементов, ИмяПоля, ПравоеЗначение, ВидСравнения = Неопределено)
	
	ЭлементОтбора = КоллекцияЭлементов.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных(ИмяПоля);
	ЭлементОтбора.ВидСравнения     = ?(ВидСравнения = Неопределено, ВидСравненияКомпоновкиДанных.Равно, ВидСравнения);
	ЭлементОтбора.Использование    = Истина;
	ЭлементОтбора.ПравоеЗначение   = ПравоеЗначение;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
КонецПроцедуры // УстановитьЭлементОтбораКоллекции()

Процедура ИзменитьЭлементОтбораГруппыСписка(Группа, ИмяПоля, ПравоеЗначение = Неопределено, Установить = Ложь, ВидСравнения = Неопределено) Экспорт
	
	УдалитьЭлементОтбораКоллекции(Группа.Элементы, ИмяПоля);
	
	Если Установить Тогда
		УстановитьЭлементОтбораКоллекции(Группа.Элементы, ИмяПоля, ПравоеЗначение, ВидСравнения);
	КонецЕсли;
	
КонецПроцедуры // ИзменитьЭлементОтбораГруппыСписка()

Функция НайтиЭлементОтбораПоПредставлению(КоллекцияЭлементов, Представление, ВидПоиска = 0) Экспорт
	
	ВозвращаемоеЗначение = Неопределено;
	
	Для каждого ЭлементОтбора Из КоллекцияЭлементов Цикл
		Если ВидПоиска = 0 Тогда
			Если ЭлементОтбора.Представление = Представление Тогда
				ВозвращаемоеЗначение = ЭлементОтбора;
				Прервать;
			КонецЕсли;
		ИначеЕсли ВидПоиска = 1 Тогда
			Если Найти(ЭлементОтбора.Представление, Представление) = 1 Тогда
				ВозвращаемоеЗначение = ЭлементОтбора;
				Прервать;
			КонецЕсли;
		ИначеЕсли ВидПоиска = 2 Тогда
			Если Найти(ЭлементОтбора.Представление, Представление) > 0 Тогда
				ВозвращаемоеЗначение = ЭлементОтбора;
				Прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение
	
КонецФункции // НайтиЭлементОтбораПоПредставлению()

Функция СоздатьГруппуЭлементовОтбора(КоллекцияЭлементов, Представление, ТипГруппы) Экспорт
	
	ГруппаЭлементовОтбора = НайтиЭлементОтбораПоПредставлению(КоллекцияЭлементов, Представление);
	Если ГруппаЭлементовОтбора = Неопределено Тогда
		ГруппаЭлементовОтбора = КоллекцияЭлементов.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	Иначе
		ГруппаЭлементовОтбора.Элементы.Очистить();
	КонецЕсли;
	
	ГруппаЭлементовОтбора.Представление    = Представление;
	ГруппаЭлементовОтбора.Применение       = ТипПримененияОтбораКомпоновкиДанных.Элементы;
	ГруппаЭлементовОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ГруппаЭлементовОтбора.ТипГруппы        = ТипГруппы;
	ГруппаЭлементовОтбора.Использование    = Истина;
	
	Возврат ГруппаЭлементовОтбора;
	
КонецФункции

//Удаляет элемент отбора динамического списка
//
//Параметры:
//Список  - обрабатываемый динамический список,
//ИмяПоля - имя поля компоновки, отбор по которому нужно удалить
//
Процедура УдалитьЭлементОтбораСписка(Список, ИмяПоля) Экспорт
	
	ЭлементыДляУдаления = Новый Массив;
	
	ЭлементыОтбора = Список.Отбор.Элементы;
	ПолеКомпоновки = Новый ПолеКомпоновкиДанных(ИмяПоля);
	Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных")
			И ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновки Тогда
			ЭлементыДляУдаления.Добавить(ЭлементОтбора);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ЭлементОтбораДляУдаления Из ЭлементыДляУдаления Цикл
		ЭлементыОтбора.Удалить(ЭлементОтбораДляУдаления);
	КонецЦикла;
	
КонецПроцедуры // УдалитьЭлементОтбораСписка()

//Устанавливает элемент отбор динамического списка
//
//Параметры:
//Список			- обрабатываемый динамический список,
//ИмяПоля			- имя поля компоновки, отбор по которому нужно установить,
//ВидСравнения		- вид сравнения отбора, по умолчанию - Равно,
//ПравоеЗначение 	- значение отбора
//
Процедура УстановитьЭлементОтбораСписка(Список, ИмяПоля, ПравоеЗначение, ВидСравнения = Неопределено, Представление = "") Экспорт
	
	ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ИмяПоля);	
	ЭлементОтбора.ВидСравнения   = ?(ВидСравнения = Неопределено, ВидСравненияКомпоновкиДанных.Равно, ВидСравнения);
	ЭлементОтбора.Использование  = Истина;
	ЭлементОтбора.ПравоеЗначение = ПравоеЗначение;
	ЭлементОтбора.Представление  = Представление;
	
КонецПроцедуры // УстановитьЭлементОтбораСписка()

//Изменяет элемент отбора динамического списка
//
//Параметры:
//Список         - обрабатываемый динамический список,
//ИмяПоля        - имя поля компоновки, отбор по которому нужно установить,
//ВидСравнения   - вид сравнения отбора, по умолчанию - Равно,
//ПравоеЗначение - значение отбора,
//Установить     - признак необходимости установить отбор
//
Процедура ИзменитьЭлементОтбораСписка(Список, ИмяПоля, ПравоеЗначение = Неопределено, Установить = Ложь, ВидСравнения = Неопределено) Экспорт
	
	УдалитьЭлементОтбораСписка(Список, ИмяПоля);
	
	Если Установить Тогда
		УстановитьЭлементОтбораСписка(Список, ИмяПоля, ПравоеЗначение, ВидСравнения);
	КонецЕсли;
	
КонецПроцедуры // ИзменитьЭлементОтбораСписка()

// Устанавливает или изменяет "быстрый" отбор динамического списка (по значениям отбора, указанным в реквизитах формы)
//
// Параметры:
// Форма - ФормаКлиентскогоПриложения - форма, у которой есть реквизит динамический список с именем Список
// ИмяПоля - Строка - имя отбора, у формы должны быть реквизиты с именами Отбор<ИмяПоля> и Отбор<ИмяПоля>Использование
//
Процедура УстановитьБыстрыйОтбор(Форма, ИмяПоля, ВидСравнения = Неопределено) Экспорт
	
	ПравоеЗначение = Форма["Отбор" + ИмяПоля];
	Использование  = Форма["Отбор" + ИмяПоля + "Использование"];
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
		Форма.Список.КомпоновщикНастроек.Настройки.Отбор, 
		ИмяПоля);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Форма.Список.КомпоновщикНастроек.Настройки.Отбор,
		ИмяПоля,
		ПравоеЗначение,
		ВидСравнения,
		,
		Использование);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура УдалитьЭлементОтбораКоллекции(КоллекцияЭлементов, ИмяПоля)
	
	ПолеКомпоновки = Новый ПолеКомпоновкиДанных(ИмяПоля);
	Для Каждого ЭлементОтбора Из КоллекцияЭлементов Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных")
			И ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновки Тогда
			КоллекцияЭлементов.Удалить(ЭлементОтбора);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // УдалитьЭлементОтбораКоллекции()

