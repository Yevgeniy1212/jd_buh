﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мВалютаРегламентированногоУчета Экспорт;

Перем ЕстьПС Экспорт;
Перем ЕстьКПС Экспорт;

Перем ОПС Экспорт;
Перем ИПС Экспорт;
Перем КОПС Экспорт;
Перем КИПС Экспорт;

#Если Клиент Тогда
	

Процедура ОбновитьСЗ () Экспорт
		
	Отбор = Новый Структура("Организация", Организация);
	НастройкиМетодаНачисления = РегистрыСведений.НастройкиМетодаНачисления.ПолучитьПоследнее(Дата, Отбор);
	ПериодРасчетаПорогаСущественности = НастройкиМетодаНачисления.ПериодРасчетаПорогаСущественности;
	
	Если ЗначениеЗаполнено (ПериодРегистрации) и ЗначениеЗаполнено(Организация) Тогда
		ЗапросРасходов.Очистить();
		
		ЗапросАналитикиПредПериод = Новый Запрос("ВЫБРАТЬ
												 |	СУММА(ТиповойОбороты.СуммаОборотДт) КАК СуммаОборотДт,
												 |	ТиповойОбороты.Субконто1
												 |ИЗ
												 |	РегистрБухгалтерии.Типовой.Обороты(&НачПериода, &КонПериода, Период, , , , , ) КАК ТиповойОбороты
												 |ГДЕ
												 |	ПОДСТРОКА(ТиповойОбороты.Счет.Код, 1, 1) = &Счет
												 |
												 |СГРУППИРОВАТЬ ПО
												 |	ТиповойОбороты.Субконто1");
									   
		//ЗапросАналитикиПредПериод.УстановитьПараметр("НачПериода",НачалоКвартала(ДобавитьМесяц(ПериодРегистрации,-12)));
		//ЗапросАналитикиПредПериод.УстановитьПараметр("КонПериода",КонецКвартала(ДобавитьМесяц(ПериодРегистрации,-12)));
		//ЗапросАналитикиПредПериод.УстановитьПараметр("Счет","7");
		//ВыборкаАналитикиПредПериод = ЗапросАналитикиПредПериод.Выполнить().Выбрать();				
		//
		//Пока ВыборкаАналитикиПредПериод.Следующий() Цикл
		//	Стр = ЗапросРасходов.Добавить();
		//	Стр.СтатьяРасхода = ВыборкаАналитикиПредПериод.Субконто1;
		//	Стр.СЗ_ЗаПредыдущийПериод = ВыборкаАналитикиПредПериод.СуммаОборотДт/3;
		//	СтрокаДобавлена = Истина;
		//КонецЦикла;
		
		Если ПериодРасчетаПорогаСущественности = Перечисления.ПериодРасчетаПорогаСущественности.Квартал Тогда
			ЗапросАналитикиПредПериод.УстановитьПараметр("НачПериода",НачалоКвартала(ДобавитьМесяц(ПериодРегистрации,-3)));
			ЗапросАналитикиПредПериод.УстановитьПараметр("КонПериода",КонецКвартала(ДобавитьМесяц(ПериодРегистрации,-3)));
		Иначе
			ЗапросАналитикиПредПериод.УстановитьПараметр("НачПериода",НачалоМесяца(ДобавитьМесяц(ПериодРегистрации,-1)));
			ЗапросАналитикиПредПериод.УстановитьПараметр("КонПериода",КонецМесяца(ДобавитьМесяц(ПериодРегистрации,-1)));
		КонецЕсли;
		
		//Если ПериодРасчетаПорогаСущественности = Перечисления.ПериодРасчетаПорогаСущественности.Квартал Тогда
		//	ЗапросАналитикиПредПериод.УстановитьПараметр("НачПериода",НачалоКвартала(ПериодРегистрации));
		//	ЗапросАналитикиПредПериод.УстановитьПараметр("КонПериода",КонецКвартала(ПериодРегистрации));
		//Иначе
		//	ЗапросАналитикиПредПериод.УстановитьПараметр("НачПериода",НачалоМесяца(ПериодРегистрации));
		//	ЗапросАналитикиПредПериод.УстановитьПараметр("КонПериода",КонецМесяца(ПериодРегистрации));
		//КонецЕсли;		
		
		ЗапросАналитикиПредПериод.УстановитьПараметр("Счет","7");
		ВыборкаАналитикиТекПериод = ЗапросАналитикиПредПериод.Выполнить().Выбрать();				
		
		Пока ВыборкаАналитикиТекПериод.Следующий() Цикл
			СтрокаТЧ = ЗапросРасходов.Найти(ВыборкаАналитикиТекПериод.Субконто1,"СтатьяРасхода");
			Если ПериодРасчетаПорогаСущественности = Перечисления.ПериодРасчетаПорогаСущественности.Квартал Тогда
				Если СтрокаТЧ <> Неопределено Тогда
					СтрокаТЧ.СЗ_ДляТекущегоПериода = ВыборкаАналитикиТекПериод.СуммаОборотДт/3;
				Иначе
					Стр = ЗапросРасходов.Добавить();
					Стр.СтатьяРасхода = ВыборкаАналитикиТекПериод.Субконто1;		
					Стр.СЗ_ДляТекущегоПериода = ВыборкаАналитикиТекПериод.СуммаОборотДт/3;
				КонецЕсли;
			ИначеЕсли ПериодРасчетаПорогаСущественности = Перечисления.ПериодРасчетаПорогаСущественности.Месяц Тогда
				Если СтрокаТЧ <> Неопределено Тогда
					СтрокаТЧ.СЗ_ДляТекущегоПериода = ВыборкаАналитикиТекПериод.СуммаОборотДт;
				Иначе
					Стр = ЗапросРасходов.Добавить();
					Стр.СтатьяРасхода = ВыборкаАналитикиТекПериод.Субконто1;		
					Стр.СЗ_ДляТекущегоПериода = ВыборкаАналитикиТекПериод.СуммаОборотДт;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		ЗапросРасходов.Сортировать("СтатьяРасхода");
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбновитьСД () Экспорт
	
	Отбор = Новый Структура("Организация", Организация);
	НастройкиМетодаНачисления = РегистрыСведений.НастройкиМетодаНачисления.ПолучитьПоследнее(Дата, Отбор);
	ПериодРасчетаПорогаСущественности = НастройкиМетодаНачисления.ПериодРасчетаПорогаСущественности;
	
	Если ЗначениеЗаполнено (ПериодРегистрации) и ЗначениеЗаполнено(Организация) Тогда
		ЗапросДоходов.Очистить();
		
		ЗапросАналитикиПредПериод = Новый Запрос("ВЫБРАТЬ
		                                         |	СУММА(ТиповойОбороты.СуммаОборотКт) КАК СуммаОборотКт,
		                                         |	ТиповойОбороты.Субконто1
		                                         |ИЗ
		                                         |	РегистрБухгалтерии.Типовой.Обороты(&НачПериода, &КонПериода, Период, , , , , ) КАК ТиповойОбороты
		                                         |ГДЕ
		                                         |	ПОДСТРОКА(ТиповойОбороты.Счет.Код, 1, 1) = &Счет
		                                         |
		                                         |СГРУППИРОВАТЬ ПО
		                                         |	ТиповойОбороты.Субконто1");
									   
		//ЗапросАналитикиПредПериод.УстановитьПараметр("НачПериода",НачалоКвартала(ДобавитьМесяц(ПериодРегистрации,-12)));
		//ЗапросАналитикиПредПериод.УстановитьПараметр("КонПериода",КонецКвартала(ДобавитьМесяц(ПериодРегистрации,-12)));
		//ЗапросАналитикиПредПериод.УстановитьПараметр("Счет","6");
		//ВыборкаАналитикиПредПериод = ЗапросАналитикиПредПериод.Выполнить().Выбрать();				
		//
		//Пока ВыборкаАналитикиПредПериод.Следующий() Цикл
		//	Стр = ЗапросДоходов.Добавить();
		//	Стр.СтатьяДохода = ВыборкаАналитикиПредПериод.Субконто1;
		//	Стр.СД_ЗаПредыдущийПериод = ВыборкаАналитикиПредПериод.СуммаОборотКт/3;
		//	СтрокаДобавлена = Истина;
		//КонецЦикла;
		
		Если ПериодРасчетаПорогаСущественности = Перечисления.ПериодРасчетаПорогаСущественности.Квартал Тогда
			ЗапросАналитикиПредПериод.УстановитьПараметр("НачПериода",НачалоКвартала(ДобавитьМесяц(ПериодРегистрации,-3)));
			ЗапросАналитикиПредПериод.УстановитьПараметр("КонПериода",КонецКвартала(ДобавитьМесяц(ПериодРегистрации,-3)));
		Иначе
			ЗапросАналитикиПредПериод.УстановитьПараметр("НачПериода",НачалоМесяца(ДобавитьМесяц(ПериодРегистрации,-1)));
			ЗапросАналитикиПредПериод.УстановитьПараметр("КонПериода",КонецМесяца(ДобавитьМесяц(ПериодРегистрации,-1)));
		КонецЕсли;
		
		ЗапросАналитикиПредПериод.УстановитьПараметр("Счет","6");
		ВыборкаАналитикиТекПериод = ЗапросАналитикиПредПериод.Выполнить().Выбрать();				
		
		Пока ВыборкаАналитикиТекПериод.Следующий() Цикл
			СтрокаТЧ = ЗапросДоходов.Найти(ВыборкаАналитикиТекПериод.Субконто1,"СтатьяДохода");
			Если ПериодРасчетаПорогаСущественности = Перечисления.ПериодРасчетаПорогаСущественности.Квартал Тогда
				Если СтрокаТЧ <> Неопределено Тогда
					СтрокаТЧ.СД_ДляТекущегоПериода = ВыборкаАналитикиТекПериод.СуммаОборотКт/3;
				Иначе
					Стр = ЗапросДоходов.Добавить();
					Стр.СтатьяДохода = ВыборкаАналитикиТекПериод.Субконто1;		
					Стр.СД_ДляТекущегоПериода = ВыборкаАналитикиТекПериод.СуммаОборотКт/3;
				КонецЕсли;
			ИначеЕсли ПериодРасчетаПорогаСущественности = Перечисления.ПериодРасчетаПорогаСущественности.Месяц Тогда
				Если СтрокаТЧ <> Неопределено Тогда
					СтрокаТЧ.СД_ДляТекущегоПериода = ВыборкаАналитикиТекПериод.СуммаОборотКт;
				Иначе
					Стр = ЗапросДоходов.Добавить();
					Стр.СтатьяДохода = ВыборкаАналитикиТекПериод.Субконто1;		
					Стр.СД_ДляТекущегоПериода = ВыборкаАналитикиТекПериод.СуммаОборотКт;
				КонецЕсли;				
			КонецЕсли;
		КонецЦикла;
		
		ЗапросДоходов.Сортировать("СтатьяДохода");
	КонецЕсли;	
	
КонецПроцедуры
	
// Печать справки расчета начислений
Функция ПечатьЗапроса()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);
	Запрос.Текст ="
	|ВЫБРАТЬ
	|	Номер,
	|	Дата,
	|	Организация,
	|	Организация КАК Руководители,
	|	Организация КАК Поставщик,
	|	ПериодРегистрации
	|ИЗ
	|	Документ.ЗапросДляРасчетаНачислений КАК РасчетНачислений
	|
	|ГДЕ
	|	РасчетНачислений.Ссылка = &ТекущийДокумент";

	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗапросДляРасчетаНачислений_ЗапросНачислений";

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗапросДляРасчетаНачисленийЗапросРасходов.СтатьяРасхода,
	               |	ЗапросДляРасчетаНачисленийЗапросРасходов.ВключатьВЗапрос
	               |ИЗ
	               |	Документ.ЗапросДляРасчетаНачислений.ЗапросРасходов КАК ЗапросДляРасчетаНачисленийЗапросРасходов
	               |ГДЕ
	               |	ЗапросДляРасчетаНачисленийЗапросРасходов.Ссылка = &Ссылка";

	ЗапросНачисления = Запрос.Выполнить().Выгрузить();

	Макет = ПолучитьМакет("ЗапросНачислений");

	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	ОбластьМакета.Параметры.ПериодРегистрации = РаботаСДиалогами.ДатаКакМесяцПредставление(Шапка.ПериодРегистрации);
    ТабДокумент.Вывести(ОбластьМакета);			
	
	
	ОбластьСтроки = Макет.ПолучитьОбласть("Строка");
    НомерСтроки = 1;
	Для Каждого ВыборкаСтрокНачисления Из ЗапросНачисления Цикл 
	    Если ВыборкаСтрокНачисления.ВключатьВЗапрос Тогда
			ОбластьСтроки.Параметры.НомерСтроки = НомерСтроки;

			ОбластьСтроки.Параметры.СтатьяРасхода = ВыборкаСтрокНачисления.СтатьяРасхода;
			
			ТабДокумент.Вывести(ОбластьСтроки);
	        НомерСтроки = НомерСтроки + 1;
		КонецЕсли;
	КонецЦикла;
	
	
	Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗапросДляРасчетаНачисленийЗапросДоходов.СтатьяДохода,
	               |	ЗапросДляРасчетаНачисленийЗапросДоходов.ВключатьВЗапрос
	               |ИЗ
	               |	Документ.ЗапросДляРасчетаНачислений.ЗапросДоходов КАК ЗапросДляРасчетаНачисленийЗапросДоходов
	               |ГДЕ
	               |	ЗапросДляРасчетаНачисленийЗапросДоходов.Ссылка = &Ссылка";

	ЗапросНачисления = Запрос.Выполнить().Выгрузить();

	Макет = ПолучитьМакет("ЗапросНачислений");

	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаД");
    ТабДокумент.Вывести(ОбластьМакета);			
	
	
	ОбластьСтроки = Макет.ПолучитьОбласть("СтрокаД");
    НомерСтроки = 1;
	Для Каждого ВыборкаСтрокНачисления Из ЗапросНачисления Цикл 
	    Если ВыборкаСтрокНачисления.ВключатьВЗапрос Тогда
			ОбластьСтроки.Параметры.НомерСтроки = НомерСтроки;

			ОбластьСтроки.Параметры.СтатьяРасхода = ВыборкаСтрокНачисления.СтатьяДохода;
			
			ТабДокумент.Вывести(ОбластьСтроки);
	        НомерСтроки = НомерСтроки + 1;
		КонецЕсли;
	КонецЦикла;	

	ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
    ТабДокумент.Вывести(ОбластьМакета);	
	
	Возврат ТабДокумент;	
КонецФункции

Функция ВернутьМесяцВСтроке(Дата)
	
	МесяцДаты = Число(Месяц(Дата));
	
	Если МесяцДаты>9 Тогда
		Возврат Строка(МесяцДаты); 
	Иначе
		Возврат "0"+Строка(МесяцДаты)
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходмое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт
	
	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	КонецЕсли;
	
	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	// Получить экземпляр документа на печать
	//Если ИмяМакета = "Счет" Тогда
	Если ИмяМакета = "Запрос" Тогда
		
		//ТабДокумент = ПечатьСчетаЗаказа();
		ТабДокумент = ПечатьЗапроса();
		
	КонецЕсли;
	
	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, РаботаСДиалогами.СформироватьЗаголовокДокумента(ЭтотОбъект, ""));
	
КонецПроцедуры // Печать

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	//Возврат Новый Структура("Счет","Счет на оплату");
	Возврат Новый Структура("Запрос","Запрос статей расходов");

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	НетНачислений = Ложь;
	НетНеисполненныхНачислений = Ложь;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
ЕстьПС  = Ложь;
ЕстьКПС = Ложь;

ОПС  = 0;
ИПС  = 0;
КОПС = 0;
КИПС = 0;


мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();