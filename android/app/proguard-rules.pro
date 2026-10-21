# ==============================================================================
# Suporte ao Flutter Engine e Play Core (Ignorar avisos do R8)
# ==============================================================================
-dontwarn com.google.android.play.core.**
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.provider.** { *; }

# ==============================================================================
# WorkManager e Banco Interno Room (Suas regras atuais)
# ==============================================================================
-keep class androidx.work.impl.WorkDatabase_Impl { *; }
-keep class * extends androidx.room.RoomDatabase { *; }
-keep class * extends androidx.work.ListenableWorker {
    public <init>(android.content.Context, androidx.work.WorkerParameters);
}

-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# ==============================================================================
# Firebase & Storage
# ==============================================================================
-keep class com.google.firebase.** { *; }
-keepclassmembers class com.google.firebase.** { *; }

# ==============================================================================
# Flutter Downloader & Notificações
# ==============================================================================
-keep class com.vn.flutter_downloader.** { *; }
-keep class vn.hunghd.flutterdownloader.** { *; }
-keep class androidx.work.** { *; }
-keep class androidx.core.app.NotificationCompat** { *; }