﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы конфигурации.
// ОбщийМодуль.ОбновлениеИнформационнойБазыБИП.
//
// 1С:Библиотека интернет-поддержки
//
// Библиотека предназначена для встраивания в различные прикладные решения,
// разработанные на платформе 1С:Предприятие 8, и дающая возможность пользователям
// этих решений работать с сервисами сопровождения из привычных им интерфейсов
// прикладных решений.
//
// Официальное информационно-технологическое сопровождение пользователей
// продуктов 1С:Предприятие 8 включает в себя сервисы и услуги, которые предоставляются
// Фирмой 1С и ее сертифицированными партнерами. С полным списком сервисов и условий
// работы с ними можно ознакомиться на Портале 1С:ИТС https://portal.1c.ru. Интерфейс
// для работы с некоторыми сервисами может быть встроен непосредственно в программные продукты,
// тем самым дополняя функциональные возможности этих продуктов. Программный код таких
// интерфейсов составляет суть "1С:Библиотеки интернет-поддержки".
//
// Обращаем внимание, что некоторые подсистемы библиотеки могут быть встроены в любые
// программные продукты на платформе 1С:Предприятие 8, а некоторые только в продукты,
// удовлетворяющие определенным условиям. Наличие таких условий обусловлено спецификой
// сервисов. Детально эти условия указаны в описании каждой подсистемы библиотеки.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Заполняет основные сведения о библиотеке или основной конфигурации.
// Библиотека, имя которой имя совпадает с именем конфигурации в метаданных, определяется как основная конфигурация.
// 
// Параметры:
//  Описание - Структура - сведения о библиотеке:
//
//   * Имя                 - Строка - имя библиотеки, например, "СтандартныеПодсистемы".
//   * Версия              - Строка - версия в формате из 4-х цифр, например, "2.1.3.1".
//
//   * ТребуемыеПодсистемы - Массив - имена других библиотек (Строка), от которых зависит данная библиотека.
//                                    Обработчики обновления таких библиотек должны быть вызваны ранее
//                                    обработчиков обновления данной библиотеки.
//                                    При циклических зависимостях или, напротив, отсутствии каких-либо зависимостей,
//                                    порядок вызова обработчиков обновления определяется порядком добавления модулей
//                                    в процедуре ПриДобавленииПодсистем общего модуля
//                                    ПодсистемыКонфигурацииПереопределяемый.
//   * РежимВыполненияОтложенныхОбработчиков - Строка - "Последовательно" - отложенные обработчики обновления выполняются
//                                    последовательно в интервале от номера версии информационной базы до номера
//                                    версии конфигурации включительно или "Параллельно" - отложенный обработчик после
//                                    обработки первой порции данных передает управление следующему обработчику, а после
//                                    выполнения последнего обработчика цикл повторяется заново.
//
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя                            = "ИнтернетПоддержкаПользователей";
	Описание.Версия                         = ИнтернетПоддержкаПользователейКлиентСервер.ВерсияБиблиотеки();
	Описание.ИдентификаторИнтернетПоддержки = "ISL";
	
	// Требуется библиотека стандартных подсистем.
	Описание.ТребуемыеПодсистемы.Добавить("СтандартныеПодсистемы");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления информационной базы.

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
// Параметры:
//	Обработчики - ТаблицаЗначений - описание полей, см. в процедуре
//		ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления().
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	// БазоваяФункциональностьБИП
	ИнтернетПоддержкаПользователей.ПриДобавленииОбработчиковОбновления(Обработчики);
	// Конец БазоваяФункциональностьБИП
	
	// ДанныеНагрузкиИРентабельности
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ДанныеНагрузкиИРентабельности") Тогда
		МодульДанныеНагрузкиИРентабельности = ОбщегоНазначения.ОбщийМодуль("ДанныеНагрузкиИРентабельности");
		МодульДанныеНагрузкиИРентабельности.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	
	// МониторПортала1СИТС
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.МониторПортала1СИТС") Тогда
		МодульМониторПортала1СИТС = ОбщегоНазначения.ОбщийМодуль("МониторПортала1СИТС");
		МодульМониторПортала1СИТС.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	// Конец МониторПортала1СИТС
	
	// Новости
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		МодульОбработкаНовостейСлужебный = ОбщегоНазначения.ОбщийМодуль("ОбработкаНовостейСлужебный");
		МодульОбработкаНовостейСлужебный.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	// Конец Новости
	
	// ОнлайнОплаты
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОнлайнОплаты") Тогда
		МодульОнлайнОплатыСлужебный = ОбщегоНазначения.ОбщийМодуль("ОнлайнОплатыСлужебный");
		МодульОнлайнОплатыСлужебный.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	// Конец ОнлайнОплаты
	
	// ПодключениеСервисовСопровождения
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПодключениеСервисовСопровождения") Тогда
		МодульПодключениеСервисовСопровождения = ОбщегоНазначения.ОбщийМодуль("ПодключениеСервисовСопровождения");
		МодульПодключениеСервисовСопровождения.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	// Конец ПодключениеСервисовСопровождения
	
	// ПолучениеОбновленийПрограммы
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы") Тогда
		МодульПолучениеОбновленийПрограммы = ОбщегоНазначения.ОбщийМодуль("ПолучениеОбновленийПрограммы");
		МодульПолучениеОбновленийПрограммы.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	// Конец ПолучениеОбновленийПрограммы
	
	// СПАРКРиски
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СПАРКРиски") Тогда
		МодульСПАРКРиски = ОбщегоНазначения.ОбщийМодуль("СПАРКРиски");
		МодульСПАРКРиски.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	// Конец СПАРКРиски
	
	// РаботаСКонтрагентами
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.РаботаСКонтрагентами") Тогда
		МодульРаботаСКонтрагентами = ОбщегоНазначения.ОбщийМодуль("РаботаСКонтрагентами");
		МодульРаботаСКонтрагентами.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	// Конец РаботаСКонтрагентами
	
	// РаботаСКлассификаторами
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.РаботаСКлассификаторами") Тогда
		МодульРаботаСКлассификаторами = ОбщегоНазначения.ОбщийМодуль("РаботаСКлассификаторами");
		МодульРаботаСКлассификаторами.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	// Конец РаботаСКлассификаторами
	
	// ПолучениеВнешнихКомпонент
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеВнешнихКомпонент") Тогда
		МодульПолучениеВнешнихКомпонент = ОбщегоНазначения.ОбщийМодуль("ПолучениеВнешнихКомпонент");
		МодульПолучениеВнешнихКомпонент.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	// Конец ПолучениеВнешнихКомпонент
	
	// ИнтеграцияСКоннект
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ИнтеграцияСКоннект") Тогда
		МодульИнтеграцияСКоннект = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияСКоннект");
		МодульИнтеграцияСКоннект.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	// Конец ИнтеграцияСКоннект
	
	// СистемаБыстрыхПлатежей.БазоваяФункциональностьСБП
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СистемаБыстрыхПлатежей.БазоваяФункциональностьСБП") Тогда
		МодульСистемаБыстрыхПлатежейСлужебный = ОбщегоНазначения.ОбщийМодуль("СистемаБыстрыхПлатежейСлужебный");
		МодульСистемаБыстрыхПлатежейСлужебный.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	// Конец СистемаБыстрыхПлатежей.БазоваяФункциональностьСБП
	
	// ПолучениеРегламентированныхОтчетов
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеРегламентированныхОтчетов") Тогда
		МодульПолучениеРегламентированныхОтчетов = ОбщегоНазначения.ОбщийМодуль("ПолучениеРегламентированныхОтчетов");
		МодульПолучениеРегламентированныхОтчетов.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	// Конец ПолучениеРегламентированныхОтчетов
	
КонецПроцедуры

// Вызывается перед обработчиками обновления данных ИБ.
//
//@skip-warning
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
	
	
КонецПроцедуры

// Вызывается после завершения обновления данных ИБ.
// 
// Параметры:
//   ПредыдущаяВерсияИБ - Строка - версия до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсияИБ - Строка - версия после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков обновления,
//                                             сгруппированных по номеру версии.
//   ВыводитьОписаниеОбновлений - Булево - если установить Истина, то будет выведена форма
//                                с описанием обновлений. По умолчанию, Истина.
//                                Возвращаемое значение.
//   МонопольныйРежим           - Булево - Истина, если обновление выполнялось в монопольном режиме.
//
//@skip-warning
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсияИБ, Знач ТекущаяВерсияИБ,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
	
	
КонецПроцедуры

// Вызывается при подготовке табличного документа с описанием изменений системы.
//
// Параметры:
//  Макет - ТабличныйДокумент - описание обновлений. См. также общий макет ОписаниеИзмененийСистемы.
//
//@skip-warning
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
	
	
КонецПроцедуры

// Позволяет переопределить режим обновления данных информационной базы.
// Для использования в редких (нештатных) случаях перехода, не предусмотренных в
// стандартной процедуре определения режима обновления.
//
// Параметры:
//   РежимОбновленияДанных - Строка - в обработчике можно присвоить одно из значений:
//              "НачальноеЗаполнение"     - если это первый запуск пустой базы (области данных);
//              "ОбновлениеВерсии"        - если выполняется первый запуск после обновление конфигурации базы данных;
//              "ПереходСДругойПрограммы" - если выполняется первый запуск после обновление конфигурации базы данных, 
//                                          в которой изменилось имя основной конфигурации.
//
//   СтандартнаяОбработка  - Булево - если присвоить Ложь, то стандартная процедура
//                                    определения режима обновления не выполняется, 
//                                    а используется значение РежимОбновленияДанных.
//
//@skip-warning
Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

