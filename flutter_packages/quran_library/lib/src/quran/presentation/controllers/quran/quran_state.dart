part of '/quran.dart';

class QuranState {
  /// -------- [Variables] ----------
  // List<SurahModel> surahs = [];
  List<List<AyahModel>> pages = [];
  List<AyahModel> allAyahs = [];

  RxInt currentPageNumber = 1.obs;
  RxBool isPlayExpanded = false.obs;
  // RxBool isSajda => false.obs;
  RxBool isBold = false.obs;
  RxDouble scaleFactor = 1.0.obs;
  RxDouble baseScaleFactor = 1.0.obs;
  // قفل سلوك التمرير أثناء عملية التكبير/التصغير بإصبعين
  // Lock scrolling while pinch-to-zoom is active
  RxBool isScaling = false.obs;
  Map<int, int> pageToHizbQuarterMap = {};

  double surahItemHeight = 90.0;

  bool isQuranLoaded = false;
  RxBool isFontDownloaded = true.obs;
  RxList<int> fontsDownloadedList = <int>[].obs;
  RxInt fontsSelected = 0.obs;

  /// هل خطوط التجويد المضغوطة جاهزة للعرض؟
  RxBool fontsReady = false.obs;

  /// نسبة تقدّم تحميل خطوط التجويد (0.0–1.0).
  RxDouble fontsLoadProgress = 0.0.obs;

  RxBool isShowMenu = false.obs;

  final FocusNode quranPageRLFocusNode = FocusNode();

  RxBool isTajweedEnabled = false.obs;

  /// وضع العرض الحالي (افتراضي، صفحة قابلة للتمرير، صفحتان، مصحف+تفسير، آية+تفسير)
  /// Current display mode
  Rx<QuranDisplayMode> displayMode = QuranDisplayMode.defaultMode.obs;

  // ملاحظة: تم إزالة GlobalKey<ScaffoldState> لتجنب التعارض مع التطبيقات الأخرى
  // Note: GlobalKey<ScaffoldState> has been removed to avoid conflicts with other applications

  void dispose() {
    currentPageNumber.close();
    isPlayExpanded.close();
    isBold.close();
    scaleFactor.close();
    baseScaleFactor.close();
    isScaling.close();
    isFontDownloaded.close();
    fontsDownloadedList.close();
    fontsSelected.close();
    fontsReady.close();
    fontsLoadProgress.close();
    displayMode.close();
    quranPageRLFocusNode.dispose();
  }
}
