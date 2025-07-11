﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Параметры.Отбор.Свойство("СпособВыплаты") И Параметры.Отбор.СпособВыплаты = Перечисления.СпособыВыплатыЗарплаты.ЧерезКассу Тогда
		
		ОтборПоФЛ = Параметры.Отбор.Свойство("ФизЛицо");

		Запрос = Новый Запрос;
		
		Если Параметры.Отбор.Свойство("СтруктурноеПодразделение") Тогда
			УсловиеСтруктурноеПодразделение = " И ЗарплатаКВыплатеОрганизации." + ?(ОтборПоФЛ, "Ссылка.", "") + "СтруктурноеПодразделение = &СтруктурноеПодразделение";
			Запрос.УстановитьПараметр("СтруктурноеПодразделение", Параметры.Отбор.СтруктурноеПодразделение);
		Иначе
			УсловиеСтруктурноеПодразделение = "";
		КонецЕсли;
		
		Если ОтборПоФЛ Тогда
			Запрос.УстановитьПараметр("парамФизЛицо", Параметры.Отбор.ФизЛицо);
		Иначе
			Запрос.УстановитьПараметр("парамФизЛицо", Справочники.Контрагенты.ПустаяСсылка());
		КонецЕсли;
		
		Запрос.Текст = "ВЫБРАТЬ
		               |	ВедомостьПрочихДоходовВыплаты.Ссылка КАК Ссылка
		               |ИЗ
		               |	Документ.ВедомостьПрочихДоходов.Выплаты КАК ВедомостьПрочихДоходовВыплаты
		               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВедомостьПрочихДоходов КАК ВедомостьПрочихДоходов
		               |		ПО ВедомостьПрочихДоходовВыплаты.Ссылка = ВедомостьПрочихДоходов.Ссылка
		               |ГДЕ
		               |	ВедомостьПрочихДоходовВыплаты.Физлицо = &парамФизЛицо
		               |	И ВедомостьПрочихДоходов.Организация = &Организация
		               |	И ВедомостьПрочихДоходов.СпособВыплаты = &СпособВыплаты";
		
		Запрос.УстановитьПараметр("Организация",   Параметры.Отбор.Организация);
		Запрос.УстановитьПараметр("СпособВыплаты", Перечисления.СпособыВыплатыЗарплаты.ЧерезКассу);
		
		СписокОтбора = Новый СписокЗначений;
		СписокОтбора.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
		
		Параметры.Отбор.Вставить("Ссылка", СписокОтбора);
		
	КонецЕсли;
	
	Если Параметры.Свойство("ПараметрыОтбораСписка") Тогда
		ПараметрыОтбораСписка = Параметры.ПараметрыОтбораСписка;
		Если ПараметрыОтбораСписка.Свойство("ОбработкаВыплатаЗарплатыРКО") Тогда
			ОткрытИзПомощника = Истина;
		КонецЕсли; 
	КонецЕсли; 
	
	Если ОткрытИзПомощника Тогда
		
		Если ПараметрыОтбораСписка.Свойство("Организация") Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ЭтаФорма.Список, "Организация", ПараметрыОтбораСписка.Организация, ВидСравненияКомпоновкиДанных.Равно,, Истина, 
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
		КонецЕсли; 
		
	Иначе
		ОбщегоНазначенияБКВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СПИСОК

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	Если ОткрытИзПомощника Тогда
		
		ОтборОрганизация = Неопределено;
		Отборы = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(Список.КомпоновщикНастроек.Настройки.Отбор, "Организация");
		
		Если Отборы.Количество() > 0 Тогда
			ОтборОрганизация = Отборы[0];
		КонецЕсли;
		
		Если ОтборОрганизация = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Для Каждого ЭлементНастроек Из Настройки.Элементы Цикл
			Если ТипЗнч(ЭлементНастроек) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
				Если ЭлементНастроек.ИдентификаторПользовательскойНастройки = "Организация" И ОтборОрганизация <> Неопределено Тогда
					ЭлементНастроек.Использование  = ОтборОрганизация.Использование;
					ЭлементНастроек.ВидСравнения   = ОтборОрганизация.ВидСравнения;
					ЭлементНастроек.ПравоеЗначение = ОтборОрганизация.ПравоеЗначение;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
			
	Иначе
		ОбщегоНазначенияБККлиентСервер.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	КонецЕсли;

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

