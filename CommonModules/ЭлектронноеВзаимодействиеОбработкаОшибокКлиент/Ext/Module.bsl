﻿////////////////////////////////////////////////////////////////////////////////
// ЭлектронноеВзаимодействиеОбработкаОшибокКлиент: механизм диагностики обмена электронными документами.
//
// Общий принцип использования подсистемы:
// 1. Инициализация контекста в начале выполнения операции - см. ЭлектронноеВзаимодействиеСлужебныйКлиент.НовыйКонтекстОперации,
//    ЭлектронноеВзаимодействиеСлужебный.НовыйКонтекстОперации.
// 2. Передача контекста по стеку вызовов через параметры методов.
// 3. При возникновении ошибки, добавление ее в контекст - см. ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.ДобавитьОшибку,
//    ЭлектронноеВзаимодействиеОбработкаОшибок.ДобавитьОшибку.
// 4. Обработка коллекции накопленных ошибок после выполнения операции - см. ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.ОбработатьОшибки,
//    ЭлектронноеВзаимодействиеОбработкаОшибок.ОбработатьОшибки.
//    Пример: "ОшибкаИнтернетСоединения" или ИмяМодуля.ВидОшибкиОшибкаИнтернетСоединения() - возвращает строковый
//    идентификатор вида ошибки.
// 5. Обработка собственных видов ошибок происходит в переопределяемой части процедуры
//    ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.ПриОпределенииПараметровВидаОшибки,
//    см. пример в области ВидыОшибок общего модуля ЭлектронноеВзаимодействиеОбработкаОшибокКлиентСервер.
//
// Пример:
// КонтекстОперации = ЭлектронноеВзаимодействиеСлужебныйКлиент.НовыйКонтекстОперации();
// HTTPСоединение = Новый HTTPСоединение("1c-edo.ru");
// HTTPЗапрос = Новый HTTPЗапрос;
// Попытка
//       Ответ = HTTPСоединение.Получить(HTTPЗапрос);
// Исключение
//       Ошибка = ЭлектронноеВзаимодействиеОбработкаОшибокКлиентСервер.НоваяОшибка(НСтр("ru = 'Получение маркера'"),
//          ЭлектронноеВзаимодействиеОбработкаОшибокКлиентСервер.ВидОшибкиИнтернетСоединение(),
//          ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
//          НСтр("ru = 'Произошла ошибка при подключении'"));
//       ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.ДобавитьОшибку(КонтекстОперации, Ошибка);
// КонецПопытки;
// ПараметрыОбработкиОшибок = ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.НовыеПараметрыОбработкиОшибок();
// ПараметрыОбработкиОшибок.ОбработчикПовторенияДействия = Новый ОписаниеОповещения("ПолучениеМаркера", ЭтотОбъект);
// ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.ОбработатьОшибки(КонтекстОперации, ПараметрыОбработкиОшибок);
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Добавляет ошибку в контекст выполняемой операции.
//
// Параметры:
//  КонтекстОперации   - Структура - контекст операции, см. ЭлектронноеВзаимодействиеСлужебный.НовыйКонтекстОперации.
//  Ошибка                       - Структура - добавляемая ошибка, см. ЭлектронноеВзаимодействиеОбработкаОшибокКлиентСервер.НоваяОшибка.
//  ЗаписыватьВЖурналРегистрации - Булево - признак записи информации об ошибке в журнал регистрации.
//  КодСобытия                   - Строка - код события журнала регистрации.
//
// Пример:
//  КонтекстОперации = ЭлектронноеВзаимодействиеСлужебныйКлиент.НовыйКонтекстОперации();
//  Ошибка = ЭлектронноеВзаимодействиеОбработкаОшибокКлиентСервер.НоваяОшибка(НСтр("ru = 'Распаковка архива'"),
//  	ЭлектронноеВзаимодействиеОбработкаОшибокКлиентСервер.ВидОшибкиРаботаСФайлами(),
//  	ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
//  	НСтр("ru = 'Произошла ошибка при распаковке архива'"));
//  ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.ДобавитьОшибку(КонтекстОперации, Ошибка);
//
Процедура ДобавитьОшибку(КонтекстОперации, Ошибка, ЗаписыватьВЖурналРегистрации = Истина, КодСобытия = "ОбменСКонтрагентами") Экспорт
	
	Если Не ЗначениеЗаполнено(КонтекстОперации) Тогда
		СообщатьОбОшибке = Истина;
		КонтекстОперации = ЭлектронноеВзаимодействиеСлужебныйКлиент.НовыйКонтекстОперации();
	Иначе 
		СообщатьОбОшибке = Ложь;
	КонецЕсли;
	
	ДанныеОшибки = ЭлектронноеВзаимодействиеОбработкаОшибокКлиентСервер.ДобавитьОшибку(КонтекстОперации, Ошибка,
		ЗаписыватьВЖурналРегистрации, КодСобытия, СообщатьОбОшибке);
		
	КонтекстОперации.ДатаОкончанияОперации = ОбщегоНазначенияКлиент.ДатаСеанса();
	
	Если ДанныеОшибки.СообщениеДляПользователя <> "" Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ДанныеОшибки.СообщениеДляПользователя);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму вывода ошибок или отображает ошибку в текущей форме в зависимости от свойства
