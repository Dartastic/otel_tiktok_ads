// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_tiktok_ads/otel_tiktok_ads.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_tiktok_ads-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('report.get records advertiser + objective + video views', () async {
    await tracedTiktokAds<String>(
      operation: 'report.get',
      invoke: () async => const TiktokAdsCallResult(
        value: 'ok',
        result: TiktokAdsResult(
          advertiserId: 'adv_1',
          bcId: 'bc_1',
          campaignId: 'cam_1',
          objectiveType: 'CONVERSIONS',
          optimizationGoal: 'CONVERT',
          billingEvent: 'OCPM',
          placementType: 'PLACEMENT_TYPE_AUTOMATIC',
          sparkAds: true,
          spendMinor: 87500,
          currencyCode: 'USD',
          impressions: 200000,
          videoPlay25Pct: 80000,
          videoPlay100Pct: 25000,
          clicks: 2400,
          conversions: 95,
          statusCode: 200,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('tiktok_ads report.get')!);
    expect(a['tiktok_ads.advertiser.id'], 'adv_1');
    expect(a['tiktok_ads.objective.type'], 'CONVERSIONS');
    expect(a['tiktok_ads.billing.event'], 'OCPM');
    expect(a['tiktok_ads.spark_ads'], true);
    expect(a['tiktok_ads.video_play_25pct'], 80000);
    expect(a['tiktok_ads.video_play_100pct'], 25000);
    expect(a['tiktok_ads.spend.minor'], 87500);
  });

  test('HTTP 403 sets span error', () async {
    await tracedTiktokAds<String>(
      operation: 'ad.create',
      invoke: () async => const TiktokAdsCallResult(
        value: 'ok',
        result: TiktokAdsResult(statusCode: 403),
      ),
    );
    expect(
      spans.findSpanByName('tiktok_ads ad.create')!.status,
      SpanStatusCode.Error,
    );
  });

  test('suppression skips spans', () async {
    await runWithoutTiktokAdsInstrumentationAsync(() async {
      await tracedTiktokAds<String>(
        operation: 'bc.list',
        invoke: () async => const TiktokAdsCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('tiktok_ads '), isEmpty);
  });
}
