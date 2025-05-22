

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:dreamflow/models/user_model.dart';
import 'package:dreamflow/screens/login_screen.dart';
import 'package:dreamflow/screens/home_screen.dart';
import 'package:dreamflow/services/ad_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'theme.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  
  // Ad initialization moved to MyAppState to prevent blocking UI
  
  // Force portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AdService _adService = AdService();
  UserModel? _currentUser;
  bool _isSdkInitialized = false;

  Future<void> _initializeSdkAndLoadAds() async {
    if (_isSdkInitialized) return;

    try {
      await _adService.initialize();
      if (kDebugMode) {
        print("AdService: SDK Initialized.");
      }
      
      // Preload App Open Ad
      _adService.loadAppOpenAd().then((loaded) {
        if (loaded) {
          if (kDebugMode) {
            print("AdService: App Open Ad successfully preloaded.");
          }
          // Optionally show it immediately after login, or on next app resume
          // For now, we will show it after login in _handleLogin
        } else {
          if (kDebugMode) {
            print("AdService: App Open Ad failed to preload.");
          }
        }
      });

      setState(() {
        _isSdkInitialized = true;
      });
      if (kDebugMode) {
        print("MyApp: SDK Initialization and Ad Loading attempt complete.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("MyApp: Error initializing SDK or loading ads: $e");
      }
      setState(() {
        _isSdkInitialized = true; // Proceed with app even if ads fail
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeSdkAndLoadAds();
  }

  void _handleLogin(UserModel user) {
    setState(() {
      _currentUser = user;
    });
    // Show app open ad after successful login
    _adService.showAppOpenAd();
  }

  void _handleLogout(UserModel? user) {
    setState(() {
      _currentUser = user;
    });
  }

  @override
  void dispose() {
    _adService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<AdService>.value(
      value: _adService,
      child: MaterialApp(
        title: 'Win-Robux',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: _isSdkInitialized
            ? (_currentUser == null
                ? LoginScreen(onLogin: _handleLogin)
                : HomeScreen(
                    user: _currentUser!,
                    onLogout: _handleLogout,
                  ))
            : Scaffold(
                backgroundColor: Theme.of(context).colorScheme.surface,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Initializing RoSpins...',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}