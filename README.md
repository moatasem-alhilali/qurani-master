# طمأنينة — تطبيق القرآن الكريم 🕌

[![Flutter](https://img.shields.io/badge/Flutter-3.6+-blue?logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/badge/license-MIT-orange)](./LICENSE)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-green)](https://flutter.dev)
[![Version](https://img.shields.io/badge/version-1.0.5-brightgreen)](./pubspec.yaml)
![visitors](https://visitor-badge.glitch.me/badge?right_color=teal&page_id=tamaneena/quran-app)
![open source](https://img.shields.io/badge/-open%20source-wheat)

تطبيق إسلامي شامل يجمع بين قراءة القرآن الكريم والاستماع إليه مع مجموعة متكاملة من المميزات الإسلامية.

---

## بعض الشاشات

<table>
  <tr>
    <td><img src="https://github.com/yourSite0/qurani-master/blob/main/screenshots/1.jpg" alt="Image 2"></td>
    <td><img src="https://github.com/yourSite0/qurani-master/blob/main/screenshots/2.jpg" alt="Image 2"></td>
    <td><img src="https://github.com/yourSite0/qurani-master/blob/main/screenshots/3.jpg" alt="Image 2"></td>
    <td><img src="https://github.com/yourSite0/qurani-master/blob/main/screenshots/4.jpg" alt="Image 2"></td>
  </tr>
</table>

<table>
  <tr>
    <td><img src="https://github.com/yourSite0/qurani-master/blob/main/screenshots/5.jpg" alt="Image 2"></td>
    <td><img src="https://github.com/yourSite0/qurani-master/blob/main/screenshots/6.jpg" alt="Image 2"></td>
    <td><img src="https://github.com/yourSite0/qurani-master/blob/main/screenshots/7.jpg" alt="Image 2"></td>
  </tr>
</table>

---

## المميزات الرئيسية

| الميزة               | الوصف                                                         |
| -------------------- | ------------------------------------------------------------- |
| 📖 قراءة القرآن      | عرض النص بالرسم العثماني مع خطوط متعددة وعلامات الوقف         |
| 🎧 الاستماع للقرآن   | تشغيل الصوت مع قراء متعددين ودعم التحميل للاستماع بدون إنترنت |
| ⏰ مواقيت الصلاة     | تحديد المواقيت تلقائياً حسب الموقع مع إشعارات                 |
| 🕋 اتجاه القبلة      | بوصلة إلكترونية مع خريطة تفاعلية                              |
| 📿 الأذكار والأدعية  | أذكار الصباح والمساء وأذكار بعد الصلاة مع عداد التسبيح        |
| 🔍 البحث المتقدم     | محرك بحث في القرآن الكريم بدون تشكيل                          |
| 🔖 العلامات المرجعية | حفظ وتنظيم مواضع القراءة مع ملاحظات                           |
| ✨ أسماء الله الحسنى | شرح وتفسير الأسماء الحسنى                                     |
| 📚 المكتبة الإسلامية | كتب ومراجع إسلامية مع دعم التحميل                             |
| 📜 الحديث الشريف     | مجموعة الأربعين النووية                                       |
| 🛡️ الرقية الشرعية    | محتوى متخصص للرقية                                            |
| 🗓️ خطط القراءة       | برامج منظمة لختم القرآن                                       |
| 🔔 الإشعارات         | تنبيهات مجدولة للصلوات والأذكار                               |
| 🌙 الوضع الليلي      | دعم كامل للوضع الداكن والفاتح                                 |
| 🌐 دعم اللغتين       | العربية والإنجليزية                                           |
| 📡 وضع بدون إنترنت   | عمل كامل offline مع مزامنة تلقائية                            |

---

## مبدأ العمل (Operating Principle)

<a target="_blank" href="https://volansys.com/wp-content/uploads/2019/07/VOLANSYS_Tiers-of-Architecture-new.jpg">
  <img width="350" alt="clean_architecture" src="https://user-images.githubusercontent.com/61885011/132905821-d68d4792-3f8f-4660-a648-968f353dcb1c.jpg">
</a>

---

## هيكل المشروع

```
lib/
├── core/                    # المكونات الأساسية المشتركة
│   ├── bloc/                # إدارة الحالة (Theme, Connectivity, Audio)
│   ├── components/          # مكونات واجهة قابلة لإعادة الاستخدام
│   ├── local_database/      # قاعدة بيانات SQLite
│   ├── notification/        # نظام الإشعارات المحلية و Firebase
│   ├── services/            # الخدمات (Download, Location, Permission)
│   └── theme/               # إدارة المظهر والألوان
│
├── features/                # الميزات الرئيسية (26 ميزة)
│   ├── read_quran/          # قراءة القرآن
│   ├── quran_audio/         # الاستماع للقرآن
│   ├── prayer_time/         # مواقيت الصلاة
│   ├── qiblah/              # اتجاه القبلة
│   ├── thikr/               # الأذكار
│   ├── search/              # البحث
│   ├── bookmark/            # العلامات المرجعية
│   ├── allh_name/           # أسماء الله الحسنى
│   ├── books/               # المكتبة الإسلامية
│   ├── hadith_40/           # الأربعون النووية
│   ├── ruqia_shareia/       # الرقية الشرعية
│   ├── sabih/               # التسبيح
│   ├── wird/                # الورد اليومي
│   ├── young_muslim/        # محتوى الشباب المسلم
│   ├── setting/             # الإعدادات
│   └── home/                # الشاشة الرئيسية
│
├── gen/                     # ملفات مولدة تلقائياً (flutter_gen)
├── main.dart                # نقطة البداية
└── main_view.dart           # الواجهة الرئيسية
```

---

## المعمارية

يعتمد التطبيق على **Clean Architecture** مع **BLoC Pattern**:

```
Presentation Layer  →  BLoC / Cubit
Domain Layer        →  Use Cases + Entities
Data Layer          →  Repositories + Data Sources
```

---

## التقنيات المستخدمة

- **Flutter SDK** ≥ 3.6.0
- **State Management**: flutter_bloc + rxdart
- **Local DB**: sqflite
- **Network**: dio + connectivity_plus
- **Audio**: just_audio + flutter_downloader
- **Maps**: flutter_map + flutter_qiblah
- **Prayer Times**: adhan + adhan_dart
- **Firebase**: core + messaging + remote_config + firestore
- **Notifications**: flutter_local_notifications
- **DI**: get_it

---

## تشغيل المشروع

```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

---

## بناء الإصدار

```bash
# Android App Bundle
flutter build appbundle --release

# مع التشفير
flutter build appbundle --obfuscate --split-debug-info=symbols/
```

---

## سياسة الخصوصية

[Privacy Policy](./PRIVACY_POLICY.md)

---

## الخاتمة

سيسعدني الإجابة على أي أسئلة، لا تتردد في فتح Issue أو Pull Request 🙂

إذا أعجبك المشروع، لا تنسَ ⭐ تنجيم المستودع لإظهار دعمك. شكراً!

---

## الترخيص

هذا المشروع مرخص تحت [MIT License](./LICENSE).
