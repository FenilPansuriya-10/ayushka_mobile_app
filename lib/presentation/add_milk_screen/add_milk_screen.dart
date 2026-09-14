import 'package:cattle_app/core/app_export.dart';
import 'package:cattle_app/presentation/add_milk_screen/milking_calf_screen.dart';
import 'package:cattle_app/presentation/add_milk_screen/models/employee_list_response.dart';
import 'package:cattle_app/presentation/add_milk_screen/widget/searchBar.dart';
import 'package:cattle_app/widgets/app_bar/custom_app_bar.dart';
import 'package:cattle_app/widgets/custom_button.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../dashboard_screen/controller/dashboard_controller.dart';
import '../milk_screen/controller/milk_controller.dart';
import 'controller/add_milk_controller.dart';

enum CowType { MilkingCalf, DryCalf }

Rx<CowType> cowType = CowType.MilkingCalf.obs;

class AddMilkScreen extends GetView<AddMilkController> {
  const AddMilkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController = Get.put(DashboardController());

    return WillPopScope(
      onWillPop: () async {
        dashboardController.cmDashBoardData();
        dashboardController.getReminders();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstant.whiteA700,
          appBar: CustomAppBar(
            height: 60,
            centerTitle: true,
            leadingIcon: const Icon(Icons.arrow_back, color: Colors.white),
            leadingIconOnTap: () {
              dashboardController.cmDashBoardData();
              dashboardController.getReminders();
              Get.back();
            },
            title: "lbl_add_milk".tr,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.addBulkMilk, arguments: {"index": 0});
                  },
                  // child: const Image(image: AssetImage('assets/images/totalMilkIcon.png'), height: 35),
                  child: const Text("Add", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
            styleType: Style.bgFillBluegray900,
          ),
          body: GestureDetector(
            onTap: () {
              controller.isSearch.value = false;
              controller.searchFocus.unfocus();
            },
            child: Container(
              width: double.maxFinite,
              padding: getPadding(left: 10, top: 9, right: 10, bottom: 9),
              child: SingleChildScrollView(
                child: Obx(
                  () => dashboardController.milkController.dataStatus.value == DataStatusE.loading
                      ? const Center(child: CircularProgressIndicator())
                      : dashboardController.milkController.cowList.isEmpty
                      ? Center(child: Text('Record not found', style: AppStyle.txtOutfitMedium20))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(padding: const EdgeInsets.only(left: 10, right: 10), child: CustomSearchBar()),
                            Padding(
                              padding: getPadding(left: 16, top: 26),
                              child: controller.isHide.value
                                  ? const SizedBox()
                                  : Text(
                                      "${controller.cowId.value} : ${controller.cowName.value} - ${controller.cowType}",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtOutfitMedium20Blue700,
                                    ),
                            ),
                            if (controller.cowType == 'Milking' || controller.cowType == 'Milking-Pregnant') ...{
                              controller.isHide.value ? const SizedBox() : MilkingCalf(context),
                            } else ...{
                              DryCalf(),
                            },
                            controller.tepData.value || controller.cowType == 'Dry-Calf'
                                ? const SizedBox()
                                : controller.cowType == 'Milking' || controller.cowType == 'Milking-Pregnant'
                                ? SizedBox(
                                    width: double.maxFinite,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10, right: 10),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(color: const Color(0xffE5F0FF), borderRadius: BorderRadius.circular(8)),
                                            child: DropdownSearch<EmployeeData>(
                                              selectedItem: controller.selectedEmployee.value,
                                              items: (filter, loadProps) => controller.employeeList
                                                  .where(
                                                    (emp) =>
                                                        emp.payrollName.toLowerCase().contains(filter.toLowerCase()) ||
                                                        emp.empId.toLowerCase().contains(filter.toLowerCase()),
                                                  )
                                                  .toList(),
                                              itemAsString: (EmployeeData emp) => emp.payrollName,
                                              compareFn: (a, b) => a.empId == b.empId,
                                              popupProps: PopupProps.dialog(
                                                showSearchBox: true,
                                                searchFieldProps: TextFieldProps(
                                                  decoration: InputDecoration(
                                                    hintText: "Search Employee".tr,
                                                    border: const OutlineInputBorder(),
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                  ),
                                                ),
                                              ),
                                              decoratorProps: DropDownDecoratorProps(
                                                decoration: InputDecoration(
                                                  hintText: "Select Employee".tr,
                                                  border: InputBorder.none,
                                                  prefixIcon: const Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Image(image: AssetImage('assets/images/remarkIcon.png'), height: 30, width: 30),
                                                  ),
                                                  hintStyle: const TextStyle(fontSize: 18, fontFamily: 'Outfit'),
                                                ),
                                              ),
                                              onChanged: (EmployeeData? newValue) {
                                                controller.selectedEmployee.value = newValue;
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10, right: 10),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(color: const Color(0xffE5F0FF), borderRadius: BorderRadius.circular(8)),
                                            child: TextFormField(
                                              controller: controller.remarkController,
                                              decoration: InputDecoration(
                                                hintText: "Enter Remarks".tr,
                                                border: InputBorder.none,
                                                prefixIcon: const Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Icon(Icons.note_alt_outlined, color: Colors.blueGrey, size: 28),
                                                ),
                                                hintStyle: const TextStyle(fontSize: 18, fontFamily: 'Outfit'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            controller.isHide.value || controller.tepData.value || controller.cowType == 'Dry-Calf'
                                ? const SizedBox()
                                : controller.cowType == 'Milking' || controller.cowType == 'Milking-Pregnant'
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: SizedBox(
                                      height: 50,
                                      width: double.infinity,
                                      child: CustomButton(
                                        onTap: () {
                                          if (controller.cowType == 'Milking' || controller.cowType == 'Milking-Pregnant') {
                                            controller.AddMilkApi(context);
                                          } else {
                                            Get.back();
                                          }
                                        },
                                        height: getVerticalSize(58),
                                        text: "Add milk".tr,
                                        textStyle: const TextStyle(color: Colors.white, fontFamily: 'Outfit', fontSize: 20),
                                        margin: getMargin(left: 59, right: 58),
                                        variant: ButtonVariant.FillBluegray900,
                                        padding: ButtonPadding.PaddingAll13,
                                        fontStyle: ButtonFontStyle.OutfitMedium25,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),

                            controller.cowType == 'Pregnant'
                                ? Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                          AppRoutes.addNewCow,
                                          arguments: {
                                            'shedId': controller.shedId.value,
                                            'tagId': controller.cowId.value,
                                            'calfName': controller.cowName.value,
                                            'isChildEntry': true,
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: 170,
                                        height: 55,
                                        padding: getPadding(left: 25, top: 2, right: 25, bottom: 2),
                                        decoration: BoxDecoration(color: Colors.green[300], borderRadius: BorderRadius.circular(30)),
                                        child: Center(
                                          child: Text(
                                            "Entry".tr,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtOutfitMedium25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Obx(() {
            return controller.tepData.value || controller.cowType == 'Dry-Calf'
                ? const SizedBox()
                : controller.cowType == 'Milking' || controller.cowType == 'Milking-Pregnant'
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.addNewCow,
                              arguments: {
                                'shedId': controller.shedId.value,
                                'tagId': controller.cowId.value,
                                'calfName': controller.cowName.value,
                                'isChildEntry': true,
                              },
                            );
                          },
                          child: Container(
                            width: 150,
                            height: 55,
                            padding: getPadding(left: 25, top: 2, right: 25, bottom: 2),
                            decoration: BoxDecoration(color: Colors.green[300], borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Text("Entry".tr, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left, style: AppStyle.txtOutfitMedium25),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.CowTransfer,
                              arguments: {'shedId': controller.shedId.value, 'tagId': controller.cowId.value, 'calfName': controller.cowName.value},
                            );
                          },
                          child: Container(
                            width: 150,
                            height: 55,
                            padding: getPadding(left: 25, top: 2, right: 25, bottom: 2),
                            decoration: BoxDecoration(color: const Color(0xffff4d4d), borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Text(
                                "lbl_exit".tr,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtOutfitMedium25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox();
          }),
        ),
      ),
    );
  }
}
