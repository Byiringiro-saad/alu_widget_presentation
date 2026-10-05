import 'package:flutter/material.dart';

// Adding and removing: the item GROWS open / SHRINKS closed.
class SizeScreen extends StatefulWidget {
  const SizeScreen({super.key});

  @override
  State<SizeScreen> createState() => _SizeScreenState();
}

class _SizeScreenState extends State<SizeScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3'];
  int _counter = 3;

  void _addItem() {
    _counter++;
    final int index = _items.length;
    _items.insert(index, 'Item $_counter');
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
      (context, animation) => _buildItem(item, animation),
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

  // The row's height goes from 0 to full (add) and back to 0 (remove).
  Widget _buildItem(String item, Animation<double> animation) {
    return SizeTransition(sizeFactor: animation, child: _buildCard(item));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Size')),
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
