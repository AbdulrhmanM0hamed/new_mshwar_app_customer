import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mshwar_app_customer/core/app/env.dart';
import 'package:new_mshwar_app_customer/core/routing/routes.dart';
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
import 'package:new_mshwar_app_customer/feature/auth/presentation/pages/register_page.dart';

/// ─────────────────────────────────────────────────────────────
/// Phone Login Page — sends OTP to mobile number.
/// ─────────────────────────────────────────────────────────────
class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSendOtp() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final phone = '${Env.defaultCountryCode}${_phoneController.text.trim()}';
    context.read<AuthCubit>().sendOtp(phone);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;

    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (prev, curr) =>
          prev.errorMessage != curr.errorMessage ||
          prev.successMessage != curr.successMessage ||
          prev.otpSent != curr.otpSent,
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackbar.errorGlobal(state.errorMessage!);
          context.read<AuthCubit>().clearError();
        }
        if (state.successMessage != null) {
          AppSnackbar.successGlobal(l.translate(state.successMessage!));
          context.read<AuthCubit>().clearSuccess();
        }
        if (state.otpSent && state.flow == AuthFlow.otp) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<AuthCubit>(),
                child: const OtpVerificationPage(),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state.isLoading,
          child: AuthScreenLayout(
            showBackButton: true,
            title: l.phoneLoginTitle,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l.enterPhoneNumber,
                    style: getBoldStyle(
                      fontSize: FontSize.size24,
                      color: AppColors.primaryDark,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    l.otpWillBeSent,
                    style: getRegularStyle(
                      fontSize: FontSize.size14,
                      color: AppColors.textSecondary,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  const SizedBox(height: Spacing.xxl),

                  // ── Country code + Phone ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: Spacing.inputHeight,
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.base,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(
                            Spacing.inputRadius,
                          ),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '+${Env.defaultCountryCode}',
                            style: getBoldStyle(
                              fontSize: FontSize.size16,
                              color: AppColors.primary,
                              fontFamily: FontConstant.cairo,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: Spacing.sm),
                      Expanded(
                        child: AppTextField(
                          controller: _phoneController,
                          hint: 'XXXXXXXX',
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          prefixIcon: const Icon(
                            Icons.phone_outlined,
                            size: 20,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: Validators.required,
                          onSubmitted: (_) => _onSendOtp(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.xxl),

                  AppButton.filled(
                    text: l.sendOtp,
                    isLoading: state.isLoading,
                    onPressed: _onSendOtp,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// ─────────────────────────────────────────────────────────────
/// OTP Verification Page — enter 6-digit code.
/// ─────────────────────────────────────────────────────────────
class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _onVerify() {
    final l = context.l;
    if (_otp.length != 6) {
      AppSnackbar.errorGlobal(l.invalidOtp6Digits);
      return;
    }
    FocusScope.of(context).unfocus();

    final phone = context.read<AuthCubit>().state.phoneNumber ?? '';
    context.read<AuthCubit>().verifyOtp(phone, _otp);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;

    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (prev, curr) =>
          prev.errorMessage != curr.errorMessage ||
          prev.successMessage != curr.successMessage ||
          prev.user != curr.user ||
          prev.isNewUser != curr.isNewUser,
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackbar.errorGlobal(state.errorMessage!);
          context.read<AuthCubit>().clearError();
        }
        if (state.successMessage != null) {
          AppSnackbar.successGlobal(l.translate(state.successMessage!));
          context.read<AuthCubit>().clearSuccess();
        }
        if (state.user != null && state.otpVerified) {
          Navigator.pushNamedAndRemoveUntil(context, Routes.home, (_) => false);
        }
        if (state.isNewUser && state.otpVerified) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<AuthCubit>(),
                child: const RegisterPage(),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state.isLoading,
          child: AuthScreenLayout(
            showBackButton: true,
            title: l.verifyCode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l.enterOtp,
                  style: getBoldStyle(
                    fontSize: FontSize.size24,
                    color: AppColors.primaryDark,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  l.otpSentTo(state.phoneNumber ?? ''),
                  style: getRegularStyle(
                    fontSize: FontSize.size14,
                    color: AppColors.textSecondary,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
                const SizedBox(height: Spacing.xxl),

                // ── OTP Fields ──
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 48,
                        height: 56,
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          style: getBoldStyle(
                            fontSize: FontSize.size24,
                            color: AppColors.textPrimary,
                            fontFamily: FontConstant.cairo,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _controllers[index].text.isNotEmpty
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: _controllers[index].text.isNotEmpty
                                ? AppColors.primarySurface
                                : AppColors.surface,
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              _focusNodes[index + 1].requestFocus();
                            }
                            if (value.isEmpty && index > 0) {
                              _focusNodes[index - 1].requestFocus();
                            }
                            setState(() {});
                            if (_otp.length == 6) _onVerify();
                          },
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: Spacing.xxl),

                AppButton.filled(
                  text: l.confirm,
                  isLoading: state.isLoading,
                  onPressed: _onVerify,
                ),
                const SizedBox(height: Spacing.base),

                // ── Resend ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l.didntReceiveCode,
                      style: getRegularStyle(
                        fontSize: FontSize.size14,
                        color: AppColors.textSecondary,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                    TextButton(
                      onPressed: state.isLoading
                          ? null
                          : () {
                              final phone = state.phoneNumber ?? '';
                              context.read<AuthCubit>().sendOtp(phone);
                            },
                      child: Text(
                        l.resendCode,
                        style: getBoldStyle(
                          fontSize: FontSize.size14,
                          color: AppColors.primary,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
