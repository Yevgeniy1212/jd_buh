﻿#Область ОтправкаФормВС
	
Функция ПроверитьВозможностьОтправкиДокументовЭДВС(МассивЭДВС, ДополнительныеПараметры) Экспорт
	
	Возврат ВССервер.ПроверитьВозможностьОтправкиДокументовЭДВС(МассивЭДВС, ДополнительныеПараметры);
	
КонецФункции

Функция ПроверитьНаличиеТоваровВиртуальногоСклада(МассивЭДВС, ДополнительныеПараметры) Экспорт
	
	Возврат ВССервер.ПроверитьНаличиеТоваровВиртуальногоСклада(МассивЭДВС, ДополнительныеПараметры);	
	
КонецФункции

// См. ЭСФСервер.СоздатьИсходящиеInvoice()
Процедура СоздатьИсходящиеUForm(Знач МассивЭД, Знач УстанавливатьПодпись, Знач ТипПодписи, АдресКоллекцииInvoiceXML, КоллекцияSignedContentXML, ВерсияВС = "1") Экспорт
	
	КоллекцияInvoiceXML = Неопределено;                                               
	ВССервер.СоздатьИсходящиеUForm(МассивЭД, УстанавливатьПодпись, ТипПодписи, КоллекцияInvoiceXML, КоллекцияSignedContentXML, ВерсияВС);
	
	// После того, как переменная АдресКоллекцииInvoiceXML станет не нужна, 
	// необходимо самостоятельно очистить временное хранилище,
	// иначе значение будет удалено только после перезапуска сервера.
	АдресКоллекцииInvoiceXML = ПоместитьВоВременноеХранилище(КоллекцияInvoiceXML, Новый УникальныйИдентификатор);
	
КонецПроцедуры

Функция ОтправитьИсходящиеUTTN(ВерсияВС, Знач КоллекцияДанныеКоллекцииUttnXML, Знач КоллекцияПодписей, Знач ДанныеПрофилейИСЭСФ) Экспорт
	
	Результат = ВССервер.ОтправитьИсходящиеUTTN(ВерсияВС, КоллекцияДанныеКоллекцииUttnXML, КоллекцияПодписей, ДанныеПрофилейИСЭСФ);
	
КонецФункции

Функция ОтправитьИсходящиеUTTNВФоне(Знач ПараметрыВыгрузки, Знач АдресХранилища) Экспорт

	Результат = ОтправитьИсходящиеUTTN(
					ПараметрыВыгрузки.ВерсияВС, 
					ПараметрыВыгрузки.КоллекцияСоответствиеЭД, 
					ПараметрыВыгрузки.КоллекцияПодписейЭД, 
					ПараметрыВыгрузки.ДанныеПрофилейИСЭСФ 
					);
	
	Возврат Результат;
	
КонецФункции

Функция СоздатьИОтправитьКоллекциюUForm(КоллекцияСгруппированныхЭД, ДанныеПрофилейИСЭСФ, ДополнительныеПараметры, ВерсияВС) Экспорт

	КоллекцияПодписейИСЭСФ = Новый Соответствие;
	КоллекцияАдресКоллекцииUformXML = Новый Соответствие;
	КоллекцияСоответствиеЭД = Новый Соответствие;
	ЗапускатьФоновоеЗадание =  ДополнительныеПараметры.ЗапускатьФоновоеЗадание;
		
	Для Каждого СгруппированныеЭД Из КоллекцияСгруппированныхЭД Цикл
		
		СтруктурнаяЕдиница = СгруппированныеЭД.Ключ;
		МассивЭД = СгруппированныеЭД.Значение;
		
		ДанныеКлючаЭЦП = ДанныеПрофилейИСЭСФ.Получить(СтруктурнаяЕдиница);
		
		ДанныеПрофиляИСЭСФ = ЭСФВызовСервера.ДанныеПрофиляИСЭСФ(ДанныеКлючаЭЦП.ПрофильИСЭСФ);

		АдресКоллекцииUformXML = Неопределено;
		КоллекцияSignedContentXML = Неопределено;
		
		ТипПодписиЭСФ = ЭСФКлиентСервер.ТипПодписиЭСФ(ДанныеКлючаЭЦП, ДанныеПрофиляИСЭСФ);
		
		СоздатьИсходящиеUForm(МассивЭД, Истина, ТипПодписиЭСФ, АдресКоллекцииUformXML, КоллекцияSignedContentXML, ВерсияВС);
		
		КоллекцияПодписей = ЭСФКлиентСервер.НоваяКоллекцияПодписейЭСФ(КоллекцияSignedContentXML, ДанныеКлючаЭЦП, ДанныеПрофиляИСЭСФ);
		
		Если КоллекцияПодписей.Количество() = 0 Тогда
			ТекстОшибки = НСтр("ru='Не удалось выполнить подпись документов.'");
			ЭСФКлиентСерверПереопределяемый.СообщитьПользователю(ТекстОшибки);
			Возврат Неопределено;
		КонецЕсли;
		
		СоответствиеЭД = ПолучитьИзВременногоХранилища(АдресКоллекцииUformXML);
		
		КоллекцияСоответствиеЭД.Вставить(СтруктурнаяЕдиница, СоответствиеЭД);
		КоллекцияПодписейИСЭСФ.Вставить(СтруктурнаяЕдиница, КоллекцияПодписей);
		КоллекцияАдресКоллекцииUformXML.Вставить(СтруктурнаяЕдиница, АдресКоллекцииUformXML);
		
	КонецЦикла;
	
	Если ЗапускатьФоновоеЗадание Тогда
		
		КлючФоновогоЗадания = Новый УникальныйИдентификатор;
		
		ПараметрыЗадания = Новый Структура("ВерсияВС, КоллекцияСоответствиеЭД, КоллекцияПодписейЭД, ДанныеПрофилейИСЭСФ", ВерсияВС, КоллекцияСоответствиеЭД, КоллекцияПодписейИСЭСФ, ДанныеПрофилейИСЭСФ);
		ПараметрыВыполнения = ЭСФКлиентСерверПереопределяемый.ПараметрыВыполненияВФоне();
		ПараметрыВыполнения.КлючФоновогоЗадания = КлючФоновогоЗадания;
		
		РезультатОтправки = ЭСФСерверПереопределяемый.ВыполнитьВФоне("ВСВызовСервера.ОтправитьИсходящиеUTTNВФоне", ПараметрыЗадания, ПараметрыВыполнения);

	Иначе
	
		Результат = ОтправитьИсходящиеUTTN(
					ВерсияВС,
					КоллекцияАдресКоллекцииUformXML, 
					КоллекцияПодписейИСЭСФ, 
					ДанныеПрофилейИСЭСФ
					);
	
			
	КонецЕсли;
	
	// Принудительное удаление, иначе значение не удалится.
	УдалитьИзВременногоХранилища(АдресКоллекцииUformXML);

	Возврат РезультатОтправки;
		
