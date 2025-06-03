import 'package:flutter/material.dart';
import '../views/email_prompt_screen.dart';

class AppRoutes {
  static const emailPrompt = '/';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case emailPrompt:
        return MaterialPageRoute(builder: (_) => const EmailPromptScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404 - Page not found')),
          ),
        );
    }
  }
}