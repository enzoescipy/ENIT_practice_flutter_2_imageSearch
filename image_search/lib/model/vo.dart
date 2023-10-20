class VO {
  /// if 0 or positive, this vo is liked by user.
  /// if negitive, this vo is just the information vo made by searching.
  int likeOrder = -1;
  late bool isImageVO;
  late String url;
}

class ImageVO extends VO {
  late DateTime dateTime;
  String thumbnailURL;
  String imageURL;
  String name;

  ImageVO(String url, String dateTimeString, this.thumbnailURL, this.imageURL, this.name) {
    isImageVO = true;
    dateTime = DateTime.parse(dateTimeString);
    this.url = url;
  }

  @override
  String toString() {
    return "$isImageVO, $likeOrder, $url, $dateTime, $thumbnailURL, $imageURL, $name";
  }
}

class WebVO extends VO {
  late DateTime dateTime;
  String title;
  String contents;
  WebVO(String url, String dateTimeString, this.title, this.contents) {
    isImageVO = false;
    dateTime = DateTime.parse(dateTimeString);
    this.url = url;
  }

  @override
  String toString() {
    return "$isImageVO, $likeOrder, $url, $dateTime, $title, $contents";
  }
}
