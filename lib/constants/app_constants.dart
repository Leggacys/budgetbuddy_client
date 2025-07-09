// Global constants for the application
class AppConstants {
  // API URLs
  static const String baseUrl = 'https://api.budgetbuddy.com';
  static const String devServerUrl = 'http://10.0.2.2:5000';

  // App Information
  static const String appName = 'Budget Buddy';
  static const String appVersion = '1.0.0';

  // Shared Preferences Keys
  static const String userEmailKey = 'user_email';
  static const String userTokenKey = 'user_token';

  // Deep Link Schemes
  static const String deepLinkScheme = 'com.example.budgetbuddy';

  // Error Messages
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError =
      'Network error. Please check your connection.';
  static const String authError = 'Authentication failed. Please log in again.';
}

// Color constants
class AppColors {
  static const primaryColor = 0xFF2196F3;
  static const secondaryColor = 0xFF03DAC6;
  static const errorColor = 0xFFB00020;
  static const backgroundColor = 0xFFF5F5F5;
}

// Text style constants
class AppTextStyles {
  static const double headingSize = 24.0;
  static const double bodySize = 16.0;
  static const double captionSize = 12.0;
}