// КонтекстныйРежимОбработки параметра ПараметрыОбработкиОшибок.
// Вызывается после завершения операции.
//
// Параметры:
//  КонтекстОперации   - Структура - контекст операции, см. ЭлектронноеВзаимодействиеСлужебный.НовыйКонтекстОперации.
//  ПараметрыОбработкиОшибок     - Структура - см. ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.НовыеПараметрыОбработкиОшибок.
//
Процедура ОбработатьОшибки(КонтекстОперации, ПараметрыОбработкиОшибок = Неопределено) Экспорт
	
	Если КонтекстОперации = Неопределено Или КонтекстОперации.ОшибкиОбработаны Тогда
		Возврат;
	КонецЕсли;
	
	Ошибки = КонтекстОперации.Диагностика.Ошибки;
	
	ВидыОшибок = ЭлектронноеВзаимодействиеОбработкаОшибокКлиентСервер.ЗначенияСвойствОшибок(Ошибки, "ВидОшибки");
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
		КонтекстОперации.ОшибкиОбработаны = Истина;
		ОткрытьФормуВыводаОшибок(КонтекстОперации, ПараметрыОбработкиОшибок);
	КонецЕсли;
	
КонецПроцедуры

// Формирует структуру, описывающую параметры обработки ошибок для использования в ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.ОбработатьОшибки.
// 
// Возвращаемое значение:
//  Структура - со свойствами:
//     * КонтекстныйРежимОбработки - Булево - Истина указывается в случае вывода подсказок в форму, в которой
//                                            произошла ошибка.
//                                            Ложь - обработка будет происходить вне формы (откроется мастер
//                                            диагностики или форма вывода ошибок).
//     * ОбработчикПовторенияДействия - ОписаниеОповещения - действие, которое будет выполнено при нажатии
//                                      кнопки "Повторить действие".
//     * ОбработчикЗакрытия - ОписаниеОповещения - действие, которое будет выполнено после закрытия мастера
//                            диагностики.
//
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

// Оповещает форму вывода ошибок об устранении ошибок.
// Необходимо вызывать в обработчиках нажатия на гиперссылку формы ошибок для обновления текста решения для ошибки.
// См. свойство ОбработчикиНажатия функции ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.НовыеПараметрыВидаОшибки.
//
// Параметры:
//  ИсправленныеОшибки - Массив из ЭлектронноеВзаимодействиеОбработкаОшибокКлиентСервер.НоваяОшибка - содержит ошибки,
//                                которые были исправлены.
//                     - Массив из Строка - содержит виды ошибок, которые были исправлены.
//                     - Структура - отбор, где Ключ - имя свойства, Значение - значение свойства.
//                     - Соответствие - отбор, где Ключ - имя свойства (может содержать обращение через точку,
//                                     пример: "ДополнительныеДанные.ВидЭД"), Значение - значение свойства.
//
Процедура ОповеститьОбИсправленииОшибок(ИсправленныеОшибки) Экспорт
	
	Оповестить(ИмяСобытияИсправлениеОшибок(), ИсправленныеОшибки);
	
КонецПроцедуры

