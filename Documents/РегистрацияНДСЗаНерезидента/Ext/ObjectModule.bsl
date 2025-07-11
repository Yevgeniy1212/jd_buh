﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

#Область УправлениеДоступом

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ОбщегоНазначенияБК.ЗаполнитьНаборыПоОрганизацииСтурктурномуПодразделению(ЭтотОбъект, Таблица, "Организация", "СтруктурноеПодразделение");
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения <> Неопределено Тогда 
		Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")  
			И ДанныеЗаполнения.Свойство("АдресВременногоХранилища") Тогда			
			Документы.РегистрацияНДСЗаНерезидента.ЗаполнитьНДСПоТаблицеДокументов(ЭтотОбъект, ДанныеЗаполнения);						
		Иначе	
			Документы.РегистрацияНДСЗаНерезидента.ЗаполнитьПоДокументуОснованию(ЭтотОбъект, ДанныеЗаполнения);
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());	
	
	Если Не ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		СтруктураКурсаОбъекта = ОбщегоНазначенияБК.ПолучитьКурсВалюты(ВалютаДокумента, Дата);
		
		КурсВзаиморасчетов 		= СтруктураКурсаОбъекта.Курс;
		КратностьВзаиморасчетов = СтруктураКурсаОбъекта.Кратность;
		
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.РегистрацияНДСЗаНерезидента.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	
	Если ВидОперации = Перечисления.ВидыОперацийРегистрацииНДСЗаНерезидента.ПринятиеНДСКЗачету и не Отказ Тогда
		Документы.РегистрацияНДСЗаНерезидента.ВыполнитьКонтрольНДСкЗачету(Отказ, ПараметрыПроведения.ТаблицаНДС);	
	КонецЕсли;	
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	УчетНДСИАкциза.СформироватьДвиженияНДСЗаНерезидента(ПараметрыПроведения.ТаблицаНДС, ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
    
    РаботаСДоговорамиКонтрагентов.ЗаполнитьДоговорПередЗаписью(ЭтотОбъект);
    
	Сумма 		= ДокументыПоступления.Итог("Сумма");
	СуммаНДС 	= ДокументыПоступления.Итог("СуммаНДС");
	СуммаСНДС 	= ДокументыПоступления.Итог("СуммаСНДС");
	
	Если НЕ УчитыватьКПН Тогда
		ВидУчетаНУ = Справочники.ВидыУчетаНУ.ПустаяСсылка();
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		ТекстСообщения = НСтр("ru = 'Документ не записан ...'");
		ОбщегоНазначенияБК.ОшибкаПриПроведении(ТекстСообщения, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если НЕ ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Организация, Дата)
  		ИЛИ НЕ УчитыватьКПН Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ВидУчетаНУ");
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецЕсли
