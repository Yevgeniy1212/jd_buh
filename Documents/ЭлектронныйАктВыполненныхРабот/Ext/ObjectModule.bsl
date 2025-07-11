﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий
	
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	ДокументАВР_ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ДокументАВР_ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов) Экспорт
	
	ПроверятьДатуВыполненияТЧ = Ложь;
	Если Не ЗначениеЗаполнено(ЭтотОбъект.ДатаВыполненияРабот) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДатаВыполненияРабот");
		ПроверятьДатуВыполненияТЧ = Истина;
	КонецЕсли;
	
	ЭСФСерверПереопределяемый.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ДокументАВР_ПроверитьЗаполнениеТабличнойЧастиПострочно(ЭтотОбъект, ЭтотОбъект.Услуги, "Услуги", ПроверятьДатуВыполненияТЧ, Отказ);
	
КонецПроцедуры

Процедура ДокументАВР_ПроверитьЗаполнениеТабличнойЧастиПострочно(ЭтотОбъект, ПроверяемаяТабличнаячасть, ИмяТабличнойЧасти, ПроверятьДатуВыполненияТЧ, Отказ)
	
	Для Каждого СтрокаТабличнойЧасти Из ПроверяемаяТабличнаячасть Цикл
		
		ТекстСообщенияШаблон = НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2 списка ""%3""'");
		
		Если Не ЗначениеЗаполнено(СтрокаТабличнойЧасти.Номенклатура) Тогда
			//Номенклатура
			ТекстСообщения = ЭСФКлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(ТекстСообщенияШаблон, 
			"Номенклатура", 
			Формат(СтрокаТабличнойЧасти.НомерСтроки, "ЧН=0; ЧГ="), 
			ИмяТабличнойЧасти);
			
			Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки-1, "ЧН=0; ЧГ=") + "].Номенклатура";
			ЭСФКлиентСерверПереопределяемый.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;	
		
		Если Не ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтавкаНДС) Тогда
			//ЕдиницаИзмерения
			ТекстСообщения = ЭСФКлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(ТекстСообщенияШаблон, 
			"СтавкаНДС", 
			Формат(СтрокаТабличнойЧасти.НомерСтроки, "ЧН=0; ЧГ="), 
			ИмяТабличнойЧасти);
			
			Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки-1, "ЧН=0; ЧГ=") + "].СтавкаНДС";
			ЭСФКлиентСерверПереопределяемый.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если ПроверятьДатуВыполненияТЧ Тогда
			ТекстСообщенияШаблонДата = НСтр("ru = 'Необходимо заполнить колонку ""Дата выполнения работ"" в строке %2 списка ""%3"" или поле ""Дата выполнения работ"" в разделе A'");
			
			Если Не ЗначениеЗаполнено(СтрокаТабличнойЧасти.ДатаВыполнения) Тогда
				//ДатаВыполнения
				ТекстСообщения = ЭСФКлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(ТекстСообщенияШаблонДата, 
				"ДатаВыполнения", 
				Формат(СтрокаТабличнойЧасти.НомерСтроки, "ЧН=0; ЧГ="), 
				ИмяТабличнойЧасти);
				
				Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки-1, "ЧН=0; ЧГ=") + "].ДатаВыполнения";
				ЭСФКлиентСерверПереопределяемый.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ОбработкаОбменЭСФ = ЭСФСерверПовтИсп.ОбработкаОбменЭСФ();
	ОбработкаОбменЭСФ.ДокументАВР_ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Процедура ПриКопировании(ОбъектКопирования)
	
	Если ЗначениеЗаполнено(ОбъектКопирования.Идентификатор) Тогда
		Идентификатор = Неопределено;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОбъектКопирования.ЭЦП) Тогда
		ЭЦП = Неопределено;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОбъектКопирования.РегистрационныйНомер) Тогда
		РегистрационныйНомер = Неопределено;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОбъектКопирования.Статус) Тогда
		Статус = Перечисления.СтатусыАВР.Черновик; // по умолчанию новый документ имеет статус Черновик
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОбъектКопирования.ДокументОснование) Тогда
		ДокументОснование = Неопределено; 
	КонецЕсли;
	
	ЭтотОбъект.Ошибки.Очистить();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ОбработкаОбменЭСФ = ЭСФСерверПовтИсп.ОбработкаОбменЭСФ();
	ОбработкаОбменЭСФ.ДокументАВР_ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	ОбработкаОбменЭСФ = ЭСФСерверПовтИсп.ОбработкаОбменЭСФ();
	ОбработкаОбменЭСФ.ДокументАВР_ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли