﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВССерверПереопределяемый.ЭДВСФормаСпискаИВыбораПриСозданииНаСервере(ЭтаФорма);
	
	//скрыта команда создания ЭДВС
	ОбщегоНазначенияБККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаДокументЭлектронныйДокументВССоздатьЭлектронныйДокументВС", "Видимость", Ложь);
	
	Элементы.ОткрытьОповещенияЭСФ.Заголовок = ЭСФВызовСервера.ПолучитьТекстГиперссылкиОповещений();
	
	ПараметрыЭСФ = ЭСФСервер.ПолучитьПараметрыЭСФ();
	Если не ПараметрыЭСФ.ИспользоватьОткрытиеСессииСПодписью Тогда
		 Элементы.СписокДанныеАктивностиТикетов.Видимость = Ложь;
	КонецЕсли;
	
	ЭСФСервер.ПроверитьИспользованиеСервернойКриптографии(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = ВСКлиентСервер.ИмяСобытияЗаписьЭДВС() Тогда
		Элементы.Список.Обновить();
	ИначеЕсли ИмяСобытия = "ВС_ПроверятьОповещенияФоновогоЗадания"
		И ЭтаФорма.КлючУникальности = Источник Тогда
		
		ВСКлиентПереопределяемый.ОбработкаОповещенияВС_ПроверятьОповещенияФоновогоЗадания(ЭтаФорма, Параметр);
		
	ИначеЕсли ИмяСобытия = ЭСФКлиентСервер.ИмяСобытияЗаписьУведомленийИСЭСФ() Тогда
		
		Элементы.ОткрытьОповещенияЭСФ.Заголовок = ЭСФВызовСервера.ПолучитьТекстГиперссылкиОповещений();
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	УстановитьБыстрыйОтбор("Организация", Организация);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьБыстрыйОтбор(ВидЭлемента, ЗначениеЭлемента)
	
	ЭСФКлиентСерверПереопределяемый.ИзменитьЭлементОтбораСписка(Список, ВидЭлемента, ЗначениеЭлемента, ЗначениеЗаполнено(ЗначениеЭлемента));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОткрытьОповещенияИСЭСФ(Команда)
	ЭСФКлиент.ОткрытьФормуОповещенийИСЭСФ(,);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОповещенияИСЭСФ(Команда)
	Элементы.ОткрытьОповещенияЭСФ.Заголовок = ЭСФВызовСервера.ПолучитьТекстГиперссылкиОповещений();
КонецПроцедуры

&НаКлиенте
Процедура ДанныеАктивностиТикетов(Команда)
	ОткрытьФорму("Обработка.ОбменЭСФ.Форма.РаботаСТикетами");

КонецПроцедуры

&НаКлиенте
Процедура КомментарийМестоУстановкиБиблиотекиНаСервереОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ЭСФКлиент.ОбработкаНавигационнойСсылкиМестоУстановкиБиблиотеки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
     ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
     ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
 
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
     ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
     ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

