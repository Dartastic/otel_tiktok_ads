// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_tiktok_ads/otel_tiktok_ads.dart';

/// Traces TikTok Ads calls with OpenTelemetry.
///
/// `otel_tiktok_ads` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each TikTok Ads call in
/// [tracedTiktokAds]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'tiktok-ads-example');

  // Wraps a TikTok Ads API call in a CLIENT span.
  final tiktokAdsId = await tracedTiktokAds<String>(
    operation: 'campaign.create',
    invoke: () async {
      // Make the TikTok Ads call here, then report what it returned.
      const id = 'tiktok_ads_8f3a2c';
      return const TiktokAdsCallResult(
          value: id,
          result: TiktokAdsResult(
              advertiserId: 'advertiser_8f3a2c',
              bcId: 'bc_8f3a2c',
              campaignId: 'campaign_8f3a2c',
              adGroupId: 'adgroup_8f3a2c',
              adId: 'ad_8f3a2c',
              objectiveType: 'TRAFFIC',
              optimizationGoal: 'CLICK',
              billingEvent: 'CPC',
              placementType: 'PLACEMENT_TYPE_AUTOMATIC',
              operationStatus: 'ENABLE',
              sparkAds: true,
              spendMinor: 1,
              currencyCode: 'usd',
              impressions: 1,
              reach: 1,
              videoPlay25Pct: 1,
              videoPlay100Pct: 1,
              clicks: 1,
              conversions: 1,
              statusCode: 201));
    },
  );
  OTelLog.info('tracedTiktokAds campaign.create returned $tiktokAdsId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutTiktokAdsInstrumentationAsync.
  await runWithoutTiktokAdsInstrumentationAsync(
    () => tracedTiktokAds<String>(
      operation: 'campaign.create',
      invoke: () async {
        const id = 'tiktok_ads_8f3a2c';
        return const TiktokAdsCallResult(
            value: id,
            result: TiktokAdsResult(
                advertiserId: 'advertiser_8f3a2c',
                bcId: 'bc_8f3a2c',
                campaignId: 'campaign_8f3a2c',
                adGroupId: 'adgroup_8f3a2c',
                adId: 'ad_8f3a2c',
                objectiveType: 'TRAFFIC',
                optimizationGoal: 'CLICK',
                billingEvent: 'CPC',
                placementType: 'PLACEMENT_TYPE_AUTOMATIC',
                operationStatus: 'ENABLE',
                sparkAds: true,
                spendMinor: 1,
                currencyCode: 'usd',
                impressions: 1,
                reach: 1,
                videoPlay25Pct: 1,
                videoPlay100Pct: 1,
                clicks: 1,
                conversions: 1,
                statusCode: 201));
      },
    ),
  );

  await OTel.shutdown();
}
