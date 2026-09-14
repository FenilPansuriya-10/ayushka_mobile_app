import 'package:cattle_app/presentation/add_milk_screen/models/add_Bulk_Milk_Request.dart';
import 'package:cattle_app/presentation/add_milk_screen/models/add_Bulk_Milk_Response.dart';
import 'package:cattle_app/presentation/add_milk_screen/models/addmilk_request.dart';
import 'package:cattle_app/presentation/add_milk_screen/models/validate_Milk_Request.dart';
import 'package:cattle_app/presentation/add_milk_screen/models/validate_Milk_Response.dart';
import 'package:cattle_app/widgets/toast_message/toast_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';

import '../../../core/utils/pref_utils.dart';
import '../../../data/apiClient/api_client.dart';
import '../../../data/apiClient/api_methods.dart';
import '../../../widgets/loder.dart';
import '../../milk_screen/controller/milk_controller.dart';
import '../models/addmilk_response.dart';
import '../models/addmilkhistory_response.dart';
import '../models/employee_list_response.dart';
import '../widget/searchBar.dart';

enum DataStatus { loading, done, error }

class AddMilkController extends GetxController {
  MilkController milkController = Get.put(MilkController());

  Rx<DataStatus> dataStatus = DataStatus.loading.obs;

  Map<String, dynamic> args = Get.arguments ?? {};

  FocusNode searchFocus = FocusNode();
  FocusNode addMilkFocus = FocusNode();
  RxList<Item> filteredList = <Item>[].obs;
  List<Item> itemList = [];
  RxBool isSearch = false.obs;
  RxBool isHide = false.obs;

  RxString cowName = ''.obs;
  RxString cowType = ''.obs;
  RxString shedId = ''.obs;

  RxString cowId = ''.obs;

  RxString todayMorningMilkCount = ''.obs;
  RxString todayEveningMilkCount = ''.obs;
  RxString cowsLastMilkLiter = ''.obs;

  RxString dayTimes = ''.obs;

  Milkdata? milkData;

  RxBool tepData = false.obs;

  List<TodayMilkFiltered> todayMilkFiltered = [];

  RxList<bulkMIlkData> BulkMilk = <bulkMIlkData>[].obs;

  late AddMilkResponse addMilkResponse;

  RxString selectedCowId = 'Cow ID'.obs;
  RxString selectedTime = 'Time'.obs;

  TextEditingController cowIdController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController DateController = TextEditingController();
  TextEditingController LiterController = TextEditingController();
  TextEditingController searchNameIDController = TextEditingController();
  TextEditingController? searchNameController;
  TextEditingController? searchIdController;
  TextEditingController remarkController = TextEditingController();
  RxList<EmployeeData> employeeList = <EmployeeData>[].obs;
  Rxn<EmployeeData> selectedEmployee = Rxn<EmployeeData>();

  var adMilkController = TextEditingController(text: '0.0');
  var milkML = RxDouble(0.0);

  GlobalKey<FormState> timeKey = GlobalKey<FormState>();
  GlobalKey<FormState> cowIdKey = GlobalKey<FormState>();
  GlobalKey<FormState> literKey = GlobalKey<FormState>();

  AddMilkController() {
    if (args['index'] != null && milkController.cowList.isNotEmpty && args['index'] < milkController.cowList.length) {
      int index = args['index'];
      cowName.value = milkController.cowList[index].calfName;
      cowId.value = milkController.cowList[index].tagId;
      cowType.value = milkController.cowList[index].type;
      shedId.value = milkController.cowList[index].shedId;
      searchNameController = TextEditingController(text: milkController.cowList[index].calfName);
      searchIdController = TextEditingController(text: milkController.cowList[index].tagId);
    } else {
      searchNameController = TextEditingController();
      searchIdController = TextEditingController();
    }

    for (var data in milkController.cowList) {
      itemList.add(Item(id: data.tagId, name: data.calfName, type: data.type));
    }
  }

  @override
  void onInit() {
    if (args['tagId'] != null) {
      MilkHistory(id: args['tagId'].toString());
    }
    getEmployeeList();
    super.onInit();
  }

  Future<void> getEmployeeList() async {
    try {
      var response = await WebService.cmGetRequestWithToken(
        url: ApiClient.getEmployeeListByGaushalaId,
        body: '',
        token: PrefUtils.getToken.toString(),
      );
      if (response.statusCode == 200) {
        EmployeeListResponse employeeResp = employeeListResponseFromJson(response.data);
        employeeList.assignAll(employeeResp.data);
      }
    } catch (e) {
      print("Error fetching employees: $e");
    }
  }

