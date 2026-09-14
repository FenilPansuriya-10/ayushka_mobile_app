// ignore_for_file: must_be_immutable

import 'package:cattle_app/core/app_export.dart';
import 'package:cattle_app/presentation/milk_screen/chart_page.dart';
import 'package:cattle_app/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

import '../../widgets/custom_button.dart';
import '../filter_screen/filter_controller.dart';
import 'controller/milk_controller.dart';

class MilkScreen extends GetWidget<MilkController> {
  MilkScreen({Key? key}) : super(key: key);

  FilterController filterController = Get.put(FilterController());

  final ValueNotifierList<String> valueNotifier = ValueNotifierList<String>([]);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.sort.clear();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          backgroundColor: ColorConstant.whiteA700,
          appBar: CustomAppBar(
            leadingIconOnTap: () {
              controller.sort.clear();
              Get.back();
            },
            leadingIcon: Icon(Icons.arrow_back, color: Colors.white),
            centerTitle: true,
            height: 60,
            title: "lbl_milk".tr,
            styleType: Style.bgFillBluegray900,
            actions: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Image(image: AssetImage("assets/images/remark.png"), height: 30, width: 30),
                ),
                onTap: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) => WillPopScope(
                      onWillPop: () async => false,
                      child: AlertDialog(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(22.0))),
                        elevation: 0,
                        content: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10, left: 0, right: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Start Date : ',
                                            style: TextStyle(fontWeight: FontWeight.bold, color: ColorConstant.blueGray9007f, fontSize: 17),
                                          ),
                                          Spacer(),
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
                                              controller.milkReportStartDateController.text = DateFormat('dd-MM-yyyy').format(dateTime).toString();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10, left: 0, right: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            'End Date : ',
                                            style: TextStyle(fontWeight: FontWeight.bold, color: ColorConstant.blueGray9007f, fontSize: 17),
                                          ),
                                          Spacer(),
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
                                              controller.milkReportEndDateController.text = DateFormat('dd-MM-yyyy').format(dateTime).toString();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: TextField(
                                        controller: controller.milkReportCowIDController,
                                        decoration: InputDecoration(
                                          hintText: 'Cow ID',
                                          labelText: "Cow ID",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(getHorizontalSize(10.00)),
                                            borderSide: BorderSide(color: ColorConstant.blueGray9007f, width: 2),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(getHorizontalSize(10.00)),
                                            borderSide: BorderSide(color: ColorConstant.blueGray9007f, width: 2),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(getHorizontalSize(10.00)),
                                            borderSide: BorderSide(color: ColorConstant.blueGray9007f, width: 2),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(getHorizontalSize(10.00)),
                                            borderSide: BorderSide(color: ColorConstant.blueGray9007f, width: 2),
                                          ),
                                          suffixIcon: IconButton(onPressed: controller.milkReportCowIDController.clear, icon: Icon(Icons.clear)),
                                        ),
                                      ),
                                    ),
                                    // Report Mode Selection
                                    Obx(
                                      () => Column(
                                        children: [
                                          RadioListTile<String>(
                                            title: const Text('Shed Wise'),
                                            value: 'Shed',
                                            groupValue: controller.reportMode.value,
                                            onChanged: (value) {
                                              controller.setReportMode(value!);
                                            },
                                          ),
                                          RadioListTile<String>(
                                            title: const Text('Employee Wise'),
                                            value: 'Employee',
                                            groupValue: controller.reportMode.value,
                                            onChanged: (value) {
                                              controller.setReportMode(value!);
                                            },
                                          ),
                                          RadioListTile<String>(
                                            title: const Text('Employee Monthly'),
                                            value: 'Employee Monthly',
                                            groupValue: controller.reportMode.value,
                                            onChanged: (value) {
                                              controller.setReportMode(value!);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: CustomButton(
                                        text: "Apply",
                                        width: 200,
                                        height: 55,
                                        textStyle: TextStyle(color: Colors.white, fontSize: 20),
                                        variant: ButtonVariant.FillGreen600b2,
                                        onTap: () {
                                          controller.cowMilkReport();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.black26,
                                radius: 15,
                                child: Icon(Icons.close, color: Colors.black, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Container(
            width: size.width,
            height: size.height,
            padding: getPadding(top: 90),
            decoration: BoxDecoration(color: ColorConstant.whiteA700),
            child: SingleChildScrollView(
              padding: getPadding(top: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder<List<String>>(
                    valueListenable: valueNotifier,
                    builder: (context, value, child) {
                      return value.isNull || value.isEmpty
                          ? SizedBox()
                          : Container(
                              height: 50,
                              width: double.maxFinite,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: value.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue[50],
                                        border: Border.all(width: 2, color: Colors.blue),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.toNamed(AppRoutes.filterScreen);
                                            },
                                            child: Text('${value[index]}', style: TextStyle(color: Colors.black)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                    },
                  ),
                  Padding(
                    padding: getPadding(top: 18),
                    child: Divider(
                      height: getVerticalSize(1),
                      thickness: getVerticalSize(1),
                      color: ColorConstant.blueGray4007f,
                      indent: getHorizontalSize(10),
                      endIndent: getHorizontalSize(10),
                    ),
                  ),
                  LineChart(),
                  Padding(
                    padding: getPadding(top: 9),
                    child: Divider(
                      height: getVerticalSize(1),
                      thickness: getVerticalSize(1),
                      color: ColorConstant.gray4004c,
                      indent: getHorizontalSize(10),
                      endIndent: getHorizontalSize(10),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ValueNotifierList<T> extends ValueNotifier<List<T>> {
  ValueNotifierList(List<T> value) : super(value);

  void add(T valueToAdd) {
    value = [...value, valueToAdd];
  }

  void remove(T valueToRemove) {
    value = value.where((value) => value != valueToRemove).toList();
  }
}
