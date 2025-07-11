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
	
	УчетТоваров.ЗаполнитьНаборыПоОрганизацииСтрутурномуПодразделениюСкладу(ЭтотОбъект, Таблица, "Организация", "СтруктурноеПодразделение", "Склад");
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснования(ДанныеЗаполнения);
		Возврат;
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Основание") И ДанныеЗаполнения.Свойство("ВводНаОсновании") Тогда
			ВыбранныйВидОперации = Неопределено;
			ДанныеЗаполнения.Свойство("ВидОперации", ВыбранныйВидОперации);
			ЗаполнитьПоДокументуОснования(ДанныеЗаполнения.Основание, ВыбранныйВидОперации);
			Возврат;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета(), "Продажа");
	
	Если Не ЗначениеЗаполнено(СпособВыпискиАктовВыполненныхРабот) Тогда		
		СпособВыпискиАктовВыполненныхРабот = Перечисления.СпособыВыпискиАктовВыполненныхРабот.ВБумажномВиде;		
	КонецЕсли;    

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПользовательУправляетСчетамиУчета = СчетаУчетаВДокументахВызовСервераПовтИсп.ПользовательУправляетСчетамиУчета();
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	ПараметрыПострочнойПроверки   = Новый Структура("ПроверятьЗаполнениеСчетаУчетаНУ, ПользовательУправляетСчетамиУчета", Товары.Количество() > 0, ПользовательУправляетСчетамиУчета);
    
	Если Товары.Количество() > 0 
		ИЛИ Услуги.Количество() > 0 Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары");
		МассивНепроверяемыхРеквизитов.Добавить("Услуги");		
		
	Иначе
		Если ВидОперации = Перечисления.ВидыОперацийРеализацияТоваров.Услуги Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Товары");
		ИначеЕсли ВидОперации = Перечисления.ВидыОперацийРеализацияТоваров.Товары Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Услуги");		
		КонецЕсли;
	КонецЕсли;
	
	Если Товары.Количество() = 0 Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
	КонецЕсли;
	
	Если НЕ ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Организация, Дата)
		ИЛИ НЕ УчитыватьКПН Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ВидУчетаНУ");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетДоходовНУ");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетСписанияСебестоимостиНУ");
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.СчетДоходовНУ");
		
		ПараметрыПострочнойПроверки.Вставить("ПроверятьЗаполнениеСчетаУчетаНУ", Ложь);
		
	КонецЕсли;
	
	Если НЕ ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНДС(Организация, Дата)
		ИЛИ НЕ УчитыватьНДС Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.НДСВидОперацииРеализации");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СтавкаНДС");
		
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.НДСВидОперацииРеализации");
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.СтавкаНДС");
		
	КонецЕсли;

	Если ОтложитьНачислениеНДС Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.НДСВидОперацииРеализации");
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Если УчитыватьНДС ИЛИ ПараметрыПострочнойПроверки.ПроверятьЗаполнениеСчетаУчетаНУ Тогда 
		ПараметрыПострочнойПроверки.Вставить("ПроверятьЗаполнениеСчетаУчетаНДС", УчитыватьНДС);
		ПроверитьЗаполнениеТабличнойЧастиПострочно(Товары, "Товары", Отказ, ПараметрыПострочнойПроверки, НСтр("ru='ТМЗ'"));
	КонецЕсли;
	
	Если УчитыватьНДС Тогда
		ПараметрыПострочнойПроверки.Очистить();
		ПараметрыПострочнойПроверки = Новый Структура("ПроверятьЗаполнениеСчетаУчетаНДС, ПользовательУправляетСчетамиУчета", Истина, ПользовательУправляетСчетамиУчета);
		ПроверитьЗаполнениеТабличнойЧастиПострочно(Услуги, "Услуги", Отказ, ПараметрыПострочнойПроверки, НСтр("ru='Услуги'"));
	КонецЕсли;
	
	Если УчитыватьАкциз Тогда
		ВыполнитьПроверкиСвязанныеСАкцизомВТабличнойЧасти(Товары, "Товары", Отказ, ПользовательУправляетСчетамиУчета);
	КонецЕсли;
	
	СчетаУчетаВДокументах.ПроверитьЗаполнение(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, Новый Соответствие);

	Если Не ЗначениеЗаполнено(СпособВыпискиАктовВыполненныхРабот) Тогда		
		СпособВыпискиАктовВыполненныхРабот = Перечисления.СпособыВыпискиАктовВыполненныхРабот.ВБумажномВиде;		
	КонецЕсли;    
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если СпособВыпискиАктовВыполненныхРабот <> Перечисления.СпособыВыпискиАктовВыполненныхРабот.НаПорталеГосЗакупа 
		И СпособВыпискиАктовВыполненныхРабот <> Перечисления.СпособыВыпискиАктовВыполненныхРабот.НаПорталеИСЭСФ Тогда
		ДатаПодписанияГЗ = Дата;
	КонецЕсли;
	
	Если ВидОперации <> Перечисления.ВидыОперацийРеализацияТоваров.Услуги Тогда
		ОтложитьНачислениеНДС = Ложь;
	КонецЕсли;
	
	Если ОтложитьНачислениеНДС Тогда
		ДатаПодписанияГЗ = Дата;
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ВидОперации = Перечисления.ВидыОперацийРеализацияТоваров.Товары Тогда		
		Услуги.Очистить();	
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийРеализацияТоваров.Услуги Тогда
		Товары.Очистить();
	КонецЕсли;
	
	// Свойство ЗакрыватьФорму используется при проведении из формы документа
	Если ДополнительныеСвойства.Свойство("ЗакрыватьФорму") Тогда
		ДополнительныеСвойства.Удалить("ЗакрыватьФорму");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаПодписанияГЗ) И НЕ СпособВыпискиАктовВыполненныхРабот = Перечисления.СпособыВыпискиАктовВыполненныхРабот.ВБумажномВиде Тогда
		Если  РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда			
			РежимЗаписи    = ?(Проведен, РежимЗаписиДокумента.ОтменаПроведения, РежимЗаписиДокумента.Запись);
			
			ПредставлениеДатыПодписания = "";
			ТекстСообщения = "";
			
			Если СпособВыпискиАктовВыполненныхРабот = Перечисления.СпособыВыпискиАктовВыполненныхРабот.НаПорталеИСЭСФ Тогда	
				Если ОтложитьНачислениеНДС Тогда
					ТекстСообщения =
					НСтр("ru = 'Проведение документа, выставленного на портале ИС ЭСФ возможно только после заполнения ""Даты дохода"". Документ будет записан без проведения'");
				Иначе 
					ТекстСообщения =
					НСтр("ru = 'Проведение документа, выставленного на портале ИС ЭСФ возможно только после заполнения ""Даты подписания"". Документ будет записан без проведения'");					
				КонецЕсли;				
			ИначеЕсли СпособВыпискиАктовВыполненныхРабот = Перечисления.СпособыВыпискиАктовВыполненныхРабот.НаПорталеГосЗакупа Тогда
				Если ОтложитьНачислениеНДС Тогда
					ТекстСообщения =
					НСтр("ru = 'Проведение документа, выставленного на портале Гос.закупа возможно только после заполнения ""Даты дохода"". Документ будет записан без проведения'");
				Иначе
					ТекстСообщения =
					НСтр("ru = 'Проведение документа, выставленного на портале Гос.закупа возможно только после заполнения ""Даты подписания"". Документ будет записан без проведения'");
				КонецЕсли;
			КонецЕсли;
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДатаПодписанияГЗ", "Объект", Ложь);
			ДополнительныеСвойства.Вставить("ЗакрыватьФорму", Ложь);
		Конецесли;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения И ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда
			
		ТаблицаРеквизитов = Новый ТаблицаЗначений;
		
		ТаблицаРеквизитов.Колонки.Добавить("Период");
		ТаблицаРеквизитов.Колонки.Добавить("Регистратор");
		ТаблицаРеквизитов.Колонки.Добавить("Организация");
		ТаблицаРеквизитов.Колонки.Добавить("СчетНаОплатуПокупателю");
		
		СтрокаТабРеквизитов = ТаблицаРеквизитов.Добавить();
		СтрокаТабРеквизитов.Период      = Дата;
		СтрокаТабРеквизитов.Регистратор = Ссылка;
		СтрокаТабРеквизитов.Организация = Организация;
		СтрокаТабРеквизитов.СчетНаОплатуПокупателю = ДокументОснование; 
		
		ТаблицаТовары = Документы.СчетНаОплатуПокупателю.ТоварыУслугиПоСчету(ДокументОснование);  
		
		ТаблицаСчетовНаОплату = Новый ТаблицаЗначений;
		
		ТаблицаСчетовНаОплату.Колонки.Добавить("СчетНаОплатуПокупателю");  
		
		СтрокаТабСчетовНаОплату = ТаблицаСчетовНаОплату.Добавить();
		СтрокаТабСчетовНаОплату.СчетНаОплатуПокупателю = ДокументОснование;
				
		ТаблицаСтатусовСчетов = СтатусыДокументов.ПодготовитьТаблицуСтатусовОтменыОтгрузкиПоСчетам(
			ТаблицаСчетовНаОплату,
			ТаблицаТовары,
			ТаблицаРеквизитов);  
			
		СтатусыДокументов.СформироватьДвиженияСтатусовДокументов(
			ТаблицаСтатусовСчетов, ТаблицаРеквизитов);
		
	КонецЕсли;
	 	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение И НомераГТДСервер.ВедетсяУчетПоТоварамОрганизаций(Дата) Тогда
		ТаблицаДокумента = НомераГТДСервер.ПодготовитьТаблицуТоваровСУчетомСкладовВТЧ(Товары, Истина, Склад);
		ТаблицаНомераГТД = НомераГТДСервер.ПодготовитьТаблицуНомеровГТД(ТаблицаДокумента, НомераГТД.Выгрузить());
		НомераГТДСервер.ЗаполнитьТаблицуНомераГТД(ЭтотОбъект,ТаблицаДокумента, ТаблицаНомераГТД);
	КонецЕсли;
		
	УчетНДСИАкциза.ОчиститьДанныеПоУчастникамСовместнойДеятельности(ЭтотОбъект, ДоговорКонтрагента);
	
	СуммаДокумента = УчетНДСИАкциза.ПолучитьСуммуДокументаСНДС(ЭтотОбъект);
	
	СчетаУчетаВДокументах.ЗаполнитьПередЗаписью(ЭтотОбъект, РежимЗаписи);
	
	УчетНДСИАкциза.СинхронизацияПометкиНаУдалениеУСчетаФактуры(ЭтотОбъект, "СчетФактураВыданный", Отказ);
	
	РаботаСДоговорамиКонтрагентов.ЗаполнитьДоговорПередЗаписью(ЭтотОбъект);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета(),,, ОбъектКопирования.Ссылка);

	Если ЗначениеЗаполнено(ОбъектКопирования.НомераГТД) Тогда
		НомераГТД.Очистить();
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(ОбъектКопирования.ДатаПодписанияГЗ) Тогда
		ДатаПодписанияГЗ = Дата(1,1,1);
	КонецЕсли;
	
	ОтложитьНачислениеНДС = Ложь;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	УчетНДСИАкциза.ДобавитьОбновитьСведенияПоАктамВыполненныхРабот(ЭтотОбъект); 		
		
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	//синхронизируем данные счет-фактуры и документа основания
	УчетНДСИАкциза.СинхронизироватьДанныеДокументаИСчетаФактуры(ЭтотОбъект, Отказ, "СчетФактураВыданный"); 		
	Если Отказ Тогда
		ТекстСообщения = НСтр("ru = 'Документ не записан ...'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.РеализацияТоваровУслуг.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	// Изменение статуса счетов на оплату 
	
	ГрупповоеПерепроведение = Неопределено;
	Если ЭтотОбъект.ДополнительныеСвойства.Свойство("ГрупповоеПерепроведение") Тогда	
		ГрупповоеПерепроведение = ЭтотОбъект.ДополнительныеСвойства.ГрупповоеПерепроведение;	
	Иначе 	
		ГрупповоеПерепроведение = Ложь;	
	КонецЕсли;
	
	Если Не ГрупповоеПерепроведение Тогда
		
		ТаблицаСтатусовСчетов = СтатусыДокументов.ПодготовитьТаблицуСтатусовОтгрузкиПоСчетам(
			ПараметрыПроведения.ТаблицаСчетовНаОплату,
			ПараметрыПроведения.ОтгрузкаТоваровОказаниеУслугПоСчету,
			ПараметрыПроведения.Реквизиты);
		
		СтатусыДокументов.СформироватьДвиженияСтатусовДокументов(
			ТаблицаСтатусовСчетов, ПараметрыПроведения.Реквизиты);
		
	КонецЕсли;
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ
	
	// Таблица списанных товаров
	ТаблицаСписанныеТовары = УчетТоваров.ПодготовитьТаблицуСписанныеТовары(ПараметрыПроведения.ТаблицаТовары,
			ПараметрыПроведения.Реквизиты, Отказ);
	
	// Таблица взаиморасчетов с учетом зачета авансов
	ТаблицаВзаиморасчеты = УправлениеВзаиморасчетамиСервер.ПодготовитьТаблицуВзаиморасчетовЗачетАвансов(
		ПараметрыПроведения.ЗачетАвансовТаблицаДокумента, ПараметрыПроведения.ЗачетАвансовРеквизиты, Отказ);
		
	// Таблицы выручки от реализации: собственных товаров и услуг
	ТаблицыРеализация = УчетДоходовРасходов.ПодготовитьТаблицыВыручкиОтРеализации(
		ПараметрыПроведения.РеализацияТаблицаДокумента, ТаблицаВзаиморасчеты,
		ПараметрыПроведения.Реквизиты, Отказ);
		
	ОбщегоНазначенияБКВызовСервера.ДобавитьКолонкуВТаблицуЗначений(ТаблицаВзаиморасчеты, "НомерЖурнала", НСтр("ru = 'АВ'", ОбщегоНазначения.КодОсновногоЯзыка()));
	
	Если ПараметрыПроведения.Реквизиты[0].ВидОперации = Перечисления.ВидыОперацийРеализацияТоваров.ПередачаСтруктурномуПодразделению Тогда 
		Документы.РеализацияТоваровУслуг.ДобавитьКолонкуСодержание(ТаблицыРеализация.СобственныеТоварыУслуги, НСтр("ru='Положит. отклонение ст-ти реал-ции от себест-ти'", ОбщегоНазначения.КодОсновногоЯзыка()));
		УчетДоходовРасходов.ПодготовитьТаблицыОтклоненияСтоимостиРеализацииОтСебестоимости(
			ТаблицыРеализация, ТаблицаСписанныеТовары, ПараметрыПроведения.РеализацияТаблицаДокумента, ПараметрыПроведения.Реквизиты, Отказ);
	Иначе 
		Документы.РеализацияТоваровУслуг.ДобавитьКолонкуСодержание(ТаблицыРеализация.СобственныеТоварыУслуги);
	КонецЕсли;
	
	ОпределятьДоходОтРеализацииПоКурсуАванса = УчетнаяПолитикаСервер.ОпределятьДоходОтРеализацииПоКурсуАванса(ПараметрыПроведения.Реквизиты[0].Организация, ПараметрыПроведения.Реквизиты[0].Период);
	Если ОпределятьДоходОтРеализацииПоКурсуАванса Тогда
		ТаблицаРеализацияТМЗ = УчетТоваров.ПодготовитьТаблицуРеализацияТМЗ(
			ТаблицаСписанныеТовары, ТаблицыРеализация.СобственныеТоварыУслуги,
			ПараметрыПроведения.Реквизиты, Отказ);
	Иначе
		ТаблицаРеализацияТМЗ = УчетТоваров.ПодготовитьТаблицуРеализацияТМЗ(
			ТаблицаСписанныеТовары, ПараметрыПроведения.РеализацияТаблицаДокумента,
			ПараметрыПроведения.Реквизиты, Отказ);
	КонецЕсли;
	
	//КОНТРОЛЬ ПО РЕГИСТРУ "ТОВАРЫ ОРГАНИЗАЦИЙ
	НомераГТДСервер.ВыполнитьКонтрольТоварыОрганизаций(ПараметрыПроведения.ТаблицаТоварыОрганизаций,ПараметрыПроведения.Реквизиты, , Отказ);
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ  	
	УчетТоваров.СформироватьДвиженияСписаниеТоваров(ТаблицаСписанныеТовары,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	// Товары организаций
	НомераГТДСервер.СформироватьДвиженияТоварыОрганизаций(ПараметрыПроведения.ТаблицаТоварыОрганизаций,ПараметрыПроведения.Реквизиты, Движения, Отказ);		

	УправлениеВзаиморасчетамиСервер.СформироватьДвиженияЗачетАвансов(ТаблицаВзаиморасчеты,
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Движения, Отказ);
		
	УчетДоходовРасходов.СформироватьДвиженияРеализация(
		ТаблицыРеализация.СобственныеТоварыУслуги, ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	УчетТоваров.СформироватьДвиженияРеализацияТМЗ(ТаблицаРеализацияТМЗ, Движения, Отказ);
		
	УчетНДСИАкциза.СформироватьДвиженияРеализацияАктивовУслуг(ПараметрыПроведения.ТаблицаНДС, ПараметрыПроведения.ТаблицаУчастникиСовместнойДеятельности,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	// Переоценка валютных остатков - после формирования проводок всеми другими механизмами
	ТаблицаПереоценка = УчетДоходовРасходов.ПодготовитьТаблицуПереоценкаВалютныхОстатковПоПроводкамДокумента(
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Движения, Отказ);

	УчетДоходовРасходов.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценка,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	// Отражение ПР в НУ 
	ПроцедурыНалоговогоУчета.ОтразитьПостоянныеРазницыВНУ(ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	УчетНДСИАкциза.СинхронизацияПризнакаПроведенияУСчетаФактуры(Ссылка, Отказ, Истина, "СчетФактураВыданный");
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	УчетНДСИАкциза.СинхронизацияПризнакаПроведенияУСчетаФактуры(Ссылка, Отказ, Ложь, "СчетФактураВыданный");
	
	//Каспийсофт
	Если ВидОперацииМН = Перечисления.ВидыОперацийМН.Оценочные Тогда		
		МН.ПриУдалении(ЭтотОбъект, Отказ);
	КонецЕсли;	
	//Каспийсофт
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ЗаполнитьПоДокументуОснования(Основание, ВыбранныйВидОперации = Неопределено) Экспорт
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		Документы.РеализацияТоваровУслуг.ЗаполнитьДокументПоПоступлениюТоваровИУслуг(ЭтотОбъект, Основание);
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		Документы.РеализацияТоваровУслуг.ЗаполнитьДокументПоРеализацииТоваровИУслуг(ЭтотОбъект, Основание);
		Возврат
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда
		Документы.РеализацияТоваровУслуг.ЗаполнитьДокументПоСчетуНаОплатуПокупателю(ЭтотОбъект, Основание);
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.СчетФактураВыданный") Тогда
		Документы.РеализацияТоваровУслуг.ЗаполнитьДокументПоСчетФактураВыданный(ЭтотОбъект, Основание);
	КонецЕсли;
	ЭтотОбъект.ВидОперации = ?(ВыбранныйВидОперации = Неопределено, Документы.РеализацияТоваровУслуг.ОпределитьВидОперацииПоДокументуОснованию(Основание), ВыбранныйВидОперации);
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета(), , , , Основание);
	
	Если ЗначениеЗаполнено(ЭтотОбъект.ДоговорКонтрагента) Тогда 
		ЭтотОбъект.ВалютаДокумента = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ЭтотОбъект.ДоговорКонтрагента, "ВалютаВзаиморасчетов");				
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеТабличнойЧастиПострочно(ПроверяемаяТабличнаячасть, ИмяТабличнойЧасти, Отказ, ПараметрыПроверки, ПредставлениеТЧ="")
	
	ПользовательУправляетСчетамиУчета = ПараметрыПроверки.Свойство("ПользовательУправляетСчетамиУчета") И ПараметрыПроверки.ПользовательУправляетСчетамиУчета;
	ПроверятьЗаполнениеСчетаУчетаНДС  = ПараметрыПроверки.Свойство("ПроверятьЗаполнениеСчетаУчетаНДС") И ПараметрыПроверки.ПроверятьЗаполнениеСчетаУчетаНДС;
	ПроверятьЗаполнениеСчетаУчетаНУ   = ПараметрыПроверки.Свойство("ПроверятьЗаполнениеСчетаУчетаНУ") И ПараметрыПроверки.ПроверятьЗаполнениеСчетаУчетаНУ;
	
	Для Каждого СтрокаТабличнойЧасти Из ПроверяемаяТабличнаячасть Цикл
		
		Если ПроверятьЗаполнениеСчетаУчетаНДС И ПользовательУправляетСчетамиУчета И НЕ ОтложитьНачислениеНДС
			И УчетНДСиАкцизаВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС) <> 0 И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетУчетаНДСПоРеализации) Тогда
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = 'Счет НДС'"),
				СтрокаТабличнойЧасти.НомерСтроки, ПредставлениеТЧ);
			Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СчетУчетаНДСПоРеализации";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если ПроверятьЗаполнениеСчетаУчетаНУ И ПользовательУправляетСчетамиУчета
			И ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетУчетаБУ) И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетУчетаНУ) 
			И НЕ ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТабличнойЧасти.СчетУчетаБУ).Забалансовый Тогда
			
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = 'Счет учета (НУ)'"),
				СтрокаТабличнойЧасти.НомерСтроки, ПредставлениеТЧ);
			Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СчетУчетаНУ";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;

	КонецЦикла;
	
