import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool displayLogin = true;
  bool blnLoginStatus = false;
  String strLoginStatus = "";
  String loggedOnUser = "User";
  String loggedOnPass = "Password";
  Map<String, String> allUsers = {
    "ExampleUser": "ExamplePass",
    "AnotherUser": "AnotherPass"
  };

  void login() {
    if (allUsers.containsKey(loggedOnUser)) {
      if (allUsers[loggedOnUser] == loggedOnPass) {
        setState(() {
          displayLogin = false;
        });
        Navigator.of(context).push(

        )
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
      setState(() {
        displayLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 50),
            Row(children: [
              const SizedBox(
                width: 50,
              ),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Username',
                    //onChanged: (value) => LoggedOnUser = value,
                  ),
                  //onChanged: (value) => LoggedOnUser = value,
                  onChanged: (value) {
                    loggedOnUser = value;
                  },
                ),
              ),
              const SizedBox(
                width: 50,
              ),
            ]),
            const SizedBox(height: 50),
            Row(children: [
              const SizedBox(
                width: 50,
              ),
              Expanded(
                child: TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                  ),
                  onChanged: (value) {
                    loggedOnPass = value;
                  },
                ),
              ),
              const SizedBox(
                width: 50,
              ),
            ]),
            const SizedBox(height: 25),
            Row(children: [
              const SizedBox(width: 50),
              TextButton(
                  onPressed: login,
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: const Text("Log In")),
              const SizedBox(width: 50),
              TextButton(
                  onPressed: createAccount,
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: const Text("Create Account")),
              const SizedBox(width: 50),
            ]),
            const SizedBox(height: 5),
            Visibility(
              visible: blnLoginStatus,
              child: Text(strLoginStatus,
                  style: const TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
  }
}

/*class inputBox extends StatelessWidget {
  @override

}*/