  void filterList(String query) {
    print("Query: $query");
    filteredList.value = itemList.where((item) {
      final itemId = item.id.toString().toLowerCase();
      final queryLower = query.toLowerCase();
      final result = itemId.contains(queryLower);
      print("Item: $itemId, Contains: $result");
      return result;
    }).toList();
  }

  // void filterList(String query) {
  //   print("Query: $query");
  //
  //   // Convert query to lowercase for case-insensitive matching
  //   final queryLower = query.toLowerCase();
  //
  //   // Filter items
  //   filteredList.value = itemList.where((item) {
  //     // ✅ Only include items where cow type is "Milking"
  //     final isMilkingType = item.type == "Milking";
  //
  //     // ✅ Match query with either ID or name
  //     final matchesQuery = item.id.toLowerCase().contains(queryLower) ||
  //         item.name.toLowerCase().contains(queryLower);
  //
  //     final result = isMilkingType && matchesQuery;
  //
  //     print("Item: ${item.id}, Type: ${item.type}, Match: $result");
  //     return result;
  //   }).toList();
  // }

  String getTimeOfDay() {
    var now = DateTime.now();
    var currentTime = TimeOfDay.fromDateTime(now);

    if (currentTime.hour < 12) {
      return 'morning';
    } else {
      return 'evening';
    }
  }

  bool isMilkDoneMorning() {
    if (milkData!.todayMilkFiltered.length == 0 || milkData == null) {
      return false;
    }
    if (milkData!.todayMilkFiltered.length >= 2) {
      return true;
    }

    return getTimeOfDay() == milkData!.todayMilkFiltered.first.dayTime;
  }

  bool isMilkDoneEve() {
    if (milkData!.todayMilkFiltered.length == 0 || milkData == null) {
      return false;
    }
    if (milkData!.todayMilkFiltered.length >= 2) {
      return true;
    }
    return getTimeOfDay() == milkData!.todayMilkFiltered.last.dayTime;
  }

  bool isShowData() {
    tepData.value = isMilkDoneMorning() || isMilkDoneEve();

    return isMilkDoneMorning() || isMilkDoneEve();
  }

  String convertDateFormat({required String date}) {
    DateTime inputDate = DateFormat("dd-MM-yyyy").parse(date);

    String formattedDate = DateFormat("yyyy-MM-dd").format(inputDate);

    return formattedDate;
  }

  Future<void> AddMilkApi(BuildContext context) async {
    if (selectedEmployee.value == null) {
      CattleToast.msg("Please select an employee");
      return;
    }

    AppLoader().show();
    var response = await WebService.cmPostWithTokenRequest(
      url: ApiClient.addMilk,
      body: addMilkRequestToJson(
        AddMilkRequest(
          cowTagId: cowId.value.toString(),
          liter: milkML.value == 0.0 ? 0.1 : milkML.value,
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          dayTime: getTimeOfDay(),
          remark: "${selectedEmployee.value!.empId} - ${selectedEmployee.value!.payrollName}",
          empRemarks: remarkController.value.text,
        ),
      ),
      token: PrefUtils.getToken.toString(),
    );
    AppLoader().hide();
    try {
      if (response.statusCode == 200) {
        addMilkResponse = addMilkResponseFromJson(response.data);
        isHide.value = true;
        isSearch.value = true;
        searchNameIDController.clear();
        remarkController.clear();
        selectedEmployee.value = null;
        milkML.value = 0.0;
        CattleToast.msg(addMilkResponse.message);
        print(response.statusCode);
      }
    } catch (error) {
      AppLoader().hide();
      CattleToast.msg(addMilkResponse.message);
      print("******************Catch**ERROR**********************");
      print(error.toString());
      print("********************ERROR**********************");
    }
  }

