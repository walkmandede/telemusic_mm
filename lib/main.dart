import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/controllers/my_audio_handler.dart';
import 'package:telemusic_v2/src/views/gateway/gateway_page.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appInitLoad();
  await Future.delayed(const Duration(milliseconds: 100));
  runApp(const MainApp());
}

Future<void> appInitLoad() async {
  //audio handler initiazing
  audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.telemusicmm.app',
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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          defaultTransition: Transition.noTransition,
          home: const GatewayPage()),
    );
  }
}
