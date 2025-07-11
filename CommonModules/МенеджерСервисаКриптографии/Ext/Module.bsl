﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Менеджер сервиса криптографии".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ЗаявлениеНаПодключение

// Отправить заявление на подключение
//
// Параметры:
//  Заявление - Структура - заявление.
// 
// Возвращаемое значение:
//  Структура - результат:
//  * Выполнено - Булево
//  * КодОшибки - Строка
//  * ОписаниеОшибки - Строка
//
Функция ОтправитьЗаявлениеНаПодключение(Заявление) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/requests/%1/request_sender", ВерсияПрограммногоИнтерфейса_v2_0());
	
	ПараметрыЗапроса = Заявление;
	ПараметрыЗапроса.Вставить("client", ПолучитьОписаниеКлиента());
	
	ПоляОтвета = Новый Структура("req_id", "Идентификатор");
	
	Возврат ВызватьHTTPМетод("POST", URL, ПараметрыЗапроса, ПоляОтвета);

КонецФункции

// Сформировать заявление для подписания
//
// Параметры:
//  Заявление - Структура - заявление.
// 
// Возвращаемое значение:
//  Структура - результат:
//  * Выполнено - Булево
//  * КодОшибки - Строка
//  * ОписаниеОшибки - Строка
//
Функция СформироватьЗаявлениеДляПодписания(Заявление) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/requests/%1/request", ВерсияПрограммногоИнтерфейса_v2_0());
	
	ПараметрыЗапроса = Заявление;
	ПараметрыЗапроса.Вставить("client", ПолучитьОписаниеКлиента());
	
	ПоляОтвета = Новый Структура("req_id, request", "Идентификатор", "Заявление");
	ПараметрыПреобразования = Новый Структура("ИменаСвойствДляВосстановления", СтрРазделить("request", ","));
	
	Возврат ВызватьHTTPМетод("POST", URL, ПараметрыЗапроса, ПоляОтвета,, ПараметрыПреобразования);

КонецФункции

// Отправить подписанное заявление
//
// Параметры:
//  Заявление - Структура - заявление.
// 
// Возвращаемое значение:
//  Структура - результат:
//  * Выполнено - Булево
//  * КодОшибки - Строка
//  * ОписаниеОшибки - Строка
//
Функция ОтправитьПодписанноеЗаявление(Заявление) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/requests/%1/signed_request_sender", ВерсияПрограммногоИнтерфейса_v2_0());
	
	ПараметрыЗапроса = Заявление;
	ПараметрыЗапроса.Вставить("client", ПолучитьОписаниеКлиента());
	
	ПоляОтвета = Новый Структура;
	
	Возврат ВызватьHTTPМетод("POST", URL, ПараметрыЗапроса, ПоляОтвета);

КонецФункции

// Функция - Получить статус заявления на подключение
//
// Параметры:
//  ИдентификаторЗаявления - Строка - идентификатор заявления.
// 
// Возвращаемое значение:
//  Структура - результат:
//  * Выполнено - Булево
//  * КодОшибки - Строка
//  * ОписаниеОшибки - Строка
///
Функция ПолучитьСтатусЗаявленияНаПодключение(ИдентификаторЗаявления) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/requests/%1/request/%2",
										ВерсияПрограммногоИнтерфейса_v1_1(),
										ИдентификаторЗаявления);
										
	ПоляОтвета = Новый Структура();
	ПоляОтвета.Вставить("status", "Статус");
	ПоляОтвета.Вставить("details", "Пояснение");
	ПоляОтвета.Вставить("token_id", "ИдентификаторСертификата");
	ПоляОтвета.Вставить("token_value", "Токен");
	
	Возврат ВызватьHTTPМетод("GET", URL, Неопределено, ПоляОтвета);

КонецФункции

#КонецОбласти

#Область ПроверкаТелефонаИЭлектроннойПочты

