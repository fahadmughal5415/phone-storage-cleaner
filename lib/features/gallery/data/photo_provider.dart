import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_storage_cleaner/features/gallery/data/photo_service.dart';
import 'package:photo_manager/photo_manager.dart';

final photoServiceProvider = Provider<PhotoService>((ref) {
  return PhotoService();
});

final totalAssetsProvider = FutureProvider<int>((ref) async {
  final service = ref.watch(photoServiceProvider);
  return await service.getAssetCount();
});

final recentAssetsProvider = FutureProvider.family<List<AssetEntity>, int>((ref, page) async {
  final service = ref.watch(photoServiceProvider);
  return await service.getAssets(page: page);
});
