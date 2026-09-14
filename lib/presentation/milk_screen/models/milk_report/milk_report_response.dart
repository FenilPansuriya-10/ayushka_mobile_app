import 'dart:convert';

MilkReportResponse milkReportResponseFromJson(String str) => MilkReportResponse.fromJson(json.decode(str));

String milkReportResponseToJson(MilkReportResponse data) => json.encode(data.toJson());

class MilkReportResponse {
  final String status;
  final String message;
  final MilkReportData? milkReportData;

  MilkReportResponse({required this.status, required this.message, required this.milkReportData});

  factory MilkReportResponse.fromJson(Map<String, dynamic> json) => MilkReportResponse(
    status: json["status"] ?? "",
    message: json["message"] ?? "",
    milkReportData: json["data"] != null ? MilkReportData.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() => {"status": status, "message": message, "data": milkReportData?.toJson()};
}

class MilkReportData {
  final List<MilkDatum> milkData;
  final List<SummaryDatum> summaryData;
  final List<PendingCow> pendingCows;

  MilkReportData({required this.milkData, required this.summaryData, required this.pendingCows});

  factory MilkReportData.fromJson(Map<String, dynamic> json) => MilkReportData(
    milkData: json["milk"] != null ? List<MilkDatum>.from(json["milk"].map((x) => MilkDatum.fromJson(x))) : [],
    summaryData: json["summary"] != null ? List<SummaryDatum>.from(json["summary"].map((x) => SummaryDatum.fromJson(x))) : [],
    pendingCows: json["pendingCows"] != null ? List<PendingCow>.from(json["pendingCows"].map((x) => PendingCow.fromJson(x))) : [],
  );

  Map<String, dynamic> toJson() => {
    "milk": List<dynamic>.from(milkData.map((x) => x.toJson())),
    "summary": List<dynamic>.from(summaryData.map((x) => x.toJson())),
    "pendingCows": List<dynamic>.from(pendingCows.map((x) => x.toJson())),
  };
}

class MilkDatum {
  final num morning;
  final String? morningEmployee;
  final num evening;
  final String? eveningEmployee;
  final String cowTagId;
  final String shedId;
  final String date;
  final num total;

  MilkDatum({
    required this.morning,
    this.morningEmployee,
    required this.evening,
    this.eveningEmployee,
    required this.cowTagId,
    required this.shedId,
    required this.date,
    required this.total,
  });

  factory MilkDatum.fromJson(Map<String, dynamic> json) => MilkDatum(
    morning: json["morning"] != null ? (json["morning"] is Map ? (json["morning"]["milk"] ?? 0) : json["morning"]) : 0,
    morningEmployee: json["morning"] != null && json["morning"] is Map ? json["morning"]["employee_name"] : null,
    evening: json["evening"] != null ? (json["evening"] is Map ? (json["evening"]["milk"] ?? 0) : json["evening"]) : 0,
    eveningEmployee: json["evening"] != null && json["evening"] is Map ? json["evening"]["employee_name"] : null,
    cowTagId: json["cow_tag_id"] ?? "",
    shedId: json["shed_id"] ?? json["cow_tag_id"] ?? "",
    date: json["date"] ?? "",
    total: json["total"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "morning": {"milk": morning, "employee_name": morningEmployee},
    "evening": {"milk": evening, "employee_name": eveningEmployee},
    "cow_tag_id": cowTagId,
    "shed_id": shedId,
    "date": date,
    "total": total,
  };
}

class PendingCow {
  final String date;
  final List<PendingCowId> morning;
  final List<PendingCowId> evening;

  PendingCow({required this.date, required this.morning, required this.evening});

  factory PendingCow.fromJson(Map<String, dynamic> json) => PendingCow(
    date: json["date"] ?? "",
    morning: json["morning"] != null ? List<PendingCowId>.from(json["morning"].map((x) => PendingCowId.fromJson(x))) : [],
    evening: json["evening"] != null ? List<PendingCowId>.from(json["evening"].map((x) => PendingCowId.fromJson(x))) : [],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "morning": List<dynamic>.from(morning.map((x) => x.toJson())),
    "evening": List<dynamic>.from(evening.map((x) => x.toJson())),
  };
}

class PendingCowId {
  final String tagId;
  final String shedId;

  PendingCowId({required this.tagId, required this.shedId});

  factory PendingCowId.fromJson(Map<String, dynamic> json) => PendingCowId(tagId: json["tagId"] ?? "", shedId: json["shedId"] ?? "");

  Map<String, dynamic> toJson() => {"tagId": tagId, "shedId": shedId};
}

class SummaryDatum {
  final num cowsCount;
  final num milkCount;
  final String breed;

  SummaryDatum({required this.cowsCount, required this.milkCount, required this.breed});

  factory SummaryDatum.fromJson(Map<String, dynamic> json) =>
      SummaryDatum(cowsCount: json["cows_count"] ?? 0, milkCount: json["milk_count"] ?? 0, breed: json["breed"] ?? "");

  Map<String, dynamic> toJson() => {"cows_count": cowsCount, "milk_count": milkCount, "breed": breed};
}
