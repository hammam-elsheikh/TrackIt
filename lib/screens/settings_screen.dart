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

          RadioListTile<ThemeMode>(
            value: ThemeMode.light,
            groupValue: settings.themeMode,
            title: const Text('Light'),
            onChanged: settings.setThemeMode,
          ),

          RadioListTile<ThemeMode>(
            value: ThemeMode.dark,
            groupValue: settings.themeMode,
            title: const Text('Dark'),
            onChanged: settings.setThemeMode,
          ),

          RadioListTile<ThemeMode>(
            value: ThemeMode.system,
            groupValue: settings.themeMode,
            title: const Text('System'),
            onChanged: settings.setThemeMode,
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
