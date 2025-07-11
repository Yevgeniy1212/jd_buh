﻿
#Область СлужебныеПроцедурыИФункции

// Проверяет, что включена ф.о "Использовать подключаемое оборудование" и авторизовался пользователь,
// а не внешний пользователь.
Функция ИспользоватьПодключаемоеОборудование() Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьПодключаемоеОборудование") И ТипЗнч(Пользователи.АвторизованныйПользователь()) = Тип("СправочникСсылка.Пользователи");
	
КонецФункции

//Функция возвращает ИИН пользователя информационной базы
// Параметры:
//  ПользовательИБ - Ссылка - Пользователь для которого нужно получить значение ИИН,
//														в случае если пользователь не передан - информация возвращается для текущего пользователя
//
// Возвращаемое значение:
//  ИИН - строкас текстом ИИН пользователя.
//
Функция ИННПользователяИБ(ПользовательИБ = Неопределено) Экспорт
	
	Если Не ПользовательИБ = Неопределено Тогда 
		Пользователь = ПользовательИБ;
	Иначе 
		//Функция БСП присутствует в конфигурациях использующих данную бибилотеку
		Пользователь = Пользователи.АвторизованныйПользователь();
	КонецЕсли;
	
	Если ТипЗнч(Пользователь) = Тип("СправочникСсылка.Пользователи") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Пользователи.Ссылка КАК Ссылка,
		|	ФизическиеЛица.ИдентификационныйКодЛичности КАК ИНН
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ФизическиеЛица
		|		ПО Пользователи.ФизЛицо = ФизическиеЛица.Ссылка
		|ГДЕ
		|	Пользователи.Ссылка = &Ссылка";
		Запрос.УстановитьПараметр("Ссылка", Пользователь);
		
		Результат = Запрос.Выполнить();
		Если Не Результат.Пустой() Тогда 
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			Возврат Выборка.ИНН;
		Иначе 
			Возврат "";
		КонецЕсли;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции 

//Процедура формирует временную таблицу ВТОрганизации в менеджер временных таблиц переданный в параметр МенеджерВТ, с отбором по переданным организациям, либо по БИН организации
//	Параметры:
//		Организация - Ссылка, МассивСсылок, Строка	 - Ссылка на элемент справочника организации, массив ссылок организаций либо строка БИН
//		МенеджерВТ - Менеджер временных таблиц	 - Менеджер временных таблиц в который помещается результирующая таблица
//	Результат выполнения:
//		В менеджер временных таблиц переданный в параметр МенеджерВТ формируется временная таблица с именем ВТОрганизации и одной колонкой Ссылка - типа ссылка на элемент справочника организации.
//		В данную таблицу помещается список Организаций с отбором по переданному в параметре Организации значению. Если входной параметр Организация = Неопределно , ворзвращается список всех доступных Организаций.
//
Процедура СформироватьВТПоОрганизацииСОтбором(Организация, МенеджерВТ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВТОрганизации
	|ИЗ
	|	Справочник.Организации КАК Организации
	|	&УсловиеОтбора";
	
	Если Организация = Неопределено Тогда
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеОтбора", "");
		
	ИначеЕсли ТипЗнч(Организация) = Тип("Массив") Тогда
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеОтбора", "ГДЕ
		|	Организации.Ссылка В(&ЗначениеОтбора)");
		
	ИначеЕсли ТипЗнч(Организация) = Тип("СправочникСсылка.Организации") Тогда
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеОтбора", "ГДЕ
		|	Организации.Ссылка = &ЗначениеОтбора");
		
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеОтбора", "ГДЕ
		|	Организации.ИдентификационныйНомер = &ЗначениеОтбора");
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ЗначениеОтбора", Организация);
	
	Запрос.Выполнить();
	
КонецПроцедуры

Функция ПолучитьИнформациюОЮрЛице() Экспорт
	
	КонтрагентДистрибьютор = Константы.ЕдиныйДистрибьюторЛСИСЦЭДМ.Получить();
	СведенияОЮрЛице = ОбщегоНазначенияБКВызовСервера.СведенияОЮрФизЛице(КонтрагентДистрибьютор, ТекущаяДатаСеанса());
	
	СведенияОЮрЛицеДляЗаполнения = Новый Структура();
	СведенияОЮрЛицеДляЗаполнения.Вставить("ИИНБИН", СведенияОЮрЛице.БИН_ИИН);
	СведенияОЮрЛицеДляЗаполнения.Вставить("ЮридическийАдрес", СведенияОЮрЛице.ЮридическийАдрес);
	СведенияОЮрЛицеДляЗаполнения.Вставить("Представление", СведенияОЮрЛице.Представление);
	
	Возврат СведенияОЮрЛицеДляЗаполнения;
	
КонецФункции

Функция ПолучитьЗначениеКонстантыОтображенияДанныхНоменклатурыСУЗ() Экспорт
	
	Возврат Константы.ОтображатьДанныеПоНоменклатуреВДокументахСУЗИСМПТК.Получить();
		
КонецФункции

Функция ПроверитьПоддержкуДвойногоФорматаТранспортныхКодов() Экспорт
	
	Возврат Константы.ПоддержкаДвойногоФорматаТранспортныхКодовИСМПТК.Получить();
	
КонецФункции 

Функция РазрешенаПовторнаяПечатьКодовМаркировки() Экспорт
	
	Возврат РаботаСДокументамиИСМПТКПереопределяемый.ПроверитьДоступностьРоли("ПравоСбросаФлагаПечатиЗаказаВПулеИСМПТК", ОбщегоНазначенияИСМПТККлиентСерверПереопределяемый.ТекущийПользователь());
	
КонецФункции

Функция РазрешеноПовторноеПолучениеКодовМаркировки() Экспорт
	
	Возврат РаботаСДокументамиИСМПТКПереопределяемый.ПроверитьДоступностьРоли("АдминистрированиеИСМПТК", ОбщегоНазначенияИСМПТККлиентСерверПереопределяемый.ТекущийПользователь());
	
КонецФункции

Функция ПроверитьЭтоТорговоеРешение() Экспорт
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	Возврат Ложь;
	
КонецФункции

Функция ОписаниеТипаЧисло(Разрядность, РазрядностьДробнойЧасти = 0, Знач ЗнакЧисла = Неопределено) Экспорт
	
	Возврат ОбщегоНазначения.ОписаниеТипаЧисло(Разрядность, РазрядностьДробнойЧасти, ЗнакЧисла);
	
КонецФункции

Функция ОписаниеТипаСтрока(ДлинаСтроки) Экспорт
	
	Возврат ОбщегоНазначения.ОписаниеТипаСтрока(ДлинаСтроки);
	
КонецФункции

Функция ОписаниеТипаДата(ЧастиДаты) Экспорт

	Возврат ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты);
	
КонецФункции

Функция СтрокаТаблицыЗначенийВСтруктуру(СтрокаТаблицыЗначений) Экспорт
	
	Возврат ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтрокаТаблицыЗначений);
	
КонецФункции

Функция ХранилищеОбщихНастроекЗагрузить(КлючОбъекта, КлючНастроек, ЗначениеПоУмолчанию = Неопределено, ОписаниеНастроек = Неопределено, ИмяПользователя = Неопределено) Экспорт
	
	Возврат ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(КлючОбъекта, КлючНастроек, ЗначениеПоУмолчанию, ОписаниеНастроек, ИмяПользователя);
	
КонецФункции

Процедура ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек = Неопределено, ИмяПользователя = Неопределено, ОбновитьПовторноИспользуемыеЗначения = Ложь) Экспорт
			
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек, ИмяПользователя, ОбновитьПовторноИспользуемыеЗначения);
	
 КонецПроцедуры

Процедура ПриНачалеВыполненияРегламентногоЗадания(РегламентноеЗадание = Неопределено) Экспорт

	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(РегламентноеЗадание);
	
КонецПроцедуры

Функция РазделениеВключено() Экспорт
	
	Возврат ОбщегоНазначения.РазделениеВключено();

КонецФункции

Функция НайтиЗадания(Отбор) Экспорт
	
	Возврат РегламентныеЗаданияСервер.НайтиЗадания(Отбор);
	
КонецФункции

Процедура ИзменитьЗадание(Знач Идентификатор, Знач Параметры) Экспорт

	РегламентныеЗаданияСервер.ИзменитьЗадание(Идентификатор, Параметры);
	
КонецПроцедуры

Функция ПодсистемаСуществует(ПолноеИмяПодсистемы) Экспорт
	
	Возврат ОбщегоНазначения.ПодсистемаСуществует(ПолноеИмяПодсистемы);
	
КонецФункции

Функция ОбщийМодуль(Имя) Экспорт

	Возврат ОбщегоНазначения.ОбщийМодуль(Имя); 
	
КонецФункции

Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат ОбновлениеИнформационнойБазыСлужебный.СобытиеЖурналаРегистрации();
	
КонецФункции

Функция ЭтоПолноправныйПользователь(Пользователь = Неопределено, ПроверятьПраваАдминистрированияСистемы = Ложь, УчитыватьПривилегированныйРежим = Истина) Экспорт
	
	Возврат Пользователи.ЭтоПолноправныйПользователь(Пользователь, ПроверятьПраваАдминистрированияСистемы, УчитыватьПривилегированныйРежим);
	
КонецФункции

Процедура УстановитьУсловноеОформлениеПоляДата(Форма, ПолноеИмяРеквизита = "Список.Дата", ИмяЭлемента = "Дата") Экспорт

	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(Форма, ПолноеИмяРеквизита, ИмяЭлемента);
	
КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Форма, Знач ПараметрыВызова, Знач Источник, Результат = Неопределено) Экспорт

	ПодключаемыеКоманды.ВыполнитьКоманду(Форма, ПараметрыВызова, Источник, Результат);
	
КонецПроцедуры

Процедура ЗаписатьДанные(Знач Данные, Знач РегистрироватьНаУзлахПлановОбмена = Неопределено, Знач ВключитьБизнесЛогику = Ложь) Экспорт
	
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(Данные, РегистрироватьНаУзлахПлановОбмена, ВключитьБизнесЛогику);
	
КонецПроцедуры

Функция ПараметрыВыполненияВФоне(Знач ИдентификаторФормы = Неопределено) Экспорт
	
	Возврат ДлительныеОперации.ПараметрыВыполненияВФоне(ИдентификаторФормы);
	
КонецФункции

Процедура ПолучитьДанныеКонтрагентаИзЕАЭС(ПерезаполнятьИИНБИНПоставщика, НалоговыйНомер, Поставщик) Экспорт
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	Если ЗначениеЗаполнено(Поставщик) Тогда
		Если ТипЗнч(Поставщик) = Тип("СправочникСсылка.Организации") Тогда
			НалоговыйНомер = СокрЛП(Поставщик.КодВСтранеРегистрации);
		ИначеЕсли ТипЗнч(Поставщик) = Тип("СправочникСсылка.Контрагенты") Тогда
			НалоговыйНомер = СокрЛП(Поставщик.НомерНалоговойРегистрацииВСтранеРезидентства);
		Иначе
			НалоговыйНомер = Неопределено;
		КонецЕсли;
	Иначе
		НалоговыйНомер = Неопределено;
	КонецЕсли;
	ПерезаполнятьИИНБИНПоставщика = ЗначениеЗаполнено(НалоговыйНомер);	
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Процедура ОбновлениеИБОтметитьКОбработке(Параметры, МассивСсылок) Экспорт
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
КонецПроцедуры

Функция ОбновлениеИБВыбратьСсылкиДляОбработки(Очередь, ПолноеИмяОбъекта) Экспорт
	
	Возврат ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Очередь, ПолноеИмяОбъекта);
	
КонецФункции

Процедура ОбновлениеИБЗаписатьДанные(ДокументОбъект) Экспорт
	
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДокументОбъект);
	
КонецПроцедуры

Процедура ОбновлениеИБОтметитьВыполнениеОбработки(ПереданнаяСсылка) Экспорт
	
	ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ПереданнаяСсылка);

КонецПроцедуры

Функция ОбновлениеИБОбработкаДанныхЗавершена(Очередь, ПолноеИмяОбъекта) Экспорт
	
	Возврат ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Очередь, ПолноеИмяОбъекта);
	
КонецФункции

#КонецОбласти

#Область РегистрШтрихкоды

Функция ПолучитьИмяНоменклатурыДляРегистраШтрихкоды()
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	Возврат "Номенклатура"; //"Владелец";
	
КонецФункции

Функция ПолучитьПредставлениеРегистраШтрихкоды() Экспорт
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	Возврат Метаданные.РегистрыСведений.ШтрихкодыНоменклатуры.Представление();
	
КонецФункции

