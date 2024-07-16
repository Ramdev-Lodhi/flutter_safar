import 'dart:convert';
import 'package:get/get.dart';
import 'package:safar/constants/api.dart';
import 'package:safar/model/job_model.dart';
import 'package:safar/view/dashboard_view.dart';
import 'package:safar/view/select_scan_type_view.dart';
import 'package:safar/view/widgets/custom_snackbar.dart';
import 'package:http/http.dart' as http;

class HomeRepository {
  Future<bool> checkConnection() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      final data = jsonDecode(response.body.toString());
      if (data != null && data['status'] == '200') {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> sendInwardsData(String qrId, String godown) async {
    try {
      String base64Qr = base64.encode(utf8.encode(qrId));
      String encodedQr = Uri.encodeComponent(base64Qr);
      final url = Uri.parse('${apiUrl}insert_inwards/$encodedQr/$godown');

      final response = await http.get(url);
      final data = jsonDecode(response.body.toString());

      if (data != null) {
        if (data['status'] == '200') {
          CustomSnackbar.snackbar('Success', 'Data added successfully');
        } else if (data['status'] == '409') {
          CustomSnackbar.snackbar('Error', 'QR already exists in inwards');
        }
      } else {
        CustomSnackbar.snackbar('Error', 'Something went wrong');
      }
    } catch (e) {
      CustomSnackbar.snackbar('Error', e.toString());
    }
  }

  Future<void> sendOutwardsData(String qrId) async {
    try {
      String base64Qr = base64.encode(utf8.encode(qrId));
      String encodedQr = Uri.encodeComponent(base64Qr);
      final url = Uri.parse('${apiUrl}insert_outwards/$encodedQr');

      final response = await http.get(url);
      final data = jsonDecode(response.body.toString());
      if (data != null) {
        if (data['status'] == '200') {
          CustomSnackbar.snackbar('Success', 'Data updated successfully');
        } else if (data['status'] == '409') {
          CustomSnackbar.snackbar('Error', 'QR already exists in outwards');
        } else if (data['status'] == '404') {
          CustomSnackbar.snackbar(
              'Error', 'Please add inwards data before outwards');
        }
      } else {
        CustomSnackbar.snackbar('Error', 'Something went wrong');
      }
    } catch (e) {
      CustomSnackbar.snackbar('Error', e.toString());
    }
  }

  Future<List<Job>> getJobsheetStatus(
      String jobId, Map<String, dynamic> result) async {
    try {
      List<Job> jobs = [];
      final url = Uri.parse('${apiUrl}get_jobsheet_status/$jobId');
      final response = await http.get(url);
      final apiData = jsonDecode(response.body.toString());
      for (final job in result['jobs']) {
        bool isChecked = false;
        for (final val in apiData) {
          if (val['dept_id'] == job['dept_id']) {
            val['isChecked'] = true;
            isChecked = true;
            jobs.add(Job.fromJson(val));
          }
        }
        if (!isChecked) jobs.add(Job.fromJson(job));
      }
      return jobs;
    } catch (e) {
      CustomSnackbar.snackbar('Error', e.toString());
      return [];
    }
  }

  Future<void> submitJobsheet(
      int jobId, String jobType, List<Map<String, dynamic>> jobList) async {
    try {
      String base64Data =
          base64.encode(utf8.encode(jsonEncode({"data": jobList})));
      String encodedData = Uri.encodeComponent(base64Data);
      print('encoded Data : $encodedData');
      final url =
          Uri.parse('${apiUrl}submitJobsheet/$jobId/$jobType/$encodedData');
print(url);
      final response = await http.get(url);
      final data = jsonDecode(response.body.toString());

      if (data != null && data['status'] == '200') {
        CustomSnackbar.snackbar('Success', 'Jobsheet added successfully');
      } else {
        CustomSnackbar.snackbar('Error', 'Something went wrong');
      }
    } catch (e) {
      CustomSnackbar.snackbar('Error', e.toString());
    }
  }

  Future<Map<String, dynamic>> login(String email, String pass) async {
    try {
      final url = Uri.parse('${apiUrl}login');
      final response = await http.post(url, body: {
        'email': email,
        'pass': pass,
      });
      var resp = jsonDecode(response.body.toString());
      if (resp['status'] == '500') {
        CustomSnackbar.snackbar_login(
            'Error', 'Login Failed Please Try Again.......');
        return {'status': '500', 'message': 'Something went wrong'};
      } else {
        return {'status': '200', 'name': resp['name'],'role':resp['role']};
      }
    } catch (e) {
      CustomSnackbar.snackbar_login(
          'Error', 'Login Failed Please Try Again.......');
      return {'status': '500', 'message': 'Something went wrong'};
    }
  }

  Future<Map<String, List<dynamic>?>> chartData() async {
    try {
      final url = Uri.parse('${apiUrl}chart_data');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic>? categoryCountsFirst = data['category_counts_first'];
        List<dynamic>? categoryCountsSecond = data['category_counts_second'];
        List<dynamic>? jobSheet = data['jobsheet'];

        return {
          'category_counts_first': categoryCountsFirst,
          'category_counts_second': categoryCountsSecond,
          'jobsheet': jobSheet,
        };
      } else {
        // Handle other status codes
        return {
          'category_counts_first': null,
          'category_counts_second': null,
          'jobsheet': null,
        };
      }
    } catch (e) {
      CustomSnackbar.snackbar_login('Error', 'Failed to fetch data. Please try again.');
      return {
        'category_counts_first': null,
        'category_counts_second': null,
        'jobsheet': null,
      };
    }
  }

}
