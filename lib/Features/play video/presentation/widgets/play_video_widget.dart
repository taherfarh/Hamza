import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videolink;
  final String coursname;
  final String? firebaseUrl;
  final String? filePath;
  final bool isOffline;

  const VideoPlayerPage({
    Key? key,
    required this.coursname,
    required this.videolink,
    this.firebaseUrl,
    this.filePath,
    this.isOffline = false,
  }) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  final noscreenshot = NoScreenshot.instance;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  bool isLoading = true;
  String? error;
  bool isDownloaded = false;
  late String localFilePath;

  bool canDownloadToday = true;

  @override
  void initState() {
    super.initState();
    noscreenshot.screenshotOff();

    if (widget.isOffline && widget.filePath != null) {
      localFilePath = widget.filePath!;
      _initializeVideo(fromFile: true, localPath: localFilePath);
    } else {
      _initializeVideo(fromFile: false);
      _checkIfDownloaded();
      _checkDownloadLimit();
    }
  }

  String _buildFileName() {
    return "${widget.coursname}_${widget.videolink}".replaceAll(' ', '_') +
        ".mp4";
  }

  Future<void> _checkIfDownloaded() async {
    final filename = _buildFileName();
    final dir = await getApplicationDocumentsDirectory();
    final path = "${dir.path}/$filename";
    final file = File(path);

    final prefs = await SharedPreferences.getInstance();
    final downloaded = prefs.getStringList('offline_videos') ?? [];

    if (file.existsSync() && downloaded.contains(filename)) {
      setState(() {
        isDownloaded = true;
      });
    }
  }

  Future<void> _checkDownloadLimit() async {
    final prefs = await SharedPreferences.getInstance();

    final now = DateTime.now();
    final todayString = "${now.year}-${now.month}-${now.day}";

    final lastDownloadDate = prefs.getString("download_date");
    final downloadCount = prefs.getInt("download_count") ?? 0;

    if (lastDownloadDate == todayString && downloadCount >= 3) {
      setState(() {
        canDownloadToday = false;
      });
    } else {
      setState(() {
        canDownloadToday = true;
      });
    }
  }

  Future<void> _initializeVideo({
    required bool fromFile,
    String? localPath,
  }) async {
    try {
      if (fromFile) {
        _videoPlayerController = VideoPlayerController.file(File(localPath!));
      } else {
        final url =
            'https://hamzandlove.com/GetVideoLink.php?course=${Uri.encodeComponent(widget.coursname)}&video=${Uri.encodeComponent(widget.videolink)}';
        final response = await http.get(Uri.parse(url));
        final realUrl = response.body.trim();

        if (!realUrl.startsWith("http")) {
          throw Exception("الرابط غير صالح");
        }

        _videoPlayerController = VideoPlayerController.network(realUrl);
      }

      await _videoPlayerController!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
      );

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error initializing video: $e");
      setState(() {
        error = "فشل في تشغيل الفيديو: $e";
        isLoading = false;
      });
    }
  }

  Future<void> _downloadAndSaveVideo() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final now = DateTime.now();
      final todayString = "${now.year}-${now.month}-${now.day}";

      final lastDownloadDate = prefs.getString("download_date");
      int downloadCount = prefs.getInt("download_count") ?? 0;

      if (lastDownloadDate == todayString) {
        if (downloadCount >= 3) {
          setState(() {
            canDownloadToday = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    "You have reached the daily download limit of 3 videos.")),
          );
          return;
        }
      } else {
        // بداية يوم جديد
        downloadCount = 0;
        await prefs.setString("download_date", todayString);
      }

      final firebaseLink = widget.firebaseUrl;

      if (firebaseLink == null || !firebaseLink.startsWith("http")) {
        throw Exception("رابط التحميل غير متوفر أو غير صالح");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Downloading video...")),
      );

      final videoResponse = await http.get(Uri.parse(firebaseLink));
      final dir = await getApplicationDocumentsDirectory();
      final filename = _buildFileName();
      final file = File("${dir.path}/$filename");

      await file.writeAsBytes(videoResponse.bodyBytes);

      final existing = prefs.getStringList('offline_videos') ?? [];
      if (!existing.contains(filename)) {
        existing.add(filename);
        await prefs.setStringList('offline_videos', existing);
      }

      downloadCount += 1;
      await prefs.setInt("download_count", downloadCount);

      setState(() {
        isDownloaded = true;
        canDownloadToday = downloadCount < 3;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download completed successfully!")),
      );
    } catch (e) {
      print("Error downloading video: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download failed")),
      );
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.coursname)),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.coursname)),
        body: Center(child: Text(error!)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coursname),
        automaticallyImplyLeading: true,
        actions: [
          if (!isDownloaded && !widget.isOffline && canDownloadToday)
            IconButton(
              icon: Icon(
                IconlyLight.download,
                size: 30,
              ),
              tooltip: "Download Video",
              onPressed: _downloadAndSaveVideo,
            ),
        ],
      ),
      body: Chewie(controller: _chewieController!),
    );
  }
}