КонецФункции

#КонецОбласти 

#Область ВыгрузкаФормВXML

// См. Обработка.ОбменЭСФ.СоздатьXMLДляИмпортаВВС()
Функция СоздатьXMLДляИмпортаВВС(Знач МассивЭДВС) Экспорт
	
	Возврат ЭСФСерверПовтИсп.ОбработкаОбменЭСФ().СоздатьXMLДляИмпортаВВС(МассивЭДВС);
	
КонецФункции

#КонецОбласти 

#Область РаботаССессиями

// См. ВССервер.ПроверитьДоступИВерсиюВСНаСервере
Функция ПроверитьДоступИВерсиюВСНаСервере() Экспорт
	Возврат ВССервер.ПроверитьДоступИВерсиюВСНаСервере();	
КонецФункции

// См. ВССервер.ОткрытьСессию
Функция ОткрытьСессию(Знач ПрофильИСЭСФ, ВерсияВС = Неопределено) Экспорт
	Возврат ВССервер.ОткрытьСессию(ПрофильИСЭСФ, ВерсияВС);	
КонецФункции

// См. ВССервер.ОткрытьСессиюСПодписью
Функция ОткрытьСессиюСПодписью(Знач ПрофильИСЭСФ, ВерсияВС = Неопределено, ПодписанныйАвторизационныйТикет) Экспорт
	Возврат ВССервер.ОткрытьСессиюСПодписью(ПрофильИСЭСФ, ВерсияВС, ПодписанныйАвторизационныйТикет);	
КонецФункции

Функция ОткрытьСессиюСПодписьюПредварительно(Знач ПрофильИСЭСФ,ПараметрыОткрытияСессии) Экспорт
	
	Возврат ВССервер.ОткрытьСессиюСПодписьюПредварительно(ПрофильИСЭСФ, ПараметрыОткрытияСессии);
	
КонецФункции

Функция ПолучитьАвторизационныйТикет(Знач ПрофильИСЭСФ, ВерсияИСЭСФ = Неопределено) Экспорт
	
	Возврат ВССервер.ПолучитьАвторизационныйТикет(ПрофильИСЭСФ, ВерсияИСЭСФ);

КонецФункции

Функция ЗакрытьСессию(Знач ПрофильИСЭСФ, Знач ИдентификаторСессии, ВерсияВС = Неопределено) Экспорт
	ВССервер.ЗакрытьСессию(ПрофильИСЭСФ, ИдентификаторСессии, ВерсияВС);
КонецФункции

#КонецОбласти 

#Область ПолучениеСозданиеСкладов

// См. ЭСФСервер.ПроверитьВозможностьОтправкиДокументовЭСФ()
//	 ВАЖНО! Массив изменяется внутрии функции, Знач не устанавливаем перед объявлением переменной
Процедура ПроверитьВозможностьСозданияСкладовПоставитьВОчередь(МассивВС, ДополнительныеПараметры) Экспорт
	
	ВССервер.ПроверитьВозможностьСозданияСкладовПоставитьВОчередь(МассивВС, ДополнительныеПараметры);
	
КонецПроцедуры
// См. ВССервер.ПолучитьСклады
Функция ПолучитьСклады(Знач ПрофильИСЭСФ, ВерсияВС = Неопределено) Экспорт
	Возврат ВССервер.ПолучитьСклады(ПрофильИСЭСФ, ВерсияВС);
КонецФункции

Процедура ОбновитьСтатусВСПоИдентификатору(Знач СтруктураВС, Знач ДанныеПрофилейИСЭСФ) Экспорт
	
		ДанныеСтруктурнойЕдиницы = ДанныеПрофилейИСЭСФ.Получить(СтруктураВС.СтруктурнаяЕдиница);
		
		ДанныеПрофиляИСЭСФ = ЭСФСервер.ДанныеПрофиляИСЭСФ(ДанныеСтруктурнойЕдиницы.ПрофильИСЭСФ);
		
		ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации = ДанныеСтруктурнойЕдиницы.ПарольИСЭСФ;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВиртуальныеСклады.ИдентификаторСклада КАК Идентификатор,
		|	ВиртуальныеСклады.Статус КАК Статус
		|ИЗ
		|	Справочник.ВиртуальныеСклады КАК ВиртуальныеСклады
		|ГДЕ
		|	ВиртуальныеСклады.Ссылка  = &ВС";	
		Запрос.УстановитьПараметр("ВС", СтруктураВС.ВС);	
		Выборка = Запрос.Выполнить().Выбрать();	
				
		ИдентификаторСтатус = Новый Структура;
				
		Если Выборка.Следующий() Тогда
				ИдентификаторСтатус.Вставить("Идентификатор", Выборка.Идентификатор);
				ИдентификаторСтатус.Вставить("Статус", Выборка.Статус);
				ИдентификаторСтатус.Вставить("Ссылка", СтруктураВС.ВС);
		КонецЕсли;
		
		ИдентификаторСессии = ВССервер.ОткрытьСессию(ДанныеПрофиляИСЭСФ);
		
		ВССервер.ОбновитьСтатусВСПоИдентификатору(ИдентификаторСтатус, ДанныеПрофиляИСЭСФ, ИдентификаторСессии);
		
		ВССервер.ЗакрытьСессию(ДанныеПрофиляИСЭСФ, ИдентификаторСессии);
				
КонецПроцедуры

Процедура СоздатьВСВФоне(Знач ПараметрыВыгрузки, Знач АдресХранилища) Экспорт
	
	СоздатьВС (ПараметрыВыгрузки.КоллекцияСгруппированныхВС, ПараметрыВыгрузки.ДанныеПрофилейИСЭСФ);
	
КонецПроцедуры

Процедура СоздатьВС(Знач КоллекцияСгруппированныхВС, Знач ДанныеПрофилейИСЭСФ) Экспорт
	
	ОбработкаОбменЭСФ = ЭСФСерверПовтИсп.ОбработкаОбменЭСФ();
	
	Для Каждого СгруппированныеВС Из КоллекцияСгруппированныхВС Цикл
		
		СтруктурнаяЕдиница = СгруппированныеВС.Ключ;
		СгруппированныйМассивВС = СгруппированныеВС.Значение;
		
		ДанныеСтруктурнойЕдиницы = ДанныеПрофилейИСЭСФ.Получить(СтруктурнаяЕдиница);
		
		ДанныеПрофиляИСЭСФ = ЭСФСервер.ДанныеПрофиляИСЭСФ(ДанныеСтруктурнойЕдиницы.ПрофильИСЭСФ);
		
		ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации = ДанныеСтруктурнойЕдиницы.ПарольИСЭСФ;
		
		ОбработкаОбменЭСФ.СоздатьВС(СгруппированныйМассивВС, ДанныеПрофиляИСЭСФ);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти 

#Область ОбновлениеСкладов

Процедура ОбновитьСкладыИзВСВФоне(Знач ПараметрыВыгрузки, Знач АдресХранилища) Экспорт
	
	ОбновитьСкладыИзВС(ПараметрыВыгрузки.КоллекцияСгруппированныхСкладов, ПараметрыВыгрузки.ДанныеПрофилейИСЭСФ);
	
КонецПроцедуры

Процедура ОбновитьСкладыИзВС(Знач КоллекцияСгруппированныхСкладов, Знач ДанныеПрофилейИСЭСФ) Экспорт
	
	ОбработкаОбменЭСФ = ЭСФСерверПовтИсп.ОбработкаОбменЭСФ();
	
	Для Каждого СгруппированныеСклады Из КоллекцияСгруппированныхСкладов Цикл
		
		СтруктурнаяЕдиница = СгруппированныеСклады.Ключ;
		СгруппированныйМассивЭДВС = СгруппированныеСклады.Значение;
		
		ДанныеСтруктурнойЕдиницы = ДанныеПрофилейИСЭСФ.Получить(СтруктурнаяЕдиница);
		
		ДанныеПрофиляИСЭСФ = ЭСФСервер.ДанныеПрофиляИСЭСФ(ДанныеСтруктурнойЕдиницы.ПрофильИСЭСФ);
		
		ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации = ДанныеСтруктурнойЕдиницы.ПарольИСЭСФ;
		
		ОбработкаОбменЭСФ.ОбновитьСкладыИзВС(СгруппированныйМассивЭДВС, ДанныеПрофиляИСЭСФ);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ПолучениеФормВС
	
// Вызывает процедуру ПолучитьНовыеУТТН для фоновых заданий
Функция ПолучитьНовыеУТТН(Знач ПараметрыВыгрузки, Знач АдресХранилища = Неопределено) Экспорт
	
	Возврат ВССервер.ПолучитьНовыеУТТН(ПараметрыВыгрузки);
	
КонецФункции

#КонецОбласти

#Область ОбновлениеФормВС

Процедура ОбновитьДокументыУТТНИзВСВФоне(Знач ПараметрыВыгрузки, Знач АдресХранилища) Экспорт
	
	ОбновитьДокументыУТТНИзВС (ПараметрыВыгрузки.КоллекцияСгруппированныхУТТН, ПараметрыВыгрузки.ДанныеПрофилейИСЭСФ);
	
КонецПроцедуры

Процедура ОбновитьДокументыУТТНИзВС(Знач КоллекцияСгруппированныхЭДВС, Знач ДанныеПрофилейИСЭСФ) Экспорт
	
	ОбработкаОбменЭСФ = ЭСФСерверПовтИсп.ОбработкаОбменЭСФ();
	
	Для Каждого СгруппированныеЭДВС Из КоллекцияСгруппированныхЭДВС Цикл
		
		СтруктурнаяЕдиница = СгруппированныеЭДВС.Ключ;
		СгруппированныйМассивЭДВС = СгруппированныеЭДВС.Значение;
		
		ДанныеСтруктурнойЕдиницы = ДанныеПрофилейИСЭСФ.Получить(СтруктурнаяЕдиница);
		
		ДанныеПрофиляИСЭСФ = ЭСФСервер.ДанныеПрофиляИСЭСФ(ДанныеСтруктурнойЕдиницы.ПрофильИСЭСФ);
		
		ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации = ДанныеСтруктурнойЕдиницы.ПарольИСЭСФ;
		
		ОбработкаОбменЭСФ.ОбновитьДокументыУТТНИзВС(СгруппированныйМассивЭДВС, ДанныеПрофиляИСЭСФ);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти 

#Область ПолучениеОшибокТяжелогоФЛКФормВС

Процедура ПолучитьОшибкиЭДВСПоИдентификаторам(Знач КоллекцияСгруппированныхЭДВС, Знач ДанныеПрофилейИСЭСФ, Знач ОбновитьДокументыВС) Экспорт
	
	Для Каждого СгруппированныеЭДВС Из КоллекцияСгруппированныхЭДВС Цикл
		
		СтруктурнаяЕдиница = СгруппированныеЭДВС.Ключ;
		СгруппированныйМассивЭДВС = СгруппированныеЭДВС.Значение;
		
		ДанныеСтруктурнойЕдиницы = ДанныеПрофилейИСЭСФ.Получить(СтруктурнаяЕдиница);
		
		ДанныеПрофиляИСЭСФ = ЭСФСервер.ДанныеПрофиляИСЭСФ(ДанныеСтруктурнойЕдиницы.ПрофильИСЭСФ);
		
		ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации = ДанныеСтруктурнойЕдиницы.ПарольИСЭСФ;
		
		// Получить МассивИдентификаторовЭДВС из МассивЭДВС.
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЭлектронныйДокументВС.Идентификатор		
		|ИЗ
		|	Документ.ЭлектронныйДокументВС КАК ЭлектронныйДокументВС
		|ГДЕ
		|	ЭлектронныйДокументВС.Ссылка В(&МассивЭДВС)";	
		Запрос.УстановитьПараметр("МассивЭДВС", СгруппированныйМассивЭДВС);	
		Выборка = Запрос.Выполнить().Выбрать();	
		МассивИдентификаторовЭДВС = Новый Массив;
		Пока Выборка.Следующий() Цикл

				МассивИдентификаторовЭДВС.Добавить(Выборка.Идентификатор);
		КонецЦикла;
		
		ИдентификаторСессии = ВССервер.ОткрытьСессию(ДанныеПрофиляИСЭСФ);
		
		Если МассивИдентификаторовЭДВС.Количество() <> 0 Тогда
			ВССервер.ПолучитьОшибкиЭДВСПоИдентификаторам(МассивИдентификаторовЭДВС, ДанныеПрофиляИСЭСФ, ИдентификаторСессии, ОбновитьДокументыВС);
		КонецЕсли;
		
		ВССервер.ЗакрытьСессию(ДанныеПрофиляИСЭСФ, ИдентификаторСессии);
		
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти 

#Область ПолучениеИдентификаторовТоваров

Процедура ПолучитьИдентификаторыТоваровУТТНизВСВФоне(Знач ПараметрыВыгрузки, Знач АдресХранилища) Экспорт
	
	ПолучитьИдентификаторыТоваровУТТНизВС(ПараметрыВыгрузки.КоллекцияСгруппированныхДокументов, ПараметрыВыгрузки.ДанныеПрофилейИСЭСФ);
	
КонецПроцедуры

Процедура ПолучитьИдентификаторыТоваровУТТНизВС(КоллекцияСгруппированныхЭДВС, ДанныеПрофилейИСЭСФ, ДополнительныеПараметры = Неопределено) Экспорт
	
	ОбработкаОбменЭСФ = ЭСФСерверПовтИсп.ОбработкаОбменЭСФ();
		
	Для Каждого СгруппированныеЭДВС Из КоллекцияСгруппированныхЭДВС Цикл
		
		СтруктурнаяЕдиница = СгруппированныеЭДВС.Ключ;
		СгруппированныйМассивЭДВС = СгруппированныеЭДВС.Значение;
		
		ДанныеСтруктурнойЕдиницы = ДанныеПрофилейИСЭСФ.Получить(СтруктурнаяЕдиница);
		
		ДанныеПрофиляИСЭСФ = ЭСФСервер.ДанныеПрофиляИСЭСФ(ДанныеСтруктурнойЕдиницы.ПрофильИСЭСФ);
		
		ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации = ДанныеСтруктурнойЕдиницы.ПарольИСЭСФ;
		
		ОбработкаОбменЭСФ.ПолучитьИдентификаторыТоваровПоРегНомерамДокументов(СгруппированныйМассивЭДВС, ДанныеПрофиляИСЭСФ, , , ДополнительныеПараметры);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти 

#Область ОбновлениеИзменениеСтатусовФормВС

Процедура ОбновитьСтатусыЭДВСПоИдентификаторам(Знач КоллекцияСгруппированныхЭДВС, Знач ДанныеПрофилейИСЭСФ) Экспорт
	
	Для Каждого СгруппированныеЭДВС Из КоллекцияСгруппированныхЭДВС Цикл
		
		СтруктурнаяЕдиница = СгруппированныеЭДВС.Ключ;
		СгруппированныйМассивЭДВС = СгруппированныеЭДВС.Значение;
		
		ДанныеСтруктурнойЕдиницы = ДанныеПрофилейИСЭСФ.Получить(СтруктурнаяЕдиница);
		
		ДанныеПрофиляИСЭСФ = ЭСФСервер.ДанныеПрофиляИСЭСФ(ДанныеСтруктурнойЕдиницы.ПрофильИСЭСФ);
		
		ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации = ДанныеСтруктурнойЕдиницы.ПарольИСЭСФ;
		
		// Получить МассивИдентификаторовЭДВС из МассивЭДВС.
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЭлектронныйДокументВС.Идентификатор
		|ИЗ
		|	Документ.ЭлектронныйДокументВС КАК ЭлектронныйДокументВС
		|ГДЕ
		|	ЭлектронныйДокументВС.Ссылка В(&МассивЭДВС)";	
		Запрос.УстановитьПараметр("МассивЭДВС", СгруппированныйМассивЭДВС);	
		Выборка = Запрос.Выполнить().Выбрать();	
		МассивИдентификаторовЭДВС = Новый Массив;
		//МассивИдентификаторовИсходящихЭДВС = Новый Массив;	
		Пока Выборка.Следующий() Цикл
			//Если Выборка.Направление = Перечисления.НаправленияЭСФ.Входящий Тогда
				МассивИдентификаторовЭДВС.Добавить(Выборка.Идентификатор);
			//Иначе // Выборка.Направление = Перечисления.НаправленияЭСФ.Исходящий
				//МассивИдентификаторовИсходящихЭСФ.Добавить(Выборка.Идентификатор);	
			//КонецЕсли;
		КонецЦикла;
		
		ИдентификаторСессии = ВССервер.ОткрытьСессию(ДанныеПрофиляИСЭСФ);
		
		Если МассивИдентификаторовЭДВС.Количество() <> 0 Тогда
			ВССервер.ОбновитьСтатусыЭДВСПоИдентификаторам(МассивИдентификаторовЭДВС, ДанныеПрофиляИСЭСФ, ИдентификаторСессии);
		КонецЕсли;
		//
		//Если МассивИдентификаторовИсходящихЭСФ.Количество() <> 0 Тогда
		//	ЭСФСервер.ОбновитьСтатусыЭСФПоИдентификаторам(МассивИдентификаторовИсходящихЭСФ, Перечисления.НаправленияЭСФ.Исходящий, ДанныеПрофиляИСЭСФ, ИдентификаторСессии);
		//КонецЕсли;
		
		ВССервер.ЗакрытьСессию(ДанныеПрофиляИСЭСФ, ИдентификаторСессии);
		
	КонецЦикла;
		
КонецПроцедуры

Функция ОбновитьСтатусыЭДВСПоИдентификаторамВФоне(Знач ПараметрыВыгрузки, Знач АдресХранилища) Экспорт
	    ОбновитьСтатусыЭДВСПоИдентификаторам(ПараметрыВыгрузки.КоллекцияСгруппированныхЭДВС, ПараметрыВыгрузки.ДанныеПрофилейИСЭСФ);	
КонецФункции

// См. ВССервер.ВыполнитьЗапросНаИзменениеСтатусовВС()
Функция ВыполнитьЗапросНаИзменениеСтатусовВС(Знач Действие, Знач ТекстЗапроса, Знач ПрофильИСЭСФ, ИдентификаторСессии = Неопределено) Экспорт
	
	Возврат ВССервер.ВыполнитьЗапросНаИзменениеСтатусовВС(Действие, ТекстЗапроса, ПрофильИСЭСФ, ИдентификаторСессии);
	
КонецФункции

Функция ВыполнитьЗапросНаИзменениеСтатусовВФоне(Знач ПараметрыВыгрузки, Знач АдресХранилища) Экспорт
	
	ДанныеИзмененияСтатусов = ВыполнитьЗапросНаИзменениеСтатусовВС(ПараметрыВыгрузки.Действие, ПараметрыВыгрузки.ТекстЗапроса, ПараметрыВыгрузки.ДанныеПрофиляИСЭСФ);
	ПоместитьВоВременноеХранилище(ДанныеИзмененияСтатусов, АдресХранилища);
	Возврат ДанныеИзмененияСтатусов;

КонецФункции

Функция ИзменитьСтатусыЭДВС(Действие, КоллецияДляИзмененияСтатусов, ДанныеКлючаЭЦП, ДанныеПрофиляИСЭСФ) Экспорт
	
	Результат = СоздатьЗапросНаИзменениеСтатусовВС(Действие, КоллецияДляИзмененияСтатусов, ДанныеКлючаЭЦП.ОткрытыйСертификатBase64);
	
	Контейнер = ЭСФКлиентСервер.КонтейнерМетодов();
	
	Если ЭСФВызовСервера.ИспользоватьПодписьНовойКомпоненты() Тогда
		
		СтрокаЗапросаВМассив = Новый Массив;
		СтрокаЗапросаВМассив.Добавить(Результат.СтрокаДляПодписи);
		
		Если ЭСФВызовСервера.ИспользоватьВнешнююКриптографиюДляКомпоненты() Тогда
			КоллекцияПодписейЭСФ = ЭСФКлиентСервер.НоваяКоллекцияПодписейЭСФ(СтрокаЗапросаВМассив, ДанныеКлючаЭЦП, ДанныеПрофиляИСЭСФ);
		Иначе
			ТекстОшибки = нСтр("ru='Использование подписи компонентой без внешней криптографии не поддерживается на сервере.'");
			ЭСФКлиентСерверПереопределяемый.СообщитьПользователю(ТекстОшибки);
			Возврат Неопределено;
		КонецЕсли;
		
		Если КоллекцияПодписейЭСФ.Количество() = 0 Тогда
			ТекстОшибки = НСтр("ru='Не удалось выполнить подпись документов.'");
			ЭСФКлиентСерверПереопределяемый.СообщитьПользователю(ТекстОшибки);
			// Не помещаем в очередь отправки, так как сведения для подписи мы не получили
			ЭСФВызовСервера.ОчиститьОчередьОтправкиЭСФ(КоллецияДляИзмененияСтатусов);
			Возврат Неопределено;
		КонецЕсли;
		
		Если ДанныеПрофиляИСЭСФ.Свойство("ОткрытыйСертификатBase64") Тогда
			Сертификат = ДанныеПрофиляИСЭСФ.ОткрытыйСертификатBase64;
			ДанныеКлючаЭЦП.Вставить("ОткрытыйСертификатBase64", Сертификат);
		КонецЕсли;
		
		ПодписьЗапроса = КоллекцияПодписейЭСФ.Получить(Результат.СтрокаДляПодписи);
		
	Иначе
		
		ПодписьЗапроса = Контейнер.СоздатьЭЦП(
			Результат.СтрокаДляПодписи, 
			ДанныеКлючаЭЦП.КлючBase64, 
			ДанныеКлючаЭЦП.Пароль);
		
	КонецЕсли;
	
	ТекстЗапроса = Результат.ТекстЗапроса; 
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[signature]", ПодписьЗапроса);
	
	Возврат ВыполнитьЗапросНаИзменениеСтатусовВС(Действие, ТекстЗапроса, ДанныеПрофиляИСЭСФ);	
	
КонецФункции

Функция ИзменитьСтатусыЭДВСВФоне(Знач ПараметрыВыгрузки, Знач АдресХранилища) Экспорт

	ДанныеИзмененияСтатусов = ИзменитьСтатусыЭДВС(ПараметрыВыгрузки.Действие, ПараметрыВыгрузки.КоллецияДляИзмененияСтатусов, ПараметрыВыгрузки.ДанныеКлючаЭЦП, ПараметрыВыгрузки.ДанныеПрофиляИСЭСФ);
	ПоместитьВоВременноеХранилище(ДанныеИзмененияСтатусов, АдресХранилища);
	Возврат ДанныеИзмененияСтатусов;
	
КонецФункции

// См. ВССервер.СоздатьЗапросНаИзменениеСтатусовВС()
Функция СоздатьЗапросНаИзменениеСтатусовВС(Знач Действие, Знач КоллецияДляИзмененияСтатусов, Знач ОткрытыйКлючЭЦП) Экспорт
	
	Возврат ВССервер.СоздатьЗапросНаИзменениеСтатусовВС(Действие, КоллецияДляИзмененияСтатусов, ОткрытыйКлючЭЦП);
	
КонецФункции

#КонецОбласти 

#Область ГСВС

Функция ПолучитьГСВС(Идентификатор = "", КодТНВЭД = "") Экспорт
	
	Возврат ЭСФСервер.ПолучитьГСВС(Идентификатор, КодТНВЭД);
	
КонецФункции

Функция ЗагрузитьСправочникГСВС(знач ДополнительныеПараметры) Экспорт
	Возврат ВССервер.ЗагрузитьСправочникГСВС(ДополнительныеПараметры);
КонецФункции	

Функция ЗагрузитьСправочникГСВСВФоне(знач ДополнительныеПараметры, знач АдресХранилища) Экспорт
	Возврат ВССервер.ЗагрузитьСправочникГСВС(ДополнительныеПараметры);
КонецФункции	

#КонецОбласти 

#Область МетодыОбщегоНазначения
	
Функция ТекстРазделителяЗапросовПакета() Экспорт

	ТекстРазделителя =
	"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";

	Возврат ТекстРазделителя;

КонецФункции

Функция СтрокаСоответствуетФасету(знач Строка,знач Фасет) Экспорт
	
	Возврат ВССервер.СтрокаСоответствуетФасету(Строка, Фасет);
	
КонецФункции

#КонецОбласти

#Область СозданиеЭДВС

//Создает множество Электронных документов ВС
//
Функция СоздатьСписокЭлектронныхДокументовВС(ПараметрыСоздания) Экспорт
	Возврат ЭСФСерверПовтИсп.ОбработкаОбменЭСФ().СоздатьСписокЭлектронныхДокументовВС(ПараметрыСоздания);	
КонецФункции

Функция ПодготовитьПараметрыДляВыполненияКомандыСоздатьЭДВС(ПараметрКоманды, ВидДвижения) Экспорт
	Возврат ЭСФСерверПовтИсп.ОбработкаОбменЭСФ().ПодготовитьПараметрыДляВыполненияКомандыСоздатьЭДВС(ПараметрКоманды, ВидДвижения);
КонецФункции

Процедура ИсключитьЭСФНеОтраженныеВУчете(МассивДокументовЭСФ, УдалятьЭлементМассива) Экспорт
	ВССерверПереопределяемый.ИсключитьЭСФНеОтраженныеВУчете(МассивДокументовЭСФ, УдалятьЭлементМассива);
КонецПроцедуры	

Функция ТипыФормЭДВСВКоторыхУстанавливаютсяЦены() Экспорт 
	Возврат ВССерверПереопределяемый.ТипыФормЭДВСВКоторыхУстанавливаютсяЦены();	
КонецФункции

Функция ПолучитьДополнительныеПараметрыЗапросаБУ() Экспорт
	Возврат ВССерверПереопределяемый.ПолучитьДополнительныеПараметрыЗапросаБУ();	
КонецФункции	

Функция ТипДокументаТаможеннойДекларации(ТипДокумента) Экспорт
	Возврат ВССерверПереопределяемый.ТипДокументаТаможеннойДекларации(ТипДокумента);
КонецФункции

Функция ТипыДокументовТаможеннойДекларации() Экспорт
	Возврат ВССерверПереопределяемый.ТипыДокументовТаможеннойДекларации();
КонецФункции

Функция ТипДокументаСНТ() Экспорт
	
	Возврат ВССерверПереопределяемый.ТипДокументаСНТ();
	
КонецФункции

//Разбивает документы ЭДВС по числу строк
//
Функция РазбитьЭлектронныеДокументыВС(ПараметрыСоздания) Экспорт
	Возврат ЭСФСерверПовтИсп.ОбработкаОбменЭСФ().РазбитьЭлектронныеДокументыВС(ПараметрыСоздания);
КонецФункции

#КонецОбласти

#Область ИдентификаторыТоваровВС

Функция ВедетсяУчетПоИдентификаторамТоваровВС() Экспорт
	
	Возврат ВССервер.ВедетсяУчетПоИдентификаторамТоваровВС();
	
КонецФункции

// См. Обработка.ОбменЭСФ.ДатаНачалаУчетаПоИдентификаторам()
Функция ДатаНачалаУчетаПоИдентификаторам() Экспорт
	
	Возврат ЭСФСерверПовтИсп.ОбработкаОбменЭСФ().ДатаНачалаУчетаПоИдентификаторам();
	
КонецФункции

Функция ПроверитьЭДВСНаНаличиеИдентификаторовТоваровВС(Знач ОбъектЭДВС) Экспорт
	
	Возврат ЭСФСерверПовтИсп.ОбработкаОбменЭСФ().ПроверитьЭДВСНаНаличиеИдентификаторовТоваровВС(ОбъектЭДВС);
	
КонецФункции

Функция ПроверитьЭСФНаНаличиеИдентификаторовТоваровВС(Знач ОбъектЭСФ) Экспорт
	
	Возврат ЭСФСерверПовтИсп.ОбработкаОбменЭСФ().ПроверитьЭСФНаНаличиеИдентификаторовТоваровВС(ОбъектЭСФ);
	
КонецФункции

// Вызывает процедуру ПолучитьИдентификаторыТоваров для фоновых заданий
Функция ПолучитьИдентификаторыТоваров(Знач ПараметрыВыгрузки, Знач АдресХранилища = Неопределено) Экспорт
	
	Возврат ВССервер.ПолучитьИдентификаторыТоваров(ПараметрыВыгрузки);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СгруппироватьЭДВСПоСтруктурнымЕдиницам(Знач МассивЭД, ОткрыватьСессиюФилиаломПолучателем = Ложь) Экспорт
	
	ОбработкаОбменЭСФ = ЭСФСерверПовтИсп.ОбработкаОбменЭСФ();
	КоллекцияСгруппированныхЭСФ = ОбработкаОбменЭСФ.Переопределяемый_СгруппироватьЭДВСПоСтруктурнымЕдиницам(МассивЭД, ОткрыватьСессиюФилиаломПолучателем);
	Возврат КоллекцияСгруппированныхЭСФ;
	
КонецФункции

// Находит в МассивЭДВС документы, у которых дата отличается от параметра Дата.
//
// Параметры:
//  МассивЭДВС - Массив - Массив документов ВС, среди которых необходимо найти документ с отличающейся датой.
//   Каждый элемент массива должен иметь тип ДокументСсылка.ЭлектронныйДокументВС.
//  Дата - Дата - Будут найдены документы ВС, дата которых отличается от этой даты.
//
// Возвращаемое значение:
//   Массив - Массив длкументов ВС, дата которых отличается от Дата.
//    Каждый элемент массива имеет тип ДокументСсылка.ЭлектронныйДокументВС.
//
Функция МассивЭДВСДругаяДата(МассивЭДВС, Дата, ИзмененГод = Ложь) Экспорт
	
	МассивЭДВСДругаяДата = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ГОД(ЭлектронныйДокументВС.Дата) <> ГОД(&Дата) КАК ИзмененГод,
	|	ЭлектронныйДокументВС.Ссылка КАК ЭДВС
	|ИЗ
	|	Документ.ЭлектронныйДокументВС КАК ЭлектронныйДокументВС
	|ГДЕ
	|	ЭлектронныйДокументВС.Ссылка В(&МассивЭДВС)
	|	И НАЧАЛОПЕРИОДА(ЭлектронныйДокументВС.Дата, ДЕНЬ) <> &Дата
	|	И ЭлектронныйДокументВС.Состояние В (&МассивСостояний)";       
	
	Запрос.УстановитьПараметр("МассивЭДВС", МассивЭДВС);	
	Запрос.УстановитьПараметр("Дата", Дата);	
	
	МассивСостояний = Новый Массив;
	МассивСостояний.Добавить(Перечисления.СостоянияЭДВС.Сформирован);
	МассивСостояний.Добавить(Перечисления.СостоянияЭДВС.ОтклоненСервером);
	Запрос.УстановитьПараметр("МассивСостояний", МассивСостояний);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();	
		Пока Выборка.Следующий() Цикл
			МассивЭДВСДругаяДата.Добавить(Выборка.ЭДВС);
			Если Выборка.ИзмененГод Тогда
				ИзмененГод = Выборка.ИзмененГод;
			КонецЕсли;
		КонецЦикла;		
	КонецЕсли;
	
	Возврат МассивЭДВСДругаяДата;
	
КонецФункции

// Устанавливает дату для документов ЭСФ и связанных счетов фактур.
//
// Параметры:
//  МассивЭСФ - Массив - Массив документов ЭСФ, для которых необходимо установить дату.
//   Если у ЭСФ указан счет-фактура, то для счета-фактуры тоже будет установлена эта дата.
//   Каждый элемент массива должен иметь тип ДокументСсылка.ЭСФ.
//  ТекущаяДата - Дата - Дата, которую необходимо установить для документов ЭСФ и счетов-фактур.
//   Должна быть началом дня.
//
Процедура УстановитьТекущуюДатуДляЭДВС(Знач МассивЭДВС, Знач ТекущаяДата) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЭлектронныйДокументВС.Ссылка КАК ЭДВС,
	|	ЭлектронныйДокументВС.Дата КАК ДатаЭДВС
	|ИЗ
	|	Документ.ЭлектронныйДокументВС КАК ЭлектронныйДокументВС
	|ГДЕ
	|	ЭлектронныйДокументВС.Ссылка В(&МассивЭДВС)";
	
	Запрос.УстановитьПараметр("МассивЭДВС", МассивЭДВС);
	Выборка = Запрос.Выполнить().Выбрать();
	
	НачатьТранзакцию();
	
	Попытка
		
		Пока Выборка.Следующий() Цикл
			
			//ОбъектСчетФактура = Неопределено;
			//ИзмененНомерСФ    = Ложь;
			//Если ЗначениеЗаполнено(Выборка.СчетФактура) И Выборка.ДатаСчетаФактуры <> ТекущаяДата Тогда
			//	ОбъектСчетФактура = Выборка.СчетФактура.ПолучитьОбъект();
			//	
			//	Если Год(ОбъектСчетФактура.Дата) <> Год(ТекущаяДата) Тогда
			//		ОбъектСчетФактура.Номер = "";
			//		ИзмененНомерСФ          = Истина;
			//	КонецЕсли;
			//	
			//	ОбъектСчетФактура.Дата = ТекущаяДата;
			//	ОбъектСчетФактура.ДополнительныеСвойства.Вставить(ЭСФКлиентСерверПереопределяемый.ИмяПропуститьПроверкуЗапретаИзменения(), Истина);
			//	ОбъектСчетФактура.Записать();
			//КонецЕсли;
			
			Если Выборка.ДатаЭДВС <> ТекущаяДата Тогда
				ОбъектЭДВС = Выборка.ЭДВС.ПолучитьОбъект();
				ОбъектЭДВС.Дата = ТекущаяДата;
				
				//Если ОбъектСчетФактура <> Неопределено И ИзмененНомерСФ Тогда
				//	ОбъектЭДВС.Номер = ЭСФСерверПереопределяемый.ПолучитьНомерНаПечать(ОбъектСчетФактура);
				//КонецЕсли;
				
				ОбъектЭДВС.ДополнительныеСвойства.Вставить(ЭСФКлиентСерверПереопределяемый.ИмяПропуститьПроверкуЗапретаИзменения(), Истина);
				ОбъектЭДВС.ОбменДанными.Загрузка = Истина;
				ОбъектЭДВС.Записать();
			КонецЕсли;
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'ВСВызовСервера.УстановитьТекущуюДатуДляЭДВС'"), 
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;
	
КонецПроцедуры

Функция ПолучитьТаблицуПараметров(СписокКолонок, ИсходнаяТаблица = Неопределено) Экспорт

	Если ИсходнаяТаблица = Неопределено Тогда
		
		ТаблицаРезультат = Новый ТаблицаЗначений;
		Колонки = Новый Структура(СписокКолонок);
		Для каждого Колонка Из Колонки Цикл
			ТаблицаРезультат.Колонки.Добавить(Колонка.Ключ);
		КонецЦикла;
		Возврат ТаблицаРезультат;

	Иначе

		Возврат ИсходнаяТаблица.Скопировать(, СписокКолонок);

	КонецЕсли;

КонецФункции

Функция ПолучитьПредопределеннуюСтрануКазахстан() Экспорт
	Возврат ВССерверПереопределяемый.ПолучитьПредопределеннуюСтрануКазахстан();
КонецФункции

Функция ПолучитьЭДВСПоИмпорту(МассивЭД) Экспорт
	
	ОбработкаОбменЭСФ = ЭСФСерверПовтИсп.ОбработкаОбменЭСФ();
	МассивИмпортныхЭД = ОбработкаОбменЭСФ.ПолучитьМассивЭДВСПоИмпорту(МассивЭД);
	Возврат МассивИмпортныхЭД;

КонецФункции

Функция СгруппироватьВСПоСтруктурнымЕдиницам(ВС, ОткрыватьСессиюФилиаломПолучателем = Ложь) Экспорт
	
	ОбработкаОбменЭСФ = ЭСФСерверПовтИсп.ОбработкаОбменЭСФ();
	КоллекцияСгруппированныхВС = ОбработкаОбменЭСФ.Переопределяемый_СгруппироватьВСПоСтруктурнымЕдиницам(ВС, ОткрыватьСессиюФилиаломПолучателем);
	Возврат КоллекцияСгруппированныхВС;
	
КонецФункции

Функция СгруппироватьСкладыПоСтруктурнымЕдиницам(Знач МассивСкладов) Экспорт
	
	ОбработкаОбменЭСФ = ЭСФСерверПовтИсп.ОбработкаОбменЭСФ();
	КоллекцияСгруппированныхСкладов = ОбработкаОбменЭСФ.Переопределяемый_СгруппироватьСкладыПоСтруктурнымЕдиницам(МассивСкладов);
	Возврат КоллекцияСгруппированныхСкладов;
	
КонецФункции

#КонецОбласти 