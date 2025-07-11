﻿
&НаКлиенте
Процедура ВыполнитьЗагрузку(Команда)
     
    Оповещение  = Новый ОписаниеОповещения("НачатьВыполнениеЗагрузки", ЭтаФорма);
    ПоказатьВопрос(Оповещение, "Выполнить загрузку данных из файла """ + ПутьКФайлу + """ ?",
                    РежимДиалогаВопрос.ДаНет, , , "Начало загрузки");
 
КонецПроцедуры
 
&НаКлиенте
Процедура НачатьВыполнениеЗагрузки(Результат, Параметры) Экспорт
     
    Если НЕ Результат = КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли;
 
    ВыполнитьЗагрузкуНаСервере(АдресХранения, Объект.Организация, Объект.ПодразделениеОрганизации, ПерваяСтрока, ПоследняяСтрока, 
                                     Объект.ДатаПринятияКУчету);
     
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузкуНаСервере(АдресХранения, Организация, ПодразделениеОрганизации, ПерваяСтрока, ПоследняяСтрока, ДатаПринятияКУчету)

	Если СокрЛП(ПутьКФайлу)="" Тогда
		ПоказатьПредупреждение(,,"Файл не выбран!"); 
		Возврат;
	КонецЕсли; 
	
	Файл = Новый Файл(ПутьКФайлу);
	Если Не Файл.Существует() Тогда
		ПоказатьПредупреждение(,"Выбранный файл не существует!"); 
		Возврат;
	КонецЕсли; 
	
	Состояние("Запуск Excel");
	xlШаблон = Новый COMОбъект("excel.application");
  
	//ОбъектExcel = Новый COMОбъект("Excel.Application");

	Состояние("Открытие файла");
	Попытка
		КнигаШаблон = xlШаблон.workbooks.open(ПутьКФайлу);
	Исключение
		Сообщить("Не возможно открыть выбранный файл!");
		xlШаблон.Quit();
	КонецПопытки;

	   
    Попытка
        xlШаблон.Sheets(1).Select();
    Исключение
        xlШаблон.ActiveWorkbook.Close();
        xlШаблон = 0;
         
		//Возврат "Ошибка при чтении файла: " + ПутьКФайлу;
    КонецПопытки;
     
    Version = xlШаблон.Version;
     
    Версия = Лев(Version, Найти(Version,".") - 1 );
     
    Если Версия = "8" тогда
        ФайлСтрок   = xlШаблон.Cells.CurrentRegion.Rows.Count;
        ФайлКолонок = Макс(xlШаблон.Cells.CurrentRegion.Columns.Count, 13);
    Иначе
        ФайлСтрок   = xlШаблон.Cells(1,1).SpecialCells(11).Row;
        ФайлКолонок = xlШаблон.Cells(1,1).SpecialCells(11).Column;
    Конецесли;
	
	Док = СоздатьДокНаСервере(Организация, ПодразделениеОрганизации);
	
	Для НС = ПерваяСтрока по ПоследняяСтрока Цикл
		
		 ИнвНомер     = СтрЗаменить(СокрЛП(xlШаблон.Cells(НС, 3).Text), " ", "");
         Наименование = СокрЛП(xlШаблон.Cells(НС, 2).Text);
				 
		 Если ИнвНомер = "" И Наименование = "" Тогда
		    Продолжить;
		 КонецЕсли;		 
		 
		 мГруппаОС = СокрЛП(xlШаблон.Cells(НС, 8).Text);
		 НайдОС = СоздатьОСНаСервере(ИнвНомер, Наименование, мГруппаОС);
		 Если СокрЛП(xlШаблон.Cells(НС, 2).Text) <> "" Тогда	 
			Года = СокрЛП(xlШаблон.Cells(НС, 5).Text);
			ФИО = СокрЛП(xlШаблон.Cells(НС, 7).Text);
			ДобавитьВДокНаСервере(Док, НайдОС, ДатаПринятияКУчету, Года, ФИО); 
		КонецЕсли;		 
		
		//Загружено = Загружено + 1;
			
	КонецЦикла;
	
	Сообщить(" Создан документ " + Док + ". Проведите его!");

    Сообщить("Все.");
 
    xlШаблон.DisplayAlerts = 0;
    xlШаблон.Quit();
    xlШаблон.DisplayAlerts = 1;

КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогВыбораФайла								=	Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.Фильтр						=	"Файл Excel (*.xls; *.xlsx)|*.xls; *.xlsx; *.csv";
	ДиалогВыбораФайла.Расширение					=	"*.xls";
	
	ДиалогВыбораФайла.Заголовок						=	"Выберите файл";
	ДиалогВыбораФайла.ПредварительныйПросмотр		=	Ложь;
	ДиалогВыбораФайла.ИндексФильтра					=	0;
	ДиалогВыбораФайла.ПолноеИмяФайла				=	ПутьКФайлу;
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла	=	Истина;
	Если ДиалогВыбораФайла.Выбрать() Тогда
		ПутьКФайлу = ДиалогВыбораФайла.ПолноеИмяФайла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВыделитьСлово(ИсходнаяСтрока, СчетчикВызова) Экспорт
	
	Буфер = СокрЛ(ИсходнаяСтрока);
	ПозицияПослПробела = Найти(Буфер, " ");
	
	Если (ПозицияПослПробела = 0)
		 Или (СчетчикВызова >= 3) Тогда
		ИсходнаяСтрока = "";
		Возврат Буфер;
	КонецЕсли;
	
	ВыделенноеСлово = СокрЛП(Лев(Буфер, ПозицияПослПробела));
	ИсходнаяСтрока = Сред(ИсходнаяСтрока, ПозицияПослПробела + 1);
	
	Возврат ВыделенноеСлово;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьМОЛ(ФИ) Экспорт
	
	МОЛ = НайтиМОЛ(ФИ);	
	Возврат МОЛ;
	
КонецФункции

&НаСервереБезКонтекста
Функция НайтиМОЛ(ФИ) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст ="ВЫБРАТЬ
	              |	ФизическиеЛица.Ссылка КАК Ссылка
	              |ИЗ
	              |	Справочник.ФизическиеЛица КАК ФизическиеЛица
	              |ГДЕ
	              |	ФизическиеЛица.Наименование ПОДОБНО &ФИ ";
	
	Запрос.УстановитьПараметр("ФИ", "%"+ ФИ+ "%");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ССылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;	
	
КонецФункции	

&НаСервере
Функция СоздатьДокНаСервере(Организация, ПодразделениеОрганизации) Экспорт
	
	Док = Документы.ВводНачальныхОстатковОСЗабаланс.СоздатьДокумент();
	  
	Док.Дата = ТекущаяДата();
	
	Док.Организация = Организация;
		
	ТекПользователь = ПараметрыСеанса.ТекущийПользователь;
	
	Док.Автор = ТекПользователь;
	Док.Ответственный = ТекПользователь;

	Док.ПодразделениеОрганизации = ПодразделениеОрганизации;
	Док.СтруктурноеПодразделение = Организация;
	Док.ОтражатьВБухгалтерскомУчете = Истина;
	
	//ДокОбъект = Док.ПолучитьОбъект();
	Док.Записать(РежимЗаписиДокумента.Запись);
	
	Возврат Док.Ссылка;
	
КонецФункции

&НаСервере
Функция СоздатьОСНаСервере(ИнвНомер, Наименование, ГруппаОС) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
		                |	ОС.Ссылка КАК Ссылка,
		                |	ОС.Родитель КАК Родитель
		                |ИЗ
		                |	Справочник.ОсновныеСредства КАК ОС
		                |ГДЕ
		                |	ОС.ПометкаУдаления = Ложь
		                |	И ОС.Наименование = &Наименование
					    |	И ОС.ИнвНомер = &ИнвНомер
		                |	И ОС.Родитель = &Родитель";
		 
		 Запрос.УстановитьПараметр("Наименование",Наименование); 
		 Запрос.УстановитьПараметр("ИнвНомер",ИнвНомер); 
		 Запрос.УстановитьПараметр("Родитель",Справочники.ОсновныеСредства.НайтиПоНаименованию("_Забалансовые ОС"));
		 Выборка = Запрос.Выполнить().Выбрать();
		 Если Выборка.Следующий() Тогда
			 НовоеОС = Выборка.Ссылка;
		 Иначе // добавляем
			 НовоеОС = Справочники.ОсновныеСредства.СоздатьЭлемент();
			 НовоеОС.НаименованиеПолное = Наименование;
			 НовоеОС.Наименование = Наименование;
			 Если СтрНайти(ГруппаОС, "оргтехника и компьютеры") > 0 Тогда
				 НовоеОС.ГруппаОС = Перечисления.ГруппыОС.ОргтехникаИКомпьютеры;
			 ИначеЕсли	СтрНайти(ГруппаОС, "Инструменты,производственный и хозяйстственный инвентарь") > 0 Тогда
				 НовоеОС.ГруппаОС = Перечисления.ГруппыОС.ИнструментПроизводственныйИХозИнвентарь;
			 ИначеЕсли СтрНайти(ГруппаОС, "Офисная мебель") > 0 Тогда
				 НовоеОС.ГруппаОС = Перечисления.ГруппыОС.ОфиснаяМебель;
			 ИначеЕсли СтрНайти(ГруппаОС, "Транспортные средства") > 0  Тогда
				 НовоеОС.ГруппаОС = Перечисления.ГруппыОС.ТранспортныеСредства;
			 Иначе
				 НовоеОС.ГруппаОС = Перечисления.ГруппыОС.МашиныИОборудование;
			 КонецЕсли;
			 НовоеОС.ИнвНомер = ИнвНомер;
			 НовоеОС.Родитель = Справочники.ОсновныеСредства.НайтиПоНаименованию("_Забалансовые ОС");
			 НовоеОС.Записать();
			 ОСКод = НовоеОС.Код;
			 НовоеОС = Справочники.ОсновныеСредства.НайтиПоКоду(ОСКод); 
		 КонецЕсли;

	Возврат НовоеОС;
КонецФункции

&НаСервере
Процедура ДобавитьВДокНаСервере(Док, НайдОС, ДатаПринятияКУчету, Года, ФИО) Экспорт
	
	        ДокОбъект = Док.ПолучитьОбъект();
			ДокОС = ДокОбъект.ОС.Добавить();
			ДокОС.ОсновноеСредство = НайдОС;
			ДокОС.ГрафикАмортизацииБУ = Справочники.ГодовыеГрафикиАмортизацииОС.НайтиПоКоду("000000001");
			ДокОС.ДатаПринятияКУчетуРегл = ДатаПринятияКУчету;
			ДокОС.ИнвентарныйНомерРегл = НайдОС.ИнвНомер;
			//ФИО = СокрЛП(ОбъектExcel.Cells(НС, 7).Text);
			Фамилия  = ВыделитьСлово(ФИО, 1);
			Имя      = ВыделитьСлово(ФИО, 2);
			//Отчество = ВыделитьСлово(ФИО, 3);
			мФИО =  СокрЛП(Фамилия) + " " + Лев(Имя,1);
			ДокОС.МОЛ = ПолучитьМОЛ(мФИО);
			ДокОС.НомерДокументаПринятияКУчетуРегл = 1;
			ДокОС.СостояниеПринятияКУчетуРегл =  Справочники.СобытияОС.НайтиПоНаименованию("Принято к учету"); 
			ДокОС.СпособПоступленияРегл = Перечисления.СпособыПоступленияАктивов.Иное;
			КолвоЛет = Число(Сред(Года,1,1));
			ДокОС.СрокПолезногоИспользованияБУ = Окр(КолвоЛет *12);  // в месяцах
			ДокОС.СчетУчетаБУ = ПланыСчетов.Типовой.НайтиПоКоду("9040");
			ДокОС.СчетУчетаЗатратПоМодернизацииБУ = ПланыСчетов.Типовой.НайтиПоКоду("2933");
			ДокОС.СчетДоходовОтРеализацииБУ = ПланыСчетов.Типовой.НайтиПоКоду("6210");
			ДокОС.СчетСебестоимостиПриРеализацииБУ = ПланыСчетов.Типовой.НайтиПоКоду("7410");
			ДокОС.ПризнакФиксированногоАктива = Ложь;
			ДокОС.ОбъектИмущественногоНалога = Ложь;
			ДокОС.ОбъектТранспортногоНалога = Ложь;
			ДокОС.ОбъектЗемельногоНалога = Ложь;
			
			Сообщить(" Основное средство " + НайдОС  + " с инвентарным номером " + НайдОС.ИнвНомер + " обработано");
			
			ДокОбъект.Записать(РежимЗаписиДокумента.Запись);

КонецПроцедуры

&НаСервере
Функция ЗаписатьНаСервер(АдресХранилища, Расширение) Экспорт

               

                ЛокальныйАдресКаталога = КаталогВременныхФайлов();                     

               

                // Проверим существует ли указанный каталог

                КаталогЗаписи = Новый Файл(ЛокальныйАдресКаталога);

               

                ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресХранилища);

                ПутьКФайлу = Новый УникальныйИдентификатор;

               

                Попытка            

                               // Записать файл на сервере

                               ДвоичныеДанные.Записать(ЛокальныйАдресКаталога  + "\" + ПутьКФайлу + Расширение);  

                Исключение                   

                               ЗаписьЖурналаРегистрации("Запись htm-файла на сервере.", УровеньЖурналаРегистрации.Ошибка, , ,ОписаниеОшибки());

                КонецПопытки;

               

                ПутьФайлаНаСервере = ЛокальныйАдресКаталога  + "\" + ПутьКФайлу + Расширение;

               

                Возврат ПутьФайлаНаСервере;

               

			КонецФункции

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогВыбораФайла								=	Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.Фильтр						=	"Файл Excel (*.xls; *.xlsx)|*.xls; *.xlsx; *.csv";
	ДиалогВыбораФайла.Расширение					=	"*.xls";
	
	ДиалогВыбораФайла.Заголовок						=	"Выберите файл";
	ДиалогВыбораФайла.ПредварительныйПросмотр		=	Ложь;
	ДиалогВыбораФайла.ИндексФильтра					=	0;
	ДиалогВыбораФайла.ПолноеИмяФайла				=	ПутьКФайлу;
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла	=	Истина;
	Если ДиалогВыбораФайла.Выбрать() Тогда
		ПутьКФайлу = ДиалогВыбораФайла.ПолноеИмяФайла;
	КонецЕсли;

КонецПроцедуры
