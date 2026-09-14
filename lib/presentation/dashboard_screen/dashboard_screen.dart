import 'package:cattle_app/core/app_export.dart';
import 'package:cattle_app/presentation/cow_screen/cow_controller.dart';
import 'package:cattle_app/presentation/dashboard_screen/controller/dashboard_controller.dart';
import 'package:cattle_app/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;

import '../../widgets/alert_dialog.dart';
import '../Expense/stock_out_screen.dart';

// ignore_for_file: must_be_immutable
class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController = Get.put(DashboardController());

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Column(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image(image: AssetImage('assets/images/Logo Black.png'), height: 80),
                    ),
                    Text('Cattle Management', style: TextStyle(color: Colors.black, fontSize: 20)),
                  ],
                ),
              ),
              PrefUtils.getUserType == 02
                  ? Column(
                      children: [
                        ListTile(
                          title: Align(
                            alignment: Alignment.topLeft,
                            child: TextButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.changeGuashala);
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Change Guashala',
                                  style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Align(
                            alignment: Alignment.topLeft,
                            child: TextButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.guashalaReportScreen);
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Report',
                                  style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              ListTile(
                title: Row(
                  children: const [
                    SizedBox(width: 20),
                    Text('Log Out', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 30),
                    Icon(Icons.logout, color: Colors.black),
                  ],
                ),
                onTap: () {
                  CattleAlertDialog(
                    context,
                    cancelonTap: () {
                      Get.back();
                    },
                    Sajesan: 'Are you sure ?',
                    onpressed: () {
                      PrefUtils().clearPreferencesData();
                      Get.offAllNamed(AppRoutes.loginScreen);
                    },
                    text: 'Log OUT',
                    cancel: true,
                  );
                },
              ),
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Obx(() => Text('Version : ${dashboardController.version.value}', style: const TextStyle(fontSize: 15, color: Colors.black))),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: ColorConstant.whiteA700,
        appBar: CustomAppBar(
          height: 60,
          leadingIconOnTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          leadingIcon: const Icon(Icons.menu, color: Colors.white),
          centerTitle: true,
          title: "lbl_dashboard".tr,
          styleType: Style.bgFillBluegray900,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            padding: getPadding(all: 19),
            child:
                (dashboardController.retrievedData!['user_id'] == "Gaushalamilk1" || dashboardController.retrievedData!['user_id'] == "Gaushalamilk2")
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: getPadding(left: 2, top: 18, right: 8, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Future.delayed(const Duration(seconds: 2), () {
                                    Get.toNamed(AppRoutes.milkScreen);
                                  });
                                },
                                child: Container(
                                  margin: getMargin(left: 16),
                                  decoration: AppDecoration.fillDeeppurple300.copyWith(borderRadius: BorderRadiusStyle.roundedBorder30),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: getPadding(left: 20, top: 20),
                                        child: Text(
                                          "lbl_1500_l".tr,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtOutfitRegular15,
                                        ),
                                      ),
                                      Padding(
                                        padding: getPadding(left: 16, top: 1),
                                        child: Text(
                                          "lbl_milk".tr,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtOutfitMedium25,
                                        ),
                                      ),
                                      Card(
                                        clipBehavior: Clip.antiAlias,
                                        elevation: 0,
                                        margin: getMargin(top: 17),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadiusStyle.roundedBorder30),
                                        child: Container(
                                          height: getVerticalSize(84),
                                          width: getHorizontalSize(110),
                                          padding: getPadding(left: 29, top: 15, right: 29, bottom: 15),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadiusStyle.roundedBorder30,
                                            image: DecorationImage(image: fs.Svg(ImageConstant.imgGroup7), fit: BoxFit.cover),
                                          ),
                                          child: Stack(
                                            children: [
                                              CustomImageView(
                                                imagePath: ImageConstant.imgCowbreed44x44,
                                                height: getSize(44),
                                                width: getSize(44),
                                                radius: BorderRadius.circular(getHorizontalSize(22)),
                                                alignment: Alignment.bottomLeft,
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
                            const SizedBox(width: 20),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    AppRoutes.addMilkScreen,
                                    arguments: {
                                      'id': dashboardController.milkController.cowList[0].id,
                                      'tagId': dashboardController.milkController.cowList[0].tagId,
                                      'calfName': dashboardController.milkController.cowList[0].calfName,
                                      'index': 0,
                                    },
                                  );
                                },
                                child: Container(
                                  margin: getMargin(right: 16),
                                  decoration: AppDecoration.fillDeeppurple300.copyWith(borderRadius: BorderRadiusStyle.roundedBorder30),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: getPadding(left: 20, top: 20),
                                        child: Text(
                                          "".tr,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtOutfitRegular15,
                                        ),
                                      ),
                                      Padding(
                                        padding: getPadding(left: 16, top: 1),
                                        child: Text(
                                          "Add Milk".tr,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtOutfitMedium25,
                                        ),
                                      ),
                                      Card(
                                        clipBehavior: Clip.antiAlias,
                                        elevation: 0,
                                        margin: getMargin(top: 17),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadiusStyle.roundedBorder30),
                                        child: Container(
                                          height: getVerticalSize(84),
                                          width: getHorizontalSize(110),
                                          padding: getPadding(left: 29, top: 15, right: 29, bottom: 15),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadiusStyle.roundedBorder30,
                                            image: DecorationImage(image: fs.Svg(ImageConstant.imgGroup7), fit: BoxFit.cover),
                                          ),
                                          child: Stack(children: [Image(image: AssetImage(ImageConstant.imgGear1))]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: getMargin(right: 5),
                        padding: getPadding(left: 13, top: 12, right: 13, bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xff9F81E0),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(color: Colors.grey.shade400, offset: const Offset(0.0, 4.0), blurRadius: 10), //BoxShadow
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgMilkcan1,
                              height: getVerticalSize(135),
                              width: getHorizontalSize(125),
                              margin: getMargin(bottom: 4),
                            ),
                            Obx(() {
                              switch (dashboardController.dataStatus.value) {
                                case DataStatus.loading:
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text(
                                          "Loading...".tr,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  );
                                case DataStatus.error:
                                  return Column(children: const [Center(child: Text("ERROR"))]);
                                case DataStatus.done:
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: getPadding(left: 0, top: 0),
                                        child: Text(
                                          "Morning Milk Yield",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: ColorConstant.whiteA700,
                                            fontSize: getFontSize(25),
                                            fontFamily: 'Outfit',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: getPadding(top: 1),
                                        child: Text(
                                          "${dashboardController.todaysMilk.value}L",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtOutfitLight55,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "lbl_from".tr,
                                            style: TextStyle(
                                              color: ColorConstant.whiteA700,
                                              fontSize: getFontSize(20),
                                              fontFamily: 'Outfit',
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Text(
                                            dashboardController.milkingCows.value,
                                            style: const TextStyle(color: Color(0xff583c93), fontSize: 19, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            " Milking cows",
                                            style: TextStyle(
                                              color: ColorConstant.whiteA700,
                                              fontSize: getFontSize(22),
                                              fontFamily: 'Outfit',
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                              }
                            }),
                          ],
                        ),
                      ),
                      Obx(() {
                        return dashboardController.reminderData.isTrue
                            ? Column(
                                children: [
                                  PrefUtils.getUserType == 1 ||
                                          PrefUtils.getUserType == 2 ||
                                          PrefUtils.getUserType == 3 ||
                                          PrefUtils.getUserType == 4 ||
                                          PrefUtils.getUserType == 5
                                      ? dashboardController.getReminderData!.pendingMedicationsObj.content == "0"
                                            ? const SizedBox()
                                            : Padding(
                                                padding: const EdgeInsets.only(top: 20),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Get.toNamed(AppRoutes.medicationScreen);
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(18),
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xffE6A4B4),
                                                      borderRadius: BorderRadius.circular(40),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey.shade400,
                                                          offset: const Offset(0.0, 4.0),
                                                          blurRadius: 10,
                                                        ), //BoxShadow
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        const Padding(
                                                          padding: EdgeInsets.only(right: 10),
                                                          child: Image(image: AssetImage('assets/images/medication action.png'), height: 40),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '${dashboardController.getReminderData!.pendingMedicationsObj.content} ',
                                                              style: const TextStyle(color: Color(0xffAf2655), fontSize: 18, fontFamily: 'Outfit'),
                                                            ),
                                                            const Text(
                                                              'Cows need medication action',
                                                              style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Outfit'),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                      : const SizedBox(),
                                  PrefUtils.getUserType == 1 ||
                                          PrefUtils.getUserType == 2 ||
                                          PrefUtils.getUserType == 3 ||
                                          PrefUtils.getUserType == 5 ||
                                          PrefUtils.getUserType == 6 ||
                                          PrefUtils.getUserType == 7
                                      ? dashboardController.getReminderData!.getPendingMilkingCowsObj.content.isEmpty
                                            ? const SizedBox()
                                            : Padding(
                                                padding: const EdgeInsets.only(top: 20),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    await dashboardController.milkController.lastSevenDayMilkData();
                                                    Future.delayed(const Duration(seconds: 2), () {
                                                      Get.toNamed(AppRoutes.milkScreen);
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(18),
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xffAAD7D9).withOpacity(0.8),
                                                      borderRadius: BorderRadius.circular(40),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey.shade400,
                                                          offset: const Offset(0.0, 4.0),
                                                          blurRadius: 10,
                                                        ), //BoxShadow
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        const Padding(
                                                          padding: EdgeInsets.only(right: 10),
                                                          child: Image(image: AssetImage('assets/images/pendingCow.png'), height: 40),
                                                        ),
                                                        Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                const Text(
                                                                  'Morning ',
                                                                  style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Outfit'),
                                                                ),
                                                                Text(
                                                                  dashboardController.getReminderData!.getPendingMilkingCowsObj.content.split('-')[0],
                                                                  style: const TextStyle(
                                                                    color: Color(0xff0766AD),
                                                                    fontSize: 18,
                                                                    fontFamily: 'Outfit',
                                                                  ),
                                                                ),
                                                                const Text(
                                                                  ' pending milking cows',
                                                                  style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Outfit'),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Text(
                                                                  'Evening ',
                                                                  style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Outfit'),
                                                                ),
                                                                Text(
                                                                  dashboardController.getReminderData!.getPendingMilkingCowsObj.content.split('-')[1],
                                                                  style: const TextStyle(
                                                                    color: Color(0xff0766AD),
                                                                    fontSize: 18,
                                                                    fontFamily: 'Outfit',
                                                                  ),
                                                                ),
                                                                const Text(
                                                                  ' pending milking cows',
                                                                  style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Outfit'),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                      : const SizedBox(),
                                  PrefUtils.getUserType == 1 || PrefUtils.getUserType == 2 || PrefUtils.getUserType == 3 || PrefUtils.getUserType == 5
                                      ? dashboardController.getReminderData!.stockOutObj.content.isEmpty
                                            ? const SizedBox()
                                            : ReminderContainer(
                                                image: 'assets/images/stock.png',
                                                text: dashboardController.getReminderData!.stockOutObj.content,
                                                height: 40,
                                                textColor: Colors.white,
                                                boxColor: const Color(0xffFECDA6),
                                                onTap: () {
                                                  Get.to(const StockOutScreen());
                                                },
                                              )
                                      : const SizedBox(),
                                  PrefUtils.getUserType == 1 ||
                                          PrefUtils.getUserType == 2 ||
                                          PrefUtils.getUserType == 3 ||
                                          PrefUtils.getUserType == 4 ||
                                          PrefUtils.getUserType == 5
                                      ? (dashboardController.getReminderData!.pendingVaccinesObj != null &&
                                                dashboardController.getReminderData!.pendingVaccinesObj!.content != "0" &&
                                                dashboardController.getReminderData!.pendingVaccinesObj!.content.isNotEmpty)
                                            ? ReminderContainer(
                                                image: 'assets/images/vaccine 1.png',
                                                text: '${dashboardController.getReminderData!.pendingVaccinesObj!.content} Cows pending vaccines',
                                                height: 40,
                                                textColor: Colors.white,
                                                boxColor: const Color(0xff91C8E4),
                                                onTap: () {
                                                  Get.toNamed(AppRoutes.vaccineReminderScreen);
                                                },
                                              )
                                            : const SizedBox()
                                      : const SizedBox(),
                                ],
                              )
                            : const SizedBox();
                      }),
                      PrefUtils.getUserType == 1 ||
                              PrefUtils.getUserType == 2 ||
                              PrefUtils.getUserType == 3 ||
                              PrefUtils.getUserType == 4 ||
                              PrefUtils.getUserType == 5 ||
                              PrefUtils.getUserType == 7
                          ? const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 20),
                              child: Text('Cow', style: TextStyle(fontSize: 22, fontFamily: 'Outfit')),
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PrefUtils.getUserType == 1 ||
                                        PrefUtils.getUserType == 2 ||
                                        PrefUtils.getUserType == 3 ||
                                        PrefUtils.getUserType == 4 ||
                                        PrefUtils.getUserType == 5 ||
                                        PrefUtils.getUserType == 7
                                    ? DashboardView(
                                        text: 'All cattle',
                                        image: 'assets/images/cow.png',
                                        onTap: () {
                                          moduleEnum = ModuleEnum.cowsScreen;
                                          Get.toNamed(AppRoutes.cowsScreen);
                                        },
                                        padding: 5,
                                      )
                                    : const SizedBox(),
                                PrefUtils.getUserType == 1 ||
                                        PrefUtils.getUserType == 2 ||
                                        PrefUtils.getUserType == 3 ||
                                        PrefUtils.getUserType == 4 ||
                                        PrefUtils.getUserType == 5 ||
                                        PrefUtils.getUserType == 7
                                    ? DashboardView(
                                        text: 'Add cattle',
                                        image: 'assets/images/AddCattle.png',
                                        onTap: () {
                                          Get.toNamed(AppRoutes.addNewCow, arguments: {'isChildEntry': false});
                                        },
                                        padding: 15,
                                      )
                                    : const SizedBox(),
                                PrefUtils.getUserType == 1 ||
                                        PrefUtils.getUserType == 2 ||
                                        PrefUtils.getUserType == 3 ||
                                        PrefUtils.getUserType == 4 ||
                                        PrefUtils.getUserType == 5 ||
                                        PrefUtils.getUserType == 7
                                    ? DashboardView(
                                        text: 'shed count',
                                        image: 'assets/images/shedCount.png',
                                        onTap: () {
                                          moduleEnum = ModuleEnum.shedCountingScreen;
                                          Get.toNamed(AppRoutes.shedCounting);
                                        },
                                        padding: 15,
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            /*                            PrefUtils.getUserType == 2
                                ? DashboardView(
                                    text: 'Cow Report',
                                    image: 'assets/images/CowReport.png',
                                    onTap: () {
                                      Get.toNamed(AppRoutes.sairDetailScreen);
                                    },
                                    padding: 12,
                                  )
                                : const SizedBox(),*/
                          ],
                        ),
                      ),
                      PrefUtils.getUserType == 1 ||
                              PrefUtils.getUserType == 2 ||
                              PrefUtils.getUserType == 3 ||
                              PrefUtils.getUserType == 5 ||
                              PrefUtils.getUserType == 6 ||
                              PrefUtils.getUserType == 7
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(color: Colors.grey.shade200),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 20),
                                  child: Text('Milk', style: TextStyle(fontSize: 22, fontFamily: 'Outfit')),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PrefUtils.getUserType == 1 ||
                                    PrefUtils.getUserType == 2 ||
                                    PrefUtils.getUserType == 3 ||
                                    PrefUtils.getUserType == 5 ||
                                    PrefUtils.getUserType == 6 ||
                                    PrefUtils.getUserType == 7
                                ? DashboardView(
                                    text: 'Add milk',
                                    image: 'assets/images/addMilk.png',
                                    onTap: () {
                                      Get.toNamed(
                                        AppRoutes.addMilkScreen,
                                        arguments: {
                                          'id': dashboardController
                                              .milkController
                                              .cowList[dashboardController.milkController.getFirstMilkingCowIndex()]
                                              .id,
                                          'tagId': dashboardController
                                              .milkController
                                              .cowList[dashboardController.milkController.getFirstMilkingCowIndex()]
                                              .tagId,
                                          'calfName': dashboardController
                                              .milkController
                                              .cowList[dashboardController.milkController.getFirstMilkingCowIndex()]
                                              .calfName,
                                          'index': dashboardController.milkController.getFirstMilkingCowIndex(),
                                        },
                                      );
                                    },
                                    padding: 15,
                                  )
                                : const SizedBox(),
                            PrefUtils.getUserType == 1 ||
                                    PrefUtils.getUserType == 2 ||
                                    PrefUtils.getUserType == 3 ||
                                    PrefUtils.getUserType == 5 ||
                                    PrefUtils.getUserType == 6 ||
                                    PrefUtils.getUserType == 7
                                ? DashboardView(
                                    text: 'Milk data',
                                    image: 'assets/images/Milkdata.png',
                                    onTap: () {
                                      dashboardController.milkController.lastSevenDayMilkData();
                                      Future.delayed(const Duration(seconds: 2), () {
                                        Get.toNamed(AppRoutes.milkScreen);
                                      });
                                    },
                                    padding: 15,
                                  )
                                : const SizedBox(),
                            PrefUtils.getUserType == 1 ||
                                    PrefUtils.getUserType == 2 ||
                                    PrefUtils.getUserType == 3 ||
                                    PrefUtils.getUserType == 5 ||
                                    PrefUtils.getUserType == 6
                                ? DashboardView(
                                    text: 'Dairy Usage',
                                    image: 'assets/images/DairyUsageIcon.png',
                                    onTap: () {
                                      dashboardController.cmDashBoardData();
                                      dashboardController.getReminders();
                                      Get.toNamed(
                                        AppRoutes.dairyUsageScreen,
                                        arguments: {
                                          'todaysMilk': dashboardController.dashBoardDataResponse?.data.todaysMilk.toStringAsFixed(1) ?? '',
                                          'todayMilkUsage': dashboardController.dashBoardDataResponse?.data.todayMilkUsage.toStringAsFixed(1) ?? '',
                                        },
                                      );
                                    },
                                    padding: 15,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      PrefUtils.getUserType == 1 ||
                              PrefUtils.getUserType == 2 ||
                              PrefUtils.getUserType == 3 ||
                              PrefUtils.getUserType == 5 ||
                              PrefUtils.getUserType == 6
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(color: Colors.grey.shade200),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 20),
                                  child: Text('Stock & Sales', style: TextStyle(fontSize: 22, fontFamily: 'Outfit')),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PrefUtils.getUserType == 1 ||
                                    PrefUtils.getUserType == 2 ||
                                    PrefUtils.getUserType == 3 ||
                                    PrefUtils.getUserType == 5 ||
                                    PrefUtils.getUserType == 6
                                ? DashboardView(
                                    text: 'Add Sales',
                                    image: 'assets/images/addSales.png',
                                    onTap: () {
                                      Get.toNamed(AppRoutes.sealsEntry);
                                    },
                                    padding: 15,
                                  )
                                : const SizedBox(),
                            PrefUtils.getUserType == 1 || PrefUtils.getUserType == 2 || PrefUtils.getUserType == 3 || PrefUtils.getUserType == 5
                                ? DashboardView(
                                    text: 'Add Stock',
                                    image: 'assets/images/addStock.png',
                                    onTap: () {
                                      Get.toNamed(AppRoutes.expenseScreen);
                                    },
                                    padding: 15,
                                  )
                                : const SizedBox(),
                            PrefUtils.getUserType == 1 || PrefUtils.getUserType == 2 || PrefUtils.getUserType == 3 || PrefUtils.getUserType == 5
                                ? DashboardView(
                                    text: 'Stock out',
                                    image: 'assets/images/stockOut.png',
                                    onTap: () {
                                      Get.to(const StockOutScreen());
                                    },
                                    padding: 15,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      PrefUtils.getUserType == 1 ||
                              PrefUtils.getUserType == 2 ||
                              PrefUtils.getUserType == 3 ||
                              PrefUtils.getUserType == 4 ||
                              PrefUtils.getUserType == 5
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(color: Colors.grey.shade200),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 20),
                                  child: Text('Medication', style: TextStyle(fontSize: 22, fontFamily: 'Outfit')),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Wrap(
                                    spacing: 16,
                                    runSpacing: 8,
                                    alignment: WrapAlignment.spaceBetween,
                                    children: [
                                      DashboardView(
                                        text: 'Add medication',
                                        image: 'assets/images/addMedication.png',
                                        onTap: () {
                                          Get.toNamed(AppRoutes.addVaccineScreen);
                                        },
                                        padding: 15,
                                      ),
                                      DashboardView(
                                        text: 'Medication data',
                                        image: 'assets/images/MedicationData.png',
                                        onTap: () {
                                          Get.toNamed(AppRoutes.medicationScreen);
                                        },
                                        padding: 15,
                                      ),
                                      DashboardView(
                                        text: 'Vaccine Reminder',
                                        image: 'assets/images/vaccine 1.png',
                                        onTap: () {
                                          Get.toNamed(AppRoutes.vaccineReminderScreen);
                                        },
                                        padding: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      PrefUtils.getUserType == 1 || PrefUtils.getUserType == 2 || PrefUtils.getUserType == 3 || PrefUtils.getUserType == 5
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(color: Colors.grey.shade200),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 20),
                                  child: Text('HR', style: TextStyle(fontSize: 22, fontFamily: 'Outfit')),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      DashboardView(
                                        text: 'Attendance',
                                        image: 'assets/images/Attendance.png',
                                        onTap: () {
                                          moduleEnum = ModuleEnum.attendance;
                                          Get.toNamed(AppRoutes.attendance);
                                        },
                                        padding: 15,
                                      ),
                                      DashboardView(
                                        text: 'HR',
                                        image: 'assets/images/HR.png',
                                        onTap: () {
                                          moduleEnum = ModuleEnum.hr;
                                          Get.toNamed(AppRoutes.hr);
                                        },
                                        padding: 15,
                                      ),
                                      DashboardBlankView(),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget ReminderContainer({
    required String image,
    required String text,
    required double height,
    required Color textColor,
    required Color boxColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(color: Colors.grey.shade400, offset: const Offset(0.0, 4.0), blurRadius: 10), //BoxShadow
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Image(image: AssetImage(image), height: height),
              ),
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: 15, fontFamily: 'Outfit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget DashboardView({required String text, required String image, required double padding, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(offset: const Offset(2.0, 3.0), color: Colors.grey.shade300, blurRadius: 8), //BoxShadow
              ],
            ),
            child: Image(image: AssetImage(image)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontFamily: 'Outfit'),
            ),
          ),
        ],
      ),
    );
  }

  Widget DashboardBlankView() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Text('', style: TextStyle(fontSize: 15, fontFamily: 'Outfit')),
        ),
      ],
    );
  }
}
