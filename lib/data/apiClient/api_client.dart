import 'package:cattle_app/core/app_export.dart';

bool isLive = true;

class ApiClient extends GetConnect {
  static String cmBaseUrl = isLive
      // ? "https://api.gaushalaweb.com"
      ? "https://ayushkaapi.cygnux.in"
      // : "http://192.168.0.207:5050";
      : "http://192.168.0.207:5050";

  static String getCowLastId = "$cmBaseUrl/device/api/v1/cow/getLastCowId?gaushala_id=";
  static String loginUrl = "$cmBaseUrl/device/auth/login";
  static String cowListUrl = "$cmBaseUrl/device/api/v1/cow/list";
  static String dashBoardData = "$cmBaseUrl/device/api/v1/milk/todayTotalMilk";
  static String addMilk = "$cmBaseUrl/device/api/v1/milk/create";
  static String combinedCowShedApi = "$cmBaseUrl/device/api/v1/shedtransferhistory/cobinedCowShedApi";
  static String cowMilkHistory = "$cmBaseUrl/device/api/v1/milk/todayMilk";
  static String defaultVariables = "$cmBaseUrl/device/api/v1/milk/defaultVariables";
  static String cowTransfer = "$cmBaseUrl/device/api/v1/cow/cowTransfer";
  static String cowDetail = "$cmBaseUrl/device/api/v1/cow/getCow";
  static String milkUsage = "$cmBaseUrl/device/api/v1/milk_usage/create";
  static String milkHistory = "$cmBaseUrl/device/api/v1/milk/lastSevenDayMilkData";
  static String stock = "$cmBaseUrl/device/api/v1/stock/create";
  static String stockAddBulk = "$cmBaseUrl/device/api/v1/stock/addBulk";
  static String stockList = "$cmBaseUrl/device/api/v1/stock/list";

  static String lastRFONo = "$cmBaseUrl/device/api/v1/stock/lastRFONo";
  static String CancelRFO = "$cmBaseUrl/device/api/v1/stock/deleteRecordAsRFO";
  static String addCow = "$cmBaseUrl/device/api/v1/cow/create";
  static String todayMilkUsage = "$cmBaseUrl/device/api/v1/milk_usage/todayMilkUsage";
  static String salesTransaction = "$cmBaseUrl/device/api/v1/sales_transaction/create";
  static String salesTransactionHistory = "$cmBaseUrl/device/api/v1/sales_transaction/list";
  static String employeeList = "$cmBaseUrl/device/api/v1/employee/list";
  static String addEmployee = "$cmBaseUrl/device/api/v1/employee/create";
  static String getEmployeeDetail = "$cmBaseUrl/device/api/v1/employee/";
  static String exitEmployee = "$cmBaseUrl/device/api/v1/employee/partial-update/";
  static String editEmployee = "$cmBaseUrl/device/api/v1/employee/update/";
  static String empList = "$cmBaseUrl/device/api/v1/emp_joining/list";

  /// Attendance Employee List Api
  static String absentEmpList = "$cmBaseUrl/device/api/v1/emp_attendance/findAllAbsent_emp";

  /// Absent Attendance List Api
  static String attendanceSubmit = "$cmBaseUrl/device/api/v1/emp_attendance/addBulk";

  /// Attendance Submit Api
  static String updateAttendance = "$cmBaseUrl/device/api/v1/emp_attendance/update/";

  /// Attendance Update Api
  static String attendanceHistory = "$cmBaseUrl/device/api/v1/emp_attendance/list";

  /// Attendance History Api
  static String partialUpdate = "$cmBaseUrl/device/api/v1/employee/partial-update/";

  /// HR Screen PartialUpdate Api
  static String medicineData = "$cmBaseUrl/device/api/v1/medicine/list";
  static String addMedicine = "$cmBaseUrl/device/api/v1/medicine/bulkAddMedicine";
  static String medicineByCowId = "$cmBaseUrl/device/api/v1/medicine/getMedicineByCowId";
  static String bulkMilk = "$cmBaseUrl/device/api/v1/milk/addBulk";
  static String validateMilk = "$cmBaseUrl/device/api/v1/milk/validateMilk";
  static String medicineUpdate = "$cmBaseUrl/device/api/v1/medicineUpdate";
  static String getPendingMedicine = "$cmBaseUrl/device/api/v1/medicine/getPendingMedications";
  static String getMedicationHistory = "$cmBaseUrl/device/api/v1/medicine/getMedicationHistory";
  static String getPendingVaccineCow = "$cmBaseUrl/device/api/v1/medicine/getPendingVaccineCows";
  static String getItemStock = "$cmBaseUrl/device/api/v1/report/getItemStock";
  static String milkInfo = "$cmBaseUrl/device/api/v1/cow/getCowsMilkInfo";
  static String cowHierarchy = "$cmBaseUrl/device/api/v1/cow/getCowFamily";
  static String empHistory = "$cmBaseUrl/device/api/v1/emp_attendance/list";
  static String editEmployeeSalary = "$cmBaseUrl/device/api/v1/employee/updateEmployeeSalary";
  static String upcomingMedications = "$cmBaseUrl/device/api/v1/medicine/getUpcomingMedications";
  static String addNewMedicine = "$cmBaseUrl/device/api/v1/medicine/addNewMedicine";
  static String removeMedicine = "$cmBaseUrl/device/api/v1/medicine/removeMedicine";
  static String getReminders = "$cmBaseUrl/device/api/v1/dairymetrics/getReminders";
  static String milkUsageHistory = "$cmBaseUrl/device/api/v1/milk_usage/list";
  static String getRFODetails = "$cmBaseUrl/device/api/v1/stock/getRFODetails";
  static String getLatestAppVersion = "$cmBaseUrl/device/api/v1/dairymetrics/getLatestAppVersion";
  static String changeGuashala = "$cmBaseUrl/device/auth/changeGuashala";
  static String getSairFamily = "$cmBaseUrl/device/api/v1/cow/getSairFamily";
  static String sendExpenseReport = "$cmBaseUrl/device/api/v1/email/sendExpenseReport";
  static String sendSalesEmail = "$cmBaseUrl/device/api/v1/email/sendSalesEmail";
  static String sendProfitLossReport = "$cmBaseUrl/device/api/v1/email/sendProfitLossReport";
  static String editCowDetail = "$cmBaseUrl/device/api/v1/cow/update";
  static String cowMilkReport = "$cmBaseUrl/device/api/v1/milk/getTodayMilkHistory";
  static String getChildrenDetails = "$cmBaseUrl/device/api/v1/cow/getChildrenDetails";
  static String getEmployeeListByGaushalaId = "$cmBaseUrl/device/api/v1/employee/getEmployeeListByGaushalaId";
  static String pendingVaccinesList = "$cmBaseUrl/device/api/v1/medical-reminder/pending-list";
}
