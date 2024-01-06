import 'dart:async';

import 'package:firebase_performance/firebase_performance.dart';
import 'package:http/http.dart';

import '../configs.dart';

class ConfigPerformance {
  static final FirebasePerformance _performance = FirebasePerformance.instance;
  static const bool _isPerformanceCollectionEnabled = false;
  static const traceSignIn = 'traceSignIn';
  static const phoneNumber = 'phoneNumber';
  static const send = 'SEND';
  static const baseUrl = EnvironmentConfig.baseUrl;

  static Future<void> init() async {
    await _togglePerformanceCollection();
    await customHttpMetric();
  }

  static Future<void> _togglePerformanceCollection() async {
    // No-op for web.
    await _performance
        .setPerformanceCollectionEnabled(!_isPerformanceCollectionEnabled);

    // Always true for web.
    await _performance.isPerformanceCollectionEnabled();
  }

  static Future<void> signIn(String phoneNumber) async {
    final trace = _performance.newTrace(traceSignIn);
    await trace.start();
    trace.putAttribute(phoneNumber, phoneNumber);
    await trace.stop();
  }

  static Future<void> customHttpMetric() async {
    final metricHttpClient = _MetricHttpClient(Client());

    final request = Request(
      send,
      Uri.parse(baseUrl),
    );

    unawaited(metricHttpClient.send(request));
  }
}

class _MetricHttpClient extends BaseClient {
  _MetricHttpClient(this._inner);

  final Client _inner;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    // Custom network monitoring is not supported for web.
    // https://firebase.google.com/docs/perf-mon/custom-network-traces?platform=android
    final metric = FirebasePerformance.instance
        .newHttpMetric(request.url.toString(), HttpMethod.Get)
      ..requestPayloadSize = request.contentLength;

    await metric.start();

    StreamedResponse response;
    try {
      response = await _inner.send(request);
      print(
        'Called ${request.url} with custom monitoring, response code: ${response.statusCode}',
      );

      metric
        ..responseContentType = 'application/json'
        ..httpResponseCode = response.statusCode
        ..responsePayloadSize = response.contentLength;
      // ..putAttribute('score', '15')
      // ..putAttribute('to_be_removed', 'should_not_be_logged');
    } finally {
      // metric.removeAttribute('to_be_removed');
      await metric.stop();
    }

    // final attributes = metric.getAttributes();

    // print('Http metric attributes: $attributes.');
    // final score = metric.getAttribute('score');
    // print('Http metric score attribute value: $score');
    return response;
  }
}
