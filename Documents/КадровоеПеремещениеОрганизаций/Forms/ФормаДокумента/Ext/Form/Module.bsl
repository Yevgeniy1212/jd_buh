﻿&НаКлиенте
Перем СинхронизируемыеТабличныеЧасти;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ПодготовитьФормуНаСервере();
		РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// РедактированиеДокументовПользователей
	ПраваДоступаКОбъектам.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец РедактированиеДокументовПользователей
	
	ПодготовитьФормуНаСервере();
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.СотрудникиОрганизаций.Форма.ФормаСписка" Тогда
		
		Для Каждого СтрокаМассива Из ВыбранноеЗначение Цикл
			
			Если Объект.РаботникиОрганизации.НайтиСтроки(Новый Структура("Сотрудник", СтрокаМассива)).Количество() = 0 Тогда
				
				СтрокаРаботники = Объект.РаботникиОрганизации.Добавить();	
				СтрокаРаботники.Сотрудник = СтрокаМассива;
				ВыполнитьЗаполнениеДанныхСотрудника(СтрокаРаботники);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
		
	ОбщегоНазначенияБККлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "Документ ""кадровое перемещение организации"" (проведение)";
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если ИсходнаяОрганизация = Объект.Организация Тогда
		Возврат
	КонецЕсли;
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ИндексацияЗаработкаПриИзменении(Элемент)
	
	Если НЕ Объект.ИндексацияЗаработка И Объект.КоэффициентИндексацииЗаработка > 0 Тогда
		Объект.КоэффициентИндексацииЗаработка = 0;
	ИначеЕсли Объект.ИндексацияЗаработка Тогда
		Объект.КоэффициентИндексацииЗаработка = 1;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбособленноеПодразделениеОткудаПриИзменении(Элемент)
	
	Если ПоддержкаРаботыСоСтруктурнымиПодразделениями Тогда
		Объект.СтруктурноеПодразделениеОткуда = ПредопределенноеЗначение("Справочник.ПодразделенияОрганизаций.ПустаяСсылка");	
		СтруктурноеПодразделениеОрганизацияОткуда = Объект.ОбособленноеПодразделениеОткуда;
		Элементы.СтруктурноеПодразделениеОрганизацияОткуда.Видимость = ОбособленноеПодразделениеПриИзмененииНаСервереБезКонтекста(Объект.ОбособленноеПодразделениеОткуда);
		ВидимостьПанелиСтруктурногоПодразделения(ЭтаФорма, Ложь);
	Иначе 
		Если Объект.СтруктурноеПодразделениеОткуда <> ПредопределенноеЗначение("Справочник.ПодразделенияОрганизаций.ПустаяСсылка") Тогда
			Объект.СтруктурноеПодразделениеОткуда = ПредопределенноеЗначение("Справочник.ПодразделенияОрганизаций.ПустаяСсылка")	
		КонецЕсли;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбособленноеПодразделениеКудаПриИзменении(Элемент)
	
	Если ПоддержкаРаботыСоСтруктурнымиПодразделениями Тогда
		Объект.СтруктурноеПодразделениеКуда = ПредопределенноеЗначение("Справочник.ПодразделенияОрганизаций.ПустаяСсылка");
		СтруктурноеПодразделениеОрганизацияКуда = Объект.ОбособленноеПодразделениеКуда;
		Результат = Новый Структура("Организация, СтруктурноеПодразделение, ИзмененаОрганизация, ИзмененоСтруктурноеПодразделение", 
									Объект.ОбособленноеПодразделениеКуда, 
									Объект.СтруктурноеПодразделениеКуда,
									Истина,
									Истина);
		
		Элементы.СтруктурноеПодразделениеОрганизацияКуда.Видимость = ОбособленноеПодразделениеПриИзмененииНаСервереБезКонтекста(Объект.ОбособленноеПодразделениеКуда);
		ВидимостьПанелиСтруктурногоПодразделения(ЭтаФорма, Ложь);
	Иначе
		Если Объект.СтруктурноеПодразделениеКуда <> ПредопределенноеЗначение("Справочник.ПодразделенияОрганизаций.ПустаяСсылка") Тогда
			Объект.СтруктурноеПодразделениеКуда = ПредопределенноеЗначение("Справочник.ПодразделенияОрганизаций.ПустаяСсылка");	
			Результат = Новый Структура("Организация, СтруктурноеПодразделение, ИзмененаОрганизация, ИзмененоСтруктурноеПодразделение", 
										Объект.ОбособленноеПодразделениеКуда, 
										Объект.СтруктурноеПодразделениеКуда,
										Истина,
										Истина);
			
		Иначе
			Результат = Новый Структура("Организация, СтруктурноеПодразделение, ИзмененаОрганизация, ИзмененоСтруктурноеПодразделение", 
										Объект.ОбособленноеПодразделениеКуда, 
										Объект.СтруктурноеПодразделениеКуда,
										Истина,
										Ложь);
		КонецЕсли;
	КонецЕсли;
	
	РаботаСДиалогамиКлиент.ПослеВыбораСтруктурногоПодразделения(Результат, Объект.ОбособленноеПодразделениеКуда, Объект.СтруктурноеПодразделениеКуда, СтруктурноеПодразделениеОрганизацияКуда);
	Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
		Модифицированность = Истина;
		Результат.Вставить("НеобходимоИзменитьЗначенияРеквизитовОбъекта", Ложь);
		РаботаСДиалогамиКлиент.ПоказатьВопросОбОчисткеНекорректныхЗначенийПодразделения(ЭтаФорма, Результат, "ПослеЗакрытияВопросаОбОчисткеНекорректныхЗначенийОбособленногоПодразделенияКуда");
	КонецЕсли;

	УстановитьФункциональныеОпцииФормы();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияОткудаПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СтруктурноеПодразделениеОрганизацияОткуда) Тогда 
		Объект.СтруктурноеПодразделениеОткуда     = Неопределено;
        СтруктурноеПодразделениеОрганизацияОткуда = Объект.Организация
	Иначе 
		Объект.СтруктурноеПодразделениеОткуда = СтруктурноеПодразделениеОрганизацияОткуда;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияОткудаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСДиалогамиКлиент.СтруктурноеПодразделениеНачалоВыбора(ЭтаФорма, СтандартнаяОбработка, Объект.ОбособленноеПодразделениеОткуда, Объект.СтруктурноеПодразделениеОткуда, Ложь,"ПослеВыбораСтруктурногоПодразделенияОткуда");
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияКудаПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СтруктурноеПодразделениеОрганизацияКуда) Тогда 
		Объект.СтруктурноеПодразделениеКуда     = Неопределено;
		СтруктурноеПодразделениеОрганизацияКуда = Объект.Организация;
	Иначе 
		Результат = РаботаСДиалогамиКлиент.ПроверитьИзменениеЗначенийОрганизацииСтруктурногоПодразделения(СтруктурноеПодразделениеОрганизацияКуда, Объект.ОбособленноеПодразделениеКуда, Объект.СтруктурноеПодразделениеКуда);
		Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
			Если Результат.ИзмененоСтруктурноеПодразделение Тогда
				РаботаСДиалогамиКлиент.ПоказатьВопросОбОчисткеНекорректныхЗначенийПодразделения(ЭтаФорма, Результат, "ПослеЗакрытияВопросаОбОчисткеНекорректныхЗначенийСтруктурногоПодразделенияКуда");
			Иначе 
				СтруктурноеПодразделениеОрганизацияКудаПриИзмененииНаСервере();
			КонецЕсли;	
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияКудаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСДиалогамиКлиент.СтруктурноеПодразделениеНачалоВыбора(ЭтаФорма, СтандартнаяОбработка, Объект.ОбособленноеПодразделениеКуда, Объект.СтруктурноеПодразделениеКуда, Ложь, "ПослеВыбораСтруктурногоПодразделенияКуда");
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	 ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");

 КонецПроцедуры
 
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ РаботникиОрганизации

