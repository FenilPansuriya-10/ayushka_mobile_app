import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

import '../../core/utils/color_constant.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/rich_text.dart';
import '../cow_screen/Add_cow/add_cow_controller.dart';
import '../dashboard_screen/controller/dashboard_controller.dart';
import 'controller/add_milk_controller.dart';
import 'models/employee_list_response.dart';

class AddBulkMilkScreen extends StatelessWidget {
  const AddBulkMilkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController = Get.find<DashboardController>();
    final AddMilkController controller = Get.find<AddMilkController>();
    final AddCowScreenController addCowScreenController = Get.put(AddCowScreenController());

    return WillPopScope(
      onWillPop: () async {
        dashboardController.cmDashBoardData();
        dashboardController.getReminders();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            height: 60,
            centerTitle: true,
            leadingIconOnTap: () {
              dashboardController.cmDashBoardData();
              dashboardController.getReminders();
              Get.back();
              Get.back();
            },
            leadingIcon: const Icon(Icons.arrow_back, color: Colors.white),
            title: 'Add Bulk Milk',
            styleType: Style.bgFillBluegray900,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) => WillPopScope(
                        onWillPop: () async => false,
                        child: AlertDialog(
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(22.0))),
                          elevation: 0,
                          content: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.black26,
                                    radius: 15,
                                    child: Icon(Icons.close, color: Colors.black, size: 20),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        Obx(
                                          () => Form(
                                            key: controller.cowIdKey,
                                            child: DropdownButtonFormField<String>(
                                              value: controller.selectedCowId.value == 'Cow ID' ? null : controller.selectedCowId.value,
                                              isExpanded: true,
                                              decoration: InputDecoration(
                                                hintText: 'Cow ID',
                                                labelText: 'Cow ID',
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                              ),
                                              items: addCowScreenController.milkController.cowList.map((data) {
                                                return DropdownMenuItem<String>(
                                                  value: '${data.tagId} : ${data.calfName}',
                                                  child: Text(
                                                    '${data.tagId} : ${data.calfName}',
                                                    style: const TextStyle(fontSize: 16, fontFamily: 'Outfit'),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                controller.selectedCowId.value = newValue ?? 'Cow ID';
                                              },
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please Enter Cow ID';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10, left: 0, right: 10),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Date : ',
                                                style: TextStyle(fontWeight: FontWeight.bold, color: ColorConstant.blueGray9007f, fontSize: 17),
                                              ),
                                              const Spacer(),
                                              TimePickerSpinnerPopUp(
                                                mode: CupertinoDatePickerMode.date,
                                                initTime: DateTime.now(),
                                                maxTime: DateTime.now().add(const Duration(days: 10)),
                                                barrierColor: Colors.black12,
                                                minuteInterval: 1,
                                                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                                                cancelText: 'Cancel',
                                                confirmText: 'OK',
                                                pressType: PressType.singlePress,
                                                timeFormat: 'dd-MM-yyyy',
                                                onChange: (dateTime) {
                                                  controller.DateController.text = DateFormat('dd-MM-yyyy').format(dateTime).toString();
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Obx(
                                          () => Form(
                                            key: controller.timeKey,
                                            child: DropdownButtonFormField<String>(
                                              value: controller.selectedTime.value == 'Time' ? null : controller.selectedTime.value,
                                              isExpanded: true,
                                              decoration: InputDecoration(
                                                hintText: 'Time',
                                                labelText: 'Time',
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                              ),
                                              items: const ['morning', 'evening'].map((String val) {
                                                return DropdownMenuItem<String>(
                                                  value: val,
                                                  child: Text(val, style: const TextStyle(fontSize: 16, fontFamily: 'Outfit')),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                controller.selectedTime.value = newValue ?? 'Time';
                                              },
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please Enter time';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        CustomTextFormField(
                                          globalKey: controller.literKey,
                                          controller: controller.LiterController,
                                          textInputType: const TextInputType.numberWithOptions(decimal: true),
                                          hintText: "Liter",
                                          labelText: "Liter",
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please Enter Liter';
                                            }
                                            return null;
                                          },
                                        ),
                                        Obx(
                                          () => Padding(
                                            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                            child: DropdownButtonFormField<EmployeeData>(
                                              value: controller.selectedEmployee.value,
                                              isExpanded: true,
                                              decoration: InputDecoration(
                                                hintText: "Select Employee".tr,
                                                labelText: "Select Employee".tr,
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                              ),
                                              items: controller.employeeList.map((EmployeeData emp) {
                                                return DropdownMenuItem<EmployeeData>(
                                                  value: emp,
                                                  child: Text(
                                                    "${emp.empId} - ${emp.payrollName}",
                                                    style: const TextStyle(fontSize: 16, fontFamily: 'Outfit'),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (EmployeeData? newValue) {
                                                controller.selectedEmployee.value = newValue;
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                          child: TextFormField(
                                            controller: controller.remarkController,
                                            decoration: InputDecoration(
                                              hintText: "Enter Remarks".tr,
                                              labelText: "Remarks".tr,
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: CustomButton(
                                            text: "Add",
                                            width: 200,
                                            height: 55,
                                            textStyle: const TextStyle(color: Colors.white, fontSize: 20),
                                            variant: ButtonVariant.FillGreen600b2,
                                            onTap: () {
                                              if ((controller.cowIdKey.currentState?.validate() ?? false) &&
                                                  (controller.timeKey.currentState?.validate() ?? false) &&
                                                  (controller.literKey.currentState?.validate() ?? false)) {
                                                controller.ValidateMilk(context);
                                                Future.delayed(const Duration(milliseconds: 400), () {
                                                  controller.selectedTime.value = 'Time';
                                                });
                                                Get.back();
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white, size: 25),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Obx(
                    () => ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.BulkMilk.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.BulkMilk.removeAt(index);
                                      },
                                      child: const CircleAvatar(
                                        backgroundColor: Colors.black26,
                                        radius: 10,
                                        child: Icon(Icons.close, color: Colors.black, size: 15),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: CattleRichText(
                                          text: 'CowID : ',
                                          fontSize1: 14,
                                          color: const Color(0xff262626),
                                          richText: '${controller.BulkMilk[index].cowTagId}',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Expanded(
                                        child: CattleRichText(
                                          text: 'Date : ',
                                          fontSize1: 14,
                                          color: const Color(0xff262626),
                                          richText: convertDateFormat(date: controller.BulkMilk[index].date),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: CattleRichText(
                                          text: 'Time : ',
                                          fontSize1: 14,
                                          color: const Color(0xff262626),
                                          richText: '${controller.BulkMilk[index].dayTime}',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Expanded(
                                        child: CattleRichText(
                                          text: 'Liter : ',
                                          fontSize1: 14,
                                          color: const Color(0xff262626),
                                          richText: '${controller.BulkMilk[index].liter}',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(left: 50, right: 50, bottom: 10),
            child: CustomButton(
              text: "submit",
              width: 200,
              height: 60,
              textStyle: const TextStyle(color: Colors.white, fontSize: 20),
              variant: ButtonVariant.FillGreen600b2,
              onTap: () {
                controller.AddBulkMilk(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  String convertDateFormat({required String date}) {
    DateTime inputDate = DateFormat("yyyy-MM-dd").parse(date);
    String formattedDate = DateFormat("dd-MM-yyyy").format(inputDate);
    return formattedDate;
  }
}
