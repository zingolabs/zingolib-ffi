#!/bin/bash
set -euo pipefail
# Note: This script is just temporary, it will eventually be replaced by a cargo-based script with cargo-make.

# Detect Android SDK root
ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT:-$HOME/Android/Sdk}

# Try to detect latest NDK installed
if [ -d "$ANDROID_SDK_ROOT/ndk" ]; then
  LATEST_NDK=$(ls "$ANDROID_SDK_ROOT/ndk" | sort -V | tail -n1)
  ANDROID_NDK="$ANDROID_SDK_ROOT/ndk/$LATEST_NDK"
elif [ -d "$ANDROID_SDK_ROOT/ndk-bundle" ]; then
  ANDROID_NDK="$ANDROID_SDK_ROOT/ndk-bundle"
else
  echo "❌ Could not locate Android NDK. Set ANDROID_SDK_ROOT or install the NDK via Android Studio."
  exit 1
fi

echo "✅ Using NDK at $ANDROID_NDK"

# Export env vars needed by bindgen and cargo-ndk
export ANDROID_NDK_HOME="$ANDROID_NDK"
export ANDROID_NDK_ROOT="$ANDROID_NDK"
export BINDGEN_EXTRA_CLANG_ARGS="--sysroot=$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot"

export BINDGEN_EXTRA_CLANG_ARGS="--sysroot=$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot"

cargo run \
    --release --features=uniffi/cli \
    --bin uniffi-bindgen \
    generate ./src/zingolib.udl \
    --language kotlin \
    --out-dir ../zingolib_android/lib/src/main/kotlin/

time cargo ndk -t arm64-v8a -t armeabi-v7a -t x86 -t x86_64 build --release -Z build-std

# Run object-stripping tool

llvm-strip --strip-all ../target/aarch64-linux-android/release/libzingolib.so
llvm-strip --strip-all ../target/armv7-linux-androideabi/release/libzingolib.so
llvm-strip --strip-all ../target/i686-linux-android/release/libzingolib.so
llvm-strip --strip-all ../target/x86_64-linux-android/release/libzingolib.so

# Remove comments

llvm-objcopy --remove-section .comment ../target/aarch64-linux-android/release/libzingolib.so
llvm-objcopy --remove-section .comment ../target/armv7-linux-androideabi/release/libzingolib.so
llvm-objcopy --remove-section .comment ../target/i686-linux-android/release/libzingolib.so
llvm-objcopy --remove-section .comment ../target/x86_64-linux-android/release/libzingolib.so

# Export build artifacts

# Create folders
mkdir -p ../zingolib_android/lib/src/main/jniLibs/arm64-v8a
mkdir -p ../zingolib_android/lib/src/main/jniLibs/armeabi-v7a
mkdir -p ../zingolib_android/lib/src/main/jniLibs/x86
mkdir -p ../zingolib_android/lib/src/main/jniLibs/x86_64

mkdir -p ../zingolib_android/lib/build/generated/source/uniffi/debug/java/uniffi/zingo
mkdir -p ../zingolib_android/lib/build/generated/source/uniffi/release/java/uniffi/zingo

# Copy artifacts
cp ../target/x86_64-linux-android/release/libzingolib.so ../zingolib_android/lib/src/main/jniLibs/x86_64/libzingolib_android.so
cp ../target/i686-linux-android/release/libzingolib.so ../zingolib_android/lib/src/main/jniLibs/x86/libzingolib_android.so
cp ../target/armv7-linux-androideabi/release/libzingolib.so ../zingolib_android/lib/src/main/jniLibs/armeabi-v7a/libzingolib_android.so
cp ../target/aarch64-linux-android/release/libzingolib.so ../zingolib_android/lib/src/main/jniLibs/arm64-v8a/libzingolib_android.so