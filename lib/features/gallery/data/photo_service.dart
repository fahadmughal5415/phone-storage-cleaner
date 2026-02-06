import 'package:photo_manager/photo_manager.dart';

class PhotoService {
  Future<bool> requestPermission() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    return ps.isAuth;
  }

  Future<int> getAssetCount() async {
    return await PhotoManager.getAssetCount();
  }

  Future<List<AssetEntity>> getAssets({int page = 0, int size = 80}) async {
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      onlyAll: true,
      type: RequestType.common, // Photos and Videos
    );

    if (paths.isEmpty) return [];

    // The first path is usually "Recent" or "All"
    final AssetPathEntity allPath = paths.first;
    
    // Fetch assets for this page
    return await allPath.getAssetListPaged(page: page, size: size);
  }
  
  // Fetch all assets (be careful with memory, better to use pagination in UI, 
  // but for analysis we might need a way to scan indexes)
  // For "Importing", we likely just want to know the count and maybe some metadata 
  // without loading all thumbnails.
  
  Future<List<AssetPathEntity>> getAlbums() async {
    return await PhotoManager.getAssetPathList(type: RequestType.common);
  }
}
