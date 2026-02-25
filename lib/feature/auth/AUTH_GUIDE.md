# 🔐 دليل هيكلية قسم المصادقة (Auth Feature)

هذا الدليل يشرح بالتفصيل الممل كيف تم بناء قسم الـ Auth (تسجيل الدخول، إنشاء حساب، الخ) باستخدام أحدث التقنيات وأفضل المعايير (Clean Architecture) مع استخدام مكاتب `Retrofit` و `Freezed` و `json_serializable`.

إذا كنت تستخدم هذه المكاتب لأول مرة، فهذا الدليل سيأخذك خطوة بخطوة من بداية وصول الداتا من السيرفر (Data Layer) وصولاً إلى عرضها في الشاشة (UI Layer).

---

## 📁 الهيكل العام (Structure)

داخل `lib/feature/auth/` نجد هذا التقسيم الواضح:

```
auth/
├── data/                       ← (التعامل مع البيانات والسيرفر)
│   ├── model/                  ← (موديلات التطبيق الداخلية)
│   ├── response_model/         ← (موديلات مخصصة لاستقبال رد السيرفر)
│   ├── repo/                   ← (الوسيط بين الداتا والـ UI)
│   └── di/                     ← (حقن الاعتماديات - Dependency Injection)
└── presentation/               ← (واجهة المستخدم واللوجيك الخاص بها)
    ├── cubits/                 ← (إدارة الحالة - State Management)
    ├── pages/                  ← (الشاشات الكاملة)
    └── widgets/                ← (مكونات الشاشة المجزأة)
```

---

## 🔄 دورة حياة البيانات (The Cycle)

الcycle بتمشي بالترتيب الآتي (من تحت لفوق):

1. **Model / Response Model**: تصميم شكل الداتا.
2. **Retrofit API**: عمل الـ functions اللي بتكلم السيرفر.
3. **Repository**: استدعاء الـ API وتحويل النتيجة إلى `Success` أو `Error`.
4. **Cubit**: استدعاء الـ Repo وتغيير حالة الشاشة (`Loading`, `Success`, `Error`).
5. **UI (Page)**: الاستماع لتغييرات الـ Cubit وتحديث الشاشة (مثلاً إظهار Loading Indicator، أو إظهار Snackbar في حال الخطأ).

---

## 1️⃣ الطبقة الأولى: Models & Serializers

لأننا لا نريد كتابة الـ `fromJson` و `toJson` بشكل يدوي (لأنه عرضة للأخطاء وصعب في التعديل)، نستخدم `Freezed` و `json_serializable`.

### ما هو `Freezed`؟

هي مكتبة بتقوم بتوليد كود (Code Generation) عشان تخلي الـ Models الخاصة بك:

- **Immutable** (ثابتة لا تتغير بعد إنشائها، لو عايز تغير فيها بتعمل نسخة جديدة بـ `copyWith`).
- تدعم **Value Equality** (لو عندي أوبجيكتين بنفس الداتا، يبقوا متساويين).

### ما هو `json_serializable`؟

بيولد كود بيحوّل الـ JSON اللي راجع من السيرفر إلى Dart Object والعكس.

### مثال: `user_model.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

// لازم نكتب السطرين دول عشان الـ build_runner يولد الكود فيهم
part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed // بنقول لـ freezed يشتغل على الكلاس ده
class UserModel with _$UserModel {
  const UserModel._(); // عشان نقدر نضيف دوال (functions) جوا الكلاس

  const factory UserModel({
    // @JsonKey بتستخدم لو اسم الـ key في السيرفر مختلف عن المتغير في التطبيق
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'prenom') required String firstName,
    @JsonKey(name: 'nom') required String lastName,
    // ... باقي المتغيرات
  }) = _UserModel;

  // الدالة دي بتربط الكلاس بالكود اللي اتولد عشان الـ JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
```

> ⚠️ **مهم جداً:** بعد كتابة أو تعديل أي Model بيستخدم `part`، سيظهر لك خطأ أحمر. يجب تشغيل هذا الأمر في الـ Terminal لتوليد الكود المخفي:
> `dart run build_runner build --delete-conflicting-outputs`

---

## 2️⃣ الطبقة الثانية: Network (Retrofit)

### ما هو `Retrofit`؟

هو مبني فوق `Dio`. بدل ما نكتب تفاصيل الـ Request (URL, Body, Headers) بشكل يدوي (زي `dio.post('url', data: body)`)، بنعرف شكل الـ API كـ `abstract class` و `Retrofit` بيولد كود الـ `Dio` بالنيابة عننا بصورة آمنة جداً (Type-Safe).

### مثال: `auth_repo_api.dart`

```dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
// ... imports

