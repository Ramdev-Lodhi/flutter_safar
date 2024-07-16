import 'package:safar/repository/home_repository.dart';
import 'package:get/get.dart';
import "package:safar/model/job_model.dart";
import 'package:shared_preferences/shared_preferences.dart';

import '../view/dashboard_view.dart';
import '../view/widgets/custom_snackbar.dart';

class HomeController extends GetxController {

  final homeRepository = HomeRepository();
  RxList<dynamic>? categoryCountsFirst = RxList<dynamic>();
  RxList<dynamic>? categoryCountsSecond = RxList<dynamic>();
  RxList<dynamic>? jobSheet = RxList<dynamic>();

  @override
  void onInit() {
    super.onInit();
    fetchChartData();
  }

  Future<bool> checkConnection() async {
    bool connectionStatus = false;
    connectionStatus = await homeRepository.checkConnection();
    return connectionStatus;
  }

  Future<void> login(String email, String pass) async {
    var loginResponse = await homeRepository.login(email, pass);
    print(loginResponse);
    if (loginResponse['status'] == '200') {
      await saveUserData(loginResponse['name'],loginResponse['role'], email);
      Get.offAll(() => DashboardView());
    }
  }

  Future<void> saveUserData(String name,String role, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('role', role);
    await prefs.setString('email', email);
  }

  Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    String? role = prefs.getString('role');
    String? email = prefs.getString('email');
    return {'name': name ?? '','role': role ?? '', 'email': email ?? ''};
  }

  List<Map<String, dynamic>> getDataFromQR(String qrData) {
    List<String> codeData = qrData.split('~');
    if (codeData.length != 9) {
      return [];
    }
    Map<String, dynamic> data = {
      'qr_id': qrData,
      'a_name': codeData[2],
      'a_size': codeData[3],
      'a_color': codeData[5],
      'no_of_pairs': codeData[6],
      'quality': codeData[7],
    };
    List<Map<String, dynamic>> result = [data];
    return result;
  }

  Future<void> sendData(
      List<Map<String, dynamic>> qrData, String scanType, String godown) async {
    if (scanType == 'inwards') {
      for (final qr in qrData) {
        await homeRepository.sendInwardsData(qr['qr_id'], godown);
      }
    } else {
      for (final qr in qrData) {
        await homeRepository.sendOutwardsData(qr['qr_id']);
      }
    }
  }

  Future<List<Job>> getJobsheetStatus(
      String jobId, Map<String, dynamic> result) async {
    List<Job> jobs = await homeRepository.getJobsheetStatus(jobId, result);
    return jobs;
  }

  Future<void> submitJobsheet(
      Map<String, dynamic> result, List<Job> jobs) async {
    List<Map<String, dynamic>> jobList = [];
    for (final value in jobs) {
      if (value.isChecked) {
        jobList.add(value.toJson());
      }
    }
    await homeRepository.submitJobsheet(
        int.parse(result['job_id']), result['job_type'], jobList);
  }
  Future<void> fetchChartData() async {
    var data = await homeRepository.chartData();
    if (data != null) {
      categoryCountsFirst!.assignAll(data['category_counts_first']!);
      categoryCountsSecond!.assignAll(data['category_counts_second']!);
      jobSheet!.assignAll(data['jobsheet']!);
    }
  }
  Future<void> saveChartData(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('email', email);
  }
}
