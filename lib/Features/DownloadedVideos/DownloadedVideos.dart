import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hamza/Features/play%20video/presentation/widgets/play_video_widget.dart';
import 'package:hamza/core/constant.dart';
import 'package:hamza/core/responsive/responsive_size.dart';
import 'package:iconly/iconly.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadedVideosPage extends StatefulWidget {
  const DownloadedVideosPage({Key? key}) : super(key: key);

  @override
  State<DownloadedVideosPage> createState() => _DownloadedVideosPageState();
}

class _DownloadedVideosPageState extends State<DownloadedVideosPage> {
  List<Map<String, String>> downloadedVideos = [];

  @override
  void initState() {
    super.initState();
    _loadDownloadedVideos();
  }

  Future<void> _loadDownloadedVideos() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('offline_videos') ?? [];
    final dir = await getApplicationDocumentsDirectory();

    List<Map<String, String>> results = [];

    for (String filename in savedList) {
      final file = File("${dir.path}/$filename");
      if (await file.exists()) {
        final parts = filename.replaceAll(".mp4", "").split("-");
        final coursename = parts.first;
        final videoname = parts.sublist(1).join("-");

        results.add({
          'filename': filename,
          'path': file.path,
          'coursename': coursename,
          'videoname': videoname,
        });
      }
    }

    setState(() {
      downloadedVideos = results;
    });
  }

  void _confirmDelete(String filename) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete Video"),
        content: Text("Are you sure you want to delete this video?"),
        actions: [
          TextButton(
            child: Text("No"),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: Text("Yes", style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteVideo(filename);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteVideo(String filename) async {
    final prefs = await SharedPreferences.getInstance();
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$filename");

    if (await file.exists()) {
      await file.delete();
    }

    List<String> savedList = prefs.getStringList('offline_videos') ?? [];
    savedList.remove(filename);
    await prefs.setStringList('offline_videos', savedList);

    setState(() {
      downloadedVideos.removeWhere((video) => video['filename'] == filename);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: kprimecolor,
        centerTitle: true,
        title: Text(
          "Downloaded Videos",
          style: TextStyle(
            fontSize: ResponsiveSize(context: context, size: 24).size,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: downloadedVideos.isEmpty
          ? Center(
              child: Text(
                "No downloaded videos found.",
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: downloadedVideos.length,
              itemBuilder: (context, index) {
                final video = downloadedVideos[index];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    leading:
                        Icon(IconlyLight.video, size: 32, color: kprimecolor),
                    title: Text(
                      " ${video['coursename']}",
                      style: TextStyle(
                          color: Colors.grey[700], fontWeight: FontWeight.w900),
                    ),
                    trailing: IconButton(
                      icon:
                          Icon(IconlyLight.delete, color: Colors.red, size: 26),
                      onPressed: () => _confirmDelete(video['filename']!),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VideoPlayerPage(
                            coursname: video['coursename']!,
                            videolink: video['videoname']!,
                            filePath: video['path']!,
                            isOffline: true,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
