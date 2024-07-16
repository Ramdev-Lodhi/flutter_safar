import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:safar/view/multi_result_view.dart';
import 'package:safar/view/widgets/custom_button_widget.dart';
import 'package:get/get.dart';

class SelectGodownView extends StatefulWidget {
  final String scanType;
  const SelectGodownView({required this.scanType, super.key});

  @override
  State<SelectGodownView> createState() => _SelectGodownViewState();
}

class _SelectGodownViewState extends State<SelectGodownView> {
  String? godown;
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
      appBar: AppBar(
        title: const Text(
          'Select Godown',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
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
              title: 'Godown 1',
              color: Colors.amber,
              onPressed: () async {
                setState(() {
                  godown = '1';
                });
                await scanQR();
                if (result != null && godown != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MultiResultPageView(
                          result: result!,
                          scanType: widget.scanType,
                          godown: godown!)));
                }
              },
            ),
            const SizedBox(
              height: 30,
            ),
            CustomButton(
              title: 'Godown 2',
              color: Colors.deepOrange,
              onPressed: () async {
                setState(() {
                  godown = '2';
                });
                await scanQR();
                if (result != null && godown != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MultiResultPageView(
                          result: result!,
                          scanType: widget.scanType,
                          godown: godown!)));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