// Входные параметры:
// УсловиеВыбора - строка - "ПЕРВЫЕ Х" или "РАЗРЕШЕННЫЕ"
// УсловияОтбора - массив - каждый элемент - Структура, где:
//		ИмяПараметра  - строка -
//		ВыборИзСписка - булево - определяем условие выбора (= или В)
Функция ПолучитьТекстЗапросаДляРегистраШтрихкодов(УсловиеВыбора = "", УсловияОтбора = "") Экспорт

	//ПЕРЕОПРЕДЕЛЕНИЕ//
	Текст = "ВЫБРАТЬ %условие%
	|	ДанныеШтрихкодов.Штрихкод КАК Штрихкод,
	|	ДанныеШтрихкодов.Номенклатура КАК Номенклатура,
	|	"""" КАК Характеристика,
	|	"""" КАК ЕдиницаИзмерения,
	|	ДанныеШтрихкодов.Номенклатура.Наименование КАК НоменклатураНаименование,
	|	"""" КАК ХарактеристикаНаименование,
	|	"""" КАК УпаковкаНаименование,
	|	ДанныеШтрихкодов.Номенклатура.БазоваяЕдиницаИзмерения КАК БазоваяЕдиницаИзмерения,
	|	ДанныеШтрихкодов.Номенклатура.ОсобенностьУчета КАК ОсобенностьУчета
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры КАК ДанныеШтрихкодов
	|";
	
	Текст = СтрЗаменить(Текст, "%условие%", УсловиеВыбора);
	Если ЗначениеЗаполнено(УсловияОтбора) Тогда
		ТекстУсловия = "";
		Для Каждого ЭлементОтбора Из УсловияОтбора Цикл
			ТекстЭтогоУсловия = "ДанныеШтрихкодов."
							  + ЭлементОтбора.ИмяПараметра
							  + ?(ЭлементОтбора.ВыборИзСписка,
							  	  " В (&" + ЭлементОтбора.ИмяПараметра + ")",
							  	  " = &" + ЭлементОтбора.ИмяПараметра)
							  + Символы.ПС;
			ТекстУсловия = ?(ЗначениеЗаполнено(ТекстУсловия), ТекстУсловия + "И " + ТекстЭтогоУсловия, ТекстЭтогоУсловия);
		КонецЦикла;
		Текст = Текст + "ГДЕ" + Символы.ПС + ТекстУсловия;		
	КонецЕсли;
	
	Возврат Текст;
	
КонецФункции

Функция ПолучитьСтруктуруДанныхДляРегистраШтрихкодов()
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	//Состав структуры изменяться не должен. Допускается передача неопределенного значения вместо ссылки.
	ДанныеШтрихкодов = Новый Структура();
	ДанныеШтрихкодов.Вставить("Номенклатура",     Справочники.Номенклатура.ПустаяСсылка());
	ДанныеШтрихкодов.Вставить("Характеристика",   "");
	ДанныеШтрихкодов.Вставить("ЕдиницаИзмерения", Справочники.КлассификаторЕдиницИзмерения.ПустаяСсылка());
	ДанныеШтрихкодов.Вставить("БазоваяЕдиницаИзмерения", Справочники.КлассификаторЕдиницИзмерения.ПустаяСсылка()); 
	ДанныеШтрихкодов.Вставить("Штрихкод", "");
	ДанныеШтрихкодов.Вставить("НоменклатураНаименование",   "");
	ДанныеШтрихкодов.Вставить("ХарактеристикаНаименование", "");
	ДанныеШтрихкодов.Вставить("УпаковкаНаименование", 		"");

	Возврат ДанныеШтрихкодов;
	
КонецФункции

