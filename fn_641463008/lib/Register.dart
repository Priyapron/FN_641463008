import 'package:fn_641463008/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterUserForm extends StatefulWidget {
  @override
  _RegisterUserFormState createState() => _RegisterUserFormState();
}

class _RegisterUserFormState extends State<RegisterUserForm> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phonController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void registerUser() async {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String address = addressController.text;
    String phon = phonController.text;
    String email = emailController.text;
    String username = usernameController.text;
    String password = passwordController.text;

    String apiUrl = 'http://localhost/fn-db/saveregister.php';

    Map<String, dynamic> requestBody = {
      'firstname': firstName,
      'lastname': lastName,
      'address': address,
      'phon': phon,
      'email': email,
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
        showSuccessDialog(context);
      } else {
        print('Failed to register user');
      }
    } catch (error) {
      print('Error connecting to the server: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'Firstname'),
            ),
            TextFormField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Lastname'),
            ),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextFormField(
              controller: phonController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            ElevatedButton(
              onPressed: registerUser,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Successfully'),
        content: Text('Your information has been successfully saved.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
            },
            child: Text('Go to Login Page'),
          ),
        ],
      );
    },
  );
}
