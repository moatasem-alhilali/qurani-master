class CategoryDetailModel {
  CategoryDetailModel({
    this.id,
    this.sourceid,
    this.sourceId,
    this.title,
    this.description,
    this.fullDescription,
    this.type,
    this.addDate,
    this.updateDate,
    this.orginalItem,
    this.translationLanguage,
    this.sourceLanguage,
    this.displayBoxMp4Default,
    this.image,
    this.locales,
    this.localesTypes,
    this.case_,
    this.importanceLevel,
    this.hits,
    this.preparedBy,
    this.attachments,
    this.apiUrl,
  });

  factory CategoryDetailModel.fromJson(Map<String, dynamic> json) {
    return CategoryDetailModel(
      id: json['id'] as int?,
      sourceid: json['sourceid'] as int?,
      sourceId: json['source_id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      fullDescription: json['full_description'] as String?,
      type: json['type'] as String?,
      addDate: json['add_date'] as int?,
      updateDate: json['update_date'] as int?,
      orginalItem: json['orginal_item'] as String?,
      translationLanguage: json['translation_language'] as String?,
      sourceLanguage: json['source_language'] as String?,
      displayBoxMp4Default: json['display_box_mp4_default'] as int?,
      image: json['image'] as String?,
      apiUrl: json['api_url'] as String?,
      locales: json['locales'] != null
          ? List<String>.from(json['locales'] as List)
          : null,
      localesTypes: json['locales-types'] != null
          ? (json['locales-types'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                  key, LocaleType.fromJson(value as Map<String, dynamic>)),
            )
          : null,
      case_: json['case'] as String?,
      importanceLevel: json['importance_level'] as String?,
      hits: json['hits'] as int?,
      preparedBy: json['prepared_by'] != null
          ? (json['prepared_by'] as List)
              .map((e) => PreparedBy.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      attachments: json['attachments'] != null
          ? (json['attachments'] as List)
              .map((e) => Attachment.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
  final int? id;
  final int? sourceid;
  final int? sourceId;
  final String? title;
  final String? description;
  final String? fullDescription;
  final String? type;
  final int? addDate;
  final int? updateDate;
  final String? orginalItem;
  final String? translationLanguage;
  final String? sourceLanguage;
  final int? displayBoxMp4Default;
  final String? image;
  final String? apiUrl;
  final List<String>? locales;
  final Map<String, LocaleType>? localesTypes;
  final String? case_;
  final String? importanceLevel;
  final int? hits;
  final List<PreparedBy>? preparedBy;
  final List<Attachment>? attachments;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sourceid': sourceid,
      'source_id': sourceId,
      'title': title,
      'description': description,
      'full_description': fullDescription,
      'type': type,
      'add_date': addDate,
      'update_date': updateDate,
      'orginal_item': orginalItem,
      'translation_language': translationLanguage,
      'source_language': sourceLanguage,
      'display_box_mp4_default': displayBoxMp4Default,
      'image': image,
      'locales': locales,
      'locales-types':
          localesTypes?.map((key, value) => MapEntry(key, value.toJson())),
      'case': case_,
      'importance_level': importanceLevel,
      'hits': hits,
      'prepared_by': preparedBy?.map((e) => e.toJson()).toList(),
      'attachments': attachments?.map((e) => e.toJson()).toList(),
    };
  }
}

class LocaleType {
  LocaleType({
    this.locale,
    this.type,
  });

  factory LocaleType.fromJson(Map<String, dynamic> json) {
    return LocaleType(
      locale: json['locale'] as String?,
      type: json['type'] as String?,
    );
  }
  final String? locale;
  final String? type;

  Map<String, dynamic> toJson() {
    return {
      'locale': locale,
      'type': type,
    };
  }
}

class PreparedBy {
  PreparedBy({
    this.id,
    this.sourceId,
    this.title,
    this.type,
    this.kind,
    this.description,
    this.apiUrl,
  });

  factory PreparedBy.fromJson(Map<String, dynamic> json) {
    return PreparedBy(
      id: json['id'] as int?,
      sourceId: json['source_id'] as int?,
      title: json['title'] as String?,
      type: json['type'] as String?,
      kind: json['kind'] as String?,
      description: json['description'] as String?,
      apiUrl: json['api_url'] as String?,
    );
  }
  final int? id;
  final int? sourceId;
  final String? title;
  final String? type;
  final String? kind;
  final String? description;
  final String? apiUrl;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source_id': sourceId,
      'title': title,
      'type': type,
      'kind': kind,
      'description': description,
      'api_url': apiUrl,
    };
  }
}

class Attachment {
  Attachment({
    this.order,
    this.size,
    this.extensionType,
    this.description,
    this.url,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      order: json['order'] as int?,
      size: json['size'] as String?,
      extensionType: json['extension_type'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
    );
  }
  final int? order;
  final String? size;
  final String? extensionType;
  final String? description;
  final String? url;

  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'size': size,
      'extension_type': extensionType,
      'description': description,
      'url': url,
    };
  }
}
