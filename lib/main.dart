import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/app_settings.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppSettings(),
      child: const TaskTrackerApp(),
    ),
  );
}

class TaskTrackerApp extends StatelessWidget {
  const TaskTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return AnimatedTheme(
      data: settings.themeMode == ThemeMode.dark
          ? ThemeData.dark()
          : ThemeData.light(),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Tracker',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: settings.themeMode,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(settings.fontScale)),
            child: child!,
          );
        },
        home: const HomeScreen(),
      ),
    );
  }
}
