﻿////////////////////////////////////////////////////////////////////////////////
// ЗаполнениеДокументов: 
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Процедура предназначена для заполнения общих реквизитов документов по документу основанию,
//	вызывается в обработчиках событий "ОбработкаЗаполнения" в модулях документов.
//
// Параметры:
//  ДокументОбъект  - объект редактируемого документа,
//  ДокументОснование - объект документа основания
//  КопироватьПодразделение - булево - если да - подразделение организации берется из документа-основания,
//										если нет - из реквизита СчетОрганизации или настройки пользователя
//
Процедура ЗаполнитьПоОснованию(ДокументОбъект, ДокументОснование, КопироватьПодразделение = Истина) Экспорт
	ЗаполнитьШапкуДокументаПоОснованию(ДокументОбъект, ДокументОснование);	
КонецПроцедуры

// Процедура предназначена для заполнения общих реквизитов документов,
// вызывается в обработчиках событий "ПриОткрытии" в модулех форм всех документов.
//
// Параметры:
//  ДокументОбъект                 - объект редактируемого документа,
//  ТекПользователь                - ссылка на справочник, определяет текущего пользователя  
//  ВалютаРегламентированногоУчета - валюта регламентированного учета
//  ТипОперации                    - необязаетельный, строка вида операции ("Покупка" или "Продажа"),
//                                   если не передан, то реквизиты, зависящие от вида операции, не заполняются
//
Процедура ЗаполнитьШапкуДокумента(ДокументОбъект, ВалютаРегламентированногоУчета = Неопределено, ТипОперации = "", НеИзменятьРеквизитыПоНДС = Ложь,ПараметрОбъектКопирования = Неопределено, ПараметрОснование = Неопределено) Экспорт
	
	Перем ТипЦен;
	
	ТекПользователь = Пользователи.ТекущийПользователь();
	
	Если ТипЗнч(ДокументОбъект) = Тип("Структура") ИЛИ 
		ТипЗнч(ДокументОбъект) = Тип("ДанныеФормыСтруктура") Тогда 
		МетаданныеДокумента = ДокументОбъект.Ссылка.Метаданные();
	Иначе 
		МетаданныеДокумента = ДокументОбъект.Метаданные();
	КонецЕсли;
	
	//заполнение даты
	Если НЕ ЗначениеЗаполнено(ДокументОбъект.Дата) Тогда
		ДокументОбъект.Дата = НачалоДня(ТекущаяДата());
	КонецЕсли;
	
	// Флаги принадлежности к учету заполняем, только если оба не заполнены
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ОтражатьВУправленческомУчете", МетаданныеДокумента) 
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("ОтражатьВБухгалтерскомУчете", МетаданныеДокумента) Тогда
		
		//По умолчанию все документы требуют отражения в бухгалтерском учете
		Если ЗначениеЗаполнено(ПараметрОбъектКопирования) Тогда
			ДокументОбъект.ОтражатьВБухгалтерскомУчете  = ПараметрОбъектКопирования.ОтражатьВБухгалтерскомУчете;
			ДокументОбъект.ОтражатьВУправленческомУчете = ПараметрОбъектКопирования.ОтражатьВБухгалтерскомУчете;
		Иначе
			Если НЕ (ДокументОбъект.ОтражатьВУправленческомУчете 
				ИЛИ ДокументОбъект.ОтражатьВБухгалтерскомУчете) Тогда
				
				ДокументОбъект.ОтражатьВУправленческомУчете = Ложь;
				ДокументОбъект.ОтражатьВБухгалтерскомУчете  = Истина;				
			КонецЕсли;
		КонецЕсли;   	
		
	ИначеЕсли ОбщегоНазначения.ЕстьРеквизитОбъекта("ОтражатьВБухгалтерскомУчете", МетаданныеДокумента) Тогда
		
		//По умолчанию все документы требуют отражения в бухгалтерском учете
		Если ЗначениеЗаполнено(ПараметрОбъектКопирования) Тогда
			ДокументОбъект.ОтражатьВБухгалтерскомУчете = ПараметрОбъектКопирования.ОтражатьВБухгалтерскомУчете;
		Иначе
			//По умолчанию все документы требуют отражения в бухгалтерском учете
			ДокументОбъект.ОтражатьВБухгалтерскомУчете = Истина
		КонецЕсли;
		
	КонецЕсли; 
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Организация", МетаданныеДокумента) 
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.Организация)) Тогда
		ДокументОбъект.Организация = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОсновнаяОрганизация");
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ПодразделениеОрганизации", МетаданныеДокумента)
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.ПодразделениеОрганизации)) Тогда
		ДокументОбъект.ПодразделениеОрганизации = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОсновноеПодразделениеОрганизации");
	КонецЕсли;
	
	//
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Подразделение", МетаданныеДокумента)
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.Подразделение)) Тогда
		
		Если ОбщегоНазначенияБК.ЕстьПредопределенныйЭлемент("Подразделение",Метаданные.ПланыВидовХарактеристик.НастройкиПользователей) Тогда
			ДокументОбъект.Подразделение = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОсновноеПодразделение");
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ЦФО", МетаданныеДокумента)
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.ЦФО)) Тогда
		
		Если ОбщегоНазначенияБК.ЕстьПредопределенныйЭлемент("ОсновноеЦФО",Метаданные.ПланыВидовХарактеристик.НастройкиПользователей) Тогда
			ДокументОбъект.ЦФО = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОсновноеЦФО");
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурноеПодразделение", МетаданныеДокумента)
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.СтруктурноеПодразделение)) Тогда
		СтруктурноеПодразделение = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОсновноеСтруктурноеПодразделениеОрганизации");
		Если СтруктурноеПодразделение = Неопределено Тогда
			ДокументОбъект.СтруктурноеПодразделение = ДокументОбъект.Организация;
		ИначеЕсли ТипЗнч(СтруктурноеПодразделение) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
			ДокументОбъект.СтруктурноеПодразделение = СтруктурноеПодразделение;
		Иначе
			ДокументОбъект.СтруктурноеПодразделение = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();							
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурноеПодразделениеОтправитель", МетаданныеДокумента)
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.СтруктурноеПодразделениеОтправитель)) Тогда
		СтруктурноеПодразделение = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОсновноеСтруктурноеПодразделениеОрганизации");
		Если СтруктурноеПодразделение = Неопределено Тогда
			ДокументОбъект.СтруктурноеПодразделениеОтправитель = ДокументОбъект.Организация;
		ИначеЕсли ТипЗнч(СтруктурноеПодразделение) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
			ДокументОбъект.СтруктурноеПодразделениеОтправитель = СтруктурноеПодразделение;
		Иначе
			ДокументОбъект.СтруктурноеПодразделениеОтправитель = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();							
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурнаяЕдиница", МетаданныеДокумента)
		И НЕ ЗначениеЗаполнено(ДокументОбъект.СтруктурнаяЕдиница) 
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("Организация", МетаданныеДокумента) Тогда
		ДокументОбъект.СтруктурнаяЕдиница = ДокументОбъект.Организация.ОсновнойБанковскийСчет;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Ответственный", МетаданныеДокумента)
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.Ответственный)) Тогда
		ДокументОбъект.Ответственный = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОсновнойОтветственный");
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Автор", МетаданныеДокумента)
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.Автор)) Тогда
		ДокументОбъект.Автор = ТекПользователь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ВидОперации", МетаданныеДокумента)
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.ВидОперации)) Тогда
		ДокументОбъект.ВидОперации = Перечисления[ДокументОбъект.ВидОперации.Метаданные().Имя][0];
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Склад", МетаданныеДокумента)
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.Склад)) Тогда
		ДокументОбъект.Склад = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОсновнойСклад");
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СкладОрдер", МетаданныеДокумента)
		И НЕ ЗначениеЗаполнено(ДокументОбъект.СкладОрдер) Тогда
		ДокументОбъект.СкладОрдер = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОсновнойСклад");
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СтавкаНДС", МетаданныеДокумента)
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.СтавкаНДС)) Тогда
		ДокументОбъект.СтавкаНДС = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОсновнаяСтавкаНДС");
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("БанковскийСчетОрганизации", МетаданныеДокумента)
		И НЕ ЗначениеЗаполнено(ДокументОбъект.БанковскийСчетОрганизации)
		И (ЗначениеЗаполнено(ДокументОбъект.Организация)) Тогда
		СчетПоУмолчанию = ДокументОбъект.Организация.ОсновнойБанковскийСчет;
		ДокументОбъект.БанковскийСчетОрганизации = СчетПоУмолчанию;
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ВалютаДокумента", МетаданныеДокумента) Тогда
			ДокументОбъект.ВалютаДокумента = СчетПоУмолчанию.ВалютаДенежныхСредств;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СчетОрганизации", МетаданныеДокумента)
		И НЕ ЗначениеЗаполнено(ДокументОбъект.СчетОрганизации)
		И (ЗначениеЗаполнено(ДокументОбъект.Организация)) Тогда
		СчетПоУмолчанию = ДокументОбъект.Организация.ОсновнойБанковскийСчет;
		ДокументОбъект.СчетОрганизации = СчетПоУмолчанию;
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ВалютаДокумента", МетаданныеДокумента) Тогда
			ДокументОбъект.ВалютаДокумента =  СчетПоУмолчанию.ВалютаДенежныхСредств;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ВалютаДокумента", МетаданныеДокумента)
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.ВалютаДокумента)) Тогда
		ДокументОбъект.ВалютаДокумента = ВалютаРегламентированногоУчета;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("КурсДокумента", МетаданныеДокумента)
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.КурсДокумента)) Тогда
		СтруктураКурсаДокумента      = ОбщегоНазначения.ПолучитьКурсВалюты(ДокументОбъект.ВалютаДокумента, ДокументОбъект.Дата);
		ДокументОбъект.КурсДокумента = СтруктураКурсаДокумента.Курс;
		
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("КратностьДокумента", МетаданныеДокумента) Тогда
			ДокументОбъект.КратностьДокумента = СтруктураКурсаДокумента.Кратность;
		КонецЕсли;
	КонецЕсли;
	
	// Если тип цен оказался не заполненным, то берем его из установок пользователя
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ТипЦен", МетаданныеДокумента)
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.ТипЦен)) Тогда
		Если ТипОперации = "Продажа" Тогда
			ДокументОбъект.ТипЦен = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОсновнойТипЦенПродажи");
		КонецЕсли;
	КонецЕсли;
	
	//если документ скопирован, флаги учета переносим как есть
	Если ЗначениеЗаполнено(ПараметрОбъектКопирования) Тогда
		
		// Флаги учета налогов заполняем, только если флаг УчитыватьНДС не заполнен.
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьНДС", МетаданныеДокумента) Тогда
			ДокументОбъект.УчитыватьНДС =  ПараметрОбъектКопирования.УчитыватьНДС ;	
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СуммаВключаетНДС", МетаданныеДокумента) Тогда
				ДокументОбъект.СуммаВключаетНДС =  ПараметрОбъектКопирования.СуммаВключаетНДС ;	
			КонецЕсли;			
		КонецЕсли;
		
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьАкциз", МетаданныеДокумента) Тогда
			ДокументОбъект.УчитыватьАкциз =  ПараметрОбъектКопирования.УчитыватьАкциз;
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СуммаВключаетАкциз", МетаданныеДокумента) Тогда			
				ДокументОбъект.СуммаВключаетАкциз = ПараметрОбъектКопирования.СуммаВключаетАкциз;
			КонецЕсли;				
		КонецЕсли;
		
		// Не используемый реквизит не заполняем
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("УдалитьДоверенность", МетаданныеДокумента) Тогда
			ДокументОбъект.УдалитьДоверенность =  "";
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(ПараметрОснование) И ТипЗнч(ПараметрОснование) <> Тип("Структура") Тогда
		
		Если Метаданные.Документы.Найти(ПараметрОснование.Метаданные().Имя) <> Неопределено Тогда
			
			МетаданныеОснования = ПараметрОснование.Метаданные();
			
			// если в основании есть реквизит Учитывать НДС, подставляем оттуда
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьНДС", МетаданныеДокумента) И
				ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьНДС", МетаданныеОснования) Тогда
				
				ДокументОбъект.УчитыватьНДС = ПараметрОснование.УчитыватьНДС ;	
				
				// Флаги учета налогов заполняем, только если флаг УчитыватьНДС не заполнен.
			ИначеЕсли ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьНДС", МетаданныеДокумента) И (НЕ НеИзменятьРеквизитыПоНДС) Тогда
				
				ДокументОбъект.УчитыватьНДС =  ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНДС(ДокументОбъект.Организация, ДокументОбъект.Дата);		
				
			КонецЕсли;
			
			// если в основании есть реквизит Учитывать акциз, подставляем оттуда
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьАкциз", МетаданныеДокумента) 
				И ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьАкциз", МетаданныеОснования) Тогда
				
				ДокументОбъект.УчитыватьАкциз =  ПараметрОснование.УчитыватьАкциз;
				
			ИначеЕсли ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьАкциз", МетаданныеДокумента) Тогда
				
				ДокументОбъект.УчитыватьАкциз =  ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаАкциза(ДокументОбъект.Организация, ДокументОбъект.Дата);
				
			КонецЕсли;
			
			Если (ОбщегоНазначения.ЕстьРеквизитОбъекта("ТипЦен", МетаданныеДокумента))
				И (ЗначениеЗаполнено(ДокументОбъект.ТипЦен)) Тогда
				
				УстановитьПризнакиИзТипаЦен = Истина;
				// Если ТипЦен - элемент справочника ТипыЦенНоменклатуры и цены выбранного типа расчетные, 
				// то флаги включения налогов надо брать из базовой цены
				Если ДокументОбъект.ТипЦен.Метаданные().Реквизиты.Найти("Рассчитывается") <> Неопределено Тогда
					ТипЦен = ?(ДокументОбъект.ТипЦен.Рассчитывается, ДокументОбъект.ТипЦен.БазовыйТипЦен, ДокументОбъект.ТипЦен);
				Иначе
					ТипЦен = ДокументОбъект.ТипЦен;
				КонецЕсли;
				
			Иначе
				
				УстановитьПризнакиИзТипаЦен = Ложь;
				
			КонецЕсли;
			
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СуммаВключаетНДС", МетаданныеДокумента) 
				И ОбщегоНазначения.ЕстьРеквизитОбъекта("СуммаВключаетНДС", МетаданныеОснования) Тогда
				
				ДокументОбъект.СуммаВключаетНДС =  ПараметрОснование.СуммаВключаетНДС ;	
				
			ИначеЕсли ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьНДС", МетаданныеДокумента) 
				И ДокументОбъект.УчитыватьНДС И ОбщегоНазначения.ЕстьРеквизитОбъекта("СуммаВключаетНДС", МетаданныеДокумента) Тогда
				
				Если УстановитьПризнакиИзТипаЦен Тогда
					ДокументОбъект.СуммаВключаетНДС = ТипЦен.ЦенаВключаетНДС;
				Иначе
					ДокументОбъект.СуммаВключаетНДС = Истина;
				КонецЕсли;
				
			КонецЕсли;
			
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СуммаВключаетАкциз", МетаданныеДокумента) 
				И ОбщегоНазначения.ЕстьРеквизитОбъекта("СуммаВключаетАкциз", МетаданныеОснования) Тогда			
				
				ДокументОбъект.СуммаВключаетАкциз = ПараметрОснование.СуммаВключаетАкциз;
				
			ИначеЕсли ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьАкциз", МетаданныеДокумента) 
				И ДокументОбъект.УчитыватьАкциз И ОбщегоНазначения.ЕстьРеквизитОбъекта("СуммаВключаетАкциз", МетаданныеДокумента) Тогда
				
				Если УстановитьПризнакиИзТипаЦен Тогда
					ДокументОбъект.СуммаВключаетАкциз = ТипЦен.ЦенаВключаетАкциз;
				Иначе
					ДокументОбъект.СуммаВключаетАкциз = Истина;
				КонецЕсли;
				
			КонецЕсли;							
		КонецЕсли;
		
	Иначе
		
		// Флаги учета налогов заполняем, только если флаг УчитыватьНДС не заполнен.
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьНДС", МетаданныеДокумента) 
			И (НЕ НеИзменятьРеквизитыПоНДС) Тогда
			ДокументОбъект.УчитыватьНДС = ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНДС(ДокументОбъект.Организация, ДокументОбъект.Дата);		
		КонецЕсли; 
		
		// Флаги учета налогов заполняем, только если флаг УчитыватьНДС не заполнен.
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьАкциз", МетаданныеДокумента) Тогда
			ДокументОбъект.УчитыватьАкциз =  ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаАкциза(ДокументОбъект.Организация, ДокументОбъект.Дата);		
		КонецЕсли; 
		
		Если (ОбщегоНазначения.ЕстьРеквизитОбъекта("ТипЦен", МетаданныеДокумента))
			И (ЗначениеЗаполнено(ДокументОбъект.ТипЦен)) Тогда
			
			// Если ТипЦен - элемент справочника ТипыЦенНоменклатуры и цены выбранного типа расчетные, 
			// то флаги включения налогов надо брать из базовой цены
			ТипЦен = ДокументОбъект.ТипЦен;
			
			// Флаги учета налогов заполняем, только если флаг УчитыватьНДС заполнен.
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьНДС", МетаданныеДокумента)
				И ДокументОбъект.УчитыватьНДС И ОбщегоНазначения.ЕстьРеквизитОбъекта("СуммаВключаетНДС", МетаданныеДокумента) И (НЕ НеИзменятьРеквизитыПоНДС) Тогда
				ДокументОбъект.СуммаВключаетНДС = ТипЦен.ЦенаВключаетНДС;
			КонецЕсли; 
			
			// Флаги учета налогов заполняем, только если флаг УчитыватьАкциз заполнен.
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьАкциз", МетаданныеДокумента) 
				И ДокументОбъект.УчитыватьАкциз И ОбщегоНазначения.ЕстьРеквизитОбъекта("СуммаВключаетАкциз", МетаданныеДокумента)Тогда			
				ДокументОбъект.СуммаВключаетАкциз = ТипЦен.ЦенаВключаетАкциз;
			КонецЕсли; 		
		Иначе          
			// Заполним значениями по умолчанию (нет, либо не заполнен ТипЦен).
			// Флаги учета налогов заполняем, только если флаг УчитыватьНДС не заполнен.
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьНДС", МетаданныеДокумента) 
				И ДокументОбъект.УчитыватьНДС И ОбщегоНазначения.ЕстьРеквизитОбъекта("СуммаВключаетНДС", МетаданныеДокумента) И (НЕ НеИзменятьРеквизитыПоНДС) Тогда			
				ДокументОбъект.СуммаВключаетНДС = Истина;
			КонецЕсли; 
			
			// Заполним значениями по умолчанию (нет, либо не заполнен ТипЦен).
			// Флаги учета налогов заполняем, только если флаг УчитыватьНДС не заполнен.
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьАкциз", МетаданныеДокумента) И ДокументОбъект.УчитыватьАкциз И ОбщегоНазначения.ЕстьРеквизитОбъекта("СуммаВключаетАкциз", МетаданныеДокумента)Тогда			
				ДокументОбъект.СуммаВключаетАкциз = Истина;
			КонецЕсли;		
		КонецЕсли;
	КонецЕсли;
	
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьКПН", МетаданныеДокумента) Тогда
		ТекЗначениеПлательщикаНаПрибыль = ПолучитьФункциональнуюОпцию("ПлательщикКПН", Новый Структура("Организация, Дата", ДокументОбъект.Организация, ДокументОбъект.Дата));
		Если ЗначениеЗаполнено(ПараметрОбъектКопирования) Тогда			
			Если ТекЗначениеПлательщикаНаПрибыль Тогда
				ДокументОбъект.УчитыватьКПН = ПараметрОбъектКопирования.УчитыватьКПН;
			Иначе
				ДокументОбъект.УчитыватьКПН = Ложь;            
			КонецЕсли;			
		Иначе
			ДокументОбъект.УчитыватьКПН = ТекЗначениеПлательщикаНаПрибыль;
		КонецЕсли;
		
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ВидУчетаНУ", МетаданныеДокумента) И ДокументОбъект.УчитыватьКПН Тогда
			ОтражатьДокументыВНалоговомУчете = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОтражатьДокументыВНалоговомУчете"); 
			Если ЗначениеЗаполнено(ПараметрОбъектКопирования) Тогда	
				ДокументОбъект.ВидУчетаНУ = ПараметрОбъектКопирования.ВидУчетаНУ;
			Иначе
				ДокументОбъект.ВидУчетаНУ  = ?(ОтражатьДокументыВНалоговомУчете, Справочники.ВидыУчетаНУ.НУ, Справочники.ВидыУчетаНУ.НеОтражаетсяВНУ);			
			КонецЕсли;			
		КонецЕсли; 
	КонецЕсли;
	
	//Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ВерсияБюджета", МетаданныеДокумента)
	//	И (НЕ ЗначениеЗаполнено(ДокументОбъект.ВерсияБюджета)) Тогда
	//	ДокументОбъект.ВерсияБюджета = КТ_РаботаСФормамиСервер.ПолучитьОсновнуюВерсию();
	//	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Год", МетаданныеДокумента)
	//		И (НЕ ЗначениеЗаполнено(ДокументОбъект.Год)) Тогда
	//		ДокументОбъект.Год = КТ_РаботаСФормамиСервер.ПолучитьГодСтрокойПоВерсииБюджета(ДокументОбъект.ВерсияБюджета);
	//	КонецЕсли;
	//КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ЗанимаемыхСтавок", МетаданныеДокумента)
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.ЗанимаемыхСтавок)) Тогда
		ДокументОбъект.ЗанимаемыхСтавок = 1;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ДатаС", МетаданныеДокумента)
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.ДатаС)) Тогда
		ДокументОбъект.ДатаС = ДокументОбъект.Дата;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ПериодРегистрации", МетаданныеДокумента)
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.ПериодРегистрации)) Тогда
		ДокументОбъект.ПериодРегистрации = НачалоМесяца(ОбщегоНазначения.ТекущаяДатаПользователя());
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ПериодНачисленияЗарплаты", МетаданныеДокумента)
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.ПериодНачисленияЗарплаты)) Тогда
		ДокументОбъект.ПериодНачисленияЗарплаты = НачалоМесяца(ТекущаяДатаСеанса());
	КонецЕсли;
	
	СтруктураДокументовПоступления = Новый Структура;
	СтруктураДокументовПоступления.Вставить("ПоступлениеТоваровУслуг");
	СтруктураДокументовПоступления.Вставить("Доверенность");
	СтруктураДокументовПоступления.Вставить("ПоступлениеДопРасходов");
	СтруктураДокументовПоступления.Вставить("ПоступлениеНМА");
	СтруктураДокументовПоступления.Вставить("ВозвратТоваровПоставщику");
	СтруктураДокументовРеализации = Новый Структура;
	СтруктураДокументовРеализации.Вставить("РеализацияТоваровУслуг");
	СтруктураДокументовРеализации.Вставить("АктОбОказанииПроизводственныхУслуг");
	СтруктураДокументовРеализации.Вставить("РеализацияУслугПоПереработке");
	СтруктураДокументовРеализации.Вставить("ВозвратТоваровОтПокупателя");
	СтруктураДокументовРеализации.Вставить("СчетНаОплатуПокупателю");
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Контрагент", МетаданныеДокумента)
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.Контрагент)) Тогда
		Если СтруктураДокументовРеализации.Свойство(МетаданныеДокумента.Имя) Тогда
			ДокументОбъект.Контрагент = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОсновнойПокупатель");
		ИначеЕсли СтруктураДокументовПоступления.Свойство(МетаданныеДокумента.Имя) Тогда
			ДокументОбъект.Контрагент = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОсновнойПоставщик");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьШапкуДокумента()

