import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/app_user.dart';
import '../models/user_role.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// قراءة بروفايل المستخدم الحالي
  Future<AppUser?> getCurrentUserProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final data = await _supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (data == null) return null;

    return AppUser.fromMap(data);
  }

  /// إنشاء / تحديث بروفايل المستخدم (يستخدم في أول تسجيل)
  Future<void> createOrUpdateProfile({
    required UserRole role,
    required String fullName,
    required String email,
    required String bio,
    required List<String> skills,
    required List<String> subjects,
    String? linkedinUrl,
  }) async {
    final user = _supabase.auth.currentUser!;
    await _supabase.from('profiles').upsert({
      'id': user.id,
      'full_name': fullName,
      'email': email,
      'role': userRoleToString(role),
      'bio': bio,
      'skills': skills,
      'subjects': subjects,
      'linkedin_url': linkedinUrl,
    });
  }

  Future<void> updateProfile({
  required String bio,
  required List<String> skills,
  required List<String> subjects,
  String? linkedinUrl,
}) async {
  final user = _supabase.auth.currentUser!;

  await _supabase.from('profiles').update({
    'bio': bio,
    'skills': skills,
    'subjects': subjects,
    'linkedin_url': linkedinUrl,
  }).eq('id', user.id);
}

  /// تحديث الدور فقط
  Future<void> updateRole(UserRole role) async {
    final user = _supabase.auth.currentUser!;
    await _supabase
        .from('profiles')
        .update({'role': userRoleToString(role)})
        .eq('id', user.id);
  }

  /// البحث عن المدرسين
  Future<List<AppUser>> searchTutors(String query) async {
    final rows = await _supabase
        .from('profiles')
        .select()
        .inFilter('role', ['tutor', 'both']);

    final q = query.toLowerCase();

    final list = (rows as List)
        .where((row) {
          final skills = List<String>.from(row['skills'] ?? []);
          final subjects = List<String>.from(row['subjects'] ?? []);
          final full = [...skills, ...subjects].join(' ').toLowerCase();

          return full.contains(q);
        })
        .map((row) => AppUser.fromMap(row))
        .toList();

    return list;
  }
}
