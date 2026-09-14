import 'package:cattle_app/core/app_export.dart';
import 'package:cattle_app/presentation/cow_screen/cow_details/cow_details_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/dropdown/dropdown.dart';
import '../../common file/defaultVariablesList.dart';

class EditCowDetailsScreen extends GetView<CowsDetailScreenController> {
  const EditCowDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          height: 60,
          leadingIcon: const Icon(Icons.arrow_back, color: Colors.white),
          leadingIconOnTap: () {
            Get.back();
          },
          title: "Edit Cow Details",
          styleType: Style.bgFillBluegray900,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => Dropdown(
                        selectedItem: "${controller.breedController.text}".obs,
                        globalKey: controller.breedKey,
                        text: 'Breed  '.obs,
                        list: breed.map((data) => data.value).toList(),
                        onChanged: (value) async {
                          controller.breedController.text = value.toString();
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please Enter Breed ';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Dropdown(
                      selectedItem: "${controller.genderController.text}".obs,
                      globalKey: controller.genderKey,
                      text: 'Gender '.obs,
                      list: controller.Gender,
                      showSearchBox: false,
                      onChanged: (value) async {
                        controller.genderController.text = value.toString();
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please Enter Gender ';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      globalKey: controller.calfIDKey,
                      controller: controller.calfIDController,
                      textInputType: TextInputType.none,
                      hintText: "Cow ID",
                      labelText: "Cow ID",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Cow ID ';
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomTextFormField(
                      globalKey: controller.calfNameKey,
                      controller: controller.calfNameController,
                      hintText: "Cow Name",
                      labelText: "Cow Name",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Cow Name ';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
                      child: InkWell(
                        onTap: () {
                          onTapDOBDate(context: context);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey, width: 2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(() => Text(controller.dobText.value.isEmpty ? "Date of Birth" : controller.dobText.value)),
                              IconButton(
                                onPressed: () {
                                  controller.dobController.clear();
                                  controller.dobText.value = '';
                                },
                                icon: const Icon(Icons.cancel_outlined),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
                      child: InkWell(
                        onTap: () {
                          onTapPurchaseDate(context: context);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey, width: 2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(() => Text(controller.purchaseDateText.value.isEmpty ? 'Purchase Date' : controller.purchaseDateText.value)),
                              IconButton(
                                onPressed: () {
                                  controller.purchaseDateController.clear();
                                  controller.purchaseDateText.value = '';
                                },
                                icon: const Icon(Icons.cancel_outlined),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Row(
                  children: [
                    Text(
                      'Time : ',
                      style: TextStyle(fontWeight: FontWeight.bold, color: ColorConstant.blueGray9007f, fontSize: 17),
                    ),
                    const Spacer(),
                    TimePickerSpinnerPopUp(
                      mode: CupertinoDatePickerMode.time,
                      initTime: DateTime.now(),
                      onChange: (dateTime) {
                        controller.timeController.text = DateFormat('hh:mm:a').format(dateTime).toString();
                      },
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Obx(
                    () => Column(
                      children: [
                        Dropdown(
                          selectedItem: "${controller.cowTypeController.text}".obs,
                          globalKey: controller.cowTypeKey,
                          text: 'Cow Type '.obs,
                          list: cowType.map((data) => data.id).toList(),
                          onChanged: (value) async {
                            controller.cowTypeController.text = value.toString();
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please Enter Cow Type ';
                            }
                            return null;
                          },
                        ),
                        Dropdown(
                          selectedItem: "${controller.damIdController.text}".obs,
                          text: 'Dam ID  '.obs,
                          list: controller.milkController.cowList.map((data) => data.tagId + ' - ' + data.calfName).toList(),
                          onChanged: (value) async {
                            controller.damIdController.text = value.toString();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Obx(
                () => Dropdown(
                  selectedItem: "${controller.sairIdController.text}".obs,
                  text: 'Sair ID  '.obs,
                  list: bull.map((data) => data.id + ' - ' + data.value).toList(),
                  onChanged: (value) async {
                    controller.sairIdController.text = value.toString();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => Dropdown(
                        selectedItem: "${controller.newShedIdController.text}".obs,
                        globalKey: controller.newShedIdKey,
                        text: 'New Shed Id  '.obs,
                        list: shed.map((data) => data.value).toList(),
                        onChanged: (value) async {
                          controller.newShedIdController.text = value.toString();
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please Enter New Shed Id ';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomTextFormField(
                      globalKey: controller.cowWeightKey,
                      controller: controller.cowWeightController,
                      hintText: "Calf Weight",
                      labelText: "Calf Weight",
                      textInputType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Calf Weight  ';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              CustomTextFormField(hintText: 'Remark  ', labelText: 'Remark  ', controller: controller.remarkController),
              const SizedBox(height: 10),
            ],
          ),
        ),
        bottomNavigationBar: CustomButton(
          onTap: () {
            controller.editCowsDetail();
          },
          height: getVerticalSize(58),
          text: "lbl_done".tr,
          margin: getMargin(left: 59, right: 58, bottom: 25),
          variant: ButtonVariant.FillGreen600b2,
          padding: ButtonPadding.PaddingAll13,
          textStyle: const TextStyle(color: Colors.white),
          fontStyle: ButtonFontStyle.OutfitMedium25,
        ),
      ),
    );
  }

  Future<void> onTapDOBDate({required BuildContext context}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime(2000),
      initialDate: DateTime.now(),
    );
    if (pickedDate == null) return;
    controller.dobController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
    controller.dobText.value = controller.dobController.text;
  }

  Future<void> onTapPurchaseDate({required BuildContext context}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime(2000),
      initialDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (pickedDate == null) return;
    controller.purchaseDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
    controller.purchaseDateText.value = controller.purchaseDateController.text;
  }
}
