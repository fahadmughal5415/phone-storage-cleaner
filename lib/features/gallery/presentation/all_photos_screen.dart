import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_storage_cleaner/features/gallery/data/photo_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class AllPhotosScreen extends ConsumerWidget {
  const AllPhotosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only fetch first page for demo/speed
    final assetsAsync = ref.watch(recentAssetsProvider(0));

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Photos'),
      ),
      body: assetsAsync.when(
        data: (assets) {
          if (assets.isEmpty) {
            return const Center(child: Text('No photos found'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: assets.length,
            itemBuilder: (context, index) {
              final asset = assets[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AssetEntityImage(
                  asset,
                  isOriginal: false, // Use thumbnail
                  thumbnailSize: const ThumbnailSize.square(200),
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
