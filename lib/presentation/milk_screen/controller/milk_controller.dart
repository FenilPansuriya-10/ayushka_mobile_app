import 'dart:convert';
import 'dart:typed_data';

import 'package:cattle_app/core/utils/pref_utils.dart';
import 'package:cattle_app/data/apiClient/api_client.dart';
import 'package:cattle_app/data/apiClient/api_methods.dart';
import 'package:cattle_app/presentation/milk_screen/models/cowList_res.dart';
import 'package:cattle_app/presentation/milk_screen/models/milk_history_response.dart';
import 'package:cattle_app/presentation/milk_screen/models/milk_model.dart';
import 'package:cattle_app/presentation/milk_screen/models/milk_report/milk_report_request.dart';
import 'package:cattle_app/presentation/milk_screen/models/milk_report/milk_report_response.dart';
import 'package:cattle_app/widgets/loder.dart';
import 'package:cattle_app/widgets/toast_message/toast_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../chart_page.dart';

enum DataStatusE { loading, done, error }

class MilkController extends GetxController {
  Rx<MilkModel> milkModelObj = MilkModel().obs;

  Rx<DataStatusE> dataStatus = DataStatusE.loading.obs;

  RxList<String> sort = <String>[].obs;

  // New observable to track report type selection: 'Shed' or 'Employee'
  RxString reportMode = 'Shed'.obs;

  // Helper to change report mode
  void setReportMode(String mode) => reportMode.value = mode;

  CowListRes? cowListRes;

  Data? cowData;

  MilkHistory? milkHistory;

  List<Datum> cowList = [];

  bool isNaObjAdded = true;

  RxDouble morningLiters = 0.0.obs;

  RxDouble eveningLiters = 0.0.obs;

  RxInt totalEveningCow = 0.obs;

  RxInt totalMorningCow = 0.obs;

  RxString girCow = ''.obs;

  RxString otherCow = ''.obs;

  RxString totalMilkingCow = ''.obs;

  RxList<MilkDatum> cowsMilkData = <MilkDatum>[].obs;

  RxList<SummaryDatum> cowsSummaryData = <SummaryDatum>[].obs;
  RxList<PendingCow> pendingCowData = <PendingCow>[].obs;

  RxList pendingMorningCows = [].obs;

  RxList pendingEveningCows = [].obs;

  RxBool pendingMorningCow = false.obs;

  RxBool pendingEveningCow = false.obs;

  RxBool toDayCow = false.obs;

  RxBool toDayDate = false.obs;

  RxString Date = '0'.obs;

  TextEditingController milkReportStartDateController = TextEditingController();
  TextEditingController milkReportEndDateController = TextEditingController();
  TextEditingController milkReportCowIDController = TextEditingController();

  Future<void> loadMoreData() async {
    update();
  }

  String extractDate(String input) {
    List<String> parts = input.split(':');
    if (parts.length >= 1) {
      return parts[0].trim();
    } else {
      return '';
    }
  }

  void initChartData() {
    if (milkHistory == null || milkHistory!.last7DayMilks.isEmpty) return;
    if (Date.value == "0" || Date.value.split(' : ')[0] == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
      toDayDate.value = true;
      girCow.value = '';
      otherCow.value = '';
      Date.value = milkHistory!.last7DayMilks.last.date;
      if (DateFormat('yyyy-MM-dd').format(DateTime.now()) == Date.value.split(' : ')[0]) {
        toDayCow.value = true;
      } else {
        toDayCow.value = false;
      }
      for (var entry in milkHistory!.last7DayMilks) {
        if (entry.date == extractDate(Date.value)) {
          morningLiters.value = entry.morningMilk;
          eveningLiters.value = entry.eveningMilk;
          totalMorningCow.value = entry.milkingCowsMorning;
          totalEveningCow.value = entry.milkingCowsEvening;
          totalMilkingCow.value = entry.totalMilkingCows;
          girCow.value = entry.totalGirCows;
          otherCow.value = '${int.parse(entry.totalMilkingCows) - int.parse(entry.totalGirCows)}';
        }
      }
      pendingMorningCows.value = milkHistory!.pendingCows.morning;
      pendingEveningCows.value = milkHistory!.pendingCows.evening;
    }
  }

