﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ПолучитьДанныеМонитора(ПараметрыЗадания, АдресРезультата) Экспорт
	
	МониторПортала1СИТС.ЗаписатьИнформациюВЖурналРегистрации(
		НСтр("ru = 'Начало получения данных Монитора Портала 1С:ИТС'"));
	
	РезультатОперации = МониторПортала1СИТС.ДанныеМонитора();
	
	Если ПустаяСтрока(РезультатОперации.ИмяОшибки) Тогда
		
		РезультатОперации.Данные.Вставить("ПредупрежденияСервисов", Новый Структура);
		РезультатОперации.Данные.ПредупрежденияСервисов.Вставить(
			"ДанныеПредупреждений",
			МониторПортала1СИТС.КэшУведомленийМонитора());
		РезультатОперации.Данные.ПредупрежденияСервисов.Вставить(
			"ЕстьПредупреждения",
			(РезультатОперации.Данные.ПредупрежденияСервисов.ДанныеПредупреждений.Количество() > 0));
			
		ДополнительныеДанные = Неопределено;
		ИнтеграцияПодсистемБИП.ПриПолученииДополнительныхДанныхМонитора(
			ДополнительныеДанные,
			ПараметрыЗадания.ПараметрыПолученияДополнительныхДанных);
		МониторПортала1СИТСПереопределяемый.ПриПолученииДополнительныхДанныхМонитора(
			ДополнительныеДанные,
			ПараметрыЗадания.ПараметрыПолученияДополнительныхДанных);
		РезультатОперации.Вставить("ДополнительныеДанные", ДополнительныеДанные);
	ИначеЕсли РезультатОперации.ИмяОшибки <> "НеЗаполненыДанныеАутентификации" Тогда
		МониторПортала1СИТС.ЗаписатьОшибкуВЖурналРегистрации(
			НСтр("ru = 'Не удалось получить данные Монитора Портала 1С:ИТС.'")
				+ Символы.ПС
				+ РезультатОперации.ИнформацияОбОшибке);
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(РезультатОперации, АдресРезультата);
	
	МониторПортала1СИТС.ЗаписатьИнформациюВЖурналРегистрации(
		НСтр("ru = 'Завершено получение данных Монитора Портала 1С:ИТС'"));
	
КонецПроцедуры

Процедура ПолучитьДеталиДанныхМонитора(Параметры, АдресРезультата) Экспорт
	
	МониторПортала1СИТС.ЗаписатьИнформациюВЖурналРегистрации(
		НСтр("ru = 'Начало получения деталей данных Монитора Портала 1С:ИТС'"));
	
	РезультатОперации = МониторПортала1СИТС.ДеталиДанныхМонитора(
		Параметры.Логин,
		Параметры.Договоры1СИТС,
		Параметры.АктивацияСервисовСопровождения,
		Параметры.ДоговорыНаСервисы);
	ПоместитьВоВременноеХранилище(РезультатОперации, АдресРезультата);
	
	Если Не ПустаяСтрока(РезультатОперации.ИмяОшибки) Тогда
		МониторПортала1СИТС.ЗаписатьОшибкуВЖурналРегистрации(
			НСтр("ru = 'Не удалось получить детали данных Монитора Портала 1С:ИТС.'")
				+ Символы.ПС
				+ РезультатОперации.ИнформацияОбОшибке);
	КонецЕсли;
	
	МониторПортала1СИТС.ЗаписатьИнформациюВЖурналРегистрации(
		НСтр("ru = 'Завершено получение деталей данных Монитора Портала 1С:ИТС'"));
	
КонецПроцедуры

Процедура ПолучитьДеталиИнформацияОДоступномОбновлении(Параметры, АдресРезультата) Экспорт
	
	МониторПортала1СИТС.ЗаписатьИнформациюВЖурналРегистрации(
		НСтр("ru = 'Начало получения деталей информации о доступном обновлении'"));
	
	МодульПолучениеОбновленийПрограммы = ОбщегоНазначения.ОбщийМодуль("ПолучениеОбновленийПрограммы");
	ИнформацияОбОбновлении = МодульПолучениеОбновленийПрограммы.ИнформацияОДоступномОбновлении();
	ПоместитьВоВременноеХранилище(ИнформацияОбОбновлении, АдресРезультата);
	
	Если Не ПустаяСтрока(ИнформацияОбОбновлении.ИмяОшибки) Тогда
		МониторПортала1СИТС.ЗаписатьОшибкуВЖурналРегистрации(
			НСтр("ru = 'Не удалось получить детали информации о доступном обновлении.'")
				+ Символы.ПС
				+ ИнформацияОбОбновлении.ИнформацияОбОшибке);
	КонецЕсли;
	
	МониторПортала1СИТС.ЗаписатьИнформациюВЖурналРегистрации(
		НСтр("ru = 'Завершено получение деталей информации о доступном обновлении'"));
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли