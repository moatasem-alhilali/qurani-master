import SwiftUI
import WidgetKit

/// «آية اليوم»: آية قصيرة ثابتة طوال يوم المدينة، تتبدّل عند منتصف الليل.
struct DailyAyahWidget: Widget {
    /// يطابق `HomeWidgetIds.iosDailyAyah`.
    let kind = "tamaneena.widget.dailyAyah"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TamaneenaTimelineProvider()) { entry in
            DailyAyahView(entry: entry)
        }
        .configurationDisplayName("آية اليوم")
        .description("آية قصيرة تتجدّد كل يوم.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct DailyAyahView: View {
    let entry: TamaneenaEntry

    @Environment(\.widgetFamily) private var family
    @Environment(\.colorScheme) private var scheme

    private static let fallback = WidgetVerse(
        date: "",
        text: "﴿أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ﴾",
        source: "سورة الرعد · ٢٨"
    )

    var body: some View {
        let palette = WidgetPalette.of(scheme)
        let verse = entry.payload?.verse(for: entry.date) ?? Self.fallback

        return VStack(alignment: .leading, spacing: 6) {
            // الآية عربية دائمًا فيبقى الاتّجاه من اليمين؛ العنوان وحده بلغة التطبيق.
            Text(entry.payload?.label("dailyAyah", "آية اليوم") ?? "آية اليوم")
                .font(.caption.weight(.bold))
                .foregroundColor(palette.accent)

            Text(verse.text)
                .font(.system(size: family == .systemSmall ? 14 : 16, weight: .medium))
                .foregroundColor(palette.ink)
                .lineSpacing(3)
                .minimumScaleFactor(0.7)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

            Text(verse.source)
                .font(.caption2)
                .foregroundColor(palette.inkSoft)
                .lineLimit(1)
        }
        .widgetSurface(palette.surface)
        .widgetURL(WidgetLinks.dailyAyah)
        .environment(\.layoutDirection, .rightToLeft)
    }
}
