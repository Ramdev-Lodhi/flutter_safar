import 'package:flutter/material.dart';
import 'package:safar/controller/home_controller.dart';
import 'package:safar/view/dashboard_view.dart';
import 'package:safar/view/select_scan_type_view.dart';
import 'package:safar/view/widgets/custom_snackbar.dart';
import 'package:get/get.dart';

class MultiResultPageView extends StatefulWidget {
  final String scanType;
  final String godown;
  final String result;
  const MultiResultPageView(
      {required this.result,
      required this.scanType,
      required this.godown,
      super.key});

  @override
  State<MultiResultPageView> createState() => _MultiResultPageViewState();
}

class _MultiResultPageViewState extends State<MultiResultPageView> {
  final homeController = Get.put(HomeController());
  final session = Get.find<HomeController>();
  List<Map<String, dynamic>> data = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserData();
    setState(() {
      data = homeController.getDataFromQR(widget.result);
    });
  }
  String userName = '';
  Future<void> loadUserData() async {
    var userData = await session.getUserData();
    setState(() {
      userName = userData['name']!;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF214162),
          title: const Text(
            'Result',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView(children: <Widget>[
                      DataTable(
                          border: const TableBorder(
                              bottom: BorderSide(color: Colors.black, width: 1),
                              horizontalInside:
                                  BorderSide(color: Colors.black, width: 1),
                              verticalInside:
                                  BorderSide(color: Colors.black, width: 1)),
                          horizontalMargin: 5,
                          columnSpacing: 0,
                          columns: const [
                            DataColumn(
                                label: Center(
                              child: Text('S. No.',
                                  softWrap: true,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            )),
                            DataColumn(
                                label: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Article',
                                  softWrap: true,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            )),
                            DataColumn(
                                label: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Size',
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            )),
                            DataColumn(
                                label: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Color',
                                  softWrap: true,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            )),
                            DataColumn(
                                label: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('No. of Pairs',
                                  softWrap: true,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            )),
                            DataColumn(
                                label: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Quality',
                                  softWrap: true,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            )),
                          ],
                          rows: [
                            for (int i = 0; i < data.length; i++)
                              DataRow(cells: [
                                DataCell(Center(child: Text('${i + 1}'))),
                                DataCell(
                                    Center(child: Text(data[i]['a_name']))),
                                DataCell(
                                    Center(child: Text(data[i]['a_size']))),
                                DataCell(
                                    Center(child: Text(data[i]['a_color']))),
                                DataCell(Center(
                                    child: Text(data[i]['no_of_pairs']))),
                                DataCell(Center(
                                    child: Text(data[i]['quality']))),
                              ])
                          ]),
                    ]),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: ElevatedButton(
                          onPressed: data.isEmpty
                              ? null
                              : () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await homeController.sendData(
                                      data, widget.scanType, widget.godown);
                                  setState(() {
                                    isLoading = false;
                                  });

                                  Get.offAll(() =>  DashboardView());
                                },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF336699),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          child: const Text(
                            'Submit',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ))
                ],
              )));
  }
}