// Получить код проверки телефона
//
// Параметры:
//  Телефон - Строка - телефон,
//  Идентификатор - Строка - идентификатор.
// 
// Возвращаемое значение:
//  Структура - результат, поля:
// 	 * Идентификатор - Строка - 
// 	 * НомерКода - Число - 
// 	 * ВремяДействияКода - Число - 
// 	 * ЗадержкаПередПовторнойОтправкой - Число -  
Функция ПолучитьКодПроверкиТелефона(Телефон, Идентификатор = "") Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/verification/%1/phone/code", ВерсияПрограммногоИнтерфейса_v1_1());
	
	ПараметрыЗапроса = Новый Структура("phone,req_id,repeat", Телефон, Идентификатор, ЗначениеЗаполнено(Идентификатор));
	
	ПоляОтвета = Новый Структура;
	ПоляОтвета.Вставить("req_id", "Идентификатор");
	ПоляОтвета.Вставить("num", "НомерКода");
	ПоляОтвета.Вставить("life_time", "ВремяДействияКода");
	ПоляОтвета.Вставить("delay", "ЗадержкаПередПовторнойОтправкой");
	
	Возврат ВызватьHTTPМетод("POST", URL, ПараметрыЗапроса, ПоляОтвета);

КонецФункции

// Проверить телефон по коду
//
// Параметры:
//  Идентификатор - Строка - идентификатор,
//  Код - Строка - код.
// 
// Возвращаемое значение:
//  Структура - результат:
//  * Выполнено - Булево
//  * КодОшибки - Число
//  * ОписаниеОшибки - Строка
///
Функция ПроверитьТелефонПоКоду(Идентификатор, Код) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/verification/%1/phone", ВерсияПрограммногоИнтерфейса_v1_1());
	
	ПараметрыЗапроса = Новый Структура("req_id,code", Идентификатор, Код);
	
	ПоляОтвета = Новый Структура;
	
	Возврат ВызватьHTTPМетод("POST", URL, ПараметрыЗапроса, ПоляОтвета);
	
КонецФункции

// Получить код проверки электронной почты
//
// Параметры:
//  ЭлектроннаяПочта - Строка - электронная почта,
//  Идентификатор - Строка - идентификатор.
// 
// Возвращаемое значение:
//  Структура - результат:
//   * Идентификатор - Строка - 
//	 * НомерКода - Число - 
//	 * ВремяДействияКода - Число - 
//	 * ЗадержкаПередПовторнойОтправкой - Число -  
Функция ПолучитьКодПроверкиЭлектроннойПочты(ЭлектроннаяПочта, Идентификатор = "") Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/verification/%1/email/code", ВерсияПрограммногоИнтерфейса_v1_1());
	
	ПараметрыЗапроса = Новый Структура("email,req_id,repeat", ЭлектроннаяПочта, Идентификатор, ЗначениеЗаполнено(Идентификатор));
	
	Если НЕ ОбщегоНазначения.ПодсистемаСуществует("РегламентированнаяОтчетность.ЭлектронныйДокументооборотСКонтролирующимиОрганами") Тогда
		ПараметрыЗапроса.Вставить("subject", НСтр("ru = 'Проверочный код подтверждения электронной почты в 1С'"));
	КонецЕсли;

	ПоляОтвета = Новый Структура;
	ПоляОтвета.Вставить("req_id", "Идентификатор");
	ПоляОтвета.Вставить("num", "НомерКода");
	ПоляОтвета.Вставить("life_time", "ВремяДействияКода");
	ПоляОтвета.Вставить("delay", "ЗадержкаПередПовторнойОтправкой");
	
	Возврат ВызватьHTTPМетод("POST", URL, ПараметрыЗапроса, ПоляОтвета);
	
КонецФункции

