//
//  TamaneenaWidgetsDesignPreview.swift
//  طمأنينة — تصاميم WidgetKit للويدجتات الجديدة.
//
//  ⚠️ هذا الملفّ **مصمَّم وغير مفعّل عمدًا**.
//
//  لا يُبنى ولا يُشحن: لم يُضف إلى هدف TamaneenaWidgets في Xcode، ولا تظهر
//  أي من بنياته في `TamaneenaWidgets: WidgetBundle`. النظام لا يعرض إلا ما
//  تُصرّح به الحزمة، فوجود الملفّ وحده لا يُنشئ ويدجتًا.
//
//  لتفعيلها لاحقًا — خطوتان لا ثالث لهما:
//    1. أضف هذا الملفّ إلى عضوية هدف TamaneenaWidgets (Target Membership).
//    2. أضف البنيات الستّ إلى `body` في `TamaneenaWidgets`.
//  وما عدا ذلك جاهز: مفاتيح البيانات تكتبها `HomeWidgetsService` بالفعل على
//  المنصّتين، وأسماء الأنواع مسجّلة في `iosWidgetKinds`.
//
//  المقابل على أندرويد: `TamaneenaExtraWidgets.kt` — وهو مفعّل هناك.
//

import SwiftUI
import WidgetKit

/// معرّف مجموعة التطبيقات.
///
/// مُعاد تعريفه هنا لأن نظيره في `TamaneenaWidgets.swift` معلَن `private`،
/// وهي في المستوى الأعلى تعني «محصور بملفّه». والتعريفان لا يتعارضان لهذا
/// السبب نفسه. القيمة يجب أن تطابق `HomeWidgetsService.appGroupId` في دارت.
private let appGroupId = "group.com.tamaneena.tamaneenaapp.widgets"

// MARK: - البيانات الإضافية

/// حقول الويدجتات الجديدة، تُقرأ من مجموعة التطبيقات نفسها.
///
/// فُصلت عن `TamaneenaWidgetData` لتبقى هذه الإضافة قابلة للحذف بملفّ واحد
/// ما دامت غير مفعّلة، ولئلّا يتضخّم نوعٌ يُحمَّل في كل ويدجت عامل.
struct TamaneenaExtraData {
    let tasbihTitle: String
    let tasbihText: String
    let tasbihCount: Int
    let qiblaTitle: String
    let qiblaDirection: String
    let qiblaDistance: String
    let hijriTitle: String
    let hijriDate: String
    let hijriGregorian: String
    let hijriWeekday: String
    let readingTitle: String
    let readingSurah: String
    let readingPosition: String
    let trackerFlags: String
    let trackerCaption: String

    static func load() -> TamaneenaExtraData {
        let defaults = UserDefaults(suiteName: appGroupId) ?? .standard
        return TamaneenaExtraData(
            tasbihTitle: defaults.string(forKey: "tasbih_title") ?? "المسبحة",
            tasbihText: defaults.string(forKey: "tasbih_text") ?? "سبحان الله وبحمده",
            tasbihCount: defaults.integer(forKey: "widget_tasbih_count"),
            qiblaTitle: defaults.string(forKey: "qibla_title") ?? "القبلة",
            qiblaDirection: defaults.string(forKey: "qibla_direction") ?? "—",
            qiblaDistance: defaults.string(forKey: "qibla_distance") ?? "حدّد موقعك في المواقيت",
            hijriTitle: defaults.string(forKey: "hijri_title") ?? "التاريخ الهجري",
            hijriDate: defaults.string(forKey: "hijri_date") ?? "—",
            hijriGregorian: defaults.string(forKey: "hijri_gregorian") ?? "",
            hijriWeekday: defaults.string(forKey: "hijri_weekday") ?? "طمأنينة",
            readingTitle: defaults.string(forKey: "reading_title") ?? "متابعة القراءة",
            readingSurah: defaults.string(forKey: "reading_surah") ?? "لم تبدأ بعد",
            readingPosition: defaults.string(forKey: "reading_position") ?? "افتح المصحف لتبدأ",
            trackerFlags: defaults.string(forKey: "tracker_flags") ?? "00000",
            trackerCaption: defaults.string(forKey: "tracker_caption") ?? "افتح التطبيق لتعليم ما صلّيت"
        )
    }
}

struct TamaneenaExtraEntry: TimelineEntry {
    let date: Date
    let data: TamaneenaWidgetData
    let extra: TamaneenaExtraData
}

struct TamaneenaExtraProvider: TimelineProvider {
    func placeholder(in context: Context) -> TamaneenaExtraEntry {
        TamaneenaExtraEntry(date: Date(), data: .load(), extra: .load())
    }

    func getSnapshot(in context: Context, completion: @escaping (TamaneenaExtraEntry) -> Void) {
        completion(TamaneenaExtraEntry(date: Date(), data: .load(), extra: .load()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TamaneenaExtraEntry>) -> Void) {
        let entry = TamaneenaExtraEntry(date: Date(), data: .load(), extra: .load())
        // تحديث كل نصف ساعة: المحتوى هنا يوميّ أو موضعي، ولا شيء منه يتغيّر
        // بالدقيقة كما يتغيّر عدّاد الصلاة القادمة.
        let next = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) ?? Date()
        completion(Timeline(entries: [entry], policy: .after(next)))
    }
}

// MARK: - لبنات العرض

/// خلفية الويدجت: نفس تدرّج أندرويد وحدّه الذهبي، فتبدو الهوية واحدة على
/// المنصّتين مهما اختلفت خلفية المستخدم.
private struct TamaneenaSurface<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(14)
            .background(
                LinearGradient(
                    colors: [
                        Color(hex: "#2B2114"),
                        Color(hex: "#20190F"),
                        Color(hex: "#15110B"),
                    ],
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading
                )
            )
            .environment(\.layoutDirection, .rightToLeft)
    }
}

private struct StatWidgetView: View {
    let title: String
    let primary: String
    let caption: String
    let footer: String

    var body: some View {
        TamaneenaSurface {
            VStack(alignment: .trailing, spacing: 4) {
                Text(title)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#D4B873"))
                Text(primary)
                    .font(.system(size: 19, weight: .heavy))
                    .foregroundColor(Color(hex: "#FFF7E1"))
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                Text(caption)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(Color(hex: "#D4B873"))
                    .lineLimit(2)
                Spacer(minLength: 0)
                Text(footer)
                    .font(.system(size: 9, weight: .regular))
                    .foregroundColor(Color(hex: "#9C8149"))
            }
        }
    }
}

// MARK: - المسبحة

/// المسبحة على iOS.
///
/// فرقٌ جوهري عن أندرويد: `AppIntent` وحده يسمح بالضغط داخل الويدجت، وهو
/// iOS 17 فما فوق. وقبلها يبقى الويدجت عرضًا للعدّاد يفتح التطبيق باللمس —
/// ولا يُدّعى غير ذلك.
struct TasbihWidgetView: View {
    let entry: TamaneenaExtraEntry

    private var filledBeads: Int {
        entry.extra.tasbihCount == 0 ? 0 : ((entry.extra.tasbihCount - 1) % 10) + 1
    }

    var body: some View {
        TamaneenaSurface {
            VStack(alignment: .trailing, spacing: 8) {
                Text(entry.extra.tasbihTitle)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#D4B873"))

                HStack(spacing: 10) {
                    Text("\(entry.extra.tasbihCount)")
                        .font(.system(size: 22, weight: .heavy))
                        .foregroundColor(Color(hex: "#FFF7E1"))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(
                            Capsule().fill(Color(hex: "#2E2415"))
                        )
                        .overlay(
                            Capsule().stroke(Color(hex: "#C9A46A"), lineWidth: 1)
                        )

                    Text(entry.extra.tasbihText)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(hex: "#FFF7E1"))
                        .multilineTextAlignment(.trailing)
                        .lineLimit(2)
                }

                HStack(spacing: 5) {
                    ForEach(0..<10, id: \.self) { index in
                        Circle()
                            .fill(index < filledBeads ? Color(hex: "#C9A46A") : .clear)
                            .overlay(
                                Circle().stroke(
                                    index < filledBeads ? .clear : Color(hex: "#6B5836"),
                                    lineWidth: 1
                                )
                            )
                            .frame(width: 7, height: 7)
                    }
                }
                Spacer(minLength: 0)
            }
        }
    }
}

// MARK: - تتبّع الصلوات

struct TrackerWidgetView: View {
    let entry: TamaneenaExtraEntry

    private let names = ["الفجر", "الظهر", "العصر", "المغرب", "العشاء"]

    private var done: [Bool] {
        let flags = Array(entry.extra.trackerFlags)
        return (0..<5).map { index in
            index < flags.count && flags[index] == "1"
        }
    }

    var body: some View {
        TamaneenaSurface {
            VStack(alignment: .trailing, spacing: 10) {
                HStack {
                    Text("\(done.filter { $0 }.count) / 5")
                        .font(.system(size: 12, weight: .heavy))
                        .foregroundColor(Color(hex: "#FFF7E1"))
                    Spacer()
                    Text("صلوات اليوم")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(hex: "#D4B873"))
                }

                HStack(spacing: 0) {
                    ForEach(0..<5, id: \.self) { index in
                        VStack(spacing: 4) {
                            Circle()
                                .fill(done[index] ? Color(hex: "#C9A46A") : .clear)
                                .overlay(
                                    Circle().stroke(
                                        done[index] ? .clear : Color(hex: "#6B5836"),
                                        lineWidth: 1
                                    )
                                )
                                .frame(width: 12, height: 12)
                            Text(names[index])
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundColor(Color(hex: "#9C8149"))
                        }
                        .frame(maxWidth: .infinity)
                    }
                }

                Spacer(minLength: 0)
                Text(entry.extra.trackerCaption)
                    .font(.system(size: 9))
                    .foregroundColor(Color(hex: "#9C8149"))
                    .lineLimit(1)
            }
        }
    }
}

// MARK: - تعريفات الويدجتات (غير مسجّلة في الحزمة)

struct TamaneenaTasbihWidget: Widget {
    let kind = "TamaneenaTasbihWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TamaneenaExtraProvider()) { entry in
            TasbihWidgetView(entry: entry)
                .widgetURL(URL(string: "tamaneena://widgets/tasbih"))
        }
        .configurationDisplayName("طمأنينة - المسبحة")
        .description("عدّاد التسبيح على الشاشة الرئيسية.")
        .supportedFamilies([.systemMedium])
    }
}

struct TamaneenaTrackerWidget: Widget {
    let kind = "TamaneenaTrackerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TamaneenaExtraProvider()) { entry in
            TrackerWidgetView(entry: entry)
                .widgetURL(URL(string: "tamaneena://widgets/tracker"))
        }
        .configurationDisplayName("طمأنينة - صلوات اليوم")
        .description("متابعة الصلوات الخمس اليوم.")
        .supportedFamilies([.systemMedium])
    }
}

struct TamaneenaQiblaWidget: Widget {
    let kind = "TamaneenaQiblaWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TamaneenaExtraProvider()) { entry in
            StatWidgetView(
                title: entry.extra.qiblaTitle,
                primary: entry.extra.qiblaDirection,
                caption: entry.extra.qiblaDistance,
                footer: entry.data.prayerCity
            )
            .widgetURL(URL(string: "tamaneena://widgets/qibla"))
        }
        .configurationDisplayName("طمأنينة - القبلة")
        .description("جهة القبلة والمسافة إلى مكّة.")
        .supportedFamilies([.systemSmall])
    }
}

struct TamaneenaHijriWidget: Widget {
    let kind = "TamaneenaHijriWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TamaneenaExtraProvider()) { entry in
            StatWidgetView(
                title: entry.extra.hijriTitle,
                primary: entry.extra.hijriDate,
                caption: entry.extra.hijriGregorian,
                footer: entry.extra.hijriWeekday
            )
            .widgetURL(URL(string: "tamaneena://widgets/hijri"))
        }
        .configurationDisplayName("طمأنينة - التاريخ الهجري")
        .description("اليوم الهجري ومقابله الميلادي.")
        .supportedFamilies([.systemSmall])
    }
}

struct TamaneenaReadingWidget: Widget {
    let kind = "TamaneenaReadingWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TamaneenaExtraProvider()) { entry in
            StatWidgetView(
                title: entry.extra.readingTitle,
                primary: entry.extra.readingSurah,
                caption: entry.extra.readingPosition,
                footer: entry.data.updatedAt
            )
            .widgetURL(URL(string: "tamaneena://widgets/reading"))
        }
        .configurationDisplayName("طمأنينة - متابعة القراءة")
        .description("آخر سورة وصفحة وقفت عندها.")
        .supportedFamilies([.systemSmall])
    }
}

/// حزمة معطّلة عمدًا.
///
/// لا تحمل `@main`، فلا يراها النظام. تُبقي التصاميم مجموعةً في مكان واحد
/// ليُنسخ محتواها إلى الحزمة الحقيقية عند التفعيل.
struct TamaneenaDesignedWidgetsPreviewBundle: WidgetBundle {
    var body: some Widget {
        TamaneenaTasbihWidget()
        TamaneenaTrackerWidget()
        TamaneenaQiblaWidget()
        TamaneenaHijriWidget()
        TamaneenaReadingWidget()
    }
}
