# 云开发容器：固定 Android CLI、JDK、Node、pnpm 和 Gradle，减少本地环境依赖。
FROM mcr.microsoft.com/devcontainers/java:1-17-bookworm

ARG NODE_MAJOR=22
ARG ANDROID_SDK_ROOT=/opt/android-sdk
ARG ANDROID_CMDLINE_TOOLS_VERSION=13114758
ARG GRADLE_VERSION=9.4.1

ENV ANDROID_HOME=${ANDROID_SDK_ROOT}
ENV ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT}
ENV PATH=${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/emulator:/opt/gradle/bin:${PATH}

USER root

# 安装 Node.js、Android SDK 依赖、Gradle 和基础排障工具。
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        unzip \
        zip \
        wget \
        xz-utils \
        libglu1-mesa \
        libpulse0 \
        libc6-i386 \
        lib32stdc++6 \
        lib32gcc-s1 \
        lib32z1 \
    && curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && corepack enable \
    && corepack prepare pnpm@10.12.1 --activate \
    && mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
    && wget -q https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CMDLINE_TOOLS_VERSION}_latest.zip -O /tmp/android-commandline-tools.zip \
    && unzip -q /tmp/android-commandline-tools.zip -d /tmp/android-commandline-tools \
    && mv /tmp/android-commandline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
    && yes | sdkmanager --licenses >/dev/null \
    && sdkmanager \
        "platform-tools" \
        "emulator" \
        "platforms;android-36" \
        "build-tools;36.0.0" \
        "system-images;android-36;google_apis;x86_64" \
    && wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -O /tmp/gradle.zip \
    && unzip -q /tmp/gradle.zip -d /opt \
    && ln -s /opt/gradle-${GRADLE_VERSION} /opt/gradle \
    && chown -R vscode:vscode ${ANDROID_SDK_ROOT} /opt/gradle-${GRADLE_VERSION} \
    && rm -rf /var/lib/apt/lists/* /tmp/*

USER vscode

