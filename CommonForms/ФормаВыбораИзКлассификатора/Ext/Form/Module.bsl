﻿////////////////////////////////////////////////////////////////////////////////
// Описание формы
// Параметры фомры:
//  ИмяМакета - Строка - передается имя макета.
//  ИмяСекции - Строка - передается имя секции макета.
//  ПолучатьПолныеДанные - Булево - признак возврата полных данных. Если Истина то возвращается структура "Код" и "Наименование" если Ложь то возвращается только "Код".
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КоличествоГрупп = 2;
	
	Если НЕ ЗначениеЗаполнено(Параметры.ИмяМакета) ИЛИ НЕ ЗначениеЗаполнено(Параметры.ИмяСекции) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ЗаголовокФормы = "";
	
	Если Параметры.Свойство("Заголовок", ЗаголовокФормы) И ЗначениеЗаполнено(ЗаголовокФормы) Тогда
		ЭтаФорма.АвтоЗаголовок = Ложь;
		ЭтаФорма.Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	ИмяМакета 		 = Параметры.ИмяМакета;
	ИмяСекции 		 = Параметры.ИмяСекции;
	АдресМакета      = Параметры.АдресМакета;
	ТекущийКодСтроки = Параметры.ТекущийКодСтроки;
	
	ПолучатьПолныеДанные = Параметры.ПолучатьПолныеДанные;
	
	Дерево = РеквизитФормыВЗначение("Таблица",Тип("ДеревоЗначений"));
	Дерево.Строки.Очистить();
	
	Если ЗначениеЗаполнено(СсылкаНаКлассификатор) Тогда
		Попытка
			ИмяФайла = ПолучитьИмяВременногоФайла();
			
			ДвоичныеДанные = СсылкаНаКлассификатор.ХранилищеОбработки.Получить();
			ДвоичныеДанные.Записать(ИмяФайла);
			
			Макет = Новый ТабличныйДокумент;
			Макет.Прочитать(ИмяФайла); 
			
			УдалитьФайлы(ИмяФайла);
		Исключение
			СсылкаНаКлассификатор = Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка();
			Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_" + СокрЛП(Параметры.ИмяМакета));
			Если Параметры.Свойство("ЯзыкМакета") Тогда
				Макет.КодЯзыка = Параметры.ЯзыкМакета;
			КонецЕсли;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Классификатор не найден'"));
		КонецПопытки;
	Иначе
		Если Не Параметры.Свойство("ИмяОтчета") Тогда
			//Имя макета может передаваться полностью
			Если Параметры.ИмяМакета = "ПереченьИзъятий" Тогда
				Макет = РегистрыСведений.ТоварыСПониженнойСтавкойПошлин.ПолучитьМакетПереченьИзъятий();
				Элементы.ДекорацияНадписьЗаголовка.Заголовок = НСтр("ru = 'Перечень изъятий'");
			ИначеЕсли ЭтоАдресВременногоХранилища(АдресМакета) Тогда
				Попытка
					Макет = ПолучитьИзВременногоХранилища(АдресМакета);
				Исключение
					Макет = Неопределено;
				КонецПопытки;
				Если ТипЗнч(Макет) <> Тип("ТабличныйДокумент") И ТипЗнч(Макет) <> Тип("ТекстовыйДокумент") Тогда
					Отказ = Истина;
				КонецЕсли;
			ИначеЕсли Найти(СокрЛП(Параметры.ИмяМакета), "ПФ_MXL_") Тогда
				Макет = УправлениеПечатью.МакетПечатнойФормы(СокрЛП(Параметры.ИмяМакета));
			Иначе
				Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_" + СокрЛП(Параметры.ИмяМакета));
				Если Параметры.Свойство("ЯзыкМакета") Тогда
					Макет.КодЯзыка = Параметры.ЯзыкМакета;
				КонецЕсли;
			КонецЕсли;
		Иначе
			Макет = Отчеты[Параметры.ИмяОтчета].ПолучитьМакет(СокрЛП(Параметры.ИмяМакета));
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.ИмяМакета = "КодыТНВЭД" Тогда
		МакетТНВЭД = Макет;
		СписокТНВЭДПереченьИзъятий = РегистрыСведений.ТоварыСПониженнойСтавкойПошлин.ЗаполнитьСписокПереченьИзъятий();
		ЗаполнениеТаблицыТНВЭД(Параметры.ИмяСекции, МакетТНВЭД, Дерево);
		УправлениеФормой(ЭтаФорма);
		Возврат;
	КонецЕсли;
	
	ВремяНачалаЗамера = ОценкаПроизводительности.НачатьЗамерВремени();	
	
	Если ТипЗнч(Макет) = Тип("ТабличныйДокумент") Тогда
		
		ТекстШапки = Макет.ПолучитьОбласть("Шапка|Наименование").ТекущаяОбласть.Текст;
		Элементы.ДекорацияНадписьЗаголовка.Заголовок = СокрЛП(ТекстШапки);
		
		Область = Макет.Области[Параметры.ИмяСекции];
		
		Для Ном = Область.Верх По Область.Низ Цикл
			Если НЕ СокрЛП(Макет.Область(Ном, 5).Текст) = "" Тогда
				Если НЕ СокрЛП(Макет.Область(Ном, 1).Текст) = "" Тогда
					НоваяСтрока = Дерево.Строки.Добавить();
					НоваяСтрока.КодСтроки    = СокрЛП(Макет.Область(Ном, 1).Текст);
					НоваяСтрока.Наименование = СокрЛП(Макет.Область(Ном, 5).Текст);
					НоваяСтрока.Группа = 0;
				ИначеЕсли НЕ СокрЛП(Макет.Область(Ном, 2).Текст) = "" Тогда
					Подстрока = НоваяСтрока.Строки.Добавить();
					Подстрока.КодСтроки    = СокрЛП(Макет.Область(Ном, 2).Текст);
					Подстрока.Наименование = СокрЛП(Макет.Область(Ном, 5).Текст);
					Подстрока.Группа = 1;
				ИначеЕсли НЕ СокрЛП(Макет.Область(Ном, 3).Текст) = "" Тогда
					ПодстрокаПодстроки = Подстрока.Строки.Добавить();
					ПодстрокаПодстроки.КодСтроки    = СокрЛП(Макет.Область(Ном, 3).Текст);
					ПодстрокаПодстроки.Наименование = СокрЛП(Макет.Область(Ном, 5).Текст);
					ПодстрокаПодстроки.Группа = 2;
				ИначеЕсли НЕ СокрЛП(Макет.Область(Ном, 4).Текст) = "" Тогда
					ПодстрокаПодстрокиСтроки = ПодстрокаПодстроки.Строки.Добавить();
					ПодстрокаПодстрокиСтроки.КодСтроки    = СокрЛП(Макет.Область(Ном, 4).Текст);
					ПодстрокаПодстрокиСтроки.Наименование = СокрЛП(Макет.Область(Ном, 5).Текст);
					ПодстрокаПодстрокиСтроки.Группа = 3;
					Группировать = Истина; 
				КонецЕсли;
				КоличествоГрупп = 3;
				
			ИначеЕсли НЕ СокрЛП(Макет.Область(Ном, 4).Текст) = "" Тогда
				Если НЕ СокрЛП(Макет.Область(Ном, 1).Текст) = "" Тогда
					НоваяСтрока = Дерево.Строки.Добавить();
					НоваяСтрока.КодСтроки    = СокрЛП(Макет.Область(Ном, 1).Текст);
					НоваяСтрока.Наименование = СокрЛП(Макет.Область(Ном, 4).Текст);
					НоваяСтрока.Группа = 0;
				ИначеЕсли НЕ СокрЛП(Макет.Область(Ном, 2).Текст) = "" Тогда
					Подстрока = НоваяСтрока.Строки.Добавить();
					Подстрока.КодСтроки    = СокрЛП(Макет.Область(Ном, 2).Текст);
					Подстрока.Наименование = СокрЛП(Макет.Область(Ном, 4).Текст);
					Подстрока.Группа = 1;
				ИначеЕсли НЕ СокрЛП(Макет.Область(Ном, 3).Текст) = "" Тогда
					ПодстрокаПодстроки = Подстрока.Строки.Добавить();
					ПодстрокаПодстроки.КодСтроки    = СокрЛП(Макет.Область(Ном, 3).Текст);
					ПодстрокаПодстроки.Наименование = СокрЛП(Макет.Область(Ном, 4).Текст);
					ПодстрокаПодстроки.Группа = 2;
					Группировать = Истина;
				КонецЕсли;
				КоличествоГрупп = 2;
			ИначеЕсли НЕ СокрЛП(Макет.Область(Ном, 3).Текст) = "" Тогда 
				НоваяСтрока = Дерево.Строки.Добавить();
				НоваяСтрока.КодСтроки    = СокрЛП(Макет.Область(Ном, 1).Текст);
				НоваяСтрока.Наименование = СокрЛП(Макет.Область(Ном, 2).Текст);
				НоваяСтрока.Группа = 1;
				Если Параметры.ИмяСекции = "СН" Тогда
					ОбластьПодстроки = Макет.Области[Параметры.ИмяСекции + "_200" + "_" + СтрЗаменить(НоваяСтрока.КодСтроки, "E", "A")];
				ИначеЕсли СтрНайти(Параметры.ИмяСекции, "НалогНаПрибыль") <> 0 Тогда
					ИмяПодсекции = СокрЛП(Макет.Область(Ном, 3).Текст);
                    ОбластьПодстроки = Макет.Области[ИмяПодсекции];
                Иначе 
                    ОбластьПодстроки = Макет.Области[Параметры.ИмяСекции + "_" + СтрЗаменить(НоваяСтрока.КодСтроки,".","_")];              	
                КонецЕсли; 
				Для НомПодСекции = ОбластьПодстроки.Верх По ОбластьПодстроки.Низ Цикл
					Подстрока = НоваяСтрока.Строки.Добавить();
					Подстрока.КодСтроки    = СокрЛП(Макет.Область(НомПодСекции, 1).Текст);
					Подстрока.Наименование = СокрЛП(Макет.Область(НомПодСекции, 2).Текст);
					Подстрока.КодПодстроки = НоваяСтрока.КодСтроки + "." + СокрЛП(Макет.Область(НомПодСекции, 1).Текст);
					Подстрока.Группа = 0;
				КонецЦикла;	
			Иначе	
				Строка = Дерево.Строки.Добавить();
				Строка.КодСтроки    = СокрЛП(Макет.Область(Ном, 1).Текст);
				Строка.Наименование = СокрЛП(Макет.Область(Ном, 2).Текст);
			КонецЕсли;
			
		КонецЦикла;
		
		Если Параметры.Свойство("ПустойКодСтрокиДекларации") Тогда
			ПустойКодОбласть = Макет.Области.Найти("ПустойКодСтрокиДекларации");
			Если ПустойКодОбласть <> Неопределено Тогда
				Для Ном = ПустойКодОбласть.Верх По ПустойКодОбласть.Низ Цикл
					Строка = Дерево.Строки.Добавить();
					Строка.КодСтроки    = СокрЛП(Макет.Область(Ном, 1).Текст);
					Строка.Наименование = СокрЛП(Макет.Область(Ном, 2).Текст);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Макет) = Тип("ТекстовыйДокумент") Тогда
		
		КлассификаторXML = Макет.ПолучитьТекст();
		ТаблицаПоказателей = ОбщегоНазначения.ЗначениеИзСтрокиXML(КлассификаторXML);
		
		Если НЕ Тип(ТаблицаПоказателей) =  Тип("ТаблицаЗначений") Тогда
			Возврат;
		КонецЕсли;
		
		Если ТаблицаПоказателей.Колонки.Найти("КодТНВЭД") = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Для Каждого СтрокаПоказателя Из ТаблицаПоказателей Цикл
			НоваяСтрока = Дерево.Строки.Добавить();
			НоваяСтрока.КодСтроки    = СокрЛП(СтрокаПоказателя.КодТНВЭД);
			НоваяСтрока.Наименование = СокрЛП(СтрокаПоказателя.НаименованиеСтроки);
		КонецЦикла;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(Дерево,"Таблица");
	
	Если ТекущийКодСтроки <> Неопределено И ТекущийКодСтроки <> "" Тогда
		ТекущийКодСтроки = ?(Прав(СокрЛП(ТекущийКодСтроки),1) = ".", Лев(ТекущийКодСтроки, СтрДлина(СокрЛП(ТекущийКодСтроки)) -1), СокрЛП(ТекущийКодСтроки));	
		
		МассивНайденныхСтрок = Новый Массив;
		НайтиСтрокиВДанныхФормыДерево(Таблица.ПолучитьЭлементы(), "КодСтроки", ТекущийКодСтроки, МассивНайденныхСтрок);
		Если МассивНайденныхСтрок.Количество() <> 0 Тогда
			Элементы.Таблица.ТекущаяСтрока = МассивНайденныхСтрок[0].ПолучитьИдентификатор();
		КонецЕсли;
		
	КонецЕсли;
	
	ТекстИмениМакета = ИмяМакета;
	Если СтрНайти(ТекстИмениМакета, "Коды") Тогда
		ТекстИмениМакета = "Коды " + Нрег(СтрЗаменить(ТекстИмениМакета, "Коды", ""));
	КонецЕсли;	
	ОценкаПроизводительности.ЗакончитьЗамерВремени("Форма выбора из классификатора (заполнение таблицы """ + ТекстИмениМакета + """)", ВремяНачалаЗамера);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Если Форма.ИмяМакета = "КодыКатегорийЗемель" Тогда
		Элементы.ТаблицаКодСтроки.Заголовок = НСтр("ru='Наименование'");
		Элементы.ТаблицаНаименование.Заголовок = НСтр("ru='Полное наименование'");
	КонецЕсли;
	
	Если Не Форма.ИмяМакета = "КодыТНВЭД" Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Неопределено;
	ТекущаяСтрока = Элементы.Таблица.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		ТекущиеДанные = Форма.Таблица.НайтиПоИдентификатору(ТекущаяСтрока);
	КонецЕсли;
	
	Если ТекущиеДанные <> Неопределено И ТекущиеДанные.КодСтроки <> "" Тогда
		Если ЗначениеЗаполнено(ТекущиеДанные.ВходитВПереченьИзъятия) Тогда
			Элементы.НадписьВходитВПереченьИзъятий.Видимость = Истина;
		Иначе
			Элементы.НадписьВходитВПереченьИзъятий.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НайтиСтрокиВДанныхФормыДерево(ЭлементыДанныхФормыДерево, ИмяКолонки, ИскомоеЗначение, МассивНайденныхСтрок)
	
	Для Каждого ЭлементДерева Из ЭлементыДанныхФормыДерево Цикл
		
		ЗначенияСовпадают = Истина;
		
		Если ЭлементДерева[ИмяКолонки] <> ИскомоеЗначение  Тогда
			ЗначенияСовпадают = Ложь;
		КонецЕсли;
		
		Если ЗначенияСовпадают Тогда
			МассивНайденныхСтрок.Добавить(ЭлементДерева);
		КонецЕсли;
		
		НайтиСтрокиВДанныхФормыДерево(ЭлементДерева.ПолучитьЭлементы(), "КодПодстроки", ИскомоеЗначение, МассивНайденныхСтрок);
	КонецЦикла;
	
	Возврат МассивНайденныхСтрок;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ "ТАБЛИЦА"

&НаКлиенте
Процедура ТаблицаВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ЗначениеВозврата = Неопределено;
	
	Если НЕ ПустаяСтрока(Элемент.ТекущиеДанные.КодПодстроки) Тогда
		КодСтроки = Элемент.ТекущиеДанные.КодПодстроки;
		ИмяКолонки = "КодПодстроки";
	Иначе
		КодСтроки = Элемент.ТекущиеДанные.КодСтроки;
		ИмяКолонки = "КодСтроки";
 	КонецЕсли;
	
	Выбор(КодСтроки, ЗначениеВозврата, ИмяКолонки);
	
	Если ЗначениеВозврата = Неопределено Тогда 
		Возврат
	КонецЕсли;
	
	Если ТипЗнч(ЗначениеВозврата) = Тип("Структура")
			И ЗначениеВозврата.Свойство("Развернуть") Тогда
		СтрокаДерева = Элементы.Таблица.ТекущаяСтрока;
		
		Если Элементы.Таблица.Развернут(СтрокаДерева) Тогда
			Элементы.Таблица.Свернуть(СтрокаДерева);
		Иначе	
			Элементы.Таблица.Развернуть(СтрокаДерева, Истина);
		КонецЕсли;	
		Возврат
	КонецЕсли;
	
	ОповеститьОВыборе(ЗначениеВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПриАктивизацииСтроки(Элемент)
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура Выбор(КодСтроки, ЗначениеВозврата, ИмяКолонки)
	
	Дерево = РеквизитФормыВЗначение("Таблица");
	
	Если ИмяСекции = "НДС_Реализация" ИЛИ ИмяСекции = "НДС_Зачет" ИЛИ ИмяСекции = "СН"
			ИЛИ ИмяСекции = "НалогНаПрибыль_Доходы" ИЛИ ИмяСекции = "НалогНаПрибыль_Расходы" Тогда
		МассивНайденныхСтрок = Новый Массив;
		НайтиСтрокиВДанныхФормыДерево(Таблица.ПолучитьЭлементы(), ИмяКолонки, КодСтроки, МассивНайденныхСтрок);
		Если МассивНайденныхСтрок.Количество() <> 0 Тогда
			ВыбраннаяСтрока = МассивНайденныхСтрок[0];
		КонецЕсли;
	Иначе
		ВыбраннаяСтрока = Дерево.Строки.Найти(КодСтроки, "КодСтроки", Истина);
	КонецЕсли;
	
	Если Группировать = Истина Тогда
		Если ИмяМакета = "КодыТНВЭД" Тогда
			ВыборТНВЭД(ВыбраннаяСтрока, ЗначениеВозврата);
			Возврат
		КонецЕсли;
		Если Не ВыбраннаяСтрока.Родитель = Неопределено И ВыбраннаяСтрока.Группа = КоличествоГрупп Тогда
			Если ПолучатьПолныеДанные Тогда
				ЗначениеВозврата = Новый Структура("КодСтроки, Наименование", ВыбраннаяСтрока.КодСтроки, ВыбраннаяСтрока.Наименование);
			Иначе
				ЗначениеВозврата = ВыбраннаяСтрока.КодСтроки;
			КонецЕсли;
		Иначе
			Возврат;
		КонецЕсли;
	ИначеЕсли ИмяСекции = "НДС_Реализация" ИЛИ ИмяСекции = "НДС_Зачет" ИЛИ ИмяСекции = "СН"
			ИЛИ ИмяСекции = "НалогНаПрибыль_Доходы" ИЛИ ИмяСекции = "НалогНаПрибыль_Расходы" Тогда
		Если ВыбраннаяСтрока.Группа = 1 И НЕ ИмяСекции = "СН"
				И НЕ ИмяСекции = "НалогНаПрибыль_Доходы" И НЕ ИмяСекции = "НалогНаПрибыль_Расходы" Тогда
			СтандартнаяОбработка = Ложь;
			ЗначениеВозврата = Новый Структура("КодСтроки, Развернуть", ВыбраннаяСтрока.КодСтроки, Истина);
		Иначе 
			СтандартнаяОбработка = Ложь;
			Если ПолучатьПолныеДанные Тогда
				ЗначениеВозврата = Новый Структура("КодСтроки, Наименование", КодСтроки, ВыбраннаяСтрока.Наименование);
			Иначе
				ЗначениеВозврата = КодСтроки;
			КонецЕсли;
		КонецЕсли;	
	ИначеЕсли СтрНайти(ИмяСекции, "НДС_Реализация_") <>	0 
				ИЛИ СтрНайти(ИмяСекции, "НДС_Зачет_") <> 0 
                ИЛИ СтрНайти(ИмяСекции, "СН_") <> 0
				ИЛИ СтрНайти(ИмяСекции, "НалогНаПрибыль_Доходы_") <> 0 
				ИЛИ СтрНайти(ИмяСекции, "НалогНаПрибыль_Расходы_") <> 0 Тогда 
		СтандартнаяОбработка = Ложь;	
		ЗначениеВозврата = ВыбраннаяСтрока.КодСтроки;
	Иначе	
		СтандартнаяОбработка = Ложь;
		Если ПолучатьПолныеДанные Тогда
			ЗначениеВозврата = Новый Структура("КодСтроки, Наименование", ВыбраннаяСтрока.КодСтроки, ВыбраннаяСтрока.Наименование);
		Иначе
			ЗначениеВозврата = ВыбраннаяСтрока.КодСтроки;
		КонецЕсли;
	КонецЕсли;
	
	Если ВозвращатьСтруктуруДополнительныхПараметров Тогда
		ЗначениеВозврата = Новый Структура("ЗначениеВыбора, Команда, СтруктураДопПараметров",ЗначениеВозврата, "ПодборИзКлассификатора", СтруктураДополнительныхПараметров);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыборТНВЭД(ВыбраннаяСтрока, ЗначениеВозврата)

	Если Группировать = Истина Тогда
		Если Не ВыбраннаяСтрока.Родитель = Неопределено И ВыбраннаяСтрока.Группа = КоличествоГрупп Тогда 
			Если ПолучатьПолныеДанные Тогда
				ЗначениеВозврата = Новый Структура("КодСтроки, Наименование,ВходитВПереченьИзъятия", ВыбраннаяСтрока.КодСтроки, ВыбраннаяСтрока.Наименование, ВыбраннаяСтрока.ВходитВПереченьИзъятия);
			Иначе
				ЗначениеВозврата = ВыбраннаяСтрока.КодСтроки;
			КонецЕсли;
		Иначе	
			Если СтрДлина(ВыбраннаяСтрока.КодСтроки) = 2 Тогда 
				ИмяСекции = "Область"+ВыбраннаяСтрока.КодСтроки;
				
				ДоЗаписьТаблицыТНВЭД(ИмяСекции, Неопределено);
				
				МассивНайденныхСтрок = Новый Массив;
				НайтиСтрокиВДанныхФормыДерево(Таблица.ПолучитьЭлементы(), "КодСтроки", ВыбраннаяСтрока.КодСтроки, МассивНайденныхСтрок);
				Если МассивНайденныхСтрок.Количество() <> 0 Тогда
					Элементы.Таблица.ТекущаяСтрока = МассивНайденныхСтрок[0].ПолучитьИдентификатор();
				КонецЕсли;
			КонецЕсли;
			
			Возврат;
			
		КонецЕсли;
	КонецЕсли;
	
	Если ВозвращатьСтруктуруДополнительныхПараметров Тогда
		ЗначениеВозврата = Новый Структура("ЗначениеВыбора, Команда, СтруктураДопПараметров",ЗначениеВозврата, "ПодборИзКлассификатора", СтруктураДополнительныхПараметров);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнениеТаблицыТНВЭД(ИмяСекции, Макет, Дерево)
	
	ВремяНачалаЗамера = ОценкаПроизводительности.НачатьЗамерВремени();
	
	ТаблицаТНВЭДПереченьИзъятий = Новый ТаблицаЗначений;
	ТаблицаТНВЭДПереченьИзъятий.Колонки.Добавить("Код", Новый ОписаниеТипов("Строка"));
	
	МассивКодов = СписокТНВЭДПереченьИзъятий.ВыгрузитьЗначения();
	Для Н = 1 По МассивКодов.Количество() Цикл
    	ТаблицаТНВЭДПереченьИзъятий.Добавить();
	КонецЦикла; 
	
	ТаблицаТНВЭДПереченьИзъятий.ЗагрузитьКолонку(МассивКодов, "Код");
	ТаблицаТНВЭДПереченьИзъятий.Индексы.Добавить("Код");
	
	ТекстШапки = Макет.ПолучитьОбласть("Шапка|Наименование").ТекущаяОбласть.Текст;
	Элементы.ДекорацияНадписьЗаголовка.Заголовок = СокрЛП(ТекстШапки);
	
	Область = Макет.Области["Область00"];
	
	АктуальнаяВетка = Неопределено;
	ТекСтрока = Неопределено;
	Для Ном = Область.Верх По Область.Низ Цикл
		Если НЕ СокрЛП(Макет.Область(Ном, 5).Текст) = "" Тогда
			Если НЕ СокрЛП(Макет.Область(Ном, 1).Текст) = "" Тогда
				НоваяСтрока = Дерево.Строки.Добавить();
				НоваяСтрока.КодСтроки    = СокрЛП(Макет.Область(Ном, 1).Текст);
				НоваяСтрока.Наименование = СокрЛП(Макет.Область(Ном, 5).Текст);
				НоваяСтрока.Группа = 0;
				
				АктуальнаяВетка = НоваяСтрока;
				// Обнуляем последующие
				Подстрока = Неопределено;
				ПодстрокаПодстроки = Неопределено;
				
				ТекСтрока = НоваяСтрока;
			ИначеЕсли НЕ СокрЛП(Макет.Область(Ном, 2).Текст) = "" И НЕ СокрЛП(Макет.Область(Ном, 2).Текст) = "#" Тогда
				Если НоваяСтрока <> Неопределено Тогда
					// в пределах стандартной иерархии
					РодительскаяВетка = НоваяСтрока;
				Иначе
					//родитель не определен. Включаем в последнюю актуальную группу
					РодительскаяВетка = АктуальнаяВетка;
				КонецЕсли;		
				Подстрока = РодительскаяВетка.Строки.Добавить();
				Подстрока.КодСтроки    = СокрЛП(Макет.Область(Ном, 2).Текст);
				Подстрока.Наименование = СокрЛП(Макет.Область(Ном, 5).Текст);
				Подстрока.Группа = 1;
				ТекСтрока = Подстрока;
				
				АктуальнаяВетка = Подстрока;
				// Обнуляем последующие
				ПодстрокаПодстроки = Неопределено;
			ИначеЕсли НЕ СокрЛП(Макет.Область(Ном, 3).Текст) = "" И НЕ СокрЛП(Макет.Область(Ном, 3).Текст) = "#" Тогда
				Если Подстрока <> Неопределено Тогда
					// в пределах стандартной иерархии
					РодительскаяВетка = Подстрока;
				Иначе
					//родитель не определен. Включаем в последнюю актуальную группу
					РодительскаяВетка = АктуальнаяВетка;
				КонецЕсли;
				ПодстрокаПодстроки = РодительскаяВетка.Строки.Добавить();
				ПодстрокаПодстроки.КодСтроки    = СокрЛП(Макет.Область(Ном, 3).Текст);
				ПодстрокаПодстроки.Наименование = СокрЛП(Макет.Область(Ном, 5).Текст);
				ПодстрокаПодстроки.Группа = 2;
				
				ТекСтрока = ПодстрокаПодстроки;
				АктуальнаяВетка = ПодстрокаПодстроки;
			ИначеЕсли НЕ СокрЛП(Макет.Область(Ном, 4).Текст) = "" Тогда
				Если ПодстрокаПодстроки <> Неопределено Тогда
					// в пределах стандартной иерархии
					Если СокрЛП(Макет.Область(Ном, 2).Текст) = "#" Тогда
						РодительскаяВетка = НоваяСтрока;
					ИначеЕсли СокрЛП(Макет.Область(Ном, 3).Текст) = "#" Тогда
						РодительскаяВетка = Подстрока;
					Иначе
						РодительскаяВетка = ПодстрокаПодстроки;
					КонецЕсли;
				Иначе
					//родитель не определен. Включаем в последнюю актуальную группу
					Если СокрЛП(Макет.Область(Ном, 2).Текст) = "#" Тогда
						РодительскаяВетка = НоваяСтрока;
					ИначеЕсли СокрЛП(Макет.Область(Ном, 3).Текст) = "#" Тогда
						РодительскаяВетка = Подстрока;
					Иначе
						РодительскаяВетка = АктуальнаяВетка;
					КонецЕсли;
				КонецЕсли;
				ПодстрокаПодстрокиСтроки = РодительскаяВетка.Строки.Добавить();
				ПодстрокаПодстрокиСтроки.КодСтроки    = СокрЛП(Макет.Область(Ном, 4).Текст);
				ПодстрокаПодстрокиСтроки.КодПодстроки = СокрЛП(Макет.Область(Ном, 4).Текст);
				ПодстрокаПодстрокиСтроки.Наименование = СокрЛП(Макет.Область(Ном, 5).Текст);
				ПодстрокаПодстрокиСтроки.Группа = 3;
				ТекСтрока = ПодстрокаПодстрокиСтроки;
				Группировать = Истина;
			
			КонецЕсли;
			КоличествоГрупп = 3;
		
		Иначе 
			Строка = Дерево.Строки.Добавить();
			Строка.КодСтроки    = СокрЛП(Макет.Область(Ном, 1).Текст);
			Строка.Наименование = СокрЛП(Макет.Область(Ном, 2).Текст);
			ТекСтрока = Строка;
			
		КонецЕсли;
		
		Если ТекСтрока <> Неопределено И ТаблицаТНВЭДПереченьИзъятий.Найти(ТекСтрока.КодСтроки, "Код") <> Неопределено Тогда
			ТекСтрока.ВходитВПереченьИзъятия = НСтр("ru ='Товар входит в перечень изъятий'");
		Иначе
			ТекСтрока.ВходитВПереченьИзъятия = "";
		КонецЕсли;
	КонецЦикла;
	
	Группировать = Истина;
	
	ЗначениеВРеквизитФормы(Дерево, "Таблица");
	
	//инициализируемся на строке, если было уже выбрано значение из классификатора
	Если ТекущийКодСтроки <> Неопределено И ТекущийКодСтроки <> "" Тогда
		ТекущийКодСтроки = ?(Прав(СокрЛП(ТекущийКодСтроки),1) = ".", Лев(ТекущийКодСтроки, СтрДлина(СокрЛП(ТекущийКодСтроки)) -1), СокрЛП(ТекущийКодСтроки));
		ИмяСекции = "Область"+Лев(ТекущийКодСтроки,2);
		ДоЗаписьТаблицыТНВЭД(ИмяСекции, Дерево, ТаблицаТНВЭДПереченьИзъятий);
		
		МассивНайденныхСтрок = Новый Массив;
		НайтиСтрокиВДанныхФормыДерево(Таблица.ПолучитьЭлементы(), "КодСтроки", ТекущийКодСтроки, МассивНайденныхСтрок);
		Если МассивНайденныхСтрок.Количество() <> 0 Тогда
			Элементы.Таблица.ТекущаяСтрока = МассивНайденныхСтрок[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
	ОценкаПроизводительности.ЗакончитьЗамерВремени("Форма выбора из классификатора (заполнение таблицы ""коды тнвэд"")", ВремяНачалаЗамера);	
	
КонецПроцедуры

&НаСервере
Процедура ДоЗаписьТаблицыТНВЭД(ИмяСекции, Дерево, ТаблицаТНВЭДПереченьИзъятий = Неопределено)
	
	Если Дерево = Неопределено Тогда
		Дерево = РеквизитФормыВЗначение("Таблица");
	КонецЕсли;
	
	Макет = МакетТНВЭД;
	ТекстШапки = Макет.ПолучитьОбласть("Шапка|Наименование").ТекущаяОбласть.Текст;
	Элементы.ДекорацияНадписьЗаголовка.Заголовок = СокрЛП(ТекстШапки);
	Если Макет.Области.Найти(ИмяСекции) = Неопределено Тогда
		Возврат;
	Иначе
		Область = Макет.Области[ИмяСекции];
	КонецЕсли;
	
	Если ТаблицаТНВЭДПереченьИзъятий = Неопределено Тогда
		
		ТаблицаТНВЭДПереченьИзъятий = Новый ТаблицаЗначений;
		ТаблицаТНВЭДПереченьИзъятий.Колонки.Добавить("Код", Новый ОписаниеТипов("Строка"));
		
		МассивКодов = СписокТНВЭДПереченьИзъятий.ВыгрузитьЗначения();
		Для Н = 1 По МассивКодов.Количество() Цикл
	    	ТаблицаТНВЭДПереченьИзъятий.Добавить();
		КонецЦикла; 
		
		ТаблицаТНВЭДПереченьИзъятий.ЗагрузитьКолонку(МассивКодов, "Код");
		ТаблицаТНВЭДПереченьИзъятий.Индексы.Добавить("Код");
		
	КонецЕсли;
	
	АктуальнаяВетка = Неопределено;
	ТекСтрока = Неопределено;
	Для Ном = Область.Верх По Область.Низ Цикл
		Если НЕ СокрЛП(Макет.Область(Ном, 5).Текст) = "" Тогда 
			Если НЕ СокрЛП(Макет.Область(Ном, 1).Текст) = "" Тогда
				НоваяСтрока = Дерево.Строки.Найти(СокрЛП(Макет.Область(Ном, 1).Текст),"КодСтроки");
				Если НоваяСтрока = Неопределено Тогда
					// в макете нет такой родительской области
					Возврат
				КонецЕсли;
				
				Если НоваяСтрока.Загружен Тогда 
					АктуальнаяВетка = НоваяСтрока;
					Возврат
				КонецЕсли;
				
				НоваяСтрока.Загружен = Истина;
				АктуальнаяВетка = НоваяСтрока;
				// Обнуляем последующие
				Подстрока = Неопределено;
				ПодстрокаПодстроки = Неопределено;
				ТекСтрока = НоваяСтрока;
			ИначеЕсли НЕ СокрЛП(Макет.Область(Ном, 2).Текст) = "" И НЕ СокрЛП(Макет.Область(Ном, 2).Текст) = "#" Тогда 
				Если НоваяСтрока <> Неопределено Тогда
					// в пределах стандартной иерархии
					РодительскаяВетка = НоваяСтрока;
				Иначе
					//родитель не определен. Включаем в последнюю актуальную группу
					РодительскаяВетка = АктуальнаяВетка;
				КонецЕсли;
				Подстрока = РодительскаяВетка.Строки.Добавить();
				Подстрока.КодСтроки    = СокрЛП(Макет.Область(Ном, 2).Текст);
				Подстрока.Наименование = СокрЛП(Макет.Область(Ном, 5).Текст);
				Подстрока.Группа = 1;
				
				АктуальнаяВетка = Подстрока;
				// Обнуляем последующие
				ПодстрокаПодстроки = Неопределено;
				ТекСтрока = Подстрока;
			ИначеЕсли НЕ СокрЛП(Макет.Область(Ном, 3).Текст) = "" И НЕ СокрЛП(Макет.Область(Ном, 3).Текст) = "#" Тогда 
				Если Подстрока <> Неопределено Тогда
					// в пределах стандартной иерархии
					РодительскаяВетка = Подстрока;
				Иначе
					//родитель не определен. Включаем в последнюю актуальную группу
					РодительскаяВетка = АктуальнаяВетка;
				КонецЕсли;
				ПодстрокаПодстроки = РодительскаяВетка.Строки.Добавить();
				ПодстрокаПодстроки.КодСтроки    = СокрЛП(Макет.Область(Ном, 3).Текст);
				ПодстрокаПодстроки.Наименование = СокрЛП(Макет.Область(Ном, 5).Текст);
				ПодстрокаПодстроки.Группа = 2;
				
				АктуальнаяВетка = ПодстрокаПодстроки;
				ТекСтрока = ПодстрокаПодстроки;
				
			ИначеЕсли НЕ СокрЛП(Макет.Область(Ном, 4).Текст) = "" Тогда 
				Если ПодстрокаПодстроки <> Неопределено Тогда
					// в пределах стандартной иерархии
					Если СокрЛП(Макет.Область(Ном, 2).Текст) = "#" Тогда
						РодительскаяВетка = НоваяСтрока;
					ИначеЕсли СокрЛП(Макет.Область(Ном, 3).Текст) = "#" Тогда
						РодительскаяВетка = Подстрока;
					Иначе
						РодительскаяВетка = ПодстрокаПодстроки;
					КонецЕсли;
				Иначе
					//родитель не определен. Включаем в последнюю актуальную группу
					Если СокрЛП(Макет.Область(Ном, 2).Текст) = "#" Тогда
						РодительскаяВетка = НоваяСтрока;
					ИначеЕсли СокрЛП(Макет.Область(Ном, 3).Текст) = "#" Тогда
						РодительскаяВетка = Подстрока;
					Иначе
						РодительскаяВетка = АктуальнаяВетка;
					КонецЕсли;
				КонецЕсли;
				ПодстрокаПодстрокиСтроки = РодительскаяВетка.Строки.Добавить();
				ПодстрокаПодстрокиСтроки.КодСтроки    = СокрЛП(Макет.Область(Ном, 4).Текст);
				ПодстрокаПодстрокиСтроки.Наименование = СокрЛП(Макет.Область(Ном, 5).Текст);
				ПодстрокаПодстрокиСтроки.Группа = 3;	
				
				ТекСтрока = ПодстрокаПодстрокиСтроки;

				Группировать = Истина;
			КонецЕсли;
			КоличествоГрупп = 3;
			
		Иначе 
			Строка = Дерево.Строки.Добавить();
			Строка.КодСтроки    = СокрЛП(Макет.Область(Ном, 1).Текст);
			Строка.Наименование = СокрЛП(Макет.Область(Ном, 2).Текст);
			ТекСтрока = Строка;
		КонецЕсли;
		
		Если ТекСтрока <> Неопределено И ТаблицаТНВЭДПереченьИзъятий.Найти(ТекСтрока.КодСтроки, "Код") <> Неопределено Тогда
			ТекСтрока.ВходитВПереченьИзъятия = НСтр("ru ='Товар входит в перечень изъятий'");
		Иначе
			ТекСтрока.ВходитВПереченьИзъятия = "";
		КонецЕсли;
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево,"Таблица");
	
КонецПроцедуры

