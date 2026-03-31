part of '../audio.dart';

class ReadersConstants {
  ReadersConstants._();
  static const ayahs1stSource = "https://cdn.islamic.network/quran/audio/";
  static const ayahs2ndSource = "https://everyayah.com/data/";
  static const surahUrl1 = "https://download.quranicaudio.com/quran/";
  static const surahUrl2 = "https://server16.mp3quran.net/";
  static const surahUrl3 = "https://server12.mp3quran.net/";
  static const surahUrl4 = "https://server6.mp3quran.net/";
  static const surahUrl5 = "https://server11.mp3quran.net/";

  /// قائمة القراء المخصصة (اختيارية) - يمكن للمستخدم تعيينها
  static List<ReaderInfo>? customAyahReaders;
  static List<ReaderInfo>? customSurahReaders;

  /// الحصول على قائمة قراء الآيات (المخصصة أو الافتراضية)
  static List<ReaderInfo> get activeAyahReaders =>
      customAyahReaders ?? ayahReaderInfo;

  /// الحصول على قائمة قراء السور (المخصصة أو الافتراضية)
  static List<ReaderInfo> get activeSurahReaders =>
      customSurahReaders ?? surahReaderInfo;

  static final List<ReaderInfo> ayahReaderInfo = [
    const ReaderInfo(
      index: 0,
      name: 'عبد الباسط',
      readerNamePath: 'Abdul_Basit_Murattal_192kbps',
      url: ayahs2ndSource,
    ),
    const ReaderInfo(
      index: 1,
      name: 'محمد المنشاوي',
      readerNamePath: 'Minshawy_Murattal_128kbps',
      url: ayahs2ndSource,
    ),
    const ReaderInfo(
      index: 2,
      name: 'محمود الحصري',
      readerNamePath: 'Husary_128kbps',
      url: ayahs2ndSource,
    ),
    const ReaderInfo(
      index: 3,
      name: 'أحمد العجمي',
      readerNamePath: '128/ar.ahmedajamy',
      url: ayahs1stSource,
    ),
    const ReaderInfo(
      index: 4,
      name: 'ماهر المعيقلي',
      readerNamePath: 'MaherAlMuaiqly128kbps',
      url: ayahs2ndSource,
    ),
    const ReaderInfo(
      index: 5,
      name: 'سعود الشريم',
      readerNamePath: 'Saood_ash-Shuraym_128kbps',
      url: ayahs2ndSource,
    ),
    const ReaderInfo(
      index: 6,
      name: 'عبد الله الجهني',
      readerNamePath: 'Abdullaah_3awwaad_Al-Juhaynee_128kbps',
      url: ayahs2ndSource,
    ),
    const ReaderInfo(
      index: 7,
      name: 'فارس عباد',
      readerNamePath: 'Fares_Abbad_64kbps',
      url: ayahs2ndSource,
    ),
    const ReaderInfo(
      index: 8,
      name: 'محمد أيوب',
      readerNamePath: '128/ar.muhammadayyoub',
      url: ayahs1stSource,
    ),
    const ReaderInfo(
      index: 9,
      name: 'ماهر المعيقلي - مجود',
      readerNamePath: 'MaherAlMuaiqly128kbps',
      url: ayahs2ndSource,
    ),
    const ReaderInfo(
      index: 10,
      name: 'ياسر الدوسري - مجود',
      readerNamePath: 'Yasser_Ad-Dussary_128kbps',
      url: ayahs2ndSource,
    ),
  ];

  static final List<ReaderInfo> surahReaderInfo = [
    const ReaderInfo(
      index: 0,
      name: 'عبد الباسط',
      readerNamePath: 'abdul_basit_murattal/',
      url: surahUrl1,
    ),
    const ReaderInfo(
      index: 1,
      name: 'محمد المنشاوي',
      readerNamePath: 'muhammad_siddeeq_al-minshaawee/',
      url: surahUrl1,
    ),
    const ReaderInfo(
      index: 2,
      name: 'محمود الحصري',
      readerNamePath: 'mahmood_khaleel_al-husaree_iza3a/',
      url: surahUrl1,
    ),
    const ReaderInfo(
      index: 3,
      name: 'أحمد العجمي',
      readerNamePath: 'ahmed_ibn_3ali_al-3ajamy/',
      url: surahUrl1,
    ),
    const ReaderInfo(
      index: 4,
      name: 'ماهر المعيقلي',
      readerNamePath: 'maher_almu3aiqly/year1440/',
      url: surahUrl1,
    ),
    const ReaderInfo(
      index: 5,
      name: 'سعود الشريم',
      readerNamePath: 'sa3ood_al-shuraym/',
      url: surahUrl1,
    ),
    const ReaderInfo(
      index: 6,
      name: 'سعد الغامدي',
      readerNamePath: 'sa3d_al-ghaamidi/complete/',
      url: surahUrl1,
    ),
    const ReaderInfo(
      index: 7,
      name: 'مصطفى العززاوي',
      readerNamePath: 'mustafa_al3azzawi/',
      url: surahUrl1,
    ),
    const ReaderInfo(
      index: 8,
      name: 'ناصر القطامي',
      readerNamePath: 'nasser_bin_ali_alqatami/',
      url: surahUrl1,
    ),
    const ReaderInfo(
      index: 9,
      name: 'قادر الكردي',
      readerNamePath: 'peshawa/Rewayat-Hafs-A-n-Assem/',
      url: surahUrl2,
    ),
    const ReaderInfo(
      index: 10,
      name: 'شيرزاد طاهر',
      readerNamePath: 'taher/',
      url: surahUrl3,
    ),
    const ReaderInfo(
      index: 11,
      name: 'عبد الرحمن العوسي',
      readerNamePath: 'aloosi/',
      url: surahUrl4,
    ),
    const ReaderInfo(
      index: 12,
      name: 'وديع اليمني',
      readerNamePath: 'wdee3/',
      url: surahUrl4,
    ),
    const ReaderInfo(
      index: 13,
      name: 'ياسر الدوسري',
      readerNamePath: 'yasser_ad-dussary/',
      url: surahUrl1,
    ),
    const ReaderInfo(
      index: 14,
      name: 'عبد الله الجهني',
      readerNamePath: 'abdullaah_3awwaad_al-juhaynee/',
      url: surahUrl1,
    ),
    const ReaderInfo(
      index: 15,
      name: 'فارس عباد',
      readerNamePath: 'fares/',
      url: surahUrl1,
    ),
    const ReaderInfo(
      index: 16,
      name: 'محمد أيوب',
      readerNamePath: 'muhammad_ayyoob_hq/',
      url: surahUrl1,
    ),
    const ReaderInfo(
      index: 17,
      name: 'ماهر المعيقلي - مجود',
      readerNamePath: 'maher/',
      url: surahUrl3,
    ),
    const ReaderInfo(
      index: 18,
      name: 'أحمد النفيس - مجود',
      readerNamePath: 'nufais/Rewayat-Hafs-A-n-Assem/',
      url: surahUrl2,
    ),
    const ReaderInfo(
      index: 19,
      name: 'ياسر الدوسري - مجود',
      readerNamePath: 'yasser/',
      url: surahUrl5,
    ),
  ];
}
