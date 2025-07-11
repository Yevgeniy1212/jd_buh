﻿////////////////////////////////////////////////////////////////////////////////
// ЭлектронноеВзаимодействиеСлужебныйВызовСервера: общий механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Получает значение функциональной опции.
//
// Параметры:
//  НаименованиеФО - Строка - имя функциональной опции.
//
// Возвращаемое значение:
//  Булево - признак включенной ФО.
//
Функция ЗначениеФункциональнойОпции(НаименованиеФО) Экспорт
	
	СоответствиеФО = Новый Соответствие;
	
	// Библиотека стандартных подсистем
	
	ЭлектронноеВзаимодействиеПереопределяемый.ПолучитьСоответствиеФункциональныхОпций(СоответствиеФО);
	
	// Электронные документы
	СоответствиеФО.Вставить("ИспользоватьОбменЭД",                    "ИспользоватьОбменЭД");
	СоответствиеФО.Вставить("ИспользоватьОбменЭДМеждуОрганизациями",  "ИспользоватьОбменЭДМеждуОрганизациями");
	СоответствиеФО.Вставить("ИспользоватьОбменСБанками",              "ИспользоватьОбменСБанками");
	СоответствиеФО.Вставить("ИспользоватьЭлектронныеПодписиЭД",       "ИспользоватьЭлектронныеПодписиЭД");
	СоответствиеФО.Вставить("ИспользоватьИнтеграциюСЯндексКассой",    "ИспользоватьИнтеграциюСЯндексКассой");
	СоответствиеФО.Вставить("ИспользоватьПрямойОбменЭлектроннымиДокументами",
		"ИспользоватьПрямойОбменЭлектроннымиДокументами");
	
	ИмяФОПрикладногоРешения = СоответствиеФО.Получить(НаименованиеФО);
	Если ИмяФОПрикладногоРешения = Неопределено Тогда // не задано соответствие
		Результат = Ложь;
	Иначе
		Результат = ПолучитьФункциональнуюОпцию(ИмяФОПрикладногоРешения)
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Преобразует двоичные данные в строку на сервере.
//
// Параметры:
//  Данные - ДвоичныеДанные, Строка - двоичные данные или адрес временного хранилища.
//
// Возвращаемое значение:
//  Строка - Строка в кодировке UTF8.
//
Функция СтрокаИзДвоичныхДанных(Знач Данные) Экспорт
	
	Результат = Данные;
	
	Если ТипЗнч(Данные) = Тип("Строка") И ЭтоАдресВременногоХранилища(Данные) Тогда
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(Данные);
	Иначе
		ДвоичныеДанные = Данные;
	КонецЕсли;
	
	Если ТипЗнч(ДвоичныеДанные) = Тип("ДвоичныеДанные") Тогда
		ВремФайл = ПолучитьИмяВременногоФайла();
		ДвоичныеДанные.Записать(ВремФайл);
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(ВремФайл, КодировкаТекста.UTF8);
		
		ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ВремФайл);
		
		Результат = ТекстовыйДокумент.ПолучитьТекст();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает имя прикладного справочника по имени библиотечного справочника.
//
// Параметры:
//  ИмяСправочника - Строка - название справочника из библиотеки.
//
// Возвращаемое значение:
//  Строка - строковое имя прикладного справочника.
//
Функция ИмяПрикладногоСправочника(ИмяСправочника) Экспорт
	
	Возврат ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника(ИмяСправочника);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Ошибки и сообщения

// Обрабатывает исключительные ситуации по электронным документам.
//
// Параметры:
//  ВидОперации          - строка - вид операции при которой возникло исключение.
//  ПодробныйТекстОшибки - строка - описание ошибки.
//  Ошибки       - строка - текст ошибки.
//                       - массив - массив, содержащий структуры описания ошибок (см. ЭлектронноеВзаимодействиеСлужебный.ДобавитьОшибку).
//  КодСобытия           - Строка - код события, используется для стандартизации иерархии событий.
//                                  Возможные значения см. в ЭлектронноеВзаимодействие.ОбработатьОшибку.
//  СсылкаНаОбъект       - ДокументСсылка, СправочникСсылка - объект с которым связано данное событие.ЗаписатьОшибкуВЖурналРегистрации().
//
Процедура ОбработатьОшибку(ВидОперации, ПодробныйТекстОшибки, Ошибки = "", КодСобытия = "ОбменСКонтрагентами", СсылкаНаОбъект = Неопределено) Экспорт
	
	// Выведем ошибку в сообщении пользователю.

	Если ЗначениеЗаполнено(Ошибки) Тогда
		Если ТипЗнч(Ошибки) = Тип("Массив") Тогда
			// Выводим раздельные сообщения, каждое из которых может быть привязано к своей форме.
			Для Каждого ОписаниеОшибки Из Ошибки Цикл
				КлючДанных = СсылкаНаОбъект;
				Если ЗначениеЗаполнено(ОписаниеОшибки.КлючСообщения) Тогда
					КлючДанных = ОписаниеОшибки.КлючСообщения;
				КонецЕсли;
				
				Поле = "";
				ПутьКДанным = "";
				Если ЗначениеЗаполнено(ОписаниеОшибки.ПутьКДаннымСообщения) Тогда
					СоставляющиеПути = СтрРазделить(ОписаниеОшибки.ПутьКДаннымСообщения, ".");
					Если СоставляющиеПути.Количество() = 1 Тогда
						Поле = СоставляющиеПути[0];
					Иначе
						ПутьКДанным = СоставляющиеПути[0];
						СоставляющиеПути.Удалить(0);
						Поле = СтрСоединить(СоставляющиеПути, ".");
					КонецЕсли;
				КонецЕсли;
				
				ОбщегоНазначения.СообщитьПользователю(ОписаниеОшибки.ТекстОшибки, КлючДанных, Поле, ПутьКДанным);
			КонецЦикла;
		Иначе
			// Передана строка - выводим единое сообщение пользователю.
			ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь( , , Ложь);
	
			Если ЭтоПолноправныйПользователь И ЗначениеЗаполнено(Ошибки) И ЗначениеЗаполнено(ПодробныйТекстОшибки)
				И ПодробныйТекстОшибки <> Ошибки Тогда
				
				Ошибки = Ошибки + Символы.ПС + НСтр("ru ='Подробности см. в журнале регистрации.'");
			КонецЕсли;
			
			ОбщегоНазначения.СообщитьПользователю(Ошибки, СсылкаНаОбъект);
		КонецЕсли;
	КонецЕсли;
	
	ЗаписатьОшибкуВЖурналРегистрации(ВидОперации, ПодробныйТекстОшибки, КодСобытия, СсылкаНаОбъект);

КонецПроцедуры

// Возвращает текст сообщения пользователю о необходимости  настройки системы.
//
// Параметры:
//  ВидОперации - Строка - признак выполняемой операции.
//
// Возвращаемое значение:
//  Строка - Строка сообщения.
//
Функция ТекстСообщенияОНеобходимостиНастройкиСистемы(ВидОперации) Экспорт
	
	ТекстСообщения = "";
	ЭлектронноеВзаимодействиеПереопределяемый.ТекстСообщенияОНеобходимостиНастройкиСистемы(ВидОперации, ТекстСообщения);
	Если НЕ ЗначениеЗаполнено(ТекстСообщения) Тогда
		Если ВРег(ВидОперации) = "РАБОТАСЭД" Тогда
			ТекстСообщения = НСтр("ru = 'Для работы с электронными документами необходимо
			|в настройках системы включить использование обмена электронными документами.'");
		ИначеЕсли ВРег(ВидОперации) = "ПОДПИСАНИЕЭД" Тогда
			ТекстСообщения = НСтр("ru = 'Для возможности подписания ЭД необходимо
			|в настройках системы включить опцию использования электронных цифровых подписей.'");
		ИначеЕсли ВРег(ВидОперации) = "НАСТРОЙКАКРИПТОГРАФИИ" Тогда
			ТекстСообщения = НСтр("ru = 'Для возможности настройки криптографии необходимо 
			|в настройках системы включить опцию использования электронных цифровых подписей.'");
		ИначеЕсли ВРег(ВидОперации) = "РАБОТАСБАНКАМИ" Тогда
			ТекстСообщения = НСтр("ru = 'Для возможности обмена ЭД с банками необходимо 
			|в настройках системы включить опцию использования прямого взаимодействия с банками.'");
		Иначе
			ТекстСообщения = НСтр("ru='Операция не может быть выполнена. Не выполнены необходимые настройки системы.'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТекстСообщения;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Криптография

// Находит существующий или создает новый элемент справочника СертификатыКлючейЭлектроннойПодписиИШифрования.
//
// Параметры:
//  ДвоичныеДанныеСертификата - ДвоичныеДанные - содержимое сертификата;
//  Организация - СправочникСсылка.Организации - организация;
//  ИнформацияОПрограммеКриптографии - Строка - название криптосредства;
//                                - СправочникСсылка.ПрограммыЭлектроннойПодписиИШифрования - ссылка на программу криптографии.
//
// Возвращаемое значение:
//  СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - ссылка на новый сертификат.
//
Функция НайтиСоздатьСертификатЭП(ДвоичныеДанныеСертификата, Организация, ИнформацияОПрограммеКриптографии = Неопределено) Экспорт
	
	Если ТипЗнч(ИнформацияОПрограммеКриптографии) = Тип("Строка")  Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		               |	ПрограммыЭлектроннойПодписиИШифрования.Ссылка
		               |ИЗ
		               |	Справочник.ПрограммыЭлектроннойПодписиИШифрования КАК ПрограммыЭлектроннойПодписиИШифрования
		               |ГДЕ
		               |	ПрограммыЭлектроннойПодписиИШифрования.ИмяПрограммы = &НазваниеПрограммыКриптографии";
		Запрос.УстановитьПараметр("НазваниеПрограммыКриптографии", ИнформацияОПрограммеКриптографии);
		УстановитьПривилегированныйРежим(Истина);
		Выборка = Запрос.Выполнить().Выбрать();
		УстановитьПривилегированныйРежим(Ложь);
		Если Выборка.Следующий() Тогда
			Программа = Выборка.Ссылка;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ИнформацияОПрограммеКриптографии) = Тип("СправочникСсылка.ПрограммыЭлектроннойПодписиИШифрования") Тогда
		Программа = ИнформацияОПрограммеКриптографии;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Организация", Организация);
	
	// Если в ИБ уже есть такой сертификат, и в нем заполнена программа криптографии, то не меняем программу,
	// т.к. он могла быть указана правильно вручную.
	СсылкаНаСертификат = ЭлектроннаяПодпись.СсылкаНаСертификат(ДвоичныеДанныеСертификата);
	Если НЕ ЗначениеЗаполнено(СсылкаНаСертификат)
		ИЛИ (ЗначениеЗаполнено(СсылкаНаСертификат)
				И НЕ ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаСертификат, "Программа"))) Тогда
		ДополнительныеПараметры.Вставить("Программа", Программа);
	КонецЕсли;
	
	Возврат ЭлектроннаяПодпись.ЗаписатьСертификатВСправочник(ДвоичныеДанныеСертификата, ДополнительныеПараметры);

КонецФункции

// Позволяет получить значения реквизитов сертификата ЭП.
//
// Параметры:
//  СертификатЭП - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - ссылка на элемент справочника "Сертификаты ЭП".
//
// Возвращаемое значение:
//  Структура - значений реквизитов.
//
Функция РеквизитыСертификата(СертификатЭП) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ПараметрыСертификата = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СертификатЭП,
		"Отозван, Отпечаток, ДействителенДо, ПользовательОповещенОСрокеДействия,
		|Фамилия, Имя, Отчество, Должность, Организация, ДанныеСертификата,
		|Наименование, Пользователь, КомуВыдан, Фирма");
	ПараметрыСертификата.Вставить("ДвоичныеДанныеСертификата", ПараметрыСертификата.ДанныеСертификата.Получить());
	ПараметрыСертификата.Вставить("ВыбранныйСертификат", СертификатЭП);
	ПараметрыСертификата.Вставить("ПарольПолучен", Ложь);
	ПараметрыСертификата.Вставить("ПарольПользователя", Неопределено);
	
	// В БСП методах необходим параметр
	ПараметрыСертификата.Вставить("Комментарий", "");
	
	Возврат ПараметрыСертификата;
	
КонецФункции

// Возвращает пароль к сертификату, если доступен текущему пользователю.
// При вызове в привилегированном режиме текущий пользователь не учитывается.
//
// Параметры:
//  Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - вернуть пароль
//                 к указанному сертификату.
//  МассивОтпечатков - Массив - массив отпечатков сертификатов для которых требуется получить сохраненные пароли.
//              
// Возвращаемое значение:
//  Неопределено - пароль для указанного сертификата не указан.
//  Строка       - пароль для указанного сертификата.
//  Соответствие - все заданные пароли по массиву отпечатков,
//                 в виде ключ - сертификат и значение - пароль.
//
Функция ПарольКСертификату(Сертификат = Неопределено, МассивОтпечатков = Неопределено) Экспорт
	
	МетаданныеСправочникаСертификатов = Метаданные.НайтиПоПолномуИмени("Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования");
	Если Не ПравоДоступа("Чтение", МетаданныеСправочникаСертификатов) Тогда
		Если Сертификат <> Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		Возврат Новый СписокЗначений;
	КонецЕсли;
		
	Если Сертификат <> Неопределено Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		Данные = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Сертификат,"ПаролиСертификатов");
		УстановитьПривилегированныйРежим(Ложь);
		
		Если ТипЗнч(Данные) <> Тип("Соответствие") Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		Пользователь = Пользователи.ТекущийПользователь();
		Пароль = Данные.Получить(Пользователь);
		
		Если ЗначениеЗаполнено(Пароль) Тогда
			Возврат Пароль;
		КонецЕсли;
		
		Пользователь = Справочники.Пользователи.ПустаяСсылка();
		Пароль = Данные.Получить(Пользователь);
		
		Если ЗначениеЗаполнено(Пароль) Тогда
			Возврат Пароль;
		КонецЕсли;
		
		Возврат Неопределено;
		
	КонецЕсли;
		
	Если МассивОтпечатков <> Неопределено Тогда
		
		ПаролиСертификатов = Новый Соответствие;
		
		УстановитьПривилегированныйРежим(Истина);
		
		Для Каждого Отпечаток Из МассивОтпечатков Цикл
			
			СертификатПоОтпечатку = ЭлектроннаяПодпись.СсылкаНаСертификат(Отпечаток);
			
			Если ЗначениеЗаполнено(СертификатПоОтпечатку) Тогда
				
				Данные = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(СертификатПоОтпечатку,"ПаролиСертификатов");
				
				Если ТипЗнч(Данные) <> Тип("Соответствие") Тогда
					Продолжить;
				КонецЕсли;
				
				Пользователь = Пользователи.ТекущийПользователь();
				Пароль = Данные.Получить(Пользователь);
				
				Если ЗначениеЗаполнено(Пароль) Тогда
					ПаролиСертификатов.Вставить(СертификатПоОтпечатку, Пароль);
				Иначе
					
					Пользователь = Справочники.Пользователи.ПустаяСсылка();
					Пароль = Данные.Получить(Пользователь);
					
					Если ЗначениеЗаполнено(Пароль) Тогда
						ПаролиСертификатов.Вставить(СертификатПоОтпечатку, Пароль);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		УстановитьПривилегированныйРежим(Ложь);
		
		Возврат ПаролиСертификатов;
		
	КонецЕсли;
	
КонецФункции

// Получает массив структур личных сертификатов для показа в диалоге выбора сертификатов для подписи или шифрования.
//
// Параметры:
//   ПоказыватьОшибку  - Булево - если Ложь, то ошибка создания менеджера криптографии не отображается.
//
// Возвращаемое значение:
//   Массив - массив структур с полями сертификата.
Функция МассивОтпечатковСертификатов(ПоказыватьОшибку = Истина) Экспорт
	
	МассивОтпечатков = Новый Массив;
	
	Если НЕ ЭлектронноеВзаимодействиеСлужебный.ВыполнятьКриптооперацииНаСервере() Тогда
		Возврат МассивОтпечатков;
	КонецЕсли;
	
	Отказ = Ложь;
	МенеджерКриптографии = ЭлектронноеВзаимодействиеСлужебный.МенеджерКриптографии(Отказ, ПоказыватьОшибку);
	Если Отказ Тогда
		Возврат МассивОтпечатков;
	КонецЕсли;
	
	ТекущаяДата = ТекущаяДатаСеанса(); // Используется для выявления истекших сертификатов, которые хранятся на клиентском компьютере.
	
	ХранилищеСертификатовКриптографии = МенеджерКриптографии.ПолучитьХранилищеСертификатов(
		ТипХранилищаСертификатовКриптографии.ПерсональныеСертификаты);
	СертификатыХранилища = ХранилищеСертификатовКриптографии.ПолучитьВсе();
	
	Для Каждого Сертификат Из СертификатыХранилища Цикл
		Если Сертификат.ДатаОкончания < ТекущаяДата Тогда
			Продолжить; // Пропуск истекших сертификатов.
		КонецЕсли;
		
		СтруктураСертификата = ЭлектроннаяПодпись.СвойстваСертификата(Сертификат);
		Если СтруктураСертификата <> Неопределено Тогда
			СтрокаОтпечатка = Base64Строка(Сертификат.Отпечаток);
			Если МассивОтпечатков.Найти(СтрокаОтпечатка) = Неопределено Тогда
				МассивОтпечатков.Добавить(СтрокаОтпечатка);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивОтпечатков;
	
КонецФункции

// Получение структуры команд ЭДО из сохраненной настройки.
//  ИмяКоманды - Строка - имя команды.
//  АдресКомандВоВременномХранилище - Строка - адрес во временном хранилище.
//
Функция ОписаниеКомандыЭДО(ИмяКоманды, АдресКомандВоВременномХранилище) Экспорт
	
	КомандыЭДО = ПолучитьИзВременногоХранилища(АдресКомандВоВременномХранилище);
	Для Каждого КомандаЭДО Из КомандыЭДО.НайтиСтроки(Новый Структура("ИмяКомандыНаФорме", ИмяКоманды)) Цикл
		Возврат ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(КомандаЭДО);
	КонецЦикла;
	
КонецФункции

// Проверяет будет ли пользователю показываться оповещение о наличии новых эд в сервисе 1С-ЭДО
// Возвращаемое значение:
//   Булево - результат проверки.
//
Функция ОповещатьОСобытияхЭДО() Экспорт
	
	Оповещать = Ложь;
	
	ЕстьОбменСКонтрагентами = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами");
	
	Если Не ЕстьОбменСКонтрагентами Тогда
		Возврат Ложь;
	КонецЕсли;
	
	МодульОбменСКонтрагентамиСлужебныйВызовСервера = ОбщегоНазначения.ОбщийМодуль("ОбменСКонтрагентамиСлужебныйВызовСервера");
	
	Если МодульОбменСКонтрагентамиСлужебныйВызовСервера.ЕстьПравоОбработкиЭД()
		И ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ЕстьПроверкаНовыхЭД() Тогда
		Оповещать = Истина;
	КонецЕсли;
	
	Возврат Оповещать;
	
КонецФункции

Функция ОписаниеПрограммКриптографии() Экспорт
	
	Возврат ЭлектронноеВзаимодействиеСлужебный.ОписаниеПрограммКриптографии();
	
КонецФункции

Функция НайтиСсылкиНаПрограммыКриптографии(Знач ОписанияПрограмм) Экспорт
	
	ИменаПрограмм = Новый Массив;
	Для каждого Описание Из ОписанияПрограмм Цикл
		Если Описание.Установлена Тогда
			ИменаПрограмм.Добавить(Описание.ИмяПрограммы);
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Программы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПрограммыЭлектроннойПодписиИШифрования КАК Программы
	|ГДЕ
	|	Программы.ИмяПрограммы В(&ИменаПрограмм)";
	Запрос.УстановитьПараметр("ИменаПрограмм", ИменаПрограмм);
	
	НайденныеПрограммы = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НайденныеПрограммы.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат НайденныеПрограммы;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Мобильный клиент

// Возвращает Истина, если клиентское приложение является мобильным клиентом.
//
// Возвращаемое значение:
//  Булево - если нет клиентского приложения, возвращается Ложь.
//
Функция ЭтоМобильныйКлиент() Экспорт
	
	Возврат ОбщегоНазначения.ЭтоМобильныйКлиент();
	
КонецФункции

// Событие возникает при открытии недоступной формы на мобильном клиенте
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - открываемая форма
//
Процедура ПриОткрытииНедоступнойФормыНаМобильномКлиенте(Форма) Экспорт
	
	ТекстСообщения = НСтр("ru = 'Функциональность в мобильном клиенте пока недоступна. Воспользуйтесь веб-клиентом или тонким клиентом'");
	ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	Форма = Метаданные.Обработки.ЭлектронноеВзаимодействие.Формы.ПустаяФорма;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обрабатывает исключительные ситуации по электронным документам.
//
// Параметры:
//  ВидОперации - строка - вид операции при которой возникло исключение.
//  ПодробныйТекстОшибки - строка - описание ошибки.
//  КодСобытия           - Строка - код события, используется для стандартизации иерархии событий.
//                                  Возможные значения см. в ЭлектронноеВзаимодействие.ОбработатьОшибку.
//  СсылкаНаОбъект       - ДокументСсылка, СправочникСсылка - объект с которым связано данное событие.
//
Процедура ЗаписатьОшибкуВЖурналРегистрации(Знач ВидОперации, ПодробныйТекстОшибки, КодСобытия = "ОбменСКонтрагентами",
	СсылкаНаОбъект = Неопределено)
	
	Если Прав(ВидОперации, 1) <> "." Тогда
		ВидОперации = ВидОперации + ".";
	КонецЕсли;
	
	ТекстОшибки = СтрШаблон(НСтр("ru = 'Выполнение операции: %1
		|%2'"), ВидОперации, ПодробныйТекстОшибки);
	
	ОбъектМетаданных = Неопределено;
	Если ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		ОбъектМетаданных = СсылкаНаОбъект.Метаданные();
	КонецЕсли;
	
	ЭлектронноеВзаимодействиеСлужебный.ВыполнитьЗаписьСобытияПоЭДВЖурналРегистрации(
		ТекстОшибки, КодСобытия, , ОбъектМетаданных, СсылкаНаОбъект);

КонецПроцедуры

#КонецОбласти
