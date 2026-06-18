// Gradle 根工程配置，Android Studio 从这里识别 KMP 与 Android 模块。
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "BabyGrowthLog"
include(":apps:android")
include(":shared")

