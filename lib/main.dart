import 'package:crustascan_app/providers/auth_provider.dart';
import 'package:crustascan_app/providers/guest_provider.dart';
import 'package:crustascan_app/providers/history_provider.dart';
import 'package:crustascan_app/providers/register_user_image_provider.dart';
import 'package:crustascan_app/providers/user_provider.dart';
import 'package:crustascan_app/views/pages/on_boarding/on_boarding_page.dart';
import 'package:crustascan_app/views/pages/auth/login_page.dart';
import 'package:crustascan_app/views/widgets/global_loading_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => GuestProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => RegisterUserImageProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crustascan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.redAccent,
          brightness: Brightness.light,
        ),
      ),
      home: AppInitializer(),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool? _hasSeenOnboarding;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('onboarding_completed') ?? false;

    setState(() {
      _hasSeenOnboarding = hasSeenOnboarding;

      // DEBUG: Set _hasSeenOnBoarding = false to show onboarding everytime it restarts.
      _hasSeenOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading spinner while checking
    if (_hasSeenOnboarding == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Navigate directly depending on flag
    return _hasSeenOnboarding!
        ? GlobalLoadingPage(navigateNextPage: LoginPage())
        : GlobalLoadingPage(navigateNextPage: OnBoardingPage());
  }
}
