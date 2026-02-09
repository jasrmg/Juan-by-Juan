plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.jasrmgdev.juan_by_juan"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
      applicationId = "com.jasrmgdev.juan_by_juan"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "environment"
    productFlavors {
      create("uat") {
        dimension = "environment"
        versionNameSuffix ="-uat"
        resValue("string", "app_name", "Juan by Juan UAT")
      }
      create("qat") {
        dimension = "environment"
        versionNameSuffix ="-qat"
        resValue("string", "app_name", "Juan by Juan QAT")
      }
      create("prod") {
        dimension = "environment"
        resValue("string", "app_name", "Juan by Juan")
      }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