// Входящие параметры:
// ВозвращатьВсе - булево - определяет нужно ли получить все сведения из регистра или только единственное значение
// Штрихкод - строка, массив, СписокЗначений - для отбора в регистре
// Номенклатура - Справочник.Номенклатура - для отбора в регистре
Функция ПолучитьДанныеНоменклатурыИзРегистраШтрихкодовПоШтрихкоду(ВозвращатьВсе = Ложь, Штрихкод, Номенклатура = Неопределено) Экспорт 
	
    УсловияОтбора = Новый Массив();
	УсловиеШтрихкод = Новый Структура();
	УсловиеШтрихкод.Вставить("ИмяПараметра",  "Штрихкод");
	УсловиеШтрихкод.Вставить("ВыборИзСписка", Не ТипЗнч(Штрихкод) = Тип("Строка"));
	УсловияОтбора.Добавить(УсловиеШтрихкод);
	Если Не Номенклатура = Неопределено Тогда
		ИмяПараметраНоменклатура = ПолучитьИмяНоменклатурыДляРегистраШтрихкоды();
		УсловиеНоменклатура = Новый Структура();
		УсловиеНоменклатура.Вставить("ИмяПараметра",  ИмяПараметраНоменклатура);
		УсловиеНоменклатура.Вставить("ВыборИзСписка", Ложь);
		УсловияОтбора.Добавить(УсловиеНоменклатура);
	КонецЕсли;
	
	Текст = ПолучитьТекстЗапросаДляРегистраШтрихкодов(, УсловияОтбора);
	
	Запрос = Новый Запрос();
	Запрос.Текст = Текст;
	Запрос.УстановитьПараметр("Штрихкод", Штрихкод);
	Если Не Номенклатура = Неопределено Тогда
		Запрос.УстановитьПараметр(ИмяПараметраНоменклатура, Номенклатура);
	КонецЕсли;
	
	Если ВозвращатьВсе Тогда
		Возврат Запрос.Выполнить().Выгрузить();
	Иначе
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Количество() = 0 Тогда
			Возврат Неопределено;
		Иначе
			Если Не Выборка.Количество() = 1 Тогда
				ТекстСообщения = НСтр("ru = 'Внимание! Штрихкод %1 зарегистрирован в базе более чем 1 раз. Номенклатура подобрана случайным образом из его списка зарегистрированных товаров.'");
				ТекстСообщения = ОбщегоНазначенияИСМПТККлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(ТекстСообщения, Штрихкод); 
				ОбщегоНазначенияИСМПТККлиентСерверПереопределяемый.СообщитьПользователю(ТекстСообщения);
			КонецЕсли;
			
			Выборка.Следующий();
			ДанныеШтрихкода = ПолучитьСтруктуруДанныхДляРегистраШтрихкодов();
			ЗаполнитьЗначенияСвойств(ДанныеШтрихкода, Выборка);
			Возврат ДанныеШтрихкода;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область Характеристики

Функция ПроверитьИспользованиеХарактеристик() Экспорт
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	Возврат Ложь;
	///////////////////
	   	
КонецФункции

Функция ПроверитьВедениеУчетаПоХарактеристикамУНоменклатуры(Номенклатура) Экспорт
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	Возврат Ложь;
	///////////////////
		
КонецФункции

#КонецОбласти

#Область Номенклатура

Функция ПолучитьПустуюСсылкуНоменклатура() Экспорт
	
	Возврат Справочники.Номенклатура.ПустаяСсылка();
	
КонецФункции

