import Foundation

struct WidgetPrayer: Decodable, Hashable {
    let key: String
    let name: String
    /// اللحظة الحقيقية بالميلي ثانية منذ 1970.
    let at: Double
    /// الوقت المعروض بساعة المدينة، مُنسَّق في Dart كما في التطبيق.
    let time: String
    let isPrayer: Bool

    var date: Date { Date(timeIntervalSince1970: at / 1000) }
}

struct WidgetDay: Decodable {
    let date: String
    let weekday: String
    let gregorian: String
    let hijri: String
    let prayers: [WidgetPrayer]
}

struct WidgetVerse: Decodable {
    let date: String
    let text: String
    let source: String
}

/// بيانات الودجات كما يكتبها `HomeWidgetPayloadBuilder` في Dart.
///
/// تحمل مواقيت 30 يومًا بلحظات حقيقية، فتختار الودجت المعروض الآن بنفسها
/// دون أيّ تشغيل للتطبيق.
struct WidgetPayload: Decodable {
    let version: Int
    let utcOffsetMinutes: Int
    let location: String?
    let days: [WidgetDay]
    let verses: [WidgetVerse]
    /// اتّجاه لغة التطبيق (لا الجهاز). غائب في بيانات قديمة ← عربية.
    var rtl: Bool? = nil
    /// نصوص الودجت بلغة التطبيق، يكتبها Dart من L10n.
    var labels: [String: String]? = nil

    var isRtl: Bool { rtl ?? true }

    /// نصّ بلغة التطبيق، وإلا [fallback] العربي.
    func label(_ key: String, _ fallback: String) -> String {
        guard let value = labels?[key], !value.isEmpty else { return fallback }
        return value
    }

    /// «العصر بعد» / «Asr in» — القالب من Dart، و{prayer} يُملأ هنا.
    func nextIn(_ prayerName: String) -> String {
        let template = label("nextIn", "{prayer} بعد")
        guard template.contains("{prayer}") else { return "\(prayerName) بعد" }
        return template.replacingOccurrences(of: "{prayer}", with: prayerName)
    }

    /// أوّل صلاة لم يحن وقتها (الشروق مستثنى)، مع يومها.
    func nextPrayer(after now: Date) -> (day: WidgetDay, prayer: WidgetPrayer)? {
        for day in days {
            for prayer in day.prayers where prayer.isPrayer && prayer.date > now {
                return (day, prayer)
            }
        }
        return nil
    }

    /// آية يوم المدينة الحالي.
    func verse(for now: Date) -> WidgetVerse? {
        let key = dateKey(for: now)
        return verses.first { $0.date == key }
    }

    /// لحظات تغيّر المعروض بين [now] و[end]: كل صلاة وشروق، ومنتصف ليل المدينة.
    /// تصبح هذه مدخلات الجدول الزمني، فتنتقل الودجت عندها دون إعادة تحميل.
    func boundaries(after now: Date, until end: Date) -> [Date] {
        var result = Set<Date>()
        for day in days {
            for prayer in day.prayers where prayer.date > now && prayer.date <= end {
                result.insert(prayer.date)
            }
        }

        let calendar = cityCalendar
        var midnight = calendar.startOfDay(for: now)
        while let next = calendar.date(byAdding: .day, value: 1, to: midnight), next <= end {
            result.insert(next)
            midnight = next
        }
        return result.sorted()
    }

    /// `yyyy-MM-dd` بتاريخ المدينة — نفس مفاتيح Dart.
    private func dateKey(for now: Date) -> String {
        let parts = cityCalendar.dateComponents([.year, .month, .day], from: now)
        return String(format: "%04d-%02d-%02d", parts.year ?? 0, parts.month ?? 0, parts.day ?? 0)
    }

    private var cityCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: utcOffsetMinutes * 60) ?? .current
        return calendar
    }
}

enum WidgetPayloadStore {
    /// يطابق `HomeWidgetIds.appGroupId` وملفّي entitlements.
    static let appGroup = "group.com.tamaanina.app.widgets"
    /// يطابق `HomeWidgetIds.payloadKey`.
    static let key = "tamaneena_widgets_v2_payload"
    /// يطابق `HomeWidgetIds.payloadVersion`؛ بيانات بإصدار آخر تُتجاهل.
    static let supportedVersion = 2

    static func load() -> WidgetPayload? {
        guard
            let raw = UserDefaults(suiteName: appGroup)?.string(forKey: key),
            let data = raw.data(using: .utf8),
            let payload = try? JSONDecoder().decode(WidgetPayload.self, from: data),
            payload.version == supportedVersion
        else {
            return nil
        }
        return payload
    }
}

extension WidgetPayload {
    /// بيانات عرض لمعرض الودجات قبل أوّل مزامنة.
    static func sample(now: Date = Date()) -> WidgetPayload {
        func prayer(_ key: String, _ name: String, _ minutes: Double, _ time: String,
                    isPrayer: Bool = true) -> WidgetPrayer {
            WidgetPrayer(
                key: key,
                name: name,
                at: (now.timeIntervalSince1970 + minutes * 60) * 1000,
                time: time,
                isPrayer: isPrayer
            )
        }

        let day = WidgetDay(
            date: "",
            weekday: "الأربعاء",
            gregorian: "",
            hijri: "٤ ربيع الآخر ١٤٤٨ هـ",
            prayers: [
                prayer("fajr", "الفجر", -600, "4:25 ص"),
                prayer("sunrise", "الشروق", -520, "5:43 ص", isPrayer: false),
                prayer("dhuhr", "الظهر", -180, "11:48 ص"),
                prayer("asr", "العصر", 75, "3:15 م"),
                prayer("maghrib", "المغرب", 250, "6:10 م"),
                prayer("isha", "العشاء", 340, "7:40 م"),
            ]
        )
        return WidgetPayload(
            version: WidgetPayloadStore.supportedVersion,
            utcOffsetMinutes: 180,
            location: "منطقة الرياض",
            days: [day],
            verses: []
        )
    }
}
