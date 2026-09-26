import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import '../../utils/firebase_options.dart';

class AnalyticsService {
  AnalyticsService._();

  static final AnalyticsService instance = AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: {
          'platform': DefaultFirebaseOptions.getCurrentPlatform,
          ...?parameters,
        },
      );
      // Debug log
      debugPrint('[Analytics] Event: $name | Parameters: $parameters');
    } catch (e, stackTrace) {
      debugPrint('[Analytics] Failed: $name | Error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> setUserId(String userId) async {
    try {
      await _analytics.setUserId(id: userId);
      debugPrint('[Analytics] User ID set: $userId');
    } catch (e, stackTrace) {
      debugPrint('[Analytics] Failed to set User ID | Error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> clearUserId() async {
    try {
      await _analytics.setUserId(id: null);
      debugPrint('[Analytics] User ID cleared');
    } catch (e, stackTrace) {
      debugPrint('[Analytics] Failed to clear User ID | Error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    try {
      await _analytics.setUserProperty(
        name: name,
        value: value,
      );
      debugPrint('[Analytics] User Property: $name = $value');
    } catch (e, stackTrace) {
      debugPrint(
        '[Analytics] Failed to set User Property | '
        '$name = $value | Error: $e',
      );
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}