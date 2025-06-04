import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/presentation_model.dart';
import '../controllers/presentation_controller.dart';
import '../controllers/signup_controller.dart';
import '../routes/router.dart';

class Session2Screen extends StatefulWidget {
  final UserModel user;
  final String session1Id;

  const Session2Screen({
    super.key,
    required this.user,
    required this.session1Id,
  });

  @override
  State<Session2Screen> createState() => _Session2ScreenState();
}

class _Session2ScreenState extends State<Session2Screen> {
  final _presentationController = PresentationController();
  final _signupController = SignupController();

  List<PresentationModel> _presentations = [];
  Map<String, bool> _availability = {};
  String? _selectedPresentationId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPresentations();
  }

  Future<void> _loadPresentations() async {
    final all = await _presentationController.getEligiblePresentations(widget.user);
    final session2 = all
        .where((p) => p.session.contains(2) && p.id != widget.session1Id)
        .toList();

    final availability = <String, bool>{};
    for (final p in session2) {
      availability[p.id] = await _signupController.isPresentationAvailable("${p.id}_s2");
    }

    setState(() {
      _presentations = session2;
      _availability = availability;
      _loading = false;
    });
  }

  void _submit() async {
    if (_selectedPresentationId == null) return;

    final email = widget.user.email;
    final session1Id = "${widget.session1Id}_s1";
    final session2Id = "${_selectedPresentationId!}_s2";

    setState(() => _loading = true);

    try {
      await _signupController.registerForSessions(
        email: email,
        session1Id: session1Id,
        session2Id: session2Id,
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.schedule,
            (route) => false,
        arguments: widget.user,
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup failed. Please try again.")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Session 2 Presentation")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Session 2 (11:00 – 11:25 AM)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _presentations.length,
              itemBuilder: (context, index) {
                final p = _presentations[index];
                final selected = _selectedPresentationId == p.id;
                final isAvailable = _availability[p.id] ?? true;

                return Card(
                  color: selected ? Colors.lightBlue.shade100 : null,
                  child: ListTile(
                    title: Text(p.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Speaker: ${p.speaker}"),
                        Text(
                          isAvailable ? 'Available' : 'Full',
                          style: TextStyle(
                            color: isAvailable ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    trailing: selected ? const Icon(Icons.check_circle) : null,
                    onTap: () {
                      setState(() {
                        _selectedPresentationId = p.id;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _goBack,
                child: const Text("Back"),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _selectedPresentationId == null ? null : _submit,
                child: const Text("Sign Up"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

