import 'dart:convert';

class User {
  final String name; // Tên người dùng
  final String email; // Email đăng ký

  User({required this.name, required this.email});

  /// Tạo đối tượng `User` từ một `Map`
  factory User.fromMap(Map<String, dynamic> map) {
    return User(name: map['name'] ?? '', email: map['email'] ?? '');
  }

  /// Chuyển đối tượng `User` thành `Map`
  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email};
  }

  /// Tạo một bản sao của `User` với các giá trị được cập nhật
  User copyWith({String? name, String? email}) {
    return User(name: name ?? this.name, email: email ?? this.email);
  }

  /// Chuyển đối tượng `User` thành chuỗi JSON
  String toJson() => json.encode(toMap());

  /// Tạo đối tượng `User` từ chuỗi JSON
  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() => 'User(name: $name, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User && other.name == name && other.email == email;
  }

  @override
  int get hashCode => name.hashCode ^ email.hashCode;
}
