# 🏗️ Core & Utils Architecture Guide

> **مشوار — Customer App**
> هذا الملف يشرح كيفية استخدام الـ Core System الكامل في التطبيق.

---

## 📁 الهيكل الكامل

```
lib/
├── main.dart                          ← Entry point
├── core/
│   ├── app/
│   │   ├── app_initializer.dart       ← Bootstrap (Hive, Env, DI, Locale)
│   │   ├── app_config.dart            ← Read-only config
│   │   ├── env.dart                   ← dev / staging / prod
│   │   └── app_runner.dart            ← Root MaterialApp widget
│   ├── di/
│   │   ├── di.dart                    ← GetIt instance + configureDependencies()
│   │   └── modules/
│   │       ├── network_module.dart    ← Dio, Connectivity, NetworkInfo
│   │       ├── storage_module.dart    ← Placeholder (static classes)
│   │       └── localization_module.dart ← LocaleCubit, ThemeCubit
│   ├── network/
│   │   ├── dio_client.dart            ← Singleton Dio factory
│   │   ├── retrofit_client.dart       ← Helper for Retrofit clients
│   │   ├── interceptors/
│   │   │   ├── auth_interceptor.dart  ← Bearer token auto-attach
│   │   │   ├── lang_interceptor.dart  ← Accept-Language header
│   │   │   ├── logging_interceptor.dart ← Dev-only request/response logging
│   │   │   └── retry_interceptor.dart ← Auto-retry on transient errors
│   │   ├── endpoints.dart             ← All API paths
│   │   └── network_info.dart          ← Connectivity check
│   ├── error/
│   │   ├── failure.dart               ← Failure hierarchy (Equatable)
│   │   ├── exception.dart             ← Data-layer exceptions
│   │   ├── error_mapper.dart          ← Failure → localised string
│   │   └── result.dart                ← Sealed Result<T> type
│   ├── routing/
│   │   ├── app_router.dart            ← onGenerateRoute
│   │   ├── routes.dart                ← Named route constants
│   │   └── navigation_service.dart    ← Context-free navigation
│   ├── localization/
│   │   ├── locale_cubit.dart          ← Language switching + persistence
│   │   ├── localization_service.dart  ← All translated strings (ar/en/ur)
│   │   └── supported_locales.dart     ← Locale list + RTL detection
│   ├── theme/
│   │   ├── theme_cubit.dart           ← Light / Dark toggle + persistence
│   │   ├── app_theme.dart             ← Full ThemeData (light + dark)
│   │   ├── colors.dart                ← AppColors palette
│   │   ├── text_styles.dart           ← AppTextStyles (Cairo font)
│   │   └── spacing.dart               ← Spacing tokens (4dp grid)
│   ├── storage/
│   │   ├── preferences.dart           ← Hive wrapper (sync reads)
│   │   └── secure_storage.dart        ← flutter_secure_storage wrapper
│   ├── constants/
│   │   ├── app_constants.dart         ← Timeouts, pagination, limits
│   │   ├── keys.dart                  ← Storage & argument keys
│   │   ├── assets.dart                ← Asset paths
│   │   └── durations.dart             ← AppDurations (animations, debounce)
│   ├── utils/
│   │   ├── validators.dart            ← Form validators (localised)
│   │   ├── formatters.dart            ← Date, number, currency, phone
│   │   ├── debouncer.dart             ← Search debouncing
│   │   ├── logger.dart                ← AppLogger (zero-cost in release)
│   │   └── extensions/
│   │       ├── context_ext.dart       ← Theme, nav, snackbar, media
│   │       ├── string_ext.dart        ← Capitalize, validate, Arabic digits
│   │       ├── num_ext.dart           ← SizedBox gaps, padding, radius
│   │       └── date_ext.dart          ← Format, compare, age
│   ├── platform/
│   │   └── device_info.dart           ← Screen info, tablet detection
│   └── widgets/
│       ├── app_scaffold.dart          ← Base Scaffold
│       ├── app_button.dart            ← Filled / Outlined / Text + loading
│       ├── app_text_field.dart        ← Styled TextFormField
│       ├── app_svg.dart               ← SVG wrapper
│       ├── app_dialog.dart            ← Confirm / Info / Destructive
│       ├── app_snackbar.dart          ← Error / Success / Warning
│       ├── loading/
│       │   ├── loading_overlay.dart   ← Full-screen overlay
│       │   └── shimmer_list.dart      ← Skeleton loading
│       ├── states/
│       │   ├── empty_view.dart        ← "Nothing here"
│       │   ├── error_view.dart        ← Error + retry
│       │   └── no_internet_view.dart  ← WiFi off + retry
│       └── animations/
│           ├── fade_in.dart           ← Fade animation wrapper
│           └── slide_in.dart          ← Slide animation wrapper
├── shared/
│   ├── widgets/
│   │   ├── bottom_nav_shell.dart      ← Main tab navigation
│   │   ├── cached_image.dart          ← Network image with fallback
│   │   └── pagination_list.dart       ← Auto-load paginated list
│   └── models/
│       └── pagination.dart            ← Generic Pagination<T> model
└── features/                          ← (Feature modules go here)
```

