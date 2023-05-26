class PushNotificationResponse {
  final int? multicastId;
  final int? success;
  final int? failure;
  final int? canonicalIds;
  final List<PushNotificationResult>? results;

  PushNotificationResponse({
    this.multicastId,
    this.success,
    this.failure,
    this.canonicalIds,
    this.results,
  });

  factory PushNotificationResponse.fromJson(Map<String, dynamic> json) {
    return PushNotificationResponse(
      multicastId: json['multicast_id'] as int,
      success: json['success'] as int,
      failure: json['failure'] as int,
      canonicalIds: json['canonical_ids'] as int,
      results: (json['results'] as List<dynamic>)
          .map((result) =>
              PushNotificationResult.fromJson(result as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PushNotificationResult {
  final String? messageId;
  final String? error;

  PushNotificationResult({this.messageId, this.error});

  factory PushNotificationResult.fromJson(Map<String, dynamic> json) =>
      PushNotificationResult(
        messageId: json['message_id'] as String?,
        error: json['error'] as String?,
      );
}