&НаКлиенте
Процедура РаботникиОрганизацииПриАктивизацииСтроки(Элемент)
	
	СинхронизироватьСтроки(ЭтаФорма, Объект, Элементы.РаботникиОрганизации, СинхронизируемыеТабличныеЧасти, "Сотрудник");
	
КонецПроцедуры

&НаКлиенте
Процедура РаботникиОрганизацииСотрудникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Истина);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	Если ЗначениеЗаполнено(Объект.ОбособленноеПодразделениеОткуда) Тогда  
		ПараметрыФормы.Вставить("ОтборОрганизация", Объект.ОбособленноеПодразделениеОткуда); 
	Иначе 
		ПараметрыФормы.Вставить("ОтборОрганизация", Объект.Организация); 
	КонецЕсли;  
	ПараметрыФормы.Вставить("ОтборПодразделениеОрганизации", Объект.СтруктурноеПодразделениеОткуда);
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	
	ОбработчикОповещения = Новый ОписаниеОповещения("СписокСотрудниковСписокЗавершениеВыбора", ЭтотОбъект);

	ОткрытьФорму("Справочник.СотрудникиОрганизаций.Форма.ФормаСписка", ПараметрыФормы, Элемент,,,,ОбработчикОповещения, Режим);
	
КонецПроцедуры

&НаКлиенте
Процедура РаботникиОрганизацииСотрудникПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.РаботникиОрганизации.ТекущиеДанные;

	ВыполнитьЗаполнениеДанныхСотрудника(ТекущиеДанные);
		
КонецПроцедуры