// Проверить электронную почту по коду
//
// Параметры:
//  Идентификатор - Строка - идентификатор,
//  Код - Строка - код.
// 
// Возвращаемое значение:
//  Структура - результат:
//  * Выполнено - Булево
//  * КодОшибки - Число
//  * ОписаниеОшибки - Строка
///
Функция ПроверитьЭлектроннуюПочтуПоКоду(Идентификатор, Код) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/verification/%1/email", ВерсияПрограммногоИнтерфейса_v1_1());
	
	ПараметрыЗапроса = Новый Структура("req_id,code", Идентификатор, Код);
	
	ПоляОтвета = Новый Структура;
	
	Возврат ВызватьHTTPМетод("POST", URL, ПараметрыЗапроса, ПоляОтвета);

КонецФункции

#КонецОбласти

#Область ИзменениеНастроекПолученияВременныхПаролейПровайдером

// Напечатать заявление
//
// Параметры:
//  ИдентификаторЗаявления - Строка - идентификатор заявления,
//  ИдентификаторПроверки - Строка - идентификатор проверки,
//  ИдентификаторСертификата - Строка - идентификатор сертификата.
// 
// Возвращаемое значение:
//  Структура - результат:
//  * Выполнено - Булево
//  * КодОшибки - Число
//  * ОписаниеОшибки - Строка
//
Функция НапечататьЗаявление(ИдентификаторЗаявления, ИдентификаторПроверки, ИдентификаторСертификата) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/otp/%1/phone/request/%2",
										ВерсияПрограммногоИнтерфейса_v1_1(),
										ИдентификаторЗаявления);
										
	ПараметрыЗапроса = Новый Структура("client", ПолучитьОписаниеКлиента());
	ПараметрыЗапроса.Вставить("phone", ИдентификаторПроверки);
	ПараметрыЗапроса.Вставить("cert_id", ИдентификаторСертификата);
	
	Результат = ВызватьHTTPМетод("POST", URL, ПараметрыЗапроса, Новый Структура);
	Если Результат.Выполнено Тогда
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("mxl");
		ДанныеРезультата = Результат.Файл; // ДвоичныеДанные
		ДанныеРезультата.Записать(ИмяВременногоФайла);
		
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ТабличныйДокумент.Прочитать(ИмяВременногоФайла);
		
		УдалитьФайлы(ИмяВременногоФайла);
		
		Результат.Файл = ТабличныйДокумент;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Отправить заявление
//
// Параметры:
//  ИдентификаторЗаявления - Строка - идентификатор заявления,
//  ФайлЗаявления - Строка - файл заявления.
// 
// Возвращаемое значение:
//  Структура - результат:
//  * Выполнено - Булево
//  * КодОшибки - Число
//  * ОписаниеОшибки - Строка
//
Функция ОтправитьЗаявление(ИдентификаторЗаявления, ФайлЗаявления) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/otp/%1/phone/request/%2",
										ВерсияПрограммногоИнтерфейса_v1_1(),
										ИдентификаторЗаявления);
										
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Disposition", 
		СтрШаблон("attachment; filename=%1", КодироватьСтроку(ФайлЗаявления.Имя, СпособКодированияСтроки.КодировкаURL)));
		
	Результат = ВызватьHTTPМетод("PUT", URL, ПолучитьИзВременногоХранилища(ФайлЗаявления.Адрес), Новый Структура, Заголовки);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ИзменениеНастроекПолученияВременныхПаролейПользователем

// Начать изменение настроек получения временных паролей
//
// Параметры:
//  ИдентификаторСертификата - Строка - идентификатор сертификата,
//  Телефон - Строка - телефон,
//  ЭлектроннаяПочта - Строка - электронная почта,
//  Идентификатор - Строка - идентификатор.
// 
// Возвращаемое значение:
//  Структура - результат, поля:
// 	 * Идентификатор - Строка - 
// 	 * ВремяДействияКода - Число - 
// 	 * ЗадержкаПередПовторнойОтправкой - Число -  
Функция НачатьИзменениеНастроекПолученияВременныхПаролей(ИдентификаторСертификата, Телефон, ЭлектроннаяПочта, Идентификатор = "") Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/otp/%1/users_requests", ВерсияПрограммногоИнтерфейса_v1_1());
	
	ПараметрыЗапроса = Новый Структура("client", ПолучитьОписаниеКлиента());
	Если ЗначениеЗаполнено(Идентификатор) Тогда
		ПараметрыЗапроса.Вставить("req_id", Идентификатор);
	Иначе
		ПараметрыЗапроса.Вставить("cert_id", ИдентификаторСертификата);
		Если Телефон <> Неопределено Тогда
			ПараметрыЗапроса.Вставить("phone", Телефон);
		КонецЕсли;
		Если ЭлектроннаяПочта <> Неопределено Тогда
			ПараметрыЗапроса.Вставить("email", ЭлектроннаяПочта);
		КонецЕсли;
	КонецЕсли;

	ПоляОтвета = Новый Структура("req_id,life_time,delay", "Идентификатор", "ВремяДействияКода", "ЗадержкаПередПовторнойОтправкой");
	
	Возврат ВызватьHTTPМетод("POST", URL, ПараметрыЗапроса, ПоляОтвета);
	
КонецФункции

// Завершить изменение настроек получения временных паролей
//
// Параметры:
//  Идентификатор - Строка - идентификатор,
//  Код - Строка - код.
// 
// Возвращаемое значение:
//  Структура - результат:
//  * Выполнено - Булево
//  * КодОшибки - Число
//  * ОписаниеОшибки - Строка
//
Функция ЗавершитьИзменениеНастроекПолученияВременныхПаролей(Идентификатор, Код) Экспорт
			
	URL = АдресСервиса() + СтрШаблон("/hs/otp/%1/user_request/%2", ВерсияПрограммногоИнтерфейса_v1_1(), Идентификатор);
										
	ПараметрыЗапроса = Новый Структура("req_id,code", Идентификатор, Код);
	
	Возврат ВызватьHTTPМетод("PUT", URL, ПараметрыЗапроса, Новый Структура);
	
КонецФункции

#КонецОбласти

#Область ЗаявленияНаСертификат

// Создает контейнер закрытого ключа и запроса на сертификат
//
// Параметры:
//	ПараметрыЗаявления - Структура - Содержит поля для формирования заявления на сертификат:
// 	 * ИдентификаторЗаявления   - Строка - идентификатор поиска запроса на сертификат.
//	 * СодержаниеЗапроса 		- Строка - содержит поля OID.
//	 * НомерТелефона			- Строка - содержит идентификатор подтвержденного телефона
//	 * ЭлектроннаяПочта			- Строка - содержит идентификатор подтвердденной эл. почты
//	 * НотариусАдвокатГлаваКФХ	- Булево - 
//	 * ИдентификаторАбонента	- Строка - идентификатор.
//	АдресРезультата - Строка - адрес временного хранилища куда выкладывается результат функции Структура.
// 
Процедура СоздатьКонтейнерИЗапросНаСертификат(ПараметрыЗаявления, АдресРезультата) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/certificate/new_request/%1", ПараметрыЗаявления.ИдентификаторЗаявления);
	
	КодированнаяСтрока 	= СериализаторXDTO.XMLСтрока(Новый ХранилищеЗначения(ПараметрыЗаявления.СодержаниеЗапроса));
	ПараметрыЗапроса 	= Новый Структура();
	ПараметрыЗапроса.Вставить("НотариусАдвокатГлаваКФХ", ПараметрыЗаявления.НотариусАдвокатГлаваКФХ);
	ПараметрыЗапроса.Вставить("ИдентификаторАбонента", ПараметрыЗаявления.ИдентификаторАбонента);
	ПараметрыЗапроса.Вставить("ЭлектроннаяПочта", ПараметрыЗаявления.ЭлектроннаяПочта);
	ПараметрыЗапроса.Вставить("ТелефонМобильный", ПараметрыЗаявления.НомерТелефона);
	ПараметрыЗапроса.Вставить("СодержаниеЗапроса", КодированнаяСтрока);
	ПараметрыЗапроса.Вставить("client", ПолучитьОписаниеКлиента());
	
	ПоляОтвета 				= Новый Структура("request, public_key, provider, provtype", 
												"ЗапросНаСертификат", "ОткрытыйКлюч", "ИмяПровайдера", "ТипПровайдера");
	ПараметрыПреобразования = Новый Структура("ИменаСвойствДляВосстановления", СтрРазделить("request,public_key", ","));
	Результат				= ВызватьHTTPМетод("PUT", URL, ПараметрыЗапроса, ПоляОтвета, , ПараметрыПреобразования);
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры	

