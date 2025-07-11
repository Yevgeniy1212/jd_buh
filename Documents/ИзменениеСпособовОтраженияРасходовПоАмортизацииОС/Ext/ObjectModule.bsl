﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснования(ДанныеЗаполнения);
		Возврат;
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда 
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;

	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	УправлениеВнеоборотнымиАктивамиСервер.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", Новый Структура("ОсновноеСредство"), Отказ);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.ИзменениеСпособовОтраженияРасходовПоАмортизацииОС.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Если вдруг не удалось получить параметры проведения и не установлен флаг Отказ, то просто выйдем из проведения
	Если ПараметрыПроведения = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	Если ПараметрыПроведения.СобытияОСОрганизацийТаблицаОС.Количество() <> 0 Тогда 
		УчетОС.СформироватьДвиженияРегистрацияСобытияОС(ПараметрыПроведения.СобытияОСОрганизацийТаблицаОС, 
														ПараметрыПроведения.Реквизиты,
														Движения, Отказ);
	КонецЕсли;

	Если ПараметрыПроведения.СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчетТаблицаОС.Количество() <> 0 Тогда 
		УчетОС.СформироватьДвиженияСпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчет(ПараметрыПроведения.СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчетТаблицаОС,
				ПараметрыПроведения.Реквизиты,
				Движения, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	              	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура выполняет заполнение документа по документу-основанию
//
Процедура ЗаполнитьПоДокументуОснования(Основание) Экспорт
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПеремещениеОС") Тогда
		Документы.ИзменениеСпособовОтраженияРасходовПоАмортизацииОС.ЗаполнитьДокументПоПеремещениеОС(ЭтотОбъект, Основание);
	КонецЕсли;
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета(), , , , Основание);

КонецПроцедуры // ЗаполнитьПоДокументуОснования()

#КонецЕсли
