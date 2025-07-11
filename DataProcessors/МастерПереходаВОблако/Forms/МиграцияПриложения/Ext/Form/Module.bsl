﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем ЗакрытьБезусловно;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если РегламентныеЗаданияСервер.РаботаСВнешнимиРесурсамиЗаблокирована() Тогда
		ВызватьИсключение НСтр("ru = 'Работа со всеми внешними ресурсами (синхронизация данных, отправка почты и т.п.) заблокирована.'");
	КонецЕсли;
	
	АдресСервиса = ?(Сервис = "Другой", "", Сервис);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеПерехода());
	
	Если Состояние <> Перечисления.СостоянияМиграцииПриложения.Выполняется Тогда
		
		Наименование = СтрШаблон(НСтр("ru = '%1 (Миграция приложения)'"), Метаданные.Синоним);
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Пользователи.Ссылка КАК Ссылка,
		|	Пользователи.ИдентификаторПользователяИБ
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи";
	Результат = Запрос.Выполнить().Выгрузить();
	Если Результат.Количество() = 0 Тогда
		КоличествоШагов = 3;
	ИначеЕсли Результат.Количество() = 1 И Не ЗначениеЗаполнено(Результат[0].ИдентификаторПользователяИБ) Тогда
		КоличествоШагов = 3;
	Иначе
		КоличествоШагов = 4;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПриОткрытииФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Или ЗакрытьБезусловно = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Задание) Тогда
		Отказ = Истина;
		ПоказатьПредупреждениеУстановленМонопольныйРежим();
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаНачала) Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемОповещение", ЭтотОбъект);
	ТекстВопроса = НСтр("ru = 'Закрыть помощник?'");
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСозданиеПриложение Тогда
		НоваяСтраница = СтраницаСозданиеПриложениеДалее();
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОжидание Тогда
		НоваяСтраница = СтраницаОжиданиеДалее();
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРезультат Тогда
		НоваяСтраница = СтраницаРезультатДалее();
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОшибка Тогда
		НоваяСтраница = СтраницаОшибкаДалее();
	КонецЕсли;
	
	Если НоваяСтраница <> Неопределено Тогда
		ОткрытиеСтраницы(НоваяСтраница);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОжидание Тогда
	
		ОтменитьПереход();
		ОтключитьОбработчикОбновленияСтатусаПереходаВСервис();
		ПараметрыПриложения.Удалить(МиграцияПриложенийКлиент.ИмяФормыПереходаВСервис());
		
		ОткрытиеСтраницы(Элементы.СтраницаРезультат);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Страница = Элементы[СтекСтраниц[СтекСтраниц.Количество() - 2].Значение];
	Если Страница = Элементы.СтраницаПодтверждениеРегистрации Тогда
		Страница = Элементы[СтекСтраниц[СтекСтраниц.Количество() - 3].Значение];
	КонецЕсли;
	
	ОткрытиеСтраницы(Страница);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиСтраниц

&НаКлиенте
Процедура ОткрытиеСтраницы(Страница)
	
	Элементы.Далее.Видимость = Истина;
	Элементы.Далее.Доступность = Истина;
	Элементы.Далее.Заголовок = НСтр("ru = 'Далее'");
	
	Элементы.Отмена.Видимость = Ложь;
	Элементы.Отмена.Заголовок = НСтр("ru = 'Отмена'");
	
	Элементы.Назад.Видимость = Истина;
	
	НайденныйЭлемент = СтекСтраниц.НайтиПоЗначению(Страница.Имя);
	Если НайденныйЭлемент = Неопределено Тогда
		СтекСтраниц.Добавить(Страница.Имя);
	Иначе
		КоличествоПовторов = СтекСтраниц.Количество() - СтекСтраниц.Индекс(НайденныйЭлемент) - 1;
		Для НомерПовтора = 1 По КоличествоПовторов Цикл
			СтекСтраниц.Удалить(СтекСтраниц.Количество() - 1);
		КонецЦикла;
	КонецЕсли;
	ЭтоПереходНазад = НайденныйЭлемент <> Неопределено;
	
	Если Страница = Элементы.СтраницаСозданиеПриложение Тогда
		СтраницаСозданиеПриложениеОткрытие(ЭтоПереходНазад);
	ИначеЕсли Страница = Элементы.СтраницаОжидание Тогда
		СтраницаОжиданиеОткрытие(ЭтоПереходНазад);
	ИначеЕсли Страница = Элементы.СтраницаОшибка Тогда
		СтраницаОшибкаОткрытие(ЭтоПереходНазад);
	ИначеЕсли Страница = Элементы.СтраницаРезультат Тогда
		СтраницаРезультатОткрытие(ЭтоПереходНазад);
	КонецЕсли;
	
	Элементы.Страницы.ТекущаяСтраница = Страница;
	
КонецПроцедуры

&НаКлиенте
Функция СтраницаСозданиеПриложениеДалее()
	
	Отказ = Ложь;
	Если Не ЗначениеЗаполнено(Наименование) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Не заполнено поле ""Наименование""'"), , "Наименование", , Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НачатьПереход();
	
	Возврат Элементы.СтраницаОжидание;
	
КонецФункции

&НаКлиенте
Процедура СтраницаСозданиеПриложениеОткрытие(ЭтоПереходНазад)
	
	Заголовок = СтрШаблон(НСтр("ru = 'Шаг %1 из %1: Параметры создания приложения'"), КоличествоШагов);
	Элементы.Далее.Заголовок = НСтр("ru = 'Начать миграцию'");
	Элементы.Назад.Видимость = Ложь;
	
	Если Не ЗначениеЗаполнено(Наименование) Тогда
		Наименование = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СтраницаОжиданиеДалее()
	
	Задание = ЗапуститьМонопольноеЗавершение();
	
	Если ЗначениеЗаполнено(Задание) Тогда
		ЗаблокироватьВесьИнтерфейс();
		ПоказатьПредупреждениеУстановленМонопольныйРежим();
	Иначе
		Текст = НСтр("ru = 'Не удалось установить монопольный режим, необходимо завершение сеансов всех пользователей.'");
		ПоказатьПредупреждение(, Текст);
	КонецЕсли;

	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура СтраницаОжиданиеОткрытие(ЭтоПереходНазад)
	
	ПараметрыПриложения[МиграцияПриложенийКлиент.ИмяФормыПереходаВСервис()] = ЭтотОбъект;
	
	Элементы.Далее.Видимость = ТребуетсяМонопольныйРежим;
	Элементы.Далее.Заголовок = НСтр("ru = 'Завершить миграцию'");
	Элементы.Далее.Доступность = Не ЗначениеЗаполнено(Задание);
	Заголовок = ?(ЗначениеЗаполнено(Задание), 
		НСтр("ru = 'Завершение миграции...'"), 
		НСтр("ru = 'Выполняется миграция...'"));
	Элементы.Отмена.Видимость = Истина;
	Элементы.Назад.Видимость = Ложь;
	
	ПС = Символы.ПС;
	Таб = Символы.Таб;
	
	Строки = Новый Массив;
	Строки.Добавить(НСтр("ru = 'Адрес сервиса'") + ": ");
	Строки.Добавить(Новый ФорматированнаяСтрока(АдресСервиса, , , , АдресСервиса));
	Строки.Добавить(ПС);
	Строки.Добавить(СтрШаблон(НСтр("ru = 'Код абонента: %1'"), КодАбонента) + ПС);
	Строки.Добавить(СтрШаблон(НСтр("ru = 'Код приложения: %1'"), КодПриложения) + ПС);
	Строки.Добавить(НСтр("ru = 'Контакты обслуживающей организации'") + ":" + ПС);
	Строки.Добавить(Таб);
	Строки.Добавить(Таб + СтрШаблон(НСтр("ru = 'e-mail: %1'"), ОбслуживающаяОрганизацияЭлектроннаяПочта) + ПС);
	Строки.Добавить(Таб);
	Строки.Добавить(Таб + СтрШаблон(НСтр("ru = 'тел.: %1'"), ОбслуживающаяОрганизацияТелефон) + ПС);
	
	Элементы.ДекорацияИнформация.Заголовок = Новый ФорматированнаяСтрока(Строки);
	
	ПодключитьОбработчикОбновленияСтатусаПереходаВСервис();
	
КонецПроцедуры

