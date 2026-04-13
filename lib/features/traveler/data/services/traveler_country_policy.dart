class TravelerCountryPolicy {
  static bool isIslamicCountryCode(String? isoCode) {
    final normalized = isoCode?.trim().toUpperCase();
    if (normalized == null || normalized.isEmpty) {
      return false;
    }
    return _islamicCountryCodes.contains(normalized);
  }

  // دول منظمة التعاون الإسلامي + الدول ذات الغالبية المسلمة.
  static const Set<String> _islamicCountryCodes = {
    'AF',
    'AL',
    'AZ',
    'BH',
    'BD',
    'BN',
    'BF',
    'TD',
    'KM',
    'DJ',
    'EG',
    'GA',
    'GM',
    'GN',
    'GW',
    'ID',
    'IR',
    'IQ',
    'JO',
    'KZ',
    'KW',
    'KG',
    'LB',
    'LY',
    'MY',
    'MV',
    'ML',
    'MR',
    'MA',
    'MZ',
    'NE',
    'NG',
    'OM',
    'PK',
    'PS',
    'QA',
    'SA',
    'SN',
    'SL',
    'SO',
    'SD',
    'SR',
    'SY',
    'TJ',
    'TG',
    'TN',
    'TR',
    'TM',
    'AE',
    'UZ',
    'YE',
  };
}
