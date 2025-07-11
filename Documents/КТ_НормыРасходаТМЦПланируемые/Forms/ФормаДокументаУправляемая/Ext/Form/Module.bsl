﻿
&НаСервере
// Процедура - При создании на сервере
//
// Параметры:
//  Отказ				 - 	 - 
//  СтандартнаяОбработка - 	 - 
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// Настройка формы при создании
	КТ_РаботаСФормамиСервер.ПриСозданииНаСервере(ЭтаФорма, Объект);
	// Конец 
	
	Если Объект.Ссылка.Пустая() Тогда
		
		ПодготовитьФормуНаСервере();
		
	КонецЕсли;
	
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(Строка(Объект.ВидОперации), Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
// Процедура - Подготовить форму на сервере
//
Процедура ПодготовитьФормуНаСервере()
	
	Если Параметры.Ключ.Пустая() Тогда
		
		КТ_ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(Объект);
		
	КонецЕсли;
	
	ОбщегоНазначенияБК.УстановитьТекстАвтора(НадписьАвтор, Объект.Автор);
	
КонецПроцедуры

&НаСервере
// Процедура - При чтении на сервере
//
// Параметры:
//  ТекущийОбъект	 - 	 - 
//
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	ПодготовитьФормуНаСервере();
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(Строка(Объект.ВидОперации), Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
// Процедура - При открытии
//
// Параметры:
//  Отказ	 - 	 - 
//
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	НастроитьДоступность();
	НастроитьВидимость();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
// Процедура - Настроить доступность
//
Процедура НастроитьДоступность()
	
	
	
КонецПроцедуры

&НаКлиенте
// Процедура - Настроить видимость
//
Процедура НастроитьВидимость()
	
	
	
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////
//Шапка документа
////////////////////////////////////////////////////////////////////////////////

&НаКлиенте
Процедура УчастокПриИзменении(Элемент)
	ОпределитьВидУчастка(Объект.Участок);
КонецПроцедуры

&НаСервере
Процедура ОпределитьВидУчастка(Участок)
	Объект.ВидУчастка = РегистрыСведений.ОтчетПФА_СоставГруппировокПодразделений.Получить(Новый Структура("Подразделение", Участок)).Группировка;
	Если Объект.ВидУчастка.Пустая() Тогда
		Объект.ВидУчастка = РегистрыСведений.ОтчетПФА_СоставГруппировокПодразделений.Получить(Новый Структура("Подразделение", Участок.Родитель)).Группировка;
	КонецЕсли;
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////
//Табличные части документа
////////////////////////////////////////////////////////////////////////////////

&НаКлиенте
// Процедура - Заполнить по другому участку
//
// Параметры:
//  Команда	 - 	 - 
//
Процедура ЗаполнитьПоДругомуУчастку(Команда)
	
	ВыбранноеЗначение = ОткрытьФормуМодально("Документ.КТ_НормыРасходаТМЦ.ФормаВыбора", , ЭтаФорма);
	Если ВыбранноеЗначение <> Неопределено Тогда
		ЗаполнитьПоДругомуУчасткуНаСервере(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Процедура - Заполнить по другому участку на сервере
//
Процедура ЗаполнитьПоДругомуУчасткуНаСервере(ДокументСсылка)
	
	Объект.СписокНорм.Загрузить(ДокументСсылка.СписокНорм.Выгрузить());
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
//Подвал
////////////////////////////////////////////////////////////////////////////////

&НаКлиенте
// Процедура - Комментарий начало выбора
//
// Параметры:
//  Элемент				 - 	 - 
//  ДанныеВыбора		 - 	 - 
//  СтандартнаяОбработка - 	 - 
//
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	#Если ТонкийКлиент Тогда
		КТ_РаботаСДиалогамиКлиент.ПоказатьФормуРедактированияКомментария(Объект.Комментарий, ЭтаФорма, "Комментарий");
	#КонецЕсли
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
//Основные действия формы при закрытии
////////////////////////////////////////////////////////////////////////////////

&НаКлиенте
// Процедура - Перед записью (используется при контроле по финплану)
//
// Параметры:
//  Отказ			 - 	 - 
//  ПараметрыЗаписи	 - 	 - 
//
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	
	
КонецПроцедуры

&НаСервере
// Процедура - Перед записью на сервере
//
// Параметры:
//  Отказ			 - 	 - 
//  ТекущийОбъект	 - 	 - 
//  ПараметрыЗаписи	 - 	 - 
//
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	
	
КонецПроцедуры

&НаКлиенте
// Процедура - Перед закрытием
//
// Параметры:
//  Отказ				 - 	 - 
//  ЗавершениеРаботы	 - 	 - 
//  ТекстПредупреждения	 - 	 - 
//  СтандартнаяОбработка - 	 - 
//
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	
	
КонецПроцедуры

&НаКлиенте
// Процедура - При закрытии
//
// Параметры:
//  ЗавершениеРаботы - 	 - 
//
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	
	
КонецПроцедуры

&НаСервере
// Процедура - При записи на сервере
//
// Параметры:
//  Отказ			 - 	 - 
//  ТекущийОбъект	 - 	 - 
//  ПараметрыЗаписи	 - 	 - 
//
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
// Процедура - После записи
//
// Параметры:
//  ПараметрыЗаписи	 - 	 - 
//
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	
	
КонецПроцедуры

// Процедура - После записи на сервере
//
// Параметры:
//  ТекущийОбъект	 - 	 - 
//  ПараметрыЗаписи	 - 	 - 
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(Строка(Объект.ВидОперации), Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры
