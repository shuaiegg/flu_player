import 'dart:io';
import 'package:fijkplayer/fijkplayer.dart';
import 'player_platform_interface.dart';

class Player extends FijkPlayer {
  static const asset_url_suffix = "asset:///";
  static String _cachePath = '/storage/emulated/0/Android/data/com.exmaple.mc/files';
  bool enableCache = true;
  static const cache_switch = 'ijkio:cache:ffio:';

  static void setCachePath(String path){
    _cachePath = path;
  }

  @override
  Future<void> setDataSource(String path,{bool autoPlay = false,bool showCover = false}) async {
    var videoPath = getVideoCathePath(path, _cachePath);
    //三级缓存判断
    if(File(videoPath).existsSync()){
      //如果二级缓存存在，直接用本地保存到视频文件
      path = videoPath;
      print('Video - play cache video : $path');
    }else if(enableCache){
      //走三级缓存，并添加到二级缓存.--本地缓存。
      //设置播放器缓存到步骤
      //1,增加视频url path前缀
      path = '$cache_switch$path';
      //2，通过setoption 设置cache_file_path
      setOption(FijkOption.formatCategory, 'cache_file_path', videoPath);
    }else{
      print('Video-play http with cache : $path');
    }
    super.setDataSource(path,autoPlay: autoPlay,showCover: showCover);
  }


  void setCommonDataSource(
    String url, {
    SourceType type = SourceType.net,
    bool autoPlay = false,
    bool showCover = false,
  }) {
    if(type == SourceType.asset && !url.startsWith(asset_url_suffix)){
      url = asset_url_suffix + url;
    }
    setDataSource(url,autoPlay: autoPlay,showCover: showCover);
  }

  String getVideoCathePath(String url,String cachePath){
    Uri uri = Uri.parse(url);
    String name = uri.pathSegments.last;
    var path = '$cachePath/$name';
    print('Video get video path : $path');
    return path;
  }

  Future<String?> getPlatformVersion() {
    return PlayerPlatform.instance.getPlatformVersion();
  }
}

enum SourceType { net, asset }
