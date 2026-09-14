import 'dart:convert';

import 'package:cattle_app/presentation/common%20file/defaultVariablesList.dart';
import 'package:cattle_app/presentation/cow_screen/cow_controller.dart';
import 'package:cattle_app/presentation/cow_screen/cow_details/model/Milk_Information/Milk_Information_Request.dart';
import 'package:cattle_app/presentation/cow_screen/cow_details/model/Milk_Information/Milk_Information_Respons.dart';
import 'package:cattle_app/presentation/cow_screen/cow_details/model/cow_details_request.dart';
import 'package:cattle_app/presentation/cow_screen/cow_details/model/cow_details_response.dart';
import 'package:cattle_app/presentation/cow_screen/cow_details/model/edit_Cow_Details_models/edit_cow_details_request.dart';
import 'package:cattle_app/presentation/cow_screen/cow_details/model/edit_cow_details_models/edit_cow_details_response.dart';
import 'package:cattle_app/presentation/milk_screen/controller/milk_controller.dart';
import 'package:cattle_app/widgets/toast_message/toast_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, Node;
import 'package:graphview/GraphView.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/pref_utils.dart';
import '../../../data/apiClient/api_client.dart';
import '../../../data/apiClient/api_methods.dart';
import '../../medical_report_screen/models/medicine_History_ByCowID_Request.dart';
import '../../medical_report_screen/models/medicine_History_ByCowID_Response.dart';
import 'model/cow_family_hierarchy_model/children_hierarchy_response.dart';
import 'model/cow_family_hierarchy_model/cow_Hierarchy_request.dart';
import 'model/cow_family_hierarchy_model/cow_Hierarchy_response.dart';
import 'model/cow_family_hierarchy_model/graph_model.dart';

enum DataStatus { loading, done, error }

enum CowHierarchyDataStatus { loading, done, error }

enum MilkInfoStatus { loading, done, error }

class CowsDetailScreenController extends GetxController {
  Map<String, dynamic> argument = Get.arguments;

  Rx<DataStatus> dataStatus = DataStatus.loading.obs;
  RxList<MedicineHistoryDatum> MedicineData = <MedicineHistoryDatum>[].obs;
  RxString dobText = ''.obs;
  RxString purchaseDateText = ''.obs;
  Rx<CowHierarchyDataStatus> cowHierarchyStatus = CowHierarchyDataStatus.loading.obs;
  Rx<CowHierarchyDataStatus> childrenHierarchyStatus = CowHierarchyDataStatus.loading.obs;
  Rx<MilkInfoStatus> milkInfoStatus = MilkInfoStatus.loading.obs;
  late CowHierarchyResponse? cowHierarchyResponse;
  late ChildrenHierarchyResponse? childrenHierarchyResponse;
  RxList<NodeModel> nodes = <NodeModel>[].obs;
  RxList<EdgeModel> edgesList = <EdgeModel>[].obs;
  Rx<Graph> graph = Graph().obs;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  RxList<NodeModel> childrenNodes = <NodeModel>[].obs;
  RxList<EdgeModel> childrenEdgesList = <EdgeModel>[].obs;
  Rx<Graph> childrenGraph = Graph().obs;
  BuchheimWalkerConfiguration childrenBuilder = BuchheimWalkerConfiguration();

  int index = 0;

  FoundCow? foundCow;

  RxDouble totalMilk = 0.0.obs;
  RxDouble lastYearTotalMilk = 0.0.obs;
  RxDouble currentYearTotalMilk = 0.0.obs;

  MilkController milkController = Get.put(MilkController());

  @override
  void onInit() {
    () async {
      retrieveCowData();
      await cowsDetail(id: argument['tagId'].toString());
      await milkInfoDetail(id: argument['tagId'].toString());
      await medicineData(id: argument['tagId'].toString());
      await cowHierarchyApi(cowId: argument['tagId'].toString());
    }();
    super.onInit();
  }

  Map<String, dynamic> args = Get.arguments;
  Map<String, dynamic>? retrievedData = PrefUtils.getData;

  TextEditingController breedController = TextEditingController();
  TextEditingController calfIDController = TextEditingController();
  TextEditingController calfNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController sairIdController = TextEditingController();
  TextEditingController cowTypeController = TextEditingController();
  TextEditingController damIdController = TextEditingController();
  TextEditingController newShedIdController = TextEditingController();
  TextEditingController cowWeightController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController purchaseDateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController ShedIdController = TextEditingController();
  TextEditingController RemarkController = TextEditingController();
  TextEditingController CowTypeController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController sendDiedDateController = TextEditingController();

  GlobalKey<FormState> breedKey = GlobalKey<FormState>();
  GlobalKey<FormState> calfIDKey = GlobalKey<FormState>();
  GlobalKey<FormState> calfNameKey = GlobalKey<FormState>();
  GlobalKey<FormState> genderKey = GlobalKey<FormState>();
  GlobalKey<FormState> sairIdKey = GlobalKey<FormState>();
  GlobalKey<FormState> cowTypeKey = GlobalKey<FormState>();
  GlobalKey<FormState> damIdKey = GlobalKey<FormState>();
  GlobalKey<FormState> newShedIdKey = GlobalKey<FormState>();
  GlobalKey<FormState> cowWeightKey = GlobalKey<FormState>();
  GlobalKey<FormState> CowTypeKey = GlobalKey<FormState>();
  GlobalKey<FormState> ShedIdKey = GlobalKey<FormState>();
  GlobalKey<FormState> RemarkKey = GlobalKey<FormState>();

  RxList<String> Gender = ['Female', 'Male'].obs;

  int calculateAgeFromString(String birthdateString) {
    DateTime birthdate = DateTime.parse(birthdateString);

    final now = DateTime.now();
    int age = now.year - birthdate.year;

    if (now.month < birthdate.month || (now.month == birthdate.month && now.day < birthdate.day)) {
      age--;
    }

    return age;
  }

  String convertDateFormat({required String date}) {
    DateTime inputDate = DateFormat("dd-MM-yyyy").parse(date);

    String formattedDate = DateFormat("yyyy-MM-dd").format(inputDate);

    return formattedDate;
  }

  String CowDOBDateFormat({required String date}) {
    DateTime inputDate = DateFormat("yyyy-MM-dd").parse(date);

    String formattedDate = DateFormat("dd-MM-yyyy").format(inputDate);

    return formattedDate;
  }

  Future<void> medicineData({required String id}) async {
    final Response response = await WebService.cmPostWithTokenRequest(
      url: ApiClient.medicineByCowId,
      body: medicineHistoryByCowIdRequestToJson(MedicineHistoryByCowIdRequest(cowId: id)),
      token: PrefUtils.getToken.toString(),
    );
    try {
      if (response.statusCode == 200) {
        MedicineHistoryByCowIdResponse medicineHistoryByCowIdResponse = medicineHistoryByCowIdResponseFromJson(response.data);
        MedicineData.value = medicineHistoryByCowIdResponse.medicineHistoryData;
      } else {
        print(response.statusCode);
        CattleToast.msg(response.statusMessage!);
      }
    } catch (error) {
      print(error);
      CattleToast.msg(error.toString());
    }
  }

  Future<void> cowsDetail({required String id}) async {
    try {
      final Response response = await WebService.cmPostWithTokenRequest(
        url: ApiClient.cowDetail,
        body: cowDetailsRequestToJson(CowDetailsRequest(tagId: id)),
        token: PrefUtils.getToken.toString(),
      );
      if (response.statusCode == 200) {
        CowDetailsResponse cowDetailsResponse = await cowDetailsResponseFromJson(response.data);
        foundCow = cowDetailsResponse.cowDetails.foundCow;
        breedController = TextEditingController(text: foundCow!.breed);
        genderController = TextEditingController(text: foundCow!.isFemale == true ? "Female" : "Male");
        calfIDController = TextEditingController(text: foundCow!.tagId);
        calfNameController = TextEditingController(text: foundCow!.calfName);
        dobController = TextEditingController(text: CowDOBDateFormat(date: foundCow!.dob));
        dobText.value = dobController.text;
        purchaseDateController = TextEditingController(text: foundCow!.purchaseDate);
        purchaseDateText.value = purchaseDateController.text;
        sendDiedDateController = TextEditingController(text: foundCow!.sendDiedDate);
        timeController = TextEditingController(text: foundCow!.deliveryTime);
        cowTypeController = TextEditingController(text: foundCow!.type);
        damIdController = TextEditingController(text: "${foundCow!.damId} - ${foundCow!.damName}");
        sairIdController = TextEditingController(text: "${foundCow!.sairId} - ${foundCow!.sairName}");
        newShedIdController = TextEditingController(text: foundCow!.shedId);
        cowWeightController = TextEditingController(text: "${foundCow!.calfWeight}");
        remarkController = TextEditingController(text: foundCow!.remark);
        idController = TextEditingController(text: foundCow!.id);
        _changeStatus(DataStatus.done);
        childrenHierarchyApi(cowId: id);
        CattleToast.msg(cowDetailsResponse.message);
        print(response.statusCode);
      } else {
        print("*******************statusCode***********************");
        print(response.statusCode);
        CattleToast.msg(response.statusMessage!);
        print("*******************statusCode***********************");
        _changeStatus(DataStatus.error);
      }
    } catch (error) {
      print("******************Catch**ERROR**********************");
      print(error.toString());
      CattleToast.msg(error.toString());
      print("********************ERROR**********************");
      _changeStatus(DataStatus.error);
    }
    return;
  }

  String findValueById(String id) {
    for (var item in bull) {
      if (item.id == id) {
        return item.value;
      }
    }
    return 'Not Found';
  }

  String extractId(String input) {
    List<String> parts = input.split(" - ");
    String id = parts[0];
    return id;
  }

  String extractName(String input) {
    List<String> parts = input.split(" - ");
    String id = parts[1];
    return id;
  }

  Future<void> editCowsDetail() async {
    try {
      final Response response = await WebService.cmPostWithTokenRequest(
        url: "${ApiClient.editCowDetail}/${idController.text}",
        body: editCowDetailsRequestToJson(
          EditCowDetailsRequest(
            breed: breedController.text,
            tagId: calfIDController.text,
            dob: convertDateFormat(date: dobController.text),
            calfName: calfNameController.text,
            isFemale: genderController.text == "Female" ? true : false,
            damId: extractId(damIdController.text),
            damName: extractName(damIdController.text),
            sairName: findValueById(extractId(sairIdController.text)),
            deliveryTime: timeController.text,
            purchaseDate: purchaseDateController.text,
            remark: remarkController.text,
            sairID: extractId(sairIdController.text),
            type: cowTypeController.text,
            sendDiedDate: sendDiedDateController.text,
          ),
        ),
        token: PrefUtils.getToken.toString(),
      );
      if (response.statusCode == 200) {
        EditCowDetailsResponse editCowDetailsResponse = await editCowDetailsResponseFromJson(response.data);
        await milkController.cmCowList();
        if (Get.isRegistered<CowsScreenController>()) {
          Get.find<CowsScreenController>().getData();
        }
        Get.back();
        Get.back();
        CattleToast.msg(editCowDetailsResponse.message);
        print(response.statusCode);
      } else {
        debugPrint("*******************statusCode***********************");
        debugPrint(response.statusCode.toString());
        CattleToast.msg(response.statusMessage!);
        debugPrint("*******************statusCode***********************");
      }
    } catch (error) {
      debugPrint("******************Catch**ERROR**********************");
      print(error.toString());
      CattleToast.msg(error.toString());
      debugPrint("********************ERROR**********************");
    }
    return;
  }

  Future<void> milkInfoDetail({required String id}) async {
    changeMilkInfoStatus(MilkInfoStatus.loading);
    try {
      final Response response = await WebService.cmPostWithTokenRequest(
        url: ApiClient.milkInfo,
        body: milkInformationRequestToJson(MilkInformationRequest(tagId: id)),
        token: PrefUtils.getToken.toString(),
      );
      if (response.statusCode == 200) {
        MilkInformationRespons milkInformationRespons = await milkInformationResponsFromJson(response.data);
        totalMilk.value = milkInformationRespons.milkInfoData.totalMilk.toDouble();
        lastYearTotalMilk.value = milkInformationRespons.milkInfoData.lastYearTotalMilk.toDouble();
        currentYearTotalMilk.value = milkInformationRespons.milkInfoData.currentYearTotalMilk.toDouble();
        changeMilkInfoStatus(MilkInfoStatus.done);

        print(response.statusCode);
      } else {
        print("*******************statusCode***********************");
        print(response.statusCode);
        CattleToast.msg(response.statusMessage!);

        print("*******************statusCode***********************");
        changeMilkInfoStatus(MilkInfoStatus.error);
      }
    } catch (error) {
      print("******************Catch**ERROR**********************");
      print(error.toString());
      CattleToast.msg(error.toString());
      print("********************ERROR**********************");
      changeMilkInfoStatus(MilkInfoStatus.error);
    }
    return;
  }

  Future<void> cowHierarchyApi({required String cowId}) async {
    changeStatus(CowHierarchyDataStatus.loading);
    nodes.clear();
    edgesList.clear();
    graph.value = Graph();

    final response = await WebService.cmPostWithTokenRequest(
      url: ApiClient.cowHierarchy,
      body: cowHierarchyRequestToJson(CowHierarchyRequest(tagId: cowId)),
      token: PrefUtils.getToken.toString(),
    );

    try {
      if (response.statusCode == 200) {
        cowHierarchyResponse = await cowHierarchyFromJson(response.data);
        print(jsonDecode(response.data));
        if (cowHierarchyResponse!.status == "SUCCESS") {
          await addCowIdGraph();
          await chatDataAdd();
          changeStatus(CowHierarchyDataStatus.done);
          print("done");
        } else {
          changeStatus(CowHierarchyDataStatus.error);
          print("error1");
        }
      } else {
        changeStatus(CowHierarchyDataStatus.error);
        print("error2");
      }
    } catch (error) {
      changeStatus(CowHierarchyDataStatus.error);
      print("error3");
      print(error);
    }
  }

  addCowIdGraph() {
    if (cowHierarchyResponse != null) {
      nodes.add(
        NodeModel(
          id: cowHierarchyResponse!.cowData.cowId,
          label: cowHierarchyResponse!.cowData.calfName,
          gender: cowHierarchyResponse!.cowData.gender,
          type: cowHierarchyResponse!.cowData.type,
          breed: cowHierarchyResponse!.cowData.breed,
        ),
      );
      addParentsToGraph(cowHierarchyResponse!.cowData.parentsList, cowHierarchyResponse!.cowData.cowId);
    }
  }

  void addParentsToGraph(List<CowData> parents, String parentNode) {
    for (var parent in parents) {
      String parentCowNode = parent.cowId;
      nodes.add(NodeModel(id: parentCowNode, label: parent.calfName, gender: parent.gender, type: parent.type, breed: parent.breed));
      edgesList.add(EdgeModel(from: parentNode, to: parentCowNode));
      if (parent.parentsList.isNotEmpty) {
        addParentsToGraph(parent.parentsList, parentCowNode);
      }
    }
  }

  chatDataAdd() {
    print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    print(jsonEncode(nodes));
    print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    print(jsonEncode(edgesList));
    var edges = edgesList;
    edges.forEach((element) {
      var fromNodeId = element.from;
      var toNodeId = element.to;
      graph.value.addEdge(Node.Id(fromNodeId), Node.Id(toNodeId));
    });

    builder
      ..siblingSeparation = (100)
      ..levelSeparation = (150)
      ..subtreeSeparation = (150)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_BOTTOM_TOP);
  }

  Future<void> childrenHierarchyApi({required String cowId}) async {
    changeChildrenStatus(CowHierarchyDataStatus.loading);
    childrenNodes.clear();
    childrenEdgesList.clear();
    childrenGraph.value = Graph();

    final response = await WebService.cmPostWithTokenRequest(
      url: ApiClient.getChildrenDetails,
      body: cowHierarchyRequestToJson(CowHierarchyRequest(tagId: cowId)),
      token: PrefUtils.getToken.toString(),
    );

    try {
      if (response.statusCode == 200) {
        childrenHierarchyResponse = await childrenHierarchyFromJson(response.data);
        if (childrenHierarchyResponse!.status == "SUCCESS") {
          await addChildrenGraph();
          await childrenChatDataAdd();
          changeChildrenStatus(CowHierarchyDataStatus.done);
        } else {
          changeChildrenStatus(CowHierarchyDataStatus.error);
        }
      } else {
        changeChildrenStatus(CowHierarchyDataStatus.error);
      }
    } catch (error) {
      changeChildrenStatus(CowHierarchyDataStatus.error);
      print(error);
    }
  }

  addChildrenGraph() {
    if (childrenHierarchyResponse != null && childrenHierarchyResponse!.childrenData.isNotEmpty) {
      childrenNodes.add(
        NodeModel(
          id: foundCow!.tagId,
          label: foundCow!.calfName,
          gender: foundCow!.isFemale == true ? "Female" : "Male",
          type: foundCow!.type,
          breed: foundCow!.breed,
        ),
      );
      addChildrenToGraph(childrenHierarchyResponse!.childrenData, foundCow!.tagId);
    }
  }

  void addChildrenToGraph(List<CowData> children, String parentNode) {
    for (var child in children) {
      String childNodeId = child.cowId.toString();
      childrenNodes.add(NodeModel(id: childNodeId, label: child.calfName, gender: child.gender, type: child.type, breed: child.breed));
      childrenEdgesList.add(EdgeModel(from: parentNode, to: childNodeId));
      // We do NOT recurse into child.parentsList because those are the parents
      // of the child (which includes the current parentNode), creating a cycle!
    }
  }

  childrenChatDataAdd() {
    var edges = childrenEdgesList;
    edges.forEach((element) {
      var fromNodeId = element.from;
      var toNodeId = element.to;
      childrenGraph.value.addEdge(Node.Id(fromNodeId), Node.Id(toNodeId));
    });

    childrenBuilder
      ..siblingSeparation = (100)
      ..levelSeparation = (150)
      ..subtreeSeparation = (150)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
  }

  changeStatus(CowHierarchyDataStatus value) => cowHierarchyStatus(value);
  changeChildrenStatus(CowHierarchyDataStatus value) => childrenHierarchyStatus(value);

  changeMilkInfoStatus(MilkInfoStatus value) => milkInfoStatus(value);

  _changeStatus(DataStatus value) => dataStatus(value);
}
