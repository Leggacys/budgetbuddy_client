# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.

# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep Google Sign-In classes
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.common.** { *; }

# Keep HTTP client classes
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }

# Keep Flutter classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep app links classes
-keep class com.llfbandit.app_links.** { *; }

# Keep URL launcher classes
-keep class io.flutter.plugins.urllauncher.** { *; }

# Keep shared preferences classes
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# General Android rules
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep custom attributes
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses