﻿
&НаКлиенте
Процедура РежимОписанияПриИзменении(Элемент)
	Если РежимОписания=0 Тогда
		Описание = ПолучитьОписание("ОписаниеОбщий");
	ИначеЕсли РежимОписания=1 Тогда
		Описание = ПолучитьОписание("ОписаниеЧастный");
    КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьОписание(ИмяМакета)
	ДокОбъект = РеквизитФормыВЗначение("Объект");
	Возврат ДокОбъект.ПолучитьМакет(ИмяМакета).ПолучитьТекст();
КонецФункции


&НаКлиенте
Процедура ВидПриИзменении(Элемент)
	ВидимостьЭлементовПриСменеОперации();
	Объект.Параметры.Очистить();
	Если Объект.Вид = ПредопределенноеЗначение("Перечисление.Нейро_ВидыПользовательскогоГенератора.Общий") Тогда
		РежимОписания=0;
		НоваяСтрока = Объект.Параметры.Добавить();
		НоваяСтрока.Вид = ПредопределенноеЗначение("Перечисление.Нейро_ПараметрыГенератора.НачальныйИндекс");
		НоваяСтрока.Имя = "min_index";
		НоваяСтрока.Тип = ПредопределенноеЗначение("Перечисление.Нейро_Типы.Целое");
		
		НоваяСтрока = Объект.Параметры.Добавить();
		НоваяСтрока.Вид = ПредопределенноеЗначение("Перечисление.Нейро_ПараметрыГенератора.КонечныйИндекс");
		НоваяСтрока.Имя = "max_index";
		НоваяСтрока.Тип = ПредопределенноеЗначение("Перечисление.Нейро_Типы.Целое");
		
		НоваяСтрока = Объект.Параметры.Добавить();
		НоваяСтрока.Вид = ПредопределенноеЗначение("Перечисление.Нейро_ПараметрыГенератора.Перемешивать");
		НоваяСтрока.Имя = "shuffle";
		НоваяСтрока.Тип = ПредопределенноеЗначение("Перечисление.Нейро_Типы.Булево");
		
		НоваяСтрока = Объект.Параметры.Добавить();
		НоваяСтрока.Вид = ПредопределенноеЗначение("Перечисление.Нейро_ПараметрыГенератора.РазмерПакета");
		НоваяСтрока.Имя = "batch_size";
		НоваяСтрока.Тип = ПредопределенноеЗначение("Перечисление.Нейро_Типы.Целое");
		
		НоваяСтрока = Объект.Параметры.Добавить();
		НоваяСтрока.Вид = ПредопределенноеЗначение("Перечисление.Нейро_ПараметрыГенератора.ВидДанных");
		НоваяСтрока.Имя = "subset";
		НоваяСтрока.Тип = ПредопределенноеЗначение("Перечисление.Нейро_Типы.Строка");
		
		НоваяСтрока = Объект.Параметры.Добавить();
		НоваяСтрока.Вид = ПредопределенноеЗначение("Перечисление.Нейро_ПараметрыГенератора.КоличествоОбразцов");
		НоваяСтрока.Имя = "nInputs";
		НоваяСтрока.Тип = ПредопределенноеЗначение("Перечисление.Нейро_Типы.Целое");
		
		НоваяСтрока = Объект.Параметры.Добавить();
		НоваяСтрока.Вид = ПредопределенноеЗначение("Перечисление.Нейро_ПараметрыГенератора.КоличествоЦелей");
		НоваяСтрока.Имя = "nOutputs";
		НоваяСтрока.Тип = ПредопределенноеЗначение("Перечисление.Нейро_Типы.Целое");
	ИначеЕсли Объект.Вид = ПредопределенноеЗначение("Перечисление.Нейро_ВидыПользовательскогоГенератора.Частный") Тогда
		РежимОписания=1;
		НоваяСтрока = Объект.Параметры.Добавить();
		НоваяСтрока.Вид = ПредопределенноеЗначение("Перечисление.Нейро_ПараметрыГенератора.Образцы");
		НоваяСтрока.Имя = "samples";
		НоваяСтрока = Объект.Параметры.Добавить();
		НоваяСтрока.Вид = ПредопределенноеЗначение("Перечисление.Нейро_ПараметрыГенератора.Цели");
		НоваяСтрока.Имя = "targets";
		НоваяСтрока = Объект.Параметры.Добавить();
		НоваяСтрока.Вид = ПредопределенноеЗначение("Перечисление.Нейро_ПараметрыГенератора.НачальныйИндекс");
		НоваяСтрока.Имя = "min_index";
		НоваяСтрока.Тип = ПредопределенноеЗначение("Перечисление.Нейро_Типы.Целое");
		НоваяСтрока = Объект.Параметры.Добавить();
		НоваяСтрока.Вид = ПредопределенноеЗначение("Перечисление.Нейро_ПараметрыГенератора.КонечныйИндекс");
		НоваяСтрока.Имя = "max_index";
		НоваяСтрока.Тип = ПредопределенноеЗначение("Перечисление.Нейро_Типы.Целое");
		НоваяСтрока = Объект.Параметры.Добавить();
		НоваяСтрока.Вид = ПредопределенноеЗначение("Перечисление.Нейро_ПараметрыГенератора.Перемешивать");
		НоваяСтрока.Имя = "shuffle";
		НоваяСтрока.Тип = ПредопределенноеЗначение("Перечисление.Нейро_Типы.Булево");
		НоваяСтрока = Объект.Параметры.Добавить();
		НоваяСтрока.Вид = ПредопределенноеЗначение("Перечисление.Нейро_ПараметрыГенератора.РазмерПакета");
		НоваяСтрока.Имя = "batch_size";
		НоваяСтрока.Тип = ПредопределенноеЗначение("Перечисление.Нейро_Типы.Целое");
		НоваяСтрока = Объект.Параметры.Добавить();
		НоваяСтрока.Вид = ПредопределенноеЗначение("Перечисление.Нейро_ПараметрыГенератора.ВидДанных");
		НоваяСтрока.Имя = "subset";
		НоваяСтрока.Тип = ПредопределенноеЗначение("Перечисление.Нейро_Типы.Строка");
	Иначе
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Ключ.Пустая() Или Параметры.Ключ.Вид.Пустая() Тогда
		Элементы.Вид.ТолькоПросмотр=Ложь
	КонецЕсли;
	Если Параметры.Ключ.Пустая() И Параметры.Свойство("ЗначенияЗаполнения") Тогда
		Если Параметры.ЗначенияЗаполнения.Свойство("Вид") Тогда
			//ВидПриИзменении(Элементы.Вид);
			Элементы.Вид.ТолькоПросмотр=Истина;
		КонецЕсли;
	КонецЕсли;
	Если Параметры.Ключ.Пустая() И Параметры.Свойство("ТекстЗаполнения") Тогда
		Если Параметры.ТекстЗаполнения<>"" Тогда
			Объект.Наименование=""
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВидимостьЭлементовПриСменеОперации();
	Если Параметры.Ключ.Пустая() И НЕ Объект.Вид.Пустая() Тогда
		ВидПриИзменении(Элементы.Вид);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидимостьЭлементовПриСменеОперации()
	Если Объект.Вид = ПредопределенноеЗначение("Перечисление.Нейро_ВидыПользовательскогоГенератора.Общий") Тогда
		РежимОписания=0;
		Описание = ПолучитьОписание("ОписаниеОбщий");
		Элементы.ГруппаИмпорт.Видимость = Истина;
		Элементы.ИмяГенератора.Видимость=Ложь;
	ИначеЕсли Объект.Вид = ПредопределенноеЗначение("Перечисление.Нейро_ВидыПользовательскогоГенератора.Частный") Тогда
		РежимОписания=1;
		Описание = ПолучитьОписание("ОписаниеЧастный");
		Элементы.ГруппаИмпорт.Видимость = Ложь;
		Элементы.ИмяГенератора.Видимость=Истина;
	Иначе
		РежимОписания=Неопределено;
		Описание="";
		Элементы.ИмяГенератора.Видимость=Ложь;
		Элементы.ГруппаИмпорт.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыВидНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	Элемент.СписокВыбора.Очистить();
	Элемент.СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.Нейро_ПараметрыГенератора.Дополнительный"));
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ВыборВидаПараметра", ЭтаФорма);
	ПоказатьВыборИзСписка(ОписаниеОповещенияОЗакрытии, Элемент.СписокВыбора, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ВыборВидаПараметра(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	Если ВыбранныйЭлемент<>Неопределено Тогда
		Элементы.Параметры.ТекущиеДанные.Вид = ВыбранныйЭлемент.Значение;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПараметрыПриАктивизацииСтроки(Элемент)
	Если Элемент.ТекущиеДанные=Неопределено Тогда возврат КонецЕсли;
	Если НЕ Элемент.ТекущиеДанные.Вид.Пустая() И Элемент.ТекущиеДанные.Вид<>ПредопределенноеЗначение("Перечисление.Нейро_ПараметрыГенератора.Дополнительный") Тогда
		Элементы.ПараметрыНомерСтроки.ТолькоПросмотр=Истина;
		Элементы.ПараметрыВид.ТолькоПросмотр=Истина;
		Элементы.ПараметрыИмя.ТолькоПросмотр=Истина;
		Элементы.ПараметрыТип.ТолькоПросмотр=Истина;
	Иначе
		Элементы.ПараметрыНомерСтроки.ТолькоПросмотр=Ложь;
		Элементы.ПараметрыВид.ТолькоПросмотр=Ложь;
		Элементы.ПараметрыИмя.ТолькоПросмотр=Ложь;
		Элементы.ПараметрыТип.ТолькоПросмотр=Ложь;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПараметрыПередУдалением(Элемент, Отказ)
	Если Элемент.ТекущиеДанные.Вид<>ПредопределенноеЗначение("Перечисление.Нейро_ПараметрыГенератора.Дополнительный") 
		И НЕ Элемент.ТекущиеДанные.Вид.Пустая() Тогда
		Отказ=Истина;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПараметрыИмяПриИзменении(Элемент)
	Элементы.Параметры.ТекущиеДанные.Имя = СтрЗаменить(Нейро_СозданиеМоделиНаСервере.Транслит(Элемент.ТекстРедактирования)," ", "_");
КонецПроцедуры


&НаКлиенте
Процедура УвеличитьОтступ(Команда)
	Строки = СтрРазделить(Объект.ТекстПрограммы, Символы.ПС);
	Результат = "";
	Для Сч=1 По СтрЧислоСтрок(Объект.ТекстПрограммы) Цикл
		Результат=Результат+"    "+СтрПолучитьСтроку(Объект.ТекстПрограммы,Сч)+"
		|";
	КонецЦикла;
	Объект.ТекстПрограммы=Результат;
КонецПроцедуры


&НаКлиенте
Процедура УменьшитьОтступ(Команда)
	ПробеловСлева=Неопределено;
	КоличествоПробелов=Новый Массив(СтрЧислоСтрок(Объект.ТекстПрограммы));
	Для Сч=1 По СтрЧислоСтрок(Объект.ТекстПрограммы) Цикл
		Строка = СтрПолучитьСтроку(Объект.ТекстПрограммы,Сч);
		Если СокрЛП(Строка)="" Тогда Продолжить КонецЕсли;
		ВсегоСлева=СтрДлина(Строка)-СтрДлина(СокрЛ(Строка));
		Если ВсегоСлева>4 Тогда ВсегоСлева=4 КонецЕсли;
		Если ПробеловСлева=Неопределено Тогда
			ПробеловСлева=ВсегоСлева
		ИначеЕсли ПробеловСлева>ВсегоСлева Тогда
			ПробеловСлева=ВсегоСлева
		КонецЕсли;
	КонецЦикла;
	Если ПробеловСлева=Неопределено Или ПробеловСлева=0 Тогда Возврат КонецЕсли;
	Результат = "";
	Для Сч=1 По СтрЧислоСтрок(Объект.ТекстПрограммы) Цикл
		Строка = СтрПолучитьСтроку(Объект.ТекстПрограммы,Сч);
		Если СокрЛП(Строка)="" Тогда 
			Результат=Результат+"
			|";
			Продолжить 
		КонецЕсли;
		Результат=Результат+Прав(Строка,СтрДлина(Строка)-ПробеловСлева)+"
		|";
	КонецЦикла;
	Объект.ТекстПрограммы=Результат;
КонецПроцедуры


&НаКлиенте
Процедура АлгоритмыПриАктивизацииСтроки(Элемент)
	Если Элемент.ТекущиеДанные=Неопределено Тогда Возврат КонецЕсли;
	Если Не Элемент.ТекущиеДанные.Алгоритм.Пустая() Тогда
		ПоказатьПараметрыАлгоритма(Элемент.ТекущиеДанные.Алгоритм);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПоказатьПараметрыАлгоритма(Алгоритм)
	ИмпортАлгоритмов.Очистить();
	ПараметрыАлгоритмов.Очистить();
	Для Каждого СтрокаИмпорт Из Алгоритм.Импорт Цикл
		НоваяСтрока = ИмпортАлгоритмов.Добавить();
		НоваяСтрока.Идентификатор = СтрокаИмпорт.Идентификатор
	КонецЦикла;
	Для Каждого СтрокаПараметр Из Алгоритм.Параметры Цикл
		НоваяСтрока = ПараметрыАлгоритмов.Добавить();
		НоваяСтрока.Имя = СтрокаПараметр.Имя;
		НоваяСтрока.Описание = СтрокаПараметр.Описание;
	КонецЦикла;
	ОписаниеАлгоритма = Алгоритм.Описание;
КонецПроцедуры


&НаКлиенте
Процедура АлгоритмыАлгоритмПриИзменении(Элемент)
	ПоказатьПараметрыАлгоритма(Элементы.Алгоритмы.ТекущиеДанные.Алгоритм)
КонецПроцедуры


&НаКлиенте
Процедура ПеренестиВТекст(Команда)
	ТекстВставки="";
	Для Каждого Идентификатор Из Элементы.Алгоритмы.ВыделенныеСтроки Цикл
		Если ТекстВставки<>"" Тогда 
			ТекстВставки=ТекстВставки+"
			|";
		КонецЕсли;
		СтрокаАлгоритм = Объект.Алгоритмы.НайтиПоИдентификатору(Идентификатор);
		Алгоритм = СтрокаАлгоритм.Алгоритм;
		СтруктураПараметры = ПараметрыАлгоритмаВСтроку(Алгоритм);
		//Для Каждого СтрокаПараметр Из Алгоритм.Параметры Цикл
		//	Если ТекстПараметры<>"" Тогда ТекстПараметры=ТекстПараметры+", " КонецЕсли;
		//	ТекстПараметры=ТекстПараметры+СтрокаПараметр.Имя
		//КонецЦикла;
		ТекстВставки=ТекстВставки+?(СтруктураПараметры.ВозвращаетРезультат,"result=","")+СтруктураПараметры.Идентификатор+"("+СтруктураПараметры.ТекстПараметры+")"
	КонецЦикла;
	Если ТекстВставки<>"" Тогда
		Объект.ТекстПрограммы=Объект.ТекстПрограммы+"
		|"+ТекстВставки+"
		|";
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПараметрыАлгоритмаВСтроку(Алгоритм)
	ТекстПараметры = "";
	Для Каждого СтрокаПараметр Из Алгоритм.Параметры Цикл
		Если ТекстПараметры<>"" Тогда ТекстПараметры=ТекстПараметры+", " КонецЕсли;
		ТекстПараметры=ТекстПараметры+СтрокаПараметр.Имя
	КонецЦикла;
	Возврат Новый Структура("Идентификатор, ТекстПараметры, ВозвращаетРезультат",Алгоритм.Идентификатор, ТекстПараметры, Алгоритм.ВозвращаетРезультат);
КонецФункции

&НаКлиенте
Процедура ЗагрузитьСписок(Команда)
	Если Объект.Алгоритмы.Количество()>0 Тогда
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОчиститьСписок", ЭтотОбъект, Неопределено);
		ПоказатьВопрос(Оповещение, "Очистить список алгоритмов?", Режим, 0);
	Иначе
		ПослеЗакрытияВопросаОчиститьСписок(КодВозвратаДиалога.Нет, Неопределено)
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаОчиститьСписок(Результат, ДопПараметры) Экспорт
    Если Результат = КодВозвратаДиалога.Да Тогда
        Объект.Алгоритмы.Очистить();
		Модифицированность=Истина;
    КонецЕсли;

	ПараметрыВыбора1 = Новый Структура("РежимВыбора",Истина);
	ОбработкаВыбора = Новый ОписаниеОповещения("ПриЗакрытииФормыВыбора", ЭтаФорма,"ЗагрузитьСписокАлгоритмов");
	ОткрытьФорму("Справочник.Нейро_СпискиАлгоритмов.ФормаВыбора",ПараметрыВыбора1,ЭтаФорма,,,,ОбработкаВыбора);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьСписок(Команда)
	ПараметрыВыбора1 = Новый Структура("РежимВыбора",Истина);
	ОбработкаВыбора = Новый ОписаниеОповещения("ПриЗакрытииФормыВыбора", ЭтаФорма,"СохранитьСписокАлгоритмов");
	ОткрытьФорму("Справочник.Нейро_СпискиАлгоритмов.ФормаВыбора",ПараметрыВыбора1,ЭтаФорма,,,,ОбработкаВыбора);
КонецПроцедуры
	
&НаКлиенте
Процедура ПриЗакрытииФормыВыбора(Значение, ДопПараметры) Экспорт
    Если Значение = Неопределено Тогда  ///Если ничего не выбрать - вернется пустое значение (Неопределено)
        Возврат;
    КонецЕсли;

	Если ДопПараметры = "СохранитьСписокАлгоритмов" Тогда 
		ЗаписатьСписокАлгоритмовВСправочник(Значение)
	ИначеЕсли ДопПараметры = "ЗагрузитьСписокАлгоритмов" Тогда 
		МассивАлгоритмов = ПолучитьСписокАлгоритмов(Значение);
		Для Каждого Алгоритм Из МассивАлгоритмов Цикл
			НоваяСтрока = Объект.Алгоритмы.Добавить();
			НоваяСтрока.Алгоритм = Алгоритм;
		КонецЦикла;
		Модифицированность=Истина;
		Если Объект.Алгоритмы.Количество()>0 Тогда
			Элементы.Алгоритмы.ТекущаяСтрока = Объект.Алгоритмы.Получить(Объект.Алгоритмы.Количество()-1).ПолучитьИдентификатор();
			АлгоритмыПриАктивизацииСтроки(Элементы.Алгоритмы);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокАлгоритмов(СпискиАлгоритмовСсылка)
	Результат = Новый Массив;
	Для Каждого СтрокаАлгоритм Из СпискиАлгоритмовСсылка.Алгоритмы Цикл
		Результат.Добавить(СтрокаАлгоритм.Алгоритм);
	КонецЦикла;
	Возврат Результат;
КонецФункции

&НаСервере
Процедура ЗаписатьСписокАлгоритмовВСправочник(СпискиАлгоритмовСсылка)
	СправочникОбъект = СпискиАлгоритмовСсылка.ПолучитьОбъект();
	СправочникОбъект.Алгоритмы.Очистить();
	Для Каждого СтрокаАлгоритм Из Объект.Алгоритмы Цикл
		НоваяСтрока = СправочникОбъект.Алгоритмы.Добавить();
		НоваяСтрока.Алгоритм = СтрокаАлгоритм.Алгоритм;
	КонецЦикла;
	СправочникОбъект.Записать();
КонецПроцедуры
