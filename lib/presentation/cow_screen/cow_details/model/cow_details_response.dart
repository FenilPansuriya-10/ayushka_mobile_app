
import 'dart:convert';

CowDetailsResponse cowDetailsResponseFromJson(dynamic str) {
  if (str is Map<String, dynamic>) {
    return CowDetailsResponse.fromJson(str);
  }
  if (str is String) {
    return CowDetailsResponse.fromJson(json.decode(str));
  }
  return CowDetailsResponse.fromJson(json.decode(str.toString()));
}

String cowDetailsResponseToJson(CowDetailsResponse data) => json.encode(data.toJson());

class CowDetailsResponse {
  final String status;
  final String message;
  final CowDetails? cowDetails;

  CowDetailsResponse({
    required this.status,
    required this.message,
    this.cowDetails,
  });

  factory CowDetailsResponse.fromJson(Map<String, dynamic> json) => CowDetailsResponse(
    status: json["status"] ?? '',
    message: json["message"] ?? '',
    cowDetails: json["data"] != null ? CowDetails.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "CowDetails": cowDetails?.toJson(),
  };
}

class CowDetails {
  final FoundCow? foundCow;
  final String latestCalfdob;

  CowDetails({
    this.foundCow,
    required this.latestCalfdob,
  });

  factory CowDetails.fromJson(Map<String, dynamic> json) => CowDetails(
    foundCow: json["foundCOW"] != null ? FoundCow.fromJson(json["foundCOW"]) : null,
    latestCalfdob: json["latestCalfdob"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "foundCOW": foundCow?.toJson(),
    "latestCalfdob": latestCalfdob,
  };
}

class FoundCow {
  final String breed;
  final String type;
  final String shedId;
  final String tagId;
  final String dob;
  final String calfName;
  final bool isFemale;
  final String addedBy;
  final int calfWeight;
  final String damId;
  final String damName;
  final String sairId;
  final String sairName;
  final String deliveryTime;
  final String sendDiedDate;
  final String purchaseDate;
  final String remark;
  final String createdAt;
  final String updatedAt;
  final bool isDeleted;
  final String id;

  FoundCow({
    required this.breed,
    required this.type,
    required this.shedId,
    required this.tagId,
    required this.dob,
    required this.calfName,
    required this.isFemale,
    required this.addedBy,
    required this.calfWeight,
    required this.damId,
    required this.damName,
    required this.sairId,
    required this.sairName,
    required this.deliveryTime,
    required this.sendDiedDate,
    required this.purchaseDate,
    required this.remark,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.id,
  });

  factory FoundCow.fromJson(Map<String, dynamic> json) => FoundCow(
    breed: json["breed"] ?? '',
    type: json["type"] ?? '',
    shedId: json["shed_id"] ?? '',
    tagId: json["tag_id"]?.toString() ?? '',
    dob: json["dob"] ?? '',
    calfName: json["calf_name"] ?? '',
    isFemale: json["isFemale"] ?? false,
    addedBy: json["addedBy"] ?? '',
    calfWeight: json["calf_weight"] is int
        ? json["calf_weight"]
        : int.tryParse(json["calf_weight"]?.toString() ?? '0') ?? 0,
    damId: json["dam_id"] ?? '',
    damName: json["dam_name"] ?? '',
    sairId: json["sair_id"] ?? '',
    sairName: json["sair_name"] ?? '',
    deliveryTime: json["delivery_time"] ?? '',
    sendDiedDate: json["send_died_date"] ?? '',
    purchaseDate: json["purchase_date"] ?? '',
    remark: json["remark"] ?? '',
    createdAt: json["createdAt"] ?? '',
    updatedAt: json["updatedAt"] ?? '',
    isDeleted: json["isDeleted"] ?? false,
    id: json["id"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "breed": breed,
    "type": type,
    "shed_id": shedId,
    "tag_id": tagId,
    "dob": dob,
    "calf_name": calfName,
    "isFemale": isFemale,
    "addedBy": addedBy,
    "calf_weight": calfWeight,
    "dam_id": damId,
    "dam_name": damName,
    "sair_id": sairId,
    "sair_name": sairName,
    "delivery_time": deliveryTime,
    "send_died_date": sendDiedDate,
    "purchase_date": purchaseDate,
    "remark": remark,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "isDeleted": isDeleted,
    "id": id,
  };
}
