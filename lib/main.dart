import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants/app_colors.dart';
import 'models/navigation_provider.dart';
import 'widgets/live_notice_bar.dart';
import 'widgets/bottom_nav_footer.dart';
import 'widgets/tools_more_sheets.dart';

import 'screens/home_screen.dart';
import 'screens/quran_list_screen.dart';
import 'screens/hadith_screen.dart';
import 'screens/dua_screen.dart';
import 'screens/tasbih_screen.dart';
import 'screens/prayer_times_screen.dart';
import 'screens/prayer_settings_screen.dart';
import 'screens/zakat_screen.dart';
import 'screens/qibla_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/radio_screen.dart';
import 'screens/ai_chat_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NavigationProvider(),
      child: const MinarahApp(),
    ),
  );
}

class MinarahApp extends StatelessWidget {
  const MinarahApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.poppinsTextTheme(
      Theme.of(context).textTheme,
    ).apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    );

    return MaterialApp(
      title: 'MINARAH - Islamic Hub BD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: AppColors.primaryDark,
        primaryColor: AppColors.primaryGreen,
        fontFamily: GoogleFonts.poppins().fontFamily,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accentGold,
          secondary: AppColors.primaryGreen,
          surface: AppColors.primaryDark,
          onPrimary: AppColors.primaryDark,
          onSecondary: Colors.white,
          onSurface: AppColors.lightGold,
        ),
        textTheme: textTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryDark,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.lightGold),
          titleTextStyle: TextStyle(
            color: AppColors.lightGold,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.primaryDark,
          selectedItemColor: AppColors.accentGold,
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
        ),
        dividerColor: AppColors.glassBorder,
        cardColor: AppColors.cardBgSolid,
      ),
      home: const MainLayout(),
    );
  }
}

/// MAIN LAYOUT
/// Tab 0 = Home, 1 = Quran List, 2 = Hadith
/// Tab 3 = Tools grid sheet, Tab 4 = More grid sheet
class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  static const List<Widget> _pages = [
    HomeScreen(),
    QuranListScreen(),
    HadithScreen(),
  ];

  void _handleTap(BuildContext context, int index) {
    final nav = Provider.of<NavigationProvider>(context, listen: false);
    if (index <= 2) {
      nav.setIndex(index);
      return;
    }
    if (index == 3) {
      showGridSheet(context, title: 'Tools', actions: [
        SheetAction(
          Icons.fingerprint_rounded,
          'Tasbih',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const TasbihScreen())),
        ),
        SheetAction(
          Icons.access_time_rounded,
          'Prayer Times',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const PrayerTimesScreen())),
        ),
        SheetAction(
          Icons.tune_rounded,
          'Prayer Settings',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const PrayerSettingsScreen())),
        ),
        SheetAction(
          Icons.savings_rounded,
          'Zakat',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ZakatScreen())),
        ),
        SheetAction(
          Icons.explore_rounded,
          'Qibla',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const QiblaScreen())),
        ),
        SheetAction(
          Icons.calendar_month_rounded,
          'Calendar',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const CalendarScreen())),
        ),
        SheetAction(
          Icons.radio_rounded,
          'Radio',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const RadioScreen())),
        ),
      ]);
    } else {
      showGridSheet(context, title: 'More', actions: [
        SheetAction(
          Icons.volunteer_activism_rounded,
          'Dua',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const DuaScreen())),
        ),
        SheetAction(
          Icons.smart_toy_rounded,
          'AI Assistant',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AiChatScreen())),
        ),
        SheetAction(
          Icons.settings_rounded,
          'Settings',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SettingsScreen())),
        ),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            const LiveNoticeBar(),
            Expanded(child: _pages[navProvider.currentIndex.clamp(0, 2)]),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: BottomNavFooter(onTap: (i) => _handleTap(context, i)),
      ),
    );
  }
}
