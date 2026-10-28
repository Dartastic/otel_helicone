// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_helicone_suppression.dart';

class HeliconeResult {
  /// Creates a result.
  const HeliconeResult({
    this.orgId,
    this.userId,
    this.requestId,
    this.targetUrl,
    this.provider,
    this.modelName,
    this.featureName,
    this.cacheStatus,
    this.cacheBucket,
    this.promptId,
    this.promptVersion,
    this.experimentId,
    this.rateLimitPolicy,
    this.retryCount,
    this.tokensInput,
    this.tokensOutput,
    this.costUsdMicros,
    this.latencyMs,
    this.timeToFirstTokenMs,
    this.requestStatus,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? orgId;
  final String? userId;
  final String? requestId;
  final String? targetUrl;
  final String? provider;
  final String? modelName;
  final String? featureName;
  final String? cacheStatus;
  final String? cacheBucket;
  final String? promptId;
  final int? promptVersion;
  final String? experimentId;
  final String? rateLimitPolicy;
  final int? retryCount;
  final int? tokensInput;
  final int? tokensOutput;
  final int? costUsdMicros;
  final int? latencyMs;
  final int? timeToFirstTokenMs;
  final String? requestStatus;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

/// What a traced call returned: the value for the caller plus fields
/// recorded on the span.
class HeliconeCallResult<T> {
  /// Creates a call result.
  const HeliconeCallResult({required this.value, this.result});

  /// The value returned to the caller.
  final T value;
  final HeliconeResult? result;
}

Future<T> tracedHelicone<T>({
  required String operation,
  required Future<HeliconeCallResult<T>> Function() invoke,
  APITracer? tracer,
}) async {
  if (heliconeInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTelAPI.tracerProvider().getTracer('otel_helicone');
  final span = t.startSpan('helicone $operation', kind: SpanKind.client);
  try {
    span.addAttributes(OTelAPI.attributes(
        [OTelAPI.attributeString('rpc.system', 'helicone')]));
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.method', operation)]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.orgId != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('helicone.org.id', res.orgId!)]));
      }
      if (res.userId != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('helicone.user.id', res.userId!)]));
      }
      if (res.requestId != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('helicone.request.id', res.requestId!)]));
      }
      if (res.targetUrl != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('helicone.target.url', res.targetUrl!)]));
      }
      if (res.provider != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('gen_ai.system', res.provider!)]));
      }
      if (res.modelName != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('gen_ai.request.model', res.modelName!)]));
      }
      if (res.featureName != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('helicone.feature', res.featureName!)]));
      }
      if (res.cacheStatus != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('helicone.cache.status', res.cacheStatus!)
        ]));
      }
      if (res.cacheBucket != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('helicone.cache.bucket', res.cacheBucket!)
        ]));
      }
      if (res.promptId != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('helicone.prompt.id', res.promptId!)]));
      }
      if (res.promptVersion != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('helicone.prompt.version', res.promptVersion!)
        ]));
      }
      if (res.experimentId != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('helicone.experiment.id', res.experimentId!)
        ]));
      }
      if (res.rateLimitPolicy != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'helicone.rate_limit.policy', res.rateLimitPolicy!)
        ]));
      }
      if (res.retryCount != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeInt('helicone.retry.count', res.retryCount!)]));
      }
      if (res.tokensInput != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('gen_ai.usage.input_tokens', res.tokensInput!)
        ]));
      }
      if (res.tokensOutput != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('gen_ai.usage.output_tokens', res.tokensOutput!)
        ]));
      }
      if (res.costUsdMicros != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('helicone.cost.usd_micros', res.costUsdMicros!)
        ]));
      }
      if (res.latencyMs != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeInt('helicone.latency_ms', res.latencyMs!)]));
      }
      if (res.timeToFirstTokenMs != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt(
              'helicone.time_to_first_token_ms', res.timeToFirstTokenMs!)
        ]));
      }
      if (res.requestStatus != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('helicone.request.status', res.requestStatus!)
        ]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('http.response.status_code', res.statusCode!)
        ]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('helicone.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              ErrorAttributes.errorType.key, res.errorCode ?? 'helicone.error')
        ]));
        span.setStatus(SpanStatusCode.Error, res.errorMessage);
      }
    }
    return r.value;
  } catch (e, st) {
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
