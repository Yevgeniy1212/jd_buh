﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияБКВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ОбщегоНазначенияБК.ФормаСпискаПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБККлиентСервер.ВосстановитьОтборСписка(Список, Настройки, "Организация");

КонецПроцедуры

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОперацию(Команда)
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы("Вручную");
	ОткрытьФорму("Документ.ОперацияБух.ФормаОбъекта", СтруктураПараметров, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьСторноДокумента(Команда)
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы("Корректировка");
	ОткрытьФорму("Документ.ОперацияБух.ФормаОбъекта", СтруктураПараметров, ЭтаФорма);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов


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

&НаКлиенте
Функция ПолучитьСтруктуруПараметровФормы(СпособЗаполнения = "")

	СтруктураПараметров = Новый Структура;
	
	ЗначенияЗаполнения = ОбщегоНазначенияБКВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
	
	СпособыЗаполнения = Новый Массив;
	СпособыЗаполнения.Добавить("Вручную");
	СпособыЗаполнения.Добавить("Корректировка");
		
	Если СпособыЗаполнения.Найти(СпособЗаполнения) <> Неопределено Тогда
		ЗначенияЗаполнения.Вставить("СпособЗаполнения", СпособЗаполнения);
	ИначеЕсли НЕ ЗначенияЗаполнения.Свойство("СпособЗаполнения")
		ИЛИ СпособыЗаполнения.Найти(ЗначенияЗаполнения.СпособЗаполнения) = Неопределено Тогда
		ЗначенияЗаполнения.Вставить("СпособЗаполнения", СпособыЗаполнения[0]);
	КонецЕсли;
	
	СтруктураПараметров.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы("Вручную");
	Если Копирование Тогда
		СтруктураПараметров.Вставить("ЗначениеКопирования", Элементы.Список.ТекущиеДанные.Ссылка);
	КонецЕсли;
	ОткрытьФорму("Документ.ОперацияБух.ФормаОбъекта", СтруктураПараметров, ЭтаФорма);

КонецПроцедуры

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

