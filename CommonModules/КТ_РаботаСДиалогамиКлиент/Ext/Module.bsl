﻿////////////////////////////////////////////////////////////////////////////////
// Функции для обработки действий пользователя в процессе редактирования
// многострочного текста, например комментария в документах.

// Открывает форму редактирования произвольного многострочного текста.
//
// Параметры:
//  ОповещениеОЗакрытии     - ОписаниеОповещения - содержит описание процедуры, которая будет вызвана 
//                            после закрытия формы ввода текста с теми же параметрами, что и для метода
//                            ПоказатьВводСтроки.
//  МногострочныйТекст      - Строка - произвольный текст, который необходимо отредактировать;
//  Заголовок               - Строка - текст, который необходимо отобразить в заголовке формы.
//
// Пример:
//
//   Оповещение = Новый ОписаниеОповещения("КомментарийЗавершениеВвода", ЭтотОбъект);
//   ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(Оповещение, Элемент.ТекстРедактирования);
//
//   &НаКлиенте
//   Процедура КомментарийЗавершениеВвода(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
//      Если ВведенныйТекст = Неопределено Тогда
//		   Возврат;
//   	КонецЕсли;	
//	
//	   Объект.МногострочныйКомментарий = ВведенныйТекст;
//	   Модифицированность = Истина;
//   КонецПроцедуры
//
Процедура ПоказатьФормуРедактированияМногострочногоТекста(Знач ОповещениеОЗакрытии, 
	Знач МногострочныйТекст, Знач Заголовок = Неопределено) Экспорт
	
	Если Заголовок = Неопределено Тогда
		ПоказатьВводСтроки(ОповещениеОЗакрытии, МногострочныйТекст,,, Истина);
	Иначе
		ПоказатьВводСтроки(ОповещениеОЗакрытии, МногострочныйТекст, Заголовок,, Истина);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму редактирования многострочного комментария.
