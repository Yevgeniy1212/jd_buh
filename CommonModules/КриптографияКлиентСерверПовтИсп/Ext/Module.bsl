﻿// При вызове функции из клиентского контекста с передачей управления на сервер
Функция НовыйКриптопровайдер(УникальныйИдентификаторФормыКлиента = Неопределено, РежимТишины = Ложь, ТолькоПодключение = Ложь) Экспорт
	
	Если Не ЭСФКлиентСерверПереопределяемый.ПроверитьВозможностьИспользованияКриптопровайдера() Тогда
		
		ТекстСообщения = НСтр("ru = 'Отмена создания криптопровайдера в связи с не поддерживаемой версией платформы и версией ОС.'");
		
		СистемнаяИнформация = Новый СистемнаяИнформация;
		ИнформацияОСистеме = Символы.ПС + НСтр("ru='Сведения об аппаратном и программном обеспечении:'");
		ИнформацияОСистеме = ИнформацияОСистеме + Символы.ПС + НСтр("ru='ОС:' ") + СистемнаяИнформация.ВерсияОС;
		ИнформацияОСистеме = ИнформацияОСистеме + Символы.ПС + НСтр("ru='Версия 1С:'") + СистемнаяИнформация.ВерсияПриложения;
		ИнформацияОСистеме = ИнформацияОСистеме + Символы.ПС + НСтр("ru='Тип платформы:'") + СистемнаяИнформация.ТипПлатформы;
		ИнформацияОСистеме = ИнформацияОСистеме + Символы.ПС + НСтр("ru='Тип процессора:'") + СистемнаяИнформация.Процессор;
		ТекстСообщения = ТекстСообщения + ИнформацияОСистеме;
		
		ЭСФВызовСервера.СоздатьЗаписьЖурналаРегистрации(
			НСтр("ru = 'КриптографияКлиентСерверПовтИсп.НовыйКриптопровайдер'"),
			"Ошибка",,,
			ТекстСообщения
		);
		
		Если РежимТишины Тогда
			Возврат Неопределено;
		Иначе
			ТекстИсключения = НСтр("ru = 'В информационных базах на ОС Linux под управлением платформы выше версии 8.3.21 не поддерживается работа прежней криптографической библиотеки 1.8.
				|Рекомендуется отказаться от использования прежней версии в настройках и использовать компоненту для работы со средствами криптографии НУЦ РК.'"
			);
			ВызватьИсключение ТекстИсключения;
		КонецЕсли;
		
	КонецЕсли;
	
	Контейнер = ЭСФКлиентСервер.КонтейнерМетодов();
	
	// Для сохранения ссылки в контексте перехода с клиента на сервер (в случае если криптопровацйдер создается на клиенте), 
	// выделение адреса ссылки происходит в контексте вызова (на клиенте)
	СсылкаНаМодуль = Контейнер.АдресБиблиотекиКриптографии(УникальныйИдентификаторФормыКлиента);
	
	УдалосьПодключить = ПодключитьВнешнююКомпоненту(СсылкаНаМодуль, Контейнер.ИмяКомпонентыКриптографии(), ТипВнешнейКомпоненты.Native, ТипПодключенияВнешнейКомпоненты.НеИзолированно); 
	
	Если УдалосьПодключить Тогда
		
		Криптопровайдер = Новый(Контейнер.ИмяОбъектаКриптографии());
		
	Иначе
		
		#Если Сервер ИЛИ ВнешнееСоединение Тогда
			Если РежимТишины Тогда
				Возврат Неопределено;
			Иначе				
				// Это сервер. На сервере НЕ требуется установка внешней компоненты перед подключением.	
				ВызватьИсключение НСтр("ru = 'Не удалось подключить внешнюю компоненту для работы с криптографией.'");
			КонецЕсли;
			
		#Иначе
			
			Если НЕ ТолькоПодключение Тогда
				
				// отказ от модальности, преполагаем только открытие формы установки криптографии.
				ОткрытьФорму(Контейнер.ПолноеИмяФормыУстановкаКриптографии());
				Возврат Неопределено;
				
			КонецЕсли;
			
		#КонецЕсли
		
	КонецЕсли;
	
	УдалитьИзВременногоХранилища(СсылкаНаМодуль);
	
	#Если Клиент Тогда
	Если НЕ ТолькоПодключение И НЕ Контейнер.ВерсияВнешнегоМодуляКриптографии() = СтрЗаменить(Криптопровайдер.Версия, ",", ".") Тогда 
		ОткрытьФорму("Обработка.ОбменЭСФ.Форма.ОбновлениеКомпонентыКриптографии");
		ВызватьИсключение НСтр("ru = 'Новая версия криптобиблиотеки загружена в информационную базу, требуется обновление на компьютере пользователя'");
	КонецЕсли;
	#КонецЕсли
	
	Возврат Криптопровайдер;
	
КонецФункции

Функция НовыйКриптопровайдерWSSocket(УникальныйИдентификаторФормыКлиента = Неопределено, РежимТишины = Ложь, ТолькоПодключение = Ложь) Экспорт
 	Контейнер = ЭСФКлиентСервер.КонтейнерМетодов();
	
	// Для сохранения ссылки в контексте перехода с клиента на сервер (в случае если криптопровацйдер создается на клиенте), 
	// выделение адреса ссылки происходит в контексте вызова (на клиенте)
	СсылкаНаМодуль = Контейнер.АдресБиблиотекиКриптографииНЦА(УникальныйИдентификаторФормыКлиента);
	
	УдалосьПодключить = ПодключитьВнешнююКомпоненту(СсылкаНаМодуль, Контейнер.ИмяКомпонентыКриптографииНЦА(), ТипВнешнейКомпоненты.Native, ТипПодключенияВнешнейКомпоненты.НеИзолированно); 
	
	Если УдалосьПодключить Тогда
		
		Криптопровайдер = Новый(Контейнер.ИмяОбъектаКриптографииНЦА());
		
	Иначе
		
		#Если Сервер ИЛИ ВнешнееСоединение Тогда
			Если РежимТишины Тогда
				Возврат Неопределено;
			Иначе				
				// Это сервер. На сервере НЕ требуется установка внешней компоненты перед подключением.	
				ВызватьИсключение НСтр("ru = 'Не удалось подключить внешнюю компоненту для работы с криптографией.'");
			КонецЕсли;
			
		#Иначе
			
			//Если НЕ ТолькоПодключение Тогда
				
				//внешнюю компоненту WSCrypto можно попробовать установить сразу
				Попытка
					УстановитьВнешнююКомпоненту(СсылкаНаМодуль);
					УдалосьПодключить = ПодключитьВнешнююКомпоненту(СсылкаНаМодуль, Контейнер.ИмяКомпонентыКриптографииНЦА(), ТипВнешнейКомпоненты.Native, ТипПодключенияВнешнейКомпоненты.НеИзолированно);
					Если УдалосьПодключить Тогда
						Криптопровайдер = Новый(Контейнер.ИмяОбъектаКриптографииНЦА());
					КонецЕсли;
				Исключение
					ЭСФВызовСервера.СоздатьЗаписьЖурналаРегистрации(
						НСтр("ru = 'Не удалось установить внешнюю компоненту работы с криптографией.'"), 
						"Ошибка",,,
						ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				КонецПопытки;
				
			//КонецЕсли;
			
		#КонецЕсли
		
	КонецЕсли;
	
	УдалитьИзВременногоХранилища(СсылкаНаМодуль);
	
	
	Если НЕ ТолькоПодключение И ЭСФКлиентСервер.ВерсияКомпонентыНЦАВБазе() > СтрЗаменить(Криптопровайдер.Версия, ",", ".") Тогда 
		ВызватьИсключение НСтр("ru = 'Новая версия библиотеки работы с NCA Layer загружена в информационную базу, требуется обновление на компьютере пользователя. Обновление доступно в настройках электронных счетов-фактур.'");
	КонецЕсли;
	
	Возврат Криптопровайдер;
	
КонецФункции

