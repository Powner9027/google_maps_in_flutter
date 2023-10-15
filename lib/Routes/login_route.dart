import 'package:flutter/material.dart';
import 'map_route.dart';

class LoginRoute extends StatefulWidget {
  const LoginRoute({super.key});

  @override
  State<LoginRoute> createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  bool displayLogin = true;
  bool blnLoginStatus = false;
  String strLoginStatus = "";
  String loggedOnUser = "User";
  String loggedOnPass = "Password";
  Map<String, String> allUsers = {
    "ExampleUser": "ExamplePass",
    "AnotherUser": "AnotherPass"
  };

  InputDecoration fieldStyle = InputDecoration(
    filled: true,
    fillColor: const Color(0xDDFFFFFF),
    contentPadding: const EdgeInsets.all(16),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.white,
          width: 5,
        )
    ),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.white,
          width: 5,
        )
    ),
  );

  void login() {
    if (allUsers.containsKey(loggedOnUser)) {
      if (allUsers[loggedOnUser] == loggedOnPass) {
        setState(() {
          displayLogin = false;
        });
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const MapRoute()));
      } else {
        setState(() {
          strLoginStatus = "Incorrect password for username: $loggedOnUser";
          blnLoginStatus = true;
        });
      }
    } else {
      setState(() {
        strLoginStatus =
            "Could not find an account with username: $loggedOnUser";
        blnLoginStatus = true;
      });
    }

    //Set<String> allAccounts;// = allUsers.Split('\n');
  }

  void createAccount() {
    if (allUsers.containsKey(loggedOnUser)) {
      setState(() {
        strLoginStatus = "Username already exists";
        blnLoginStatus = true;
      });
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const MapRoute()));
      setState(() {
        displayLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            "Assets/earthrise.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              "Assets/geovibes_logo_white_border.png",
              height: MediaQuery.of(context).size.height / 6.5,
            ),
            const Spacer(),
            Row(children: [
              const Spacer(),
              Container(
                width: MediaQuery.of(context).size.width * .9,
                child: Column(
                  children: [
                    const Row(
                      children: [
                        SizedBox(width: 11),
                        Text(
                          "USERNAME",
                          style: TextStyle(
                            fontFamily: 'Brandon',
                            fontSize: 32,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      style: const TextStyle(
                          fontFamily: 'Brandon',
                          fontSize: 20,
                          color: Color(0xFF135498),
                      ),
                      decoration: fieldStyle,
                      //onChanged: (value) => LoggedOnUser = value,
                      onChanged: (value) {
                        loggedOnUser = value;
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ]),
            const Spacer(),
            Container(
              width: MediaQuery.of(context).size.width * .9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        SizedBox(width: 11),
                        Text(
                          "PASSWORD",
                          style: TextStyle(
                          fontFamily: 'Brandon',
                          fontSize: 32,
                          color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      obscureText: true,
                      style: const TextStyle(
                        fontFamily: 'Brandon',
                        fontSize: 20,
                        color: Color(0xFF135498),
                      ),
                      decoration: fieldStyle,
                      onChanged: (value) {
                        loggedOnPass = value;
                      },
                    ),
                  ],
                ),
            ),
            const SizedBox(height: 25),
            Row(children: [
              const Spacer(),
              TextButton(
                  onPressed: login,
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: const Text(
                      "Log In",
                  style: TextStyle(
                    fontFamily: 'Brandon',
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                    color: Color(0xFFFFFFFF),
                  ))),
              const Spacer(),
              TextButton(
                  onPressed: createAccount,
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: const Text(
                      "Create Account",
                    style: TextStyle(
                      fontFamily: 'Brandon',
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      color: Color(0xFFFFFFFF),
                    )
                  )),
              const Spacer(),
            ]),
            const Spacer(),
            Visibility(
              visible: blnLoginStatus,
              child:
                  Text(strLoginStatus, style: const TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ]),
    );
  }
}
