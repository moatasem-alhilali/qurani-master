// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class L10nTr extends L10n {
  L10nTr([String locale = 'tr']) : super(locale);

  @override
  String get floatingAdhkarTitle => 'Yüzen Zikirler';

  @override
  String get floatingAdhkarSourceBuiltIn => 'Varsayılan';

  @override
  String get floatingAdhkarSourceCustom => 'Özel';

  @override
  String get floatingAdhkarSourceMyAdhkar => 'Zikirlerim';

  @override
  String get floatingAdhkarSourceAppLibrary => 'Uygulama kütüphanesi';

  @override
  String get floatingAdhkarDefaultDhikrTitle => 'Varsayılan zikir';

  @override
  String get floatingAdhkarRandomDhikrTitle => 'Rastgele zikir';

  @override
  String get floatingAdhkarIosNotificationSubtitle => 'Rastgele zikirler';

  @override
  String get floatingAdhkarOverlayServiceTitle => 'Yüzen rastgele zikirler';

  @override
  String get floatingAdhkarOverlayServiceContent =>
      'Yüzen zikir hizmeti arka planda çalışıyor';

  @override
  String get floatingAdhkarErrorUnsupportedPlatform =>
      'Bu özellik bu platformda kullanılamaz.';

  @override
  String get floatingAdhkarErrorIosNotificationsToEnable =>
      'iPhone\'da zikir hatırlatıcılarını açmak için bildirimlere izin vermelisin.';

  @override
  String get floatingAdhkarErrorOverlayPermissionFirst =>
      'Önce diğer uygulamaların üzerinde gösterme izni verilmeli.';

  @override
  String get floatingAdhkarErrorNoSource =>
      'Yüzen zikirler için en az bir kaynağı etkinleştir.';

  @override
  String get floatingAdhkarErrorIosNotificationsRequired =>
      'iPhone hatırlatıcıları için bildirim izni gerekli.';

  @override
  String get floatingAdhkarErrorOverlayPermissionRequired =>
      'Yüzen pencere için izin gerekli.';

  @override
  String get floatingAdhkarErrorTitleAndTextRequired =>
      'Varsayılan zikri güncellemek için başlık ve metin gerekli.';

  @override
  String get floatingAdhkarErrorNotificationsDenied =>
      'Bildirim izni verilmedi.';

  @override
  String get floatingAdhkarErrorOverlayDenied =>
      'Diğer uygulamaların üzerinde gösterme izni verilmedi.';

  @override
  String get floatingAdhkarErrorEnableBeforePreview =>
      'Önce özelliği aç, ardından canlı önizlemeyi kullan.';

  @override
  String get floatingAdhkarErrorPreviewNotificationsRequired =>
      'Şimdi zikir göstermek için bildirim izni gerekli.';

  @override
  String get floatingAdhkarErrorPreviewOverlayRequired =>
      'Yüzen zikri göstermek için izin gerekli.';

  @override
  String get floatingAdhkarStatusUnsupported => 'Desteklenmiyor';

  @override
  String get floatingAdhkarStatusPermissionRequired => 'İzin gerekli';

  @override
  String get floatingAdhkarStatusMisconfigured => 'Kurulum gerekli';

  @override
  String get floatingAdhkarStatusActive => 'Çalışıyor';

  @override
  String get floatingAdhkarStatusInactive => 'Durduruldu';

  @override
  String get floatingAdhkarManageTitle => 'Zikirleri yönet';

  @override
  String get floatingAdhkarManageSubtitle =>
      'Varsayılanlardan görünecekleri seç, kendi zikirlerini ekle';

  @override
  String get floatingAdhkarAddPrivateTooltip => 'Özel zikir ekle';

  @override
  String get floatingAdhkarAddCustomTitle => 'Özel zikir ekle';

  @override
  String get floatingAdhkarAddCustomSubtitle =>
      'Etkinleştirildiğinde yüzen zikirler arasında yer alacak.';

  @override
  String get floatingAdhkarEditTitle => 'Zikri düzenle';

  @override
  String get floatingAdhkarEditSubtitle =>
      'Metni güncelle ve değişiklikleri hemen kaydet.';

  @override
  String floatingAdhkarEnabledOfTotal(int enabled, int total) {
    return '$enabled / $total';
  }

  @override
  String get floatingAdhkarEmptyBuiltInTitle => 'Varsayılan zikir yok';

  @override
  String get floatingAdhkarEmptyBuiltInMessage =>
      'Uygulamadaki varsayılan zikir kütüphanesi bulunamadı.';

  @override
  String get floatingAdhkarEmptyCustomTitle => 'Henüz özel zikir yok';

  @override
  String get floatingAdhkarEmptyCustomMessage =>
      'Rastgele yüzen zikirlere katılması için kendi zikrini veya duanı ekle.';

  @override
  String get floatingAdhkarAddNewDhikr => 'Yeni zikir ekle';

  @override
  String get floatingAdhkarItemOptions => 'Zikir seçenekleri';

  @override
  String get floatingAdhkarTabBuiltIn => 'Varsayılan zikirler';

  @override
  String get floatingAdhkarTabCustom => 'Özel zikirler';

  @override
  String get floatingAdhkarPreviewHeader => 'Zikir önizlemesi';

  @override
  String get floatingAdhkarAdvancedTitle => 'Gelişmiş ayarlar';

  @override
  String get floatingAdhkarAdvancedSubtitle =>
      'Görünme sıklığı, süre ve kaynaklar';

  @override
  String get floatingAdhkarFrequencyTitle => 'Görünme sıklığı';

  @override
  String get floatingAdhkarVisibleDurationTitle => 'Ekranda kalma süresi';

  @override
  String floatingAdhkarSecondsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saniye',
      one: '$count saniye',
    );
    return '$_temp0';
  }

  @override
  String get floatingAdhkarSourcesTitle => 'Zikir kaynakları';

  @override
  String get floatingAdhkarAllowNotifications => 'Bildirimlere izin ver';

  @override
  String get floatingAdhkarGrantPermission => 'Gerekli izni ver';

  @override
  String get floatingAdhkarPermissionHint =>
      'İzin olmadan zikir diğer uygulamaların üzerinde görünmez';

  @override
  String get floatingAdhkarSendNow => 'Şimdi zikir gönder';

  @override
  String get floatingAdhkarShowNow => 'Şimdi zikir göster';

  @override
  String get floatingAdhkarPreviewReadyHint => 'Zikrin nasıl görüneceğini dene';

  @override
  String get floatingAdhkarPreviewDisabledHint => 'Önce hizmeti aç ve izni ver';

  @override
  String get floatingAdhkarIosReminders => 'iPhone hatırlatıcıları';

  @override
  String get floatingAdhkarFloatingService => 'Yüzen hizmet';

  @override
  String get floatingAdhkarUnsupportedPlatform =>
      'Bu platformda desteklenmiyor';

  @override
  String get floatingAdhkarStatBuiltIn => 'Varsayılan';

  @override
  String get floatingAdhkarStatCustom => 'Özel';

  @override
  String get floatingAdhkarSettingsTitleIos => 'Zikir hatırlatıcı ayarları';

  @override
  String get floatingAdhkarSettingsTitle => 'Yüzen zikir ayarları';

  @override
  String get floatingAdhkarReminderTiming => 'Hatırlatma zamanı';

  @override
  String get floatingAdhkarAppearanceTiming => 'Görünme zamanı';

  @override
  String get floatingAdhkarReminderFrequency => 'Hatırlatma sıklığı';

  @override
  String get floatingAdhkarAppearanceFrequency => 'Görünme sıklığı';

  @override
  String get floatingAdhkarBuiltInSourceSubtitle =>
      'Uygulamanın temel dahili kaynağı';

  @override
  String get floatingAdhkarCustomSourceSubtitle => 'Kendi eklediğin zikirler';

  @override
  String get floatingAdhkarMixSources => 'Kaynakları karıştır';

  @override
  String get floatingAdhkarMixSourcesOn => 'Tek bir birleşik listeden seçilir';

  @override
  String get floatingAdhkarMixSourcesOff =>
      'Varsayılan ve özel arasında sırayla';

  @override
  String get floatingAdhkarSaveNeedsSource =>
      'Kaydetmeden önce en az bir kaynağı etkinleştir.';

  @override
  String get floatingAdhkarMasterSwitch => 'Özelliği tamamen aç';

  @override
  String get floatingAdhkarMasterSwitchIosHint =>
      'iPhone\'da zikir bildirimleri planlanır';

  @override
  String get floatingAdhkarMasterSwitchHint =>
      'Arka plan hizmeti zikirleri göstermeye başlar';

  @override
  String get floatingAdhkarSaveSettings => 'Ayarları kaydet';

  @override
  String floatingAdhkarEveryMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Her $count dakikada',
      one: 'Her $count dakikada',
    );
    return '$_temp0';
  }

  @override
  String get floatingAdhkarSourcesMixed => 'Varsayılan ve özel karışık';

  @override
  String get floatingAdhkarSourcesAlternating => 'Varsayılan ve özel sırayla';

  @override
  String get floatingAdhkarSourcesBuiltInOnly => 'Yalnızca varsayılan zikirler';

  @override
  String get floatingAdhkarSourcesCustomOnly => 'Yalnızca kullanıcı zikirleri';

  @override
  String get floatingAdhkarSourcesNone => 'Etkin kaynak yok';

  @override
  String get sabihTitle => 'Tesbih';

  @override
  String get sabihBeadWalnut => 'Ceviz';

  @override
  String get sabihBeadOak => 'Meşe';

  @override
  String get sabihBeadEmerald => 'Zümrüt';

  @override
  String get sabihBeadOnyx => 'Siyah oniks';

  @override
  String get sabihBeadAmber => 'Kehribar';

  @override
  String get sabihBeadMahogany => 'Maun';

  @override
  String get sabihBeadSage => 'Zeytin yeşili';

  @override
  String get sabihBeadGarnet => 'Kırmızı akik';

  @override
  String get sabihErrorRefreshList => 'Zikir listesi güncellenemedi.';

  @override
  String get sabihErrorLoad => 'Zikirler yüklenemedi.';

  @override
  String get sabihErrorRecord => 'Zikir kaydedilemedi.';

  @override
  String get sabihErrorResetToday => 'Bugünün sayacı sıfırlanamadı.';

  @override
  String get sabihAnalyticsTitle => 'İstatistikler';

  @override
  String get sabihTabOverview => 'Genel bakış';

  @override
  String get sabihTabDetails => 'Zikir ayrıntıları';

  @override
  String get sabihDhikrSettingsTooltip => 'Zikir ayarları';

  @override
  String get sabihAddCustomDhikr => 'Özel zikir ekle';

  @override
  String get sabihEmptyMessage => 'Zikir bulunamadı';

  @override
  String get sabihAddFirst => 'İlk zikrini ekle';

  @override
  String get sabihSaveChanges => 'Değişiklikleri kaydet';

  @override
  String get sabihAddDhikr => 'Zikri ekle';

  @override
  String get sabihSaveFailed => 'Zikir kaydedilemedi.';

  @override
  String get sabihUpdatedSuccess => 'Zikir güncellendi.';

  @override
  String get sabihAddedSuccess => 'Zikir eklendi.';

  @override
  String get sabihEditDhikr => 'Zikri düzenle';

  @override
  String get sabihFieldText => 'Zikir metni';

  @override
  String sabihExampleHint(String example) {
    return 'Örnek: $example';
  }

  @override
  String get sabihTextRequired => 'Lütfen zikir metnini gir';

  @override
  String get sabihTextTooShort => 'Zikir metni çok kısa';

  @override
  String get sabihFieldVirtue => 'Fazileti veya kısa açıklama (isteğe bağlı)';

  @override
  String get sabihPeriodToday => 'Bugün';

  @override
  String get sabihPeriodWeek => 'Hafta';

  @override
  String get sabihPeriodMonth => 'Ay';

  @override
  String get sabihPeriodYear => 'Yıl';

  @override
  String get sabihPeriodAll => 'Tümü';

  @override
  String get sabihThisWeek => 'Bu hafta';

  @override
  String get sabihThisMonth => 'Bu ay';

  @override
  String get sabihAllTime => 'Tüm zamanlar';

  @override
  String get sabihMostUsed => 'En çok çekilen zikirler';

  @override
  String get sabihTotalCount => 'Toplam zikir sayısı';

  @override
  String get sabihNoDataYet => 'Henüz veri yok';

  @override
  String get sabihResetTodayCounter => 'Bugünün sayacını sıfırla';

  @override
  String get sabihEditThisDhikr => 'Bu zikri düzenle';

  @override
  String get sabihDeleteThisDhikr => 'Bu zikri sil';

  @override
  String get sabihCustomBadge => 'Özel';

  @override
  String get sabihNoCustomDhikr => 'Özel zikir yok';

  @override
  String get sabihSummaryTitle => 'Zikir özeti';

  @override
  String get sabihTodayNotStarted => 'Bugün henüz zikre başlamadın';

  @override
  String sabihTodayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bugün $count kez zikrettin',
      one: 'Bugün $count kez zikrettin',
    );
    return '$_temp0';
  }

  @override
  String get sabihCounterSemantics => 'Tesbih';

  @override
  String sabihTargetReached(int target) {
    return 'Hedefe ulaşıldı: $target';
  }

  @override
  String sabihTargetOf(int target) {
    return '/ $target';
  }

  @override
  String sabihTargetLabel(int target) {
    return 'Hedef: $target';
  }

  @override
  String get sabihTapAnywhere => 'Tesbih için herhangi bir yere dokun';

  @override
  String get sabihCountSemantics => 'Tesbih sayısı';

  @override
  String get sabihInvalidNumber => 'Sıfırdan büyük geçerli bir sayı gir';

  @override
  String get sabihSettingsTitle => 'Tesbih ayarları';

  @override
  String get sabihTargetSection => 'Zikir hedefi';

  @override
  String get sabihTargetAutoHint =>
      'Değiştirmezsen otomatik ilerler: 33, sonra 99, sonra her 100.';

  @override
  String get sabihFontSize => 'Yazı boyutu';

  @override
  String get sabihFontSizeGlyph => 'A';

  @override
  String sabihPercent(int value) {
    return '%$value';
  }

  @override
  String get sabihVibration => 'Titreşim';

  @override
  String get sabihVibrationTitle => 'Her tesbihte hafif titreşim';

  @override
  String get sabihVibrationSubtitle =>
      'Hedefe ulaşınca daha belirgin bir titreşim';

  @override
  String get sabihBeadDesign => 'Tesbih tasarımı';

  @override
  String get sabihResetTodayCounterAction => 'Bugünün sayacını sıfırla';

  @override
  String get anotherScreenGroupDaily => 'Günlük virdin';

  @override
  String get anotherScreenGroupKnowledge => 'İlim ve tilavet';

  @override
  String get anotherScreenGroupTools => 'Zikirler ve araçlar';

  @override
  String get anotherScreenDailyWird => 'Günlük Vird';

  @override
  String get anotherScreenDailyWirdSubtitle =>
      'Günlük zikir ve tilavetin için düzenli bir vird';

  @override
  String get anotherScreenKhatmaPlans => 'Hatim planları';

  @override
  String get anotherScreenKhatmaPlansSubtitle =>
      'Hatmi sana uygun şekilde tamamlaman için düzenli planlar';

  @override
  String get anotherScreenTasbihSubtitle =>
      'Rahat ve net bir sayaçla kolay tesbih';

  @override
  String get anotherScreenFloatingAdhkarSubtitle =>
      'Diğer uygulamaların üzerinde görünen kısa zikirler';

  @override
  String get anotherScreenFajrCompanion => 'Sabah Arkadaşı';

  @override
  String get anotherScreenFajrCompanionSubtitle =>
      'Davet hatırlatıcıları ve planlı aramalar';

  @override
  String get anotherScreenSurahEncyclopedia => 'Sure Ansiklopedisi';

  @override
  String get anotherScreenSurahEncyclopediaSubtitle =>
      'Sureleri, faziletlerini ve konularını keşfet';

  @override
  String get anotherScreenNawawi40 => 'Kırk Hadis (Nevevî)';

  @override
  String get anotherScreenNawawi40Subtitle =>
      'Dinin temel konularını kapsayan hadisler';

  @override
  String get anotherScreenNamesOfAllah => 'Esmaü\'l-Hüsna';

  @override
  String get anotherScreenNamesOfAllahSubtitle =>
      'Allah\'ın isimleri ve mübarek anlamları üzerine tefekkür';

  @override
  String get anotherScreenRadio => 'Radyo';

  @override
  String get anotherScreenRadioSubtitle =>
      'Kesintisiz canlı Kur\'an ve İslami radyolar';

  @override
  String get anotherScreenHisnMuslim => 'Hısnü\'l-Müslim';

  @override
  String get anotherScreenHisnMuslimSubtitle =>
      'Hal ve durumlara göre düzenlenmiş kapsamlı zikirler';

  @override
  String get anotherScreenMyDuas => 'Dualarım';

  @override
  String get anotherScreenMyDuasSubtitle =>
      'Kişisel dualarını tek bir yerde sakla';

  @override
  String get anotherScreenTraveler => 'Yolcu';

  @override
  String get anotherScreenTravelerSubtitle =>
      'Yolculuk zikirleri, yolculuk vakitleri ve faydalı yerler';

  @override
  String get anotherScreenHomeWidgets => 'Ana ekran widget\'ları';

  @override
  String get anotherScreenHomeWidgetsSubtitle =>
      'Sıradaki namaz, bugünün vakitleri ve günün ayeti';

  @override
  String get anotherScreenFootnotes => 'Dipnotlar';

  @override
  String anotherScreenChapterNumber(int number) {
    return 'Bölüm $number';
  }

  @override
  String anotherScreenTextsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count metin',
      one: '$count metin',
    );
    return '$_temp0';
  }

  @override
  String anotherScreenFootnotesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dipnot',
      one: '$count dipnot',
    );
    return '$_temp0';
  }

  @override
  String get anotherScreenDhikrText => 'Zikir metni';

  @override
  String get anotherScreenHisnSearchHint => 'Hısnü\'l-Müslim\'de ara';

  @override
  String get anotherScreenNoResults => 'Sonuç yok';

  @override
  String get anotherScreenHisnNoResultsMessage =>
      'Hısnü\'l-Müslim\'de aramanla eşleşen bir bölüm bulunamadı.';

  @override
  String get anotherScreenShowAllAdhkar => 'Tüm zikirleri göster';

  @override
  String get anotherScreenSurahSearchHint => 'Sure ara';

  @override
  String anotherScreenSurahTitle(String name) {
    return '$name Suresi';
  }

  @override
  String anotherScreenLabelHeading(String label) {
    return '$label:';
  }

  @override
  String anotherScreenLabelValue(String label, String value) {
    return '$label: $value';
  }

  @override
  String get anotherScreenSurahOrder => 'Sıra';

  @override
  String get anotherScreenSurahNumber => 'Sure numarası';

  @override
  String get anotherScreenAyahCount => 'Ayet sayısı';

  @override
  String get anotherScreenSurahNameMeaning => 'Sure adının anlamı';

  @override
  String get anotherScreenSurahNamingReason => 'İsimlendirilme sebebi';

  @override
  String get anotherScreenSurahOtherNamesShort => 'Diğer isimleri';

  @override
  String get anotherScreenSurahOtherNames => 'Surenin diğer isimleri';

  @override
  String get anotherScreenSurahPurpose => 'Genel amacı';

  @override
  String get anotherScreenSurahRevelationReason => 'Nüzul sebebi';

  @override
  String get anotherScreenSurahVirtues => 'Surenin faziletleri';

  @override
  String get anotherScreenSurahRelations => 'Surenin münasebetleri';

  @override
  String anotherScreenAyahsLabel(String count) {
    return '$count ayet';
  }

  @override
  String get anotherScreenNoMatchingResults => 'Eşleşen sonuç yok';

  @override
  String get anotherScreenShowAllSurahs => 'Tüm sureleri göster';

  @override
  String get quranPlanAnalysisStartFirst =>
      'İlerlemeni analiz etmek için ilk oturumuna başla.';

  @override
  String get quranPlanAnalysisFinished => 'Tebrikler! Planı tamamladın.';

  @override
  String get quranPlanAnalysisOnTrack =>
      'Doğru yoldasın, hatmi süreden önce bitirmen bekleniyor!';

  @override
  String get quranPlanAnalysisBehind =>
      'Biraz gecikebilirsin. Okuma temponu artırmayı dene.';

  @override
  String quranPlanReminderTitle(String title) {
    return 'Hatim planı: $title';
  }

  @override
  String quranPlanReminderBody(String title) {
    return '\"$title\" planındaki bugünkü oturumunu unutma!';
  }

  @override
  String get quranPlanAddTitle => 'Yeni hatim planı ekle';

  @override
  String get quranPlanDetailsHeader => 'Plan ayrıntıları';

  @override
  String get quranPlanTitleLabel => 'Plan başlığı';

  @override
  String get quranPlanTitleHint => 'Plan adı';

  @override
  String get quranPlanTitleRequired => 'Bir başlık gir';

  @override
  String get quranPlanFromJuz => 'Başlangıç cüzü';

  @override
  String get quranPlanToJuz => 'Bitiş cüzü';

  @override
  String get quranPlanChooseStart => 'Başlangıcı seç';

  @override
  String get quranPlanChooseEnd => 'Bitişi seç';

  @override
  String get quranPlanEndBeforeStart => 'Bitiş, başlangıçtan önce';

  @override
  String get quranPlanDaysLabel => 'Gün sayısı';

  @override
  String get quranPlanDaysHint => 'Örnek: 30';

  @override
  String get quranPlanDaysInvalid => 'Geçerli bir gün sayısı gir';

  @override
  String get quranPlanSave => 'Planı kaydet';

  @override
  String get quranPlanChoose => 'Seç';

  @override
  String quranPlanJuz(int number) {
    return '$number. cüz';
  }

  @override
  String get quranPlanDailyReminder => 'Günlük hatırlatıcı';

  @override
  String get quranPlanNotSet => 'Belirlenmedi';

  @override
  String get quranPlanListTitle => 'Hatim planları';

  @override
  String get quranPlanNewTooltip => 'Yeni plan';

  @override
  String get quranPlanSearchHint => 'Plan ara';

  @override
  String quranPlanJuzRange(int start, int end) {
    return '$start. cüzden $end. cüze';
  }

  @override
  String quranPlanDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün',
      one: '$count gün',
    );
    return '$_temp0';
  }

  @override
  String quranPlanLoadedSessions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oturum yüklendi',
      one: '$count oturum yüklendi',
    );
    return '$_temp0';
  }

  @override
  String quranPlanProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String get quranPlanDeleteConfirm => 'Plan silinsin mi?';

  @override
  String get quranPlanConfirm => 'Onayla';

  @override
  String get quranPlanDelete => 'Planı sil';

  @override
  String get quranPlanStagnationWarning =>
      'Dikkat: Birkaç gündür ara verdin. Bugün kısa bir oturum ritmi yeniden yakalamaya yeter.';

  @override
  String get quranPlanLoadFailed => 'Bu plan şu anda yüklenemedi.';

  @override
  String get quranPlanTodaySession => 'Bugünün oturumu';

  @override
  String get quranPlanAllSessionsDone =>
      'Bu planın tüm oturumlarını tamamladın, Allah razı olsun.';

  @override
  String get quranPlanRhythm => 'Plan ritmi';

  @override
  String get quranPlanPath => 'Hatim yolu';

  @override
  String get quranPlanNoSessions => 'Henüz gösterilecek oturum yok.';

  @override
  String get quranPlanCompleteConfirm => 'Oturum tamamlansın mı?';

  @override
  String quranPlanSessionNumber(int number) {
    return 'Oturum $number';
  }

  @override
  String get quranPlanSessionDone => 'Tamamlandı';

  @override
  String get quranPlanCurrentSession => 'Mevcut oturumun';

  @override
  String get quranPlanOpenMushafHint => 'Oturumun başında Mushaf\'ı aç';

  @override
  String get quranPlanSessionCompleted => 'Tamamlanan oturum';

  @override
  String get quranPlanCompleteSession => 'Oturumu bitir';

  @override
  String quranPlanSurahFallback(int number) {
    return 'Sure $number';
  }

  @override
  String quranPlanSessionRange(
      String fromSurah, int fromAyah, String toSurah, int toAyah) {
    return '$fromSurah, $fromAyah. ayet – $toSurah, $toAyah. ayet';
  }

  @override
  String quranPlanCompletedAt(String date) {
    return 'Tamamlandı · $date';
  }

  @override
  String get quranPlanExpectedFinish => 'Tahmini hatim günü';

  @override
  String get quranPlanAverageInterval => 'Oturumlar arası ortalama süre';

  @override
  String quranPlanAverageIntervalValue(String days) {
    return '$days gün';
  }

  @override
  String get quranPlanMostActiveDay => 'En aktif gün';

  @override
  String get quranPlanLeastActiveDay => 'En az aktif gün';

  @override
  String get quranPlanCompletionProbability => 'Planı tamamlama olasılığı';

  @override
  String quranPlanPercentValue(int percent) {
    return 'Yüzde $percent';
  }

  @override
  String get quranPlanStagnationDays => 'Ara verilen günler';

  @override
  String get cleanupRouteNotFound => 'Sayfa bulunamadı';

  @override
  String get cleanupNotificationSubtitle => 'Yeni bildirim';

  @override
  String get cleanupNotificationActionView => 'Görüntüle';

  @override
  String get cleanupNotificationActionDismiss => 'Kapat';

  @override
  String get cleanupDownloadActionFailed =>
      'İndirme işlemi tamamlanamadı. Tekrar dene.';

  @override
  String get cleanupDownloadStatusQueued => 'Sırada';

  @override
  String get cleanupDownloadStatusCanceled => 'İptal edildi';

  @override
  String get cleanupDownloadStatusUnknown => 'Bilinmiyor';

  @override
  String get cleanupRadioMediaArtist => 'Kur\'an-ı Kerim Radyosu';

  @override
  String get cleanupDhikrMeaningSubhanAllah =>
      'Allah her türlü noksanlıktan münezzehtir';

  @override
  String get cleanupDhikrMeaningAlhamdulillah => 'Hamd Allah\'a mahsustur';

  @override
  String get cleanupDhikrMeaningLaIlaha => 'Allah\'tan başka ilah yoktur';

  @override
  String get cleanupDhikrMeaningAllahuAkbar => 'Allah en büyüktür';

  @override
  String get cleanupDhikrMeaningLaHawla =>
      'Güç ve kuvvet ancak Allah\'ın yardımıyladır';

  @override
  String get cleanupDhikrMeaningAstaghfirullah =>
      'Allah\'tan bağışlanma dilerim';

  @override
  String get cleanupDhikrMeaningSubhanAllahWaBihamdihi =>
      'Allah\'ı hamdiyle tespih ederim, yüce Allah\'ı tespih ederim';

  @override
  String get appName => 'Tamaneena';

  @override
  String get commonContinue => 'Devam';

  @override
  String get commonSave => 'Kaydet';

  @override
  String get commonCancel => 'İptal';

  @override
  String get commonOk => 'Tamam';

  @override
  String get commonClose => 'Kapat';

  @override
  String get commonDone => 'Bitti';

  @override
  String get commonRetry => 'Tekrar dene';

  @override
  String get commonSearch => 'Ara';

  @override
  String get commonSettings => 'Ayarlar';

  @override
  String get commonLoading => 'Yükleniyor…';

  @override
  String get commonError => 'Bir hata oluştu';

  @override
  String get commonDelete => 'Sil';

  @override
  String get commonEdit => 'Düzenle';

  @override
  String get commonAdd => 'Ekle';

  @override
  String get commonShare => 'Paylaş';

  @override
  String get commonCopy => 'Kopyala';

  @override
  String get commonCopied => 'Kopyalandı';

  @override
  String get commonBack => 'Geri';

  @override
  String get commonYes => 'Evet';

  @override
  String get commonNo => 'Hayır';

  @override
  String get commonRefresh => 'Yenile';

  @override
  String get commonSeeAll => 'Tümünü gör';

  @override
  String get commonEnable => 'Etkinleştir';

  @override
  String get commonDisable => 'Kapat';

  @override
  String get commonLater => 'Daha sonra';

  @override
  String get prayerFajr => 'Sabah';

  @override
  String get prayerSunrise => 'Güneş';

  @override
  String get prayerDhuhr => 'Öğle';

  @override
  String get prayerAsr => 'İkindi';

  @override
  String get prayerMaghrib => 'Akşam';

  @override
  String get prayerIsha => 'Yatsı';

  @override
  String get prayerJumuah => 'Cuma';

  @override
  String get hijriMonth1 => 'Muharrem';

  @override
  String get hijriMonth2 => 'Safer';

  @override
  String get hijriMonth3 => 'Rebiülevvel';

  @override
  String get hijriMonth4 => 'Rebiülahir';

  @override
  String get hijriMonth5 => 'Cemaziyelevvel';

  @override
  String get hijriMonth6 => 'Cemaziyelahir';

  @override
  String get hijriMonth7 => 'Recep';

  @override
  String get hijriMonth8 => 'Şaban';

  @override
  String get hijriMonth9 => 'Ramazan';

  @override
  String get hijriMonth10 => 'Şevval';

  @override
  String get hijriMonth11 => 'Zilkade';

  @override
  String get hijriMonth12 => 'Zilhicce';

  @override
  String hijriDate(String day, String month, String year) {
    return '$day $month $year H';
  }

  @override
  String get youngMuslimTitle => 'Küçük Müslüman';

  @override
  String get youngMuslimQuizUnanswered => 'Cevaplanmadı';

  @override
  String get youngMuslimResumeReminderTitle =>
      'Küçük Müslüman\'da izlemeye devam et';

  @override
  String youngMuslimResumeReminderBody(String topic) {
    return '\"$topic\" hikâyesine dön ve yolculuğuna sakince devam et.';
  }

  @override
  String get youngMuslimAudienceKidsSafe => 'Çocuklar için güvenli';

  @override
  String get youngMuslimAudienceGeneral => 'Genel izleyici';

  @override
  String get youngMuslimStatSeries => 'Seri';

  @override
  String get youngMuslimStatEpisode => 'Bölüm';

  @override
  String get youngMuslimChooseSeries => 'Seri seç';

  @override
  String get youngMuslimEpisodes => 'Bölümler';

  @override
  String youngMuslimEpisodesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bölüm',
      one: '$count bölüm',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNoEpisodesTitle => 'Şu anda bölüm yok';

  @override
  String get youngMuslimNoEpisodesSubtitle =>
      'Seçili seriyi değiştir ya da filtreler güncellendikten sonra tekrar gel.';

  @override
  String get youngMuslimCategoryLoadError => 'Bölüm yüklenemedi';

  @override
  String get youngMuslimTryAgainShortly => 'Birazdan tekrar dene.';

  @override
  String get youngMuslimSearchHint => 'Hikâye ara...';

  @override
  String get youngMuslimAchievements => 'Başarılar';

  @override
  String get youngMuslimQuickFilter => 'Hızlı filtre';

  @override
  String get youngMuslimFilterResults => 'Filtre sonuçları';

  @override
  String youngMuslimResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sonuç',
      one: '$count sonuç',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNoMatchesTitle => 'Eşleşen sonuç yok';

  @override
  String get youngMuslimNoMatchesSubtitle =>
      'Daha fazla bölüm görmek için daha basit kelimeler dene ya da filtreleri değiştir.';

  @override
  String get youngMuslimSections => 'Kategoriler';

  @override
  String get youngMuslimContinueWatching => 'İzlemeye devam et';

  @override
  String get youngMuslimRecentlyWatched => 'Son izlenenler';

  @override
  String get youngMuslimFavorites => 'Favoriler';

  @override
  String get youngMuslimWatchLater => 'Sonra izle';

  @override
  String get youngMuslimSuggestions => 'Sana uygun öneriler';

  @override
  String get youngMuslimGreetingWelcome =>
      'Hikâyeler ve öğrenme dünyasına hoş geldin';

  @override
  String get youngMuslimGreetingPickNew =>
      'Yeni bir hikâye seç ve yolculuğuna bugün başla';

  @override
  String youngMuslimGreetingWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Seni bekleyen $count bölüm var',
      one: 'Seni bekleyen $count bölüm var',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimRewardsTitle => 'Puanlarım ve başarılarım';

  @override
  String youngMuslimLevelAndPoints(int level, int points) {
    return 'Seviye $level · $points puan';
  }

  @override
  String get youngMuslimNextLevelProgress => 'Sonraki seviyeye ilerleme';

  @override
  String youngMuslimProgressOf(int current, int total) {
    return '$current / $total';
  }

  @override
  String get youngMuslimStatAchievements => 'Başarı';

  @override
  String get youngMuslimStatEpisodes => 'Bölüm';

  @override
  String get youngMuslimStatAnswers => 'Cevap';

  @override
  String get youngMuslimFilterAll => 'Tümü';

  @override
  String get youngMuslimStatusInProgress => 'İzleniyor';

  @override
  String get youngMuslimStatusCompleted => 'Tamamlandı';

  @override
  String get youngMuslimStatusWatchLater => 'Sonra';

  @override
  String get youngMuslimFiltersActiveNote =>
      'Filtreler şu anda etkin; sayfanın üstündeki filtre düğmesinden değiştirebilirsin.';

  @override
  String get youngMuslimClearFilters => 'Temizle';

  @override
  String get youngMuslimContentLoadError => 'İçerik yüklenemedi';

  @override
  String get youngMuslimPullToRetry => 'Tekrar denemek için sayfayı aşağı çek.';

  @override
  String get youngMuslimFilterSheetTitle => 'İçeriği filtrele';

  @override
  String get youngMuslimCategoryLabel => 'Kategori';

  @override
  String get youngMuslimFilterLanguage => 'Dil';

  @override
  String get youngMuslimLanguageArabic => 'Arapça';

  @override
  String get youngMuslimLanguageFrench => 'Fransızca';

  @override
  String get youngMuslimLanguageMixed => 'Karışık';

  @override
  String get youngMuslimFilterContentType => 'İçerik türü';

  @override
  String get youngMuslimContentTypeStorySeries => 'Hikâye serileri';

  @override
  String get youngMuslimApplyFilters => 'Filtreleri uygula';

  @override
  String get youngMuslimPlayerTitle => 'Çocuklar için güvenli oynatma';

  @override
  String get youngMuslimEpisodeQuizTitle => 'İzledikten sonra bölüm sorusu';

  @override
  String get youngMuslimSeriesChallenge => 'Seri meydan okuması';

  @override
  String get youngMuslimPlayerLoadError => 'Oynatıcı şu anda yüklenemedi.';

  @override
  String get youngMuslimWatchOptions => 'İzleme seçenekleri';

  @override
  String get youngMuslimPlayNextEpisode => 'Sonraki bölümü oynat';

  @override
  String youngMuslimNextEpisodeFromSeries(String episode) {
    return 'Aynı seriden $episode. bölüm';
  }

  @override
  String get youngMuslimSeriesPlaylist => 'Seri listesi';

  @override
  String get youngMuslimAutoPlayNext => 'Sonraki bölümü otomatik oynat';

  @override
  String get youngMuslimAutoPlayNextSubtitle =>
      'Bölüm bitince yalnızca aynı seri içinde';

  @override
  String get youngMuslimResumeButton => 'İzlemeye devam et';

  @override
  String get youngMuslimPlayNow => 'Şimdi oynat';

  @override
  String youngMuslimPercent(int percent) {
    return '%$percent';
  }

  @override
  String get youngMuslimProgress => 'İlerleme';

  @override
  String get youngMuslimWatchCount => 'İzlenme sayısı';

  @override
  String get youngMuslimEpisodeDuration => 'Bölüm süresi';

  @override
  String youngMuslimLastWatched(String when) {
    return 'Son izleme: $when';
  }

  @override
  String get youngMuslimEpisodeInfo => 'Bölüm bilgisi';

  @override
  String get youngMuslimStory => 'Hikâye';

  @override
  String get youngMuslimSeries => 'Seri';

  @override
  String get youngMuslimEpisodeNumber => 'Bölüm numarası';

  @override
  String get youngMuslimEpisodeTools => 'Bölüm araçları';

  @override
  String get youngMuslimEpisodeQuestions => 'Bölüm soruları';

  @override
  String get youngMuslimEpisodeQuestionsSubtitle =>
      'Çocuğun izlediklerini pekiştiren kısa sorular';

  @override
  String get youngMuslimAfterWatchQuestion => 'İzledikten sonra soru';

  @override
  String get youngMuslimNextEpisode => 'Sonraki bölüm';

  @override
  String get youngMuslimSimilarEpisodes => 'Benzer bölümler';

  @override
  String get youngMuslimDetailsLoadError => 'Bölüm ayrıntıları yüklenemedi';

  @override
  String get youngMuslimQuizIntro =>
      'Çocuğun izlediklerini pekiştirmesine yardımcı olan basit sorular.';

  @override
  String youngMuslimQuestionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count soru',
      one: '$count soru',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimXpOnPass(int points) {
    return 'Başarınca +$points puan';
  }

  @override
  String youngMuslimPassingScore(int score) {
    return 'Geçme notu: $score';
  }

  @override
  String get youngMuslimGrading => 'Cevaplar değerlendiriliyor';

  @override
  String get youngMuslimSubmitAnswers => 'Cevapları gönder';

  @override
  String get youngMuslimAnswerHint => 'Cevabını buraya açıkça yaz...';

  @override
  String get youngMuslimQuizPassed => 'Aferin şampiyon';

  @override
  String get youngMuslimQuizAlmost => 'Tam cevaba çok yakınsın';

  @override
  String youngMuslimQuizScore(int correct, int total) {
    return 'Doğru cevap: $correct / $total';
  }

  @override
  String youngMuslimXpGained(int points) {
    return '+$points puan';
  }

  @override
  String youngMuslimLevel(int level) {
    return 'Seviye $level';
  }

  @override
  String youngMuslimPoints(int points) {
    String _temp0 = intl.Intl.pluralLogic(
      points,
      locale: localeName,
      other: '$points puan',
      one: '$points puan',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNewAchievements => 'Yeni başarılar';

  @override
  String get youngMuslimReviewAnswers => 'Cevapları gözden geçir';

  @override
  String get youngMuslimFinish => 'Bitir';

  @override
  String get youngMuslimYourAnswer => 'Cevabın';

  @override
  String get youngMuslimCorrectAnswer => 'Doğru cevap';

  @override
  String get youngMuslimStatSeriesPlural => 'Seri';

  @override
  String get youngMuslimStatPerfectScores => 'Tam puan';

  @override
  String get youngMuslimUnlockedAchievements => 'Açılan başarılar';

  @override
  String youngMuslimAchievementsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count başarı',
      one: '$count başarı',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNoAchievementsTitle => 'Henüz başarı yok';

  @override
  String get youngMuslimNoAchievementsSubtitle =>
      'Yolculuğa başlamak için ilk bölümü bitir ya da ilk soruyu cevapla.';

  @override
  String get youngMuslimUpcomingAchievements => 'Yaklaşan başarılar';

  @override
  String get youngMuslimAchievementUnlocked => 'Bu başarının kilidi açıldı.';

  @override
  String youngMuslimAchievementUnlockedAt(String when) {
    return 'Açıldı: $when';
  }

  @override
  String get youngMuslimCurrentProgress => 'Mevcut ilerleme';

  @override
  String youngMuslimDurationHoursMinutes(int hours, int minutes) {
    return '$hours sa $minutes dk';
  }

  @override
  String youngMuslimDurationMinutes(int minutes) {
    return '$minutes dk';
  }

  @override
  String get youngMuslimNotWatchedYet => 'Henüz izlenmedi';

  @override
  String get youngMuslimJustNow => 'Az önce';

  @override
  String youngMuslimMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dakika önce',
      one: '$count dakika önce',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saat önce',
      one: '$count saat önce',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün önce',
      one: '$count gün önce',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimWatched => 'İzlendi';

  @override
  String youngMuslimProgressPercent(int percent) {
    return 'İlerleme %$percent';
  }

  @override
  String get youngMuslimReadyToWatch => 'İzlemeye hazır';

  @override
  String youngMuslimCategorySeriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seri',
      one: '$count seri',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimCategorySeriesCountKids(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seri · çocuklar için',
      one: '$count seri · çocuklar için',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimEpisodeMeta(int episode, String duration) {
    return 'Bölüm $episode · $duration';
  }

  @override
  String get youngMuslimResumeWhereLeft => 'Kaldığın yerden devam et';

  @override
  String youngMuslimTimeRemaining(String duration) {
    return 'Kalan: $duration';
  }

  @override
  String get youngMuslimAlmostDone => 'Bitmek üzere';

  @override
  String get categoriesRequestFailed => 'İşlem gerçekleştirilemedi';

  @override
  String get categoriesLibraryTitle => 'Kütüphane';

  @override
  String get categoriesQuranSciencesHeader => 'Kur\'an-ı Kerim ve ilimleri';

  @override
  String get categoriesTypesHeader => 'Türler';

  @override
  String get categoriesSectionsHeader => 'Bölümler';

  @override
  String get categoriesFamousRecitations => 'Meşhur tilavetler';

  @override
  String get categoriesKidsTeaching => 'Çocuklar için Kur\'an eğitimi';

  @override
  String get categoriesRecitationsByNarration =>
      'Farklı rivayet ve kıraatlerle tilavetler';

  @override
  String get categoriesRecitationsByNarrationShort => 'Rivayetlerle tilavetler';

  @override
  String get categoriesHaramainMushafs => 'Harameyn mushafları';

  @override
  String get categoriesTypeVideos => 'Videolar';

  @override
  String get categoriesTypeBooks => 'Kitaplar';

  @override
  String get categoriesTypeStories => 'Hikâyeler';

  @override
  String get categoriesTypeAudios => 'Sesli dersler';

  @override
  String get categoriesTypeFatwas => 'Fetvalar';

  @override
  String get categoriesTypeQuran => 'Kur\'an';

  @override
  String get categoriesTypePresentations => 'Sunumlar';

  @override
  String get categoriesTypeNews => 'Haberler';

  @override
  String get categoriesTypeArticles => 'Makaleler';

  @override
  String get categoriesTypeApps => 'Uygulamalar';

  @override
  String get categoriesTypeSermons => 'Hutbeler';

  @override
  String get categoriesTopicQuran => 'Kur\'an';

  @override
  String get categoriesTopicSunnah => 'Sünnet';

  @override
  String get categoriesTopicSeerah => 'Siyer';

  @override
  String get categoriesTopicAqeedah => 'Akaid';

  @override
  String get categoriesTopicFiqh => 'Fıkıh';

  @override
  String get categoriesTopicHistory => 'Tarih';

  @override
  String get categoriesTopicArabic => 'Arap dili';

  @override
  String get categoriesTopicIslamicStudies => 'İslami ilimler';

  @override
  String get categoriesTopicLessons => 'İlmî dersler';

  @override
  String get categoriesTopicMajorSins => 'Büyük günahlar ve haramlar';

  @override
  String get categoriesNoSearchResults => 'Bu arama için sonuç yok.';

  @override
  String categoriesItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğe',
      one: '$count öğe',
    );
    return '$_temp0';
  }

  @override
  String get categoriesItemAudio => 'Ses';

  @override
  String get categoriesItemBook => 'Kitap';

  @override
  String get categoriesItemArticle => 'Makale';

  @override
  String get categoriesItemVideo => 'Video';

  @override
  String get categoriesFallbackTitle => 'Kategori';

  @override
  String get categoriesNoAttachments => 'Bu içerik için ek yok.';

  @override
  String get categoriesAttachments => 'Ekler';

  @override
  String get categoriesActionWatch => 'İzle';

  @override
  String get categoriesActionRead => 'Oku';

  @override
  String get categoriesActionOpen => 'Aç';

  @override
  String categoriesOrder(String order) {
    return 'Sıra $order';
  }

  @override
  String get categoriesDownload => 'İndir';

  @override
  String get categoriesAttachmentFallback => 'Ek';

  @override
  String get categoriesNoChapters => 'Bu bölümde başlık yok.';

  @override
  String get categoriesClearSearch => 'Aramayı temizle';

  @override
  String get categoriesAudioLoadError => 'Ses içerikleri yüklenemedi.';

  @override
  String categoriesAudioClipNumber(int number) {
    return 'Kayıt $number';
  }

  @override
  String get categoriesAudioClipFallback => 'Ses kaydı';

  @override
  String get booksTitle => 'Kitaplar';

  @override
  String get booksLoadError => 'Kitaplar şu anda yüklenemedi.';

  @override
  String get booksEmpty => 'Gösterilecek kitap yok.';

  @override
  String get booksFilesHeader => 'Kitap dosyaları';

  @override
  String get booksNoFilesTitle => 'Dosya yok';

  @override
  String get booksNoFilesBody => 'Bu kitaba indirilebilir dosya eklenmemiş.';

  @override
  String get booksDescriptionHeader => 'Açıklama';

  @override
  String get booksReferenceHeader => 'Kaynak';

  @override
  String booksFileNumber(int number) {
    return 'Dosya $number';
  }

  @override
  String get booksReadTitle => 'Kitabı oku';

  @override
  String get booksViewerFailed => 'Kitap uygulama içinde gösterilemedi';

  @override
  String get booksOpenOutsideHint => 'Uygulama dışında açabilirsin';

  @override
  String get booksOpenOutside => 'Uygulama dışında aç';

  @override
  String get hadith40Title => 'Kırk Hadis (Nevevî)';

  @override
  String hadith40Number(int number) {
    return 'Hadis $number';
  }

  @override
  String get hadith40SearchHint => 'Hadis ara';

  @override
  String get hadith40NoResults => 'Bu arama için sonuç yok';

  @override
  String get hadith40ShowAll => 'Tüm hadisleri göster';

  @override
  String hadith40SheetSubtitle(int number) {
    return 'Kırk Hadis (Nevevî) · Hadis $number';
  }

  @override
  String get hadith40Explanation => 'Hadisin şerhi';

  @override
  String hadith40ShareText(String title, String hadith, String explanation) {
    return '$title\n\n$hadith\n\nHadisin şerhi:\n$explanation';
  }

  @override
  String get allahNamesTitle => 'Esmaü\'l-Hüsna';

  @override
  String allahNamesNameOrder(int number) {
    return 'Esmaü\'l-Hüsna\'dan $number. isim';
  }

  @override
  String get allahNamesMeaning => 'Anlamı';

  @override
  String get allahNamesSearchHint => 'Esmaü\'l-Hüsna\'da ara';

  @override
  String get allahNamesNoResultsTitle => 'Sonuç yok';

  @override
  String get allahNamesNoResultsMessage =>
      'Aramanla eşleşen bir isim bulunamadı.';

  @override
  String get allahNamesShowAll => 'Tüm isimleri göster';

  @override
  String get readQuranListen => 'Dinle';

  @override
  String get readQuranAyah => 'Ayet';

  @override
  String get readQuranTafsir => 'Ayetin tefsiri';

  @override
  String get quranAudioPlayPause => 'Oynat veya duraklat';

  @override
  String audiosTrackNumber(int number) {
    return 'Kayıt $number';
  }

  @override
  String get audiosTracksHeader => 'Kayıtlar';

  @override
  String get audiosSearchSeriesHint => 'Seri ara';

  @override
  String get audiosSeriesSubtitle => 'Sesli seri';

  @override
  String get audiosNoSeries => 'Gösterilecek seri yok';

  @override
  String get audiosNoResults => 'Aramana uygun sonuç yok';

  @override
  String get audiosPrevious => 'Önceki';

  @override
  String get audiosNext => 'Sonraki';

  @override
  String get audiosPause => 'Duraklat';

  @override
  String get audiosPlay => 'Oynat';

  @override
  String get coreUpdateDownloaded =>
      'Güncelleme indirildi, şimdi yükleyebilirsin.';

  @override
  String get coreUpdateInstallNow => 'Şimdi yükle';

  @override
  String get coreUpdateAvailableTitle => 'Yeni güncelleme var';

  @override
  String coreUpdateAvailableMessage(String version) {
    return '$version sürümü artık App Store\'da.';
  }

  @override
  String get coreUpdateWhatsNew => 'Bu sürümde yenilikler:';

  @override
  String get coreUpdateNow => 'Şimdi güncelle';

  @override
  String get coreExitDialogTitle => 'Uyarı';

  @override
  String get coreExitDialogMessage =>
      'Uygulamadan çıkmak istediğine emin misin?';

  @override
  String get coreExitConfirmMessage => 'Çıkmak istediğine emin misin?';

  @override
  String get coreExitStay => 'Vazgeç';

  @override
  String get coreExitAction => 'Çık';

  @override
  String get coreDeleteDhikrTitle => 'Zikir silinsin mi?';

  @override
  String get coreDeleteDhikrMessage => 'Bu zikri silmek istediğine emin misin?';

  @override
  String get coreFieldRequired => 'Bu alan zorunludur';

  @override
  String get coreNoData => 'Veri yok.';

  @override
  String get coreNoDataToShow => 'Gösterilecek veri yok';

  @override
  String get coreContent => 'İçerik';

  @override
  String get coreGenericError => 'Bir şeyler ters gitti, lütfen tekrar dene';

  @override
  String get coreLoadDataError => 'Veriler yüklenirken bir hata oluştu';

  @override
  String coreErrorStatus(String code) {
    return 'Durum: $code';
  }

  @override
  String get coreCloseSearch => 'Aramayı kapat';

  @override
  String get coreClear => 'Temizle';

  @override
  String get coreSheetDefaultTitle => 'Yeni ekle';

  @override
  String get coreSheetDefaultSubtitle => 'İçeriği özelleştir';

  @override
  String get coreCopiedSuccessfully => 'Kopyalandı';

  @override
  String get coreDownloadStarted => 'İndirme başladı';

  @override
  String get coreDownloadCompleted => 'İndirildi';

  @override
  String get coreSaveReadingPositionPrompt =>
      'Okuma yerini kaydetmek ister misin?';

  @override
  String get coreLocationServiceDisabled =>
      'Konum hizmeti kapalı. Namaz vakitlerini belirlemek için aç.';

  @override
  String get coreLocationPermissionDenied => 'Konum erişim izni verilmedi.';

  @override
  String get coreLocationPermissionDeniedForever =>
      'Konum izni kalıcı olarak reddedildi. Uygulama ayarlarından aç.';

  @override
  String get coreNotNow => 'Şimdi değil';

  @override
  String get coreAllow => 'İzin ver';

  @override
  String get coreOpenSettings => 'Ayarları aç';

  @override
  String get coreNotificationPermissionTitle => 'Bildirim izni';

  @override
  String get coreNotificationPermissionRationale =>
      'Uygulama, sana namaz vakitlerini ve zikirleri hatırlatmak için bildirim iznine ihtiyaç duyar.\nBu, gün boyunca İslam\'ın öğretileriyle bağını korumana yardımcı olur.';

  @override
  String get coreNotificationSettingsTitle => 'Bildirim ayarları';

  @override
  String get coreNotificationPermanentlyDeniedMessage =>
      'Bildirim izni kalıcı olarak reddedildi.\nLütfen Ayarlar\'a gidip bildirimleri elle aç.';

  @override
  String get corePermissionStatusGranted => 'Tüm izinler verildi';

  @override
  String get corePermissionStatusDenied => 'Bildirim izinleri reddedildi';

  @override
  String get corePermissionStatusPermanentlyDenied =>
      'İzinler kalıcı olarak reddedildi';

  @override
  String get corePermissionStatusPartial => 'Yalnızca bazı izinler verildi';

  @override
  String get corePermissionStatusUnknown => 'İzin durumu bilinmiyor';

  @override
  String get corePermissionResultGranted => 'Tüm izinler başarıyla verildi';

  @override
  String get corePermissionResultDenied => 'İzin isteği reddedildi';

  @override
  String get corePermissionResultPermanentlyDenied =>
      'İzinler kalıcı olarak reddedildi - lütfen Ayarlar\'a git';

  @override
  String get corePermissionResultPartial =>
      'Bazı izinler verildi - ek izinler gerekebilir';

  @override
  String get corePermissionResultError => 'İzin istenirken bir hata oluştu';

  @override
  String get coreNotificationActionOpenApp => 'Uygulamayı aç';

  @override
  String get coreNotificationActionDismiss => 'Gizle';

  @override
  String get coreNotificationActionMarkRead => 'Okudum';

  @override
  String get coreNotificationActionRemindLater => 'Sonra hatırlat';

  @override
  String get coreNotificationGroupName => 'İslami bildirimler';

  @override
  String get coreNotificationGroupDescription =>
      'İslami uygulamanın bildirim grubu';

  @override
  String coreNotificationChannelDescription(String channel) {
    return 'İslami bildirimler için $channel kanalı';
  }

  @override
  String get coreNotificationAppLabel => 'Tamaneena uygulaması';

  @override
  String get coreNotificationMore => 'Daha fazla...';

  @override
  String coreNotificationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bildirim',
      one: '$count bildirim',
      zero: 'Bildirim yok',
    );
    return '$_temp0';
  }

  @override
  String coreNotificationNewCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yeni bildirim',
      one: '$count yeni bildirim',
      zero: 'Yeni bildirim yok',
    );
    return '$_temp0';
  }

  @override
  String coreAthanTicker(String prayer) {
    return '$prayer ezanı vakti geldi';
  }

  @override
  String coreAthanDescription(String prayer) {
    return '$prayer ezanı';
  }

  @override
  String get coreChannelAthan => 'Tamaneena - Ezan';

  @override
  String get coreChannelMohammed => 'Tamaneena - Salavat';

  @override
  String get coreChannelMorning => 'Tamaneena - Sabah zikirleri';

  @override
  String get coreChannelNight => 'Tamaneena - Akşam zikirleri';

  @override
  String get coreChannelSleep => 'Tamaneena - Uyku zikirleri';

  @override
  String get coreChannelGetUp => 'Tamaneena - Uyanma zikirleri';

  @override
  String get coreChannelMiddleNight => 'Tamaneena - Gece namazı';

  @override
  String get coreChannelRandomThikr => 'Tamaneena - Rastgele zikirler';

  @override
  String get coreChannelAstgferAllh => 'Tamaneena - İstiğfar';

  @override
  String get coreChannelHasbnaAllh => 'Tamaneena - Hasbünallah';

  @override
  String get coreChannelLaHawla =>
      'Tamaneena - Lâ havle velâ kuvvete illâ billâh';

  @override
  String get coreChannelSubhanAllh => 'Tamaneena - Sübhanallah';

  @override
  String get coreChannelDefaultChannel => 'Tamaneena - Genel bildirimler';

  @override
  String get coreChannelSmartOutreach => 'Tamaneena - Sabah Arkadaşı';

  @override
  String get coreFcmChannelHighImportance => 'Tamaneena - Önemli bildirimler';

  @override
  String get coreFcmChannelChat => 'Tamaneena - Mesajlar';

  @override
  String get coreFcmChannelUpdates => 'Tamaneena - Güncellemeler';

  @override
  String get coreFcmChannelHighImportanceDescription =>
      'Tamaneena uygulamasının önemli bildirim kanalı';

  @override
  String get coreFcmChannelDefaultDescription =>
      'Tamaneena uygulamasının genel bildirim kanalı';

  @override
  String get coreFcmChannelChatDescription =>
      'Tamaneena uygulamasının mesaj ve uyarı kanalı';

  @override
  String get coreFcmChannelUpdatesDescription =>
      'Tamaneena uygulamasının güncelleme kanalı';

  @override
  String get languageTitle => 'Dilini seç';

  @override
  String get languageSubtitle => 'Daha sonra ayarlardan değiştirebilirsin.';

  @override
  String get languageSettingTitle => 'Dil';

  @override
  String get languageSettingSubtitle => 'Uygulama arayüzü dili';

  @override
  String get languageReligiousTextNote =>
      'Kur\'an-ı Kerim, zikirler ve dualar Arapça asıllarıyla kalır.';

  @override
  String get outreachTitle => 'Sabah Arkadaşı';

  @override
  String get outreachTagline =>
      'Sevdiklerinin gününü hayırla başlatan sakin arama listeleri';

  @override
  String get outreachActionCallOnly => 'Yalnızca ara';

  @override
  String get outreachErrorScheduleNotFound => 'Bu liste mevcut değil.';

  @override
  String get outreachContactsPermissionDenied =>
      'Numarayı otomatik seçmek için kişilere erişime izin vermelisin.';

  @override
  String get outreachContactNoPhone => 'Seçilen kişinin telefon numarası yok.';

  @override
  String get outreachContactPickError => 'Kişi seçilirken bir hata oluştu.';

  @override
  String get outreachUnnamed => 'Adsız';

  @override
  String get outreachPermissionPhone => 'Telefon';

  @override
  String get outreachPermissionContacts => 'Kişiler';

  @override
  String get outreachPermissionNotifications => 'Bildirimler';

  @override
  String get outreachListSeparator => ', ';

  @override
  String get outreachValidationTitleRequired => 'Liste için bir ad yaz.';

  @override
  String get outreachValidationAddNumber => 'En az bir numara ekle.';

  @override
  String get outreachValidationEmptyPhone =>
      'Her alanda bir telefon numarası olmalı.';

  @override
  String get outreachValidationIncompleteNumber => 'Eksik bir numara var.';

  @override
  String get outreachValidationDuplicateNumber =>
      'Aynı listede tekrarlanan bir numara var.';

  @override
  String get outreachValidationPickDay => 'En az bir gün seç.';

  @override
  String get outreachValidationEnableWithoutNumbers =>
      'Numarası olmayan bir liste açılamaz.';

  @override
  String get outreachCallLogsTitle => 'Arama kaydı';

  @override
  String get outreachClearLog => 'Kaydı temizle';

  @override
  String get outreachStatTotal => 'Toplam';

  @override
  String get outreachStatAnswered => 'Cevapladı';

  @override
  String get outreachStatNotAnswered => 'Cevaplamadı';

  @override
  String get outreachStatFailed => 'Başarısız';

  @override
  String get outreachResultsHeader => 'Sonuçlar';

  @override
  String get outreachNoResultsTitle => 'Henüz sonuç yok';

  @override
  String get outreachNoResultsMessage =>
      'İlk çalıştırmadan sonra her aramanın sonucu burada görünür.';

  @override
  String outreachSecondsShort(int seconds) {
    return '$seconds sn';
  }

  @override
  String outreachSecondsValue(int seconds) {
    return '$seconds sn';
  }

  @override
  String get outreachCallStatusAnswered => 'Cevaplandı';

  @override
  String get outreachCallStatusNotAnswered => 'Cevaplanmadı';

  @override
  String get outreachCallStatusFailed => 'Arama başarısız';

  @override
  String get outreachExecutionTitle => 'Aramaları başlat';

  @override
  String get outreachCallsStartedFromAlert =>
      'Aramalar bildirimden başlatıldı.';

  @override
  String get outreachCallsStartedNow => 'Aramalar şimdi başladı.';

  @override
  String get outreachCallsStartFailed =>
      'Aramalar şu anda başlatılamadı. Tekrar dene.';

  @override
  String get outreachCallLogsReviewSubtitle =>
      'Liste bittikten sonra kimin cevap verip vermediğini gör';

  @override
  String get outreachPreparingCalls => 'Aramalar hazırlanıyor...';

  @override
  String get outreachDontCloseHint => 'İşlem başlayana kadar sayfayı kapatma.';

  @override
  String get outreachCanCloseHint =>
      'Sayfayı artık kapatabilir, sonucu kayıttan inceleyebilirsin.';

  @override
  String get outreachAddList => 'Liste ekle';

  @override
  String get outreachStatLists => 'Listeler';

  @override
  String get outreachStatEnabled => 'Etkin';

  @override
  String get outreachStatNumbers => 'Numaralar';

  @override
  String get outreachListsHeader => 'Arama listeleri';

  @override
  String get outreachToolsHeader => 'Araçlar';

  @override
  String get outreachCallLogsSubtitle =>
      'Her aramanın sonucu: kim cevapladı, kim cevaplamadı';

  @override
  String get outreachSettingsTitle => 'Arama ayarları';

  @override
  String get outreachSettingsSubtitle =>
      'Varsayılan süreler ve yeni listelerin davranışı';

  @override
  String get outreachNoListsTitle => 'Henüz liste yok';

  @override
  String get outreachNoListsMessage =>
      'Bir liste ekle; saatini ve aramak istediğin numaraları belirle.';

  @override
  String get outreachStartsNow => 'Şimdi başlıyor';

  @override
  String outreachStartsInMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dakika sonra',
      one: '$count dakika sonra',
    );
    return '$_temp0';
  }

  @override
  String outreachStartsInHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saat sonra',
      one: '$count saat sonra',
    );
    return '$_temp0';
  }

  @override
  String outreachStartsInHoursMinutes(int hours, int minutes) {
    return '$hours saat $minutes dakika sonra';
  }

  @override
  String outreachStartsInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün sonra',
      one: '$count gün sonra',
    );
    return '$_temp0';
  }

  @override
  String outreachPermissionsRequiredSnack(String permissions) {
    return 'Önce şu izinleri açmalısın: $permissions';
  }

  @override
  String outreachPermissionsNotice(String permissions) {
    return 'Gerekli izinler eksik. Listelerin zamanında çalışması için şunları aç: $permissions';
  }

  @override
  String get outreachGrantPermissions => 'İzinleri ver';

  @override
  String get outreachOpenSettings => 'Ayarları aç';

  @override
  String get outreachSettingsSaved => 'Ayarlar kaydedildi.';

  @override
  String get outreachSettingsIntro => 'Bu değerler her yeni listeye uygulanır.';

  @override
  String get outreachDefaultDurationsHeader => 'Varsayılan süreler';

  @override
  String get outreachRingTimeout => 'Cevap bekleme süresi';

  @override
  String get outreachHangupDelay => 'Cevaptan sonra bekleme';

  @override
  String get outreachDelayBetweenEach => 'Numaralar arası bekleme';

  @override
  String get outreachBehaviorHeader => 'Liste davranışı';

  @override
  String get outreachStopAfterFirstAnswerList =>
      'İlk cevaptan sonra listeyi durdur';

  @override
  String get outreachRetryIfNoAnswer => 'Cevap yoksa tekrar ara';

  @override
  String get outreachRestartAfterFinish => 'Bitince yeniden başlat';

  @override
  String get outreachSaveSettings => 'Ayarları kaydet';

  @override
  String get outreachBackgroundHeader => 'Arka planda çalışma';

  @override
  String get outreachBatteryTitle => 'Uygulamayı pil tasarrufundan muaf tut';

  @override
  String get outreachBatterySubtitle =>
      'Listeler arka planda durursa pil ayarlarından uygulamanın çalışmasına izin ver.';

  @override
  String get outreachEditList => 'Listeyi düzenle';

  @override
  String get outreachNewList => 'Yeni liste';

  @override
  String get outreachCallTimeHeader => 'Arama saati';

  @override
  String get outreachManualTime => 'Saati elle seç';

  @override
  String get outreachManualTimeSubtitle => 'Saati ve dakikayı kendin belirle';

  @override
  String get outreachUseFajrTime => 'Sabah namazı vaktini kullan';

  @override
  String outreachUseFajrTimeWithTime(String time) {
    return 'Sabah namazı vaktini kullan · $time';
  }

  @override
  String get outreachPrayerTimesNotReady =>
      'Namaz vakitleri şu anda hazır değil';

  @override
  String get outreachFajrAutoFill =>
      'Saat bugünün vakitlerinden otomatik doldurulur';

  @override
  String get outreachFajrUnavailable =>
      'Sabah namazı vakti şu anda mevcut değil. Birazdan tekrar dene.';

  @override
  String outreachFajrTimeUsed(String time) {
    return 'Sabah namazı vakti kullanıldı: $time';
  }

  @override
  String get outreachContactFetchFailed => 'Kişi şu anda alınamadı.';

  @override
  String get outreachExactAlarmHint =>
      'Sabah Arkadaşı\'nın tam zamanında çalışması için cihaz ayarlarından tam zamanlı alarm iznini aç.';

  @override
  String get outreachListNameHeader => 'Liste adı';

  @override
  String get outreachStartTime => 'Başlama saati';

  @override
  String get outreachStartTimeHint =>
      'Saati elle seç ya da sabah namazı vaktini kullan';

  @override
  String outreachFajrTimeToday(String time) {
    return 'Bugün sabah namazı vakti: $time';
  }

  @override
  String outreachContactsHeader(int count) {
    return 'Kişiler · $count';
  }

  @override
  String get outreachPickFromContacts => 'Kişilerden seç';

  @override
  String get outreachPickFromContactsSubtitle =>
      'Bu listeye yeni bir numara ekle';

  @override
  String get outreachAdvancedSettings => 'Gelişmiş ayarlar';

  @override
  String get outreachAdvancedSettingsSubtitle =>
      'Günler, bekleme süreleri ve tekrar davranışı';

  @override
  String get outreachSaving => 'Kaydediliyor...';

  @override
  String get outreachSaveList => 'Listeyi kaydet';

  @override
  String get outreachNoNumbersYet => 'Henüz numara eklenmedi.';

  @override
  String get outreachEnableList => 'Bu listeyi aç';

  @override
  String get outreachDailyRepeat => 'Her gün tekrarla';

  @override
  String get outreachEveryDay => 'Her gün';

  @override
  String get outreachSelectedWeekdays => 'Haftanın seçili günleri';

  @override
  String get outreachDelayBetweenNumbers => 'Numaralar arası bekleme';

  @override
  String get outreachStopAfterFirstAnswer => 'İlk cevaptan sonra durdur';

  @override
  String get outreachRetryOnNoAnswer => 'Cevap yoksa tekrar ara';

  @override
  String get outreachRepeatWholeCycle => 'Tüm döngüyü tekrarla';

  @override
  String get outreachListNameHint => 'Örnek: Sabah namazı hatırlatması';

  @override
  String get outreachTitleFieldRequired => 'Liste için bir ad yaz';

  @override
  String get outreachPickNumber => 'Numarayı seç';

  @override
  String get outreachMultipleNumbers => 'Bu kişide birden fazla numara var.';

  @override
  String get outreachNoDays => 'Belirli gün yok';

  @override
  String outreachContactsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count numara',
      one: '$count numara',
      zero: 'Numara yok',
    );
    return '$_temp0';
  }

  @override
  String outreachMetaRing(int seconds) {
    return 'Bekleme $seconds sn';
  }

  @override
  String outreachMetaAfterAnswer(int seconds) {
    return 'Cevaptan sonra $seconds sn';
  }

  @override
  String outreachMetaBetween(int seconds) {
    return 'Numaralar arası $seconds sn';
  }

  @override
  String get outreachNearest => 'En yakın';

  @override
  String get outreachStartNow => 'Şimdi başlat';

  @override
  String get outreachStatusActive => 'Etkin';

  @override
  String get outreachStatusStopped => 'Durduruldu';

  @override
  String outreachStatusSemantics(String status) {
    return 'Durum: $status';
  }

  @override
  String get outreachWeekday1 => 'Pazartesi';

  @override
  String get outreachWeekday2 => 'Salı';

  @override
  String get outreachWeekday3 => 'Çarşamba';

  @override
  String get outreachWeekday4 => 'Perşembe';

  @override
  String get outreachWeekday5 => 'Cuma';

  @override
  String get outreachWeekday6 => 'Cumartesi';

  @override
  String get outreachWeekday7 => 'Pazar';

  @override
  String get travelerServicesTitle => 'Yolcu hizmetleri';

  @override
  String get travelerNearbyMosques => 'Yakındaki camiler';

  @override
  String get travelerNearbyHalalRestaurants => 'Yakındaki helal restoranlar';

  @override
  String get travelerHalalRestaurants => 'Helal restoranlar';

  @override
  String get travelerHintAroundYou => 'Şu an çevrende';

  @override
  String get travelerHintWithCounter => 'Sayaçlı';

  @override
  String get travelerHintByCountry => 'Ülkene göre';

  @override
  String get travelerFlightPrayer => 'Uçakta namaz';

  @override
  String get travelerHintByFlightNumber => 'Uçuş numarasıyla';

  @override
  String get travelerSetLocationForMakkah =>
      'Mekke\'ye uzaklığın görünmesi için vakitlerde konumunu belirle.';

  @override
  String get travelerInMakkah =>
      'Mekke-i Mükerreme\'desin — Allah kabul etsin.';

  @override
  String get travelerYourLocation => 'Konumun';

  @override
  String get travelerMakkah => 'Mekke-i Mükerreme';

  @override
  String get travelerQibla => 'Kıble';

  @override
  String travelerDistanceMeters(String value) {
    return '$value m';
  }

  @override
  String travelerDistanceKm(String value) {
    return '$value km';
  }

  @override
  String get travelerListSeparator => ', ';

  @override
  String get travelerDirectionN => 'Kuzey';

  @override
  String get travelerDirectionNE => 'Kuzeydoğu';

  @override
  String get travelerDirectionE => 'Doğu';

  @override
  String get travelerDirectionSE => 'Güneydoğu';

  @override
  String get travelerDirectionS => 'Güney';

  @override
  String get travelerDirectionSW => 'Güneybatı';

  @override
  String get travelerDirectionW => 'Batı';

  @override
  String get travelerDirectionNW => 'Kuzeybatı';

  @override
  String get travelerPrayerUnknown => 'Belirsiz';

  @override
  String get travelerPrayerShortFajr => 'Sabah';

  @override
  String get travelerPrayerShortSunrise => 'Güneş';

  @override
  String get travelerPrayerShortDhuhr => 'Öğle';

  @override
  String get travelerPrayerShortAsr => 'İkindi';

  @override
  String get travelerPrayerShortMaghrib => 'Akşam';

  @override
  String get travelerPrayerShortIsha => 'Yatsı';

  @override
  String get travelerNoMosquesFound => 'Mevcut alanda cami bulunamadı.';

  @override
  String get travelerNoRestaurantsFound =>
      'Bu alanda helal restoran bulunamadı.';

  @override
  String travelerWalkingMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Yürüyerek $count dk',
      one: 'Yürüyerek $count dk',
    );
    return '$_temp0';
  }

  @override
  String get travelerDefaultMosqueName => 'Yakındaki cami';

  @override
  String get travelerDefaultRestaurantName => 'Helal restoran';

  @override
  String get travelerNoDetailedAddress => 'Ayrıntılı adres yok';

  @override
  String get travelerRepeatBySituation => 'Duruma göre';

  @override
  String get travelerRepeatOnce => '1 kez';

  @override
  String travelerRepeatTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kez',
      one: '$count kez',
    );
    return '$_temp0';
  }

  @override
  String get travelerStageStart => 'Yolculuğun başında';

  @override
  String get travelerStageOnTheWay => 'Yolda';

  @override
  String get travelerStageStop => 'Mola verirken';

  @override
  String get travelerStageReturn => 'Dönüşte';

  @override
  String get travelerStageFarewell => 'Yolcuyu uğurlama';

  @override
  String get travelerStageFarewellReply => 'Yolcu için dua';

  @override
  String get travelerAthkarTitle => 'Yolculuk zikirleri';

  @override
  String get travelerAthkarLoadFailed => 'Yolculuk zikirleri yüklenemedi.';

  @override
  String get travelerFarewellTitle => 'Yolcu uğurlayan için';

  @override
  String get travelerFarewellCaption =>
      'Senin yolun için değil — geride kalanlar için';

  @override
  String get travelerRoadComplete => 'Yol zikirlerini tamamladın';

  @override
  String get travelerRoadStations => 'Yol durakları';

  @override
  String get travelerRoadCompleteCaption => 'Selametle git.';

  @override
  String get travelerRoadCaption =>
      'Her zikir yolculuğun kendi anında — bulunduğun durağı aç.';

  @override
  String travelerShareVirtue(String virtue) {
    return 'Fazileti: $virtue';
  }

  @override
  String travelerShareSource(String source, String hadith) {
    return 'Kaynak: $source ($hadith)';
  }

  @override
  String get travelerResetCounter => 'Sayacı sıfırla';

  @override
  String get travelerCounterDone => 'Tamam';

  @override
  String get travelerCounterCount => 'Say';

  @override
  String get travelerCountDhikr => 'Zikri say';

  @override
  String get travelerFlightPrayerTitle => 'Uçakta namaz vakitleri';

  @override
  String get travelerShowTimes => 'Vakitleri göster';

  @override
  String get travelerShowMap => 'Haritayı göster';

  @override
  String get travelerShowList => 'Listeyi göster';

  @override
  String get travelerSearchByFlightNumber => 'Uçuş numarasıyla ara';

  @override
  String get travelerRunSearchNow => 'Şimdi ara';

  @override
  String get travelerFlightAttemptsExhausted =>
      'Deneme hakkın bitti. Tekrar denemek için sayfayı yeniden aç.';

  @override
  String get travelerFlightNumberInvalid =>
      'Uçuş numarası geçersiz. Örnek: EK202 veya MS985';

  @override
  String get travelerFlightFetchFailed => 'Uçuş bilgileri şu anda alınamadı.';

  @override
  String get travelerSourceMock => 'Yerel simülasyon (API\'siz)';

  @override
  String get travelerCityRiyadh => 'Riyad';

  @override
  String get travelerCityJeddah => 'Cidde';

  @override
  String get travelerCityDubai => 'Dubai';

  @override
  String get travelerCityDoha => 'Doha';

  @override
  String get travelerCityIstanbul => 'İstanbul';

  @override
  String get travelerCityCairo => 'Kahire';

  @override
  String get travelerCityKualaLumpur => 'Kuala Lumpur';

  @override
  String get travelerCityLondon => 'Londra';

  @override
  String get travelerCityParis => 'Paris';

  @override
  String get travelerCityNewYork => 'New York';

  @override
  String get travelerAttemptsRemaining => 'Kalan deneme';

  @override
  String get travelerLiveTrack => 'Canlı rota';

  @override
  String get travelerTakeoff => 'Kalkış';

  @override
  String get travelerLanding => 'İniş';

  @override
  String get travelerFlightEnded => 'Uçuş bitti — uçakta kalan vakit yok.';

  @override
  String get travelerNoPrayerDuringFlight =>
      'Bu uçuş süresince hiçbir namaz vakti girmedi.';

  @override
  String get travelerAllFlightPrayersPassed => 'Bu uçuşun tüm vakitleri geçti.';

  @override
  String travelerCountdownHoursMinutes(int hours, int minutes) {
    return '$hours sa $minutes dk sonra';
  }

  @override
  String travelerCountdownMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dakika sonra',
      one: '$count dakika sonra',
    );
    return '$_temp0';
  }

  @override
  String travelerNextPrayerAboard(String prayer, String countdown) {
    return 'Uçakta $prayer — $countdown';
  }

  @override
  String travelerFirstPrayerAboard(String prayer) {
    return 'Uçaktaki ilk namaz: $prayer';
  }

  @override
  String travelerAtPlaneLocalTime(String time, String offset) {
    return 'Uçağın bulunduğu yerin saatiyle $time ($offset)';
  }

  @override
  String get travelerLocalTimeAbovePlane =>
      'Uçağın bulunduğu yerin yerel saatiyle';

  @override
  String get travelerTapStopHint =>
      'Haritada yerini görmek için herhangi bir durağa dokun';

  @override
  String get travelerUpcoming => 'Yaklaşan';

  @override
  String get travelerNext => 'Sıradaki';

  @override
  String travelerStopGmt(String place, String time) {
    return '$place · GMT $time';
  }

  @override
  String get travelerSearchByFlightNumberHeader => 'Uçuş numarasıyla ara';

  @override
  String get travelerRun => 'Çalıştır';

  @override
  String get travelerFlightSearchHint =>
      'Rota boyunca namaz vakitlerini hesaplamamız için uçuş numarasını yaz.';

  @override
  String get travelerFlightDetails => 'Uçuş ayrıntıları';

  @override
  String get travelerFlightNumber => 'Uçuş numarası';

  @override
  String get travelerFrom => 'Nereden';

  @override
  String get travelerTo => 'Nereye';

  @override
  String get travelerDataSource => 'Veri kaynağı';

  @override
  String get travelerFlightTimeline => 'Uçuş zaman çizelgesi';

  @override
  String get travelerNoTimesDuringFlight =>
      'Bu uçuş süresince vakit görünmedi.';

  @override
  String get travelerFlightNumberExample => 'Örnek: EK202';

  @override
  String get travelerShowFullRoute => 'Rotanın tamamını göster';

  @override
  String get travelerZoomIn => 'Yakınlaştır';

  @override
  String get travelerZoomOut => 'Uzaklaştır';

  @override
  String get travelerLocationFailed =>
      'Mevcut konumun belirlenemedi. Tekrar dene.';

  @override
  String get travelerLocationServiceDisabled =>
      'Konum hizmeti kapalı. Yakındaki sonuçları görmek için aç.';

  @override
  String get travelerLocationPermissionRequired =>
      'Bu özelliğin çalışması için konum izni verilmeli.';

  @override
  String get travelerLocationPermissionDeniedForever =>
      'Konum izni kalıcı olarak reddedildi. Uygulama ayarlarını aç.';

  @override
  String get travelerPlacesFetchFailed =>
      'Yakındaki sonuçlar şu anda alınamadı. Tekrar dene.';

  @override
  String get travelerExpandRadius => 'Alanı genişlet';

  @override
  String travelerAllWithinRadius(String radius) {
    return 'Hepsi $radius içinde — ok her birinin yönünü gösterir.';
  }

  @override
  String get travelerRadius => 'Alan';

  @override
  String get travelerNearestPlaces => 'En yakın yerler';

  @override
  String travelerFoundResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Yakınında $count sonuç bulundu',
      one: 'Yakınında $count sonuç bulundu',
    );
    return '$_temp0';
  }

  @override
  String get travelerUnexpectedError => 'Beklenmeyen bir hata oluştu';

  @override
  String get travelerHalalRestricted =>
      'Helal restoran araması Müslüman ülkelerde gösterilmez,\nçünkü oradaki restoranlar zaten helaldir.';

  @override
  String get travelerOpenMapsFailed => 'Harita uygulaması açılamadı.';

  @override
  String get travelerNearestMosque => 'Sana en yakın cami';

  @override
  String get travelerNearestRestaurant => 'En yakın helal restoran';

  @override
  String get travelerTakeMeThere => 'Beni oraya götür';

  @override
  String travelerWillMakeIt(int count, String prayer) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$prayer vaktine yetişirsin — $count dakika kaldı',
      one: '$prayer vaktine yetişirsin — $count dakika kaldı',
    );
    return '$_temp0';
  }

  @override
  String travelerMightMiss(int count, String prayer) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Yürüyerek $prayer vaktine yetişemeyebilirsin — $count dakika kaldı',
      one: 'Yürüyerek $prayer vaktine yetişemeyebilirsin — $count dakika kaldı',
    );
    return '$_temp0';
  }

  @override
  String get travelerOpenInGoogleMaps => 'Google Haritalar\'da aç';

  @override
  String get travelerTapMarkerHint => 'Ayrıntılar için işarete dokun';

  @override
  String get travelerOpenPhoneFailed => 'Telefon uygulaması açılamadı.';

  @override
  String get travelerOpenLinkFailed => 'Bağlantı açılamadı.';

  @override
  String get travelerDirections => 'Yol tarifi';

  @override
  String get travelerGoogleMaps => 'Google Haritalar';

  @override
  String get travelerCall => 'Ara';

  @override
  String get travelerUpdating => 'Güncelleniyor…';

  @override
  String travelerResultsCount(int count) {
    return 'Sonuç sayısı: $count';
  }

  @override
  String get travelerMyCurrentLocation => 'Mevcut konumum';

  @override
  String get travelerMaps => 'Haritalar';

  @override
  String get travelerMyLocation => 'Konumum';

  @override
  String get qiblahTitle => 'Kıble';

  @override
  String get qiblahRefreshTooltip => 'Yönü yenile';

  @override
  String get qiblahErrorNoSensor => 'Cihazın yön algılamayı desteklemiyor';

  @override
  String get qiblahErrorPermissionRequired =>
      'Kıble yönünü belirlemek için konum erişimine izin vermelisin';

  @override
  String qiblahErrorGeneric(String error) {
    return 'Kıble yönü belirlenirken hata oluştu: $error';
  }

  @override
  String get qiblahErrorLocationServiceOff =>
      'Konum hizmetleri kapalı. Lütfen ayarlardan aç';

  @override
  String get qiblahErrorPermissionDeniedForever =>
      'Konum izinleri kalıcı olarak reddedildi. Lütfen uygulama ayarlarından aç';

  @override
  String get qiblahErrorLocationFailed => 'Mevcut konum alınamadı';

  @override
  String get qiblahUnknownLocation => 'Bilinmeyen konum';

  @override
  String qiblahErrorDirection(String error) {
    return 'Yön belirleme hatası: $error';
  }

  @override
  String get qiblahErrorStreamFailed => 'Yön takibi başlatılamadı';

  @override
  String get qiblahLocating => 'Konum belirleniyor...';

  @override
  String get qiblahAligned => 'Kıbleye yöneldin';

  @override
  String qiblahTurnLeft(int degrees) {
    return 'Sola $degrees° dön';
  }

  @override
  String qiblahTurnRight(int degrees) {
    return 'Sağa $degrees° dön';
  }

  @override
  String get qiblahLoadingTitle => 'Kıble yönü belirleniyor';

  @override
  String get qiblahLoadingSubtitle =>
      'Konumun açık olduğundan ve izinlerin verildiğinden emin ol';

  @override
  String get qiblahHintAligned => 'Cihazı sabit tut, ok kıble işaretinde';

  @override
  String get qiblahHintMove => 'Ok işarete gelene kadar cihazı yavaşça çevir';

  @override
  String get qiblahReadingsHeader => 'Pusula verileri';

  @override
  String get qiblahCurrentHeading => 'Mevcut yönün';

  @override
  String get qiblahAngle => 'Kıble açısı';

  @override
  String get qiblahCurrentLocation => 'Mevcut konumun';

  @override
  String get qiblahDistanceToMecca => 'Mekke\'ye uzaklık';

  @override
  String qiblahDistanceKm(int km) {
    return '$km km';
  }

  @override
  String get qiblahInstructionsHeader => 'Kullanım talimatları';

  @override
  String get qiblahInstructions =>
      '• Telefonu önünde düz tut.\n• Altın ok üstteki işaretle buluşana kadar yavaşça dön.\n• Hizalandığında halka parlar ve hafif bir titreşim hissedersin.\n• Metal nesneleri telefondan uzak tut.\n• İbre kararsızsa telefonu 8 şeklinde hareket ettir.';

  @override
  String get qiblahCompassNorth => 'K';

  @override
  String get qiblahCompassEast => 'D';

  @override
  String get qiblahCompassSouth => 'G';

  @override
  String get qiblahCompassWest => 'B';

  @override
  String get homeSectionYourDay => 'Günün';

  @override
  String get homeSectionAyah => 'Kur\'an\'dan bir ayet';

  @override
  String get homeSectionFeatures => 'Özellikler';

  @override
  String get homeSectionKids => 'Çocuk bölümü';

  @override
  String get homeYoungMuslimTitle => 'Küçük Müslüman';

  @override
  String get homeYoungMuslimSubtitle =>
      'Çocuklar için hikâyeler, adaplar ve zikirler';

  @override
  String homeUpdateAvailable(String version) {
    return 'Yeni güncelleme var · Sürüm $version';
  }

  @override
  String get homeUpdateAction => 'Güncelle';

  @override
  String get homeContinueReading => 'Okumaya devam et';

  @override
  String get homeStartReading => 'Okumaya başla';

  @override
  String homeContinueReadingPosition(String surah, int page) {
    return '$surah · Sayfa $page';
  }

  @override
  String get homeStartReadingPosition => 'Fâtiha Suresi\'nden · Sayfa 1';

  @override
  String homeAyahReference(String surah, int number) {
    return '$surah · Ayet $number';
  }

  @override
  String homeAyahNumber(int number) {
    return 'Ayet $number';
  }

  @override
  String get homeAnotherAyah => 'Başka ayet';

  @override
  String get homeReadInMushaf => 'Mushaf\'ta oku';

  @override
  String get homeTrackerComplete =>
      'Bugünün namazlarını tamamladın, Allah kabul etsin';

  @override
  String get homeTrackerPrompt => 'Bugün kıldıklarını işaretle';

  @override
  String homeTrackerProgress(int count, int total) {
    return '$count / $total';
  }

  @override
  String homeTrackerStreak(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days gün üst üste',
      one: '$days gün üst üste',
    );
    return '$_temp0';
  }

  @override
  String get homeNavHome => 'Ana sayfa';

  @override
  String get homeNavSections => 'Bölümler';

  @override
  String homeNextPrayerRemaining(String prayer, String time, String remaining) {
    return '  $prayer : $time  \n Kalan süre : $remaining ';
  }

  @override
  String get prayerTimeHighLatAuto => 'Otomatik';

  @override
  String get prayerTimeHighLatAutoDesc =>
      'Hesaplama yönteminin varsayılan değerini kullanır.';

  @override
  String get prayerTimeHighLatMiddleOfNight => 'Gece yarısı';

  @override
  String get prayerTimeHighLatMiddleOfNightDesc =>
      'İmsak gece yarısından önce olmaz, yatsı da gece yarısından sonraya kalmaz.';

  @override
  String get prayerTimeHighLatSeventhOfNight => 'Gecenin yedide biri';

  @override
  String get prayerTimeHighLatSeventhOfNightDesc =>
      'İmsak için gecenin son yedide birini, yatsı için ilk yedide birini esas alır.';

  @override
  String get prayerTimeHighLatTwilightAngle => 'Şafak açısı';

  @override
  String get prayerTimeHighLatTwilightAngleDesc =>
      'Geceyi seçilen imsak ve yatsı açılarına göre böler.';

  @override
  String get prayerTimeIshaModeAngle => 'Açıyla yatsı';

  @override
  String get prayerTimeIshaModeAngleDesc =>
      'Yatsı, güneşin ufuk altındaki açısıyla hesaplanır.';

  @override
  String get prayerTimeIshaModeInterval => 'Süreyle yatsı';

  @override
  String get prayerTimeIshaModeIntervalDesc =>
      'Yatsı, akşamdan sonra sabit dakika sayısıyla hesaplanır.';

  @override
  String get prayerTimeMethodUmmAlQura => 'Ümmü\'l-Kurâ - Mekke';

  @override
  String get prayerTimeMethodMuslimWorldLeague => 'Müslüman Dünya Ligi';

  @override
  String get prayerTimeMethodEgyptian => 'Mısır Genel Ölçüm Kurumu';

  @override
  String get prayerTimeMethodKarachi => 'İslami İlimler Üniversitesi - Karaçi';

  @override
  String get prayerTimeMethodDubai => 'Dubai';

  @override
  String get prayerTimeMethodQatar => 'Katar';

  @override
  String get prayerTimeMethodKuwait => 'Kuveyt';

  @override
  String get prayerTimeMethodSingapore => 'Singapur';

  @override
  String get prayerTimeMethodTurkey => 'Diyanet - Türkiye';

  @override
  String get prayerTimeMethodTehran => 'Tahran Üniversitesi Jeofizik Enstitüsü';

  @override
  String get prayerTimeMethodMoonSighting => 'Moonsighting Committee';

  @override
  String get prayerTimeMethodNorthAmerica =>
      'Kuzey Amerika İslam Birliği (ISNA)';

  @override
  String get prayerTimeMethodCustom => 'Özel ayar';

  @override
  String get prayerTimeMethodUmmAlQuraDesc =>
      'İmsak 18.5°, yatsı akşamdan 90 dakika sonra.';

  @override
  String get prayerTimeMethodMuslimWorldLeagueDesc => 'İmsak 18°, yatsı 17°.';

  @override
  String get prayerTimeMethodEgyptianDesc => 'İmsak 19.5°, yatsı 17.5°.';

  @override
  String get prayerTimeMethodKarachiDesc => 'İmsak 18°, yatsı 18°.';

  @override
  String get prayerTimeMethodDubaiDesc => 'İmsak ve yatsı 18.2°.';

  @override
  String get prayerTimeMethodQatarDesc =>
      'İmsak 18°, yatsı akşamdan 90 dakika sonra.';

  @override
  String get prayerTimeMethodKuwaitDesc => 'İmsak 18°, yatsı 17.5°.';

  @override
  String get prayerTimeMethodSingaporeDesc => 'İmsak 20°, yatsı 18°.';

  @override
  String get prayerTimeMethodTurkeyDesc =>
      'İmsak 18°, yatsı 17°, Diyanet düzeltmeleriyle.';

  @override
  String get prayerTimeMethodTehranDesc =>
      'İmsak 17.7°, yatsı 14°, akşam 4.5°.';

  @override
  String get prayerTimeMethodMoonSightingDesc =>
      'İmsak 18°, yatsı 18°, mevsimsel düzeltmelerle.';

  @override
  String get prayerTimeMethodNorthAmericaDesc => 'İmsak 15°, yatsı 15°.';

  @override
  String get prayerTimeMethodCustomDesc =>
      'İmsak, yatsı ve akşam açılarını kendin belirle.';

  @override
  String get prayerTimeMadhabShafi => 'Şafii, Maliki ve Hanbeli';

  @override
  String get prayerTimeMadhabHanafi => 'Hanefi';

  @override
  String get prayerTimeMadhabShafiDesc =>
      'İkindi, bir cismin gölgesi kendi boyu kadar olunca girer; Maliki ve Hanbeli de böyledir.';

  @override
  String get prayerTimeMadhabHanafiDesc =>
      'İkindi, bir cismin gölgesi boyunun iki katı olunca girer.';

  @override
  String get prayerTimeCalcIntro =>
      'Bölgende esas alınan takvimi seç; mahalle camisiyle eşleştirmen gerekirse vakitleri elle düzenle.';

  @override
  String get prayerTimeCalcMethod => 'Hesaplama yöntemi';

  @override
  String get prayerTimeCalcAsrMadhab => 'İkindi hesabı mezhebi';

  @override
  String get prayerTimeMadhabShafiShort => 'Şafii';

  @override
  String get prayerTimeCalcHighLatitude => 'Yüksek enlemler';

  @override
  String get prayerTimeCalcRamadanIsha => 'Ramazan\'da yatsıyı geciktir';

  @override
  String get prayerTimeCalcRamadanIshaHint =>
      'Ümmü\'l-Kurâ takviminde olduğu gibi ay boyunca yatsıya 30 dakika ekler.';

  @override
  String get prayerTimeCalcRestoreDefaults => 'Ümmü\'l-Kurâ ayarlarına dön';

  @override
  String get prayerTimeCalcCustomAngles => 'Özel hesaplama açıları';

  @override
  String get prayerTimeCalcFajrAngle => 'İmsak açısı';

  @override
  String get prayerTimeCalcIshaMode => 'Yatsı hesabı';

  @override
  String get prayerTimeCalcIshaModeHint =>
      'Ya şafak açısıyla ya da akşamdan sonra sabit bir süreyle.';

  @override
  String get prayerTimeCalcIshaAngle => 'Yatsı açısı';

  @override
  String get prayerTimeCalcIshaAfterMaghrib => 'Akşamdan sonra yatsı';

  @override
  String get prayerTimeCalcMaghribAngleToggle =>
      'Gün batımı yerine akşam açısı';

  @override
  String get prayerTimeCalcMaghribAngleToggleHint =>
      'Akşam için gün batımı anı yerine şafak açısı kullananlar için.';

  @override
  String get prayerTimeCalcMaghribAngle => 'Akşam açısı';

  @override
  String prayerTimeMinutesShort(String value) {
    return '$value dk';
  }

  @override
  String get prayerTimeMinutesZero => '0 dk';

  @override
  String get prayerTimeCalcManualAdjust => 'Her vakit için elle düzeltme';

  @override
  String get prayerTimeCalcManualAdjustHint =>
      'Vakitleri mahalle camisiyle dakikası dakikasına eşleştir';

  @override
  String prayerTimeCalcManualAdjustCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vakit elle düzeltildi',
      one: '$count vakit elle düzeltildi',
    );
    return '$_temp0';
  }

  @override
  String get prayerTimeGenericPrayer => 'Namaz';

  @override
  String prayerTimeAthanTitle(String prayer) {
    return '$prayer ezanı';
  }

  @override
  String prayerTimeAthanTitleWithTime(String prayer, String time) {
    return '$prayer ezanı • $time';
  }

  @override
  String get prayerTimeAthanBodyFajr =>
      'Haydi namaza — gününe sabahın nuruyla başla.';

  @override
  String get prayerTimeAthanBodyDhuhr => 'Kalbine bir mola ver.';

  @override
  String get prayerTimeAthanBodyAsr => 'Allah ile bağını tazele.';

  @override
  String get prayerTimeAthanBodyMaghrib => 'Gününü ibadet ve huzurla kapat.';

  @override
  String get prayerTimeAthanBodyIsha => 'Günün son namazını kaçırma.';

  @override
  String get prayerTimeAthanBodyDefault => 'Allah ibadetini kabul etsin.';

  @override
  String get prayerTimeAthanExpandedHint =>
      'Namaz uyarısını ve ayrıntıları açmak için dokun.';

  @override
  String prayerTimeAthanTicker(String prayer) {
    return '$prayer ezanı vakti geldi';
  }

  @override
  String get prayerTimeAlertNow => 'Namaz vakti geldi';

  @override
  String get prayerTimeAlertMessage =>
      'Namazını huşuyla kıl; o kalbin nuru, ruhun huzurudur.';

  @override
  String get prayerTimeAlertReady => 'Namaza hazırım';

  @override
  String get prayerTimeAlertOpenTimes => 'Namaz vakitleri sayfasını aç';

  @override
  String get prayerTimeTitle => 'Namaz vakitleri';

  @override
  String get prayerTimeSettingsTitle => 'Namaz vakti ayarları';

  @override
  String get prayerTimeSheetAthanTime => 'Ezan vakti';

  @override
  String get prayerTimeSheetUntilDhuhr => 'Öğleye kadar';

  @override
  String get prayerTimeSheetWindow => 'Vakit süresi';

  @override
  String get prayerTimeSheetShift => 'Bugüne göre fark';

  @override
  String get prayerTimeWeekdaySat => 'Cmt';

  @override
  String get prayerTimeWeekdaySun => 'Paz';

  @override
  String get prayerTimeWeekdayMon => 'Pzt';

  @override
  String get prayerTimeWeekdayTue => 'Sal';

  @override
  String get prayerTimeWeekdayWed => 'Çar';

  @override
  String get prayerTimeWeekdayThu => 'Per';

  @override
  String get prayerTimeWeekdayFri => 'Cum';

  @override
  String get prayerTimeLessThanMinute => 'Bir dakikadan az';

  @override
  String prayerTimeHoursShort(int hours) {
    return '$hours sa';
  }

  @override
  String prayerTimeHoursMinutesShort(int hours, int minutes) {
    return '$hours sa $minutes dk';
  }

  @override
  String get prayerTimeShiftSameDay => 'Bugün';

  @override
  String get prayerTimeShiftNone => 'Fark yok';

  @override
  String prayerTimeShiftLater(int minutes) {
    return '$minutes dk geç';
  }

  @override
  String prayerTimeShiftEarlier(int minutes) {
    return '$minutes dk erken';
  }

  @override
  String get prayerTimeAm => 'ÖÖ';

  @override
  String get prayerTimePm => 'ÖS';

  @override
  String get prayerTimeLocationSourceManual => 'Elle seçildi';

  @override
  String get prayerTimeLocationSourceDevice => 'Cihaz konumu';

  @override
  String get prayerTimeLocationPickHint =>
      'Bir şehir seç ya da cihaz konumunu kullan';

  @override
  String prayerTimeLocationDetails(String details, String source) {
    return '$details · $source';
  }

  @override
  String get prayerTimeLocationNotSet => 'Henüz konum belirlenmedi';

  @override
  String get prayerTimeMyLocation => 'Mevcut konumum';

  @override
  String get prayerTimeGrantPermission => 'İzin ver';

  @override
  String get prayerTimeEmptyWeekTitle =>
      'Haftalık tablonun görünmesi için konumunu belirle';

  @override
  String get prayerTimeEmptyWeekSubtitle =>
      'Şehrini ara ya da cihaz konumunu kullan';

  @override
  String get prayerTimeSetLocation => 'Konum belirle';

  @override
  String get prayerTimeWeekNeedsCity =>
      'Tüm haftanın vakitlerini görmek için şehrini belirle';

  @override
  String get prayerTimeWeekHint =>
      'Diğer günler için tabloyu yatay kaydır · Ayrıntılar için bir vakte dokun';

  @override
  String prayerTimeNightPrayerHeader(String day) {
    return 'Gece namazı · $day';
  }

  @override
  String get prayerTimeMidnight => 'Gece yarısı';

  @override
  String get prayerTimeMidnightHint => 'Akşam ile sabah arasının ortası';

  @override
  String get prayerTimeLastThird => 'Gecenin son üçte biri';

  @override
  String get prayerTimeLastThirdHint =>
      'Gece namazı ve dua için en faziletli vakit';

  @override
  String get prayerTimeLocationHeader => 'Konum';

  @override
  String get prayerTimeLocationUpdateFailed => 'Mevcut konum güncellenemedi.';

  @override
  String get prayerTimeToday => 'Bugün';

  @override
  String get prayerTimeTomorrow => 'Yarın';

  @override
  String get prayerTimeTablePrayerColumn => 'Namaz';

  @override
  String get prayerTimeSettingsCalcHeader => 'Vakit hesaplama yöntemi';

  @override
  String get prayerTimeSettingsSilentHeader => 'Namaz vaktinde sessiz';

  @override
  String get prayerTimeSilentNeedsPermission =>
      'Özelliğin çalışması için önce Rahatsız Etmeyin iznini ver.';

  @override
  String get prayerTimeSettingsSaved => 'Namaz vakti ayarları kaydedildi.';

  @override
  String get prayerTimeSilentHint =>
      'Namaz vaktinde cihazı sessize alır, sonra sesi otomatik olarak geri açar.';

  @override
  String get prayerTimeSilentEnable => 'Otomatik sessizi aç';

  @override
  String get prayerTimeSilentPermissionNote =>
      'Bu özellik sistemden «Rahatsız Etmeyin» izni gerektirir.';

  @override
  String get prayerTimeSilentDuration => 'Namazdan sonra sessiz kalma süresi';

  @override
  String get prayerTimeMinutesSuffix => 'dk';

  @override
  String get prayerTimeSaving => 'Kaydediliyor';

  @override
  String get prayerTimeSaveSettings => 'Ayarları kaydet';

  @override
  String get prayerTimeSavedLocation => 'Kayıtlı konum';

  @override
  String get prayerTimePickerMapPointLabel => 'Haritada seçilen konum';

  @override
  String get prayerTimePickerResolving => 'Seçilen konumun adı okunuyor...';

  @override
  String get prayerTimePickerTapMap => 'Bölgeyi belirlemek için haritaya dokun';

  @override
  String get prayerTimePickerTitle => 'Bölge seç';

  @override
  String get prayerTimePickerSubtitle => 'Ara ya da haritadan bir nokta seç';

  @override
  String get prayerTimePickerUsingDevice => 'Cihaz konumu kullanılıyor...';

  @override
  String get prayerTimePickerUseDevice => 'Cihazın mevcut konumunu kullan';

  @override
  String get prayerTimePickerMapTab => 'Harita';

  @override
  String get prayerTimePickerSearchHint => 'Şehir veya ülke adı';

  @override
  String get prayerTimePickerNoResults => 'Eşleşen sonuç bulunamadı';

  @override
  String get prayerTimePickerStartTyping => 'Şehir adını yazmaya başla';

  @override
  String get prayerTimePickerTapMapToChoose =>
      'Bölge seçmek için haritaya dokun';

  @override
  String get prayerTimePickerApplying => 'Uygulanıyor';

  @override
  String get prayerTimePickerApply => 'Uygula';

  @override
  String prayerTimeCurrentLabel(String prayer) {
    return 'Şu an: $prayer';
  }

  @override
  String prayerTimeNextLabel(String prayer) {
    return 'Sıradaki: $prayer';
  }

  @override
  String get prayerTimeEnableLocation => 'Konumu aç';

  @override
  String get prayerTimeTimelineEmptyTitle =>
      'Bölge belirlenmeden namaz vakitleri gösterilemez';

  @override
  String get prayerTimeTimelineEmptySubtitle =>
      'Elle bir şehir seç ya da cihazın mevcut konumunu kullan';

  @override
  String get prayerTimeTimelineChooseArea => 'Bölge seç';

  @override
  String get prayerTimeNow => 'Şimdi';

  @override
  String get prayerTimeNextBadge => 'Sıradaki';

  @override
  String get prayerTimeRowNext => 'Sıradaki namaz';

  @override
  String get prayerTimeRowCompleted => 'Vakti geçti';

  @override
  String get prayerTimeRowLocalTime => 'Yerel saat';

  @override
  String get prayerTimeLoadingTimes => 'Vakitler yükleniyor';

  @override
  String get prayerTimeLocatingShort => 'Konum belirleniyor';

  @override
  String get prayerTimeNoticeUnavailable =>
      'Namaz vakitlerini doğru göstermek için konumu aç ya da izin ver.';

  @override
  String get prayerTimeNoticeServiceOffSaved =>
      'Vakitler son kaydedilen konuma göre. Otomatik güncellemek için konumu aç.';

  @override
  String get prayerTimeNoticeServiceOff =>
      'Konum hizmeti kapalı. Vakitleri mevcut konumuna göre görmek için aç.';

  @override
  String get prayerTimeNoticePermissionDeniedSaved =>
      'Vakitler son kaydedilen konuma göre. Şimdi güncellemek için konum erişimine izin ver.';

  @override
  String get prayerTimeNoticePermissionDenied =>
      'Konum izni verilmedi. Vakitleri mevcut konumuna göre görmek için izin ver.';

  @override
  String get prayerTimeNoticeDeniedForeverSaved =>
      'Vakitler son kaydedilen konuma göre. Konum iznini yeniden açmak için ayarları aç.';

  @override
  String get prayerTimeNoticeDeniedForever =>
      'Konum izni kalıcı olarak reddedildi. Vakitleri doğru görmek için ayarlardan aç.';

  @override
  String get prayerTimeNoticeErrorSaved =>
      'Konum şu anda güncellenemedi, bu yüzden son kaydedilen konum kullanılıyor.';

  @override
  String get prayerTimeNoticeError =>
      'Konum şu anda belirlenemedi. Vakitleri görmek için konumu aç ya da izin ver.';

  @override
  String get prayerTimeOpenSettings => 'Ayarları aç';

  @override
  String prayerTimeCountdownNow(String prayer) {
    return '$prayer vakti geldi';
  }

  @override
  String prayerTimeCountdownUnderMinute(String prayer) {
    return '$prayer vaktine bir dakikadan az kaldı';
  }

  @override
  String prayerTimeCountdownMinutes(String prayer, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes dakika',
      one: '$minutes dakika',
    );
    return '$prayer vaktine $_temp0 kaldı';
  }

  @override
  String prayerTimeCountdownHours(String prayer, int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours saat',
      one: '$hours saat',
    );
    return '$prayer vaktine $_temp0 kaldı';
  }

  @override
  String prayerTimeCountdownHoursMinutes(
      String prayer, int hours, int minutes) {
    return '$prayer vaktine $hours sa $minutes dk kaldı';
  }

  @override
  String get prayerTimeRemainingNow => 'Vakit geldi';

  @override
  String prayerTimeRemainingMinutes(int minutes) {
    return '$minutes dk kaldı';
  }

  @override
  String prayerTimeRemainingHours(int hours) {
    return '$hours sa kaldı';
  }

  @override
  String prayerTimeRemainingHoursMinutes(int hours, int minutes) {
    return '$hours sa $minutes dk kaldı';
  }

  @override
  String get prayerTimeCurrentLocationFallback => 'Mevcut konum';

  @override
  String get prayerTimeYouAreInTime => 'Şu anki vakit';

  @override
  String prayerTimeBoardHijriLine(String hijri) {
    return '$hijri · Ümmü\'l-Kurâ takvimi';
  }

  @override
  String get prayerTimeAllTimes => 'Tüm vakitler';

  @override
  String get prayerTimeMuteAthan => 'Bu namazın ezanını sustur';

  @override
  String get prayerTimeUnmuteAthan => 'Bu namazın ezanını aç';

  @override
  String get prayerTimeQuickMushaf => 'Mushaf';

  @override
  String get prayerTimeQuickPrayerTimes => 'Namaz vakitleri';

  @override
  String get prayerTimeQuickAdhkar => 'Zikir kütüphanesi';

  @override
  String get prayerTimeErrorLoad => 'Namaz vakitleri şu anda yüklenemedi';

  @override
  String get prayerTimeErrorUpdateArea => 'Seçilen bölge güncellenemedi';

  @override
  String get prayerTimeErrorApplySettings =>
      'Vakitler yeni ayarlarla güncellenemedi';

  @override
  String get prayerTimeErrorServiceOff =>
      'Konum hizmeti kapalı. Aç ya da elle bir şehir seç.';

  @override
  String get prayerTimeErrorPermission =>
      'Konum izni vermen ya da elle bir şehir seçmen gerekiyor.';

  @override
  String get prayerTimeErrorDeniedForever =>
      'Konum izni kalıcı olarak reddedildi. Ayarları aç ya da bir şehir seç.';

  @override
  String get prayerTimeErrorDeviceLocation =>
      'Cihaz konumu şu anda belirlenemedi';

  @override
  String get homeWidgetsPinFailed =>
      'Ekleme penceresi açılamadı. Ana ekrandan elle ekle.';

  @override
  String get homeWidgetsSyncSuccess => 'Widget\'lar güncellendi';

  @override
  String get homeWidgetsSyncFailed =>
      'Güncellenemedi. Konumunun belirlendiğinden emin ol.';

  @override
  String get homeWidgetsAddTooltip => 'Ana ekrana ekle';

  @override
  String get homeWidgetsTitle => 'Ana ekran widget\'ları';

  @override
  String get homeWidgetsHowToHeader => 'Nasıl eklenir';

  @override
  String homeWidgetsHowToAndroid(String appName) {
    return 'Widget\'ın yanındaki ekle düğmesine bas ya da ana ekranda boş bir alana uzun basıp «Widget\'lar» menüsüne gir ve «$appName» ara.';
  }

  @override
  String homeWidgetsHowToIos(String appName) {
    return 'Ana ekranda boş bir alana uzun bas, ardından üstteki «+» düğmesine dokun ve «$appName» ara. Sıradaki namaz widget\'ı kilit ekranında da kullanılabilir.';
  }

  @override
  String get homeWidgetsListHeader => 'Widget\'lar';

  @override
  String get homeWidgetsNextPrayerTitle => 'Sıradaki namaz';

  @override
  String get homeWidgetsNextPrayerSubtitleAndroid =>
      'Namazın adı ve vakti, canlı geri sayımla';

  @override
  String get homeWidgetsNextPrayerSubtitleIos =>
      'Küçük boy · kilit ekranında üç farklı görünüm';

  @override
  String get homeWidgetsTodayTimesTitle => 'Bugünün vakitleri';

  @override
  String get homeWidgetsTodayTimesSubtitle =>
      'Hicri tarih ve şehirle altı vakit';

  @override
  String get homeWidgetsDailyAyahTitle => 'Günün ayeti';

  @override
  String get homeWidgetsDailyAyahSubtitle => 'Her gün yenilenen kısa bir ayet';

  @override
  String get homeWidgetsSyncHeader => 'Senkronizasyon';

  @override
  String get homeWidgetsSyncNow => 'Widget\'ları şimdi güncelle';

  @override
  String homeWidgetsSyncSubtitle(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days günlük',
      one: '$days günlük',
    );
    return 'Mevcut konumun ve ayarlarınla $_temp0 vakitleri hesaplar';
  }

  @override
  String homeWidgetsSyncHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days gün',
      one: '$days gün',
    );
    return 'Widget\'lar uygulamayı açmadan $_temp0 çalışır ve arka planda otomatik yenilenir. Konumun veya hesaplama yöntemin değiştiğinde kendiliğinden güncellenir.';
  }

  @override
  String get settingsDeveloperName => 'Moatasem Alhilali';

  @override
  String get settingsUpdateStarting => 'Uygulama güncellemesi başlatılıyor...';

  @override
  String get settingsUpdateUpToDate =>
      'Uygulamanın en son sürümünü kullanıyorsun.';

  @override
  String get settingsUpdateCheckFailed =>
      'Güncellemeler kontrol edilemedi, daha sonra tekrar dene.';

  @override
  String get settingsGroupPreferences => 'Tercihler';

  @override
  String get settingsDarkModeTitle => 'Koyu tema';

  @override
  String get settingsStatusOn => 'Açık';

  @override
  String get settingsStatusOff => 'Kapalı';

  @override
  String get settingsNotificationsTitle => 'Bildirim ayarları';

  @override
  String get settingsNotificationsSubtitle =>
      'Uygulamadan gelen her bildirimi yönet';

  @override
  String get settingsDownloadsTitle => 'İndirme ayarları';

  @override
  String get settingsDownloadsSubtitle =>
      'İndirilen dosyaları ve depolama alanını yönet';

  @override
  String get settingsGroupApp => 'Uygulama';

  @override
  String get settingsCheckUpdatesTitle => 'Güncellemeleri kontrol et';

  @override
  String get settingsCheckUpdatesSubtitle =>
      'En son sürümü kullandığından emin ol';

  @override
  String get settingsAboutUsTitle => 'Hakkımızda';

  @override
  String get settingsAboutUsSubtitle =>
      'Tamaneena uygulamasını ve amacını tanı';

  @override
  String get settingsRateAppTitle => 'Uygulamayı değerlendir';

  @override
  String get settingsRateAppSubtitle =>
      'Mağazada puan vererek hayrın yayılmasına katkıda bulun';

  @override
  String get settingsGroupPrivacy => 'Gizlilik ve güvenlik';

  @override
  String get settingsPrivacyPolicyTitle => 'Gizlilik politikası';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Uygulama verilerini ve izinlerini nasıl kullanıyor';

  @override
  String get settingsDataSafetyTitle => 'Veri güvenliği';

  @override
  String get settingsDataSafetySubtitle =>
      'Veriler, izinler ve nasıl kullanıldıklarına dair özet';

  @override
  String get settingsGroupDeveloper => 'Geliştirici';

  @override
  String get settingsAboutDeveloperTitle => 'Geliştirici hakkında';

  @override
  String get settingsAboutDeveloperSubtitle =>
      'Geliştiricinin bilgileri ve iletişim bağlantıları';

  @override
  String get settingsDeveloperContactSubtitle =>
      'Web sitesi veya WhatsApp üzerinden doğrudan iletişim';

  @override
  String get settingsPersonalWebsite => 'Kişisel web sitesi';

  @override
  String get settingsGroupFollowNews => 'Son haberleri takip et';

  @override
  String get settingsSocialTelegram => 'Telegram';

  @override
  String get settingsSocialWhatsapp => 'WhatsApp';

  @override
  String get settingsSocialFacebook => 'Facebook';

  @override
  String get settingsSocialInstagram => 'Instagram';

  @override
  String get settingsSocialTwitter => 'X (Twitter)';

  @override
  String get settingsPrivacyIntro =>
      'Uygulamanın verilerini nasıl kullandığına dair açık ve kısa bilgiler.';

  @override
  String get settingsPrivacyMattersTitle => 'Gizliliğin bizim için önemli';

  @override
  String get settingsPrivacyMattersBody =>
      'Tamaneena\'da uygulama deneyiminin açık ve güvenli olmasına özen gösteriyoruz. Yalnızca uygulamanın özelliklerini çalıştırmak ve geliştirmek için gerekli verileri kullanıyoruz; kullanıcı verilerini satmıyor veya reklam amacıyla paylaşmıyoruz.';

  @override
  String get settingsPrivacyDataUsedTitle =>
      'Uygulamanın kullanabileceği veriler';

  @override
  String get settingsPrivacyDataUsedBody =>
      'Uygulama; namaz vakitlerini ve kıbleyi hesaplamak için konumu, ezan ve zikir uyarıları için bildirimleri, indirilen içerik ve yerel ayarları saklamak için depolamayı, kişileri ise yalnızca Sabah Arkadaşı gibi kullanıcının açtığı özelliklerde kullanabilir.';

  @override
  String get settingsPrivacyControlTitle => 'Verilerinin kontrolü';

  @override
  String get settingsPrivacyControlBody =>
      'Bildirimleri uygulama içindeki bildirim ayarlarından kapatabilir veya düzenleyebilir, sistem izinlerini istediğin zaman cihaz ayarlarından yönetebilirsin.';

  @override
  String get settingsPrivacyThirdPartyTitle => 'Üçüncü taraf hizmetler';

  @override
  String get settingsPrivacyThirdPartyBody =>
      'Uygulama, ayarları güncellemek ve genel bildirimler göndermek için Firebase Remote Config ve Firebase Messaging gibi hizmetleri kullanabilir. Bu hizmetler yalnızca uygulamayı çalıştırmak ve deneyimi iyileştirmek için kullanılır.';

  @override
  String get settingsDataSafetyIntro =>
      'Uygulamanın kullandığı verilerin ve bunların nasıl saklanıp paylaşıldığının özeti.';

  @override
  String get settingsDataSafetySensitiveTitle => 'Hassas veriler';

  @override
  String get settingsDataSafetySensitiveBody =>
      'Uygulama, kullanıcının seçtiği belirli bir özellik gerektirmedikçe hassas veri istemez. Uyarı saatleri, tercihler ve okuma planları gibi bazı veriler cihazda yerel olarak saklanır.';

  @override
  String get settingsDataSafetyLocationTitle => 'Konum';

  @override
  String get settingsDataSafetyLocationBody =>
      'Konum; namaz vakitlerini, kıble yönünü ve konuma dayalı hizmetleri hesaplamak için kullanılır. Kullanıcı konum iznini sistem ayarlarından kapatabilir.';

  @override
  String get settingsDataSafetyNotificationsTitle => 'Bildirimler';

  @override
  String get settingsDataSafetyNotificationsBody =>
      'Uygulama bildirimleri ezan, zikirler, hatırlatıcılar ve bazı genel uygulama mesajları için kullanır. Her bildirim türü bildirim ayarları sayfasından yönetilebilir.';

  @override
  String get settingsDataSafetyStorageTitle => 'Depolama ve indirme';

  @override
  String get settingsDataSafetyStorageBody =>
      'Uygulama, kullanıcının indirmeyi seçtiği ses kayıtları veya uygulamadaki içerikler gibi dosyaları saklamak için depolamayı kullanabilir.';

  @override
  String get settingsDataSafetySharingTitle => 'Paylaşım';

  @override
  String get settingsDataSafetySharingBody =>
      'Kişisel verilerin satış veya pazarlama amacıyla üçüncü taraflarla paylaşılmaz. Yapılan her paylaşım, gerekli işletim hizmetleri kapsamında ya da kullanıcının başlattığı bir işlemle olur.';

  @override
  String get settingsAboutAppBody =>
      'Namaz, zikir, Kur\'an tilaveti ve günlük virdine huzurla, kullanıcıya yakın bir üslupla devam etmene yardımcı olan bir Kur\'an ve ibadet uygulaması.';

  @override
  String get settingsAboutMissionTitle => 'Amacımız';

  @override
  String get settingsAboutMissionBody =>
      'Kullanıcıya rahatsız etmeden ibadette yardımcı olan hafif bir yol arkadaşı olmak; Mushaf, zikirler, namaz vakitleri, hatırlatıcılar ve aile için yardımcı özellikler gibi önemli günlük araçları bir araya getirmek.';

  @override
  String get settingsAboutOfferTitle => 'Sunduklarımız';

  @override
  String get settingsAboutOfferBody =>
      'Mushaf, zikirler, namaz vakitleri, kıble, günlük vird, widget\'lar, Sabah Arkadaşı, Küçük Müslüman, yolcu hizmetleri ve kullanıcının ihtiyacına göre özelleştirilebilen hatırlatıcılar.';

  @override
  String get settingsDeveloperHeroBody =>
      '7 yılı aşkın deneyime sahip Full Stack ve Mobile yazılım mühendisi; Flutter, Laravel, Next.js ve web ile mobil için üretim seviyesinde uygulamalar geliştirme konusunda uzman.';

  @override
  String get settingsDeveloperBioTitle => 'Kısaca';

  @override
  String get settingsDeveloperBioBody =>
      'Moatasem Alhilali, gerçek kullanıcılara hizmet eden uygulamalar ve dijital platformlar geliştiriyor; özellikle mobil uygulamalar, arka uç sistemleri, kullanıcı arayüzleri ile Fintech ve SaaS platformlarına ilgi duyuyor.';

  @override
  String get settingsDeveloperFieldsTitle => 'Çalışma alanları';

  @override
  String get settingsDeveloperFieldsBody =>
      'Flutter, Laravel, Next.js, React, API Development, mobil uygulamalar, web uygulamaları, Fintech çözümleri ve SaaS platformları.';

  @override
  String get settingsDeveloperContactTitle => 'İletişim yolları';

  @override
  String get settingsContactWebsite => 'Web sitesi';

  @override
  String get settingsContactEmail => 'E-posta';

  @override
  String get settingsAppLinksTitle => 'Uygulama bağlantıları';

  @override
  String get notifSettingsLabelAppNotifications => 'Uygulama bildirimleri';

  @override
  String get notifSettingsLabelAllAthan => 'Tüm ezan bildirimleri';

  @override
  String notifSettingsAthanOf(String prayer) {
    return '$prayer ezanı';
  }

  @override
  String get notifSettingsLabelMiddleNight => 'Gece namazı';

  @override
  String get notifSettingsLabelThikrMorning => 'Sabah zikirleri';

  @override
  String get notifSettingsLabelThikrEvening => 'Akşam zikirleri';

  @override
  String get notifSettingsLabelThikrWakeUp => 'Uyanma zikirleri';

  @override
  String get notifSettingsLabelThikrSleep => 'Uyku zikirleri';

  @override
  String get notifSettingsLabelSalawat => 'Hz. Muhammed\'e ﷺ salavat';

  @override
  String get notifSettingsLabelRandomAudioThikr => 'Rastgele sesli zikirler';

  @override
  String get notifSettingsLabelFloatingAdhkar =>
      'Yüzen zikirler ve alternatif hatırlatıcılar';

  @override
  String get notifSettingsLabelDailyQuranWird => 'Günlük Kur\'an virdi';

  @override
  String get notifSettingsLabelReadSurahMulk => 'Mülk Suresi\'ni oku';

  @override
  String get notifSettingsLabelReadSpecificSurah => 'Belirli bir sureyi oku';

  @override
  String get notifSettingsLabelReadSurahKahf => 'Kehf Suresi\'ni oku';

  @override
  String get notifSettingsLabelFasting => 'Oruç hatırlatıcısı';

  @override
  String get notifSettingsLabelFastingMonday => 'Pazartesi orucu';

  @override
  String get notifSettingsLabelFastingThursday => 'Perşembe orucu';

  @override
  String get notifSettingsLabelBestDua =>
      'Allah katında en sevimli ve etkisi büyük dualardan';

  @override
  String get notifSettingsLabelWirdMorning => 'Sabah virdi';

  @override
  String get notifSettingsLabelWirdEvening => 'Akşam virdi';

  @override
  String get notifSettingsLabelWirdNight => 'Uyku öncesi vird';

  @override
  String get notifSettingsLabelWirdSummary => 'Günlük vird özeti';

  @override
  String get notifSettingsLabelYoungMuslim => 'Küçük Müslüman hatırlatıcısı';

  @override
  String get notifSettingsLabelQuranPlan => 'Kur\'an planı hatırlatıcısı';

  @override
  String get notifSettingsLabelGeneral => 'Genel uygulama bildirimleri';

  @override
  String get notifSettingsTitleRandomThikr => 'Rastgele zikir';

  @override
  String get notifSettingsTitleFloatingAdhkar => 'Yüzen zikirler';

  @override
  String get notifSettingsTitlePrayerAthan => 'Namaz ezanı';

  @override
  String get notifSettingsBodyThikrMorning => 'Sabah zikirlerini unutma!';

  @override
  String get notifSettingsBodyThikrEvening => 'Akşam zikirlerini unutma!';

  @override
  String get notifSettingsBodyMiddleNight =>
      'Gece namazı vakti; gecenin son üçte birini değerlendir.';

  @override
  String get notifSettingsBodySalawat =>
      'Peygamber Efendimiz\'e ﷺ salavat getir, günün bereketlensin.';

  @override
  String get notifSettingsBodyRememberAllah =>
      'Allah\'ı an ki O da seni ansın!';

  @override
  String get notifSettingsBodyReadQuran => 'Günlük Kur\'an virdine vakit ayır.';

  @override
  String get notifSettingsBodyReadSurahMulk =>
      'Bu gece Mülk Suresi\'ni okumayı unutma.';

  @override
  String get notifSettingsBodyThikrSleep => 'Uyumadan önce uyku zikirleri.';

  @override
  String get notifSettingsBodyThikrWakeUp =>
      'Uyanınca gününe Allah\'ı anarak başla.';

  @override
  String get notifSettingsBodyReadSurah =>
      'Bugün seçtiğin sureyi okumayı unutma.';

  @override
  String get notifSettingsBodyReadSurahKahf =>
      'Cuma günü Kehf Suresi\'ni okumayı unutma.';

  @override
  String get notifSettingsBodyFasting => 'Nafile oruç hatırlatması.';

  @override
  String get notifSettingsBodyFastingMonday => 'Pazartesi orucu hatırlatması.';

  @override
  String get notifSettingsBodyFastingThursday => 'Perşembe orucu hatırlatması.';

  @override
  String get notifSettingsBodyAthanTime => 'Ezan vakti geldi.';

  @override
  String get notifSettingsBodyWirdMorning => 'Gününe ibadet azığınla başla.';

  @override
  String get notifSettingsBodyWirdEvening =>
      'Akşam virdinle Allah\'a bağını tazele.';

  @override
  String get notifSettingsBodyWirdNight => 'Gününü zikir ve duayla bitir.';

  @override
  String get notifSettingsBodyWirdSummary =>
      'Bugünkü ibadet azığını gözden geçir.';

  @override
  String get notifSettingsBodyYoungMuslim =>
      'Küçük Müslüman içeriğine dönme hatırlatması.';

  @override
  String get notifSettingsBodyQuranPlan =>
      'Kur\'an planındaki bugünkü oturumu unutma.';

  @override
  String get notifSettingsBodyGeneral =>
      'Tamaneena uygulamasından genel bildirimler ve uyarılar.';

  @override
  String get notifSettingsAllPrayers => 'Tüm namazlar';

  @override
  String get notifSettingsSalawatShort => 'Salavat';

  @override
  String get notifSettingsQuranWirdShort => 'Kur\'an virdi';

  @override
  String get notifSettingsGroupGeneral => 'Genel';

  @override
  String get notifSettingsGroupAthan => 'Ezan';

  @override
  String get notifSettingsGroupDailyWird => 'Günlük vird';

  @override
  String get notifSettingsGroupAdhkar => 'Zikirler';

  @override
  String get notifSettingsGroupQuran => 'Kur\'an';

  @override
  String get notifSettingsGroupAppSections => 'Uygulama bölümleri';

  @override
  String get notifSettingsGroupNightAndWaking => 'Gece ve uyanış';

  @override
  String get notifSettingsGroupFasting => 'Oruç';

  @override
  String get notifSettingsGroupRecurringAdhkar => 'Tekrarlanan zikirler';

  @override
  String get notifSettingsGroupSystem => 'Sistem';

  @override
  String get notifSettingsMasterTitle => 'Tüm uygulama bildirimleri';

  @override
  String get notifSettingsMasterOnSubtitle =>
      'Bildirimler açık; her türü aşağıdan ayarlayabilirsin';

  @override
  String get notifSettingsMasterOffSubtitle =>
      'Bu anahtarı açana kadar tüm bildirimler kapalı';

  @override
  String get notifSettingsSystemTitle => 'Sistem bildirimleri';

  @override
  String get notifSettingsSystemSubtitle =>
      'Cihazındaki planlanmış ve etkin bildirimleri gör';

  @override
  String get notifSettingsStatusStopped => 'Kapalı';

  @override
  String get notifSettingsStatusEnabled => 'Açık';

  @override
  String notifSettingsSummaryDaily(String time) {
    return 'Her gün · $time';
  }

  @override
  String notifSettingsSummaryHourly(int minute) {
    return 'Her saat, $minute. dakikada';
  }

  @override
  String notifSettingsSummaryEveryNMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Her $count dakikada',
      one: 'Her $count dakikada',
    );
    return '$_temp0';
  }

  @override
  String get notifSettingsListSeparator => ', ';

  @override
  String get notifSettingsNoDaysSelected => 'Belirli gün yok';

  @override
  String notifSettingsSummaryWeekly(String days, String time) {
    return 'Haftalık ($days) · $time';
  }

  @override
  String notifSettingsSummaryCustom(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Özel plan · $count saat',
      one: 'Özel plan · $count saat',
      zero: 'Özel plan · saat yok',
    );
    return '$_temp0';
  }

  @override
  String get notifSettingsScheduleTimesTooltip => 'Hatırlatma saatleri';

  @override
  String get notifSettingsEditScheduleTitle => 'Planı düzenle';

  @override
  String get notifSettingsEditScheduleSubtitle =>
      'Tekrar türünü ve hatırlatma saatini değiştir';

  @override
  String get notifSettingsExtraSchedulesTitle => 'Ek saatleri yönet';

  @override
  String get notifSettingsExtraSchedulesSubtitle =>
      'Bu bildirim için birden fazla saat ekle';

  @override
  String get notifScheduleBodyAllAthan =>
      'Tüm ezan uyarıları belirlenen vakitlerde tekrarlanacak.';

  @override
  String get notifScheduleBodyAthanFajr =>
      'Sabah ezanı vakti geldi, namaza koş.';

  @override
  String get notifScheduleBodyAthanDhuhr => 'Öğle ezanı vakti geldi.';

  @override
  String get notifScheduleBodyAthanAsr => 'İkindi ezanı vakti geldi.';

  @override
  String get notifScheduleBodyAthanMaghrib => 'Akşam ezanı vakti geldi.';

  @override
  String get notifScheduleBodyAthanIsha => 'Yatsı ezanı vakti geldi.';

  @override
  String get notifScheduleBodyMiddleNight =>
      'Gece namazı vakti! Kalk ve Rahman\'a yakar.';

  @override
  String get notifScheduleBodyThikrMorning => 'Sabah zikirlerini unutma!';

  @override
  String get notifScheduleBodyThikrEvening => 'Akşam zikirlerini unutma!';

  @override
  String get notifScheduleBodySalawat =>
      'Peygamber Efendimiz\'e ﷺ salavat getir, sana on sevap yazılsın.';

  @override
  String get notifScheduleBodyReadQuran => 'Bugünkü Kur\'an virdini unutma.';

  @override
  String get notifScheduleBodyReadSurahMulk =>
      'Uyumadan önce Mülk Suresi\'ni oku.';

  @override
  String get notifScheduleBodyThikrSleep =>
      'Uyumadan önce uyku zikirlerini oku.';

  @override
  String get notifScheduleBodyThikrWakeUp =>
      'Gününe uyanma zikirleriyle başla.';

  @override
  String get notifScheduleBodyReadSurah =>
      'Bugün için belirlenen sureyi okumayı unutma.';

  @override
  String get notifScheduleBodyReadSurahKahf => 'Cuma günü Kehf Suresi\'ni oku.';

  @override
  String get notifScheduleBodyFasting =>
      'Nafile orucun sevabı büyüktür, fırsatı kaçırma.';

  @override
  String get notifScheduleTitleRandomThikr => 'Özel planlı rastgele zikirler';

  @override
  String get notifScheduleValidateTime => 'Önce hatırlatma saatini belirle';

  @override
  String get notifScheduleValidateMinute =>
      'Her saatin kaçıncı dakikası olduğunu belirle';

  @override
  String get notifScheduleValidateWeekday => 'Haftanın en az bir gününü seç';

  @override
  String get notifScheduleValidateInterval =>
      'Dakika sayısını gir (sıfırdan büyük)';

  @override
  String get notifScheduleValidateDate => 'En az bir tarih ekle';

  @override
  String get notifScheduleDetails => 'Ayrıntılar';

  @override
  String get notifScheduleMinuteOfHourTitle => 'Her saatin dakikası';

  @override
  String get notifScheduleMinuteOfHourSubtitle => '0 ile 59 arasında bir sayı';

  @override
  String get notifScheduleMinuteUnit => 'dakika';

  @override
  String get notifScheduleRepeatTitle => 'Tekrar';

  @override
  String get notifScheduleRepeatSubtitle =>
      'Her hatırlatma ile sonraki arasındaki süre';

  @override
  String get notifScheduleCustomTime => 'Özel saat';

  @override
  String get notifScheduleDeleteTime => 'Saati sil';

  @override
  String get notifScheduleNoTimesYet => 'Henüz saat eklemedin';

  @override
  String get notifScheduleAddTime => 'Saat ekle';

  @override
  String get notifScheduleSaveSchedule => 'Planı kaydet';

  @override
  String get notifScheduleAddNewTitle => 'Yeni saat ekle';

  @override
  String get notifScheduleEditTitle => 'Saati düzenle';

  @override
  String get notifScheduleOptionalLabel => 'İsteğe bağlı açıklama';

  @override
  String get notifScheduleAddConfirm => 'Saati ekle';

  @override
  String get notifScheduleSaveEdit => 'Değişikliği kaydet';

  @override
  String get notifScheduleTypeDaily => 'Günlük';

  @override
  String get notifScheduleTypeHourly => 'Saatlik';

  @override
  String get notifScheduleTypeEveryNMinutes => 'Birkaç dakikada bir';

  @override
  String get notifScheduleTypeWeekly => 'Haftalık';

  @override
  String get notifScheduleTypeCustomDates => 'Özel tarihler';

  @override
  String get notifScheduleTypeDailyDesc => 'Her gün aynı saatte tekrarlanır';

  @override
  String get notifScheduleTypeHourlyDesc =>
      'Her saat belirli bir dakikada tekrarlanır';

  @override
  String get notifScheduleTypeEveryNMinutesDesc =>
      'Belirlediğin aralıklarla tekrarlanır';

  @override
  String get notifScheduleTypeWeeklyDesc =>
      'Haftanın belirli günlerinde tekrarlanır';

  @override
  String get notifScheduleTypeCustomDatesDesc =>
      'Seçtiğin tarih ve saatlerde görünür';

  @override
  String get notifScheduleTypeTitle => 'Plan türü';

  @override
  String get notifScheduleTimeTitle => 'Hatırlatma saati';

  @override
  String get notifScheduleTimeSubtitle => 'Saat ve dakikayı seçmek için dokun';

  @override
  String get notifScheduleLabelHint => 'Bu saat için kısa bir açıklama ekle';

  @override
  String notifScheduleRowDaily(String time) {
    return 'Her gün · $time';
  }

  @override
  String notifScheduleRowWeekly(String days, String time) {
    return '$days · $time';
  }

  @override
  String get notifScheduleNoDays => 'Gün yok';

  @override
  String notifScheduleRowCustom(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count özel saat',
      one: '$count özel saat',
      zero: 'Özel saat yok',
    );
    return '$_temp0';
  }

  @override
  String get notifScheduleDayShort1 => 'Pzt';

  @override
  String get notifScheduleDayShort2 => 'Sal';

  @override
  String get notifScheduleDayShort3 => 'Çar';

  @override
  String get notifScheduleDayShort4 => 'Per';

  @override
  String get notifScheduleDayShort5 => 'Cum';

  @override
  String get notifScheduleDayShort6 => 'Cmt';

  @override
  String get notifScheduleDayShort7 => 'Paz';

  @override
  String get notifScheduleAllDays => 'Tüm günler';

  @override
  String get notifScheduleWorkDays => 'İş günleri';

  @override
  String get notifScheduleWeekend => 'Hafta sonu';

  @override
  String get notifScheduleClear => 'Temizle';

  @override
  String get notifScheduleStatTotal => 'Toplam';

  @override
  String get notifScheduleStatEnabled => 'Açık';

  @override
  String get notifScheduleStatStopped => 'Kapalı';

  @override
  String get notifScheduleUnexpectedError => 'Beklenmeyen bir hata oluştu';

  @override
  String get notifScheduleSaved => 'Kaydedildi';

  @override
  String get notifScheduleScreenTitle => 'Bildirim saatleri';

  @override
  String get notifScheduleListTitle => 'Saatler';

  @override
  String get notifScheduleEmpty =>
      'Henüz saat yok — «Saat ekle» düğmesinden bir saat ekle.';

  @override
  String get notifScheduleDeleteTitle => 'Saati sil';

  @override
  String get notifScheduleDeleteMessage =>
      'Bu saati silmek istediğine emin misin?\nBuna bağlı tüm bildirimler iptal edilecek.';

  @override
  String get notifScheduleSaving => 'Kaydediliyor...';

  @override
  String get notifScheduleLoading => 'Saatler yükleniyor...';

  @override
  String notifScheduleLoadFailed(String error) {
    return 'Saatler yüklenemedi: $error';
  }

  @override
  String get notifScheduleAdded => 'Saat eklendi';

  @override
  String notifScheduleAddFailed(String error) {
    return 'Saat eklenemedi: $error';
  }

  @override
  String get notifScheduleUpdated => 'Saat güncellendi';

  @override
  String notifScheduleUpdateFailed(String error) {
    return 'Saat güncellenemedi: $error';
  }

  @override
  String get notifScheduleDeleted => 'Saat silindi';

  @override
  String notifScheduleDeleteFailed(String error) {
    return 'Saat silinemedi: $error';
  }

  @override
  String get notifScheduleActivated => 'Saat etkinleştirildi';

  @override
  String get notifScheduleDeactivated => 'Saat devre dışı bırakıldı';

  @override
  String notifScheduleToggleFailed(String error) {
    return 'Saatin durumu değiştirilemedi: $error';
  }

  @override
  String get notifSettingsScheduledGroup => 'Planlanmış';

  @override
  String get notifSettingsNoScheduled => 'Şu anda planlanmış bildirim yok';

  @override
  String get notifSettingsShownNowGroup => 'Şu an görünen';

  @override
  String get notifSettingsNoShown => 'Bildirim çubuğunda görünen bildirim yok';

  @override
  String get notifSettingsUntitled => 'Başlıksız bildirim';

  @override
  String get notifSettingsDismiss => 'Bildirimi gizle';

  @override
  String get notifSettingsCancelNotification => 'Bildirimi iptal et';

  @override
  String notifSettingsAthanTicker(String prayer) {
    return '$prayer ezanı vakti geldi';
  }

  @override
  String get downloadTitle => 'İndirilenler';

  @override
  String get downloadEmptyAll =>
      'Henüz indirme yok; başlamak için bir indirme ekle.';

  @override
  String get downloadEmptyActive => 'Etkin indirme yok';

  @override
  String get downloadEmptyCompleted => 'Tamamlanan indirme yok';

  @override
  String get downloadEmptyPaused => 'Duraklatılan indirme yok';

  @override
  String get downloadEmptyFailed => 'Başarısız indirme yok';

  @override
  String get downloadCancelAll => 'Tümünü iptal et';

  @override
  String get downloadCancelAllConfirm =>
      'Tüm etkin indirmeleri iptal etmek istediğine emin misin?';

  @override
  String get downloadAdd => 'İndirme ekle';

  @override
  String get downloadFilterAll => 'Tümü';

  @override
  String get downloadStatusActive => 'Etkin';

  @override
  String get downloadStatusCompleted => 'Tamamlandı';

  @override
  String get downloadStatusPaused => 'Duraklatıldı';

  @override
  String get downloadStatusFailed => 'Başarısız';

  @override
  String get downloadStarted => 'İndirme başladı';

  @override
  String get downloadAddNewTitle => 'Yeni indirme ekle';

  @override
  String get downloadUrlLabel => 'Dosya bağlantısı';

  @override
  String get downloadUrlRequired => 'Lütfen indirme bağlantısını gir';

  @override
  String get downloadUrlInvalid => 'Lütfen geçerli bir bağlantı gir';

  @override
  String get downloadFileNameLabel => 'Dosya adı';

  @override
  String get downloadOptional => 'İsteğe bağlı';

  @override
  String get downloadPublicStorageTitle => 'Genel depolama';

  @override
  String get downloadPublicStorageSubtitle => 'İndirilenler klasörüne kaydet';

  @override
  String get downloadAllowCellularTitle => 'Mobil veriye izin ver';

  @override
  String get downloadAllowCellularSubtitle => 'Mobil veri üzerinden indir';

  @override
  String get downloadStart => 'İndirmeyi başlat';

  @override
  String get downloadPause => 'Duraklat';

  @override
  String get downloadResume => 'Devam et';

  @override
  String get downloadOpenFile => 'Dosyayı aç';

  @override
  String get downloadRemoveFromList => 'Listeden kaldır';

  @override
  String get downloadDeleteFile => 'Dosyayı sil';

  @override
  String get downloadTotal => 'Toplam';

  @override
  String get downloadInProgressNow => 'Şu an indiriliyor';

  @override
  String downloadAndMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 've $count indirme daha',
      one: 've $count indirme daha',
    );
    return '$_temp0';
  }

  @override
  String get widgetLabelNextPrayer => 'Sıradaki namaz';

  @override
  String get widgetLabelDailyAyah => 'Günün ayeti';

  @override
  String get widgetLabelOpenApp => 'Tamaneena\'yı aç';

  @override
  String get widgetLabelSetLocation => 'Uygulamada konumunu belirle';

  @override
  String get widgetLabelRefreshNeeded => 'Vakitleri güncellemek için';

  @override
  String widgetLabelNextIn(String prayer) {
    return '$prayer vaktine';
  }

  @override
  String get dailyWirdTitle => 'Günlük Vird';

  @override
  String get dailyWirdSettingsTooltip => 'Vird ayarları';

  @override
  String get dailyWirdUnexpectedError => 'Beklenmeyen bir hata oluştu.';

  @override
  String get dailyWirdRemindersHeader => 'Hatırlatıcılar';

  @override
  String get dailyWirdReminderSleepLabel => 'Uyku zikirleri';

  @override
  String get dailyWirdProgramHeader => 'Program';

  @override
  String get dailyWirdSaveSetup => 'Kurulumu kaydet';

  @override
  String get dailyWirdSetupFailed => 'Günlük vird kurulamadı.';

  @override
  String get dailyWirdItemNotFound => 'Vird öğesi bulunamadı.';

  @override
  String get dailyWirdTodayTasksHeader => 'Bugünün amelleri';

  @override
  String dailyWirdStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Devamlılık: $count gün',
      one: 'Devamlılık: $count gün',
      zero: 'Devamlılık: 0 gün',
    );
    return '$_temp0';
  }

  @override
  String dailyWirdWeeklyAdherence(int percent) {
    return 'Haftalık devamlılık %$percent';
  }

  @override
  String get dailyWirdChoosePresetTitle => 'Günlük virdini seç';

  @override
  String get dailyWirdChoosePresetSubtitle =>
      'Hazır bir programla başla, sonra dilediğin gibi özelleştir';

  @override
  String get dailyWirdItemOptions => 'Amel seçenekleri';

  @override
  String get dailyWirdEditTargetCount => 'Hedef sayıyı düzenle';

  @override
  String get dailyWirdStartOver => 'Baştan başla';

  @override
  String get dailyWirdMoveUp => 'Yukarı taşı';

  @override
  String get dailyWirdMoveDown => 'Aşağı taşı';

  @override
  String get dailyWirdHideItem => 'Virdden gizle';

  @override
  String get dailyWirdCountHint => 'Örnek: 50 kez';

  @override
  String get dailyWirdTimeMorning => 'Sabah';

  @override
  String get dailyWirdTimeEvening => 'Akşam';

  @override
  String get dailyWirdTimeNight => 'Gece';

  @override
  String get dailyWirdTimeAny => 'Her an';

  @override
  String get dailyWirdTimeMorningLong => 'Sabah vakti';

  @override
  String get dailyWirdTimeEveningLong => 'Akşam vakti';

  @override
  String get dailyWirdTimeNightLong => 'Uyumadan önce';

  @override
  String get dailyWirdTimeAnyLong => 'Herhangi bir vakitte';

  @override
  String get dailyWirdTypeDhikrSet => 'Zikirler';

  @override
  String get dailyWirdTypeCountedDhikr => 'Sayılı zikir';

  @override
  String get dailyWirdTypeQuran => 'Kur\'an virdi';

  @override
  String get dailyWirdTypeDua => 'Dua';

  @override
  String get dailyWirdTypeSurah => 'Sure';

  @override
  String dailyWirdCountProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String dailyWirdCompletedOf(int done, int total, String unit) {
    return 'Tamamlanan: $done / $total$unit';
  }

  @override
  String get dailyWirdItemDone => 'Tamamlandı';

  @override
  String get dailyWirdMarkComplete => 'Tamamla';

  @override
  String get dailyWirdCountOnce => 'Bir kez say';

  @override
  String get dailyWirdCompleteThis => 'Bu ameli tamamla';

  @override
  String get dailyWirdUncomplete => 'Tamamlamayı geri al';

  @override
  String get dailyWirdReminderMorningTitle => 'Sabah virdi';

  @override
  String get dailyWirdReminderMorningBody =>
      'Gününe Allah\'ı anarak, Kitabını okuyarak ve dua ederek başla.';

  @override
  String get dailyWirdReminderEveningTitle => 'Akşam virdi';

  @override
  String get dailyWirdReminderEveningBody =>
      'Allah ile bağını tazele, akşam virdinden kolayına geleni tamamla.';

  @override
  String get dailyWirdReminderNightTitle => 'Uyku öncesi vird';

  @override
  String get dailyWirdReminderNightBody =>
      'Gününü zikir, dua ve virdinden kalanlarla bitir.';

  @override
  String get dailyWirdReminderSummaryTitle => 'Gün sonu muhasebesi';

  @override
  String get dailyWirdReminderSummaryBody =>
      'Bugünkü virdini gözden geçir, neleri tamamladığına bak.';

  @override
  String get wirdMorningAdhkar => 'Sabah zikirleri';

  @override
  String get wirdEveningAdhkar => 'Akşam zikirleri';

  @override
  String get wirdMorningTitle => 'Sabah virdi';

  @override
  String get wirdEveningTitle => 'Akşam virdi';

  @override
  String get wirdSearchHint => 'Zikir ara';

  @override
  String wirdPagerPosition(int current, int total) {
    return 'Zikir $current / $total';
  }

  @override
  String get wirdPrevious => 'Önceki';

  @override
  String get wirdNext => 'Sonraki';

  @override
  String get wirdShowSingle => 'Tek tek göster';

  @override
  String get wirdShowList => 'Liste halinde göster';

  @override
  String get wirdTypeMorningOnly => 'Yalnızca sabah';

  @override
  String get wirdTypeEveningOnly => 'Yalnızca akşam';

  @override
  String get wirdTypeBoth => 'Sabah ve akşam';

  @override
  String get wirdNoAudio => 'Ses dosyası yok';

  @override
  String get wirdPause => 'Duraklat';

  @override
  String get wirdReplay => 'Yeniden oynat';

  @override
  String get wirdPlayAudio => 'Sesi oynat';

  @override
  String wirdRemaining(int remaining, int total) {
    return 'Kalan: $remaining / $total';
  }

  @override
  String get wirdCompleted => 'Tamamladın';

  @override
  String get wirdResetCount => 'Sayacı sıfırla';

  @override
  String get wirdCopyDhikr => 'Zikri kopyala';

  @override
  String get wirdSource => 'Kaynak';

  @override
  String get wirdShowDetails => 'Ayrıntıları göster';

  @override
  String get wirdHideDetails => 'Ayrıntıları gizle';

  @override
  String get wirdVirtue => 'Fazileti';

  @override
  String get wirdHadithText => 'Hadis metni';

  @override
  String get wirdWordExplanations => 'Seçili kelimelerin açıklaması';

  @override
  String get wirdReadOnce => 'Bir kez okudum';

  @override
  String get wirdPlayAll => 'Virdin tamamını oynat';

  @override
  String get wirdPreparingAudio => 'Ses hazırlanıyor';

  @override
  String get wirdReplayAll => 'Virdi yeniden oynat';

  @override
  String get wirdPlayAllFinished => 'Tüm zikirlerin oynatılması bitti.';

  @override
  String get wirdNowPlaying => 'Şimdi okunuyor';

  @override
  String wirdRepeatProgress(int current, int total) {
    return 'Tekrar $current / $total';
  }

  @override
  String get thikrLibraryTitle => 'Zikir kütüphanesi';

  @override
  String get thikrGroupDaily => 'Günlük zikirlerin';

  @override
  String get thikrMorningSubtitle =>
      'Sabah namazından kuşluk vaktine kadar virdin';

  @override
  String get thikrEveningSubtitle => 'İkindiden geceye kadar virdin';

  @override
  String get thikrSleepTitle => 'Uyku ve rüya zikirleri';

  @override
  String get thikrSleepSubtitle => 'Uyumadan önce ve uykuda korkunca okunanlar';

  @override
  String get thikrPrayerJumuahTitle => 'Namaz ve Cuma zikirleri';

  @override
  String get thikrPrayerJumuahSubtitle =>
      'Ezan, namaz sonrası ve Cuma günü zikirleri';

  @override
  String get thikrGroupDuas => 'Me\'sur dualar';

  @override
  String get thikrQuranicDuasTitle => 'Kur\'an\'daki dualar';

  @override
  String get thikrQuranicDuasSubtitle =>
      'Allah\'ın Kitabı\'nda geçen peygamber duaları';

  @override
  String get thikrComprehensiveDuasTitle => 'Kapsamlı dualar';

  @override
  String get thikrComprehensiveDuasSubtitle =>
      'Dünya ve ahiret hayrını toplayan dualar';

  @override
  String get thikrHajjTitle => 'Hac ve umre duaları';

  @override
  String get thikrHajjSubtitle =>
      'İhram, tavaf, say ve mukaddes mekânlardaki dualar';

  @override
  String get thikrFuneralTitle => 'Ölü ve cenaze duaları';

  @override
  String get thikrFuneralSubtitle =>
      'Cenaze namazında ve kabir başında okunanlar';

  @override
  String get thikrGroupTools => 'Araçların';

  @override
  String get thikrTasbeehTitle => 'Tesbih';

  @override
  String get thikrTasbeehSubtitle =>
      'Tesbihlerini sayan ve günlük toplamını saklayan sayaç';

  @override
  String get thikrMyDuasSubtitle => 'Kendi eklediğin dualar tek bir yerde';

  @override
  String get thikrSliderSubtitle => 'Bu vaktin virdi, şimdi aç';

  @override
  String get afterPrayerTitle => 'Namaz sonrası zikirler';

  @override
  String get afterPrayerSubtitle => 'Namazdan sonra okunan zikirler';

  @override
  String get afterPrayerSearchHint => 'Zikir ara';

  @override
  String afterPrayerFallbackTitle(int number) {
    return 'Namaz sonrası zikir $number';
  }

  @override
  String afterPrayerRepeatCountLine(int count) {
    return 'Tekrar sayısı: $count';
  }

  @override
  String afterPrayerVirtueLine(String virtue) {
    return 'Fazileti: $virtue';
  }

  @override
  String get afterPrayerRepeatLabel => 'Tekrar';

  @override
  String get afterPrayerVirtueLabel => 'Fazilet';

  @override
  String get afterPrayerMentioned => 'Belirtilmiş';

  @override
  String get afterPrayerNotMentioned => 'Belirtilmemiş';

  @override
  String get afterPrayerTextSection => 'Zikir metni';

  @override
  String get afterPrayerVirtueSection => 'Zikrin fazileti';

  @override
  String afterPrayerRepeatTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kez',
      one: '$count kez',
    );
    return '$_temp0';
  }

  @override
  String get afterPrayerNoResults => 'Eşleşen sonuç yok';

  @override
  String get afterPrayerShowAll => 'Tüm zikirleri göster';

  @override
  String get myDuasTitle => 'Dualarım';

  @override
  String get myDuasActionFailed => 'İşlem gerçekleştirilemedi.';

  @override
  String get myDuasEmptyCustomTitle => 'Eklenmiş dua yok';

  @override
  String get myDuasEmptyCustomMessage =>
      'Bu bölüm yalnızca senin eklediğin duaları gösterir.';

  @override
  String get myDuasEmptyTitle => 'Henüz dua yok';

  @override
  String get myDuasEmptyMessage => 'İlk duanı ekle, hemen burada görünsün.';

  @override
  String get myDuasAddNew => 'Yeni dua ekle';

  @override
  String get myDuasAdd => 'Dua ekle';

  @override
  String get myDuasAddSubtitle =>
      'Kendi dualarının arasında görünmesi için duayı yaz.';

  @override
  String get myDuasEditTitle => 'Duayı düzenle';

  @override
  String get myDuasEditSubtitle =>
      'Metni veya açıklamayı düzenleyip değişiklikleri hemen kaydedebilirsin.';

  @override
  String get myDuasCountLabel => 'Dua sayısı';

  @override
  String get myDuasTodayLabel => 'Bugünkü tekrar';

  @override
  String get myDuasOptions => 'Dua seçenekleri';

  @override
  String get myDuasResetToday => 'Bugünün sayacını sıfırla';

  @override
  String get ruqyahTitle => 'Rukye';

  @override
  String get ruqyahSearchHint => 'Rukye ara';

  @override
  String get ruqyahDefaultReference => 'Kur\'an-ı Kerim';

  @override
  String get ruqyahUnspecified => 'Belirtilmemiş';

  @override
  String ruqyahRepeatLine(String count) {
    return 'Tekrar: $count';
  }

  @override
  String ruqyahReferenceLine(String reference) {
    return 'Kaynak: $reference';
  }

  @override
  String ruqyahDescriptionLine(String description) {
    return 'Açıklama: $description';
  }

  @override
  String ruqyahNumber(int number) {
    return 'Rukye $number';
  }

  @override
  String get ruqyahTextSection => 'Rukye metni';

  @override
  String get ruqyahDescriptionSection => 'Açıklama';

  @override
  String get ruqyahNoResultsTitle => 'Sonuç yok';

  @override
  String get ruqyahNoResultsMessage => 'Aramanla eşleşen bir rukye bulunamadı.';

  @override
  String get ruqyahShowAll => 'Tüm rukyeleri göster';

  @override
  String get radioTitle => 'Radyo';

  @override
  String get radioKindReciters => 'Kârîler';

  @override
  String get radioKindPrograms => 'Programlar ve tilavetler';

  @override
  String get radioLoadFailed => 'Radyolar şu anda yüklenemedi.';

  @override
  String get radioPlayFailed => 'Radyo şu anda çalınamadı.';

  @override
  String get radioToggleFailed => 'Oynatma durumu değiştirilemedi.';

  @override
  String get radioStopFailed => 'Radyo durdurulamadı.';

  @override
  String get radioNoMatch => 'Bu isimde istasyon yok.';

  @override
  String get radioSearchHint => 'Kârî veya program ara';

  @override
  String get radioFavouritesHint =>
      'Favorilere eklemek için bir istasyona uzun bas.';

  @override
  String get radioAddFavourite => 'Favorilere ekle';

  @override
  String get radioRemoveFavourite => 'Favorilerden kaldır';

  @override
  String radioAddedToFavourites(String station) {
    return '$station favorilere eklendi';
  }

  @override
  String radioRemovedFromFavourites(String station) {
    return '$station favorilerden kaldırıldı';
  }

  @override
  String get radioSleepTimer => 'Uyku zamanlayıcısı';

  @override
  String get radioSleepTimerDescription =>
      'Yayın seçilen sürenin sonunda kendiliğinden durur.';

  @override
  String radioStopsIn(String time) {
    return '$time sonra duracak';
  }

  @override
  String get radioCancelTimer => 'Zamanlayıcıyı iptal et';

  @override
  String radioMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dakika',
      one: '$count dakika',
    );
    return '$_temp0';
  }

  @override
  String get radioStopBroadcast => 'Yayını durdur';

  @override
  String get radioTuning => 'Bağlanıyor…';

  @override
  String get radioLive => 'Canlı yayın';

  @override
  String get radioPaused => 'Duraklatıldı';

  @override
  String get radioTapToPlay => 'Oynatmak için dokun';

  @override
  String get radioPause => 'Duraklat';

  @override
  String get radioPlay => 'Oynat';
}
