﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Конструктор параметра СвойстваПодписи для добавления и обновления данных электронной подписи.
// Содержит развернутое описание подписи.
// 
// Возвращаемое значение:
//   Структура:
//     * Подпись             - ДвоичныеДанные - результат подписания.
//                           - Строка - подписанный КонвертXML, если передавался в данных.
//     * УстановившийПодпись - СправочникСсылка.Пользователи - пользователь, который
//                           подписал объект информационной базы.
//     * Комментарий         - Строка - комментарий, если он был введен при подписании.
//     * ИмяФайлаПодписи     - Строка - если подпись добавлена из файла.
//     * ДатаПодписи         - Дата - дата, когда подпись была сделана. Имеет смысл для случаев,
//                           когда дату невозможно извлечь из данных подписи.
//     * ДатаПроверкиПодписи - Дата - дата последней проверки подписи.
//     * ПодписьВерна        - Булево - результат последней проверки подписи.
//     * ТребуетсяПроверка   - Булево - не удалось проверить подпись.
//
//     Используются при обновлении усовершенствованной подписи:
//     * ПодписанныйОбъект   - ОпределяемыйТип.ПодписанныйОбъект - объект, с которым связана подпись.
//                             Игнорируется в методах, в которые объект передается как параметр.
//     * ПорядковыйНомер     - Число - идентификатор подписи, по которому можно упорядочивать их в списке.
//                             Не заполнен, если подпись не связана с объектом.
//     * ОшибкаПриАвтоматическомПродлении - Булево - не использовать, служебный, заполняется регламентным заданием.
//     Используются для связи с машиночитаемой доверенностью:
//     * ИдентификаторПодписи - УникальныйИдентификатор
//     * РезультатПроверкиПодписиПоМЧД - Массив из Структура, Структура - МашиночитаемыеДоверенностиФНС.РезультатПроверкиПодписиПоМЧД
//
//     Производные свойства подписи:
//     * ТипПодписи          - ПеречислениеСсылка.ТипыПодписиКриптографии
//     * СрокДействияПоследнейМеткиВремени - Дата - срок действия сертификата, которым подписана
//                                           последняя метка времени (или пустая дата, если нет метки времени),
//                                           если удалось определить с помощью МенеджераКриптографии
//     * Сертификат          - ХранилищеЗначения - содержит выгрузку сертификата,
//                             который использовался для подписания (содержится в подписи).
//                           - ДвоичныеДанные
//     * Отпечаток           - Строка - отпечаток сертификата в формате строки Base64.
//     * КомуВыданСертификат - Строка - представление субъекта, полученное из двоичных данных сертификата.
//     * ОписаниеСертификата - Структура - свойство, требуемое для сертификатов, которые
//                             не могут быть переданы в метод платформы СертификатКриптографии, со свойствами:
//        ** СерийныйНомер - Строка - серийный номер сертификата, как у объекта платформы СертификатКриптографии.
//        ** КемВыдан      - Строка - как возвращает функция ПредставлениеИздателя.
//        ** КомуВыдан     - Строка - как возвращает функция ПредставлениеСубъекта.
//        ** ДатаНачала    - Строка - дата сертификата, как у объекта платформы СертификатКриптографии в формате "ДЛФ=D".
//        ** ДатаОкончания - Строка - дата сертификата, как у объекта платформы СертификатКриптографии в формате "ДЛФ=D".
//
Функция НовыеСвойстваПодписи() Экспорт
	
	Структура = Новый Структура;
	Структура.Вставить("Подпись");
	Структура.Вставить("УстановившийПодпись");
	Структура.Вставить("Комментарий");
	Структура.Вставить("ИмяФайлаПодписи");
	Структура.Вставить("ДатаПодписи");
	Структура.Вставить("ДатаПроверкиПодписи");
	Структура.Вставить("ПодписьВерна");
	Структура.Вставить("ПодписанныйОбъект");
	Структура.Вставить("ПорядковыйНомер");
	Структура.Вставить("ТребуетсяПроверка", Ложь);
	
	Структура.Вставить("Сертификат");
	Структура.Вставить("Отпечаток");
	Структура.Вставить("КомуВыданСертификат");
	Структура.Вставить("ТипПодписи");
	Структура.Вставить("СрокДействияПоследнейМеткиВремени");
	
	Структура.Вставить("ОписаниеСертификата");
	
	Структура.Вставить("ОшибкаПриАвтоматическомПродлении", Ложь);
	Структура.Вставить("ИдентификаторПодписи");
	Структура.Вставить("РезультатПроверкиПодписиПоМЧД");
	
	Возврат Структура;
	
КонецФункции

