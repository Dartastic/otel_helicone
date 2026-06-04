// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

import 'otel_helicone_suppression.dart';

class HeliconeResult {
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

class HeliconeCallResult<T> {
  const HeliconeCallResult({required this.value, this.result});
  final T value;
  final HeliconeResult? result;
}

Future<T> tracedHelicone<T>({
  required String operation,
  required Future<HeliconeCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (heliconeInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_helicone');
  final span = t.startSpan('helicone $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.system', 'helicone')]));
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.method', operation)]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.orgId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('helicone.org.id', res.orgId!)]));
      }
      if (res.userId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('helicone.user.id', res.userId!)]));
      }
      if (res.requestId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('helicone.request.id', res.requestId!)]));
      }
      if (res.targetUrl != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('helicone.target.url', res.targetUrl!)]));
      }
      if (res.provider != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('gen_ai.system', res.provider!)]));
      }
      if (res.modelName != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('gen_ai.request.model', res.modelName!)]));
      }
      if (res.featureName != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('helicone.feature', res.featureName!)]));
      }
      if (res.cacheStatus != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('helicone.cache.status', res.cacheStatus!)]));
      }
      if (res.cacheBucket != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('helicone.cache.bucket', res.cacheBucket!)]));
      }
      if (res.promptId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('helicone.prompt.id', res.promptId!)]));
      }
      if (res.promptVersion != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt('helicone.prompt.version', res.promptVersion!)
        ]));
      }
      if (res.experimentId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('helicone.experiment.id', res.experimentId!)
        ]));
      }
      if (res.rateLimitPolicy != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
              'helicone.rate_limit.policy', res.rateLimitPolicy!)
        ]));
      }
      if (res.retryCount != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('helicone.retry.count', res.retryCount!)]));
      }
      if (res.tokensInput != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt('gen_ai.usage.input_tokens', res.tokensInput!)
        ]));
      }
      if (res.tokensOutput != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt('gen_ai.usage.output_tokens', res.tokensOutput!)
        ]));
      }
      if (res.costUsdMicros != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt('helicone.cost.usd_micros', res.costUsdMicros!)
        ]));
      }
      if (res.latencyMs != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('helicone.latency_ms', res.latencyMs!)]));
      }
      if (res.timeToFirstTokenMs != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt(
              'helicone.time_to_first_token_ms', res.timeToFirstTokenMs!)
        ]));
      }
      if (res.requestStatus != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('helicone.request.status', res.requestStatus!)
        ]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('http.response.status_code', res.statusCode!)]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('helicone.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
              ErrorResource.errorType.key, res.errorCode ?? 'helicone.error')
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