// Возвращает параметры вида ошибки.
//
// Параметры:
//  ВидОшибки - Строка - см. область ВидыОшибок общего модуля ЭлектронноеВзаимодействиеОбработкаОшибокКлиентСервер.
// 
// Возвращаемое значение:
// Структура - см. ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.НовыеПараметрыВидаОшибки.
//
Функция ПараметрыВидаОшибки(ВидОшибки) Экспорт
	
	ПараметрыВидаОшибки = НовыеПараметрыВидаОшибки();
	
	ПараметрыВидаОшибки.ОбработчикиНажатия.Вставить("список ошибок", ОбработчикОткрытияФормыДетализацииОшибок());
	
	ЭлектронноеВзаимодействиеСлужебныйКлиент.ПриОпределенииПараметровВидаОшибки(ВидОшибки, ПараметрыВидаОшибки);
	
	Если ПараметрыВидаОшибки.ЗаголовокПроблемы = "" Тогда
		
		ПараметрыВидаОшибки.ЗаголовокПроблемы = НСтр("ru = 'Неизвестная ошибка'");
		ОписаниеРешения = СтроковыеФункцииКлиент.ФорматированнаяСтрока(
			НСтр("ru = '<a href = ""Обратитесь"">Обратитесь</a> в тех. поддержку'"));
		ПараметрыВидаОшибки.ОписаниеРешения = ОписаниеРешения;
		ПараметрыВидаОшибки.ОбработчикиНажатия.Вставить("Обратитесь", ОбработчикОткрытияФормыОбращенияВТехподдержку());
		
	КонецЕсли;
	
	Возврат ПараметрыВидаОшибки;
	
КонецФункции

// Возвращает описание процедуры, выполняющей открытие формы обращения в техподдержку.
// Для использования в ЭлектронноеВзаимодействиеСлужебныйКлиент.ПриОпределенииПараметровВидаОшибки.
// 
// Возвращаемое значение:
// Строка - описание обработчика в формате ИмяОбщегоМодуля.ИмяПроцедуры.
//
Функция ОбработчикОткрытияФормыОбращенияВТехподдержку() Экспорт
	
	Возврат "ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.ОткрытьФормуОбращенияВТехПоддержку";
	
КонецФункции

Процедура СообщитьОшибкиПользователю(КонтекстОперации) Экспорт
	
	Для каждого Ошибка Из КонтекстОперации.Диагностика.Ошибки Цикл
		ОбщегоНазначенияКлиент.СообщитьПользователю(Ошибка.КраткоеПредставлениеОшибки);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиФормыОшибок

Процедура ОткрытьЖурналРегистрации(КонтекстОперации, ДополнительныеПараметры) Экспорт
	
	Отбор = ЭлектронноеВзаимодействиеОбработкаОшибокКлиентСервер.ОтборЖурналаРегистрации(КонтекстОперации);
	ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации(Отбор);
	
КонецПроцедуры

Процедура ОткрытьФормуОбращенияВТехПоддержку(КонтекстОперации, ДополнительныеПараметры) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("КонтекстОперации", КонтекстОперации);
	НачатьПолучениеИнформацииДляТехПоддержки(Контекст);
	
КонецПроцедуры

Процедура ОткрытьФормуДетализацииОшибок(КонтекстОперации, ДополнительныеПараметры) Экспорт
	

	
КонецПроцедуры

#КонецОбласти

#Область ИнформацияДляТехподдержки

Процедура НачатьПолучениеИнформацииДляТехПоддержки(Контекст)
	
	ТехническаяИнформация = Новый Структура;
	ОповещениеОЗавершении = Новый ОписаниеОповещения("НачатьПолучениеИнформацииДляТехПоддержкиЗавершение", ЭтотОбъект, Контекст);
	ЭлектронноеВзаимодействиеСлужебныйКлиент.ПередФормированиемФайлаДляТехподдержки(ТехническаяИнформация, ОповещениеОЗавершении);
	
КонецПроцедуры

Процедура НачатьПолучениеИнформацииДляТехПоддержкиЗавершение(ТехническаяИнформация, Контекст) Экспорт
	
	ДлительнаяОперация = ЭлектронноеВзаимодействиеОбработкаОшибокВызовСервера.НачатьПолучениеФайлаДляТехПоддержки(Контекст.КонтекстОперации, ТехническаяИнформация);
	
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
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Ошибка при получении файла для тех.поддержки:'") + Результат.КраткоеПредставлениеОшибки);
	Иначе 
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее 

