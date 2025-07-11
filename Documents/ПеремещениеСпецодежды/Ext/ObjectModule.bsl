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
	
	УчетТоваров.ЗаполнитьНаборыПоОрганизацииСтрутурномуПодразделениюСкладу(ЭтотОбъект, Таблица, "Организация", "СтруктурноеПодразделениеОтправитель", "СкладОтправитель");
	УчетТоваров.ЗаполнитьНаборыПоОрганизацииСтрутурномуПодразделениюСкладу(ЭтотОбъект, Таблица, "Организация", "СтруктурноеПодразделениеПолучатель", "СкладПолучатель");
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();	
	ОрганизацияПлательщикНалогаНаПрибыль 			= ПолучитьФункциональнуюОпцию("ПлательщикКПН", Новый Структура("Организация, Период", Организация, Дата));
	
	//Учет ВР всегда идет только балансовым методом
	ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль 	= ОрганизацияПлательщикНалогаНаПрибыль И ПроцедурыНалоговогоУчета.ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль(Организация, Дата);
	
	// Проверка заполнения табличной части "Товары"
	Если НЕ УчитыватьКПН ИЛИ (НЕ ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль ИЛИ НЕ ВидУчетаНУ = Справочники.ВидыУчетаНУ.НУ) Тогда 		
		МассивНепроверяемыхРеквизитов.Добавить("ВидУчетаНУ");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетУчетаНУ");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.НовыйСчетУчетаНУ");   		
	КонецЕсли;

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета(),,, ОбъектКопирования.Ссылка);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.ПеремещениеСпецодежды.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Таблица списанных товаров
	ТаблицаСписанныеТовары = УчетТоваров.ПодготовитьТаблицуСписанныеТовары(ПараметрыПроведения.СписаниеТоваровТаблицаТовары,
			ПараметрыПроведения.СписаниеТоваровРеквизиты, Отказ);
			
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	УчетТоваров.СформироватьДвиженияСписаниеТоваров(ТаблицаСписанныеТовары,
			ПараметрыПроведения.СписаниеТоваровРеквизиты, Движения, Отказ);
			
	СформироватьЗаписиПоСпецОдежде(Отказ);
			
КонецПроцедуры

Процедура СформироватьЗаписиПоСпецОдежде(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата", Новый Граница(Дата, ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("Мол", МОЛОтправитель);
	Запрос.УстановитьПараметр("Склад", СкладОтправитель);
	Запрос.Текст =
	"ВЫБРАТЬ Номенклатура, ДатаВыдачи, ДатаОкончания, КоличествоОстаток КАК Количество
	|ИЗ РегистрНакопления.СрокСлужбыСО.Остатки(&Дата, МОЛПолучатель = &Мол И СкладПолучатель = &Склад) КАК СрокСлужбыСООстатки";
	тзОстатки = Запрос.Выполнить().Выгрузить();
	Отбор = Новый Структура("Номенклатура, ДатаВыдачи, ДатаОкончания", );
	
	ТаблицаДвижений = Движения.СрокСлужбыСО.Выгрузить();
	ТаблицаДвижений.Очистить();
	Для каждого текСтрока из Товары цикл
		Движение 					= ТаблицаДвижений.Добавить();
		Движение.Номенклатура 		= текСтрока.Номенклатура;
		Движение.СрокСлужбы 		= текстрока.СрокСлужбы;
		Движение.ДатаОкончания 		= текстрока.ДатаОкончания;
		Движение.ДатаВыдачи 		= текстрока.ДатаВыдачи;
		Движение.СкладПолучатель 	= СкладОтправитель;
		Движение.МОЛПолучатель 		= МОЛОтправитель;
		Движение.Количество			= текстрока.Количество;
		
		ЗаполнитьЗначенияСвойств(Отбор, Движение);
		МасСтр = тзОстатки.НайтиСтроки(Отбор);
		Если МасСтр.Количество()=0 Тогда
			Сообщить("У МОЛа """+МОЛОтправитель+""" нет остатка СО """+текСтрока.Номенклатура+""" (выдано "+Формат(текстрока.ДатаВыдачи, "ДФ=д.ММ.гггг")+")", СтатусСообщения.ОченьВажное);
		ИначеЕсли МасСтр.Получить(0).Количество<текстрока.Количество Тогда
			Сообщить("У МОЛа """+МОЛОтправитель+""" не достаточно СО """+текСтрока.Номенклатура+""" (выдано "+Формат(текстрока.ДатаВыдачи, "ДФ=д.ММ.гггг")+"), есть "+МасСтр.Получить(0).Количество+", требуется "+текстрока.Количество, СтатусСообщения.ОченьВажное);
		КонецЕсли;
	Конеццикла;
	Движения.СрокСлужбыСО.мПериод          = Дата;
	Движения.СрокСлужбыСО.мТаблицаДвижений = ТаблицаДвижений;
	Движения.СрокСлужбыСО.ВыполнитьРасход();
	
	ТаблицаДвижений = Движения.СрокСлужбыСО.Выгрузить();
	ТаблицаДвижений.Очистить();
	Для каждого текСтрока из Товары цикл
		Движение 					= ТаблицаДвижений.Добавить();
		Движение.Номенклатура 		= текСтрока.Номенклатура;
		Движение.СрокСлужбы 		= текстрока.СрокСлужбыОст;
		Движение.ДатаОкончания 		= текстрока.ДатаОкончания;
		Движение.ДатаВыдачи 		= Дата;
		Движение.СкладПолучатель 	= СкладПолучатель;
		Движение.МОЛПолучатель 		= МОЛПолучатель;
		Движение.Количество			= текстрока.Количество;
	Конеццикла;
	Движения.СрокСлужбыСО.мПериод          = Дата;
	Движения.СрокСлужбыСО.мТаблицаДвижений = ТаблицаДвижений;
	Движения.СрокСлужбыСО.ВыполнитьПриход();
	
	Движения.ВыданнаяСО.Очистить();
	Для каждого текСтрока Из Товары Цикл
		Если Не СкладОтправитель=СкладПолучатель Или Не МОЛОтправитель=МОЛПолучатель Тогда
			Движение = Движения.ВыданнаяСО.Добавить();
			ЗаполнитьЗначенияСвойств(Движение, текСтрока, "Номенклатура,ДатаВыдачи,СрокСлужбы,ДатаОкончания,Количество");
			Движение.Период 			= Дата;
			Движение.Склад 				= СкладОтправитель;
			Движение.МОЛ 				= МОЛОтправитель;
			Движение.Перемещено 		= Истина;
			Движение.СнятоСУчета 		= Истина;
		КонецЕсли;
		Движение = Движения.ВыданнаяСО.Добавить();
		ЗаполнитьЗначенияСвойств(Движение, текСтрока, "Номенклатура,ДатаОкончания,Количество,Цена,Сумма");
		Движение.Период 			= Дата;
		Движение.Склад 				= СкладПолучатель;
		Движение.МОЛ 				= МОЛПолучатель;
		Движение.ДатаВыдачи 		= Дата;
		Движение.СрокСлужбы 		= текстрока.СрокСлужбыОст;
		Движение.Перемещено 		= Истина;
	КонецЦикла;
	
КонецПроцедуры	


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли


