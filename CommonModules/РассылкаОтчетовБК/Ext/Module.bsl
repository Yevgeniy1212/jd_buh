﻿
#Область СлужебныйПрограммныйИнтерфейс

// Размещает на форме команду настройки рассылки отчета.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой необходимо разместить команду настройки рассылки отчета.
//
Процедура ПриСозданииНаСервере(Форма) Экспорт
	
	Параметры = Форма.Параметры;
	
	Если (Параметры.Свойство("ОткрытьРасшифровку") И Параметры.ОткрытьРасшифровку)
		ИЛИ Параметры.Свойство("ВидРасшифровки") Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"НастроитьРассылкуОтчета",
			"Видимость",
			Ложь);
		
		Возврат;
	КонецЕсли;
	
	// Для рассылки важно, чтобы ключ текущего варианта совпадал с ключом, указанным при открытии отчета по команде.
	Если Параметры.Свойство("КлючВарианта")
		И НЕ ПустаяСтрока(Параметры.КлючВарианта)
		И Параметры.КлючВарианта <> Форма.КлючТекущегоВарианта Тогда
		Форма.КлючТекущегоВарианта = Параметры.КлючВарианта;
	КонецЕсли;
	
	ИнициализироватьФормуОтчета(Форма);
	
	ОткрытИзРассылки = Ложь;
	Если Параметры.Свойство("ОткрытИзРассылки") Тогда
		ОткрытИзРассылки = Параметры.ОткрытИзРассылки;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ОткрытИзРассылки") Тогда
		
		Форма.ОткрытИзРассылки = ОткрытИзРассылки;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"НастроитьРассылкуОтчета",
			"Доступность",
			НЕ ОткрытИзРассылки);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"НастроитьРассылкуОтчетаВсеДействия",
			"Доступность",
			НЕ ОткрытИзРассылки);
			
		Если ТипЗнч(Параметры.ПользовательскиеНастройки) = Тип("ПользовательскиеНастройкиКомпоновкиДанных") И ОткрытИзРассылки Тогда
			ПараметрыПериода = Новый Структура("ПериодОтчета, НачалоПериода, КонецПериода, Период");
			БухгалтерскиеОтчетыВызовСервера.УстановкаПериодаОтчетаРассылка(ПараметрыПериода, Параметры.ПользовательскиеНастройки);
			Отчет = Форма.РеквизитФормыВЗначение("Отчет");
			Попытка
				ЗаполнитьЗначенияСвойств(Отчет, ПараметрыПериода);
				Форма.ЗначениеВРеквизитФормы(Отчет, "Отчет");
			Исключение
			КонецПопытки;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ОтчетТабличныйДокумент") И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "Результат") Тогда
		Форма.Результат.Вывести(Параметры.ОтчетТабличныйДокумент);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Форма.Элементы.Результат, "НеИспользовать");
	КонецЕсли;
	
	Если Параметры.Свойство("ИдентификаторСтрокиОтчета") И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "НастройкиОтчета") Тогда
		Форма.НастройкиОтчета.Вставить("ИдентификаторСтрокиОтчета", Параметры.ИдентификаторСтрокиОтчета);
	КонецЕсли;
	
	Если Параметры.Свойство("ИдентификаторФормыРассылки") И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "НастройкиОтчета") Тогда
		Форма.НастройкиОтчета.Вставить("ИдентификаторФормыРассылки", Параметры.ИдентификаторФормыРассылки);
	КонецЕсли;
	
	Если ТипЗнч(Параметры.ПользовательскиеНастройки) = Тип("Массив") И ОткрытИзРассылки Тогда // не СКД отчет 
		Отчет = Форма.РеквизитФормыВЗначение("Отчет");
		Попытка
			Отчет.ЗаполнитьНастройкиОтчетаРассылка(Параметры.ПользовательскиеНастройки, Форма);
			Форма.ЗначениеВРеквизитФормы(Отчет, "Отчет");
		Исключение
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

// Вызывается из обработчика события ОбработкаВыбора формы отчета.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Форма отчета.
//	ВыбранноеЗначение - Произвольный - Результат выбора в подчиненной форме.
//	ИсточникВыбора - Произвольный - Форма, где осуществлен выбор.
//
Процедура ФормаОтчетаОбработкаВыбора(Форма, ВыбранноеЗначение) Экспорт
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		НастройкиОтчета = Форма.НастройкиОтчета;
		НастройкиОтчета.Вставить("РассылкаОтчетаСсылка",  ВыбранноеЗначение.РассылкаОтчетаСсылка);
		НастройкиОтчета.Вставить("РассылкаОтчетаАктивна", ВыбранноеЗначение.РассылкаОтчетаАктивна);
		
		УстановитьКартинкуКнопокНастройкиРассылки(Форма, ВыбранноеЗначение.РассылкаОтчетаАктивна);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет на основе данных отчета параметры схемы компоновки данных, используемые для формирования отчетов в рассылке.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма отчета, из которой открывается форма настройки рассылки отчета.
//
Процедура ЗаполнитьНастройкиОтчетаДляРассылки(Форма, СохраняемыеРеквизитыФормы = Неопределено, УдаляемыеРеквизитыФормы = Неопределено) Экспорт
	
	Отчет = Форма.Отчет;
	
	// Сохраним значения реквизитов отчета во временную структуру для дальнейшего копирования в рассылку.
	Настройки = Новый Структура("ДополнительныеСвойства", Новый Структура);
	Форма.ОткрытИзРассылки = Истина;
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(Форма, Настройки,, СохраняемыеРеквизитыФормы);
	
	// Получим сохраненные данные отчета.
	ДанныеОтчетаРассылка = Настройки.ДополнительныеСвойства.ДанныеОтчетаРассылка.Получить();
	
	Если УдаляемыеРеквизитыФормы <> Неопределено И ТипЗнч(УдаляемыеРеквизитыФормы) = Тип("Массив") Тогда
		Для Каждого РеквизитФормы Из УдаляемыеРеквизитыФормы Цикл
			Если ДанныеОтчетаРассылка.Свойство(РеквизитФормы) Тогда
				ДанныеОтчетаРассылка.Удалить(РеквизитФормы);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// [1] Сохраним период отчета в соответствующий параметр схемы КД.
	// [2] Заполним вариант расписания по указанным значениям "НачалоПериода" и "КонецПериода".
	Если (Отчет.Свойство("НачалоПериода") И Отчет.Свойство("КонецПериода"))
		ИЛИ (Отчет.Свойство("Период") И ТипЗнч(Отчет.Период) = Тип("Дата")) Тогда
		
		НачалоПериода = ?(Отчет.Свойство("НачалоПериода"), Отчет.НачалоПериода, НачалоДня(Отчет.Период));
		КонецПериода  = ?(Отчет.Свойство("КонецПериода"),  Отчет.КонецПериода,  КонецДня(Отчет.Период));
		
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
			Отчет.КомпоновщикНастроек, "ПериодОтчета",
			Новый СтандартныйПериод(НачалоПериода, КонецПериода), Истина);
		
		ЗаполнитьВариантРасписанияВНастройкахФормыОтчета(Форма, НачалоПериода, КонецПериода);
		
	КонецЕсли;
	
	// Из всех данных отчета сохраним только те, которые используются в рассылке.
	МенеджерОтчета  = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Форма.ИмяФормы);
	НастройкиОтчета = МенеджерОтчета.ПустыеПараметрыКомпоновкиОтчета();
	
	ЗаполнитьЗначенияСвойств(НастройкиОтчета, ДанныеОтчетаРассылка);
	
	ПользовательскиеНастройки = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки;
	НастройкиОтчета.Вставить("ДанныеОтчетаРассылка", ДанныеОтчетаРассылка);
	Если ПользовательскиеНастройки <> Неопределено Тогда
		ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ДанныеОтчетаРассылка", Новый ХранилищеЗначения(ДанныеОтчетаРассылка, Новый СжатиеДанных(9)));
		Отчет.КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(ПользовательскиеНастройки);
	КонецЕсли;
	
	
	НастройкиОтчета.Вставить("НастройкиКомпоновкиДанных", Отчет.КомпоновщикНастроек.ПолучитьНастройки());
	
	ПоместитьВоВременноеХранилище(Новый ХранилищеЗначения(НастройкиОтчета, Новый СжатиеДанных(9)), Форма.НастройкиОтчета.АдресНастроекОтчета);
	
	Форма.ОткрытИзРассылки = Ложь;
	
КонецПроцедуры

// Позволяет дополнить или изменить параметры доставки при выполнении рассылки отчетов.
//
// Параметры:
//   ПараметрыДоставки - Структура - Настройки транспорта (способа доставки) отчетов.
//     Описание см. в функции РассылкаОтчетов.ВыполнитьРассылку()
//
Процедура ПриПодготовкеПараметровВыполненияРассылки(ПараметрыДоставки) Экспорт
	
	// БК 3.0
	//ПараметрыДоставки.Вставить("ПодписьАвтора", БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("Подпись"));
	
КонецПроцедуры

