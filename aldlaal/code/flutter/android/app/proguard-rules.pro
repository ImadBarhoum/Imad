# Flutter-specific rules.
-keep class io.flutter.app.**
-keep class io.flutter.plugin.**
-keep class io.flutter.util.**
-keep class io.flutter.view.**
-keep class io.flutter.plugins.**

# Firebase Messaging
-keep class com.google.firebase.messaging.**

# Awesome Notifications
-keep class me.carda.awesome_notifications.**

# Rules for Google Play Core Library (from your error log)
-keep class com.google.android.play.core.splitcompat.SplitCompatApplication
-keep class com.google.android.play.core.splitinstall.**
-keep class com.google.android.play.core.tasks.**