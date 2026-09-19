package com.tamaneena.tamaneena_app.l10n

import android.content.Context
import android.content.res.Configuration
import android.os.LocaleList
import java.util.Locale

/**
 * لغة التطبيق التي اختارها المستخدم داخل التطبيق (لا لغة الجهاز).
 *
 * يكتبها Dart عبر `CacheService` (حزمة shared_preferences بواجهتها القديمة
 * `SharedPreferences`) تحت المفتاح `L10nService.storageKey` = `app_locale_code`.
 * على أندرويد تحفظها الإضافة في ملف `FlutterSharedPreferences` مع البادئة
 * `flutter.`، فيُقرأ المفتاح هنا كـ `flutter.app_locale_code`.
 */
object AppLocale {
    private const val FLUTTER_PREFS_NAME = "FlutterSharedPreferences"
    private const val LOCALE_KEY = "flutter.app_locale_code"

    /** يطابق `AppLanguage` في Dart. العربية هي الافتراضية. */
    private val SUPPORTED_CODES = setOf("ar", "ur", "bn", "id", "fa", "tr")
    const val DEFAULT_CODE = "ar"

    /** رمز اللغة المحفوظ بصيغة Dart (`id` لا `in`)، أو العربية. */
    fun savedLanguageCode(context: Context): String {
        val saved = try {
            context.getSharedPreferences(FLUTTER_PREFS_NAME, Context.MODE_PRIVATE)
                .getString(LOCALE_KEY, null)
        } catch (_: Exception) {
            null
        }
        return saved?.takeIf { it in SUPPORTED_CODES } ?: DEFAULT_CODE
    }

    /**
     * موارد أندرويد للإندونيسية في `values-in` (الرمز القديم)، فنبني الـ Locale
     * بالرمز نفسه حتى تُطابَق على كل الإصدارات.
     */
    @Suppress("DEPRECATION")
    fun localeFor(code: String): Locale = Locale(if (code == "id") "in" else code)
}

/**
 * سياق تُقرأ منه الموارد (`getString`) بلغة التطبيق المختارة بدل لغة الجهاز.
 * عند أي خطأ يُعاد السياق الأصلي كما هو.
 */
fun Context.appLocalized(): Context {
    return try {
        val locale = AppLocale.localeFor(AppLocale.savedLanguageCode(this))
        val config = Configuration(resources.configuration)
        config.setLocale(locale)
        // minSdk = 24، فـ LocaleList متاحة دائمًا.
        config.setLocales(LocaleList(locale))
        createConfigurationContext(config)
    } catch (_: Exception) {
        this
    }
}
