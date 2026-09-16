import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.samma3ly.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "30.0.15729638"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // مطلوب من flutter_local_notifications (يعتمد على مكتبات جافا 8+
        // desugared) — بدونه فشل البناء بـ "requires core library
        // desugaring to be enabled for :app".
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        // اسم التطبيق الثابت للأبد على أي جهاز — لا يتغيّر بعد أول نشر
        // حقيقي، وإلا اعتبره أندرويد تطبيقاً مختلفاً تماماً (يفرض حذف
        // النسخة القديمة يدوياً، فتُفقَد بيانات المستخدم المحلية).
        applicationId = "com.samma3ly.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val keystorePropertiesFile = rootProject.file("key.properties")
            if (keystorePropertiesFile.exists()) {
                val keystoreProperties = Properties()
                keystoreProperties.load(FileInputStream(keystorePropertiesFile))
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // مفتاح توقيع ثابت (android/key.properties، غير متتبَّع في
            // Git) — لازم يكون نفسه في كل نسخة تُنشَر مستقبلاً، وإلا رفض
            // أندرويد أي تحديث لاحق باعتباره تطبيقاً موقَّعاً بمفتاح
            // مختلف. لو الملف غير موجود بعد (مثلاً على CI بلا الملف
            // السرّي)، يرجع تلقائياً لمفتاح الـdebug — بناء صالح للاختبار
            // فقط، غير مخصَّص للنشر الفعلي.
            val keystorePropertiesFile = rootProject.file("key.properties")
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
