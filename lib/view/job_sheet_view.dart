import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:safar/controller/home_controller.dart';
import 'package:safar/model/job_model.dart';
import 'package:safar/view/dashboard_view.dart';
import 'package:safar/view/widgets/custom_snackbar.dart';

class JobSheetView extends StatefulWidget {
  const JobSheetView({super.key});

  @override
  State<JobSheetView> createState() => _JobSheetViewState();
}

class _JobSheetViewState extends State<JobSheetView> {
  final noOfPairsController = TextEditingController();
  final weightController = TextEditingController();
  final damageController = TextEditingController();
  final homeController = HomeController();
  Map<String, dynamic>? result;
  List<Job> jobs = [];
  bool isLoading = false;
  int selectedTile = -1;

  Future<void> scanQR() async {
    try {
      final data = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'cancel', true, ScanMode.DEFAULT);

      if (!mounted) return;

      if (data.toString() != '-1') {
        setState(() {
          result = jsonDecode(data);
        });
        jobs =
        await homeController.getJobsheetStatus(result!['job_id'], result!);
        setState(() {});
      }
    } catch (e) {
      CustomSnackbar.snackbar('Error', e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    scanQR();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Sheet', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF212529),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: result != null
                ? ListView.builder(
              itemBuilder: (context, index) {
                Job job = jobs[index];
                return ExpansionTile(
                  leading: Checkbox(
                    onChanged: (value) {
                      setState(() {
                        jobs[index] =
                            job.copyWith(isChecked: value);
                      });
                    },
                    value: job.isChecked,
                  ),
                  title: Text(job.name),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: job.noOfPairs,
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                jobs[index] =
                                    job.copyWith(noOfPairs: value);
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding:
                              const EdgeInsets.all(10),
                              labelText: "No. of Pairs Dispatched",
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .primaryColor,
                                    width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            initialValue: job.weight,
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                jobs[index] =
                                    job.copyWith(weight: value);
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding:
                              const EdgeInsets.all(10),
                              labelText: "Sack Weight Dispatched",
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .primaryColor,
                                    width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            initialValue: job.damage,
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                jobs[index] =
                                    job.copyWith(damage: value);
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding:
                              const EdgeInsets.all(10),
                              labelText: "Total Damage",
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .primaryColor,
                                    width: 2),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                );
              },
              itemCount: jobs.length,
            )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });

                  // Ensure that the next job after a checked job is included with null values
                  List<Job> adjustedJobs = List.from(jobs);
                  for (int i = 0; i < jobs.length; i++) {
                    if (jobs[i].isChecked) {
                      adjustedJobs[i] = adjustedJobs[i]
                          .copyWith(status: 'success',
                        datedispatched: DateTime.now(),
                        datereceived: DateTime.now(),);
                      print(jobs.length);
                      if (i + 1 < jobs.length) {
                        if (!adjustedJobs[i + 1].isChecked) {
                          adjustedJobs[i + 1] = adjustedJobs[i + 1].copyWith(
                              noOfPairs: null,
                              weight: null,
                              damage: null,
                              status: 'pending',
                              datereceived: DateTime.now(),
                              datedispatched: DateTime.now(),
                              isChecked: true);
                        }
                      }
                    }
                  }

                  await homeController.submitJobsheet(result!, adjustedJobs);
                  setState(() {
                    isLoading = false;
                  });

                  Get.offAll(() =>  DashboardView());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A6168),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
