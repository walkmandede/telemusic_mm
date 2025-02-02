import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telemusic_v2/src/controllers/my_audio_handler.dart';
import 'package:telemusic_v2/src/views/gateway/gateway_page.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appInitLoad();
  runApp(const MainApp());
}

Future<void> appInitLoad() async {
  //audio handler initiazing
  audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.kphkph.audio',
      androidNotificationChannelName: 'Audio Playback',
      androidNotificationOngoing: true,
    ),
  );

  //
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  bool _isAppRestarted = false;

  @override
  void initState() {
    super.initState();
    // Add this class as a lifecycle observer
    WidgetsBinding.instance.addObserver(this);
    _checkAppState();
  }

  @override
  void dispose() {
    // Remove observer to avoid memory leaks
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Check app state during initialization
  Future<void> _checkAppState() async {
    final prefs = await SharedPreferences.getInstance();
    final wasAppInForeground = prefs.getBool('was_app_in_foreground') ?? false;

    setState(() {
      _isAppRestarted = wasAppInForeground; // If true, the app was restarted
    });

    // Update the state to mark the app as being in the foreground now
    prefs.setBool('was_app_in_foreground', true);
  }

  // Monitor app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final prefs = await SharedPreferences.getInstance();

    if (state == AppLifecycleState.detached) {
      // The app is being closed or moved to the background, mark as not in the foreground
      // audioHandler.stop();
      await prefs.setBool('was_app_in_foreground', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: GetMaterialApp(
          theme: AppTheme.theme,
          title: "Telemusic MM",
          debugShowCheckedModeBanner: false,
          // defaultTransition: Transition.,
          home: const GatewayPage()),
    );
  }
}