Процедура ПоискНоменклатурыПоШтрихкодуПриСозданииНаСервере(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	
	// Связь характеристики и номенклатуры
	СвязиПараметровВыбора = Новый Массив();
	СвязиПараметровВыбора.Добавить(Новый СвязьПараметраВыбора("Номенклатура", "Элементы.ШтрихкодыНоменклатуры.ТекущиеДанные.Номенклатура", РежимИзмененияСвязанногоЗначения.НеИзменять));
	
	Элементы.ШтрихкодыНоменклатурыХарактеристика.СвязиПараметровВыбора = Новый ФиксированныйМассив(СвязиПараметровВыбора);
		
	// Добавление реквизитов
	МассивДобавляемыхРеквизитов = Новый Массив;
	МассивДобавляемыхРеквизитов.Добавить(Новый РеквизитФормы("ИспользоватьПодключаемоеОборудование", Новый ОписаниеТипов("Булево")));
	МассивДобавляемыхРеквизитов.Добавить(Новый РеквизитФормы("ПоддерживаемыеТипыПодключаемогоОборудования", Новый ОписаниеТипов("Строка")));
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	МассивДобавляемыхРеквизитов.Добавить(Новый РеквизитФормы("Упаковка", Новый ОписаниеТипов("СправочникСсылка.КлассификаторЕдиницИзмерения"), "ШтрихкодыНоменклатуры"));
	///////////////////
		
	Форма.ИзменитьРеквизиты(МассивДобавляемыхРеквизитов);
	
	// Добавление элементов
	НовыйЭлемент             = Форма.Элементы.Вставить("ГруппаУпаковкаЕдиницаИзмерения", Тип("ГруппаФормы"), Элементы.ШтрихкодыНоменклатуры, Элементы.ШтрихкодыНоменклатурыКоличество);
	НовыйЭлемент.Вид         = ВидГруппыФормы.ГруппаКолонок;
	НовыйЭлемент.Заголовок   = НСтр("ru = 'Упаковка, единица измерения'");
	НовыйЭлемент.Группировка = ГруппировкаКолонок.ВЯчейке;
	НовыйЭлемент.Видимость   = Истина;
	
	НовыйЭлемент     = Форма.Элементы.Вставить("Упаковка", Тип("ПолеФормы"), Элементы.ГруппаУпаковкаЕдиницаИзмерения);
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ОтображатьВШапке = Ложь;
	НовыйЭлемент.ПутьКДанным = "ШтрихкодыНоменклатуры.Упаковка";
	НовыйЭлемент.СвязиПараметровВыбора = Новый ФиксированныйМассив(СвязиПараметровВыбора);
	НовыйЭлемент.Видимость   = Истина;
	
	Элемент = Форма.Элементы.Найти("ШтрихкодыНоменклатурыЕдиницаИзмерения");
	Элемент.ОтображатьВШапке = Ложь;
	Элемент.Видимость 		 = Ложь;
	Форма.Элементы.Переместить(Элемент, Элементы.ГруппаУпаковкаЕдиницаИзмерения);	
	
	НовыйЭлемент             = Форма.Элементы.Вставить("ЕдиницаИзмерения", Тип("ПолеФормы"), Элементы.ГруппаУпаковкаЕдиницаИзмерения);
	НовыйЭлемент.Вид         = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.Заголовок   = НСтр("ru = 'Ед. изм.'");
	НовыйЭлемент.ПутьКДанным = "ШтрихкодыНоменклатуры.Номенклатура.БазоваяЕдиницаИзмерения";
	НовыйЭлемент.Видимость   = Истина;
	
КонецПроцедуры

Процедура ПоискНоменклатурыПоШтрихкодуПослеЗагрузкиНоменклатуры(СтрокаТаблицыШтрихкодов, НоменклатураСсылка) Экспорт
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	СтрокаТаблицыШтрихкодов.Упаковка = ОбщегоНазначенияИСМПТК.ЗначениеРеквизитаОбъекта(НоменклатураСсылка, "БазоваяЕдиницаИзмерения");
	///////////////////	
	
КонецПроцедуры

Функция ПолучитьВидПродукцииПоНоменклатуре(Номенклатура) Экспорт
	
	ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.ПустаяСсылка");
	Если Номенклатура = Неопределено
		ИЛИ Не ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура")
		ИЛИ Номенклатура = Справочники.Номенклатура.ПустаяСсылка() Тогда
		Возврат ВидПродукции;
	КонецЕсли;
		
	Если Номенклатура.ОсобенностьУчета = ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ОбувнаяПродукция") Тогда
		
		ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.Обувная");
		
	ИначеЕсли Номенклатура.ОсобенностьУчета = ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ТабачнаяПродукция") Тогда
		
		ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.Табачная");
		
	ИначеЕсли Номенклатура.ОсобенностьУчета = ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.МолочнаяПродукция") Тогда
		
		ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.МолочнаяПродукция");
		
	ИначеЕсли Номенклатура.ОсобенностьУчета = ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ЛекарственныеПрепараты") Тогда
		
		ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.ЛекарственныеПрепараты");
		
	ИначеЕсли Номенклатура.ОсобенностьУчета = ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ЛегкаяПромышленность") Тогда
		
		ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.ЛегкаяПромышленность");
		
	КонецЕсли;
	
	Возврат ВидПродукции;
	
КонецФункции

Функция ПроверитьИспользованиеСерийУНоменклатуры(Номенклатура) Экспорт
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	Возврат Ложь;
	///////////////////
	
КонецФункции

Функция ПроверитьНоменклатуруНаПринадлежностьКМаркировке(Номенклатура) Экспорт
	
	Если Не ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Номенклатура.ОсобенностьУчета = ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ОбувнаяПродукция") 
		Или Номенклатура.ОсобенностьУчета = ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ТабачнаяПродукция")
		Или Номенклатура.ОсобенностьУчета = ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.МолочнаяПродукция")
		Или Номенклатура.ОсобенностьУчета = ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ЛекарственныеПрепараты")
		Или Номенклатура.ОсобенностьУчета = ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ЛегкаяПромышленность") Тогда
		
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСведенияОНоменклатуре(Номенклатура) Экспорт
	
	ДанныеНоменклатуры = Новый Структура();
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	Если ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура") Тогда		
		ДанныеНоменклатуры.Вставить("ЕдиницаИзмерения", Номенклатура.БазоваяЕдиницаИзмерения);
	Иначе	
		ДанныеНоменклатуры.Вставить("ЕдиницаИзмерения", Справочники.КлассификаторЕдиницИзмерения.ПустаяСсылка());
	КонецЕсли;
	///////////////////
	
	Возврат ДанныеНоменклатуры;

КонецФункции

Функция ПолучитьДанныеОНоменклатуреПоGTIN(ТаблицаШК) Экспорт
	
	ДанныеШтрихкодов   = ТаблицаШК.Скопировать(, "Штрихкод"); 	
	ДанныеШтрихкодов.Свернуть("Штрихкод");
	ДанныеНоменклатуры = ПодобратьДанныеПоGTINДляЗаказа(ДанныеШтрихкодов);
	
	//Необходимо дозаполнить исходную таблицу полученными данными по номенклатуре
	Для Каждого СтрокаТовар Из ДанныеНоменклатуры Цикл
		
		Отбор = Новый Структура();
		Отбор.Вставить("Штрихкод", СтрокаТовар.Штрихкод);
		СтрокиИсходнойТаблицы = ТаблицаШК.НайтиСтроки(Отбор);
		
		Если СтрокиИсходнойТаблицы.Количество() > 0 Тогда
			Для Каждого СтрокаИсходнойТаблицы Из СтрокиИсходнойТаблицы Цикл
				СтрокаИсходнойТаблицы.Номенклатура   = СтрокаТовар.Номенклатура; 
				СтрокаИсходнойТаблицы.Характеристика = СтрокаТовар.Характеристика;
				СтрокаИсходнойТаблицы.Упаковка       = СтрокаТовар.Упаковка;
			КонецЦикла;
		КонецЕсли;
 	
	КонецЦикла;
	
	Возврат ТаблицаШК;
		
КонецФункции

Функция ПодобратьДанныеПоGTINДляЗаказа(МассивGTIN) Экспорт
	
	УсловияОтбора = Новый Массив();
	УсловиеШтрихкод = Новый Структура();
	УсловиеШтрихкод.Вставить("ИмяПараметра",  "Штрихкод");
	УсловиеШтрихкод.Вставить("ВыборИзСписка", Истина);
	УсловияОтбора.Добавить(УсловиеШтрихкод);
	
	Текст = ПолучитьТекстЗапросаДляРегистраШтрихкодов(, УсловияОтбора);
	
	Запрос = Новый Запрос();
	Запрос.Текст = Текст;
	Запрос.УстановитьПараметр("Штрихкод", МассивGTIN); 
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	Упаковка = Справочники.КлассификаторЕдиницИзмерения.ПустаяСсылка();
	///////////////////
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ДанныеНоменклатуры = Новый Массив();
	Пока Выборка.Следующий() Цикл
		
		ДанныеШтрихкода = Новый Структура();
		ДанныеШтрихкода.Вставить("Штрихкод",       Выборка.Штрихкод);		
		ДанныеШтрихкода.Вставить("Номенклатура",   Выборка.Номенклатура);
		ДанныеШтрихкода.Вставить("Характеристика", Выборка.Характеристика);
		//ПЕРЕОПРЕДЕЛЕНИЕ//
		ДанныеШтрихкода.Вставить("Упаковка", Упаковка);
		ДанныеШтрихкода.Вставить("ИспользуютсяУпаковки", Ложь);
		///////////////////
		ДанныеНоменклатуры.Добавить(ДанныеШтрихкода);
		
	КонецЦикла;
	
	Возврат ДанныеНоменклатуры;
	
КонецФункции

Функция УпаковкаНеШтучная(Номенклатура, Упаковка) Экспорт
	
	//Проверяет зарегистрированную упаковку на соответствие 1 единице товара:
	//если упаковка штучная, то воспринимаем ее как единицу товара и приравниваем к базовой единице.
	//Это необходимо при проверке штрихкода для того, чтобы понять зарегистрирован он для единицы товара (потребит. код)
	//или реальной упаковки (групповой код)
	
	Если Не ЗначениеЗаполнено(Номенклатура) Или Не ЗначениеЗаполнено(Упаковка) Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	КоэффициентУпаковки = ПолучитьКоэффициентУпаковки(Упаковка, Номенклатура);
	Возврат ?(КоэффициентУпаковки = 1, Ложь, Истина);
	
КонецФункции

Функция ПересчитатьКоличествоУпаковокВКоличество(КоличествоУпаковок, Упаковка, Номенклатура) Экспорт
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	Если Не ЗначениеЗаполнено(Номенклатура) Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	КоэффициентУпаковки = ПолучитьКоэффициентУпаковки(Упаковка, Номенклатура);
	Возврат КоличествоУпаковок * КоэффициентУпаковки;	
	
КонецФункции

Функция ПолучитьКоэффициентУпаковки(Упаковка, Номенклатура) Экспорт
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	КоэффициентУпаковки = 1;
	///////////////////
	
	Возврат КоэффициентУпаковки;	
	
КонецФункции

#КонецОбласти

#Область Штрихкод

Процедура ПоискНоменклатурыПоШтрихкодуОбработкаПроверкиЗаполнения(Форма, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	ШтрихкодыНоменклатуры = Форма.ШтрихкодыНоменклатуры;
	
	УсловияОтбора   = Новый Массив();
	УсловиеШтрихкод = Новый Структура();
	УсловиеШтрихкод.Вставить("ИмяПараметра",  "Штрихкод");
	УсловиеШтрихкод.Вставить("ВыборИзСписка", Истина);
	УсловияОтбора.Добавить(УсловиеШтрихкод);
	
	Текст = ПолучитьТекстЗапросаДляРегистраШтрихкодов(" ПЕРВЫЕ 1", УсловияОтбора);
	
	Запрос = Новый Запрос();
	Запрос.Текст = Текст;
	Запрос.УстановитьПараметр("Штрихкод", ШтрихкодыНоменклатуры.Выгрузить(Новый Структура("Зарегистрирован", Ложь),"Штрихкод").ВыгрузитьКолонку("Штрихкод"));
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда // Штрихкод уже записан в БД
		
		СтрокаТЧ = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("Штрихкод", Выборка.Штрихкод))[0];
		
		ОписаниеОшибки = НСтр("ru = 'Такой штрихкод уже назначен для номенклатуры %Номенклатура%'");
		ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Номенклатура%", Выборка.НоменклатураНаименование);
		
		ОбщегоНазначенияИСМПТККлиентСерверПереопределяемый.СообщитьПользователю(ОписаниеОшибки,,"ШтрихкодыНоменклатуры["+ШтрихкодыНоменклатуры.Индекс(СтрокаТЧ)+"].Штрихкод",,Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьШтрихкодНоменклатуры(Номенклатура, ШтрихкодEAN, ЕИ = Неопределено, Характеристика) Экспорт
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	МенеджерЗаписи = РегистрыСведений.ШтрихкодыНоменклатуры.СоздатьМенеджерЗаписи();	
	МенеджерЗаписи.Штрихкод 	  = ШтрихкодEAN;
	МенеджерЗаписи.Номенклатура	  = Номенклатура;	
	///////////////////
		
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

Процедура ЗарегистрироватьШтрихкоды(ШтрихкодыНоменклатуры) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных();
		
		//ПЕРЕОПРЕДЕЛЕНИЕ//
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ШтрихкодыНоменклатуры");
		///////////////////
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		
		Блокировка.Заблокировать();
		
		Для Каждого СтрокаШтрихкода Из ШтрихкодыНоменклатуры Цикл
			
			//ПЕРЕОПРЕДЕЛЕНИЕ//
			МенеджерЗаписи = РегистрыСведений.ШтрихкодыНоменклатуры.СоздатьМенеджерЗаписи();
			///////////////////		
			
			МенеджерЗаписи.Штрихкод         = СтрокаШтрихкода.Штрихкод;
					
			//ПЕРЕОПРЕДЕЛЕНИЕ//
			МенеджерЗаписи.Номенклатура  	= СтрокаШтрихкода.Номенклатура;
			///////////////////
					
			МенеджерЗаписи.Записать();
						
		КонецЦикла;
				
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
	КонецПопытки;

КонецПроцедуры

#КонецОбласти

#Область ДлительныеОперации

Функция ВыполнитьПроцедуру(Знач ПараметрыВыполнения = Неопределено, ИмяПроцедуры, Знач Параметр1 = Неопределено,
	Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено, Знач Параметр4 = Неопределено,
	Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено, Знач Параметр7 = Неопределено) Экспорт
	
	Возврат ДлительныеОперации.ВыполнитьПроцедуру(ПараметрыВыполнения, ИмяПроцедуры, Параметр1, 
	Параметр2, Параметр3, Параметр4, Параметр5, Параметр6, Параметр7);
	
КонецФункции

Функция ВыполнитьФункцию(Знач ПараметрыВыполнения, ИмяФункции, Знач Параметр1 = Неопределено,
	Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено, Знач Параметр4 = Неопределено,
	Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено, Знач Параметр7 = Неопределено) Экспорт
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, ИмяФункции, Параметр1, 
	Параметр2, Параметр3, Параметр4, Параметр5, Параметр6, Параметр7);
	
КонецФункции

Функция СообщенияПользователю(УдалятьПолученные = Ложь, ИдентификаторЗадания = Неопределено) Экспорт
	
	Возврат ДлительныеОперации.СообщенияПользователю(УдалятьПолученные, ИдентификаторЗадания);
	
КонецФункции

#КонецОбласти