// Добавляет в список процедуры-обработчики перехода с другой программы (с другим именем конфигурации).
// Например, для перехода между разными, но родственными конфигурациями: базовая -> проф -> корп.
// Вызывается перед началом обновления данных ИБ.
//
// Параметры:
//	Обработчики - ТаблицаЗначений - с колонками:
//		* ПредыдущееИмяКонфигурации - Строка - имя конфигурации, с которой выполняется переход;
//			или "*", если нужно выполнять при переходе с любой конфигурации.
//		* Процедура - Строка - полное имя процедуры-обработчика перехода с программы ПредыдущееИмяКонфигурации. 
//			Например, "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику"
//			Обязательно должна быть экспортной.
//
// Пример:
//	Обработчик = Обработчики.Добавить();
//	Обработчик.ПредыдущееИмяКонфигурации  = "УправлениеТорговлей";
//	Обработчик.Процедура                  = "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику";
//
//@skip-warning
Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
	
	
	
КонецПроцедуры

// Вызывается после выполнения всех процедур-обработчиков перехода с другой программы (с другим именем конфигурации),
// и до начала выполнения обновления данных ИБ.
//
// Параметры:
//  ПредыдущееИмяКонфигурации    - Строка - имя конфигурации до перехода.
//  ПредыдущаяВерсияКонфигурации - Строка - имя предыдущей конфигурации (до перехода).
//  Параметры                    - Структура - :
//    * ВыполнитьОбновлениеСВерсии   - Булево - по умолчанию Истина. Если установить Ложь, 
//        то будут выполнена только обязательные обработчики обновления (с версией "*").
//    * ВерсияКонфигурации           - Строка - номер версии после перехода. 
//        По умолчанию, равен значению версии конфигурации в свойствах метаданных.
//        Для того чтобы выполнить, например, все обработчики обновления с версии ПредыдущаяВерсияКонфигурации, 
//        следует установить значение параметра в ПредыдущаяВерсияКонфигурации.
//        Для того чтобы выполнить вообще все обработчики обновления, установить значение "0.0.0.1".
//    * ОчиститьСведенияОПредыдущейКонфигурации - Булево - по умолчанию Истина. 
//        Для случаев когда предыдущая конфигурация совпадает по имени с подсистемой текущей конфигурации, следует указать Ложь.
//
//@skip-warning
Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации, 
	Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
