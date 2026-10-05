import 'package:flutter/material.dart';

class SlideScreen extends StatefulWidget {
  const SlideScreen({super.key});

  @override
  State<SlideScreen> createState() => _SlideScreenState();
}

class _SlideScreenState extends State<SlideScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _items = ['Apple', 'Banana', 'Cherry'];
  int _counter = 0;

  void _addItem() {
    _counter++;
    final int index = _items.length;
    _items.insert(index, 'Fruit $_counter');
    _listKey.currentState!.insertItem(
      index,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _removeItem(String item) {
    final int index = _items.indexOf(item);
    if (index == -1) return; // already removed
    _items.removeAt(index);
    _listKey.currentState!.removeItem(
      index,
      (context, animation) => _buildRemovedItem(item, animation),
      duration: const Duration(milliseconds: 500),
    );
  }

  // The card itself, without any animation.
  Widget _buildCard(String item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        title: Text(item),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _removeItem(item),
        ),
      ),
    );
  }

  // ADD animation: slide in from the right.
  // Offset(1, 0) means "one full width to the right".
  Widget _buildItem(String item, Animation<double> animation) {
    return SlideTransition(
      position: animation.drive(
        Tween(begin: const Offset(1, 0), end: Offset.zero),
      ),
      child: _buildCard(item),
    );
  }

  // REMOVE animation: slide out to the right.
  // Offset(1, 0) means "one full width to the right".
  Widget _buildRemovedItem(String item, Animation<double> animation) {
    return SlideTransition(
      position: animation.drive(Tween(begin: Offset(1, 0), end: Offset.zero)),
      child: _buildCard(item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Slide')),
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
