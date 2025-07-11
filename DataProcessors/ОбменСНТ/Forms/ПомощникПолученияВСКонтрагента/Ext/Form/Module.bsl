﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВыбранныйКонтрагент = Неопределено;
	//Проверка, если вдруг свойство "Контрагент" будет отстутсвовать
	Если Параметры.Свойство("Контрагент") Тогда
		ВыбранныйКонтрагент = Параметры.Контрагент;
	КонецЕсли;
	
	ЗаполнитьСписокКонтрагентов(ВыбранныйКонтрагент);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокКонтрагентов(ВыбранныйКонтрагент)
	
	Запрос = Новый Запрос;
	ТекстЗапроса = СНТСерверПереопределяемый.ТекстЗапросаЗаполненияСпискаКонтрагентов();
		
	СоответсвиеИменРеквизитов = Новый Соответствие;
	СоответсвиеИменРеквизитов.Вставить("%КонтрагентИНН", "");
	
	ЭСФСерверПереопределяемый.ЗаполнитьСоответсвиеИменРеквизитовПолейЗапросов(СоответсвиеИменРеквизитов);
	ЭСФСервер.ЗаменитьИменаРеквизитовПолейЗапросов(ТекстЗапроса, СоответсвиеИменРеквизитов);
	
	Запрос.Текст = ТекстЗапроса;	
	РезультатЗапроса = Запрос.Выполнить();
	ЭтаФорма.Контрагенты.Загрузить(РезультатЗапроса.Выгрузить());
	
	Если ВыбранныйКонтрагент <> Неопределено Тогда
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Контрагент", ВыбранныйКонтрагент);
		
		НайденныйКонтрагент = Контрагенты.НайтиСтроки(ПараметрыОтбора);
		Если НайденныйКонтрагент <> Неопределено Тогда
			НайденныйКонтрагент[0].ВыбратьКонтрагента = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьВиртуальныеСкладыКонтрагентаНаСервере(Отказ)
	
	МассивВыбранныхВС = Новый Массив;
	ВыбратьВиртуальныеСкладыКонтрагентаДляСправочника(ПолученныеВС.ПолучитьЭлементы(), МассивВыбранныхВС);
	Если МассивВыбранныхВС.Количество() = 0 Тогда
		СообщениеПользователю = НСтр("ru = 'Отметьте полученные виртуальные склады контрагентов для продолжения.'");
		ЭСФКлиентСерверПереопределяемый.СообщитьПользователю(НСтр(СообщениеПользователю));
		Отказ = Истина;
		Возврат;
	Иначе
		СохранитьВиртуальныеСкладыКонтрагентаВСправочник(МассивВыбранныхВС);
	КонецЕсли; 
	
КонецПроцедуры

