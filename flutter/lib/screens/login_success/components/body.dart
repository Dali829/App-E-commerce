import 'package:flutter/material.dart';
import 'package:ecommerce/components/default_button.dart';
import 'package:ecommerce/screens/home/home_screen.dart';
import 'package:ecommerce/size_config.dart';

import '../../../agentDashboard/agentDashboard.dart';
import '../../../dashboard/dashboard_screen.dart';
import '../../../main.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isAdmin = true;

  @override
  void initState() {
    super.initState();
    print(sharedPref?.getString("isAdmin"));
    print(sharedPref?.getString("role"));
  }

  @override
  Widget build(BuildContext context) {
    return (sharedPref?.getString("isAdmin") != "false")
        ? ((Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Center(
                child: Image.asset(
                  "assets/images/5500661.jpg",
                  height: SizeConfig.screenHeight * 0.4, //40%
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.08),
              Text(
                "Login Success Admin",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(30),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              SizedBox(
                width: SizeConfig.screenWidth * 0.6,
                child: DefaultButton(
                  text: "Go to home",
                  press: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DashboardScreen()));
                  },
                ),
              ),
              Spacer(),
            ],
          )))
        : ((sharedPref?.getString("role") == "user")
            ? Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  Center(
                    child: Image.asset(
                      "assets/images/5500661.jpg",
                      height: SizeConfig.screenHeight * 0.4, //40%
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  Text(
                    "Login Success",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(30),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.6,
                    child: DefaultButton(
                      text: "Go to home",
                      press: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomeScreen()));
                      },
                    ),
                  ),
                  Spacer(),
                ],
              )
            : Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  Center(
                    child: Image.asset(
                      "assets/images/5500661.jpg",
                      height: SizeConfig.screenHeight * 0.4, //40%
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  Text(
                    "Login Success Agent",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(30),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.6,
                    child: DefaultButton(
                      text: "Go to home",
                      press: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DashboardAgentScreen()));
                      },
                    ),
                  ),
                  Spacer(),
                ],
              ));
  }
}
