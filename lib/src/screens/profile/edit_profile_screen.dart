import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';
import '../../services/profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final bioCtrl = TextEditingController();
  final skillsCtrl = TextEditingController();
  final subjectsCtrl = TextEditingController();
  final linkedinCtrl = TextEditingController();

  bool loading = true;
  bool saving = false;

  late AppUser currentUser;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final profileService =
        Provider.of<ProfileService>(context, listen: false);

    final user = await profileService.getCurrentUserProfile();
    if (user != null) {
      currentUser = user;
      bioCtrl.text = user.bio;
      skillsCtrl.text = user.skills.join(', ');
      subjectsCtrl.text = user.subjects.join(', ');
      linkedinCtrl.text = user.linkedinUrl ?? "";
    }

    setState(() => loading = false);
  }

  @override
  void dispose() {
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
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ===== Bio =====
                  TextField(
                    controller: bioCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Bio",
                      prefixIcon: const Icon(Icons.info_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ===== Skills =====
                  TextField(
                    controller: skillsCtrl,
                    decoration: InputDecoration(
                      labelText: "Skills (comma separated)",
                      prefixIcon: const Icon(Icons.star_border),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ===== Subjects =====
                  TextField(
                    controller: subjectsCtrl,
                    decoration: InputDecoration(
                      labelText: "Subjects (comma separated)",
                      prefixIcon: const Icon(Icons.book_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ===== LinkedIn =====
                  TextField(
                    controller: linkedinCtrl,
                    decoration: InputDecoration(
                      labelText: "LinkedIn URL",
                      prefixIcon: const Icon(Icons.link),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ===== Save Button =====
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F80ED),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      onPressed: saving
                          ? null
                          : () async {
                              setState(() => saving = true);

                              await profileService.updateProfile(
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

                              Navigator.pop(context);
                            },
                      child: saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
