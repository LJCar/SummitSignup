import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/presentation_model.dart';
import '../controllers/signup_controller.dart';
import '../routes/router.dart'; // <-- Make sure AppRoutes is imported

class ScheduleScreen extends StatefulWidget {
  final UserModel user;

  const ScheduleScreen({super.key, required this.user});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final _signupController = SignupController();
  List<PresentationModel> _presentations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    final presentations = await _signupController.getRegisteredPresentations(widget.user.email);
    setState(() {
      _presentations = presentations;
      _loading = false;
    });
  }

  Widget _buildSessionCard(int sessionNum, String timeRange) {
    final pres = _presentations.firstWhere(
          (p) => p.session.contains(sessionNum),
      orElse: () => PresentationModel(
        id: '',
        title: '',
        speaker: '',
        room: '',
        session: [],
        audience: [],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session $sessionNum ($timeRange)',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          child: pres.id.isEmpty
              ? const ListTile(
            title: Text("No presentation registered."),
          )
              : ListTile(
            title: Text(pres.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Speaker: ${pres.speaker}"),
                Text("Room: ${pres.room}"),
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text("✔ Registered", style: TextStyle(color: Colors.green)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  void _startOver() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.emailPrompt, // Go to the email prompt screen
          (route) => false,       // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Schedule")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome ${widget.user.name}, this is your UHN Summit schedule:",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            _buildSessionCard(1, "10:30 – 10:55 AM"),
            _buildSessionCard(2, "11:00 – 11:25 AM"),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _startOver,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text("End Session", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}