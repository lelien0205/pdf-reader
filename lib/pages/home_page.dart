import 'package:flutter/material.dart';
import 'package:pdf_reader/components/my_app_bar.dart';
import 'package:pdf_reader/components/my_bottom_bar.dart';
import 'package:pdf_reader/pages/all_file_page.dart';
import 'package:pdf_reader/pages/favorite_file_page.dart';
import 'package:pdf_reader/pages/recent_file_page.dart';
import 'package:pdf_reader/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const List<String> _title = [
    'All Files',
    'Recent Files',
    'Favourite Files'
  ];

  final List<Widget> _pages = [
    const AllFilePage(),
    const RecentFilePage(),
    const FavoriteFilePage()
  ];

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      bottomNavigationBar: MyBottomBar(
        onTap: navigateBottomBar,
      ),
      appBar: MyAppBar(
        title: _title[_selectedIndex],
        actions: [
          IconButton(
            onPressed: () {
              themeProvider.changeTheme();
            },
            icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded),
          )
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}
