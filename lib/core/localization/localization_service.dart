import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────────
/// Centralised localization service.
///
/// • Holds all translatable strings in maps per locale.
/// • Provides typed getters for every string (no magic keys in UI).
/// • Singleton [instance] for use outside widget tree (Cubits, repos).
/// • [of(context)] for use inside widgets.
/// ─────────────────────────────────────────────────────────────
class LocalizationService {
  // ── singleton ────────────────────────────────────────────
  static LocalizationService? _instance;
  static LocalizationService get instance {
    assert(_instance != null, 'LocalizationService not initialised');
    return _instance!;
  }

  /// Call once at app startup (inside AppInitializer).
  static void init(Locale locale) {
    _instance = LocalizationService._(locale);
  }

  /// Convenience — reads from closest [Localizations] ancestor.
  static LocalizationService of(BuildContext context) => instance;

  // ── state ────────────────────────────────────────────────
  Locale _locale;
  Locale get locale => _locale;

  LocalizationService._(this._locale);

  void setLocale(Locale locale) {
    _locale = locale;
    _instance = LocalizationService._(locale);
  }

  String _t(String key) {
    final langMap = _translations[_locale.languageCode];
    return langMap?[key] ?? _translations['en']?[key] ?? key;
  }

  /// Exposes translation for dynamic keys (like error codes from API).
  String translate(String key) => _t(key);

  // ═══════════════════════════════════════════════════════════
  // ██  TYPED GETTERS  ██
  // ═══════════════════════════════════════════════════════════

  // ── General ──
  String get appName => _t('app_name');
  String get ok => _t('ok');
  String get cancel => _t('cancel');
  String get yes => _t('yes');
  String get no => _t('no');
  String get save => _t('save');
  String get delete_ => _t('delete');
  String get edit => _t('edit');
  String get close => _t('close');
  String get retry => _t('retry');
  String get loading => _t('loading');
  String get search => _t('search');
  String get noData => _t('no_data');
  String get seeAll => _t('see_all');
  String get next_ => _t('next');
  String get previous => _t('previous');
  String get done_ => _t('done');
  String get skip => _t('skip');
  String get back => _t('back');
  String get confirm => _t('confirm');
  String get or_ => _t('or');

  // ── Errors ──
  String get noInternetConnection => _t('no_internet_connection');
  String get serverError => _t('server_error');
  String get cacheError => _t('cache_error');
  String get validationError => _t('validation_error');
  String get unauthorized => _t('unauthorized');
  String get unexpectedError => _t('unexpected_error');
  String get connectionTimeout => _t('connection_timeout');
  String get sessionExpired => _t('session_expired');
  String get somethingWentWrong => _t('something_went_wrong');

  // ── Validation ──
  String get fieldRequired => _t('field_required');
  String get invalidEmail => _t('invalid_email');
  String get invalidPhone => _t('invalid_phone');
  String get passwordTooShort => _t('password_too_short');
  String get passwordsNotMatch => _t('passwords_not_match');

  // ── Network states ──
  String get noInternet => _t('no_internet');
  String get noInternetDesc => _t('no_internet_desc');
  String get emptyHere => _t('empty_here');
  String get emptyHereDesc => _t('empty_here_desc');
  String get errorOccurred => _t('error_occurred');
  String get errorOccurredDesc => _t('error_occurred_desc');

  // ── Auth ──
  String get login => _t('login');
  String get loginSubtitle => _t('login_subtitle');
  String get email => _t('email');
  String get emailHint => _t('email_hint');
  String get password => _t('password');
  String get passwordHint => _t('password_hint');
  String get forgotPassword => _t('forgot_password');
  String get loginWithPhone => _t('login_with_phone');
  String get noAccount => _t('no_account');
  String get registerNow => _t('register_now');
  String get signInWithGoogle => _t('sign_in_with_google');
  String get signInWithApple => _t('sign_in_with_apple');

