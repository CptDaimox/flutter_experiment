import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_experiment/auth/auth_page.dart';
import 'package:flutter_experiment/pages/home.dart';
import 'package:flutter_experiment/pages/profile.dart';
import 'package:flutter_experiment/pages/responsive_page.dart';
import 'package:flutter_experiment/pages/settings.dart';
import 'package:flutter_experiment/pages/users.dart';
import 'package:flutter_experiment/theme/dark_mode.dart';
import 'package:flutter_experiment/theme/light_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('de'), // German
      ],
      home: const AuthPage(),
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/home': (context) => HomePage(),
        '/settings': (context) => const SettingsPage(),
        '/profile': (context) => const ProfilePage(),
        '/users': (context) => const UsersPage(),
        '/responsive': (context) => const ResponsivePage(),
      },
    );
  }
}
