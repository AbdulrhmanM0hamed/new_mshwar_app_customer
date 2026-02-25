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
/// Login Page — Email & Password
/// ─────────────────────────────────────────────────────────────
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    context.read<AuthCubit>().loginWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;

    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (prev, curr) =>
          prev.errorMessage != curr.errorMessage ||
          prev.successMessage != curr.successMessage ||
          prev.user != curr.user,
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackbar.errorGlobal(state.errorMessage!);
          context.read<AuthCubit>().clearError();
        }
        if (state.successMessage != null) {
          AppSnackbar.successGlobal(l.translate(state.successMessage!));
          context.read<AuthCubit>().clearSuccess();
        }
        if (state.user != null && state.flow == AuthFlow.login) {
          Navigator.pushNamedAndRemoveUntil(context, Routes.home, (_) => false);
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state.isLoading,
          child: AuthScreenLayout(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Title ──
                  Text(
                    l.login,
                    style: getBoldStyle(
                      fontSize: FontSize.size24,
                      color: AppColors.primaryDark,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    l.loginSubtitle,
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
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.email_outlined, size: 20),
                    validator: Validators.email,
                  ),
                  const SizedBox(height: Spacing.base),

                  // ── Password ──
                  AppTextField(
                    controller: _passwordController,
                    label: l.password,
                    hint: l.passwordHint,
                    obscureText: state.obscurePassword,
                    textInputAction: TextInputAction.done,
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
                    onSubmitted: (_) => _onLogin(),
                  ),
                  const SizedBox(height: Spacing.sm),

                  // ── Forgot password ──
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.forgotPassword);
                      },
                      child: Text(
                        l.forgotPassword,
                        style: getSemiBoldStyle(
                          fontSize: FontSize.size13,
                          color: AppColors.primary,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),

                  // ── Login button ──
                  AppButton.filled(
                    text: l.login,
                    isLoading: state.isLoading,
                    onPressed: _onLogin,
                  ),
                  const SizedBox(height: Spacing.base),

                  // ── Phone login ──
                  AppButton.outlined(
                    text: l.loginWithPhone,
                    icon: Icons.phone_outlined,
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.otp);
                    },
                  ),
                  const SizedBox(height: Spacing.xl),

                  // ── Register link ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l.noAccount,
                        style: getRegularStyle(
                          fontSize: FontSize.size14,
                          color: AppColors.textSecondary,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.register);
                        },
                        child: Text(
                          l.registerNow,
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
          ),
        );
      },
    );
  }
}
