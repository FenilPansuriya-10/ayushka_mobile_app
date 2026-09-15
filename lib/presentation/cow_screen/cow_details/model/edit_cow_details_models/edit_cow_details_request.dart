import 'dart:convert';

EditCowDetailsRequest editCowDetailsRequestFromJson(String str) => EditCowDetailsRequest.fromJson(json.decode(str));

String editCowDetailsRequestToJson(EditCowDetailsRequest data) => json.encode(data.toJson());

class EditCowDetailsRequest {
  final String breed;
  final String tagId;
  final String dob;
  final String calfName;
  final bool isFemale;
  final String damId;
  final String damName;
  final String sairName;
  final String sairID;
  final String deliveryTime;
  final String purchaseDate;
  final String sendDiedDate;
  final String type;
  final String remark;
  final String shedId;
  final double calfWeight;

  EditCowDetailsRequest({
    required this.breed,
    required this.tagId,
    required this.dob,
    required this.calfName,
    required this.isFemale,
    required this.damId,
    required this.damName,
    required this.sairName,
    required this.deliveryTime,
    required this.purchaseDate,
    required this.sendDiedDate,
    required this.type,
    required this.remark,
    required this.sairID,
    required this.shedId,
    required this.calfWeight,
  });

  factory EditCowDetailsRequest.fromJson(Map<String, dynamic> json) => EditCowDetailsRequest(
    breed: json["breed"] ?? "",
    tagId: json["tag_id"] ?? "",
    dob: json["dob"] ?? "",
    calfName: json["calf_name"] ?? "",
    isFemale: json["isFemale"] ?? false,
    damId: json["dam_id"] ?? "",
    damName: json["dam_name"] ?? "",
    type: json["type"] ?? "",
    sairName: json["sair_name"] ?? "",
    deliveryTime: json["delivery_time"] ?? "",
    purchaseDate: json["purchase_date"] ?? "",
    sendDiedDate: json["send_died_date"] ?? "",
    remark: json["remark"] ?? "",
    sairID: json["sair_id"] ?? "",
    shedId: json["shed_id"] ?? "",
    calfWeight: (json["calf_weight"] is num)
        ? (json["calf_weight"] as num).toDouble()
        : double.tryParse(json["calf_weight"]?.toString() ?? "0") ?? 0.0,
  );

  Map<String, dynamic> toJson() => {
    "breed": breed,
    "tag_id": tagId,
    "dob": dob,
    "calf_name": calfName,
    "type": type,
    "isFemale": isFemale,
    "dam_id": damId,
    "dam_name": damName,
    "sair_name": sairName,
    "delivery_time": deliveryTime,
    "purchase_date": purchaseDate,
    "send_died_date": sendDiedDate,
    "remark": remark,
    "sair_id": sairID,
    "shed_id": shedId,
    "calf_weight": calfWeight,
  };
}
