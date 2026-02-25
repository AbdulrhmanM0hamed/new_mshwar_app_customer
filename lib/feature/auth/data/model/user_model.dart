import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

String _idFromJson(dynamic id) => id?.toString() ?? '';
String _stringFromJson(dynamic v) => v?.toString() ?? '';

/// ─────────────────────────────────────────────────────────────
/// Domain user model — used throughout the app.
///
/// Note: API returns French keys (nom = last name, prenom = first name).
/// This model normalises them to English.
/// ─────────────────────────────────────────────────────────────
@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    @JsonKey(name: 'id', fromJson: _idFromJson) required String id,
    @JsonKey(name: 'prenom', fromJson: _stringFromJson)
    required String firstName,
    @JsonKey(name: 'nom', fromJson: _stringFromJson) required String lastName,
    @JsonKey(fromJson: _stringFromJson) required String email,
    @JsonKey(fromJson: _stringFromJson) required String phone,
    @JsonKey(name: 'photo_path') String? photoPath,
    @JsonKey(name: 'login_type') String? loginType,
    @JsonKey(name: 'accesstoken') String? accessToken,
    @JsonKey(name: 'admin_commission') String? adminCommission,
    @JsonKey(name: 'user_cat') String? userCat,
  }) = _UserModel;

  String get fullName => '$firstName $lastName'.trim();

  /// Parse from API response JSON.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Stringify for Hive persistence.
  String toJsonString() => jsonEncode(toJson());

  /// Parse from Hive stored string.
  factory UserModel.fromJsonString(String jsonString) {
    return UserModel.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }
}
