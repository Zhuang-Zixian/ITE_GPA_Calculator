import 'package:flutter/material.dart';
import 'gpa_calculator_screen.dart';
import 'home_page.dart'; // not used might use it
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoginEnabled = false;
  bool isEmailValid = false;
  bool isPasswordVisible = false;
  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    // Load stored credentials
    loadCredentials();
  }

  void loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedEmail = prefs.getString('email');
    String? storedPassword = prefs.getString('password');

    if (storedEmail != null && storedPassword != null) {
      setState(() {
        emailController.text = storedEmail;
        passwordController.text = storedPassword;
        validateInput();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC5092C),
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          setState(() {
            isKeyboardVisible = notification is ScrollEndNotification &&
                MediaQuery.of(context).viewInsets.bottom == 0;
          });
          return true;
        },
        child: Container(
          height: isKeyboardVisible
              ? MediaQuery.of(context).size.height
              : double.infinity,
          color: Colors.grey[200],
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/itelogo.png',
                      height: 150,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Institute of Technical Education',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC5092C),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      onChanged: (_) => validateEmail(),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      onChanged: (_) => validateInput(),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !isPasswordVisible,
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextButton(
                          onPressed: () {
                            showForgotPasswordDialog();
                          },
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        onPressed: isLoginEnabled
                            ? () {
                          if (validateEmailAndPassword()) {
                            // Navigate to the HomePage instead of GpaCalculatorScreen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GpaCalculatorScreen(), // Change here
                              ),
                            );
                          } else {
                            showErrorDialog(
                              'Invalid email or password. Please try again.',
                            );
                          }
                        }
                            : null,
                        child: Text('Login', style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFC5092C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void validateInput() {
    setState(() {
      // Update isLoginEnabled based on email and password validity
      isLoginEnabled = isEmailValid && passwordController.text.isNotEmpty;
    });
  }

  void validateEmail() {
    bool isValid =
    RegExp(r'^[a-zA-Z0-9_.+-]+@gmail\.com$').hasMatch(emailController.text);

    setState(() {
      isEmailValid = isValid;
      validateInput();
    });
  }

  bool validateEmailAndPassword() {
    bool isEmailValid =
    RegExp(r'^[a-zA-Z0-9_.+-]+@gmail\.com$').hasMatch(emailController.text);

    if (!isEmailValid) {
      showErrorDialog(
        'Invalid email format. Please enter a valid Gmail address.',
      );
      return false;
    }

    // Check if the password matches some criteria, you can customize
    // this part. For simplicity, I'm just checking if the password is not empty.
    bool isPasswordValid = passwordController.text.isNotEmpty;

    if (!isPasswordValid) {
      showErrorDialog('Password is required.');
      return false;
    }

    return true;
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showForgotPasswordDialog() {
    TextEditingController newEmailController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forgot Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newEmailController,
                decoration: InputDecoration(
                  labelText: 'New Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: newPasswordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  updateCredentials(
                    newEmailController.text,
                    newPasswordController.text,
                  );
                  Navigator.pop(context);
                },
                child: Text('Update Password'),
              ),
            ],
          ),
        );
      },
    );
  }

  void updateCredentials(String newEmail, String newPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', newEmail);
    prefs.setString('password', newPassword);
    print('Credentials updated: $newEmail, $newPassword');
  }
}
