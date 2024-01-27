class MassageModel {
  MassageModel({
    required this.msg,
    required this.sentTime,
    required this.fromID,
    required this.readTime,
    required this.ToID,
    required this.type,
  });
  late final String msg;
  late final String sentTime;
  late final String fromID;
  late final String readTime;
  late final String ToID;
  late final Type type;

  MassageModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    sentTime = json['sent_time'].toString();
    fromID = json['from_ID'].toString();
    readTime = json['read_time'].toString();
    ToID = json['To_ID'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['sent_time'] = sentTime;
    data['from_ID'] = fromID;
    data['read_time'] = readTime;
    data['To_ID'] = ToID;
    data['type'] = type.name;
    return data;
  }
}

enum Type { text, image }
