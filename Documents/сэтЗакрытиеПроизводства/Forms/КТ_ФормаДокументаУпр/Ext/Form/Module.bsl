﻿#Область СлужебныеПроцедурыИФункцииБСП

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

// Конец СтандартныеПодсистемы

#КонецОбласти 

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Параметры.Ключ.Пустая() Тогда    
		
		УстановитьКомментарий();
		
		Объект.Дата = НачалоДня(КонецМесяца(ТекущаяДата()));
		
		ВключитьВыключитьФлажки(Истина);
		
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;

КонецПроцедуры


&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтаФорма);

КонецПроцедуры


&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	УстановитьЗаголовокФормы();
	
КонецПроцедуры    

&НаСервере
Процедура УстановитьЗаголовокФормы()  
	
	ТекстЗаголовка = НСтр("ru = 'Закрытие производства'");
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстЗаголовка = ТекстЗаголовка + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru=' %1 от %2'"), Объект.Номер, Формат(Объект.Дата, "ДЛФ=D"));
	Иначе
		ТекстЗаголовка = ТекстЗаголовка + НСтр("ru = ' (создание)'");
	КонецЕсли;
	
	Заголовок = ТекстЗаголовка;  
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКомментарий()

	Объект.Комментарий = "Закрытие месяца за " + Формат( Объект.Дата, "ДФ='ММММ гггг'");
	
КонецПроцедуры // УстановитьКомментарий()

&НаСервере
Процедура ВключитьВыключитьФлажки(Параметр)
	
	Объект.АмортизацияОСБУ                                 = Параметр;		
	Объект.АмортизацияНМАБУ                                = Параметр;		
	
//	Объект.СписаниеРезерваПоПереоценкеОСБУ					= Параметр;
	
	Объект.ПереоценкаВалютныхСредствБУ                     = Параметр;
	
	Объект.СписаниеРБПБУ                                   = Параметр;
	
	Объект.РасчетСтоимостиПродукцииБУ                      = Параметр;
	
	Объект.ПереносНЗП										= Параметр;
	
	Объект.РеформацияБалансаБУ                             = Параметр;			
	
	Объект.АмортизацияФАНУ									= Параметр;			
	Объект.РасчетВычетовПоРасходамНаРемонт					= Параметр;			
	Объект.РасчетДоходаОтПревышенияСтоимостиВыбывшихФА		= Параметр;			
	Объект.СписаниеПриВыбытииВсехФАГруппы					= Параметр;				
	Объект.СписаниеСтоимостногоБалансаГруппыМенееМинимума	= Параметр;			
	
	Объект.ВключениеВСтоимостныйБалансАктивовУчитываемыхОтдельно =  Параметр;			
	                            	
	Объект.РасчетВременныхРазниц		                    = Параметр;  		
	Объект.РасчетНалогаНаПрибыль                           = Параметр;
	Объект.РасчетНДСКЗачету								= Параметр;	
	//Объект.ЗакрытиеПодотчетныхСумм							= Параметр;
	//Объект.ЗачетАвансовыхПлатежейПоНалогамИСборам			= Параметр;
	
	
КонецПроцедуры


&НаКлиенте
Процедура НЗППередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры


&НаКлиенте
Процедура НЗППередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры       

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	УстановитьКомментарий();

	ДатаКонецМесяца = КонецМесяца(Объект.Дата);
	Если День(Объект.Дата) <> День(ДатаКонецМесяца) Тогда
		
		Дата = НачалоДня(ДатаКонецМесяца);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВключитьВсе(Команда)

	Для Каждого Стр из Объект.НЗП Цикл
		
		Стр.ОтноситьНаНЗП = Истина;
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ВыключитьВсе(Команда)

	Для Каждого Стр из Объект.НЗП Цикл
		
		Стр.ОтноситьНаНЗП = Ложь;
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ВключитьВсе1(Команда)

	Для Каждого Стр из Объект.Убыток Цикл
		
		Стр.ОтноситьНаУбыток = Истина;
		
	КонецЦикла;


КонецПроцедуры

&НаКлиенте
Процедура ВыключитьВсе1(Команда)

	Для Каждого Стр из Объект.Убыток Цикл
		
		Стр.ОтноситьНаУбыток = Ложь;
		
	КонецЦикла;


КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНЗПНаСервере()
	
	Объект.НЗП.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Расходы.Субконто2 КАК НоменклатурнаяГруппа,
	|	СУММА(Расходы.СуммаОборотДт - Расходы.СуммаОборотКт) КАК Расходы,
	|	СУММА(Доходы.СуммаОборотКт - Доходы.СуммаОборотДт) КАК Доходы
	|ИЗ
	|	РегистрБухгалтерии.Типовой.Обороты(&НачДата, &КонДата, , Счет В ИЕРАРХИИ (&СчетаЗатрат), , Организация = &Организация, , ) КАК Расходы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Типовой.Обороты(&НачДата, &КонДата, , Счет В ИЕРАРХИИ (&Счет6000), , Организация = &Организация, , ) КАК Доходы
	|		ПО Расходы.Субконто2 = Доходы.Субконто2
	|
	|СГРУППИРОВАТЬ ПО
	|	Расходы.Субконто2";
	Запрос.УстановитьПараметр("НачДата", НачалоМесяца(Объект.Дата));
	Запрос.УстановитьПараметр("КонДата", КонецМесяца(Объект.Дата));
	//Запрос.УстановитьПараметр("Счет8000", ПланыСчетов.Типовой.СчетаПроизводственногоУчета);
	Запрос.УстановитьПараметр("Счет6000", ПланыСчетов.Типовой.ДоходОтРеализацииПродукцииИОказанияУслуг_);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	
	СчетаЗатрат = Новый Массив;
	СчетаЗатрат.Добавить(ПланыСчетов.Типовой.ОсновноеПроизводство);
	СчетаЗатрат.Добавить(ПланыСчетов.Типовой.ПолуфабрикатыСобственногоПроизводства);
	СчетаЗатрат.Добавить(ПланыСчетов.Типовой.ВспомогательныеПроизводства);
	//Наталья СЭТ
	//СчетаЗатрат.Добавить(ПланыСчетов.Типовой.НакладныеРасходы);
	//Наталья СЭТ
	Запрос.УстановитьПараметр("СчетаЗатрат",        СчетаЗатрат);
		
	ТЗ = Запрос.Выполнить().Выгрузить();
	
	Объект.НЗП.Загрузить(ТЗ);  
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНЗП(Команда)
	ЗаполнитьНЗПНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьУбытокНаСервере()

	Объект.НЗП.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Убыток.Субконто1 КАК Подразделение,
	|	Убыток.СуммаОборотДт - Убыток.СуммаОборотКт КАК Сумма,
	|	Убыток.Субконто2 КАК СтатьиЗатрат
	|ИЗ
	|	РегистрБухгалтерии.Типовой.Обороты(&НачДата, &КонДата, , Счет = &Счет8410, , Организация = &Организация, , ) КАК Убыток";
	Запрос.УстановитьПараметр("НачДата", НачалоМесяца(Объект.Дата));
	Запрос.УстановитьПараметр("КонДата", КонецМесяца(Объект.Дата));
	Запрос.УстановитьПараметр("Счет8410", ПланыСчетов.Типовой.НакладныеРасходы);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	
	//СчетаЗатрат = Новый Массив;
	//СчетаЗатрат.Добавить(ПланыСчетов.Типовой.ОсновноеПроизводство);
	//СчетаЗатрат.Добавить(ПланыСчетов.Типовой.ПолуфабрикатыСобственногоПроизводства);
	//СчетаЗатрат.Добавить(ПланыСчетов.Типовой.ВспомогательныеПроизводства);
	////Наталья СЭТ
	////СчетаЗатрат.Добавить(ПланыСчетов.Типовой.НакладныеРасходы);
	////Наталья СЭТ
	//Запрос.УстановитьПараметр("СчетаЗатрат",        СчетаЗатрат);
		
	ТЗ = Запрос.Выполнить().Выгрузить();
	
	Объект.Убыток.Загрузить(ТЗ);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьУбыток(Команда)
	ЗаполнитьУбытокНаСервере();
КонецПроцедуры










