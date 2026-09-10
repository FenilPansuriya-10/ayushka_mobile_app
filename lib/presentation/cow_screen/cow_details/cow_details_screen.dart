import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cattle_app/core/app_export.dart';
import 'package:cattle_app/presentation/cow_screen/cow_details/cow_details_controller.dart';
import 'package:cattle_app/widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/rich_text.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
class CowDetailScreen extends GetView<CowsDetailScreenController> {
  CowDetailScreen({Key? key}) : super(key: key);

  String convertDateFormat({required String date}) {
    try {
      DateTime inputDate = DateFormat("yyyy-MM-dd").parse(date);
      String formattedDate = DateFormat("dd-MM-yyyy").format(inputDate);
      return formattedDate;
    } catch (e) {
      return date;
    }
  }

  Widget infoTextview({
    required String text,
    required String totalMilk,
    required double fontSize,
    required double fontSize1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          text,
          style: TextStyle(color: Colors.black54, fontSize: fontSize),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.orange.withOpacity(0.2)),
          child: Text(
            totalMilk,
            style: TextStyle(
                color: const Color(0xffE46E00),
                fontSize: fontSize1,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // Generates PDF report and opens a preview with download/share options
  // Observable list of selected sections for PDF
  final RxList<String> _selectedPdfSections = <String>['Milk', 'Medical', 'Family', 'Children'].obs;

  // Show dialog with checkboxes to pick sections and then preview PDF
  Future<void> _showPdfOptionsDialog() async {
    await showDialog(
      context: Get.context!,
      builder: (_) {
        return AlertDialog(
          title: const Text('Select PDF Sections'),
          content: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Milk', 'Medical', 'Family', 'Children'].map((section) {
              return CheckboxListTile(
                title: Text(section),
                value: _selectedPdfSections.contains(section),
                onChanged: (bool? value) {
                  if (value == true) {
                    if (!_selectedPdfSections.contains(section)) _selectedPdfSections.add(section);
                  } else {
                    _selectedPdfSections.remove(section);
                  }
                },
              );
            }).toList(),
          )),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
                onPressed: () async {
                  Get.back();
                  await showDialog(
                    context: Get.context!,
                    builder: (_) => Dialog(
                      insetPadding: const EdgeInsets.all(20),
                      child: Container(
                        width: double.infinity,
                        height: 500,
                        padding: const EdgeInsets.all(10),
                        child: PdfPreview(
                          build: (format) async => _buildPdf(format),
                          pageFormats: {'A4': PdfPageFormat.a4},
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('Preview'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Get.back();
                  await _downloadPdf();
                },
                child: const Text('Download'),
              ),
          ],
        );
      },
    );
  }
  Future<Uint8List> _buildPdf(PdfPageFormat format) async {
    // Build PDF document with selected sections

    final cow = controller.foundCow!;
    final pdf = pw.Document();
    final logoBytes = (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List();
    final logoImage = pw.MemoryImage(logoBytes);
    pdf.addPage(pw.MultiPage(
      pageFormat: format,
      margin: const pw.EdgeInsets.all(24),
      header: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(child: pw.Image(logoImage, height: 60)),
          pw.SizedBox(height: 10),
          pw.Text('Cow Report', style:  pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),
        ],
      ),
      footer: (pw.Context context) => pw.Container(
        alignment: pw.Alignment.centerRight,
        margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
        child: pw.Text('Page ${context.pageNumber} of ${context.pagesCount}', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey)),
      ),
      build: (pw.Context context) => [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Tag ID: ${cow.tagId}'),
            pw.Text('Name: ${cow.calfName}'),
            pw.Text('Breed: ${cow.breed}'),
            pw.Text('Age: ${controller.calculateAgeFromString(cow.dob)} years'),
            pw.Text('Type: ${cow.type}'),
            pw.SizedBox(height: 10),
            if (_selectedPdfSections.contains('Milk')) ...[
              pw.Text('Milk Information', style: const pw.TextStyle(decoration: pw.TextDecoration.underline)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: const ['Metric', 'Value (L)'],
                data: [
                  ['Total Milk', controller.totalMilk.value.toStringAsFixed(1)],
                  ['Current Year', controller.currentYearTotalMilk.value.toStringAsFixed(1)],
                  ['Last Year', controller.lastYearTotalMilk.value.toStringAsFixed(1)],
                ],
              ),
              pw.SizedBox(height: 10),
            ],
            if (_selectedPdfSections.contains('Medical')) ...[
              pw.Text('Medical Information', style: const pw.TextStyle(decoration: pw.TextDecoration.underline)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: const ['Type', 'Date', 'Dose', 'Status', 'Remark'],
                data: controller.MedicineData.map((med) => [
                  med.type,
                  convertDateFormat(date: med.nextDoseTime),
                  '${med.heatAttempt}/${med.dose}',
                  med.status,
                  med.remark,
                ]).toList(),
              ),
              pw.SizedBox(height: 10),
            ],
            if (_selectedPdfSections.contains('Family')) ...[
              pw.Text('Family', style: const pw.TextStyle(decoration: pw.TextDecoration.underline)),
              pw.Text('Dam: ${cow.damId}-${cow.damName}'),
              pw.Text('Sire: ${cow.sairId}-${cow.sairName}'),
              pw.SizedBox(height: 10),
            ],
            if (_selectedPdfSections.contains('Children')) ...[
              pw.Text('Children', style: const pw.TextStyle(decoration: pw.TextDecoration.underline)),
              pw.SizedBox(height: 10),
              controller.childrenHierarchyResponse?.childrenData != null && controller.childrenHierarchyResponse!.childrenData.isNotEmpty
                  ? pw.Table.fromTextArray(
                      headers: const ['Tag ID', 'Name', 'Breed', 'Gender'],
                      data: controller.childrenHierarchyResponse!.childrenData.map((child) => [
                        child.cowId,
                        child.calfName,
                        child.breed,
                        child.gender,
                      ]).toList(),
                    )
                  : pw.Text('No children data available.'),
              pw.SizedBox(height: 10),
            ],
          ],
        ),
      ],
    ));
    return await pdf.save();
  }

  // Generates PDF and saves it to device storage, then shares the file for download
  Future<void> _downloadPdf() async {
    try {
      final pdfData = await _buildPdf(PdfPageFormat.a4);
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/${controller.foundCow!.tagId}_report.pdf';
      final file = File(filePath);
      await file.writeAsBytes(pdfData);
      // Share the PDF file to allow user to download/save/share
      await Printing.sharePdf(bytes: pdfData, filename: '${controller.foundCow!.tagId}_report.pdf');
      Get.snackbar('Success', 'PDF saved to $filePath');
    } catch (e) {
      Get.snackbar('Error', 'Failed to download PDF: $e');
    }
  }

  Widget _buildNoDataWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            "NO DATA FOUND",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "No record found for this cow.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Scaffold(
          appBar: CustomAppBar(
            height: 60,
            centerTitle: true,
            leadingIconOnTap: () {
              Get.back();
            },
            leadingIcon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            title: controller.dataStatus.value == DataStatus.done && controller.foundCow != null
                ? '${controller.foundCow!.tagId} : ${controller.foundCow!.calfName}'
                : 'Cow Details',
            styleType: Style.bgFillBluegray900,
            actions: controller.dataStatus.value == DataStatus.done && controller.foundCow != null
                ? [
                    InkWell(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.editCowDetailsScreen,
                          arguments: {
                            'tagId': controller.foundCow!.tagId,
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Image(
                          image: AssetImage(ImageConstant.editIcon),
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await _showPdfOptionsDialog();
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.picture_as_pdf, color: Colors.white, size: 30),
                      ),
                    ),
                  ]
                : null,
          ),
          body: () {
            switch (controller.dataStatus.value) {
              case DataStatus.loading:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [Center(child: CircularProgressIndicator())],
                );
              case DataStatus.error:
                return _buildNoDataWidget();
              case DataStatus.done:
                if (controller.foundCow == null) {
                  return _buildNoDataWidget();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              stops: [0.0, 1.0],
                              colors: [
                                Color(0xffFFAF4D),
                                Color(0xffFFBFBF),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    controller.foundCow!.breed,
                                    style: const TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                const Image(
                                  image: AssetImage('assets/images/Group 109.png'),
                                  height: 70,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${controller.foundCow!.tagId} : ${controller.foundCow!.calfName}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    controller.foundCow!.shedId,
                                    style: const TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    controller.foundCow!.type,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  Text(
                                    '${controller.calculateAgeFromString(controller.foundCow!.dob)} year',
                                    style: const TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    CowDetailList(
                      text: 'DameID : ',
                      richText: "${controller.foundCow!.damId}-${controller.foundCow!.damName}",
                    ),
                    CowDetailList(
                      text: 'SairID : ',
                      richText: "${controller.foundCow!.sairId}-${controller.foundCow!.sairName}",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.familyHierarchy);
                        },
                        child: Row(
                          children: const [
                            Image(
                              image: AssetImage('assets/images/family.png'),
                              height: 35,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Family Hierarchy',
                                style: TextStyle(
                                  color: Color(0xff2973D9),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.childrenHierarchy);
                        },
                        child: Row(
                          children: const [
                            Image(
                              image: AssetImage('assets/images/family.png'),
                              height: 35,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Children Hierarchy',
                                style: TextStyle(
                                  color: Color(0xff2973D9),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Divider(
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
                              child: const Text(
                                'Milk Information',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Container(
                                margin: getMargin(right: 5),
                                padding: getPadding(left: 13, top: 12, right: 13, bottom: 12),
                                decoration: BoxDecoration(
                                    color: Colors.orangeAccent.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomImageView(
                                      imagePath: ImageConstant.imgMilkcan1,
                                      height: getVerticalSize(110),
                                      width: getHorizontalSize(100),
                                      margin: getMargin(bottom: 4),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Total milk yield',
                                          style: TextStyle(color: Colors.black54, fontSize: 16),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Colors.orange.withOpacity(0.2)),
                                          child: Text(
                                            '${controller.totalMilk.value.toStringAsFixed(1)}L',
                                            style: const TextStyle(
                                                color: Color(0xffE46E00),
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        infoTextview(
                                          text: '${DateFormat('yyyy').format(DateTime.now())} milk yield',
                                          totalMilk: '${controller.currentYearTotalMilk.value.toStringAsFixed(1)}L',
                                          fontSize: 14,
                                          fontSize1: 16,
                                        ),
                                        infoTextview(
                                          text: '${DateFormat('yyyy').format(DateTime.now().subtract(const Duration(days: 365)))} milk yield',
                                          totalMilk: '${controller.lastYearTotalMilk.value.toStringAsFixed(1)}L',
                                          fontSize: 14,
                                          fontSize1: 16,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Divider(
                                color: Colors.grey.withOpacity(0.3),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, bottom: 10),
                              child: const Text(
                                'Medical Information',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 200,
                              child: Obx(() {
                                switch (controller.milkInfoStatus.value) {
                                  case MilkInfoStatus.loading:
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: const [
                                        Center(child: CircularProgressIndicator())
                                      ],
                                    );
                                  case MilkInfoStatus.error:
                                    return const Center(
                                      child: Text("NO DATA FOUND", style: TextStyle(fontSize: 20)),
                                    );
                                  case MilkInfoStatus.done:
                                    return controller.MedicineData.isEmpty
                                        ? const Center(
                                            child: Text(
                                              "NO DATA FOUND",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        : ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: controller.MedicineData.length,
                                            itemBuilder: (context, index) {
                                              final medItem = controller.MedicineData[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(left: 15, right: 15),
                                                child: Container(
                                                  width: 250,
                                                  decoration: BoxDecoration(
                                                      color: Colors.orangeAccent.withOpacity(0.1),
                                                      borderRadius: BorderRadius.circular(8)),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              medItem.type == 'VACCINE'
                                                                  ? '${medItem.vacName}'
                                                                  : '${medItem.type}',
                                                              style: const TextStyle(
                                                                color: Color(0xffE46E00),
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.bold,
                                                               ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment.topRight,
                                                              child: Image(
                                                                image: AssetImage(medItem.type == 'VACCINE'
                                                                    ? 'assets/images/vaccine.png'
                                                                    : medItem.type == 'HEAT'
                                                                        ? 'assets/images/heatCow.png'
                                                                        : 'assets/images/medicine.png'),
                                                                height: 35,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            CowDetailWidget(
                                                              text: convertDateFormat(date: medItem.nextDoseTime),
                                                              images: 'assets/images/date.png',
                                                            ),
                                                            Text(
                                                              '${medItem.heatAttempt}/${medItem.dose}',
                                                              style: const TextStyle(
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 20),
                                                            ),
                                                          ],
                                                        ),
                                                        CowDetailWidget(
                                                          text: '${medItem.status}',
                                                          images: 'assets/images/running.png',
                                                        ),
                                                        CowDetailWidget(
                                                          text: '${medItem.remark}',
                                                          images: 'assets/images/remark.png',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                }
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
            }
          }(),
        ),
      ),
    );
  }
}

class CowDetailWidget extends StatelessWidget {
  const CowDetailWidget({Key? key, required this.text, required this.images}) : super(key: key);

  final String text;
  final String images;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Image(
            image: AssetImage(images),
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              text,
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class CowDetailList extends StatelessWidget {
  const CowDetailList({Key? key, required this.text, required this.richText}) : super(key: key);

  final String text;
  final String richText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: CattleRichText(
        text: text,
        richText: richText,
        color: Colors.black54,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