// Результат проверки подписи.
// 
// Возвращаемое значение:
//  Структура:
//   * Результат - Булево     - Истина, если проверка выполнена успешно.
//             - Строка       - описание ошибки проверки подписи.
//             - Неопределено - не удалось получить менеджер криптографии (когда не указан).
//   * ПодписьВерна        - Булево, Неопределено - результат последней проверки подписи.
//   * СертификатОтозван   - Булево - ошибка связана с тем, что сертификат отозван.
//   * ТребуетсяПроверка   - Булево - не удалось проверить подпись.
//   * ТипПодписи          - ПеречислениеСсылка.ТипыПодписиКриптографии - не заполнен при проверке подписей конверта XML.
//   * СрокДействияПоследнейМеткиВремени - Дата - срок действия сертификата, которым подписана
//    последняя метка времени (или пустая дата, если нет метки времени), если удалось определить с помощью МенеджераКриптографии.
//   * НеподтвержденнаяДатаПодписи - Дата - неподтвержденная дата подписи.
//                               - Неопределено - неподтвержденная дата подписи отсутствует в данных подписи и для
//                                                конверта XML.
//   * ДатаПодписиИзМетки  - Дата - дата самой ранней метки времени.
//                       - Неопределено - метка времени отсутствует в данных подписи и при проверке конверта XML.
//   * Сертификат          - ДвоичныеДанные - сертификат подписанта
//   * Отпечаток           - Строка - отпечаток сертификата в формате строки Base64.
//   * КомуВыданСертификат - Строка - представление субъекта, полученное из двоичных данных сертификата.
//
Функция РезультатПроверкиПодписи() Экспорт
	
	Структура = Новый Структура;
	Структура.Вставить("Результат");
	Структура.Вставить("ПодписьВерна");
	Структура.Вставить("СертификатОтозван", Ложь);
	Структура.Вставить("ТребуетсяПроверка");
	
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(
		Структура, ЭлектроннаяПодписьСлужебныйКлиентСервер.СвойстваПодписиПриЧтенииИПроверке());
		
	Возврат Структура;
	
КонецФункции

#Область УстаревшиеПроцедурыИФункции

// Устарела.
// См. ЭлектроннаяПодписьКлиент.ПредставлениеСертификата.
// См. ЭлектроннаяПодпись.ПредставлениеСертификата.
//
Функция ПредставлениеСертификата(Сертификат, Отчество = Ложь, СрокДействия = Истина) Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Если СрокДействия Тогда
		Возврат ЭлектроннаяПодпись.ПредставлениеСертификата(Сертификат);
	Иначе	
		Возврат ЭлектроннаяПодпись.ПредставлениеСубъекта(Сертификат);
	КонецЕсли;	
#Иначе
	Если СрокДействия Тогда
		Возврат ЭлектроннаяПодписьКлиент.ПредставлениеСертификата(Сертификат);
	Иначе
		Возврат ЭлектроннаяПодписьКлиент.ПредставлениеСубъекта(Сертификат);
	КонецЕсли;
#КонецЕсли
	
КонецФункции

// Устарела.
// См. ЭлектроннаяПодписьКлиент.ПредставлениеСубъекта.
// См. ЭлектроннаяПодпись.ПредставлениеСубъекта.
//
Функция ПредставлениеСубъекта(Сертификат, Отчество = Истина) Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат ЭлектроннаяПодпись.ПредставлениеСубъекта(Сертификат);
#Иначе
	Возврат ЭлектроннаяПодписьКлиент.ПредставлениеСубъекта(Сертификат);
#КонецЕсли
	
КонецФункции

// Устарела.
// См. ЭлектроннаяПодписьКлиент.ПредставлениеИздателя.
// См. ЭлектроннаяПодпись.ПредставлениеИздателя.
//
Функция ПредставлениеИздателя(Сертификат) Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат ЭлектроннаяПодпись.ПредставлениеИздателя(Сертификат);
#Иначе
	Возврат ЭлектроннаяПодписьКлиент.ПредставлениеИздателя(Сертификат);
#КонецЕсли
	
КонецФункции

// Устарела.
// См. ЭлектроннаяПодписьКлиент.СвойстваСертификата.
// См. ЭлектроннаяПодпись.СвойстваСертификата.
//
Функция ЗаполнитьСтруктуруСертификата(Сертификат) Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат ЭлектроннаяПодпись.СвойстваСертификата(Сертификат);
#Иначе
	Возврат ЭлектроннаяПодписьКлиент.СвойстваСертификата(Сертификат);
#КонецЕсли
	
КонецФункции

// Устарела.
// См. ЭлектроннаяПодписьКлиент.СвойстваСубъектаСертификата.
// См. ЭлектроннаяПодпись.СвойстваСубъектаСертификата.
//
Функция СвойстваСубъектаСертификата(Сертификат) Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат ЭлектроннаяПодпись.СвойстваСубъектаСертификата(Сертификат);
#Иначе
	Возврат ЭлектроннаяПодписьКлиент.СвойстваСубъектаСертификата(Сертификат);
#КонецЕсли
	
КонецФункции

// Устарела.
// См. ЭлектроннаяПодписьКлиент.СвойстваИздателяСертификата.
// См. ЭлектроннаяПодпись.СвойстваИздателяСертификата.
//
Функция СвойстваИздателяСертификата(Сертификат) Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат ЭлектроннаяПодпись.СвойстваИздателяСертификата(Сертификат);
#Иначе
	Возврат ЭлектроннаяПодписьКлиент.СвойстваИздателяСертификата(Сертификат);
#КонецЕсли
	
КонецФункции

// Устарела.
// См. ЭлектроннаяПодписьКлиент.ПараметрыXMLDSig.
// См. ЭлектроннаяПодпись.ПараметрыXMLDSig.
//
Функция ПараметрыXMLDSig() Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат ЭлектроннаяПодпись.ПараметрыXMLDSig();
#Иначе
	Возврат ЭлектроннаяПодписьКлиент.ПараметрыXMLDSig();
#КонецЕсли
	
КонецФункции

#КонецОбласти

#КонецОбласти