// Позволяет дополнить или изменить параметры доставки при выполнении рассылки отчетов.
//
// Параметры:
//   ПараметрыДоставки - Структура - Настройки транспорта (способа доставки) отчетов.
//     Описание см. в функции РассылкаОтчетов.ВыполнитьРассылку()
//   СтрокаПолучатель - СтрокаДереваЗначений, Неопределено - см. РассылкаОтчетов.ОтправитьОтчетыПолучателю().
//
Процедура ПриОтправкеОтчетовПолучателю(Вложения, ПараметрыДоставки, СтрокаПолучатель) Экспорт
	
	СформироватьПредставлениеОтчетовДляПолучателя(ПараметрыДоставки, СтрокаПолучатель);
	
	ПараметрыДоставки.ШаблонТемы = СтрЗаменить(ПараметрыДоставки.ШаблонТемы,
		"[ПредставлениеОтчета]", ПараметрыДоставки.ПредставлениеОтчетаВТемеПисьма);
	
	Если ПараметрыДоставки.ПисьмоВФорматеHTML Тогда
		ПараметрыДоставки.СформированныеОтчетыМаркированныйСписок = СтрЗаменить(
			ПараметрыДоставки.СформированныеОтчетыМаркированныйСписок,
			Символы.ПС,
			Символы.ПС + "<br>");
	КонецЕсли;
	ПараметрыДоставки.ШаблонТекста = СтрЗаменить(ПараметрыДоставки.ШаблонТекста,
		"[СформированныеОтчетыМаркированныйСписок]", ПараметрыДоставки.СформированныеОтчетыМаркированныйСписок);
	
	ПараметрыДоставки.ШаблонТекста = СтрЗаменить(ПараметрыДоставки.ШаблонТекста,
		"[ПодписьАвтора]", ПараметрыДоставки.ПодписьАвтора);
	
КонецПроцедуры

// Проверяет идентичность двух коллекций настроек отчета.
//
// Параметры:
//  КоллекцияНастроек1 - Структура,    ФиксированнаяСтруктура,
//            Соответствие, ФиксированноеСоответствие - сравниваемые данные.
//
//  КоллекцияНастроек2 - Произвольный - те же типы, что и для параметра КоллекцияНастроек1.
//
// Возвращаемое значение:
//  Булево - Истина, если совпадают.
//
Функция КоллекцииНастроекОтчетаИдентичны(ЗНАЧ КоллекцияНастроек1, ЗНАЧ КоллекцияНастроек2) Экспорт
	
	Если ТипЗнч(КоллекцияНастроек1) <> ТипЗнч(КоллекцияНастроек2) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(КоллекцияНастроек1) = Тип("Структура")
		ИЛИ ТипЗнч(КоллекцияНастроек1) = Тип("ФиксированнаяСтруктура") Тогда
		
		Если КоллекцияНастроек1.Количество() <> КоллекцияНастроек2.Количество() Тогда
			Возврат Ложь;
		КонецЕсли;
		
		КлючиКУдалению = Новый Массив;
		Для Каждого КлючИЗначение Из КоллекцияНастроек1 Цикл
			Если ТипЗнч(КлючИЗначение.Значение) = Тип("НастройкиКомпоновкиДанных")
				ИЛИ ТипЗнч(КлючИЗначение.Значение) = Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
				
				ВтороеЗначение = Неопределено;
				Если НЕ КоллекцияНастроек2.Свойство(КлючИЗначение.Ключ, ВтороеЗначение)
					ИЛИ НЕ НастройкиКомпоновкиДанныхИдентичны(КлючИЗначение.Значение, ВтороеЗначение) Тогда
					
					Возврат Ложь;
				КонецЕсли;
				
				КлючиКУдалению.Добавить(КлючИЗначение.Ключ);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого Ключ Из КлючиКУдалению Цикл
			КоллекцияНастроек1.Удалить(Ключ);
			КоллекцияНастроек2.Удалить(Ключ);
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(КоллекцияНастроек1) = Тип("Соответствие")
		ИЛИ ТипЗнч(КоллекцияНастроек1) = Тип("ФиксированноеСоответствие") Тогда
		
		Если КоллекцияНастроек1.Количество() <> КоллекцияНастроек2.Количество() Тогда
			Возврат Ложь;
		КонецЕсли;
		
		КлючиКУдалению = Новый Массив;
		Для Каждого КлючИЗначение Из КоллекцияНастроек1 Цикл
			Если ТипЗнч(КлючИЗначение.Значение) = Тип("НастройкиКомпоновкиДанных")
				ИЛИ ТипЗнч(КлючИЗначение.Значение) = Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
				
				ВтороеЗначение = КоллекцияНастроек2.Получить(КлючИЗначение.Ключ);
				Если НЕ НастройкиКомпоновкиДанныхИдентичны(КлючИЗначение.Значение, ВтороеЗначение) Тогда
					Возврат Ложь;
				КонецЕсли;
				
				КлючиКУдалению.Добавить(КлючИЗначение.Ключ);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого Ключ Из КлючиКУдалению Цикл
			КоллекцияНастроек1.Удалить(Ключ);
			КоллекцияНастроек2.Удалить(Ключ);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ДанныеСовпадают(КоллекцияНастроек1, КоллекцияНастроек2);
	
