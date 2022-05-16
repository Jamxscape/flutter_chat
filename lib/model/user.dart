import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class User {
  User({
    this.id,
    this.name,
  });

  factory User.fromJson(Map<String, dynamic> jsonRes) => User(
        id: asT<int?>(jsonRes['id']),
        name: asT<String?>(jsonRes['name']),
      );

  int? id;
  String? name;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
      };

  User clone() => User.fromJson(toJson());
}
