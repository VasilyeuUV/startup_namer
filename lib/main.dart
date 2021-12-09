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
    return const MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),
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
      ),
      body: _buildSuggestions(),
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
    );
  }
}
