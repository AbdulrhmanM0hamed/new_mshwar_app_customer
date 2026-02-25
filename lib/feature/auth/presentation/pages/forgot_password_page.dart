import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mshwar_app_customer/core/theme/colors.dart';
import 'package:new_mshwar_app_customer/core/theme/spacing.dart';
import 'package:new_mshwar_app_customer/core/constants/styles_manger.dart';
import 'package:new_mshwar_app_customer/core/constants/font_manger.dart';
import 'package:new_mshwar_app_customer/core/utils/extensions/context_ext.dart';
import 'package:new_mshwar_app_customer/core/utils/validators.dart';
import 'package:new_mshwar_app_customer/core/widgets/app_button.dart';
import 'package:new_mshwar_app_customer/core/widgets/app_text_field.dart';
import 'package:new_mshwar_app_customer/core/widgets/app_snackbar.dart';
import 'package:new_mshwar_app_customer/core/widgets/loading/loading_overlay.dart';
import 'package:new_mshwar_app_customer/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:new_mshwar_app_customer/feature/auth/presentation/cubits/auth_state.dart';
import 'package:new_mshwar_app_customer/feature/auth/presentation/widgets/auth_screen_layout.dart';

/// ─────────────────────────────────────────────────────────────
/// Forgot Password Page — sends OTP to email.
/// After OTP is sent, shows the reset password form.
/// ─────────────────────────────────────────────────────────────
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailFormKey = GlobalKey<FormState>();
  final _resetFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSendOtp() {
    if (!_emailFormKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    context.read<AuthCubit>().sendResetPasswordOtp(
      _emailController.text.trim(),
    );
  }

  void _onResetPassword() {
    if (!_resetFormKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    context.read<AuthCubit>().resetPassword(
      email: _emailController.text.trim(),
      otp: _otpController.text.trim(),
      newPassword: _newPasswordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;

    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (prev, curr) =>
          prev.errorMessage != curr.errorMessage ||
          prev.successMessage != curr.successMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackbar.errorGlobal(state.errorMessage!);
          context.read<AuthCubit>().clearError();
        }
        if (state.successMessage != null &&
            state.flow == AuthFlow.resetPassword) {
          AppSnackbar.successGlobal(l.translate(state.successMessage!));
          context.read<AuthCubit>().clearSuccess();
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final showResetForm =
            state.otpSent && state.flow == AuthFlow.forgotPassword;

        return LoadingOverlay(
          isLoading: state.isLoading,
          child: AuthScreenLayout(
            showBackButton: true,
            title: l.recoverPassword,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: showResetForm
                  ? _buildResetForm(state, l)
                  : _buildEmailForm(state, l),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmailForm(AuthState state, dynamic l) {
    return Form(
      key: _emailFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Icon ──
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.primarySurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_reset_rounded,
              size: 36,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: Spacing.lg),

          Text(
            l.forgotPasswordTitle,
            style: getBoldStyle(
              fontSize: FontSize.size24,
              color: AppColors.primaryDark,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            l.forgotPasswordSubtitle,
            style: getRegularStyle(
              fontSize: FontSize.size14,
              color: AppColors.textSecondary,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: Spacing.xxl),

          // ── Email ──
          AppTextField(
            controller: _emailController,
            label: l.email,
            hint: l.emailHint,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(Icons.email_outlined, size: 20),
            validator: Validators.email,
            onSubmitted: (_) => _onSendOtp(),
          ),
          const SizedBox(height: Spacing.xxl),

          AppButton.filled(
            text: l.sendOtp,
            isLoading: state.isLoading,
            onPressed: _onSendOtp,
          ),
        ],
      ),
    );
  }

  Widget _buildResetForm(AuthState state, dynamic l) {
    return Form(
      key: _resetFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.resetPassword,
            style: getBoldStyle(
              fontSize: FontSize.size24,
              color: AppColors.primaryDark,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            l.otpSentToEmail(_emailController.text),
            style: getRegularStyle(
              fontSize: FontSize.size14,
              color: AppColors.textSecondary,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: Spacing.xl),

          // ── OTP ──
          AppTextField(
            controller: _otpController,
            label: l.otpCode,
            hint: l.enterCode,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.pin_outlined, size: 20),
            validator: Validators.required,
          ),
          const SizedBox(height: Spacing.base),

          // ── New Password ──
          AppTextField(
            controller: _newPasswordController,
            label: l.newPassword,
            hint: l.passwordHint,
            obscureText: state.obscurePassword,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.lock_outlined, size: 20),
            suffixIcon: IconButton(
              onPressed: () =>
                  context.read<AuthCubit>().togglePasswordVisibility(),
              icon: Icon(
                state.obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: AppColors.textHint,
              ),
            ),
            validator: Validators.password,
          ),
          const SizedBox(height: Spacing.base),

          // ── Confirm Password ──
          AppTextField(
            controller: _confirmPasswordController,
            label: l.confirmPassword,
            hint: l.passwordHint,
            obscureText: state.obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(Icons.lock_outlined, size: 20),
            suffixIcon: IconButton(
              onPressed: () =>
                  context.read<AuthCubit>().toggleConfirmPasswordVisibility(),
              icon: Icon(
                state.obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: AppColors.textHint,
              ),
            ),
            validator: (v) =>
                Validators.confirmPassword(v, _newPasswordController.text),
            onSubmitted: (_) => _onResetPassword(),
          ),
          const SizedBox(height: Spacing.xxl),

          AppButton.filled(
            text: l.resetBtn,
            isLoading: state.isLoading,
            onPressed: _onResetPassword,
          ),
          const SizedBox(height: Spacing.base),

          // ── Resend ──
          Center(
            child: TextButton(
              onPressed: state.isLoading ? null : _onSendOtp,
              child: Text(
                l.resendOtp,
                style: getSemiBoldStyle(
                  fontSize: FontSize.size13,
                  color: AppColors.primary,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
