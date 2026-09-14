import 'dart:convert';

MedicineHistoryByCowIdResponse medicineHistoryByCowIdResponseFromJson(String str) => MedicineHistoryByCowIdResponse.fromJson(json.decode(str));

String medicineHistoryByCowIdResponseToJson(MedicineHistoryByCowIdResponse data) => json.encode(data.toJson());

class MedicineHistoryByCowIdResponse {
  final String status;
  final String message;
  final List<MedicineHistoryDatum> medicineHistoryData;

  MedicineHistoryByCowIdResponse({required this.status, required this.message, required this.medicineHistoryData});

  factory MedicineHistoryByCowIdResponse.fromJson(Map<String, dynamic> json) {
    return MedicineHistoryByCowIdResponse(
      status: json["status"] ?? "",
      message: json["message"] ?? "",
      medicineHistoryData: json["data"] != null ? List<MedicineHistoryDatum>.from(json["data"].map((x) => MedicineHistoryDatum.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() => {"status": status, "message": message, "data": List<dynamic>.from(medicineHistoryData.map((x) => x.toJson()))};
}

class MedicineHistoryDatum {
  final int id;
  final String gaushalaId;
  final String cowId;
  final String vacName;
  final int dose;
  final String nextDoseTime;
  final String date;
  final String remark;
  final int gapInDay;
  final String status;
  final String addedBy;
  final String type;
  final String toDate;
  final int heatAttempt;
  final String items;
  final String lastLogRemark;

  MedicineHistoryDatum({
    required this.id,
    required this.gaushalaId,
    required this.cowId,
    required this.vacName,
    required this.dose,
    required this.nextDoseTime,
    required this.date,
    required this.remark,
    required this.gapInDay,
    required this.status,
    required this.addedBy,
    required this.type,
    required this.toDate,
    required this.heatAttempt,
    required this.items,
    required this.lastLogRemark,
  });

  factory MedicineHistoryDatum.fromJson(Map<String, dynamic> json) => MedicineHistoryDatum(
    id: json["_id"] ?? 0,
    gaushalaId: json["gaushala_id"] ?? "",
    cowId: json["cowId"] ?? "",
    vacName: json["vac_name"] ?? "",
    dose: json["dose"] ?? 0,
    nextDoseTime: json["next_dose_time"] ?? "",
    date: json["date"] ?? "",
    remark: json["remark"] ?? "",
    gapInDay: json["gap_in_day"] ?? 0,
    status: json["status"] ?? "",
    addedBy: json["added_by"] ?? "",
    type: json["type"] ?? "",
    toDate: json["to_date"] ?? "",
    heatAttempt: json["heat_attempt"] ?? 0,
    items: json["items"] ?? "",
    lastLogRemark: json["last_log_remark"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "gaushala_id": gaushalaId,
    "cowId": cowId,
    "vac_name": vacName,
    "dose": dose,
    "next_dose_time": nextDoseTime,
    "date": date,
    "remark": remark,
    "gap_in_day": gapInDay,
    "status": status,
    "added_by": addedBy,
    "type": type,
    "to_date": toDate,
    "heat_attempt": heatAttempt,
    "items": items,
    "last_log_remark": lastLogRemark,
  };
}
