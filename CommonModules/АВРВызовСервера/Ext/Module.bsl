﻿
#Область ПроверкаИУстановкаТекДаты 

// Находит в МассивАВР документы, у которых дата отличается от параметра Дата.
//
// Параметры:
//  МассивАВР - Массив - Массив АВР, среди которых необходимо найти АВР с отличающейся датой.
//   Каждый элемент массива должен иметь тип ДокументСсылка.АктВыполненныхРабот.
//  Дата - Дата - Будут найдены АВР, дата которых отличается от этой даты.
//
// Возвращаемое значение:
//   Массив - Массив АВР, дата которых отличается от Дата.
//    Каждый элемент массива имеет тип ДокументСсылка.АктВыполненныхРабот.
//
Функция МассивАВРДругаяДата(МассивАВР, Дата, ИзмененГод = Ложь) Экспорт
	
	МассивАВРДругаяДата = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЭлектронныйАктВыполненныхРабот.Ссылка КАК АВР,
	|	ГОД(ЭлектронныйАктВыполненныхРабот.Дата) <> ГОД(&Дата) КАК ИзмененГод
	|ИЗ
	|	Документ.ЭлектронныйАктВыполненныхРабот КАК ЭлектронныйАктВыполненныхРабот
	|ГДЕ
	|	ЭлектронныйАктВыполненныхРабот.Ссылка В(&МассивАВР)
	|	И НАЧАЛОПЕРИОДА(ЭлектронныйАктВыполненныхРабот.Дата, ДЕНЬ) <> &Дата
	|	И ЭлектронныйАктВыполненныхРабот.Состояние В (&МассивСостояний)";
		
	Запрос.УстановитьПараметр("МассивАВР", МассивАВР);	
	Запрос.УстановитьПараметр("Дата", Дата);	
	
	МассивСостояний = Новый Массив;
	МассивСостояний.Добавить(Перечисления.СостоянияАВР.Сформирован);
	МассивСостояний.Добавить(Перечисления.СостоянияАВР.ОтклоненСервером);
	Запрос.УстановитьПараметр("МассивСостояний", МассивСостояний);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();	
		Пока Выборка.Следующий() Цикл
			МассивАВРДругаяДата.Добавить(Выборка.АВР);
			Если Выборка.ИзмененГод Тогда
				ИзмененГод = Выборка.ИзмененГод;
			КонецЕсли;
		КонецЦикла;		
	КонецЕсли;
	
	Возврат МассивАВРДругаяДата;
	
КонецФункции

// Устанавливает дату для документов АВР. // и связанных счетов фактур.
//
// Параметры:
//  МассивАВР - Массив - Массив документов АВР, для которых необходимо установить дату.
//   //Если у АВР указан счет-фактура, то для счета-фактуры тоже будет установлена эта дата.
//   Каждый элемент массива должен иметь тип ДокументСсылка.АктВыполненныхРабот.
//  ТекущаяДата - Дата - Дата, которую необходимо установить для документов АВР // и счетов-фактур.
//   Должна быть началом дня.
//	НужноСкорректироватьОснования - Булево - Определяет, нужно ли корректировать дату основания (при отправле АВР, если дата отличается от текущей).
//
Процедура УстановитьТекущуюДатуДляАВР(Знач МассивАВР, Знач ТекущаяДата) Экспорт
	
	Запрос 		 = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЭлектронныйАктВыполненныхРабот.Ссылка КАК АВР,
	|	ЭлектронныйАктВыполненныхРабот.Дата КАК ДатаАВР,
	|	ЭлектронныйАктВыполненныхРабот.ДокументОснование КАК ДокументОснование,
	|	НАЧАЛОПЕРИОДА(ЭлектронныйАктВыполненныхРабот.ДокументОснование.%ДокументОснованиеДата, ДЕНЬ) КАК ДатаДокументаОснования
	|ИЗ
	|	Документ.ЭлектронныйАктВыполненныхРабот КАК ЭлектронныйАктВыполненныхРабот
	|ГДЕ
	|	ЭлектронныйАктВыполненныхРабот.Ссылка В(&МассивАВР)";
	
	
	СоответсвиеИменРеквизитов = Новый Соответствие;
	СоответсвиеИменРеквизитов.Вставить("%ДокументОснованиеДата", "");
	
	ЗаполнитьСоответсвиеИменРеквизитовПолейЗапросов(СоответсвиеИменРеквизитов);
	
	ЭСФСервер.ЗаменитьИменаРеквизитовПолейЗапросов(ТекстЗапроса, СоответсвиеИменРеквизитов);
	
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("МассивАВР", МассивАВР);
	Выборка = Запрос.Выполнить().Выбрать();
	
	НачатьТранзакцию();
	МассивОснований = Новый Массив();
	
	Попытка
		
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.ДатаАВР <> ТекущаяДата Тогда
				
				Если Не АВРСерверПереопределяемый.МожноИзменитьДатуСвязанногоДокументаАВР(Выборка.ДокументОснование) Тогда
					
					ТекстСообщения  = ЭСФКлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(
										НСтр("ru = 'Связанный документ ""%1"" проведен, изменение даты невозможно!'"),
										Выборка.ДокументОснование);
					ЭСФКлиентСерверПереопределяемый.СообщитьПользователю(ТекстСообщения);
					Продолжить;
					
				Иначе
					
					ОбъектАВР = Выборка.АВР.ПолучитьОбъект();
					ОбъектАВР.Дата = ТекущаяДата;
					ОбъектАВР.Записать();
					
					МассивОснований.Добавить(Выборка.ДокументОснование);					
									
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если МассивОснований.Количество() <> 0 Тогда
			//Корректировать основание можем только если документ не проведен, но в УПК могут быть различия, 
			//поэтому выносим действия с основаниями в переопределяемый.
			АВРСерверПереопределяемый.ОбновитьДатыПервичныхДокументовПриОтправкеАВР(МассивОснований);
		КонецЕсли;
					
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'АВРВызовСервера.УстановитьТекущуюДатуДляАВР'"), 
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;
	
КонецПроцедуры

Процедура ЗаполнитьСоответсвиеИменРеквизитовПолейЗапросов(СоответсвиеИменРеквизитов) Экспорт
	
	АВРСерверПереопределяемый.ЗаполнитьСоответсвиеИменРеквизитовПолейЗапросов(СоответсвиеИменРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область ОтправкаАВР 

Функция СгруппироватьАВРПоСтруктурнымЕдиницам(Знач МассивАВР) Экспорт
	
	ОбработкаОбменЭСФ = ЭСФСерверПовтИсп.ОбработкаОбменЭСФ();
	КоллекцияСгруппированныхАВР = ОбработкаОбменЭСФ.Переопределяемый_СгруппироватьАВРПоСтруктурнымЕдиницам(МассивАВР);
	
	Возврат КоллекцияСгруппированныхАВР;
	
КонецФункции

// См. АВРСервер.СоздатьИсходящиеAwp()
Процедура СоздатьИсходящиеAwp(Знач МассивАВР, Знач УстанавливатьПодпись, Знач ТипПодписиЭСФ, АдресКоллекцииAwpXML, КоллекцияSignedContentXML, УполномоченныйСотрудник, ВерсияИСЭСФ, ДолжностьПодписывающего) Экспорт
	
	КоллекцияAwpXML = Неопределено;                                               
	АВРСервер.СоздатьИсходящиеAwp(МассивАВР, УстанавливатьПодпись, ТипПодписиЭСФ, КоллекцияAwpXML, КоллекцияSignedContentXML, УполномоченныйСотрудник, ВерсияИСЭСФ, ДолжностьПодписывающего);
	
	// После того, как переменная АдресКоллекцииAwpXML станет не нужна, 
	// необходимо самостоятельно очистить временное хранилище,
	// иначе значение будет удалено только после перезапуска сервера.
	АдресКоллекцииAwpXML = ПоместитьВоВременноеХранилище(КоллекцияAwpXML, Новый УникальныйИдентификатор);
	
КонецПроцедуры

Функция СоздатьИОтправитьКоллекциюAwp(КоллекцияСгруппированныхАВР, ДанныеПрофилейИСЭСФ, ДополнительныеПараметры, ВерсияИСЭСФ) Экспорт

	КоллекцияПодписейАВР = Новый Соответствие;
	КоллекцияАдресКоллекцииAwpXML = Новый Соответствие;
	КоллекцияСоответствиеАВР = Новый Соответствие;
	КоллекцияУполномоченныйСотрудник =  ДополнительныеПараметры.КоллекцияУполномоченныйСотрудник;
	ЗапускатьФоновоеЗадание =  ДополнительныеПараметры.ЗапускатьФоновоеЗадание;
		
	Для Каждого СгруппированныеАВР Из КоллекцияСгруппированныхАВР Цикл
		
		СтруктурнаяЕдиница = СгруппированныеАВР.Ключ;
		МассивАВР = СгруппированныеАВР.Значение;
		
		ДанныеКлючаЭЦП = ДанныеПрофилейИСЭСФ.Получить(СтруктурнаяЕдиница);
		
		ДанныеПрофиляИСЭСФ = ЭСФВызовСервера.ДанныеПрофиляИСЭСФ(ДанныеКлючаЭЦП.ПрофильИСЭСФ);

		АдресКоллекцииAwpXML = Неопределено;
		КоллекцияSignedContentXML = Неопределено;
		
		ТипПодписиЭСФ = ЭСФКлиентСервер.ТипПодписиЭСФ(ДанныеКлючаЭЦП, ДанныеПрофиляИСЭСФ);
		
		УполномоченныйСотрудник = КоллекцияУполномоченныйСотрудник.Получить(СтруктурнаяЕдиница);
		
		СоздатьИсходящиеAwp(МассивАВР, Истина, ТипПодписиЭСФ, АдресКоллекцииAwpXML, КоллекцияSignedContentXML, УполномоченныйСотрудник, ВерсияИСЭСФ, ДанныеКлючаЭЦП.ДолжностьПодписывающего);
		
		КоллекцияПодписей = ЭСФКлиентСервер.НоваяКоллекцияПодписейЭСФ(КоллекцияSignedContentXML, ДанныеКлючаЭЦП, ДанныеПрофиляИСЭСФ);
		
		Если КоллекцияПодписей.Количество() = 0 Тогда
			ТекстОшибки = НСтр("ru='Не удалось выполнить подпись документов.'");
			ЭСФКлиентСерверПереопределяемый.СообщитьПользователю(ТекстОшибки);
			Возврат Неопределено;
		КонецЕсли;
		
		СоответствиеАВР = ПолучитьИзВременногоХранилища(АдресКоллекцииAwpXML);
		
		КоллекцияСоответствиеАВР.Вставить(СтруктурнаяЕдиница, СоответствиеАВР);
		КоллекцияПодписейАВР.Вставить(СтруктурнаяЕдиница, КоллекцияПодписей);
		КоллекцияАдресКоллекцииAwpXML.Вставить(СтруктурнаяЕдиница, АдресКоллекцииAwpXML);
		
	КонецЦикла;
	
	Если ЗапускатьФоновоеЗадание Тогда
		
		КлючФоновогоЗадания = Новый УникальныйИдентификатор;
		
		ПараметрыЗадания = Новый Структура("ВерсияИСЭСФ, КоллекцияСоответствиеАВР, КоллекцияПодписейАВР, ДанныеПрофилейИСЭСФ, КоллекцияУполномоченныйСотрудник, КлючФоновогоЗадания", ВерсияИСЭСФ, КоллекцияСоответствиеАВР, КоллекцияПодписейАВР, ДанныеПрофилейИСЭСФ, КоллекцияУполномоченныйСотрудник, КлючФоновогоЗадания);
		ПараметрыВыполнения = ЭСФКлиентСерверПереопределяемый.ПараметрыВыполненияВФоне();
		ПараметрыВыполнения.КлючФоновогоЗадания = КлючФоновогоЗадания;
		
		Если ДополнительныеПараметры.Свойство("НеПерезаполнятьОчередьОтправки") Тогда       
			ПараметрыЗадания.Вставить("НеПерезаполнятьОчередьОтправки", ДополнительныеПараметры.НеПерезаполнятьОчередьОтправки);
		КонецЕсли;
		
		РезультатОтправки = ЭСФСерверПереопределяемый.ВыполнитьВФоне("АВРВызовСервера.ОтправитьИсходящиеAwpВФоне", ПараметрыЗадания, ПараметрыВыполнения);

	Иначе
	
		РезультатОтправки = ОтправитьИсходящиеAwp(
			ВерсияИСЭСФ,
			КоллекцияАдресКоллекцииAwpXML,
			КоллекцияПодписейАВР,
			ДанныеПрофилейИСЭСФ
			);	
			
	КонецЕсли;
	
	// Принудительное удаление, иначе значение не удалится.
	УдалитьИзВременногоХранилища(АдресКоллекцииAwpXML);

	Возврат РезультатОтправки;
		
КонецФункции

Функция ОтправитьИсходящиеAwpВФоне(Знач ПараметрыВыгрузки, Знач АдресХранилища) Экспорт

	ЭСФСервер.ЗаполнитьДанныеФоновогоЗаданияВОчередиОтправкиЭСФ(ПараметрыВыгрузки.КоллекцияСоответствиеАВР, ПараметрыВыгрузки.КлючФоновогоЗадания);
	
	НеПерезаполнятьОчередьОтправки = ПараметрыВыгрузки.Свойство("НеПерезаполнятьОчередьОтправки");
	
	Результат = ОтправитьИсходящиеAwp(ПараметрыВыгрузки.ВерсияИСЭСФ, ПараметрыВыгрузки.КоллекцияСоответствиеАВР, ПараметрыВыгрузки.КоллекцияПодписейАВР, ПараметрыВыгрузки.ДанныеПрофилейИСЭСФ, ПараметрыВыгрузки.КоллекцияУполномоченныйСотрудник, НеПерезаполнятьОчередьОтправки);
	
	Возврат Результат;
	
КонецФункции

// См. АВРСервер.ОтправитьИсходящиеAwp()
Функция ОтправитьИсходящиеAwp(ВерсияИСЭСФ, Знач КоллекцияДанныеКоллекцииAwpXML, Знач КоллекцияПодписейАВР, Знач ДанныеПрофилейИСЭСФ, КоллекцияУполномоченныйСотрудник = Неопределено, НеПерезаполнятьОчередьОтправки = Ложь) Экспорт
	
	Для Каждого СгруппированнаяAwpXML Из КоллекцияДанныеКоллекцииAwpXML Цикл
		
		СтруктурнаяЕдиница = СгруппированнаяAwpXML.Ключ;
		ДанныеКоллекцииAwpXML = СгруппированнаяAwpXML.Значение;
		
		Если ТипЗнч(ДанныеКоллекцииAwpXML) = Тип("Соответствие") Тогда
			КоллекцияAwpXML = ДанныеКоллекцииAwpXML;
		Иначе
			КоллекцияAwpXML = ПолучитьИзВременногоХранилища(ДанныеКоллекцииAwpXML);
		КонецЕсли;
		
		ДанныеСтруктурнойЕдиницы = ДанныеПрофилейИСЭСФ.Получить(СтруктурнаяЕдиница);
		ОткрытыйКлючЭЦП = ДанныеСтруктурнойЕдиницы.ОткрытыйСертификатBase64;
		КоллекцияПодписей = КоллекцияПодписейАВР.Получить(СтруктурнаяЕдиница);
		
		ДанныеПрофиляИСЭСФ = ЭСФСервер.ДанныеПрофиляИСЭСФ(ДанныеСтруктурнойЕдиницы.ПрофильИСЭСФ);
		
		ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации = ДанныеСтруктурнойЕдиницы.ПарольИСЭСФ;
		ДанныеПрофиляИСЭСФ.Вставить("ДолжностьПодписывающего", ДанныеСтруктурнойЕдиницы.ДолжностьПодписывающего);
		
		Если ЭСФВызовСервера.ИспользоватьПодписьНовойКомпоненты() И Не ЭСФВызовСервера.ИспользоватьВнешнююКриптографиюДляКомпоненты() Тогда
			ТипПодписи = ЭСФКлиентСервер.ТипПодписиИСЭСФ(ДанныеСтруктурнойЕдиницы.ТипПодписи);
			ДанныеПрофиляИСЭСФ.Вставить("ТипПодписи", ТипПодписи);
		КонецЕсли;
		
		Если КоллекцияУполномоченныйСотрудник = Неопределено Тогда
			УполномоченныйСотрудник = Неопределено;
		Иначе
			УполномоченныйСотрудник = КоллекцияУполномоченныйСотрудник.Получить(СтруктурнаяЕдиница);
		КонецЕсли;
		
		Результат = АВРСервер.ОтправитьИсходящиеAwp(ВерсияИСЭСФ, КоллекцияAwpXML, КоллекцияПодписей, ДанныеПрофиляИСЭСФ, ОткрытыйКлючЭЦП, , УполномоченныйСотрудник, НеПерезаполнятьОчередьОтправки);

	КонецЦикла;
	
КонецФункции

// См. АВРСервер.ПроверитьВозможностьОтправкиДокументовАВР()
//	 ВАЖНО! Массив изменяется внутрии функции, Знач не устанавливаем перед объявлением переменной
Функция ПроверитьВозможностьОтправкиДокументовАВР(МассивИсходящихАВР, ДополнительныеПараметры) Экспорт
	
	Возврат АВРСервер.ПроверитьВозможностьОтправкиДокументовАВР(МассивИсходящихАВР, ДополнительныеПараметры);
	
КонецФункции

// Получает должность выписывающего АВР при отправке одного документа.
// Если происходит пакетная отправка, то возвращается пустое значение.
//
Функция ПолучитьДолжностьВыписывающегоАВР(МассивИсходящихАВР) Экспорт
	
	Результат = "";
	Если ТипЗнч(МассивИсходящихАВР) = Тип("Массив") И МассивИсходящихАВР.Количество() = 1 Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ЭлектронныйАктВыполненныхРабот.ДолжностьСдающего КАК ДолжностьСдающего
		|ИЗ
		|	Документ.ЭлектронныйАктВыполненныхРабот КАК ЭлектронныйАктВыполненныхРабот
		|ГДЕ
		|	ЭлектронныйАктВыполненныхРабот.Ссылка = &ДокументАВР";
		
		Запрос.УстановитьПараметр("ДокументАВР", МассивИсходящихАВР[0]);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Результат = Выборка.ДолжностьСдающего;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// См. АВРКлиент.ПроверитьИсходящиеЭАВР().
Процедура ПроверитьИсходящиеЭАВР(Знач МассивИсходящихЭАВР) Экспорт
	
	АВРСервер.ПроверитьИсходящиеЭАВР(МассивИсходящихЭАВР);
	
КонецПроцедуры


#КонецОбласти 

#Область ОбновлениеАВРИзИСЭСФ

Функция ПроверитьВозможностьОбновления(МассивАВР) Экспорт
	
	МассивОшибочныхАВР = Новый Массив;
	   	 	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДокументыАВР.Ссылка,
	|	ДокументыАВР.Статус,
	|	ДокументыАВР.Направление КАК Направление
	|ИЗ
	|	Документ.ЭлектронныйАктВыполненныхРабот КАК ДокументыАВР
	|ГДЕ
	|	ДокументыАВР.Ссылка В(&МассивАВР)
	|	И ДокументыАВР.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыАВР.Ошибочный)";
		
	Запрос.УстановитьПараметр("МассивАВР", МассивАВР);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		МассивОшибочныхАВР.Добавить(Выборка.Ссылка);
	КонецЦикла;
	              	
	Если МассивОшибочныхАВР.Количество() > 0 Тогда
		ЭСФКлиентСерверПереопределяемый.СообщитьПользователю(НСтр("ru='Среди отправляемых АВР есть документ со статусом ""Ошибочный"". Обновление не будет произведено.'"));
		Возврат Ложь;
	Иначе 
		Возврат Истина;
	КонецЕсли;	
	
КонецФункции

Процедура ОбновитьДокументыАВРИзИСЭСФ(Знач КоллекцияСгруппированныхАВР, Знач ДанныеПрофилейИСЭСФ) Экспорт
	
	ОбработкаОбменЭСФ = ЭСФСерверПовтИсп.ОбработкаОбменЭСФ();
	
	Для Каждого СгруппированныеАВР Из КоллекцияСгруппированныхАВР Цикл
		
		СтруктурнаяЕдиница = СгруппированныеАВР.Ключ;
		СгруппированныйМассивАВР = СгруппированныеАВР.Значение;
		
		ДанныеСтруктурнойЕдиницы = ДанныеПрофилейИСЭСФ.Получить(СтруктурнаяЕдиница);
		
		ДанныеПрофиляИСЭСФ = ЭСФСервер.ДанныеПрофиляИСЭСФ(ДанныеСтруктурнойЕдиницы.ПрофильИСЭСФ);
		
		ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации = ДанныеСтруктурнойЕдиницы.ПарольИСЭСФ;
		
		ОбработкаОбменЭСФ.ОбновитьДокументыАВРИзИСЭСФ(СгруппированныйМассивАВР, ДанныеПрофиляИСЭСФ);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьДокументыАВРИзИСЭСФВФоне(Знач ПараметрыВыгрузки, Знач АдресХранилища) Экспорт
	
	ОбновитьДокументыАВРИзИСЭСФ(ПараметрыВыгрузки.КоллекцияСгруппированныхАВР, ПараметрыВыгрузки.ДанныеПрофилейИСЭСФ);
	
КонецПроцедуры

#КонецОбласти 

#Область ПроцедурыИФункцииФоновыхЗаданий

Функция ВыполнитьВФоне(Знач ИмяПроцедуры, Знач ПараметрыПроцедуры, Знач ПараметрыВыполнения) Экспорт

	Возврат АВРСерверПереопределяемый.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

#КонецОбласти

#Область ПолучениеАВРИзИСЭСФ

// Вызывает процедуру ПолучитьНовыеАВР для фоновых заданий
Функция ПолучитьНовыеАВР(Знач ПараметрыВыгрузки, Знач АдресХранилища = Неопределено) Экспорт
	
	Возврат АВРСервер.ПолучитьНовыеАВР(ПараметрыВыгрузки);
	
КонецФункции

#КонецОбласти 

#Область ИзменениеСтатусовАВР

// См. АВРСервер.ВыполнитьЗапросНаИзменениеСтатусов()
Функция ВыполнитьЗапросНаИзменениеСтатусов(Знач Действие, Знач ТекстЗапроса, Знач ПрофильИСЭСФ, ИдентификаторСессии = Неопределено, Знач СоответствиеПодписейАВР = Неопределено) Экспорт
	
	Возврат АВРСервер.ВыполнитьЗапросНаИзменениеСтатусов(Действие, ТекстЗапроса, ПрофильИСЭСФ, ИдентификаторСессии, СоответствиеПодписейАВР);
	
КонецФункции

Функция ВыполнитьЗапросНаИзменениеСтатусовВФоне(Знач ПараметрыВыгрузки, Знач АдресХранилища) Экспорт
	
	ДанныеИзмененияСтатусов = ВыполнитьЗапросНаИзменениеСтатусов(ПараметрыВыгрузки.Действие, ПараметрыВыгрузки.ТекстЗапроса, ПараметрыВыгрузки.ДанныеПрофиляИСЭСФ,,ПараметрыВыгрузки.СоответствиеПодписейАВР);
	ПоместитьВоВременноеХранилище(ДанныеИзмененияСтатусов, АдресХранилища);
	
	Возврат ДанныеИзмененияСтатусов;

КонецФункции

Функция ИзменитьСтатусыАВРВФоне(Знач ПараметрыВыгрузки, Знач АдресХранилища) Экспорт

	ДанныеИзмененияСтатусов = ИзменитьСтатусыАВР(ПараметрыВыгрузки.Действие, ПараметрыВыгрузки.КоллецияДляИзмененияСтатусов, ПараметрыВыгрузки.ДанныеКлючаЭЦП, ПараметрыВыгрузки.ДанныеПрофиляИСЭСФ);
	ПоместитьВоВременноеХранилище(ДанныеИзмененияСтатусов, АдресХранилища);
	
	Возврат ДанныеИзмененияСтатусов;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Изменение статусов АВР 

Функция ИзменитьСтатусыАВР(Действие, КоллецияДляИзмененияСтатусов, ДанныеКлючаЭЦП, ДанныеПрофиляИСЭСФ) Экспорт
	
	СоответствиеПодписейАВР = Новый Соответствие();
	ТипПодписиАВР = ЭСФКлиентСервер.ТипПодписиЭСФ(ДанныеКлючаЭЦП, ДанныеПрофиляИСЭСФ);
	Результат = СоздатьЗапросНаИзменениеСтатусов(Действие, КоллецияДляИзмененияСтатусов, ДанныеКлючаЭЦП, ТипПодписиАВР);
	Контейнер = АВРКлиентСервер.КонтейнерМетодов();
	awpActionInfoList = "";
	ТекстЗапроса = Результат.ТекстЗапроса;
	
	Если ДанныеКлючаЭЦП.Свойство("ДолжностьПодписывающего") Тогда
		ДолжностьПодписывающего = ДанныеКлючаЭЦП.ДолжностьПодписывающего;
	Иначе
		ДолжностьПодписывающего = Неопределено;
	КонецЕсли;
	
	Если ЭСФВызовСервера.ИспользоватьПодписьНовойКомпоненты() Тогда
		
		КоллекцияПодписейАВР = Новый Соответствие;
		
		Если ЭСФВызовСервера.ИспользоватьВнешнююКриптографиюДляКомпоненты() Тогда
			КоллекцияПодписейАВР = ЭСФКлиентСервер.НоваяКоллекцияПодписейЭСФ(Результат.МассивЧастейЗапроса, ДанныеКлючаЭЦП, ДанныеПрофиляИСЭСФ);
		Иначе
			ТекстОшибки = нСтр("ru='Использование подписи компонентой без внешней криптографии не поддерживается на сервере.'");
			ЭСФКлиентСерверПереопределяемый.СообщитьПользователю(ТекстОшибки);
			Возврат Неопределено;
		КонецЕсли;
		
		Если КоллекцияПодписейАВР.Количество() = 0 Тогда
			ТекстОшибки = НСтр("ru='Не удалось выполнить подпись документов.'");
			ЭСФКлиентСерверПереопределяемый.СообщитьПользователю(ТекстОшибки);
			Возврат Неопределено;
		КонецЕсли;
		
		Если ДанныеПрофиляИСЭСФ.Свойство("ОткрытыйСертификатBase64") Тогда
			Сертификат = ДанныеПрофиляИСЭСФ.ОткрытыйСертификатBase64;
			ДанныеКлючаЭЦП.Вставить("ОткрытыйСертификатBase64", Сертификат);
		КонецЕсли;
		
		Для Каждого ЭлементМассива из Результат.МассивЧастейЗапроса Цикл
			Подпись = КоллекцияПодписейАВР.Получить(ЭлементМассива.ИД);
			ТекстЧастиЗапроса = СтрЗаменить(ЭлементМассива.ЧастьЗапроса, "[Signature]", Подпись);
			awpActionInfoList = awpActionInfoList + ТекстЧастиЗапроса;
			
			СоответствиеПодписейАВР.Вставить(ЭлементМассива.ИД, Новый Структура("Подпись, ТипПодписи, ДолжностьПодписывающего", Подпись, ТипПодписиАВР, ДолжностьПодписывающего));
			
		КонецЦикла;
		
	Иначе
		
		Для Каждого ЭлементМассива из Результат.МассивЧастейЗапроса Цикл
			Подпись = Контейнер.СоздатьЭЦП(
			ЭлементМассива.СтрокаДляПодписи,
			ДанныеКлючаЭЦП.КлючBase64,
			ДанныеКлючаЭЦП.Пароль);
			ТекстЧастиЗапроса = СтрЗаменить(ЭлементМассива.ЧастьЗапроса, "[Signature]", Подпись);
			awpActionInfoList = awpActionInfoList + ТекстЧастиЗапроса;
			
			СоответствиеПодписейАВР.Вставить(ЭлементМассива.ИД, Новый Структура("Подпись, ТипПодписи, ДолжностьПодписывающего", Подпись, ТипПодписиАВР, ДолжностьПодписывающего));
			
		КонецЦикла;
		
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[awpActionInfoList]", awpActionInfoList);
	Возврат ВыполнитьЗапросНаИзменениеСтатусов(Действие, ТекстЗапроса, ДанныеПрофиляИСЭСФ,,СоответствиеПодписейАВР);

КонецФункции

Функция СоздатьЗапросНаИзменениеСтатусов(Знач Действие, Знач КоллецияДляИзмененияСтатусов, Знач ДанныеКлючаЭЦП, Знач ТипПодписиЭСФ) Экспорт
	
	Возврат АВРСервер.СоздатьЗапросНаИзменениеСтатусов(Действие, КоллецияДляИзмененияСтатусов, ДанныеКлючаЭЦП, ТипПодписиЭСФ);
	
КонецФункции

#КонецОбласти 

#Область СозданиеЭАВР

Функция ПодготовитьПараметрыДляВыполненияКомандыСоздатьЭАВР(ПараметрКоманды) Экспорт
	Возврат ЭСФСерверПовтИсп.ОбработкаОбменЭСФ().ПодготовитьПараметрыДляВыполненияКомандыСоздатьЭАВР(ПараметрКоманды);
КонецФункции

Функция СоздатьСписокИсходящихЭАВР(ПараметрыСоздания) Экспорт
	Возврат ЭСФСерверПовтИсп.ОбработкаОбменЭСФ().СоздатьСписокИсходящихАВР(ПараметрыСоздания);
КонецФункции

Функция ПроверитьДокументОснованияЭАВР(ДокументОснования) Экспорт
	Возврат ЭСФСерверПовтИсп.ОбработкаОбменЭСФ().ПроверитьДокументОснованияЭАВР(ДокументОснования);
КонецФункции

Функция ПроверитьНепроведенныеПервичныеДокументы(МассивПервичныхДокументов) Экспорт
	
	НепроведенныеПервичныеДокументы = Новый Массив();
	
	Для Каждого Документ Из МассивПервичныхДокументов Цикл
		
		Если НЕ ЗначениеЗаполнено(Документ.Ссылка) ИЛИ НЕ Документ.Проведен Тогда
			НепроведенныеПервичныеДокументы.Добавить(Документ);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат НепроведенныеПервичныеДокументы;
	
КонецФункции

Функция ПолучитьТипДокументаПоСсылке(СсылкаНаДокумент) Экспорт
	Возврат СсылкаНаДокумент.Метаданные().Имя;
КонецФункции

Функция ПроверитьПервичныеДокументыНаНаличиеИсправленныхЭАВР(МассивОснований) Экспорт

	Возврат АВРСервер.ПроверитьПервичныеДокументыНаНаличиеИсправленныхЭАВР(МассивОснований);

КонецФункции

#КонецОбласти
