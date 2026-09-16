import SwiftUI
import WidgetKit

/// «الصلاة القادمة»: صغيرة للشاشة الرئيسية، وثلاثة أشكال لشاشة القفل (iOS 16+).
struct NextPrayerWidget: Widget {
    /// يطابق `HomeWidgetIds.iosNextPrayer`.
    let kind = "tamaneena.widget.nextPrayer"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TamaneenaTimelineProvider()) { entry in
            NextPrayerView(entry: entry)
        }
        .configurationDisplayName("الصلاة القادمة")
        .description("اسم الصلاة القادمة ووقتها مع عدّ تنازلي حيّ.")
        .supportedFamilies(Self.families)
    }

    private static var families: [WidgetFamily] {
        if #available(iOSApplicationExtension 16.0, *) {
            return [.systemSmall, .accessoryCircular, .accessoryRectangular, .accessoryInline]
        }
        return [.systemSmall]
    }
}

struct NextPrayerView: View {
    let entry: TamaneenaEntry

    @Environment(\.widgetFamily) private var family
    @Environment(\.colorScheme) private var scheme

    private var next: (day: WidgetDay, prayer: WidgetPrayer)? {
        entry.payload?.nextPrayer(after: entry.date)
    }

    var body: some View {
        content
            .widgetURL(WidgetLinks.nextPrayer)
            .environment(\.layoutDirection, .rightToLeft)
    }

    @ViewBuilder
    private var content: some View {
        if #available(iOSApplicationExtension 16.0, *) {
            switch family {
            case .accessoryCircular:
                circular.accessorySurface()
            case .accessoryRectangular:
                rectangular.accessorySurface()
            case .accessoryInline:
                inline.accessorySurface()
            default:
                small
            }
        } else {
            small
        }
    }

    // MARK: الشاشة الرئيسية

    private var small: some View {
        let palette = WidgetPalette.of(scheme)

        return VStack(alignment: .leading, spacing: 2) {
            Text("الصلاة القادمة")
                .font(.caption2)
                .foregroundColor(palette.inkSoft)

            if let next = next {
                Text(next.prayer.name)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(palette.accent)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                Text(next.prayer.time)
                    .font(.subheadline)
                    .foregroundColor(palette.ink)

                Text(next.prayer.date, style: .timer)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .multilineTextAlignment(.leading)
                    .foregroundColor(palette.ink)

                Spacer(minLength: 0)

                Text(entry.payload?.location ?? "")
                    .font(.caption2)
                    .foregroundColor(palette.inkSoft)
                    .lineLimit(1)
            } else {
                Spacer(minLength: 0)
                EmptyStateText(payload: entry.payload, palette: palette)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .widgetSurface(palette.surface)
    }

    // MARK: شاشة القفل

    @available(iOSApplicationExtension 16.0, *)
    private var circular: some View {
        ZStack {
            AccessoryWidgetBackground()
            if let next = next {
                VStack(spacing: 0) {
                    Text(next.prayer.name)
                        .font(.system(size: 11, weight: .semibold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    Text(next.prayer.date, style: .timer)
                        .font(.system(size: 10, weight: .medium))
                        .monospacedDigit()
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
                }
                .padding(4)
            } else {
                Image(systemName: "moon.stars")
            }
        }
    }

    @available(iOSApplicationExtension 16.0, *)
    private var rectangular: some View {
        VStack(alignment: .leading, spacing: 1) {
            if let next = next {
                HStack(spacing: 4) {
                    Text(next.prayer.name)
                        .font(.headline)
                        .widgetAccentable()
                    Text(next.prayer.time)
                        .font(.caption)
                }
                Text(next.prayer.date, style: .timer)
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .monospacedDigit()
                    .multilineTextAlignment(.leading)
                Text(entry.payload?.location ?? "")
                    .font(.caption2)
                    .lineLimit(1)
            } else {
                Text("افتح طمأنينة")
                    .font(.headline)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @available(iOSApplicationExtension 16.0, *)
    private var inline: some View {
        if let next = next {
            return Text("\(next.prayer.name) \(next.prayer.time)")
        }
        return Text("طمأنينة")
    }
}

/// رسالة بلا بيانات: لم يُحدَّد موقع، أو انتهت الأيام المحسوبة.
struct EmptyStateText: View {
    let payload: WidgetPayload?
    let palette: WidgetPalette

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("افتح طمأنينة")
                .font(.headline)
                .foregroundColor(palette.accent)
            Text(payload?.location == nil ? "حدّد موقعك في التطبيق" : "لتحديث المواقيت")
                .font(.caption)
                .foregroundColor(palette.inkSoft)
        }
    }
}
