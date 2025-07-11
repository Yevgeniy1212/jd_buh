﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") И ДанныеЗаполнения <> Неопределено Тогда
		Документы.си_ПриемкаСпецодеждыИИнвентаряПоХарактеристикам.ЗаполнитьПоПоступлению(ДанныеЗаполнения,Истина,ЭтотОбъект);
		ДокументОснование = ДанныеЗаполнения;
	Иначе
		общ_ПереопределяемыеПроцедурыБКСервер.ЗаполнитьШапкуДокумента(ЭтотОбъект, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ВедетсяУчетПоСкладам = си_УчетСпецодеждыСерверПовтИсп.ВедетсяУчетПоСкладам();
	
	Если ВедетсяУчетПоСкладам Тогда
		ПроверяемыеРеквизиты.Добавить("Склад");
	КонецЕсли;
	
	//Документы.си_ПриемкаСпецодеждыИИнвентаряПоХарактеристикам.ПроверитьЗаполнениеКоличестваТабЧастиТоварыПоДокументуОснования(ЭтотОбъект,Отказ,Материалы.Выгрузить());
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.си_ПриемкаСпецодеждыИИнвентаряПоХарактеристикам.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Таблица списанных товаров
	ТаблицаСписанныеТовары = УчетТоваров.ПодготовитьТаблицуСписанныеТовары(ПараметрыПроведения.СписаниеТоваровТаблицаТовары,
			ПараметрыПроведения.СписаниеТоваровРеквизиты, Отказ);
			
	//КОНТРОЛЬ ПО РЕГИСТРУ "ТОВАРЫ ОРГАНИЗАЦИЙ
	НомераГТДСервер.ВыполнитьКонтрольТоварыОрганизаций(ПараметрыПроведения.ТаблицаТоварыОрганизаций,ПараметрыПроведения.Реквизиты, , Отказ);
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	УчетТоваров.СформироватьДвиженияСписаниеТоваров(ТаблицаСписанныеТовары,
			ПараметрыПроведения.СписаниеТоваровРеквизиты, Движения, Отказ);
			
	// Товары организаций
	НомераГТДСервер.СформироватьДвиженияТоварыОрганизаций(ПараметрыПроведения.ТаблицаТоварыОрганизаций,ПараметрыПроведения.Реквизиты, Движения, Отказ);	

	// Отражение ПР в НУ 
	общ_ПереопределяемыеПроцедурыБКСервер.ОтразитьПостоянныеРазницыВНУ(ЭтотОбъект,ПараметрыПроведения.СписаниеТоваровРеквизиты, Движения, Отказ);
	
	ТаблицаМатериалыВЭксплуатацию = си_УчетСпецодеждыСервер.ПодготовитьТаблицуПередачиВЭксплуатацию(ПараметрыПроведения.ТаблицаМатериалы,ПараметрыПроведения,Движения,Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	//	++кибернетика: 2024-09-20 Искендеров Алишер - фикс ошибки расчета себестоимости в регистре материалы на складе
	Для каждого Движение Из Движения.Типовой Цикл
		
		Если Движение.СчетДт = ПланыСчетов.Типовой.НайтиПоКоду("1353") И Движение.СчетКт = ПланыСчетов.Типовой.НайтиПоКоду("1316") Тогда
			НайденныеСтроки = ТаблицаМатериалыВЭксплуатацию.НайтиСтроки(Новый Структура("Номенклатура, СчетУчетаБУ", Движение.СубконтоДт.Номенклатура, Движение.СчетКт));
			Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				НайденнаяСтрока.Стоимость = Движение.Сумма;		
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	//	--кибернетика: 2024-09-20 Искендеров Алишер
	
	// передача в эксплуатацию
	си_УчетСпецодеждыУправлениеПроведениемДокументовСервер.СформироватьДвиженияПоРегистрам(ПараметрыПроведения.Реквизиты, ТаблицаМатериалыВЭксплуатацию, Движения, Отказ,"Материалы","си_УчетСпецодеждыСервер","ЗарегистрироватьДвиженияМатериалыНаСкладеПоступление");
	
		// амортизация передаваемых в эксплуатацию
	//си_УчетСпецодеждыСервер.СформироватьДвиженияАмортизацияМатериаловприПередачеВЭксплуатацию(ПараметрыПроведения.Реквизиты, ТаблицаМатериалыВЭксплуатацию, ПараметрыПроведения.СпособыОтраженияРасходов, Движения, Отказ);
	
	//// списание с ордерного склада
	//си_УчетСпецодеждыУправлениеПроведениемДокументовСервер.СформироватьДвиженияПоРегистрам(ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаМатериалы, Движения, Отказ,"Материалы","си_УчетСпецодеждыСервер","ЗарегистрироватьДвиженияПриходРасходПоОрдерномуСкладу");
			
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение И НомераГТДСервер.ВедетсяУчетПоТоварамОрганизаций(Дата) Тогда
		ТаблицаДокумента = общ_ПереопределяемыеПроцедурыБКСервер.ПодготовитьТаблицуТоваровСУчетомСкладовВТЧ(Материалы, Истина, Склад);
		ТаблицаНомераГТД = НомераГТДСервер.ПодготовитьТаблицуНомеровГТД(ТаблицаДокумента, НомераГТД.Выгрузить());
		общ_ПереопределяемыеПроцедурыБКСервер.ЗаполнитьТаблицуНомераГТД(ЭтотОбъект,ТаблицаДокумента, ТаблицаНомераГТД);
	КонецЕсли;
	//Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
	//	общ_ПереопределяемыеПроцедурыБКСервер.ЗаполнитьТаблицуНомераГТД(ЭтотОбъект,"Материалы");
	//КонецЕсли;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Если ЗначениеЗаполнено(ОбъектКопирования.НомераГТД) Тогда
		НомераГТД.Очистить();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли