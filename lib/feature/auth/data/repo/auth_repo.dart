import 'package:dio/dio.dart';
import 'package:new_mshwar_app_customer/core/app/env.dart';
import 'package:new_mshwar_app_customer/core/error/failure.dart';
import 'package:new_mshwar_app_customer/core/error/result.dart';
import 'package:new_mshwar_app_customer/core/storage/preferences.dart';
import 'package:new_mshwar_app_customer/core/utils/logger.dart';
import 'package:new_mshwar_app_customer/feature/auth/data/model/user_model.dart';
import 'package:new_mshwar_app_customer/feature/auth/data/response_model/auth_response.dart';
import 'package:new_mshwar_app_customer/feature/auth/data/repo/auth_repo_api.dart';

/// ─────────────────────────────────────────────────────────────
/// Auth Repository — abstract interface + implementation.
/// ─────────────────────────────────────────────────────────────

// ═══════════════════════════════════════════════════════════
// ██  INTERFACE  ██
// ═══════════════════════════════════════════════════════════
abstract class AuthRepo {
  /// Email & password login.
  Future<Result<UserModel>> loginWithEmail(String email, String password);

  /// Send OTP to mobile.
  Future<Result<String>> sendOtp(String mobile);

  /// Verify OTP code.
  Future<Result<bool>> verifyOtp(String mobile, String otp);

  /// Check if user exists (phone or social).
  Future<Result<ExistingUserResponse>> checkExistingUser({
    String? email,
    String? phone,
    String? loginType,
  });

  /// Get profile by phone.
  Future<Result<UserModel>> getProfileByPhone(String phone);

  /// Register new user.
  Future<Result<UserModel>> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required String loginType,
  });

  /// Send reset password OTP.
  Future<Result<String>> sendResetPasswordOtp(String email);

  /// Reset password.
  Future<Result<String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
}

// ═══════════════════════════════════════════════════════════
// ██  IMPLEMENTATION  ██
// ═══════════════════════════════════════════════════════════
class AuthRepoImpl implements AuthRepo {
  final AuthRepoApi _api;

  AuthRepoImpl(this._api);

  // ── Helper: persist session data after successful login ──
  Future<void> _persistSession(UserModel user) async {
    if (user.accessToken != null && user.accessToken!.isNotEmpty) {
      await Preferences.setToken(user.accessToken!);
    }
    await Preferences.setUserId(user.id);
    await Preferences.setUserJson(user.toJsonString());
    await Preferences.setBool('is_login', true);
    AppLogger.info('✅ Session persisted for user: ${user.id}');
  }

  // ── Helper: handle DioException → Failure ──
  Result<T> _handleDioError<T>(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const Result.failure(
        NetworkFailure(message: 'no_internet_connection'),
      );
    }
    final msg = _extractErrorMessage(e.response?.data);
    return Result.failure(
      ServerFailure(message: msg, statusCode: e.response?.statusCode),
    );
  }

  String _extractErrorMessage(dynamic data) {
    if (data == null) return 'server_error';
    if (data is Map) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          'server_error';
    }
    return 'server_error';
  }

  // ══════════════════════════════════════════════════════════
  // ██  LOGIN WITH EMAIL  ██
  // ══════════════════════════════════════════════════════════
  @override
  Future<Result<UserModel>> loginWithEmail(
    String email,
    String password,
  ) async {
    try {
      final authResponse = await _api.login({
        'email': email,
        'mdp': password,
        'user_cat': Env.userCategory,
      });

      if (authResponse.isSuccess && authResponse.user != null) {
        await _persistSession(authResponse.user!);
        return Result.success(authResponse.user!);
      }

      return Result.failure(
        ServerFailure(message: authResponse.message ?? 'login_failed'),
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      AppLogger.error('Login error', e);
      return const Result.failure(UnexpectedFailure());
    }
  }

  // ══════════════════════════════════════════════════════════
  // ██  SEND OTP  ██
  // ══════════════════════════════════════════════════════════
  @override
  Future<Result<String>> sendOtp(String mobile) async {
    try {
      final otpResponse = await _api.sendOtp({'mobile': mobile});

      if (otpResponse.isSuccess) {
        return Result.success(otpResponse.message ?? 'OTP sent');
      }

      return Result.failure(
        ServerFailure(message: otpResponse.message ?? 'otp_failed'),
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      AppLogger.error('Send OTP error', e);
      return const Result.failure(UnexpectedFailure());
    }
  }

  // ══════════════════════════════════════════════════════════
  // ██  VERIFY OTP  ██
  // ══════════════════════════════════════════════════════════
  @override
  Future<Result<bool>> verifyOtp(String mobile, String otp) async {
    try {
      final otpResponse = await _api.verifyOtp({'mobile': mobile, 'otp': otp});

      if (otpResponse.isSuccess) {
        return const Result.success(true);
      }

      return Result.failure(
        ServerFailure(message: otpResponse.message ?? 'invalid_otp'),
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      AppLogger.error('Verify OTP error', e);
      return const Result.failure(UnexpectedFailure());
    }
  }

  // ══════════════════════════════════════════════════════════
  // ██  CHECK EXISTING USER  ██
  // ══════════════════════════════════════════════════════════
  @override
  Future<Result<ExistingUserResponse>> checkExistingUser({
    String? email,
    String? phone,
    String? loginType,
  }) async {
    try {
      final body = <String, dynamic>{'user_cat': Env.userCategory};
      if (email != null) body['email'] = email;
      if (phone != null) body['phone'] = phone;
      if (loginType != null) body['login_type'] = loginType;

      final existingResponse = await _api.checkExistingUser(body);

      return Result.success(existingResponse);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      AppLogger.error('Check existing user error', e);
      return const Result.failure(UnexpectedFailure());
    }
  }

  // ══════════════════════════════════════════════════════════
  // ██  PROFILE BY PHONE  ██
  // ══════════════════════════════════════════════════════════
  @override
  Future<Result<UserModel>> getProfileByPhone(String phone) async {
    try {
      final authResponse = await _api.getProfileByPhone({
        'phone': phone,
        'user_cat': Env.userCategory,
      });

      if (authResponse.isSuccess && authResponse.user != null) {
        await _persistSession(authResponse.user!);
        return Result.success(authResponse.user!);
      }

      return Result.failure(
        ServerFailure(message: authResponse.message ?? 'profile_failed'),
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      AppLogger.error('Profile by phone error', e);
      return const Result.failure(UnexpectedFailure());
    }
  }

  // ══════════════════════════════════════════════════════════
  // ██  REGISTER  ██
  // ══════════════════════════════════════════════════════════
  @override
  Future<Result<UserModel>> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required String loginType,
  }) async {
    try {
      final authResponse = await _api.register({
        'firstname': firstName,
        'lastname': lastName,
        'phone': phone,
        'email': email,
        'password': password,
        'login_type': loginType,
        'tonotify': 'yes',
        'account_type': Env.userCategory,
      });

      if (authResponse.isSuccess && authResponse.user != null) {
        await _persistSession(authResponse.user!);
        return Result.success(authResponse.user!);
      }

      return Result.failure(
        ServerFailure(message: authResponse.message ?? 'registration_failed'),
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      AppLogger.error('Register error', e);
      return const Result.failure(UnexpectedFailure());
    }
  }

  // ══════════════════════════════════════════════════════════
  // ██  RESET PASSWORD OTP  ██
  // ══════════════════════════════════════════════════════════
  @override
  Future<Result<String>> sendResetPasswordOtp(String email) async {
    try {
      final otpResponse = await _api.sendResetPasswordOtp({'email': email});

      if (otpResponse.isSuccess) {
        return Result.success(otpResponse.message ?? 'OTP sent');
      }

      return Result.failure(
        ServerFailure(message: otpResponse.message ?? 'otp_failed'),
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      AppLogger.error('Reset password OTP error', e);
      return const Result.failure(UnexpectedFailure());
    }
  }

  // ══════════════════════════════════════════════════════════
  // ██  RESET PASSWORD  ██
  // ══════════════════════════════════════════════════════════
  @override
  Future<Result<String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final otpResponse = await _api.resetPassword({
        'email': email,
        'otp': otp,
        'password': newPassword,
      });

      if (otpResponse.isSuccess) {
        return Result.success(otpResponse.message ?? 'Password reset');
      }

      return Result.failure(
        ServerFailure(message: otpResponse.message ?? 'reset_failed'),
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      AppLogger.error('Reset password error', e);
      return const Result.failure(UnexpectedFailure());
    }
  }
}
