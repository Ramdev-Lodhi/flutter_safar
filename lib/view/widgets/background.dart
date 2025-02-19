import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height,
      color: Colors.grey[200],
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
                "assets/images/bottomright.png",
                width: size.width
            ),
          ), Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
                "assets/images/bottomup.png",
                width: size.width
            ),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
                "assets/images/bottom.png",
                width: size.width
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
                "assets/images/bottom1.png",
                width: size.width
            ),
          ),
          child
        ],
      ),
    );
  }
}