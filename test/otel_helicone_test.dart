// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_helicone/otel_helicone.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_helicone-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('proxy.completion records cache hit + cost', () async {
    await tracedHelicone<String>(
      operation: 'proxy.completion',
      invoke: () async => const HeliconeCallResult(
        value: 'ok',
        result: HeliconeResult(
          provider: 'openai',
          modelName: 'gpt-4o',
          cacheStatus: 'HIT',
          cacheBucket: 'b_1',
          tokensInput: 0,
          tokensOutput: 0,
          costUsdMicros: 0,
          latencyMs: 15,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('helicone proxy.completion')!);
    expect(a['helicone.cache.status'], 'HIT');
    expect(a['gen_ai.system'], 'openai');
  });

  test('rate_limit policy + retry recorded', () async {
    await tracedHelicone<String>(
      operation: 'proxy.completion',
      invoke: () async => const HeliconeCallResult(
        value: 'ok',
        result: HeliconeResult(
          rateLimitPolicy: 'tier-1',
          retryCount: 2,
          timeToFirstTokenMs: 220,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('helicone proxy.completion')!);
    expect(a['helicone.rate_limit.policy'], 'tier-1');
    expect(a['helicone.retry.count'], 2);
  });

  test('upstream error sets span error', () async {
    await tracedHelicone<String>(
      operation: 'proxy.completion',
      invoke: () async => const HeliconeCallResult(
        value: 'ok',
        result: HeliconeResult(
          errorCode: 'upstream_error',
          statusCode: 502,
        ),
      ),
    );
    expect(
      spans.findSpanByName('helicone proxy.completion')!.status,
      SpanStatusCode.Error,
    );
  });

  test('suppression skips spans', () async {
    await runWithoutHeliconeInstrumentationAsync(() async {
      await tracedHelicone<String>(
        operation: 'requests.list',
        invoke: () async => const HeliconeCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('helicone '), isEmpty);
  });
}