//Выбираем выделенные строки из временного дерева значений,
//для дальнейшего сохранения ВС в справочник ВиртуальныеСкладыКонтрагента. 
&НаСервереБезКонтекста 
Процедура ВыбратьВиртуальныеСкладыКонтрагентаДляСправочника(Строки, МассивВыбранныхВС)
	
	Для Каждого СтрокаДерева Из Строки Цикл
		ПодчиненныеСтроки = СтрокаДерева.ПолучитьЭлементы();
		Если ПодчиненныеСтроки.Количество() > 0 Тогда
			
			Для Каждого Строка Из ПодчиненныеСтроки Цикл
				Если Строка.ВыбратьДляСоздания Тогда
					МассивВыбранныхВС.Добавить(Строка);
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьВиртуальныеСкладыКонтрагентаВСправочник(ВыбранныеВС)
	
	СправочникВСКонтрагента = Справочники.ВиртуальныеСкладыКонтрагента;
	НекоторыеСкладыУДругогоКонтрагента = Ложь;
	СтрокаСкладов = "";
	КоличествоЗаписанных = 0;
	Для Каждого Склад Из ВыбранныеВС Цикл
		Если Склад.id <> Неопределено Тогда
			ЭлементСправочника = СправочникВСКонтрагента.НайтиПоРеквизиту("ИдентификаторСклада", Склад.id);
			Если НЕ ЗначениеЗаполнено(ЭлементСправочника) Тогда
				
				ЭлементСправочника = СправочникВСКонтрагента.СоздатьЭлемент();
				ЭлементСправочника.Контрагент = Склад.Контрагент;
				ЭлементСправочника.ИдентификаторСклада = Склад.id;
				ЭлементСправочника.Наименование = Склад.storeName;
				ЭлементСправочника.Адрес = Склад.address;
				ЭлементСправочника.Статус = ВСКлиентСервер.СтатусСклада_ИБ(Склад.status);
				
				Попытка
					ЭлементСправочника.Записать();
					ЗаполнитьЗначенияСвойств(ТаблицаСозданныхВС.Добавить(), Склад, "Контрагент, storeName, id, address, status, ПредставлениеСтатуса");
					КоличествоЗаписанных = КоличествоЗаписанных + 1;
				Исключение
					ТекстСообщения = ЭСФКлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(НСтр("ru='При записи справочника %1 произошла ошибка: %2'"),ЭлементСправочника, ОписаниеОшибки());
					ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				КонецПопытки;
				
			ИначеЕсли Склад.Контрагент <> ЭлементСправочника.Контрагент Тогда
				НекоторыеСкладыУДругогоКонтрагента = Истина;
				СтрокаСкладов = СтрокаСкладов + Символы.ПС + ЭлементСправочника.Наименование + НСтр("ru=' (Идентификатор склада: '") + ЭлементСправочника.ИдентификаторСклада + "), ";
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если КоличествоЗаписанных > 0 Тогда
		
		ТекстСообщения = НСтр("ru='Склады созданы'");
		ЭСФКлиентСерверПереопределяемый.СообщитьПользователю(ТекстСообщения);
		
	КонецЕсли; 
	
	Если НекоторыеСкладыУДругогоКонтрагента Тогда
		ТекстСообщения = ЭСФКлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(НСтр("ru = 'Склады не были созданы для текущего контрагента. Следующие склады уже присутствуют в системе и принадлежат другим контрагентам: %1'"), СтрокаСкладов);
		ЭСФКлиентСервер.СообщитьПользователю(ТекстСообщения);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВС(Команда)
	
	Если ПроверитьВыборКонтрагентаПользователем() Тогда
		ПолучитьВСКонтрагента();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВСКонтрагента()
	
	Контейнер = ЭСФКлиентСервер.КонтейнерМетодов();
	
	Если Не Контейнер.КриптопровайдерПодключается() Тогда
		Возврат;
	КонецЕсли;
	
	МассивВыбранныхКонтрагентов = ПолучитьВыбранныхКонтрагентов(Контрагенты);
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("МассивВыбранныхКонтрагентов", МассивВыбранныхКонтрагентов);
	
	ПолучитьСкладыКонтрагентаИзИСВС = Новый ОписаниеОповещения("ПолучитьСкладыКонтрагентаЗавершение", ЭтаФорма, ДополнительныеПараметры);
	
	ПараметрыФормы = Новый Структура("ТребуетсяВыборПрофиляИСЭСФ, ВызвавшийМодуль", Истина, ПредопределенноеЗначение("Перечисление.МодулиЭСФ.ВС"));
	
	Если ЭСФВызовСервера.ИспользоватьОткрытиеСессииСПодписью() И ЭСФВызовСервера.ИспользоватьВнешнююКриптографиюДляКомпоненты() Тогда
		ПараметрыФормы.Вставить("ТребуетсяВыборСертификатаВхода", Истина);
	КонецЕсли;
	
	ЭСФКлиент.ОткрытьФормуВводаДанныхИСЭСФ(ПолучитьСкладыКонтрагентаИзИСВС, ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСкладыКонтрагентаЗавершение(Результат = Неопределено, ДополнительныеПараметры) Экспорт
	
	//до перехода на сервер нужно получить ИД сессии на клиенте!
	//при этом учеть получение для каждого профиля
	Если НЕ ОткрытьСессиюСПодписьюДляПрофилей(Результат, , Истина) Тогда
		Возврат;
	КонецЕсли;
	ПолучитьСкладыКонтрагентаИзИСВС(Результат, ДополнительныеПараметры);
		
КонецПроцедуры

&НаСервере
Процедура ПолучитьСкладыКонтрагентаИзИСВС(ДанныеПрофиляИСЭСФ, ДополнительныеПараметры) Экспорт
	
	Если ДанныеПрофиляИСЭСФ <> Неопределено Тогда
		Для Каждого Элемент Из ДанныеПрофиляИСЭСФ Цикл
			ДанныеПрофиляИСЭСФ = Неопределено;
			ПрофильИСЭСФ = Элемент.Значение.ПрофильИСЭСФ;
			ПарольПрофиляИСЭСФ = Элемент.Значение.ПарольИСЭСФ;
			
			Если ДанныеПрофиляИСЭСФ = Неопределено Тогда
				ДанныеПрофиляИСЭСФ = ЭСФСервер.ДанныеПрофиляИСЭСФ(ПрофильИСЭСФ);
			КонецЕсли;
			
			Если ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации = "" Тогда
				ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации = ПарольПрофиляИСЭСФ;
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ДанныеПрофиляИСЭСФ) Тогда
				Возврат;	
			КонецЕсли;
			
			МассивКонтрагентов = ДополнительныеПараметры.МассивВыбранныхКонтрагентов;
			
			ВСКонтрагентов = СНТВызовСервера.ПолучитьВСКонтрагента(ДанныеПрофиляИСЭСФ, МассивКонтрагентов);
			
			Если ВСКонтрагентов <> Неопределено Тогда
				ВременнаяТаблицаВС = ТаблицаЗначенийВДеревоЗначений(ВСКонтрагентов);
				ЗначениеВРеквизитФормы(ВременнаяТаблицаВС, "ПолученныеВС");
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Перекидываем таблицу значений в дерево значений
Функция ТаблицаЗначенийВДеревоЗначений(ВСКонтрагентов)
	
	Запрос = Новый ПостроительЗапроса;
	Запрос.ИсточникДанных = Новый ОписаниеИсточникаДанных(ВСКонтрагентов);//передаем ТЗ
	
	Запрос.ИсточникДанных.Колонки.Контрагент.Измерение = Истина;//по этой колонке идет группировка
	
	Запрос.ЗаполнитьНастройки();
	Запрос.Выполнить();
	Дерево = Запрос.Результат.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	Возврат Дерево;
	
