﻿
////////////////////////////////////////////////////////////////////////////////
// ОбработкаНеисправностейБЭДКлиент: механизм обработки неисправностей.
//
// Общий принцип использования подсистемы:
// 1. Инициализация контекста в начале выполнения операции - 
//    см. ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики,
//    ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики.
// 2. Передача контекста по стеку вызовов через параметры методов.
// 3. При возникновении ошибки, добавление ее в контекст - см. ОбработкаНеисправностейБЭДКлиент.ДобавитьОшибку,
//    ОбработкаНеисправностейБЭД.ДобавитьОшибку.
// 4. Обработка коллекции накопленных ошибок после выполнения операции - 
//    см. ОбработкаНеисправностейБЭДКлиент.ОбработатьОшибки.
//    Пример: "ОшибкаИнтернетСоединения" или ИмяМодуля.ВидОшибкиОшибкаИнтернетСоединения() - возвращает строковый
//    идентификатор вида ошибки.
// 5. Обработка собственных видов ошибок происходит в переопределяемой части процедуры
//    ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки,
//    см. пример в области ВидыОшибок общего модуля ОбработкаНеисправностейБЭДКлиентСервер.
//
// Пример:
// КонтекстДиагностики = ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики();
// HTTPСоединение = Новый HTTPСоединение("1c-edo.ru");
// HTTPЗапрос = Новый HTTPЗапрос;
// Попытка
//       Ответ = HTTPСоединение.Получить(HTTPЗапрос);
// Исключение
//       Ошибка = ОбработкаНеисправностейБЭДКлиент.НоваяОшибка(НСтр("ru = 'Получение маркера'"),
//          ОбменСКонтрагентамиСлужебныйКлиентСервер.ВидОшибкиИнтернетСоединение(),
//          ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
//          НСтр("ru = 'Произошла ошибка при подключении'"));
//       ОбработкаНеисправностейБЭДКлиент.ДобавитьОшибку(КонтекстДиагностики, Ошибка);
// КонецПопытки;
// ПараметрыОбработкиОшибок = ОбработкаНеисправностейБЭДКлиент.НовыеПараметрыОбработкиОшибок();
// ПараметрыОбработкиОшибок.ОбработчикПовторенияДействия = Новый ОписаниеОповещения("ПолучениеМаркера", ЭтотОбъект);
// ОбработкаНеисправностейБЭДКлиент.ОбработатьОшибки(КонтекстДиагностики, ПараметрыОбработкиОшибок);
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область РегистрацияОшибок

// Создает структуру, содержащую данные для диагностики.
// Используется в процедурах:
// ОбработкаНеисправностейБЭД.ДобавитьОшибку,
// ОбработкаНеисправностейБЭДКлиент.ДобавитьОшибку,
// ОбработкаНеисправностейБЭДКлиент.ОбработатьОшибки.
// В структуру нельзя помещать мутабельные объекты, т.к. она может передаваться между клиентом и сервером.
// 
// Возвращаемое значение:
//   Структура:
//      * ЗаголовокОперации           - Строка - заголовок, который будет выведен в форму мастера диагностики и в форму
//                                               вывода ошибок.
//      * Диагностика                 - Структура:
//         ** Ошибки                   - Массив из см. ОбработкаНеисправностейБЭДКлиент.НоваяОшибка - ошибки,
//                                               возникшие в процессе выполнения операции.
//      * ДополнительныеСвойства      - Структура - коллекция дополнительных свойств.
Функция НовыйКонтекстДиагностики() Экспорт
	
	Контекст = ОбработкаНеисправностейБЭДКлиентСервер.НовыйКонтекстДиагностики();
	Контекст.Вставить("ДатаНачалаОперации", ОбщегоНазначенияКлиент.ДатаСеанса());
	
	ОбработкаНеисправностейБЭДСобытияКлиент.ПриИнициализацииКонтекстаДиагностики(Контекст);
		
	Возврат Контекст;
	
КонецФункции

