import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:safar/view/job_sheet_view.dart';
import 'package:safar/view/login_view.dart';
import 'package:safar/view/multi_result_view.dart';
import 'package:safar/view/select_godown_view.dart';
import 'package:safar/view/widgets/custom_button_widget.dart';
import 'package:get/get.dart';

class SelectScanTypeView extends StatefulWidget {
  const SelectScanTypeView({super.key});

  @override
  State<SelectScanTypeView> createState() => _SelectScanTypeViewState();
}

class _SelectScanTypeViewState extends State<SelectScanTypeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String? result;

  Future<void> scanQR() async {
    try {
      final data = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'cancel', true, ScanMode.DEFAULT);

      if (!mounted) return;

      setState(() {
        if (data.toString() != '-1') {
          result = data.toString();
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Select Scan Type',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        // backgroundColor: Theme.of(context).primaryColor,
        backgroundColor: Color(0xFF214162),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomButton(
              title: 'Inwards',
              color: Colors.green,
              onPressed: () {
                Get.to(() => const SelectGodownView(scanType: 'inwards'));
              },
            ),
            const SizedBox(
              height: 30,
            ),
            CustomButton(
              title: 'Outwards',
              color: Colors.blue,
              onPressed: () async {
                await scanQR();
                if (result != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MultiResultPageView(
                          result: result!, scanType: 'outwards', godown: '')));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
