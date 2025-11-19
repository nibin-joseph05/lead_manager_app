import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/lead_provider.dart';
import 'screens/home/lead_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LeadApp());
}

class LeadApp extends StatelessWidget {
  const LeadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LeadProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mini Lead Manager',
        themeMode: ThemeMode.system,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const LeadListScreen(),
      ),
    );
  }
}
