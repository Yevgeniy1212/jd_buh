﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьТаблицуДанныеЭЦП();
	
	КомпонентаKalkan = ЭТДСервер.ИспользоватьВнешнююКриптографиюДляКомпоненты();
	ВыполнятьКриптографическиеОперацииНаКлиенте = ЭТДСерверПовтИсп.ВыполнятьКриптографическиеОперацииНаКлиенте();
	
	ДобавитьИнформациюОбИспользованииКриптографии();
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьТаблицуДанныеЭЦПСеансовымиДанными();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КлючИмяНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыполнятьКриптографическиеОперацииНаКлиенте Тогда
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ДиалогОткрытияФайла.Фильтр = НСтр("ru = 'ЭЦП (*.p12)|*.p12'");
		ДиалогОткрытияФайла.Заголовок = "Выбор сертификата ЭЦП";
		Если ДиалогОткрытияФайла.Выбрать() Тогда
			ОбработкаВыбораКлючаЗавершение(Истина, , ДиалогОткрытияФайла.ПолноеИмяФайла);
		Иначе
			Для Каждого СтрокаДанных Из ДанныеЭЦП Цикл
				СтруктурнаяЕдиницаТекст = Строка(СтрокаДанных.СтруктурнаяЕдиница);
				
				ТекстСообщения = НСтр("ru = 'Выберите файл сертификата (%1)'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтруктурнаяЕдиницаТекст);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "КлючИмя");
			КонецЦикла;
		КонецЕсли;
	Иначе
		ОбработкаВыбораКлючаЗавершение = Новый ОписаниеОповещения("ОбработкаВыбораКлючаЗавершение", ЭтаФорма);
		НачатьПомещениеФайла(ОбработкаВыбораКлючаЗавершение,,,, УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораКлючаЗавершение(Результат, Адрес, ВыбранноеИмяФайла = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ВыполнятьКриптографическиеОперацииНаКлиенте Тогда
		ИнформацияПоФайлу = ЭТДКлиент.ИнформацияПоФайлу(ВыбранноеИмяФайла);
		
		Если ВРег(ИнформацияПоФайлу.Расширение) <> ".P12" Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Файл должен иметь расширение ""*.p12"".'"));
			Возврат;
		КонецЕсли;
		
		Для Каждого СтрокаДанных Из ДанныеЭЦП Цикл
			СтрокаДанных.КлючИмя = ИнформацияПоФайлу.Имя;
			СтрокаДанных.КлючПолноеИмя = ВыбранноеИмяФайла;
			
			КлючИмя = ИнформацияПоФайлу.Имя;
		КонецЦикла;
	ИначеЕсли Результат = Истина Тогда
		ИнформацияПоФайлу = ЭТДКлиент.ИнформацияПоФайлу(ВыбранноеИмяФайла);
		
		Если ВРег(ИнформацияПоФайлу.Расширение) <> ".P12" Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Файл должен иметь расширение ""*.p12"".'"));
			Возврат;
		КонецЕсли;
		
		Для Каждого СтрокаДанных Из ДанныеЭЦП Цикл
			СтрокаДанных.КлючИмя = ИнформацияПоФайлу.Имя;
			СтрокаДанных.КлючПолноеИмя = ВыбранноеИмяФайла;
			СтрокаДанных.КлючBase64 = КлючBase64(Адрес);
			
			КлючИмя = ИнформацияПоФайлу.Имя;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапомнитьНаВремяСеансаПриИзменении(Элемент)
	
	Для Каждого СтрокаДанных Из ДанныеЭЦП Цикл
		СтрокаДанных.ЗапомнитьНаВремяСеанса = ЗапомнитьНаВремяСеанса;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	Для Каждого СтрокаДанных Из ДанныеЭЦП Цикл
		СтрокаДанных.Пароль = Пароль;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	СчетчикСтруктурныхЕдиниц = 0;
	
	ЕстьОшибки = Ложь;
	
	СоответствиеОрганизацийИНастроек = Новый Соответствие;
	
	Для Каждого СтрокаДанных Из ДанныеЭЦП Цикл
		
		СтруктурнаяЕдиницаТекст = Строка(СтрокаДанных.СтруктурнаяЕдиница);
		
		Если ПустаяСтрока(СтрокаДанных.КлючПолноеИмя) Тогда
			ТекстСообщения = НСтр("ru = 'Выберите файл сертификата (%1)'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтруктурнаяЕдиницаТекст);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "КлючИмя");
			ЕстьОшибки = Истина;
		КонецЕсли;
		
		Если ПустаяСтрока(СтрокаДанных.Пароль) И КомпонентаKalkan Тогда
			ТекстСообщения = НСтр("ru = 'Укажите пароль сертификата (%1)'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтруктурнаяЕдиницаТекст);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Пароль");
			ЕстьОшибки = Истина;
		КонецЕсли;
		
		СчетчикСтруктурныхЕдиниц = СчетчикСтруктурныхЕдиниц + 1;
		
	КонецЦикла;
	
	Если ЕстьОшибки Тогда
		
		Возврат;
		
	Иначе
		
		Для Каждого СтрокаДанных Из ДанныеЭЦП Цикл
			
			Результат = Новый Структура;
			
			Результат.Вставить("Пароль", СтрокаДанных.Пароль);
			Результат.Вставить("КлючBase64", СтрокаДанных.КлючBase64);
			Результат.Вставить("АдресКлюча", СтрокаДанных.КлючПолноеИмя);
			
			СоответствиеОрганизацийИНастроек.Вставить(СтрокаДанных.СтруктурнаяЕдиница, Результат);
			
		КонецЦикла;
		
		// Запомнить введенные данные.
		СохранитьРасположениеКлючевогоКонтейнера();
		ЗапомнитьПарольКлючевогоКонтейнераНаВремяСеанса();
		Если ВыполнятьКриптографическиеОперацииНаКлиенте Тогда
			ЗапомнитьАдресКлючаНаВремяСеанса();
		Иначе
			ЗапомнитьКлючBase64НаВремяСеанса();
		КонецЕсли;
		
		Закрыть(СоответствиеОрганизацийИНастроек);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуДанныеЭЦП()
	
	Если Параметры.Свойство("СтруктурнаяЕдиница") Тогда
		СтрокаДанных = ДанныеЭЦП.Добавить();
		СтрокаДанных.СтруктурнаяЕдиница = Параметры.СтруктурнаяЕдиница;
		
		КлючПолноеИмя = СохраненноеРасположениеКлючевогоКонтейнера(Параметры.СтруктурнаяЕдиница);
		Если ЗначениеЗаполнено(КлючПолноеИмя) Тогда
			СтрокаДанных.КлючПолноеИмя = КлючПолноеИмя;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуДанныеЭЦПСеансовымиДанными()
	
	Для Каждого СтрокаДанных Из ДанныеЭЦП Цикл
		
		Если ВыполнятьКриптографическиеОперацииНаКлиенте Тогда
			ДанныеКлюча = АдресКлючаЗапомненныйНаВремяСеанса(СтрокаДанных.СтруктурнаяЕдиница);
			СтрокаДанных.КлючИмя = ДанныеКлюча.КлючИмя;
			СтрокаДанных.КлючПолноеИмя = ДанныеКлюча.КлючПолноеИмя;
			
			СтрокаДанных.Пароль = ПарольКлючевогоКонтейнераЗапомненныйНаВремяСеанса(СтрокаДанных.КлючИмя);
			
			Если НЕ ПустаяСтрока(СтрокаДанных.КлючПолноеИмя) Тогда
				СтрокаДанных.ЗапомнитьНаВремяСеанса = Истина;
				
				ЗапомнитьНаВремяСеанса = Истина;
			КонецЕсли;
		Иначе
			ДанныеКлюча = КлючBase64ЗапомненныйНаВремяСеанса(СтрокаДанных.СтруктурнаяЕдиница);
			СтрокаДанных.КлючИмя = ДанныеКлюча.КлючИмя;
			СтрокаДанных.КлючBase64 = ДанныеКлюча.КлючBase64;
			
			СтрокаДанных.Пароль = ПарольКлючевогоКонтейнераЗапомненныйНаВремяСеанса(СтрокаДанных.КлючИмя);
			
			Если НЕ ПустаяСтрока(СтрокаДанных.КлючBase64) Тогда
				СтрокаДанных.ЗапомнитьНаВремяСеанса = Истина;
				
				ЗапомнитьНаВремяСеанса = Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КлючBase64(Адрес)
	
	КлючДвоичныеДанные = ПолучитьИзВременногоХранилища(Адрес);
	КлючBase64 = Base64Строка(КлючДвоичныеДанные);
	
	Возврат КлючBase64;
	
КонецФункции

&НаСервере
Процедура УстановитьВидимость()
	
	Если КомпонентаKalkan Тогда
		Элементы.НадписьПарольНеИспользуется.Видимость = Ложь;
	Иначе
		Элементы.Пароль.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьИнформациюОбИспользованииКриптографии()
	
	ГруппаКриптография = Элементы.Вставить("ГруппаКомментарийМестоУстановкиБиблиотекиНаСервере",Тип("ГруппаФормы"),,Элементы.ДанныеКлюча);
	ГруппаКриптография.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаКриптография.Заголовок = "";
	ГруппаКриптография.Видимость = Ложь;
	ГруппаКриптография.РастягиватьПоВертикали = Ложь;
	ГруппаКриптография.РастягиватьПоГоризонтали = Ложь;
	ГруппаКриптография.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	ГруппаКриптография.ОтображатьЗаголовок = Ложь;
	ГруппаКриптография.Отображение = ОтображениеОбычнойГруппы.Нет;
	ГруппаКриптография.ЦветФона = Новый Цвет(255, 251, 227);
	ГруппаКриптография.СквозноеВыравнивание = СквозноеВыравнивание.Использовать;
	ГруппаКриптография.ВертикальноеПоложениеПодчиненных = ВертикальноеПоложениеЭлемента.Центр;
	
	НовыйЭлемент = Элементы.Вставить("КомментарийМестоУстановкиБиблиотекиНаСервере",Тип("ДекорацияФормы"),ЭтаФорма.Элементы.ГруппаКомментарийМестоУстановкиБиблиотекиНаСервере,Неопределено);
	НовыйЭлемент.Вид = ВидДекорацииФормы.Надпись;
	НовыйЭлемент.АвтоМаксимальнаяШирина = Ложь;
	НовыйЭлемент.МаксимальнаяШирина = 50;
	НовыйЭлемент.УстановитьДействие("ОбработкаНавигационнойСсылки", "КомментарийМестоУстановкиБиблиотекиНаСервереОбработкаНавигационнойСсылки");
	
	НовыйЭлемент = Элементы.Вставить("ДекорацияМестоУстановкиБиблиотекиНаСервере",Тип("ДекорацияФормы"),ЭтаФорма.Элементы.ГруппаКомментарийМестоУстановкиБиблиотекиНаСервере,ЭтаФорма.Элементы.КомментарийМестоУстановкиБиблиотекиНаСервере);
	НовыйЭлемент.Заголовок = "";
	НовыйЭлемент.Вид = ВидДекорацииФормы.Картинка;
	НовыйЭлемент.Картинка = БиблиотекаКартинок.Предупреждение;
	НовыйЭлемент.Высота = 1;
	НовыйЭлемент.Ширина = 2;
	
	ЭТДСервер.ПроверитьИспользованиеСервернойКриптографии(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийМестоУстановкиБиблиотекиНаСервереОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ЭТДКлиент.ОбработкаНавигационнойСсылкиМестоУстановкиБиблиотеки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сохранение и загрузка расположения ключевого контейнера

&НаСервере
Процедура СохранитьРасположениеКлючевогоКонтейнера()
	
	Для Каждого СтрокаДанных Из ДанныеЭЦП Цикл
	
		СоответствиеРасположений = ХранилищеОбщихНастроек.Загрузить(ИмяНастройкиРасположенияКлючевыхКонтейнеров());
		СоответствиеРасположений = ?(СоответствиеРасположений = Неопределено, Новый Соответствие(), СоответствиеРасположений); 
		
		СоответствиеРасположений.Вставить(СтрокаДанных.СтруктурнаяЕдиница, СтрокаДанных.КлючПолноеИмя);
		
		ХранилищеОбщихНастроек.Сохранить(ИмяНастройкиРасположенияКлючевыхКонтейнеров(), , СоответствиеРасположений);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СохраненноеРасположениеКлючевогоКонтейнера(Знач Организация)
	
	СоответствиеРасположений = ХранилищеОбщихНастроек.Загрузить(ИмяНастройкиРасположенияКлючевыхКонтейнеров());
	
	Если СоответствиеРасположений <> Неопределено Тогда
		Расположение = СоответствиеРасположений.Получить(Организация);
	КонецЕсли;
	
	Расположение = ?(Расположение = Неопределено, "", Расположение);
	
	Возврат Расположение;
	
КонецФункции

&НаСервере
Функция ИмяНастройкиРасположенияКлючевыхКонтейнеров()
	
	Возврат "РасположенияКлючевыхКонтейнеровДляЭТД";
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Сохранение и загрузка пароля ключевого контейнера.

&НаКлиенте
Процедура ЗапомнитьПарольКлючевогоКонтейнераНаВремяСеанса()
	
	ИмяСеансовыхДанных = ЭТДКлиент.ИмяСеансовыхДанныхПарольКлючевогоКонтейнераЭЦП();
	
	Для Каждого СтрокаДанных Из ДанныеЭЦП Цикл
		
		Если СтрокаДанных.ЗапомнитьНаВремяСеанса Тогда
			ЭТДКлиент.СохранитьСеансовыеДанные(ИмяСеансовыхДанных, СтрокаДанных.КлючИмя, СтрокаДанных.Пароль);
		Иначе
			ЭТДКлиент.УдалитьСеансовыеДанные(ИмяСеансовыхДанных, СтрокаДанных.КлючИмя);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПарольКлючевогоКонтейнераЗапомненныйНаВремяСеанса(Знач КлючИмя)
	
	ИмяСеансовыхДанных = ЭТДКлиент.ИмяСеансовыхДанныхПарольКлючевогоКонтейнераЭЦП();
	
	Пароль = ЭТДКлиент.ПолучитьСеансовыеДанные(ИмяСеансовыхДанных, КлючИмя, "");
	
	Возврат Пароль;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Сохранение и загрузка ключевого контейнера в формате Base64.
// Ключевой контейнер сохраняется в переменной сеанса пользователя.

&НаКлиенте
Процедура ЗапомнитьКлючBase64НаВремяСеанса()
	
	ИмяСеансовыхДанных = ЭТДКлиент.ИмяСеансовыхДанныхКлючBase64();
	
	Для Каждого СтрокаДанных Из ДанныеЭЦП Цикл
		
		ДанныеКлюча = Новый Структура;
		ДанныеКлюча.Вставить("КлючИмя", СтрокаДанных.КлючИмя);
		ДанныеКлюча.Вставить("КлючBase64", СтрокаДанных.КлючBase64);
		
		Если СтрокаДанных.ЗапомнитьНаВремяСеанса Тогда
			ЭТДКлиент.СохранитьСеансовыеДанные(ИмяСеансовыхДанных, СтрокаДанных.СтруктурнаяЕдиница, ДанныеКлюча); 
		Иначе
			ЭТДКлиент.УдалитьСеансовыеДанные(ИмяСеансовыхДанных, СтрокаДанных.СтруктурнаяЕдиница);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция КлючBase64ЗапомненныйНаВремяСеанса(Знач Организация)
	
	ИмяСеансовыхДанных = ЭТДКлиент.ИмяСеансовыхДанныхКлючBase64();
	
	ПустыеДанныеКлюча = Новый Структура;
	ПустыеДанныеКлюча.Вставить("КлючИмя", НСтр("ru = 'Выбрать сертификат...'"));
	ПустыеДанныеКлюча.Вставить("КлючBase64", "");
	
	ДанныеКлюча = ЭТДКлиент.ПолучитьСеансовыеДанные(ИмяСеансовыхДанных, Организация, ПустыеДанныеКлюча);
	
	КлючИмя = ДанныеКлюча.КлючИмя;
	
	Возврат ДанныеКлюча;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Сохранение и загрузка полного пути к ключевому контейнеру
// Путь сохраняется в переменной сеанса пользователя.

&НаКлиенте
Процедура ЗапомнитьАдресКлючаНаВремяСеанса()
	
	ИмяСеансовыхДанных = ЭТДКлиент.ИмяСеансовыхДанныхАдресКлюча();
	
	Для Каждого СтрокаДанных Из ДанныеЭЦП Цикл
		
		ДанныеКлюча = Новый Структура;
		ДанныеКлюча.Вставить("КлючИмя", СтрокаДанных.КлючИмя);
		ДанныеКлюча.Вставить("КлючПолноеИмя", СтрокаДанных.КлючПолноеИмя);
		
		Если СтрокаДанных.ЗапомнитьНаВремяСеанса Тогда
			ЭТДКлиент.СохранитьСеансовыеДанные(ИмяСеансовыхДанных, СтрокаДанных.СтруктурнаяЕдиница, ДанныеКлюча); 
		Иначе
			ЭТДКлиент.УдалитьСеансовыеДанные(ИмяСеансовыхДанных, СтрокаДанных.СтруктурнаяЕдиница);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция АдресКлючаЗапомненныйНаВремяСеанса(Знач Организация)
	
	ИмяСеансовыхДанных = ЭТДКлиент.ИмяСеансовыхДанныхАдресКлюча();
	
	ПустыеДанныеКлюча = Новый Структура;
	ПустыеДанныеКлюча.Вставить("КлючИмя", НСтр("ru = 'Выбрать сертификат...'"));
	ПустыеДанныеКлюча.Вставить("КлючПолноеИмя", "");
	
	ДанныеКлюча = ЭТДКлиент.ПолучитьСеансовыеДанные(ИмяСеансовыхДанных, Организация, ПустыеДанныеКлюча);
	
	КлючИмя = ДанныеКлюча.КлючИмя;
	
	Возврат ДанныеКлюча;
	
КонецФункции

#КонецОбласти
