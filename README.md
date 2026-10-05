# AnimatedList in Flutter

A small Flutter app for learning the **`AnimatedList`** widget. It has six screens. Each one shows the same list of items with a different animation for adding and removing them.

Open the app, pick a demo from the menu, tap **+** to add an item and tap the red bin to remove one.

---

## Table of contents

1. [What is AnimatedList?](#1-what-is-animatedlist)
2. [The big idea](#2-the-big-idea)
3. [The building blocks](#3-the-building-blocks)
4. [Adding an item](#4-adding-an-item)
5. [Removing an item](#5-removing-an-item)
6. [The `animation` value](#6-the-animation-value)
7. [The six examples](#7-the-six-examples)
8. [Running the project](#8-running-the-project)

---

## 1. What is AnimatedList?

A normal `ListView` just appears. When you add or remove an item and call `setState`, the list redraws and the change happens instantly.

`AnimatedList` is a scrolling list that **animates items as they are added or removed**. New items can fade, slide, grow or spin into place, and removed items can animate away instead of disappearing.

| `ListView` | `AnimatedList` |
|---|---|
| Items appear and vanish instantly | Items animate in and out |
| You change the data and call `setState` | You change the data and **tell the list** what changed |
| `itemBuilder: (context, index)` | `itemBuilder: (context, index, animation)` |

---

## 2. The big idea

> **AnimatedList does not watch your data.**

With a `ListView`, you change your list and call `setState`, and Flutter redraws everything.

`AnimatedList` works differently. It doesn't know your data has changed until **you tell it**, by calling one of these:

- `insertItem(index)` means "a new item appeared at this position, animate it in."
- `removeItem(index, builder)` means "the item at this position is gone, animate it out."

So every change happens in **two steps**:

1. Change your data (the `List`).
2. Tell the `AnimatedList` what you changed.

Your data and the widget must always agree. If your list has 5 items, the `AnimatedList` must also think it has 5.

---

## 3. The building blocks

Every screen in this project has the same three pieces.

### a) A `GlobalKey`

```dart
final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
```

The key is your **remote control** for the list. Through `_listKey.currentState` you can call `insertItem` and `removeItem`.

### b) Your data

```dart
final List<String> _items = ['Item 1', 'Item 2', 'Item 3'];
```

A plain Dart list. What's on screen always mirrors it.

### c) The `AnimatedList` widget

```dart
AnimatedList(
  key: _listKey,                       // connect the remote control
  initialItemCount: _items.length,     // how many items to show at the start
  itemBuilder: (context, index, animation) {
    return _buildItem(_items[index], animation);
  },
)
```

| Property | What it does |
|---|---|
| `key` | Connects the widget to your `GlobalKey` |
| `initialItemCount` | How many items exist when the screen first opens. It is only read once. |
| `itemBuilder` | Builds one item. Unlike `ListView`, it also receives an `animation`. |

---

## 4. Adding an item

```dart
void _addItem() {
  _counter++;
  final int index = _items.length;          // add at the end
  _items.insert(index, 'Item $_counter');   // step 1: change the data
  _listKey.currentState!.insertItem(index); // step 2: tell the list
}
```

When you call `insertItem`, the list calls your `itemBuilder` for the new position and plays the animation forwards, **from 0.0 to 1.0**.

Notice that there's **no `setState`**. `insertItem` handles the redraw.

---

## 5. Removing an item

Removing is the tricky one:

```dart
void _removeItem(String item) {
  final int index = _items.indexOf(item);
  if (index == -1) return;                  // already removed
  _items.removeAt(index);                   // step 1: change the data
  _listKey.currentState!.removeItem(        // step 2: tell the list...
    index,
    (context, animation) => _buildItem(item, animation), // ...and how to draw it
  );
}
```

**Why does `removeItem` need a builder?**

By the time the animation plays, the item is **already gone from your data**. The list can't call `itemBuilder` for it, because `_items[index]` is now a different item. So you hand it a builder that knows how to draw the item that's leaving. That's why we keep the removed `item` in a variable.

**Why look up the index with `indexOf`?**

If a user taps the bin on an item that is already animating away, a stored index would be wrong and could crash the app. Looking the item up (and returning if it's not found) keeps it safe.

---

## 6. The `animation` value

The `animation` is a number that changes over time:

| When | It goes from | To |
|---|---|---|
| Adding an item | `0.0` | `1.0` |
| Removing an item | `1.0` | `0.0` |

You decide what that number **means**. Wrap the item in a widget that uses it:

- In `FadeTransition`, the number is the **opacity**: 0 is invisible, 1 is fully visible.
- In `SizeTransition`, it is the **height**: 0 is flat, 1 is full height.
- In `ScaleTransition`, it is the **size**: 0 is a dot, 1 is normal size.
- In `RotationTransition`, it is the **number of turns**: 1 is one full spin.

> This is the most important lesson: **the list logic never changes. Only the wrapper around the item changes.** All six screens below have the same add and remove code. They differ only in `_buildItem`.

### Changing the speed

`insertItem` and `removeItem` both take an optional `duration`. The default is 300 milliseconds.

```dart
_listKey.currentState!.insertItem(index, duration: const Duration(milliseconds: 500));
```

---

## 7. The six examples

All examples are in `lib/screens/`. The home menu (`home_screen.dart`) opens each one.

### 1. Fade: `fade_screen.dart`

The item **fades in** and **fades out**.

```dart
Widget _buildItem(String item, Animation<double> animation) {
  return FadeTransition(
    opacity: animation,
    child: Card(/* ... */),
  );
}
```

- This is the simplest file. It has numbered comments (1 to 6) that walk through every piece in order, so **start here**.
- It uses the default duration (300 ms).
- **Watch closely when you remove an item.** It fades out, but its empty space stays until the end and then the items below **jump up**. A fade only changes opacity, not size, so the row still takes up space. The Combo example fixes this.

### 2. Size: `size_screen.dart`

The item **grows open** and **shrinks closed**.

```dart
Widget _buildItem(String item, Animation<double> animation) {
  return SizeTransition(sizeFactor: animation, child: _buildCard(item));
}
```

- `sizeFactor` controls the row's height.
- Because the row really shrinks, the items below move up **smoothly**. There is no jump.
- From here on, each file has a `_buildCard` helper. It draws the card with no animation, so `_buildItem` only has to add the animation around it.

### 3. Slide: `slide_screen.dart`

The item **slides in from the right**.

```dart
Widget _buildItem(String item, Animation<double> animation) {
  return SlideTransition(
    position: animation.drive(
      Tween(begin: const Offset(1, 0), end: Offset.zero),
    ),
    child: _buildCard(item),
  );
}
```

- `SlideTransition` needs a **position**, not a number from 0 to 1. A **`Tween`** converts between them: `animation.drive(Tween(...))` turns 0 into `begin` and 1 into `end`.
- `Offset(1, 0)` means "one full width to the right". `Offset.zero` is the item's normal place.
  - `Offset(-1, 0)` is from the left, `Offset(0, 1)` from below and `Offset(0, -1)` from above.
- This screen uses **two builders**: `_buildItem` for adding and `_buildRemovedItem` for removing. Separate builders let the add and remove animations be different.
- **Discussion point:** here both builders use the same slide. When an item is removed, the animation runs backwards (1 to 0), so the item slides back out to the right, the same way it came in. Like the Fade example, the empty space then snaps shut. How would you fix that? (Hint: look at Combo.)

### 4. Scale: `scale_screen.dart`

The item **zooms in** from its center and **zooms out** when removed.

```dart
Widget _buildItem(String item, Animation<double> animation) {
  return ScaleTransition(scale: animation, child: _buildCard(item));
}
```

- `scale` 0.0 is an invisible dot, and 1.0 is normal size.

### 5. Rotation: `rotation_screen.dart`

The item **spins in** while growing.

```dart
Widget _buildItem(String item, Animation<double> animation) {
  return RotationTransition(
    turns: animation,
    child: ScaleTransition(scale: animation, child: _buildCard(item)),
  );
}
```

- `turns` 1.0 is one full turn.
- This is the first example that **combines two transitions** by nesting them. On its own, a full-size card spinning in place looks messy. Adding a `ScaleTransition` makes it spin in from nothing.

### 6. Combo + Curve: `combo_screen.dart`

This screen brings everything together:

- **Adding:** the item **pops in like a spring**, using scale and fade together with a bouncy curve.
- **Removing:** the item **fades out while shrinking**, which is a different animation from adding.

```dart
// ADD
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

// REMOVE
Widget _buildRemovedItem(String item, Animation<double> animation) {
  return SizeTransition(
    sizeFactor: animation,
    child: FadeTransition(opacity: animation, child: _buildCard(item)),
  );
}
```

There are two new ideas here:

1. **Curves.** A `CurvedAnimation` changes **how** the value moves from 0 to 1, not where it starts or ends. `Curves.elasticOut` overshoots past 1 and wobbles back, like a spring. Other curves to try are `Curves.easeOut`, `Curves.bounceOut` and `Curves.easeOutBack`.
2. **Fixing the jump.** The remove builder puts a `SizeTransition` **on the outside**. The item fades and also shrinks, so the items below slide up smoothly. This solves the problem seen in the Fade and Slide examples.

---

## 8. Running the project

You need [Flutter](https://docs.flutter.dev/get-started/install) installed.

```bash
git clone https://github.com/Byiringiro-saad/alu_widget_presentation.git
cd alu_widget_presentation
flutter pub get
flutter run
```

Run the tests (one per screen, each adding and removing an item):

```bash
flutter test
```

### Project structure

```
lib/
├── main.dart                 # starts the app and opens HomeScreen
└── screens/
    ├── home_screen.dart      # menu with one tile per demo
    ├── fade_screen.dart      # 1. FadeTransition (start here)
    ├── size_screen.dart      # 2. SizeTransition
    ├── slide_screen.dart     # 3. SlideTransition
    ├── scale_screen.dart     # 4. ScaleTransition
    ├── rotation_screen.dart  # 5. RotationTransition + ScaleTransition
    └── combo_screen.dart     # 6. Curves and different add/remove animations
```

### Further reading

- [AnimatedList API docs](https://api.flutter.dev/flutter/widgets/AnimatedList-class.html)
- [Flutter animations overview](https://docs.flutter.dev/ui/animations)
- [Curves reference (with animated previews)](https://api.flutter.dev/flutter/animation/Curves-class.html)