&НаКлиенте
Функция СтраницаРезультатДалее()
	
	ОчиститьСостояниеВыгрузки();
	Закрыть();
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура СтраницаРезультатОткрытие(ЭтоПереходНазад)
	
	Заголовок = НСтр("ru = 'Результат миграции'");
	
	Элементы.Далее.Заголовок = НСтр("ru = 'Готово'");
	Элементы.Отмена.Видимость = Ложь;
	Элементы.Назад.Видимость = Ложь;
	
	Элементы.ДекорацияСсылка.Видимость = ЗначениеЗаполнено(АдресПриложения);
	Если ЗначениеЗаполнено(АдресПриложения) Тогда
		Элементы.ДекорацияСсылка.Заголовок = Новый ФорматированнаяСтрока(АдресПриложения, , , , АдресПриложения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СтраницаОшибкаДалее()
	
	ОчиститьСостояниеВыгрузки();
	ПараметрыПриложения.Удалить(МиграцияПриложенийКлиент.ИмяФормыПереходаВСервис());
	Закрыть();
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура СтраницаОшибкаОткрытие(ЭтоПереходНазад)
	
	Заголовок = НСтр("ru = 'Ошибка миграции'");
	
	Элементы.Далее.Заголовок = НСтр("ru = 'Готово'");
	Элементы.Отмена.Видимость = Ложь;
	Элементы.Назад.Видимость = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура НачатьПереход()
	
	МиграцияПриложений.ПроверитьСоставПланаОбмена();
	
	ДанныеПриложения = МиграцияПриложений.СоздатьПриложениеДляМиграции(
		ЭтотОбъект, Наименование, ЧасовойПоясСеанса(), ПраваПользователей, РасширенияДляВосстановления);
	КодПриложения = ДанныеПриложения.Код;
	
	ВыгружатьНастройкиПользователей = Новый Соответствие;
	Для Каждого ПравоПользователя Из ПраваПользователей Цикл
		Если ЗначениеЗаполнено(ПравоПользователя.Пользователь) Тогда
			ВыгружатьНастройкиПользователей.Вставить(ПравоПользователя.Пользователь, ПравоПользователя.Логин);
		КонецЕсли;
	КонецЦикла;
	
	ЗавершитьМиграциюАвтоматически = ВариантЗавершенияМиграции = 0;
	
	ДанныеОбслуживающейОрганизации = МиграцияПриложений.ДанныеОбслуживающейОрганизации(ЭтотОбъект);
	
	ОбслуживающаяОрганизацияЭлектроннаяПочта = ДанныеОбслуживающейОрганизации.ЭлектроннаяПочта;
	ОбслуживающаяОрганизацияТелефон = ДанныеОбслуживающейОрганизации.Телефон;
	
	ДополнительныеСвойства = Новый Структура;
	ДополнительныеСвойства.Вставить("АдресСервиса", АдресСервиса);
	ДополнительныеСвойства.Вставить("ОбслуживающаяОрганизацияЭлектроннаяПочта", ОбслуживающаяОрганизацияЭлектроннаяПочта);
	ДополнительныеСвойства.Вставить("ОбслуживающаяОрганизацияТелефон", ОбслуживающаяОрганизацияТелефон);
	ДополнительныеСвойства.Вставить("КодАбонента", КодАбонента);
	ДополнительныеСвойства.Вставить("КодПриложения", КодПриложения);
	
	МиграцияПриложений.НачатьВыгрузку(
		ДанныеПриложения.АдресПриложения, 
		ДанныеПриложения.Логин, 
		ДанныеПриложения.Пароль, 
		ВыгружатьНастройкиПользователей, 
		ЗавершитьМиграциюАвтоматически, 
		ДополнительныеСвойства);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеПерехода());
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьПереход()
	
	МиграцияПриложений.ОтменитьВыгрузку();
	ВыключитьМонопольныйРежим();
	Задание = Неопределено;
	АдресПриложения = "";
	ДатаЗавершения = ТекущаяДатаСеанса();
	Комментарий = НСтр("ru = 'Переход в сервис отменен'");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СостояниеПерехода()
	
	СостояниеПерехода = МиграцияПриложений.СостояниеВыгрузки();
	СостояниеПерехода.Вставить("ОсталосьВремени", НСтр("ru = 'Рассчитывается...'"));
	
	Если (СостояниеПерехода.Состояние = Перечисления.СостоянияМиграцииПриложения.Выполняется 
			Или СостояниеПерехода.Состояние = Перечисления.СостоянияМиграцииПриложения.ОжиданиеЗагрузки)
		И СостояниеПерехода.НомерОтправленногоСообщения >= 3 
		И СостояниеПерехода.ЗагруженоОбъектов <> 0 Тогда
		
		ОставшеесяВремя = (ТекущаяУниверсальнаяДата() - СостояниеПерехода.ДатаНачала) / 
			СостояниеПерехода.ЗагруженоОбъектов * СостояниеПерехода.ЗагрузитьОбъектов;
		
		Если ОставшеесяВремя <= 180 Тогда
			СостояниеПерехода.ОсталосьВремени = НСтр("ru = 'Несколько минут'");
		ИначеЕсли ОставшеесяВремя <= 3600 Тогда
			СостояниеПерехода.ОсталосьВремени = СтрШаблон(НСтр("ru = '~ %1 мин.'"), Окр(ОставшеесяВремя / 60));
		Иначе
			СостояниеПерехода.ОсталосьВремени = СтрШаблон(НСтр("ru = '~ %1 ч.'"), Окр(ОставшеесяВремя / 3600, 1));
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СостояниеПерехода.ДатаНачала) Тогда
		СостояниеПерехода.ДатаНачала = МестноеВремя(СостояниеПерехода.ДатаНачала, ЧасовойПоясСеанса());
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СостояниеПерехода.ДатаЗавершения) Тогда
		СостояниеПерехода.ДатаЗавершения = МестноеВремя(СостояниеПерехода.ДатаЗавершения, ЧасовойПоясСеанса());
	КонецЕсли;
	
	СостояниеПерехода.Вставить("Прогресс", 0);
	Если СостояниеПерехода.ЗагруженоОбъектов <> 0 Тогда
		СостояниеПерехода.Вставить("Прогресс", СостояниеПерехода.ЗагруженоОбъектов * 100 / 
			(СостояниеПерехода.ЗагрузитьОбъектов + СостояниеПерехода.ЗагруженоОбъектов));
	КонецЕсли;
	
	СостояниеПерехода.Вставить("ТекстСообщенийОтправленоОбработано", СтрШаблон(НСтр("ru = '%1 / %2'"), 
		СостояниеПерехода.НомерОтправленногоСообщения, СостояниеПерехода.НомерПринятогоСообщения));
	СостояниеПерехода.Вставить("ТекстОбъектовВыгруженоЗагружено", СтрШаблон(НСтр("ru = '%1 / %2'"), 
		СостояниеПерехода.ВыгруженоОбъектов, СостояниеПерехода.ЗагруженоОбъектов));
	СостояниеПерехода.Вставить("ТекстОсталосьВыгрузитьЗагрузить", СтрШаблон(НСтр("ru = '%1 / %2'"), 
		СостояниеПерехода.ИзмененоОбъектов, СостояниеПерехода.ЗагрузитьОбъектов));
	
	Возврат СостояниеПерехода;
	
КонецФункции

&НаКлиенте
Процедура ОбновлениеСтатусаПерехода() Экспорт
	
	ПрошлоеТребуетсяМонопольныйРежим = ТребуетсяМонопольныйРежим;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеПерехода());
	
	Если ЗначениеЗаполнено(ДатаЗавершения) Тогда
		
		Если ЗначениеЗаполнено(Задание) Тогда
			Если ВыключитьМонопольныйРежим() Тогда
				Задание = Неопределено;
				ОтключитьОбработчикОбновленияСтатусаПереходаВСервис();
				ПараметрыПриложения.Удалить(МиграцияПриложенийКлиент.ИмяФормыПереходаВСервис());
			КонецЕсли;
		КонецЕсли;
		
		Если Состояние = ПредопределенноеЗначение("Перечисление.СостоянияМиграцииПриложения.ЗавершенаСОшибкой") Тогда
			НоваяСтраница = Элементы.СтраницаОшибка;
		Иначе
			НоваяСтраница = Элементы.СтраницаРезультат;
		КонецЕсли;
		
		ОткрытиеСтраницы(НоваяСтраница);
		
		Если Не Открыта() Тогда
			Открыть();
		КонецЕсли;
		
	Иначе
		
		Элементы.Далее.Видимость = ТребуетсяМонопольныйРежим;
		Если ЗначениеЗаполнено(Задание) Тогда
			// Проверка запущенного задания
			Задание = ЗапуститьМонопольноеЗавершение();
		ИначеЕсли ТребуетсяМонопольныйРежим И ЗавершитьМиграциюАвтоматически Тогда
			// Попытка установки монопольного режима и в случае успеха нужно заблокировать весь интерфейс, 
			// чтобы пользователь не мог изменять данные.
			Задание = ЗапуститьМонопольноеЗавершение();
			Если ЗначениеЗаполнено(Задание) Тогда
				ЗаблокироватьВесьИнтерфейс();
			КонецЕсли;
		ИначеЕсли ТребуетсяМонопольныйРежим И Не ПрошлоеТребуетсяМонопольныйРежим И Не ЗавершитьМиграциюАвтоматически И Не Открыта() Тогда
			// Данные почти выгружены, осталось установить монопольный режим,
			// Для этого нужно показать форму, чтобы пользователь нажал кнопку.
			Открыть();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьСостояниеВыгрузки()
	
	РегистрыСведений.МиграцияПриложенийСостояниеВыгрузки.СоздатьНаборЗаписей().Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемОповещение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗакрытьБезусловно = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапуститьМонопольноеЗавершение()
	
	Попытка
		УстановитьМонопольныйРежим(Истина);
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
	Отбор = Новый Структура("Ключ, Состояние", "МиграцияПриложенийВыгрузка", СостояниеФоновогоЗадания.Активно);
	ЗапущенныеЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	Если ЗапущенныеЗадания.Количество() = 0 Тогда
		ПараметрыЗадания = Новый Массив;
		ПараметрыЗадания.Добавить(Истина);
		ФоновоеЗадание = ФоновыеЗадания.Выполнить("МиграцияПриложений.ЗаданиеВыгрузка", ПараметрыЗадания, "МиграцияПриложенийВыгрузка");
		Возврат ФоновоеЗадание.УникальныйИдентификатор;
	Иначе
		Возврат ЗапущенныеЗадания[0].УникальныйИдентификатор;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ВыключитьМонопольныйРежим()
	
	Попытка
		УстановитьМонопольныйРежим(Ложь);
	Исключение
		Возврат Ложь;
	КонецПопытки;

	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытииФормы(ПриНачалеРаботыСистемы = Ложь) Экспорт
	
	Если Состояние = ПредопределенноеЗначение("Перечисление.СостоянияМиграцииПриложения.ЗавершенаУспешно") Тогда
		НоваяСтраница = Элементы.СтраницаРезультат;
	ИначеЕсли Состояние = ПредопределенноеЗначение("Перечисление.СостоянияМиграцииПриложения.ЗавершенаСОшибкой") Тогда
		НоваяСтраница = Элементы.СтраницаОшибка;
	ИначеЕсли Состояние = ПредопределенноеЗначение("Перечисление.СостоянияМиграцииПриложения.Выполняется")
		Или Состояние = ПредопределенноеЗначение("Перечисление.СостоянияМиграцииПриложения.ОжиданиеЗагрузки") Тогда
		НоваяСтраница = Элементы.СтраницаОжидание;
	Иначе
		НоваяСтраница = Элементы.СтраницаСозданиеПриложение;
	КонецЕсли;
	
	ОткрытиеСтраницы(НоваяСтраница);
	
	Если ПриНачалеРаботыСистемы 
		И (ЗначениеЗаполнено(ДатаЗавершения) Или ТребуетсяМонопольныйРежим) 
		И Не Открыта() Тогда
		Открыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаблокироватьВесьИнтерфейс()
	
	Если Открыта() Тогда
		ОткрытиеСтраницы(Элементы.Страницы.ТекущаяСтраница);
	Иначе
		Открыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПредупреждениеУстановленМонопольныйРежим()
	
	Текст = НСтр("ru = 'Установлен монопольный режим, не закрывайте приложение до окончания миграции.'");
	ПоказатьПредупреждение(, Текст);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
