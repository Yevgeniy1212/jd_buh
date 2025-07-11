﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Новости".
// ОбщийМодуль.ОбработкаНовостейКлиентПовтИсп.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область ФункциональныеОпции

// Функция возвращает результат - можно ли работать с новостями.
// Это результат функциональной опции "РазрешенаРаботаСНовостями"
//   И доступны нужные роли
//   И это не внешний пользователь.
// 
// Возвращаемое значение:
//  Булево - ИСТИНА, если есть возможность работы с новостями.
//
Функция РазрешенаРаботаСНовостями() Экспорт

	Результат = ОбработкаНовостейВызовСервера.РазрешенаРаботаСНовостями();

	Возврат Результат;

КонецФункции

// Функция возвращает результат - можно ли работать с новостями текущему пользователю.
// Это результат функциональной опции "РазрешенаРаботаСНовостями"
//   И доступны нужные роли
//   И это не внешний пользователь
//   И задан параметр сеанса ТекущийПользователь (т.е. мы не зашли в базу с отключенным списком пользователей).
// 
// Возвращаемое значение:
//  Булево - ИСТИНА, если есть возможность работы с новостями текущему пользователю.
//
Функция РазрешенаРаботаСНовостямиТекущемуПользователю() Экспорт

	Результат = ОбработкаНовостейВызовСервера.РазрешенаРаботаСНовостямиТекущемуПользователю();

	Возврат Результат;

КонецФункции

// Функция возвращает результат - можно ли работать с новостями через интернет.
// Это результат функциональной опции "РазрешенаРаботаСНовостямиЧерезИнтернет"
//   И доступны нужные роли
//   И это не внешний пользователь.
// 
// Возвращаемое значение:
//  Булево - ИСТИНА, если разрешена работа с новостями через интернет, ЛОЖЬ, если можно работать только с локальными новостями.
//
Функция РазрешенаРаботаСНовостямиЧерезИнтернет() Экспорт

	Результат = ОбработкаНовостейВызовСервера.РазрешенаРаботаСНовостямиЧерезИнтернет();

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область РаботаСТекстомНовости

// Функция возвращает ХТМЛ или простой текст новости по ссылке на новость.
//
// Параметры:
//  лкНовости            - СправочникОбъект.Новость, Структура, Массив - данные новости или списка новостей;
//  ПараметрыОтображения - Структура, Неопределено - структура, в которой передаются параметры для отображения новости.
//                         Список возможных параметров:
//    * ОтображатьЗаголовок - Булево.
//
// Возвращаемое значение:
//  Строка - текст новости в формате HTML.
//
Функция ПолучитьХТМЛТекстНовостей(лкНовости, ПараметрыОтображения = Неопределено) Экспорт

	Результат = ОбработкаНовостейВызовСервера.ПолучитьХТМЛТекстНовостей(лкНовости, ПараметрыОтображения);

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ПоискДанных

// Функция возвращает ссылку на ленту новостей по ее коду.
//
// Параметры:
//  ЛентаНовостейКод - Строка - код ленты новостей.
//
// Возвращаемое значение:
//   СправочникСсылка.ЛентыНовостей - ссылка на ленту новостей или пустая ссылка, если нет ленты новостей с таким кодом.
//
Функция ПолучитьЛентуНовостейПоКоду(ЛентаНовостейКод) Экспорт

	Результат = ОбработкаНовостейВызовСервера.ПолучитьЛентуНовостейПоКоду(ЛентаНовостейКод);

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ЛогИОтладка

// Функция возвращает значение, надо ли вести подробный журнал регистрации.
//
// Возвращаемое значение:
//   Булево - Истина, если надо вести подробный журнал регистрации, Ложь в противном случае.
//
Функция ВестиПодробныйЖурналРегистрации() Экспорт

	Возврат ОбработкаНовостейВызовСервера.ВестиПодробныйЖурналРегистрации();

КонецФункции

#КонецОбласти

#Область СостояниеПодсистемы

// Получает состояние подсистемы.
//
// Возвращаемое значение:
//   Строка - см. параметр "СостояниеПодсистемы", метод ОбработкаНовостейСлужебный.УстановитьСостояниеПодсистемы().
//
Функция ПолучитьСостояниеПодсистемы() Экспорт

	Результат = ОбработкаНовостейВызовСервера.ПолучитьСостояниеПодсистемы();

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецОбласти
