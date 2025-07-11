﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Идентификатор", Идентификатор);
	Параметры.Свойство("ДрайверОборудования", ДрайверОборудования);
	
	Заголовок = НСтр("ru='Оборудование:'") + Символы.НПП  + Строка(Идентификатор);
	
	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;

	СписокПорт = Элементы.Порт.СписокВыбора;
	Для Номер = 1 По 64 Цикл
		СписокПорт.Добавить(Номер, СтрШаблон(НСтр("ru = 'COM%1'"), Формат(Номер, "ЧЦ=2; ЧДЦ=0; ЧН=0; ЧГ=0")));
	КонецЦикла;
	
	СписокСкорость = Элементы.Скорость.СписокВыбора;
	СписокСкорость.Добавить(9600,   НСтр("ru = '9600 бод'"));
	
	времПорт                       = Неопределено;
	времСкорость                   = Неопределено;
	времТаймаут                    = Неопределено;
	времПарольККМ                  = Неопределено;
	времНомерСекции                = Неопределено;
	времКодСимволаЧастичногоОтреза = Неопределено;
	времМодель                     = Неопределено;
	
	Параметры.ПараметрыОборудования.Свойство("Порт"                      , времПорт);
	Параметры.ПараметрыОборудования.Свойство("Скорость"                  , времСкорость);
	Параметры.ПараметрыОборудования.Свойство("Таймаут"                   , времТаймаут);
	Параметры.ПараметрыОборудования.Свойство("ПарольККМ"                 , времПарольККМ);
	Параметры.ПараметрыОборудования.Свойство("НомерСекции"               , времНомерСекции);
	Параметры.ПараметрыОборудования.Свойство("КодСимволаЧастичногоОтреза", времКодСимволаЧастичногоОтреза);
	Параметры.ПараметрыОборудования.Свойство("Модель"                    , времМодель);
	
	Порт                       = ?(времПорт                       = Неопределено,        1, времПорт);
	Скорость                   = ?(времСкорость                   = Неопределено,     9600, времСкорость);
	Таймаут                    = ?(времТаймаут                    = Неопределено,      100, времТаймаут);
	ПарольККМ                  = ?(времПарольККМ                  = Неопределено, "000000", времПарольККМ);
	НомерСекции                = ?(времНомерСекции                = Неопределено,        0, времНомерСекции);
	КодСимволаЧастичногоОтреза = ?(времКодСимволаЧастичногоОтреза = Неопределено,       22, времКодСимволаЧастичногоОтреза);
	Модель                     = ?(времМодель                     = Неопределено, Элементы.Модель.СписокВыбора[0], времМодель);
	
	Элементы.ТестУстройства.Видимость = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто);
	Элементы.УстановитьДрайвер.Видимость = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьИнформациюОДрайвере();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	НовыеЗначениеПараметров = Новый Структура;
	НовыеЗначениеПараметров.Вставить("Порт"                       , Порт);
	НовыеЗначениеПараметров.Вставить("Скорость"                   , Скорость);
	НовыеЗначениеПараметров.Вставить("Таймаут"                    , Таймаут);
	НовыеЗначениеПараметров.Вставить("ПарольККМ"                  , ПарольККМ);
	НовыеЗначениеПараметров.Вставить("НомерСекции"                , НомерСекции);
	НовыеЗначениеПараметров.Вставить("КодСимволаЧастичногоОтреза" , КодСимволаЧастичногоОтреза);
	НовыеЗначениеПараметров.Вставить("Модель"                     , Модель);
	
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор", Идентификатор);
	Результат.Вставить("ПараметрыОборудования", НовыеЗначениеПараметров);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)
	
	ОчиститьСообщения();
	
	РезультатТеста    = Неопределено;
	
	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;
	
	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"                      , Порт);
	времПараметрыУстройства.Вставить("Скорость"                  , Скорость);
	времПараметрыУстройства.Вставить("Таймаут"                   , Таймаут);
	времПараметрыУстройства.Вставить("ПарольККМ"                 , ПарольККМ);
	времПараметрыУстройства.Вставить("НомерСекции"               , НомерСекции);
	времПараметрыУстройства.Вставить("КодСимволаЧастичногоОтреза", КодСимволаЧастичногоОтреза);
	времПараметрыУстройства.Вставить("Модель"                    , Модель);
	
	Результат = МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("CheckHealth",
	                                                                      ВходныеПараметры,
	                                                                      ВыходныеПараметры,
	                                                                      Идентификатор,
	                                                                      времПараметрыУстройства);

	ДополнительноеОписание = ?(ТипЗнч(ВыходныеПараметры) = Тип("Массив")
	                           И ВыходныеПараметры.Количество() >= 2,
	                           НСтр("ru = 'Дополнительное описание:'") + " " + ВыходныеПараметры[1],
	                           "");
	Если Результат Тогда
		ТекстСообщения = НСтр("ru = 'Тест успешно выполнен.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                  "",
		                                                                  Символы.ПС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                           "",
		                                                                           ДополнительноеОписание));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Иначе
		ТекстСообщения = НСтр("ru = 'Тест не пройден.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                  "",
		                                                                  Символы.ПС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                           "",
		                                                                           ДополнительноеОписание));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьДрайверИзАрхиваПриЗавершении(Результат) Экспорт 
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Установка драйвера завершена.'")); 
	ОбновитьИнформациюОДрайвере();
	