// Инициализирует параметры вида ошибки.
// 
// Возвращаемое значение:
//  Структура - с ключами:
//    * ЗаголовокПроблемы - Строка - краткая суть проблемы, выводится крупным шрифтом.
//    * ОписаниеПроблемы - Строка - детальное описание проблемы.
//    * ОписаниеРешения - Строка - описание решения проблемы, может содержать гиперссылки,
//                           при нажатии на которые выполняются обработчики, заданные в параметре ОбработчикиНажатия.
//    * ВыводитьСсылкуНаСписокОшибок - Булево - если истина - в форму вывода ошибок под описанием проблемы будет
//                           добавлена гиперссылка, при нажатии на которую откроется форма со списком ошибок
//                           по текущему виду ошибки.
//    * ОбработчикиНажатия - Соответствие - где:
//        ** Ключ - Строка - фраза, которая будет выделена как гиперссылка.
//        ** Значение - Строка - содержит описание клиентской процедуры в формате ИмяОбщегоМодуля.ИмяПроцедуры,
//                           которая будет вызвана при нажатии на гиперссылку.
//           Процедура будет вызвана со следующими параметрами:
//             * КонтекстОперации - Структура - см. ЭлектронноеВзаимодействиеСлужебный.НовыйКонтекстОперации.
//             * ДополнительныеПараметры - Произвольный - значение, которое было указано при создании описания процедуры.
//    * ВыполнятьОбработчикАвтоматически - Булево - если значение параметра - Истина и в коллекции накопленных
//                           ошибок находятся ошибки только одного вида, будет выполнен обработчик, указанный в параметре
//                           АвтоматическиВыполняемыйОбработчик без открытия формы вывода ошибок.
//    * АвтоматическиВыполняемыйОбработчик - Строка - обработчик, который будет выполнен при значении параметра
//                            ВыполнятьОбработчикПриЕдинственномВидеОшибок - Истина.
//    * Статус - Строка - статус вида ошибки, см. область "СтатусыОшибок" модуля ЭлектронноеВзаимодействиеОбработкаОшибокКлиентСервер.
//                        Определяет картинку вида ошибки в форме вывода ошибок.
//
Функция НовыеПараметрыВидаОшибки()
	
	Параметры = Новый Структура;
	Параметры.Вставить("ЗаголовокПроблемы", "");
	Параметры.Вставить("ОписаниеПроблемы", "");
	Параметры.Вставить("ОписаниеРешения", "");
	Параметры.Вставить("ВыводитьСсылкуНаСписокОшибок", Истина);
	Параметры.Вставить("ОбработчикиНажатия", Новый Соответствие);
	Параметры.Вставить("ПараметрыОбработчиков", Новый Соответствие);
	Параметры.Вставить("ВыполнятьОбработчикАвтоматически", Ложь);
	Параметры.Вставить("АвтоматическиВыполняемыйОбработчик", "");
	Параметры.Вставить("Статус", ЭлектронноеВзаимодействиеОбработкаОшибокКлиентСервер.СтатусОшибкиВажная());
	
	Возврат Параметры;
	
КонецФункции

// Возвращает описание процедуры, выполняющей открытие формы детализации ошибок.
// 
// Возвращаемое значение:
// Строка - описание обработчика в формате ИмяОбщегоМодуля.ИмяПроцедуры.
//
Функция ОбработчикОткрытияФормыДетализацииОшибок()
	
	Возврат "ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.ОткрытьФормуДетализацииОшибок";
	
КонецФункции

