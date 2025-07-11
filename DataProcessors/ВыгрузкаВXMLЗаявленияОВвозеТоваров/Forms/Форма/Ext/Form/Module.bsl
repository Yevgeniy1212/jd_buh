﻿
////////////////////////////////////////////////////////////////////////////////
// Форма выполняет выгрузку данных документа "ЗаявлениеОВвозеТоваровИУплатеКосвенныхНалогов"
// в формате XML для последующего предоставления в налоговые органы.
//
// Параметры формы:
//  ДокументДляВыгрузки - ДокументСсылка.ЗаявлениеОВвозеТоваровИУплатеКосвенныхНалогов - Документ, данные которого необходимо выгрузить в XML
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ДокументДляВыгрузки") Тогда
		Объект.ДокументДляВыгрузки = Параметры.ДокументДляВыгрузки;
	КонецЕсли;
	
	Объект.РевизияВыгрузки        = Элементы.РевизияВыгрузки.СписокВыбора.Получить(Элементы.РевизияВыгрузки.СписокВыбора.Количество() - 1).Значение;
	Объект.ОкруглятьИтоговыеСуммы = Истина;
	ВерсияФНО                     = "328.00."+СтрЗаменить(Объект.РевизияВыгрузки,"_",".");
		
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Элементы.РевизияВыгрузки.СписокВыбора.НайтиПоЗначению(Настройки.Получить("Объект.РевизияВыгрузки")) = Неопределено Тогда
		РевизияВыгрузки        = Элементы.РевизияВыгрузки.СписокВыбора.Получить(Элементы.РевизияВыгрузки.СписокВыбора.Количество() - 1);
		Объект.РевизияВыгрузки = РевизияВыгрузки.Значение;
	КонецЕсли;
	ВерсияФНО = "328.00."+СтрЗаменить(Объект.РевизияВыгрузки,"_",".");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ ЗначениеЗаполнено(Объект.ДокументДляВыгрузки) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Обработка предназначена для служебного использования'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	НачатьПодключениеРасширенияРаботыСФайлами(Новый ОписаниеОповещения("ПодключениеРасширенияРаботыСФайламиЗавершение", ЭтотОбъект));
	
	Если РаботаСФайламиСлужебныйКлиент.РасширениеРаботыСФайламиПодключено() Тогда
		Если НЕ ЗначениеЗаполнено(Объект.ФайлВыгрузки) Тогда
			КаталогВыгрузки = РаботаСФайламиСлужебныйКлиент.КаталогВыгрузки();
			Если КаталогВыгрузки = Неопределено Тогда 
				Объект.ФайлВыгрузки = "";
			Иначе
				Объект.ФайлВыгрузки = РаботаСФайламиСлужебныйКлиент.КаталогВыгрузки() + "328.xml";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПодключениеРасширенияРаботыСФайламиЗавершение(Подключено, ДополнительныеПараметры) Экспорт
	
	ВозможностьВыбораФайлов = Подключено;
	
	Если НЕ ВозможностьВыбораФайлов Тогда
		ПодключитьОбработчикОжидания("Подключаемый_УстановкаРасширенияРаботыСФайлами", 0.1, Истина);
	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ФайлВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПозицияНачалоИмяФайла = СтрНайти(Объект.ФайлВыгрузки,"\",НаправлениеПоиска.СКонца);
	ИмяФайла = Сред(Объект.ФайлВыгрузки, ПозицияНачалоИмяФайла + 1);
	ПолныйКаталогВыгрузки = Лев(Объект.ФайлВыгрузки,ПозицияНачалоИмяФайла);

	ДиалогВыбораФайлВыгрузки = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайлВыгрузки.Заголовок      = НСтр("ru = 'Выберите файл'");
	
	ДиалогВыбораФайлВыгрузки.ПолноеИмяФайла = ИмяФайла;
	ДиалогВыбораФайлВыгрузки.Каталог        = ПолныйКаталогВыгрузки;
	
	ДиалогВыбораФайлВыгрузки.Фильтр         = "*.xml|*.xml|" + НСтр("ru = 'Все файлы'") + "(*.*)|*.*";
	ДиалогВыбораФайлВыгрузки.Расширение     = "xml";
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборФайлаДляВыгрузкиЗавершение", ЭтотОбъект);
	ДиалогВыбораФайлВыгрузки.Показать(ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаДляВыгрузкиЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено
		И ВыбранныеФайлы.Количество()>0 Тогда
		
		Объект.ФайлВыгрузки = ВыбранныеФайлы.Получить(0);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлВыгрузкиОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения;
	НачатьЗапускПриложения(Оповещение, Объект.ФайлВыгрузки);

КонецПроцедуры

&НаКлиенте
Процедура РевизияВыгрузкиПриИзменении(Элемент)
	
	ВерсияФНО = "328.00."+СтрЗаменить(Объект.РевизияВыгрузки,"_",".");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выгрузить(Команда)
	
	Отказ = Ложь;
	
	Если ВозможностьВыбораФайлов Тогда
		Если НЕ ЗначениеЗаполнено(Объект.ФайлВыгрузки) Тогда
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения(,, НСтр("ru = 'Файл выгрузки'"));
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				ТекстСообщения,
				,
				"ФайлВыгрузки",
				"Объект",
				Отказ);
		КонецЕсли;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.РевизияВыгрузки) Тогда
		ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения(,, НСтр("ru = 'Ревизия выгрузки'"));
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			ТекстСообщения,
			,
			"РевизияВыгрузки",
			"Объект",
			Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Выгрузка данных документа в формат XML'"));
	
	ВыгрузитьОтчетВXMLДляСОНОНаКлиенте();
	
	Если НЕ НеВыдаватьСообщениеОЗавершенииВыгрузки Тогда
		ТекстСообщения = НСтр("ru = 'Если Вы планируете сдавать отчет в электронной форме, 
						|Вам необходимо открыть данный файл в соответствующем 
						|программном обеспечении по вводу и передаче форм налоговой отчетности, 
						|предоставляемой налоговым комитетом, заполнить недостающие данные 
						|и ОБЯЗАТЕЛЬНО сохранить его в этой программе!'");
						
		ПараметрыВопроса = СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю();
		ПараметрыВопроса.Вставить("Заголовок", НСтр("ru = 'Выгрузка данных в файл завершена'"));
		ПараметрыВопроса.Вставить("Картинка", БиблиотекаКартинок.Информация32);
		ПараметрыВопроса.Вставить("ТекстФлажка", НСтр("ru = 'Больше не показывать это сообщение'"));
		
		ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("ПослеЗакрытияПредупрежденияЗавершениеВыгрузки", ЭтотОбъект);
		СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(
			ОписаниеОповещенияОЗавершении,
			ТекстСообщения,
			РежимДиалогаВопрос.ОК,
			ПараметрыВопроса
		);
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ВыгрузитьОтчетВXMLДляСОНОНаКлиенте()
	
	УИДЗамера = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Ложь, "Обработка ""выгрузка в xml заявления о ввозе товаров");
	
	АдресФайлаВоВременномХранилище = ВыгрузитьОтчетВXMLДляСОНОНаСервере();
	
	ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(УИДЗамера);
	
	Если ВозможностьВыбораФайлов Тогда
			
		ПередаваемыеФайлы = Новый Массив;
		ПереданныеФайлы   = Новый Массив;
		МассивВызовов     = Новый Массив;
		
		ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(Объект.ФайлВыгрузки, АдресФайлаВоВременномХранилище);
		
		ПередаваемыеФайлы.Добавить(ОписаниеФайла);
			
		МассивВызовов.Добавить(Новый Массив);
		
		МассивВызовов[0].Добавить("ПолучитьФайлы");
		МассивВызовов[0].Добавить(ПередаваемыеФайлы);
		МассивВызовов[0].Добавить(ПереданныеФайлы);
		МассивВызовов[0].Добавить("");
		МассивВызовов[0].Добавить(Ложь);
		
		НачатьЗапросРазрешенияПользователя(Новый ОписаниеОповещения("ПолучениеФайловЗавершение", ЭтотОбъект, Новый Структура("ПередаваемыеФайлы", ПередаваемыеФайлы)), МассивВызовов);		
			
	Иначе
		
		Попытка 			
			
			ПолучитьФайл(АдресФайлаВоВременномХранилище, "328.xml", Истина);
				
		Исключение
			
			ШаблонСообщения = НСтр("ru = 'При записи файла возникла ошибка
			|%1'");
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучениеФайловЗавершение(РазрешенияПолучены, ДополнительныеПараметры) Экспорт
	
	ПередаваемыеФайлы     = ДополнительныеПараметры.ПередаваемыеФайлы;

	Если РазрешенияПолучены Тогда			
		НачатьПолучениеФайлов(Новый ОписаниеОповещения("ВыгрузитьЗавершение", ЭтотОбъект, Новый Структура("ПередаваемыеФайлы", ПередаваемыеФайлы)), ПередаваемыеФайлы, Объект.ФайлВыгрузки, Ложь);   			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьЗавершение(ПолученныеФайлы, ДополнительныеПараметры) Экспорт
	
	ПередаваемыеФайлы     = ДополнительныеПараметры.ПередаваемыеФайлы;
	
	ФайлВыгрузки = Объект.ФайлВыгрузки;
	
	Если ПередаваемыеФайлы.Количество() > 0 Тогда
		ТекстСообщения = НСтр("ru = 'Данные успешно выгружены'");	
		#Если НЕ ВебКлиент Тогда
			НавигационнаяСсылка = "file://" + СтрЗаменить(СокрЛП(ФайлВыгрузки), "\", "/");
			ПоказатьОповещениеПользователя(ТекстСообщения, НавигационнаяСсылка, ФайлВыгрузки);
		#Иначе
			ПоказатьОповещениеПользователя(ТекстСообщения, , ФайлВыгрузки);
		#КонецЕсли  							
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВыгрузитьОтчетВXMLДляСОНОНаСервере()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Возврат ОбработкаОбъект.ВыгрузитьОтчетВXMLДляСОНО(Объект.ДокументДляВыгрузки, Объект.РевизияВыгрузки);
	
КонецФункции

&НаКлиенте
Процедура ПослеЗакрытияПредупрежденияЗавершениеВыгрузки(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		НеВыдаватьСообщениеОЗавершенииВыгрузки = Результат.БольшеНеЗадаватьЭтотВопрос;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УстановкаРасширенияРаботыСФайлами()
	
	ОповещениеПриОткрытии = Новый ОписаниеОповещения("УстановкаРасширенияРаботыСФайламиЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОповещениеПриОткрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановкаРасширенияРаботыСФайламиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВозможностьВыбораФайлов = Ложь;
	
	НачатьПодключениеРасширенияРаботыСФайлами(Новый ОписаниеОповещения("УстановкаРасширенияРаботыСФайламиЗавершениеЗавершение", ЭтотОбъект));
		
КонецПроцедуры

&НаКлиенте
Процедура УстановкаРасширенияРаботыСФайламиЗавершениеЗавершение(Подключено, ДополнительныеПараметры) Экспорт
	
	ВозможностьВыбораФайлов = Подключено;
	УстановитьВидимостьЭлементовВыбораФайлов();

КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьЭлементовВыбораФайлов()
	
	Элементы.ФайлВыгрузки.Видимость = ВозможностьВыбораФайлов;
		
КонецПроцедуры
