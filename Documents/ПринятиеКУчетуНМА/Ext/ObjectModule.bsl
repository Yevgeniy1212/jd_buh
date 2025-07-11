﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		Документы.ПринятиеКУчетуНМА.ЗаполнитьПоДокументуОснования(ЭтотОбъект, ДанныеЗаполнения);
		Возврат;
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда 
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	УправлениеВнеоборотнымиАктивамиСервер.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "НМА", Новый Структура("НематериальныйАктив"), Отказ);
	
	ПроверитьЗаполнениеТабличнойЧастиПострочно(Отказ) ;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.ПринятиеКУчетуНМА.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Если вдруг не удалось получить параметры проведения и не установлен флаг Отказ, то просто выйдем из проведения
	Если ПараметрыПроведения = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	//Проверем возможность изменения состояния НМА
	УчетНМА.ПроверитьВозможностьИзмененияСостоянияНМА(ПараметрыПроведения.ТаблицаСостоянийНМА,	Отказ);

	Если Отказ Тогда
		Возврат;
	КонецЕсли;
		
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	УправлениеВнеоборотнымиАктивамиСервер.СформироватьДвиженияОбъектыНалоговогоУчетаФА(ПараметрыПроведения.ТаблицаОбъектыНалоговогоУчетаФА, ПараметрыПроведения.Реквизиты ,
		 Движения, Отказ);

	 УправлениеВнеоборотнымиАктивамиСервер.СформироватьДвиженияФАУчитываемыхОтдельно(ПараметрыПроведения.ТаблицаФАУчитываемыеОтдельно, ПараметрыПроведения.Реквизиты,
		 Движения, Отказ);
		 
	УчетНМА.СформироватьДвиженияПервоначальныеСведенияНМАБухгалтерскийУчет(ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаНМА,
	     Движения, Отказ);

	УчетНМА.СформироватьДвиженияИзменениеСостоянияНМА(ПараметрыПроведения.ТаблицаСостоянийНМА,
		 Движения, Отказ);
		 
	УчетНМА.СформироватьДвиженияСпособыОтраженияРасходовПоАмортизацииНМАБухгалтерскийУчет(ПараметрыПроведения.ТаблицаНМА, ПараметрыПроведения.Реквизиты,
		 Движения, Отказ);
		 
	УчетНМА.СформироватьДвиженияСчетаУчетаНМА(ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаНМА, 
		 Движения, Отказ);
		 
	УчетНМА.СформироватьДвиженияОбъектыИмущественногоНалога(ПараметрыПроведения.ТаблицаОбъектыИмущественногоНалога, ПараметрыПроведения.РеквизитыОбъектыИмущественногоНалога,
		 Движения, Отказ);
				 
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПроверитьЗаполнениеТабличнойЧастиПострочно(Отказ, ПараметрыПроверки = Неопределено)
	
	Для Каждого СтрокаТабличнойЧасти ИЗ НМА Цикл
		
		РеквизитыДляПроверки = Новый Структура;

		Если СтрокаТабличнойЧасти.НачислятьАмортизациюБУ Тогда
			
			РеквизитыДляПроверки.Вставить("СтоимостьБУ");
			РеквизитыДляПроверки.Вставить("СпособНачисленияАмортизацииБУ");
			РеквизитыДляПроверки.Вставить("СпособОтраженияРасходовПоАмортизацииБУ");
			
			// При производственном способе начисления амортизации не требуется знать информацию о сроке полезного использования,
			// т.к. при данном способе срок полезного использования не участвует в расчете амортизации. 
			Если СтрокаТабличнойЧасти.СпособНачисленияАмортизацииБУ <> Перечисления.СпособыНачисленияАмортизацииНМА.Производственный Тогда
				РеквизитыДляПроверки.Вставить("СрокПолезногоИспользованияБУ");
			КонецЕсли;
			
			Если СтрокаТабличнойЧасти.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.Производственный Тогда
				РеквизитыДляПроверки.Вставить("ОбъемПродукцииРаботДляВычисленияАмортизацииБУ", СтатусСообщения.Важное);
			КонецЕсли;		
					
		КонецЕсли;
		
		Если СтрокаТабличнойЧасти.ПризнакФиксированногоАктива Тогда				
			РеквизитыДляПроверки.Вставить("ГруппаНУ"); 				
		КонецЕсли;
		
		// Цикл по проверяемым полям
		Для Каждого КлючЗначение Из РеквизитыДляПроверки Цикл
			Значение = СтрокаТабличнойЧасти[КлючЗначение.Ключ];  			
			Если НЕ ЗначениеЗаполнено(Значение) Тогда // надо ругаться
				
				МетаданныеРеквизиты    =    Метаданные().ТабличныеЧасти.НМА.Реквизиты;
				ПредставлениеРеквизита = МетаданныеРеквизиты[КлючЗначение.Ключ].Представление();
				
				ТекстСообщение = НСтр("ru = 'В строке номер %1 табличной части ""НМА"" не заполнено значение реквизита ""%2""'");
				
				Поле = "НМА" + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "]." + КлючЗначение.Ключ ;

				ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщение, СтрокаТабличнойЧасти.НомерСтроки, ПредставлениеРеквизита),
																  ЭтотОбъект, Поле,"Объект", Отказ);
								
			КонецЕсли;
			
		КонецЦикла;	
	КонецЦикла;
		
КонецПроцедуры

#КонецЕсли