КонецФункции

&НаКлиенте
Процедура УстановитьВсеПометкиПоКонтрагентам(Команда)
	УстановитьСнятьВсеПометкиПоКонтрагентам(Истина);
	ЗаполнитьСпискиОтборыПоВыбраннымКонтрагентам();
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеПометкиПоКонтрагентам(Команда)
	УстановитьСнятьВсеПометкиПоКонтрагентам(Ложь);
	ЗаполнитьСпискиОтборыПоВыбраннымКонтрагентам();
КонецПроцедуры

Процедура УстановитьСнятьВсеПометкиПоКонтрагентам(Отметка)
	
	Для Каждого Строка Из Контрагенты Цикл
		Строка.ВыбратьКонтрагента = Отметка;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентыВыбратьКонтрагентаПриИзменении(Элемент)
	
	ЗаполнитьСпискиОтборыПоВыбраннымКонтрагентам();
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьВыборКонтрагентаПользователем()
	
	МассивВыбранныхКонтрагентов = ПолучитьВыбранныхКонтрагентов(Контрагенты);
	Если МассивВыбранныхКонтрагентов.Количество() = 0 Тогда
		Предупреждение(НСтр("ru='Выберите одного или нескольких контрагентов для продолжения.'"));
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьСпискиОтборыПоВыбраннымКонтрагентам()
	
	ПолученныеВС.ПолучитьЭлементы().Очистить();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьВыбранныхКонтрагентов(Контрагенты)
	
	ПараметрыОтбора = Новый Структура;
	МассивКонтрагентов = Новый Массив;
	
	ПараметрыОтбора.Вставить("ВыбратьКонтрагента", Истина);
	НайденныеСтроки = Контрагенты.НайтиСтроки(ПараметрыОтбора);
	
	Для Каждого Строка из НайденныеСтроки цикл
		МассивКонтрагентов.Добавить(Строка.Контрагент);
	КонецЦикла;
	
	Возврат МассивКонтрагентов;
	
