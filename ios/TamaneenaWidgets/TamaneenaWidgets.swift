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
    let prayerCity: String
    let prayerFajrTime: String
    let prayerSunriseTime: String
    let prayerDhuhrTime: String
    let prayerAsrTime: String
    let prayerMaghribTime: String
    let prayerIshaTime: String
    let prayerSchedule: [PrayerScheduleItem]
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
            prayerCity: defaults.string(forKey: "prayer_city") ?? "طمأنينة",
            prayerFajrTime: defaults.string(forKey: "prayer_fajr_time") ?? "--:--",
            prayerSunriseTime: defaults.string(forKey: "prayer_sunrise_time") ?? "--:--",
            prayerDhuhrTime: defaults.string(forKey: "prayer_dhuhr_time") ?? "--:--",
            prayerAsrTime: defaults.string(forKey: "prayer_asr_time") ?? "--:--",
            prayerMaghribTime: defaults.string(forKey: "prayer_maghrib_time") ?? "--:--",
            prayerIshaTime: defaults.string(forKey: "prayer_isha_time") ?? "--:--",
            prayerSchedule: PrayerScheduleItem.load(
                from: defaults.string(forKey: "prayer_schedule_json") ?? "[]"
            ),
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
            accentHex: defaults.string(forKey: "widget_accent_hex") ?? "#C9A46A",
            surfaceHex: defaults.string(forKey: "widget_surface_hex") ?? "#17130D",
            onSurfaceHex: defaults.string(forKey: "widget_on_surface_hex") ?? "#FFF7E1",
            mutedHex: defaults.string(forKey: "widget_muted_hex") ?? "#D4B873"
        )
    }

    func resolvedPrayer(for date: Date) -> TamaneenaWidgetData {
        guard let next = prayerSchedule
            .filter({ $0.isPrayer && $0.date > date })
            .sorted(by: { $0.date < $1.date })
            .first else {
            return self
        }

        return TamaneenaWidgetData(
            prayerLabel: prayerLabel,
            prayerName: next.name,
            prayerTime: next.time,
            prayerRemaining: Self.remainingText(until: next.date, from: date),
            prayerCity: prayerCity,
            prayerFajrTime: prayerFajrTime,
            prayerSunriseTime: prayerSunriseTime,
            prayerDhuhrTime: prayerDhuhrTime,
            prayerAsrTime: prayerAsrTime,
            prayerMaghribTime: prayerMaghribTime,
            prayerIshaTime: prayerIshaTime,
            prayerSchedule: prayerSchedule,
            dhikrTitle: dhikrTitle,
            dhikrText: dhikrText,
            dhikrSource: dhikrSource,
            ayahTitle: ayahTitle,
            ayahText: ayahText,
            ayahSource: ayahSource,
            wirdTitle: wirdTitle,
            wirdProgress: wirdProgress,
            wirdSummary: wirdSummary,
            updatedAt: updatedAt,
            accentHex: accentHex,
            surfaceHex: surfaceHex,
            onSurfaceHex: onSurfaceHex,
            mutedHex: mutedHex
        )
    }

    private static func remainingText(until target: Date, from date: Date) -> String {
        let totalMinutes = max(Int(target.timeIntervalSince(date) / 60), 0)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        return hours <= 0 ? "بعد \(minutes) د" : "بعد \(hours) س \(minutes) د"
    }
}

struct PrayerScheduleItem {
    let name: String
    let time: String
    let date: Date
    let isPrayer: Bool

    static func load(from raw: String) -> [PrayerScheduleItem] {
        guard
            let data = raw.data(using: .utf8),
            let objects = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
        else {
            return []
        }

        return objects.compactMap { object in
            guard
                let name = object["name"] as? String,
                let time = object["time"] as? String
            else {
                return nil
            }
            let epochMillis: Double
            if let doubleValue = object["epochMillis"] as? Double {
                epochMillis = doubleValue
            } else if let intValue = object["epochMillis"] as? Int {
                epochMillis = Double(intValue)
            } else {
                return nil
            }
            return PrayerScheduleItem(
                name: name,
                time: time,
                date: Date(timeIntervalSince1970: epochMillis / 1000),
                isPrayer: object["isPrayer"] as? Bool ?? true
            )
        }
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

private struct WidgetDecor: View {
    let data: TamaneenaWidgetData

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color(hex: data.accentHex).opacity(0.48), lineWidth: 1)
            VStack {
                HStack {
                    Text("۞")
                        .font(.system(size: 34, weight: .regular))
                        .foregroundColor(Color(hex: data.accentHex).opacity(0.16))
                    Spacer()
                }
                Spacer()
                Rectangle()
                    .fill(Color(hex: data.accentHex).opacity(0.36))
                    .frame(height: 1)
            }
            .padding(8)
        }
    }
}

private struct WidgetBrandMark: View {
    let data: TamaneenaWidgetData

    var body: some View {
        HStack(spacing: 4) {
            Text("طمأنينة")
                .font(.system(size: 8, weight: .bold))
            Text("۞")
                .font(.system(size: 10, weight: .bold))
        }
        .foregroundColor(Color(hex: data.mutedHex))
        .lineLimit(1)
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
        let now = Date()
        let baseData = TamaneenaWidgetData.load()
        let prayerDates = baseData.prayerSchedule
            .filter { $0.isPrayer && $0.date > now }
            .sorted { $0.date < $1.date }
            .prefix(8)
            .map(\.date)
        let entryDates = [now] + prayerDates.map { $0.addingTimeInterval(2) }
        let entries = entryDates.map { date in
            TamaneenaWidgetEntry(
                date: date,
                data: baseData.resolvedPrayer(for: date)
            )
        }
        let nextRefresh = entries.last?.date.addingTimeInterval(1800)
            ?? now.addingTimeInterval(1800)
        completion(Timeline(entries: entries, policy: .after(nextRefresh)))
    }
}

private struct PrayerWidgetView: View {
    let entry: TamaneenaWidgetEntry

    var body: some View {
        ZStack {
            Color(hex: entry.data.surfaceHex)
            WidgetDecor(data: entry.data)
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    WidgetBrandMark(data: entry.data)
                    Spacer(minLength: 2)
                    Text(entry.data.prayerLabel)
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(Color(hex: entry.data.mutedHex))
                }
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
            WidgetDecor(data: entry.data)
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    WidgetBrandMark(data: entry.data)
                    Spacer(minLength: 2)
                    Text(title)
                        .font(.caption2.weight(.bold))
                        .foregroundColor(Color(hex: entry.data.mutedHex))
                }
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
            WidgetDecor(data: entry.data)
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    WidgetBrandMark(data: entry.data)
                    Spacer(minLength: 2)
                    Text(entry.data.wirdTitle)
                        .font(.caption2.weight(.bold))
                        .foregroundColor(Color(hex: entry.data.mutedHex))
                }
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

private struct PrayerTimesWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: TamaneenaWidgetEntry

    private var isSmallFamily: Bool {
        family == .systemSmall
    }

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: isSmallFamily ? 3 : 5),
            count: isSmallFamily ? 2 : 3
        )
    }

    private var prayerItems: [(title: String, time: String)] {
        [
            ("الفجر", entry.data.prayerFajrTime),
            ("الشروق", entry.data.prayerSunriseTime),
            ("الظهر", entry.data.prayerDhuhrTime),
            ("العصر", entry.data.prayerAsrTime),
            ("المغرب", entry.data.prayerMaghribTime),
            ("العشاء", entry.data.prayerIshaTime),
        ]
    }

    var body: some View {
        ZStack {
            Color(hex: entry.data.surfaceHex)
            WidgetDecor(data: entry.data)
            VStack(alignment: .trailing, spacing: isSmallFamily ? 4 : 6) {
                HStack(spacing: 4) {
                    WidgetBrandMark(data: entry.data)
                    if !isSmallFamily {
                        Text(entry.data.prayerCity)
                            .font(.system(size: 7, weight: .medium))
                            .foregroundColor(Color(hex: entry.data.mutedHex).opacity(0.86))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                    Spacer(minLength: 2)
                    Text(entry.data.updatedAt)
                        .font(.system(size: isSmallFamily ? 6 : 7, weight: .medium))
                        .foregroundColor(Color(hex: entry.data.mutedHex).opacity(0.72))
                        .lineLimit(1)
                    Text("مواقيت الصلاة")
                        .font(.system(size: isSmallFamily ? 8 : 9, weight: .bold))
                        .foregroundColor(Color(hex: entry.data.mutedHex))
                        .lineLimit(1)
                }
                LazyVGrid(columns: columns, spacing: isSmallFamily ? 3 : 5) {
                    ForEach(Array(prayerItems.enumerated()), id: \.offset) { pair in
                        PrayerTimeCell(
                            title: pair.element.title,
                            time: pair.element.time,
                            entry: entry,
                            compact: isSmallFamily,
                            isHighlighted: pair.element.title == entry.data.prayerName
                        )
                    }
                }
            }
            .padding(isSmallFamily ? 8 : 10)
            .environment(\.layoutDirection, .rightToLeft)
        }
    }
}

private struct PrayerTimeCell: View {
    let title: String
    let time: String
    let entry: TamaneenaWidgetEntry
    let compact: Bool
    let isHighlighted: Bool

    var body: some View {
        VStack(spacing: compact ? 0 : 1) {
            Text(title)
                .font(.system(size: compact ? 7 : 8, weight: .semibold))
                .foregroundColor(Color(hex: entry.data.mutedHex).opacity(isHighlighted ? 1 : 0.9))
                .lineLimit(1)
            Text(time)
                .font(.system(size: compact ? 10 : 12, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: entry.data.onSurfaceHex))
                .lineLimit(1)
                .minimumScaleFactor(0.72)
        }
        .frame(maxWidth: .infinity, minHeight: compact ? 23 : 31)
        .padding(.horizontal, compact ? 2 : 4)
        .padding(.vertical, compact ? 2 : 3)
        .background(
            RoundedRectangle(cornerRadius: compact ? 7 : 9)
                .fill(Color(hex: entry.data.accentHex).opacity(isHighlighted ? 0.18 : 0.07))
        )
        .overlay(
            RoundedRectangle(cornerRadius: compact ? 7 : 9)
                .stroke(Color(hex: entry.data.accentHex).opacity(isHighlighted ? 0.34 : 0.14), lineWidth: 0.7)
        )
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

struct TamaneenaPrayerTimesWidget: Widget {
    let kind = "TamaneenaPrayerTimesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TamaneenaProvider()) { entry in
            PrayerTimesWidgetView(entry: entry)
                .widgetURL(URL(string: "tamaneena://widgets/prayer"))
        }
        .configurationDisplayName("طمأنينة - مواقيت الصلاة")
        .description("يعرض مواقيت الصلاة اليومية بتصميم مختصر.")
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
        TamaneenaPrayerTimesWidget()
        if #available(iOSApplicationExtension 16.0, *) {
            TamaneenaLockPrayerWidget()
            TamaneenaLockDhikrWidget()
            TamaneenaLockAyahWidget()
        }
    }
}