КонецПроцедуры 

&НаКлиенте
Процедура УстановитьДрайверИзДистрибутиваПриЗавершении(Результат, Параметры) Экспорт 
	
	Если Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Установка драйвера завершена.'")); 
		ОбновитьИнформациюОДрайвере();
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='При установке драйвера из дистрибутива произошла ошибка.'")); 
	КонецЕсли;

КонецПроцедуры 

&НаКлиенте
Процедура УстановитьДрайвер(Команда)
	
	ОчиститьСообщения();
	ОповещенияДрайверИзДистрибутиваПриЗавершении = Новый ОписаниеОповещения("УстановитьДрайверИзДистрибутиваПриЗавершении", ЭтотОбъект);
	ОповещенияДрайверИзАрхиваПриЗавершении = Новый ОписаниеОповещения("УстановитьДрайверИзАрхиваПриЗавершении", ЭтотОбъект);
	МенеджерОборудованияКлиент.УстановитьДрайвер(ДрайверОборудования, ОповещенияДрайверИзДистрибутиваПриЗавершении, ОповещенияДрайверИзАрхиваПриЗавершении);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере()

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"                      , Порт);
	времПараметрыУстройства.Вставить("Скорость"                  , Скорость);
	времПараметрыУстройства.Вставить("Таймаут"                   , Таймаут);
	времПараметрыУстройства.Вставить("ПарольККМ"                 , ПарольККМ);
	времПараметрыУстройства.Вставить("НомерСекции"               , НомерСекции);
	времПараметрыУстройства.Вставить("КодСимволаЧастичногоОтреза", КодСимволаЧастичногоОтреза);
	времПараметрыУстройства.Вставить("Модель"                    , Модель);

	Если МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("ПолучитьВерсиюДрайвера",
	                                                               ВходныеПараметры,
	                                                               ВыходныеПараметры,
	                                                               Идентификатор,
	                                                               времПараметрыУстройства) Тогда
		Драйвер = ВыходныеПараметры[0];
		Версия  = ВыходныеПараметры[1];
	Иначе
		Драйвер = ВыходныеПараметры[2];
		Версия  = НСтр("ru='Не определена'");
	КонецЕсли;

	Элементы.Драйвер.ЦветТекста = ?(Драйвер = НСтр("ru='Не установлен'"), ЦветОшибки, ЦветТекста);
	Элементы.Версия.ЦветТекста  = ?(Версия  = НСтр("ru='Не определена'"), ЦветОшибки, ЦветТекста);
	Элементы.УстановитьДрайвер.Доступность = Не (Драйвер = НСтр("ru='Установлен'"));

КонецПроцедуры

#КонецОбласти