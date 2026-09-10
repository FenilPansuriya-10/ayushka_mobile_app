import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';
import 'package:cattle_app/data/apiClient/api_client.dart';
import 'package:cattle_app/data/apiClient/api_methods.dart';
import 'package:cattle_app/presentation/add_milk_screen/models/Cow_Transfer_Request.dart';
import 'package:cattle_app/presentation/add_milk_screen/models/Cow_Transfer_Response.dart';
import 'package:cattle_app/presentation/cow_screen/cow_details/model/cow_details_request.dart';
import 'package:cattle_app/presentation/milk_screen/controller/milk_controller.dart';
import 'package:cattle_app/widgets/loder.dart';
import 'package:cattle_app/widgets/toast_message/toast_message.dart';

import '../../../core/utils/pref_utils.dart';
import '../../common file/defaultVariablesList.dart';
import '../../cow_screen/cow_details/model/cow_details_response.dart';

class ShedTransferController extends GetxController {
  MilkController milkController = MilkController();

  TextEditingController cowIdController = TextEditingController();
  TextEditingController oldShedController = TextEditingController();
  TextEditingController newShedController = TextEditingController();
  TextEditingController cowTypeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  GlobalKey<FormState> cowIdKey = GlobalKey<FormState>();
  GlobalKey<FormState> oldShedKey = GlobalKey<FormState>();
  GlobalKey<FormState> newShedKey = GlobalKey<FormState>();
  GlobalKey<FormState> cowTypeKey = GlobalKey<FormState>();

  Map<String, dynamic>? retrievedData = PrefUtils.getData;

  RxString? oldShed;

  FoundCow? foundCow;

  RxBool showShed = false.obs;

  RxString selectedCowId = 'cowId'.obs;
  RxString selectedOldShed = 'oldShed'.obs;
  RxString selectedNewShed = 'newShed'.obs;
  RxString selectedCowType = 'cowType'.obs;

  RxList<CowTransferData> cowTransfer = <CowTransferData>[].obs;
  @override
  void onInit() {
    milkController = Get.put(MilkController());
    retrieveCowData();
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String cowId({required String id}) {
    List<String> parts = id.split(' : ');
    String? desiredOutput;

    return desiredOutput = "${parts[0]}";
  }

  Future<void> CowsDetail({required String id}) async {
    AppLoader().show();
    try {
      final Response response = await WebService.cmPostWithTokenRequest(
        url: ApiClient.cowDetail,
        body: cowDetailsRequestToJson(CowDetailsRequest(tagId: cowId(id: id))),
        token: PrefUtils.getToken.toString(),
      );
      AppLoader().hide();
      if (response.statusCode == 200) {
        CowDetailsResponse cowDetailsResponse = cowDetailsResponseFromJson(response.data);
        if (cowDetailsResponse.cowDetails?.foundCow != null) {
          foundCow = cowDetailsResponse.cowDetails!.foundCow;
          oldShedController = TextEditingController(text: "${foundCow!.shedId}");
          selectedOldShed.value = foundCow!.shedId;
          cowTypeController = TextEditingController(text: "${foundCow!.type}");
          selectedCowType.value = foundCow!.type;
          showShed.value = true;
        }
        print(response.statusCode);
      } else {
        print("*******************statusCode***********************");
        print(response.statusCode);
        CattleToast.msg(response.statusMessage!);
        print("*******************statusCode***********************");
      }
    } catch (error) {
      AppLoader().hide();
      print("******************Catch**ERROR**********************");
      print(error.toString());
      CattleToast.msg(error.toString());
      print("********************ERROR**********************");
    }
    return;
  }

  Future<void> CowTransfer(BuildContext context) async {
    AppLoader().show();
    Response response = await WebService.cmPostWithTokenRequest(
      url: ApiClient.cowTransfer,
      body: cowTransferRequestToJson(
        CowTransferRequest(
          userId: retrievedData!['user_id'],
          cowId: cowId(id: cowIdController.text),
          oldShed: oldShedController.text,
          dateTime: DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now().toUtc()),
          newShed: newShedController.text,
          cowType: cowTypeController.text,
          description: descriptionController.text.isEmpty || descriptionController.text == ''
              ? ''
              : descriptionController.text,
          gaushalaId: PrefUtils.getGaushalaId.toString(),
        ),
      ),
      token: PrefUtils.getToken.toString(),
    );
    AppLoader().hide();
    try {
      if (response.statusCode == 200) {
        CowTransferResponse cowTransferResponse = await cowTransferResponseFromJson(response.data);
        if (cowTransferResponse.status == "SUCCESS") {
          descriptionController.clear();
          cowIdController.clear();
          selectedCowId.value = 'cowId';
          oldShedController.clear();
          selectedOldShed.value = 'oldShed';
          newShedController.clear();
          selectedNewShed.value = 'newShed';
          cowTypeController.clear();
          selectedCowType.value = 'cowType';
          milkController.cmCowList();
          cowTransfer.add(cowTransferResponse.cowTransferData);
          CattleToast.msg(cowTransferResponse.message);
        } else {
          print(cowTransferResponse.status);
          CattleToast.msg(cowTransferResponse.status);
        }
        print(response.statusCode);
      } else {
        print("*******************statusCode***********************");
        print(response.statusCode);
        CattleToast.msg(response.statusMessage!);
        print("*******************statusCode***********************");
      }
    } catch (error, s) {
      AppLoader().hide();
      print('##########################################################$s');
      print("******************Catch**ERROR**********************");
      print(error.toString());
      CattleToast.msg(error.toString());
      print("********************ERROR**********************");
    }
    return;
  }
}
