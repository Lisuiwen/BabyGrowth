// KMP 共享模块，承载业务模型、规则和同步协议。
plugins {
    id("org.jetbrains.kotlin.multiplatform")
    id("org.jetbrains.kotlin.plugin.serialization")
}

kotlin {
    androidTarget()

    sourceSets {
        commonMain.dependencies {
            implementation("org.jetbrains.kotlinx:kotlinx-datetime:0.7.1")
            implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.9.0")
        }
        commonTest.dependencies {
            implementation(kotlin("test"))
        }
    }
}

