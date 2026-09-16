import SwiftUI
import WidgetKit

/// «مواقيت اليوم»: الصلوات الستّ مع التاريخ الهجري والمدينة، والقادمة مميّزة.
struct PrayerTimesWidget: Widget {
    /// يطابق `HomeWidgetIds.iosPrayerTimes`.
    let kind = "tamaneena.widget.prayerTimes"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TamaneenaTimelineProvider()) { entry in
            PrayerTimesView(entry: entry)
        }
        .configurationDisplayName("مواقيت اليوم")
        .description("مواقيت الصلوات مع التاريخ الهجري والمدينة.")
        .supportedFamilies([.systemMedium])
    }
}

struct PrayerTimesView: View {
    let entry: TamaneenaEntry

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let palette = WidgetPalette.of(scheme)

        return Group {
            // اليوم المعروض هو يوم الصلاة القادمة: بعد العشاء يظهر جدول الغد.
            if let next = entry.payload?.nextPrayer(after: entry.date) {
                schedule(day: next.day, next: next.prayer, palette: palette)
            } else {
                EmptyStateText(payload: entry.payload, palette: palette)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
        }
        .widgetSurface(palette.surface)
        .widgetURL(WidgetLinks.prayerTimes)
        .environment(\.layoutDirection, .rightToLeft)
    }

    private func schedule(day: WidgetDay, next: WidgetPrayer, palette: WidgetPalette) -> some View {
        VStack(spacing: 6) {
            HStack(spacing: 8) {
                Text(entry.payload?.location ?? "")
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(palette.ink)
                    .lineLimit(1)
                Spacer(minLength: 0)
                Text("\(day.weekday) · \(day.hijri)")
                    .font(.caption2)
                    .foregroundColor(palette.inkSoft)
                    .lineLimit(1)
            }

            HStack(spacing: 3) {
                ForEach(day.prayers, id: \.key) { prayer in
                    let isNext = prayer.key == next.key && prayer.at == next.at
                    VStack(spacing: 2) {
                        Text(prayer.name)
                            .font(.caption2)
                            .foregroundColor(palette.inkSoft)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                        Text(prayer.time)
                            .font(.caption.weight(.bold))
                            .foregroundColor(palette.ink)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(isNext ? palette.accentTint : Color.clear)
                    )
                }
            }
            .frame(maxHeight: .infinity)

            HStack(spacing: 4) {
                Text("\(next.name) بعد")
                    .font(.caption)
                    .foregroundColor(palette.inkSoft)
                Text(next.date, style: .timer)
                    .font(.caption.weight(.bold))
                    .monospacedDigit()
                    .foregroundColor(palette.accent)
            }
        }
    }
}
