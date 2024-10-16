﻿&НаСервере
Процедура СоздатьТаблицуНаСервере(Текст)

	Результат = СоздатьТаблицуЗначений(Текст);
    НоваяТаблицаЗначений = Результат.ТаблицаЗначений;
	
	СписокКолонок.Очистить();
	Для Сч=0 По НоваяТаблицаЗначений.Колонки.Количество()-1 Цикл
		СписокКолонок.Добавить(СтрЗаменить(СокрЛП(Сч),Символы.НПП,""));
	КонецЦикла;
	
    // Чтобы воспользоваться методом управляемой формы
    // ИзменитьРеквизиты(ДобавляемыеРеквизиты, УдаляемыеРеквизиты)
    // надо сформировать два массива: ДобавляемыеРеквизиты и
    // УдаляемыеРеквизиты
    
    // Удаляемые реквизиты: колонки старой таблицы значений
    РеквизитДанныеТаблицы = РеквизитФормыВЗначение("ДанныеТаблицы");
    УдаляемыеРеквизиты = Новый Массив();
    Для Каждого Колонка Из РеквизитДанныеТаблицы.Колонки Цикл
        УдаляемыеРеквизиты.Добавить("ДанныеТаблицы." + Колонка.Имя);       
    КонецЦикла;
    
    // Добавляемые реквизиты: колонки новой таблицы значений
    ДобавляемыеРеквизиты = Новый Массив();
    Для Каждого Колонка Из НоваяТаблицаЗначений.Колонки Цикл
        МассивТипов = Новый Массив();
        МассивТипов.Добавить(Колонка.ТипЗначения);
        НоваяКолонка = Новый РеквизитФормы(
            Колонка.Имя,
            Новый ОписаниеТипов(МассивТипов),
            "ДанныеТаблицы", Колонка.Заголовок
        );
        ДобавляемыеРеквизиты.Добавить(НоваяКолонка);
    КонецЦикла;
    
    // Удаляем старые реквизиты и добавляем новые
    ИзменитьРеквизиты(ДобавляемыеРеквизиты, УдаляемыеРеквизиты);
    
    // Присваиваем новое значение реквизиту формы
    ЗначениеВРеквизитФормы(НоваяТаблицаЗначений, "ДанныеТаблицы");
    
    // Теперь удаляем таблицу с формы и добавляем ее заново.
    // После этого в цикле добавляем колонки таблицы и для
    // каждой указываем наименование, тип, родителя и путь
    // к данным
    
    // Удаляем таблицу с формы
    ЭлементТаблица = Элементы.Найти("МояТаблицаФормы");
    Если ЭлементТаблица <> Неопределено Тогда
        Элементы.Удалить(ЭлементТаблица);       
    КонецЕсли;    
    // И добавляем ее заново
    ЭлементТаблица = Элементы.Добавить("МояТаблицаФормы", Тип("ТаблицаФормы"), Элементы.ГруппаПросмотр);
    ЭлементТаблица.ПутьКДанным = "ДанныеТаблицы";
    ЭлементТаблица.Отображение = ОтображениеТаблицы.Список;
	ЭлементТаблица.ПоложениеЗаголовка=ПоложениеЗаголовкаЭлементаФормы.Нет;
	//ЭлементТаблица.Заголовок = "Просмотр (первые 10 строк)";
	ЭлементТаблица.КоманднаяПанель.Видимость=Ложь;
    
    // Выводим на форму колонки таблицы
    ЭлементТаблица = Элементы.МояТаблицаФормы;
    Для Каждого Колонка Из НоваяТаблицаЗначений.Колонки Цикл
        НовыйЭлементФормы = Элементы.Добавить(
            "ДанныеТаблицы" + Колонка.Имя,
            Тип("ПолеФормы"),
            ЭлементТаблица
        );
        НовыйЭлементФормы.Вид = ВидПоляФормы.ПолеВвода;
        НовыйЭлементФормы.ПутьКДанным = "ДанныеТаблицы." + Колонка.Имя;
    КонецЦикла;
        
КонецПроцедуры

