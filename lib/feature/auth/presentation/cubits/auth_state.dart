import 'package:equatable/equatable.dart';
import 'package:new_mshwar_app_customer/feature/auth/data/model/user_model.dart';

/// ─────────────────────────────────────────────────────────────
/// Auth states — covers all flows (login, OTP, register, reset).
/// ─────────────────────────────────────────────────────────────
enum AuthFlow { login, otp, register, forgotPassword, resetPassword }

class AuthState extends Equatable {
  final AuthFlow flow;
  final bool isLoading;
  final String? errorMessage;
  final UserModel? user;
  final String? successMessage;

  // OTP flow specifics
  final bool otpSent;
  final bool otpVerified;
  final String? phoneNumber;

  // Registration context
  final String? socialEmail;
  final String? socialLoginType;
  final bool isNewUser;

  // Password visibility
  final bool obscurePassword;
  final bool obscureConfirmPassword;

  const AuthState({
    this.flow = AuthFlow.login,
    this.isLoading = false,
    this.errorMessage,
    this.user,
    this.successMessage,
    this.otpSent = false,
    this.otpVerified = false,
    this.phoneNumber,
    this.socialEmail,
    this.socialLoginType,
    this.isNewUser = false,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
  });

  // ── Named constructors ──
  const AuthState.initial() : this();

  AuthState copyWith({
    AuthFlow? flow,
    bool? isLoading,
    String? errorMessage,
    UserModel? user,
    String? successMessage,
    bool? otpSent,
    bool? otpVerified,
    String? phoneNumber,
    String? socialEmail,
    String? socialLoginType,
    bool? isNewUser,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return AuthState(
      flow: flow ?? this.flow,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      user: user ?? this.user,
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
      otpSent: otpSent ?? this.otpSent,
      otpVerified: otpVerified ?? this.otpVerified,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      socialEmail: socialEmail ?? this.socialEmail,
      socialLoginType: socialLoginType ?? this.socialLoginType,
      isNewUser: isNewUser ?? this.isNewUser,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
    );
  }

  bool get isAuthenticated => user != null;

  @override
  List<Object?> get props => [
    flow,
    isLoading,
    errorMessage,
    user,
    successMessage,
    otpSent,
    otpVerified,
    phoneNumber,
    socialEmail,
    socialLoginType,
    isNewUser,
    obscurePassword,
    obscureConfirmPassword,
  ];
}
