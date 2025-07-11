﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыВиртуальныхСкладов.НеСозданВС");
	КонецЕсли;
	
	ОтборСоответствиеВиртуальныхСкладов();	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура ОтборСоответствиеВиртуальныхСкладов()
	
	ЭлементОтбора = СоответствиеВиртуальныхСкладов.Отбор.Элементы;
    ЭлементОтбора.Очистить();
    ЭлементОтбора = СоответствиеВиртуальныхСкладов.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
    ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВиртуальныйСклад");
    ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
    ЭлементОтбора.Использование = Истина;
    ЭлементОтбора.ПравоеЗначение = Объект.Ссылка;
	
КонецПроцедуры

&НаКлиенте
Процедура СоответствиеВиртуальныхСкладовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)

	ЭтоНовыйДокумент = ПроверитьВозможностьСозданияСоответствия();
	
	Если ЭтоНовыйДокумент Тогда
		Отказ = Истина;
	Иначе
		Отказ = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьВозможностьСозданияСоответствия()
	
	ЭтоНовый = Ложь;
	
	Если Объект.Ссылка.Пустая() Тогда          
		ТекстСообщения = НСтр("ru = 'Перед созданием нового соответствия необходимо записать элемент и переоткрыть форму!'");
		ЭСФКлиентСерверПереопределяемый.СообщитьПользователю(ТекстСообщения);
		ЭтоНовый = Истина;
	КонецЕсли;
	
	Если НЕ Объект.Ссылка.Пустая() И Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыВиртуальныхСкладов.Неактивен") Тогда          
		ТекстСообщения = НСтр("ru = 'Нельзя создать соответствие виртуального склада со статусом ""Не действует в ИС ЭСФ""'");
		ЭСФКлиентСерверПереопределяемый.СообщитьПользователю(ТекстСообщения);
		ЭтоНовый = Истина;
	КонецЕсли;
	
	Возврат ЭтоНовый;
	
КонецФункции

&НаСервере
Процедура УправлениеФормой()
	
	Если Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыВиртуальныхСкладов.Активен") Тогда
		Элементы.КнопкаСменитьСтатус.Видимость = Истина;
		Элементы.КнопкаСменитьСтатус.Заголовок = НСтр("ru = 'Закрыть склад'");
		Элементы.КнопкаСоздатьВиртуальныйСклад.Видимость = Ложь;
		Элементы.ЯвляетсяСкладомПоУмолчанию.ТолькоПросмотр = Истина;
		Элементы.ПризнакОприходования.ТолькоПросмотр = Истина;
	ИначеЕсли
		Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыВиртуальныхСкладов.Неактивен") Тогда
		Элементы.КнопкаСменитьСтатус.Видимость = Истина;
		Элементы.КнопкаСменитьСтатус.Заголовок = НСтр("ru = 'Восстановить склад'");
		Элементы.КнопкаСоздатьВиртуальныйСклад.Видимость = Ложь;
		Элементы.ЯвляетсяСкладомПоУмолчанию.ТолькоПросмотр = Истина;
		Элементы.ПризнакОприходования.ТолькоПросмотр = Истина;
	Иначе
		Элементы.КнопкаСменитьСтатус.Видимость = Ложь;
		Элементы.КнопкаСоздатьВиртуальныйСклад.Видимость = Истина;
	КонецЕсли;
	
	Элементы.СкладДляЛизинга.Видимость = ВССервер.ИспользоватьСНТ(); 
	Элементы.ГруппаЛизингополучатель.Видимость = ВССервер.ИспользоватьСНТ() И Объект.СкладДляЛизинга; 
	
	ОбновитьПредставлениеСтатусВС();
				
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = ВСКлиентСервер.ИмяСобытияЗаписьВС() Тогда
		
		Если Параметры.Ключ.Пустая() Тогда
			УправлениеФормой();	
		Иначе
			ЭтаФорма.Прочитать();	
			УправлениеФормой();
		КонецЕсли;	
	Конецесли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеСтатуса()
	
	   УправлениеФормой();
	   
КонецПроцедуры
   
// Обновляет представление статуса виртуального склада в форме виртуального склада.
&НаСервере
Процедура ОбновитьПредставлениеСтатусВС()
			
	Элементы.Статус.ЦветТекста = ВСКлиентСервер.ЦветСтатусВС(Объект.Статус);
			
КонецПроцедуры

&НаКлиенте
Процедура СкладДляЛизингаПриИзменении(Элемент)
	
	УправлениеФормой();

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

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры
