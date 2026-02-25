import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:new_mshwar_app_customer/feature/auth/data/model/user_model.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

/// ─────────────────────────────────────────────────────────────
/// Auth API response wrappers.
/// ─────────────────────────────────────────────────────────────

@freezed
class AuthResponse with _$AuthResponse {
  const AuthResponse._();

  const factory AuthResponse({
    String? success,
    @JsonKey(name: 'data') UserModel? user,
    String? message,
    dynamic error,
  }) = _AuthResponse;

  bool get isSuccess => success == 'Success';

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

@freezed
class OtpResponse with _$OtpResponse {
  const OtpResponse._();

  const factory OtpResponse({String? success, String? message, dynamic error}) =
      _OtpResponse;

  bool get isSuccess => success == 'Success';

  factory OtpResponse.fromJson(Map<String, dynamic> json) =>
      _$OtpResponseFromJson(json);
}

@freezed
class ExistingUserResponse with _$ExistingUserResponse {
  const ExistingUserResponse._();

  const factory ExistingUserResponse({
    String? success,
    @JsonKey(name: 'data') UserModel? user,
    String? message,
  }) = _ExistingUserResponse;

  bool get isSuccess => success == 'Success';
  bool get userExists => isSuccess;

  factory ExistingUserResponse.fromJson(Map<String, dynamic> json) =>
      _$ExistingUserResponseFromJson(json);
}
