import 'package:flutter/material.dart';
import '../controllers/user_controller.dart';
import '../routes/router.dart';

class EmailPromptScreen extends StatefulWidget {
  const EmailPromptScreen({super.key});

  @override
  State<EmailPromptScreen> createState() => _EmailPromptScreenState();
}

class _EmailPromptScreenState extends State<EmailPromptScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _userController = UserController();
  bool _loading = false;
  String? _error;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    final email = _controller.text.trim().toLowerCase();
    final user = await _userController.fetchUserByEmail(email);

    setState(() => _loading = false);

    if (user == null) {
      setState(() {
        _error = "Enter a valid registered email";
        _formKey.currentState!.validate();
      });
    } else {
      setState(() => _error = null);

      if (!user.signedUp) {
        Navigator.pushNamed(
          context,
          AppRoutes.session1,
          arguments: user,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.schedule,
              (route) => false,
          arguments: user,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("UHN Summit 2025")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Enter your registered email:"),
              const SizedBox(height: 16),
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  final email = value?.toLowerCase().trim();
                  final emailRegex = RegExp(r'^[\w-\.]+@uhn\.ca$');
                  if (email == null || !emailRegex.hasMatch(email)) {
                    return 'Enter a valid registered email';
                  }
                  if (_error != null) {
                    final temp = _error;
                    _error = null;
                    return temp;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _submit,
                child: const Text("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}