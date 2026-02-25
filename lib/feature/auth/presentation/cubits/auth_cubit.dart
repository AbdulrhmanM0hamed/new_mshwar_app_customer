import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mshwar_app_customer/core/error/error_mapper.dart';
import 'package:new_mshwar_app_customer/core/utils/logger.dart';
import 'package:new_mshwar_app_customer/feature/auth/data/repo/auth_repo.dart';
import 'package:new_mshwar_app_customer/feature/auth/presentation/cubits/auth_state.dart';

/// ─────────────────────────────────────────────────────────────
/// Auth Cubit — orchestrates login, OTP, register, reset flows.
/// ─────────────────────────────────────────────────────────────
class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _repo;

  AuthCubit(this._repo) : super(const AuthState.initial());

  // ══════════════════════════════════════════════════════════
  // ██  PASSWORD VISIBILITY  ██
  // ══════════════════════════════════════════════════════════
  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword));
  }

  // ══════════════════════════════════════════════════════════
  // ██  CLEAR ERROR  ██
  // ══════════════════════════════════════════════════════════
  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  void clearSuccess() {
    emit(state.copyWith(clearSuccess: true));
  }

  // ══════════════════════════════════════════════════════════
  // ██  EMAIL + PASSWORD LOGIN  ██
  // ══════════════════════════════════════════════════════════
  Future<void> loginWithEmail(String email, String password) async {
    emit(
      state.copyWith(isLoading: true, clearError: true, flow: AuthFlow.login),
    );

    final result = await _repo.loginWithEmail(email, password);

    result.when(
      success: (user) {
        AppLogger.info('✅ Login success: ${user.fullName}');
        emit(
          state.copyWith(
            isLoading: false,
            user: user,
            successMessage: 'login_success',
          ),
        );
      },
      failure: (f) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: ErrorMapper.toMessageRaw(f),
          ),
        );
      },
    );
  }

  // ══════════════════════════════════════════════════════════
  // ██  SEND OTP  ██
  // ══════════════════════════════════════════════════════════
  Future<void> sendOtp(String mobile) async {
    emit(
      state.copyWith(
        isLoading: true,
        clearError: true,
        flow: AuthFlow.otp,
        phoneNumber: mobile,
      ),
    );

    final result = await _repo.sendOtp(mobile);

    result.when(
      success: (msg) {
        emit(
          state.copyWith(isLoading: false, otpSent: true, successMessage: msg),
        );
      },
      failure: (f) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: ErrorMapper.toMessageRaw(f),
          ),
        );
      },
    );
  }

  // ══════════════════════════════════════════════════════════
  // ██  VERIFY OTP  ██
  // ══════════════════════════════════════════════════════════
  Future<void> verifyOtp(String mobile, String otp) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _repo.verifyOtp(mobile, otp);

    await result.when(
      success: (_) async {
        // OTP verified — check if user exists
        final existResult = await _repo.checkExistingUser(phone: mobile);

        existResult.when(
          success: (existResponse) async {
            if (existResponse.userExists && existResponse.user != null) {
              // Existing user → fetch profile and login
              final profileResult = await _repo.getProfileByPhone(mobile);
              profileResult.when(
                success: (user) {
                  emit(
                    state.copyWith(
                      isLoading: false,
                      otpVerified: true,
                      user: user,
                      successMessage: 'login_success',
                    ),
                  );
                },
                failure: (f) {
                  emit(
                    state.copyWith(
                      isLoading: false,
                      errorMessage: ErrorMapper.toMessageRaw(f),
                    ),
                  );
                },
              );
            } else {
              // New user → navigate to registration
              emit(
                state.copyWith(
                  isLoading: false,
                  otpVerified: true,
                  isNewUser: true,
                ),
              );
            }
          },
          failure: (f) {
            emit(
              state.copyWith(
                isLoading: false,
                errorMessage: ErrorMapper.toMessageRaw(f),
              ),
            );
          },
        );
      },
      failure: (f) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: ErrorMapper.toMessageRaw(f),
          ),
        );
      },
    );
  }

  // ══════════════════════════════════════════════════════════
  // ██  REGISTER  ██
  // ══════════════════════════════════════════════════════════
  Future<void> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    String loginType = 'phoneNumber',
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        clearError: true,
        flow: AuthFlow.register,
      ),
    );

    final result = await _repo.register(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      password: password,
      loginType: loginType,
    );

    result.when(
      success: (user) {
        AppLogger.info('✅ Registration success: ${user.fullName}');
        emit(
          state.copyWith(
            isLoading: false,
            user: user,
            successMessage: 'registration_success',
          ),
        );
      },
      failure: (f) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: ErrorMapper.toMessageRaw(f),
          ),
        );
      },
    );
  }

  // ══════════════════════════════════════════════════════════
  // ██  FORGOT PASSWORD  ██
  // ══════════════════════════════════════════════════════════
  Future<void> sendResetPasswordOtp(String email) async {
    emit(
      state.copyWith(
        isLoading: true,
        clearError: true,
        flow: AuthFlow.forgotPassword,
      ),
    );

    final result = await _repo.sendResetPasswordOtp(email);

    result.when(
      success: (msg) {
        emit(
          state.copyWith(isLoading: false, otpSent: true, successMessage: msg),
        );
      },
      failure: (f) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: ErrorMapper.toMessageRaw(f),
          ),
        );
      },
    );
  }

  // ══════════════════════════════════════════════════════════
  // ██  RESET PASSWORD  ██
  // ══════════════════════════════════════════════════════════
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        clearError: true,
        flow: AuthFlow.resetPassword,
      ),
    );

    final result = await _repo.resetPassword(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );

    result.when(
      success: (msg) {
        emit(state.copyWith(isLoading: false, successMessage: msg));
      },
      failure: (f) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: ErrorMapper.toMessageRaw(f),
          ),
        );
      },
    );
  }

  // ══════════════════════════════════════════════════════════
  // ██  CHECK SOCIAL LOGIN  ██
  // ══════════════════════════════════════════════════════════
  Future<void> checkSocialLogin({
    required String email,
    required String loginType,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        clearError: true,
        socialEmail: email,
        socialLoginType: loginType,
      ),
    );

    final result = await _repo.checkExistingUser(
      email: email,
      loginType: loginType,
    );

    result.when(
      success: (existResponse) async {
        if (existResponse.userExists) {
          // Existing user — fetch profile
          final profileResult = await _repo.getProfileByPhone(
            existResponse.user?.phone ?? '',
          );
          profileResult.when(
            success: (user) {
              emit(
                state.copyWith(
                  isLoading: false,
                  user: user,
                  successMessage: 'login_success',
                ),
              );
            },
            failure: (f) {
              emit(
                state.copyWith(
                  isLoading: false,
                  errorMessage: ErrorMapper.toMessageRaw(f),
                ),
              );
            },
          );
        } else {
          // New user → go to registration with social data pre-filled
          emit(
            state.copyWith(
              isLoading: false,
              isNewUser: true,
              socialEmail: email,
              socialLoginType: loginType,
            ),
          );
        }
      },
      failure: (f) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: ErrorMapper.toMessageRaw(f),
          ),
        );
      },
    );
  }
}
