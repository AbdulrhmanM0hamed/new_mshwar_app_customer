/// ─────────────────────────────────────────────────────────────
/// All API endpoint paths in one place.
/// Only the **path** portion — base URL comes from [Env].
/// ─────────────────────────────────────────────────────────────
class Endpoints {
  Endpoints._();

  // ── Auth ──
  static const String login = '/user-login';
  static const String register = '/user';
  static const String sendOtp = '/send-otp';
  static const String verifyOtp = '/verify-otp';
  static const String existingUser = '/existing-user';
  static const String profileByPhone = '/profilebyphone';
  static const String resetPasswordOtp = '/reset-password-otp';
  static const String resetPassword = '/resert-password'; // API typo preserved
  static const String socialLogin = '/existing-user';

  // ── User / Profile ──
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/update-profile';
  static const String changePassword = '/user/change-password';
  static const String deleteAccount = '/user/delete-account';

  // ── Home ──
  static const String home = '/home';
  static const String banners = '/banners';
  static const String categories = '/categories';

  // ── Wallet ──
  static const String wallet = '/wallet';
  static const String walletHistory = '/wallet/history';
  static const String walletCharge = '/wallet/charge';

  // ── Notifications ──
  static const String notifications = '/notifications';
  static const String readNotification = '/notifications/read';

  // ── Settings ──
  static const String settings = '/settings';
  static const String aboutUs = '/pages/about-us';
  static const String termsConditions = '/pages/terms-conditions';
  static const String privacyPolicy = '/pages/privacy-policy';
  static const String contactUs = '/contact-us';

  // ── Subscription / Packages ──
  static const String packages = '/packages';
  static const String userPackages = '/packages/user-packages';
  static const String subscriptions = '/subscription';
  static const String userSubscriptions = '/subscription/user-subscriptions';

  // ── Rides ──
  static const String rides = '/rides';
  static const String rideHistory = '/rides/history';
  static const String rideDetails = '/rides/details';
  static const String cancelRide = '/rides/cancel';
  static const String rateRide = '/rides/rate';

  // ── Addresses ──
  static const String addresses = '/addresses';
  static const String addAddress = '/addresses/add';
  static const String updateAddress = '/addresses/update';
  static const String deleteAddress = '/addresses/delete';

  // ── Vehicle Categories ──
  static const String vehicleCategories = '/vehicle-categories';

  // ── General ──
  static const String appVersion = '/app-version';
  static const String faqs = '/faqs';
}
