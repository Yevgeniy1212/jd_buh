﻿
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
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства	
	
	Если Параметры.Ключ.Пустая() Тогда
		Объект.СпособВыпискиАктовВыполненныхРабот = Перечисления.СпособыВыпискиАктовВыполненныхРабот.ВБумажномВиде;
		ПодготовитьФормуНаСервере();
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
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	 	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	УправлениеФормой(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	Оповестить("Запись_Договор", Объект.Ссылка, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр)Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)

	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства 
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства 

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ФормаВыбораИзКлассификатора") Тогда
		
		Если ВРег(ИсточникВыбора.ИмяМакета) = ВРег("УсловияПоставки") Тогда
			
			Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда 
				Объект.УсловияПоставки = ВыбранноеЗначение;
				ОбновитьПредставлениеЭлемента("УсловияПоставки");
			Иначе 
				Объект.УсловияПоставки								   = ВыбранноеЗначение.КодСтроки;
				Элементы.ДекорацияРасшифровкаУсловияПоставки.Заголовок = ВыбранноеЗначение.Наименование;
			КонецЕсли;
			
			Модифицированность = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "ОбщаяФорма.ФормаУчастникиСовместнойДеятельности" Тогда		
		
		Объект.УчастникиСовместнойДеятельности.Очистить();
		
		Для Каждого Элемент Из ВыбранноеЗначение.УчастникиСовместнойДеятельности Цикл
			НоваяСтрока = Объект.УчастникиСовместнойДеятельности.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока,Элемент);
		КонецЦикла;
		
		Объект.ПоверенныйОператор = ВыбранноеЗначение.ПоверенныйОператор;
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	УстановитьПараметрыВыбораВидаДоговора(ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура ДоговорСовместнойДеятельностиПриИзменении(Элемент)
	
	Если Объект.ДоговорСовместнойДеятельности <> Истина И Объект.УчастникиСовместнойДеятельности.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru='Участники совместной деятельности будут очищены. Продолжить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПриИзмененииДоговорСовместнойДеятельности", ЭтотОбъект, Параметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	ИначеЕсли Объект.ДоговорСовместнойДеятельности = Истина Тогда 
		СтрокаТЧ = Объект.УчастникиСовместнойДеятельности.Добавить();
		СтрокаТЧ.УчастникСовместнойДеятельности = Объект.Владелец;
		
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановленСрокОплатыПриИзменении(Элемент)
	
	УстановленСрокОплатыПриИзмененииНаСервере(); 	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	// СтандартныеПодсистемы.Свойства
	Если ЭтотОбъект.ПараметрыСвойств.Свойство(ТекущаяСтраница.Имя)
		И НЕ ЭтотОбъект.ПараметрыСвойств.ВыполненаОтложеннаяИнициализация Тогда
		СвойстваВыполнитьОтложеннуюИнициализацию();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура УсловияПоставкиПриИзменении(Элемент)
	
	ОбновитьПредставлениеЭлемента("УсловияПоставки");
	
КонецПроцедуры

&НаКлиенте
Процедура УсловияПоставкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора"		  , Истина);
	ПараметрыФормы.Вставить("ИмяМакета"			  , "УсловияПоставки");
	ПараметрыФормы.Вставить("ИмяСекции"			  ,	"Классификатор");
	ПараметрыФормы.Вставить("ПолучатьПолныеДанные", Истина);
	ПараметрыФормы.Вставить("ТекущийКодСтроки"	  , ?(НЕ ЗначениеЗаполнено(Объект.УсловияПоставки), Неопределено, СокрЛП(Объект.УсловияПоставки)));
	ПараметрыФормы.Вставить("ЯзыкМакета", ОбщегоНазначенияКлиент.КодОсновногоЯзыка());
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораИзКлассификатора", ПараметрыФормы, ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникСРППриИзменении(Элемент)
	
	Если Объект.УчастникСРП <> Истина И Объект.УчастникиСовместнойДеятельности.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru='Участники СРП будут очищены. Продолжить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПриИзмененииУчастникаСРП", ЭтотОбъект, Параметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	ИначеЕсли Объект.УчастникСРП = Истина Тогда 
		СтрокаТЧ = Объект.УчастникиСовместнойДеятельности.Добавить();
		СтрокаТЧ.УчастникСовместнойДеятельности = Объект.Владелец;
		
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияУчастникиСовместнойДеятельностиНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура();
	Если  Объект.ДоговорСовместнойДеятельности Тогда
		ПараметрыФормы.Вставить("УчастникСРП", Объект.ДоговорСовместнойДеятельности);
	Иначе
		ПараметрыФормы.Вставить("УчастникСРП", Объект.УчастникСРП);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("ТолькоПросмотр",                      ТолькоПросмотр);
	ПараметрыФормы.Вставить("ПоверенныйОператор",                  Объект.ПоверенныйОператор);
	ПараметрыФормы.Вставить("ДоговорСовместнойДеятельности",       Объект.ДоговорСовместнойДеятельности);
	ПараметрыФормы.Вставить("УчастникиСовместнойДеятельности",     Объект.УчастникиСовместнойДеятельности);
	ПараметрыФормы.Вставить("ИспользоватьКакПоверенногоОператора", Истина);
	
	ОткрытьФорму("ОбщаяФорма.ФормаУчастникиСовместнойДеятельности", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаВзаиморасчетовПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства


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
	
	УстановитьПараметрыВыбораВидаДоговора(ЭтаФорма);
	
	ОбщегоНазначенияБКВызовСервера.АктивизироватьЭлементФормы(ЭтаФорма, "Наименование");
	
	ОбновитьПредставлениеЭлемента("УсловияПоставки");
	
	ИспользоватьЭлектронныеАВР = ПолучитьФункциональнуюОпцию("ИспользоватьЭлектронныеАВР");
	Если ИспользоватьЭлектронныеАВР Тогда  		
	 	Элементы.СпособВыпискиАктовВыполненныхРабот.СписокВыбора.Вставить(1, Перечисления.СпособыВыпискиАктовВыполненныхРабот.НаПорталеИСЭСФ);
	КонецЕсли;
	
	Элементы.ТипЦен.Видимость = ПравоДоступа("Чтение", Метаданные.Справочники.ТипыЦенНоменклатуры);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрыВыбораВидаДоговора(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	НовыеПараметры = Новый Массив();

	СписокВидовДоговоров = Новый Массив;
	Если НЕ ЗначениеЗаполнено(Объект.Владелец) Тогда
		СписокВидовДоговоров.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.Прочее"));
	Иначе
		СписокВидовДоговоров.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком"));
		СписокВидовДоговоров.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПокупателем"));
		СписокВидовДоговоров.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.Прочее"));
	КонецЕсли;
	НовыеПараметры.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СписокВидовДоговоров)));

	Элементы.ВидДоговора.ПараметрыВыбора = Новый ФиксированныйМассив(НовыеПараметры);   
      
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Если Объект.УстановленСрокОплаты Тогда
		Элементы.УстановленСрокОплаты.Заголовок = НСтр("ru = 'Установлен срок оплаты по договору, дней:'");
	Иначе
		Элементы.УстановленСрокОплаты.Заголовок = НСтр("ru = 'Установлен срок оплаты по договору'");
	КонецЕсли; 
	
	Элементы.ДоговорСовместнойДеятельности.Доступность = Не Объект.УчастникСРП; 
	Элементы.УчастникСРП.Доступность                   = Не Объект.ДоговорСовместнойДеятельности;
	Элементы.ГруппаПроверенныйОператор.Видимость       = Объект.УчастникСРП ИЛИ Объект.ДоговорСовместнойДеятельности;
	
	Элементы.СрокОплаты.Видимость = Объект.УстановленСрокОплаты;
	Элементы.ГруппаУчастникиСовместнойДеятельности.Видимость = Объект.ДоговорСовместнойДеятельности ИЛИ Объект.УчастникСРП;
	
	Если Объект.ДоговорСовместнойДеятельности Тогда
		Элементы.ДекорацияУчастникиСовместнойДеятельности.Заголовок = НСтр("ru ='Участники совместной деятельности'");
	ИначеЕсли Объект.УчастникСРП Тогда
		Элементы.ДекорацияУчастникиСовместнойДеятельности.Заголовок = НСтр("ru ='Участники СРП'");
	КонецЕсли;
	 	
КонецПроцедуры 

&НаКлиенте
Процедура ПослеЗакрытияВопросаПриИзмененииДоговорСовместнойДеятельности(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет	Тогда
		Если Объект.ДоговорСовместнойДеятельности <> Истина Тогда
			Объект.ДоговорСовместнойДеятельности = Истина;
		КонецЕсли;
	Иначе 
		Объект.УчастникиСовместнойДеятельности.Очистить();
		Объект.ПоверенныйОператор = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
	КонецЕсли;

	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаПриИзмененииУчастникаСРП(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет	Тогда
		Если Объект.УчастникСРП <> Истина Тогда
			Объект.УчастникСРП = Истина;
		КонецЕсли;
	Иначе 
		Объект.УчастникиСовместнойДеятельности.Очистить();
		Объект.ПоверенныйОператор = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
	КонецЕсли;

	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановленСрокОплатыПриИзмененииНаСервере()
	
	Если Объект.УстановленСрокОплаты Тогда
		
		Если Объект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПокупателем Тогда
		    Объект.СрокОплаты = Константы.СрокОплатыПокупателей.Получить();
		ИначеЕсли Объект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком Тогда
		    Объект.СрокОплаты = Константы.СрокОплатыПоставщикам.Получить();
		КонецЕсли;   		
	Иначе
		Объект.СрокОплаты = 0;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ОбновитьПредставлениеЭлемента(ИмяОбновляемогоЭлемента)
	
	Если ИмяОбновляемогоЭлемента = "УсловияПоставки" Тогда
		
		Если ПустаяСтрока(Объект.УсловияПоставки) Тогда
			Элементы.ДекорацияРасшифровкаУсловияПоставки.Заголовок = НСтр("ru ='<не указано>'");
		Иначе
			
			Если МакетКодовСтрокУсловияПоставки.ВысотаТаблицы = 0 Тогда
				МакетКодовСтрокУсловияПоставки = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_УсловияПоставки");
				МакетКодовСтрокУсловияПоставки.КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
			КонецЕсли;
			
			ОбластьСтрок = МакетКодовСтрокУсловияПоставки.Области.Найти("Классификатор");
			
			НаименованиеСтроки = РегламентированнаяОтчетность.ПолучитьНаименованиеСтрокиКлассификатораПоКоду(МакетКодовСтрокУсловияПоставки, ОбластьСтрок, Объект.УсловияПоставки);
			
			Если ПустаяСтрока(НаименованиеСтроки) Тогда
				Элементы.ДекорацияРасшифровкаУсловияПоставки.Заголовок = СтрШаблон(НСтр("ru ='строка с кодом %1 не найдена.'"), СокрЛП(Объект.УсловияПоставки));
			Иначе
				Элементы.ДекорацияРасшифровкаУсловияПоставки.Заголовок = НаименованиеСтроки;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
    УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
    УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
    УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
	УправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства 

