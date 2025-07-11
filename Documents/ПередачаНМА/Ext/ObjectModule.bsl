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
		
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если НЕ ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Организация, Дата)
		ИЛИ НЕ УчитыватьКПН Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ВидУчетаНУ");
				
	КонецЕсли;

	Если НЕ ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНДС(Организация, Дата)
		ИЛИ НЕ УчитыватьНДС Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("НДСВидОперацииРеализации");
		МассивНепроверяемыхРеквизитов.Добавить("СтавкаНДС");
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаНДСПоРеализации");
		
	КонецЕсли;

    Если НЕ ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
	КонецЕсли;
    
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

	ПроверкаОСПоУчетнымДанным(Отказ, ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	//// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект, Ложь);
	
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.ПередачаНМА.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	//
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Если вдруг не удалось получить параметры проведения и не установлен флаг Отказ, то просто выйдем из проведения
	Если ПараметрыПроведения = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ
	
	//Проверем возможность изменения состояния НМА
	УчетНМА.ПроверитьВозможностьИзмененияСостоянияНМА(ПараметрыПроведения.ТаблицаСостоянийНМА,	Отказ);
	
	УчетНМА.ПроверитьСведенияПоНМА(ПараметрыПроведения.Реквизиты, Отказ);

	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	// Таблица взаиморасчетов с учетом зачета авансов
	ТаблицаВзаиморасчеты = УправлениеВзаиморасчетамиСервер.ПодготовитьТаблицуВзаиморасчетовЗачетАвансов(
		ПараметрыПроведения.ЗачетАвансовТаблицаДокумента, ПараметрыПроведения.ЗачетАвансовРеквизиты, Отказ);
		
	// Таблицы выручки от реализации: собственных товаров и услуг
	ТаблицыРеализация = УчетДоходовРасходов.ПодготовитьТаблицыВыручкиОтРеализации(
		ПараметрыПроведения.РеализацияТаблицаДокумента, ТаблицаВзаиморасчеты,
		ПараметрыПроведения.Реквизиты, Отказ);

	// Таблицы, содержащая данные по расчету амортизации
	ТаблицаАмортизацииНМА = УчетНМА.ПодготовитьТаблицуАмортизацииНМАБухРегл(ПараметрыПроведения.Реквизиты, ПараметрыПроведения.Реквизиты, Ложь);
	
	ТаблицаНМАРаспределениеАмортизацииПоНаправлениямРегл = УправлениеВнеоборотнымиАктивамиСервер.ПодготовитьТаблицуРаспределениеАмортизацииПоНаправлениямРегл(ТаблицаАмортизацииНМА, ПараметрыПроведения.Реквизиты, Отказ);
	
	Документы.ПередачаНМА.ДобавитьКолонкуСодержание(ТаблицыРеализация.СобственныеТоварыУслуги);
	
	ОбщегоНазначенияБКВызовСервера.ДобавитьКолонкуВТаблицуЗначений(ТаблицаВзаиморасчеты, "НомерЖурнала", НСтр("ru = 'АВ'", ОбщегоНазначения.КодОсновногоЯзыка()));	
	ОбщегоНазначенияБКВызовСервера.ДобавитьКолонкуВТаблицуЗначений(ПараметрыПроведения.РеквизитыСтоимостьНМА, "НомерЖурнала", НСтр("ru = 'НА'", ОбщегоНазначения.КодОсновногоЯзыка()));
	ОбщегоНазначенияБКВызовСервера.ДобавитьКолонкуВТаблицуЗначений(ПараметрыПроведения.РеквизитыРаспределениеАмортизации, "НомерЖурнала", НСтр("ru = 'НА'", ОбщегоНазначения.КодОсновногоЯзыка()));
	ОбщегоНазначенияБКВызовСервера.ДобавитьКолонкуВТаблицуЗначений(ТаблицыРеализация.СобственныеТоварыУслуги, "НомерЖурнала", НСтр("ru = 'НА'", ОбщегоНазначения.КодОсновногоЯзыка()));

	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	УправлениеВнеоборотнымиАктивамиСервер.СформироватьДвиженияАмортизацииПоНаправлениямРегл(ТаблицаНМАРаспределениеАмортизацииПоНаправлениямРегл, ПараметрыПроведения.РеквизитыРаспределениеАмортизации,
		Движения, Отказ);

	УчетНМА.СформироватьДвиженияИзменениеСостоянияНМА(ПараметрыПроведения.ТаблицаСостоянийНМА,
		 Движения, Отказ);
		 
	УправлениеВнеоборотнымиАктивамиСервер.СформироватьДвиженияОбъектыНалоговогоУчетаФА(ПараметрыПроведения.ТаблицаОбъектыНалоговогоУчетаФА,ПараметрыПроведения.Реквизиты,
		 Движения, Отказ);
		 
	УправлениеВнеоборотнымиАктивамиСервер.СформироватьДвиженияФАУчитываемыхОтдельно(ПараметрыПроведения.ТаблицаФАУчитываемыеОтдельно,ПараметрыПроведения.Реквизиты,
		 Движения, Отказ);
		 
	УчетНМА.СформироватьДвиженияОбъектыИмущественногоНалога(ПараметрыПроведения.ТаблицаОбъектыИмущественногоНалога, ПараметрыПроведения.РеквизитыОбъектыИмущественногоНалога,
		 Движения, Отказ);
		 
	УчетНМА.СформироватьДвиженияПередачаНМА(ПараметрыПроведения.РеквизитыСтоимостьНМА,ПараметрыПроведения.ТаблицаСтоимостьНМА,
	    ТаблицаАмортизацииНМА, Движения, Отказ);

	УправлениеВзаиморасчетамиСервер.СформироватьДвиженияЗачетАвансов(ТаблицаВзаиморасчеты,
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Движения, Отказ);	      
	                              		
	УчетДоходовРасходов.СформироватьДвиженияРеализация(
		ТаблицыРеализация.СобственныеТоварыУслуги, ПараметрыПроведения.РеквизитыРеализация, Движения, Отказ);
		
	УчетНДСИАкциза.СформироватьДвиженияРеализацияАктивовУслуг(ПараметрыПроведения.ТаблицаНДС, ПараметрыПроведения.ТаблицаУчастникиСовместнойДеятельности,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);  
		
		// Переоценка валютных остатков - после формирования проводок всеми другими механизмами
	ТаблицаПереоценка = УчетДоходовРасходов.ПодготовитьТаблицуПереоценкаВалютныхОстатковПоПроводкамДокумента(
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Движения, Отказ);

	УчетДоходовРасходов.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценка,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		                           	       
	ПроцедурыНалоговогоУчета.ОтразитьПостоянныеРазницыВНУ(ПараметрыПроведения.Реквизиты, Движения, Отказ)
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ УчитыватьКПН Тогда
		ВидУчетаНУ = Справочники.ВидыУчетаНУ.ПустаяСсылка();
	КонецЕсли;	
	
	УчетНДСИАкциза.ОчиститьДанныеПоУчастникамСовместнойДеятельности(ЭтотОбъект, ДоговорКонтрагента);
	
	РаботаСДоговорамиКонтрагентов.ЗаполнитьДоговорПередЗаписью(ЭтотОбъект);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	УдалитьДоверенность = "";
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ЗаполнитьПоДокументуОснования(Основание) Экспорт
	Документы.ПередачаНМА.ЗаполнитьПоДокументуОснованию(ЭтотОбъект, Основание);	
КонецПроцедуры

Процедура ПроверкаОСПоУчетнымДанным(Отказ, ЭтотОбъект)

	// Создание таблицы значений 
	ТаблицаЗначений = Новый ТаблицаЗначений;
	ТаблицаЗначений.Колонки.Добавить("НематериальныйАктив", Новый ОписаниеТипов("СправочникСсылка.НематериальныеАктивы"));

	// добавим строку
	Стр=ТаблицаЗначений.Добавить();
	Стр.НематериальныйАктив=ЭтотОбъект.НематериальныйАктив;
	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НематериальныйАктив", 	  ЭтотОбъект.НематериальныйАктив);
	Запрос.УстановитьПараметр("ДатаДокумента", 		 	  ЭтотОбъект.Дата);
	Запрос.УстановитьПараметр("Организация", 		 	  ЭтотОбъект.Организация);
	Запрос.УстановитьПараметр("СтруктурноеПодразделение", ЭтотОбъект.СтруктурноеПодразделение);
	Запрос.УстановитьПараметр("ПередачаНМА", 			  ТаблицаЗначений);
	Запрос.УстановитьПараметр("Ссылка", 			  	  ЭтотОбъект.Ссылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПередачаНМА.НематериальныйАктив
	               |ПОМЕСТИТЬ ПередачаНМА
	               |ИЗ
	               |	&ПередачаНМА КАК ПередачаНМА
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ПервоначСведения.НематериальныйАктив КАК НематериальныйАктив
	               |ПОМЕСТИТЬ ПервоначальныеСведенияНМА
	               |ИЗ
	               |	РегистрСведений.ПервоначальныеСведенияНМАБухгалтерскийУчет.СрезПоследних(
	               |			&ДатаДокумента,
	               |			НематериальныйАктив = &НематериальныйАктив
	               |				И Организация = &Организация
	               |				И Регистратор <> &Ссылка) КАК ПервоначСведения
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	НематериальныйАктив
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	СостоянияНМАОрганизацииСрезПоследних.НематериальныйАктив КАК НематериальныйАктив
	               |ПОМЕСТИТЬ НМА_СнятыеСУчета
	               |ИЗ
	               |	РегистрСведений.СостоянияНМАОрганизаций.СрезПоследних(
	               |			&ДатаДокумента,
	               |			НематериальныйАктив = &НематериальныйАктив
	               |				И Организация = &Организация
	               |				И Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.Списан)
	               |				И Регистратор <> &Ссылка) КАК СостоянияНМАОрганизацииСрезПоследних
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	НематериальныйАктив
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	СчетаУчетаНМА.НематериальныйАктив,
	               |	СчетаУчетаНМА.Организация,
	               |	СчетаУчетаНМА.СчетУчетаБУ
	               |ПОМЕСТИТЬ ВТ_СчетаУчетаНМА
	               |ИЗ
	               |	РегистрСведений.СчетаУчетаНМА.СрезПоследних(
	               |			&ДатаДокумента,
	               |			НематериальныйАктив = &НематериальныйАктив
	               |				И Организация = &Организация
	               |				И Регистратор <> &Ссылка) КАК СчетаУчетаНМА
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ТиповойОстатки.Счет,
	               |	ТиповойОстатки.Субконто1 КАК НематериальныйАктив,
	               |	ТиповойОстатки.Организация,
	               |	ТиповойОстатки.СтруктурноеПодразделение,
	               |	ТиповойОстатки.СуммаОстаток
	               |ПОМЕСТИТЬ ВТ_СтоимостьНМА
	               |ИЗ
	               |	РегистрБухгалтерии.Типовой.Остатки(
	               |			&ДатаДокумента,
	               |			Счет В
	               |				(ВЫБРАТЬ
	               |					ВТ_СчетаУчетаНМА.СчетУчетаБУ
	               |				ИЗ
	               |					ВТ_СчетаУчетаНМА),
	               |			,
	               |			Организация = &Организация
	               |				И СтруктурноеПодразделение = &СтруктурноеПодразделение
	               |				И Субконто1 В (&НематериальныйАктив)) КАК ТиповойОстатки
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ПередачаНМА.НематериальныйАктив,
			       |	ПередачаНМА.НематериальныйАктив.Код КАК Код,
				   |	ВЫБОР
	               |		КОГДА ПервоначальныеСведенияНМА.НематериальныйАктив ЕСТЬ NULL 
	               |			ТОГДА ЛОЖЬ
	               |		ИНАЧЕ ИСТИНА
	               |	КОНЕЦ КАК ОтражалосьВБухгалтерскомУчете,
	               |	ВЫБОР
	               |		КОГДА НМА_СнятыеСУчета.НематериальныйАктив ЕСТЬ NULL 
	               |			ТОГДА ЛОЖЬ
	               |		ИНАЧЕ ИСТИНА
	               |	КОНЕЦ КАК СнятоСУчета,
	               |	ВЫБОР
	               |		КОГДА СтоимостьНМА.НематериальныйАктив ЕСТЬ NULL 
	               |			ТОГДА ЛОЖЬ
	               |		ИНАЧЕ ИСТИНА
	               |	КОНЕЦ КАК ЕстьДанныеПоБухгалтерскомуУчету
	               |ИЗ
	               |	ПередачаНМА КАК ПередачаНМА
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ПервоначальныеСведенияНМА КАК ПервоначальныеСведенияНМА
	               |		ПО ПередачаНМА.НематериальныйАктив = ПервоначальныеСведенияНМА.НематериальныйАктив
	               |		ЛЕВОЕ СОЕДИНЕНИЕ НМА_СнятыеСУчета КАК НМА_СнятыеСУчета
	               |		ПО ПередачаНМА.НематериальныйАктив = НМА_СнятыеСУчета.НематериальныйАктив
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СтоимостьНМА КАК СтоимостьНМА
	               |		ПО ПередачаНМА.НематериальныйАктив = СтоимостьНМА.НематериальныйАктив";
	               
	ТаблицаПоНМА = Запрос.Выполнить().Выгрузить();               
				   
	Для Каждого СтрокаНМА Из ТаблицаПоНМА Цикл
		
	
		Если НЕ СтрокаНМА.ОтражалосьВБухгалтерскомУчете Тогда
			
			ТекстСообщения = НСтр("ru='Нематериальный актив <%1> код <%2> не отражался в учете по указанной организации.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СокрЛП(СтрокаНМА.НематериальныйАктив), СокрЛП(СтрокаНМА.Код));
			Поле = "НематериальныйАктив";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект.Ссылка, Поле, "Объект"); 

			Отказ = Истина;
			Возврат;
		КонецЕсли;

		Если СтрокаНМА.СнятоСУчета Тогда
			
			ТекстСообщения = НСтр("ru='Нематериальный актив <%1> код <%2> снят с учета в указанной организации.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СокрЛП(СтрокаНМА.НематериальныйАктив), СокрЛП(СтрокаНМА.Код));
			Поле = "НематериальныйАктив";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект.Ссылка, Поле, "Объект"); 

			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		Если НЕ СтрокаНМА.ЕстьДанныеПоБухгалтерскомуУчету Тогда
			
			ТекстСообщения = НСтр("ru='Для нематериального актива <%1> код <%2> не обнаружены данные по бухгалтерскому учету по указнному структурному подразделению организации.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СокрЛП(СтрокаНМА.НематериальныйАктив), СокрЛП(СтрокаНМА.Код));
			Поле = "НематериальныйАктив";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект.Ссылка, Поле, "Объект"); 

			Отказ = Истина;
			Возврат;
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры // ПроверкаРеквизитов()

#КонецЕсли




