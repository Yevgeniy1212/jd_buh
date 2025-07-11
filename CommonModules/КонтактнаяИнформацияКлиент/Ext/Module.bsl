﻿////////////////////////////////////////////////////////////////////////////////
// КонтактнаяИнформация: содержит алгоритмы работы с контактной информацией, 
//   исполняемые на клиенте
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Чтение и запись контактной информации

// Обработчик события "ПередУдалением" табличного поля набора записей.
//
// Параметры:
//  Элемент - Табличное поле
//  Отказ - Булево
//
Процедура УдалитьЗаписьКонтактнойИнформации(Элемент, Отказ) Экспорт

КонецПроцедуры // УдалитьЗаписьКонтактнойИнформации()

// Редактирование контактной информации

// Процедура инициирует редактирование записи.
// 
// Параметры:
//  СтруктураЗаписи - Структура, НаборЗаписейРегистраСведений, МенеджерЗаписи, ЗаписьНабораЗаписей -
//                    Данные для редактирования
//  Записывать      - Булево, Записывать данные в ИД при окончании редактирования
//  ВладелецФормы   - Форма, откуда вызывается редактирование
//  СтруктураПредустановленныхЗначений - Структура - данные для заполнения формы по умолчанию,
//                    могут отличаться от редактируемых, например при копировании
Процедура ОткрытьФормуРедактированияЗаписиРегистра(СтруктураЗаписи = Неопределено, Записывать = Ложь, ВладелецФормы = Неопределено, СтруктураПредустановленныхЗначений = Неопределено, ДоступностьОбъекта = Ложь, ИмяПроцедурыОписанияОповещения = "ПослеЗакрытияФормыРедактированияЗаписиКИ") Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗаписыватьВРегистр", Записывать);
	ПараметрыФормы.Вставить("ДоступностьОбъекта", ДоступностьОбъекта);
	
	ТипКИ = Неопределено;
	Если ТипЗнч(СтруктураЗаписи) = Тип("ДанныеФормыЭлементКоллекции")
	 ИЛИ ТипЗнч(СтруктураЗаписи) = Тип("ДанныеФормыСтруктура")Тогда
		ЛокальнаяСтруктураЗаписи = КонтактнаяИнформацияКлиентСервер.ПолучитьСтруктуруЗаписиРегистра(СтруктураЗаписи);
		ТипКИ = СтруктураЗаписи.Тип;
		ПараметрыФормы.Вставить("РедактируетсяНаборЗаписей", Ложь);
	ИначеЕсли ТипЗнч(СтруктураЗаписи) = Тип("ДанныеФормыСтруктураСКоллекцией")
		ИЛИ ТипЗнч(СтруктураЗаписи) = Тип("ДинамическийСписок") Тогда
		// Значит вводим нового
		ПараметрыФормы.Вставить("РедактируетсяНаборЗаписей", Истина);
		Если ТипЗнч(СтруктураЗаписи) = Тип("ДанныеФормыСтруктураСКоллекцией") И СтруктураЗаписи.Отбор.Объект.Использование = Истина И СтруктураЗаписи.Отбор.Объект.Значение <> Неопределено Тогда
			ЛокальнаяСтруктураЗаписи = Новый Структура("Объект", СтруктураЗаписи.Отбор.Объект.Значение);
		ИначеЕсли ТипЗнч(СтруктураЗаписи) = Тип("ДинамическийСписок") И СтруктураЗаписи.Отбор.Элементы.Количество() <> 0 Тогда
			СписокПолей = Новый Массив();
			СписокПолей.Добавить("Объект");
			СписокОтбораПоОбъекту = БухгалтерскиеОтчетыКлиентСервер.НайтиЭлементыОтбора(СтруктураЗаписи.Отбор, СписокПолей, Истина);
			Если СписокОтбораПоОбъекту.Количество() = 1 Тогда
				ЛокальнаяСтруктураЗаписи = Новый Структура("Объект", СписокОтбораПоОбъекту[0].ПравоеЗначение);
			КонецЕсли;
		ИначеЕсли ТипЗнч(СтруктураПредустановленныхЗначений) = Тип("Структура") Тогда
			ПараметрыФормы.Вставить("РедактируемаяЗапись", СтруктураПредустановленныхЗначений);
		КонецЕсли; 
	ИначеЕсли ТипЗнч(СтруктураЗаписи) = Тип("Структура") Тогда
		ЛокальнаяСтруктураЗаписи = СтруктураЗаписи;
		ТипКИ = СтруктураЗаписи.Тип;
		ПараметрыФормы.Вставить("РедактируетсяНаборЗаписей", Ложь);
	КонецЕсли;
	
	Если СтруктураПредустановленныхЗначений <> Неопределено Тогда
		ЛокальнаяСтруктураЗаписи = СтруктураПредустановленныхЗначений;
	КонецЕсли; 
	
	ПараметрыФормы.Вставить("ЛокальнаяСтруктураЗаписи", ЛокальнаяСтруктураЗаписи);
	
	Если НЕ ЗначениеЗаполнено(ТипКИ) Тогда
	
		СписокТиповКИ = Новый СписокЗначений();

		СписокТиповКИ.ЗагрузитьЗначения(КонтактнаяИнформацияКлиентСерверПовтИсп.МассивТиповКонтактнойИнформации());
		
		ДополнительныеПараметры = Новый Структура("СтруктураЗаписи, ВладелецФормы, ПараметрыФормы, ИмяПроцедурыОписанияОповещения", СтруктураЗаписи, ВладелецФормы, ПараметрыФормы, ИмяПроцедурыОписанияОповещения);
		ОписаниеОповещенияВыбораТипаКИ = Новый ОписаниеОповещения("ПослеВыбораТипаКонтакнойИнформацииПриОткрытииФормыРедактированияКИ", КонтактнаяИнформацияКлиент.ЭтотОбъект, ДополнительныеПараметры);
		
		СписокТиповКИ.ПоказатьВыборЭлемента(ОписаниеОповещенияВыбораТипаКИ, НСтр("ru = 'Выберите тип контактной информации'"));

		Возврат;
	КонецЕсли;
	
	ПараметрыФормы.Вставить("ТипКИ", ТипКИ);
	
	ОткрытьФормуРедактированияЗаписиРегистраПродолжение(
		СтруктураЗаписи,
		ВладелецФормы,
		ПараметрыФормы,
		ИмяПроцедурыОписанияОповещения);

КонецПроцедуры

Процедура НачалоВыбораЭлементаАдреса(Элемент, КодЧастиАдреса, ЧастиАдреса, Параметры = Неопределено) Экспорт
	
	КодРеквизита = ВРег(КодЧастиАдреса);
	Если КодРеквизита = "ОБЛАСТЬ" Тогда
		Уровень = 1;
		
	ИначеЕсли КодРеквизита = "РАЙОН" Тогда
		Уровень = 2;
		
	ИначеЕсли КодРеквизита = "ГОРОД" Тогда
		Уровень = 3;
		
	ИначеЕсли КодРеквизита = "НАСЕЛЕННЫЙПУНКТ" Тогда
		Уровень = 4;
		
	ИначеЕсли КодРеквизита = "УЛИЦА" Тогда
		Уровень = 5;
		
	Иначе
		Возврат;
		
	КонецЕсли;
	
	ПараметрыФормы = ?(Параметры = Неопределено, Новый Структура, Параметры);
	
	ПараметрыФормы.Вставить("Область", ЧастиАдреса.Область.Значение);
	Если ЧастиАдреса.Область.Свойство("КодКлассификатора") Тогда
		ПараметрыФормы.Вставить("ОбластьКодКлассификатора", ЧастиАдреса.Область.КодКлассификатора);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("Район", ЧастиАдреса.Район.Значение);
	Если ЧастиАдреса.Район.Свойство("КодКлассификатора") Тогда
		ПараметрыФормы.Вставить("РайонКодКлассификатора", ЧастиАдреса.Район.КодКлассификатора);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("Город", ЧастиАдреса.Город.Значение);
	Если ЧастиАдреса.Город.Свойство("КодКлассификатора") Тогда
		ПараметрыФормы.Вставить("ГородКодКлассификатора", ЧастиАдреса.Город.КодКлассификатора);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("НаселенныйПункт", ЧастиАдреса.НаселенныйПункт.Значение);
	Если ЧастиАдреса.НаселенныйПункт.Свойство("КодКлассификатора") Тогда
		ПараметрыФормы.Вставить("НаселенныйПунктКодКлассификатора", ЧастиАдреса.НаселенныйПункт.КодКлассификатора);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("Улица", ЧастиАдреса.Улица.Значение);
	Если ЧастиАдреса.Улица.Свойство("КодКлассификатора") Тогда
		ПараметрыФормы.Вставить("УлицаКодКлассификатора", ЧастиАдреса.Улица.КодКлассификатора);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("Уровень", Уровень);
	
	АдресныйКлассификаторКлиент.ОткрытьФормуВыбораКАТО(ПараметрыФормы, Элемент);
	
КонецПроцедуры

// Адресный классификатор

//Предлагает загрузить адресный классификатор
//
//  Параметры:
//      Текст  - Строка        - Дополнительный текст предложения
//      Область - Число, Строка - Код или название региона для загрузки
//
Процедура ПредложениеЗагрузкиКлассификатора(Знач Текст = "", Знач Область = Неопределено) Экспорт
	
	ТипПараметраРегиона = ТипЗнч(Область);
	ПараметрыЗагрузки   = Новый Структура;
	
	Если ТипПараметраРегиона = Тип("Число") Тогда
		ПараметрыЗагрузки.Вставить("КодОбластиДляЗагрузки", Область);
		
	ИначеЕсли ТипПараметраРегиона = Тип("Строка") Тогда
		ПараметрыЗагрузки.Вставить("НазваниеОбластиДляЗагрузки", Область);
		
	КонецЕсли;
	
	ТекстЗаголовка = НСтр("ru = 'Подтверждение'");
	ТекстВопроса   = СокрЛП(Текст + Символы.ПС + НСтр("ru = 'Загрузить классификатор сейчас?'") );

	Оповещение = Новый ОписаниеОповещения("ПредложениеЗагрузкиКлассификатораЗавершение", ЭтотОбъект, ПараметрыЗагрузки);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,ТекстЗаголовка);
	
КонецПроцедуры

Процедура ПредложениеЗагрузкиКлассификатораЗавершение(Знач РезультатВопроса, Знач ДополнительныеПараметры) Экспорт
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	АдресныйКлассификаторКлиент.ЗагрузитьАдресныйКлассификатор(ДополнительныеПараметры);
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПослеВыбораТипаКонтакнойИнформацииПриОткрытииФормыРедактированияКИ(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры.ПараметрыФормы.Вставить("ТипКИ", Результат.Значение);
	
	ОткрытьФормуРедактированияЗаписиРегистраПродолжение(
		ДополнительныеПараметры.СтруктураЗаписи,
		ДополнительныеПараметры.ВладелецФормы,
		ДополнительныеПараметры.ПараметрыФормы,
		ДополнительныеПараметры.ИмяПроцедурыОписанияОповещения);

КонецПроцедуры

Процедура ОткрытьФормуРедактированияЗаписиРегистраПродолжение(СтруктураЗаписи, ВладелецФормы, ПараметрыФормы, ИмяПроцедурыОписанияОповещения)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(ИмяПроцедурыОписанияОповещения, ВладелецФормы);
	
	ОткрытьФорму(
		КонтактнаяИнформацияКлиентСерверПовтИсп.ПолучитьИмяФормыРедактированияЗаписи(ПараметрыФормы.ТипКИ),
		ПараметрыФормы,
		ВладелецФормы,
		,
		,
		,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры
