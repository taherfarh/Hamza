class VideoListModel {
  final String name;
  final String link;
  final String downloadLink; 

  VideoListModel({
    required this.name,
    required this.link,
    required this.downloadLink, 
  });

  factory VideoListModel.fromJson(Map<String, dynamic> json) {
    return VideoListModel(
      name: json["name"],
      link: json["link"],
      downloadLink: json["Download_link"], 
    );
  }
}