&НаСервере
Функция СоздатьТаблицуЗначений(Текст)
	Результат = Новый Структура;
	Результат.Вставить("Строк", 0);
	Результат.Вставить("ТаблицаЗначений");

	ТаблицаЗначений = Новый ТаблицаЗначений();
	
	Если Текст.КоличествоСтрок()=0 Тогда
		Результат.ТаблицаЗначений=ТаблицаЗначений;
		Возврат Результат
	КонецЕсли;
	
	Если Объект.Разделитель="\t" Тогда
		Разделитель=Символы.Таб
	ИначеЕсли Объект.Разделитель="\v" Тогда
		Разделитель=Символы.ВТаб
	ИначеЕсли Объект.Разделитель="\r" Тогда
		Разделитель=Символы.ВК
	ИначеЕсли Объект.Разделитель="\n" Тогда
		Разделитель=Символы.ПС
	ИначеЕсли Объект.Разделитель="\0" Тогда
		Разделитель=Null
	Иначе
		Разделитель=Объект.Разделитель
	КонецЕсли;
	
	Строка1=Текст.ПолучитьСтроку(1);
	Колонки=СтрРазделить(Строка1,Разделитель);
	КоличествоКолонок=Колонки.Количество();
	Для Сч=0 По Колонки.Количество()-1 Цикл
		ТаблицаЗначений.Колонки.Добавить("К"+СтрЗаменить(Сч,Символы.НПП,""),,СокрЛП(Сч));
	КонецЦикла;
	
	Для Сч=1 По Текст.КоличествоСтрок() Цикл
		Строка = Текст.ПолучитьСтроку(Сч);
		Колонки=СтрРазделить(Строка,Разделитель);
        НоваяСтрока = ТаблицаЗначений.Добавить();
		Для Сч1=0 По КоличествоКолонок-1 Цикл
			НоваяСтрока[Сч1]=Колонки[Сч1]
		КонецЦикла;
	КонецЦикла;
	
	Результат = Новый Структура;
	//Результат.Вставить("Строк", Строки.Количество());
	Результат.Вставить("ТаблицаЗначений", ТаблицаЗначений);
    Возврат Результат

КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.Разделитель.СписокВыбора.Добавить(",", "Запятая");
	Элементы.Разделитель.СписокВыбора.Добавить(" ", "Пробел");
	Элементы.Разделитель.СписокВыбора.Добавить("\t", "Табулятор");
	Элементы.Разделитель.СписокВыбора.Добавить("\v", "Вертикальный табулятор");
	//Элементы.Разделитель.СписокВыбора.Добавить("\\", "Обратная дробь");
	Элементы.Разделитель.СписокВыбора.Добавить("\r", "Возврат каретки");
	Элементы.Разделитель.СписокВыбора.Добавить("\n", "Новая строка");
	Элементы.Разделитель.СписокВыбора.Добавить("\0", "Null");
	
	Элементы.ВыходныеФайлыСоединитель.СписокВыбора.Добавить(",", "Запятая");
	Элементы.ВыходныеФайлыСоединитель.СписокВыбора.Добавить(" ", "Пробел");
	Элементы.ВыходныеФайлыСоединитель.СписокВыбора.Добавить("\t", "Табулятор");
	Элементы.ВыходныеФайлыСоединитель.СписокВыбора.Добавить("\v", "Вертикальный табулятор");
	Элементы.ВыходныеФайлыСоединитель.СписокВыбора.Добавить("\\", "Обратная дробь");
	Элементы.ВыходныеФайлыСоединитель.СписокВыбора.Добавить("\r", "Возврат каретки");
	Элементы.ВыходныеФайлыСоединитель.СписокВыбора.Добавить("\n", "Новая строка");
	Элементы.ВыходныеФайлыСоединитель.СписокВыбора.Добавить("\0", "Null");
	
	Нейро_РаботаСФайлами.ПолучитьКаталогНейроконструктора(ЭтотОбъект);
КонецПроцедуры


