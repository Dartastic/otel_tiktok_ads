// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

import 'otel_tiktok_ads_suppression.dart';

const _tracerName = 'dartastic_otel_libs_tiktok_ads';

Tracer _tracer() => OTel.tracerProvider().getTracer(_tracerName);

class TiktokAdsResult {
  const TiktokAdsResult({
    this.advertiserId,
    this.bcId,
    this.campaignId,
    this.adGroupId,
    this.adId,
    this.objectiveType,
    this.optimizationGoal,
    this.billingEvent,
    this.placementType,
    this.operationStatus,
    this.sparkAds,
    this.spendMinor,
    this.currencyCode,
    this.impressions,
    this.reach,
    this.videoPlay25Pct,
    this.videoPlay100Pct,
    this.clicks,
    this.conversions,
    this.statusCode,
  });

  final String? advertiserId;

  /// Business Center id (parent of advertiser).
  final String? bcId;

  final String? campaignId;
  final String? adGroupId;
  final String? adId;

  /// `TRAFFIC` / `CONVERSIONS` / `APP_PROMOTION` / `LEAD_GENERATION` /
  /// `REACH` / `VIDEO_VIEWS` / `SHOP_PURCHASES` / `ENGAGEMENT`.
  final String? objectiveType;

  /// `CLICK` / `CONVERT` / `INSTALL` / `VALUE` / `REACH` /
  /// `VIDEO_VIEW` / `LEAD_GENERATION`.
  final String? optimizationGoal;

  /// `CPC` / `CPM` / `OCPM` / `CPV`.
  final String? billingEvent;

  /// `PLACEMENT_TYPE_AUTOMATIC` / `PLACEMENT_TYPE_NORMAL` (manual
  /// selection of TikTok/Pangle/News Feed App Series).
  final String? placementType;

  /// `ENABLE` / `DISABLE` / `DELETE`. Note creative review uses
  /// status_code returned separately.
  final String? operationStatus;

  /// `true` if the ad uses Spark Ads (boosted organic post).
  final bool? sparkAds;

  /// Spend in minor currency units.
  final int? spendMinor;

  final String? currencyCode;
  final int? impressions;
  final int? reach;
  final int? videoPlay25Pct;
  final int? videoPlay100Pct;
  final int? clicks;
  final int? conversions;
  final int? statusCode;
}

class TiktokAdsCallResult<T> {
  const TiktokAdsCallResult({required this.value, this.result});
  final T value;
  final TiktokAdsResult? result;
}

/// Wraps a TikTok Ads API call in a CLIENT span. [operation] is one of
/// `campaign.create`, `adgroup.create`, `ad.create`, `report.get`,
/// `audience.create`, `pixel.event`, `bc.list`.
Future<T> tracedTiktokAds<T>({
  required String operation,
  required Future<TiktokAdsCallResult<T>> Function() invoke,
}) async {
  if (tiktokAdsInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final m = <String, Object>{
    'rpc.system': 'tiktok_ads',
    'rpc.method': operation,
    'tiktok_ads.operation': operation,
  };

  final span = _tracer().startSpan(
    'tiktok_ads $operation',
    kind: SpanKind.client,
    attributes: OTel.attributesFromMap(m),
  );
  try {
    final r = await invoke();
    if (r.result != null) {
      final extras = <Attribute<Object>>[];
      if (r.result!.advertiserId != null) {
        extras.add(OTel.attributeString(
          'tiktok_ads.advertiser.id',
          r.result!.advertiserId!,
        ));
      }
      if (r.result!.bcId != null) {
        extras.add(OTel.attributeString('tiktok_ads.bc.id', r.result!.bcId!));
      }
      if (r.result!.campaignId != null) {
        extras.add(OTel.attributeString(
          'tiktok_ads.campaign.id',
          r.result!.campaignId!,
        ));
      }
      if (r.result!.adGroupId != null) {
        extras.add(OTel.attributeString(
          'tiktok_ads.ad_group.id',
          r.result!.adGroupId!,
        ));
      }
      if (r.result!.adId != null) {
        extras.add(OTel.attributeString(
          'tiktok_ads.ad.id',
          r.result!.adId!,
        ));
      }
      if (r.result!.objectiveType != null) {
        extras.add(OTel.attributeString(
          'tiktok_ads.objective.type',
          r.result!.objectiveType!,
        ));
      }
      if (r.result!.optimizationGoal != null) {
        extras.add(OTel.attributeString(
          'tiktok_ads.optimization.goal',
          r.result!.optimizationGoal!,
        ));
      }
      if (r.result!.billingEvent != null) {
        extras.add(OTel.attributeString(
          'tiktok_ads.billing.event',
          r.result!.billingEvent!,
        ));
      }
      if (r.result!.placementType != null) {
        extras.add(OTel.attributeString(
          'tiktok_ads.placement.type',
          r.result!.placementType!,
        ));
      }
      if (r.result!.operationStatus != null) {
        extras.add(OTel.attributeString(
          'tiktok_ads.operation.status',
          r.result!.operationStatus!,
        ));
      }
      if (r.result!.sparkAds != null) {
        extras.add(OTel.attributeBool(
          'tiktok_ads.spark_ads',
          r.result!.sparkAds!,
        ));
      }
      if (r.result!.spendMinor != null) {
        extras.add(OTel.attributeInt(
          'tiktok_ads.spend.minor',
          r.result!.spendMinor!,
        ));
      }
      if (r.result!.currencyCode != null) {
        extras.add(OTel.attributeString(
          'tiktok_ads.currency.code',
          r.result!.currencyCode!,
        ));
      }
      if (r.result!.impressions != null) {
        extras.add(OTel.attributeInt(
          'tiktok_ads.impressions',
          r.result!.impressions!,
        ));
      }
      if (r.result!.reach != null) {
        extras.add(OTel.attributeInt(
          'tiktok_ads.reach',
          r.result!.reach!,
        ));
      }
      if (r.result!.videoPlay25Pct != null) {
        extras.add(OTel.attributeInt(
          'tiktok_ads.video_play_25pct',
          r.result!.videoPlay25Pct!,
        ));
      }
      if (r.result!.videoPlay100Pct != null) {
        extras.add(OTel.attributeInt(
          'tiktok_ads.video_play_100pct',
          r.result!.videoPlay100Pct!,
        ));
      }
      if (r.result!.clicks != null) {
        extras.add(OTel.attributeInt(
          'tiktok_ads.clicks',
          r.result!.clicks!,
        ));
      }
      if (r.result!.conversions != null) {
        extras.add(OTel.attributeInt(
          'tiktok_ads.conversions',
          r.result!.conversions!,
        ));
      }
      if (r.result!.statusCode != null) {
        extras.add(OTel.attributeInt(
          'http.response.status_code',
          r.result!.statusCode!,
        ));
        if (r.result!.statusCode! >= 400) {
          span.setStatus(
            SpanStatusCode.Error,
            'TikTok Ads HTTP ${r.result!.statusCode}',
          );
        }
      }
      if (extras.isNotEmpty) span.addAttributes(OTel.attributes(extras));
    }
    return r.value;
  } catch (e, st) {
    span.addAttributes(OTel.attributes([
      OTel.attributeString(
        ErrorResource.errorType.key,
        e.runtimeType.toString(),
      ),
    ]));
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
