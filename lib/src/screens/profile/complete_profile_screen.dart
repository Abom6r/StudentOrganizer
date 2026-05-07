import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_role.dart';
import '../../services/profile_service.dart';
import '../home/home_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  final UserRole initialRole;
  final String initialName;
  final String initialEmail;

  const CompleteProfileScreen({
    super.key,
    required this.initialRole,
    required this.initialName,
    required this.initialEmail,
  });

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  final bioCtrl = TextEditingController();
  final skillsCtrl = TextEditingController();
  final subjectsCtrl = TextEditingController();
  final linkedinCtrl = TextEditingController();

  late UserRole _role;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.initialName);
    emailCtrl = TextEditingController(text: widget.initialEmail);
    _role = widget.initialRole;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    bioCtrl.dispose();
    skillsCtrl.dispose();
    subjectsCtrl.dispose();
    linkedinCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileService = Provider.of<ProfileService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Complete your profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Full name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Role',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RadioListTile<UserRole>(
              title: const Text('Student'),
              value: UserRole.student,
              groupValue: _role,
              onChanged: (val) => setState(() => _role = val!),
            ),
            RadioListTile<UserRole>(
              title: const Text('Tutor'),
              value: UserRole.tutor,
              groupValue: _role,
              onChanged: (val) => setState(() => _role = val!),
            ),
            // لو تبغى Both:
            // RadioListTile<UserRole>(
            //   title: const Text('Both'),
            //   value: UserRole.both,
            //   groupValue: _role,
            //   onChanged: (val) => setState(() => _role = val!),
            // ),

            const SizedBox(height: 16),
            TextField(
              controller: bioCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Bio'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: skillsCtrl,
              decoration: const InputDecoration(
                labelText: 'Skills (comma separated)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: subjectsCtrl,
              decoration: const InputDecoration(
                labelText: 'Subjects (comma separated)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: linkedinCtrl,
              decoration: const InputDecoration(
                labelText: 'LinkedIn URL (optional)',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: saving
                  ? null
                  : () async {
                      setState(() => saving = true);
                      await profileService.createOrUpdateProfile(
                        role: _role,
                        fullName: nameCtrl.text.trim(),
                        email: emailCtrl.text.trim(),
                        bio: bioCtrl.text.trim(),
                        skills: skillsCtrl.text
                            .split(',')
                            .map((e) => e.trim())
                            .where((e) => e.isNotEmpty)
                            .toList(),
                        subjects: subjectsCtrl.text
                            .split(',')
                            .map((e) => e.trim())
                            .where((e) => e.isNotEmpty)
                            .toList(),
                        linkedinUrl: linkedinCtrl.text.trim().isEmpty
                            ? null
                            : linkedinCtrl.text.trim(),
                      );
                      if (!mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HomeScreen(),
                        ),
                        (route) => false,
                      );
                      setState(() => saving = false);
                    },
              child: saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save profile'),
            ),
          ],
        ),
      ),
    );
  }
}
