// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),

      // Устанавливаем пользовательскую тему оформления приложения
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  /// для хранения списка пар слов
  final _suggestions = <WordPair>[];

  /// для хранения пар слов, выбранных пользователем (в виде списка Set (а не List). Set не хранит дубликаты)
  final _saved = <WordPair>{};

  /// параметры шрифта
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),

        // actions принимает массив виджетов
        actions: [
          /// Значок списка в AppBar (бургер-меню)
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    // отправляем маршрут в стек Навигатора
    // Навигатор добавляет кнопку «Назад» на панель приложения,
    // т.е. явно реализовывать Navigator.pop не нужно
    // context - это BuildContext (!!!)
    Navigator.of(context).push(
      // Новая страница (маршрут)
      MaterialPageRoute<void>(
        // - конструктор
        builder: (context) {
          //  -- генерируем строки ListTile
          final tiles = _saved.map((pair) => ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              ));

          // -- список с выбранными строками
          final devided = tiles.isNotEmpty
              // --- divideTiles() добавляет горизонтальный интервал между каждым ListTile
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          // возвращаем Scaffold, содержащую:
          return Scaffold(
            // название новой страницы (маршрута) по имени Saved Suggestions
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),

            // Тело нового маршрута состоит из ListView, содержащих ListTiles строки.
            // Каждая строка разделена разделителем.
            body: ListView(children: devided),
          );
        },
      ),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // функция обратного вызова, создаёт парное слово и помещает его в cnhjre ListTile
        itemBuilder: (context, i) {
          // для нечётных слов функция добавляет Divider виджет, для визуального разделения записей высотой в 1px
          if (i.isOdd) {
            return const Divider(
              thickness: 2.0,
            );
          }

          // возвращает целочисленный результат 0, 1, 1, 2, 2 для вычисления фактического количества пар слов в Списке за вычетом разделителей
          final index = i ~/ 2;

          // если достигнут предел доступных пар слов, создаётся ещё 10 и добавляются в список
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    // флаг наличия пары слов в Избранном
    final alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),

      // добавляем иконки
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
        semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
      ),

      // прикосновение к записи в списке
      onTap: () {
        // - переключение состояния
        // (setState() запускает вызов build() State-объекта,
        // что приводит к обновлению пользовательского интерфейса)
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}
