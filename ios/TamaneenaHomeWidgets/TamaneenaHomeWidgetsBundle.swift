import SwiftUI
import WidgetKit

/// نقطة دخول امتداد ودجات «طمأنينة».
///
/// البيانات يكتبها التطبيق في مجموعة `group.com.tamaanina.app.widgets`
/// (انظر `HomeWidgetSync` في Dart)، وكل ودجت تقرأها من `WidgetPayloadStore`.
@main
struct TamaneenaHomeWidgetsBundle: WidgetBundle {
    var body: some Widget {
        NextPrayerWidget()
        PrayerTimesWidget()
        DailyAyahWidget()
    }
}
