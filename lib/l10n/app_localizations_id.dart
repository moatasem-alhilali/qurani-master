// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class L10nId extends L10n {
  L10nId([String locale = 'id']) : super(locale);

  @override
  String get floatingAdhkarTitle => 'Zikir Melayang';

  @override
  String get floatingAdhkarSourceBuiltIn => 'Bawaan';

  @override
  String get floatingAdhkarSourceCustom => 'Kustom';

  @override
  String get floatingAdhkarSourceMyAdhkar => 'Zikir Saya';

  @override
  String get floatingAdhkarSourceAppLibrary => 'Pustaka aplikasi';

  @override
  String get floatingAdhkarDefaultDhikrTitle => 'Zikir bawaan';

  @override
  String get floatingAdhkarRandomDhikrTitle => 'Zikir acak';

  @override
  String get floatingAdhkarIosNotificationSubtitle => 'Zikir acak';

  @override
  String get floatingAdhkarOverlayServiceTitle => 'Zikir Acak Melayang';

  @override
  String get floatingAdhkarOverlayServiceContent =>
      'Layanan zikir melayang berjalan di latar belakang';

  @override
  String get floatingAdhkarErrorUnsupportedPlatform =>
      'Fitur ini tidak tersedia di platform ini.';

  @override
  String get floatingAdhkarErrorIosNotificationsToEnable =>
      'Izinkan notifikasi untuk mengaktifkan pengingat zikir di iPhone.';

  @override
  String get floatingAdhkarErrorOverlayPermissionFirst =>
      'Berikan izin tampil di atas aplikasi lain terlebih dahulu.';

  @override
  String get floatingAdhkarErrorNoSource =>
      'Aktifkan setidaknya satu sumber untuk zikir melayang.';

  @override
  String get floatingAdhkarErrorIosNotificationsRequired =>
      'Izin notifikasi diperlukan untuk pengingat iPhone.';

  @override
  String get floatingAdhkarErrorOverlayPermissionRequired =>
      'Izin diperlukan untuk menampilkan jendela melayang.';

  @override
  String get floatingAdhkarErrorTitleAndTextRequired =>
      'Judul dan teks wajib diisi untuk memperbarui zikir bawaan.';

  @override
  String get floatingAdhkarErrorNotificationsDenied =>
      'Izin notifikasi tidak diberikan.';

  @override
  String get floatingAdhkarErrorOverlayDenied =>
      'Izin tampil di atas aplikasi lain tidak diberikan.';

  @override
  String get floatingAdhkarErrorEnableBeforePreview =>
      'Aktifkan fitur ini dulu, lalu gunakan pratinjau langsung.';

  @override
  String get floatingAdhkarErrorPreviewNotificationsRequired =>
      'Izin notifikasi diperlukan untuk menampilkan zikir sekarang.';

  @override
  String get floatingAdhkarErrorPreviewOverlayRequired =>
      'Izin diperlukan untuk menampilkan zikir melayang.';

  @override
  String get floatingAdhkarStatusUnsupported => 'Tidak didukung';

  @override
  String get floatingAdhkarStatusPermissionRequired => 'Perlu izin';

  @override
  String get floatingAdhkarStatusMisconfigured => 'Perlu diatur';

  @override
  String get floatingAdhkarStatusActive => 'Sedang berjalan';

  @override
  String get floatingAdhkarStatusInactive => 'Berhenti';

  @override
  String get floatingAdhkarManageTitle => 'Kelola Zikir';

  @override
  String get floatingAdhkarManageSubtitle =>
      'Pilih zikir bawaan yang ditampilkan dan tambahkan zikir Anda';

  @override
  String get floatingAdhkarAddPrivateTooltip => 'Tambah zikir pribadi';

  @override
  String get floatingAdhkarAddCustomTitle => 'Tambah zikir kustom';

  @override
  String get floatingAdhkarAddCustomSubtitle =>
      'Zikir ini akan tersedia di zikir melayang setelah diaktifkan.';

  @override
  String get floatingAdhkarEditTitle => 'Edit zikir';

  @override
  String get floatingAdhkarEditSubtitle =>
      'Perbarui teksnya, lalu simpan perubahan.';

  @override
  String floatingAdhkarEnabledOfTotal(int enabled, int total) {
    return '$enabled dari $total';
  }

  @override
  String get floatingAdhkarEmptyBuiltInTitle => 'Tidak ada zikir bawaan';

  @override
  String get floatingAdhkarEmptyBuiltInMessage =>
      'Pustaka zikir bawaan tidak ditemukan di aplikasi.';

  @override
  String get floatingAdhkarEmptyCustomTitle => 'Belum ada zikir pribadi';

  @override
  String get floatingAdhkarEmptyCustomMessage =>
      'Tambahkan zikir atau doa Anda agar ikut dalam rotasi acak zikir melayang.';

  @override
  String get floatingAdhkarAddNewDhikr => 'Tambah zikir baru';

  @override
  String get floatingAdhkarItemOptions => 'Opsi zikir';

  @override
  String get floatingAdhkarTabBuiltIn => 'Zikir Bawaan';

  @override
  String get floatingAdhkarTabCustom => 'Zikir Pribadi';

  @override
  String get floatingAdhkarPreviewHeader => 'Pratinjau Zikir';

  @override
  String get floatingAdhkarAdvancedTitle => 'Pengaturan lanjutan';

  @override
  String get floatingAdhkarAdvancedSubtitle =>
      'Frekuensi tampil, durasi, dan sumber';

  @override
  String get floatingAdhkarFrequencyTitle => 'Frekuensi tampil';

  @override
  String get floatingAdhkarVisibleDurationTitle => 'Durasi tampil zikir';

  @override
  String floatingAdhkarSecondsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count detik',
    );
    return '$_temp0';
  }

  @override
  String get floatingAdhkarSourcesTitle => 'Sumber zikir';

  @override
  String get floatingAdhkarAllowNotifications => 'Izinkan notifikasi';

  @override
  String get floatingAdhkarGrantPermission => 'Berikan izin yang diperlukan';

  @override
  String get floatingAdhkarPermissionHint =>
      'Tanpa izin ini, zikir tidak akan tampil di atas aplikasi lain';

  @override
  String get floatingAdhkarSendNow => 'Kirim zikir sekarang';

  @override
  String get floatingAdhkarShowNow => 'Tampilkan zikir sekarang';

  @override
  String get floatingAdhkarPreviewReadyHint =>
      'Coba lihat tampilan zikir seperti yang akan muncul';

  @override
  String get floatingAdhkarPreviewDisabledHint =>
      'Aktifkan layanan dan berikan izin terlebih dahulu';

  @override
  String get floatingAdhkarIosReminders => 'Pengingat iPhone';

  @override
  String get floatingAdhkarFloatingService => 'Layanan melayang';

  @override
  String get floatingAdhkarUnsupportedPlatform =>
      'Tidak didukung di platform ini';

  @override
  String get floatingAdhkarStatBuiltIn => 'Bawaan';

  @override
  String get floatingAdhkarStatCustom => 'Pribadi';

  @override
  String get floatingAdhkarSettingsTitleIos => 'Pengaturan Pengingat Zikir';

  @override
  String get floatingAdhkarSettingsTitle => 'Pengaturan Zikir Melayang';

  @override
  String get floatingAdhkarReminderTiming => 'Waktu pengingat';

  @override
  String get floatingAdhkarAppearanceTiming => 'Waktu tampil';

  @override
  String get floatingAdhkarReminderFrequency => 'Frekuensi pengingat';

  @override
  String get floatingAdhkarAppearanceFrequency => 'Frekuensi tampil';

  @override
  String get floatingAdhkarBuiltInSourceSubtitle =>
      'Sumber utama bawaan aplikasi';

  @override
  String get floatingAdhkarCustomSourceSubtitle =>
      'Zikir yang Anda tambahkan sendiri';

  @override
  String get floatingAdhkarMixSources => 'Campur sumber';

  @override
  String get floatingAdhkarMixSourcesOn => 'Dipilih dari satu daftar gabungan';

  @override
  String get floatingAdhkarMixSourcesOff =>
      'Bergantian antara bawaan dan kustom';

  @override
  String get floatingAdhkarSaveNeedsSource =>
      'Aktifkan setidaknya satu sumber sebelum menyimpan.';

  @override
  String get floatingAdhkarMasterSwitch => 'Aktifkan fitur sepenuhnya';

  @override
  String get floatingAdhkarMasterSwitchIosHint =>
      'Menjadwalkan pengingat zikir di iPhone';

  @override
  String get floatingAdhkarMasterSwitchHint =>
      'Layanan latar belakang mulai menampilkan zikir';

  @override
  String get floatingAdhkarSaveSettings => 'Simpan pengaturan';

  @override
  String floatingAdhkarEveryMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Setiap $count menit',
      one: 'Setiap menit',
    );
    return '$_temp0';
  }

  @override
  String get floatingAdhkarSourcesMixed => 'Gabungan bawaan dan kustom';

  @override
  String get floatingAdhkarSourcesAlternating => 'Bergantian bawaan dan kustom';

  @override
  String get floatingAdhkarSourcesBuiltInOnly => 'Hanya zikir bawaan';

  @override
  String get floatingAdhkarSourcesCustomOnly => 'Hanya zikir pengguna';

  @override
  String get floatingAdhkarSourcesNone => 'Tidak ada sumber aktif';

  @override
  String get sabihTitle => 'Tasbih';

  @override
  String get sabihBeadWalnut => 'Kenari';

  @override
  String get sabihBeadOak => 'Ek';

  @override
  String get sabihBeadEmerald => 'Zamrud';

  @override
  String get sabihBeadOnyx => 'Onyx hitam';

  @override
  String get sabihBeadAmber => 'Amber';

  @override
  String get sabihBeadMahogany => 'Mahoni';

  @override
  String get sabihBeadSage => 'Hijau zaitun';

  @override
  String get sabihBeadGarnet => 'Akik merah';

  @override
  String get sabihErrorRefreshList => 'Gagal memperbarui daftar zikir.';

  @override
  String get sabihErrorLoad => 'Gagal memuat zikir.';

  @override
  String get sabihErrorRecord => 'Gagal mencatat zikir.';

  @override
  String get sabihErrorResetToday => 'Gagal mengatur ulang hitungan hari ini.';

  @override
  String get sabihAnalyticsTitle => 'Statistik';

  @override
  String get sabihTabOverview => 'Ringkasan';

  @override
  String get sabihTabDetails => 'Rincian zikir';

  @override
  String get sabihDhikrSettingsTooltip => 'Pengaturan zikir';

  @override
  String get sabihAddCustomDhikr => 'Tambah zikir kustom';

  @override
  String get sabihEmptyMessage => 'Tidak ada zikir ditemukan';

  @override
  String get sabihAddFirst => 'Tambahkan zikir pertama Anda';

  @override
  String get sabihSaveChanges => 'Simpan perubahan';

  @override
  String get sabihAddDhikr => 'Tambah zikir';

  @override
  String get sabihSaveFailed => 'Gagal menyimpan zikir.';

  @override
  String get sabihUpdatedSuccess => 'Zikir berhasil diperbarui.';

  @override
  String get sabihAddedSuccess => 'Zikir berhasil ditambahkan.';

  @override
  String get sabihEditDhikr => 'Edit zikir';

  @override
  String get sabihFieldText => 'Teks zikir';

  @override
  String sabihExampleHint(String example) {
    return 'Contoh: $example';
  }

  @override
  String get sabihTextRequired => 'Masukkan teks zikir';

  @override
  String get sabihTextTooShort => 'Teks zikir terlalu pendek';

  @override
  String get sabihFieldVirtue => 'Keutamaan atau deskripsi singkat (opsional)';

  @override
  String get sabihPeriodToday => 'Hari ini';

  @override
  String get sabihPeriodWeek => 'Minggu';

  @override
  String get sabihPeriodMonth => 'Bulan';

  @override
  String get sabihPeriodYear => 'Tahun';

  @override
  String get sabihPeriodAll => 'Semua';

  @override
  String get sabihThisWeek => 'Minggu ini';

  @override
  String get sabihThisMonth => 'Bulan ini';

  @override
  String get sabihAllTime => 'Sepanjang waktu';

  @override
  String get sabihMostUsed => 'Zikir paling sering';

  @override
  String get sabihTotalCount => 'Total zikir';

  @override
  String get sabihNoDataYet => 'Belum ada data';

  @override
  String get sabihResetTodayCounter => 'Atur ulang hitungan hari ini';

  @override
  String get sabihEditThisDhikr => 'Edit zikir ini';

  @override
  String get sabihDeleteThisDhikr => 'Hapus zikir ini';

  @override
  String get sabihCustomBadge => 'Kustom';

  @override
  String get sabihNoCustomDhikr => 'Tidak ada zikir kustom';

  @override
  String get sabihSummaryTitle => 'Ringkasan Zikir';

  @override
  String get sabihTodayNotStarted => 'Anda belum berzikir hari ini';

  @override
  String sabihTodayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hari ini Anda berzikir $count kali',
      one: 'Hari ini Anda berzikir 1 kali',
    );
    return '$_temp0';
  }

  @override
  String get sabihCounterSemantics => 'Tasbih';

  @override
  String sabihTargetReached(int target) {
    return 'Mencapai $target';
  }

  @override
  String sabihTargetOf(int target) {
    return 'dari $target';
  }

  @override
  String sabihTargetLabel(int target) {
    return 'Target $target';
  }

  @override
  String get sabihTapAnywhere => 'Ketuk di mana saja untuk bertasbih';

  @override
  String get sabihCountSemantics => 'Jumlah tasbih';

  @override
  String get sabihInvalidNumber => 'Masukkan bilangan bulat lebih dari nol';

  @override
  String get sabihSettingsTitle => 'Pengaturan Tasbih';

  @override
  String get sabihTargetSection => 'Target zikir';

  @override
  String get sabihTargetAutoHint =>
      'Biarkan apa adanya dan target akan naik otomatis: 33, lalu 99, lalu setiap 100.';

  @override
  String get sabihFontSize => 'Ukuran huruf';

  @override
  String get sabihFontSizeGlyph => 'A';

  @override
  String sabihPercent(int value) {
    return '$value%';
  }

  @override
  String get sabihVibration => 'Getaran';

  @override
  String get sabihVibrationTitle => 'Getaran ringan setiap tasbih';

  @override
  String get sabihVibrationSubtitle =>
      'Dan getaran lebih kuat saat target tercapai';

  @override
  String get sabihBeadDesign => 'Desain Tasbih';

  @override
  String get sabihResetTodayCounterAction => 'Atur ulang hitungan hari ini';

  @override
  String get anotherScreenGroupDaily => 'Amalan Harian';

  @override
  String get anotherScreenGroupKnowledge => 'Ilmu & Tilawah';

  @override
  String get anotherScreenGroupTools => 'Zikir & Alat';

  @override
  String get anotherScreenDailyWird => 'Bekal Siang dan Malam';

  @override
  String get anotherScreenDailyWirdSubtitle =>
      'Wirid ibadah terstruktur untuk zikir dan tilawah harian Anda';

  @override
  String get anotherScreenKhatmaPlans => 'Rencana Khatam';

  @override
  String get anotherScreenKhatmaPlansSubtitle =>
      'Rencana teratur untuk mengkhatamkan Al-Qur\'an sesuai kemampuan Anda';

  @override
  String get anotherScreenTasbihSubtitle =>
      'Tasbih mudah dengan penghitung yang nyaman dan jelas';

  @override
  String get anotherScreenFloatingAdhkarSubtitle =>
      'Zikir singkat yang muncul di atas aplikasi lain';

  @override
  String get anotherScreenFajrCompanion => 'Teman Subuh';

  @override
  String get anotherScreenFajrCompanionSubtitle =>
      'Pengingat ajakan dan panggilan terjadwal';

  @override
  String get anotherScreenSurahEncyclopedia => 'Ensiklopedia Surah';

  @override
  String get anotherScreenSurahEncyclopediaSubtitle =>
      'Jelajahi surah, keutamaan, dan temanya';

  @override
  String get anotherScreenNawawi40 => 'Hadis Arbain Nawawi';

  @override
  String get anotherScreenNawawi40Subtitle =>
      'Hadis-hadis pokok dalam berbagai bab agama';

  @override
  String get anotherScreenNamesOfAllah => 'Asmaul Husna';

  @override
  String get anotherScreenNamesOfAllahSubtitle =>
      'Renungkan nama-nama Allah dan maknanya yang mulia';

  @override
  String get anotherScreenRadio => 'Radio';

  @override
  String get anotherScreenRadioSubtitle =>
      'Radio Al-Qur\'an dan Islami siaran langsung tanpa henti';

  @override
  String get anotherScreenHisnMuslim => 'Hisnul Muslim';

  @override
  String get anotherScreenHisnMuslimSubtitle =>
      'Kumpulan zikir lengkap untuk berbagai keadaan dan momen';

  @override
  String get anotherScreenMyDuas => 'Doa Pribadi Saya';

  @override
  String get anotherScreenMyDuasSubtitle =>
      'Simpan doa-doa pribadi Anda di satu tempat';

  @override
  String get anotherScreenTraveler => 'Musafir';

  @override
  String get anotherScreenTravelerSubtitle =>
      'Zikir safar, jadwal perjalanan, dan tempat bermanfaat';

  @override
  String get anotherScreenHomeWidgets => 'Widget Layar Utama';

  @override
  String get anotherScreenHomeWidgetsSubtitle =>
      'Salat berikutnya, jadwal hari ini, dan ayat hari ini';

  @override
  String get anotherScreenFootnotes => 'Catatan Kaki';

  @override
  String anotherScreenChapterNumber(int number) {
    return 'Bab $number';
  }

  @override
  String anotherScreenTextsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count teks',
    );
    return '$_temp0';
  }

  @override
  String anotherScreenFootnotesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count catatan kaki',
    );
    return '$_temp0';
  }

  @override
  String get anotherScreenDhikrText => 'Teks Zikir';

  @override
  String get anotherScreenHisnSearchHint => 'Cari di Hisnul Muslim';

  @override
  String get anotherScreenNoResults => 'Tidak ada hasil';

  @override
  String get anotherScreenHisnNoResultsMessage =>
      'Tidak ada bab di Hisnul Muslim yang cocok dengan pencarian Anda.';

  @override
  String get anotherScreenShowAllAdhkar => 'Tampilkan semua zikir';

  @override
  String get anotherScreenSurahSearchHint => 'Cari surah';

  @override
  String anotherScreenSurahTitle(String name) {
    return 'Surah $name';
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
  String get anotherScreenSurahOrder => 'Urutan';

  @override
  String get anotherScreenSurahNumber => 'Nomor surah';

  @override
  String get anotherScreenAyahCount => 'Jumlah ayat';

  @override
  String get anotherScreenSurahNameMeaning => 'Arti nama surah';

  @override
  String get anotherScreenSurahNamingReason => 'Sebab penamaan';

  @override
  String get anotherScreenSurahOtherNamesShort => 'Nama lain';

  @override
  String get anotherScreenSurahOtherNames => 'Nama lain surah';

  @override
  String get anotherScreenSurahPurpose => 'Tujuan umum';

  @override
  String get anotherScreenSurahRevelationReason => 'Asbabun nuzul';

  @override
  String get anotherScreenSurahVirtues => 'Keutamaan surah';

  @override
  String get anotherScreenSurahRelations => 'Munasabah surah';

  @override
  String anotherScreenAyahsLabel(String count) {
    return '$count ayat';
  }

  @override
  String get anotherScreenNoMatchingResults => 'Tidak ada hasil yang cocok';

  @override
  String get anotherScreenShowAllSurahs => 'Tampilkan semua surah';

  @override
  String get quranPlanAnalysisStartFirst =>
      'Mulai sesi pertama untuk menganalisis kemajuan Anda.';

  @override
  String get quranPlanAnalysisFinished =>
      'Selamat! Anda telah menyelesaikan rencana ini.';

  @override
  String get quranPlanAnalysisOnTrack =>
      'Anda berada di jalur yang benar dan diperkirakan khatam sebelum waktunya!';

  @override
  String get quranPlanAnalysisBehind =>
      'Anda mungkin sedikit terlambat dari jadwal. Coba percepat laju bacaan Anda.';

  @override
  String quranPlanReminderTitle(String title) {
    return 'Rencana khatam Al-Qur\'an: $title';
  }

  @override
  String quranPlanReminderBody(String title) {
    return 'Jangan lupa sesi hari ini dalam rencana \"$title\"!';
  }

  @override
  String get quranPlanAddTitle => 'Tambah rencana khatam baru';

  @override
  String get quranPlanDetailsHeader => 'Detail rencana';

  @override
  String get quranPlanTitleLabel => 'Judul rencana';

  @override
  String get quranPlanTitleHint => 'Nama rencana';

  @override
  String get quranPlanTitleRequired => 'Masukkan judul';

  @override
  String get quranPlanFromJuz => 'Dari juz';

  @override
  String get quranPlanToJuz => 'Sampai juz';

  @override
  String get quranPlanChooseStart => 'Pilih awal';

  @override
  String get quranPlanChooseEnd => 'Pilih akhir';

  @override
  String get quranPlanEndBeforeStart => 'Akhir berada sebelum awal';

  @override
  String get quranPlanDaysLabel => 'Jumlah hari';

  @override
  String get quranPlanDaysHint => 'Contoh: 30';

  @override
  String get quranPlanDaysInvalid => 'Masukkan jumlah hari yang benar';

  @override
  String get quranPlanSave => 'Simpan rencana';

  @override
  String get quranPlanChoose => 'Pilih';

  @override
  String quranPlanJuz(int number) {
    return 'Juz $number';
  }

  @override
  String get quranPlanDailyReminder => 'Pengingat harian';

  @override
  String get quranPlanNotSet => 'Belum diatur';

  @override
  String get quranPlanListTitle => 'Rencana Khatam';

  @override
  String get quranPlanNewTooltip => 'Rencana baru';

  @override
  String get quranPlanSearchHint => 'Cari rencana';

  @override
  String quranPlanJuzRange(int start, int end) {
    return 'Juz $start sampai $end';
  }

  @override
  String quranPlanDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hari',
    );
    return '$_temp0';
  }

  @override
  String quranPlanLoadedSessions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sesi dimuat',
    );
    return '$_temp0';
  }

  @override
  String quranPlanProgress(int done, int total) {
    return '$done dari $total';
  }

  @override
  String get quranPlanDeleteConfirm => 'Hapus rencana ini?';

  @override
  String get quranPlanConfirm => 'Konfirmasi';

  @override
  String get quranPlanDelete => 'Hapus rencana';

  @override
  String get quranPlanStagnationWarning =>
      'Perhatian: Anda sudah beberapa hari tidak membaca. Satu sesi singkat hari ini cukup untuk kembali ke ritme.';

  @override
  String get quranPlanLoadFailed => 'Rencana ini tidak dapat dimuat saat ini.';

  @override
  String get quranPlanTodaySession => 'Sesi hari ini';

  @override
  String get quranPlanAllSessionsDone =>
      'Anda telah menyelesaikan semua sesi rencana ini, semoga Allah memberkahi Anda.';

  @override
  String get quranPlanRhythm => 'Ritme Rencana';

  @override
  String get quranPlanPath => 'Jalur Khatam';

  @override
  String get quranPlanNoSessions => 'Belum ada sesi yang ditampilkan.';

  @override
  String get quranPlanCompleteConfirm => 'Selesaikan sesi ini?';

  @override
  String quranPlanSessionNumber(int number) {
    return 'Sesi $number';
  }

  @override
  String get quranPlanSessionDone => 'Selesai';

  @override
  String get quranPlanCurrentSession => 'Sesi Anda saat ini';

  @override
  String get quranPlanOpenMushafHint => 'Buka mushaf saat memulai sesi';

  @override
  String get quranPlanSessionCompleted => 'Sesi selesai';

  @override
  String get quranPlanCompleteSession => 'Selesaikan sesi';

  @override
  String quranPlanSurahFallback(int number) {
    return 'Surah $number';
  }

  @override
  String quranPlanSessionRange(
      String fromSurah, int fromAyah, String toSurah, int toAyah) {
    return 'Dari $fromSurah ayat $fromAyah sampai $toSurah ayat $toAyah';
  }

  @override
  String quranPlanCompletedAt(String date) {
    return 'Selesai · $date';
  }

  @override
  String get quranPlanExpectedFinish => 'Perkiraan hari khatam';

  @override
  String get quranPlanAverageInterval => 'Rata-rata jeda antarsesi';

  @override
  String quranPlanAverageIntervalValue(String days) {
    return '$days hari';
  }

  @override
  String get quranPlanMostActiveDay => 'Hari paling aktif';

  @override
  String get quranPlanLeastActiveDay => 'Hari paling sedikit aktif';

  @override
  String get quranPlanCompletionProbability => 'Peluang menyelesaikan rencana';

  @override
  String quranPlanPercentValue(int percent) {
    return '$percent persen';
  }

  @override
  String get quranPlanStagnationDays => 'Hari tanpa membaca';

  @override
  String get cleanupRouteNotFound => 'Halaman tidak ditemukan';

  @override
  String get cleanupNotificationSubtitle => 'Notifikasi baru';

  @override
  String get cleanupNotificationActionView => 'Lihat';

  @override
  String get cleanupNotificationActionDismiss => 'Abaikan';

  @override
  String get cleanupDownloadActionFailed => 'Proses unduhan gagal. Coba lagi.';

  @override
  String get cleanupDownloadStatusQueued => 'Menunggu';

  @override
  String get cleanupDownloadStatusCanceled => 'Dibatalkan';

  @override
  String get cleanupDownloadStatusUnknown => 'Tidak diketahui';

  @override
  String get cleanupRadioMediaArtist => 'Radio Al-Qur\'an';

  @override
  String get cleanupDhikrMeaningSubhanAllah => 'Mahasuci Allah';

  @override
  String get cleanupDhikrMeaningAlhamdulillah => 'Segala puji bagi Allah';

  @override
  String get cleanupDhikrMeaningLaIlaha => 'Tiada tuhan selain Allah';

  @override
  String get cleanupDhikrMeaningAllahuAkbar => 'Allah Mahabesar';

  @override
  String get cleanupDhikrMeaningLaHawla =>
      'Tiada daya dan kekuatan kecuali dengan pertolongan Allah';

  @override
  String get cleanupDhikrMeaningAstaghfirullah =>
      'Aku memohon ampun kepada Allah';

  @override
  String get cleanupDhikrMeaningSubhanAllahWaBihamdihi =>
      'Mahasuci Allah dan segala puji bagi-Nya, Mahasuci Allah Yang Mahaagung';

  @override
  String get appName => 'Tamaneena';

  @override
  String get commonContinue => 'Lanjutkan';

  @override
  String get commonSave => 'Simpan';

  @override
  String get commonCancel => 'Batal';

  @override
  String get commonOk => 'Oke';

  @override
  String get commonClose => 'Tutup';

  @override
  String get commonDone => 'Selesai';

  @override
  String get commonRetry => 'Coba lagi';

  @override
  String get commonSearch => 'Cari';

  @override
  String get commonSettings => 'Pengaturan';

  @override
  String get commonLoading => 'Memuat…';

  @override
  String get commonError => 'Terjadi kesalahan';

  @override
  String get commonDelete => 'Hapus';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonAdd => 'Tambah';

  @override
  String get commonShare => 'Bagikan';

  @override
  String get commonCopy => 'Salin';

  @override
  String get commonCopied => 'Disalin';

  @override
  String get commonBack => 'Kembali';

  @override
  String get commonYes => 'Ya';

  @override
  String get commonNo => 'Tidak';

  @override
  String get commonRefresh => 'Muat ulang';

  @override
  String get commonSeeAll => 'Lihat semua';

  @override
  String get commonEnable => 'Aktifkan';

  @override
  String get commonDisable => 'Nonaktifkan';

  @override
  String get commonLater => 'Nanti';

  @override
  String get prayerFajr => 'Subuh';

  @override
  String get prayerSunrise => 'Terbit';

  @override
  String get prayerDhuhr => 'Zuhur';

  @override
  String get prayerAsr => 'Asar';

  @override
  String get prayerMaghrib => 'Magrib';

  @override
  String get prayerIsha => 'Isya';

  @override
  String get prayerJumuah => 'Jumat';

  @override
  String get hijriMonth1 => 'Muharram';

  @override
  String get hijriMonth2 => 'Safar';

  @override
  String get hijriMonth3 => 'Rabiulawal';

  @override
  String get hijriMonth4 => 'Rabiulakhir';

  @override
  String get hijriMonth5 => 'Jumadilawal';

  @override
  String get hijriMonth6 => 'Jumadilakhir';

  @override
  String get hijriMonth7 => 'Rajab';

  @override
  String get hijriMonth8 => 'Syakban';

  @override
  String get hijriMonth9 => 'Ramadan';

  @override
  String get hijriMonth10 => 'Syawal';

  @override
  String get hijriMonth11 => 'Zulkaidah';

  @override
  String get hijriMonth12 => 'Zulhijah';

  @override
  String hijriDate(String day, String month, String year) {
    return '$day $month $year H';
  }

  @override
  String get youngMuslimTitle => 'Muslim Cilik';

  @override
  String get youngMuslimQuizUnanswered => 'Belum dijawab';

  @override
  String get youngMuslimResumeReminderTitle =>
      'Lanjutkan menonton di Muslim Cilik';

  @override
  String youngMuslimResumeReminderBody(String topic) {
    return 'Kembali ke \"$topic\" dan lanjutkan perjalananmu dengan tenang.';
  }

  @override
  String get youngMuslimAudienceKidsSafe => 'Aman untuk anak';

  @override
  String get youngMuslimAudienceGeneral => 'Tontonan umum';

  @override
  String get youngMuslimStatSeries => 'Serial';

  @override
  String get youngMuslimStatEpisode => 'Episode';

  @override
  String get youngMuslimChooseSeries => 'Pilih serial';

  @override
  String get youngMuslimEpisodes => 'Episode';

  @override
  String youngMuslimEpisodesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count episode',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNoEpisodesTitle => 'Belum ada episode';

  @override
  String get youngMuslimNoEpisodesSubtitle =>
      'Ganti serial yang dipilih atau kembali lagi nanti setelah filter diperbarui.';

  @override
  String get youngMuslimCategoryLoadError => 'Gagal memuat bagian ini';

  @override
  String get youngMuslimTryAgainShortly => 'Coba lagi sebentar lagi.';

  @override
  String get youngMuslimSearchHint => 'Cari cerita...';

  @override
  String get youngMuslimAchievements => 'Pencapaian';

  @override
  String get youngMuslimQuickFilter => 'Filter Cepat';

  @override
  String get youngMuslimFilterResults => 'Hasil filter';

  @override
  String youngMuslimResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hasil',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNoMatchesTitle => 'Tidak ada hasil yang cocok';

  @override
  String get youngMuslimNoMatchesSubtitle =>
      'Coba kata yang lebih sederhana atau ubah filter agar lebih banyak episode muncul.';

  @override
  String get youngMuslimSections => 'Kategori';

  @override
  String get youngMuslimContinueWatching => 'Lanjutkan Menonton';

  @override
  String get youngMuslimRecentlyWatched => 'Baru Ditonton';

  @override
  String get youngMuslimFavorites => 'Favorit';

  @override
  String get youngMuslimWatchLater => 'Tonton Nanti';

  @override
  String get youngMuslimSuggestions => 'Saran untukmu';

  @override
  String get youngMuslimGreetingWelcome =>
      'Selamat datang di dunia cerita dan belajar';

  @override
  String get youngMuslimGreetingPickNew =>
      'Pilih cerita baru dan mulai petualanganmu hari ini';

  @override
  String youngMuslimGreetingWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ada $count episode yang menunggumu untuk dilanjutkan',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimRewardsTitle => 'Poin dan Pencapaianku';

  @override
  String youngMuslimLevelAndPoints(int level, int points) {
    return 'Level $level · $points poin';
  }

  @override
  String get youngMuslimNextLevelProgress => 'Kemajuan ke level berikutnya';

  @override
  String youngMuslimProgressOf(int current, int total) {
    return '$current dari $total';
  }

  @override
  String get youngMuslimStatAchievements => 'Pencapaian';

  @override
  String get youngMuslimStatEpisodes => 'Episode';

  @override
  String get youngMuslimStatAnswers => 'Jawaban';

  @override
  String get youngMuslimFilterAll => 'Semua';

  @override
  String get youngMuslimStatusInProgress => 'Sedang ditonton';

  @override
  String get youngMuslimStatusCompleted => 'Selesai';

  @override
  String get youngMuslimStatusWatchLater => 'Nanti';

  @override
  String get youngMuslimFiltersActiveNote =>
      'Filter sedang aktif. Kamu bisa mengubahnya lewat tombol filter di atas halaman.';

  @override
  String get youngMuslimClearFilters => 'Hapus';

  @override
  String get youngMuslimContentLoadError => 'Gagal memuat konten';

  @override
  String get youngMuslimPullToRetry =>
      'Tarik halaman ke bawah untuk mencoba lagi.';

  @override
  String get youngMuslimFilterSheetTitle => 'Filter Konten';

  @override
  String get youngMuslimCategoryLabel => 'Kategori';

  @override
  String get youngMuslimFilterLanguage => 'Bahasa';

  @override
  String get youngMuslimLanguageArabic => 'Arab';

  @override
  String get youngMuslimLanguageFrench => 'Prancis';

  @override
  String get youngMuslimLanguageMixed => 'Campuran';

  @override
  String get youngMuslimFilterContentType => 'Jenis konten';

  @override
  String get youngMuslimContentTypeStorySeries => 'Serial cerita';

  @override
  String get youngMuslimApplyFilters => 'Terapkan filter';

  @override
  String get youngMuslimPlayerTitle => 'Pemutar Aman Anak';

  @override
  String get youngMuslimEpisodeQuizTitle => 'Pertanyaan setelah menonton';

  @override
  String get youngMuslimSeriesChallenge => 'Tantangan Serial';

  @override
  String get youngMuslimPlayerLoadError =>
      'Pemutar tidak dapat dimuat saat ini.';

  @override
  String get youngMuslimWatchOptions => 'Opsi menonton';

  @override
  String get youngMuslimPlayNextEpisode => 'Putar episode berikutnya';

  @override
  String youngMuslimNextEpisodeFromSeries(String episode) {
    return 'Episode $episode dari serial yang sama';
  }

  @override
  String get youngMuslimSeriesPlaylist => 'Daftar serial';

  @override
  String get youngMuslimAutoPlayNext => 'Putar episode berikutnya otomatis';

  @override
  String get youngMuslimAutoPlayNextSubtitle =>
      'Hanya dalam serial yang sama setelah episode selesai';

  @override
  String get youngMuslimResumeButton => 'Lanjutkan menonton';

  @override
  String get youngMuslimPlayNow => 'Putar sekarang';

  @override
  String youngMuslimPercent(int percent) {
    return '$percent%';
  }

  @override
  String get youngMuslimProgress => 'Kemajuan';

  @override
  String get youngMuslimWatchCount => 'Jumlah ditonton';

  @override
  String get youngMuslimEpisodeDuration => 'Durasi episode';

  @override
  String youngMuslimLastWatched(String when) {
    return 'Terakhir ditonton: $when';
  }

  @override
  String get youngMuslimEpisodeInfo => 'Info episode';

  @override
  String get youngMuslimStory => 'Cerita';

  @override
  String get youngMuslimSeries => 'Serial';

  @override
  String get youngMuslimEpisodeNumber => 'Nomor episode';

  @override
  String get youngMuslimEpisodeTools => 'Alat episode';

  @override
  String get youngMuslimEpisodeQuestions => 'Pertanyaan episode';

  @override
  String get youngMuslimEpisodeQuestionsSubtitle =>
      'Pertanyaan singkat untuk memperkuat apa yang ditonton anak';

  @override
  String get youngMuslimAfterWatchQuestion => 'Pertanyaan setelah menonton';

  @override
  String get youngMuslimNextEpisode => 'Episode berikutnya';

  @override
  String get youngMuslimSimilarEpisodes => 'Episode serupa';

  @override
  String get youngMuslimDetailsLoadError => 'Gagal memuat detail episode';

  @override
  String get youngMuslimQuizIntro =>
      'Pertanyaan sederhana untuk membantu anak mengingat apa yang ditontonnya.';

  @override
  String youngMuslimQuestionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pertanyaan',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimXpOnPass(int points) {
    return '+$points poin jika lulus';
  }

  @override
  String youngMuslimPassingScore(int score) {
    return 'Lulus dengan $score benar';
  }

  @override
  String get youngMuslimGrading => 'Memeriksa jawaban';

  @override
  String get youngMuslimSubmitAnswers => 'Kirim jawaban';

  @override
  String get youngMuslimAnswerHint => 'Tulis jawabanmu di sini dengan jelas...';

  @override
  String get youngMuslimQuizPassed => 'Hebat, Juara!';

  @override
  String get youngMuslimQuizAlmost => 'Sedikit lagi jawabanmu sempurna';

  @override
  String youngMuslimQuizScore(int correct, int total) {
    return 'Kamu menjawab $correct dari $total dengan benar';
  }

  @override
  String youngMuslimXpGained(int points) {
    return '+$points poin';
  }

  @override
  String youngMuslimLevel(int level) {
    return 'Level $level';
  }

  @override
  String youngMuslimPoints(int points) {
    String _temp0 = intl.Intl.pluralLogic(
      points,
      locale: localeName,
      other: '$points poin',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNewAchievements => 'Pencapaian baru';

  @override
  String get youngMuslimReviewAnswers => 'Tinjau jawaban';

  @override
  String get youngMuslimFinish => 'Selesai';

  @override
  String get youngMuslimYourAnswer => 'Jawabanmu';

  @override
  String get youngMuslimCorrectAnswer => 'Jawaban yang benar';

  @override
  String get youngMuslimStatSeriesPlural => 'Serial';

  @override
  String get youngMuslimStatPerfectScores => 'Nilai sempurna';

  @override
  String get youngMuslimUnlockedAchievements => 'Pencapaian terbuka';

  @override
  String youngMuslimAchievementsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pencapaian',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNoAchievementsTitle => 'Belum ada pencapaian';

  @override
  String get youngMuslimNoAchievementsSubtitle =>
      'Selesaikan episode pertama atau jawab pertanyaan pertama untuk memulai.';

  @override
  String get youngMuslimUpcomingAchievements => 'Pencapaian berikutnya';

  @override
  String get youngMuslimAchievementUnlocked => 'Pencapaian ini sudah terbuka.';

  @override
  String youngMuslimAchievementUnlockedAt(String when) {
    return 'Terbuka $when';
  }

  @override
  String get youngMuslimCurrentProgress => 'Kemajuan saat ini';

  @override
  String youngMuslimDurationHoursMinutes(int hours, int minutes) {
    return '${hours}j ${minutes}m';
  }

  @override
  String youngMuslimDurationMinutes(int minutes) {
    return '${minutes}m';
  }

  @override
  String get youngMuslimNotWatchedYet => 'Belum ditonton';

  @override
  String get youngMuslimJustNow => 'Baru saja';

  @override
  String youngMuslimMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count menit lalu',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jam lalu',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hari lalu',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimWatched => 'Sudah ditonton';

  @override
  String youngMuslimProgressPercent(int percent) {
    return 'Kemajuan $percent%';
  }

  @override
  String get youngMuslimReadyToWatch => 'Siap ditonton';

  @override
  String youngMuslimCategorySeriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count serial',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimCategorySeriesCountKids(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count serial · untuk anak',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimEpisodeMeta(int episode, String duration) {
    return 'Episode $episode · $duration';
  }

  @override
  String get youngMuslimResumeWhereLeft => 'Lanjutkan dari terakhir kali';

  @override
  String youngMuslimTimeRemaining(String duration) {
    return 'Sisa $duration';
  }

  @override
  String get youngMuslimAlmostDone => 'Hampir selesai';

  @override
  String get categoriesRequestFailed => 'Tidak dapat memproses permintaan';

  @override
  String get categoriesLibraryTitle => 'Perpustakaan';

  @override
  String get categoriesQuranSciencesHeader => 'Al-Qur\'an dan Ilmunya';

  @override
  String get categoriesTypesHeader => 'Jenis';

  @override
  String get categoriesSectionsHeader => 'Topik';

  @override
  String get categoriesFamousRecitations => 'Tilawah terkenal';

  @override
  String get categoriesKidsTeaching => 'Belajar untuk anak';

  @override
  String get categoriesRecitationsByNarration =>
      'Tilawah berbagai riwayat dan qiraat';

  @override
  String get categoriesRecitationsByNarrationShort => 'Tilawah riwayat';

  @override
  String get categoriesHaramainMushafs => 'Mushaf Haramain';

  @override
  String get categoriesTypeVideos => 'Video';

  @override
  String get categoriesTypeBooks => 'Buku';

  @override
  String get categoriesTypeStories => 'Kisah';

  @override
  String get categoriesTypeAudios => 'Audio';

  @override
  String get categoriesTypeFatwas => 'Fatwa';

  @override
  String get categoriesTypeQuran => 'Al-Qur\'an';

  @override
  String get categoriesTypePresentations => 'Presentasi';

  @override
  String get categoriesTypeNews => 'Berita';

  @override
  String get categoriesTypeArticles => 'Artikel';

  @override
  String get categoriesTypeApps => 'Aplikasi';

  @override
  String get categoriesTypeSermons => 'Khotbah';

  @override
  String get categoriesTopicQuran => 'Al-Qur\'an';

  @override
  String get categoriesTopicSunnah => 'Sunah';

  @override
  String get categoriesTopicSeerah => 'Sirah Nabawiyah';

  @override
  String get categoriesTopicAqeedah => 'Akidah';

  @override
  String get categoriesTopicFiqh => 'Fikih';

  @override
  String get categoriesTopicHistory => 'Sejarah';

  @override
  String get categoriesTopicArabic => 'Bahasa Arab';

  @override
  String get categoriesTopicIslamicStudies => 'Studi Islam';

  @override
  String get categoriesTopicLessons => 'Kajian Ilmiah';

  @override
  String get categoriesTopicMajorSins => 'Dosa Besar dan Hal Haram';

  @override
  String get categoriesNoSearchResults =>
      'Tidak ada hasil untuk pencarian ini.';

  @override
  String categoriesItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count item',
    );
    return '$_temp0';
  }

  @override
  String get categoriesItemAudio => 'Audio';

  @override
  String get categoriesItemBook => 'Buku';

  @override
  String get categoriesItemArticle => 'Artikel';

  @override
  String get categoriesItemVideo => 'Video';

  @override
  String get categoriesFallbackTitle => 'Kategori';

  @override
  String get categoriesNoAttachments => 'Tidak ada lampiran untuk materi ini.';

  @override
  String get categoriesAttachments => 'Lampiran';

  @override
  String get categoriesActionWatch => 'Tonton';

  @override
  String get categoriesActionRead => 'Baca';

  @override
  String get categoriesActionOpen => 'Buka';

  @override
  String categoriesOrder(String order) {
    return 'Urutan $order';
  }

  @override
  String get categoriesDownload => 'Unduh';

  @override
  String get categoriesAttachmentFallback => 'Lampiran';

  @override
  String get categoriesNoChapters => 'Tidak ada bab di bagian ini.';

  @override
  String get categoriesClearSearch => 'Hapus pencarian';

  @override
  String get categoriesAudioLoadError => 'Gagal memuat materi audio.';

  @override
  String categoriesAudioClipNumber(int number) {
    return 'Klip $number';
  }

  @override
  String get categoriesAudioClipFallback => 'Klip audio';

  @override
  String get booksTitle => 'Buku';

  @override
  String get booksLoadError => 'Buku tidak dapat dimuat saat ini.';

  @override
  String get booksEmpty => 'Tidak ada buku untuk ditampilkan.';

  @override
  String get booksFilesHeader => 'File Buku';

  @override
  String get booksNoFilesTitle => 'Tidak ada file';

  @override
  String get booksNoFilesBody => 'Buku ini tidak memiliki file untuk diunduh.';

  @override
  String get booksDescriptionHeader => 'Deskripsi';

  @override
  String get booksReferenceHeader => 'Referensi';

  @override
  String booksFileNumber(int number) {
    return 'File $number';
  }

  @override
  String get booksReadTitle => 'Baca Buku';

  @override
  String get booksViewerFailed =>
      'Buku tidak dapat ditampilkan di dalam aplikasi';

  @override
  String get booksOpenOutsideHint => 'Anda dapat membukanya di luar aplikasi';

  @override
  String get booksOpenOutside => 'Buka di luar aplikasi';

  @override
  String get hadith40Title => 'Hadis Arbain Nawawi';

  @override
  String hadith40Number(int number) {
    return 'Hadis $number';
  }

  @override
  String get hadith40SearchHint => 'Cari hadis';

  @override
  String get hadith40NoResults => 'Tidak ada hasil untuk pencarian ini';

  @override
  String get hadith40ShowAll => 'Tampilkan semua hadis';

  @override
  String hadith40SheetSubtitle(int number) {
    return 'Arbain Nawawi · Hadis $number';
  }

  @override
  String get hadith40Explanation => 'Penjelasan Hadis';

  @override
  String hadith40ShareText(String title, String hadith, String explanation) {
    return '$title\n\n$hadith\n\nPenjelasan hadis:\n$explanation';
  }

  @override
  String get allahNamesTitle => 'Asmaul Husna';

  @override
  String allahNamesNameOrder(int number) {
    return 'Nama ke-$number dari Asmaul Husna';
  }

  @override
  String get allahNamesMeaning => 'Makna';

  @override
  String get allahNamesSearchHint => 'Cari di Asmaul Husna';

  @override
  String get allahNamesNoResultsTitle => 'Tidak ada hasil';

  @override
  String get allahNamesNoResultsMessage =>
      'Tidak ada nama yang cocok dengan pencarian Anda.';

  @override
  String get allahNamesShowAll => 'Tampilkan semua nama';

  @override
  String get readQuranListen => 'Dengarkan';

  @override
  String get readQuranAyah => 'Ayat';

  @override
  String get readQuranTafsir => 'Tafsir Ayat';

  @override
  String get quranAudioPlayPause => 'Putar atau jeda';

  @override
  String audiosTrackNumber(int number) {
    return 'Trek $number';
  }

  @override
  String get audiosTracksHeader => 'Trek';

  @override
  String get audiosSearchSeriesHint => 'Cari serial';

  @override
  String get audiosSeriesSubtitle => 'Serial audio';

  @override
  String get audiosNoSeries => 'Tidak ada serial untuk ditampilkan';

  @override
  String get audiosNoResults => 'Tidak ada hasil untuk pencarian Anda';

  @override
  String get audiosPrevious => 'Sebelumnya';

  @override
  String get audiosNext => 'Berikutnya';

  @override
  String get audiosPause => 'Jeda';

  @override
  String get audiosPlay => 'Putar';

  @override
  String get coreUpdateDownloaded =>
      'Pembaruan telah diunduh, Anda dapat memasangnya sekarang.';

  @override
  String get coreUpdateInstallNow => 'Pasang sekarang';

  @override
  String get coreUpdateAvailableTitle => 'Pembaruan baru tersedia';

  @override
  String coreUpdateAvailableMessage(String version) {
    return 'Versi $version kini tersedia di App Store.';
  }

  @override
  String get coreUpdateWhatsNew => 'Yang baru di versi ini:';

  @override
  String get coreUpdateNow => 'Perbarui sekarang';

  @override
  String get coreExitDialogTitle => 'Perhatian';

  @override
  String get coreExitDialogMessage => 'Yakin ingin keluar dari aplikasi?';

  @override
  String get coreExitConfirmMessage => 'Yakin ingin keluar?';

  @override
  String get coreExitStay => 'Batal';

  @override
  String get coreExitAction => 'Keluar';

  @override
  String get coreDeleteDhikrTitle => 'Hapus zikir?';

  @override
  String get coreDeleteDhikrMessage => 'Yakin ingin menghapus zikir ini?';

  @override
  String get coreFieldRequired => 'Kolom ini wajib diisi';

  @override
  String get coreNoData => 'Tidak ada data.';

  @override
  String get coreNoDataToShow => 'Tidak ada data untuk ditampilkan';

  @override
  String get coreContent => 'Konten';

  @override
  String get coreGenericError => 'Terjadi kesalahan, silakan coba lagi';

  @override
  String get coreLoadDataError => 'Terjadi kesalahan saat memuat data';

  @override
  String coreErrorStatus(String code) {
    return 'Status: $code';
  }

  @override
  String get coreCloseSearch => 'Tutup pencarian';

  @override
  String get coreClear => 'Hapus';

  @override
  String get coreSheetDefaultTitle => 'Tambah baru';

  @override
  String get coreSheetDefaultSubtitle => 'Sesuaikan konten';

  @override
  String get coreCopiedSuccessfully => 'Berhasil disalin';

  @override
  String get coreDownloadStarted => 'Unduhan dimulai';

  @override
  String get coreDownloadCompleted => 'Unduhan selesai';

  @override
  String get coreSaveReadingPositionPrompt => 'Simpan posisi bacaan Anda?';

  @override
  String get coreLocationServiceDisabled =>
      'Layanan lokasi tidak aktif. Aktifkan untuk menentukan jadwal salat.';

  @override
  String get coreLocationPermissionDenied =>
      'Izin akses lokasi tidak diberikan.';

  @override
  String get coreLocationPermissionDeniedForever =>
      'Izin lokasi ditolak permanen. Aktifkan dari pengaturan aplikasi.';

  @override
  String get coreNotNow => 'Jangan sekarang';

  @override
  String get coreAllow => 'Izinkan';

  @override
  String get coreOpenSettings => 'Buka pengaturan';

  @override
  String get coreNotificationPermissionTitle => 'Izin Notifikasi';

  @override
  String get coreNotificationPermissionRationale =>
      'Aplikasi memerlukan izin notifikasi untuk mengingatkan Anda waktu salat dan zikir.\nIni membantu Anda tetap terhubung dengan ajaran Islam sepanjang hari.';

  @override
  String get coreNotificationSettingsTitle => 'Pengaturan Notifikasi';

  @override
  String get coreNotificationPermanentlyDeniedMessage =>
      'Izin notifikasi ditolak secara permanen.\nSilakan buka Pengaturan dan aktifkan notifikasi secara manual.';

  @override
  String get corePermissionStatusGranted => 'Semua izin telah diberikan';

  @override
  String get corePermissionStatusDenied => 'Izin notifikasi ditolak';

  @override
  String get corePermissionStatusPermanentlyDenied =>
      'Izin ditolak secara permanen';

  @override
  String get corePermissionStatusPartial =>
      'Hanya sebagian izin yang diberikan';

  @override
  String get corePermissionStatusUnknown => 'Status izin tidak diketahui';

  @override
  String get corePermissionResultGranted => 'Semua izin berhasil diberikan';

  @override
  String get corePermissionResultDenied => 'Permintaan izin ditolak';

  @override
  String get corePermissionResultPermanentlyDenied =>
      'Izin ditolak secara permanen - silakan buka Pengaturan';

  @override
  String get corePermissionResultPartial =>
      'Sebagian izin diberikan - mungkin perlu izin tambahan';

  @override
  String get corePermissionResultError => 'Terjadi kesalahan saat meminta izin';

  @override
  String get coreNotificationActionOpenApp => 'Buka aplikasi';

  @override
  String get coreNotificationActionDismiss => 'Tutup';

  @override
  String get coreNotificationActionMarkRead => 'Sudah dibaca';

  @override
  String get coreNotificationActionRemindLater => 'Ingatkan nanti';

  @override
  String get coreNotificationGroupName => 'Notifikasi Islami';

  @override
  String get coreNotificationGroupDescription =>
      'Grup notifikasi aplikasi Islami ini';

  @override
  String coreNotificationChannelDescription(String channel) {
    return 'Saluran $channel untuk notifikasi Islami';
  }

  @override
  String get coreNotificationAppLabel => 'Aplikasi Tamaneena';

  @override
  String get coreNotificationMore => 'Selengkapnya...';

  @override
  String coreNotificationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count notifikasi',
      zero: 'Tidak ada notifikasi',
    );
    return '$_temp0';
  }

  @override
  String coreNotificationNewCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count notifikasi baru',
      zero: 'Tidak ada notifikasi baru',
    );
    return '$_temp0';
  }

  @override
  String coreAthanTicker(String prayer) {
    return 'Telah masuk waktu azan $prayer';
  }

  @override
  String coreAthanDescription(String prayer) {
    return 'Azan $prayer';
  }

  @override
  String get coreChannelAthan => 'Tamaneena - Azan';

  @override
  String get coreChannelMohammed => 'Tamaneena - Selawat Nabi';

  @override
  String get coreChannelMorning => 'Tamaneena - Zikir Pagi';

  @override
  String get coreChannelNight => 'Tamaneena - Zikir Petang';

  @override
  String get coreChannelSleep => 'Tamaneena - Zikir Sebelum Tidur';

  @override
  String get coreChannelGetUp => 'Tamaneena - Zikir Bangun Tidur';

  @override
  String get coreChannelMiddleNight => 'Tamaneena - Qiyamul Lail';

  @override
  String get coreChannelRandomThikr => 'Tamaneena - Zikir Acak';

  @override
  String get coreChannelAstgferAllh => 'Tamaneena - Istigfar';

  @override
  String get coreChannelHasbnaAllh => 'Tamaneena - Hasbunallah';

  @override
  String get coreChannelLaHawla =>
      'Tamaneena - La Haula wa La Quwwata Illa Billah';

  @override
  String get coreChannelSubhanAllh => 'Tamaneena - Subhanallah';

  @override
  String get coreChannelDefaultChannel => 'Tamaneena - Notifikasi Umum';

  @override
  String get coreChannelSmartOutreach => 'Tamaneena - Teman Subuh';

  @override
  String get coreFcmChannelHighImportance => 'Tamaneena - Notifikasi Penting';

  @override
  String get coreFcmChannelChat => 'Tamaneena - Pesan';

  @override
  String get coreFcmChannelUpdates => 'Tamaneena - Pembaruan';

  @override
  String get coreFcmChannelHighImportanceDescription =>
      'Saluran notifikasi penting aplikasi Tamaneena';

  @override
  String get coreFcmChannelDefaultDescription =>
      'Saluran notifikasi umum aplikasi Tamaneena';

  @override
  String get coreFcmChannelChatDescription =>
      'Saluran pesan dan peringatan aplikasi Tamaneena';

  @override
  String get coreFcmChannelUpdatesDescription =>
      'Saluran pembaruan aplikasi Tamaneena';

  @override
  String get languageTitle => 'Pilih bahasa Anda';

  @override
  String get languageSubtitle => 'Anda dapat mengubahnya nanti di Pengaturan.';

  @override
  String get languageSettingTitle => 'Bahasa';

  @override
  String get languageSettingSubtitle => 'Bahasa tampilan aplikasi';

  @override
  String get languageReligiousTextNote =>
      'Al-Qur\'an, zikir, dan doa tetap ditampilkan dalam teks Arab aslinya.';

  @override
  String get outreachTitle => 'Teman Subuh';

  @override
  String get outreachTagline =>
      'Daftar panggilan yang tenang untuk mengawali hari orang tercinta dengan kebaikan';

  @override
  String get outreachActionCallOnly => 'Hanya panggilan';

  @override
  String get outreachErrorScheduleNotFound => 'Daftar ini tidak ditemukan.';

  @override
  String get outreachContactsPermissionDenied =>
      'Izinkan akses kontak untuk memilih nomor secara otomatis.';

  @override
  String get outreachContactNoPhone =>
      'Kontak yang dipilih tidak memiliki nomor telepon.';

  @override
  String get outreachContactPickError =>
      'Terjadi kesalahan saat memilih kontak.';

  @override
  String get outreachUnnamed => 'Tanpa nama';

  @override
  String get outreachPermissionPhone => 'Telepon';

  @override
  String get outreachPermissionContacts => 'Kontak';

  @override
  String get outreachPermissionNotifications => 'Notifikasi';

  @override
  String get outreachListSeparator => ', ';

  @override
  String get outreachValidationTitleRequired => 'Tulis nama untuk daftar ini.';

  @override
  String get outreachValidationAddNumber => 'Tambahkan setidaknya satu nomor.';

  @override
  String get outreachValidationEmptyPhone =>
      'Setiap kolom harus berisi nomor telepon.';

  @override
  String get outreachValidationIncompleteNumber =>
      'Ada nomor yang belum lengkap.';

  @override
  String get outreachValidationDuplicateNumber =>
      'Ada nomor ganda di daftar yang sama.';

  @override
  String get outreachValidationPickDay => 'Pilih setidaknya satu hari.';

  @override
  String get outreachValidationEnableWithoutNumbers =>
      'Daftar tanpa nomor tidak dapat diaktifkan.';

  @override
  String get outreachCallLogsTitle => 'Riwayat Panggilan';

  @override
  String get outreachClearLog => 'Hapus riwayat';

  @override
  String get outreachStatTotal => 'Total';

  @override
  String get outreachStatAnswered => 'Menjawab';

  @override
  String get outreachStatNotAnswered => 'Tidak menjawab';

  @override
  String get outreachStatFailed => 'Gagal';

  @override
  String get outreachResultsHeader => 'Hasil';

  @override
  String get outreachNoResultsTitle => 'Belum ada hasil';

  @override
  String get outreachNoResultsMessage =>
      'Hasil setiap panggilan akan muncul di sini setelah dijalankan pertama kali.';

  @override
  String outreachSecondsShort(int seconds) {
    return '${seconds}d';
  }

  @override
  String outreachSecondsValue(int seconds) {
    return '$seconds dtk';
  }

  @override
  String get outreachCallStatusAnswered => 'Dijawab';

  @override
  String get outreachCallStatusNotAnswered => 'Tidak dijawab';

  @override
  String get outreachCallStatusFailed => 'Panggilan gagal';

  @override
  String get outreachExecutionTitle => 'Mulai Panggilan';

  @override
  String get outreachCallsStartedFromAlert =>
      'Panggilan dimulai dari pengingat.';

  @override
  String get outreachCallsStartedNow => 'Panggilan dimulai sekarang.';

  @override
  String get outreachCallsStartFailed =>
      'Panggilan tidak dapat dimulai saat ini. Coba lagi.';

  @override
  String get outreachCallLogsReviewSubtitle =>
      'Lihat siapa yang menjawab dan tidak setelah daftar selesai';

  @override
  String get outreachPreparingCalls => 'Menyiapkan panggilan...';

  @override
  String get outreachDontCloseHint =>
      'Jangan tutup halaman ini sampai proses dimulai.';

  @override
  String get outreachCanCloseHint =>
      'Anda dapat menutup halaman sekarang dan melihat hasilnya di riwayat.';

  @override
  String get outreachAddList => 'Tambah daftar';

  @override
  String get outreachStatLists => 'Daftar';

  @override
  String get outreachStatEnabled => 'Aktif';

  @override
  String get outreachStatNumbers => 'Nomor';

  @override
  String get outreachListsHeader => 'Daftar Panggilan';

  @override
  String get outreachToolsHeader => 'Alat';

  @override
  String get outreachCallLogsSubtitle =>
      'Hasil setiap panggilan: siapa yang menjawab dan tidak';

  @override
  String get outreachSettingsTitle => 'Pengaturan Panggilan';

  @override
  String get outreachSettingsSubtitle =>
      'Durasi bawaan dan perilaku daftar baru';

  @override
  String get outreachNoListsTitle => 'Belum ada daftar';

  @override
  String get outreachNoListsMessage =>
      'Tambahkan daftar, lalu atur waktu dan nomor yang ingin Anda hubungi.';

  @override
  String get outreachStartsNow => 'Dimulai sekarang';

  @override
  String outreachStartsInMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dalam $count menit',
    );
    return '$_temp0';
  }

  @override
  String outreachStartsInHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dalam $count jam',
    );
    return '$_temp0';
  }

  @override
  String outreachStartsInHoursMinutes(int hours, int minutes) {
    return 'Dalam $hours jam $minutes menit';
  }

  @override
  String outreachStartsInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dalam $count hari',
      one: 'Besok',
    );
    return '$_temp0';
  }

  @override
  String outreachPermissionsRequiredSnack(String permissions) {
    return 'Aktifkan izin berikut terlebih dahulu: $permissions';
  }

  @override
  String outreachPermissionsNotice(String permissions) {
    return 'Izin yang diperlukan belum lengkap. Agar daftar berjalan tepat waktu, aktifkan: $permissions';
  }

  @override
  String get outreachGrantPermissions => 'Berikan izin';

  @override
  String get outreachOpenSettings => 'Buka pengaturan';

  @override
  String get outreachSettingsSaved => 'Pengaturan disimpan.';

  @override
  String get outreachSettingsIntro =>
      'Nilai ini diterapkan ke setiap daftar baru.';

  @override
  String get outreachDefaultDurationsHeader => 'Durasi Bawaan';

  @override
  String get outreachRingTimeout => 'Batas waktu dering';

  @override
  String get outreachHangupDelay => 'Tunggu setelah dijawab';

  @override
  String get outreachDelayBetweenEach => 'Jeda antarnomor';

  @override
  String get outreachBehaviorHeader => 'Perilaku Daftar';

  @override
  String get outreachStopAfterFirstAnswerList =>
      'Hentikan daftar setelah jawaban pertama';

  @override
  String get outreachRetryIfNoAnswer => 'Panggil ulang jika tidak dijawab';

  @override
  String get outreachRestartAfterFinish => 'Mulai ulang setelah selesai';

  @override
  String get outreachSaveSettings => 'Simpan pengaturan';

  @override
  String get outreachBackgroundHeader => 'Berjalan di Latar Belakang';

  @override
  String get outreachBatteryTitle =>
      'Kecualikan aplikasi dari penghemat baterai';

  @override
  String get outreachBatterySubtitle =>
      'Jika daftar berhenti saat di latar belakang, izinkan aplikasi berjalan dari pengaturan baterai.';

  @override
  String get outreachEditList => 'Edit daftar';

  @override
  String get outreachNewList => 'Daftar baru';

  @override
  String get outreachCallTimeHeader => 'Waktu Panggilan';

  @override
  String get outreachManualTime => 'Pilih waktu manual';

  @override
  String get outreachManualTimeSubtitle => 'Tentukan jam dan menit sendiri';

  @override
  String get outreachUseFajrTime => 'Gunakan waktu Subuh';

  @override
  String outreachUseFajrTimeWithTime(String time) {
    return 'Gunakan waktu Subuh · $time';
  }

  @override
  String get outreachPrayerTimesNotReady => 'Jadwal salat belum siap';

  @override
  String get outreachFajrAutoFill =>
      'Waktu diisi otomatis dari jadwal hari ini';

  @override
  String get outreachFajrUnavailable =>
      'Waktu Subuh belum tersedia. Coba lagi sebentar.';

  @override
  String outreachFajrTimeUsed(String time) {
    return 'Waktu Subuh digunakan: $time';
  }

  @override
  String get outreachContactFetchFailed =>
      'Kontak tidak dapat diambil saat ini.';

  @override
  String get outreachExactAlarmHint =>
      'Agar Teman Subuh berjalan tepat waktu, aktifkan izin alarm presisi di pengaturan perangkat.';

  @override
  String get outreachListNameHeader => 'Nama Daftar';

  @override
  String get outreachStartTime => 'Waktu mulai';

  @override
  String get outreachStartTimeHint =>
      'Pilih waktu manual atau gunakan waktu Subuh';

  @override
  String outreachFajrTimeToday(String time) {
    return 'Waktu Subuh hari ini $time';
  }

  @override
  String outreachContactsHeader(int count) {
    return 'Kontak · $count';
  }

  @override
  String get outreachPickFromContacts => 'Pilih dari kontak';

  @override
  String get outreachPickFromContactsSubtitle =>
      'Tambahkan nomor baru ke daftar ini';

  @override
  String get outreachAdvancedSettings => 'Pengaturan lanjutan';

  @override
  String get outreachAdvancedSettingsSubtitle =>
      'Hari, durasi tunggu, dan pengulangan';

  @override
  String get outreachSaving => 'Menyimpan...';

  @override
  String get outreachSaveList => 'Simpan daftar';

  @override
  String get outreachNoNumbersYet => 'Belum ada nomor yang ditambahkan.';

  @override
  String get outreachEnableList => 'Aktifkan daftar ini';

  @override
  String get outreachDailyRepeat => 'Ulangi setiap hari';

  @override
  String get outreachEveryDay => 'Setiap hari';

  @override
  String get outreachSelectedWeekdays => 'Hari tertentu dalam seminggu';

  @override
  String get outreachDelayBetweenNumbers => 'Jeda antarnomor';

  @override
  String get outreachStopAfterFirstAnswer => 'Berhenti setelah jawaban pertama';

  @override
  String get outreachRetryOnNoAnswer => 'Ulangi jika tidak dijawab';

  @override
  String get outreachRepeatWholeCycle => 'Ulangi seluruh putaran';

  @override
  String get outreachListNameHint => 'Contoh: Pengingat Subuh';

  @override
  String get outreachTitleFieldRequired => 'Tulis nama untuk daftar ini';

  @override
  String get outreachPickNumber => 'Pilih nomor';

  @override
  String get outreachMultipleNumbers =>
      'Kontak ini memiliki lebih dari satu nomor.';

  @override
  String get outreachNoDays => 'Tanpa hari tertentu';

  @override
  String outreachContactsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nomor',
      zero: 'Tanpa nomor',
    );
    return '$_temp0';
  }

  @override
  String outreachMetaRing(int seconds) {
    return 'Dering ${seconds}d';
  }

  @override
  String outreachMetaAfterAnswer(int seconds) {
    return 'Setelah dijawab ${seconds}d';
  }

  @override
  String outreachMetaBetween(int seconds) {
    return 'Antarnomor ${seconds}d';
  }

  @override
  String get outreachNearest => 'Terdekat';

  @override
  String get outreachStartNow => 'Mulai sekarang';

  @override
  String get outreachStatusActive => 'Aktif';

  @override
  String get outreachStatusStopped => 'Berhenti';

  @override
  String outreachStatusSemantics(String status) {
    return 'Status: $status';
  }

  @override
  String get outreachWeekday1 => 'Senin';

  @override
  String get outreachWeekday2 => 'Selasa';

  @override
  String get outreachWeekday3 => 'Rabu';

  @override
  String get outreachWeekday4 => 'Kamis';

  @override
  String get outreachWeekday5 => 'Jumat';

  @override
  String get outreachWeekday6 => 'Sabtu';

  @override
  String get outreachWeekday7 => 'Minggu';

  @override
  String get travelerServicesTitle => 'Layanan Musafir';

  @override
  String get travelerNearbyMosques => 'Masjid terdekat';

  @override
  String get travelerNearbyHalalRestaurants => 'Restoran halal terdekat';

  @override
  String get travelerHalalRestaurants => 'Restoran halal';

  @override
  String get travelerHintAroundYou => 'Di sekitar Anda';

  @override
  String get travelerHintWithCounter => 'Dengan penghitung';

  @override
  String get travelerHintByCountry => 'Sesuai negara Anda';

  @override
  String get travelerFlightPrayer => 'Salat di Pesawat';

  @override
  String get travelerHintByFlightNumber => 'Dengan nomor penerbangan';

  @override
  String get travelerSetLocationForMakkah =>
      'Atur lokasi Anda di jadwal salat untuk melihat jarak ke Makkah.';

  @override
  String get travelerInMakkah =>
      'Anda berada di Makkah Al-Mukarramah — semoga Allah menerima ibadah Anda.';

  @override
  String get travelerYourLocation => 'Lokasi Anda';

  @override
  String get travelerMakkah => 'Makkah Al-Mukarramah';

  @override
  String get travelerQibla => 'Kiblat';

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
  String get travelerDirectionN => 'Utara';

  @override
  String get travelerDirectionNE => 'Timur laut';

  @override
  String get travelerDirectionE => 'Timur';

  @override
  String get travelerDirectionSE => 'Tenggara';

  @override
  String get travelerDirectionS => 'Selatan';

  @override
  String get travelerDirectionSW => 'Barat daya';

  @override
  String get travelerDirectionW => 'Barat';

  @override
  String get travelerDirectionNW => 'Barat laut';

  @override
  String get travelerPrayerUnknown => 'Tidak diketahui';

  @override
  String get travelerPrayerShortFajr => 'Subuh';

  @override
  String get travelerPrayerShortSunrise => 'Terbit';

  @override
  String get travelerPrayerShortDhuhr => 'Zuhur';

  @override
  String get travelerPrayerShortAsr => 'Asar';

  @override
  String get travelerPrayerShortMaghrib => 'Magrib';

  @override
  String get travelerPrayerShortIsha => 'Isya';

  @override
  String get travelerNoMosquesFound =>
      'Tidak ada masjid ditemukan dalam jangkauan saat ini.';

  @override
  String get travelerNoRestaurantsFound =>
      'Tidak ada restoran halal ditemukan dalam jangkauan ini.';

  @override
  String travelerWalkingMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count menit jalan kaki',
    );
    return '$_temp0';
  }

  @override
  String get travelerDefaultMosqueName => 'Masjid terdekat';

  @override
  String get travelerDefaultRestaurantName => 'Restoran halal';

  @override
  String get travelerNoDetailedAddress => 'Tanpa alamat lengkap';

  @override
  String get travelerRepeatBySituation => 'Sesuai keadaan';

  @override
  String get travelerRepeatOnce => '1 kali';

  @override
  String travelerRepeatTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kali',
    );
    return '$_temp0';
  }

  @override
  String get travelerStageStart => 'Saat memulai perjalanan';

  @override
  String get travelerStageOnTheWay => 'Di perjalanan';

  @override
  String get travelerStageStop => 'Saat singgah';

  @override
  String get travelerStageReturn => 'Saat pulang';

  @override
  String get travelerStageFarewell => 'Melepas musafir';

  @override
  String get travelerStageFarewellReply => 'Doa untuk musafir';

  @override
  String get travelerAthkarTitle => 'Zikir Safar';

  @override
  String get travelerAthkarLoadFailed => 'Gagal memuat zikir safar.';

  @override
  String get travelerFarewellTitle => 'Bagi yang melepas musafir';

  @override
  String get travelerFarewellCaption =>
      'Bukan untuk perjalananmu — melainkan untuk yang kau tinggalkan';

  @override
  String get travelerRoadComplete => 'Zikir perjalananmu telah selesai';

  @override
  String get travelerRoadStations => 'Tahapan Perjalanan';

  @override
  String get travelerRoadCompleteCaption => 'Semoga keselamatan menyertaimu.';

  @override
  String get travelerRoadCaption =>
      'Setiap zikir ada tempatnya dalam perjalanan — buka tahapan tempat Anda berada.';

  @override
  String travelerShareVirtue(String virtue) {
    return 'Keutamaan: $virtue';
  }

  @override
  String travelerShareSource(String source, String hadith) {
    return 'Sumber: $source ($hadith)';
  }

  @override
  String get travelerResetCounter => 'Atur ulang hitungan';

  @override
  String get travelerCounterDone => 'Selesai';

  @override
  String get travelerCounterCount => 'Hitung';

  @override
  String get travelerCountDhikr => 'Hitung zikir';

  @override
  String get travelerFlightPrayerTitle => 'Jadwal Salat di Pesawat';

  @override
  String get travelerShowTimes => 'Tampilkan jadwal';

  @override
  String get travelerShowMap => 'Tampilkan peta';

  @override
  String get travelerShowList => 'Tampilkan daftar';

  @override
  String get travelerSearchByFlightNumber => 'Cari dengan nomor penerbangan';

  @override
  String get travelerRunSearchNow => 'Cari sekarang';

  @override
  String get travelerFlightAttemptsExhausted =>
      'Kesempatan pencarian habis. Buka ulang halaman untuk mencoba lagi.';

  @override
  String get travelerFlightNumberInvalid =>
      'Nomor penerbangan tidak valid. Contoh: EK202 atau MS985';

  @override
  String get travelerFlightFetchFailed =>
      'Data penerbangan tidak dapat diambil saat ini.';

  @override
  String get travelerSourceMock => 'Simulasi lokal (tanpa API)';

  @override
  String get travelerCityRiyadh => 'Riyadh';

  @override
  String get travelerCityJeddah => 'Jeddah';

  @override
  String get travelerCityDubai => 'Dubai';

  @override
  String get travelerCityDoha => 'Doha';

  @override
  String get travelerCityIstanbul => 'Istanbul';

  @override
  String get travelerCityCairo => 'Kairo';

  @override
  String get travelerCityKualaLumpur => 'Kuala Lumpur';

  @override
  String get travelerCityLondon => 'London';

  @override
  String get travelerCityParis => 'Paris';

  @override
  String get travelerCityNewYork => 'New York';

  @override
  String get travelerAttemptsRemaining => 'Sisa percobaan';

  @override
  String get travelerLiveTrack => 'Rute langsung';

  @override
  String get travelerTakeoff => 'Lepas landas';

  @override
  String get travelerLanding => 'Mendarat';

  @override
  String get travelerFlightEnded =>
      'Penerbangan telah berakhir — tidak ada lagi waktu salat di pesawat.';

  @override
  String get travelerNoPrayerDuringFlight =>
      'Tidak ada waktu salat selama durasi penerbangan ini.';

  @override
  String get travelerAllFlightPrayersPassed =>
      'Semua waktu salat dalam penerbangan ini telah lewat.';

  @override
  String travelerCountdownHoursMinutes(int hours, int minutes) {
    return 'Dalam $hours j $minutes m';
  }

  @override
  String travelerCountdownMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dalam $count menit',
    );
    return '$_temp0';
  }

  @override
  String travelerNextPrayerAboard(String prayer, String countdown) {
    return '$prayer di pesawat — $countdown';
  }

  @override
  String travelerFirstPrayerAboard(String prayer) {
    return 'Salat pertama di pesawat: $prayer';
  }

  @override
  String travelerAtPlaneLocalTime(String time, String offset) {
    return '$time waktu posisi pesawat ($offset)';
  }

  @override
  String get travelerLocalTimeAbovePlane =>
      'Waktu setempat di bawah posisi pesawat';

  @override
  String get travelerTapStopHint =>
      'Ketuk titik mana pun untuk melihat posisinya di peta';

  @override
  String get travelerUpcoming => 'Akan datang';

  @override
  String get travelerNext => 'Berikutnya';

  @override
  String travelerStopGmt(String place, String time) {
    return '$place · GMT $time';
  }

  @override
  String get travelerSearchByFlightNumberHeader =>
      'Cari dengan nomor penerbangan';

  @override
  String get travelerRun => 'Cari';

  @override
  String get travelerFlightSearchHint =>
      'Masukkan nomor penerbangan untuk menghitung jadwal salat sepanjang rute.';

  @override
  String get travelerFlightDetails => 'Detail Penerbangan';

  @override
  String get travelerFlightNumber => 'Nomor penerbangan';

  @override
  String get travelerFrom => 'Dari';

  @override
  String get travelerTo => 'Ke';

  @override
  String get travelerDataSource => 'Sumber data';

  @override
  String get travelerFlightTimeline => 'Linimasa Penerbangan';

  @override
  String get travelerNoTimesDuringFlight =>
      'Tidak ada jadwal salat selama durasi penerbangan ini.';

  @override
  String get travelerFlightNumberExample => 'Contoh: EK202';

  @override
  String get travelerShowFullRoute => 'Tampilkan seluruh rute';

  @override
  String get travelerZoomIn => 'Perbesar';

  @override
  String get travelerZoomOut => 'Perkecil';

  @override
  String get travelerLocationFailed =>
      'Lokasi Anda saat ini tidak dapat ditentukan. Coba lagi.';

  @override
  String get travelerLocationServiceDisabled =>
      'Layanan lokasi tidak aktif. Aktifkan untuk menampilkan hasil terdekat.';

  @override
  String get travelerLocationPermissionRequired =>
      'Izin lokasi diperlukan agar fitur ini berfungsi.';

  @override
  String get travelerLocationPermissionDeniedForever =>
      'Izin lokasi ditolak permanen. Buka pengaturan aplikasi.';

  @override
  String get travelerPlacesFetchFailed =>
      'Hasil terdekat tidak dapat diambil saat ini. Coba lagi.';

  @override
  String get travelerExpandRadius => 'Perluas jangkauan';

  @override
  String travelerAllWithinRadius(String radius) {
    return 'Semuanya dalam jarak $radius — panah menunjukkan arah masing-masing.';
  }

  @override
  String get travelerRadius => 'Jangkauan';

  @override
  String get travelerNearestPlaces => 'Tempat Terdekat';

  @override
  String travelerFoundResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ditemukan $count hasil di dekat Anda',
    );
    return '$_temp0';
  }

  @override
  String get travelerUnexpectedError => 'Terjadi kesalahan tak terduga';

  @override
  String get travelerHalalRestricted =>
      'Pencarian restoran halal tidak tersedia di negara-negara Muslim,\nkarena restorannya pada dasarnya sudah halal.';

  @override
  String get travelerOpenMapsFailed => 'Aplikasi peta tidak dapat dibuka.';

  @override
  String get travelerNearestMosque => 'Masjid terdekat dari Anda';

  @override
  String get travelerNearestRestaurant => 'Restoran halal terdekat';

  @override
  String get travelerTakeMeThere => 'Antar saya ke sana';

  @override
  String travelerWillMakeIt(int count, String prayer) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sempat untuk $prayer — tersisa $count menit',
    );
    return '$_temp0';
  }

  @override
  String travelerMightMiss(int count, String prayer) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Mungkin tidak sempat $prayer jika berjalan kaki — tersisa $count menit',
    );
    return '$_temp0';
  }

  @override
  String get travelerOpenInGoogleMaps => 'Buka di Google Maps';

  @override
  String get travelerTapMarkerHint => 'Ketuk penanda untuk melihat detail';

  @override
  String get travelerOpenPhoneFailed => 'Aplikasi telepon tidak dapat dibuka.';

  @override
  String get travelerOpenLinkFailed => 'Tautan tidak dapat dibuka.';

  @override
  String get travelerDirections => 'Rute';

  @override
  String get travelerGoogleMaps => 'Google Maps';

  @override
  String get travelerCall => 'Telepon';

  @override
  String get travelerUpdating => 'Memperbarui…';

  @override
  String travelerResultsCount(int count) {
    return 'Jumlah hasil $count';
  }

  @override
  String get travelerMyCurrentLocation => 'Lokasi saya saat ini';

  @override
  String get travelerMaps => 'Peta';

  @override
  String get travelerMyLocation => 'Lokasi saya';

  @override
  String get qiblahTitle => 'Kiblat';

  @override
  String get qiblahRefreshTooltip => 'Perbarui arah';

  @override
  String get qiblahErrorNoSensor =>
      'Perangkat Anda tidak mendukung sensor arah';

  @override
  String get qiblahErrorPermissionRequired =>
      'Izinkan akses lokasi untuk menentukan arah kiblat';

  @override
  String qiblahErrorGeneric(String error) {
    return 'Terjadi kesalahan saat menentukan arah kiblat: $error';
  }

  @override
  String get qiblahErrorLocationServiceOff =>
      'Layanan lokasi tidak aktif. Silakan aktifkan di Pengaturan';

  @override
  String get qiblahErrorPermissionDeniedForever =>
      'Izin lokasi ditolak permanen. Silakan aktifkan di pengaturan aplikasi';

  @override
  String get qiblahErrorLocationFailed => 'Gagal mendapatkan lokasi saat ini';

  @override
  String get qiblahUnknownLocation => 'Lokasi tidak diketahui';

  @override
  String qiblahErrorDirection(String error) {
    return 'Kesalahan menentukan arah: $error';
  }

  @override
  String get qiblahErrorStreamFailed => 'Gagal memulai pelacakan arah';

  @override
  String get qiblahLocating => 'Menentukan lokasi...';

  @override
  String get qiblahAligned => 'Anda sudah menghadap kiblat';

  @override
  String qiblahTurnLeft(int degrees) {
    return 'Putar ke kiri $degrees°';
  }

  @override
  String qiblahTurnRight(int degrees) {
    return 'Putar ke kanan $degrees°';
  }

  @override
  String get qiblahLoadingTitle => 'Menentukan arah kiblat';

  @override
  String get qiblahLoadingSubtitle =>
      'Pastikan lokasi aktif dan izin telah diberikan';

  @override
  String get qiblahHintAligned =>
      'Tahan perangkat, panah sudah di tanda kiblat';

  @override
  String get qiblahHintMove =>
      'Gerakkan perangkat perlahan hingga panah mencapai tanda';

  @override
  String get qiblahReadingsHeader => 'Pembacaan Kompas';

  @override
  String get qiblahCurrentHeading => 'Arah Anda saat ini';

  @override
  String get qiblahAngle => 'Sudut kiblat';

  @override
  String get qiblahCurrentLocation => 'Lokasi Anda saat ini';

  @override
  String get qiblahDistanceToMecca => 'Jarak ke Makkah';

  @override
  String qiblahDistanceKm(int km) {
    return '$km km';
  }

  @override
  String get qiblahInstructionsHeader => 'Petunjuk Penggunaan';

  @override
  String get qiblahInstructions =>
      '• Pegang ponsel mendatar di depan Anda.\n• Bergeraklah perlahan hingga panah emas bertemu tanda di atas.\n• Saat sejajar, lingkaran akan menyala dan terasa getaran ringan.\n• Jauhkan benda logam dari ponsel.\n• Jika penunjuk tidak stabil, gerakkan ponsel membentuk angka 8.';

  @override
  String get qiblahCompassNorth => 'U';

  @override
  String get qiblahCompassEast => 'T';

  @override
  String get qiblahCompassSouth => 'S';

  @override
  String get qiblahCompassWest => 'B';

  @override
  String get homeSectionYourDay => 'Hari Anda';

  @override
  String get homeSectionAyah => 'Ayat Al-Qur\'an';

  @override
  String get homeSectionFeatures => 'Fitur';

  @override
  String get homeSectionKids => 'Bagian Anak';

  @override
  String get homeYoungMuslimTitle => 'Muslim Cilik';

  @override
  String get homeYoungMuslimSubtitle => 'Kisah, adab, dan zikir untuk anak';

  @override
  String homeUpdateAvailable(String version) {
    return 'Ada pembaruan baru · Versi $version';
  }

  @override
  String get homeUpdateAction => 'Perbarui';

  @override
  String get homeContinueReading => 'Lanjutkan membaca';

  @override
  String get homeStartReading => 'Mulai membaca';

  @override
  String homeContinueReadingPosition(String surah, int page) {
    return '$surah · Halaman $page';
  }

  @override
  String get homeStartReadingPosition => 'Dari Surah Al-Fatihah · Halaman 1';

  @override
  String homeAyahReference(String surah, int number) {
    return '$surah · Ayat $number';
  }

  @override
  String homeAyahNumber(int number) {
    return 'Ayat $number';
  }

  @override
  String get homeAnotherAyah => 'Ayat lain';

  @override
  String get homeReadInMushaf => 'Baca di mushaf';

  @override
  String get homeTrackerComplete =>
      'Salat hari ini telah lengkap, semoga Allah menerimanya';

  @override
  String get homeTrackerPrompt =>
      'Tandai salat yang sudah Anda kerjakan hari ini';

  @override
  String homeTrackerProgress(int count, int total) {
    return '$count dari $total';
  }

  @override
  String homeTrackerStreak(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days hari berturut-turut',
      one: '1 hari',
    );
    return '$_temp0';
  }

  @override
  String get homeNavHome => 'Beranda';

  @override
  String get homeNavSections => 'Kategori';

  @override
  String homeNextPrayerRemaining(String prayer, String time, String remaining) {
    return '$prayer: $time\nSisa waktu: $remaining';
  }

  @override
  String get prayerTimeHighLatAuto => 'Otomatis';

  @override
  String get prayerTimeHighLatAutoDesc =>
      'Mengikuti nilai bawaan metode perhitungan.';

  @override
  String get prayerTimeHighLatMiddleOfNight => 'Tengah malam';

  @override
  String get prayerTimeHighLatMiddleOfNightDesc =>
      'Subuh tidak lebih awal dari tengah malam dan Isya tidak lebih lambat darinya.';

  @override
  String get prayerTimeHighLatSeventhOfNight => 'Sepertujuh malam';

  @override
  String get prayerTimeHighLatSeventhOfNightDesc =>
      'Menggunakan sepertujuh terakhir malam untuk Subuh dan sepertujuh pertama untuk Isya.';

  @override
  String get prayerTimeHighLatTwilightAngle => 'Sudut senja';

  @override
  String get prayerTimeHighLatTwilightAngleDesc =>
      'Membagi malam berdasarkan sudut Subuh dan Isya yang dipilih.';

  @override
  String get prayerTimeIshaModeAngle => 'Isya dengan sudut';

  @override
  String get prayerTimeIshaModeAngleDesc =>
      'Isya dihitung berdasarkan sudut matahari di bawah ufuk.';

  @override
  String get prayerTimeIshaModeInterval => 'Isya dengan interval';

  @override
  String get prayerTimeIshaModeIntervalDesc =>
      'Isya dihitung dengan jumlah menit tetap setelah Magrib.';

  @override
  String get prayerTimeMethodUmmAlQura => 'Umm al-Qura - Makkah';

  @override
  String get prayerTimeMethodMuslimWorldLeague => 'Liga Muslim Dunia (MWL)';

  @override
  String get prayerTimeMethodEgyptian => 'Otoritas Survei Umum Mesir';

  @override
  String get prayerTimeMethodKarachi => 'Universitas Ilmu Islam Karachi';

  @override
  String get prayerTimeMethodDubai => 'Dubai';

  @override
  String get prayerTimeMethodQatar => 'Qatar';

  @override
  String get prayerTimeMethodKuwait => 'Kuwait';

  @override
  String get prayerTimeMethodSingapore => 'Singapura';

  @override
  String get prayerTimeMethodTurkey => 'Diyanet - Turki';

  @override
  String get prayerTimeMethodTehran => 'Institut Geofisika Universitas Teheran';

  @override
  String get prayerTimeMethodMoonSighting => 'Moonsighting Committee';

  @override
  String get prayerTimeMethodNorthAmerica => 'ISNA - Amerika Utara';

  @override
  String get prayerTimeMethodCustom => 'Pengaturan kustom';

  @override
  String get prayerTimeMethodUmmAlQuraDesc =>
      'Subuh 18,5° dan Isya 90 menit setelah Magrib.';

  @override
  String get prayerTimeMethodMuslimWorldLeagueDesc => 'Subuh 18° dan Isya 17°.';

  @override
  String get prayerTimeMethodEgyptianDesc => 'Subuh 19,5° dan Isya 17,5°.';

  @override
  String get prayerTimeMethodKarachiDesc => 'Subuh 18° dan Isya 18°.';

  @override
  String get prayerTimeMethodDubaiDesc => 'Subuh dan Isya 18,2°.';

  @override
  String get prayerTimeMethodQatarDesc =>
      'Subuh 18° dan Isya 90 menit setelah Magrib.';

  @override
  String get prayerTimeMethodKuwaitDesc => 'Subuh 18° dan Isya 17,5°.';

  @override
  String get prayerTimeMethodSingaporeDesc => 'Subuh 20° dan Isya 18°.';

  @override
  String get prayerTimeMethodTurkeyDesc =>
      'Subuh 18° dan Isya 17° dengan penyesuaian Diyanet.';

  @override
  String get prayerTimeMethodTehranDesc =>
      'Subuh 17,7°, Isya 14°, dan Magrib 4,5°.';

  @override
  String get prayerTimeMethodMoonSightingDesc =>
      'Subuh 18° dan Isya 18° dengan penyesuaian musiman.';

  @override
  String get prayerTimeMethodNorthAmericaDesc => 'Subuh 15° dan Isya 15°.';

  @override
  String get prayerTimeMethodCustomDesc =>
      'Tentukan sendiri sudut Subuh, Isya, dan Magrib.';

  @override
  String get prayerTimeMadhabShafi => 'Syafi\'i, Maliki, dan Hanbali';

  @override
  String get prayerTimeMadhabHanafi => 'Hanafi';

  @override
  String get prayerTimeMadhabShafiDesc =>
      'Asar dimulai saat bayangan benda sama panjang dengan bendanya; juga pendapat Maliki dan Hanbali.';

  @override
  String get prayerTimeMadhabHanafiDesc =>
      'Asar dimulai saat bayangan benda dua kali panjang bendanya.';

  @override
  String get prayerTimeCalcIntro =>
      'Pilih metode yang digunakan otoritas setempat, dan sesuaikan jadwal secara manual bila perlu agar sama dengan masjid terdekat.';

  @override
  String get prayerTimeCalcMethod => 'Metode perhitungan';

  @override
  String get prayerTimeCalcAsrMadhab => 'Mazhab perhitungan Asar';

  @override
  String get prayerTimeMadhabShafiShort => 'Syafi\'i';

  @override
  String get prayerTimeCalcHighLatitude => 'Lintang tinggi';

  @override
  String get prayerTimeCalcRamadanIsha => 'Tunda Isya saat Ramadan';

  @override
  String get prayerTimeCalcRamadanIshaHint =>
      'Menambah 30 menit pada Isya selama sebulan penuh, seperti kalender Umm al-Qura.';

  @override
  String get prayerTimeCalcRestoreDefaults =>
      'Kembalikan pengaturan Umm al-Qura';

  @override
  String get prayerTimeCalcCustomAngles => 'Sudut Perhitungan Kustom';

  @override
  String get prayerTimeCalcFajrAngle => 'Sudut Subuh';

  @override
  String get prayerTimeCalcIshaMode => 'Perhitungan Isya';

  @override
  String get prayerTimeCalcIshaModeHint =>
      'Dengan sudut senja, atau dengan jeda tetap setelah Magrib.';

  @override
  String get prayerTimeCalcIshaAngle => 'Sudut Isya';

  @override
  String get prayerTimeCalcIshaAfterMaghrib => 'Isya setelah Magrib';

  @override
  String get prayerTimeCalcMaghribAngleToggle => 'Sudut Magrib, bukan terbenam';

  @override
  String get prayerTimeCalcMaghribAngleToggleHint =>
      'Bagi yang memakai sudut senja untuk Magrib, bukan saat matahari terbenam.';

  @override
  String get prayerTimeCalcMaghribAngle => 'Sudut Magrib';

  @override
  String prayerTimeMinutesShort(String value) {
    return '$value mnt';
  }

  @override
  String get prayerTimeMinutesZero => '0 mnt';

  @override
  String get prayerTimeCalcManualAdjust => 'Penyesuaian manual tiap waktu';

  @override
  String get prayerTimeCalcManualAdjustHint =>
      'Samakan jadwal dengan masjid terdekat hingga hitungan menit';

  @override
  String prayerTimeCalcManualAdjustCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count waktu disesuaikan manual',
    );
    return '$_temp0';
  }

  @override
  String get prayerTimeGenericPrayer => 'Salat';

  @override
  String prayerTimeAthanTitle(String prayer) {
    return 'Azan $prayer';
  }

  @override
  String prayerTimeAthanTitleWithTime(String prayer, String time) {
    return 'Azan $prayer • $time';
  }

  @override
  String get prayerTimeAthanBodyFajr =>
      'Mari salat — awali harimu dengan cahaya Subuh.';

  @override
  String get prayerTimeAthanBodyDhuhr => 'Jadikan ia istirahat bagi hati.';

  @override
  String get prayerTimeAthanBodyAsr => 'Perbarui kehadiranmu bersama Allah.';

  @override
  String get prayerTimeAthanBodyMaghrib =>
      'Tutup harimu dengan ketaatan dan ketenangan.';

  @override
  String get prayerTimeAthanBodyIsha => 'Jangan lewatkan salat penutup hari.';

  @override
  String get prayerTimeAthanBodyDefault => 'Semoga Allah menerima ibadahmu.';

  @override
  String get prayerTimeAthanExpandedHint =>
      'Ketuk untuk membuka pengingat salat dan detailnya.';

  @override
  String prayerTimeAthanTicker(String prayer) {
    return 'Telah masuk waktu azan $prayer';
  }

  @override
  String get prayerTimeAlertNow => 'Telah masuk waktu salat';

  @override
  String get prayerTimeAlertMessage =>
      'Dirikan salatmu dengan khusyuk, karena ia cahaya hati dan ketenangan jiwa.';

  @override
  String get prayerTimeAlertReady => 'Saya siap salat';

  @override
  String get prayerTimeAlertOpenTimes => 'Buka halaman jadwal salat';

  @override
  String get prayerTimeTitle => 'Jadwal Salat';

  @override
  String get prayerTimeSettingsTitle => 'Pengaturan Jadwal Salat';

  @override
  String get prayerTimeSheetAthanTime => 'Waktu azan';

  @override
  String get prayerTimeSheetUntilDhuhr => 'Hingga Zuhur';

  @override
  String get prayerTimeSheetWindow => 'Durasi waktu';

  @override
  String get prayerTimeSheetShift => 'Selisih dari hari ini';

  @override
  String get prayerTimeWeekdaySat => 'Sab';

  @override
  String get prayerTimeWeekdaySun => 'Min';

  @override
  String get prayerTimeWeekdayMon => 'Sen';

  @override
  String get prayerTimeWeekdayTue => 'Sel';

  @override
  String get prayerTimeWeekdayWed => 'Rab';

  @override
  String get prayerTimeWeekdayThu => 'Kam';

  @override
  String get prayerTimeWeekdayFri => 'Jum';

  @override
  String get prayerTimeLessThanMinute => 'Kurang dari semenit';

  @override
  String prayerTimeHoursShort(int hours) {
    return '$hours j';
  }

  @override
  String prayerTimeHoursMinutesShort(int hours, int minutes) {
    return '$hours j $minutes mnt';
  }

  @override
  String get prayerTimeShiftSameDay => 'Hari ini';

  @override
  String get prayerTimeShiftNone => 'Tanpa selisih';

  @override
  String prayerTimeShiftLater(int minutes) {
    return '$minutes mnt lebih lambat';
  }

  @override
  String prayerTimeShiftEarlier(int minutes) {
    return '$minutes mnt lebih awal';
  }

  @override
  String get prayerTimeAm => 'AM';

  @override
  String get prayerTimePm => 'PM';

  @override
  String get prayerTimeLocationSourceManual => 'Pilihan manual';

  @override
  String get prayerTimeLocationSourceDevice => 'Lokasi perangkat';

  @override
  String get prayerTimeLocationPickHint =>
      'Pilih kota atau gunakan lokasi perangkat';

  @override
  String prayerTimeLocationDetails(String details, String source) {
    return '$details · $source';
  }

  @override
  String get prayerTimeLocationNotSet => 'Lokasi belum diatur';

  @override
  String get prayerTimeMyLocation => 'Lokasi saya saat ini';

  @override
  String get prayerTimeGrantPermission => 'Berikan izin';

  @override
  String get prayerTimeEmptyWeekTitle =>
      'Atur lokasi Anda untuk menampilkan jadwal mingguan';

  @override
  String get prayerTimeEmptyWeekSubtitle =>
      'Cari kota Anda atau gunakan lokasi perangkat';

  @override
  String get prayerTimeSetLocation => 'Atur lokasi';

  @override
  String get prayerTimeWeekNeedsCity =>
      'Atur kota Anda untuk melihat jadwal sepekan penuh';

  @override
  String get prayerTimeWeekHint =>
      'Geser tabel ke samping untuk hari lainnya · Ketuk waktu untuk detailnya';

  @override
  String prayerTimeNightPrayerHeader(String day) {
    return 'Qiyamul Lail · $day';
  }

  @override
  String get prayerTimeMidnight => 'Tengah malam';

  @override
  String get prayerTimeMidnightHint => 'Pertengahan antara Magrib dan Subuh';

  @override
  String get prayerTimeLastThird => 'Sepertiga malam terakhir';

  @override
  String get prayerTimeLastThirdHint =>
      'Waktu terbaik untuk qiyamul lail dan berdoa';

  @override
  String get prayerTimeLocationHeader => 'Lokasi';

  @override
  String get prayerTimeLocationUpdateFailed =>
      'Lokasi saat ini tidak dapat diperbarui.';

  @override
  String get prayerTimeToday => 'Hari ini';

  @override
  String get prayerTimeTomorrow => 'Besok';

  @override
  String get prayerTimeTablePrayerColumn => 'Salat';

  @override
  String get prayerTimeSettingsCalcHeader => 'Metode Perhitungan Jadwal';

  @override
  String get prayerTimeSettingsSilentHeader => 'Mode Senyap Saat Salat';

  @override
  String get prayerTimeSilentNeedsPermission =>
      'Berikan izin Jangan Ganggu terlebih dahulu agar fitur ini berfungsi.';

  @override
  String get prayerTimeSettingsSaved => 'Pengaturan jadwal salat disimpan.';

  @override
  String get prayerTimeSilentHint =>
      'Mengubah ponsel ke mode senyap saat waktu salat, lalu mengembalikan suara otomatis.';

  @override
  String get prayerTimeSilentEnable => 'Aktifkan senyap otomatis';

  @override
  String get prayerTimeSilentPermissionNote =>
      'Fitur ini memerlukan izin «Jangan Ganggu» dari sistem.';

  @override
  String get prayerTimeSilentDuration => 'Durasi senyap setelah salat';

  @override
  String get prayerTimeMinutesSuffix => 'mnt';

  @override
  String get prayerTimeSaving => 'Menyimpan';

  @override
  String get prayerTimeSaveSettings => 'Simpan pengaturan';

  @override
  String get prayerTimeSavedLocation => 'Lokasi tersimpan';

  @override
  String get prayerTimePickerMapPointLabel => 'Lokasi yang dipilih di peta';

  @override
  String get prayerTimePickerResolving => 'Membaca nama lokasi yang dipilih...';

  @override
  String get prayerTimePickerTapMap => 'Ketuk peta untuk menentukan wilayah';

  @override
  String get prayerTimePickerTitle => 'Pilih Wilayah';

  @override
  String get prayerTimePickerSubtitle => 'Cari atau pilih titik di peta';

  @override
  String get prayerTimePickerUsingDevice => 'Menggunakan lokasi perangkat...';

  @override
  String get prayerTimePickerUseDevice => 'Gunakan lokasi perangkat saat ini';

  @override
  String get prayerTimePickerMapTab => 'Peta';

  @override
  String get prayerTimePickerSearchHint => 'Nama kota atau negara';

  @override
  String get prayerTimePickerNoResults => 'Tidak ada hasil yang cocok';

  @override
  String get prayerTimePickerStartTyping => 'Mulai ketik nama kota';

  @override
  String get prayerTimePickerTapMapToChoose =>
      'Ketuk peta untuk memilih wilayah';

  @override
  String get prayerTimePickerApplying => 'Menerapkan';

  @override
  String get prayerTimePickerApply => 'Terapkan';

  @override
  String prayerTimeCurrentLabel(String prayer) {
    return 'Saat ini $prayer';
  }

  @override
  String prayerTimeNextLabel(String prayer) {
    return 'Berikutnya $prayer';
  }

  @override
  String get prayerTimeEnableLocation => 'Aktifkan lokasi';

  @override
  String get prayerTimeTimelineEmptyTitle =>
      'Jadwal salat tidak dapat ditampilkan sebelum wilayah diatur';

  @override
  String get prayerTimeTimelineEmptySubtitle =>
      'Pilih kota secara manual atau gunakan lokasi perangkat saat ini';

  @override
  String get prayerTimeTimelineChooseArea => 'Pilih wilayah';

  @override
  String get prayerTimeNow => 'Sekarang';

  @override
  String get prayerTimeNextBadge => 'Berikutnya';

  @override
  String get prayerTimeRowNext => 'Salat berikutnya';

  @override
  String get prayerTimeRowCompleted => 'Waktunya telah lewat';

  @override
  String get prayerTimeRowLocalTime => 'Waktu setempat';

  @override
  String get prayerTimeLoadingTimes => 'Memuat jadwal';

  @override
  String get prayerTimeLocatingShort => 'Menentukan lokasi';

  @override
  String get prayerTimeNoticeUnavailable =>
      'Aktifkan lokasi atau berikan izin untuk menampilkan jadwal salat yang akurat.';

  @override
  String get prayerTimeNoticeServiceOffSaved =>
      'Jadwal saat ini memakai lokasi tersimpan terakhir. Aktifkan lokasi agar diperbarui otomatis.';

  @override
  String get prayerTimeNoticeServiceOff =>
      'Layanan lokasi tidak aktif. Aktifkan untuk menampilkan jadwal salat sesuai lokasi Anda saat ini.';

  @override
  String get prayerTimeNoticePermissionDeniedSaved =>
      'Jadwal saat ini memakai lokasi tersimpan terakhir. Izinkan akses lokasi untuk memperbaruinya sekarang.';

  @override
  String get prayerTimeNoticePermissionDenied =>
      'Izin lokasi belum diberikan. Izinkan untuk menampilkan jadwal sesuai lokasi Anda saat ini.';

  @override
  String get prayerTimeNoticeDeniedForeverSaved =>
      'Jadwal saat ini memakai lokasi tersimpan terakhir. Buka pengaturan untuk mengaktifkan kembali izin lokasi.';

  @override
  String get prayerTimeNoticeDeniedForever =>
      'Izin lokasi ditolak permanen. Buka pengaturan dan aktifkan untuk menampilkan jadwal yang akurat.';

  @override
  String get prayerTimeNoticeErrorSaved =>
      'Lokasi tidak dapat diperbarui saat ini, jadi lokasi tersimpan terakhir digunakan.';

  @override
  String get prayerTimeNoticeError =>
      'Lokasi tidak dapat ditentukan saat ini. Aktifkan lokasi atau berikan izin untuk menampilkan jadwal.';

  @override
  String get prayerTimeOpenSettings => 'Buka pengaturan';

  @override
  String prayerTimeCountdownNow(String prayer) {
    return 'Telah masuk waktu $prayer';
  }

  @override
  String prayerTimeCountdownUnderMinute(String prayer) {
    return '$prayer kurang dari semenit lagi';
  }

  @override
  String prayerTimeCountdownMinutes(String prayer, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes menit lagi',
    );
    return '$prayer $_temp0';
  }

  @override
  String prayerTimeCountdownHours(String prayer, int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours jam lagi',
    );
    return '$prayer $_temp0';
  }

  @override
  String prayerTimeCountdownHoursMinutes(
      String prayer, int hours, int minutes) {
    return '$prayer $hours j $minutes mnt lagi';
  }

  @override
  String get prayerTimeRemainingNow => 'Sudah masuk waktu';

  @override
  String prayerTimeRemainingMinutes(int minutes) {
    return '$minutes mnt lagi';
  }

  @override
  String prayerTimeRemainingHours(int hours) {
    return '$hours j lagi';
  }

  @override
  String prayerTimeRemainingHoursMinutes(int hours, int minutes) {
    return '$hours j $minutes mnt lagi';
  }

  @override
  String get prayerTimeCurrentLocationFallback => 'Lokasi saat ini';

  @override
  String get prayerTimeYouAreInTime => 'Sekarang masuk waktu';

  @override
  String prayerTimeBoardHijriLine(String hijri) {
    return '$hijri · Kalender Umm al-Qura';
  }

  @override
  String get prayerTimeAllTimes => 'Semua jadwal';

  @override
  String get prayerTimeMuteAthan => 'Bisukan azan salat ini';

  @override
  String get prayerTimeUnmuteAthan => 'Aktifkan azan salat ini';

  @override
  String get prayerTimeQuickMushaf => 'Mushaf';

  @override
  String get prayerTimeQuickPrayerTimes => 'Jadwal Salat';

  @override
  String get prayerTimeQuickAdhkar => 'Pustaka Zikir';

  @override
  String get prayerTimeErrorLoad => 'Jadwal salat tidak dapat dimuat saat ini';

  @override
  String get prayerTimeErrorUpdateArea =>
      'Wilayah yang dipilih tidak dapat diterapkan';

  @override
  String get prayerTimeErrorApplySettings =>
      'Jadwal tidak dapat diperbarui dengan pengaturan baru';

  @override
  String get prayerTimeErrorServiceOff =>
      'Layanan lokasi tidak aktif. Aktifkan atau pilih kota secara manual.';

  @override
  String get prayerTimeErrorPermission =>
      'Izin lokasi diperlukan, atau pilih kota secara manual.';

  @override
  String get prayerTimeErrorDeniedForever =>
      'Izin lokasi ditolak permanen. Buka pengaturan atau pilih kota.';

  @override
  String get prayerTimeErrorDeviceLocation =>
      'Lokasi perangkat tidak dapat ditentukan saat ini';

  @override
  String get homeWidgetsPinFailed =>
      'Jendela tambah widget tidak dapat dibuka. Tambahkan secara manual dari layar utama.';

  @override
  String get homeWidgetsSyncSuccess => 'Widget diperbarui';

  @override
  String get homeWidgetsSyncFailed =>
      'Gagal memperbarui. Pastikan lokasi Anda sudah diatur.';

  @override
  String get homeWidgetsAddTooltip => 'Tambahkan ke layar utama';

  @override
  String get homeWidgetsTitle => 'Widget Layar Utama';

  @override
  String get homeWidgetsHowToHeader => 'Cara Menambahkan';

  @override
  String homeWidgetsHowToAndroid(String appName) {
    return 'Ketuk tombol tambah di samping widget, atau tekan lama area kosong di layar utama, pilih «Widget», lalu cari «$appName».';
  }

  @override
  String homeWidgetsHowToIos(String appName) {
    return 'Tekan lama area kosong di layar utama, ketuk tombol «+» di atas layar, lalu cari «$appName». Widget salat berikutnya juga tersedia untuk layar kunci.';
  }

  @override
  String get homeWidgetsListHeader => 'Widget';

  @override
  String get homeWidgetsNextPrayerTitle => 'Salat Berikutnya';

  @override
  String get homeWidgetsNextPrayerSubtitleAndroid =>
      'Nama dan waktu salat dengan hitung mundur langsung';

  @override
  String get homeWidgetsNextPrayerSubtitleIos =>
      'Kecil · dan layar kunci dalam tiga gaya';

  @override
  String get homeWidgetsTodayTimesTitle => 'Jadwal Hari Ini';

  @override
  String get homeWidgetsTodayTimesSubtitle =>
      'Enam waktu salat beserta tanggal Hijriah dan kota';

  @override
  String get homeWidgetsDailyAyahTitle => 'Ayat Hari Ini';

  @override
  String get homeWidgetsDailyAyahSubtitle =>
      'Ayat pendek yang berganti setiap hari';

  @override
  String get homeWidgetsSyncHeader => 'Sinkronisasi';

  @override
  String get homeWidgetsSyncNow => 'Perbarui widget sekarang';

  @override
  String homeWidgetsSyncSubtitle(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days hari',
    );
    return 'Menghitung jadwal $_temp0 dengan lokasi dan pengaturan Anda saat ini';
  }

  @override
  String homeWidgetsSyncHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days hari',
    );
    return 'Widget berfungsi selama $_temp0 tanpa membuka aplikasi dan diperbarui otomatis di latar belakang. Widget juga menyesuaikan sendiri saat lokasi atau metode perhitungan berubah.';
  }

  @override
  String get settingsDeveloperName => 'Moatasem Alhilali';

  @override
  String get settingsUpdateStarting => 'Memulai pembaruan aplikasi...';

  @override
  String get settingsUpdateUpToDate =>
      'Anda menggunakan versi aplikasi terbaru.';

  @override
  String get settingsUpdateCheckFailed =>
      'Gagal memeriksa pembaruan, coba lagi nanti.';

  @override
  String get settingsGroupPreferences => 'Preferensi';

  @override
  String get settingsDarkModeTitle => 'Mode Gelap';

  @override
  String get settingsStatusOn => 'Aktif';

  @override
  String get settingsStatusOff => 'Nonaktif';

  @override
  String get settingsNotificationsTitle => 'Pengaturan Notifikasi';

  @override
  String get settingsNotificationsSubtitle =>
      'Kendalikan setiap pemberitahuan dari aplikasi';

  @override
  String get settingsDownloadsTitle => 'Pengaturan Unduhan';

  @override
  String get settingsDownloadsSubtitle =>
      'Kelola file unduhan dan ruang penyimpanan';

  @override
  String get settingsGroupApp => 'Aplikasi';

  @override
  String get settingsCheckUpdatesTitle => 'Periksa Pembaruan';

  @override
  String get settingsCheckUpdatesSubtitle =>
      'Pastikan Anda menggunakan versi terbaru';

  @override
  String get settingsAboutUsTitle => 'Tentang Kami';

  @override
  String get settingsAboutUsSubtitle => 'Kenali aplikasi Tamaneena dan misinya';

  @override
  String get settingsRateAppTitle => 'Beri Nilai Aplikasi';

  @override
  String get settingsRateAppSubtitle =>
      'Bantu sebarkan kebaikan dengan memberi ulasan di toko aplikasi';

  @override
  String get settingsGroupPrivacy => 'Privasi dan Keamanan';

  @override
  String get settingsPrivacyPolicyTitle => 'Kebijakan Privasi';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Cara aplikasi menangani data dan izin Anda';

  @override
  String get settingsDataSafetyTitle => 'Keamanan Data';

  @override
  String get settingsDataSafetySubtitle =>
      'Ringkasan data, izin, dan cara penggunaannya';

  @override
  String get settingsGroupDeveloper => 'Pengembang';

  @override
  String get settingsAboutDeveloperTitle => 'Tentang Pengembang';

  @override
  String get settingsAboutDeveloperSubtitle =>
      'Informasi dan tautan kontak pengembang';

  @override
  String get settingsDeveloperContactSubtitle =>
      'Hubungi langsung lewat situs web atau WhatsApp';

  @override
  String get settingsPersonalWebsite => 'Situs pribadi';

  @override
  String get settingsGroupFollowNews => 'Ikuti Kabar Terbaru';

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
      'Informasi singkat dan jelas tentang cara aplikasi menangani data Anda.';

  @override
  String get settingsPrivacyMattersTitle => 'Privasi Anda penting bagi kami';

  @override
  String get settingsPrivacyMattersBody =>
      'Di Tamaneena, kami memastikan pengalaman menggunakan aplikasi tetap jelas dan aman. Kami hanya menggunakan data yang diperlukan untuk menjalankan dan meningkatkan fitur aplikasi, serta tidak menjual atau membagikan data pengguna untuk tujuan iklan.';

  @override
  String get settingsPrivacyDataUsedTitle =>
      'Data yang mungkin digunakan aplikasi';

  @override
  String get settingsPrivacyDataUsedBody =>
      'Aplikasi dapat menggunakan lokasi untuk menghitung jadwal salat dan arah kiblat, notifikasi untuk pengingat azan dan zikir, penyimpanan untuk menyimpan konten unduhan dan pengaturan lokal, serta kontak hanya pada fitur yang diaktifkan pengguna seperti Teman Subuh.';

  @override
  String get settingsPrivacyControlTitle => 'Kendali atas data Anda';

  @override
  String get settingsPrivacyControlBody =>
      'Anda dapat menonaktifkan atau mengubah notifikasi dari pengaturan notifikasi di dalam aplikasi, dan mengelola izin sistem dari pengaturan perangkat kapan saja.';

  @override
  String get settingsPrivacyThirdPartyTitle => 'Layanan pihak ketiga';

  @override
  String get settingsPrivacyThirdPartyBody =>
      'Aplikasi dapat menggunakan layanan seperti Firebase Remote Config dan Firebase Messaging untuk memperbarui pengaturan dan mengirim pemberitahuan umum. Layanan ini hanya digunakan untuk menjalankan aplikasi dan meningkatkan pengalaman.';

  @override
  String get settingsDataSafetyIntro =>
      'Ringkasan data yang digunakan aplikasi serta cara penyimpanan dan pembagiannya.';

  @override
  String get settingsDataSafetySensitiveTitle => 'Data sensitif';

  @override
  String get settingsDataSafetySensitiveBody =>
      'Aplikasi tidak meminta data sensitif kecuali diperlukan untuk fitur jelas yang dipilih pengguna. Sebagian data seperti waktu pengingat, preferensi, dan rencana bacaan disimpan secara lokal di perangkat.';

  @override
  String get settingsDataSafetyLocationTitle => 'Lokasi';

  @override
  String get settingsDataSafetyLocationBody =>
      'Lokasi digunakan untuk menghitung jadwal salat, arah kiblat, dan layanan berbasis tempat. Pengguna dapat mencabut izin lokasi dari pengaturan sistem.';

  @override
  String get settingsDataSafetyNotificationsTitle => 'Notifikasi';

  @override
  String get settingsDataSafetyNotificationsBody =>
      'Aplikasi menggunakan notifikasi untuk azan, zikir, pengingat, dan beberapa pesan umum aplikasi. Setiap jenis notifikasi dapat diatur dari halaman pengaturan notifikasi.';

  @override
  String get settingsDataSafetyStorageTitle => 'Penyimpanan dan Unduhan';

  @override
  String get settingsDataSafetyStorageBody =>
      'Aplikasi dapat menggunakan penyimpanan untuk menyimpan file dan konten yang dipilih pengguna untuk diunduh, seperti audio atau materi yang tersedia di aplikasi.';

  @override
  String get settingsDataSafetySharingTitle => 'Berbagi';

  @override
  String get settingsDataSafetySharingBody =>
      'Data pribadi Anda tidak dibagikan kepada pihak luar untuk dijual atau pemasaran. Setiap pembagian data hanya terjadi dalam layanan operasional yang diperlukan atau atas tindakan yang dimulai pengguna.';

  @override
  String get settingsAboutAppBody =>
      'Aplikasi Al-Qur\'an dan ibadah yang membantu Anda salat, berzikir, membaca Al-Qur\'an, dan istikamah menjalankan wirid harian dengan tenang dan mudah.';

  @override
  String get settingsAboutMissionTitle => 'Misi Kami';

  @override
  String get settingsAboutMissionBody =>
      'Menjadi teman ringan yang membantu pengguna dalam ketaatan tanpa mengganggu, dan menghimpun alat harian penting seperti mushaf, zikir, jadwal salat, pengingat, dan fitur pendukung untuk keluarga.';

  @override
  String get settingsAboutOfferTitle => 'Yang Kami Tawarkan';

  @override
  String get settingsAboutOfferBody =>
      'Mushaf, zikir, jadwal salat, kiblat, wirid harian, widget, Teman Subuh, Muslim Cilik, layanan musafir, dan pengingat yang dapat disesuaikan dengan kebutuhan pengguna.';

  @override
  String get settingsDeveloperHeroBody =>
      'Software engineer Full Stack dan Mobile dengan pengalaman lebih dari 7 tahun, berfokus pada Flutter, Laravel, Next.js, serta membangun aplikasi produksi untuk web dan seluler.';

  @override
  String get settingsDeveloperBioTitle => 'Profil Singkat';

  @override
  String get settingsDeveloperBioBody =>
      'Moatasem Alhilali membangun aplikasi dan platform digital yang melayani pengguna nyata, dengan perhatian khusus pada aplikasi seluler, sistem backend, antarmuka pengguna, serta platform Fintech dan SaaS.';

  @override
  String get settingsDeveloperFieldsTitle => 'Bidang Keahlian';

  @override
  String get settingsDeveloperFieldsBody =>
      'Flutter, Laravel, Next.js, React, API Development, aplikasi seluler, aplikasi web, solusi Fintech, dan platform SaaS.';

  @override
  String get settingsDeveloperContactTitle => 'Kontak';

  @override
  String get settingsContactWebsite => 'Situs web';

  @override
  String get settingsContactEmail => 'Email';

  @override
  String get settingsAppLinksTitle => 'Tautan Aplikasi';

  @override
  String get notifSettingsLabelAppNotifications => 'Notifikasi aplikasi';

  @override
  String get notifSettingsLabelAllAthan => 'Notifikasi semua azan';

  @override
  String notifSettingsAthanOf(String prayer) {
    return 'Azan $prayer';
  }

  @override
  String get notifSettingsLabelMiddleNight => 'Qiyamul Lail';

  @override
  String get notifSettingsLabelThikrMorning => 'Zikir Pagi';

  @override
  String get notifSettingsLabelThikrEvening => 'Zikir Petang';

  @override
  String get notifSettingsLabelThikrWakeUp => 'Zikir Bangun Tidur';

  @override
  String get notifSettingsLabelThikrSleep => 'Zikir Sebelum Tidur';

  @override
  String get notifSettingsLabelSalawat => 'Selawat kepada Nabi Muhammad ﷺ';

  @override
  String get notifSettingsLabelRandomAudioThikr => 'Zikir audio acak';

  @override
  String get notifSettingsLabelFloatingAdhkar =>
      'Zikir melayang dan pengingat alternatif';

  @override
  String get notifSettingsLabelDailyQuranWird => 'Wirid Al-Qur\'an harian';

  @override
  String get notifSettingsLabelReadSurahMulk => 'Membaca Surah Al-Mulk';

  @override
  String get notifSettingsLabelReadSpecificSurah => 'Membaca surah tertentu';

  @override
  String get notifSettingsLabelReadSurahKahf => 'Membaca Surah Al-Kahf';

  @override
  String get notifSettingsLabelFasting => 'Pengingat puasa';

  @override
  String get notifSettingsLabelFastingMonday => 'Puasa Senin';

  @override
  String get notifSettingsLabelFastingThursday => 'Puasa Kamis';

  @override
  String get notifSettingsLabelBestDua =>
      'Doa terbaik yang dicintai Allah Subhanahu wa Ta\'ala dan besar pengaruhnya';

  @override
  String get notifSettingsLabelWirdMorning => 'Wirid Pagi';

  @override
  String get notifSettingsLabelWirdEvening => 'Wirid Petang';

  @override
  String get notifSettingsLabelWirdNight => 'Wirid Sebelum Tidur';

  @override
  String get notifSettingsLabelWirdSummary => 'Ringkasan wirid harian';

  @override
  String get notifSettingsLabelYoungMuslim => 'Pengingat Muslim Cilik';

  @override
  String get notifSettingsLabelQuranPlan => 'Pengingat rencana Al-Qur\'an';

  @override
  String get notifSettingsLabelGeneral => 'Notifikasi umum aplikasi';

  @override
  String get notifSettingsTitleRandomThikr => 'Zikir acak';

  @override
  String get notifSettingsTitleFloatingAdhkar => 'Zikir Melayang';

  @override
  String get notifSettingsTitlePrayerAthan => 'Azan salat';

  @override
  String get notifSettingsBodyThikrMorning => 'Jangan lupa zikir pagi!';

  @override
  String get notifSettingsBodyThikrEvening => 'Jangan lupa zikir petang!';

  @override
  String get notifSettingsBodyMiddleNight =>
      'Sudah waktunya qiyamul lail, manfaatkan sepertiga malam terakhir.';

  @override
  String get notifSettingsBodySalawat =>
      'Berselawatlah kepada Nabi ﷺ, semoga harimu bahagia.';

  @override
  String get notifSettingsBodyRememberAllah =>
      'Ingatlah Allah, niscaya Dia mengingatmu!';

  @override
  String get notifSettingsBodyReadQuran =>
      'Luangkan waktu untuk wirid Al-Qur\'an harianmu.';

  @override
  String get notifSettingsBodyReadSurahMulk =>
      'Jangan lupa membaca Surah Al-Mulk malam ini.';

  @override
  String get notifSettingsBodyThikrSleep =>
      'Zikir sebelum tidur sebelum kamu terlelap.';

  @override
  String get notifSettingsBodyThikrWakeUp =>
      'Awali harimu dengan zikir kepada Allah setelah bangun tidur.';

  @override
  String get notifSettingsBodyReadSurah =>
      'Jangan lupa membaca surah pilihanmu hari ini.';

  @override
  String get notifSettingsBodyReadSurahKahf =>
      'Jangan lupa membaca Surah Al-Kahf pada hari Jumat.';

  @override
  String get notifSettingsBodyFasting => 'Pengingat puasa sunah.';

  @override
  String get notifSettingsBodyFastingMonday => 'Pengingat puasa hari Senin.';

  @override
  String get notifSettingsBodyFastingThursday => 'Pengingat puasa hari Kamis.';

  @override
  String get notifSettingsBodyAthanTime => 'Telah masuk waktu azan.';

  @override
  String get notifSettingsBodyWirdMorning =>
      'Awali harimu dengan bekal ibadahmu.';

  @override
  String get notifSettingsBodyWirdEvening =>
      'Perbarui hubunganmu dengan Allah lewat bekal petang.';

  @override
  String get notifSettingsBodyWirdNight => 'Tutup harimu dengan zikir dan doa.';

  @override
  String get notifSettingsBodyWirdSummary => 'Tinjau bekal ibadahmu hari ini.';

  @override
  String get notifSettingsBodyYoungMuslim =>
      'Pengingat untuk kembali ke konten Muslim Cilik.';

  @override
  String get notifSettingsBodyQuranPlan =>
      'Jangan lupa sesi hari ini dari rencana Al-Qur\'an-mu.';

  @override
  String get notifSettingsBodyGeneral =>
      'Notifikasi dan pemberitahuan umum dari aplikasi Tamaneena.';

  @override
  String get notifSettingsAllPrayers => 'Semua salat';

  @override
  String get notifSettingsSalawatShort => 'Selawat Nabi';

  @override
  String get notifSettingsQuranWirdShort => 'Wirid Al-Qur\'an';

  @override
  String get notifSettingsGroupGeneral => 'Umum';

  @override
  String get notifSettingsGroupAthan => 'Azan';

  @override
  String get notifSettingsGroupDailyWird => 'Wirid Harian';

  @override
  String get notifSettingsGroupAdhkar => 'Zikir';

  @override
  String get notifSettingsGroupQuran => 'Al-Qur\'an';

  @override
  String get notifSettingsGroupAppSections => 'Bagian Aplikasi';

  @override
  String get notifSettingsGroupNightAndWaking => 'Malam dan Bangun Tidur';

  @override
  String get notifSettingsGroupFasting => 'Puasa';

  @override
  String get notifSettingsGroupRecurringAdhkar => 'Zikir Berulang';

  @override
  String get notifSettingsGroupSystem => 'Sistem';

  @override
  String get notifSettingsMasterTitle => 'Semua notifikasi aplikasi';

  @override
  String get notifSettingsMasterOnSubtitle =>
      'Notifikasi aktif, Anda dapat mengatur setiap jenis di bawah';

  @override
  String get notifSettingsMasterOffSubtitle =>
      'Semua notifikasi berhenti sampai Anda mengaktifkan tombol ini';

  @override
  String get notifSettingsSystemTitle => 'Notifikasi sistem';

  @override
  String get notifSettingsSystemSubtitle =>
      'Lihat notifikasi terjadwal dan aktif di perangkat Anda';

  @override
  String get notifSettingsStatusStopped => 'Nonaktif';

  @override
  String get notifSettingsStatusEnabled => 'Aktif';

  @override
  String notifSettingsSummaryDaily(String time) {
    return 'Setiap hari · $time';
  }

  @override
  String notifSettingsSummaryHourly(int minute) {
    return 'Setiap jam pada menit ke-$minute';
  }

  @override
  String notifSettingsSummaryEveryNMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Setiap $count menit',
      one: 'Setiap menit',
    );
    return '$_temp0';
  }

  @override
  String get notifSettingsListSeparator => ', ';

  @override
  String get notifSettingsNoDaysSelected => 'Tanpa hari tertentu';

  @override
  String notifSettingsSummaryWeekly(String days, String time) {
    return 'Mingguan ($days) · $time';
  }

  @override
  String notifSettingsSummaryCustom(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jadwal kustom · $count waktu',
      zero: 'Jadwal kustom · tanpa waktu',
    );
    return '$_temp0';
  }

  @override
  String get notifSettingsScheduleTimesTooltip => 'Waktu pengingat';

  @override
  String get notifSettingsEditScheduleTitle => 'Edit jadwal';

  @override
  String get notifSettingsEditScheduleSubtitle =>
      'Ubah jenis pengulangan dan waktu pengingat';

  @override
  String get notifSettingsExtraSchedulesTitle => 'Kelola jadwal tambahan';

  @override
  String get notifSettingsExtraSchedulesSubtitle =>
      'Tambahkan lebih dari satu jadwal untuk notifikasi ini';

  @override
  String get notifScheduleBodyAllAthan =>
      'Pengingat semua azan akan berulang pada waktunya masing-masing.';

  @override
  String get notifScheduleBodyAthanFajr =>
      'Telah masuk waktu azan Subuh, segeralah salat.';

  @override
  String get notifScheduleBodyAthanDhuhr => 'Telah masuk waktu azan Zuhur.';

  @override
  String get notifScheduleBodyAthanAsr => 'Telah masuk waktu azan Asar.';

  @override
  String get notifScheduleBodyAthanMaghrib => 'Telah masuk waktu azan Magrib.';

  @override
  String get notifScheduleBodyAthanIsha => 'Telah masuk waktu azan Isya.';

  @override
  String get notifScheduleBodyMiddleNight =>
      'Sudah waktunya qiyamul lail! Bangunlah dan bermunajatlah kepada Ar-Rahman.';

  @override
  String get notifScheduleBodyThikrMorning => 'Jangan lupa zikir pagi!';

  @override
  String get notifScheduleBodyThikrEvening => 'Jangan lupa zikir petang!';

  @override
  String get notifScheduleBodySalawat =>
      'Berselawatlah kepada Nabi yang mulia ﷺ, niscaya dicatat untukmu sepuluh kebaikan.';

  @override
  String get notifScheduleBodyReadQuran =>
      'Jangan lupa wirid Al-Qur\'an-mu hari ini.';

  @override
  String get notifScheduleBodyReadSurahMulk =>
      'Bacalah Surah Al-Mulk sebelum tidur.';

  @override
  String get notifScheduleBodyThikrSleep =>
      'Bacalah zikir sebelum tidur sebelum kamu tidur.';

  @override
  String get notifScheduleBodyThikrWakeUp =>
      'Awali harimu dengan zikir bangun tidur.';

  @override
  String get notifScheduleBodyReadSurah =>
      'Jangan lupa membaca surah yang ditentukan untuk hari ini.';

  @override
  String get notifScheduleBodyReadSurahKahf =>
      'Bacalah Surah Al-Kahf pada hari Jumat.';

  @override
  String get notifScheduleBodyFasting =>
      'Puasa sunah berpahala besar, jangan lewatkan kesempatannya.';

  @override
  String get notifScheduleTitleRandomThikr => 'Zikir acak terjadwal';

  @override
  String get notifScheduleValidateTime =>
      'Tentukan waktu pengingat terlebih dahulu';

  @override
  String get notifScheduleValidateMinute => 'Tentukan menit di setiap jam';

  @override
  String get notifScheduleValidateWeekday =>
      'Pilih setidaknya satu hari dalam seminggu';

  @override
  String get notifScheduleValidateInterval =>
      'Masukkan jumlah menit (lebih dari nol)';

  @override
  String get notifScheduleValidateDate => 'Tambahkan setidaknya satu tanggal';

  @override
  String get notifScheduleDetails => 'Detail';

  @override
  String get notifScheduleMinuteOfHourTitle => 'Menit di setiap jam';

  @override
  String get notifScheduleMinuteOfHourSubtitle => 'Angka antara 0 dan 59';

  @override
  String get notifScheduleMinuteUnit => 'menit';

  @override
  String get notifScheduleRepeatTitle => 'Pengulangan';

  @override
  String get notifScheduleRepeatSubtitle =>
      'Jeda antara satu pengingat dan berikutnya';

  @override
  String get notifScheduleCustomTime => 'Jadwal kustom';

  @override
  String get notifScheduleDeleteTime => 'Hapus jadwal';

  @override
  String get notifScheduleNoTimesYet => 'Belum ada jadwal yang ditambahkan';

  @override
  String get notifScheduleAddTime => 'Tambah jadwal';

  @override
  String get notifScheduleSaveSchedule => 'Simpan jadwal';

  @override
  String get notifScheduleAddNewTitle => 'Tambah jadwal baru';

  @override
  String get notifScheduleEditTitle => 'Edit jadwal';

  @override
  String get notifScheduleOptionalLabel => 'Deskripsi opsional';

  @override
  String get notifScheduleAddConfirm => 'Tambahkan jadwal';

  @override
  String get notifScheduleSaveEdit => 'Simpan perubahan';

  @override
  String get notifScheduleTypeDaily => 'Harian';

  @override
  String get notifScheduleTypeHourly => 'Setiap jam';

  @override
  String get notifScheduleTypeEveryNMinutes => 'Setiap beberapa menit';

  @override
  String get notifScheduleTypeWeekly => 'Mingguan';

  @override
  String get notifScheduleTypeCustomDates => 'Tanggal kustom';

  @override
  String get notifScheduleTypeDailyDesc =>
      'Berulang setiap hari pada waktu yang sama';

  @override
  String get notifScheduleTypeHourlyDesc =>
      'Berulang setiap jam pada menit tertentu';

  @override
  String get notifScheduleTypeEveryNMinutesDesc =>
      'Berulang setiap selang waktu yang Anda tentukan';

  @override
  String get notifScheduleTypeWeeklyDesc =>
      'Berulang pada hari tertentu dalam seminggu';

  @override
  String get notifScheduleTypeCustomDatesDesc =>
      'Muncul pada tanggal dan waktu pilihan Anda';

  @override
  String get notifScheduleTypeTitle => 'Jenis jadwal';

  @override
  String get notifScheduleTimeTitle => 'Waktu pengingat';

  @override
  String get notifScheduleTimeSubtitle => 'Ketuk untuk memilih jam dan menit';

  @override
  String get notifScheduleLabelHint =>
      'Tambahkan deskripsi singkat untuk jadwal ini';

  @override
  String notifScheduleRowDaily(String time) {
    return 'Setiap hari · $time';
  }

  @override
  String notifScheduleRowWeekly(String days, String time) {
    return '$days · $time';
  }

  @override
  String get notifScheduleNoDays => 'Tanpa hari';

  @override
  String notifScheduleRowCustom(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jadwal kustom',
      zero: 'Tidak ada jadwal kustom',
    );
    return '$_temp0';
  }

  @override
  String get notifScheduleDayShort1 => 'Sen';

  @override
  String get notifScheduleDayShort2 => 'Sel';

  @override
  String get notifScheduleDayShort3 => 'Rab';

  @override
  String get notifScheduleDayShort4 => 'Kam';

  @override
  String get notifScheduleDayShort5 => 'Jum';

  @override
  String get notifScheduleDayShort6 => 'Sab';

  @override
  String get notifScheduleDayShort7 => 'Min';

  @override
  String get notifScheduleAllDays => 'Semua hari';

  @override
  String get notifScheduleWorkDays => 'Hari kerja';

  @override
  String get notifScheduleWeekend => 'Akhir pekan';

  @override
  String get notifScheduleClear => 'Hapus';

  @override
  String get notifScheduleStatTotal => 'Total';

  @override
  String get notifScheduleStatEnabled => 'Aktif';

  @override
  String get notifScheduleStatStopped => 'Nonaktif';

  @override
  String get notifScheduleUnexpectedError => 'Terjadi kesalahan tak terduga';

  @override
  String get notifScheduleSaved => 'Tersimpan';

  @override
  String get notifScheduleScreenTitle => 'Jadwal Notifikasi';

  @override
  String get notifScheduleListTitle => 'Jadwal';

  @override
  String get notifScheduleEmpty =>
      'Belum ada jadwal — tambahkan lewat tombol «Tambah jadwal».';

  @override
  String get notifScheduleDeleteTitle => 'Hapus jadwal';

  @override
  String get notifScheduleDeleteMessage =>
      'Yakin ingin menghapus jadwal ini?\nSemua notifikasi yang terkait akan dibatalkan.';

  @override
  String get notifScheduleSaving => 'Menyimpan...';

  @override
  String get notifScheduleLoading => 'Memuat jadwal...';

  @override
  String notifScheduleLoadFailed(String error) {
    return 'Gagal memuat jadwal: $error';
  }

  @override
  String get notifScheduleAdded => 'Jadwal berhasil ditambahkan';

  @override
  String notifScheduleAddFailed(String error) {
    return 'Gagal menambahkan jadwal: $error';
  }

  @override
  String get notifScheduleUpdated => 'Jadwal berhasil diperbarui';

  @override
  String notifScheduleUpdateFailed(String error) {
    return 'Gagal memperbarui jadwal: $error';
  }

  @override
  String get notifScheduleDeleted => 'Jadwal berhasil dihapus';

  @override
  String notifScheduleDeleteFailed(String error) {
    return 'Gagal menghapus jadwal: $error';
  }

  @override
  String get notifScheduleActivated => 'Jadwal diaktifkan';

  @override
  String get notifScheduleDeactivated => 'Jadwal dinonaktifkan';

  @override
  String notifScheduleToggleFailed(String error) {
    return 'Gagal mengubah status jadwal: $error';
  }

  @override
  String get notifSettingsScheduledGroup => 'Terjadwal';

  @override
  String get notifSettingsNoScheduled =>
      'Tidak ada notifikasi terjadwal saat ini';

  @override
  String get notifSettingsShownNowGroup => 'Sedang tampil';

  @override
  String get notifSettingsNoShown => 'Tidak ada notifikasi di bilah notifikasi';

  @override
  String get notifSettingsUntitled => 'Notifikasi tanpa judul';

  @override
  String get notifSettingsDismiss => 'Tutup notifikasi';

  @override
  String get notifSettingsCancelNotification => 'Batalkan notifikasi';

  @override
  String notifSettingsAthanTicker(String prayer) {
    return 'Telah masuk waktu azan $prayer';
  }

  @override
  String get downloadTitle => 'Unduhan';

  @override
  String get downloadEmptyAll =>
      'Belum ada unduhan, tambahkan unduhan untuk memulai.';

  @override
  String get downloadEmptyActive => 'Tidak ada unduhan aktif';

  @override
  String get downloadEmptyCompleted => 'Tidak ada unduhan selesai';

  @override
  String get downloadEmptyPaused => 'Tidak ada unduhan dijeda';

  @override
  String get downloadEmptyFailed => 'Tidak ada unduhan gagal';

  @override
  String get downloadCancelAll => 'Batalkan semua';

  @override
  String get downloadCancelAllConfirm =>
      'Yakin ingin membatalkan semua unduhan aktif?';

  @override
  String get downloadAdd => 'Tambah unduhan';

  @override
  String get downloadFilterAll => 'Semua';

  @override
  String get downloadStatusActive => 'Aktif';

  @override
  String get downloadStatusCompleted => 'Selesai';

  @override
  String get downloadStatusPaused => 'Dijeda';

  @override
  String get downloadStatusFailed => 'Gagal';

  @override
  String get downloadStarted => 'Unduhan dimulai';

  @override
  String get downloadAddNewTitle => 'Tambah unduhan baru';

  @override
  String get downloadUrlLabel => 'Tautan file';

  @override
  String get downloadUrlRequired => 'Masukkan tautan unduhan';

  @override
  String get downloadUrlInvalid => 'Masukkan tautan yang valid';

  @override
  String get downloadFileNameLabel => 'Nama file';

  @override
  String get downloadOptional => 'Opsional';

  @override
  String get downloadPublicStorageTitle => 'Penyimpanan publik';

  @override
  String get downloadPublicStorageSubtitle => 'Simpan di folder Unduhan';

  @override
  String get downloadAllowCellularTitle => 'Izinkan data seluler';

  @override
  String get downloadAllowCellularSubtitle => 'Unduh menggunakan data seluler';

  @override
  String get downloadStart => 'Mulai unduh';

  @override
  String get downloadPause => 'Jeda';

  @override
  String get downloadResume => 'Lanjutkan';

  @override
  String get downloadOpenFile => 'Buka file';

  @override
  String get downloadRemoveFromList => 'Hapus dari daftar';

  @override
  String get downloadDeleteFile => 'Hapus file';

  @override
  String get downloadTotal => 'Total';

  @override
  String get downloadInProgressNow => 'Sedang diunduh';

  @override
  String downloadAndMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dan $count lainnya',
    );
    return '$_temp0';
  }

  @override
  String get widgetLabelNextPrayer => 'Salat berikutnya';

  @override
  String get widgetLabelDailyAyah => 'Ayat hari ini';

  @override
  String get widgetLabelOpenApp => 'Buka Tamaneena';

  @override
  String get widgetLabelSetLocation => 'Atur lokasi di aplikasi';

  @override
  String get widgetLabelRefreshNeeded => 'untuk memperbarui jadwal';

  @override
  String widgetLabelNextIn(String prayer) {
    return '$prayer dalam';
  }

  @override
  String get dailyWirdTitle => 'Bekal Siang dan Malam';

  @override
  String get dailyWirdSettingsTooltip => 'Pengaturan bekal';

  @override
  String get dailyWirdUnexpectedError => 'Terjadi kesalahan tak terduga.';

  @override
  String get dailyWirdRemindersHeader => 'Pengingat';

  @override
  String get dailyWirdReminderSleepLabel => 'Zikir Sebelum Tidur';

  @override
  String get dailyWirdProgramHeader => 'Program';

  @override
  String get dailyWirdSaveSetup => 'Simpan pengaturan';

  @override
  String get dailyWirdSetupFailed => 'Gagal menyiapkan bekal ibadah.';

  @override
  String get dailyWirdItemNotFound => 'Amalan bekal ibadah tidak ditemukan.';

  @override
  String get dailyWirdTodayTasksHeader => 'Amalan Hari Ini';

  @override
  String dailyWirdStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Istikamah $count hari',
    );
    return '$_temp0';
  }

  @override
  String dailyWirdWeeklyAdherence(int percent) {
    return 'Konsistensi pekan ini $percent%';
  }

  @override
  String get dailyWirdChoosePresetTitle => 'Pilih bekal ibadah Anda';

  @override
  String get dailyWirdChoosePresetSubtitle =>
      'Mulai dengan program siap pakai, lalu sesuaikan dengan kebutuhan Anda';

  @override
  String get dailyWirdItemOptions => 'Opsi amalan';

  @override
  String get dailyWirdEditTargetCount => 'Ubah jumlah target';

  @override
  String get dailyWirdStartOver => 'Mulai dari awal';

  @override
  String get dailyWirdMoveUp => 'Naikkan urutan';

  @override
  String get dailyWirdMoveDown => 'Turunkan urutan';

  @override
  String get dailyWirdHideItem => 'Sembunyikan dari bekal';

  @override
  String get dailyWirdCountHint => 'Contoh: 50 kali';

  @override
  String get dailyWirdTimeMorning => 'Pagi';

  @override
  String get dailyWirdTimeEvening => 'Petang';

  @override
  String get dailyWirdTimeNight => 'Malam';

  @override
  String get dailyWirdTimeAny => 'Kapan saja';

  @override
  String get dailyWirdTimeMorningLong => 'Waktu pagi';

  @override
  String get dailyWirdTimeEveningLong => 'Waktu petang';

  @override
  String get dailyWirdTimeNightLong => 'Sebelum tidur';

  @override
  String get dailyWirdTimeAnyLong => 'Kapan saja';

  @override
  String get dailyWirdTypeDhikrSet => 'Zikir';

  @override
  String get dailyWirdTypeCountedDhikr => 'Zikir berhitung';

  @override
  String get dailyWirdTypeQuran => 'Wirid Al-Qur\'an';

  @override
  String get dailyWirdTypeDua => 'Doa';

  @override
  String get dailyWirdTypeSurah => 'Surah';

  @override
  String dailyWirdCountProgress(int done, int total) {
    return '$done dari $total';
  }

  @override
  String dailyWirdCompletedOf(int done, int total, String unit) {
    return 'Selesai $done dari $total$unit';
  }

  @override
  String get dailyWirdItemDone => 'Selesai';

  @override
  String get dailyWirdMarkComplete => 'Selesai';

  @override
  String get dailyWirdCountOnce => 'Hitung sekali';

  @override
  String get dailyWirdCompleteThis => 'Selesaikan amalan ini';

  @override
  String get dailyWirdUncomplete => 'Batalkan selesai';

  @override
  String get dailyWirdReminderMorningTitle => 'Bekal Pagi';

  @override
  String get dailyWirdReminderMorningBody =>
      'Awali harimu dengan zikir kepada Allah, membaca Kitab-Nya, dan berdoa.';

  @override
  String get dailyWirdReminderEveningTitle => 'Bekal Petang';

  @override
  String get dailyWirdReminderEveningBody =>
      'Perbarui hubunganmu dengan Allah dan selesaikan bekal petang semampumu.';

  @override
  String get dailyWirdReminderNightTitle => 'Bekal Sebelum Tidur';

  @override
  String get dailyWirdReminderNightBody =>
      'Tutup harimu dengan zikir, doa, dan sisa bekal ibadahmu.';

  @override
  String get dailyWirdReminderSummaryTitle => 'Muhasabah Akhir Hari';

  @override
  String get dailyWirdReminderSummaryBody =>
      'Tinjau bekal ibadahmu hari ini dan lihat apa yang telah kamu selesaikan.';

  @override
  String get wirdMorningAdhkar => 'Zikir Pagi';

  @override
  String get wirdEveningAdhkar => 'Zikir Petang';

  @override
  String get wirdMorningTitle => 'Wirid Pagi';

  @override
  String get wirdEveningTitle => 'Wirid Petang';

  @override
  String get wirdSearchHint => 'Cari zikir';

  @override
  String wirdPagerPosition(int current, int total) {
    return 'Zikir $current dari $total';
  }

  @override
  String get wirdPrevious => 'Sebelumnya';

  @override
  String get wirdNext => 'Berikutnya';

  @override
  String get wirdShowSingle => 'Tampilkan satu per satu';

  @override
  String get wirdShowList => 'Tampilkan sebagai daftar';

  @override
  String get wirdTypeMorningOnly => 'Pagi saja';

  @override
  String get wirdTypeEveningOnly => 'Petang saja';

  @override
  String get wirdTypeBoth => 'Pagi dan petang';

  @override
  String get wirdNoAudio => 'Tidak ada file audio';

  @override
  String get wirdPause => 'Jeda';

  @override
  String get wirdReplay => 'Putar ulang';

  @override
  String get wirdPlayAudio => 'Putar audio';

  @override
  String wirdRemaining(int remaining, int total) {
    return 'Sisa $remaining dari $total';
  }

  @override
  String get wirdCompleted => 'Selesai';

  @override
  String get wirdResetCount => 'Ulangi hitungan';

  @override
  String get wirdCopyDhikr => 'Salin zikir';

  @override
  String get wirdSource => 'Sumber';

  @override
  String get wirdShowDetails => 'Tampilkan detail';

  @override
  String get wirdHideDetails => 'Sembunyikan detail';

  @override
  String get wirdVirtue => 'Keutamaan';

  @override
  String get wirdHadithText => 'Teks hadis';

  @override
  String get wirdWordExplanations => 'Penjelasan kosakata pilihan';

  @override
  String get wirdReadOnce => 'Sudah dibaca 1 kali';

  @override
  String get wirdPlayAll => 'Putar seluruh wirid';

  @override
  String get wirdPreparingAudio => 'Menyiapkan audio';

  @override
  String get wirdReplayAll => 'Putar ulang wirid';

  @override
  String get wirdPlayAllFinished => 'Semua zikir telah selesai diputar.';

  @override
  String get wirdNowPlaying => 'Sedang dibacakan';

  @override
  String wirdRepeatProgress(int current, int total) {
    return 'Pengulangan $current dari $total';
  }

  @override
  String get thikrLibraryTitle => 'Pustaka Zikir';

  @override
  String get thikrGroupDaily => 'Zikir Harian';

  @override
  String get thikrMorningSubtitle =>
      'Wirid Anda setelah Subuh hingga matahari naik';

  @override
  String get thikrEveningSubtitle => 'Wirid Anda setelah Asar hingga malam';

  @override
  String get thikrSleepTitle => 'Zikir Tidur dan Mimpi';

  @override
  String get thikrSleepSubtitle =>
      'Bacaan sebelum tidur dan saat terkejut dalam tidur';

  @override
  String get thikrPrayerJumuahTitle => 'Zikir Salat dan Jumat';

  @override
  String get thikrPrayerJumuahSubtitle =>
      'Zikir azan, setelah salat, dan hari Jumat';

  @override
  String get thikrGroupDuas => 'Doa Ma\'tsur';

  @override
  String get thikrQuranicDuasTitle => 'Doa-doa dalam Al-Qur\'an';

  @override
  String get thikrQuranicDuasSubtitle =>
      'Doa para nabi sebagaimana tercantum dalam Kitabullah';

  @override
  String get thikrComprehensiveDuasTitle => 'Doa-doa Jami\'';

  @override
  String get thikrComprehensiveDuasSubtitle =>
      'Doa yang menghimpun kebaikan dunia dan akhirat';

  @override
  String get thikrHajjTitle => 'Doa Haji dan Umrah';

  @override
  String get thikrHajjSubtitle =>
      'Doa ihram, tawaf, sai, dan di tempat-tempat manasik';

  @override
  String get thikrFuneralTitle => 'Doa untuk Jenazah';

  @override
  String get thikrFuneralSubtitle =>
      'Bacaan dalam salat jenazah dan di kuburan';

  @override
  String get thikrGroupTools => 'Alat Anda';

  @override
  String get thikrTasbeehTitle => 'Tasbih';

  @override
  String get thikrTasbeehSubtitle =>
      'Penghitung tasbih yang menyimpan hasil harian Anda';

  @override
  String get thikrMyDuasSubtitle =>
      'Doa-doa yang Anda tambahkan sendiri di satu tempat';

  @override
  String get thikrSliderSubtitle => 'Wirid waktu ini, buka sekarang';

  @override
  String get afterPrayerTitle => 'Zikir Setelah Salat';

  @override
  String get afterPrayerSubtitle => 'Zikir sesudah salat';

  @override
  String get afterPrayerSearchHint => 'Cari zikir';

  @override
  String afterPrayerFallbackTitle(int number) {
    return 'Zikir setelah salat $number';
  }

  @override
  String afterPrayerRepeatCountLine(int count) {
    return 'Jumlah pengulangan: $count';
  }

  @override
  String afterPrayerVirtueLine(String virtue) {
    return 'Keutamaan: $virtue';
  }

  @override
  String get afterPrayerRepeatLabel => 'Pengulangan';

  @override
  String get afterPrayerVirtueLabel => 'Keutamaan';

  @override
  String get afterPrayerMentioned => 'Disebutkan';

  @override
  String get afterPrayerNotMentioned => 'Tidak disebutkan';

  @override
  String get afterPrayerTextSection => 'Teks Zikir';

  @override
  String get afterPrayerVirtueSection => 'Keutamaan Zikir';

  @override
  String afterPrayerRepeatTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kali',
      one: '1 kali',
    );
    return '$_temp0';
  }

  @override
  String get afterPrayerNoResults => 'Tidak ada hasil yang cocok';

  @override
  String get afterPrayerShowAll => 'Tampilkan semua zikir';

  @override
  String get myDuasTitle => 'Doa Saya';

  @override
  String get myDuasActionFailed => 'Tindakan tidak dapat dilakukan.';

  @override
  String get myDuasEmptyCustomTitle => 'Belum ada doa yang ditambahkan';

  @override
  String get myDuasEmptyCustomMessage =>
      'Bagian ini hanya menampilkan doa yang Anda tambahkan sendiri.';

  @override
  String get myDuasEmptyTitle => 'Belum ada doa';

  @override
  String get myDuasEmptyMessage =>
      'Tambahkan doa pertama Anda dan doa itu akan langsung muncul di sini.';

  @override
  String get myDuasAddNew => 'Tambah doa baru';

  @override
  String get myDuasAdd => 'Tambah doa';

  @override
  String get myDuasAddSubtitle =>
      'Tulis doa agar muncul di antara doa pribadi Anda.';

  @override
  String get myDuasEditTitle => 'Edit doa';

  @override
  String get myDuasEditSubtitle =>
      'Anda dapat mengubah teks atau deskripsi dan langsung menyimpan perubahan.';

  @override
  String get myDuasCountLabel => 'Jumlah doa';

  @override
  String get myDuasTodayLabel => 'Dibaca hari ini';

  @override
  String get myDuasOptions => 'Opsi doa';

  @override
  String get myDuasResetToday => 'Atur ulang hitungan hari ini';

  @override
  String get ruqyahTitle => 'Rukiah Syar\'iyyah';

  @override
  String get ruqyahSearchHint => 'Cari rukiah';

  @override
  String get ruqyahDefaultReference => 'Al-Qur\'an Al-Karim';

  @override
  String get ruqyahUnspecified => 'Tidak ditentukan';

  @override
  String ruqyahRepeatLine(String count) {
    return 'Pengulangan: $count';
  }

  @override
  String ruqyahReferenceLine(String reference) {
    return 'Rujukan: $reference';
  }

  @override
  String ruqyahDescriptionLine(String description) {
    return 'Deskripsi: $description';
  }

  @override
  String ruqyahNumber(int number) {
    return 'Rukiah $number';
  }

  @override
  String get ruqyahTextSection => 'Teks Rukiah';

  @override
  String get ruqyahDescriptionSection => 'Deskripsi';

  @override
  String get ruqyahNoResultsTitle => 'Tidak ada hasil';

  @override
  String get ruqyahNoResultsMessage =>
      'Tidak ada rukiah yang cocok dengan pencarian Anda.';

  @override
  String get ruqyahShowAll => 'Tampilkan semua rukiah';

  @override
  String get radioTitle => 'Radio';

  @override
  String get radioKindReciters => 'Qari';

  @override
  String get radioKindPrograms => 'Program dan Tilawah';

  @override
  String get radioLoadFailed => 'Radio tidak dapat dimuat saat ini.';

  @override
  String get radioPlayFailed => 'Radio tidak dapat diputar saat ini.';

  @override
  String get radioToggleFailed => 'Status pemutaran tidak dapat diubah.';

  @override
  String get radioStopFailed => 'Radio tidak dapat dihentikan.';

  @override
  String get radioNoMatch => 'Tidak ada stasiun dengan nama ini.';

  @override
  String get radioSearchHint => 'Cari qari atau program';

  @override
  String get radioFavouritesHint =>
      'Tekan lama stasiun mana pun untuk menambahkannya ke favorit.';

  @override
  String get radioAddFavourite => 'Tambahkan ke favorit';

  @override
  String get radioRemoveFavourite => 'Hapus dari favorit';

  @override
  String radioAddedToFavourites(String station) {
    return '$station ditambahkan ke favorit';
  }

  @override
  String radioRemovedFromFavourites(String station) {
    return '$station dihapus dari favorit';
  }

  @override
  String get radioSleepTimer => 'Timer Tidur';

  @override
  String get radioSleepTimerDescription =>
      'Siaran akan berhenti sendiri setelah durasi yang dipilih.';

  @override
  String radioStopsIn(String time) {
    return 'Berhenti dalam $time';
  }

  @override
  String get radioCancelTimer => 'Batalkan timer';

  @override
  String radioMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count menit',
    );
    return '$_temp0';
  }

  @override
  String get radioStopBroadcast => 'Hentikan siaran';

  @override
  String get radioTuning => 'Menyambungkan…';

  @override
  String get radioLive => 'Siaran langsung';

  @override
  String get radioPaused => 'Dijeda';

  @override
  String get radioTapToPlay => 'Ketuk untuk memutar';

  @override
  String get radioPause => 'Jeda';

  @override
  String get radioPlay => 'Putar';
}