  Future<void> MilkHistory({required String id}) async {
    todayMorningMilkCount.value = "";
    todayEveningMilkCount.value = "";
    dayTimes.value = '';
    cowsLastMilkLiter.value = '';
    Response response = await WebService.cmGetRequestWithToken(
      url: '${ApiClient.cowMilkHistory}/${id}',
      body: '',
      token: PrefUtils.getToken.toString(),
    );
    print(response.data);
    print(response.statusCode);
    try {
      if (response.statusCode == 200) {
        AddMilkHistoryResponse addMilkHistoryResponse = await addMilkHistoryResponseFromJson(response.data);
        todayMilkFiltered = addMilkHistoryResponse.milkdata.todayMilkFiltered;
        milkData = addMilkHistoryResponse.milkdata;
        todayMorningMilkCount.value = milkData!.todayMorningMilkCount;
        todayEveningMilkCount.value = milkData!.todayEveningMilkCount;
        cowsLastMilkLiter.value = milkData!.cowsLastMilkLiter;
        milkML.value = milkData!.lastMilkInDouble();
        adMilkController.text = milkData!.cowsLastMilkLiter;
        isShowData();
        toDayMilkTime();
        _changeStatus(DataStatus.done);

        print(response.statusCode);
      } else {
        print("*******************statusCode***********************");
        print(response.statusCode);
        print("*******************statusCode***********************");
        CattleToast.msg(response.statusMessage.toString());
        _changeStatus(DataStatus.error);
      }
    } catch (error) {
      print("******************Catch**ERROR**********************");
      print(error.toString());
      print("********************ERROR**********************");
      _changeStatus(DataStatus.error);
    }
    return;
  }

  Future<void> AddBulkMilk(BuildContext context) async {
    AppLoader().show();
    Response response = await WebService.cmPostWithTokenRequest(
      url: ApiClient.bulkMilk,
      body: addBulkMilkRequestToJson(AddBulkMilkRequest(data: BulkMilk)),
      token: PrefUtils.getToken.toString(),
    );
    AppLoader().hide();
    try {
      if (response.statusCode == 200) {
        AddBulkMilkResponse addBulkMilkResponse = addBulkMilkResponseFromJson(response.data);
        CattleToast.msg(addBulkMilkResponse.message);
        BulkMilk.clear();
        remarkController.clear();
      } else {
        print("*******************statusCode***********************");
        print(response.statusCode);
        print("*******************statusCode***********************");
        _changeStatus(DataStatus.error);
      }
    } catch (error, s) {
      AppLoader().hide();
      print('##########################################################$s');
      print("******************Catch**ERROR**********************");
      print(error.toString());
      print("********************ERROR**********************");
      _changeStatus(DataStatus.error);
    }
  }

  String CowTageId({required String id}) {
    List<String> parts = id.split(' : ');
    String? desiredOutput;
    return desiredOutput = "${parts[0]}";
  }

  Future<void> ValidateMilk(BuildContext context) async {
    if (selectedEmployee.value == null) {
      CattleToast.msg("Please select an employee");
      return;
    }

    AppLoader().show();
    var response = await WebService.cmPostWithTokenRequest(
      url: ApiClient.validateMilk,
      body: validateMilkRequestToJson(
        ValidateMilkRequest(
          cowTagId: CowTageId(id: selectedCowId.value),
          date: DateController.text.isEmpty ? DateFormat('yyyy-MM-dd').format(DateTime.now()) : convertDateFormat(date: DateController.text),
          dayTime: selectedTime.value,
        ),
      ),
      token: PrefUtils.getToken.toString(),
    );
    AppLoader().hide();
    try {
      if (response.statusCode == 200) {
        ValidateMilkResponse validateMilkResponse = validateMilkResponseFromJson(response.data);
        if (validateMilkResponse.validateMilkData.isValid == true) {
          BulkMilk.add(
            bulkMIlkData(
              cowTagId: CowTageId(id: selectedCowId.value),
              liter: double.tryParse(LiterController.text) ?? 0.0,
              date: DateController.text.isEmpty ? DateFormat('yyyy-MM-dd').format(DateTime.now()) : convertDateFormat(date: DateController.text),
              dayTime: selectedTime.value,
              remark: "${selectedEmployee.value!.empId} - ${selectedEmployee.value!.payrollName}",
              empRemarks: remarkController.value.text,
            ),
          );
        }
        cowIdController.clear();
        selectedCowId.value = 'Cow ID';
        selectedTime.value = 'Time';
        DateController.clear();
        timeController.clear();
        LiterController.clear();
        remarkController.clear();
        selectedEmployee.value = null;
        print(response.statusCode);
      }
    } catch (error) {
      AppLoader().hide();
      print("******************Catch**ERROR**********************");
      print(error.toString());
      print("********************ERROR**********************");
    }
  }

  String toDayMilkTime() {
    List<String> dayTimesList = [];

    dayTimes.value = '';
    dayTimesList.clear();

    for (var a in todayMilkFiltered) {
      dayTimesList.add(a.dayTime);
    }

    dayTimes.value = dayTimesList.join(",");
    return dayTimes.value;
  }

  DataStatus _changeStatus(DataStatus value) => dataStatus(value);
}