КонецФункции

// Возвращает набор параметров, которые необходимо сохранять в рассылке отчетов.
// Значения параметров используются при формировании отчета в рассылке.
//
// Возвращаемое значение:
//   Структура - структура настроек, сохраняемых в рассылке с неинициализированными значениями.
//
Функция НастройкиОтчетаСохраняемыеВРассылке() Экспорт
	
	КоллекцияНастроек = Новый Структура;
	КоллекцияНастроек.Вставить("ИдентификаторОтчета"          , "");
	КоллекцияНастроек.Вставить("ОткрытИзРассылки"             , Ложь);
	КоллекцияНастроек.Вставить("Интервалы"                    , Неопределено);
	КоллекцияНастроек.Вставить("Группировка"                  , Неопределено);
	КоллекцияНастроек.Вставить("ДополнительныеПоля"           , Неопределено);
	КоллекцияНастроек.Вставить("Показатели"                   , Неопределено);
	КоллекцияНастроек.Вставить("МакетОформления"              , Неопределено);
	КоллекцияНастроек.Вставить("НастройкиКомпоновкиДанных"    , Неопределено);
	КоллекцияНастроек.Вставить("НачалоПериода"                , Дата(1,1,1));
	КоллекцияНастроек.Вставить("КонецПериода"                 , Дата(1,1,1));
	КоллекцияНастроек.Вставить("Период"                       , Неопределено);
	КоллекцияНастроек.Вставить("ПериодОтчета"                 , Неопределено);
	КоллекцияНастроек.Вставить("ТипЗадолженности"             , 2);
	КоллекцияНастроек.Вставить("Периодичность"                , 9);
	КоллекцияНастроек.Вставить("Налогоплательщик"             , Справочники.Организации.ПустаяСсылка());
	КоллекцияНастроек.Вставить("Дата2"                        , Дата(1,1,1));
	КоллекцияНастроек.Вставить("Дата3"                        , Дата(1,1,1));
	КоллекцияНастроек.Вставить("Интервалы"                    , Неопределено);
	КоллекцияНастроек.Вставить("ВидРегистраОтчета"            , "");
	КоллекцияНастроек.Вставить("ВыводитьЗаголовок"            , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьПодписи"              , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьПодписиРуководителей" , Ложь);
	КоллекцияНастроек.Вставить("РежимРасшифровки"             , Ложь);
	КоллекцияНастроек.Вставить("ДанныеРасшифровки"            , Неопределено);
	КоллекцияНастроек.Вставить("СхемаКомпоновкиДанных"        , Неопределено);
	КоллекцияНастроек.Вставить("ИзмененыНастройкиВариант"     , Ложь);
	КоллекцияНастроек.Вставить("РазмещениеДополнительныхПолей", 0);
	
	КоллекцияНастроек.Вставить("СписокСтруктурныхЕдиниц"                     , Новый СписокЗначений);
	КоллекцияНастроек.Вставить("СписокПодразделений"                         , Новый СписокЗначений);
	КоллекцияНастроек.Вставить("СписокВладельцевГоловныхПодразделений"       , Новый СписокЗначений);
	КоллекцияНастроек.Вставить("ПеречислениеРазделыНалоговогоУчета"          , Перечисления.РазделыНалоговогоУчета.ПустаяСсылка());
	КоллекцияНастроек.Вставить("ПоддержкаРаботыСоСтруктурнымиПодразделениями", Ложь);

	Возврат КоллекцияНастроек;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область НастройкаРассылкиИзФормыОтчета

Процедура ИнициализироватьФормуОтчета(Форма)
	
	Если НЕ ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "НастройкиОтчета") Тогда
		Возврат;
	КонецЕсли;
	
	// Настройка рассылки отчета доступна только если есть права на отправку отчета по электронной почте.
	ДоступнаНастройкаРассылки = ДоступнаНастройкаРассылки();
	
	Если НЕ ДоступнаНастройкаРассылки Тогда
		СкрытьКнопкиНастройкиРассылкиОтчета(Форма);
		Возврат;
	КонецЕсли;
	
	ЗаполнитьНастройкиОтчета(Форма);
	
	// Рассылки можно добавлять только если есть ссылка варианта (т.е. он внутренний или дополнительный).
	Если Форма.НастройкиОтчета.Внешний Тогда
		СкрытьКнопкиНастройкиРассылкиОтчета(Форма);
		Возврат;
	КонецЕсли;
	
	// Рассылку можно настроить только для отчета, подключенного к подсистеме "ВариантыОтчетов".
	Если Форма.НастройкиОтчета.ВариантСсылка = Неопределено Тогда
		СкрытьКнопкиНастройкиРассылкиОтчета(Форма);
		Возврат;
	КонецЕсли;
	
	// Проверим, существуют ли настроенные пользователем рассылки отчета, сохраним ссылку на первую из них.
	РассылкиПользователяСОтчетом = НайтиРассылкиПользователяСОтчетом(Форма.НастройкиОтчета.ВариантСсылка);
	Если РассылкиПользователяСОтчетом.Количество() > 0 Тогда
		Форма.НастройкиОтчета.Вставить("РассылкаОтчетаСсылка",  РассылкиПользователяСОтчетом[0].Ссылка);
		Форма.НастройкиОтчета.Вставить("РассылкаОтчетаАктивна", РассылкиПользователяСОтчетом[0].Активна);
	Иначе
		Форма.НастройкиОтчета.Вставить("РассылкаОтчетаАктивна", Ложь);
	КонецЕсли;
	
	УстановитьКартинкуКнопокНастройкиРассылки(Форма, Форма.НастройкиОтчета.РассылкаОтчетаАктивна);
	
