// 根构建脚本只声明插件版本，具体模块按需启用。
plugins {
    id("com.android.application") version "9.2.0" apply false
    id("org.jetbrains.kotlin.android") version "2.4.0" apply false
    id("org.jetbrains.kotlin.multiplatform") version "2.4.0" apply false
    id("org.jetbrains.compose") version "1.9.0" apply false
    id("org.jetbrains.kotlin.plugin.serialization") version "2.4.0" apply false
}

