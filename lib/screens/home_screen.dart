import 'package:flutter/material.dart';

import 'fade_screen.dart';
import 'size_screen.dart';
import 'combo_screen.dart';
import 'scale_screen.dart';
import 'slide_screen.dart';
import 'rotation_screen.dart';

// A menu with one button per AnimatedList demo.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AnimatedList Demos')),
      body: ListView(
        children: [
          _demoTile(context, 'Fade', 'FadeTransition', const FadeScreen()),
          _demoTile(context, 'Size', 'SizeTransition', const SizeScreen()),
          _demoTile(context, 'Slide', 'SlideTransition', const SlideScreen()),
          _demoTile(context, 'Scale', 'ScaleTransition', const ScaleScreen()),
          _demoTile(
            context,
            'Rotation',
            'RotationTransition',
            const RotationScreen(),
          ),
          _demoTile(
            context,
            'Combo + Curve',
            'Scale + Fade with Curves.elasticOut',
            const ComboScreen(),
          ),
        ],
      ),
    );
  }

  Widget _demoTile(
    BuildContext context,
    String title,
    String subtitle,
    Widget screen,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }
}
