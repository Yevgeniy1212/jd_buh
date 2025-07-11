﻿////////////////////////////////////////////////////////////////////////////////
// Получение внешней или встроенной обработки "ОбменЭСФ"

Функция ОбработкаОбменСНТ() Экспорт
	
	Возврат СНТСерверПереопределяемый.ОбработкаОбменСНТ();
	
КонецФункции

//Функция возвращает структуры пустого документа СНТ
//
Функция ПолучитьПустуюСтруктуруДокументаСНТ() Экспорт
	
	СтруктураДокумента = Новый Структура;
	
	// Подготовка таблицы шапки документа
	СписокОбязательныхКолонок = "Организация," 
	+ "СтруктурноеПодразделение,"
	+ "СтруктурноеПодразделениеПолучатель,"
	+ "ТипСНТ,"	
	+ "Поставщик," 
	+ "Контрагент," 
	+ "Получатель,"
	+ "ДатаОтгрузкиТовара,"
	+ "Статус,"
	+ "ДокументОснование,"
	+ "ВидОперации,"
	+ "ВидВывоза,"
	+ "ВидВвоза,"
	+ "ВидПеремещения,"
	+ "Валюта,"
	+ "ВалютаКод,"
	+ "КурсВалюты,"
	+ "СкладОтправитель,"
	+ "СкладОтправкиИдентификатор,"
	+ "АдресОтправки,"
	+ "СкладПолучатель,"
	+ "СкладДоставкиИдентификатор,"
	+ "АдресДоставки,"
	+ "ПоставщикИдентификатор,"
	+ "ПоставщикНаименование,"
	+ "ПоставщикНерезидент,"
	+ "ПоставщикРозничнаяРеализация,"
	+ "ПоставщикМалаяТорговаяТочка,"
	+ "ПоставщикРозничныйРеализатор,"
	+ "ПоставщикКодСтраны,"
	+ "ПоставщикКодСтраныОтправки,"
	+ "ПоставщикБИНСтруктурногоПодразделения,"
	+ "ПолучательИдентификатор,"
	+ "ПолучательНаименование,"
	+ "ПолучательКодСтраны,"
	+ "ПолучательКодСтраныДоставки,"
	+ "ПолучательНерезидент,"
	+ "ПолучательРозничнаяРеализация,"
	+ "ПолучательРозничныйРеализатор,"
	+ "ПолучательМалаяТорговаяТочка,"
	+ "ПолучательБИНСтруктурногоПодразделения,"
	+ "ПолучательУчастникСовместнойДеятельности,"
	+ "ПолучательУчастникСРП,"
	+ "Грузоотправитель,"
	+ "ГрузоотправительНаименование,"
	+ "ГрузоотправительИдентификатор,"
	+ "ГрузоотправительНерезидент,"
	+ "Грузополучатель,"
	+ "ГрузополучательНаименование,"
	+ "ГрузополучательИдентификатор,"
	+ "ГрузополучательНерезидент,"
	+ "ГрузоотправительКодСтраныОтправки,"
	+ "ГрузополучательКодСтраныОтправки,"
	+ "ДоговорПоставки,"
	+ "БезДоговора,"
	+ "УникальныйНомерВалютногоКонтроля,"
	+ "ДоговорПоставкиДата,"
	+ "ДоговорПоставкиНомер,"
	+ "ДоговорПоставкиУсловияОплаты,"
	+ "ДоговорПоставкиУсловияПоставки,"
	+ "АвтомобильныйТранспорт,"
	+ "НомерТС,"
	+ "ГосномерПрицепа,"
	+ "ЖелезнодорожныйТранспорт,"
	+ "НомерВагона,"
	+ "ВоздушныйТранспорт,"
	+ "НомерБорта,"
	+ "МорскойТранспорт,"
	+ "НомерСудна,"
	+ "Трубопровод,"
	+ "Мультимодальный,"
	+ "ЗапрещеноРазбиватьДокумент,"
	+ "РаспределятьТоварыПоИП,"
	+ "СвязанныйСНТ,"
	+ "РегистрационныйНомерСвязанногоСНТ,"
	+ "ПоставщикФизическоеЛицо,"
	+ "ПолучательФизическоеЛицо,"
	+ "НомерДоверенностиОтпуск,"
	+ "ДатаДоверенностиОтпуск,"
	;
	
	СтруктураДокумента.Вставить("Реквизиты", ВСВызовСервера.ПолучитьТаблицуПараметров(СписокОбязательныхКолонок));
	
	СписокОбязательныхКолонок = 
	"Организация,"
	+ "СтруктурноеПодразделение,"
	+ "Получатель,"
	+ "УчитыватьНДС,"
	+ "СуммаВключаетНДС,"
	+ "УчитыватьАкциз,"
	+ "СуммаВключаетАкциз,"	
	+ "СкладОтправитель,"
	+ "СкладПолучатель,"
	+ "Товар,"
	+ "ДокументОснование,"
	+ "ТоварНаименование,"
	+ "КодТНВЭД,"
	+ "ЕдиницаИзмерения,"
	+ "ЕдиницаИзмеренияКод,"
	+ "Количество,"
	+ "Сумма,"
	+ "СуммаБезНалогов,"
	+ "ОборотПоРеализации,"
	+ "Цена,"
	+ "ПризнакПроисхождения,"
	+ "НомерЗаявленияВРамкахТС,"
	+ "НомерПозицииВДекларацииИлиЗаявлении,"
	+ "СтавкаАкциза,"
	+ "СуммаАкциза,"
	+ "СтавкаНДС,"
	+ "БезНДС,"
	+ "СуммаНДС,"
	+ "ИдентификаторТовара,"
	+ "ИсточникПроисхождения,"
	+ "ПризнакУчетаНаВиртуальномСкладе,"
	+ "СтавкаНДСЧисло,"
	+ "СтавкаАкцизаЧисло,"
	+ "НомерСтрокиСНТ,"
	+ "ПризнакТовараДвойногоНазначения,"
	+ "ВесНетто";
	
	СтруктураДокумента.Вставить("Товары", ВСВызовСервера.ПолучитьТаблицуПараметров(СписокОбязательныхКолонок));
	СтруктураДокумента.Вставить("ТоварыВС", ВСВызовСервера.ПолучитьТаблицуПараметров(СписокОбязательныхКолонок));
	СтруктураДокумента.Вставить("ТоварыЭкспортныйКонтроль", ВСВызовСервера.ПолучитьТаблицуПараметров(СписокОбязательныхКолонок));
	
	Возврат СтруктураДокумента;
	