part 'auth_repo_api.g.dart'; // ملف الكود المولد

@RestApi() // تحديد إن ده Retrofit Client
abstract class AuthRepoApi {
  factory AuthRepoApi(Dio dio, {String baseUrl}) = _AuthRepoApi;

  // بنحدد الـ Method (POST) والـ Endpoint المخصص ليها
  @POST(Endpoints.login)
  Future<AuthResponse> login(
    @Body() Map<String, dynamic> body, // الداتا اللي هتتبعت في الـ Body
  );
}
```

هنا لما ننادي على `login`، `Retrofit` هياخد الماب اللي بعتناها ويبعتها كـ JSON للسيرفر، ولما السيرفر يرد، هيمرر الرد مباشرة للـ `AuthResponse.fromJson` ويرجعلنا أوبجيكت جاهز!

---

## 3️⃣ الطبقة الثالثة: Repository (Repo)

الـ Repo هو "المخ" بتاع الداتا. الـ UI والـ Cubit ميعرفوش أي حاجة عن السيرفر أو `Dio` أو `Retrofit`. هما بيكلموا الـ Repo وهو بيتصرف.

لدينا ملف `auth_repo.dart` مقسم لجزئين في نفس الملف:

1. `abstract class AuthRepo`: دي مجرد "عقد" (Contract) بيقول إيه المتاح (login, register, ...).
2. `class AuthRepoImpl implements AuthRepo`: ده التنفيذ الفعلي للعقد.

### مثال التنفيذ:

```dart
class AuthRepoImpl implements AuthRepo {
  final AuthRepoApi _api; // حقن (Inject) الـ Retrofit API

  AuthRepoImpl(this._api);

  @override
  Future<Result<UserModel>> loginWithEmail(String email, String password) async {
    try {
      // 1. منكلم السيرفر عن طريق Retrofit
      final authResponse = await _api.login({
        'email': email,
        'mdp': password,
        'user_cat': Env.userCategory, // مثلاً 'customer'
      });

      // 2. بنشوف هل الرد ناجح والداتا موجودة؟
      if (authResponse.isSuccess && authResponse.user != null) {
        // 3. بنحفظ الجلسة (Token & User Data) في الـ Storage
        await _persistSession(authResponse.user!);

        // 4. بنرجع النجاح مع الداتا (Result.success)
        return Result.success(authResponse.user!);
      }

      // لو السيرفر رجع خطأ لوجيك (مثل: بيانات خاطئة)
      return Result.failure(ServerFailure(message: authResponse.message));

    } catch (e) {
      // لو حصل خطأ في النت أو تعليق بيمسك الـ Exception ويرجع Failure
      return _handleDioError(e);
    }
  }
}
```

> نستخدم `Result<T>` بحيث الدالة بترجع دايماً يا إما `Result.success(data)` أو `Result.failure(error)`. ده بيمنع حدوث Exceptions مفاجئة تطلّع التطبيق بره.

---

## 4️⃣ الطبقة الرابعة: Dependency Injection (DI)

عشان مانقعدش نعمل `new AuthRepoImpl(new AuthRepoApi(dio))` في كل صفحة ونستهلك الرام، بنستخدم `getIt` في ملف `auth_di.dart` لتسجيل كل حاجة مرة واحدة بس.

```dart
class AuthDi {
  static void register() {
    // 1. تسجيل الـ API
    getIt.registerLazySingleton<AuthRepoApi>(() => AuthRepoApi(getIt<Dio>()));

    // 2. تسجيل الـ Repo (بياخد الـ API جواه)
    getIt.registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(getIt<AuthRepoApi>()),
    );