---

## 🚀 1. App Startup Flow

```dart
// main.dart
void main() async {
  await AppInitializer.init(env: Environment.dev);
  runApp(const AppRunner());
}
```

**`AppInitializer.init()` يقوم بالتالي بالترتيب:**

1. `WidgetsFlutterBinding.ensureInitialized()`
2. `Preferences.init()` — فتح Hive box
3. `Env.init(env)` — تحديد البيئة (dev/staging/prod)
4. `LocalizationService.init(locale)` — تحميل اللغة المحفوظة
5. `configureDependencies()` — تسجيل كل الـ DI
6. System UI setup (portrait only, transparent status bar)

---

## 🌐 2. Network Layer

### إضافة API جديد لفيتشر

```dart
// features/auth/data/repo/auth_api.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:new_mshwar_app_customer/core/network/endpoints.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST(Endpoints.login)
  Future<LoginResponse> login(@Body() LoginRequest body);

  @GET(Endpoints.profile)
  Future<ProfileResponse> getProfile();
}
```

### تسجيل في DI

```dart
// features/auth/data/di/auth_di.dart
import 'package:new_mshwar_app_customer/core/di/di.dart';
import 'package:new_mshwar_app_customer/core/network/dio_client.dart';

class AuthDi {
  static void register() {
    // API
    getIt.registerLazySingleton(() => AuthApi(DioClient.instance));

    // Repo
    getIt.registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(getIt<AuthApi>()),
    );

    // Cubit
    getIt.registerFactory(() => AuthCubit(getIt<AuthRepo>()));
  }
}
```

### إضافة endpoint جديد

```dart
// core/network/endpoints.dart
static const String newEndpoint = '/path/to/endpoint';
```

---

## 🛡️ 3. Error Handling (Result Pattern)

### في الـ Repository

```dart
class AuthRepoImpl implements AuthRepo {
  final AuthApi _api;
  AuthRepoImpl(this._api);

  @override
  Future<Result<UserModel>> login(LoginRequest request) async {
    try {
      final response = await _api.login(request);
      return Result.success(response.toModel());
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return const Result.failure(
          NetworkFailure(message: 'no_internet_connection'),
        );
      }
      return Result.failure(
        ServerFailure(
          message: e.response?.data?['message'] ?? 'server_error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return const Result.failure(UnexpectedFailure());
    }
  }
}
```

### في الـ Cubit

```dart
class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _repo;
  AuthCubit(this._repo) : super(const AuthState.initial());

  Future<void> login(String email, String password) async {
    emit(const AuthState.loading());

    final result = await _repo.login(LoginRequest(email: email, password: password));

    result.when(
      success: (user) => emit(AuthState.success(user)),
      failure: (f)    => emit(AuthState.error(ErrorMapper.toMessageRaw(f))),
    );
  }
}
```

---

## 🌍 4. Localization

### الوصول للنصوص من Widget

```dart
// Option 1: via context extension
Text(context.l.retry)  // "إعادة المحاولة" / "Retry" / "دوبارہ کوشش کریں"

// Option 2: directly
Text(LocalizationService.instance.loading)
```

### تغيير اللغة

```dart
context.read<LocaleCubit>().changeLocale(SupportedLocales.english);
// أو
context.read<LocaleCubit>().toggleArabicEnglish();
```

### إضافة نص جديد

1. أضف key وقيمة في `_translations` map في `localization_service.dart` (لكل لغة)
2. أضف typed getter:

```dart
// في LocalizationService
String get myNewText => _t('my_new_text');

// في _translations:
'en': { 'my_new_text': 'Hello', ... },
'ar': { 'my_new_text': 'مرحبا', ... },
'ur': { 'my_new_text': 'ہیلو', ... },
```

---

## 🎨 5. Theme

### استخدام الألوان والخطوط

```dart
// Colors
Container(color: AppColors.primary)
Container(color: AppColors.error)

// Text styles
Text('Title', style: AppTextStyles.h3)
Text('Body', style: AppTextStyles.bodyMedium)

// Spacing
Padding(padding: EdgeInsets.all(Spacing.base))
SizedBox(height: Spacing.lg)

// أو باستخدام extensions
16.0.h   // SizedBox(height: 16)
8.0.w    // SizedBox(width: 8)
12.0.all // EdgeInsets.all(12)
```

### تبديل الثيم

```dart
context.read<ThemeCubit>().toggleDarkMode();
// أو
context.read<ThemeCubit>().setThemeMode(ThemeMode.dark);
```

---

## 💾 6. Storage

### Hive (بيانات عادية — سريع جداً)

```dart
// Save
await Preferences.setString('key', 'value');
await Preferences.setToken('jwt_token_here');

// Read (synchronous!)
final token = Preferences.token;
final name = Preferences.getString('user_name');

// Auth helpers
if (Preferences.isLoggedIn) { ... }
await Preferences.logout(); // clears token + user data
```

### Secure Storage (بيانات حساسة)

```dart
// Save
await SecureStorage.setAccessToken('sensitive_token');
await SecureStorage.setRefreshToken('refresh_token');

// Read
final token = await SecureStorage.accessToken;

// Clear
await SecureStorage.clearCredentials();
```

---

## 🧭 7. Navigation

### من Widget (مع context)

```dart
// Push
context.push(const ProfilePage());
context.pushNamed(Routes.profile);

// Replace
context.pushReplacement(const HomePage());
context.pushReplacementNamed(Routes.home);

// Clear stack
context.pushAndClear(const LoginPage());
context.pushNamedAndClear(Routes.login);

// Pop
context.pop();
```

### من Cubit / Service (بدون context)

```dart
NavigationService.push(Routes.home);
NavigationService.pushAndClear(Routes.login);
NavigationService.pop();
```

### تسجيل صفحة جديدة في Router

```dart
// core/routing/app_router.dart → onGenerateRoute
case Routes.login:
  return _page(
    BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: const LoginPage(),
    ),
    settings,
  );
```

---

## 📋 8. Validators

```dart
// في TextFormField
AppTextField(
  label: l.email,
  validator: Validators.email,
)

AppTextField(
  label: l.phone,
  validator: Validators.phone,
)

AppTextField(
  label: 'Password',
  validator: Validators.password,
)

// Confirm password
AppTextField(
  label: 'Confirm',
  validator: (v) => Validators.confirmPassword(v, passwordController.text),
)
```

---

## 🧩 9. Widgets الجاهزة

### AppButton

```dart
AppButton.filled(text: l.save, onPressed: () {})
AppButton.outlined(text: l.cancel, onPressed: () {})
AppButton.text(text: l.skip, onPressed: () {})

// مع loading
AppButton(text: l.save, isLoading: state.isLoading, onPressed: _submit)
```

### AppDialog

```dart
final confirmed = await AppDialog.confirm(
  context,
  title: 'حذف العنوان',
  message: 'هل أنت متأكد من حذف هذا العنوان؟',
);
if (confirmed == true) { ... }

// Destructive (red button)
await AppDialog.destructive(context, title: '...', message: '...');
```

### AppSnackbar

```dart
AppSnackbar.success(context, 'تم الحفظ بنجاح');
AppSnackbar.error(context, 'حدث خطأ');
AppSnackbar.warning(context, 'تنبيه');
// أو باستخدام context extension
context.showSnack('تم الحفظ');
```

### State Views

```dart
// Empty
EmptyView(title: l.noData)

// Error
ErrorView(message: errorMsg, onRetry: () => cubit.load())

// No internet
NoInternetView(onRetry: () => cubit.load())
```

### Loading

```dart
// Shimmer skeleton
ShimmerList(itemCount: 5, itemHeight: 80)

// Single shimmer box
ShimmerBox(width: 120, height: 20)

// Loading overlay (declarative)
LoadingOverlay(isLoading: state.isLoading, child: myContent)

// Loading overlay (imperative)
LoadingOverlay.show(context);
await doWork();
LoadingOverlay.hide(context);
```

