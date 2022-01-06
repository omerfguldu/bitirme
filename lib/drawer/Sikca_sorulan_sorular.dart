import 'package:etkinlik_kafasi/drawer/guvenlikipuclari.dart';
import 'package:flutter/material.dart';
import 'package:etkinlik_kafasi/extensions/size_extension.dart';

class SikcaSorulanSorular extends StatelessWidget {
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
        title: Text("Sıkça Sorulan Sorular",
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg_curve.png"),
            fit: BoxFit.contain,
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            SizedBox(height: 30,),
            Text("EKTİNLİK MERKEZİ NEDİR?",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 16.0.h),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text("""Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer.
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

            SizedBox(height: 10,),

            Text("ETKİNLİK MERKEZİNİN AMACI NEDİR?",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 16.0.h),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text("""Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.
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


            SizedBox(height: 10,),

            Text("Kimler etkinlik oluşturabilir ve kimler oluşturulan etkinliklere katılabilir?",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 16.0.h),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text("""
It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English.
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

            SizedBox(height: 10,),

            Text("Kimler turnuva oluşturabilir ve kimler oluşturulan turnuvaya eşleşme isteği gönderebilir?",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 16.0.h),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text("""
There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.

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


            SizedBox(height: 10,),

            Text("Özel etkinlik nedir, kimler özel etkinlik oluşturabilir ve kimler oluşturulan özel etkinliğe katıl talebi gönderebilir?",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 16.0.h),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text("""
Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero,

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

            SizedBox(height: 10,),

            Text("Lorem Ipsum is simply dummy text o ?",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 16.0.h),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text("""
It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here.
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

            SizedBox(height: 10,),

            Text("Where does it come from?",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 16.0.h),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text("""
Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethi.""",
                    style:  TextStyle(
                        color: const Color(0xff343633),
                        fontWeight: FontWeight.w400,
                        fontFamily: "OpenSans",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0.spByWidth),
                    textAlign: TextAlign.justify),
              ),
            ),


            SizedBox(height: 10,),

            Text("Where can I get some? ?",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 16.0.h),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text("""
There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour""",
                    style:  TextStyle(
                        color: const Color(0xff343633),
                        fontWeight: FontWeight.w400,
                        fontFamily: "OpenSans",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0.spByWidth),
                    textAlign: TextAlign.justify),
              ),
            ),

            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text("What is Lorem Ipsum?",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                width: 292.3333333333333.w,
                height: 43.666666666666664.h,
                margin: EdgeInsets.only(top: 38.0.h),
                child: RaisedButton(
                  color: Theme.of(context).buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(65.7.w),
                  ),
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => GuvenlikIpuclari()));
                  },
                  elevation: 8.3,
                  child: Text(
                    "Daha fazla bilgi için tıklayınız...",
                    style: TextStyle(
                        color: const Color(0xff343633),
                        fontWeight: FontWeight.w600,
                        fontFamily: "OpenSans",
                        fontStyle: FontStyle.normal,
                        fontSize: 18.7),
                  ),
                ),
              ),
            ),
            SizedBox(height: 60,),
          ],
        ),
      ),
    );
  }
}
