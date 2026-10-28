// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_helicone/otel_helicone.dart';

/// Traces Helicone calls with OpenTelemetry.
///
/// `otel_helicone` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Helicone call in
/// [tracedHelicone]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'helicone-example');

  // Traces a Helicone call.
  final heliconeId = await tracedHelicone<String>(
    operation: 'create',
    invoke: () async {
      // Make the Helicone call here, then report what it returned.
      const id = 'helicone_8f3a2c';
      return const HeliconeCallResult(
          value: id,
          result: HeliconeResult(
              orgId: 'org_8f3a2c',
              userId: 'user_8f3a2c',
              requestId: 'request_8f3a2c',
              targetUrl: 'https://api.example.com/v1/resource',
              provider: 'example',
              modelName: 'standard',
              featureName: 'example',
              cacheStatus: 'succeeded',
              cacheBucket: 'invoices',
              promptId: 'prompt_8f3a2c',
              promptVersion: 1,
              experimentId: 'experiment_8f3a2c',
              rateLimitPolicy: 'example',
              retryCount: 3,
              tokensInput: 128,
              tokensOutput: 128,
              costUsdMicros: 1,
              latencyMs: 120,
              timeToFirstTokenMs: 128,
              requestStatus: 'succeeded',
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedHelicone create returned $heliconeId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutHeliconeInstrumentationAsync.
  await runWithoutHeliconeInstrumentationAsync(
    () => tracedHelicone<String>(
      operation: 'create',
      invoke: () async {
        const id = 'helicone_8f3a2c';
        return const HeliconeCallResult(
            value: id,
            result: HeliconeResult(
                orgId: 'org_8f3a2c',
                userId: 'user_8f3a2c',
                requestId: 'request_8f3a2c',
                targetUrl: 'https://api.example.com/v1/resource',
                provider: 'example',
                modelName: 'standard',
                featureName: 'example',
                cacheStatus: 'succeeded',
                cacheBucket: 'invoices',
                promptId: 'prompt_8f3a2c',
                promptVersion: 1,
                experimentId: 'experiment_8f3a2c',
                rateLimitPolicy: 'example',
                retryCount: 3,
                tokensInput: 128,
                tokensOutput: 128,
                costUsdMicros: 1,
                latencyMs: 120,
                timeToFirstTokenMs: 128,
                requestStatus: 'succeeded',
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
