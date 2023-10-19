class ArticleModel {
  String? name;
  String? date;
  String? siteName;

  ArticleModel({
    this.name,
    this.date,
    this.siteName
  });



  ArticleModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        date = json['date'],
        siteName = json['siteName'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'date': date,
    'siteName': siteName,
  };

}