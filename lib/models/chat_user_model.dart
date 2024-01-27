class ChatUserModel {
  String? _id;
  String? _name;
  String? _email;
  String? _image;
  String? _about;
  String? _createdAt;
  String? _lastActive;
  bool? _isOnline;
  String? _pushToken;

  ChatUserModel(
      {String? id,
      String? name,
      String? email,
      String? image,
      String? about,
      String? createdAt,
      String? lastActive,
      bool? isOnline,
      String? pushToken}) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
    if (email != null) {
      _email = email;
    }
    if (image != null) {
      _image = image;
    }
    if (about != null) {
      _about = about;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (lastActive != null) {
      _lastActive = lastActive;
    }
    if (isOnline != null) {
      _isOnline = isOnline;
    }
    if (pushToken != null) {
      _pushToken = pushToken;
    }
  }

  String? get id => _id;
  set id(String? id) => _id = id;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get email => _email;
  set email(String? email) => _email = email;
  String? get image => _image;
  set image(String? image) => _image = image;
  String? get about => _about;
  set about(String? about) => _about = about;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get lastActive => _lastActive;
  set lastActive(String? lastActive) => _lastActive = lastActive;
  bool? get isOnline => _isOnline;
  set isOnline(bool? isOnline) => _isOnline = isOnline;
  String? get pushToken => _pushToken;
  set pushToken(String? pushToken) => _pushToken = pushToken;

  ChatUserModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _image = json['image'];
    _about = json['about'];
    _createdAt = json['created_at'];
    _lastActive = json['last_active'];
    _isOnline = json['is_online'];
    _pushToken = json['push_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['email'] = _email;
    data['image'] = _image;
    data['about'] = _about;
    data['created_at'] = _createdAt;
    data['last_active'] = _lastActive;
    data['is_online'] = _isOnline;
    data['push_token'] = _pushToken;
    return data;
  }
}
