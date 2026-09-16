import SwiftUI
import WidgetKit

struct TamaneenaEntry: TimelineEntry {
    let date: Date
    let payload: WidgetPayload?
}

/// جدول زمني واحد للودجات الثلاث.
///
/// ## لماذا مدخلات عند كل حدّ
///
/// iOS يمنح الودجت نحو 40–70 إعادة تحميل يوميًا. لو انتظرنا التطبيق ليحدّثها عند
/// كل صلاة لنفد الرصيد أو تأخّرت الصلاة القادمة. بدل ذلك يُسلَّم WidgetKit
/// مدخلًا مؤرَّخًا **بلحظة كل صلاة ومنتصف الليل** للساعات القادمة، فيبدّل المعروض
/// عندها بنفسه — والمدخلات لا تُحسب من الرصيد.
///
/// والعدّ التنازلي نفسه `Text(date, style: .timer)`، يعدّ ثانية بثانية دون مدخلات.
///
/// ## متى يُعاد التحميل
///
/// - بعد آخر مدخل (نحو 36 ساعة).
/// - فورًا حين يكتب التطبيق بيانات جديدة (`HomeWidget.updateWidget`) — تغيير موقع
///   أو إعدادات حساب أو مزامنة الخلفية.
struct TamaneenaTimelineProvider: TimelineProvider {
    private static let horizon: TimeInterval = 36 * 60 * 60
    private static let retryWithoutData: TimeInterval = 6 * 60 * 60

    func placeholder(in context: Context) -> TamaneenaEntry {
        TamaneenaEntry(date: Date(), payload: WidgetPayload.sample())
    }

    func getSnapshot(in context: Context, completion: @escaping (TamaneenaEntry) -> Void) {
        let now = Date()
        let stored = WidgetPayloadStore.load()
        // معرض الودجات قبل أوّل مزامنة يعرض مثالًا بدل رسالة «افتح التطبيق».
        let payload: WidgetPayload? = stored ?? (context.isPreview ? WidgetPayload.sample(now: now) : nil)
        completion(TamaneenaEntry(date: now, payload: payload))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TamaneenaEntry>) -> Void) {
        let now = Date()
        guard let payload = WidgetPayloadStore.load() else {
            let entry = TamaneenaEntry(date: now, payload: nil)
            completion(Timeline(entries: [entry], policy: .after(now.addingTimeInterval(Self.retryWithoutData))))
            return
        }

        let end = now.addingTimeInterval(Self.horizon)
        let dates = [now] + payload.boundaries(after: now, until: end)
        let entries = dates.map { TamaneenaEntry(date: $0, payload: payload) }
        completion(Timeline(entries: entries, policy: .after(dates.last ?? end)))
    }
}

/// روابط الضغط. `homeWidget` في الاستعلام شرط home_widget ليمرّر الرابط إلى
/// Flutter؛ المسارات تطابق `HomeWidgetClickRouter` في Dart.
enum WidgetLinks {
    static let nextPrayer = URL(string: "tamaneena://widget/next-prayer?homeWidget")!
    static let prayerTimes = URL(string: "tamaneena://widget/prayer-times?homeWidget")!
    static let dailyAyah = URL(string: "tamaneena://widget/daily-ayah?homeWidget")!
}