КонецПроцедуры

Процедура СкрытьКнопкиНастройкиРассылкиОтчета(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, "НастроитьРассылкуОтчета", "Видимость", Ложь);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, "НастроитьРассылкуОтчетаВсеДействия", "Видимость", Ложь);
	
КонецПроцедуры

Функция ДоступнаНастройкаРассылки()
	
	Возврат ПравоДоступа("Вывод", Метаданные)
		И РаботаСПочтовымиСообщениями.ДоступнаОтправкаПисем()
		И РассылкаОтчетов.ПравоДобавления();
	
КонецФункции

Процедура ЗаполнитьНастройкиОтчета(Форма)
	
	Отчет = Форма.РеквизитФормыВЗначение("Отчет");
	ОтчетМетаданные = Отчет.Метаданные();
	
	АдресСхемы = ПоместитьВоВременноеХранилище(Отчет.СхемаКомпоновкиДанных, Форма.УникальныйИдентификатор);
	
	Форма.НастройкиОтчета = ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию();
	
	НастройкиОтчета = Форма.НастройкиОтчета;
	НастройкиОтчета.Вставить("ПолноеИмя", ОтчетМетаданные.ПолноеИмя());
	
	НастройкиОтчета.Вставить("ОтчетСсылка", 
		Справочники.ИдентификаторыОбъектовМетаданных.ИдентификаторОбъектаМетаданных(ОтчетМетаданные, Ложь));
	
	НастройкиОтчета.Вставить("ВариантСсылка", ВариантыОтчетов.ВариантОтчета(НастройкиОтчета.ОтчетСсылка, Форма.КлючТекущегоВарианта));
	
	НастройкиОтчета.Вставить("Внешний", ТипЗнч(НастройкиОтчета.ОтчетСсылка) = Тип("Строка"));
	
	// Получим адрес временного хранилища, в котором будем сохранять данные отчета, передаваемые в форму настройки рассылки.
	НастройкиОтчета.Вставить("АдресНастроекОтчета", ПоместитьВоВременноеХранилище(Неопределено, Форма.УникальныйИдентификатор));
	
КонецПроцедуры

Процедура ЗаполнитьВариантРасписанияВНастройкахФормыОтчета(Форма, НачалоПериода, КонецПериода)
	
	Если НЕ ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "НастройкиОтчета") Тогда
		Возврат;
	КонецЕсли;
	
	ВариантРасписания = ВариантПериодичностиРасписанияПоГраницамПериода(НачалоПериода, КонецПериода);
	
	Если ТипЗнч(Форма.НастройкиОтчета) = Тип("Структура") Тогда
		Форма.НастройкиОтчета.Вставить("ВариантРасписания", ВариантРасписания);
	КонецЕсли;
	
КонецПроцедуры

Функция ВариантПериодичностиРасписанияПоГраницамПериода(ЗНАЧ НачалоПериода, ЗНАЧ КонецПериода)
	
	РазностьДней = (КонецПериода - НачалоПериода + 1) / (60*60*24);
	Если РазностьДней <= 1 Тогда
		Возврат Перечисления.ПериодичностиРасписанийРассылокОтчетов.Ежедневно;
	ИначеЕсли РазностьДней <= 7 Тогда
		Возврат Перечисления.ПериодичностиРасписанийРассылокОтчетов.Еженедельно;
	Иначе
		Возврат Перечисления.ПериодичностиРасписанийРассылокОтчетов.Ежемесячно;
	КонецЕсли;
	
КонецФункции

