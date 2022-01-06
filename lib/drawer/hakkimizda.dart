import 'package:flutter/material.dart';
import 'package:etkinlik_kafasi/extensions/size_extension.dart';

class Hakkimizda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
            size: 17.0.h,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Hakkımızda",
            style: TextStyle(
                color: const Color(0xff343633),
                fontWeight: FontWeight.w700,
                fontFamily: "OpenSans",
                fontStyle: FontStyle.normal,
                fontSize: 21.7.spByWidth),
            textAlign: TextAlign.center),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
//        margin: EdgeInsets.only(top: 32.70),
//        padding: EdgeInsets.symmetric(horizontal: 32.0.w),
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/bg_curve.png"),
//             fit: BoxFit.contain,
//             alignment: Alignment.bottomCenter,
//           ),
//         ),
        child: Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(top: 16.0.h,left: 15,right: 15),
          child: Text("""Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley.
          
It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release.

 Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. 

Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source.
""",
              style:  TextStyle(
                  color: const Color(0xff343633),
                  fontWeight: FontWeight.w400,
                  fontFamily: "OpenSans",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0.spByWidth),
              textAlign: TextAlign.justify),
        ),
      ),
    );
  }
}
