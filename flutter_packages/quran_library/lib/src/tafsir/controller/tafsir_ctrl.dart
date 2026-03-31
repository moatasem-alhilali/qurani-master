part of '../tafsir.dart';

class TafsirCtrl extends GetxController {
  TafsirCtrl._privateConstructor();
  static TafsirCtrl get instance =>
      GetInstance().putOrFind(() => TafsirCtrl._privateConstructor());

  // Rx<TafsirDatabase?> database = Rx<TafsirDatabase?>(null);
  RxList<TafsirTableData> tafseerList = <TafsirTableData>[].obs;

  static const _defaultDownloadedDbName = 'saadi.json';
  static const _defaultDownloadedTafsirName = 'saadi';
  static const _defaultDownloadedTranslationLangCode = 'en';

  String? selectedDBName = _defaultDownloadedDbName;
  String translationLangCode = 'en';

  int get translationsStartIndex =>
      tafsirAndTranslationsItems.indexWhere((el) =>
          el.isTranslation == true &&
          el.fileName == _defaultDownloadedTranslationLangCode);
  // RxString selectedTableName = MufaserName.saadi.name.obs;
  RxInt radioValue = 4.obs;
  final box = GetStorage();
  RxBool isDownloading = false.obs;
  RxBool onDownloading = false.obs;
  // مؤشر لمرحلة التهيئة قبل بدء التحميل الفعلي
  RxBool isPreparingDownload = false.obs;
  RxString progressString = "0".obs;
  RxDouble progress = 0.0.obs;
  RxDouble fontSizeArabic = 20.0.obs;
  late var cancelToken = CancelToken();
  final Rx<Map<int, bool>> tafsirDownloadStatus = Rx<Map<int, bool>>({});
  RxList<int> tafsirDownloadIndexList = <int>[].obs;
  int get _defaultTafsirIndex => tafsirAndTranslationsItems
      .indexWhere((el) => el.databaseName == _defaultDownloadedDbName);
  RxInt downloadIndex = 0.obs;
  // var isSelected = (-1.0).obs;
  RxList<TranslationModel> translationList = <TranslationModel>[].obs;
  final List<TafsirNameModel> tafsirAndTranslationsItems = [];
  var isLoading = false.obs;

  late Directory _appDir;

  static const String _customTafsirsKey = 'custom_tafsirs_v3';

  TafsirNameModel get selectedTafsir =>
      tafsirAndTranslationsItems[radioValue.value];

  List<TafsirNameModel> get tafsirWithoutTranslationItems =>
      tafsirAndTranslationsItems.where((t) => !t.isTranslation).toList();

  List<TafsirNameModel> get translationsWithoutTafsirItems =>
      tafsirAndTranslationsItems.where((t) => t.isTranslation).toList();

  List<TafsirNameModel> get customTafsirAndTranslationsItems =>
      tafsirAndTranslationsItems.where((e) => e.isCustom).toList();

  List<TafsirNameModel> get customTafsirWithoutTranslationsItems =>
      customTafsirAndTranslationsItems.where((e) => !e.isTranslation).toList();

  List<TafsirNameModel> get customTranslationsItems =>
      customTafsirAndTranslationsItems.where((e) => e.isTranslation).toList();

  bool getIsRemovableItem(int index) {
    return tafsirDownloadIndexList.contains(index) &&
        index != _defaultTafsirIndex &&
        index != translationsStartIndex;
  }

  Future<void> _loadPersistedCustoms() async {
    final raw = box.read(_customTafsirsKey);
    if (raw == null) return;
    try {
      final List<Map<String, dynamic>> arr = json.decode(raw) is List
          ? (json.decode(raw) as List)
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
          : [];
      for (final e in arr) {
        final m = Map<String, dynamic>.from(e);
        final customTafsirEntry = CustomTafsirEntry.fromJson(m);
        // verify file exists for custom entries; if missing skip
        tafsirAndTranslationsItems.insert(
            customTafsirEntry.index, customTafsirEntry.model);
        customTafsirEntries.insert(customTafsirEntry.index, customTafsirEntry);
      }
    } catch (e) {
      if (kDebugMode) print('Failed to load custom tafsirs: $e');
    }
  }

  Future<void> removeCustomTafsir(TafsirNameModel model) async {
    if (!model.isCustom) return;
    if (!kIsWeb &&
        model.type == TafsirFileType.json &&
        model.databaseName.isNotEmpty) {
      // try by databaseName inside app dir (non-web only)
      final f = File(join(_appDir.path, model.databaseName));
      if (await f.exists()) await f.delete();
    }
    customTafsirEntries.removeWhere((e) =>
        e.model.isCustom &&
        e.model.databaseName == model.databaseName &&
        e.model.name == model.name);
    tafsirAndTranslationsItems.removeWhere((e) =>
        e.isCustom &&
        e.databaseName == model.databaseName &&
        e.name == model.name);
    await _persistCustoms();
  }

  Future<void> _persistCustoms() async {
    final customOnly = customTafsirEntries.map((e) => e.toJson()).toList();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await box.write(_customTafsirsKey, json.encode(customOnly));
    });
  }

  bool _isTafsirInitialized = false;

  @override
  Future<void> onInit() async {
    // start from defaults
    if (!kIsWeb) {
      _appDir = await getApplicationDocumentsDirectory();
    }
    if (!_isTafsirInitialized) {
      await initTafsir();
    }
    super.onInit();
  }

  /// شرح: تهيئة التفسير مع التأكد من عدم تكرار إنشاء قاعدة البيانات
  /// Explanation: Initialize tafsir and avoid redundant DB creation
  Future<void> initTafsir() async {
    if (_isTafsirInitialized) {
      log('TafsirCtrl already initialized, skipping.', name: 'TafsirCtrl');
      return;
    }
    tafsirAndTranslationsItems.assignAll(_defaultTafsirList);
    await _loadPersistedCustoms().then((_) async {
      await _initializeTafsirDownloadStatus();
      await _loadSelectedDefaultTafseer();
      // await initializeDatabase();
    });
    _isTafsirInitialized = true;
    log('TafsirCtrl initialized.', name: 'TafsirCtrl');
  }

  Future<void> _loadSelectedDefaultTafseer() async {
    radioValue.value =
        box.read(_StorageConstants().radioValue) ?? _defaultTafsirIndex;
    translationLangCode =
        box.read(_StorageConstants().translationLangCode) ?? 'en';
    TafsirCtrl.instance.fontSizeArabic.value =
        box.read(_StorageConstants().fontSize) ?? 20.0;
  }

  // Future<void> closeCurrentDatabase() async {
  //   if (database.value != null) {
  //     if (database.value?.isOpen ?? false) await database.value?.close();
  //     database.value = null; // شرح: إعادة تعيين الكائن بعد الإغلاق
  //     log('Closed current database!', name: 'TafsirCtrl');
  //   }
  // }

  /// ------------[FetchingMethod]------------
  /// شرح: جلب بيانات التفسير للصفحة المطلوبة
  /// Explanation: Fetch tafsir data for the requested page
  Future<void> fetchData(int pageNum) async {
    // await initializeDatabase();
    isLoading.value = true;
    try {
      if (isCurrentAcustomTafsir) {
        final customEntry = customTafsirEntries.firstWhereOrNull((e) =>
            e.model.databaseName ==
                tafsirAndTranslationsItems[radioValue.value].databaseName &&
            e.model.name == tafsirAndTranslationsItems[radioValue.value].name);
        if (customEntry != null) {
          final items = customEntry.items
              // .where((e) => e.pageNum == pageNum)
              .toList(growable: false);
          tafseerList.assignAll(items);
          log('Fetched tafsir: [31m${items.length} entries from custom tafsir.',
              name: 'TafsirCtrl');
        } else {
          log('Custom tafsir entry not found.', name: 'TafsirCtrl');
        }
        return;
      }
      if (selectedTafsir.type == TafsirFileType.json) {
        String jsonString;
        if (selectedTafsir.fileName == _defaultDownloadedTafsirName) {
          jsonString = await rootBundle.loadString(
              'packages/quran_library/assets/$_defaultDownloadedTafsirName.json');
        } else {
          if (kIsWeb) {
            final url =
                'https://raw.githubusercontent.com/alheekmahlib/Islamic_database/refs/heads/main/tafseer_database/${selectedTafsir.databaseName}';
            final dio = Dio();
            final resp = await dio.get<String>(url,
                options: Options(responseType: ResponseType.plain));
            jsonString = resp.data ?? '[]';
          } else {
            String filePath = join(_appDir.path, selectedTafsir.databaseName);
            final exists = await File(filePath).exists();
            if (!exists) {
              log('NotExists');
              await tafsirAndTranslationDownload(radioValue.value);
              return;
            } else {
              jsonString = await File(filePath).readAsString();
            }
          }
        }
        final jsonData =
            List<Map<String, dynamic>>.from(json.decode(jsonString));
        final fetchedTafsirsList = jsonData.map((e) => TafsirTableData(
              id: e['index'],
              surahNum: e['sura'],
              ayahNum: e['aya'],
              tafsirText: e['text'],
              pageNum: e['PageNum'],
            ));
        final items = fetchedTafsirsList; //.where((e) => e.pageNum == pageNum);
        tafseerList.assignAll(items);
        return;
      }
    } catch (e) {
      log('Error fetching data: $e', name: 'TafsirCtrl');
    } finally {
      isLoading.value = false;
    }
  }

  /// شرح: جلب التفسير حسب رقم الصفحة
  /// Explanation: Fetch tafsir by page number
  Future<List<TafsirTableData>> fetchTafsirPage(int pageNum,
      {String? databaseName}) async {
    await fetchData(pageNum);
    return tafseerList.where((e) => e.pageNum == pageNum).toList();
  }

  /// شرح: جلب التفسير حسب رقم الآية
  /// Explanation: Fetch tafsir by ayah number
  Future<List<TafsirTableData>> fetchTafsirAyah(int ayahUQNumber,
      {String? databaseName}) async {
    return tafseerList
        .where((e) =>
            QuranCtrl.instance
                .getAyahUnqNumberBySurahAndAyahNumber(e.surahNum, e.ayahNum) ==
            ayahUQNumber)
        .toList();
  }

  /// شرح: جلب الترجمة
  /// Explanation: Fetch translation
  Future<void> fetchTranslate() async {
    try {
      isLoading.value = true;

      String jsonString;
      if (radioValue.value == translationsStartIndex) {
        jsonString = await rootBundle
            .loadString('packages/quran_library/assets/en.json');
      } else if (kIsWeb) {
        final url =
            'https://raw.githubusercontent.com/alheekmahlib/Islamic_database/refs/heads/main/quran_database/translate/$translationLangCode.json';
        final dio = Dio();
        final resp = await dio.get<String>(url,
            options: Options(responseType: ResponseType.plain));
        jsonString = resp.data ?? '{}';
      } else {
        final String path = join(_appDir.path, '$translationLangCode.json');
        final exists = await File(path).exists();
        if (!exists) {
          // حمّل الملف محليًا ثم اقرأه
          await tafsirAndTranslationDownload(radioValue.value);
          final exists2 = await File(path).exists();
          if (!exists2) throw Exception('Translation file not found');
        }
        jsonString = await File(path).readAsString();
      }

      // تحقق من نوع البنية في الملف
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // تحقق إذا كانت البنية العادية للترجمات (تحتوي على "t" في القيم)
      bool isStandardTranslation = false;
      if (jsonData.isNotEmpty) {
        final firstEntry = jsonData.entries.first;
        if (firstEntry.value is Map<String, dynamic> &&
            (firstEntry.value as Map<String, dynamic>).containsKey('t')) {
          isStandardTranslation = true;
        }
      }

      if (isStandardTranslation) {
        // البنية العادية للترجمات (en.json وغيرها)
        log('Loading standard translation format', name: 'TafsirCtrl');
        final translationsModel = TranslationsModel.fromJson(jsonString);
        translationList.value = translationsModel.getTranslationsAsList();
        log('Loaded ${translationList.length} standard translation entries',
            name: 'TafsirCtrl');
      } else {
        // البنية الجديدة للتفاسير الإنجليزية (تفسير ابن كثير مثلاً)
        final tafsirTranslations = <TranslationModel>[];
        for (final entry in jsonData.entries) {
          if (entry.value is Map<String, dynamic> &&
              entry.value['text'] != null) {
            tafsirTranslations.add(TranslationModel(
              surahAyah: entry.key,
              text: entry.value['text'] as String,
              footnotes: {},
            ));
          } else if (entry.value is String) {
            // في حالة أن القيمة تشير لآية أخرى (مثل "1:6": "1:7")
            final referencedValue = jsonData[entry.value];
            if (referencedValue is Map<String, dynamic> &&
                referencedValue['text'] != null) {
              tafsirTranslations.add(TranslationModel(
                surahAyah: entry.key,
                text: referencedValue['text'] as String,
                footnotes: {},
              ));
            }
          }
        }
        translationList.value = tafsirTranslations
          ..sort((a, b) {
            final surahComparison = a.surahNumber.compareTo(b.surahNumber);
            if (surahComparison != 0) return surahComparison;
            return a.ayahNumber.compareTo(b.ayahNumber);
          });
        log('Loaded ${tafsirTranslations.length} tafsir translation entries',
            name: 'TafsirCtrl');
      }
    } catch (e) {
      log('Error loading translation file: $e', name: 'TafsirCtrl');
    } finally {
      isLoading.value = false;
    }
    update(['tafsirs_menu_list']);
  }

  /// الحصول على ترجمة آية معينة
  /// Get translation for a specific ayah
  TranslationModel? getTranslationForAyah(int surah, int ayah) {
    return translationList.firstWhereOrNull(
      (translation) =>
          translation.surahNumber == surah && translation.ayahNumber == ayah,
    );
  }

  /// الحصول على ترجمة آية معينة بناءً على AyahModel
  /// Get translation for a specific ayah based on AyahModel
  TranslationModel? getTranslationForAyahModel(AyahModel ayah, int ayahIndex) {
    if (kDebugMode) {
      print(
          'Looking for translation: Surah ${ayah.surahNumber}, Ayah ${ayah.ayahNumber}, Index $ayahIndex, Total: ${translationList.length}');
    }

    // أولوية للبحث بناءً على رقم السورة والآية
    if (ayah.surahNumber != null) {
      final translation = translationList.firstWhereOrNull(
        (t) =>
            t.surahNumber == ayah.surahNumber &&
            t.ayahNumber == ayah.ayahNumber,
      );
      if (translation != null) {
        if (kDebugMode) {
          print('Found translation by surah/ayah: ${translation.surahAyah}');
        }
        return translation;
      }
    }

    // إذا لم توجد، استخدم المؤشر التقليدي
    if (ayahIndex > 0 && ayahIndex <= translationList.length) {
      final translation = translationList[ayahIndex - 1];
      if (kDebugMode) {
        print('Found translation by index: ${translation.surahAyah}');
      }
      return translation;
    }

    if (kDebugMode) {
      print('No translation found');
    }
    return null;
  }

  /// الحصول على النص المترجم لآية معينة
  /// Get translated text for a specific ayah
  String getTranslationText(int surah, int ayah) {
    final translation = getTranslationForAyah(surah, ayah);
    return translation?.text ?? '';
  }

  /// الحصول على الحواشي لآية معينة
  /// Get footnotes for a specific ayah
  Map<String, String> getFootnotesForAyah(int surah, int ayah) {
    final translation = getTranslationForAyah(surah, ayah);
    return translation?.footnotes ?? {};
  }

  /// الحصول على ترجمات صفحة كاملة
  /// Get translations for an entire page
  List<TranslationModel> getTranslationsForPage(int pageNumber) {
    // يحتاج تنفيذ القران للحصول على قائمة الآيات في الصفحة
    // This needs Quran implementation to get list of ayahs in the page
    return translationList.where((translation) {
      // يمكن إضافة منطق هنا للتحقق من الصفحة حسب الحاجة
      return true; // مؤقت
    }).toList();
  }

  /// ------------[DownloadMethods]------------
  /// شرح: تحميل قاعدة بيانات التفسير أو الترجمة
  /// Explanation: Download tafsir or translation database
  Future<void> tafsirAndTranslationDownload(int i) async {
    // ابدأ عرض حالة التهيئة فور النقر قبل بدء التحميل الفعلي
    isPreparingDownload.value = true;
    update(['tafsirs_menu_list']);

    if (kIsWeb) {
      // على الويب لا يوجد تنزيل محلي، اعتبره "متاح" مباشرةً
      _onDownloadSuccess(i);
      // انتهاء مرحلة التهيئة
      isPreparingDownload.value = false;
      update(['tafsirs_menu_list']);
      return;
    }

    String path;
    String fileUrl;
    final idx = (i >= 0 && i < tafsirAndTranslationsItems.length) ? i : 0;
    final selected = tafsirAndTranslationsItems[idx];
    if (!selected.isTranslation) {
      path = join(_appDir.path, selected.databaseName);
      fileUrl =
          'https://github.com/alheekmahlib/Islamic_database/raw/refs/heads/main/tafseer_database/${selected.databaseName}';
    } else {
      path = join(_appDir.path, '${selected.fileName}.json');
      fileUrl =
          'https://github.com/alheekmahlib/Islamic_database/raw/refs/heads/main/quran_database/translate/${selected.fileName}.json';
    }

    if (!onDownloading.value) {
      onDownloading.value = true;
      await downloadFile(path, fileUrl).then((_) async {
        log('Download completed for $path', name: 'TafsirCtrl');
        _onDownloadSuccess(i);
        await _saveTafsirDownloadIndex(i);
        await _loadTafsirDownloadIndices();
        await handleRadioValueChanged(i);
      });
      // انتهاء التحميل: أوقف مؤشر التهيئة إن كان ما يزال مفعلاً
      isPreparingDownload.value = false;
      onDownloading.value = false;
      update(['tafsirs_menu_list']);
      log('Downloading from URL: $fileUrl', name: 'TafsirCtrl');
    } else {
      // يوجد تنزيل جارٍ بالفعل، أوقف مؤشر التهيئة لهذا الطلب
      isPreparingDownload.value = false;
    }
    update(['tafsirs_menu_list']);
  }

  /// شرح: تهيئة حالة تحميل التفسير
  /// Explanation: Initialize tafsir download status
  Future<void> _initializeTafsirDownloadStatus() async {
    await _loadTafsirDownloadIndices();
    Map<int, bool> initialStatus = await _checkAllTafsirDownloaded();
    tafsirDownloadStatus.value = initialStatus;
  }

  /// شرح: تحديث حالة التحميل
  /// Explanation: Update download status
  void _updateDownloadStatus(int tafsirNumber, bool downloaded) {
    final newStatus = Map<int, bool>.from(tafsirDownloadStatus.value);
    newStatus[tafsirNumber] = downloaded;
    tafsirDownloadStatus.value = newStatus;
  }

  /// شرح: عند نجاح التحميل
  /// Explanation: On download success
  void _onDownloadSuccess(int tafsirNumber) {
    _updateDownloadStatus(tafsirNumber, true);
  }

  /// شرح: فحص جميع ملفات التفسير
  /// Explanation: Check all tafsir files
  Future<Map<int, bool>> _checkAllTafsirDownloaded() async {
    if (kIsWeb) {
      // على الويب: نعتبر جميع العناصر "متاحة" بدون تنزيلات محلية
      for (int i = 0; i < tafsirAndTranslationsItems.length; i++) {
        tafsirDownloadStatus.value[i] = true;
      }
      return tafsirDownloadStatus.value;
    }
    for (int i = 0; i < tafsirAndTranslationsItems.length; i++) {
      if (i == _defaultTafsirIndex ||
          i == translationsStartIndex ||
          tafsirAndTranslationsItems[i].isCustom) {
        tafsirDownloadStatus.value[i] = true;
        continue;
      }
      final dbName = tafsirAndTranslationsItems[i].databaseName;
      String filePath = '${_appDir.path}/$dbName';
      File file = File(filePath);
      final exists = await file.exists();
      if (!exists && tafsirDownloadIndexList.contains(i)) {
        tafsirDownloadIndexList.remove(i);
        await box.write('tafsirDownloadIndices', tafsirDownloadIndexList);
      }
      tafsirDownloadStatus.value[i] = exists;
    }
    return tafsirDownloadStatus.value;
  }

  /// شرح: حفظ أرقام التفسير المحملة
  /// Explanation: Save downloaded tafsir indices
  Future<void> _saveTafsirDownloadIndex(int tafsirNumber) async {
    List<dynamic> savedIndices = box.read('tafsirDownloadIndices') ??
        [_defaultTafsirIndex, translationsStartIndex];
    if (!savedIndices.contains(tafsirNumber)) {
      savedIndices.add(tafsirNumber);
      await box.write('tafsirDownloadIndices', savedIndices);
    }
  }

  /// شرح: تحميل أرقام التفسير المحملة
  /// Explanation: Load downloaded tafsir indices
  Future<void> _loadTafsirDownloadIndices() async {
    var rawList = box.read('tafsirDownloadIndices');
    List<int> savedIndices = rawList is List
        ? rawList.map((e) => e as int).toList()
        : [_defaultTafsirIndex, translationsStartIndex];
    tafsirDownloadIndexList.value = savedIndices;
  }

  /// شرح: حذف تفسير أو ترجمة محملة
  /// Explanation: Delete a downloaded tafsir or translation
  Future<bool> deleteTafsirOrTranslation({required int itemIndex}) async {
    if (kIsWeb) {
      log('Cannot delete files on web platform', name: 'TafsirCtrl');
      return false;
    }

    // منع حذف التفسير والترجمة الافتراضية
    if (itemIndex == _defaultTafsirIndex ||
        itemIndex == translationsStartIndex) {
      log('Cannot delete default tafsir or translation', name: 'TafsirCtrl');
      return false;
    }

    // منع حذف التفاسير المخصصة (لها دالة منفصلة)
    if (itemIndex >= 0 && itemIndex < tafsirAndTranslationsItems.length) {
      final selected = tafsirAndTranslationsItems[itemIndex];
      if (selected.isCustom) {
        log('Use removeCustomTafsir for custom entries', name: 'TafsirCtrl');
        return false;
      }
    }

    try {
      final selected = tafsirAndTranslationsItems[itemIndex];
      String filePath;

      if (!selected.isTranslation) {
        filePath = join(_appDir.path, selected.databaseName);
      } else {
        filePath = join(_appDir.path, '${selected.fileName}.json');
      }

      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        log('Deleted file: $filePath', name: 'TafsirCtrl');
      } else {
        log('File not found: $filePath', name: 'TafsirCtrl');
      }

      // تحديث حالة التحميل
      _updateDownloadStatus(itemIndex, false);

      // إزالة الفهرس من القائمة المحفوظة
      tafsirDownloadIndexList.remove(itemIndex);
      await box.write('tafsirDownloadIndices', tafsirDownloadIndexList);

      // إعادة فحص جميع الملفات
      await _checkAllTafsirDownloaded();

      // إذا كان التفسير المحذوف هو المختار حاليًا، العودة للتفسير الافتراضي
      if (radioValue.value == itemIndex) {
        await handleRadioValueChanged(_defaultTafsirIndex);
      }

      update(['tafsirs_menu_list']);
      log('Successfully deleted tafsir/translation at index $itemIndex',
          name: 'TafsirCtrl');
      return true;
    } catch (e) {
      log('Error deleting tafsir/translation: $e', name: 'TafsirCtrl');
      return false;
    }
  }

  List<CustomTafsirEntry> customTafsirEntries = [];

  /// Add CustomTafsirEntry objects (persist models and register entries)
  Future<bool> addCustomTafsirEntries(List<CustomTafsirEntry> entries) async {
    var added = false;
    try {
      for (final entry in entries) {
        final m = entry.model;
        final exists = tafsirAndTranslationsItems.firstWhereOrNull((e) =>
                e.isCustom &&
                e.databaseName == m.databaseName &&
                e.name == m.name) !=
            null;
        if (!exists) {
          tafsirAndTranslationsItems.insert(entry.index, m);
          added = true;
        }
      }
      // append to live observable list (avoid duplicates)
      for (final entry in entries) {
        final already = customTafsirEntries.firstWhereOrNull((e) =>
                e.model.databaseName == entry.model.databaseName &&
                e.name == entry.name) !=
            null;
        if (!already) customTafsirEntries.insert(entry.index, entry);
      }
      if (added) await _persistCustoms();
      await _initializeTafsirDownloadStatus();
      update(['tafsirs_menu_list']);
      return true;
    } catch (e) {
      if (kDebugMode) print('Error adding custom tafsir entries: $e');
      return false;
    }
  }
}

class CustomTafsirEntry {
  final String name;
  final TafsirNameModel model;
  final List<TafsirTableData> items;
  final int index;
  int ayahUnqNum(int ayahNum) => (QuranCtrl.instance
      .getAyahUnqNumberBySurahAndAyahNumber(items.first.surahNum, ayahNum));

  const CustomTafsirEntry({
    required this.name,
    required this.model,
    required this.items,
    this.index = 0,
  });

  factory CustomTafsirEntry.fromJson(Map<String, dynamic> j) =>
      CustomTafsirEntry(
        name: j['name'] as String,
        model: TafsirNameModel.fromJson(
            Map<String, dynamic>.from(j['model'] as Map)),
        items: (j['items'] as List)
            .map((e) => TafsirTableData.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        index: j['index'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'model': model.toJson(),
        'items': items.map((e) => e.toJson()).toList(),
        'index': index,
      };
}