// Процедура предназначена для заполнения общих реквизитов документов по документу основанию,
//	вызывается в обработчиках событий "ОбработкаЗаполнения" в модулях документов.
//
// Параметры:
//  ДокументОбъект  - объект редактируемого документа,
//  ДокументОснование - объект документа основания
//
Процедура ЗаполнитьШапкуДокументаПоОснованию(ДокументОбъект, ДокументОснование) Экспорт
	
	Если ТипЗнч(ДокументОбъект) = Тип("Структура") ИЛИ 
		ТипЗнч(ДокументОбъект) = Тип("ДанныеФормыСтруктура") Тогда 
		МетаданныеДокумента          = ДокументОбъект.Ссылка.Метаданные();
	Иначе 
		МетаданныеДокумента          = ДокументОбъект.Метаданные();
	КонецЕсли;
	
	МетаданныеДокументаОснования = ДокументОснование.Метаданные();
	мОтображатьСтруктурныеПодразделения = ОбщегоНазначения.ПолучитьПризнакОтображенияСтруктурныхПодразделений();
	
	//заполнение даты
	Если НЕ ЗначениеЗаполнено(ДокументОбъект.Дата) Тогда
		ДокументОбъект.Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	КонецЕсли;
	
	// Организация.
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Организация", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("Организация", МетаданныеДокументаОснования) Тогда
		ДокументОбъект.Организация = ДокументОснование.Организация;
	КонецЕсли;
	
	
	// Подразделение.
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Подразделение", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("Подразделение", МетаданныеДокументаОснования) Тогда
		ДокументОбъект.Подразделение = ДокументОснование.Подразделение;
	КонецЕсли;
	
	// ПодразделениеОрганизации.
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ПодразделениеОрганизации", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("ПодразделениеОрганизации", МетаданныеДокументаОснования) Тогда
		ДокументОбъект.ПодразделениеОрганизации = ДокументОснование.ПодразделениеОрганизации;
	КонецЕсли;
	
	// СтруктурноеПодразделение.
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурноеПодразделение", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурноеПодразделение", МетаданныеДокументаОснования)
		И мОтображатьСтруктурныеПодразделения Тогда
		ДокументОбъект.СтруктурноеПодразделение = ДокументОснование.СтруктурноеПодразделение;
	КонецЕсли;
	
	// СтруктурноеПодразделение-отправитель.
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурноеПодразделениеОтправитель", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурноеПодразделениеОтправитель", МетаданныеДокументаОснования)
		И мОтображатьСтруктурныеПодразделения Тогда
		ДокументОбъект.СтруктурноеПодразделениеОтправитель = ДокументОснование.СтруктурноеПодразделениеОтправитель;
	КонецЕсли;
	
	// СтруктурноеПодразделение-отправитель.
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурноеПодразделениеОтправитель", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурноеПодразделение", МетаданныеДокументаОснования)
		И мОтображатьСтруктурныеПодразделения Тогда
		ДокументОбъект.СтруктурноеПодразделениеОтправитель = ДокументОснование.СтруктурноеПодразделение;
	КонецЕсли;
	
	// СтруктурноеПодразделение-отправитель.
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурноеПодразделение", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурноеПодразделениеОтправитель", МетаданныеДокументаОснования)
		И мОтображатьСтруктурныеПодразделения Тогда
		ДокументОбъект.СтруктурноеПодразделение = ДокументОснование.СтруктурноеПодразделениеОтправитель;
	КонецЕсли;
	
	// СтруктурноеПодразделение-получатель.
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурноеПодразделениеПолучатель", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурноеПодразделениеПолучатель", МетаданныеДокументаОснования)
		И мОтображатьСтруктурныеПодразделения Тогда
		ДокументОбъект.СтруктурноеПодразделениеПолучатель = ДокументОснование.СтруктурноеПодразделениеПолучатель;
	КонецЕсли; 
	
	// СтруктурноеПодразделение-получатель.
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурноеПодразделениеПолучатель", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурноеПодразделение", МетаданныеДокументаОснования)
		И мОтображатьСтруктурныеПодразделения Тогда
		ДокументОбъект.СтруктурноеПодразделениеПолучатель = ДокументОснование.СтруктурноеПодразделение;
	КонецЕсли;	
	
	// Склад.
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Склад", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("Склад", МетаданныеДокументаОснования) Тогда
		ДокументОбъект.Склад = ДокументОснование.Склад;
	КонецЕсли;
	
	// Ответственный.
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Ответственный", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("Ответственный", МетаданныеДокументаОснования) Тогда
		ДокументОбъект.Ответственный = ДокументОснование.Ответственный;
	КонецЕсли;
	
	//Автор
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Автор", МетаданныеДокумента)
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.Автор)) Тогда
		ДокументОбъект.Автор = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	// Контрагент.
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Контрагент", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("Контрагент", МетаданныеДокументаОснования) Тогда
		ДокументОбъект.Контрагент = ДокументОснование.Контрагент;
	КонецЕсли;
	
	// ДоговорКонтрагента.
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ДоговорКонтрагента", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("ДоговорКонтрагента", МетаданныеДокументаОснования) 
		И (НЕ ОбщегоНазначения.ЕстьРеквизитОбъекта("Организация", МетаданныеДокумента) 
		ИЛИ ДокументОбъект.Организация = ДокументОснование.ДоговорКонтрагента.Организация) Тогда
		
		ДокументОбъект.ДоговорКонтрагента = ДокументОснование.ДоговорКонтрагента;
		
		// КурсВзаиморасчетов.
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("КурсВзаиморасчетов", МетаданныеДокумента) Тогда
			// Определим дату получения курсов
			ДатаСреза = ?(ЗначениеЗаполнено(ДокументОбъект.Дата), ДокументОбъект.Дата, ОбщегоНазначения.ТекущаяДатаПользователя());
			
			СтруктураКурсаВзаиморасчетов = ОбщегоНазначения.ПолучитьКурсВалюты(ДокументОбъект.ДоговорКонтрагента.ВалютаВзаиморасчетов, ДатаСреза);
			ДокументОбъект.КурсВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Курс;
			
			// КратностьВзаиморасчетов.
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта("КратностьВзаиморасчетов", МетаданныеДокумента) Тогда
				ДокументОбъект.КратностьВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Кратность;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	// Касса
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Касса", МетаданныеДокумента) Тогда
		
		// Если в документе-основании есть структурная единица(или касса), то берем ее оттуда
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурнаяЕдиница", МетаданныеДокументаОснования) Тогда
			Если ЗначениеЗаполнено(ДокументОснование.СтруктурнаяЕдиница) 
				И ТипЗнч(ДокументОснование.СтруктурнаяЕдиница) = Тип("СправочникСсылка.Кассы") Тогда
				ДокументОбъект.Касса = ДокументОснование.СтруктурнаяЕдиница;
			КонецЕсли;
		ИначеЕсли ОбщегоНазначения.ЕстьРеквизитОбъекта("Касса", МетаданныеДокументаОснования) Тогда
			Если ЗначениеЗаполнено(ДокументОснование.Касса) Тогда
				ДокументОбъект.Касса = ДокументОснование.Касса;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	// Банковский счет 
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("БанковскийСчет", МетаданныеДокумента) Тогда
		
		// Если в документе-основании есть структурная единица(или касса), то берем ее оттуда
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурнаяЕдиница", МетаданныеДокументаОснования) Тогда
			Если ЗначениеЗаполнено(ДокументОснование.СтруктурнаяЕдиница) 
				И ТипЗнч(ДокументОснование.СтруктурнаяЕдиница) = Тип("СправочникСсылка.БанковскиеСчета") Тогда
				ДокументОбъект.БанковскийСчет = ДокументОснование.СтруктурнаяЕдиница;
			КонецЕсли;
		ИначеЕсли ОбщегоНазначения.ЕстьРеквизитОбъекта("БанковскийСчет", МетаданныеДокументаОснования) Тогда
			Если ЗначениеЗаполнено(ДокументОснование.БанковскийСчет) Тогда
				ДокументОбъект.БанковскийСчет = ДокументОснование.БанковскийСчет;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	// Банковский счет организации
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("БанковскийСчетОрганизации", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("БанковскийСчет", МетаданныеДокументаОснования) Тогда
		
		Если НЕ ЗначениеЗаполнено(ДокументОбъект.БанковскийСчетОрганизации)
			И ЗначениеЗаполнено(ДокументОбъект.БанковскийСчет)Тогда
			ДокументОбъект.БанковскийСчетОрганизации = ДокументОснование.БанковскийСчет;
		КонецЕсли;
	КонецЕсли;
	
	// Структурная единица
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурнаяЕдиница", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурнаяЕдиница", МетаданныеДокументаОснования) Тогда
		
		Если НЕ ЗначениеЗаполнено(ДокументОбъект.СтруктурнаяЕдиница)
			И ЗначениеЗаполнено(ДокументОснование.СтруктурнаяЕдиница)Тогда
			ДокументОбъект.СтруктурнаяЕдиница = ДокументОснование.СтруктурнаяЕдиница;
		КонецЕсли;
	КонецЕсли;
	
	// ВалютаДокумента.
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ВалютаДокумента", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("ВалютаДокумента", МетаданныеДокументаОснования) Тогда
		
		// Если есть касса или банковский счет, то валюта должна браться только оттуда
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Касса", МетаданныеДокумента) Тогда
			Если ЗначениеЗаполнено(ДокументОбъект.Касса) Тогда
				ДокументОбъект.ВалютаДокумента = ДокументОбъект.Касса.ВалютаДенежныхСредств;
			КонецЕсли;
		ИначеЕсли ОбщегоНазначения.ЕстьРеквизитОбъекта("БанковскийСчет", МетаданныеДокумента) Тогда
			Если ЗначениеЗаполнено(ДокументОбъект.БанковскийСчет) Тогда
				ДокументОбъект.ВалютаДокумента = ДокументОбъект.БанковскийСчет.ВалютаДенежныхСредств;
			КонецЕсли;
		Иначе
			ДокументОбъект.ВалютаДокумента = ДокументОснование.ВалютаДокумента;
		КонецЕсли;
		
		// КурсДокумента.
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("КурсДокумента", МетаданныеДокумента) Тогда
			// Определим дату получения курсов
			ДатаСреза = ?(ЗначениеЗаполнено(ДокументОбъект.Дата), ДокументОбъект.Дата, ОбщегоНазначения.ТекущаяДатаПользователя());
			
			СтруктураКурсаДокумента = ОбщегоНазначения.ПолучитьКурсВалюты(ДокументОбъект.ВалютаДокумента, ДатаСреза);
			ДокументОбъект.КурсДокумента = СтруктураКурсаДокумента.Курс;
			
			// КратностьДокумента.
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта("КратностьДокумента", МетаданныеДокумента) Тогда
				ДокументОбъект.КратностьДокумента = СтруктураКурсаДокумента.Кратность;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	// ТипЦен.
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ТипЦен", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("ТипЦен", МетаданныеДокументаОснования) Тогда
		ДокументОбъект.ТипЦен = ДокументОснование.ТипЦен;
	КонецЕсли;
	
	// Тип скидки.
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ТипСкидкиНаценки", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("ТипСкидкиНаценки", МетаданныеДокументаОснования) Тогда
		ДокументОбъект.ТипСкидкиНаценки = ДокументОснование.ТипСкидкиНаценки;
	КонецЕсли;
	
	// Дисконтная карта
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ДисконтнаяКарта", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("ДисконтнаяКарта", МетаданныеДокументаОснования) Тогда
		ДокументОбъект.ДисконтнаяКарта = ДокументОснование.ДисконтнаяКарта;
	КонецЕсли;
	
	// УчитыватьНДС.
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьНДС", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьНДС", МетаданныеДокументаОснования) Тогда
		ДокументОбъект.УчитыватьНДС = ДокументОснование.УчитыватьНДС;
	КонецЕсли;
	
	// СуммаВключаетНДС.
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СуммаВключаетНДС", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("СуммаВключаетНДС", МетаданныеДокументаОснования) Тогда
		ДокументОбъект.СуммаВключаетНДС = ДокументОснование.СуммаВключаетНДС;
	КонецЕсли;
	
	// УчитыватьАкциз.
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьАкциз", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьАкциз", МетаданныеДокументаОснования) Тогда
		ДокументОбъект.УчитыватьАкциз = ДокументОснование.УчитыватьАкциз;
	КонецЕсли;
	
	// СуммаВключаетАкциз.
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СуммаВключаетАкциз", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("СуммаВключаетАкциз", МетаданныеДокументаОснования) Тогда
		ДокументОбъект.СуммаВключаетАкциз = ДокументОснование.СуммаВключаетАкциз;
	КонецЕсли;
	
	// ОтражатьВУправленческомУчете.
	// Если есть в основании, копируем из основания, иначе - Истина.
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ОтражатьВУправленческомУчете", МетаданныеДокумента) Тогда
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ОтражатьВУправленческомУчете", МетаданныеДокументаОснования) Тогда
			ДокументОбъект.ОтражатьВУправленческомУчете = ДокументОснование.ОтражатьВУправленческомУчете;
		Иначе
			ДокументОбъект.ОтражатьВУправленческомУчете = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ОтражатьВБухгалтерскомУчете", МетаданныеДокумента) Тогда
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ОтражатьВБухгалтерскомУчете", МетаданныеДокументаОснования) Тогда
			ДокументОбъект.ОтражатьВБухгалтерскомУчете = ДокументОснование.ОтражатьВБухгалтерскомУчете;
		Иначе
			ДокументОбъект.ОтражатьВБухгалтерскомУчете = Истина;
		КонецЕсли;
	КонецЕсли;
	
	//установка признака "УчитыватьКПН"
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьКПН", МетаданныеДокумента) Тогда
		
		ТекЗначениеПлательщикаНаПрибыль = ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(ДокументОбъект.Организация, ДокументОбъект.Дата);
		
		ДокументОбъект.УчитыватьКПН = ТекЗначениеПлательщикаНаПрибыль;		
		
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("УчитыватьКПН", МетаданныеДокументаОснования) Тогда
			Если ТекЗначениеПлательщикаНаПрибыль Тогда
				ДокументОбъект.УчитыватьКПН = ДокументОснование.УчитыватьКПН;
			Иначе
				ДокументОбъект.УчитыватьКПН = Ложь;            
			КонецЕсли;			
		КонецЕсли;
		
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ВидУчетаНУ", МетаданныеДокумента) Тогда								
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ВидУчетаНУ", МетаданныеДокументаОснования) Тогда				
				ДокументОбъект.ВидУчетаНУ = ?(ДокументОбъект.УчитыватьКПН, ДокументОснование.ВидУчетаНУ, Справочники.ВидыУчетаНУ.НеОтражаетсяВНУ);
			Иначе			                                                                                         
				ОтражатьДокументыВНалоговомУчете = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(Пользователи.ТекущийПользователь(), "ОтражатьДокументыВНалоговомУчете"); 
				Если ДокументОбъект.УчитыватьКПН Тогда
					ДокументОбъект.ВидУчетаНУ  = ?(ОтражатьДокументыВНалоговомУчете, Справочники.ВидыУчетаНУ.НУ, Справочники.ВидыУчетаНУ.НеОтражаетсяВНУ);			
				Иначе
					ДокументОбъект.ВидУчетаНУ  = Справочники.ВидыУчетаНУ.НеОтражаетсяВНУ;				
				КонецЕсли;			
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли;
	
	//данные по доверенности
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ДоверенностьНомер", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("ДоверенностьНомер", МетаданныеДокументаОснования) Тогда
		ДокументОбъект.ДоверенностьНомер = ДокументОснование.ДоверенностьНомер;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ДоверенностьДата", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("ДоверенностьДата", МетаданныеДокументаОснования) Тогда
		ДокументОбъект.ДоверенностьДата = ДокументОснование.ДоверенностьДата;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ДоверенностьЛицо", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("ДоверенностьЛицо", МетаданныеДокументаОснования) Тогда
		ДокументОбъект.ДоверенностьЛицо = ДокументОснование.ДоверенностьЛицо;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ДоверенностьВыдана", МетаданныеДокумента)
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("ДоверенностьВыдана", МетаданныеДокументаОснования) Тогда
		ДокументОбъект.ДоверенностьВыдана = ДокументОснование.ДоверенностьВыдана;
	КонецЕсли;     
	
КонецПроцедуры // ЗаполнитьШапкуДокументаПоОснованию()

