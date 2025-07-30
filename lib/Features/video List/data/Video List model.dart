class VideoListModel {
  final String name;
  final String link;
 

  VideoListModel({required this.name, required this.link });


  factory VideoListModel.fromJson(Map<String,dynamic> json){
    return VideoListModel(
      name: json["name"],
      link: json["link"]
      );
  }
}