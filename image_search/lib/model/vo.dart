class VO {
  /// if 0 or positive, this vo is liked by user.
  /// if negitive, this vo is just the information vo made by searching.
  int likeOrder = -1;
  late bool isImageVO;
  late String url;
}

class ImageVO extends VO {
  DateTime dateTime;
  String thumbnailURL;
  String imageURL;
  String name;
  ImageVO(String url, this.dateTime, this.thumbnailURL, this.imageURL, this.name) {
    isImageVO = true;
    this.url = url;
  }
}

class WebVO extends VO {
  DateTime dateTime;
  String title;
  String contents;
  WebVO(String url, this.dateTime, this.title, this.contents) {
    isImageVO = false;
    this.url = url;
  }
}
