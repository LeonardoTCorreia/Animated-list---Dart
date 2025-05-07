import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated ListView',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AnimatedListViewScreen(),
    );
  }
}

class AnimatedListViewScreen extends StatefulWidget {
  const AnimatedListViewScreen({Key? key}) : super(key: key);

  @override
  State<AnimatedListViewScreen> createState() => _AnimatedListViewScreenState();
}

class _AnimatedListViewScreenState extends State<AnimatedListViewScreen> {
  final List<String> _items = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  int _counter = 1;

  void _addItem() {
    final index = _items.length; // Posição onde o item será adicionado
    final newItem = 'Item $_counter';
    _items.add(newItem);
    _counter++;

    // Adiciona o item com animação
    _listKey.currentState?.insertItem(
      index,
      duration: const Duration(milliseconds: 500),
    );
  }

  Widget _buildItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          title: Text(_items[index]),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removeItem(index),
          ),
        ),
      ),
    );
  }

  void _removeItem(int index) {
    final removedItem = _items[index];
    _items.removeAt(index);

    // Remove o item com animação
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(removedItem),
          ),
        ),
      ),
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated ListView'),
      ),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: _items.length,
        itemBuilder: _buildItem,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
