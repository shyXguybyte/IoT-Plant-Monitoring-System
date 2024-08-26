import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_plant/MQTT/mqtt_provider.dart';
import 'package:my_plant/screens/stats.dart';
import 'firebase_options.dart';
import 'package:my_plant/screens/OnBoardingScreens/onboarding_screen.dart';
import 'package:my_plant/screens/forgot_password.dart';
import 'package:my_plant/screens/home_screen.dart';
import 'package:my_plant/screens/signup.dart';
import 'package:my_plant/screens/signIn.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = MQTTProvider();
        provider.connectAndSubscribe();
        return provider;
      },
      // Provide MQTTProvider
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Plant Monitoring System',
        initialRoute: '/boarding',
        routes: {
          '/boarding': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/reset': (context) => const ForgotPassword(),
          '/home': (context) => const HomeScreen(),
          '/stat': (context) => const StatsScreen(),
        },
      ),
    );
  }
}