  // ── Phone Login / OTP ──
  String get phoneLoginTitle => _t('phone_login_title');
  String get enterPhoneNumber => _t('enter_phone_number');
  String get otpWillBeSent => _t('otp_will_be_sent');
  String get sendOtp => _t('send_otp');
  String get verifyCode => _t('verify_code');
  String get enterOtp => _t('enter_otp');
  String otpSentTo(String phone) => '${_t('otp_sent_to')} $phone';
  String get invalidOtp6Digits => _t('invalid_otp_6_digits');
  String get didntReceiveCode => _t('didnt_receive_code');
  String get resendCode => _t('resend_code');

  // ── Register ──
  String get createAccount => _t('create_account');
  String get createNewAccount => _t('create_new_account');
  String get completeDataToRegister => _t('complete_data_to_register');
  String get firstName => _t('first_name');
  String get firstNameHint => _t('first_name_hint');
  String get lastName => _t('last_name');
  String get lastNameHint => _t('last_name_hint');
  String get phoneNumber => _t('phone_number');
  String get confirmPassword => _t('confirm_password');
  String get createAccountBtn => _t('create_account_btn');
  String get alreadyHaveAccount => _t('already_have_account');
  String get loginNow => _t('login_now');

  // ── Forgot / Reset Password ──
  String get recoverPassword => _t('recover_password');
  String get forgotPasswordTitle => _t('forgot_password_title');
  String get forgotPasswordSubtitle => _t('forgot_password_subtitle');
  String get resetPassword => _t('reset_password');
  String otpSentToEmail(String email) => '${_t('otp_sent_to_email')} $email';
  String get otpCode => _t('otp_code');
  String get enterCode => _t('enter_code');
  String get newPassword => _t('new_password');
  String get resetBtn => _t('reset_btn');
  String get resendOtp => _t('resend_otp');
  String get passwordResetSuccess => _t('password_reset_success');

  // ── Success ──
  String get loginSuccess => _t('login_success');
  String get registrationSuccess => _t('registration_success');

  // ── Bottom Nav ──
  String get navHome => _t('nav_home');
  String get navRides => _t('nav_rides');
  String get navWallet => _t('nav_wallet');
  String get navSubs => _t('nav_subs');
  String get navPkgs => _t('nav_pkgs');
  String get navSettings => _t('nav_settings');