    // 3. تسجيل الـ Cubit (بياخد الـ Repo جواه)
    // لاحظ: استخدمنا Factory عشان كل مرة بنفتح الشاشة يعمل Cubit جديد نظيف
    getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepo>()));
  }
}
```

---

## 5️⃣ الطبقة الخامسة: State Management (Cubit)

الـ `AuthCubit` هو اللي بيربط الـ UI بالـ Repo. الـ UI بيبعتله Event (مثلا دوسنا زرار تسجيل الدخول)، وهو بيكلم الـ Repo، وبيطلع الحالة (State) للـ UI عشان يعرضها.

```dart
class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _repo;
  AuthCubit(this._repo) : super(const AuthState.initial());

  Future<void> loginWithEmail(String email, String password) async {
    // 1. بنقول للـ UI إننا بدأنا تحميل (Loading)
    emit(state.copyWith(isLoading: true, clearError: true));

    // 2. بنكلم الـ Repo
    final result = await _repo.loginWithEmail(email, password);

    // 3. بنستقبل النتيجة (Result Pattern)
    result.when(
      success: (user) {
        // لو نجحنا، نوقف الـ Loading ونبعت داتا المستخدم كـ Success
        emit(state.copyWith(isLoading: false, user: user));
      },
      failure: (f) {
        // لو فشلنا، نوقف الـ Loading ونبعت رسالة الخطأ كـ Error
        emit(state.copyWith(
          isLoading: false,
          errorMessage: ErrorMapper.toMessageRaw(f) // تحويل الفشل لرسالة مقروءة للـ User
        ));
      },
    );
  }
}
```

---

## 6️⃣ الطبقة السادسة والأخيرة: واجهة المستخدم (UI)

في ملف مثل `login_page.dart`، بنستخدم الـ `BlocConsumer` (وهو دمج بين `BlocBuilder` لعمل Rebuild للشاشة، و `BlocListener` للاستماع للـ Events اللي بتظهر مرة واحدة زي الانتقال لشاشة تانية أو عرض Snackbar).

```dart
// الشاشة لازم تتغلف بـ BlocProvider ودا تم عمله مسبقاً في الـ AppRouter
BlocConsumer<AuthCubit, AuthState>(
  // بنقول للـ Listener يشتغل بس لو حصل رسالة خطأ أو اليوزر اتعمله تسجيل دخول
  listenWhen: (prev, curr) => prev.errorMessage != curr.errorMessage || prev.user != curr.user,
  listener: (context, state) {
    // هل جالي خطأ؟
    if (state.errorMessage != null) {
      AppSnackbar.errorGlobal(state.errorMessage!); // اظهر للمستخدم popup فيها الخطأ
      context.read<AuthCubit>().clearError(); // نظف الخطأ عشان ما يظهرش تاني بدون سبب
    }
    // هل دخلت بنجاح؟
    if (state.user != null) {
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (_) => false); // انتقل للرئيسية
    }
  },
  builder: (context, state) {
    // لو state.isLoading بقت true، الدائرة دي هتلف وهتمنع تفاعل المستخدم
    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Scaffold(
        // ... باقي الحقول و الـ UI
        AppButton.filled(
          text: 'تسجيل الدخول',
          isLoading: state.isLoading, // الزرار هيلف برضو كتدعيم للي فوقه
          onPressed: () {
            // الاستدعاء الحقيقي للحدث
            context.read<AuthCubit>().loginWithEmail(email, password);
          },
        ),
      )
    );
  }
)
```

---

## 🎯 ملخص الدورة في مشهد واحد

1. المستخدم يكتب الإيميل والباسورد ويضغط **"تسجيل الدخول"**.
2. الـ **UI** ينادي الدالة `loginWithEmail` في **Cubit**.
3. الـ **Cubit** يبعت حالة `isLoading = true` (الـ UI يعرض مؤشر تحميل).
4. الـ **Cubit** ينادي دالة الـ `loginWithEmail` في **AuthRepo**.
5. الـ **AuthRepo** ياخد الداتا وينادي دالة الـ `login` في **Retrofit API**.
6. الـ **Retrofit / Dio** يبعت الـ Request للسيرفر.
7. السيرفر يرد بـ JSON.
8. **Freezed & json_serializable** بيقوموا أوتوماتيكياً بتحويل الـ JSON لـ `AuthResponse` Object.
9. الـ **AuthRepo** يستقبل الاوبجكت، لو كان Success بيحفظ الـ Token ويرجع الـ `UserModel` كـ `Result.success()`.
10. الـ **Cubit** يستقبل النجاح ويبعت للـ UI حالة النجاح (الـ User Data).
11. أخيراً، الـ **UI (BlocListener)** يلاحظ وصول الداتا، فيقوم بعمل `Navigator.pushNamed` لشاشة الرئيسية.

تهانينا! 🎉 أنت الآن تفهم المعمارية الجديدة للمشروع بالكامل، وسبب كتابة كل طبقة. بمجرد تنفيذك وتشغيلك للأمر `dart run build_runner build` ستتولى كل المولدات (Generators) العمل الممل، لتترك لك حرية كتابة اللوجيك فقط بسلاسة وصفر أخطاء بشرية!