Функция НайтиРассылкиПользователяСОтчетом(ВариантОтчета)
	
	Если Не ЗначениеЗаполнено(ВариантОтчета) Или ТипЗнч(ВариантОтчета) <> Тип("СправочникСсылка.ВариантыОтчетов") 
		Или ВариантОтчета.Пустая() Тогда
		Возврат Новый ТаблицаЗначений;
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	РассылкиОтчетов.Ссылка,
		|	ВЫБОР
		|		КОГДА РассылкиОтчетов.Подготовлена И РассылкиОтчетов.ВыполнятьПоРасписанию
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Активна
		|ИЗ
		|	Справочник.РассылкиОтчетов.Отчеты КАК ТаблицаОтчеты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РассылкиОтчетов КАК РассылкиОтчетов
		|		ПО РассылкиОтчетов.Ссылка = ТаблицаОтчеты.Ссылка
		|ГДЕ
		|	ТаблицаОтчеты.Отчет = &ВариантОтчета
		|	И РассылкиОтчетов.Автор = &Автор
		|	И РассылкиОтчетов.СозданаИзФормыОтчета
		|	И НЕ РассылкиОтчетов.ПометкаУдаления");
	
	Запрос.УстановитьПараметр("ВариантОтчета", ВариантОтчета);
	Запрос.УстановитьПараметр("Автор",         ПользователиКлиентСервер.АвторизованныйПользователь());
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Процедура УстановитьКартинкуКнопокНастройкиРассылки(Форма, РассылкаОтчетаАктивна)
	
	Если РассылкаОтчетаАктивна Тогда
		Картинка = БиблиотекаКартинок.РассылкаОтчетовАктивная;
	Иначе
		Картинка = БиблиотекаКартинок.РассылкаОтчетовНеактивная;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"НастроитьРассылкуОтчета",
		"Картинка",
		Картинка);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"НастроитьРассылкуОтчетаВсеДействия",
		"Картинка",
		Картинка);
	
КонецПроцедуры

#КонецОбласти

#Область СравнениеНастроекОтчета

Функция НастройкиКомпоновкиДанныхИдентичны(ЗНАЧ КоллекцияНастроек1, ЗНАЧ КоллекцияНастроек2)
	
	Если ТипЗнч(КоллекцияНастроек1) <> ТипЗнч(КоллекцияНастроек2) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(КоллекцияНастроек1) = Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
		Возврат КоллекцияНастроек1 = КоллекцияНастроек2;
	КонецЕсли;
	
	Если ТипЗнч(КоллекцияНастроек1) <> Тип("НастройкиКомпоновкиДанных") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Для рассылки отчетов руководителя сравниваем настройки следующих наборов: Отбор, Порядок, УсловноеОформление.
	// Остальные настройки компоновки данных не редактируются пользователем интерактивно в формах отчетов.
	НастройкиСовпадают = НастройкиОтборовСовпадают(КоллекцияНастроек1.Отбор.Элементы, КоллекцияНастроек2.Отбор.Элементы)
		И НастройкиПорядкаСовпадают(КоллекцияНастроек1.Порядок.Элементы, КоллекцияНастроек2.Порядок.Элементы)
		И НастройкиУсловногоОформленияСовпадают(КоллекцияНастроек1.УсловноеОформление.Элементы, КоллекцияНастроек2.УсловноеОформление.Элементы);
	
	Возврат НастройкиСовпадают;
	
КонецФункции

Функция НастройкиОтборовСовпадают(Набор1, Набор2)
	
	Если Набор1.Количество() <> Набор2.Количество() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	КлючевыеПоля = "ЛевоеЗначение,ВидСравнения,ПравоеЗначение,Использование,Применение,Родитель";
	Для Каждого ЭлементНабора Из Набор1 Цикл
		
		// Для групп элементов отбора необходимо сравнивать вложенные отборы.
		Если ТипЗнч(ЭлементНабора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			НачальнаяПозиция = -1;
			ЕстьИдентичнаяГруппа = Ложь;
			// Из-за отсутствия какого-либо идентификатора в группах элементов отбора, выполняем обход всех групп.
			Пока Истина Цикл
				ГруппаЭлементовНабора2 = НайтиПодходящуюГруппуЭлементов(Набор2, ЭлементНабора, НачальнаяПозиция);
				Если ГруппаЭлементовНабора2 = Неопределено Тогда
					Прервать;
				КонецЕсли;
				
				ЕстьИдентичнаяГруппа = ЕстьИдентичнаяГруппа
					ИЛИ НастройкиОтборовСовпадают(ЭлементНабора.Элементы, ГруппаЭлементовНабора2.Элементы);
			КонецЦикла;
			
			Если НЕ ЕстьИдентичнаяГруппа Тогда
				Возврат Ложь;
			КонецЕсли;
		ИначеЕсли НайтиПодходящийЭлемент(Набор2, ЭлементНабора, КлючевыеПоля) = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция НастройкиПорядкаСовпадают(Набор1, Набор2)
	
	Если Набор1.Количество() <> Набор2.Количество() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	КлючевыеПоля = "Поле,Использование,ТипУпорядочивания";
	Для Индекс = 0 По Набор1.Количество() - 1 Цикл
		Данные1 = ЗначениеВСтруктуру(Набор1[Индекс], КлючевыеПоля);
		Данные2 = ЗначениеВСтруктуру(Набор2[Индекс], КлючевыеПоля);
		Если НЕ ОбщегоНазначения.ДанныеСовпадают(Данные1, Данные2) Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция НастройкиУсловногоОформленияСовпадают(Набор1, Набор2)
	
	Если Набор1.Количество() <> Набор2.Количество() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СравниваемыеПоля = "Использование,ИспользоватьВГруппировке,ИспользоватьВЗаголовке,ИспользоватьВЗаголовкеПолей,
		|ИспользоватьВИерархическойГруппировке,ИспользоватьВОбщемИтоге,ИспользоватьВОтборе,ИспользоватьВПараметрах";
	Для Каждого ЭлементНабора1 Из Набор1 Цикл
		ДанныеДляСравнения1 = ЗначениеВСтруктуру(ЭлементНабора1, СравниваемыеПоля);
		НайденЭлементВНаборе2 = Ложь;
		Для Каждого ЭлементНабора2 Из Набор2 Цикл
			ДанныеДляСравнения2 = ЗначениеВСтруктуру(ЭлементНабора2, СравниваемыеПоля);
			Если НЕ ОбщегоНазначения.ДанныеСовпадают(ДанныеДляСравнения1, ДанныеДляСравнения2) Тогда
				Продолжить;
			КонецЕсли;
			
			НайденЭлементВНаборе2 = ПараметрыУсловногоОформленияСовпадают(ЭлементНабора1.Оформление.Элементы, ЭлементНабора2.Оформление.Элементы)
				И ПоляУсловногоОформленияСовпадают(ЭлементНабора1.Поля.Элементы, ЭлементНабора2.Поля.Элементы)
				И НастройкиОтборовСовпадают(ЭлементНабора1.Отбор.Элементы, ЭлементНабора2.Отбор.Элементы);
				
			Если НайденЭлементВНаборе2 Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если НЕ НайденЭлементВНаборе2 Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция ПараметрыУсловногоОформленияСовпадают(Набор1, Набор2)
	
	Если Набор1.Количество() <> Набор2.Количество() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	КлючевыеПоля = "Использование,Параметр";
	Для Каждого ЭлементНабора1 Из Набор1 Цикл
		ЭлементНабора2 = НайтиПодходящийЭлемент(Набор2, ЭлементНабора1, КлючевыеПоля);
		Если ЭлементНабора2 = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		
		// Если в обоих наборах свойство "Использование" не установлено, то нет необходимости в дальнейшем сравнении значений.
		Если НЕ ЭлементНабора1.Использование Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЭлементНабора1.ЗначенияВложенныхПараметров.Количество() > 0 Тогда
			Если НЕ ПараметрыУсловногоОформленияСовпадают(ЭлементНабора1.ЗначенияВложенныхПараметров, ЭлементНабора2.ЗначенияВложенныхПараметров) Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЕсли;
		
		// В остальных случаях проверяем значения параметров условного оформления на равенство.
		Если НЕ ОбщегоНазначения.ДанныеСовпадают(ЭлементНабора1.Значение, ЭлементНабора2.Значение) Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция ПоляУсловногоОформленияСовпадают(Набор1, Набор2)
	
	Если Набор1.Количество() <> Набор2.Количество() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	КлючевыеПоля = "Поле,Использование";
	Для Каждого ЭлементНабора1 Из Набор1 Цикл
		Если НайтиПодходящийЭлемент(Набор2, ЭлементНабора1, КлючевыеПоля) = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция НайтиПодходящуюГруппуЭлементов(НаборЭлементов, Эталон, НачальнаяПозицияПоиска)
	
	КлючевыеПоля = "ТипГруппы, Применение, Родитель, Использование";
	СтруктураЭталона = ЗначениеВСтруктуру(Эталон, КлючевыеПоля);
	
	КоличествоЭлементов = НаборЭлементов.Количество();
	Индекс = НачальнаяПозицияПоиска + 1;
	Пока Индекс < КоличествоЭлементов Цикл
		Элемент = НаборЭлементов[Индекс];
		
		Если ТипЗнч(Элемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			СтруктураЭлемента = ЗначениеВСтруктуру(Элемент, КлючевыеПоля);
			
			Если ОбщегоНазначения.ДанныеСовпадают(СтруктураЭталона, СтруктураЭлемента) Тогда
				НачальнаяПозицияПоиска = Индекс;
				Возврат Элемент;
			КонецЕсли;
		КонецЕсли;
		
		Индекс = Индекс + 1;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

Функция НайтиПодходящийЭлемент(НаборЭлементов, Эталон, ПоляПоиска)
	
	СтруктураЭталона = ЗначениеВСтруктуру(Эталон, ПоляПоиска);
	
	Для Каждого Элемент Из НаборЭлементов Цикл
		СтруктураЭлемента = ЗначениеВСтруктуру(Элемент, ПоляПоиска);
		
		Если ОбщегоНазначения.ДанныеСовпадают(СтруктураЭталона, СтруктураЭлемента) Тогда
			Возврат Элемент;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

Функция ЗначениеВСтруктуру(Значение, ОписаниеПолей)
	
	Структура = Новый Структура(ОписаниеПолей);
	ЗаполнитьЗначенияСвойств(Структура, Значение);
	
	Если Структура.Количество() = 1 Тогда
		Для Каждого КлючИЗначение Из Структура Цикл
			КлючИЗначение.Значение = Значение;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Структура;
	
КонецФункции

#КонецОбласти

Процедура СформироватьПредставлениеОтчетовДляПолучателя(ПараметрыДоставки, СтрокаПолучатель)
	
	ЗаполнитьСформированныеОтчетыВШаблонеСообщения =
		СтрНайти(ПараметрыДоставки.ШаблонТекста, "[СформированныеОтчетыМаркированныйСписок]") <> 0;
	
	ЗаполнитьПредставлениеОтчетаВТемеПисьма =
		СтрНайти(ПараметрыДоставки.ШаблонТемы, "[ПредставлениеОтчета]") <> 0;
	
	ПредставлениеОтчетаВТемеПисьма = "";
	СформированныеОтчетыМаркированныйСписок = "";
	
	ШаблонПредставлениеОтчета = "%1%2 %3";
	ЗнакМаркера = "-";
	
	Если ПараметрыДоставки.ИспользоватьЭлектроннуюПочту
		И (ЗаполнитьСформированныеОтчетыВШаблонеСообщения ИЛИ ЗаполнитьПредставлениеОтчетаВТемеПисьма) Тогда
		
		Разделитель = Символы.ПС;
		Если ПараметрыДоставки.ДобавлятьСсылки = "ПослеОтчетов" Тогда
			Разделитель = Разделитель + Символы.ПС;
		КонецЕсли;
		
		Индекс = 0;
		
		Для Каждого СтрокаОтчет Из ПараметрыДоставки.СтрокаОбщихОтчетов.Строки Цикл
			Индекс = Индекс + 1;
			
			ПредставлениеВПисьме = ПредставлениеОтчетаВПисьме(СтрокаОтчет);
			ПредставлениеОтчетаВТемеПисьма = ПредставлениеОтчетаВТемеПисьма + ПредставлениеВПисьме + Разделитель;
			СформированныеОтчетыМаркированныйСписок = СформированныеОтчетыМаркированныйСписок
				+ СтрШаблон(ШаблонПредставлениеОтчета, Разделитель, ЗнакМаркера, ПредставлениеВПисьме);
		КонецЦикла;
		
		Если СтрокаПолучатель <> Неопределено И СтрокаПолучатель <> ПараметрыДоставки.СтрокаОбщихОтчетов Тогда
			Для Каждого СтрокаОтчет Из СтрокаПолучатель.Строки Цикл
				Индекс = Индекс + 1;
				
				ПредставлениеВПисьме = ПредставлениеОтчетаВПисьме(СтрокаОтчет);
				
				ПредставлениеОтчетаВТемеПисьма = ПредставлениеОтчетаВТемеПисьма + ПредставлениеВПисьме + Разделитель;
				
				СформированныеОтчетыМаркированныйСписок = СформированныеОтчетыМаркированныйСписок
					+ СтрШаблон(ШаблонПредставлениеОтчета, Разделитель, ЗнакМаркера, ПредставлениеВПисьме);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	ПредставлениеОтчетаВТемеПисьма = СтрЗаменить(СокрЛП(ПредставлениеОтчетаВТемеПисьма), Разделитель, ", ");
	
	ПараметрыДоставки.Вставить("ПредставлениеОтчетаВТемеПисьма", СокрЛП(ПредставлениеОтчетаВТемеПисьма));
	ПараметрыДоставки.Вставить("СформированныеОтчетыМаркированныйСписок", СокрЛП(СформированныеОтчетыМаркированныйСписок));
	
КонецПроцедуры

Функция ПредставлениеОтчетаВПисьме(СтрокаПараметрыОтчета)
	
	Если СтрокаПараметрыОтчета.Строки.Количество() = 1 Тогда
		Возврат СтрокаПараметрыОтчета.Строки[0].Настройки.ИмяФайла;
	КонецЕсли;
	
	Возврат СтрокаПараметрыОтчета.Настройки.ПредставлениеВПисьме;
	
КонецФункции

#КонецОбласти
