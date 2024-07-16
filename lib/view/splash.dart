import 'dart:async';
import 'package:flutter/material.dart';
import 'package:safar/controller/home_controller.dart';
import 'package:safar/view/login_view.dart';
import 'package:safar/view/select_scan_type_view.dart';
import 'package:safar/view/widgets/custom_snackbar.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late Timer _timer;
  int _start = 0;
  bool isConnected = false;
  final homeController = Get.put(HomeController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
    checkConnection();
  }

  Future<void> checkConnection() async {
    bool isConnected = await homeController.checkConnection();
    if (isConnected) {
      CustomSnackbar.snackbar('Success', 'Connected to server');
      Get.offAll(() =>  LoginView());
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 5) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start++;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Hero(
        tag: 'logo',
        child: Container(

          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/safarlogo.png"),
              // Correct way to load image asset
              // fit: BoxFit.cover,
            ),
          ),
          child: Container(
            margin: EdgeInsets.only(top: 400),
            child: _start < 5
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Trying to connect to server...",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CircularProgressIndicator()
                ],
              ),
            )
                : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Couldn't connect to server ! ",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _start = 0;
                      });
                      startTimer();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple),
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),


    );
  }
}