КонецФункции

&НаКлиенте
Процедура УстановитьВсеПометкиПоСкладам(Команда)
	УстановитьСнятьВсеПометкиПоСкладамНаСервере(Истина);
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеПометкиПоСкладам(Команда)
	УстановитьСнятьВсеПометкиПоСкладамНаСервере(Ложь);
КонецПроцедуры	

&НаСервере
Процедура УстановитьСнятьВсеПометкиПоСкладамНаСервере(Отметка, Знач ТекущаяВетка = Неопределено)
	
	ЭлементыВетки = Неопределено;
	Если ТекущаяВетка <> Неопределено Тогда
		СтрокаДереваФормы = ПолученныеВС.НайтиПоИдентификатору(ТекущаяВетка);
		ЭлементыВетки = СтрокаДереваФормы.ПолучитьЭлементы();
	КонецЕсли; 
	
	УстановитьСнятьВсеПометкиПоВСКонтрагентаНаСервере(ПолученныеВС.ПолучитьЭлементы(), Отметка, ЭлементыВетки);
	
КонецПроцедуры	

&НаСервереБезКонтекста
Процедура УстановитьСнятьВсеПометкиПоВСКонтрагентаНаСервере(Строки, Отметка, Знач ТекущаяВетка = Неопределено)
	
	Если ТекущаяВетка = Неопределено Тогда
		
		Для Каждого СтрокаДерева Из Строки Цикл
			ПодчиненныеСтроки = СтрокаДерева.ПолучитьЭлементы();
			Если ПодчиненныеСтроки.Количество() > 0 Тогда
				СтрокаДерева.ВыбратьДляСоздания = Отметка;
				Для Каждого Строка Из ПодчиненныеСтроки Цикл
					Строка.ВыбратьДляСоздания = Отметка;
				КонецЦикла;
				
			КонецЕсли;
		КонецЦикла;
	Иначе
		Для Каждого Строка Из ТекущаяВетка Цикл
			Строка.ВыбратьДляСоздания = Отметка;
		КонецЦикла;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	ПерейтиНаСледующуюСтраницу = Истина;
	
	Если Элементы.ГруппаОбщая.ТекущаяСтраница = Элементы.ГруппаОбщая2 Тогда
		
		МассивВыбранныхКонтрагентов = ПолучитьВыбранныхКонтрагентов(Контрагенты);
		Если МассивВыбранныхКонтрагентов.Количество() = 0 Тогда
			СообщениеПользователю = НСтр("ru = 'Выберите одного или нескольких контрагентов для продолжения'");
			ЭСФКлиентСерверПереопределяемый.СообщитьПользователю(НСтр(СообщениеПользователю));
			ПерейтиНаСледующуюСтраницу = Ложь;
		Иначе
			Отказ = Ложь;
			СоздатьВиртуальныеСкладыКонтрагентаНаСервере(Отказ);
			Если Отказ Тогда
				ПерейтиНаСледующуюСтраницу = Ложь;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПерейтиНаСледующуюСтраницу Тогда
		
		МаксимальныйИндексСтраницы = Элементы.ГруппаОбщая.ПодчиненныеЭлементы.Количество() - 1;
		СледующаяСтраница = Элементы.ГруппаОбщая.ПодчиненныеЭлементы.Получить(ИндексТекущейСтраницы() + 1);
		Элементы.ГруппаОбщая.ТекущаяСтраница = СледующаяСтраница;
		ОбновитьПанельКнопокДалееЗакрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ИндексТекущейСтраницы()
	
	Возврат Элементы.ГруппаОбщая.ПодчиненныеЭлементы.Индекс(Элементы.ГруппаОбщая.ТекущаяСтраница);
	
