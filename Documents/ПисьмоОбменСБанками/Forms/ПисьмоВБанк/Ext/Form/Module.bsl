﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();

	Элементы.УдалитьСчет.Видимость = Ложь;
	Если ЗначениеЗаполнено(Объект.СчетОрганизации) Тогда
		Счет = Объект.СчетОрганизации;
	Иначе
		Счет = НСтр("ru = '<не указан>'");
	КонецЕсли;
	
	МаксимальныйРазмерВложений = 2097152; // 2 мегабайта
	
	ЭтоНовый = НЕ ЗначениеЗаполнено(Объект.Ссылка);
	Элементы.ПричинаОтклонения.Видимость = Ложь;
	Элементы.ФормаСохранитьИнформациюДляТехническойПоддержки.Видимость = Ложь;
	
	Если ЭтоНовый Тогда
		Объект.Статус = Перечисления.СтатусыОбменСБанками.Черновик;
		Объект.Идентификатор = Новый УникальныйИдентификатор;
		Объект.Направление = Перечисления.НаправленияЭД.Исходящий;
		ОснованиеПисьма = Неопределено;
		Если Параметры.Свойство("ЗначениеЗаполнения", ОснованиеПисьма) Тогда // ответ
		
			РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОснованиеПисьма,
				"Тема, Текст, ДляВалютногоКонтроля, Организация, Банк, ВходящийНомер, ВходящаяДата, ТипПисьма, Направление, Дата, Номер, СчетОрганизации");
			Объект.Тема = "RE: " + РеквизитыОснования.Тема;
			Объект.Основание = ОснованиеПисьма;
			Объект.ДляВалютногоКонтроля = РеквизитыОснования.ДляВалютногоКонтроля;
			Объект.Организация = РеквизитыОснования.Организация;
			Объект.Банк = РеквизитыОснования.Банк;
			Объект.СчетОрганизации = РеквизитыОснования.СчетОрганизации;
			
			Если РеквизитыОснования.Направление = Перечисления.НаправленияЭД.Входящий Тогда
				НомерОснования = РеквизитыОснования.ВходящийНомер;
				ДатаОснования = РеквизитыОснования.ВходящаяДата;
				ТекстПисьма = НСтр("ru = 'Письмо из банка №%1 от %2
										|Тип письма: %3
										|Тема: %4'");
			Иначе
				НомерОснования = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(РеквизитыОснования.Номер);
				ДатаОснования = РеквизитыОснования.Дата;
				ТекстПисьма = НСтр("ru = 'Письмо в банк №%1 от %2
										|Тип письма: %3
										|Тема: %4'");
			КонецЕсли;
			
			Объект.Текст = Символы.ПС + Символы.ПС + Символы.ПС;
			ТекстПисьма = СтрШаблон(ТекстПисьма, НомерОснования, ДатаОснования, РеквизитыОснования.ТипПисьма,
				РеквизитыОснования.Тема) + Символы.ПС + Символы.ПС + РеквизитыОснования.Текст;
			Для Счетчик = 1 По СтрЧислоСтрок(ТекстПисьма) Цикл
				ТекСтрока = СтрПолучитьСтроку(ТекстПисьма, Счетчик);
				Объект.Текст = Объект.Текст + Символы.ПС + "| " + ТекСтрока;
			КонецЦикла;
			
			МассивФайлов = Новый Массив;
			РаботаСФайлами.ЗаполнитьПрисоединенныеФайлыКОбъекту(ОснованиеПисьма, МассивФайлов);
			Для каждого ЭлементКоллекции Из МассивФайлов Цикл
				Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементКоллекции, "ПометкаУдаления") Тогда
					Продолжить;
				КонецЕсли;
				ДанныеФайла = РаботаСФайлами.ДанныеФайла(ЭлементКоллекции, УникальныйИдентификатор);
				НовСтрока = ПрисоединенныеФайлыТаблица.Добавить();
				НовСтрока.Наименование = ДанныеФайла.ИмяФайла;
				НовСтрока.Размер = ДанныеФайла.Размер;
				НовСтрока.Хранение = ДанныеФайла.СсылкаНаДвоичныеДанныеФайла;
			КонецЦикла;
			
			ОформитьПрисоединенныеФайлы();
			
		ИначеЕсли Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			
			МассивФайлов = Новый Массив;
			РаботаСФайлами.ЗаполнитьПрисоединенныеФайлыКОбъекту(Параметры.ЗначениеКопирования, МассивФайлов);
			Для каждого ЭлементКоллекции Из МассивФайлов Цикл
				Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементКоллекции, "ПометкаУдаления") Тогда
					Продолжить;
				КонецЕсли;
				ДанныеФайла = РаботаСФайлами.ДанныеФайла(ЭлементКоллекции, УникальныйИдентификатор);
				НовСтрока = ПрисоединенныеФайлыТаблица.Добавить();
				НовСтрока.Наименование = ДанныеФайла.ИмяФайла;
				НовСтрока.Размер = ДанныеФайла.Размер;
				НовСтрока.Хранение = ДанныеФайла.СсылкаНаДвоичныеДанныеФайла;
			КонецЦикла;
			
			ОформитьПрисоединенныеФайлы();
			
		ИначеЕсли ЗначениеЗаполнено(Параметры.Основание) Тогда

			Объект.Основание = Параметры.Основание;
			РеквизитыОбъекта = ОбменСБанкамиСлужебныйВызовСервера.РеквизитыОснованияПисьма(Параметры.Основание);
			Объект.СчетОрганизации = РеквизитыОбъекта.Счет;
			Объект.Организация = РеквизитыОбъекта.Организация;
			Объект.Банк = РеквизитыОбъекта.Банк;
			НастройкаОбмена = ОбменСБанками.НастройкаОбмена(Объект.Организация, Объект.Банк);
			Если ЗначениеЗаполнено(НастройкаОбмена) Тогда
				Если НЕ ОбменСБанкамиСлужебныйВызовСервера.ЕстьПоддержкаВидаЭД(НастройкаОбмена, Перечисления.ВидыЭДОбменСБанками.Письмо) Тогда
					ТекстСообщения = НСтр("ru = 'Банк не поддерживает прием писем через 1С:ДиректБанк'");
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , , Отказ);
					Возврат;
				КонецЕсли;
			Иначе
				ШаблонСообщения = НСтр("ru = 'Не найдена действующая настройка обмена 1С:ДиректБанк по параметрам:
											|Организация: %1
											|Банк: %2'");
				ТекстСообщения = СтрШаблон(ШаблонСообщения, Объект.Организация, Объект.Банк);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , , Отказ);
				Возврат;
			КонецЕсли;
		КонецЕсли;
	Иначе
		МассивФайлов = Новый Массив;
		РаботаСФайлами.ЗаполнитьПрисоединенныеФайлыКОбъекту(Объект.Ссылка, МассивФайлов);
		Для каждого ЭлементКоллекции Из МассивФайлов Цикл
			Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементКоллекции, "ПометкаУдаления") Тогда
				Продолжить;
			КонецЕсли;
			ДанныеФайла = РаботаСФайлами.ДанныеФайла(ЭлементКоллекции, УникальныйИдентификатор);
			НовСтрока = ПрисоединенныеФайлыТаблица.Добавить();
			НовСтрока.Ссылка = ЭлементКоллекции;
			НовСтрока.Наименование = ДанныеФайла.ИмяФайла;
			НовСтрока.РазмерКБ = Формат(ЭлементКоллекции.Размер / 1024, "ЧДЦ=1") + " " + НСтр("ru = 'Кб'");
			НовСтрока.Сохранен = Истина;
			НовСтрока.Удалить = Объект.Статус <> Перечисления.СтатусыОбменСБанками.Черновик;
			НовСтрока.Размер = ДанныеФайла.Размер;
		КонецЦикла;
		Если Объект.Статус = Перечисления.СтатусыОбменСБанками.ОтклоненБанком Тогда
			ПоказатьПричинуОтклонения();
		КонецЕсли;
		Если ЗначениеЗаполнено(СообщениеОбмена) Тогда
			Элементы.ФормаСохранитьИнформациюДляТехническойПоддержки.Видимость = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Основание) Тогда
		Основание = Объект.Основание;
		Если Не ТолькоПросмотрПисьма Тогда
			Элементы.УдалитьОснование.Видимость = Истина;
		КонецЕсли;
	Иначе
		Основание = НСтр("ru = '<не указано>'");
		Элементы.УдалитьОснование.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.СчетОрганизации) Тогда
		Счет = Объект.СчетОрганизации;
		Элементы.УдалитьСчет.Видимость = Ложь;
	Иначе
		Счет = НСтр("ru = '<не указан>'");
	КонецЕсли;
	
	ОформитьПрисоединенныеФайлы();
	
	ОформитьШапкуФормы(ЭтоНовый, Отказ);
	
	Если ЗначениеЗаполнено(НастройкаОбмена) Тогда
		ИспользуетсяКриптография = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НастройкаОбмена, "ИспользуетсяКриптография");
	КонецЕсли;
	
	Элементы.ФормаПоказатьПодписи.Видимость = ИспользуетсяКриптография;
	
	УстановитьДоступностьЭлементов(
		ЭтотОбъект, Объект.Основание, Объект.СчетОрганизации, Объект.Организация, Объект.Банк);
		
	Элементы.УдалитьСчет.Видимость = НЕ ЗначениеЗаполнено(Объект.Основание)
		И ЗначениеЗаполнено(Объект.СчетОрганизации);
		
	ФайлыКУдалению = ПоместитьВоВременноеХранилище(Новый Массив, УникальныйИдентификатор);
	ОбновитьСтатусПисьма(Объект);
	Если Не ТолькоПросмотрПисьма Тогда
		Элементы.ТипПисьма.Доступность = ЗначениеЗаполнено(НастройкаОбмена);
	КонецЕсли;
	
	ПоказатьСкрытьТипПисьма(ЭтотОбъект, Объект.ДляВалютногоКонтроля);
	
	Элементы.ФормаПоместитьВКорзину.Видимость = Объект.Статус = Перечисления.СтатусыОбменСБанками.ОтклоненБанком
		И Не Объект.ПометкаУдаления;
		
	УстановитьНедоступностьПоРолям();
		
	// СтандартныеПодсистемы.Печать
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл" Тогда
		
		ПараметрыОтбора = Новый Структура("Ссылка", Источник);
		МассивСтрок = ПрисоединенныеФайлыТаблица.НайтиСтроки(ПараметрыОтбора);
		
		Если МассивСтрок.Количество() Тогда
			ПересчитатьРазмерФайла(Источник);
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ОбновитьСостояниеОбменСБанками" И Не Модифицированность Тогда
		
		Прочитать();
		
	КонецЕсли;
	
	// Обход ошибки проверки конфигурации
	Если Ложь Тогда
		Подключаемый_ВыполнитьКоманду(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ТолькоПросмотрПисьма = ТекущийОбъект.Статус <> Перечисления.СтатусыОбменСБанками.Черновик;
	
	Если ТолькоПросмотрПисьма Тогда
	
		Элементы.ФормаОтправить.Видимость = Ложь;
		Элементы.ГруппаОрганизацияБанк.ТолькоПросмотр = Истина;
		Элементы.ГруппаОснованиеСчет.ТолькоПросмотр = Истина;
		Элементы.ГруппаДобавлениеФайла.Видимость = Ложь;
		Элементы.ПрисоединенныеФайлыУдалить.Видимость = Ложь;
		Элементы.ПрисоединенныеФайлы.ТолькоПросмотр = Истина;
		Элементы.УдалитьОснование.Видимость = Ложь;
		Элементы.УдалитьСчет.Видимость = Ложь;
		Элементы.Организация.ТолькоПросмотр = Истина;
		Элементы.Банк.ТолькоПросмотр = Истина;
		Элементы.ТипПисьма.ТолькоПросмотр = Истина;
		Элементы.Тема.ТолькоПросмотр = Истина;
		Элементы.Текст.ТолькоПросмотр = Истина;
		Элементы.ДляВалютногоКонтроля.ТолькоПросмотр = Истина;
		
		Если НЕ ЗначениеЗаполнено(Объект.Основание) Тогда
			Элементы.Основание.Гиперссылка = Ложь;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Объект.СчетОрганизации) Тогда
			Элементы.БанковскийСчетОрганизации.Гиперссылка = Ложь;
		КонецЕсли;
			
	КонецЕсли;
	
	Если ТекущийОбъект.Статус = Перечисления.СтатусыОбменСБанками.ЧастичноПодписан Тогда
		Элементы.ФормаОтправить.Видимость = Истина;
		Элементы.ФормаОтправить.Доступность = Истина;
		Элементы.ФормаОтправить.Заголовок = НСтр("ru = 'Подписать, отправить'");
	ИначеЕсли ТекущийОбъект.Статус = Перечисления.СтатусыОбменСБанками.Подписан Тогда
		Элементы.ФормаОтправить.Видимость = Истина;
		Элементы.ФормаОтправить.Доступность = Истина;
		Элементы.ФормаОтправить.Заголовок = НСтр("ru = 'Отправить'");
	ИначеЕсли ИспользуетсяКриптография Тогда
		Элементы.ФормаОтправить.Заголовок = НСтр("ru = 'Подписать, отправить'");
	Иначе
		Элементы.ФормаОтправить.Заголовок = НСтр("ru = 'Отправить'");
	КонецЕсли;
	
	ОбновитьСтатусПисьма(ТекущийОбъект);
	
	Если ТекущийОбъект.Статус = Перечисления.СтатусыОбменСБанками.ОтклоненБанком Тогда
		ПоказатьПричинуОтклонения();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		СообщениеОбмена = ОбменСБанкамиСлужебный.СообщениеОбменаПоВладельцу(Объект.Ссылка);
		Если ЗначениеЗаполнено(СообщениеОбмена) Тогда
			Элементы.ФормаСохранитьИнформациюДляТехническойПоддержки.Видимость = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ФормаПоместитьВКорзину.Видимость = Объект.Статус = Перечисления.СтатусыОбменСБанками.ОтклоненБанком
		И Не Объект.ПометкаУдаления;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ЗначениеЗаполнено(ТекущийОбъект.Идентификатор) Тогда
		ТекущийОбъект.Идентификатор = Строка(Новый УникальныйИдентификатор);
	КонецЕсли;
	
	ТекущийОбъект.ЕстьВложение = ПрисоединенныеФайлыТаблица.Количество();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Сохранение добавленных файлов
	Для каждого ОписаниеФайла Из ПрисоединенныеФайлыТаблица Цикл
	
		Если НЕ ОписаниеФайла.Сохранен Тогда
			
			ПараметрыФайла = Новый Структура;
			ПараметрыФайла.Вставить("Автор", Пользователи.АвторизованныйПользователь());
			ПараметрыФайла.Вставить("ВладелецФайлов", Объект.Ссылка);
			СтруктураИмениФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ОписаниеФайла.Наименование);
			
			ПараметрыФайла.Вставить("ИмяБезРасширения", СтруктураИмениФайла.ИмяБезРасширения);
			РасширениеБезТочки = ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(СтруктураИмениФайла.Расширение);
			ПараметрыФайла.Вставить("РасширениеБезТочки", РасширениеБезТочки);
			ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное");
			ОписаниеФайла.Ссылка = РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, ОписаниеФайла.Хранение);
			ОписаниеФайла.Сохранен = Истина;
			
		КонецЕсли;
	
	КонецЦикла;
	
	// Удаление удаленных
	МассивКУдалению = ПолучитьИзВременногоХранилища(ФайлыКУдалению);
	Для Каждого ПрисоединенныйФайл Из МассивКУдалению Цикл
		ОбъектФайл = ПрисоединенныйФайл.ПолучитьОбъект();
		ОбъектФайл.УстановитьПометкуУдаления(Истина);
	КонецЦикла;
	
	// Сброс состояния ЭД
	Если Объект.Статус = Перечисления.СтатусыОбменСБанками.Черновик Тогда
		ОбменСБанкамиСлужебный.УстановитьНовуюВерсиюЭД(ТекущийОбъект.Ссылка, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДляВалютногоКонтроляПриИзменении(Элемент)
	
	ПоказатьСкрытьТипПисьма(ЭтотОбъект, Объект.ДляВалютногоКонтроля);
	
	Если ЗначениеЗаполнено(Объект.Основание) И ТипЗнч(Объект.Основание) = Тип("ДокументСсылка.ПисьмоОбменСБанками") Тогда
		ОснованиеСВалютнымКонтролем = ВалютныйКонтроль(Объект.Основание);
		Если Объект.ДляВалютногоКонтроля <> ОснованиеСВалютнымКонтролем Тогда
			УдалитьОснование();
			УдалитьСчетНажатие(Неопределено);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПисьмаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Основание) И ТипЗнч(Объект.Основание) = Тип("ДокументСсылка.ПисьмоОбменСБанками")
		И НЕ ДляВалютногоКонтроля(Объект.Основание) Тогда
			УдалитьОснование();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ТипПисьма) Тогда
		ТекстШаблона = ТекстШаблона(Объект.ТипПисьма);
		Если ЗначениеЗаполнено(ТекстШаблона) Тогда
			Если ПустаяСтрока(Объект.Текст) Тогда
				Объект.Текст = ТекстШаблона;
			Иначе
				ДополнительныеПараметры = Новый Структура("ТекстШаблона", ТекстШаблона);
				Оповещение = Новый ОписаниеОповещения("ПослеВопросаОЗаменеТекста", ЭтотОбъект, ДополнительныеПараметры);
				ТекстВопроса = НСтр("ru = 'Заменить текст письма шаблоном?'");
				ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Объект.СчетОрганизации = ВыбранноеЗначение;
		Счет = Объект.СчетОрганизации;
		Элементы.УдалитьСчет.Видимость = Истина;
		РеквизитыСчета = ОбменСБанкамиСлужебныйВызовСервера.РеквизитыБанковскогоСчетаОрганизации(ВыбранноеЗначение);
		Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
			Объект.Организация = РеквизитыСчета.Организация;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Объект.Банк) Тогда
			Объект.Банк = РеквизитыСчета.Банк;
		КонецЕсли;
		
		УстановитьДоступностьЭлементов(
			ЭтотОбъект, Объект.Основание, Объект.СчетОрганизации, Объект.Организация, Объект.Банк);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТемаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Модифицированность = Истина;
		Объект.Основание = ВыбранноеЗначение;
		Основание = ВыбранноеЗначение;
		Элементы.УдалитьОснование.Видимость = Истина;
		РеквизитыОбъекта = ОбменСБанкамиСлужебныйВызовСервера.РеквизитыОснованияПисьма(ВыбранноеЗначение);
		Объект.СчетОрганизации = РеквизитыОбъекта.Счет;
		
		Если ЗначениеЗаполнено(Объект.СчетОрганизации) Тогда
			Счет = Объект.СчетОрганизации;
			Элементы.УдалитьСчет.Видимость = Ложь;
		Иначе
			Счет = НСтр("ru = '<не указан>'");
		КонецЕсли;
		
		Объект.Организация = РеквизитыОбъекта.Организация;
		Элементы.Организация.ТолькоПросмотр = Истина;
		Если ЗначениеЗаполнено(РеквизитыОбъекта.Банк) Тогда
			Объект.Банк = РеквизитыОбъекта.Банк;
		КонецЕсли;
		
		УстановитьДоступностьЭлементов(
			ЭтотОбъект, Объект.Основание, Объект.СчетОрганизации, Объект.Организация, Объект.Банк);

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьОснованиеНажатие(Элемент)
	
	УдалитьОснование()
	
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Объект.Основание) Тогда
		
		ПоказатьЗначение( , Объект.Основание);
	Иначе
		
		СписокВыбора = СписокВыбораОснований();
		
		Оповещение = Новый ОписаниеОповещения("ПослеВыбораТипаОснования", ЭтотОбъект);
		ЗаголовокВыбора = НСтр("ru = 'Выберите тип основания письма'");
		СписокВыбора.ПоказатьВыборЭлемента(Оповещение, ЗаголовокВыбора);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскийСчетОрганизацииНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Объект.СчетОрганизации) Тогда
		ПоказатьЗначение( , Объект.СчетОрганизации);
	Иначе
		НазваниеСчетаВМетаданных = ОбменСБанкамиСлужебныйВызовСервера.НазваниеСчетаВМетаданных();
		Отбор = Новый Структура;
	
		Если ЗначениеЗаполнено(Объект.Организация) Тогда
			Отбор.Вставить("Организация", Объект.Организация);
			Отбор.Вставить("Владелец", Объект.Организация);
		Иначе
			Отбор.Вставить("СписокОрганизаций", Элементы.Организация.СписокВыбора.ВыгрузитьЗначения());
		КонецЕсли;
	
		Если ЗначениеЗаполнено(Объект.Банк) Тогда
			Отбор.Вставить("Банк", Объект.Банк);
		Иначе
			Отбор.Вставить("СписокБанков", Элементы.Банк.СписокВыбора.ВыгрузитьЗначения());
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура("Отбор", Отбор);
		ОткрытьФорму("Справочник." + НазваниеСчетаВМетаданных + ".ФормаВыбора", ПараметрыФормы, Элементы.Текст);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УдалитьСчетНажатие(Элемент)
	
	Объект.СчетОрганизации = Неопределено;
	Счет = НСтр("ru = '<не указан>'");
	Элементы.УдалитьСчет.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура БанкПриИзменении(Элемент)
	
	ПриИзмененииУчастника();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ПриИзмененииУчастника();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусНажатие(Элемент)
	
	Если Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыОбменСБанками.НеПодтвержден") Тогда
		ТестовыйРежим = Ложь;
		ПроверитьИспользованиеТестовогоРежима(ТестовыйРежим);
		Если ТестовыйРежим Тогда
			ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("http://194.54.14.120:9080/icdk");
		Иначе
			ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("https://sbi.sberbank.ru:9443/ic/dcb");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПрисоединенныеФайлы

&НаКлиенте
Процедура ПрисоединенныеФайлыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ПрисоединенныеФайлыУдалить" Тогда
		
		Модифицированность = Истина;
		ПараметрыОтбора = Новый Структура("Хранение", Элемент.ТекущиеДанные.Хранение);
		МассивСтрок = ПрисоединенныеФайлыТаблица.НайтиСтроки(ПараметрыОтбора);
		Если МассивСтрок.Количество() Тогда
			Строка = МассивСтрок.Получить(0);
			Если ЗначениеЗаполнено(Строка.Ссылка) Тогда
				МассивФайловКУдалению = ПолучитьИзВременногоХранилища(ФайлыКУдалению);
				МассивФайловКУдалению.Добавить(Строка.Ссылка);
				ФайлыКУдалению = ПоместитьВоВременноеХранилище(МассивФайловКУдалению, УникальныйИдентификатор);
			КонецЕсли;
			ПрисоединенныеФайлыТаблица.Удалить(Строка);
		КонецЕсли;
		
	ИначеЕсли Поле.Имя = "ПрисоединенныеФайлыНаименование" Тогда
		
		ПараметрыОтбора = Новый Структура("Хранение", Элемент.ТекущиеДанные.Хранение);
		МассивСтрок = ПрисоединенныеФайлыТаблица.НайтиСтроки(ПараметрыОтбора);
		Если МассивСтрок.Количество() Тогда
			Строка = МассивСтрок.Получить(0);
			Если ЗначениеЗаполнено(Строка.Ссылка) Тогда
				ДанныеФайла = ДанныеФайла(Строка.Ссылка, УникальныйИдентификатор);
				РаботаСФайламиКлиент.СохранитьФайлКак(ДанныеФайла);
			Иначе
				Записать();
				ДанныеФайла = ДанныеФайла(Строка.Ссылка, УникальныйИдентификатор);
				РаботаСФайламиКлиент.СохранитьФайлКак(ДанныеФайла);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ОформитьПрисоединенныеФайлы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьПодписи(Команда)
	
	ОчиститьСообщения();
	ПараметрыФормы = Новый Структура("Объект", Объект.Ссылка);
	ОткрытьФорму("Документ.ПисьмоОбменСБанками.Форма.Подписи", ПараметрыФормы, , , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИнформациюДляТехническойПоддержки(Команда)
	
	ОчиститьСообщения();
	СсылкаНаФайл = Неопределено; ИмяФайла = Неопределено;
	ПолучитьФайлДляТехническойПоддержки(Объект.Ссылка, УникальныйИдентификатор, СсылкаНаФайл, ИмяФайла);
	
	Если СсылкаНаФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПолучитьФайл(СсылкаНаФайл, ИмяФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	
	ОчиститьСообщения();
	
	Если Модифицированность ИЛИ НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Записать();
	КонецЕсли;
	
	Отказ = Ложь;
	
	Если Объект.ДляВалютногоКонтроля И Не ЗначениеЗаполнено(Объект.Основание) Тогда
		ТекстСообщения = НСтр("ru = 'В письме для целей валютного контроля должно быть указано основание.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Основание", , Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстСообщения = НСтр("ru = 'Укажите организацию'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.Организация", , Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Банк) Тогда
		ТекстСообщения = НСтр("ru = 'Укажите банк'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.Банк", , Отказ);
	КонецЕсли;
	
	ОбщийРазмер = ПрисоединенныеФайлыТаблица.Итог("Размер");
	
	Если ОбщийРазмер > МаксимальныйРазмерВложений Тогда
		Шаблон = НСтр("ru = 'Превышен объем вложений на %1 Кб.
							|Письмо не может быть отправлено.'");
		ТекстСообщения = СтрШаблон(Шаблон, Формат((ОбщийРазмер - МаксимальныйРазмерВложений) / 1024, "ЧДЦ=1"));
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "ПрисоединенныеФайлыТаблица", , Отказ);
	КонецЕсли;
	
	Если ПустаяСтрока(Объект.Тема) Тогда
		ТекстСообщения = НСтр("ru = 'Необходимо заполнить тему письма'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.Тема", , Отказ);
	КонецЕсли;
	
	Если ПустаяСтрока(Объект.Текст) Тогда
		ТекстСообщения = НСтр("ru = 'Текст письма не может быть пустым'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.Текст", , Отказ);
	КонецЕсли;
	
	Если СтрДлина(Объект.Текст) > 8000 Тогда
		ШаблонСообщения = НСтр("ru = 'Слишком большой текст письма.
									|Текущая длина: %1
									|Допустимая длина: 8000'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, СтрДлина(Объект.Текст));
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.Текст", , Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыОбменСБанками.ЧастичноПодписан") Тогда
		МассивСсылок = ЭлектронноеВзаимодействиеСлужебныйКлиент.МассивПараметров(Объект.Ссылка);
		ОбменСБанкамиСлужебныйКлиент.ОбработатьЭД(МассивСсылок, "ПодписатьОтправить");
	Иначе
		ОбменСБанкамиКлиент.СформироватьПодписатьОтправитьЭД(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайлы(Команда)
	
	ОчиститьСообщения();
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
	ПослеЗагрузкиФайлов = Новый ОписаниеОповещения("ПослеЗагрузкиФайлов", ЭтотОбъект);
	ФайловаяСистемаКлиент.ЗагрузитьФайлы(ПослеЗагрузкиФайлов, ПараметрыЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьВКорзину(Команда)
	
	ОчиститьСообщения();
	УстановитьПометкуУдаления(Объект.Ссылка);
	Оповестить("ОбновитьСостояниеОбменСБанками");
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКакЧерновик(Команда)
	
	ОчиститьСообщения();
	Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеЗагрузкиФайлов(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ОписаниеФайла Из ПомещенныеФайлы Цикл
		
		ДобавитьПрисоединенныйФайлВТаблицу(ОписаниеФайла.Хранение, ОписаниеФайла.Имя);
		
	КонецЦикла;
	
	ОформитьПрисоединенныеФайлы();
	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВалютныйКонтроль(Знач Письмо)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Письмо, "ДляВалютногоКонтроля");
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	// Тип письма недоступен пока не определена настройка обмена
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТипПисьма.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкаОбмена");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПроверитьИспользованиеТестовогоРежима(ТестовыйРежим)
	
	ОбменСБанкамиПереопределяемый.ПроверитьИспользованиеТестовогоРежима(ТестовыйРежим);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВопросаОЗаменеТекста(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.Текст = ДополнительныеПараметры.ТекстШаблона;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьПометкуУдаления(Ссылка)
	
	ОбъектПисьмо = Ссылка.ПолучитьОбъект();
	ОбъектПисьмо.УстановитьПометкуУдаления(Истина);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьСкрытьТипПисьма(Форма, ДляВалютногоКонтроля)
	
	Форма.Элементы.ТипПисьма.Видимость = Не ДляВалютногоКонтроля;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДляВалютногоКонтроля(Знач Письмо)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Письмо, "ДляВалютногоКонтроля");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементов(Форма, Основание, Счет, Организация, Банк)

	Если ЗначениеЗаполнено(Основание) ИЛИ ЗначениеЗаполнено(Счет) Тогда
		Форма.Элементы.Организация.ТолькоПросмотр = ЗначениеЗаполнено(Организация);
		Форма.Элементы.Банк.ТолькоПросмотр = ЗначениеЗаполнено(Банк);
	Иначе
		Форма.Элементы.Организация.ТолькоПросмотр = Ложь;
		Форма.Элементы.Банк.ТолькоПросмотр = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УдалитьОснование()
	
	Объект.Основание = Неопределено;
	Основание = НСтр("ru = '<не указано>'");
	Элементы.УдалитьОснование.Видимость = Ложь;
	
	Если ЗначениеЗаполнено(Объект.СчетОрганизации) Тогда
		Элементы.УдалитьСчет.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТекстШаблона(Знач ТипПисьма)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТипПисьма, "Шаблон");
	
КонецФункции

&НаСервереБезКонтекста
Процедура ПолучитьФайлДляТехническойПоддержки(Знач Письмо, Знач УникальныйИдентификатор, СсылкаНаФайл, ИмяФайла)
	
	СообщениеОбмена = ОбменСБанкамиСлужебный.СообщениеОбменаПоВладельцу(Письмо);
	
	Если Не ЗначениеЗаполнено(СообщениеОбмена) Тогда
		ТекстСообщения = НСтр("ru = 'Не найден электронный документ'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ДвоичныеДанныеФайла = ОбменСБанкамиСлужебный.ДанныеФайлаДляТехническойПоддержки(СообщениеОбмена);
	
	Если ДвоичныеДанныеФайла = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Не обнаружен присоединенный файл объекта.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, СообщениеОбмена);
		Возврат;
	КонецЕсли;
	
	ИмяФайла = Строка(СообщениеОбмена);
	ИмяФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайла) + ".zip";
	ИмяФайла = СтроковыеФункции.СтрокаЛатиницей(ИмяФайла);
	
	СсылкаНаФайл = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьПричинуОтклонения()

	СообщениеОбмена = ОбменСБанкамиСлужебный.СообщениеОбменаПоВладельцу(Объект.Ссылка);
	Если ЗначениеЗаполнено(СообщениеОбмена) Тогда
		ПричинаОтклонения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СообщениеОбмена, "ПричинаОтклонения");
		Элементы.ПричинаОтклонения.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьРазмерФайла(Знач ПрисоединенныйФайл)
	
	Для каждого ЭлементКоллекции Из ПрисоединенныеФайлыТаблица Цикл
		
		Если ЭлементКоллекции.Ссылка = ПрисоединенныйФайл Тогда
			
			ДанныеФайла = РаботаСФайлами.ДанныеФайла(ПрисоединенныйФайл, УникальныйИдентификатор);
			ЭлементКоллекции.Размер = ДанныеФайла.Размер;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОформитьПрисоединенныеФайлы();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатусПисьма(ТекущийОбъект)
	
	Элементы.Статус.Заголовок = ТекущийОбъект.Статус;
	
	Если ТекущийОбъект.Статус = Перечисления.СтатусыОбменСБанками.Отправлен Тогда
		Элементы.Статус.Заголовок = НСтр("ru = 'Письмо отправлено'");
	ИначеЕсли ТекущийОбъект.Статус = Перечисления.СтатусыОбменСБанками.Доставлен Тогда
		Элементы.Статус.Заголовок = НСтр("ru = 'Письмо доставлено'");
	ИначеЕсли ТекущийОбъект.Статус = Перечисления.СтатусыОбменСБанками.Принят Тогда
		Элементы.Статус.Заголовок = НСтр("ru = 'Письмо принято'");
	ИначеЕсли ТекущийОбъект.Статус = Перечисления.СтатусыОбменСБанками.НеПодтвержден Тогда
		Элементы.Статус.Заголовок = НСтр("ru = 'Подписать документ в личном кабинете банка'");
	ИначеЕсли ТекущийОбъект.Статус = Перечисления.СтатусыОбменСБанками.ОтклоненБанком Тогда
		Элементы.Статус.Заголовок = НСтр("ru = 'Отклонено банком'");
		Элементы.Статус.ЦветТекста = ЦветаСтиля.ПоясняющийОшибкуТекст;
	КонецЕсли;
	
	Элементы.Статус.Гиперссылка = ТекущийОбъект.Статус = Перечисления.СтатусыОбменСБанками.НеПодтвержден;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораТипаОснования(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НазваниеДокументаВМетаданных = ОбменСБанкамиСлужебныйВызовСервера.НазваниеОбъектаВМетаданных(
		ВыбранныйЭлемент.Значение);
	ПараметрыФормы = Новый Структура;
	Отбор = Новый Структура;
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		Отбор.Вставить("Организация", Объект.Организация);
	Иначе
		Отбор.Вставить("СписокОрганизаций", Элементы.Организация.СписокВыбора.ВыгрузитьЗначения());
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Банк) Тогда
		Отбор.Вставить("Банк", Объект.Банк);
	Иначе
		Отбор.Вставить("СписокБанков", Элементы.Банк.СписокВыбора.ВыгрузитьЗначения());
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Основание) И ЗначениеЗаполнено(Объект.СчетОрганизации) Тогда
		Отбор.Вставить("СчетОрганизации", Объект.СчетОрганизации);
	КонецЕсли;
	
	Если Объект.ДляВалютногоКонтроля Тогда
		Отбор.Вставить("ДляВалютногоКонтроля", Объект.ДляВалютногоКонтроля);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("Отбор", Отбор);
	
	ОткрытьФорму("Документ." + НазваниеДокументаВМетаданных + ".ФормаВыбора", ПараметрыФормы, Элементы.Тема);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СписокВыбораОснований()
	
	СписокВозврата = Новый СписокЗначений;
	
	ПлатежноеПоручение = ОбменСБанкамиСлужебный.ИмяПрикладногоРеквизита("ПлатежноеПоручениеВМетаданных", Ложь);
	
	Если ЗначениеЗаполнено(ПлатежноеПоручение) Тогда
		СписокВозврата.Добавить(Тип("ДокументСсылка." + ПлатежноеПоручение));
	КонецЕсли; 
	
	СписокВозврата.Добавить(Тип("ДокументСсылка.ПисьмоОбменСБанками"));
	
	Возврат СписокВозврата;
	
КонецФункции

&НаСервере
Процедура ОформитьШапкуФормы(ЭтоНовый, Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НастройкиОбменСБанкамиИсходящиеДокументы.Ссылка.Организация КАК Организация,
	|	НастройкиОбменСБанкамиИсходящиеДокументы.Ссылка.Банк КАК Банк
	|ИЗ
	|	Справочник.НастройкиОбменСБанками.ИсходящиеДокументы КАК НастройкиОбменСБанкамиИсходящиеДокументы
	|ГДЕ
	|	НастройкиОбменСБанкамиИсходящиеДокументы.ИсходящийДокумент = ЗНАЧЕНИЕ(Перечисление.ВидыЭДОбменСБанками.Письмо)
	|	И НЕ НастройкиОбменСБанкамиИсходящиеДокументы.Ссылка.ПометкаУдаления
	|	И НЕ НастройкиОбменСБанкамиИсходящиеДокументы.Ссылка.Недействительна";
	
	ТаблицаРезультата = Запрос.Выполнить().Выгрузить();
	
	Если ЭтоНовый И НЕ ТаблицаРезультата.Количество() Тогда
		ТекстОшибки = НСтр("ru = 'Отсутствуют действующие настройки обмена 1С:ДиректБанк со Сбербанком.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , , , Отказ);
		Возврат;
	КонецЕсли;
	
	МассивОрганизаций = ТаблицаРезультата.ВыгрузитьКолонку("Организация");
	
	Элементы.Организация.СписокВыбора.ЗагрузитьЗначения(ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивОрганизаций));
	
	МассивБанков = ТаблицаРезультата.ВыгрузитьКолонку("Банк");
	
	Элементы.Банк.СписокВыбора.ЗагрузитьЗначения(ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивБанков));
	
	Если Элементы.Организация.СписокВыбора.Количество() = 1 Тогда
		Объект.Организация = Элементы.Организация.СписокВыбора.Получить(0).Значение;
		Элементы.Организация.Видимость = Ложь;
	КонецЕсли;
	
	Если Элементы.Банк.СписокВыбора.Количество() = 1 Тогда
		Объект.Банк = Элементы.Банк.СписокВыбора.Получить(0).Значение;
		Элементы.Банк.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Организация) И ЗначениеЗаполнено(Объект.Банк) Тогда
		НастройкаОбмена = ОбменСБанками.НастройкаОбмена(Объект.Организация, Объект.Банк);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПрисоединенныйФайлВТаблицу(АдресФайла, ИмяФайла)
	
	ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(АдресФайла);
	Размер = ДвоичныеДанныеФайла.Размер();
	СтруктураФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ИмяФайла);
	Если Размер > МаксимальныйРазмерВложений Тогда
		ТекстСообщения = НСтр("ru = 'Размер файла %1 превышает допустимый.
									|Текущий размер: %2 байт.
									|Максимальный размер: %3 байт.'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, СтруктураФайла.Имя, Размер, МаксимальныйРазмерВложений);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;

	НовСтрока = ПрисоединенныеФайлыТаблица.Добавить();
	НовСтрока.Размер = Размер;
	НовСтрока.Хранение = АдресФайла;
	НовСтрока.Наименование = СтруктураФайла.Имя;
	НовСтрока.Сохранен = Ложь;
	НовСтрока.РазмерКБ = Формат(НовСтрока.Размер / 1024, "ЧДЦ=1") + " " + НСтр("ru = 'Кб'");
	
КонецПроцедуры

&НаСервере
Процедура ОформитьПрисоединенныеФайлы()
	
	ОбщийРазмер = ПрисоединенныеФайлыТаблица.Итог("Размер");
	
	Если ОбщийРазмер > 0 Тогда
		ЗаголовокФайлов = НСтр("ru = 'Файлы, %1 Кб'");
		ЗаголовокФайлов = СтрШаблон(ЗаголовокФайлов, Формат(ОбщийРазмер / 1024, "ЧДЦ=1"));
	Иначе
		ЗаголовокФайлов = НСтр("ru = 'Файлы'");
	КонецЕсли;
	
	Элементы.ПрисоединенныеФайлыНаименование.Заголовок = ЗаголовокФайлов;
	
	Если ОбщийРазмер > МаксимальныйРазмерВложений Тогда
		Шаблон = НСтр("ru = 'Превышен объем вложений на %1 Кб.'");
		Элементы.Остаток.Заголовок = СтрШаблон(Шаблон, Формат((ОбщийРазмер - МаксимальныйРазмерВложений) / 1024, "ЧДЦ=1"));
		Элементы.Остаток.ЦветТекста = ЦветаСтиля.ПоясняющийОшибкуТекст;
	ИначеЕсли ОбщийРазмер < МаксимальныйРазмерВложений Тогда
		Шаблон = НСтр("ru = 'Доступно %1 Кб.'");
		Элементы.Остаток.Заголовок = СтрШаблон(Шаблон, Формат((МаксимальныйРазмерВложений - ОбщийРазмер) / 1024, "ЧДЦ=1"));
		Элементы.Остаток.ЦветТекста = ЦветаСтиля.РезультатУспехЦвет;
	Иначе
		Элементы.Остаток.Заголовок = "";
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриИзмененииУчастника()
	
	Объект.ТипПисьма = Справочники.ТипыПисемОбменСБанками.ПустаяСсылка();
	ИспользуетсяКриптография = Ложь;
	Если ЗначениеЗаполнено(Объект.Организация) И ЗначениеЗаполнено(Объект.Банк) Тогда
		НастройкаОбмена = ОбменСБанками.НастройкаОбмена(Объект.Организация, Объект.Банк);
		ИспользуетсяКриптография = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НастройкаОбмена, "ИспользуетсяКриптография");
	Иначе
		НастройкаОбмена = Справочники.НастройкиОбменСБанками.ПустаяСсылка();
	КонецЕсли;
	Элементы.ФормаПоказатьПодписи.Видимость = ИспользуетсяКриптография;
	Элементы.ТипПисьма.Доступность = ЗначениеЗаполнено(НастройкаОбмена);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеФайла(Знач ПрисоединенныйФайл, Знач УникальныйИдентификатор)
	
	Возврат РаботаСФайлами.ДанныеФайла(ПрисоединенныйФайл, УникальныйИдентификатор);
	
КонецФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервере
Процедура УстановитьНедоступностьПоРолям()
	
	Если Не ОбменСБанкамиСлужебный.ПравоОбработкиЭД() Тогда
		Элементы.ФормаОтправить.Доступность = Ложь;
		Элементы.ФормаПоместитьВКорзину.Доступность = Ложь;
		Элементы.ФормаСохранитьКакЧерновик.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