// Инициализирует структуру, содержащую информацию об ошибке. Используется в 
// ОбработкаНеисправностейБЭД.ДобавитьОшибку,
// ОбработкаНеисправностейБЭДКлиент.ДобавитьОшибку.
//
// Параметры:
//  ВидОперации                  - Строка - наименование операции, во время выполнения которой возникла ошибка
//  ВидОшибки                    - см. ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки
//  ПодробноеПредставлениеОшибки - Строка - подробное представление ошибки
//  КраткоеПредставлениеОшибки   - Строка - краткое представление ошибки
//  ДополнительныеПараметры      - Структура:
//     * Сертификат              - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - сертификат,
//                                 по которому произошла ошибка.
//     * Подсистема              - Строка - см._ОбщегоНазначенияБЭД.ПодсистемыБЭД
//     * СсылкаНаОбъект          - ЛюбаяСсылка - объект, по которому возникла ошибка.
//     * ДополнительныеДанные    - Произвольный - произвольные данные.
// 
// Возвращаемое значение:
//  Структура: 
//    * ВидОперации                  - Строка - наименование операции, во время выполнения которой возникла ошибка
//    * ВидОшибки                    - см. ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки
//    * ПодробноеПредставлениеОшибки - Строка - подробное представление ошибки
//    * КраткоеПредставлениеОшибки   - Строка - краткое представление ошибки
//    * Сертификат              - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - сертификат,
//                                 по которому произошла ошибка.
//    * Подсистема              - Строка - см._ОбщегоНазначенияБЭД.ПодсистемыБЭД
//    * СсылкаНаОбъект          - ЛюбаяСсылка - объект, по которому возникла ошибка.
//    * ДополнительныеДанные    - Произвольный - произвольные данные.
Функция НоваяОшибка(ВидОперации, ВидОшибки, ПодробноеПредставлениеОшибки, КраткоеПредставлениеОшибки,
	ДополнительныеПараметры = Неопределено) Экспорт
	
	Ошибка = ОбработкаНеисправностейБЭДКлиентСервер.НоваяОшибка(ВидОперации, ВидОшибки, ПодробноеПредставлениеОшибки,
		КраткоеПредставлениеОшибки, ДополнительныеПараметры);
	
	ОбработкаНеисправностейБЭДСобытияКлиент.ПриИнициализацииОшибки(Ошибка);
	
	Возврат Ошибка;
	
КонецФункции

// Добавляет ошибку в контекст выполняемой операции.
//
// Параметры:
//  КонтекстДиагностики          - см. НовыйКонтекстДиагностики
//  Ошибка                       - см. ОбработкаНеисправностейБЭДКлиент.НоваяОшибка
//  Подсистема                   - Строка - см. ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД
//  ЗаписыватьВЖурналРегистрации - Булево - признак записи информации об ошибке в журнал регистрации
//
// Пример:
//  КонтекстДиагностики = ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики();
//  Ошибка = ОбработкаНеисправностейБЭДКлиент.НоваяОшибка(НСтр("ru = 'Распаковка архива'"),
//  	ОбменСКонтрагентамиСлужебныйКлиентСервер.ВидОшибкиРаботаСФайлами(),
//  	ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
//  	НСтр("ru = 'Произошла ошибка при распаковке архива'"));
//  ОбработкаНеисправностейБЭДКлиент.ДобавитьОшибку(КонтекстДиагностики, Ошибка).
Процедура ДобавитьОшибку(КонтекстДиагностики, Ошибка, Подсистема, ЗаписыватьВЖурналРегистрации = Истина) Экспорт
	
	Если Не ЗначениеЗаполнено(КонтекстДиагностики) Тогда
		СообщатьОбОшибке = Истина;
		КонтекстДиагностики = НовыйКонтекстДиагностики();
	Иначе 
		СообщатьОбОшибке = Ложь;
	КонецЕсли;
	
	ДанныеОшибки = ОбработкаНеисправностейБЭДКлиентСервер.ДобавитьОшибку(КонтекстДиагностики, Ошибка,
		ЗаписыватьВЖурналРегистрации, Подсистема, СообщатьОбОшибке);
		
	КонтекстДиагностики.ДатаОкончанияОперации = ОбщегоНазначенияКлиент.ДатаСеанса();
	
	ОбработкаНеисправностейБЭДСобытияКлиент.ПриДобавленииОшибки(КонтекстДиагностики, Ошибка);
	
	Если ДанныеОшибки.СообщениеДляПользователя <> "" Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ДанныеОшибки.СообщениеДляПользователя);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму вывода ошибок или отображает ошибку в текущей форме в зависимости от свойства