&НаКлиенте
Процедура РаботникиОрганизацииПередНачаломИзменения(Элемент, Отказ)
	
	Если Элементы.РаботникиОрганизации.ТекущиеДанные <> Неопределено Тогда 
		ТекущийСотрудник = Элементы.РаботникиОрганизации.ТекущиеДанные.Сотрудник;
	Иначе
		ТекущийСотрудник = ПредопределенноеЗначение("Справочник.СотрудникиОрганизаций.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаботникиОрганизацииПередУдалением(Элемент, Отказ)
	
	ТекущийСотрудник = Элементы.РаботникиОрганизации.ТекущиеДанные.Сотрудник;
	УдалитьНачисленияПоРаботнику(Объект, ТекущийСотрудник, Истина);
	ТекущийСотрудник = Неопределено;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ОсновныеНачисления

&НаКлиенте
Процедура ОсновныеНачисленияПриАктивизацииСтроки(Элемент)
	
	СинхронизироватьСтроки(ЭтаФорма, Объект, Элементы.ОсновныеНачисления, СинхронизируемыеТабличныеЧасти, "Сотрудник");
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеНачисленияСотрудникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Истина);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	ПараметрыФормы.Вставить("ОтборОрганизация", Объект.Организация);
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	
	ОбработчикОповещения = Новый ОписаниеОповещения("СписокОсновныеНачисленияСписокЗавершениеВыбора", ЭтотОбъект);

	ОткрытьФорму("Справочник.СотрудникиОрганизаций.Форма.ФормаСписка", ПараметрыФормы, Элемент,,,,ОбработчикОповещения, Режим);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СписокРаботниковРаботникиОрганизации(Команда)
	
	Если Объект.РаботникиОрганизации.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'Табличная часть будет полностью перезаполнена. Продолжить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаЗаполнитьПоСпискуСотрудников", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)

	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Ложь);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор",				Истина);
	ПараметрыФормы.Вставить("ПараметрВыборГруппИЭлементов",		ИспользованиеГруппИЭлементов.Элементы);
	Если ЗначениеЗаполнено(Объект.ОбособленноеПодразделениеОткуда) Тогда  
		ПараметрыФормы.Вставить("ОтборОрганизация", Объект.ОбособленноеПодразделениеОткуда); 
	Иначе 
		ПараметрыФормы.Вставить("ОтборОрганизация", Объект.Организация); 
	КонецЕсли;  
	ПараметрыФормы.Вставить("ОтборПодразделениеОрганизации", Объект.СтруктурноеПодразделениеОткуда);
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;

	ОткрытьФорму("Справочник.СотрудникиОрганизаций.Форма.ФормаСписка", ПараметрыФормы, ЭтаФорма, , , ,,Режим)

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
     ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
     ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
 
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
     ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
     ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПоддержкаРаботыСоСтруктурнымиПодразделениями ИЛИ
		 (ПоддержкаРаботыСоСтруктурнымиПодразделениями = Ложь И (ЗначениеЗаполнено(Объект.СтруктурноеПодразделениеОткуда) 
		 ИЛИ ЗначениеЗаполнено(Объект.СтруктурноеПодразделениеКуда)));
		 
	РаботаСДиалогамиКлиентСервер.УстановитьВидимостьСтруктурногоПодразделения(Объект.ОбособленноеПодразделениеОткуда, Объект.СтруктурноеПодразделениеОткуда, СтруктурноеПодразделениеОрганизацияОткуда, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	РаботаСДиалогамиКлиентСервер.УстановитьСвойстваЭлементаСтруктурноеПодразделениеОрганизация(Элементы.СтруктурноеПодразделениеОрганизацияОткуда, Объект.СтруктурноеПодразделениеОткуда, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	РаботаСДиалогамиКлиентСервер.УстановитьВидимостьСтруктурногоПодразделения(Объект.ОбособленноеПодразделениеКуда, Объект.СтруктурноеПодразделениеКуда, СтруктурноеПодразделениеОрганизацияКуда, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	РаботаСДиалогамиКлиентСервер.УстановитьСвойстваЭлементаСтруктурноеПодразделениеОрганизация(Элементы.СтруктурноеПодразделениеОрганизацияКуда, Объект.СтруктурноеПодразделениеКуда, ПоддержкаРаботыСоСтруктурнымиПодразделениями);

	Если ПоддержкаРаботыСоСтруктурнымиПодразделениями = Ложь 
		 И НЕ(ЗначениеЗаполнено(Объект.СтруктурноеПодразделениеОткуда) 
		 ИЛИ ЗначениеЗаполнено(Объект.СтруктурноеПодразделениеКуда)) Тогда
		
		Элементы.СтруктурноеПодразделениеОрганизацияОткуда.Видимость = Ложь;
		Элементы.СтруктурноеПодразделениеОрганизацияКуда.Видимость = Ложь;
	Иначе
		Элементы.СтруктурноеПодразделениеОрганизацияОткуда.Видимость = Истина;
		Элементы.СтруктурноеПодразделениеОрганизацияКуда.Видимость = Истина;
		
	КонецЕсли;
	
	ПоказыватьПодразделения = ЗначениеЗаполнено(Объект.Организация);
	Если Параметры.Ключ.Пустая()Тогда 
		Если ПоддержкаРаботыСоСтруктурнымиПодразделениями Тогда
			ИсходноеСтруктурноеПодразделение = Объект.СтруктурноеПодразделениеКуда;
			СтруктурноеПодразделениеОрганизацияКуда    = Объект.Организация;
			Объект.СтруктурноеПодразделениеКуда 	   = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
			СтруктурноеПодразделениеОрганизацияОткуда  = Объект.Организация;
			Объект.СтруктурноеПодразделениеОткуда      = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
		Иначе
			СтруктурноеПодразделениеОрганизацияКуда    = Неопределено;
			Объект.СтруктурноеПодразделениеКуда 	   = Неопределено;
			СтруктурноеПодразделениеОрганизацияОткуда  = Неопределено;
			Объект.СтруктурноеПодразделениеОткуда      = Неопределено;
		КонецЕсли;
		Объект.ОбособленноеПодразделениеКуда 	   = Объект.Организация;
		Объект.ОбособленноеПодразделениеОткуда 	   = Объект.Организация;
	КонецЕсли;
	
	УстановитьФункциональныеОпцииФормы();

	УправлениеФормой(ЭтаФорма);
		
	ОбщегоНазначенияБК.УстановитьТекстАвтора(НадписьАвтор, Объект.Автор);
		
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБККлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
	ОрганизацияЯвляетсяВкладчикомОППВ = ПроцедурыНалоговогоУчета.ПолучитьПризнакВкладчикаПрофПенсионныхВзносов(Объект.ОбособленноеПодразделениеКуда, Объект.Дата);
	
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Объект		= Форма.Объект;
	Элементы	= Форма.Элементы;
	
	Элементы.КоэффициентИндексацииЗаработка.Доступность = Объект.ИндексацияЗаработка;
	ВидимостьПанелиСтруктурногоПодразделения(Форма, Истина);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ВидимостьПанелиСтруктурногоПодразделения(Форма, ПроверятьКоличество = Ложь)
	
	Объект		= Форма.Объект;
	Элементы	= Форма.Элементы;
	
	ОбособленныеПодразделения = Ложь;
	КоличествоСтруктурныхПодразделений = ПолучитьКоличествоСтруктурныхПодразделенийОрганизации(Объект, Истина, "КоличествоСтруктурныхПодразделений");
	
	Если Форма.ПоддержкаРаботыСоСтруктурнымиПодразделениями Тогда	
		
		Если ПроверятьКоличество Тогда
			КоличествоКуда 	 = ПолучитьКоличествоСтруктурныхПодразделенийОрганизации(Объект, Истина, "КоличествоКуда");
			КоличествоОткуда = ПолучитьКоличествоСтруктурныхПодразделенийОрганизации(Объект, Истина, "КоличествоОткуда");
			
			Если КоличествоКуда = 0 Тогда
				Элементы.СтруктурноеПодразделениеОрганизацияКуда.Видимость   = Ложь;
			Иначе 
				Элементы.СтруктурноеПодразделениеОрганизацияКуда.Видимость   = ИСтина;
				
			КонецЕсли;
			
			Если КоличествоОткуда = 0 Тогда
				Элементы.СтруктурноеПодразделениеОрганизацияОткуда.Видимость = Ложь;
			Иначе
				Элементы.СтруктурноеПодразделениеОрганизацияОткуда.Видимость = Истина;
				
			КонецЕсли;
		КонецЕсли;
		
		Если НЕ Элементы.СтруктурноеПодразделениеОрганизацияКуда.Видимость И
			НЕ Элементы.СтруктурноеПодразделениеОрганизацияОткуда.Видимость Тогда
			Элементы.ГруппаОбособленныеПодразделения.Видимость = Ложь;
		Иначе
			Элементы.ГруппаОбособленныеПодразделения.Видимость = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	КоличествоОбособленныхПодразделений =ПолучитьКоличествоСтруктурныхПодразделенийОрганизации(Объект, Истина, "КоличествоОбособленныхПодразделений"); 
	Если КоличествоОбособленныхПодразделений > 1 Тогда
		ОбособленныеПодразделения = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда   
		Если Форма.ПоддержкаРаботыСоСтруктурнымиПодразделениями И КоличествоСтруктурныхПодразделений > 0 Тогда
			Если ОбособленныеПодразделения Тогда
				Элементы.ОбособленноеПодразделениеОткуда.Видимость = Истина;
				Элементы.ОбособленноеПодразделениеКуда.Видимость = Истина;
			Иначе
				Элементы.ОбособленноеПодразделениеОткуда.Видимость = Ложь;	
				Элементы.ОбособленноеПодразделениеКуда.Видимость = Ложь;
			КонецЕсли;
		ИначеЕсли ОбособленныеПодразделения Тогда
			Элементы.СтруктурноеПодразделениеОрганизацияОткуда.Видимость = Ложь;
			Элементы.СтруктурноеПодразделениеОрганизацияКуда.Видимость = Ложь;
			Элементы.ГруппаОбособленныеПодразделения.Видимость = Истина;	
		Иначе
			Элементы.ГруппаОбособленныеПодразделения.Видимость = Ложь;	
		КонецЕсли;
	Иначе
		Элементы.ГруппаОбособленныеПодразделения.Видимость = Ложь;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция  ПолучитьКоличествоСтруктурныхПодразделенийОрганизации(Объект, ПоказыватьПодразделения = Ложь, Количество) Экспорт
	
	Если Количество = "КоличествоКуда" Тогда 
		КоличествоКуда 	 = ОбщегоНазначенияБК.ПолучитьСписокСтруктурныхПодразделенийОрганизации(?(ПоказыватьПодразделения = Истина, Объект.ОбособленноеПодразделениеКуда, Объект.Организация)).Количество();
		Возврат КоличествоКуда;
	ИначеЕсли Количество = "КоличествоОткуда" Тогда
		КоличествоОткуда = ОбщегоНазначенияБК.ПолучитьСписокСтруктурныхПодразделенийОрганизации(?(ПоказыватьПодразделения = Истина, Объект.ОбособленноеПодразделениеОткуда, Объект.Организация)).Количество();
		Возврат КоличествоОткуда;
	ИначеЕсли Количество = "КоличествоСтруктурныхПодразделений" Тогда
		КоличествоСтруктурныхПодразделений = ОбщегоНазначенияБК.ПолучитьСписокСтруктурныхПодразделенийОрганизации(Объект.Организация).Количество();
		Возврат КоличествоСтруктурныхПодразделений;
	ИначеЕсли  Количество = "КоличествоОбособленныхПодразделений" Тогда
		КоличествоОбособленныхПодразделений = ОбщегоНазначенияБК.ПолучитьСписокОбособленныхПодразделенийОрганизацииДляУчетаЗарплаты(Объект.Организация).Количество();
		Возврат КоличествоОбособленныхПодразделений; 
	КонецЕсли;
			
КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Если ПоддержкаРаботыСоСтруктурнымиПодразделениями Тогда
		СтруктурноеПодразделениеОрганизацияКуда    = Объект.Организация;
		Объект.СтруктурноеПодразделениеКуда 	   = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
		СтруктурноеПодразделениеОрганизацияОткуда  = Объект.Организация;
		Объект.СтруктурноеПодразделениеОткуда      = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
	Иначе
		СтруктурноеПодразделениеОрганизацияКуда    = Неопределено;
		Объект.СтруктурноеПодразделениеКуда 	   = Неопределено;
		СтруктурноеПодразделениеОрганизацияОткуда  = Неопределено;
		Объект.СтруктурноеПодразделениеОткуда      = Неопределено;
	КонецЕсли;
	
	Объект.ОбособленноеПодразделениеКуда 	   = Объект.Организация;
	Объект.ОбособленноеПодразделениеОткуда 	   = Объект.Организация;
	
	УстановитьФункциональныеОпцииФормы();  

	ИсходнаяОрганизация = Объект.Организация;
	УправлениеФормой(ЭтаФорма);

	СтруктураРезультатаВыполнения = Неопределено;
	РаботаСДиалогами.ПриИзмененииЗначенияОрганизации(Объект,,СтруктураРезультатаВыполнения);
	
	// Если нет данных в ТЧ, то нет необходимости проверки и очищения некорректного значения Подразделения
	Если  Объект.РаботникиОрганизации.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Список для обработки ТЧ
	СписокТабличныхЧастей = Новый СписокЗначений;
	СписокРеквизитовПодразделения = Новый СписокЗначений;
	// ТЧ Работники
	СписокРеквизитовПодразделения.Добавить("ПодразделениеОрганизации"); 
	СтруктураРеквизтов = Новый Структура("ТабличнаяЧасть, СписокРеквизитовПодразделения",  Объект.РаботникиОрганизации, СписокРеквизитовПодразделения); 
	СписокТабличныхЧастей.Добавить(СтруктураРеквизтов);
	
	// Очистим некорректные значения подразделений не входящими в выбранное структурное подразделение "Куда"
	РаботаСДиалогами.ПроверитьСоответствиеПодразделения(?(ОбособленныеПодразделения = Истина, Объект.ОбособленноеПодразделениеКуда, Объект.Организация), Объект.Организация, , СписокТабличныхЧастей); 

КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораСтруктурногоПодразделенияОткуда(Результат, Параметры) Экспорт
	
	РаботаСДиалогамиКлиент.ПослеВыбораСтруктурногоПодразделения(Результат, Объект.ОбособленноеПодразделениеОткуда, Объект.СтруктурноеПодразделениеОткуда, СтруктурноеПодразделениеОрганизацияОткуда);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура РаботникиОрганизацииСотрудникПриИзмененииБезКонтекста(СтрокаТабличнойЧасти, ПараметрыОбъекта)

	ПроцедурыУправленияПерсоналомСервер.ПроставитьДанныеСтроки(ОбщегоНазначения.ТекущаяДатаПользователя(), СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьСтроки(Форма, Объект, Элемент, СинхронизируемыеТабличныеЧасти, ИмяКолонки) Экспорт

	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Имя = Элемент.Имя;
	Если СинхронизируемыеТабличныеЧасти[Имя] Тогда
		СинхронизируемыеТабличныеЧасти[Имя] = Ложь;
		Возврат;
	КонецЕсли;

	Для Каждого ЭлементСоответствия Из СинхронизируемыеТабличныеЧасти Цикл

		Если ЭлементСоответствия.Ключ = Имя Тогда 
			Продолжить;
		КонецЕсли;

		Попытка
			МассивСтрок = Объект[ЭлементСоответствия.Ключ].НайтиСтроки(Новый Структура(ИмяКолонки, Элемент.ТекущиеДанные[ИмяКолонки]));
		Исключение
			МассивСтрок = Форма[ЭлементСоответствия.Ключ].НайтиСтроки(Новый Структура(ИмяКолонки, Элемент.ТекущиеДанные[ИмяКолонки]));
		КонецПопытки;

		Если МассивСтрок.Количество() > 0 Тогда

			СинхронизируемыеТабличныеЧасти[ЭлементСоответствия.Ключ] = Истина;
			Форма.Элементы[ЭлементСоответствия.Ключ].ТекущаяСтрока = МассивСтрок[0].ПолучитьИдентификатор();

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПереформироватьНачисленияПоРаботнику(Объект, ВыбранныйСотрудник, ТекущийСотрудник)
	
	УдалитьНачисленияПоРаботнику(Объект, ТекущийСотрудник, Истина);
	
	ИзмненитьНачисленияПоСотруднику(Объект, ТекущийСотрудник, ВыбранныйСотрудник);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УдалитьНачисленияПоРаботнику(Объект, Сотрудник, УдалятьВсе)
	
	СтруктураПоиска = Новый Структура("Сотрудник", Сотрудник);
	
	// удалять начисления будем в том случае, когда в т.ч. Работники эта строка с физлицом - последняя
	Если Объект.РаботникиОрганизации.НайтиСтроки(СтруктураПоиска).Количество() > 1 Тогда
		Возврат
	КонецЕсли;
	
	Строки = Объект.ОсновныеНачисления.НайтиСтроки(СтруктураПоиска);
	
	Если УдалятьВсе Тогда
		
		Для Каждого Строка из Строки Цикл
			Объект.ОсновныеНачисления.Удалить(Строка);
		КонецЦикла;
		
	Иначе
		
		Для Каждого Строка из Строки Цикл
			
			// удалим "основное" начисление
			Если НЕ ЗначениеЗаполнено(Строка.ВидРасчета) Тогда
				Объект.ОсновныеНачисления.Удалить(Строка);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура ИзмненитьНачисленияПоСотруднику(Объект, Сотрудник, ВыбранныйСотрудник);
	
	СтруктураПоиска = Новый Структура("Сотрудник", Сотрудник);
	
	Строки = Объект.ОсновныеНачисления.НайтиСтроки(СтруктураПоиска);
	
	Для Каждого СтрокаТабличнойЧасти Из Строки Цикл
		СтрокаТабличнойЧасти.Сотрудник = ВыбранныйСотрудник;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ДобавитьНачисленияПоСтроке(ВыбранныйСотрудник)
	
	Документы.КадровоеПеремещениеОрганизаций.ДобавитьНачисленияПоСтроке(Объект, ВыбранныйСотрудник);

КонецПроцедуры

&НаСервере
Процедура ПриИзмененииЗначенияСтруктурногоПодразделенияКуда(Параметры)
	
	РаботаСДиалогами.СтруктурноеПодразделениеПриИзменении(СтруктурноеПодразделениеОрганизацияКуда, Объект.ОбособленноеПодразделениеКуда, Объект.СтруктурноеПодразделениеКуда, Параметры);

	Если ИсходноеСтруктурноеПодразделение = Объект.СтруктурноеПодразделениеКуда  
		И  Объект.СтруктурноеПодразделениеКуда <> Справочники.ПодразделенияОрганизаций.ПустаяСсылка() Тогда
		Возврат;
	КонецЕсли;
	
	ИсходноеСтруктурноеПодразделение =  Объект.СтруктурноеПодразделениеКуда;
	
	// Если нет данных в ТЧ, то нет необходимости проверки и очищения некорректного значения Подразделения
	Если  Объект.РаботникиОрганизации.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Список для обработки ТЧ
	СписокТабличныхЧастей = Новый СписокЗначений;
	СписокРеквизитовПодразделения = Новый СписокЗначений;
	
	// ТЧ Работники
	СписокРеквизитовПодразделения.Добавить("ПодразделениеОрганизации"); 
	СтруктураРеквизтов = Новый Структура("ТабличнаяЧасть, СписокРеквизитовПодразделения",  Объект.РаботникиОрганизации, СписокРеквизитовПодразделения); 
	СписокТабличныхЧастей.Добавить(СтруктураРеквизтов);
	
	// Очистим некорректные значения подразделений не входящими в выбранное структурное подразделение "Куда"
	РаботаСДиалогами.ПроверитьСоответствиеПодразделения(?(ОбособленныеПодразделения = Истина, Объект.ОбособленноеПодразделениеКуда, Объект.Организация), Объект.СтруктурноеПодразделениеКуда, , СписокТабличныхЧастей); 
	
КонецПроцедуры

&НаСервере
Процедура СтруктурноеПодразделениеОрганизацияКудаПриИзмененииНаСервере(СтруктураПараметров = Неопределено, СтруктураРезультатаВыполнения = Неопределено)
	
	Если СтруктураПараметров = Неопределено 
		ИЛИ (СтруктураПараметров.Свойство("НеобходимоИзменитьЗначенияРеквизитовОбъекта") 
			И СтруктураПараметров.НеобходимоИзменитьЗначенияРеквизитовОбъекта) Тогда 
		РаботаСДиалогами.СтруктурноеПодразделениеПриИзменении(СтруктурноеПодразделениеОрганизацияКуда, Объект.ОбособленноеПодразделениеКуда, Объект.СтруктурноеПодразделениеКуда, СтруктураПараметров);
	КонецЕсли;
	
	ПриИзмененииЗначенияОбособленноеПодразделениеКудаСервер(СтруктураПараметров, СтруктураРезультатаВыполнения);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииЗначенияОбособленноеПодразделениеКудаСервер(СтруктураПараметров, СтруктураРезультатаВыполнения)
	
	Если НЕ СтруктураПараметров.ИзмененаОрганизация И НЕ СтруктураПараметров.ИзмененоСтруктурноеПодразделение Тогда
		Возврат;
	КонецЕсли;

	// Если нет данных в ТЧ, то нет необходимости проверки и очищения некорректного значения Подразделения
	Если  Объект.РаботникиОрганизации.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Список для обработки ТЧ
	СписокТабличныхЧастей = Новый СписокЗначений;
	СписокРеквизитовПодразделения = Новый СписокЗначений;
	
	// ТЧ Работники
	СписокРеквизитовПодразделения.Добавить("ПодразделениеОрганизации"); 
	СтруктураРеквизтов = Новый Структура("ТабличнаяЧасть, СписокРеквизитовПодразделения",  Объект.РаботникиОрганизации, СписокРеквизитовПодразделения); 
	СписокТабличныхЧастей.Добавить(СтруктураРеквизтов);
	
	// Очистим некорректные значения подразделений не входящими в выбранное структурное подразделение "Куда"
	РаботаСДиалогами.ПроверитьСоответствиеПодразделения(?(ОбособленныеПодразделения = Истина, Объект.ОбособленноеПодразделениеКуда, Объект.Организация), Объект.ОбособленноеПодразделениеКуда, , СписокТабличныхЧастей); 
	
	УстановитьФункциональныеОпцииФормы();

	СтруктураРезультатаВыполнения = Неопределено;
	
	РаботаСДиалогами.ПриИзмененииЗначенияОрганизации(Объект,,СтруктураРезультатаВыполнения);

КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораСтруктурногоПодразделенияКуда(Результат, Параметры) Экспорт
	
	РаботаСДиалогамиКлиент.ПослеВыбораСтруктурногоПодразделения(Результат, Объект.ОбособленноеПодразделениеКуда, Объект.СтруктурноеПодразделениеКуда, СтруктурноеПодразделениеОрганизацияКуда);
	Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
		Модифицированность = Истина;
		Результат.Вставить("НеобходимоИзменитьЗначенияРеквизитовОбъекта", Ложь);
		РаботаСДиалогамиКлиент.ПоказатьВопросОбОчисткеНекорректныхЗначенийПодразделения(ЭтаФорма, Результат, "ПослеЗакрытияВопросаОбОчисткеНекорректныхЗначенийСтруктурногоПодразделенияКуда");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаОбОчисткеНекорректныхЗначенийСтруктурногоПодразделенияКуда(Результат, Параметры) Экспорт
	
	Параметры.Вставить("ОчищатьНекорректныеЗначения", Результат = КодВозвратаДиалога.Да);
	СтруктураРезультатаВыполнения = Неопределено;

	Если Результат =КодВозвратаДиалога.Да  Тогда
		ПриИзмененииЗначенияСтруктурногоПодразделенияКуда(Параметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаОбОчисткеНекорректныхЗначенийОбособленногоПодразделенияКуда(Результат, Параметры) Экспорт
	
	Параметры.Вставить("ОчищатьНекорректныеЗначения", Результат = КодВозвратаДиалога.Да);
	СтруктураРезультатаВыполнения = Неопределено;

	Если Результат =КодВозвратаДиалога.Да  Тогда
		ПриИзмененииЗначенияОбособленноеПодразделениеКудаСервер(Параметры, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция  ОбособленноеПодразделениеПриИзмененииНаСервереБезКонтекста(ОбособленноеПодразделение)
	
	Если ОбщегоНазначенияБК.ПолучитьСписокСтруктурныхПодразделенийОрганизации(ОбособленноеПодразделение).Количество() = 0 Тогда
		Видимость = Ложь;
	Иначе 
		Видимость = Истина;
	КонецЕсли;    	
	
	Возврат Видимость;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСписокОбособленныхПодразделенийОрганизацииДляУчетаЗарплаты (Организация) Экспорт
	
	Список = ОбщегоНазначенияБК.ПолучитьСписокОбособленныхПодразделенийОрганизацииДляУчетаЗарплаты(Организация);
	
	Возврат Список;
	
КонецФункции

&НаКлиенте
Процедура ПослеЗакрытияВопросаЗаполнитьПоСпискуСотрудников(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗаполнениеДанныхСотрудника(ДанныеСотрудника)
	
	ДанныеСтрокиТаблицы = Новый Структура("Сотрудник, Физлицо, Должность, ПодразделениеОрганизации, ИсчислятьОППВ, ДатаНачала");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ДанныеСотрудника);
	
	ПараметрыОбъекта = Новый Структура("Организация, СтруктурноеПодразделение, Дата, Ссылка, РаботникиОрганизации, ОсновныеНачисления, КоэффициентИндексацииЗаработка, ИндексацияЗаработка");
	ЗаполнитьЗначенияСвойств(ПараметрыОбъекта, Объект);
	
	РаботникиОрганизацииСотрудникПриИзмененииБезКонтекста(ДанныеСтрокиТаблицы, ПараметрыОбъекта);
	
	Если ТекущийСотрудник <> ДанныеСотрудника.Сотрудник 
		ИЛИ (ТекущийСотрудник = Неопределено 
			 И ЗначениеЗаполнено(ДанныеСотрудника.Сотрудник)) Тогда
		
		СтруктураПоиска = Новый Структура("Сотрудник", ТекущийСотрудник);
		
		Если Объект.РаботникиОрганизации.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда
			ПереформироватьНачисленияПоРаботнику(Объект, ДанныеСотрудника.Сотрудник, ТекущийСотрудник);
			ДобавитьНачисленияПоСтроке(ДанныеСтрокиТаблицы);
		Иначе
			ДобавитьНачисленияПоСтроке(ДанныеСтрокиТаблицы);
		КонецЕсли;
		
	КонецЕсли;
	
	ТекущийСотрудник = ДанныеСотрудника.Сотрудник;
	
	ЗаполнитьЗначенияСвойств(ДанныеСотрудника, ДанныеСтрокиТаблицы);

КонецПроцедуры

&НаКлиенте
Процедура СписокСотрудниковСписокЗавершениеВыбора(ВыбранноеЗначение, Параметры) Экспорт

	ТекущаяСтрока = Элементы.РаботникиОрганизации.ТекущиеДанные;
	Если  ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		ТекущаяСтрока.Сотрудник = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОсновныеНачисленияСписокЗавершениеВыбора(ВыбранноеЗначение, Параметры) Экспорт

	ТекущаяСтрока = Элементы.ОсновныеНачисления.ТекущиеДанные;
	Если  ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		ТекущаяСтрока.Сотрудник = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры


СинхронизируемыеТабличныеЧасти = Новый Соответствие;
СинхронизируемыеТабличныеЧасти["ОсновныеНачисления"]  	= Ложь;
СинхронизируемыеТабличныеЧасти["РаботникиОрганизации"]  = Ложь;
