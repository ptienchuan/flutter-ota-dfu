import 'package:flutter/material.dart';
import 'package:ota_dfu/screens/scan_screen.dart';

final colorScheme = ColorScheme.fromSeed(
  seedColor: Colors.green.shade300,
);
final colorSchemeDark = ColorScheme.fromSeed(
  seedColor: Colors.green.shade800,
  brightness: Brightness.dark,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData(
        colorScheme: colorSchemeDark,
        useMaterial3: true,
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              backgroundColor: colorSchemeDark.primaryContainer,
              foregroundColor: colorSchemeDark.onPrimaryContainer,
            ),
        scaffoldBackgroundColor: colorSchemeDark.background,
        drawerTheme: Theme.of(context).drawerTheme.copyWith(
              backgroundColor: colorSchemeDark.background,
            ),
        navigationBarTheme: Theme.of(context).navigationBarTheme.copyWith(
              backgroundColor: colorSchemeDark.primaryContainer,
              labelTextStyle: MaterialStatePropertyAll(
                TextStyle(
                  color: colorSchemeDark.onPrimaryContainer,
                ),
              ),
              indicatorColor: Colors.blue.shade800,
              iconTheme: MaterialStatePropertyAll(
                Theme.of(context).iconTheme.copyWith(
                      color: colorSchemeDark.onPrimaryContainer,
                    ),
              ),
            ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(colorSchemeDark.primaryContainer),
            foregroundColor:
                MaterialStatePropertyAll(colorSchemeDark.onPrimaryContainer),
          ),
        ),
      ),
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
            ),
        scaffoldBackgroundColor: colorScheme.background,
        drawerTheme: Theme.of(context).drawerTheme.copyWith(
              backgroundColor: colorScheme.background,
            ),
        navigationBarTheme: Theme.of(context).navigationBarTheme.copyWith(
              backgroundColor: colorScheme.primaryContainer,
              labelTextStyle: MaterialStatePropertyAll(
                TextStyle(
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              indicatorColor: Colors.blue.shade300,
              iconTheme: MaterialStatePropertyAll(
                Theme.of(context).iconTheme.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
              ),
            ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(colorScheme.primaryContainer),
            foregroundColor:
                MaterialStatePropertyAll(colorScheme.onPrimaryContainer),
          ),
        ),
      ),
      home: const ScanScreen(),
    );
  }
}