// КонтекстныйРежимОбработки параметра ПараметрыОбработкиОшибок.
// Вызывается после завершения операции.
//
// Параметры:
//  КонтекстДиагностики   - см. НовыйКонтекстДиагностики
//  ПараметрыОбработкиОшибок     - см. НовыеПараметрыОбработкиОшибок
Процедура ОбработатьОшибки(КонтекстДиагностики, ПараметрыОбработкиОшибок = Неопределено) Экспорт
	
	Если КонтекстДиагностики = Неопределено Или КонтекстДиагностики.ОшибкиОбработаны Тогда
		Возврат;
	КонецЕсли;
	
	Ошибки = ОбработкаНеисправностейБЭДКлиентСервер.ПолучитьОшибки(КонтекстДиагностики);
	ВидыОшибок = ОбработкаНеисправностейБЭДКлиентСервер.ЗначенияСвойствОшибок(Ошибки, "ВидОшибки");
	Если ВидыОшибок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыОбработкиОшибок = Неопределено Тогда
		ПараметрыОбработкиОшибок = НовыеПараметрыОбработкиОшибок();
	КонецЕсли;
	
	Если ПараметрыОбработкиОшибок.КонтекстныйРежимОбработки Тогда
		ПараметрыОбработкиОшибок.НадписьПредупреждение.Заголовок = ПараметрыОбработкиОшибок.ТекстПредупреждения;
		Если ПараметрыОбработкиОшибок.ГруппаПредупреждения <> Неопределено Тогда
			ПараметрыОбработкиОшибок.ГруппаПредупреждения.Видимость = Истина;
		КонецЕсли;
	Иначе 
		КонтекстДиагностики.ОшибкиОбработаны = Истина;
		ОткрытьФормуВыводаОшибок(КонтекстДиагностики, ПараметрыОбработкиОшибок);
	КонецЕсли;
	
КонецПроцедуры

// Формирует структуру, описывающую параметры обработки ошибок для использования в см. ОбработатьОшибки.
// 
// Возвращаемое значение:
//  Структура:
//     * КонтекстныйРежимОбработки - Булево - Истина указывается в случае вывода подсказок в форму, в которой
//                                            произошла ошибка.
//                                            Ложь - обработка будет происходить вне формы (откроется мастер
//                                            диагностики или форма вывода ошибок).
//     * ОбработчикПовторенияДействия - ОписаниеОповещения - действие, которое будет выполнено при нажатии
//                                      кнопки "Повторить действие".
//     * ОбработчикЗакрытия - ОписаниеОповещения - действие, которое будет выполнено после закрытия мастера
//                            диагностики.
Функция НовыеПараметрыОбработкиОшибок() Экспорт
	
	ПараметрыОбработки = Новый Структура;
	ПараметрыОбработки.Вставить("КонтекстныйРежимОбработки", Ложь);
	ПараметрыОбработки.Вставить("ОбработчикПовторенияДействия", Неопределено);
	ПараметрыОбработки.Вставить("ОбработчикЗакрытия", Неопределено);
	ПараметрыОбработки.Вставить("ПараметрыФормы", Новый Структура);
	ПараметрыОбработки.Вставить("ГруппаПредупреждения", Неопределено);
	ПараметрыОбработки.Вставить("НадписьПредупреждение", Неопределено);
	ПараметрыОбработки.Вставить("ТекстПредупреждения", Неопределено);
	ПараметрыОбработки.Вставить("Ошибки", Новый Массив);
	ПараметрыОбработки.Вставить("Отбор", Новый Структура());
	ПараметрыОбработки.Вставить("ФормаВладелец", Неопределено);
	
	Возврат ПараметрыОбработки;
	
КонецФункции

// Выводит краткое представление ошибок пользователю.
// 
// Параметры:
// 	КонтекстДиагностики - см. НовыйКонтекстДиагностики
Процедура СообщитьОшибкиПользователю(КонтекстДиагностики) Экспорт
	
	Для каждого Ошибка Из ОбработкаНеисправностейБЭДКлиентСервер.ПолучитьОшибки(КонтекстДиагностики) Цикл
		ОбщегоНазначенияКлиент.СообщитьПользователю(Ошибка.КраткоеПредставлениеОшибки);
	КонецЦикла;
	
КонецПроцедуры

// Параметры:
//  Приемник - см. НовыйКонтекстДиагностики
//  Источник - см. НовыйКонтекстДиагностики
Процедура ДополнитьКонтекстДиагностики(Приемник, Источник) Экспорт
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Приемник.Диагностика.Ошибки, Источник.Диагностика.Ошибки);
	
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(Приемник.ДополнительныеСвойства,
		Источник.ДополнительныеСвойства, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ИсправлениеОшибок
	
// Возвращает структуру, описывающую принцип исправления ошибок, см. ИсправитьОшибки.
// 
// Возвращаемое значение:
// 	Структура:
// * ОбработчикСобытияВыбор - см. НовоеОписаниеКомандыФормыИсправленияОшибок
// * ДополнительныеПараметрыОбработчиков - Произвольный - значение, которое будет передано в обработчик команды.
// * СкрытьКнопкуПросмотреть - Булево - кнопка "Просмотреть" будет скрыта в форме исправления ошибок
// * МножественныйВыбор - Булево - разрешает выделять несколько строк в форме исправления ошибок
// * Команды - Массив из см. НовоеОписаниеКомандыФормыИсправленияОшибок - команды, которые будут отображены в форме
//                                                                        исправления ошибок.
// * Заголовок - Строка - заголовок формы исправления ошибок
Функция НовыеПараметрыИсправленияОшибок() Экспорт
	
	ПараметрыИсправленияОшибок = Новый Структура;
	ПараметрыИсправленияОшибок.Вставить("Заголовок",                           "");
	ПараметрыИсправленияОшибок.Вставить("Команды",                             Новый Массив);
	ПараметрыИсправленияОшибок.Вставить("МножественныйВыбор",                  Ложь);
	ПараметрыИсправленияОшибок.Вставить("СкрытьКнопкуПросмотреть",             Ложь);
	ПараметрыИсправленияОшибок.Вставить("ДополнительныеПараметрыОбработчиков", Неопределено);
	ПараметрыИсправленияОшибок.Вставить("ОбработчикСобытияВыбор",              Неопределено);
	
	Возврат ПараметрыИсправленияОшибок;
	
КонецФункции

// Возвращает описание команды формы исправления ошибок, которая будет выполнена при
// вызове события Выбор поля, содержащего данные.
// 
// Возвращаемое значение:
// 	Структура:
// * Подсказка - Строка - подсказка кнопки, связанной с командой
// * Обработчик - Строка - клиентская процедура, которая будет выполнена при выполнении команды
//                         в формате "ИмяМодуля.ИмяФункции".
// * Заголовок - Строка - текст кнопки, связанной с командой
Функция НовоеОписаниеКомандыФормыИсправленияОшибок() Экспорт
	
	Команда = Новый Структура;
	Команда.Вставить("Заголовок", "");
	Команда.Вставить("Обработчик", "");
	Команда.Вставить("Подсказка", "");
	
	Возврат Команда;
	
КонецФункции

// Открывает форму исправления ошибок, если параметр Данные содержит больше одного элемента или выполняет обработчик
// исправления ошибки, если параметр Данные содержит один элемент и параметр ПараметрыИсправленияОшибок содержит
// только одну команду.
// 
// Параметры:
// 	Данные - Массив из Произвольный - данные, связанные с ошибками, которые необходимо исправить
// 	ПараметрыИсправленияОшибок - см. НовыеПараметрыИсправленияОшибок
// 	ПараметрыПредставленияДанных - Структура:
//    * ОбработчикПолученияПредставлений - Строка - функция, возвращающая представление данных
Процедура ИсправитьОшибки(Данные, ПараметрыИсправленияОшибок, ПараметрыПредставленияДанных = Неопределено) Экспорт
	
	Если ПараметрыПредставленияДанных = Неопределено Тогда
		ПараметрыПредставленияДанных = Новый Структура;
		ПараметрыПредставленияДанных.Вставить("ОбработчикПолученияПредставлений", Неопределено);
	КонецЕсли;
	
	Команды = ПараметрыИсправленияОшибок.Команды;
	Если Данные.Количество() = 1
		И Команды.Количество() = 1 Тогда
		ВыполнитьОбработчикИсправленияОшибки(Команды[0].Обработчик,
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Данные[0]),
			ПараметрыИсправленияОшибок.ДополнительныеПараметрыОбработчиков);
	Иначе
		Параметры = Новый Структура;
		Параметры.Вставить("Данные", Данные);
		Параметры.Вставить("ПараметрыИсправленияОшибок", ПараметрыИсправленияОшибок);
		Параметры.Вставить("ПараметрыПредставленияДанных", ПараметрыПредставленияДанных);
		
		ОткрытьФорму("Обработка.ОбработкаНеисправностейБЭД.Форма.ИсправлениеОшибок", Параметры); 
	КонецЕсли;
	
