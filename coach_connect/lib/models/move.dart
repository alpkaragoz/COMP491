import 'video.dart';

class Move {
  String id;
  String name;
  int setNumber;
  int repNumber;
  String coachNote;
  String clientNote;
  bool isDone;
  Video? video;

  Move(this.id, this.name, this.setNumber, this.repNumber, this.coachNote,
      this.clientNote, this.isDone, this.video);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'setNumber': setNumber,
      'repNumber': repNumber,
      'coachNote': coachNote,
      'clientNote': clientNote,
      'isDone': isDone,
      'video': video?.toMap(),
    };
  }
}
