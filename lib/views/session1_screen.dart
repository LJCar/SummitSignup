import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/presentation_model.dart';
import '../controllers/presentation_controller.dart';
import '../controllers/signup_controller.dart';
import 'session2_screen.dart';

class Session1Screen extends StatefulWidget {
  final UserModel user;

  const Session1Screen({super.key, required this.user});

  @override
  State<Session1Screen> createState() => _Session1ScreenState();
}

class _Session1ScreenState extends State<Session1Screen> {
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
    final session1 = all.where((p) => p.session.contains(1)).toList();

    final availability = <String, bool>{};
    for (final p in session1) {
      availability[p.id] = await _signupController.isPresentationAvailable(p.id);
    }

    setState(() {
      _presentations = session1;
      _availability = availability;
      _loading = false;
    });
  }

  void _next() {
    if (_selectedPresentationId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Session2Screen(
            user: widget.user,
            session1Id: _selectedPresentationId!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Session 1 Presentation")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Session 1 (10:30 – 10:55 AM)',
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
        child: ElevatedButton(
          onPressed: _selectedPresentationId == null ? null : _next,
          child: const Text("Next"),
        ),
      ),
    );
  }
}