//
// Параметры:
//  МногострочныйТекст      - Строка - произвольный текст, который необходимо отредактировать.
//  ФормаВладелец 			- УправляемаяФорма - форма, в поле которой выполняется ввод комментария.
//  ИмяРеквизита            - Строка - имя реквизита формы, в который будет помещен введенный пользователем
//                                     комментарий.
//  Заголовок               - Строка - текст, который необходимо отобразить в заголовке формы.
//                                     По умолчанию: "Комментарий".
//
// Пример использования:
//
//	 ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
//
Процедура ПоказатьФормуРедактированияКомментария(Знач МногострочныйТекст, Знач ФормаВладелец, Знач ИмяРеквизита, 
	Знач Заголовок = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура("ФормаВладелец,ИмяРеквизита", ФормаВладелец, ИмяРеквизита);
	Оповещение = Новый ОписаниеОповещения("КомментарийЗавершениеВвода", ЭтотОбъект, ДополнительныеПараметры);
	ЗаголовокФормы = ?(Заголовок <> Неопределено, Заголовок, НСтр("ru='Комментарий'"));
	ПоказатьФормуРедактированияМногострочногоТекста(Оповещение, МногострочныйТекст, ЗаголовокФормы);
	
КонецПроцедуры

Процедура КомментарийЗавершениеВвода(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
	
	Если ВведенныйТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	РеквизитФормы = ДополнительныеПараметры.ФормаВладелец;
	
	//ПутьКРеквизитуФормы = стр(ДополнительныеПараметры.ИмяРеквизита, ".");
	//// Если реквизит вида "Объект.Комментарий" и т.п.
	//Если ПутьКРеквизитуФормы.Количество() > 1 Тогда
	//	Для Индекс = 0 По ПутьКРеквизитуФормы.Количество() - 2 Цикл 
	//		РеквизитФормы = РеквизитФормы[ПутьКРеквизитуФормы[Индекс]];
	//	КонецЦикла;
	//КонецЕсли;	
	
	//РеквизитФормы[ПутьКРеквизитуФормы[ПутьКРеквизитуФормы.Количество() - 1]] = ВведенныйТекст;
	РеквизитФормы.Объект[ДополнительныеПараметры.ИмяРеквизита] = ВведенныйТекст;
	ДополнительныеПараметры.ФормаВладелец.Модифицированность = Истина;
	
КонецПроцедуры

// Открывает форму редактирования многострочного произвольного текста.
//
// Параметры:
//  МногострочныйТекст      - Строка - произвольный текст, который необходимо отредактировать.
//  ФормаВладелец 			- УправляемаяФорма - форма, в поле которой выполняется ввод текста.
//  ИмяРеквизита            - Строка - имя реквизита формы, в который будет помещен введенный пользователем
//                                     текст.
//  Заголовок               - Строка - текст, который необходимо отобразить в заголовке формы.
//                                     По умолчанию: "Комментарий".
//
// Пример использования:
//
//	 ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
//
Функция ПоказатьФормуРедактированияПроизвольногоТекста(МногострочныйТекст, Заголовок = "Введите текст") Экспорт
	
	Если ВвестиСтроку(МногострочныйТекст, Заголовок,, Истина) Тогда
		Возврат МногострочныйТекст;
	КонецЕсли;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ВВОДА ДАТЫ КАК МЕСЯЦА

// Функция преобразовывает дату в представление периода
//
// Параметры:
//   ПериодРегистрации - Дата периода
//
// Возвращаемое значение:
//  Строка
//
Функция ПолучитьПредставлениеПериодаРегистрации(ПериодРегистрации) Экспорт

	Возврат Формат(ПериодРегистрации, "ДФ='MMMM yyyy'");

КонецФункции

// Процедура обрабатывает событие регулирования в поле периода регистрации
//
Процедура РегулированиеПредставленияПериодаРегистрации(Направление, СтандартнаяОбработка, ПериодРегистрации, ПредставлениеПериодаРегистрации) Экспорт

	СтандартнаяОбработка = Ложь;
	
	Если Направление = 1 Тогда
		ПериодРегистрации = КонецМесяца(ПериодРегистрации) + 1;
	ИначеЕсли Направление = -1 Тогда
		ПериодРегистрации = НачалоМесяца(ПериодРегистрации - 1);
	КонецЕсли;

	ПредставлениеПериодаРегистрации = ПолучитьПредставлениеПериодаРегистрации(ПериодРегистрации);

КонецПроцедуры

// Процедура обрабатывает событие начала выбора из списка в поле периода регистрации
// Процедура исполняется только на клиенте
// СтандартнаяОбработка не устанавливается в значение Ложь, иначе появляется поле данных выбора со значением """" не найдено"
//
Процедура НачалоВыбораИзСпискаПредставленияПериодаРегистрации(Элемент, ПериодРегистрации, ЭтаФорма, НачальноеЗначение = Неопределено, ОбрабатыватьВыборИзСписаНаФорме = Ложь) Экспорт

	Если НачальноеЗначение = Неопределено Тогда
		НачальноеЗначение = ПериодРегистрации;
	КонецЕсли; 
	
	СписокВыбора = Новый СписокЗначений;
	НачалоТекущегоГода = НачалоГода(НачальноеЗначение);
	НачалоПрошлогоГода = НачалоГода(НачалоТекущегоГода - 1);
	СписокВыбора.Добавить(НачалоПрошлогоГода, (Формат(НачалоПрошлогоГода, "ДФ='yyyy'") + "..."));
	НачалоМесяцаЗаполнения = НачалоТекущегоГода;
	Для а = 1 По 12 Цикл
		ДобавленныйЭлемент = СписокВыбора.Добавить(НачалоМесяцаЗаполнения, КТ_РаботаСДиалогами.ДатаКакМесяцПредставление(НачалоМесяцаЗаполнения));
		НачалоМесяцаЗаполнения = ДобавитьМесяц(НачалоМесяцаЗаполнения, 1);
	КонецЦикла;
	НачалоСледующегоГода = КонецГода(НачалоТекущегоГода) + 1;
	СписокВыбора.Добавить(НачалоСледующегоГода, (Формат(НачалоСледующегоГода, "ДФ='yyyy'") + "..."));
	
	ДопПараметры = Новый Структура("Элемент, ПериодРегистрации, ЭтаФорма", Элемент, ПериодРегистрации, ЭтаФорма);
	
	ЭтаФорма.ПоказатьВыборИзСписка(Новый ОписаниеОповещения("ВыполнитьПослеВыбораИзСпискаПредставленияПериодаРегистрации", ?(ОбрабатыватьВыборИзСписаНаФорме, ЭтаФорма, КТ_РаботаСДиалогамиКлиент), ДопПараметры), СписокВыбора, Элемент, СписокВыбора.НайтиПоЗначению(ПериодРегистрации));
	
КонецПроцедуры

Процедура ВыполнитьПослеВыбораИзСпискаПредставленияПериодаРегистрации(ВыбранныйЭлемент, ДопПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	ИначеЕсли Год(ВыбранныйЭлемент.Значение) <> Год(ДопПараметры.ПериодРегистрации) Тогда
		НачалоВыбораИзСпискаПредставленияПериодаРегистрации(ДопПараметры.Элемент, ВыбранныйЭлемент.Значение, ДопПараметры.ЭтаФорма, ВыбранныйЭлемент.Значение);
		Возврат;
	КонецЕсли;
	
	ДопПараметры.ЭтаФорма.Объект.Период_с = ВыбранныйЭлемент.Значение; 
	ДопПараметры.ЭтаФорма.ПериодПредставление   = КТ_РаботаСДиалогами.ДатаКакМесяцПредставление(ВыбранныйЭлемент.Значение);
	ДопПараметры.ЭтаФорма.Модифицированность = Истина;

	//////////////////////////////////////////////////////////////////////////////
	// Оповещение об изменении периода необходимо
	// для выполнения дополнительных действий в форме источнике.
	
	ПараметрыОповещения = Новый Структура;	
	Если ДопПараметры.Свойство("ЭтаФорма") Тогда
		ПараметрыОповещения.Вставить("Форма", ДопПараметры.ЭтаФорма); 	
	КонецЕсли;
	Оповестить("ИзмененПериод", ПараметрыОповещения);
	
КонецПроцедуры

// Процедура обрабатывает событие начала выбора из списка в поле периода регистрации
// Процедура исполняется только на клиенте
//
Функция ПолучитьСпискаПредставленияПериодаРегистрации(ПериодРегистрации, СтандартнаяОбработка) Экспорт

	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора = Новый СписокЗначений;
	НачалоТекущегоГода = НачалоГода(ПериодРегистрации);
	НачалоПрошлогоГода = НачалоГода(НачалоТекущегоГода - 1);
	ДанныеВыбора.Добавить(НачалоПрошлогоГода, (Формат(НачалоПрошлогоГода, "ДФ='yyyy'") + "..."));
	НачалоМесяцаЗаполнения = НачалоТекущегоГода;
	Для а = 1 По 12 Цикл
		ДобавленныйЭлемент = ДанныеВыбора.Добавить(НачалоМесяцаЗаполнения, КТ_РаботаСДиалогами.ДатаКакМесяцПредставление(НачалоМесяцаЗаполнения));
		НачалоМесяцаЗаполнения = ДобавитьМесяц(НачалоМесяцаЗаполнения, 1);
	КонецЦикла;
	НачалоСледующегоГода = КонецГода(НачалоТекущегоГода) + 1;
	ДанныеВыбора.Добавить(НачалоСледующегоГода, (Формат(НачалоСледующегоГода, "ДФ='yyyy'") + "..."));
	
	Возврат ДанныеВыбора;
	
КонецФункции


// Предназначена для реализации "произвольного" ввода даты-месяца
// подбирает по переданному тексту строку-представление даты или список таких строк
// в переданный параметр ДатаПоТексту возвращает подобранную по тексту дату
Функция ДатаКакМесяцПодобратьДатуПоТексту(Текст, ДатаПоТексту = Неопределено) Экспорт
    СписокВозврата = Новый СписокЗначений;
    ТекущийГод = Год(ТекущаяДата());
    
    Если ПустаяСтрока(Текст) Тогда
        Возврат СписокВозврата;
    КонецЕсли;
    Если Найти(Текст, ".") <> 0 Тогда
        Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, ".");
    ИначеЕсли Найти(Текст, ",") <> 0 Тогда
        Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, ",");
    ИначеЕсли Найти(Текст, "-") <> 0 Тогда
        Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, "-");
    ИначеЕсли Найти(Текст, "/") <> 0 Тогда
        Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, "/");
    ИначеЕсли Найти(Текст, "\") <> 0 Тогда
        Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, "\");
    Иначе
        Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, " ");
    КонецЕсли;
    Если Подстроки.Количество() = 1 Тогда
        // единственное слово - пытаемся получить месяц
        Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Текст) Тогда
            МесяцЧислом = Число(Текст);
            Если МесяцЧислом >= 1 и МесяцЧислом <=12 Тогда
                ДатаПоТексту = Дата(ТекущийГод, МесяцЧислом, 1);
                Если СтрДлина(Текст) = 1 Тогда
                    СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='М/гг'"));
                Иначе
                    СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='ММ/гг'"));
                КонецЕсли;
            Иначе
                Возврат СписокВозврата;
            КонецЕсли;                
        Иначе
            СписокМесяцев = ОбщегоНазначенияБККлиент.СписокМесяцевПоСтроке(Текст);
            Для Каждого Месяц Из СписокМесяцев Цикл
                ДатаПоТексту = Дата(ТекущийГод, Месяц, 1);
                СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='ММММ гг'"));
            КонецЦикла;
        КонецЕсли;
    ИначеЕсли Подстроки.Количество() = 2 Тогда
        // два слова - первое считаем месяцем, второе - годом
        Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Подстроки[1]) Тогда
            Если ПустаяСтрока(Подстроки[1]) Тогда
                ГодЧислом = 0;
                Подстроки[1] = "0";
                ТекстВозврата = Текст + "0";
            Иначе
                ГодЧислом = Число(Подстроки[1]);
                ТекстВозврата = "";
            КонецЕсли;
            Если ГодЧислом > 3000 Тогда
                Возврат СписокВозврата;
            КонецЕсли;
            Если СтрДлина(Подстроки[1]) <= 1 Тогда
                ГодЧислом = Число(Лев(Формат(ТекущийГод, "ЧГ="), 3) + Подстроки[1]);
                СтрокаФорматированияГода = "г";
            ИначеЕсли СтрДлина(Подстроки[1]) = 2 Тогда
                ГодЧислом = Число(Лев(Формат(ТекущийГод, "ЧГ="), 2) + Подстроки[1]);
                СтрокаФорматированияГода = "гг";
            ИначеЕсли СтрДлина(Подстроки[1]) = 3 Тогда
                ГодЧислом = Число(Лев(Формат(ТекущийГод, "ЧГ="), 1) + Подстроки[1]);
                СтрокаФорматированияГода = "гггг";
            КонецЕсли;                    
        Иначе
            // второе слово может быть только годом
            Возврат СписокВозврата;
        КонецЕсли;                
        Если ЗначениеЗаполнено(Подстроки[0]) И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Подстроки[0]) Тогда
            МесяцЧислом = Число(Подстроки[0]);
            Если МесяцЧислом >= 1 и МесяцЧислом <= 12 Тогда
                // если "правильный" месяц и год
                ДатаПоТексту = Дата(ГодЧислом, МесяцЧислом, 1);
                СписокВозврата.Добавить(ТекстВозврата);
            Иначе
                Возврат СписокВозврата;
            КонецЕсли;                
        Иначе
            СписокМесяцев = ОбщегоНазначенияБККлиент.СписокМесяцевПоСтроке(Подстроки[0]);
			Если СписокМесяцев.Количество() = 1 Тогда
				ДатаПоТексту = Дата(ГодЧислом, СписокМесяцев[0], 1);
				СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='ММММ гггг'"));
			Иначе
				Для Каждого Месяц Из СписокМесяцев Цикл
                    ДатаПоТексту = Дата(ГодЧислом, Месяц, 1);
                    СписокВозврата.Добавить(Формат(Дата(ГодЧислом, Месяц, 1), "ДФ='ММММ гг'"));
                КонецЦикла;
            КонецЕсли;
        КонецЕсли;
    КонецЕсли;
    Возврат СписокВозврата;