### Animations

```dart
// Fade in
FadeIn(child: MyWidget())
FadeIn(delay: 200.ms, child: MyWidget())

// Slide in
SlideIn(child: MyWidget())
SlideIn(direction: SlideDirection.left, child: MyWidget())
SlideIn(delay: 300.ms, offset: 0.5, child: MyWidget())
```

---

## 🧱 10. Extensions

### Context

```dart
context.theme          // ThemeData
context.colorScheme    // ColorScheme
context.isDark         // bool
context.screenW        // double
context.screenH        // double
context.isTablet       // bool (width ≥ 600)
context.l              // LocalizationService
context.unfocus()      // dismiss keyboard
context.showSnack(msg) // snackbar
```

### String

```dart
'hello world'.capitalizeWords  // "Hello World"
'user@test.com'.isEmail        // true
'0770123'.isPhone              // true
'text'.truncate(3)             // "tex…"
'١٢٣'.toEnglishDigits         // "123"
'123'.toArabicDigits           // "١٢٣"
''.nullIfEmpty                 // null
```

### Num

```dart
16.h          // SizedBox(height: 16)
8.w           // SizedBox(width: 8)
12.all        // EdgeInsets.all(12)
16.horizontal // EdgeInsets.symmetric(horizontal: 16)
12.radius     // BorderRadius.circular(12)
500.ms        // Duration(milliseconds: 500)
2.sec         // Duration(seconds: 2)
```

### Date

```dart
DateTime.now().formatted      // "25 Feb 2026"
DateTime.now().timeOnly       // "12:05 PM"
DateTime.now().isToday        // true
DateTime.now().age            // 30 (years)
'2026-02-25'.toDate           // DateTime?
```

---

## 📦 11. إضافة Feature جديد (Template)

```
features/
└── my_feature/
    ├── data/
    │   ├── model/
    │   │   └── my_model.dart
    │   ├── response_model/
    │   │   └── my_response.dart
    │   ├── repo/
    │   │   └── my_repo.dart          ← (abstract + impl في نفس الملف)
    │   └── di/
    │       └── my_feature_di.dart
    └── presentation/
        ├── pages/
        │   └── my_page.dart
        ├── widgets/
        │   └── my_widget.dart
        └── cubits/
            ├── my_cubit.dart
            └── my_state.dart
```

### الخطوات:

1. **Model + Response**: أنشئ الـ data classes
2. **Repo**: abstract class + impl في ملف واحد
3. **DI**: سجّل API + Repo + Cubit في `my_feature_di.dart`
4. **أضف DI Call**: في `core/di/di.dart` → `MyFeatureDi.register();`
5. **Cubit + State**: حالات Initial / Loading / Success / Error
6. **Page**: اربط بـ BlocProvider في `app_router.dart`
7. **Route**: أضف route name في `core/routing/routes.dart`

---

## 📊 12. Packages المستخدمة

| Package                  | الغرض                          |
| ------------------------ | ------------------------------ |
| `flutter_bloc`           | State management (Cubit/Bloc)  |
| `get_it`                 | Dependency Injection           |
| `dio`                    | HTTP client                    |
| `retrofit`               | Type-safe API layer            |
| `hive` / `hive_flutter`  | Fast local storage             |
| `flutter_secure_storage` | Encrypted storage for secrets  |
| `connectivity_plus`      | Network connectivity detection |
| `equatable`              | Value equality for states      |
| `flutter_svg`            | SVG rendering                  |
| `shimmer`                | Loading skeletons              |
| `pretty_dio_logger`      | Dev network logging            |
| `intl`                   | Date/Number formatting         |
| `freezed_annotation`     | Immutable data classes         |
| `json_annotation`        | JSON serialization             |

---

## ✅ 13. Checklist لكل Feature

- [ ] لا يوجد import لـ GetX
- [ ] UI مطابق 1:1
- [ ] Navigation نفس السلوك
- [ ] Endpoints مطابقة
- [ ] لا يوجد runtime exceptions بسبب BlocProvider
- [ ] States تغطي: Initial / Loading / Success / Error
- [ ] Repo interface + impl في نفس الملف
- [ ] DI جاهز وتسجيل dependencies تم
- [ ] الكود مفصول Data / Presentation
- [ ] كل النصوص عبر LocalizationService
