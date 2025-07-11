﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОбщегоНазначенияБКВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СПИСОК

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБККлиентСервер.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦ ФОРМЫ

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
     ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
     ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
 
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
     ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
     ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Функция ПечатьЖурналДоверенностей(ОписаниеКоманды) Экспорт
	
	УсловиеТекст = "";
	СведенияОбОрганизации = Неопределено;
	
	НастройкиПользователя = Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;
	
	Для Каждого ЭлементНастройки Из НастройкиПользователя Цикл
		Если ТипЗнч(ЭлементНастройки) = Тип("ЭлементОтбораКомпоновкиДанных") И ЭлементНастройки.Использование Тогда
			Если ТипЗнч(ЭлементНастройки.ПравоеЗначение) = Тип("СправочникСсылка.Организации") и ЗначениеЗаполнено(ЭлементНастройки.ПравоеЗначение) Тогда
				СведенияОбОрганизации = ЭлементНастройки.ПравоеЗначение;
				Если ЭлементНастройки.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно 
					ИЛИ ЭлементНастройки.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
					УсловиеТекст = "Доверенность.Организация = &Организация";
				ИначеЕсли ЭлементНастройки.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно Тогда
					УсловиеТекст = "Доверенность.Организация <> &Организация";
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ОписаниеКоманды.ДополнительныеПараметры.Вставить("УсловиеОтбораПоОрганизации", Новый Структура("ТекстУсловия, ЗначениеПараметра", УсловиеТекст, СведенияОбОрганизации));
	
	ФормаСписка    = ОписаниеКоманды.Форма;
	ИнтервалСписка = ФормаСписка.Элементы.Список.Период;
	Если ЗначениеЗаполнено(ИнтервалСписка) Тогда
		ОписаниеКоманды.ДополнительныеПараметры.Вставить("Период", ИнтервалСписка);
	КонецЕсли;
	
	ОписаниеКоманды.Удалить("Форма");
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(ОписаниеКоманды.МенеджерПечати, ОписаниеКоманды.Идентификатор,
		ОписаниеКоманды.ОбъектыПечати, ЭтотОбъект, ОписаниеКоманды);
	
КонецФункции
