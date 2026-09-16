pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.11.1" apply false
    // START: FlutterFire Configuration
    // 4.3.10 ← 4.4.4: إضافة Crashlytics من الإصدار 3.x تشترط google-services
    // 4.4.1 فما فوق.
    id("com.google.gms.google-services") version("4.4.4") apply false
    // تُدخِل معرّف البناء الذي يشترطه Crashlytics عند التشغيل، وترفع ملفات
    // R8 mapping حتى تُقرأ أعطال Java/Kotlin المضغوطة في الإصدار النهائي.
    // مثال الإضافة يثبّت 2.8.1، وهو أقدم من AGP 8؛ والمشروع على AGP 8.11.1.
    id("com.google.firebase.crashlytics") version("3.0.8") apply false
    // END: FlutterFire Configuration
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")