// Привязывает сертификат к закрытому ключу в облачном хранилище
//
// Параметры:
//  ПараметрыЗаявления - Структура - Содержит поля для формирования заявления на сертификат:
//   * ИдентификаторЗаявления   - Строка - идентификатор поиска запроса на сертификат
//   * ДанныеСертификата - ДвоичныеДанные - содержит данные сертификата в кодировке PEM.
//
//  АдресРезультата - Строка - адрес временного хранилища куда выкладывается результат функции Структура.
//
Процедура УстановитьСертификатВКонтейнерИХранилище(ПараметрыЗаявления, АдресРезультата) Экспорт
	
	URL 		= АдресСервиса() + СтрШаблон("/hs/certificate/initialize_request/%1", ПараметрыЗаявления.ИдентификаторЗаявления);
	
	ДанныеСертификата		= ХранилищеСертификатов.СертификатВКодировкеDER(ПараметрыЗаявления.ДанныеСертификата, Символы.ПС);
	ПараметрыЗапроса 		= Новый Структура("data", ДанныеСертификата);
	ПараметрыПреобразования = Новый Структура("ИменаСвойствДляВосстановления", СтрРазделить("data", ","));
	
	ПоляОтвета 	= Новый Структура("success", "Успешно");
	Результат	= ВызватьHTTPМетод("PUT", URL, ПараметрыЗапроса, ПоляОтвета, , ПараметрыПреобразования);
	
	Попытка
		Если Результат.Выполнено Тогда
			ХранилищеСертификатов.Добавить(ДанныеСертификата, Перечисления.ТипХранилищаСертификатов.ПерсональныеСертификаты);	
		КонецЕсли;
	Исключение
		Результат.Выполнено = Ложь;
		Результат.Вставить("КодОшибки", "ОшибкаПриОбращенииКСерверу");
		Результат.Вставить("ОписаниеОшибки", ТехнологияСервиса.КраткийТекстОшибки(ИнформацияОбОшибке()));
		// @skip-check module-nstr-camelcase - ошибка проверки
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Электронная подпись в модели сервиса.Менеджер сервиса криптографии'", ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,, ТехнологияСервиса.ПодробныйТекстОшибки(ИнформацияОбОшибке()));
	КонецПопытки;	
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

#КонецОбласти

#Область СертификатыАбонентаПоИдентификаторуПроверкиИНН

// Сертификаты абонента по идентификатору проверки ИНН
// 
// Параметры: 
//  ИНН - Строка
//  Идентификатор - Строка
//  ТолькоДействующие - Булево - Только действующие
// 
// Возвращаемое значение: 
//  Структура - Сертификаты абонента по идентификатору проверки ИНН:
// * Сертификаты - Массив Из Структура:
// 	  ** ID - Строка
// или, если ошибка 
// * ОписаниеОшибки - Строка
// * КодОшибки - Строка
// * Выполнено - Булево
Функция СертификатыАбонентаПоИдентификаторуПроверкиИНН(ИНН, Идентификатор, ТолькоДействующие = Истина) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/requests/%1/abonent_certificates", ВерсияПрограммногоИнтерфейса_v2_0());
	
	ПараметрыЗапроса = Новый Структура("client", ПолучитьОписаниеКлиента());
	ПараметрыЗапроса.Вставить("req_id", Идентификатор);
	ПараметрыЗапроса.Вставить("inn", ИНН);
	ПараметрыЗапроса.Вставить("valid", ТолькоДействующие);

	ПоляОтвета = Новый Структура("certificates", "Сертификаты");
	
	Результат = ВызватьHTTPМетод("POST", URL, ПараметрыЗапроса, ПоляОтвета);
	
	Если Результат.Выполнено Тогда 
		Для Каждого Сертификат Из Результат.Сертификаты Цикл 
			Сертификат.ValidTo = XMLЗначение(Тип("Дата"), Сертификат.ValidTo);
			Сертификат.ValidFrom = XMLЗначение(Тип("Дата"), Сертификат.ValidFrom);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ПоискСертификата

// Поиск сертификата по отпечатку или серийному номеру.
// 
// Параметры: 
//  Отпечаток - Строка
//  СерийныйНомер - Строка
//  Сокращенно - Булево
// 
// Возвращаемое значение: 
//  Структура :
// * Выполнено - Булево
// * КодОшибки - Строка
// * ОписаниеОшибки - Строка
Функция ПоискСертификатаПоОтпечаткуИлиСерийномуНомеру(
			Отпечаток = Неопределено, 
			СерийныйНомер = Неопределено, 
			Сокращенно = Ложь) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/requests/%1/find_certificate", ВерсияПрограммногоИнтерфейса_v2_0());
	
	ПараметрыЗапроса = Новый Структура("client", ПолучитьОписаниеКлиента());
	Если ЗначениеЗаполнено(Отпечаток) Тогда 
		ПараметрыЗапроса.Вставить("thumbprint", Отпечаток);
	КонецЕсли;
	Если ЗначениеЗаполнено(СерийныйНомер) Тогда 
		ПараметрыЗапроса.Вставить("serialnumber", СерийныйНомер);
	КонецЕсли;
	Если Сокращенно Тогда 
		ПараметрыЗапроса.Вставить("important_only", Истина);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Отпечаток) И Не ЗначениеЗаполнено(СерийныйНомер) Тогда 
		Возврат Новый Структура("Выполнено, КодОшибки, ОписаниеОшибки", 
						Ложь, 
						"ПараметрыНеЗаполнены", 
						НСтр("ru = 'Необходимо заполнить thumbprint или serialnumber.'", ОбщегоНазначения.КодОсновногоЯзыка()));
	КонецЕсли;
	
	ПоляОтвета = Новый Структура("certificates", "Сертификаты");
	
	Результат = ВызватьHTTPМетод("POST", URL, ПараметрыЗапроса, ПоляОтвета);
	
	Если Результат.Выполнено Тогда 
		Для Каждого Сертификат Из Результат.Сертификаты Цикл 
			Если Не Сертификат.Свойство("ValidTo") Тогда 
				Продолжить;
			КонецЕсли;
			Сертификат.ValidTo = XMLЗначение(Тип("Дата"), Сертификат.ValidTo);
			Сертификат.ValidFrom = XMLЗначение(Тип("Дата"), Сертификат.ValidFrom);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьОписаниеКлиента()
	
	ОписаниеКлиента = Новый Структура;
	ОписаниеКлиента.Вставить("version", Метаданные.Версия);
	ОписаниеКлиента.Вставить("name", Метаданные.Имя);
	ОписаниеКлиента.Вставить("id", Формат(РаботаВМоделиСервиса.ЗначениеРазделителяСеанса(), "ЧГ="));
	
	Возврат ОписаниеКлиента;
	
КонецФункции

