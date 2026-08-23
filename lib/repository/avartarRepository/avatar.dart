import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'avatar.g.dart';

class AvatarRepository {
  final SupabaseClient _client = Supabase.instance.client;

  static const String _bucket = 'images';
  static const String _folder = 'avatar';

  Future<List<String>> getAvatarUrls() async {
    final files = await _client.storage.from(_bucket).list(path: _folder);

    return files
        .where((f) => f.name.isNotEmpty && !f.name.startsWith('.'))
        .map((f) => _client.storage.from(_bucket).getPublicUrl('$_folder/${f.name}'))
        .toList();
  }
}

@riverpod
AvatarRepository avatarRepository(Ref ref) {
  return AvatarRepository();
}

@riverpod
Future<List<String>> avatarUrls(Ref ref) async {
  final repository = ref.watch(avatarRepositoryProvider);
  return repository.getAvatarUrls();
}