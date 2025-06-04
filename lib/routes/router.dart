import 'package:flutter/material.dart';
import '../views/email_prompt_screen.dart';
import '../views/session1_screen.dart';
import '../views/session2_screen.dart';
import '../views/schedule_screen.dart';
import '../models/user_model.dart';

class AppRoutes {
  static const emailPrompt = '/';
  static const session1 = '/session1';
  static const session2 = '/session2';
  static const schedule = '/schedule';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case emailPrompt:
        return MaterialPageRoute(builder: (_) => const EmailPromptScreen());

      case session1:
        final user = settings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (_) => Session1Screen(user: user),
        );

      case session2:
        final args = settings.arguments as Map<String, dynamic>;
        final user = args['user'] as UserModel;
        final session1Id = args['session1Id'] as String;
        return MaterialPageRoute(
          builder: (_) => Session2Screen(user: user, session1Id: session1Id),
        );

      case schedule:
        final user = settings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (_) => ScheduleScreen(user: user),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404 - Page not found')),
          ),
        );
    }
  }
}