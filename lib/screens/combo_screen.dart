import 'package:flutter/material.dart';

// Adding:   the item POPS in with a springy curve (scale + fade).
// Removing: the item FADES out while SHRINKING (different from adding!).
class ComboScreen extends StatefulWidget {
  const ComboScreen({super.key});

  @override
  State<ComboScreen> createState() => _ComboScreenState();
}

class _ComboScreenState extends State<ComboScreen> {
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

  // ADD animation. A CurvedAnimation changes HOW the value moves from
  // 0 to 1. Curves.elasticOut overshoots and wobbles, like a spring.
  Widget _buildItem(String item, Animation<double> animation) {
    final Animation<double> curved = CurvedAnimation(
      parent: animation,
      curve: Curves.elasticOut,
    );
    return ScaleTransition(
      scale: curved,
      child: FadeTransition(opacity: animation, child: _buildCard(item)),
    );
  }

  // REMOVE animation. The SizeTransition on the outside closes the
  // gap smoothly, so the items below don't jump up at the end.
  Widget _buildRemovedItem(String item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(opacity: animation, child: _buildCard(item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Combo + Curve')),
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
