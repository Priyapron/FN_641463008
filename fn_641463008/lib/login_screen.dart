import 'package:flutter/material.dart';
import 'package:fn_641463008/mainmenu.dart';
import 'package:fn_641463008/register.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void SubmitLogin(BuildContext context) async {
    String username = usernameController.text;
    String password = passwordController.text;

    String apiUrl = 'http://localhost/fn-db/checklogin.php';

    Map<String, dynamic> requestBody = {
      'username': username,
      'password': password,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        print('Login Successfully');
        showSuccessDialog(context);
      } else {
        print('Login Error');
        showLoginErrorDialog(context);
      }
    } catch (error) {
      print('Error connecting to the server: $error');
      showNotConnectDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage('images/smartFarm.jpg'),
                width: 250.0,
                height: 250.0,
              ),
              SizedBox(height: 8.0),
              Text(
                'Smart Farm Platform For Farm', // Added text below the image
                style: TextStyle(
                  fontSize: 16.0, // Adjust the font size as needed
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: usernameController,
                decoration:
                    InputDecoration(labelText: 'ชื่อผู้ใช้งาน / Username :'),
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'รหัสผ่าน / Password'),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  SubmitLogin(context);
                },
                child: Text('Login'),
              ),
              SizedBox(height: 8.0),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => RegisterUserForm(),
                  ));
                },
                child: Text('Register!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showNotConnectDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error Connection???'),
        content: Text('Your Connection Error..'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // ปิดป๊อปอัพ
            },
            child: Text('Go Back'),
          ),
        ],
      );
    },
  );
}

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Successfully'),
        content: Text('Your information has been successfully saved..'),
        actions: [
          TextButton(
            onPressed: () {
//Navigator.of(context).pop(); // ปิดป๊อปอัพ
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MainMenu()));
            },
            child: Text('Goto Main menu'),
          ),
        ],
      );
    },
  );
}

void showLoginErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Login Error'),
        content: Text('Username & Password Not found..'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // ปิดป๊อปอัพ
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
