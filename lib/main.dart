import 'package:flutter/material.dart';
import 'package:pdf_reader/models/pdf_provider.dart';
import 'package:pdf_reader/pages/home_page.dart';
import 'package:pdf_reader/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => PDFProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PDF Reader',
      theme: themeProvider.currentTheme,
      home: const HomePage(),
    );
  }
}