КонецФункции // ДатаКакМесяцПодобратьДатуПоТексту()

// Процедура обрабатывается событие "АвтоПодборТекста" для поля ввода текста с датой
// 
Процедура ДатаКакМесяцАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка) Экспорт
    ДанныеВыбора = ДатаКакМесяцПодобратьДатуПоТексту(Текст);
    Если ДанныеВыбора.Количество() = 1 Тогда
        ТекстАвтоПодбора = ДанныеВыбора[0].Значение;
    КонецЕсли;
    СтандартнаяОбработка = Ложь;
КонецПроцедуры // ДатаКакМесяцАвтоПодборТекста()

// Процедура обрабатывается событие "ОкончаниеВводаТекста" для поля ввода текста с датой
//
Процедура ДатаКакМесяцОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	ДанныеВыбора = ДатаКакМесяцПодобратьДатуПоТексту(Текст);
	Если ДанныеВыбора.Количество() = 1 Тогда
		Значение = Текст;
	Иначе
		Значение = ДанныеВыбора;
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
КонецПроцедуры // ДатаКакМесяцОкончаниеВводаТекста()

// Обработчики событий поля ввода.

Процедура ВводМесяцаПриИзменении(РедактируемыйОбъект, ПутьРеквизита, ПутьРеквизитаПредставления, Модифицированность = Ложь) Экспорт
	
	ЗначениеПредставления = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизитаПредставления);
	Значение              = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита);
	
	ДатаКакМесяцПодобратьДатуПоТексту(ЗначениеПредставления, Значение);
	
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизитаПредставления, КТ_РаботаСДиалогами.ДатаКакМесяцПредставление(Значение));
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита, Значение);
	
	Модифицированность = Истина;
	
