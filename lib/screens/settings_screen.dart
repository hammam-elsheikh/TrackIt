import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---------- THEME ----------
          const Text(
            'Theme',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(value: ThemeMode.light, label: Text('Light')),
              ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
              ButtonSegment(value: ThemeMode.system, label: Text('System')),
            ],
            selected: {settings.themeMode},
            onSelectionChanged: (selected) {
              settings.setThemeMode(selected.first);
            },
          ),

          const Divider(height: 32),

          // ---------- FONT SIZE ----------
          const Text(
            'Font Size',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          Slider(
            min: 0.8,
            max: 1.4,
            divisions: 6,
            value: settings.fontScale,
            label: settings.fontScale.toStringAsFixed(1),
            onChanged: settings.setFontScale,
          ),

          Center(
            child: Text(
              'Preview text',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
