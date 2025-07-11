﻿
#Область ПрограммныйИнтерфейс

#Область Криптобиблиотека

Функция НовыйЭкземплярКриптопровайдера(УникальныйИдентификаторФормыКлиента = Неопределено, РежимТишины = Ложь, ТолькоПодключение = Ложь) Экспорт
	
	Контейнер = ЭТДКлиентСервер.КонтейнерМетодов();
	
	Если Контейнер = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
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
			
			//внешнюю компоненту WSCrypto можно попробовать установить сразу
			Попытка
				ЭТДКлиентПереопределяемый.УстановитьКомпонентуWSCrypto(СсылкаНаМодуль);
				УдалосьПодключить = ПодключитьВнешнююКомпоненту(СсылкаНаМодуль, Контейнер.ИмяКомпонентыКриптографии(), ТипВнешнейКомпоненты.Native, ТипПодключенияВнешнейКомпоненты.НеИзолированно);
				Если УдалосьПодключить Тогда
					Криптопровайдер = Новый(Контейнер.ИмяОбъектаКриптографии());
				КонецЕсли;
			Исключение
				ЭТДВызовСервера.СоздатьЗаписьЖурналаРегистрации(
					НСтр("ru = 'Не удалось установить внешнюю компоненту работы с криптографией.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
					"Ошибка",,,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
			
		#КонецЕсли
		
	КонецЕсли;
	
	УдалитьИзВременногоХранилища(СсылкаНаМодуль);
	
	Если НЕ ТолькоПодключение И ЭТДКлиентСервер.ПолучитьТекущуюВерсиюМакета() > СтрЗаменить(Криптопровайдер.Версия, ",", ".") Тогда 
		ВызватьИсключение НСтр("ru = 'Новая версия библиотеки работы с NCA Layer загружена в информационную базу, требуется обновление на компьютере пользователя. Обновление доступно в настройках электронных трудовых договоров.'");
	КонецЕсли;
	
	Возврат Криптопровайдер;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