Процедура ОткрытьФормуВыводаОшибок(КонтекстОперации, ПараметрыОбработкиОшибок) 
	
	ВыполнятьОбработчикАвтоматически = Ложь;
	Обработчик = "";
	ВидОшибки = "";
	ВидыОшибок = ЭлектронноеВзаимодействиеОбработкаОшибокКлиентСервер.ЗначенияСвойствОшибок(КонтекстОперации.Диагностика.Ошибки, "ВидОшибки");
	Если ВидыОшибок.Количество() = 1 Тогда
		ВидОшибки = ВидыОшибок[0];
		ПараметрыВидаОшибки = ПараметрыВидаОшибки(ВидОшибки);
		Если ПараметрыВидаОшибки.ВыполнятьОбработчикАвтоматически Тогда
			ВыполнятьОбработчикАвтоматически = Истина;
			Обработчик = ПараметрыВидаОшибки.АвтоматическиВыполняемыйОбработчик;
			Если Не ЗначениеЗаполнено(Обработчик) Тогда
				ВыполнятьОбработчикАвтоматически = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ВыполнятьОбработчикАвтоматически Тогда
		ВыполнитьОбработчикВидаОшибки(ВидОшибки, Обработчик, КонтекстОперации, ПараметрыОбработкиОшибок);
	Иначе
		//ОценкаПроизводительностиКлиент.ЗамерВремени(
		//	"ОбщийМодуль.ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.ОткрытьФормуВыводаОшибок");
		//
		//ПараметрыФормы = Новый Структура;
		//ПараметрыФормы.Вставить("КонтекстОперации", КонтекстОперации);
		//ПараметрыФормы.Вставить("ВозможенПовторДействия", ПараметрыОбработкиОшибок.ОбработчикПовторенияДействия <> Неопределено);
		//ОповещениеОЗакрытии = Новый ОписаниеОповещения("ФормаВыводаОшибокЗакрытие", ЭтотОбъект, ПараметрыОбработкиОшибок);
		//
		//ПараметрыВидовОшибок = Новый Соответствие;
		//Для каждого ВидОшибки Из ВидыОшибок Цикл
		//	ПараметрыВидовОшибок.Вставить(ВидОшибки, ПараметрыВидаОшибки(ВидОшибки));
		//КонецЦикла;
		//ПараметрыФормы.Вставить("ПараметрыВидовОшибок", ПараметрыВидовОшибок);
		
		//ОткрытьФорму("Обработка.ЭлектронноеВзаимодействие.Форма.Ошибки",
		//	ПараметрыФормы, ПараметрыОбработкиОшибок.ФормаВладелец,,,, ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

Процедура ФормаВыводаОшибокЗакрытие(РезультатЗакрытия, ПараметрыОбработкиОшибок) Экспорт
	
	Если РезультатЗакрытия = ДействиеПовторитьДействие() Тогда
		ВыполнитьОбработкуОповещения(ПараметрыОбработкиОшибок.ОбработчикПовторенияДействия);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьОбработчикВидаОшибки(ВидОшибки, Обработчик, КонтекстОперации,
	ДополнительныеПараметрыОбработчика = Неопределено) Экспорт
	
	Если Обработчик <> Неопределено Тогда
		ОшибкиОдногоВида = Новый Массив;
		Для каждого Ошибка Из КонтекстОперации.Диагностика.Ошибки Цикл
			Если Ошибка.ВидОшибки = ВидОшибки Тогда
				ОшибкиОдногоВида.Добавить(Ошибка);
			КонецЕсли;
		КонецЦикла;
	
		ЧастиИмениПроцедуры = СтрРазделить(Обработчик, ".");
		ИмяМодуля = ЧастиИмениПроцедуры[0];
		ИмяПроцедуры = ЧастиИмениПроцедуры[1];
		Оповещение = Новый ОписаниеОповещения(ИмяПроцедуры, ОбщегоНазначенияКлиент.ОбщийМодуль(ИмяМодуля),
			ДополнительныеПараметрыОбработчика);
		КонтекстОперацииКопия = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(КонтекстОперации);
		КонтекстОперацииКопия.Диагностика.Ошибки = ОшибкиОдногоВида;
		ВыполнитьОбработкуОповещения(Оповещение, КонтекстОперацииКопия);
	КонецЕсли;
	
КонецПроцедуры

Функция ДействиеПовторитьДействие() Экспорт
	
	Возврат "ПовторитьДействие";
	
КонецФункции

Функция ИмяСобытияИсправлениеОшибок() Экспорт
	
	Возврат "ЭлектронноеВзаимодействиеОбработкаОшибок.ВыполненоИсправлениеОшибок";
	
КонецФункции 

Процедура УдалитьОшибки(КонтекстОперации, Отбор) Экспорт
	
	Для Сч = - (КонтекстОперации.Диагностика.Ошибки.Количество() - 1) По 0 Цикл
		Если ЭлектронноеВзаимодействиеОбработкаОшибокКлиентСервер.ОшибкаСоответствуетОтбору(
			КонтекстОперации.Диагностика.Ошибки[- Сч], Отбор) Тогда
			КонтекстОперации.Диагностика.Ошибки.Удалить(- Сч);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

