﻿
&НаКлиенте
Процедура ТипСпискаПриИзменении(Элемент)
	СформироватьНаименование();
	УстановитьВидимостьКлюча();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьКлюча()
	Если Объект.ТипСписка=ПредопределенноеЗначение("Перечисление.Нейро_ТипыСписков.Словарь") Тогда
		Элементы.ЭлементыКлюч.Видимость = Истина;
	Иначе
		Элементы.ЭлементыКлюч.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если НЕ Параметры.Ключ.Пустая() Тогда
		УстановитьВидимостьКлюча()
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьОписаниеТипа(Тип)
	Возврат Нейро_ОбщийМодуль.ПолучитьОписаниеТипаИзПеречисления(Тип);
КонецФункции

&НаКлиенте
Процедура ЭлементыТипПриИзменении(Элемент)
	ОписаниеТипа = ПолучитьОписаниеТипа(Элементы.ЭлементыСписка.ТекущиеДанные.Тип);
	Если ОписаниеТипа<>Неопределено Тогда
		Элементы.ЭлементыСписка.ТекущиеДанные.Значение = ОписаниеТипа.ПривестиЗначение(Элементы.ЭлементыСписка.ТекущиеДанные.Значение);
		//Элементы.ЭлементыСписка.ТекущиеДанные.Значение.ВыбиратьТип = Ложь;
	Иначе
		Элементы.ЭлементыСписка.ТекущиеДанные.Значение = Неопределено
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СформироватьНаименование()
	Скобки = ТекстЛитералаСкобок();
	Наименование="";
	Если Объект.ЭлементыСписка.Количество()=0 Тогда 
		Объект.Наименование=Наименование;
		Возврат 
	КонецЕсли;
	Наименование=Скобки.Левая;
	Для Каждого Элемент Из Объект.ЭлементыСписка Цикл
		Если Элемент.Тип = ПредопределенноеЗначение("Перечисление.Нейро_Типы.Неопределено") Тогда
			Наименование = Наименование + "None";
		ИначеЕсли Объект.ТипСписка = ПредопределенноеЗначение("Перечисление.Нейро_ТипыСписков.Словарь") Тогда
			Наименование = Наименование + "'" +Элемент.Ключ+ "': " + СокрЛП(Элемент.Значение);
		Иначе
			Наименование = Наименование + СокрЛП(Элемент.Значение);
		КонецЕсли;
		Наименование = Наименование + ", ";
	КонецЦикла;
	Наименование=СокрП(Наименование);
	Если Прав(Наименование,1)="," Тогда
		Наименование=Лев(Наименование,СтрДлина(Наименование)-1);
	КонецЕсли;
	Наименование=Наименование+Скобки.Правая;
	Объект.Наименование=Наименование;
КонецПроцедуры

&НаКлиенте
Функция ТекстЛитералаСкобок()
	Если Объект.ТипСписка=ПредопределенноеЗначение("Перечисление.Нейро_ТипыСписков.Список") Тогда
		Возврат Новый Структура("Левая, Правая", "[", "]");
	ИначеЕсли Объект.ТипСписка=ПредопределенноеЗначение("Перечисление.Нейро_ТипыСписков.Кортеж") Тогда
		Возврат Новый Структура("Левая, Правая", "(", ")");
	ИначеЕсли Объект.ТипСписка=ПредопределенноеЗначение("Перечисление.Нейро_ТипыСписков.Словарь") Тогда
		Возврат Новый Структура("Левая, Правая", "{", "}");
	Иначе
		Возврат Новый Структура("Левая, Правая", "", "");
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ЭлементыСпискаПриИзменении(Элемент)
	СформироватьНаименование()
КонецПроцедуры

&НаКлиенте
Процедура ЭлементыСпискаПослеУдаления(Элемент)
	СформироватьНаименование()
КонецПроцедуры

&НаКлиенте
Процедура ЭлементыСпискаПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если ОтменаРедактирования Тогда
		ПодключитьОбработчикОжидания("СформироватьНаименование", 1, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЭлементыСпискаПриАктивизацииЯчейки(Элемент)
	Если Элемент.ТекущиеДанные=Неопределено Тогда Возврат КонецЕсли;
	Если Элемент.ТекущийЭлемент.Имя="ЭлементыЗначение" Тогда
		ОписаниеТипа = Нейро_ОбщийМодуль.ПолучитьОписаниеТипаИзПеречисления(Элемент.ТекущиеДанные.Тип);
		Если ОписаниеТипа<>Неопределено Тогда
			Элемент.ТекущийЭлемент.ОграничениеТипа = ОписаниеТипа;
		Иначе
			Элемент.ТекущийЭлемент.ОграничениеТипа = Новый ОписаниеТипов();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