КонецПроцедуры

// Возвращает ошибки, которые были исправлены в результате выполнения обработчика исправления ошибки.
// 
// Параметры:
// 	РезультатПроцедуры - Массив из Произвольный - данные, которые были обработаны в результате исправления 
// 	ошибок (выполнения обработчика исправления ошибки).
// 	СоответствиеОшибокДанным - Соответствие из КлючИЗначение:
// 	* Ключ - Произвольный - данные, связанные с ошибкой
//  * Значение - Массив из см. НоваяОшибка
// Возвращаемое значение:
// 	Массив
Функция ПолучитьИсправленныеОшибки(РезультатПроцедуры, СоответствиеОшибокДанным) Экспорт
	
	ИсправленныеОшибки = Новый Массив;
	Для каждого КлючИЗначение Из СоответствиеОшибокДанным Цикл
		Если РезультатПроцедуры.Найти(КлючИЗначение.Ключ) <> Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ИсправленныеОшибки, КлючИЗначение.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ИсправленныеОшибки;

КонецФункции

// Открывает элемент из формы исправления ошибок.
// 
// Параметры:
// 	ЭлементТаблицы - Произвольный
// 	ДополнительныеПараметры - Произвольный - см. ключ ДополнительныеПараметрыОбработчиков структуры, возвращаемой методом
//                                           см. НовыеПараметрыИсправленияОшибок
Процедура ОткрытьЭлементТаблицы(ЭлементТаблицы, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(ЭлементТаблицы) = Тип("Массив") Тогда
		Для каждого СтрокаРезультата Из ЭлементТаблицы Цикл
			ПоказатьЗначение(, СтрокаРезультата);
			Прервать;
		КонецЦикла;
	Иначе 
		ПоказатьЗначение(, ЭлементТаблицы);
	КонецЕсли;
	
КонецПроцедуры

// Оповещает форму вывода ошибок об устранении ошибок.
// Необходимо вызывать в обработчиках нажатия на гиперссылку формы ошибок для обновления текста решения для ошибки.
//  См. ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки.ОбработчикиНажатия.
//
// Параметры:
//  ИсправленныеОшибки - Массив из см. ОбработкаНеисправностейБЭДКлиент.НоваяОшибка
//                     - Массив из см. ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки - содержит виды 
//                                     ошибок, которые были исправлены.
//                     - Структура из КлючИЗначение:
//                         * Ключ - Строка - имя свойства.
//                         * Значение - Строка - значение свойства.
//                     - Соответствие из КлючИЗначение:
//                         * Ключ - Строка - имя свойства (может содержать обращение через точку, пример: "ДополнительныеДанные.ВидЭД").
//                         * Значение - Строка - значение свойства.
//
Процедура ОповеститьОбИсправленииОшибок(ИсправленныеОшибки) Экспорт
	
	Оповестить(ИмяСобытияИсправлениеОшибок(), ИсправленныеОшибки);
	
КонецПроцедуры

// Возвращает имя события, возникающее при исправлении вида ошибки.
// 
// Возвращаемое значение:
//  Строка
Функция ИмяСобытияИсправлениеВидаОшибки() Экспорт
	
	Возврат "ОбработкаНеисправностейБЭД.ВыполненоИсправлениеВидаОшибки";
	
КонецФункции

#КонецОбласти

#Область Прочее

// Выводит сообщение о нарушении прав доступа.
Процедура СообщитьПользователюОНарушенииПравДоступа() Экспорт
	
	ТекстСообщения = ОбработкаНеисправностейБЭДКлиентСервер.ТекстСообщенияОНарушенииПравДоступа();
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

// Заполняет данные о способах получения технической поддержки по электронному документообороту.
// 
// Параметры:
// 	ТелефонСлужбыПоддержки - Строка
// 	АдресЭлектроннойПочтыСлужбыПоддержки - Строка
Процедура ЗаполнитьДанныеСлужбыПоддержки(ТелефонСлужбыПоддержки, АдресЭлектроннойПочтыСлужбыПоддержки) Экспорт

	// Контактные данные ЗАО "Калуга Астрал"
	ТелефонСлужбыПоддержки = "8-800-333-9313";
	АдресЭлектроннойПочтыСлужбыПоддержки = "edo@1c.ru";

КонецПроцедуры

// Формирует форматированную строку со ссылкой для обращения в службу технической поддержки
// по электронному документообороту.
// 
// Параметры:
// 	Представление - Строка - представление сформированной ссылки
// Возвращаемое значение:
// 	ФорматированнаяСтрока - ссылка для обращения в службу технической поддержки.
Функция СформироватьГиперссылкуДляОбращенияВСлужбуПоддержки(Представление = "") Экспорт
	
	Если Представление = "" Тогда
		Представление = НСтр("ru = 'Техподдержка'");
	КонецЕсли;
	
	ШаблонСтроки = "<a style=""font: ЖирныйШрифтБЭД"" href=""http://1c-edo.ru/handbook"">%1</a>";
	
	Возврат СтроковыеФункцииКлиент.ФорматированнаяСтрока(ШаблонСтроки, Представление);
	
КонецФункции

// Открывает интернет-страницу с описанием сервиса 1С-Коннект.
// 
Процедура ОткрытьСтраницуСервиса1СКоннект() Экспорт
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("https://1c-connect.com/ru/forcustomers/");
	
КонецПроцедуры

// Открывает ссылку на страницу 1С-ЭДО с привязкой к разделу техподдержки.
// 
Процедура ОткрытьСтраницуТехническойПоддержки() Экспорт
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("https://portal.1c.ru/applications/30#support");
	
КонецПроцедуры

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// ЭлектронноеВзаимодействие.БазоваяФункциональность.ОбработкаНеисправностей

// Открывает мастер диагностики.
// 
// Параметры:
// 	КонтекстДиагностики - см. НовыйКонтекстДиагностики
// 	ПараметрыОбработкиОшибок - см. НовыеПараметрыОбработкиОшибок
Процедура ОткрытьМастерДиагностики(КонтекстДиагностики, ПараметрыОбработкиОшибок) Экспорт
	
	// ОбменСКонтрагентами начало 
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами.Диагностика") Тогда
		МодульДиагностикаЭДОКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ДиагностикаЭДОКлиент");
		МодульДиагностикаЭДОКлиент.ОткрытьМастерДиагностики(КонтекстДиагностики, ПараметрыОбработкиОшибок);
	КонецЕсли;
	// ОбменСКонтрагентами конец
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.БазоваяФункциональность.ОбработкаНеисправностей

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиФормыОшибок

Процедура ОткрытьЖурналРегистрации(КонтекстДиагностики, ДополнительныеПараметры) Экспорт
	
	Отбор = ОбработкаНеисправностейБЭДКлиентСервер.ОтборЖурналаРегистрации(КонтекстДиагностики);
	ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации(Отбор);
	
КонецПроцедуры

Процедура ОткрытьФормуОбращенияВТехПоддержку(КонтекстДиагностики, ДополнительныеПараметры) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("КонтекстДиагностики", КонтекстДиагностики);
	НачатьПолучениеИнформацииДляТехПоддержки(Контекст);
	
КонецПроцедуры

Процедура ОткрытьФормуДетализацииОшибок(КонтекстДиагностики, ДополнительныеПараметры) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КонтекстДиагностики", КонтекстДиагностики);
	
	ОткрытьФорму("Обработка.ОбработкаНеисправностейБЭД.Форма.ДетализацияОшибок", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ИнформацияДляТехподдержки

Процедура НачатьПолучениеИнформацииДляТехПоддержки(Контекст)
	
	ТехническаяИнформация = Новый Структура;
	ОповещениеОЗавершении = Новый ОписаниеОповещения("НачатьПолучениеИнформацииДляТехПоддержкиЗавершение",
		ЭтотОбъект, Контекст);
	ОбработкаНеисправностейБЭДСобытияКлиент.ПередФормированиемФайлаДляТехподдержки(ТехническаяИнформация,
		ОповещениеОЗавершении);
	
КонецПроцедуры

Процедура НачатьПолучениеИнформацииДляТехПоддержкиЗавершение(ТехническаяИнформация, Контекст) Экспорт
	
	ДлительнаяОперация = ОбработкаНеисправностейБЭДВызовСервера.НачатьПолучениеФайлаДляТехПоддержки(
		Контекст.КонтекстДиагностики, ТехническаяИнформация);
	
	Оповещение = Новый ОписаниеОповещения("ПослеПолученияФайлаДляТехПоддержки", ЭтотОбъект, Контекст);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
	ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Выполняется формирование файла с технической информацией'");
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Оповещение, ПараметрыОжидания);
	
КонецПроцедуры

Процедура ПослеПолученияФайлаДляТехПоддержки(Результат, Контекст) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Ошибка при получении файла для тех.поддержки:'")
			+ Результат.КраткоеПредставлениеОшибки);
	Иначе 
		АдресФайлаДляТехПоддержки = Результат.АдресРезультата;
		
		ПараметрыОбращения  = Новый Структура;
		ПараметрыОбращения.Вставить("ТекстОбращения", "");
		ПараметрыОбращения.Вставить("ТелефонСлужбыПоддержки", "");
		ПараметрыОбращения.Вставить("АдресЭлектроннойПочтыСлужбыПоддержки", "");
		ОбработкаНеисправностейБЭДСобытияКлиент.ПриОпределенииПараметровОбращенияВТехподдержку(ПараметрыОбращения,
			Контекст.КонтекстДиагностики);
		
		ДанныеДляТехПоддержки = Новый Структура;
		ДанныеДляТехПоддержки.Вставить("АдресФайлаДляТехПоддержки", АдресФайлаДляТехПоддержки);
		ДанныеДляТехПоддержки.Вставить("ТелефонСлужбыПоддержки", ПараметрыОбращения.ТелефонСлужбыПоддержки);
		ДанныеДляТехПоддержки.Вставить("АдресЭлектроннойПочтыСлужбыПоддержки",
			ПараметрыОбращения.АдресЭлектроннойПочтыСлужбыПоддержки);
		ДанныеДляТехПоддержки.Вставить("ТекстОбращения", ПараметрыОбращения.ТекстОбращения);
		
		СтандартнаяОбработка = Истина;
		ЭлектронноеВзаимодействиеКлиентПереопределяемый.ОткрытьФормуОбращенияВТехПоддержку(ДанныеДляТехПоддержки,
			СтандартнаяОбработка);
		
		Если Не СтандартнаяОбработка Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("КонтекстДиагностики", Контекст.КонтекстДиагностики);
		Если ЗначениеЗаполнено(ПараметрыОбращения.ТекстОбращения) Тогда
			ПараметрыФормы.Вставить("ТекстОбращения", ПараметрыОбращения.ТекстОбращения);
		КонецЕсли;
		
		ПараметрыФормы.Вставить("АдресФайлаДляТехПоддержки", АдресФайлаДляТехПоддержки);
		ОткрытьФорму("Обработка.ОбработкаНеисправностейБЭД.Форма.ОбращениеВТехподдержку", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее 

Процедура ОткрытьФормуВыводаОшибок(КонтекстДиагностики, ПараметрыОбработкиОшибок) 
	
	ВыполнятьОбработчикАвтоматически = Ложь;
	Обработчик = "";
	ВидОшибки = "";
	Ошибки = ОбработкаНеисправностейБЭДКлиентСервер.ПолучитьОшибки(КонтекстДиагностики);
	ИдентификаторыВидовОшибок = ОбработкаНеисправностейБЭДКлиентСервер.ЗначенияСвойствОшибок(Ошибки, "ВидОшибки");
	Если ИдентификаторыВидовОшибок.Количество() = 1 Тогда
		Ошибки = ОбработкаНеисправностейБЭДКлиентСервер.ПолучитьОшибки(КонтекстДиагностики);
		ВидОшибки = Ошибки[0].ВидОшибки;
		Если ВидОшибки.ВыполнятьОбработчикАвтоматически Тогда
			ВыполнятьОбработчикАвтоматически = Истина;
			Обработчик = ВидОшибки.АвтоматическиВыполняемыйОбработчик;
			Если Не ЗначениеЗаполнено(Обработчик) Тогда
				ВыполнятьОбработчикАвтоматически = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ВыполнятьОбработчикАвтоматически Тогда
		ВыполнитьОбработчикВидаОшибки(ВидОшибки, Обработчик, КонтекстДиагностики, ПараметрыОбработкиОшибок);
	Иначе
		ОценкаПроизводительностиКлиент.ЗамерВремени(
			"ОбщийМодуль.ОбработкаНеисправностейБЭДКлиент.ОткрытьФормуВыводаОшибок");
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("КонтекстДиагностики", КонтекстДиагностики);
		ПараметрыФормы.Вставить("ВозможенПовторДействия",
			ПараметрыОбработкиОшибок.ОбработчикПовторенияДействия <> Неопределено);
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ФормаВыводаОшибокЗакрытие", ЭтотОбъект,
			ПараметрыОбработкиОшибок);
		
		ОткрытьФорму("Обработка.ОбработкаНеисправностейБЭД.Форма.Ошибки",
			ПараметрыФормы, ПараметрыОбработкиОшибок.ФормаВладелец,,,, ОповещениеОЗакрытии,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

Процедура ФормаВыводаОшибокЗакрытие(РезультатЗакрытия, ПараметрыОбработкиОшибок) Экспорт
	
	Если РезультатЗакрытия = ДействиеПовторитьДействие() Тогда
		ВыполнитьОбработкуОповещения(ПараметрыОбработкиОшибок.ОбработчикПовторенияДействия);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьОбработчикВидаОшибки(ВидОшибки, Обработчик, КонтекстДиагностики,
	ДополнительныеПараметрыОбработчика = Неопределено) Экспорт
	
	Если Обработчик <> Неопределено Тогда
		ОшибкиОдногоВида = Новый Массив;
		Для каждого Ошибка Из ОбработкаНеисправностейБЭДКлиентСервер.ПолучитьОшибки(КонтекстДиагностики) Цикл
			Если ОбработкаНеисправностейБЭДКлиентСервер.ЭтоОшибкаДанногоВида(Ошибка, ВидОшибки) Тогда
				ОшибкиОдногоВида.Добавить(Ошибка);
			КонецЕсли;
		КонецЦикла;
	
		ЧастиИмениПроцедуры = СтрРазделить(Обработчик, ".");
		ИмяМодуля = ЧастиИмениПроцедуры[0];
		ИмяПроцедуры = ЧастиИмениПроцедуры[1];
		Оповещение = Новый ОписаниеОповещения(ИмяПроцедуры, ОбщегоНазначенияКлиент.ОбщийМодуль(ИмяМодуля),
			ДополнительныеПараметрыОбработчика);
		КонтекстДиагностикиКопия = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(КонтекстДиагностики);
		КонтекстДиагностикиКопия.Диагностика.Ошибки = ОшибкиОдногоВида;
		ВыполнитьОбработкуОповещения(Оповещение, КонтекстДиагностикиКопия);
	КонецЕсли;
	
КонецПроцедуры

Функция ДействиеПовторитьДействие() Экспорт
	
	Возврат "ПовторитьДействие";
	
КонецФункции

Функция ИмяСобытияИсправлениеОшибок() Экспорт
	
	Возврат "ОбработкаНеисправностейБЭД.ВыполненоИсправлениеОшибок";
	
КонецФункции 

Процедура УдалитьОшибки(КонтекстДиагностики, Отбор) Экспорт
	
	Ошибки = ОбработкаНеисправностейБЭДКлиентСервер.ПолучитьОшибки(КонтекстДиагностики);
	Для Сч = - (Ошибки.Количество() - 1) По 0 Цикл
		Если ОбработкаНеисправностейБЭДКлиентСервер.ОшибкаСоответствуетОтбору(
			КонтекстДиагностики.Диагностика.Ошибки[- Сч], Отбор) Тогда
			КонтекстДиагностики.Диагностика.Ошибки.Удалить(- Сч);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ВыполнитьОбработчикИсправленияОшибки(Обработчик, ОбрабатываемыеДанные, ДополнительныеПараметры) Экспорт
	
	ЧастиОбработчика = СтрРазделить(Обработчик, ".");
	Оповещение = Новый ОписаниеОповещения(ЧастиОбработчика[1],
		ОбщегоНазначенияКлиент.ОбщийМодуль(ЧастиОбработчика[0]), ДополнительныеПараметры);
	
	ВыполнитьОбработкуОповещения(Оповещение, ОбрабатываемыеДанные);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