&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Режим = РежимДиалогаВыбораФайла.Открытие;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	Файл = Новый Файл(Объект.ПутьКФайлу);
	//ПутьКФайлу=Объект.ПутьКФайлу;
	//Поз=СтрНайти(ПутьКФайлу, "\", НаправлениеПоиска.СКонца);
	//Если Поз>0 Тогда
	//	ДиалогОткрытияФайла.Каталог=Лев(ПутьКФайлу, Поз)
	//КонецЕсли;
	ДиалогОткрытияФайла.Каталог=Файл.Путь;
	ДиалогОткрытияФайла.ПолноеИмяФайла = Файл.ПолноеИмя;
	Фильтр = "Текстовые файлы (*.txt)|*.txt|Все файлы (*.*)|*.*";
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	Если Файл.Расширение<>".txt" Тогда
		ДиалогОткрытияФайла.ИндексФильтра=1;
	КонецЕсли;
	ДиалогОткрытияФайла.Заголовок = "Укажите имя исходной таблицы";	
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ОпОп = Новый ОписаниеОповещения("ПослеЗакрытияДиалогаВыбораВыходногоФайла", ЭтотОбъект);
	ДиалогОткрытияФайла.Показать(ОпОп);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияДиалогаВыбораВыходногоФайла(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	Если ВыбранныеФайлы=Неопределено Тогда Возврат КонецЕсли;
	Объект.ПутьКФайлу = ВыбранныеФайлы[0];
	
	Если ИзДокумента Тогда
		Инфо = Новый Файл(ВыбранныеФайлы[0]);
		Для Каждого СтрСлой Из Объект.ВыходныеФайлы Цикл
			Если СтрСлой.ПутьКФайлу<>"" Тогда
				Файл=Новый Файл(СтрСлой.ПутьКФайлу);
				Если СтрСлой.ПутьКСловарю<>"" И Файл.Расширение<>".txt" Тогда
					СтрСлой.ПутьКФайлу = Файл.Путь+Файл.ИмяБезРасширения+".txt";
				ИначеЕсли СтрСлой.ПутьКСловарю="" И Файл.Расширение=".txt" Тогда
					СтрСлой.ПутьКФайлу = Файл.Путь+Файл.ИмяБезРасширения+".npy";
				КонецЕсли;
			Иначе
				Если СтрСлой.ПутьКСловарю<>"" Тогда
					СтрСлой.ПутьКФайлу = Инфо.Путь+СтрСлой.ИмяСлоя+".txt";
				Иначе
					СтрСлой.ПутьКФайлу = Инфо.Путь+СтрСлой.ИмяСлоя+".npy";
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	//ТабДок = Новый ТабличныйДокумент;
	//ТабДок.Прочитать(Объект.ПутьКФайлу, СпособЧтенияЗначенийТабличногоДокумента.Текст);
	
	Текст = ПрочитатьИзФайла(Объект.ПутьКФайлу, Объект.ПропуститьСтрок, ПросматриватьСтрок);
	СоздатьТаблицуНаСервере(Текст);
	//Модифицированность=Истина;
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	Если СокрЛП(Объект.ПутьКФайлу)="" Тогда Возврат КонецЕсли;
	Если ИзДокумента Тогда
		Инфо = Новый Файл(Объект.ПутьКФайлу);
		Для Каждого СтрСлой Из Объект.ВыходныеФайлы Цикл
			Если СтрСлой.ПутьКФайлу<>"" Тогда
				Файл=Новый Файл(СтрСлой.ПутьКФайлу);
				Если СтрСлой.ПутьКСловарю<>"" И Файл.Расширение<>".txt" Тогда
					СтрСлой.ПутьКФайлу = Файл.Путь+Файл.ИмяБезРасширения+".txt";
				ИначеЕсли СтрСлой.ПутьКСловарю="" И Файл.Расширение=".txt" Тогда
					СтрСлой.ПутьКФайлу = Файл.Путь+Файл.ИмяБезРасширения+".npy";
				КонецЕсли;
			Иначе
				Если СтрСлой.ПутьКСловарю<>"" Тогда
					СтрСлой.ПутьКФайлу = Инфо.Путь+СтрСлой.ИмяСлоя+".txt";
				Иначе
					СтрСлой.ПутьКФайлу = Инфо.Путь+СтрСлой.ИмяСлоя+".npy";
				КонецЕсли;
			КонецЕсли;
			//Если СтрСлой.ПутьКФайлу <> "" Тогда продолжить КонецЕсли;
			//СтрСлой.ПутьКФайлу = Инфо.Путь+СтрСлой.ИмяСлоя+".npy";
		КонецЦикла;
	КонецЕсли;

	Текст = ПрочитатьИзФайла(Объект.ПутьКФайлу, Объект.ПропуститьСтрок, ПросматриватьСтрок);
	СоздатьТаблицуНаСервере(Текст);
КонецПроцедуры

&НаКлиенте
Процедура ВыходныеФайлыПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Режим = РежимДиалогаВыбораФайла.Сохранение;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	Файл = Новый Файл(Элементы.ВыходныеФайлы.ТекущиеДанные.ПутьКФайлу);
	//ПутьКФайлу=Элементы.ВыходныеФайлы.ТекущиеДанные.ПутьКФайлу;
	ДиалогОткрытияФайла.ПолноеИмяФайла = Файл.ПолноеИмя;
	//Поз=СтрНайти(ПутьКФайлу, "\", НаправлениеПоиска.СКонца);
	//Если Поз>0 Тогда
	//	ДиалогОткрытияФайла.Каталог=Лев(ПутьКФайлу, Поз)
	//КонецЕсли;
	ДиалогОткрытияФайла.Каталог=Файл.Путь;
	Если Элементы.ВыходныеФайлы.ТекущиеДанные.ПутьКСловарю<>"" Тогда
		Фильтр = НСтр("ru = 'Текстовый файл'; en = 'Text file'")+ "(*.txt)|*.txt";
		ДиалогОткрытияФайла.Заголовок = "Укажите имя файла";	
	Иначе
		Фильтр = НСтр("ru = 'Двоичный файл в формате NumPy'; en = 'Binary file in NumPy format'")+ "(*.npy)|*.npy";
		ДиалогОткрытияФайла.Заголовок = "Укажите имя файла в формате NPY";	
	КонецЕсли;
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ОпОп = Новый ОписаниеОповещения("ПослеЗакрытияДиалогаВыбораФайлаNPY", ЭтотОбъект);
	ДиалогОткрытияФайла.Показать(ОпОп);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияДиалогаВыбораФайлаNPY(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	Если ВыбранныеФайлы=Неопределено Тогда Возврат КонецЕсли;
	Элементы.ВыходныеФайлы.ТекущиеДанные.ПутьКФайлу = ВыбранныеФайлы[0];
КонецПроцедуры

&НаКлиенте
Процедура ВыходныеФайлыПутьКСловарюНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	Если Элементы.ВыходныеФайлы.ТекущиеДанные.СоздаватьСловарь Тогда
		Режим = РежимДиалогаВыбораФайла.Сохранение;
	Иначе
		Режим = РежимДиалогаВыбораФайла.Открытие;
	КонецЕсли;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ПутьКФайлу=Элементы.ВыходныеФайлы.ТекущиеДанные.ПутьКСловарю;
	ДиалогОткрытияФайла.ПолноеИмяФайла = ПутьКФайлу;
	Поз=СтрНайти(ПутьКФайлу, "\", НаправлениеПоиска.СКонца);
	Если Поз>0 Тогда
		ДиалогОткрытияФайла.Каталог=Лев(ПутьКФайлу, Поз)
	КонецЕсли;
	Фильтр = НСтр("ru = 'JavaScript Object Notation '; en = 'JavaScript Object Notation '")+ "(*.json)|*.json";
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.Заголовок = "Укажите имя файла для словаря";	
	
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ОпОп = Новый ОписаниеОповещения("ПослеЗакрытияДиалогаВыбораФайлаСловаря", ЭтотОбъект);
	ДиалогОткрытияФайла.Показать(ОпОп);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияДиалогаВыбораФайлаСловаря(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	Если ВыбранныеФайлы=Неопределено Тогда Возврат КонецЕсли;
	Элементы.ВыходныеФайлы.ТекущиеДанные.ПутьКСловарю = ВыбранныеФайлы[0];
	ПриИзмененииФайлаСловаря();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПросматриватьСтрок=1;	
	Если Параметры.Свойство("ИменаСлоев") Тогда
		Элементы.ВыходныеФайлыИмяСлоя.Видимость=Истина;
		Элементы.ВыходныеФайлы.КоманднаяПанель.Видимость=Ложь;
		ИзДокумента=Истина;
		Для Каждого ИмяСлоя Из Параметры.ИменаСлоев Цикл
			НоваяСтрока = Объект.ВыходныеФайлы.Добавить();
			НоваяСтрока.ИмяСлоя = ИмяСлоя;
		КонецЦикла;
	КонецЕсли;
	Если Параметры.Свойство("ПутьККаталогу") Тогда
		Объект.ПутьККаталогу=Параметры.ПутьККаталогу
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыходныеФайлыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если ИзДокумента Тогда Отказ=Истина; Возврат КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыходныеФайлыПередУдалением(Элемент, Отказ)
	Если ИзДокумента Тогда Отказ=Истина; Возврат КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыходныеФайлыКолонкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Колонки = СтрРазделить(Элементы.ВыходныеФайлы.ТекущиеДанные.Колонки,",",Ложь);
	Для Каждого Элемент Из СписокКолонок Цикл
		Элемент.Пометка=Ложь
	КонецЦикла;
	Для Каждого Колонка Из Колонки Цикл
		Элемент = СписокКолонок.НайтиПоЗначению(СокрЛП(Колонка));
		Если Элемент<>Неопределено Тогда Элемент.Пометка=Истина КонецЕсли;
	КонецЦикла;
	Оповещение = Новый ОписаниеОповещения("ПослеОтметкиЭлементов", ЭтотОбъект);
	СписокКолонок.ПоказатьОтметкуЭлементов(Оповещение, "Выберите колонки");
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтметкиЭлементов(Список, Параметры) Экспорт
    Если Список = Неопределено Тогда Возврат КонецЕсли;
	ТекстКолонки="";
	Для каждого Элемент из Список Цикл
		Если НЕ Элемент.Пометка Тогда Продолжить КонецЕсли;
		Если ТекстКолонки<>"" Тогда ТекстКолонки=ТекстКолонки+", " КонецЕсли;
		ТекстКолонки=ТекстКолонки+СтрЗаменить(СокрЛП(Элемент.Значение),Символы.НПП,"");
	КонецЦикла;
	Элементы.ВыходныеФайлы.ТекущиеДанные.Колонки=ТекстКолонки;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСоздание(Команда)
	Если Объект.ПутьККаталогу="" Тогда
		Доп=Новый Структура("Имя, Приемник", "Data", "ПутьККаталогу");
		Оп = Новый ОписаниеОповещения("ВыполнитьПродолжить", ЭтотОбъект, Доп);
		Нейро_РаботаСФайлами.НачатьПроверкуСуществованияКаталога(Оп);
	Иначе
		СформироватьИВыполнить()
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПродолжить(Результат, ДополнительныеПараметры) Экспорт
	Объект.ПутьККаталогу=ПутьККаталогу;
	СформироватьИВыполнить();
КонецПроцедуры

&НаКлиенте
Процедура СформироватьИВыполнить()
	ПрефиксИмени = "Table_"+Формат(ТекущаяДата(),"ДФ=""ггММддЧЧммсс""");
	СтруктураПараметров=Новый Структура;
	СтруктураПараметров.Вставить("ФайлОшибок", ПрефиксИмени+"_err.txt");
	СтруктураПараметров.Вставить("ФайлСообщений", ПрефиксИмени+"_msg.txt");
	СтруктураПараметров.Вставить("ИдентификаторFromJSON", Нейро_ОбщийМодуль.ПолучитьИдентификаторИзРегистра("TokenizerFromJSON"));

	ТекстПрограммы = СформироватьТекстПрограммы(СтруктураПараметров);
	
	Оп = Новый ОписаниеОповещения("ВыполнитьЗавершение", ЭтотОбъект, СтруктураПараметров);
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("КаталогВыполнения", Объект.ПутьККаталогу);
	ДопПараметры.Вставить("ФайлПрограммы", ПрефиксИмени+".py");
	ДопПараметры.Вставить("ФайлОшибок", ПрефиксИмени+"_err.txt");
	ДопПараметры.Вставить("ФайлСообщений", ПрефиксИмени+"_msg.txt");
	ДопПараметры.Вставить("Оповещение", Оп);
	ОпОшибка = Новый ОписаниеОповещения("ОшибкаВыполнения", ЭтотОбъект, СтруктураПараметров);
	ДопПараметры.Вставить("ОповещениеОбОшибке", ОпОшибка);
	Если НЕ Нейро_ОбщийМодуль.ПолучитьНастройку("УдалятьФайлыПослеВыполнения") Тогда
		ДопПараметры.Вставить("НеУдалятьФайлы", );
	КонецЕсли;
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(ТекстПрограммы);
	Нейро_РаботаСФайлами.ЗаписатьИВыполнитьПрограммуНаПитоне(ТекстовыйДокумент, ДопПараметры);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Результат = Новый Массив;
	Для Каждого СтрокаТЧ Из Объект.ВыходныеФайлы Цикл
		СтрокаВыходная = Новый Структура("ИмяСлоя,ПутьКФайлу,ТипДанных,Разделитель,ПутьКСловарю");
		СтрокаВыходная.ИмяСлоя = СтрокаТЧ.ИмяСлоя;
		СтрокаВыходная.ПутьКФайлу = СтрокаТЧ.ПутьКФайлу;
		СтрокаВыходная.ТипДанных = СтрокаТЧ.ТипДанных;
		СтрокаВыходная.Разделитель = СтрокаТЧ.Соединитель;
		СтрокаВыходная.ПутьКСловарю = СтрокаТЧ.ПутьКСловарю;
		Результат.Добавить(СтрокаВыходная);
	КонецЦикла;
	Закрыть(Результат);
КонецПроцедуры

&НаКлиенте
Процедура ОшибкаВыполнения(Результат, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

&НаСервере
Функция СформироватьТекстПрограммы(Параметры)
	ДокОбъект = РеквизитФормыВЗначение("Объект");
	Возврат ДокОбъект.СформироватьТекстПрограммы(Объект, Параметры);
КонецФункции

&НаКлиенте
Функция ПрочитатьИзФайла(ПутьКФайлу, Знач ПропуститьСтрок, Знач КоличествоСтрок)
	Результат=Новый ТекстовыйДокумент;
	Текст = Новый ЧтениеТекста(ПутьКФайлу, КодировкаТекста.ANSI);
	Пока ПропуститьСтрок>0 Цикл
		Стр = Текст.ПрочитатьСтроку();
		Если Стр = Неопределено Тогда Возврат Результат КонецЕсли;
		ПропуститьСтрок=ПропуститьСтрок-1;
	КонецЦикла;
	Пока КоличествоСтрок>0 Цикл
		Стр = Текст.ПрочитатьСтроку();
		Если Стр = Неопределено Тогда Возврат Результат КонецЕсли;
		Результат.ДобавитьСтроку(Стр);
		КоличествоСтрок=КоличествоСтрок-1;
	КонецЦикла;
	Возврат Результат
КонецФункции

&НаКлиенте
Процедура ПриИзмененииФайлаСловаря()
	Если Элементы.ВыходныеФайлы.ТекущиеДанные=Неопределено Тогда Возврат КонецЕсли;
	СтрСлой=Элементы.ВыходныеФайлы.ТекущиеДанные;
	Если ИзДокумента Тогда
		Инфо = Новый Файл(Объект.ПутьКФайлу);
		Если СтрСлой.ПутьКФайлу<>"" Тогда
			Файл=Новый Файл(СтрСлой.ПутьКФайлу);
			Если СтрСлой.ПутьКСловарю<>"" И Файл.Расширение<>".txt" Тогда
				СтрСлой.ПутьКФайлу = Файл.Путь+Файл.ИмяБезРасширения+".txt";
			ИначеЕсли СтрСлой.ПутьКСловарю="" И Файл.Расширение=".txt" Тогда
				СтрСлой.ПутьКФайлу = Файл.Путь+Файл.ИмяБезРасширения+".npy";
			КонецЕсли;
		Иначе
			Если СтрСлой.ПутьКСловарю<>"" Тогда
				СтрСлой.ПутьКФайлу = Инфо.Путь+СтрСлой.ИмяСлоя+".txt";
			Иначе
				СтрСлой.ПутьКФайлу = Инфо.Путь+СтрСлой.ИмяСлоя+".npy";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ВыходныеФайлыПутьКСловарюПриИзменении(Элемент)
	ПриИзмененииФайлаСловаря();
КонецПроцедуры


&НаКлиенте
Процедура ВыходныеФайлыПутьКСловарюОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	
	Если Элементы.ВыходныеФайлы.ТекущиеДанные.ПутьКСловарю="" Тогда Возврат КонецЕсли;
	
	Текст = Новый ЧтениеТекста(Элементы.ВыходныеФайлы.ТекущиеДанные.ПутьКСловарю);
	СтрокаJSON = Текст.Прочитать();
	Текст.Закрыть();
	
	ПараметрыД = Новый Структура;
	ПараметрыД.Вставить("ТекстМоделиJSON", СтрокаJSON);
	//Оп = Новый ОписаниеОповещения("ПослеПросмотраСловаряJSON", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.Нейро_ДеревоJSON", ПараметрыД, ЭтотОбъект, Истина, , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