КонецПроцедуры 

Процедура ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	Если Не ПустаяСтрока(Текст) Тогда
		ДанныеВыбора = ДатаКакМесяцПодобратьДатуПоТексту(Текст);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	Если Текст <> "" Тогда
		ДанныеВыбора = ДатаКакМесяцПодобратьДатуПоТексту(Текст);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВводМесяцаНачалоВыбора(Форма, РедактируемыйОбъект, ПутьРеквизита, ПутьРеквизитаПредставления, ИзменитьМодифицированность = Истина, ОповещениеЗавершения = Неопределено, ЗначениеМесяцаПоУмолчанию = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("РедактируемыйОбъект", РедактируемыйОбъект);
	ДополнительныеПараметры.Вставить("ПутьРеквизита", ПутьРеквизита);
	ДополнительныеПараметры.Вставить("ПутьРеквизитаПредставления", ПутьРеквизитаПредставления);
	ДополнительныеПараметры.Вставить("ИзменитьМодифицированность", ИзменитьМодифицированность);
	ДополнительныеПараметры.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
	
	Значение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита);
	Если Значение <= '19000101' Тогда
		
		Если ЗначениеМесяцаПоУмолчанию = Неопределено Тогда
			Значение = НачалоМесяца(ОбщегоНазначенияКлиент.ДатаСеанса());
		Иначе
			Значение = НачалоМесяца(ЗначениеМесяцаПоУмолчанию);
		КонецЕсли;
		
	КонецЕсли; 
	
	ПараметрыФормы = Новый  Структура;
	ПараметрыФормы.Вставить("Значение"								 , Значение);
	ПараметрыФормы.Вставить("НачалоПериода"							 , НачалоМесяца(Значение));
	ПараметрыФормы.Вставить("КонецПериода"							 , КонецМесяца(Значение));
	ПараметрыФормы.Вставить("РежимВыбораПериода"					 , "Месяц");
	ПараметрыФормы.Вставить("ЗапрашиватьРежимВыбораПериодаУВладельца", Ложь);
	
	Оповещение = Новый ОписаниеОповещения("ВводМесяцаНачалоВыбораЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаМесяц", ПараметрыФормы,
		Форма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура ВводМесяцаНачалоВыбораЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт

	Форма = ДополнительныеПараметры.Форма;
	РедактируемыйОбъект = ДополнительныеПараметры.РедактируемыйОбъект;
	ПутьРеквизита = ДополнительныеПараметры.ПутьРеквизита;
	ПутьРеквизитаПредставления = ДополнительныеПараметры.ПутьРеквизитаПредставления;
	ИзменитьМодифицированность = ДополнительныеПараметры.ИзменитьМодифицированность;
	ОповещениеЗавершения = ДополнительныеПараметры.ОповещениеЗавершения;
	
	Если ВыбранноеЗначение = Неопределено Тогда
		
		Если ОповещениеЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Ложь);
		КонецЕсли;
		
	Иначе
		
		Значение = ВыбранноеЗначение.НачалоПериода;
		
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита, Значение);
		Представление = КТ_РаботаСДиалогами.ДатаКакМесяцПредставление(Значение);
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизитаПредставления, Представление);
		
		Если ИзменитьМодифицированность Тогда 
			Форма.Модифицированность = Истина;
		КонецЕсли;
		
		Если ОповещениеЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Истина);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОповещениеЗавершения = Неопределено Тогда
		Форма.ОбновитьОтображениеДанных();
	КонецЕсли;
	
КонецПроцедуры

Процедура ВводМесяцаРегулирование(РедактируемыйОбъект, ПутьРеквизита, ПутьРеквизитаПредставления, Направление, Модифицированность = Ложь, ЗначениеМесяцаПоУмолчанию = Неопределено) Экспорт
	
	Значение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита);
	
	Если Значение <= '19000101' Тогда
		
		Если ЗначениеМесяцаПоУмолчанию = Неопределено Тогда
			Значение = НачалоМесяца(ОбщегоНазначенияКлиент.ДатаСеанса());
		Иначе
			Значение = НачалоМесяца(ЗначениеМесяцаПоУмолчанию);
		КонецЕсли;
		
		НовоеЗначение = Значение;
		
	Иначе
		НовоеЗначение = ДобавитьМесяц(Значение, Направление);
	КонецЕсли; 
	
	Если НовоеЗначение >= '00010101' Тогда
		
		Значение = НовоеЗначение;
		
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита, Значение);
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизитаПредставления, КТ_РаботаСДиалогами.ДатаКакМесяцПредставление(Значение));
		
		Модифицированность = Истина;
	 	
	КонецЕсли;
	
КонецПроцедуры 

////////////////////////////////////////////////////////////////////////////////




