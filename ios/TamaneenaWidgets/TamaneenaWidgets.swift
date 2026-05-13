import SwiftUI
import WidgetKit

private let appGroupId = "group.com.tamaneena.tamaneena_app.widgets"

struct TamaneenaWidgetEntry: TimelineEntry {
    let date: Date
    let data: TamaneenaWidgetData
}

struct TamaneenaWidgetData {
    let prayerLabel: String
    let prayerName: String
    let prayerTime: String
    let prayerRemaining: String
    let dhikrTitle: String
    let dhikrText: String
    let dhikrSource: String
    let ayahTitle: String
    let ayahText: String
    let ayahSource: String
    let wirdTitle: String
    let wirdProgress: String
    let wirdSummary: String
    let updatedAt: String

    static func load() -> TamaneenaWidgetData {
        let defaults = UserDefaults(suiteName: appGroupId) ?? .standard
        return TamaneenaWidgetData(
            prayerLabel: defaults.string(forKey: "prayer_label") ?? "الصلاة القادمة",
            prayerName: defaults.string(forKey: "prayer_name") ?? "الفجر",
            prayerTime: defaults.string(forKey: "prayer_time") ?? "04:18 ص",
            prayerRemaining: defaults.string(forKey: "prayer_remaining") ?? "قريبا",
            dhikrTitle: defaults.string(forKey: "dhikr_title") ?? "ذكر اليوم",
            dhikrText: defaults.string(forKey: "dhikr_text") ?? "لا إله إلا الله وحده لا شريك له",
            dhikrSource: defaults.string(forKey: "dhikr_source") ?? "أذكار طمأنينة",
            ayahTitle: defaults.string(forKey: "ayah_title") ?? "آية اليوم",
            ayahText: defaults.string(forKey: "ayah_text") ?? "ألا بذكر الله تطمئن القلوب",
            ayahSource: defaults.string(forKey: "ayah_source") ?? "الرعد: 28",
            wirdTitle: defaults.string(forKey: "wird_title") ?? "ورد اليوم",
            wirdProgress: defaults.string(forKey: "wird_progress") ?? "0%",
            wirdSummary: defaults.string(forKey: "wird_summary") ?? "ابدأ وردك الآن",
            updatedAt: defaults.string(forKey: "widget_updated_at") ?? "طمأنينة"
        )
    }
}

struct TamaneenaProvider: TimelineProvider {
    func placeholder(in context: Context) -> TamaneenaWidgetEntry {
        TamaneenaWidgetEntry(date: Date(), data: TamaneenaWidgetData.load())
    }

    func getSnapshot(in context: Context, completion: @escaping (TamaneenaWidgetEntry) -> Void) {
        completion(TamaneenaWidgetEntry(date: Date(), data: TamaneenaWidgetData.load()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TamaneenaWidgetEntry>) -> Void) {
        let entry = TamaneenaWidgetEntry(date: Date(), data: TamaneenaWidgetData.load())
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) ?? Date().addingTimeInterval(1800)
        completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
    }
}

private struct PrayerWidgetView: View {
    let entry: TamaneenaWidgetEntry

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.10, green: 0.14, blue: 0.16), Color(red: 0.73, green: 0.60, blue: 0.36)]),
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            VStack(alignment: .trailing, spacing: 8) {
                Text(entry.data.prayerLabel)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white.opacity(0.78))
                Spacer(minLength: 2)
                Text(entry.data.prayerName)
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text(entry.data.prayerTime)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.96, green: 0.82, blue: 0.50))
                    .lineLimit(1)
                Spacer(minLength: 2)
                HStack {
                    Text(entry.data.updatedAt)
                    Spacer()
                    Text(entry.data.prayerRemaining)
                }
                .font(.caption2.weight(.medium))
                .foregroundColor(.white.opacity(0.78))
            }
            .padding(16)
            .environment(\.layoutDirection, .rightToLeft)
        }
    }
}

private struct TextWidgetView: View {
    let title: String
    let bodyText: String
    let footer: String
    let colors: [Color]

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: colors), startPoint: .topTrailing, endPoint: .bottomLeading)
            VStack(alignment: .trailing, spacing: 10) {
                Text(title)
                    .font(.caption.weight(.bold))
                    .foregroundColor(.white.opacity(0.78))
                Spacer(minLength: 0)
                Text(bodyText)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(5)
                    .minimumScaleFactor(0.72)
                Spacer(minLength: 0)
                Text(footer)
                    .font(.caption2.weight(.medium))
                    .foregroundColor(.white.opacity(0.75))
                    .lineLimit(1)
            }
            .padding(16)
            .environment(\.layoutDirection, .rightToLeft)
        }
    }
}

private struct WirdWidgetView: View {
    let entry: TamaneenaWidgetEntry

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.07, green: 0.18, blue: 0.17), Color(red: 0.34, green: 0.48, blue: 0.37)]),
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            VStack(alignment: .trailing, spacing: 10) {
                Text(entry.data.wirdTitle)
                    .font(.caption.weight(.bold))
                    .foregroundColor(.white.opacity(0.78))
                Spacer(minLength: 0)
                Text(entry.data.wirdProgress)
                    .font(.system(size: 38, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(red: 0.96, green: 0.82, blue: 0.50))
                    .lineLimit(1)
                Text(entry.data.wirdSummary)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(3)
                    .minimumScaleFactor(0.75)
                Spacer(minLength: 0)
                Text(entry.data.updatedAt)
                    .font(.caption2.weight(.medium))
                    .foregroundColor(.white.opacity(0.74))
            }
            .padding(16)
            .environment(\.layoutDirection, .rightToLeft)
        }
    }
}

@available(iOSApplicationExtension 16.0, *)
private struct LockPrayerWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: TamaneenaWidgetEntry

    var body: some View {
        switch family {
        case .accessoryCircular:
            VStack(spacing: 2) {
                Text(entry.data.prayerName)
                    .font(.caption2.weight(.bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                Text(entry.data.prayerTime)
                    .font(.caption2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            .environment(\.layoutDirection, .rightToLeft)
        case .accessoryInline:
            Text("\(entry.data.prayerName) \(entry.data.prayerTime)")
        default:
            VStack(alignment: .trailing, spacing: 4) {
                Text("الصلاة القادمة")
                    .font(.caption2.weight(.semibold))
                Text("\(entry.data.prayerName) - \(entry.data.prayerTime)")
                    .font(.headline.weight(.bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Text(entry.data.prayerRemaining)
                    .font(.caption2)
                    .lineLimit(1)
            }
            .environment(\.layoutDirection, .rightToLeft)
        }
    }
}

@available(iOSApplicationExtension 16.0, *)
private struct LockDhikrWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: TamaneenaWidgetEntry

    var body: some View {
        switch family {
        case .accessoryCircular:
            Text("ذكر")
                .font(.caption.weight(.bold))
        case .accessoryInline:
            Text(entry.data.dhikrText)
                .lineLimit(1)
        default:
            VStack(alignment: .trailing, spacing: 4) {
                Text(entry.data.dhikrTitle)
                    .font(.caption2.weight(.semibold))
                Text(entry.data.dhikrText)
                    .font(.headline.weight(.bold))
                    .multilineTextAlignment(.trailing)
                    .lineLimit(2)
                    .minimumScaleFactor(0.72)
            }
            .environment(\.layoutDirection, .rightToLeft)
        }
    }
}

struct TamaneenaPrayerWidget: Widget {
    let kind = "TamaneenaPrayerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TamaneenaProvider()) { entry in
            PrayerWidgetView(entry: entry)
                .widgetURL(URL(string: "tamaneena://widgets/prayer"))
        }
        .configurationDisplayName("طمأنينة - الصلاة القادمة")
        .description("يعرض الصلاة القادمة والوقت المتبقي.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct TamaneenaDhikrWidget: Widget {
    let kind = "TamaneenaDhikrWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TamaneenaProvider()) { entry in
            TextWidgetView(
                title: entry.data.dhikrTitle,
                bodyText: entry.data.dhikrText,
                footer: entry.data.dhikrSource,
                colors: [Color(red: 0.14, green: 0.14, blue: 0.16), Color(red: 0.58, green: 0.44, blue: 0.25)]
            )
            .widgetURL(URL(string: "tamaneena://widgets/dhikr"))
        }
        .configurationDisplayName("طمأنينة - ذكر عشوائي")
        .description("ذكر متجدد من أذكار طمأنينة.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct TamaneenaAyahWidget: Widget {
    let kind = "TamaneenaAyahWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TamaneenaProvider()) { entry in
            TextWidgetView(
                title: entry.data.ayahTitle,
                bodyText: entry.data.ayahText,
                footer: entry.data.ayahSource,
                colors: [Color(red: 0.11, green: 0.15, blue: 0.18), Color(red: 0.24, green: 0.42, blue: 0.48)]
            )
            .widgetURL(URL(string: "tamaneena://widgets/ayah"))
        }
        .configurationDisplayName("طمأنينة - آية اليوم")
        .description("آية مختارة تظهر على الشاشة الرئيسية.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct TamaneenaWirdWidget: Widget {
    let kind = "TamaneenaWirdWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TamaneenaProvider()) { entry in
            WirdWidgetView(entry: entry)
                .widgetURL(URL(string: "tamaneena://widgets/wird"))
        }
        .configurationDisplayName("طمأنينة - ورد اليوم")
        .description("متابعة لطيفة لورد اليوم.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@available(iOSApplicationExtension 16.0, *)
struct TamaneenaLockPrayerWidget: Widget {
    let kind = "TamaneenaLockPrayerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TamaneenaProvider()) { entry in
            LockPrayerWidgetView(entry: entry)
                .widgetURL(URL(string: "tamaneena://widgets/prayer"))
        }
        .configurationDisplayName("طمأنينة - صلاة القفل")
        .description("الصلاة القادمة على شاشة القفل.")
        .supportedFamilies([.accessoryRectangular, .accessoryInline, .accessoryCircular])
    }
}

@available(iOSApplicationExtension 16.0, *)
struct TamaneenaLockDhikrWidget: Widget {
    let kind = "TamaneenaLockDhikrWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TamaneenaProvider()) { entry in
            LockDhikrWidgetView(entry: entry)
                .widgetURL(URL(string: "tamaneena://widgets/dhikr"))
        }
        .configurationDisplayName("طمأنينة - ذكر القفل")
        .description("ذكر مختصر على شاشة القفل.")
        .supportedFamilies([.accessoryRectangular, .accessoryInline, .accessoryCircular])
    }
}

@main
struct TamaneenaWidgets: WidgetBundle {
    var body: some Widget {
        TamaneenaPrayerWidget()
        TamaneenaDhikrWidget()
        TamaneenaAyahWidget()
        TamaneenaWirdWidget()
        if #available(iOSApplicationExtension 16.0, *) {
            TamaneenaLockPrayerWidget()
            TamaneenaLockDhikrWidget()
        }
    }
}
