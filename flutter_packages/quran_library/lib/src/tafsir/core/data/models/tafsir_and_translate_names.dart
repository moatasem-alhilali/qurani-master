part of '../../../tafsir.dart';

final List<TafsirNameModel> _defaultTafsirTranslationsList = [
  TafsirNameModel(
    name: 'English',
    bookName: 'en',
    fileName: 'en',
    databaseName: 'en.json.gz',
    isTranslation: true,
  ),
  TafsirNameModel(
    name: 'Español',
    bookName: 'es',
    fileName: 'es',
    databaseName: 'es.json.gz',
    isTranslation: true,
  ),
  TafsirNameModel(
    name: 'বাংলা',
    bookName: 'be',
    fileName: 'be',
    databaseName: 'be.json.gz',
    isTranslation: true,
  ),
  TafsirNameModel(
    name: 'اردو',
    bookName: 'urdu',
    fileName: 'urdu',
    databaseName: 'urdu.json.gz',
    isTranslation: true,
  ),
  TafsirNameModel(
    name: 'Soomaali',
    bookName: 'so',
    fileName: 'so',
    databaseName: 'so.json.gz',
    isTranslation: true,
  ),
  TafsirNameModel(
    name: 'bahasa Indonesia',
    bookName: 'in',
    fileName: 'in',
    databaseName: 'in.json.gz',
    isTranslation: true,
  ),
  TafsirNameModel(
    name: 'کوردی',
    bookName: 'ku',
    fileName: 'ku',
    databaseName: 'ku.json.gz',
    isTranslation: true,
  ),
  TafsirNameModel(
    name: 'Türkçe',
    bookName: 'tr',
    fileName: 'tr',
    databaseName: 'tr.json.gz',
    isTranslation: true,
  ),
  TafsirNameModel(
    name: 'French',
    bookName: 'fr',
    fileName: 'fr',
    databaseName: 'fr.json.gz',
    isTranslation: true,
  ),
  TafsirNameModel(
    name: 'Tafsir Ibn Kathir (EN)',
    bookName: 'en-tafisr-ibn-kathir',
    fileName: 'en-tafisr-ibn-kathir',
    databaseName: 'en-tafisr-ibn-kathir.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'Tafsir Ibn Kathir (TR)',
    bookName: 'tr-tafsir-ibne-kathir',
    fileName: 'tr-tafsir-ibne-kathir',
    databaseName: 'tr-tafsir-ibne-kathir.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'Tafsir As Saadi (UR)',
    bookName: 'tafsir-as-saadi',
    fileName: 'tafsir-as-saadi',
    databaseName: 'tafsir-as-saadi.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'Tafsir As Saadi (ID)',
    bookName: 'tafsir-as-saadi',
    fileName: 'id-tafsir-as-saadi',
    databaseName: 'id-tafsir-as-saadi.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'Tafsir Ibn Kathir (UR)',
    bookName: 'Tafsir Ibn Kathir',
    fileName: 'tafseer-ibn-e-kaseer-urdu',
    databaseName: 'tafseer-ibn-e-kaseer-urdu.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'Fe Zalul Quran Syed Qatab (UR)',
    bookName: 'Fe Zalul Quran Syed Qatab',
    fileName: 'tafsir-fe-zalul-quran-syed-qatab',
    databaseName: 'tafsir-fe-zalul-quran-syed-qatab.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'Tafsir Jalalayn (IN)',
    bookName: 'Tafsir Jalalayn',
    fileName: 'in-tafsir-jalalayn',
    databaseName: 'in-tafsir-jalalayn.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'Tafsir As Saadi (TR)',
    bookName: 'Tafsir As Saadi',
    fileName: 'tr-tafsir-as-saadi',
    databaseName: 'tr-tafsir-as-saadi.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
];
List<TafsirNameModel> get _defaultTafsirList =>
    [..._defaultTafsirItemsList, ..._defaultTafsirTranslationsList];
final List<TafsirNameModel> _defaultTafsirItemsList = [
  TafsirNameModel(
    name: 'تفسير ابن كثير',
    bookName: 'تفسير القرآن العظيم',
    fileName: 'ibnkatheer',
    databaseName: 'ibnkatheer.json.gz',
    isTranslation: false,
    type: TafsirFileType.json,
  ),
  TafsirNameModel(
    name: 'تفسير البغوي',
    bookName: 'معالم التنزيل في تفسير القرآن',
    fileName: 'baghawy',
    databaseName: 'baghawy.json.gz',
    isTranslation: false,
    type: TafsirFileType.json,
  ),
  TafsirNameModel(
    name: 'تفسير القرطبي',
    bookName: 'الجامع لأحكام القرآن',
    fileName: 'qurtubi',
    databaseName: 'qurtubi.json.gz',
    isTranslation: false,
    type: TafsirFileType.json,
  ),
  TafsirNameModel(
    name: 'تفسير السعدي',
    bookName: 'تيسير الكريم الرحمن',
    fileName: 'saadi',
    databaseName: 'saadi.json.gz',
    isTranslation: false,
    type: TafsirFileType.json,
  ),
  TafsirNameModel(
    name: 'تفسير الطبري',
    bookName: 'جامع البيان عن تأويل آي القرآن',
    fileName: 'tabari',
    databaseName: 'tabari.json.gz',
    isTranslation: false,
    type: TafsirFileType.json,
  ),
  TafsirNameModel(
    name: 'تفسير ابن جُزَيّ',
    bookName: 'تفسير ابن جُزَيّ',
    fileName: 'tafsir-ibn-juzay',
    databaseName: 'tafsir-ibn-juzay.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'تفسير ابن عطية',
    bookName: 'المحرر الوجيز ابن عطية',
    fileName: 'al-muharrar-al-wajiz-ibn-atiyyah',
    databaseName: 'al-muharrar-al-wajiz-ibn-atiyyah.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'تفسير البسيط',
    bookName: 'تفسير البسيط',
    fileName: 'al-basit',
    databaseName: 'al-basit.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'تفسير النسفي',
    bookName: 'مدارك التنزيل وحقائق التأويل',
    fileName: 'tafsir-al-nasafi',
    databaseName: 'tafsir-al-nasafi.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'اللباب في علوم الكتاب',
    bookName: 'اللباب في علوم الكتاب',
    fileName: 'al-lubab-fi-ulum-al-kitab',
    databaseName: 'al-lubab-fi-ulum-al-kitab.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'تفسير الجلالين',
    bookName: 'تفسير الجلالين',
    fileName: 'tafsir-jalalayn',
    databaseName: 'tafsir-jalalayn.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'تفسير البيضاوي',
    bookName: 'أنوار التنزيل وأسرار التأويل',
    fileName: 'tafsir-al-baydawi',
    databaseName: 'tafsir-al-baydawi.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'تفسير ابن أبي زمنين',
    bookName: 'تفسير القرآن العزيز',
    fileName: 'tafsir-ibn-abi-zamanin',
    databaseName: 'tafsir-ibn-abi-zamanin.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'تفسير الوسيط',
    bookName: 'الوسيط في تفسير القرآن المجيد',
    fileName: 'ar-tafsir-al-wasit',
    databaseName: 'ar-tafsir-al-wasit.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'تفسير السمعاني',
    bookName: 'تفسير القرآن',
    fileName: 'tafsir-al-sam-ani',
    databaseName: 'tafsir-al-sam-ani.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'تفسير البحر المحيط',
    bookName: 'تفسير البحر المحيط',
    fileName: 'al-bahr-al-muhit',
    databaseName: 'al-bahr-al-muhit.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'تفسير الثعالبي',
    bookName: 'الجواهر الحسان في تفسير القرآن',
    fileName: 'tafsir-al-tha-alibi',
    databaseName: 'tafsir-al-tha-alibi.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'أضواء البيان في إيضاح القرآن بالقرآن',
    bookName: 'أضواء البيان في إيضاح القرآن بالقرآن',
    fileName: 'adwa-al-bayan',
    databaseName: 'adwa-al-bayan.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'الوجيز في تفسير الكتاب العزيز',
    bookName: 'الوجيز في تفسير الكتاب العزيز',
    fileName: 'al-wajiz-wahidi',
    databaseName: 'al-wajiz-wahidi.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'فتح القدير للشوكاني',
    bookName: 'فتح القدير للشوكاني',
    fileName: 'fath-al-qadir-al-shawkani',
    databaseName: 'fath-al-qadir-al-shawkani.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'تفسير ابن الجوزي',
    bookName: 'زاد المسير في علم التفسير',
    fileName: 'tafsir-ibn-al-jawzi',
    databaseName: 'tafsir-ibn-al-jawzi.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'تفسير ابن القيم',
    bookName: 'تفسير القرآن الكريم',
    fileName: 'tafsir-ibn-al-qayyim',
    databaseName: 'tafsir-ibn-al-qayyim.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'تفسير الدُّر المنثور',
    bookName: 'الدر المنثور في التفسير بالمأثور',
    fileName: 'al-durr-al-manthur',
    databaseName: 'al-durr-al-manthur.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'تفسير السمرقندي',
    bookName: 'بحر العلوم',
    fileName: 'tafsir-al-samarqandi',
    databaseName: 'tafsir-al-samarqandi.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'تفسير ابن أبي حاتم',
    bookName: 'تفسير القرآن العظيم لابن أبي حاتم',
    fileName: 'tafsir-ibn-abi-hatim',
    databaseName: 'tafsir-ibn-abi-hatim.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'تفسير أبي السعود',
    bookName: 'إرشاد العقل السليم إلى مزايا الكتاب الكريم',
    fileName: 'tafsir-abi-al-su-ood',
    databaseName: 'tafsir-abi-al-su-ood.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'تفسير الماوردي',
    bookName: 'النكت والعيون',
    fileName: 'tafsir-al-mawardi',
    databaseName: 'tafsir-al-mawardi.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
  TafsirNameModel(
    name: 'تفسير الزمخشري',
    bookName: 'الكشاف عن حقائق غوامض التنزيل',
    fileName: 'al-kashshaf-al-zamakhshari',
    databaseName: 'al-kashshaf-al-zamakhshari.json.gz',
    isTranslation: true,
    type: TafsirFileType.json, // تحديد النوع كـ JSON
  ),
];
