﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИК КАНАЛОВ СООБЩЕНИЙ ДЛЯ ВЕРСИИ 1.0.3.5 ИНТЕРФЕЙСА СООБЩЕНИЙ
//  УДАЛЕННОГО АДМИНИСТРИРОВАНИЯ
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает пространство имен версии интерфейса сообщений.
//
// Возвращаемое значение:
//	Строка - 
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/1cFresh/Application/Permissions/Control/" + Версия(); // @Non-NLS-1
	
КонецФункции

// Возвращает версию интерфейса сообщений, обслуживаемую обработчиком.
//
// Возвращаемое значение:
//	Строка - 
Функция Версия() Экспорт
	
	Возврат "1.0.0.1";
	
КонецФункции

// Возвращает базовый тип для сообщений версии.
//
// Возвращаемое значение:
//	ТипОбъектаXDTO - 
Функция БазовыйТип() Экспорт
	
	Возврат СообщенияВМоделиСервисаПовтИсп.ТипТело();
	
КонецФункции

// Выполняет обработку входящих сообщений модели сервиса
//
// Параметры:
//  Сообщение - ОбъектXDTO - входящее сообщение,
//  Отправитель - ПланОбменаСсылка.ОбменСообщениями - узел плана обмена, соответствующий отправителю сообщения
//  СообщениеОбработано - Булево - флаг успешной обработки сообщения. Значение данного параметра необходимо
//    установить равным Истина в том случае, если сообщение было успешно прочитано в данном обработчике.
//
Процедура ОбработатьСообщениеМоделиСервиса(Знач Сообщение, Знач Отправитель, СообщениеОбработано) Экспорт
	
	СообщениеОбработано = Истина;
	
	Словарь = СообщенияКонтрольУправленияРазрешениямиИнтерфейс;
	ТипСообщения = Сообщение.Body.Тип();
	
	Если ТипСообщения = Словарь.СообщениеОбработанЗапросРазрешенийИнформационнойБазы(Пакет()) Тогда
		ОбработанЗапросНеразделенногоСеанса(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеОбработанЗапросРазрешенийОбластиДанных(Пакет()) Тогда
		ОбработанЗапросРазделенногоСеанса(Сообщение, Отправитель);
	Иначе
		СообщениеОбработано = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработанЗапросНеразделенногоСеанса(Знач Сообщение, Знач Отправитель)
	
	НачатьТранзакцию();
	
	Попытка
		
		Для Каждого РезультатОбработкиЗапроса Из Сообщение.Body.ProcessingResultList.ProcessingResult Цикл
			
			СообщенияКонтрольУправленияРазрешениямиРеализация.ОбработанЗапросНеразделенногоСеанса(
				РезультатОбработкиЗапроса.RequestUUID,
				СообщенияКонтрольУправленияРазрешениямиИнтерфейс.СловарьТиповРезультатовОбработкиЗапросов()[РезультатОбработкиЗапроса.ProcessingResultType],
				РезультатОбработкиЗапроса.RejectReason);
				
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

Процедура ОбработанЗапросРазделенногоСеанса(Знач Сообщение, Знач Отправитель)
	
	НачатьТранзакцию();
	
	Попытка
		
		Для Каждого РезультатОбработкиЗапроса Из Сообщение.Body.ProcessingResultList.ProcessingResult Цикл
			
			СообщенияКонтрольУправленияРазрешениямиРеализация.ОбработанЗапросРазделенногоСеанса(
				РезультатОбработкиЗапроса.RequestUUID,
				СообщенияКонтрольУправленияРазрешениямиИнтерфейс.СловарьТиповРезультатовОбработкиЗапросов()[РезультатОбработкиЗапроса.ProcessingResultType],
				РезультатОбработкиЗапроса.RejectReason);
				
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти
