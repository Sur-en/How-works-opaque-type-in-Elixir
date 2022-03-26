# Как работает тип `opaque` в Elixir

Лучше всего можно разобраться в этом с помощью рабочего кода. 

## Установка Dialyzer

Для того, чтобы мы смогли анализировать типы нам нужно установить
[Dialyzer](https://github.com/jeremyjh/dialyxir).

Сперва нужно добавить в `mix.exs` следующий код:

```elixir
defp deps do
  [
    {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
  ]
end
```

Затем, находясь в корневом папке проекта, установить добавленную зависимость
с помощью команды `mix deps.get`, потом написать в терминале следующую команду:
`mix dialyzer`. Эта команда запускает процесс анализа, который продлится 10-30 
минут.

## Перейдём к коду

1. Добавим простой [файл](https://gitlab.com/Sur.en/how-works-opaque-type-in-elixir/-/commit/e1ab13331d071457ca9594a7446b37776fa3f8cf)
с самыми обычными типами. Этот файл будет являться нашей отправной точкой.
Чтобы убедиться, что всё работает нормально давайте запустим Dialyzer.
2. Теперь давайте [добавим](https://gitlab.com/Sur.en/how-works-opaque-type-in-elixir/-/commit/804c07c01c562c64be8352d21e58988f2d22ca53) 
публичный (`type`) тип для `ID`. Чтобы убедиться, что всё работает без проблем
снова можем запустить Dialyzer.
3. А сейчас [добавим](https://gitlab.com/Sur.en/how-works-opaque-type-in-elixir/-/commit/132949d629e09527521f03e6e28632edc2875814) 
`opaque` тип, запустим Dialyzer и посмотрим, что произойдет.
На данном этапе Dialyzer говорит нам, что у нас есть проблема:

```
lib/cpu.ex:23:no_return
Function run/0 has no local return.
________________________________________________________________________________
lib/cpu.ex:28:call_without_opaque
Function call without opaqueness type mismatch.

Call does not have expected opaque term of type HashVO.t() in the 3rd position.

CPUEntity.new(_id :: 32, _cpu_specifications :: %{}, _hash :: <<_::320>>)
```

Это является следствием того, что в модуле `CPUEntity` функция `new` ожидает 
принять в качестве последнего параметра тип `HashVO`, но вместо этого принимает
тип `String`. 

Чтобы [пофиксить](https://gitlab.com/Sur.en/how-works-opaque-type-in-elixir/-/commit/2b86b88bf9c04959ba76df57a985ed97a4644366)
это нужно просто воспользоваться функцией `new` из `HashVO` модулья. 

Так же хочу обратить ваше внимание на то, что без изменения типа `hash` в структуре
модулья `CPUEntity` всё будет работать корректно. Можем снова проверить.

4. Кажется всё поняли. Тогда давайте посмотрим, что будет, если [сделаем](https://gitlab.com/Sur.en/how-works-opaque-type-in-elixir/-/commit/fd0fdfe15089999edd0dd70491faee3190e6c201)
то же самое, только уже для `cpu_specifications` и с единственным отличием - 
для неё создадим структуру.

Запустим Dialyzer и убедимся, что мы получим ошибку. 

А вот и ошибка:

```
________________________________________________________________________________
lib/cpu.ex:29:call_without_opaque
Function call without opaqueness type mismatch.

Call does not have expected opaque term of type CPUSpecificationsVO.t() in the 2nd position.

CPUEntity.new(
  _id :: 32,
  _cpu_specifications :: %CPUSpecificationsVO{:core_count => _, :version => _},
  _hash :: any()
)
```

**Причина этой ошибки в том, что для `opaque` типа мы должны типизировать всё
API**, следовательно мы должны 
[добавить](https://gitlab.com/Sur.en/how-works-opaque-type-in-elixir/-/commit/9c95911e8bca49f63004ccabe063543ac26448e9)
`@spec` для `new` функции `CPUSpecificationsVO` модулья.

После этого проверим и убедимся, что проблема решена.

И не забудем добавить `@spec` для `new` функции `HashVO` модулья.