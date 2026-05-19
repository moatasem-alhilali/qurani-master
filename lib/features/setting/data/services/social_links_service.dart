import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/main.dart';

class SocialLinksService {
  SocialLinksService({
    FirebaseRemoteConfig? remoteConfig,
    CacheService? cacheService,
  })  : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance,
        _cacheService = cacheService ?? CacheService();

  final FirebaseRemoteConfig _remoteConfig;
  final CacheService _cacheService;

  static const Duration _cacheMaxAge = Duration(days: 30);
  static const String _cacheKey = 'settings_social_links';
  static const String _cacheTimeKey = 'settings_social_links_cached_at';
  static const String telegramFallbackUrl = 'https://t.me/tamaneenaquran';

  static const Map<String, String> remoteConfigKeys = {
    'telegram': 'app_social_telegram_url',
    'whatsapp': 'app_social_whatsapp_url',
    'facebook': 'app_social_facebook_url',
    'instagram': 'app_social_instagram_url',
    'twitter': 'app_social_twitter_url',
  };

  static const Map<String, String> _defaults = {
    'app_social_telegram_url': telegramFallbackUrl,
    'app_social_whatsapp_url': '',
    'app_social_facebook_url': '',
    'app_social_instagram_url': '',
    'app_social_twitter_url': '',
  };

  Future<SocialLinks> getLinks() async {
    final cachedLinks = _getCachedLinks();
    if (cachedLinks != null && _hasValidCache()) {
      return cachedLinks;
    }

    try {
      await _remoteConfig.setDefaults(_defaults);
      await _remoteConfig.fetchAndActivate();

      final links = SocialLinks(
        telegram: _readUrl('telegram', fallback: telegramFallbackUrl),
        whatsapp: _readUrl('whatsapp'),
        facebook: _readUrl('facebook'),
        instagram: _readUrl('instagram'),
        twitter: _readUrl('twitter'),
      );

      await _cacheLinks(links);
      return links;
    } catch (e) {
      logger.e('Failed to load social links: $e');
      return cachedLinks ?? SocialLinks.defaults();
    }
  }

  String _readUrl(String key, {String fallback = ''}) {
    final remoteKey = remoteConfigKeys[key]!;
    final value = _remoteConfig.getString(remoteKey).trim();
    return value.isEmpty ? fallback : value;
  }

  bool _hasValidCache() {
    final cachedAt = _cacheService.getInt(_cacheTimeKey);
    if (cachedAt == null) return false;
    final cachedDate = DateTime.fromMillisecondsSinceEpoch(cachedAt);
    return DateTime.now().difference(cachedDate) < _cacheMaxAge;
  }

  SocialLinks? _getCachedLinks() {
    final rawValue = _cacheService.getString(_cacheKey);
    if (rawValue == null || rawValue.isEmpty) return null;

    try {
      return SocialLinks.fromJson(
        jsonDecode(rawValue) as Map<String, dynamic>,
      );
    } catch (e) {
      logger.e('Failed to parse cached social links: $e');
      return null;
    }
  }

  Future<void> _cacheLinks(SocialLinks links) async {
    await Future.wait([
      _cacheService.setString(_cacheKey, jsonEncode(links.toJson())),
      _cacheService.setInt(
        _cacheTimeKey,
        DateTime.now().millisecondsSinceEpoch,
      ),
    ]);
  }
}

class SocialLinks {
  const SocialLinks({
    required this.telegram,
    required this.whatsapp,
    required this.facebook,
    required this.instagram,
    required this.twitter,
  });

  factory SocialLinks.defaults() {
    return const SocialLinks(
      telegram: SocialLinksService.telegramFallbackUrl,
      whatsapp: '',
      facebook: '',
      instagram: '',
      twitter: '',
    );
  }

  factory SocialLinks.fromJson(Map<String, dynamic> json) {
    return SocialLinks(
      telegram: json['telegram'] as String? ?? '',
      whatsapp: json['whatsapp'] as String? ?? '',
      facebook: json['facebook'] as String? ?? '',
      instagram: json['instagram'] as String? ?? '',
      twitter: json['twitter'] as String? ?? '',
    );
  }

  final String telegram;
  final String whatsapp;
  final String facebook;
  final String instagram;
  final String twitter;

  Map<String, dynamic> toJson() {
    return {
      'telegram': telegram,
      'whatsapp': whatsapp,
      'facebook': facebook,
      'instagram': instagram,
      'twitter': twitter,
    };
  }
}