КонецФункции	

////////////////////////////////////////////////////////////////////////////////
// Получение данных профилей ИС ЭСФ

// Возврашает данные структурной единицы.
//
// Параметры:
//  СтруктурнаяЕдиница - См. Справочники.ПрофилиИСЭСФ.СтруктурнаяЕдиница - Структурная единица, данные которой необходимо получить.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура - Данные структурной единицы.
//   |- Ссылка - См. Справочники.ПрофилиИСЭСФ.СтруктурнаяЕдиница - Ссылка на структурную единицу.
//   |- ИдентификационныйНомер - "" - БИН или ИИН структурной единицы.
//
Функция ДанныеСтруктурнойЕдиницы(Знач СтруктурнаяЕдиница) Экспорт
	
	Запрос 		 = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СтруктурнаяЕдиница.Ссылка,
	|	СтруктурнаяЕдиница.%СтруктурнаяЕдиницаИдентификационныйНомер КАК ИдентификационныйНомер
	|ИЗ
	|	Справочник.[СтруктурнаяЕдиница] КАК СтруктурнаяЕдиница
	|ГДЕ
	|	СтруктурнаяЕдиница.Ссылка = &Ссылка";	
	
	ИмяТаблицы 	 = ?(ТипЗнч(СтруктурнаяЕдиница) = Тип("СправочникСсылка.Организации"), "Организации", "ПодразделенияОрганизаций");
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[СтруктурнаяЕдиница]", ИмяТаблицы);
	
	СоответсвиеИменРеквизитов = Новый Соответствие;
	СоответсвиеИменРеквизитов.Вставить("%СтруктурнаяЕдиницаИдентификационныйНомер", "");
	
	ЭСФСерверПереопределяемый.ЗаполнитьСоответсвиеИменРеквизитовПолейЗапросов(СоответсвиеИменРеквизитов);
	
	ЭСФСервер.ЗаменитьИменаРеквизитовПолейЗапросов(ТекстЗапроса, СоответсвиеИменРеквизитов);
	
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("Ссылка", СтруктурнаяЕдиница);	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ДанныеСтруктурнойЕдиницы = Новый Структура;
		
		ДанныеСтруктурнойЕдиницы.Вставить("Ссылка", Выборка.Ссылка);
		
		ДанныеСтруктурнойЕдиницы.Вставить("ИдентификационныйНомер", Выборка.ИдентификационныйНомер);
		
		ЭтоИндивидуальныйПредприниматель = ЭСФСервер.ЭтоИндивидуальныйПредприниматель(Выборка.Ссылка);
		ДанныеСтруктурнойЕдиницы.Вставить("ЭтоИндивидуальныйПредприниматель", ЭтоИндивидуальныйПредприниматель);
		
		ДанныеСтруктурнойЕдиницы = Новый ФиксированнаяСтруктура(ДанныеСтруктурнойЕдиницы);
		
	КонецЕсли;
	
	Возврат ДанныеСтруктурнойЕдиницы;
	
