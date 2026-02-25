import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:new_mshwar_app_customer/core/network/endpoints.dart';
import 'package:new_mshwar_app_customer/feature/auth/data/response_model/auth_response.dart';

part 'auth_repo_api.g.dart';

/// ─────────────────────────────────────────────────────────────
/// Retrofit Auth API Client
/// ─────────────────────────────────────────────────────────────
@RestApi()
abstract class AuthRepoApi {
  factory AuthRepoApi(Dio dio, {String baseUrl}) = _AuthRepoApi;

  @POST(Endpoints.login)
  Future<AuthResponse> login(@Body() Map<String, dynamic> body);

  @POST(Endpoints.sendOtp)
  Future<OtpResponse> sendOtp(@Body() Map<String, dynamic> body);

  @POST(Endpoints.verifyOtp)
  Future<OtpResponse> verifyOtp(@Body() Map<String, dynamic> body);

  @POST(Endpoints.existingUser)
  Future<ExistingUserResponse> checkExistingUser(
    @Body() Map<String, dynamic> body,
  );

  @POST(Endpoints.profileByPhone)
  Future<AuthResponse> getProfileByPhone(@Body() Map<String, dynamic> body);

  @POST(Endpoints.register)
  Future<AuthResponse> register(@Body() Map<String, dynamic> body);

  @POST(Endpoints.resetPasswordOtp)
  Future<OtpResponse> sendResetPasswordOtp(@Body() Map<String, dynamic> body);

  @POST(Endpoints.resetPassword)
  Future<OtpResponse> resetPassword(@Body() Map<String, dynamic> body);
}
