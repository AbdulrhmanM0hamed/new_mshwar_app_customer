import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mshwar_app_customer/core/theme/colors.dart';
import 'package:new_mshwar_app_customer/core/theme/spacing.dart';
import 'package:new_mshwar_app_customer/core/constants/styles_manger.dart';
import 'package:new_mshwar_app_customer/core/constants/font_manger.dart';
import 'package:new_mshwar_app_customer/core/utils/extensions/context_ext.dart';
import 'package:new_mshwar_app_customer/core/utils/validators.dart';
import 'package:new_mshwar_app_customer/core/widgets/app_button.dart';
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
                  // ── Welcome Title ──
                  Text(
                    l.login,
                    style: getBoldStyle(
                      fontSize: FontSize.size28,
                      color: AppColors.textPrimary,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l.loginSubtitle,
                    style: getRegularStyle(
                      fontSize: FontSize.size14,
                      color: AppColors.textSecondary,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Email Field ──
                  _buildLabel(l.email),
                  const SizedBox(height: 8),
                  _StyledTextField(
                    controller: _emailController,
                    hint: l.emailHint,
                    icon: Icons.alternate_email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 20),

                  // ── Password Field ──
                  _buildLabel(l.password),
                  const SizedBox(height: 8),
                  _StyledTextField(
                    controller: _passwordController,
                    hint: l.passwordHint,
                    icon: Icons.lock_outline_rounded,
                    obscureText: state.obscurePassword,
                    textInputAction: TextInputAction.done,
                    validator: Validators.password,
                    onSubmitted: (_) => _onLogin(),
                    suffixIcon: GestureDetector(
                      onTap: () =>
                          context.read<AuthCubit>().togglePasswordVisibility(),
                      child: Icon(
                        state.obscurePassword
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        size: 20,
                        color: AppColors.textHint,
                      ),
                    ),
                  ),

                  // ── Forgot password ──
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.forgotPassword);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 6,
                        ),
                      ),
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
                  const SizedBox(height: 16),

                  // ── Login button ──
                  AppButton.filled(text: l.login, onPressed: _onLogin),
                  const SizedBox(height: 20),

                  // ── OR Divider ──
                  _buildOrDivider(l.or_),
                  const SizedBox(height: 20),

                  // ── Phone login ──
                  _PhoneLoginButton(
                    label: l.loginWithPhone,
                    onTap: () => Navigator.pushNamed(context, Routes.otp),
                  ),
                  const SizedBox(height: 28),

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
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        ),
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: getSemiBoldStyle(
        fontSize: FontSize.size14,
        color: AppColors.textPrimary,
        fontFamily: FontConstant.cairo,
      ),
    );
  }

  Widget _buildOrDivider(String text) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1.2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.border.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              text,
              style: getRegularStyle(
                fontSize: FontSize.size12,
                color: AppColors.textHint,
                fontFamily: FontConstant.cairo,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1.2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.border.withValues(alpha: 0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ██  STYLED TEXT FIELD — Premium Input Design  ██
// ═══════════════════════════════════════════════════════════════
class _StyledTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmitted;
  final Widget? suffixIcon;

  const _StyledTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onSubmitted,
    this.suffixIcon,
  });

  @override
  State<_StyledTextField> createState() => _StyledTextFieldState();
}

class _StyledTextFieldState extends State<_StyledTextField> {
  bool _hasFocus = false;
  String? _errorText;

  static final _noBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide.none,
  );

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.isNotEmpty;
    final hasError = _errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Input Container ──
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: _hasFocus
                ? AppColors.primary.withValues(alpha: 0.03)
                : const Color(0xFFF8F9FB),
            border: Border.all(
              color: hasError
                  ? AppColors.error.withValues(alpha: 0.6)
                  : _hasFocus
                  ? AppColors.primary.withValues(alpha: 0.5)
                  : const Color(0xFFE8ECF0),
              width: _hasFocus || hasError ? 1.8 : 1.2,
            ),
          ),
          child: Focus(
            onFocusChange: (f) => setState(() => _hasFocus = f),
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              validator: (value) {
                final error = widget.validator?.call(value);
                // Update external error after frame
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() => _errorText = error);
                });
                return error == null ? null : '';
              },
              onFieldSubmitted: widget.onSubmitted,
              onChanged: (_) {
                if (_errorText != null) {
                  setState(() => _errorText = null);
                }
                setState(() {});
              },
              style: getRegularStyle(
                fontSize: FontSize.size15,
                color: AppColors.textPrimary,
                fontFamily: FontConstant.cairo,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: getRegularStyle(
                  fontSize: FontSize.size14,
                  color: AppColors.textHint,
                  fontFamily: FontConstant.cairo,
                ),
                prefixIcon: Container(
                  width: 48,
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _hasFocus || hasText
                          ? AppColors.primary.withValues(alpha: 0.12)
                          : const Color(0xFFEEEFF2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 19,
                      color: _hasFocus || hasText
                          ? AppColors.primary
                          : AppColors.textHint,
                    ),
                  ),
                ),
                suffixIcon: widget.suffixIcon != null
                    ? Padding(
                        padding: const EdgeInsetsDirectional.only(end: 12),
                        child: widget.suffixIcon,
                      )
                    : null,
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                filled: false,
                border: _noBorder,
                enabledBorder: _noBorder,
                focusedBorder: _noBorder,
                errorBorder: _noBorder,
                focusedErrorBorder: _noBorder,
                disabledBorder: _noBorder,
                // Hide the built-in error text (we show it outside)
                errorStyle: const TextStyle(
                  fontSize: 0,
                  height: 0,
                  color: Colors.transparent,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ),

        // ── External Error Text ──
        if (hasError)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 8, top: 6),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 14,
                  color: AppColors.error,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _errorText!,
                    style: getRegularStyle(
                      fontSize: FontSize.size12,
                      color: AppColors.error,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ██  PHONE LOGIN BUTTON  ██
// ═══════════════════════════════════════════════════════════════
class _PhoneLoginButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PhoneLoginButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: Spacing.buttonHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.25),
              width: 1.5,
            ),
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.04),
                AppColors.primary.withValues(alpha: 0.08),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.phone_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: getSemiBoldStyle(
                  fontSize: FontSize.size14,
                  color: AppColors.primary,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
