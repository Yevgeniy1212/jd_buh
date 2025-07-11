﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Приказ на каждого сотрудника
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПриемНаРаботу_ПриказНаСотрудника";
	КомандаПечати.Представление = НСтр("ru = 'Приказ на каждого сотрудника'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.ПроверкаПроведенияПередПечатью = НЕ ПользователиБКВызовСервераПовтИсп.РазрешитьПечатьНепроведенныхДокументов();
	КомандаПечати.Порядок = 50;
	
	// Приказ на список сотрудников
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПриемНаРаботу_ПриказНаСписокСотрудников";
	КомандаПечати.Представление = НСтр("ru = 'Приказ на список сотрудников'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.ПроверкаПроведенияПередПечатью = НЕ ПользователиБКВызовСервераПовтИсп.РазрешитьПечатьНепроведенныхДокументов();
	КомандаПечати.Порядок = 51;
	
	// Комплект документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПриемНаРаботу_ПриказНаСотрудника,ПриемНаРаботу_ПриказНаСписокСотрудников";
	КомандаПечати.Представление = НСтр("ru = 'Комплект документов'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = НЕ ПользователиБКВызовСервераПовтИсп.РазрешитьПечатьНепроведенныхДокументов();
	КомандаПечати.ФиксированныйКомплект = Истина;
	КомандаПечати.ПереопределитьПользовательскиеНастройкиКоличества = Истина;
	КомандаПечати.Порядок = 75;
	
	// Комплект документов (на принтер)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПриемНаРаботу_ПриказНаСотрудника,ПриемНаРаботу_ПриказНаСписокСотрудников";
	КомандаПечати.Представление = НСтр("ru = 'Комплект документов (на принтер)'");
	КомандаПечати.Картинка = БиблиотекаКартинок.ПечатьСразу;
	КомандаПечати.ПроверкаПроведенияПередПечатью = НЕ ПользователиБКВызовСервераПовтИсп.РазрешитьПечатьНепроведенныхДокументов();
	КомандаПечати.ФиксированныйКомплект = Истина;
	КомандаПечати.ПереопределитьПользовательскиеНастройкиКоличества = Истина;
	КомандаПечати.СразуНаПринтер = Истина;
	КомандаПечати.Порядок = 76;
	
	// Настраиваемый комплект документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПриемНаРаботу_ПриказНаСотрудника,ПриемНаРаботу_ПриказНаСписокСотрудников";
	КомандаПечати.Представление = НСтр("ru = 'Настраиваемый комплект документов'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = НЕ ПользователиБКВызовСервераПовтИсп.РазрешитьПечатьНепроведенныхДокументов();
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Настраиваемый комплект'");
	КомандаПечати.ДополнитьКомплектВнешнимиПечатнымиФормами = Истина;
	КомандаПечати.Порядок = 79;
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Печать Приказ на каждого сотрудника
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПриемНаРаботу_ПриказНаСотрудника") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ПриемНаРаботу_ПриказНаСотрудника",
			НСтр("ru = 'Приказ на каждого сотрудника'"),
			ПечатьПриказНаРаботника(МассивОбъектов, ОбъектыПечати, ПараметрыВывода.КодЯзыка),
			,
			"Документ.ПриемНаРаботуВОрганизацию.ПФ_MXL_ПриказНаРаботника");   
			
		ОписаниеПечатнойФормы = КоллекцияПечатныхФорм.Найти(ВРег("ПриемНаРаботу_ПриказНаСотрудника"), "ИмяВРЕГ");
		Если ОписаниеПечатнойФормы <> Неопределено Тогда
			ОписаниеПечатнойФормы.ДоступенВыводНаДругихЯзыках = Истина;
		КонецЕсли;	
	КонецЕсли;

	// Печать Приказ на список сотрудников
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПриемНаРаботу_ПриказНаСписокСотрудников") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ПриемНаРаботу_ПриказНаСписокСотрудников",
			НСтр("ru = 'Приказ на список сотрудников'"),
			ПечатьПриказНаРаботников(МассивОбъектов, ОбъектыПечати, ПараметрыВывода.КодЯзыка),
			,
			"Документ.ПриемНаРаботуВОрганизацию.ПФ_MXL_ПриказНаРаботников");  
			
		ОписаниеПечатнойФормы = КоллекцияПечатныхФорм.Найти(ВРег("ПриемНаРаботу_ПриказНаСписокСотрудников"), "ИмяВРЕГ");
		Если ОписаниеПечатнойФормы <> Неопределено Тогда
			ОписаниеПечатнойФормы.ДоступенВыводНаДругихЯзыках = Истина;
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Подготовка табличных печатных документов.

// Функция формирует табличный документ с печатной формой "ПриказНаРаботника"
//
Функция ПечатьПриказНаРаботника(МассивОбъектов, ОбъектыПечати, КодЯзыка=Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.КлючПараметровПечати = "ПриемНаРаботуВОрганизацию_ПриказНаРаботника";
	
	// получаем данные для печати
	Результат = СформироватьЗапросДляПечати(МассивОбъектов);
	
	// запоминаем области макета
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПриемНаРаботуВОрганизацию.ПФ_MXL_ПриказНаРаботника", КодЯзыка);
	
	ОбластьМакетаШапка = Макет.ПолучитьОбласть("Шапка"); // Шапка документа
	ОбластьМакетаРаботникНачало = Макет.ПолучитьОбласть("РаботникНачало"); // начало строки работника
	ОбластьМакетаНадбавка = Макет.ПолучитьОбласть("Надбавка"); // надбавки
	ОбластьМакетаРаботникКонец = Макет.ПолучитьОбласть("РаботникКонец"); // конец строки работника
	ОбластьМакетаПодвал = Макет.ПолучитьОбласть("Подвал"); // Подвал документа
	
	// выводим данные о руководителях организации
	ВыборкаДляШапки = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Ссылка");
	
	Пока ВыборкаДляШапки.Следующий()   Цикл
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		ОбластьМакетаШапка.Параметры.Заполнить(ВыборкаДляШапки); // Шапка документа.
		ОбластьМакетаПодвал.Параметры.Заполнить(ВыборкаДляШапки); // Для подвала.
		
		СтруктурнаяЕдиницаОрганизация = ОбщегоНазначенияБК.ПолучитьСтруктурнуюЕдиницу(ВыборкаДляШапки.Организация, ВыборкаДляШапки.СтруктурноеПодразделение, Истина);
		ОбластьМакетаШапка.Параметры.НазваниеОрганизации    = СтруктурнаяЕдиницаОрганизация.НаименованиеПолное;
		Руководители = ОбщегоНазначенияБКВызовСервера.ОтветственныеЛицаОрганизаций(СтруктурнаяЕдиницаОрганизация, ВыборкаДляШапки.ДатаДок);
		ОбластьМакетаПодвал.Параметры.ФИОРуководителя       = Руководители.Руководитель;
		ОбластьМакетаПодвал.Параметры.ДолжностьРуководителя = Руководители.РуководительДолжность;
		
		НомерДокДляПечати = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ВыборкаДляШапки.НомерДок, ВыборкаДляШапки.Ссылка);
		ОбластьМакетаШапка.Параметры.НомерДок = НомерДокДляПечати;
		
		ВыборкаРаботники = ВыборкаДляШапки.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Сотрудник");
		
		// Начинаем формировать выходной документ
		Пока ВыборкаРаботники.Следующий() Цикл
			
			ВложеннаяВыборка = ВыборкаРаботники.Выбрать(); 
			НомерШага = 0;
			Пока ВложеннаяВыборка.Следующий() Цикл
				
				НомерШага = НомерШага + 1;
				
				Если НомерШага = 1 Тогда
					// Каждый приказ на отдельной странице.
					Если ТабДокумент.ВысотаТаблицы > 0 Тогда
						ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					КонецЕсли;
					
					// Шапка документа.
					Если ВыборкаРаботники.Количество() > 1 Тогда
						ОбластьМакетаШапка.Параметры.НомерДок = НомерДокДляПечати + "/" + ВложеннаяВыборка.НомерСтроки
					КонецЕсли; 
					ТабДокумент.Вывести(ОбластьМакетаШапка);
					
					// Данные по работнику.
					ОбластьМакетаРаботникНачало.Параметры.Заполнить(ВложеннаяВыборка);
					
					ОбластьМакетаРаботникНачало.Параметры.ОкладТарифнаяСтавкаЦелаяЧасть = "" + Цел(ВложеннаяВыборка.ОкладТарифнаяСтавка);
					
					ДробнаяЧасть = ВложеннаяВыборка.ОкладТарифнаяСтавка - Цел(ВложеннаяВыборка.ОкладТарифнаяСтавка);
					ОбластьМакетаРаботникНачало.Параметры.ОкладТарифнаяСтавкаДробнаяЧасть = ?(ДробнаяЧасть = 0, "00", ДробнаяЧасть*100); 
					
					ТабДокумент.Вывести(ОбластьМакетаРаботникНачало);
				КонецЕсли;
				
				ОбластьМакетаНадбавка.Параметры.ВидНадбавкиНаименование  = НРег(ВложеннаяВыборка.ВидНадбавкиНаименование);
				ОбластьМакетаНадбавка.Параметры.НадбавкаЦелаяЧасть   = "";
				ОбластьМакетаНадбавка.Параметры.НадбавкаДробнаяЧасть = "";
				
				Если ЗначениеЗаполнено(ВложеннаяВыборка.РазмерНадбавки) Тогда
					
					Если ВложеннаяВыборка.СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.Процентом Тогда
						
						ОбластьМакетаНадбавка.Параметры.НадбавкаЦелаяЧасть = "" + ВложеннаяВыборка.РазмерНадбавки + "%";
						
					ИначеЕсли ВложеннаяВыборка.СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПоМесячномуРасчетномуПоказателю
						ИЛИ ВложеннаяВыборка.СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПоМесячномуРасчетномуПоказателюПоДням
						ИЛИ ВложеннаяВыборка.СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПоМесячномуРасчетномуПоказателюПоЧасам Тогда
						
						ОбластьМакетаНадбавка.Параметры.НадбавкаЦелаяЧасть = "" + ВложеннаяВыборка.РазмерНадбавки + НСтр("ru=' МРП'", КодЯзыка);
						
					ИначеЕсли ВложеннаяВыборка.СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПоМинимальнойЗаработнойПлате
						ИЛИ ВложеннаяВыборка.СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПоМинимальнойЗаработнойПлатеПоДням
						ИЛИ ВложеннаяВыборка.СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПоМинимальнойЗаработнойПлатеПоЧасам Тогда
						
						ОбластьМакетаНадбавка.Параметры.НадбавкаЦелаяЧасть = "" + ВложеннаяВыборка.РазмерНадбавки + НСтр("ru=' МЗП'", КодЯзыка);
						
					Иначе
						
						ОбластьМакетаНадбавка.Параметры.НадбавкаЦелаяЧасть = "" + Цел(ВложеннаяВыборка.РазмерНадбавки);
						
						ДробнаяЧасть = ВложеннаяВыборка.РазмерНадбавки - Цел(ВложеннаяВыборка.РазмерНадбавки);
						ОбластьМакетаНадбавка.Параметры.НадбавкаДробнаяЧасть = ?(ДробнаяЧасть = 0, "00", ДробнаяЧасть*100); 
						
					КонецЕсли;	
					
					ТабДокумент.Вывести(ОбластьМакетаНадбавка);
					
				КонецЕсли;
				
			КонецЦикла;
			
			ТабДокумент.Вывести(ОбластьМакетаРаботникКонец);
			
			// Подвал документа.
			ТабДокумент.Вывести(ОбластьМакетаПодвал);
			
		КонецЦикла;
		
		// если не было ни одного работника - выводим пустой бланк
		Если ТабДокумент.ВысотаТаблицы = 0 Тогда
			ТабДокумент.Вывести(ОбластьМакетаШапка);
			ТабДокумент.Вывести(ОбластьМакетаРаботникНачало);
			ТабДокумент.Вывести(ОбластьМакетаНадбавка);
			ТабДокумент.Вывести(ОбластьМакетаРаботникКонец);
			ТабДокумент.Вывести(ОбластьМакетаПодвал);
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДляШапки.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДокумент;

КонецФункции 

// Функция формирует табличный документ с печатной формой "ПриказНаРаботников".
//
Функция ПечатьПриказНаРаботников(МассивОбъектов, ОбъектыПечати, КодЯзыка=Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабДокумент.ПолеСлева = 0;
	ТабДокумент.ПолеСправа = 0;
	
	ТабДокумент.КлючПараметровПечати = "ПриемНаРаботуВОрганизацию_ПриказНаРаботников";
	
	// получаем данные для печати
	Результат = СформироватьЗапросДляПечати(МассивОбъектов);
	
	// запоминаем области макета
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПриемНаРаботуВОрганизацию.ПФ_MXL_ПриказНаРаботников", КодЯзыка);
	
	ОбластьМакетаШапка 		 = Макет.ПолучитьОбласть("Шапка"); // Шапка документа.
	ПовторятьПриПечатиСтроки = Макет.ПолучитьОбласть("ПовторятьПриПечати"); // повторяющаяся шапка страницы
	ОбластьМакетаПодвал 	 = Макет.ПолучитьОбласть("Подвал");// Подвал документа
	ОбластьМакета 			 = Макет.ПолучитьОбласть("СтрокаРаботник"); // строка работника
	
	ВыборкаДляШапки = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Ссылка");
	
	Пока ВыборкаДляШапки.Следующий()   Цикл
		
		Если ТабДокумент.ВысотаТаблицы > 0 Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		// массив с двумя строками - для разбиения на страницы
		ВыводимыеОбласти = Новый Массив();
		ВыводимыеОбласти.Добавить(ОбластьМакета);
		
		// выводим данные о руководителях организации
		ОбластьМакетаШапка.Параметры.Заполнить(ВыборкаДляШапки); // Шапка документа.
		ОбластьМакетаПодвал.Параметры.Заполнить(ВыборкаДляШапки); // Для подвала.
		
		СтруктурнаяЕдиницаОрганизация = ОбщегоНазначенияБК.ПолучитьСтруктурнуюЕдиницу(ВыборкаДляШапки.Организация, ВыборкаДляШапки.СтруктурноеПодразделение, Истина);
		ОбластьМакетаШапка.Параметры.НазваниеОрганизации    = СтруктурнаяЕдиницаОрганизация.НаименованиеПолное;
		Руководители = ОбщегоНазначенияБКВызовСервера.ОтветственныеЛицаОрганизаций(СтруктурнаяЕдиницаОрганизация,ВыборкаДляШапки.ДатаДок);
		ОбластьМакетаПодвал.Параметры.ФИОРуководителя       = Руководители.Руководитель;
		ОбластьМакетаПодвал.Параметры.ДолжностьРуководителя = Руководители.РуководительДолжность;
		
		ОбластьМакетаШапка.Параметры.НомерДок = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ВыборкаДляШапки.НомерДок, ВыборкаДляШапки.Ссылка);
		
		// Начинаем формировать выходной документ
		ТабДокумент.Вывести(ОбластьМакетаШапка); // Шапка документа.
		
		ВыборкаРаботники = ВыборкаДляШапки.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Сотрудник");
		
		// подсчитываем количество страниц документа - для корректного разбиения на страницы
		ВсегоСтрокДокумента = ВыборкаРаботники.Количество();
		
		Если НЕ ВыборкаРаботники = Неопределено Тогда
			
			ТаблицаСуммСписания = ПроцедурыБухгалтерскогоУчета.ПолучитьСуммуСписанияАктивов(ВыборкаДляШапки.Ссылка);
			КоличествоСтрок = ВыборкаРаботники.Количество();
			
			ВыведеноСтрок = 0;
			// выводим строки по работникам
			Пока ВыборкаРаботники.Следующий() Цикл
				
				ВложеннаяВыборка = ВыборкаРаботники.Выбрать(); 
				ВложеннаяВыборка.Следующий();
				
				// Данные по работнику.
				ОбластьМакета.Параметры.Заполнить(ВложеннаяВыборка);
				// Уточним валюту тарифной ставки
				ОбластьМакета.Параметры.ОкладТарифнаяСтавка = "" + Формат(ВложеннаяВыборка.ОкладТарифнаяСтавка,"ЧЦ=15; ЧДЦ=2") + Символы.ПС;
				
				// разбиение на страницы
				ВыведеноСтрок = ВыведеноСтрок + 1;
				
				// Проверим, уместится ли строка на странице или надо открывать новую страницу
				ВывестиПодвалЛиста = НЕ ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабДокумент, ВыводимыеОбласти);
				
				Если НЕ ВывестиПодвалЛиста И ВыведеноСтрок = ВсегоСтрокДокумента Тогда
					
					ВыводимыеОбласти.Добавить(ОбластьМакетаПодвал);
					ВывестиПодвалЛиста = НЕ ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабДокумент, ВыводимыеОбласти);
					
				КонецЕсли;
				
				Если ВывестиПодвалЛиста Тогда
					ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					ТабДокумент.Вывести(ПовторятьПриПечатиСтроки);
				КонецЕсли;
				
				ТабДокумент.Вывести(ОбластьМакета);
				
			КонецЦикла;
		КонецЕсли;
		
		// если не было ни одного работника - выводим пустой бланк
		Если ТабДокумент.ВысотаТаблицы = ОбластьМакетаШапка.ВысотаТаблицы Тогда
			ТабДокумент.Вывести(ОбластьМакета);
			ТабДокумент.Вывести(ОбластьМакета);
			ТабДокумент.Вывести(ОбластьМакета);
			ТабДокумент.Вывести(ОбластьМакета);
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
		
		// выводим предварительно подготовленный Подвал документа.
		ТабДокумент.Вывести(ОбластьМакетаПодвал);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДляШапки.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДокумент;

КонецФункции 

// Формирует запрос по документу.
//
Функция СформироватьЗапросДляПечати(МассивОбъектов) Экспорт
	
	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПриемНаРаботуВОрганизациюРаботникиОрганизации.Ссылка.Организация,
	|	ПриемНаРаботуВОрганизациюРаботникиОрганизации.Ссылка.СтруктурноеПодразделение,
	|	ПриемНаРаботуВОрганизациюРаботникиОрганизации.Ссылка.Дата,
	|	ПриемНаРаботуВОрганизациюРаботникиОрганизации.Ссылка,
	|	ПриемНаРаботуВОрганизациюРаботникиОрганизации.Сотрудник,
	|	ПриемНаРаботуВОрганизациюРаботникиОрганизации.ФизЛицо,
	|	ПриемНаРаботуВОрганизациюРаботникиОрганизации.ПодразделениеОрганизации,
	|	ПриемНаРаботуВОрганизациюРаботникиОрганизации.Должность,
	|	ПриемНаРаботуВОрганизациюРаботникиОрганизации.ДатаПриема,
	|	ПриемНаРаботуВОрганизациюРаботникиОрганизации.НомерСтроки,
	|	ПриемНаРаботуВОрганизациюОсновныеНачисления.Размер КАК ОкладТарифнаяСтавка,
	|	ПриемНаРаботуВОрганизациюРаботникиОрганизации.Ссылка.Номер
	|ПОМЕСТИТЬ ВТ_ДокументыПриемНаРаботуВОрганизацию
	|ИЗ
	|	Документ.ПриемНаРаботуВОрганизацию.РаботникиОрганизации КАК ПриемНаРаботуВОрганизациюРаботникиОрганизации
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриемНаРаботуВОрганизацию.ОсновныеНачисления КАК ПриемНаРаботуВОрганизациюОсновныеНачисления
	|		ПО ПриемНаРаботуВОрганизациюРаботникиОрганизации.Ссылка = ПриемНаРаботуВОрганизациюОсновныеНачисления.Ссылка
	|			И ПриемНаРаботуВОрганизациюРаботникиОрганизации.Сотрудник = ПриемНаРаботуВОрганизациюОсновныеНачисления.Сотрудник
	|			И (ПриемНаРаботуВОрганизациюОсновныеНачисления.ВидРасчета.ЗачетОтработанногоВремени)
	|ГДЕ
	|	ПриемНаРаботуВОрганизациюРаботникиОрганизации.Ссылка В(&МассивОбъектов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПериодыФИОФИзЛиц.ФизЛицо,
	|	ПериодыФИОФИзЛиц.Период,
	|	ФИОФизЛиц.Фамилия,
	|	ФИОФизЛиц.Имя,
	|	ФИОФизЛиц.Отчество
	|ПОМЕСТИТЬ ВТ_ФИОФизЛиц
	|ИЗ
	|	РегистрСведений.ФИОФизЛиц КАК ФИОФизЛиц
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ФИОФизЛиц.ФизЛицо КАК ФизЛицо,
	|			МАКСИМУМ(ФИОФизЛиц.Период) КАК Период
	|		ИЗ
	|			РегистрСведений.ФИОФизЛиц КАК ФИОФизЛиц
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ДокументыПриемНаРаботуВОрганизацию КАК ВТ_ДокументыПриемНаРаботуВОрганизацию
	|				ПО ФИОФизЛиц.Период <= ВТ_ДокументыПриемНаРаботуВОрганизацию.Дата
	|					И ФИОФизЛиц.ФизЛицо = ВТ_ДокументыПриемНаРаботуВОрганизацию.ФизЛицо
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ФИОФизЛиц.ФизЛицо) КАК ПериодыФИОФИзЛиц
	|		ПО ФИОФизЛиц.Период = ПериодыФИОФИзЛиц.Период
	|			И ФИОФизЛиц.ФизЛицо = ПериодыФИОФИзЛиц.ФизЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ДокументыПриемНаРаботуВОрганизацию.Ссылка КАК Ссылка,
	|	ВТ_ДокументыПриемНаРаботуВОрганизацию.НомерСтроки КАК НомерСтроки,
	|	ВТ_ДокументыПриемНаРаботуВОрганизацию.Сотрудник КАК Сотрудник,
	|	ВТ_ДокументыПриемНаРаботуВОрганизацию.Сотрудник.Код КАК ТабельныйНомер,
	|	ВЫБОР
	|		КОГДА ВТ_ФИОФизЛиц.Фамилия ЕСТЬ NULL 
	|			ТОГДА ВТ_ДокументыПриемНаРаботуВОрганизацию.ФизЛицо.Наименование
	|		ИНАЧЕ ВТ_ФИОФизЛиц.Фамилия + "" "" + ВТ_ФИОФизЛиц.Имя + "" "" + ВТ_ФИОФизЛиц.Отчество
	|	КОНЕЦ КАК Работник,
	|	ВТ_ДокументыПриемНаРаботуВОрганизацию.ДатаПриема,
	|	ВТ_ДокументыПриемНаРаботуВОрганизацию.ПодразделениеОрганизации КАК Подразделение,
	|	ВТ_ДокументыПриемНаРаботуВОрганизацию.Должность,
	|	ЕСТЬNULL(ВТ_ДокументыПриемНаРаботуВОрганизацию.ОкладТарифнаяСтавка, 0) КАК ОкладТарифнаяСтавка,
	|	ЕСТЬNULL(ПриемНаРаботуВОрганизациюОсновныеНачисления.ВидРасчета.Наименование, """") КАК ВидНадбавкиНаименование,
	|	ЕСТЬNULL(ПриемНаРаботуВОрганизациюОсновныеНачисления.ВидРасчета.СпособРасчета, ЗНАЧЕНИЕ(Перечисление.СпособыРасчетаОплатыТруда.ПустаяСсылка)) КАК СпособРасчета,
	|	ЕСТЬNULL(ПриемНаРаботуВОрганизациюОсновныеНачисления.Размер, 0) КАК РазмерНадбавки,
	|	ЕСТЬNULL(ПриемНаРаботуВОрганизациюОсновныеНачисления.НомерСтроки, 0) КАК НомерСтрокиНадбавки,
	|	ПриемНаРаботуВОрганизациюОсновныеНачисления.ВидРасчета КАК ВидНадбавки,
	|	ВТ_ДокументыПриемНаРаботуВОрганизацию.Организация КАК Организация,
	|	ВТ_ДокументыПриемНаРаботуВОрганизацию.СтруктурноеПодразделение КАК СтруктурноеПодразделение,
	|	ВТ_ДокументыПриемНаРаботуВОрганизацию.Дата КАК ДатаДок,
	|	ВТ_ДокументыПриемНаРаботуВОрганизацию.Номер КАК НомерДок
	|ИЗ
	|	ВТ_ДокументыПриемНаРаботуВОрганизацию КАК ВТ_ДокументыПриемНаРаботуВОрганизацию
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриемНаРаботуВОрганизацию.ОсновныеНачисления КАК ПриемНаРаботуВОрганизациюОсновныеНачисления
	|		ПО ВТ_ДокументыПриемНаРаботуВОрганизацию.Ссылка = ПриемНаРаботуВОрганизациюОсновныеНачисления.Ссылка
	|			И ВТ_ДокументыПриемНаРаботуВОрганизацию.Сотрудник = ПриемНаРаботуВОрганизациюОсновныеНачисления.Сотрудник
	|			И НЕ ПриемНаРаботуВОрганизациюОсновныеНачисления.ВидРасчета.ЗачетОтработанногоВремени
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ФИОФизЛиц КАК ВТ_ФИОФизЛиц
	|		ПО ВТ_ДокументыПриемНаРаботуВОрганизацию.ФизЛицо = ВТ_ФИОФизЛиц.ФизЛицо
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки,
	|	НомерСтрокиНадбавки
	|ИТОГИ
	|	МАКСИМУМ(Организация),
	|	МАКСИМУМ(СтруктурноеПодразделение),
	|	МАКСИМУМ(ДатаДок),
	|	МАКСИМУМ(НомерДок)
	|ПО
	|	Ссылка,
	|	Сотрудник";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Проведение

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт 
	
	ПараметрыПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	НомераТаблиц = Новый Структура;
	
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента(НомераТаблиц);
	Результат = Запрос.ВыполнитьПакет();
	ТаблицаРеквизиты = Результат[НомераТаблиц["Реквизиты"]].Выгрузить();
	ПараметрыПроведения.Вставить("Реквизиты", ТаблицаРеквизиты);
	
	Реквизиты = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаРеквизиты[0]);
	
	ОрганизацияВкладчикОППВ = ПроцедурыНалоговогоУчета.ПолучитьПризнакВкладчикаПрофПенсионныхВзносов(Реквизиты.ОбособленноеПодразделение, Реквизиты.Дата);
	
	Запрос.УстановитьПараметр("ОрганизацияВкладчикОППВ",   ОрганизацияВкладчикОППВ);
	Запрос.УстановитьПараметр("Организация", 			   Реквизиты.Организация);
	Запрос.УстановитьПараметр("ОбособленноеПодразделение", Реквизиты.ОбособленноеПодразделение);
	Запрос.УстановитьПараметр("СтруктурноеПодразделение",  Реквизиты.СтруктурноеПодразделение);
	
	НомераТаблиц = Новый Структура;
	Запрос.Текст = ТекстЗапросаРаботникиОрганизации(НомераТаблиц)
				 + ТекстЗапросаОсновныеНачисления(НомераТаблиц);

	Если НЕ ПустаяСтрока(Запрос.Текст) Тогда 
		
		Результат = Запрос.ВыполнитьПакет();
		
		Для Каждого НомерТаблицы Из НомераТаблиц Цикл
			ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
		КонецЦикла;
		
	КонецЕсли;
			
	Возврат ПараметрыПроведения;
	
КонецФункции

Функция ТекстЗапросаРеквизитыДокумента(НомераТаблиц) 
	
	НомераТаблиц.Вставить("Реквизиты", НомераТаблиц.Количество());

	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПриемНаРаботуВОрганизацию.Дата,
	|	ПриемНаРаботуВОрганизацию.Организация КАК ОбособленноеПодразделение,
	|	ПриемНаРаботуВОрганизацию.СтруктурноеПодразделение,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(УчетнаяПолитикаПоПерсоналуОрганизаций.ВестиУчетПоГоловнойОрганизации, ИСТИНА)
	|			ТОГДА ВЫБОР
	|					КОГДА ПриемНаРаботуВОрганизацию.Организация.ГоловнаяОрганизация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|						ТОГДА ПриемНаРаботуВОрганизацию.Организация
	|					ИНАЧЕ ПриемНаРаботуВОрганизацию.Организация.ГоловнаяОрганизация
	|				КОНЕЦ
	|		ИНАЧЕ ПриемНаРаботуВОрганизацию.Организация
	|	КОНЕЦ КАК Организация,
	|	ПриемНаРаботуВОрганизацию.Ссылка
	|ИЗ
	|	Документ.ПриемНаРаботуВОрганизацию КАК ПриемНаРаботуВОрганизацию
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаПоПерсоналуОрганизаций КАК УчетнаяПолитикаПоПерсоналуОрганизаций
	|		ПО ПриемНаРаботуВОрганизацию.Организация = УчетнаяПолитикаПоПерсоналуОрганизаций.Организация
	|ГДЕ
	|	ПриемНаРаботуВОрганизацию.Ссылка = &Ссылка";

	Возврат ТекстЗапроса + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ТекстЗапросаРаботникиОрганизации(НомераТаблиц)
	
	НомераТаблиц.Вставить("ВременнаяТаблицаРаботники", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ТаблицаРаботники", НомераТаблиц.Количество());

	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТЧРаботникиОрганизации.НомерСтроки КАК НомерСтроки,
	|	ТЧРаботникиОрганизации.Сотрудник,
	|	ТЧРаботникиОрганизации.Сотрудник.Физлицо КАК ФизЛицо,
	|	ТЧРаботникиОрганизации.ДатаПриема,
	|	ТЧРаботникиОрганизации.ПодразделениеОрганизации,
	|	ТЧРаботникиОрганизации.Должность,
	|	ТЧРаботникиОрганизации.ИсчислятьОППВ
	|ПОМЕСТИТЬ ВТ_РаботникиОрганизации
	|ИЗ
	|	Документ.ПриемНаРаботуВОрганизацию.РаботникиОрганизации КАК ТЧРаботникиОрганизации
	|ГДЕ
	|	ТЧРаботникиОрганизации.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&Организация КАК Организация,
	|	&ОбособленноеПодразделение КАК ОбособленноеПодразделение, 
	|	&СтруктурноеПодразделение КАК СтруктурноеПодразделение,
	|	РаботникиОрганизации.Сотрудник,
	|	РаботникиОрганизации.ДатаПриема КАК Период,
	|	РаботникиОрганизации.ПодразделениеОрганизации,
	|	РаботникиОрганизации.Должность,
	|	ВЫБОР
	|		КОГДА &ОрганизацияВкладчикОППВ
	|			ТОГДА РаботникиОрганизации.ИсчислятьОППВ
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ИсчислятьОППВ,
	|	1 КАК ЗанимаемыхСтавок,
	|	ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.ПриемНаРаботу) КАК ПричинаИзмененияСостояния
	|ИЗ
	|	ВТ_РаботникиОрганизации КАК РаботникиОрганизации";
                     	
 	Возврат	ТекстЗапроса + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ТекстЗапросаОсновныеНачисления(НомераТаблиц)
	
	НомераТаблиц.Вставить("ТаблицаОсновныеНачисления", НомераТаблиц.Количество());

	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	&Организация КАК Организация,
	|	&ОбособленноеПодразделение КАК ОбособленноеПодразделение,
	|	ТЧНачисления.Сотрудник,
	|	ТЧНачисления.ВидРасчета,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТЧНачисления.ВидРасчета.ЗачетОтработанногоВремени, ЛОЖЬ)
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ТЧНачисления.ВидРасчета
	|	КОНЕЦ КАК ВидРасчетаИзмерение,
	|	ТЧНачисления.Размер,
	|	ТЧРаботникиОрганизации.ДатаПриема КАК Период
	|ИЗ
	|	Документ.ПриемНаРаботуВОрганизацию.ОсновныеНачисления КАК ТЧНачисления
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_РаботникиОрганизации КАК ТЧРаботникиОрганизации
	|		ПО (ТЧНачисления.Сотрудник = ТЧРаботникиОрганизации.Сотрудник)
	|ГДЕ
	|	ТЧНачисления.Ссылка = &Ссылка";

	Возврат ТекстЗапроса + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

#КонецЕсли
