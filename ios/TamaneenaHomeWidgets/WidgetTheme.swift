import SwiftUI
import WidgetKit

/// ألوان الودجات من لوحة AppSkin في التطبيق، بنسختين نهارية وليلية.
///
/// تتبع مظهر النظام مباشرةً عبر `colorScheme`، فلا تحتاج تحديثًا من التطبيق
/// حين يبدّل المستخدم الوضع الداكن.
struct WidgetPalette {
    let surface: Color
    let ink: Color
    let inkSoft: Color
    let accent: Color
    let accentTint: Color

    static func of(_ scheme: ColorScheme) -> WidgetPalette {
        scheme == .dark ? dark : light
    }

    static let light = WidgetPalette(
        surface: Color(hex: 0xFFFFFF),
        ink: Color(hex: 0x1A1A1A),
        inkSoft: Color(hex: 0x6F5636),
        accent: Color(hex: 0xB18C55),
        accentTint: Color(hex: 0xC3A46B).opacity(0.16)
    )

    static let dark = WidgetPalette(
        surface: Color(hex: 0x1E1811),
        ink: Color(hex: 0xFFF7E7),
        inkSoft: Color(hex: 0xCBB08B),
        accent: Color(hex: 0xD9BE8F),
        accentTint: Color(hex: 0xD9BE8F).opacity(0.2)
    )
}

extension Color {
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}

extension View {
    /// خلفية ودجات الشاشة الرئيسية.
    ///
    /// iOS 17 يشترط `containerBackground`، وبدونه تظهر الودجت برسالة «يرجى اعتماد
    /// containerBackground». وهو يضيف هوامش المحتوى بنفسه، فالحشو اليدوي لما قبله فقط.
    @ViewBuilder
    func widgetSurface(_ color: Color) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            containerBackground(for: .widget) { color }
        } else {
            padding(14)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(color)
        }
    }

    /// خلفية ودجات شاشة القفل: شفّافة، والنظام يلوّنها. iOS 17 يشترطها هنا أيضًا.
    @ViewBuilder
    func accessorySurface() -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            containerBackground(for: .widget) { Color.clear }
        } else {
            self
        }
    }
}
