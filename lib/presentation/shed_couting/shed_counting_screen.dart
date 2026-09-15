// ignore_for_file: must_be_immutable

import 'package:cattle_app/presentation/milk_screen/controller/milk_controller.dart';
import 'package:cattle_app/presentation/shed_couting/shed_counting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../cow_screen/cow_controller.dart';
import '../milk_screen/models/cowList_res.dart';

class ShedCounting extends GetView<ShedCountingController> {
  const ShedCounting({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          leadingIconOnTap: () {
            Get.back();
          },
          leadingIcon: const Icon(Icons.arrow_back, color: Colors.white),
          actions: [
            IconButton(
              onPressed: () {
                Get.toNamed(AppRoutes.shedTransfer);
              },
              icon: const Icon(Icons.transfer_within_a_station),
              color: Colors.white,
            ),
          ],
          centerTitle: true,
          height: 60,
          title: "Shed Counting",
          styleType: Style.bgFillBluegray900,
        ),
        body: Obx(() {
          if (controller.milkController.dataStatus.value == DataStatusE.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.milkController.dataStatus.value == DataStatusE.error) {
            return const Center(child: Text("Error loading data"));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: const Color(0xffE5F0FF), borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.cowCount().length,
                            itemBuilder: (context, index) {
                              String cowType = controller.cowCount()[index];
                              Map<String, int> cattleTypeCounts = controller.cowTypeData[cowType]!;
                              return _totalCow(cattleTotalCounts: cattleTypeCounts);
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return const Divider();
                            },
                          ),
                          const Divider(height: 15, thickness: 1.5, color: Colors.black54),
                          _textView(text: 'Total Count : ', richText: controller.totalCowCount.toString()),
                        ],
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.shedCount().length,
                  itemBuilder: (context, index) {
                    String shedId = controller.shedCount()[index];
                    Map<String, int> cattleCounts = controller.shedData[shedId]!;

                    return _shedCountingWidget(cattleCounts: cattleCounts, shedId: shedId, cowList: controller.getCowListForShed(shedId), id: shedId);
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _totalCow({required Map<String, int> cattleTotalCounts}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (cattleTotalCounts['Milking'] != null) _textView(text: 'Milking : ', richText: '${cattleTotalCounts['Milking']}'),
        if (cattleTotalCounts['Milking-Calf-Male'] != null)
          _textView(text: 'Milking Calf Male: ', richText: '${cattleTotalCounts['Milking-Calf-Male']}'),
        if (cattleTotalCounts['Milking-Calf-Female'] != null)
          _textView(text: 'Milking Calf Female: ', richText: '${cattleTotalCounts['Milking-Calf-Female']}'),
        if (cattleTotalCounts['Milking-Pregnant'] != null)
          _textView(text: 'Milking Pregnant : ', richText: '${cattleTotalCounts['Milking-Pregnant']}'),
        if (cattleTotalCounts['Pregnant'] != null) _textView(text: 'Pregnant : ', richText: '${cattleTotalCounts['Pregnant']}'),
        if (cattleTotalCounts['Non-Pregnant'] != null) _textView(text: 'Non Pregnant : ', richText: '${cattleTotalCounts['Non-Pregnant']}'),
        if (cattleTotalCounts['FirstTime-Pregnant'] != null)
          _textView(text: 'FirstTime Pregnant : ', richText: '${cattleTotalCounts['FirstTime-Pregnant']}'),
        if (cattleTotalCounts['BreedingBull'] != null) _textView(text: 'BreedingBull : ', richText: '${cattleTotalCounts['BreedingBull']}'),
        if (cattleTotalCounts['Bull'] != null) _textView(text: 'Bull : ', richText: '${cattleTotalCounts['Bull']}'),
        if (cattleTotalCounts['DryCow'] != null) _textView(text: 'Dry cow : ', richText: '${cattleTotalCounts['DryCow']}'),
        if (cattleTotalCounts['Hipper'] != null) _textView(text: 'Hipper : ', richText: '${cattleTotalCounts['Hipper']}'),
        if (cattleTotalCounts['SevaCow'] != null) _textView(text: 'SevaCow : ', richText: '${cattleTotalCounts['SevaCow']}'),
        if (cattleTotalCounts['Donate'] != null) _textView(text: 'Donate : ', richText: '${cattleTotalCounts['Donate']}'),
        if (cattleTotalCounts['Died'] != null) _textView(text: 'Died : ', richText: '${cattleTotalCounts['Died']}'),
        if (cattleTotalCounts['NA'] != null) _textView(text: 'NA : ', richText: '${cattleTotalCounts['NA']}'),
        if (cattleTotalCounts['OtherFarm'] != null) _textView(text: 'OtherFarm : ', richText: '${cattleTotalCounts['OtherFarm']}'),
      ],
    );
  }

  Widget _shedCountingWidget({required Map<String, int> cattleCounts, required String shedId, required List<Datum> cowList, required String id}) {
    return InkWell(
      onTap: () {
        moduleEnum = ModuleEnum.shedCountingScreen;
        print(cattleCounts);
        Get.toNamed(AppRoutes.cowsScreen, arguments: {'shedId': shedId, 'cowList': cowList});
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Container(
          decoration: BoxDecoration(color: const Color(0xffE5F0FF), borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Image(image: AssetImage('assets/images/shed.png'), height: 40),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(shedId, style: const TextStyle(fontSize: 20, color: Colors.black)),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios_sharp, color: Colors.black45),
                  ],
                ),
                const Divider(height: 15, thickness: 1.5, color: Colors.black54),
                if (cattleCounts['Milking'] != null) _textView(text: 'Milking : ', richText: '${cattleCounts['Milking']}'),
                if (cattleCounts['Milking-Calf-Male'] != null)
                  _textView(text: 'Milking Calf Male: ', richText: '${cattleCounts['Milking-Calf-Male']}'),
                if (cattleCounts['Milking-Calf-Female'] != null)
                  _textView(text: 'Milking Calf Female: ', richText: '${cattleCounts['Milking-Calf-Female']}'),
                if (cattleCounts['Milking-Pregnant'] != null) _textView(text: 'Milking Pregnant : ', richText: '${cattleCounts['Milking-Pregnant']}'),
                if (cattleCounts['Pregnant'] != null) _textView(text: 'Pregnant : ', richText: '${cattleCounts['Pregnant']}'),
                if (cattleCounts['Non-Pregnant'] != null) _textView(text: 'Non Pregnant : ', richText: '${cattleCounts['Non-Pregnant']}'),
                if (cattleCounts['FirstTime-Pregnant'] != null)
                  _textView(text: 'FirstTime Pregnant : ', richText: '${cattleCounts['FirstTime-Pregnant']}'),
                if (cattleCounts['BreedingBull'] != null) _textView(text: 'BreedingBull : ', richText: '${cattleCounts['BreedingBull']}'),
                if (cattleCounts['Bull'] != null) _textView(text: 'Bull : ', richText: '${cattleCounts['Bull']}'),
                if (cattleCounts['DryCow'] != null) _textView(text: 'Dry cow : ', richText: '${cattleCounts['DryCow']}'),
                if (cattleCounts['Hipper'] != null) _textView(text: 'Hipper : ', richText: '${cattleCounts['Hipper']}'),
                if (cattleCounts['SevaCow'] != null) _textView(text: 'SevaCow : ', richText: '${cattleCounts['SevaCow']}'),
                if (cattleCounts['Donate'] != null) _textView(text: 'Donate : ', richText: '${cattleCounts['Donate']}'),
                if (cattleCounts['Died'] != null) _textView(text: 'Died : ', richText: '${cattleCounts['Died']}'),
                if (cattleCounts['NA'] != null) _textView(text: 'NA : ', richText: '${cattleCounts['NA']}'),
                if (cattleCounts['OtherFarm'] != null) _textView(text: 'OtherFarm : ', richText: '${cattleCounts['OtherFarm']}'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textView({required String text, required String richText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
        Text(richText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ],
    );
  }
}