  // ═══════════════════════════════════════════════════════════
  // ██  TRANSLATION MAPS  ██
  // ═══════════════════════════════════════════════════════════
  static const Map<String, Map<String, String>> _translations = {
    // ─────────── ENGLISH ───────────
    'en': {
      'app_name': 'Mshwar',
      'ok': 'OK',
      'cancel': 'Cancel',
      'yes': 'Yes',
      'no': 'No',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'close': 'Close',
      'retry': 'Retry',
      'loading': 'Loading…',
      'search': 'Search',
      'no_data': 'No data available',
      'see_all': 'See All',
      'next': 'Next',
      'previous': 'Previous',
      'done': 'Done',
      'skip': 'Skip',
      'back': 'Back',
      'confirm': 'Confirm',
      'or': 'or',
      // errors
      'no_internet_connection': 'No internet connection',
      'server_error': 'Server error, please try again',
      'cache_error': 'Local storage error',
      'validation_error': 'Please check the entered data',
      'unauthorized': 'Unauthorized access',
      'unexpected_error': 'An unexpected error occurred',
      'connection_timeout': 'Connection timed out',
      'session_expired': 'Session expired, please login again',
      'something_went_wrong': 'Something went wrong',
      // validation
      'field_required': 'This field is required',
      'invalid_email': 'Invalid email address',
      'invalid_phone': 'Invalid phone number',
      'password_too_short': 'Password must be at least 6 characters',
      'passwords_not_match': 'Passwords do not match',
      // states
      'no_internet': 'No Internet',
      'no_internet_desc':
          'Please check your internet connection and try again.',
      'empty_here': 'Nothing Here',
      'empty_here_desc': 'There is no data to display right now.',
      'error_occurred': 'Error Occurred',
      'error_occurred_desc': 'Something went wrong. Please try again.',
      // auth
      'login': 'Login',
      'login_subtitle': 'Enter your credentials to continue',
      'email': 'Email',
      'email_hint': 'example@email.com',
      'password': 'Password',
      'password_hint': '••••••••',
      'forgot_password': 'Forgot Password?',
      'login_with_phone': 'Login with phone number',
      'no_account': 'Don\'t have an account?',
      'register_now': 'Register Now',
      'sign_in_with_google': 'Sign in with Google',
      'sign_in_with_apple': 'Sign in with Apple',
      // phone / otp
      'phone_login_title': 'Login with Phone',
      'enter_phone_number': 'Enter phone number',
      'otp_will_be_sent': 'We will send you a verification code to this number',
      'send_otp': 'Send Verification Code',
      'verify_code': 'Verify Code',
      'enter_otp': 'Enter verification code',
      'otp_sent_to': 'Verification code sent to',
      'invalid_otp_6_digits': 'Please enter a 6-digit code',
      'didnt_receive_code': 'Didn\'t receive the code?',
      'resend_code': 'Resend',
      // register
      'create_account': 'Create Account',
      'create_new_account': 'Create New Account',
      'complete_data_to_register': 'Complete your details to register',
      'first_name': 'First Name',
      'first_name_hint': 'Enter your first name',
      'last_name': 'Last Name',
      'last_name_hint': 'Enter your last name',
      'phone_number': 'Phone Number',
      'confirm_password': 'Confirm Password',
      'create_account_btn': 'Create Account',
      'already_have_account': 'Already have an account?',
      'login_now': 'Login',
      // forgot / reset
      'recover_password': 'Recover Password',
      'forgot_password_title': 'Forgot your password?',
      'forgot_password_subtitle':
          'Enter your email and we\'ll send you a reset code',
      'reset_password': 'Reset Password',
      'otp_sent_to_email': 'Verification code sent to',
      'otp_code': 'Verification Code',
      'enter_code': 'Enter the code',
      'new_password': 'New Password',
      'reset_btn': 'Reset',
      'resend_otp': 'Resend Code',
      'password_reset_success': 'Password reset successfully',
      'login_success': 'Logged in successfully',
      'registration_success': 'Account created successfully',
      // bottom nav
      'nav_home': 'Home',
      'nav_rides': 'Rides',
      'nav_wallet': 'Wallet',
      'nav_subs': 'Subs',
      'nav_pkgs': 'Pkgs',
      'nav_settings': 'Settings',
      // auth errors
      'login_failed': 'Login failed, please check your credentials',
      'otp_failed': 'Failed to send OTP code',
      'invalid_otp': 'Invalid OTP code',
      'profile_failed': 'Failed to load profile',
      'registration_failed': 'Registration failed',
      'reset_failed': 'Failed to reset password',
    },

    // ─────────── ARABIC ───────────
    'ar': {
      'app_name': 'مشوار',
      'ok': 'حسناً',
      'cancel': 'إلغاء',
      'yes': 'نعم',
      'no': 'لا',
      'save': 'حفظ',
      'delete': 'حذف',
      'edit': 'تعديل',
      'close': 'إغلاق',
      'retry': 'إعادة المحاولة',
      'loading': 'جاري التحميل…',
      'search': 'بحث',
      'no_data': 'لا توجد بيانات',
      'see_all': 'عرض الكل',
      'next': 'التالي',
      'previous': 'السابق',
      'done': 'تم',
      'skip': 'تخطي',
      'back': 'رجوع',
      'confirm': 'تأكيد',
      'or': 'أو',
      // errors
      'no_internet_connection': 'لا يوجد اتصال بالإنترنت',
      'server_error': 'خطأ في الخادم، يرجى المحاولة مرة أخرى',
      'cache_error': 'خطأ في التخزين المحلي',
      'validation_error': 'يرجى التحقق من البيانات المدخلة',
      'unauthorized': 'غير مصرّح بالوصول',
      'unexpected_error': 'حدث خطأ غير متوقع',
      'connection_timeout': 'انتهت مهلة الاتصال',
      'session_expired': 'انتهت الجلسة، يرجى تسجيل الدخول مجدداً',
      'something_went_wrong': 'حدث خطأ ما',
      // validation
      'field_required': 'هذا الحقل مطلوب',
      'invalid_email': 'البريد الإلكتروني غير صحيح',
      'invalid_phone': 'رقم الهاتف غير صحيح',
      'password_too_short': 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
      'passwords_not_match': 'كلمتا المرور غير متطابقتين',
      // states
      'no_internet': 'لا يوجد إنترنت',
      'no_internet_desc': 'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.',
      'empty_here': 'لا يوجد شيء هنا',
      'empty_here_desc': 'لا توجد بيانات لعرضها حالياً.',
      'error_occurred': 'حدث خطأ',
      'error_occurred_desc': 'حدث خطأ ما. يرجى المحاولة مرة أخرى.',
      // auth
      'login': 'تسجيل الدخول',
      'login_subtitle': 'أدخل بياناتك للمتابعة',
      'email': 'البريد الإلكتروني',
      'email_hint': 'example@email.com',
      'password': 'كلمة المرور',
      'password_hint': '••••••••',
      'forgot_password': 'نسيت كلمة المرور؟',
      'login_with_phone': 'الدخول برقم الهاتف',
      'no_account': 'ليس لديك حساب؟',
      'register_now': 'سجل الآن',
      'sign_in_with_google': 'تسجيل بواسطة Google',
      'sign_in_with_apple': 'تسجيل بواسطة Apple',
      // phone / otp
      'phone_login_title': 'الدخول برقم الهاتف',
      'enter_phone_number': 'أدخل رقم الهاتف',
      'otp_will_be_sent': 'سنرسل لك رمز التحقق على هذا الرقم',
      'send_otp': 'إرسال رمز التحقق',
      'verify_code': 'التحقق من الرمز',
      'enter_otp': 'أدخل رمز التحقق',
      'otp_sent_to': 'تم إرسال رمز التحقق إلى',
      'invalid_otp_6_digits': 'يرجى إدخال رمز مكون من 6 أرقام',
      'didnt_receive_code': 'لم تستلم الرمز؟',
      'resend_code': 'إعادة الإرسال',
      // register
      'create_account': 'إنشاء حساب',
      'create_new_account': 'إنشاء حساب جديد',
      'complete_data_to_register': 'أكمل البيانات للتسجيل',
      'first_name': 'الاسم الأول',
      'first_name_hint': 'أدخل اسمك الأول',
      'last_name': 'اسم العائلة',
      'last_name_hint': 'أدخل اسم العائلة',
      'phone_number': 'رقم الهاتف',
      'confirm_password': 'تأكيد كلمة المرور',
      'create_account_btn': 'إنشاء الحساب',
      'already_have_account': 'لديك حساب بالفعل؟',
      'login_now': 'سجل الدخول',
      // forgot / reset
      'recover_password': 'استعادة كلمة المرور',
      'forgot_password_title': 'نسيت كلمة المرور؟',
      'forgot_password_subtitle':
          'أدخل بريدك الإلكتروني وسنرسل لك رمز لإعادة التعيين',
      'reset_password': 'إعادة تعيين كلمة المرور',
      'otp_sent_to_email': 'تم إرسال رمز التحقق إلى',
      'otp_code': 'رمز التحقق',
      'enter_code': 'أدخل الرمز',
      'new_password': 'كلمة المرور الجديدة',
      'reset_btn': 'إعادة التعيين',
      'resend_otp': 'إعادة إرسال الرمز',
      'password_reset_success': 'تم إعادة تعيين كلمة المرور بنجاح',
      'login_success': 'تم تسجيل الدخول بنجاح',
      'registration_success': 'تم إنشاء الحساب بنجاح',
      // bottom nav
      'nav_home': 'الرئيسية',
      'nav_rides': 'مشاويري',
      'nav_wallet': 'المحفظة',
      'nav_subs': 'اشتراكاتي',
      'nav_pkgs': 'باقاتي',
      'nav_settings': 'الإعدادات',
      // auth errors
      'login_failed': 'بيانات الدخول غير صحيحة، يرجى المحاولة مرة أخرى',
      'otp_failed': 'فشل في إرسال رمز التحقق',
      'invalid_otp': 'رمز التحقق غير صحيح',
      'profile_failed': 'فشل جلب الحساب',
      'registration_failed': 'فشل إنشاء الحساب',
      'reset_failed': 'فشل إعادة تعيين كلمة المرور',
    },

    // ─────────── URDU ───────────
    'ur': {
      'app_name': 'مشوار',
      'ok': 'ٹھیک ہے',
      'cancel': 'منسوخ',
      'yes': 'ہاں',
      'no': 'نہیں',
      'save': 'محفوظ کریں',
      'delete': 'حذف کریں',
      'edit': 'ترمیم',
      'close': 'بند کریں',
      'retry': 'دوبارہ کوشش کریں',
      'loading': 'لوڈ ہو رہا ہے…',
      'search': 'تلاش',
      'no_data': 'کوئی ڈیٹا دستیاب نہیں',
      'see_all': 'سب دیکھیں',
      'next': 'اگلا',
      'previous': 'پچھلا',
      'done': 'ہو گیا',
      'skip': 'چھوڑیں',
      'back': 'واپس',
      'confirm': 'تصدیق',
      'or': 'یا',
      // errors
      'no_internet_connection': 'انٹرنیٹ کنکشن نہیں ہے',
      'server_error': 'سرور کی خرابی، براہ کرم دوبارہ کوشش کریں',
      'cache_error': 'مقامی اسٹوریج کی خرابی',
      'validation_error': 'براہ کرم درج کردہ ڈیٹا کی جانچ کریں',
      'unauthorized': 'غیر مجاز رسائی',
      'unexpected_error': 'ایک غیر متوقع خرابی پیش آئی',
      'connection_timeout': 'کنکشن کا وقت ختم ہو گیا',
      'session_expired': 'سیشن ختم ہو گیا، براہ کرم دوبارہ لاگ ان کریں',
      'something_went_wrong': 'کچھ غلط ہو گیا',
      // validation
      'field_required': 'یہ فیلڈ ضروری ہے',
      'invalid_email': 'ای میل ایڈریس غلط ہے',
      'invalid_phone': 'فون نمبر غلط ہے',
      'password_too_short': 'پاس ورڈ کم از کم 6 حروف کا ہونا چاہیے',
      'passwords_not_match': 'پاس ورڈ مماثل نہیں ہیں',
      // states
      'no_internet': 'انٹرنیٹ نہیں ہے',
      'no_internet_desc':
          'براہ کرم اپنا انٹرنیٹ کنکشن چیک کریں اور دوبارہ کوشش کریں۔',
      'empty_here': 'یہاں کچھ نہیں ہے',
      'empty_here_desc': 'ابھی دکھانے کے لیے کوئی ڈیٹا نہیں ہے۔',
      'error_occurred': 'خرابی پیش آئی',
      'error_occurred_desc': 'کچھ غلط ہو گیا۔ براہ کرم دوبارہ کوشش کریں۔',
      // auth
      'login': 'لاگ ان',
      'login_subtitle': 'جاری رکھنے کے لیے اپنی تفصیلات درج کریں',
      'email': 'ای میل',
      'email_hint': 'example@email.com',
      'password': 'پاس ورڈ',
      'password_hint': '••••••••',
      'forgot_password': 'پاس ورڈ بھول گئے؟',
      'login_with_phone': 'فون نمبر سے لاگ ان',
      'no_account': 'اکاؤنٹ نہیں ہے؟',
      'register_now': 'ابھی رجسٹر کریں',
      'sign_in_with_google': 'Google سے سائن ان کریں',
      'sign_in_with_apple': 'Apple سے سائن ان کریں',
      // phone / otp
      'phone_login_title': 'فون سے لاگ ان',
      'enter_phone_number': 'فون نمبر درج کریں',
      'otp_will_be_sent': 'ہم آپ کو اس نمبر پر تصدیقی کوڈ بھیجیں گے',
      'send_otp': 'تصدیقی کوڈ بھیجیں',
      'verify_code': 'کوڈ کی تصدیق',
      'enter_otp': 'تصدیقی کوڈ درج کریں',
      'otp_sent_to': 'تصدیقی کوڈ بھیجا گیا',
      'invalid_otp_6_digits': 'براہ کرم 6 ہندسوں کا کوڈ درج کریں',
      'didnt_receive_code': 'کوڈ موصول نہیں ہوا؟',
      'resend_code': 'دوبارہ بھیجیں',
      // register
      'create_account': 'اکاؤنٹ بنائیں',
      'create_new_account': 'نیا اکاؤنٹ بنائیں',
      'complete_data_to_register': 'رجسٹریشن کے لیے تفصیلات مکمل کریں',
      'first_name': 'پہلا نام',
      'first_name_hint': 'اپنا پہلا نام درج کریں',
      'last_name': 'آخری نام',
      'last_name_hint': 'اپنا آخری نام درج کریں',
      'phone_number': 'فون نمبر',
      'confirm_password': 'پاس ورڈ کی تصدیق',
      'create_account_btn': 'اکاؤنٹ بنائیں',
      'already_have_account': 'پہلے سے اکاؤنٹ ہے؟',
      'login_now': 'لاگ ان کریں',
      // forgot / reset
      'recover_password': 'پاس ورڈ بازیابی',
      'forgot_password_title': 'پاس ورڈ بھول گئے؟',
      'forgot_password_subtitle':
          'اپنا ای میل درج کریں اور ہم آپ کو ری سیٹ کوڈ بھیجیں گے',
      'reset_password': 'پاس ورڈ ری سیٹ',
      'otp_sent_to_email': 'تصدیقی کوڈ بھیجا گیا',
      'otp_code': 'تصدیقی کوڈ',
      'enter_code': 'کوڈ درج کریں',
      'new_password': 'نیا پاس ورڈ',
      'reset_btn': 'ری سیٹ',
      'resend_otp': 'کوڈ دوبارہ بھیجیں',
      'password_reset_success': 'پاس ورڈ کامیابی سے ری سیٹ ہو گیا',
      'login_success': 'کامیابی سے لاگ ان ہو گیا',
      'registration_success': 'اکاؤنٹ کامیابی سے بن گیا',
      // bottom nav
      'nav_home': 'ہوم',
      'nav_rides': 'رائڈز',
      'nav_wallet': 'پرس',
      'nav_subs': 'سبسکرپشنز',
      'nav_pkgs': 'پیکجز',
      'nav_settings': 'ترتیبات',
      // auth errors
      'login_failed': 'لاگ ان ناکام، براہ کرم اپنی معلومات چیک کریں',
      'otp_failed': 'او ٹی پی کوڈ بھیجنے میں ناکام',
      'invalid_otp': 'غلط او ٹی پی کوڈ',
      'profile_failed': 'پروفائل لوڈ کرنے میں ناکام',
      'registration_failed': 'رجسٹریشن ناکام',
      'reset_failed': 'پاس ورڈ ری سیٹ کرنے میں ناکام',
    },
  };
}