// Получить параметры соединения
// 
// Параметры:
//  URL - Строка
// 
// Возвращаемое значение: см. ОбщегоНазначенияКлиентСервер.СтруктураURI
Функция ПолучитьПараметрыСоединения(URL) Экспорт
	
	ПараметрыСоединения = ОбщегоНазначенияКлиентСервер.СтруктураURI(URL);
	ПараметрыСоединения.Схема = ?(ЗначениеЗаполнено(ПараметрыСоединения.Схема), ПараметрыСоединения.Схема, "http");	
	ПараметрыСоединения.Вставить("Таймаут", 180);
	
	УстановитьПривилегированныйРежим(Истина);
	Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Константы.АдресСервисаПодключенияЭлектроннойПодписиВМоделиСервиса);
	ПараметрыСоединения.Вставить("Логин", ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Логин", Истина));
	ПараметрыСоединения.Вставить("Пароль", ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Пароль", Истина));
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ПараметрыСоединения;
	
КонецФункции

Функция АдресСервиса()
	
	УстановитьПривилегированныйРежим(Истина);

	Возврат Константы.АдресСервисаПодключенияЭлектроннойПодписиВМоделиСервиса.Получить();
	
КонецФункции

Функция ВерсияПрограммногоИнтерфейса_v1_1()
	
	Возврат "v1.1";
	
КонецФункции

Функция ВерсияПрограммногоИнтерфейса_v2_0()
	
	Возврат "v2.0";
	
КонецФункции

Функция ВызватьHTTPМетод(HTTPМетод, URL, ПараметрыЗапроса, СоответствиеПолейОтвета, Заголовки = Неопределено, ПараметрыПреобразования = Неопределено)
	
	Результат = Новый Структура;	
	
	ПараметрыСоединения = ПолучитьПараметрыСоединения(URL);
	Попытка
		Соединение = ЭлектроннаяПодписьВМоделиСервиса.СоединениеССерверомИнтернета(ПараметрыСоединения);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		// @skip-check module-nstr-camelcase - ошибка проверки
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Электронная подпись в модели сервиса.Менеджер сервиса криптографии'", ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,, ТехнологияСервиса.ПодробныйТекстОшибки(ИнформацияОбОшибке));
			
		Результат.Вставить("Выполнено", Ложь);
		Результат.Вставить("КодОшибки", "НеУдалосьУстановитьСоединение");
		Результат.Вставить("ОписаниеОшибки", НСтр("ru = 'Не удалось установить соединение с сервером.'"));		
		Возврат Результат;
	КонецПопытки;

	Запрос = Новый HTTPЗапрос(ПараметрыСоединения.ПутьНаСервере);
	Если ТипЗнч(ПараметрыЗапроса) = Тип("Структура") Тогда
		Запрос.Заголовки.Вставить("Content-Type", "application/json");
		Запрос.УстановитьТелоИзСтроки(ЭлектроннаяПодписьВМоделиСервиса.СтруктураВJSON(ПараметрыЗапроса));
	ИначеЕсли ТипЗнч(ПараметрыЗапроса) = Тип("ДвоичныеДанные") Тогда
		Запрос.Заголовки.Вставить("Content-Type", "application/octet-stream");
		Запрос.УстановитьТелоИзДвоичныхДанных(ПараметрыЗапроса);
	КонецЕсли;
	Если ЗначениеЗаполнено(Заголовки) Тогда
		Для Каждого Заголовок Из Заголовки Цикл
			Запрос.Заголовки.Вставить(Заголовок.Ключ, Заголовок.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Попытка
		Ответ = Соединение.ВызватьHTTPМетод(HTTPМетод, Запрос);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		// @skip-check module-nstr-camelcase - ошибка проверки
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Электронная подпись в модели сервиса.Менеджер сервиса криптографии'", ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,, ТехнологияСервиса.ПодробныйТекстОшибки(ИнформацияОбОшибке));
		
		Результат.Вставить("Выполнено", Ложь);
		Результат.Вставить("КодОшибки", "ОшибкаПриОбращенииКСерверу");
		Результат.Вставить("ОписаниеОшибки", ТехнологияСервиса.ПодробныйТекстОшибки(ИнформацияОбОшибке));		
		Возврат Результат;
	КонецПопытки;

	Если Ответ.КодСостояния = 200 Тогда
		Результат.Вставить("Выполнено", Истина);
		
		ContentType = ОбщегоНазначенияБТС.ЗаголовокHTTP(Ответ, "Content-Type");
		
		Если (ContentType = "application/json") Или (ContentType = "application/javascript") Тогда
			ПараметрыОтвета = ЭлектроннаяПодписьВМоделиСервиса.JsonВСтруктуру(Ответ.ПолучитьТелоКакСтроку(), ПараметрыПреобразования);
			Для Каждого Поле Из СоответствиеПолейОтвета Цикл
				Если ПараметрыОтвета.Свойство(Поле.Ключ) Тогда
					Результат.Вставить(Поле.Значение, ПараметрыОтвета[Поле.Ключ]);
				КонецЕсли;
			КонецЦикла;
		ИначеЕсли ContentType = "application/octet-stream" Тогда
			Результат.Вставить("Файл", Ответ.ПолучитьТелоКакДвоичныеДанные());
			Результат.Вставить("Имя", СтрЗаменить(ОбщегоНазначенияБТС.ЗаголовокHTTP(Ответ, "Content-Disposition"), "attachment; filename=", ""));
		КонецЕсли;
	ИначеЕсли Ответ.КодСостояния = 400 Тогда
		Результат.Вставить("Выполнено", Ложь);
		ПараметрыОтвета = ЭлектроннаяПодписьВМоделиСервиса.JsonВСтруктуру(Ответ.ПолучитьТелоКакСтроку());
		Результат.Вставить("КодОшибки", ПолучитьКодОшибки(ПараметрыОтвета.err_code));
		Результат.Вставить("ОписаниеОшибки", СокрЛП(ПараметрыОтвета.err_msg));
	Иначе
		// @skip-check module-nstr-camelcase - ошибка проверки
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Электронная подпись в модели сервиса.Менеджер сервиса криптографии'", ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,, Ответ.ПолучитьТелоКакСтроку());
		Результат.Вставить("Выполнено", Ложь);
		Результат.Вставить("КодОшибки", "НеизвестнаяОшибка");
		Результат.Вставить("ОписаниеОшибки", НСтр("ru = 'Сервис временно недоступен. Обратитесь в службу поддержки или повторите попытку позже.'"));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьКодОшибки(err_code)
	
	КодыОшибок = Новый Соответствие;
	КодыОшибок.Вставить("CertificateNotFound", "СертификатНеНайден");
	КодыОшибок.Вставить("RequestNotFound", "ЗаявлениеНеНайдено");
	КодыОшибок.Вставить("NewPhoneIsEqualToTheCurrent", "НовыйТелефонРавенТекущему");
	КодыОшибок.Вставить("NewEmailIsEqualToTheCurrent", "НоваяЭлектроннаяПочтаРавнаТекущей");
	КодыОшибок.Вставить("MaxAttemptsInputCodeExceeded", "ПревышенЛимитПопытокВводаКода");
	КодыОшибок.Вставить("CodeExpired", "СрокДействияКодаИстек");
	КодыОшибок.Вставить("CodeIsWrong", "КодНеверный");
	КодыОшибок.Вставить("TooFrequentCodeRequests", "СлишкомЧастыеПовторныеОтправки");
	
	КодОшибки = КодыОшибок.Получить(err_code);
	Если Не ЗначениеЗаполнено(КодОшибки) Тогда
		КодОшибки = err_code;
	КонецЕсли;
	
	Возврат КодОшибки;
	
КонецФункции

#КонецОбласти

