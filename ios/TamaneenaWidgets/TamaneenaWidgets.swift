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
    let accentHex: String
    let surfaceHex: String
    let onSurfaceHex: String
    let mutedHex: String

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
            ayahTitle: defaults.string(forKey: "ayah_title") ?? "آية عشوائية",
            ayahText: defaults.string(forKey: "ayah_text") ?? "ألا بذكر الله تطمئن القلوب",
            ayahSource: defaults.string(forKey: "ayah_source") ?? "الرعد: 28",
            wirdTitle: defaults.string(forKey: "wird_title") ?? "ورد اليوم",
            wirdProgress: defaults.string(forKey: "wird_progress") ?? "0%",
            wirdSummary: defaults.string(forKey: "wird_summary") ?? "ابدأ وردك الآن",
            updatedAt: defaults.string(forKey: "widget_updated_at") ?? "طمأنينة",
            accentHex: defaults.string(forKey: "widget_accent_hex") ?? "#404C6E",
            surfaceHex: defaults.string(forKey: "widget_surface_hex") ?? "#2C2C2C",
            onSurfaceHex: defaults.string(forKey: "widget_on_surface_hex") ?? "#FFFFFF",
            mutedHex: defaults.string(forKey: "widget_muted_hex") ?? "#CDAD80"
        )
    }
}

extension Color {
    init(hex: String) {
        let clean = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: clean).scanHexInt64(&value)
        let red = Double((value >> 16) & 0xFF) / 255.0
        let green = Double((value >> 8) & 0xFF) / 255.0
        let blue = Double(value & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
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
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date().addingTimeInterval(900)
        completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
    }
}

private struct PrayerWidgetView: View {
    let entry: TamaneenaWidgetEntry

    var body: some View {
        ZStack {
            Color(hex: entry.data.surfaceHex)
            VStack(alignment: .trailing, spacing: 4) {
                Text(entry.data.prayerLabel)
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(Color(hex: entry.data.mutedHex))
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(entry.data.prayerTime)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: entry.data.onSurfaceHex))
                        .lineLimit(1)
                    Spacer(minLength: 2)
                    Text(entry.data.prayerName)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: entry.data.onSurfaceHex))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                Text(entry.data.prayerRemaining)
                    .font(.caption2.weight(.medium))
                    .foregroundColor(Color(hex: entry.data.mutedHex))
                    .lineLimit(1)
                Text(entry.data.updatedAt)
                    .font(.system(size: 8, weight: .medium))
                    .foregroundColor(Color(hex: entry.data.mutedHex).opacity(0.82))
            }
            .padding(10)
            .environment(\.layoutDirection, .rightToLeft)
        }
    }
}

private struct TextWidgetView: View {
    let title: String
    let bodyText: String
    let footer: String
    let entry: TamaneenaWidgetEntry

    var body: some View {
        ZStack {
            Color(hex: entry.data.surfaceHex)
            VStack(alignment: .trailing, spacing: 4) {
                Text(title)
                    .font(.caption2.weight(.bold))
                    .foregroundColor(Color(hex: entry.data.mutedHex))
                Spacer(minLength: 0)
                Text(bodyText)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: entry.data.onSurfaceHex))
                    .multilineTextAlignment(.trailing)
                    .lineLimit(4)
                    .minimumScaleFactor(0.68)
                Spacer(minLength: 0)
                Text(footer)
                    .font(.system(size: 8, weight: .medium))
                    .foregroundColor(Color(hex: entry.data.mutedHex))
                    .lineLimit(1)
            }
            .padding(10)
            .environment(\.layoutDirection, .rightToLeft)
        }
    }
}

private struct WirdWidgetView: View {
    let entry: TamaneenaWidgetEntry

    var body: some View {
        ZStack {
            Color(hex: entry.data.surfaceHex)
            VStack(alignment: .trailing, spacing: 4) {
                Text(entry.data.wirdTitle)
                    .font(.caption2.weight(.bold))
                    .foregroundColor(Color(hex: entry.data.mutedHex))
                Spacer(minLength: 0)
                Text(entry.data.wirdProgress)
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(hex: entry.data.onSurfaceHex))
                    .lineLimit(1)
                Text(entry.data.wirdSummary)
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(Color(hex: entry.data.mutedHex))
                    .multilineTextAlignment(.trailing)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Spacer(minLength: 0)
                Text(entry.data.updatedAt)
                    .font(.system(size: 8, weight: .medium))
                    .foregroundColor(Color(hex: entry.data.mutedHex).opacity(0.82))
            }
            .padding(10)
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

@available(iOSApplicationExtension 16.0, *)
private struct LockAyahWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: TamaneenaWidgetEntry

    var body: some View {
        switch family {
        case .accessoryCircular:
            Text("آية")
                .font(.caption.weight(.bold))
        case .accessoryInline:
            Text(entry.data.ayahText)
                .lineLimit(1)
        default:
            VStack(alignment: .trailing, spacing: 4) {
                Text(entry.data.ayahTitle)
                    .font(.caption2.weight(.semibold))
                Text(entry.data.ayahText)
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
        .supportedFamilies([.systemSmall])
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
                entry: entry
            )
            .widgetURL(URL(string: "tamaneena://widgets/dhikr"))
        }
        .configurationDisplayName("طمأنينة - ذكر عشوائي")
        .description("ذكر متجدد من أذكار طمأنينة.")
        .supportedFamilies([.systemSmall])
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
                entry: entry
            )
            .widgetURL(URL(string: "tamaneena://widgets/ayah"))
        }
        .configurationDisplayName("طمأنينة - آية عشوائية")
        .description("آية متجددة تظهر على الشاشة الرئيسية.")
        .supportedFamilies([.systemSmall])
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
        .supportedFamilies([.systemSmall])
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

@available(iOSApplicationExtension 16.0, *)
struct TamaneenaLockAyahWidget: Widget {
    let kind = "TamaneenaLockAyahWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TamaneenaProvider()) { entry in
            LockAyahWidgetView(entry: entry)
                .widgetURL(URL(string: "tamaneena://widgets/ayah"))
        }
        .configurationDisplayName("طمأنينة - آية القفل")
        .description("آية مختصرة على شاشة القفل.")
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
            TamaneenaLockAyahWidget()
        }
    }
}
