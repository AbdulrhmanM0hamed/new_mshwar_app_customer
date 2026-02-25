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
import 'package:new_mshwar_app_customer/core/routing/routes.dart';
import 'package:new_mshwar_app_customer/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:new_mshwar_app_customer/feature/auth/presentation/cubits/auth_state.dart';
import 'package:new_mshwar_app_customer/feature/auth/presentation/widgets/auth_screen_layout.dart';

/// ─────────────────────────────────────────────────────────────
/// Registration Page — new user sign up.
/// ─────────────────────────────────────────────────────────────
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill from OTP or social login
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<AuthCubit>().state;
      if (state.phoneNumber != null) {
        _phoneController.text = state.phoneNumber!;
      }
      if (state.socialEmail != null) {
        _emailController.text = state.socialEmail!;
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final state = context.read<AuthCubit>().state;
    context.read<AuthCubit>().register(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      loginType: state.socialLoginType ?? 'phoneNumber',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;

    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (prev, curr) =>
          prev.errorMessage != curr.errorMessage ||
          prev.successMessage != curr.successMessage ||
          (prev.user != curr.user && curr.flow == AuthFlow.register),
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackbar.errorGlobal(state.errorMessage!);
          context.read<AuthCubit>().clearError();
        }
        if (state.successMessage != null) {
          AppSnackbar.successGlobal(l.translate(state.successMessage!));
          context.read<AuthCubit>().clearSuccess();
        }
        if (state.user != null && state.flow == AuthFlow.register) {
          Navigator.pushNamedAndRemoveUntil(context, Routes.home, (_) => false);
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state.isLoading,
          child: AuthScreenLayout(
            showBackButton: true,
            title: l.createAccount,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Title ──
                  Text(
                    l.createNewAccount,
                    style: getBoldStyle(
                      fontSize: FontSize.size24,
                      color: AppColors.primaryDark,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    l.completeDataToRegister,
                    style: getRegularStyle(
                      fontSize: FontSize.size14,
                      color: AppColors.textSecondary,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  const SizedBox(height: Spacing.xl),

                  // ── First Name ──
                  AppTextField(
                    controller: _firstNameController,
                    label: l.firstName,
                    hint: l.firstNameHint,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.person_outline, size: 20),
                    validator: Validators.required,
                  ),
                  const SizedBox(height: Spacing.base),

                  // ── Last Name ──
                  AppTextField(
                    controller: _lastNameController,
                    label: l.lastName,
                    hint: l.lastNameHint,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.person_outline, size: 20),
                    validator: Validators.required,
                  ),
                  const SizedBox(height: Spacing.base),

                  // ── Phone ──
                  AppTextField(
                    controller: _phoneController,
                    label: l.phoneNumber,
                    hint: '965XXXXXXXX',
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                    validator: Validators.phone,
                    readOnly: state.phoneNumber != null,
                  ),
                  const SizedBox(height: Spacing.base),

                  // ── Email ──
                  AppTextField(
                    controller: _emailController,
                    label: l.email,
                    hint: l.emailHint,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.email_outlined, size: 20),
                    validator: Validators.email,
                    readOnly: state.socialEmail != null,
                  ),
                  const SizedBox(height: Spacing.base),

                  // ── Password ──
                  AppTextField(
                    controller: _passwordController,
                    label: l.password,
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
                      onPressed: () => context
                          .read<AuthCubit>()
                          .toggleConfirmPasswordVisibility(),
                      icon: Icon(
                        state.obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: AppColors.textHint,
                      ),
                    ),
                    validator: (v) =>
                        Validators.confirmPassword(v, _passwordController.text),
                    onSubmitted: (_) => _onRegister(),
                  ),
                  const SizedBox(height: Spacing.xxl),

                  // ── Register button ──
                  AppButton.filled(
                    text: l.createAccountBtn,
                    isLoading: state.isLoading,
                    onPressed: _onRegister,
                  ),
                  const SizedBox(height: Spacing.base),

                  // ── Login link ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l.alreadyHaveAccount,
                        style: getRegularStyle(
                          fontSize: FontSize.size14,
                          color: AppColors.textSecondary,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.login,
                            (_) => false,
                          );
                        },
                        child: Text(
                          l.loginNow,
                          style: getBoldStyle(
                            fontSize: FontSize.size14,
                            color: AppColors.primary,
                            fontFamily: FontConstant.cairo,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.xl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
