# دليل الاستخدام والتطوير — طمأنينة

## الإعداد الأولي

```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

## تشغيل التطبيق

```bash
flutter run                          # تشغيل على الجهاز المتصل
flutter run -d android               # تشغيل على أندرويد
flutter run -d ios                   # تشغيل على iOS
```

## توليد الكود (Code Generation)

```bash
# توليد ملفات الموارد (assets, fonts, colors)
dart run build_runner build --delete-conflicting-outputs

# مراقبة التغييرات تلقائياً
dart run build_runner watch --delete-conflicting-outputs
```

## بناء الإصدار

```bash
# Android App Bundle (للنشر على Google Play)
flutter build appbundle --release

# Android APK
flutter build apk --release --split-per-abi

# مع التشفير وملفات Debug
flutter build appbundle --obfuscate --split-debug-info=symbols/

# iOS
flutter build ios --release
```

## فحص الكود

```bash
flutter analyze
flutter test
```

## إدارة الحزم

```bash
flutter pub outdated          # فحص الحزم القديمة
flutter pub upgrade           # تحديث الحزم
```

## ملاحظات مهمة

- ملف `google-services.json` مطلوب في `android/app/` لعمل Firebase
- ملف `key.properties` مطلوب في `android/` لتوقيع التطبيق
- إذن الموقع مطلوب لمواقيت الصلاة واتجاه القبلة
- إذن الإشعارات مطلوب لتنبيهات الصلوات
