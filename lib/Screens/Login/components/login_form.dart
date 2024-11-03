import 'package:flutter/material.dart';
import 'package:naturub/Models/user.dart';
import 'package:naturub/Screens/Main/home_screen.dart';
import 'package:naturub/Service/apiservice.dart';
import 'package:naturub/StateManagement/appDetails.dart';
import 'package:naturub/constants.dart';
import 'package:naturub/sharedDate/appData.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String? userName;
  String? password;
  int? empID;
  void login() {
    HttpService().validLogin(userName!, password!, context).then((value) {
      if (value is List<User>) {
        final appState = Provider.of<AppState>(context, listen: false);
        setState(() {
          empID = value[0].empID;
          appState.updateUserName(value[0].fullName);
          HttpService()
              .getSectionByUserID(empID!)
              .then((value) => {AppData.setSectionUserWise(value)});
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else if (value is String && value == 'User not found') {
        // User not found, show toast
      } else {
        // Handle other cases or unexpected formats
        print('Unexpected result: $value');
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    AppState().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    return Form(
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onChanged: (value) {
              setState(() {
                userName = value;
              });
            },
            decoration: const InputDecoration(
              hintText: "User Name",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: () {
              login();
            },
            child: Text(
              "Login".toUpperCase(),
            ),
          ),
          const SizedBox(height: defaultPadding),
          // AlreadyHaveAnAccountCheck(
          //   press: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) {
          //           return const SignUpScreen();
          //         },
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