  void updateChartData(String tooltipText) {
    if (milkHistory == null) return;
    girCow.value = '';
    otherCow.value = '';
    Date.value = tooltipText;
    if (DateFormat('yyyy-MM-dd').format(DateTime.now()) == Date.value.split(' : ')[0]) {
      toDayCow.value = true;
    } else {
      toDayCow.value = false;
    }
    for (var entry in milkHistory!.last7DayMilks) {
      if (entry.date == extractDate(Date.value)) {
        morningLiters.value = entry.morningMilk;
        eveningLiters.value = entry.eveningMilk;
        totalMorningCow.value = entry.milkingCowsMorning;
        totalEveningCow.value = entry.milkingCowsEvening;
        totalMilkingCow.value = entry.totalMilkingCows;
        girCow.value = entry.totalGirCows;
        otherCow.value = '${int.parse(entry.totalMilkingCows) - int.parse(entry.totalGirCows)}';
      }
    }
    pendingMorningCows.value = milkHistory!.pendingCows.morning;
    pendingEveningCows.value = milkHistory!.pendingCows.evening;
  }

  @override
  void onInit() {
    cmCowList();
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<ChartData> chartData() {
    Map<String, double> sumByDate = {};

    if (milkHistory != null && milkHistory!.last7DayMilks.isNotEmpty) {
      // Create a map to store sum of liters by date

      for (var milkData in milkHistory!.last7DayMilks) {
        String formattedDate = milkData.date.split(' ')[0]; // Format the date as needed
        double liter = double.parse(milkData.totalMilk.toStringAsFixed(0));

        if (sumByDate.containsKey(formattedDate)) {
          sumByDate[formattedDate] = (sumByDate[formattedDate] ?? 0) + liter;
        } else {
          sumByDate[formattedDate] = liter;
        }
      }
    }

    List<ChartData> chartDataList = [];
    sumByDate.forEach((date, literSum) {
      chartDataList.add(ChartData(date, literSum));
    });
    return chartDataList;
  }

  Future<void> cmCowList() async {
    try {
      final Response response = await WebService.cmPostWithTokenRequest(url: ApiClient.cowListUrl, body: "", token: PrefUtils.getToken.toString());

      var data = jsonDecode(response.data);

      if (response.statusCode == 200 && data['data'] != null) {
        cowListRes = cowListResFromJson(response.data);
        if (cowListRes!.status.toString() == "SUCCESS") {
          cowData = cowListRes!.data;
          cowList = cowData!.data;
          for (var tagId in cowList) {
            if (tagId.tagId != "NA") {
              isNaObjAdded = false;
            }
          }
          if (isNaObjAdded == false) {
            cowList.add(Datum(breed: 'NA', type: "NA", shedId: "NA", tagId: "NA", calfName: "NA", id: "NA", isFemale: false));
            isNaObjAdded = true;
          }
          cowList.sort((a, b) {
            final idA = a.tagId;
            final idB = b.tagId;
            final intA = int.tryParse(idA) ?? double.infinity;
            final intB = int.tryParse(idB) ?? double.infinity;

            if (intA != double.infinity && intB != double.infinity) {
              return intA.compareTo(intB);
            } else if (intA == double.infinity && intB == double.infinity) {
              return idA.compareTo(idB);
            } else {
              return intA == double.infinity ? 1 : -1; // One is int and the other is string
            }
          });
          changeStatus(DataStatusE.done);
          CattleToast.msg(cowListRes!.message);
        } else {
          print("****************status**************************");
          print(cowListRes!.status);
          CattleToast.msg(cowListRes!.status);
          print("****************status**************************");
          changeStatus(DataStatusE.error);
        }
      } else {
        print("*******************statusCode***********************");
        print(response.statusCode);
        CattleToast.msg(response.statusMessage ?? "Error");
        print("*******************statusCode***********************");
        changeStatus(DataStatusE.error);
      }
    } catch (error) {
      print("******************Catch**ERROR**********************");
      print(error.toString());
      CattleToast.msg(error.toString());
      print("********************ERROR**********************");
      changeStatus(DataStatusE.error);
    }
    return;
  }

  int getFirstMilkingCowIndex() {
    for (int i = 0; i < cowList.length; i++) {
      if (cowList[i].type == "Milking") {
        return i; // ✅ Return the index of first "Milking" cow
      }
    }
    return 0; // ✅ Return null if no "Milking" cow found
  }

  Future<MilkHistory?> lastSevenDayMilkData() async {
    try {
      Response response = await WebService.cmGetRequestWithToken(url: ApiClient.milkHistory, body: '', token: PrefUtils.getToken.toString());
      if (response.statusCode == 200) {
        MilkHistoryResponse milkHistoryResponse = await milkHistoryResponseFromJson(response.data);
        milkHistory = milkHistoryResponse.milkHistory;
        CattleToast.msg(milkHistoryResponse.message);
        changeStatus(DataStatusE.done);
        print(response.statusCode);
      } else {
        print("*******************statusCode***********************");
        print(response.statusCode);
        CattleToast.msg(response.statusMessage ?? "Error");
        print("*******************statusCode***********************");
        changeStatus(DataStatusE.error);
      }
    } catch (error) {
      print("******************Catch**ERROR**********************");
      print(error.toString());
      CattleToast.msg(error.toString());
      print("********************ERROR**********************");
      changeStatus(DataStatusE.error);
    }
    return milkHistory;
  }

  String convertDateFormat({required String date}) {
    DateTime inputDate = DateFormat("dd-MM-yyyy").parse(date);

    String formattedDate = DateFormat("yyyy-MM-dd").format(inputDate);

    return formattedDate;
  }

  String milkReportDateFormat({required String date}) {
    DateTime inputDate = DateFormat("yyyy-MM-dd").parse(date);

    String formattedDate = DateFormat("dd-MM-yyyy").format(inputDate);

    return formattedDate;
  }

  Future<void> cowMilkReport() async {
    cowsMilkData.clear();
    cowsSummaryData.clear();
    pendingCowData.clear();
    AppLoader().show();
    final Response response = await WebService.cmPostWithTokenRequest(
      url: ApiClient.cowMilkReport,
      body: milkReportRequestToJson(
        MilkReportRequest(
          startDate: milkReportStartDateController.text.isEmpty
              ? DateFormat('yyyy-MM-dd').format(DateTime.now())
              : convertDateFormat(date: milkReportStartDateController.text),
          endDate: milkReportEndDateController.text.isEmpty
              ? DateFormat('yyyy-MM-dd').format(DateTime.now())
              : convertDateFormat(date: milkReportEndDateController.text),
          cowTagId: milkReportCowIDController.text.isEmpty ? "" : milkReportCowIDController.text,
        ),
      ),
      token: PrefUtils.getToken.toString(),
    );
    // try {
    if (response.statusCode == 200) {
      AppLoader().hide();
      MilkReportResponse milkReportResponse = milkReportResponseFromJson(response.data);
      if (milkReportResponse.milkReportData != null) {
        milkReportResponse.milkReportData!.milkData.sort((a, b) {
          final idA = a.cowTagId;
          final idB = b.cowTagId;
          final intA = int.tryParse(idA) ?? double.infinity;
          final intB = int.tryParse(idB) ?? double.infinity;

          if (intA != double.infinity && intB != double.infinity) {
            return intA.compareTo(intB);
          } else if (intA == double.infinity && intB == double.infinity) {
            return idA.compareTo(idB);
          } else {
            return intA == double.infinity ? 1 : -1; // One is int and the other is string
          }
        });
        cowsMilkData.addAll(milkReportResponse.milkReportData!.milkData);
        cowsSummaryData.addAll(milkReportResponse.milkReportData!.summaryData);
        pendingCowData.addAll(milkReportResponse.milkReportData!.pendingCows);
        checkAddData();
      }
      CattleToast.msg(milkReportResponse.message);
    } else {
      AppLoader().hide();
      print(response.statusCode);
      CattleToast.msg(response.statusMessage ?? "Error");
    }
    // } catch (error) {
    //   AppLoader().hide();
    //   print(error);
    //   CattleToast.msg(error.toString());
    // }
  }

  void checkAddData() {
    AppLoader().show();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppLoader().hide();
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text("PRINT"),
            content: Container(
              height: 500,
              width: 500,
              child: PdfPreview(build: (format) => generatePdf(), initialPageFormat: PdfPageFormat.a4, maxPageWidth: 700, canDebug: false),
            ),
          );
        },
      );
    });
  }

  removeBrekets({required String data}) {
    String formatted = data.substring(1, data.length - 1);

    return formatted;
  }

  Future<Uint8List> generatePdf() async {
    final doc = pw.Document();

    List<String> sortSheds(List<String> keys) {
      keys.sort((a, b) {
        final aNum = int.tryParse(a);
        final bNum = int.tryParse(b);

        if (aNum != null && bNum != null) return aNum.compareTo(bNum);
        if (aNum != null) return -1;
        if (bNum != null) return 1;

        return a.toLowerCase().compareTo(b.toLowerCase());
      });
      return keys;
    }

    Map<String, List<dynamic>> shedGroupedData = {};

    for (var item in cowsMilkData) {
      shedGroupedData.putIfAbsent(item.shedId, () => []);
      shedGroupedData[item.shedId]!.add(item);
    }

    List<String> sortedShedKeys = sortSheds(shedGroupedData.keys.toList());

    doc.addPage(
      pw.MultiPage(
        build: (context) {
          List<List<String>> tableData = [];

          double grandTotalMilk = 0;
          int grandMorningCow = 0;
          int grandEveningCow = 0;
          double grandMorningMilk = 0;
          double grandEveningMilk = 0;

          for (var shedKey in sortedShedKeys) {
            var cows = shedGroupedData[shedKey]!;

            double morningMilk = 0;
            double eveningMilk = 0;
            double totalMilk = 0;

            int morningCowCount = 0;
            int eveningCowCount = 0;

            for (var cow in cows) {
              double m = cow.morning.toDouble();
              double e = cow.evening.toDouble();
              double t = cow.total.toDouble();

              morningMilk += m;
              eveningMilk += e;
              totalMilk += t;

              if (m > 0) {
                morningCowCount++;
              }

              if (e > 0) {
                eveningCowCount++;
              }
            }

            // Grand totals
            grandMorningCow += morningCowCount;
            grandEveningCow += eveningCowCount;
            grandMorningMilk += morningMilk;
            grandEveningMilk += eveningMilk;
            grandTotalMilk += totalMilk;

            tableData.add([
              shedKey,
              morningCowCount.toString(),
              morningMilk.toStringAsFixed(2),
              eveningCowCount.toString(),
              eveningMilk.toStringAsFixed(2),
              totalMilk.toStringAsFixed(2),
            ]);
          }

          /// Grand Total Row
          tableData.add([
            "Grand Total",
            grandMorningCow.toString(),
            grandMorningMilk.toStringAsFixed(2),
            grandEveningCow.toString(),
            grandEveningMilk.toStringAsFixed(2),
            grandTotalMilk.toStringAsFixed(2),
          ]);

          return [
            pw.Center(
              child: pw.Text("Cows Summary", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ['SL', 'Breed', 'Cows Count', 'Total Milk'],
              data: List.generate(
                cowsSummaryData.length,
                (i) => ['${i + 1}', '${cowsSummaryData[i].breed}', '${cowsSummaryData[i].cowsCount}', '${cowsSummaryData[i].milkCount}'],
              ),
              border: pw.TableBorder.all(),
              headerAlignment: pw.Alignment.center,
              cellAlignment: pw.Alignment.center,
            ),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Text("Shed Wise Milk Summary", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ["Shed No", "Total Morning Cow", "Morning Milk", "Total Evening Cow", "Evening Milk", "Total Milk"],
              data: tableData,
              border: pw.TableBorder.all(),
              headerAlignment: pw.Alignment.center,
              cellAlignment: pw.Alignment.center,
            ),
          ];
        },
      ),
    );

    if (reportMode.value == 'Shed') {
      doc.addPage(
        pw.MultiPage(
          build: (context) {
            List<pw.Widget> widgets = [];

            // ==================== MORNING REPORT ====================
            widgets.add(
              pw.Center(
                child: pw.Text("Shed Wise Morning Milk Report", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              ),
            );

            // Group by Date -> Shed (Morning)
            Map<String, Map<String, List<dynamic>>> dateShedMorning = {};
            for (var cow in cowsMilkData) {
              final shed = cow.shedId ?? '-';
              if (cow.morning > 0) {
                final d = cow.date ?? "";
                dateShedMorning.putIfAbsent(d, () => {});
                dateShedMorning[d]!.putIfAbsent(shed, () => []).add(cow);
              }
            }

            var sortedDatesM = dateShedMorning.keys.toList()..sort();
            for (var d in sortedDatesM) {
              var shedMap = dateShedMorning[d]!;
              String formattedDate = d.isNotEmpty ? milkReportDateFormat(date: d) : "";

              var sortedSheds = sortSheds(shedMap.keys.toList());

              for (var shedKey in sortedSheds) {
                var cows = shedMap[shedKey]!;
                cows.sort((a, b) => b.morning.compareTo(a.morning));

                double shedTotal = 0;
                List<List<String>> rows = [];
                for (int i = 0; i < cows.length; i++) {
                  var cow = cows[i];
                  shedTotal += cow.morning;
                  rows.add(['${i + 1}', '${cow.cowTagId}', '${cow.morning}', cow.morningEmployee ?? '-']);
                }
                rows.add(['', '', 'Shed Total', shedTotal.toStringAsFixed(2)]);

                widgets.add(pw.SizedBox(height: 20));
                widgets.add(
                  pw.Text("Shed No : $shedKey    Date : $formattedDate", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15)),
                );
                widgets.add(pw.SizedBox(height: 10));
                widgets.add(
                  pw.Table.fromTextArray(
                    headers: ['SL', 'Cow ID', 'Morning', 'M. Emp'],
                    data: rows,
                    border: pw.TableBorder.all(),
                    headerAlignment: pw.Alignment.center,
                    cellAlignment: pw.Alignment.center,
                  ),
                );
              }
            }

            widgets.add(pw.SizedBox(height: 30));

            // ==================== EVENING REPORT ====================
            widgets.add(
              pw.Center(
                child: pw.Text("Shed Wise Evening Milk Report", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              ),
            );

            // Group by Date -> Shed (Evening)
            Map<String, Map<String, List<dynamic>>> dateShedEvening = {};
            for (var cow in cowsMilkData) {
              final shed = cow.shedId ?? '-';
              if (cow.evening > 0) {
                final d = cow.date ?? "";
                dateShedEvening.putIfAbsent(d, () => {});
                dateShedEvening[d]!.putIfAbsent(shed, () => []).add(cow);
              }
            }

            var sortedDatesE = dateShedEvening.keys.toList()..sort();
            for (var d in sortedDatesE) {
              var shedMap = dateShedEvening[d]!;
              String formattedDate = d.isNotEmpty ? milkReportDateFormat(date: d) : "";

              var sortedSheds = sortSheds(shedMap.keys.toList());

              for (var shedKey in sortedSheds) {
                var cows = shedMap[shedKey]!;
                cows.sort((a, b) => b.evening.compareTo(a.evening));

                double shedTotal = 0;
                List<List<String>> rows = [];
                for (int i = 0; i < cows.length; i++) {
                  var cow = cows[i];
                  shedTotal += cow.evening;
                  rows.add(['${i + 1}', '${cow.cowTagId}', '${cow.evening}', cow.eveningEmployee ?? '-']);
                }
                rows.add(['', '', 'Shed Total', shedTotal.toStringAsFixed(2)]);

                widgets.add(pw.SizedBox(height: 20));
                widgets.add(
                  pw.Text("Shed No : $shedKey    Date : $formattedDate", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15)),
                );
                widgets.add(pw.SizedBox(height: 10));
                widgets.add(
                  pw.Table.fromTextArray(
                    headers: ['SL', 'Cow ID', 'Evening', 'E. Emp'],
                    data: rows,
                    border: pw.TableBorder.all(),
                    headerAlignment: pw.Alignment.center,
                    cellAlignment: pw.Alignment.center,
                  ),
                );
              }
            }

            return widgets;
          },
        ),
      );
    }
    // Employee Wise Report
    if (reportMode.value == 'Employee') {
      doc.addPage(
        pw.MultiPage(
          build: (context) {
            List<pw.Widget> empWidgets = [];
            // Morning Employee Report
            empWidgets.add(
              pw.Center(
                child: pw.Text('Employee Wise Morning Milk Report', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              ),
            );

            empWidgets.add(pw.SizedBox(height: 10));
            // Group by Date -> Employee (Morning)
            Map<String, Map<String, List<dynamic>>> dateEmpMorning = {};
            for (var cow in cowsMilkData) {
              final emp = cow.morningEmployee ?? '-';
              if (emp != '-') {
                final d = cow.date ?? "";
                dateEmpMorning.putIfAbsent(d, () => {});
                dateEmpMorning[d]!.putIfAbsent(emp, () => []).add(cow);
              }
            }

            var sortedDatesM = dateEmpMorning.keys.toList()..sort();
            for (var d in sortedDatesM) {
              var empMap = dateEmpMorning[d]!;
              String formattedDate = d.isNotEmpty ? milkReportDateFormat(date: d) : "";

              empMap.forEach((emp, cows) {
                empWidgets.add(pw.SizedBox(height: 20));
                empWidgets.add(
                  pw.Text('Employee : $emp    Date : $formattedDate', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15)),
                );
                empWidgets.add(pw.SizedBox(height: 10));

                double empTotal = 0;
                List<List<String>> rows = [];
                for (int i = 0; i < cows.length; i++) {
                  var c = cows[i];
                  empTotal += c.morning;
                  rows.add(['${i + 1}', '${c.cowTagId}', '${c.shedId ?? '-'}', '${c.morning}']);
                }
                rows.add(['', '', 'Total', empTotal.toStringAsFixed(2)]);

                empWidgets.add(
                  pw.Table.fromTextArray(
                    headers: ['SL', 'Cow ID', 'Shed ID', 'Morning'],
                    data: rows,
                    border: pw.TableBorder.all(),
                    headerAlignment: pw.Alignment.center,
                    cellAlignment: pw.Alignment.center,
                  ),
                );
              });
            }
            // Evening Employee Report
            empWidgets.add(pw.SizedBox(height: 20));
            empWidgets.add(
              pw.Center(
                child: pw.Text('Employee Wise Evening Milk Report', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              ),
            );
            // Group by Date -> Employee (Evening)
            Map<String, Map<String, List<dynamic>>> dateEmpEvening = {};
            for (var cow in cowsMilkData) {
              final emp = cow.eveningEmployee ?? '-';
              if (emp != '-') {
                final d = cow.date ?? "";
                dateEmpEvening.putIfAbsent(d, () => {});
                dateEmpEvening[d]!.putIfAbsent(emp, () => []).add(cow);
              }
            }

            var sortedDatesE = dateEmpEvening.keys.toList()..sort();
            for (var d in sortedDatesE) {
              var empMap = dateEmpEvening[d]!;
              String formattedDate = d.isNotEmpty ? milkReportDateFormat(date: d) : "";

              empMap.forEach((emp, cows) {
                empWidgets.add(pw.SizedBox(height: 20));
                empWidgets.add(
                  pw.Text('Employee : $emp    Date : $formattedDate', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15)),
                );
                empWidgets.add(pw.SizedBox(height: 10));

                double empTotal = 0;
                List<List<String>> rows = [];
                for (int i = 0; i < cows.length; i++) {
                  var c = cows[i];
                  empTotal += c.evening;
                  rows.add(['${i + 1}', '${c.cowTagId}', '${c.shedId ?? '-'}', '${c.evening}']);
                }
                rows.add(['', '', 'Total', empTotal.toStringAsFixed(2)]);

                empWidgets.add(
                  pw.Table.fromTextArray(
                    headers: ['SL', 'Cow ID', 'Shed ID', 'Evening'],
                    data: rows,
                    border: pw.TableBorder.all(),
                    headerAlignment: pw.Alignment.center,
                    cellAlignment: pw.Alignment.center,
                  ),
                );
              });
            }
            return empWidgets;
          },
        ),
      );
    }
    // Employee Monthly Milk Report
    if (reportMode.value == 'Employee Monthly') {
      doc.addPage(
        pw.MultiPage(
          build: (context) {
            List<pw.Widget> empWidgets = [];
            empWidgets.add(
              pw.Center(
                child: pw.Text('Employee Monthly Milk Report', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              ),
            );
            empWidgets.add(pw.SizedBox(height: 10));

            Map<String, Map<String, Map<String, Map<String, dynamic>>>> empDateCows = {};

            for (var cow in cowsMilkData) {
              double m = cow.morning.toDouble();
              double e = cow.evening.toDouble();

              if (m < 1 && e < 1) continue;

              final String date = cow.date ?? "";
              final String shed = cow.shedId ?? "-";
              final String cowId = cow.cowTagId ?? "-";

              if (m >= 1) {
                final empM = cow.morningEmployee ?? "-";
                if (empM != "-") {
                  empDateCows.putIfAbsent(empM, () => {});
                  empDateCows[empM]!.putIfAbsent(date, () => {});
                  empDateCows[empM]![date]!.putIfAbsent(cowId, () => {'shed': shed, 'morning': 0.0, 'evening': 0.0});
                  empDateCows[empM]![date]![cowId]!['morning'] = m;
                }
              }

              if (e >= 1) {
                final empE = cow.eveningEmployee ?? "-";
                if (empE != "-") {
                  empDateCows.putIfAbsent(empE, () => {});
                  empDateCows[empE]!.putIfAbsent(date, () => {});
                  empDateCows[empE]![date]!.putIfAbsent(cowId, () => {'shed': shed, 'morning': 0.0, 'evening': 0.0});
                  empDateCows[empE]![date]![cowId]!['evening'] = e;
                }
              }
            }

            var sortedEmps = empDateCows.keys.toList()..sort();

            for (var emp in sortedEmps) {
              empWidgets.add(pw.SizedBox(height: 20));
              empWidgets.add(
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(5),
                  color: PdfColors.grey300,
                  child: pw.Text('Employee : $emp', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                ),
              );
              empWidgets.add(pw.SizedBox(height: 10));

              var dateMap = empDateCows[emp]!;
              var sortedDates = dateMap.keys.toList()..sort();

              double grandMorning = 0;
              double grandEvening = 0;
              int grandDays = 0;
              int grandCows = 0;

              for (var d in sortedDates) {
                grandDays++;
                var cowMap = dateMap[d]!;
                String formattedDate = d.isNotEmpty ? milkReportDateFormat(date: d) : "";

                empWidgets.add(pw.SizedBox(height: 10));
                empWidgets.add(pw.Text('Date : $formattedDate', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)));
                empWidgets.add(pw.SizedBox(height: 10));

                var sortedCowIds = sortSheds(cowMap.keys.toList());

                double dailyMorning = 0;
                double dailyEvening = 0;
                List<List<String>> rows = [];

                for (int i = 0; i < sortedCowIds.length; i++) {
                  String cId = sortedCowIds[i];
                  var data = cowMap[cId]!;

                  double m = data['morning'];
                  double e = data['evening'];

                  dailyMorning += m;
                  dailyEvening += e;
                  grandCows++;

                  rows.add(['${i + 1}', cId, data['shed'].toString(), m > 0 ? m.toStringAsFixed(2) : "-", e > 0 ? e.toStringAsFixed(2) : "-"]);
                }

                grandMorning += dailyMorning;
                grandEvening += dailyEvening;

                empWidgets.add(
                  pw.Table.fromTextArray(
                    headers: ['SL', 'Cow ID', 'Shed ID', 'Morning', 'Evening'],
                    data: rows,
                    border: pw.TableBorder.all(),
                    headerAlignment: pw.Alignment.center,
                    cellAlignment: pw.Alignment.center,
                  ),
                );

                empWidgets.add(pw.SizedBox(height: 10));
                empWidgets.add(pw.Text('Morning Total : ${dailyMorning.toStringAsFixed(2)} L', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)));
                empWidgets.add(pw.Text('Evening Total : ${dailyEvening.toStringAsFixed(2)} L', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)));
                empWidgets.add(
                  pw.Text(
                    'Combined Total : ${(dailyMorning + dailyEvening).toStringAsFixed(2)} L',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                );
                empWidgets.add(pw.Text('Total Cows : ${sortedCowIds.length}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)));
                empWidgets.add(pw.SizedBox(height: 15));
                empWidgets.add(pw.Divider());
              }

              empWidgets.add(pw.SizedBox(height: 10));
              empWidgets.add(pw.Text('Grand Summary', style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)));
              empWidgets.add(pw.SizedBox(height: 5));
              empWidgets.add(pw.Text('Morning Total : ${grandMorning.toStringAsFixed(2)} L', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)));
              empWidgets.add(pw.Text('Evening Total : ${grandEvening.toStringAsFixed(2)} L', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)));
              empWidgets.add(
                pw.Text(
                  'Combined Total : ${(grandMorning + grandEvening).toStringAsFixed(2)} L',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              );
              empWidgets.add(pw.Text('Total Days Worked : $grandDays', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)));
              empWidgets.add(pw.Text('Total Cows Milked : $grandCows', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)));
              empWidgets.add(pw.SizedBox(height: 30));
            }

            return empWidgets;
          },
        ),
      );
    }
    return doc.save();
  }

  changeStatus(DataStatusE value) => dataStatus(value);
}
