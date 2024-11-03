import 'package:flutter/material.dart';
import 'package:naturub/Screens/Appsubmenu/proBoxAccept.dart';
import 'package:naturub/Screens/Appsubmenu/proBoxDispatch.dart';
import 'package:naturub/Screens/Appsubmenu/smsTransection.dart';
import 'package:naturub/Screens/Login/login_screen.dart';
import 'package:naturub/StateManagement/appDetails.dart';
import 'package:naturub/StateManagement/appState.dart';
import 'package:naturub/lightColor.dart';
import 'package:naturub/quar_clipper.dart';
import 'package:provider/provider.dart';

import '../Appsubmenu/proBoxAssign.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget _header(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      final appProvider = Provider.of<WeatherData>(context);
      var width = MediaQuery.of(context).size.width;
      String userName = appState.UserName;
      return ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
        child: Container(
            height: 200,
            width: width,
            decoration: BoxDecoration(
              color: LightColor.purple,
            ),
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                    top: 30,
                    right: -100,
                    child: _circularContainer(300, LightColor.lightpurple)),
                Positioned(
                    top: -100,
                    left: -45,
                    child:
                        _circularContainer(width * .5, LightColor.darkpurple)),
                Positioned(
                    top: -180,
                    right: -30,
                    child: _circularContainer(width * .7, Colors.transparent,
                        borderColor: Colors.white38)),
                Positioned(
                    top: 40,
                    left: 0,
                    child: Container(
                        width: width,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.keyboard_arrow_left,
                              color: Colors.white,
                              size: 40,
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Welcome, ${userName} ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 30,
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              appProvider.formattedBangladeshiTime,
                              style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 18,
                                  fontFamily: 'Teko',
                                  fontWeight: FontWeight.w500),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const LoginScreen();
                                }));
                              },
                              child: Icon(
                                Icons.logout,
                                color: Colors.white,
                                size: 40,
                              ),
                            )
                          ],
                        )))
              ],
            )),
      );
    });
  }

  Widget _circularContainer(double height, Color color,
      {Color borderColor = Colors.transparent, double borderWidth = 2}) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
    );
  }

  Widget _categoryRow(
    String title,
    Color primary,
    Color textColor,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: LightColor.titleTextColor, fontWeight: FontWeight.bold),
          ),
          _chip("See all", primary)
        ],
      ),
    );
  }

  Widget _featuredRowA(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _card(context,
                page: SmsTransection(),
                primary: LightColor.orange,
                backWidget: _decorationContainerD(
                    LightColor.darkseeBlue, -100, -65,
                    secondary: LightColor.lightseeBlue,
                    secondaryAccent: LightColor.seeBlue),
                chipColor: LightColor.orange,
                chipText1: "SMS dispatch & accept",
                chipText2: "SMS",
                isPrimaryCard: true,
                imgPath: "assets/icons/login.svg"),
          ],
        ),
      ),
    );
  }

  Widget _featuredRowB(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _card(context,
                page: ProductBoxAssign(),
                primary: LightColor.seeBlue,
                chipColor: LightColor.orange,
                backWidget: _decorationContainerD(
                    LightColor.darkseeBlue, -100, -65,
                    secondary: LightColor.lightseeBlue,
                    secondaryAccent: LightColor.seeBlue),
                chipText1: "Production Box Assign",
                chipText2: "Production",
                isPrimaryCard: true,
                imgPath: "assets/icons/login.svg"),
            _card(context,
                page: ProductionBoxDispatch(),
                primary: LightColor.lightpurple,
                chipColor: LightColor.orange,
                backWidget: _decorationContainerD(
                    LightColor.darkseeBlue, -100, -65,
                    secondary: LightColor.lightseeBlue,
                    secondaryAccent: LightColor.seeBlue),
                chipText1: "Box Dispatch",
                chipText2: "Production",
                isPrimaryCard: true,
                imgPath: "assets/icons/login.svg"),
            _card(context,
                page: ProductionBoxAccept(),
                primary: LightColor.seeBlue,
                chipColor: LightColor.darkBlue,
                backWidget: _decorationContainerD(
                    LightColor.darkseeBlue, -100, -65,
                    secondary: LightColor.lightseeBlue,
                    secondaryAccent: LightColor.seeBlue),
                chipText1: "Box Accept",
                chipText2: "Packing",
                isPrimaryCard: true,
                imgPath: "assets/icons/login.svg"),
            // _card(context,
            //     primary: Colors.white,
            //     chipColor: LightColor.lightpurple,
            //     backWidget: _decorationContainerE(
            //       LightColor.lightpurple,
            //       90,
            //       -40,
            //       secondary: LightColor.lightseeBlue,
            //     ),
            //     chipText1: "Bussiness foundation",
            //     chipText2: "8 Cources",
            //     imgPath:
            //         "https://i.dailymail.co.uk/i/pix/2016/08/05/19/36E9139400000578-3725856-image-a-58_1470422921868.jpg"),
            // _card(context,
            //     primary: Colors.white,
            //     chipColor: LightColor.lightOrange,
            //     backWidget: _decorationContainerF(
            //         LightColor.lightOrange, LightColor.orange, 50, -30),
            //     chipText1: "Excel skill for business",
            //     chipText2: "8 Cources",
            //     imgPath:
            //         "https://www.reiss.com/media/product/945/066/03-2.jpg?format=jpeg&auto=webp&quality=85&width=632&height=725&fit=bounds"),
            // _card(context,
            //     primary: Colors.white,
            //     chipColor: LightColor.seeBlue,
            //     backWidget: _decorationContainerA(
            //       Colors.white,
            //       -50,
            //       30,
            //     ),
            //     chipText1: "Beacame a data analyst",
            //     chipText2: "8 Cources",
            //     imgPath:
            //         "https://d1mo3tzxttab3n.cloudfront.net/static/img/shop/560x580/vint0080.jpg"),
          ],
        ),
      ),
    );
  }

  Widget _card(BuildContext context,
      {Color primary = Colors.redAccent,
      required String imgPath,
      String chipText1 = '',
      String chipText2 = '',
      required Widget backWidget,
      required Widget page,
      Color chipColor = LightColor.orange,
      bool isPrimaryCard = false}) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => page),
            (route) => false,
          );
        },
        child: Container(
            height: isPrimaryCard ? 190 : 180,
            width: isPrimaryCard ? width * .32 : width * .32,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(
                color: primary.withAlpha(200),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      offset: Offset(0, 5),
                      blurRadius: 10,
                      color: LightColor.lightpurple.withAlpha(20))
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Container(
                child: Stack(
                  children: <Widget>[
                    backWidget,
                    Positioned(
                        top: 20,
                        left: 10,
                        child: CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: AssetImage(imgPath))),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: _cardInfo(context, chipText1, chipText2,
                          LightColor.titleTextColor, chipColor,
                          isPrimaryCard: isPrimaryCard),
                    )
                  ],
                ),
              ),
            )));
  }

  Widget _cardInfo(BuildContext context, String title, String courses,
      Color textColor, Color primary,
      {bool isPrimaryCard = false}) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10),
            width: MediaQuery.of(context).size.width * .32,
            alignment: Alignment.topCenter,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isPrimaryCard ? Colors.white : textColor,
              ),
            ),
          ),
          SizedBox(height: 5),
          _chip(courses, primary, height: 5, isPrimaryCard: isPrimaryCard)
        ],
      ),
    );
  }

  Widget _chip(String text, Color textColor,
      {double height = 0, bool isPrimaryCard = false}) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: height),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: textColor.withAlpha(isPrimaryCard ? 200 : 50),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: isPrimaryCard ? Colors.white : textColor, fontSize: 12),
      ),
    );
  }

  Widget _decorationContainerA(Color primary, double top, double left) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: top,
          left: left,
          child: CircleAvatar(
            radius: 100,
            backgroundColor: primary.withAlpha(255),
          ),
        ),
        _smallContainer(primary, 20, 40),
        Positioned(
          top: 20,
          right: -30,
          child: _circularContainer(80, Colors.transparent,
              borderColor: Colors.white),
        )
      ],
    );
  }

  Widget _decorationContainerB(Color primary, double top, double left) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: -65,
          right: -65,
          child: CircleAvatar(
            radius: 70,
            backgroundColor: Colors.blue.shade100,
            child: CircleAvatar(radius: 30, backgroundColor: primary),
          ),
        ),
        Positioned(
            top: 35,
            right: -40,
            child: ClipRect(
                clipper: QuadClipper(),
                child: CircleAvatar(
                    backgroundColor: LightColor.lightseeBlue, radius: 40)))
      ],
    );
  }

  Widget _decorationContainerC(Color primary, double top, double left) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: -105,
          left: -35,
          child: CircleAvatar(
            radius: 70,
            backgroundColor: LightColor.orange.withAlpha(100),
          ),
        ),
        Positioned(
            top: 35,
            right: -40,
            child: ClipRect(
                clipper: QuadClipper(),
                child: CircleAvatar(
                    backgroundColor: LightColor.orange, radius: 40))),
        _smallContainer(
          LightColor.yellow,
          35,
          70,
        )
      ],
    );
  }

  Widget _decorationContainerD(Color primary, double top, double left,
      {required Color secondary, required Color secondaryAccent}) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: top,
          left: left,
          child: CircleAvatar(
            radius: 100,
            backgroundColor: secondary,
          ),
        ),
        _smallContainer(LightColor.yellow, 18, 35, radius: 12),
        Positioned(
          top: 130,
          left: -50,
          child: CircleAvatar(
            radius: 80,
            backgroundColor: primary,
            child: CircleAvatar(radius: 50, backgroundColor: secondaryAccent),
          ),
        ),
        Positioned(
          top: -30,
          right: -40,
          child: _circularContainer(80, Colors.transparent,
              borderColor: Colors.white),
        )
      ],
    );
  }

  Widget _decorationContainerE(Color primary, double top, double left,
      {required Color secondary}) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: -105,
          left: -35,
          child: CircleAvatar(
            radius: 70,
            backgroundColor: primary.withAlpha(100),
          ),
        ),
        Positioned(
            top: 40,
            right: -25,
            child: ClipRect(
                clipper: QuadClipper(),
                child: CircleAvatar(backgroundColor: primary, radius: 40))),
        Positioned(
            top: 45,
            right: -50,
            child: ClipRect(
                clipper: QuadClipper(),
                child: CircleAvatar(backgroundColor: secondary, radius: 50))),
        _smallContainer(LightColor.yellow, 15, 90, radius: 5)
      ],
    );
  }

  Widget _decorationContainerF(
      Color primary, Color secondary, double top, double left) {
    return Stack(
      children: <Widget>[
        Positioned(
            top: 25,
            right: -20,
            child: RotatedBox(
              quarterTurns: 1,
              child: ClipRect(
                  clipper: QuadClipper(),
                  child: CircleAvatar(
                      backgroundColor: primary.withAlpha(100), radius: 50)),
            )),
        Positioned(
            top: 34,
            right: -8,
            child: ClipRect(
                clipper: QuadClipper(),
                child: CircleAvatar(
                    backgroundColor: secondary.withAlpha(100), radius: 40))),
        _smallContainer(LightColor.yellow, 15, 90, radius: 5)
      ],
    );
  }

  Positioned _smallContainer(Color primary, double top, double left,
      {double radius = 10}) {
    return Positioned(
        top: top,
        left: left,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: primary.withAlpha(255),
        ));
  }

  BottomNavigationBarItem _bottomIcons(IconData icon) {
    return BottomNavigationBarItem(icon: Icon(icon), label: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: LightColor.purple,
        unselectedItemColor: Colors.grey.shade300,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: 0,
        items: [
          _bottomIcons(Icons.home),
          _bottomIcons(Icons.star_border),
          _bottomIcons(Icons.book),
          _bottomIcons(Icons.person),
        ],
        onTap: (index) {},
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              _header(context),
              SizedBox(height: 20),
              _categoryRow("SMS", LightColor.orange, LightColor.orange),
              _featuredRowA(context),
              SizedBox(height: 0),
              _categoryRow(
                  "Production", LightColor.purple, LightColor.darkpurple),
              _featuredRowB(context)
            ],
          ),
        ),
      ),
    );
  }
}