КонецФункции

&НаКлиенте
Процедура ОбновитьПанельКнопокДалееЗакрыть()
	
	ИндексТекущейСтраницы = Элементы.ГруппаОбщая.ПодчиненныеЭлементы.Индекс(Элементы.ГруппаОбщая.ТекущаяСтраница);
	МаксимальныйИндексСтраницы = Элементы.ГруппаОбщая.ПодчиненныеЭлементы.Количество() - 1;
	
	Если ИндексТекущейСтраницы = 0 Тогда
		
		Элементы.СтраницыПодвал.ТекущаяСтраница = Элементы.СтраницаДалее;
		Элементы.Далее.КнопкаПоУмолчанию = Истина;
		
	Иначе
		
		Элементы.СтраницыПодвал.ТекущаяСтраница = Элементы.СтраницаГотово;
		Элементы.Готово.КнопкаПоУмолчанию = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ПолученныеВСВыбратьДляСозданияПриИзменении(Элемент)
	
	ТекущаяВеткаДерева = Элементы.ПолученныеВС.ТекущиеДанные;
	ИдентификаторСтроки = ТекущаяВеткаДерева.ПолучитьИдентификатор();
	Если ТекущаяВеткаДерева.ВыбратьДляСоздания Тогда
		УстановитьСнятьВсеПометкиПоСкладамНаСервере(Истина, ИдентификаторСтроки)
	Иначе
		УстановитьСнятьВсеПометкиПоСкладамНаСервере(Ложь, ИдентификаторСтроки)
	КонецЕсли;

КонецПроцедуры

#Область СессияСПодписью

&НаКлиенте
// Открывает сессии с подписью для переданных данных с профилей ИСЭСФ.
//
// Параметры:
//  ДанныеПрофилейИСЭСФ - Массив или Ссылка на справочник ПрофилиИСЭСФ,
//   по которым(му) происходит открытие сессий.
//  ТребуетсяОткрытиеСессииВС - Булево - если установлено значение Истина
//   дополнительно будет открыта сессия ВС для данных из ДанныеПрофилейИСЭСФ.
//
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ОткрытьСессиюСПодписьюДляПрофилей(ДанныеПрофилейИСЭСФ,ТребуетсяОткрытиеСессииВС = Ложь, ТолькоСессияВС = Ложь) Экспорт
	
	Если ТолькоСессияВС Тогда
		//только сессия вс
		ПараметрыОткрытияСессии = ЭСФКлиентСервер.ПолучитьПараметрыОткрытияСессииСПодписьюПоУмолчанию();
		ПараметрыОткрытияСессии.ИмяМодуля = "VS";
		Возврат ЭСФКлиент.ОткрытьСессиюСПодписьюДляПрофилей(ДанныеПрофилейИСЭСФ, ПараметрыОткрытияСессии);
	ИначеЕсли ТребуетсяОткрытиеСессииВС Тогда
		//сессии эсф и вс
		ПараметрыОткрытияСессии = ЭСФКлиентСервер.ПолучитьПараметрыОткрытияСессииСПодписьюПоУмолчанию();
		ПараметрыОткрытияСессии.ТребуетсяДополнительноеОткрытиеСессииВС = Истина;
		Возврат ЭСФКлиент.ОткрытьСессиюСПодписьюДляПрофилей(ДанныеПрофилейИСЭСФ, ПараметрыОткрытияСессии);
	Иначе
		//только сессия эсф
		Возврат ЭСФКлиент.ОткрытьСессиюСПодписьюДляПрофилей(ДанныеПрофилейИСЭСФ);
	КонецЕсли;
	Возврат Ложь;
	
КонецФункции


#КонецОбласти


