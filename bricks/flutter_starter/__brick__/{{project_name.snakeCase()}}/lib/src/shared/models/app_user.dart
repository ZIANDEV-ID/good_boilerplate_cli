import 'package:json_annotation/json_annotation.dart';

part 'app_user.g.dart';

@JsonSerializable()
class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return _$AppUserFromJson(json);
  }

  final String id;
  final String name;
  final String email;

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