КонецПроцедуры

Процедура ВыполнитьПроверкиСвязанныеСАкцизомВТабличнойЧасти(ПроверяемаяТабличнаячасть, ИмяТабличнойЧасти, Отказ, ПользовательУправляетСчетамиУчета)
	
	Если ПроверяемаяТабличнаячасть.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаДокумента", ПроверяемаяТабличнаячасть);
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки,
	|	ТаблицаДокумента.Номенклатура,
	|	ТаблицаДокумента.СтавкаАкциза,
	|	ТаблицаДокумента.СуммаАкциза,
	|	ТаблицаДокумента.АкцизВидОперацииРеализации,
	|	ТаблицаДокумента.СчетУчетаАкцизаПоРеализации
	|ПОМЕСТИТЬ ВТ_ТаблицаДокумента
	|ИЗ
	|	&ТаблицаДокумента КАК ТаблицаДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ТаблицаДокумента.НомерСтроки,
	|	ВТ_ТаблицаДокумента.Номенклатура,
	|	ВТ_ТаблицаДокумента.СтавкаАкциза,
	|	ЕстьNULL(ВТ_ТаблицаДокумента.СуммаАкциза, 0) КАК СуммаАкциза,
	|	ВТ_ТаблицаДокумента.АкцизВидОперацииРеализации,
	|	ВТ_ТаблицаДокумента.СчетУчетаАкцизаПоРеализации,
	|	СправочникНоменклатура.ВидПодакцизногоТМЗ,
	|	ЕстьNULL(СтавкиАкциза.Ставка, 0) КАК Ставка
	|ИЗ
	|	ВТ_ТаблицаДокумента КАК ВТ_ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО ВТ_ТаблицаДокумента.Номенклатура = СправочникНоменклатура.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтавкиАкциза КАК СтавкиАкциза
	|		ПО ВТ_ТаблицаДокумента.СтавкаАкциза = СтавкиАкциза.Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл 
		
		ПутьКСтрокеТЧ = ИмяТабличнойЧасти + "[" + Формат(Выборка.НомерСтроки - 1, "ЧН=0; ЧГ=") + "]";
		Если (ЗначениеЗаполнено(Выборка.ВидПодакцизногоТМЗ) ИЛИ Выборка.СуммаАкциза <> 0) И НЕ ЗначениеЗаполнено(Выборка.СтавкаАкциза) Тогда 
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = 'Ставка акциза'"),
				Выборка.НомерСтроки, ?(ИмяТабличнойЧасти = "Товары", НСтр("ru='ТМЗ'"), ИмяТабличнойЧасти));
			Поле = ПутьКСтрокеТЧ + ".СтавкаАкциза";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Выборка.ВидПодакцизногоТМЗ) И ЗначениеЗаполнено(Выборка.СтавкаАкциза) Тогда 
			ТекстСообщения = НСтр("ru='Необходимо очистить ставку акциза или указать ""Вид подакцизного товара"" у номенклатуры'");
			Поле = ПутьКСтрокеТЧ + ".СтавкаАкциза";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.СтавкаАкциза) И НЕ ЗначениеЗаполнено(Выборка.АкцизВидОперацииРеализации) Тогда 
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = 'Вид реализации (акциз)'"),
				Выборка.НомерСтроки, ?(ИмяТабличнойЧасти = "Товары", НСтр("ru='ТМЗ'"), ИмяТабличнойЧасти));
			Поле = ПутьКСтрокеТЧ + ".АкцизВидОперацииРеализации";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.СтавкаАкциза) И НЕ ЗначениеЗаполнено(Выборка.СчетУчетаАкцизаПоРеализации) И ПользовательУправляетСчетамиУчета Тогда 
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = 'Счет акциза'"),
				Выборка.НомерСтроки, ?(ИмяТабличнойЧасти = "Товары", НСтр("ru='ТМЗ'"), ИмяТабличнойЧасти));
			Поле = ПутьКСтрокеТЧ + ".СчетУчетаАкцизаПоРеализации";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли