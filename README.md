Declarative Regions
===================

[![Build](https://github.com/reznikmm/declarative-regions/workflows/Build/badge.svg)](https://github.com/reznikmm/declarative-regions/actions)
[![REUSE status](https://api.reuse.software/badge/github.com/reznikmm/declarative-regions)](https://api.reuse.software/info/github.com/reznikmm/declarative-regions)

> An Ada declarative regions library

This repository keeps a library to create or analyze Ada declarative regions.

Тут я пытаюсь сделать простой интерфейс доступа к согласованной информации
о типах/профилях. Каждый определение (Entity) ссылается на свое окружение
и использует коды (Id) других определений, от которого оно зависит. Окружение
знает как отобразить коды на объекты определений. Если меняются типы, то
меняется отображение в окружении. Если делается снимок, то он делается со
всего окружения. Каждое изменение определения увеличивает его версию(?).
При слиянии снимков выбирается определения с большими версиями.
Удаления определений нет. Сборки мусора нет.

Тут я не использую итераторы из Ады 2012, потому, что меня от них тошнит.

## Install

Run
```
make all install PREFIX=/path/to/install
```

### Dependencies

None

## Usage


To use this declarative-regions library just add `with "declarative_-_regions";` to your project file.

## Maintainer

[Max Reznik](https://github.com/reznikmm).

## Contribute

Feel free to dive in!
[Open an issue](https://github.com/reznikmm/declarative-regions/issues/new)
or submit PRs.

## License

[MIT](LICENSE) © Maxim Reznik
