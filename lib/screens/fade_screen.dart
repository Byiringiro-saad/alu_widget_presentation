import 'package:flutter/material.dart';

class FadeScreen extends StatefulWidget {
  const FadeScreen({super.key});

  @override
  State<FadeScreen> createState() => _FadeScreenState();
}

class _FadeScreenState extends State<FadeScreen> {
  // 1. A key that lets us talk to the AnimatedList (to insert / remove items).
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  // 2. Our data. The list on screen always mirrors this.
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3'];
  int _counter = 3;

  // 3. Add an item: update the data, THEN tell the AnimatedList.
  void _addItem() {
    _counter++;
    final int index = _items.length;
    _items.insert(index, 'Item $_counter');
    _listKey.currentState!.insertItem(index);
  }

  // 4. Remove an item: update the data, THEN tell the AnimatedList
  // how to draw the item while it animates away.
  void _removeItem(String item) {
    final int index = _items.indexOf(item);

    if (index == -1) return;

    _items.removeAt(index);
    _listKey.currentState!.removeItem(
      index,
      (context, animation) => _buildItem(item, animation),
    );
  }

  // 5. How one item looks. The animation goes from 0.0 to 1.0
  // when it is added, and from 1.0 to 0.0 when it is removed.
  Widget _buildItem(String item, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: ListTile(
          title: Text(item),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removeItem(item),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fade')),
      // 6. The AnimatedList itself.
      body: AnimatedList(
        key: _listKey,
        initialItemCount: _items.length,
        itemBuilder: (context, index, animation) {
          return _buildItem(_items[index], animation);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