КонецФункции

Функция НовоеСоответствиеПолей() Экспорт
	
	Поля = Новый Соответствие;
	
	ТабДокПоляИРазделы = СНТСерверПовтИсп.ОбработкаОбменСНТ().ПолучитьМакет("ПредставлениеПолейИРазделов");
	ОбластьПоля = ТабДокПоляИРазделы.Области.Поля;	
	Для НомерСтроки = 1 По ТабДокПоляИРазделы.ВысотаТаблицы Цикл
		
		ПолеИС 			= ТабДокПоляИРазделы.Область(НомерСтроки, ОбластьПоля.Лево, НомерСтроки, ОбластьПоля.Лево).Текст;
		
		Если ПустаяСтрока(ПолеИС)Тогда
			Прервать;	
		КонецЕсли;
		
		ПолеСиноним  	= ТабДокПоляИРазделы.Область(НомерСтроки, ОбластьПоля.Лево+1, НомерСтроки, ОбластьПоля.Лево+1).Текст;
		ПолеИБ 			= ТабДокПоляИРазделы.Область(НомерСтроки, ОбластьПоля.Право, НомерСтроки, ОбластьПоля.Право).Текст;
		
		Результат = новый Структура;
		Результат.Вставить("Поле", ПолеИБ);
		Результат.Вставить("Синоним", ПолеСиноним);

		Поля.Вставить(ПолеИС, Результат);
		
	КонецЦикла;
	
	Возврат Поля;
	
КонецФункции

Функция НовоеСоответствиеРазделов() Экспорт
	
	Разделы = Новый Соответствие;
		
	ТабДокПоляИРазделы = СНТСерверПовтИсп.ОбработкаОбменСНТ().ПолучитьМакет("ПредставлениеПолейИРазделов");
	ОбластьРазделы = ТабДокПоляИРазделы.Области.Разделы;	
	Для НомерСтроки = 1 По ТабДокПоляИРазделы.ВысотаТаблицы Цикл
		
		РазделИС 		= ТабДокПоляИРазделы.Область(НомерСтроки, ОбластьРазделы.Лево, НомерСтроки, ОбластьРазделы.Лево).Текст;
		
		Если ПустаяСтрока(РазделИС)Тогда
			Прервать;	
		КонецЕсли;

		
		ИмяСтраницы 	= ТабДокПоляИРазделы.Область(НомерСтроки, ОбластьРазделы.Лево+1, НомерСтроки, ОбластьРазделы.Лево+1).Текст;
		РазделСиноним 	= ТабДокПоляИРазделы.Область(НомерСтроки, ОбластьРазделы.Лево+2, НомерСтроки, ОбластьРазделы.Лево+2).Текст;
		ТабличнаяЧасть 	= ТабДокПоляИРазделы.Область(НомерСтроки, ОбластьРазделы.Право, НомерСтроки, ОбластьРазделы.Право).Текст;
		
		Результат = новый Структура;
		Результат.Вставить("ИмяСтраницы", ИмяСтраницы);
		Результат.Вставить("Синоним", РазделСиноним);
		Результат.Вставить("ТабличнаяЧасть", ТабличнаяЧасть);

		Разделы.Вставить(РазделИС, Результат);	
		
	КонецЦикла;
	
	Возврат Разделы;
	
КонецФункции
