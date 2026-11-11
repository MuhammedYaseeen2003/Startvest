import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:startvest_app/startup_home.dart';
import 'login.dart';

void main() {
  runApp(startup_changepassword());
}

class startup_changepassword extends StatelessWidget {
  const startup_changepassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: changepasswordsub(),
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
    );
  }
}

class changepasswordsub extends StatefulWidget {
  const changepasswordsub({Key? key}) : super(key: key);

  @override
  State<changepasswordsub> createState() => _State();
}

class _State extends State<changepasswordsub> {
  TextEditingController password = TextEditingController();
  TextEditingController newpassword = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (CONTEXT) => StartupHome()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.black54,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.shade50,
              Colors.lightBlue.shade50,
            ],
            stops: [0.3, 0.7],
          ),
        ),
        child: Form(
          key: formkey,
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Header with travel-themed icon
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.lock_reset,
                          size: 60,
                          color: Colors.black45,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Update Your Password",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),

                  // Form Container
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Old Password Field
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your current password';
                            }
                            return null;
                          },
                          controller: password,
                          obscureText: _obscureOldPassword,
                          decoration: InputDecoration(
                            labelText: "Current Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(Icons.lock_outline, color: Colors.blue),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureOldPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureOldPassword = !_obscureOldPassword;
                                });
                              },
                            ),
                            labelStyle: TextStyle(color: Colors.blue),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // New Password Field
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a new password';
                            }
                            // Apply RegEx for specific patterns
                            if (!RegExp(r'[A-Z]').hasMatch(value)) {
                              return 'Must contain at least one uppercase letter';
                            }
                            if (!RegExp(r'[a-z]').hasMatch(value)) {
                              return 'Must contain at least one lowercase letter';
                            }
                            if (!RegExp(r'[0-9]').hasMatch(value)) {
                              return 'Must contain at least one digit';
                            }
                            if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                              return 'Must contain at least one special character';
                            }
                            if (value.length < 8) {
                              return 'Must be at least 8 characters long';
                            }
                            return null;
                          },
                          controller: newpassword,
                          obscureText: _obscureNewPassword,
                          decoration: InputDecoration(
                            labelText: "New Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(Icons.lock_reset, color: Colors.blue),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureNewPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureNewPassword = !_obscureNewPassword;
                                });
                              },
                            ),
                            labelStyle: TextStyle(color: Colors.blue),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Confirm Password Field
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your new password';
                            }
                            if (value != newpassword.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          controller: confirmpassword,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            labelText: "Confirm New Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(Icons.verified_user, color: Colors.blue),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                            labelStyle: TextStyle(color: Colors.blue),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        // Password Requirements
                        // Container(
                        //   margin: EdgeInsets.only(top: 15),
                        //   padding: EdgeInsets.all(12),
                        //   decoration: BoxDecoration(
                        //     color: Colors.blue.shade50,
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(
                        //         "Password must include:",
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 12,
                        //           color: Colors.blue.shade800,
                        //         ),
                        //       ),
                        //       SizedBox(height: 5),
                        //       Row(
                        //         children: [
                        //           Icon(Icons.check_circle, size: 14, color: Colors.green),
                        //           SizedBox(width: 5),
                        //           Text("8+ characters", style: TextStyle(fontSize: 12)),
                        //         ],
                        //       ),
                        //       Row(
                        //         children: [
                        //           Icon(Icons.check_circle, size: 14, color: Colors.green),
                        //           SizedBox(width: 5),
                        //           Text("Uppercase & lowercase letters", style: TextStyle(fontSize: 12)),
                        //         ],
                        //       ),
                        //       Row(
                        //         children: [
                        //           Icon(Icons.check_circle, size: 14, color: Colors.green),
                        //           SizedBox(width: 5),
                        //           Text("At least one number", style: TextStyle(fontSize: 12)),
                        //         ],
                        //       ),
                        //       Row(
                        //         children: [
                        //           Icon(Icons.check_circle, size: 14, color: Colors.green),
                        //           SizedBox(width: 5),
                        //           Text("Special character", style: TextStyle(fontSize: 12)),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        SizedBox(height: 30),

                        // Submit Button
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (!formkey.currentState!.validate()) {
                                return;
                              }
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              var data = await http.post(
                                Uri.parse("${prefs.getString("ip")}/strt_change_password"),
                                body: {
                                  "oldpassword": password.text,
                                  "newpassword": newpassword.text,
                                  "confirmpassword": confirmpassword.text,
                                  "sid": prefs.getString("sid"),
                                },
                              );

                              var decodeData = json.decode(data.body);
                              print(decodeData);
                              if (decodeData['status'] == "password changed") {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Password Changed"),
                                    content: Text("Your password has been successfully updated."),
                                    icon: Icon(Icons.check_circle, color: Colors.green, size: 40),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => login()),
                                          );
                                        },
                                        child: Text("Continue to Login", style: TextStyle(color: Colors.blue)),
                                      )
                                    ],
                                  ),
                                );
                              } else if (decodeData['status'] == "password mismatch") {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Password Mismatch"),
                                    content: Text("Please make sure your new passwords match."),
                                    icon: Icon(Icons.error_outline, color: Colors.orange, size: 40),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Try Again", style: TextStyle(color: Colors.blue)),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Invalid Password"),
                                    content: Text("Your current password is incorrect."),
                                    icon: Icon(Icons.warning_amber, color: Colors.red, size: 40),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("OK", style: TextStyle(color: Colors.blue)),
                                      )
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "UPDATE PASSWORD",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black45,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}