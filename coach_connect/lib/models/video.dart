class Video {
  String id;
  String url;
  int setNumber;

  Video(this.id, this.url, this.setNumber);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'setNumber': setNumber,
    };
  }

  static Video fromJson(Map<String, dynamic> json) {
    return Video(
      json['id'],
      json['url'],
      json['setNumber'],
    );
  }
}
