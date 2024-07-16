import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safar/controller/home_controller.dart';
import 'package:safar/view/job_sheet_view.dart';
import 'package:safar/view/login_view.dart';
import 'package:safar/view/select_scan_type_view.dart';
import 'package:pie_chart/pie_chart.dart';

class DashboardView extends StatefulWidget {

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final homeController = Get.put(HomeController());

  String userName = '';
  String userRole = '';

  var c;
  // var success =  0; var inProgress = 0; var paid= 0 ;
  @override
  void initState() {
    super.initState();
    loadUserData();
    homeController.fetchChartData();
  }

  Future<void> loadUserData() async {
    var userData = await homeController.getUserData();
    userName = userData['name']!;
    userRole = userData['role']!;
  }
  Future<void> _refreshData() async {
    await homeController.fetchChartData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'DashBoard',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF214162),
        leading: Container(
          color: const Color(0xFFff5722),
          child: IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            icon: const Icon(
              Icons.menu_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: const Color(0xFF15283C),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Image.asset(
                'assets/images/pattern_h.png',
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: const Color(0xFF214162),
                    padding: const EdgeInsets.all(16),
                    height: 150,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/safarlogo.png',
                          width: 150,
                        ),
                        const SizedBox(height: 10,),
                        Text(
                          'Welcome! $userName',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'General',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Divider(color: Colors.red, thickness: 2,),
                  const SizedBox(height: 10,),
                  ListTile(
                    onTap: () {
                      _scaffoldKey.currentState!.closeDrawer();
                    },
                    leading: const Icon(Icons.speed_rounded,
                        color: Colors.yellowAccent),
                    title: const Text(
                      'DashBoard',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SelectScanTypeView()));
                    },
                    leading: const Icon(Icons.inventory_2_rounded,
                        color: Colors.blueAccent),
                    title: const Text(
                      'Outer Box',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const JobSheetView()));
                    },
                    leading: const Icon(Icons.inventory_rounded,
                        color: Colors.deepOrangeAccent),
                    title: const Text(
                      'Job Sheet',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.offAll(() => LoginView());
                    },
                    leading: Icon(Icons.logout, color: Colors.red[300]),
                    title: const Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      body: userRole != 'admin' ? Container():Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(

          onRefresh:_refreshData ,

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  if (homeController.categoryCountsFirst != null &&
                      homeController.categoryCountsFirst!.isNotEmpty) {
                    c =0;
                    for (var category in homeController.categoryCountsFirst!){
                      c += category['count'];}
                    return Card(
                      elevation: 10,
                      child: SizedBox(
                        width: double.infinity,
                        height: 550,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'STOCK IN GODOWN (FIRST QUALITY) - $c',
                                style: TextStyle(fontSize: 20),textAlign: TextAlign.center,
                              ),
                            ),
                            const Divider(color: Colors.black12, thickness: 2,),
                            PieChart(
                              dataMap: {
                                for (var category in homeController.categoryCountsFirst!)
                                  category['name']: category['count'].toDouble(),
                              },
                              animationDuration: const Duration(milliseconds: 800),
                              chartRadius: MediaQuery.of(context).size.width / 1.2,
                              colorList: const [
                                Colors.blue,
                                Colors.green,
                                Colors.deepPurple,
                                Colors.pinkAccent,
                              ],
                              initialAngleInDegree: 0,
                              chartType: ChartType.disc,
                              ringStrokeWidth: 32,
                              legendOptions: const LegendOptions(
                                showLegendsInRow: true,
                                legendPosition: LegendPosition.top,
                                showLegends: true,
                                legendShape: BoxShape.circle,
                                legendTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              chartValuesOptions: const ChartValuesOptions(
                                showChartValueBackground: false,
                                chartValueStyle: TextStyle(color: Colors.white),
                                showChartValues: true,
                                showChartValuesInPercentage: false,
                                showChartValuesOutside: false,
                                decimalPlaces: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
                SizedBox(height: 20,),
                Obx(() {
                  if (homeController.categoryCountsSecond != null &&
                      homeController.categoryCountsSecond!.isNotEmpty) {
                     c = 0; // Initialize outside the widget tree
                    for (var category in homeController.categoryCountsSecond!) {
                      c += category['count']; // Accumulate counts
                    }
                    return Card(
                      elevation: 10,
                      child: SizedBox(
                        width: double.infinity,
                        height: 550,
                        child: Column(
                          children: [

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'STOCK IN GODOWN (SECOND QUALITY) -$c',
                                style: TextStyle(fontSize: 20),textAlign: TextAlign.center,
                              ),
                            ),
                            const Divider(color: Colors.black12, thickness: 2,),
                            PieChart(
                              dataMap: {
                                for (var category in homeController.categoryCountsSecond!)
                                  category['name']: category['count'].toDouble(),
                              },
                              animationDuration: const Duration(milliseconds: 800),
                              chartRadius: MediaQuery.of(context).size.width / 1.2,
                              colorList: const [
                                Colors.blue,
                                Colors.green,
                                Colors.deepPurple,
                                Colors.pinkAccent,
                              ],
                              initialAngleInDegree: 0,
                              chartType: ChartType.disc,
                              ringStrokeWidth: 32,
                              legendOptions: const LegendOptions(
                                showLegendsInRow: true,
                                legendPosition: LegendPosition.top,
                                showLegends: true,
                                legendShape: BoxShape.circle,
                                legendTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              chartValuesOptions: const ChartValuesOptions(
                                showChartValueBackground: false,
                                chartValueStyle: TextStyle(color: Colors.white),
                                showChartValues: true,
                                showChartValuesInPercentage: false,
                                showChartValuesOutside: false,
                                decimalPlaces: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
                SizedBox(height: 20,),
                Obx(() {
                  if (homeController.jobSheet != null &&
                      homeController.jobSheet!.isNotEmpty) {
                    int c = homeController.jobSheet!.length; // Total count of job sheets

                    int success = 0;
                    int inProgress = 0;
                    int paid = 0;

                    for (var job in homeController.jobSheet!) {
                      if (job['status'] == '1') {
                        success++;
                      } else if (job['status'] == '0') {
                        inProgress++;
                      }

                      if (job['payment_status'] == '1') {
                        paid++;
                      }
                    }
                    return Card(
                      elevation: 10,
                      child: SizedBox(
                        width: double.infinity,
                        height: 550,
                        child: Column(
                          children: [

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'JOB SHEET & PAYMENT STATUS -$c',
                                style: TextStyle(fontSize: 20),textAlign: TextAlign.center,
                              ),
                            ),
                            const Divider(color: Colors.black12, thickness: 2,),
                            PieChart(
                              dataMap: {
                                'Success': success.toDouble(),
                                'In Progress': inProgress.toDouble(),
                                'Paid': paid.toDouble(),
                              },
                              animationDuration: const Duration(milliseconds: 800),
                              chartRadius: MediaQuery.of(context).size.width / 1.2,
                              colorList: const [
                                Colors.blue,
                                Colors.red,
                                Colors.yellow,
                              ],
                              initialAngleInDegree: 0,
                              chartType: ChartType.disc,
                              ringStrokeWidth: 32,
                              legendOptions: const LegendOptions(
                                showLegendsInRow: true,
                                legendPosition: LegendPosition.top,
                                showLegends: true,
                                legendShape: BoxShape.circle,
                                legendTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              chartValuesOptions: const ChartValuesOptions(
                                showChartValueBackground: false,
                                chartValueStyle: TextStyle(color: Colors.white),
                                showChartValues: true,
                                showChartValuesInPercentage: false,
                                showChartValuesOutside: false,
                                decimalPlaces: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
                SizedBox(height: 10,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
