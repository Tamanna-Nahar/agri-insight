class NewsQueryModel {
  String newsHead;
  String newsDes;
  String newsImg;
  String newsUrl;

  NewsQueryModel({required this.newsHead, required this.newsDes, required this.newsImg, required this.newsUrl});

  factory NewsQueryModel.fromMap(Map<String, dynamic> data) {
    return NewsQueryModel(
      newsHead: data['title'] ?? "No Title",
      newsDes: data['description'] ?? "No Description",
      newsImg: data['urlToImage'] ?? "https://via.placeholder.com/150",
      newsUrl: data['url'] ?? "",
    );
  }
}