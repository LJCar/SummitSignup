import 'package:flutter/material.dart';
import '../controllers/user_controller.dart';

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
    setState(() => _loading = true);

    final email = _controller.text.trim();
    final user = await _userController.fetchUserByEmail(email);

    setState(() => _loading = false);

    if (user == null) {
      setState(() => _error = "User not found");
    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("UHN Summit")),
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
                    final emailRegex = RegExp(r'^[\w-\.]+@uhn\.ca$');
                    if (value == null || !emailRegex.hasMatch(value)) {
                      return 'Enter a valid registered email';
                    }
                    return null;
                  }
              ),
              const SizedBox(height: 16),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                  onPressed: _submit, child: const Text("Continue")),
            ],
          ),
        ),
      ),
    );
  }
}