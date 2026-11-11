import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:startvest_app/startup_home.dart';

import 'package:url_launcher/url_launcher.dart';
import 'investor_home.dart';

// import 'home.dart';

void main() {
  runApp(login());
}

class login extends StatelessWidget {
  const login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: loginsub(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }
}

class loginsub extends StatefulWidget {
  const loginsub({Key? key}) : super(key: key);

  @override
  State<loginsub> createState() => _State();
}

class _State extends State<loginsub> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(key: formkey,child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.shade700,
              Colors.teal.shade400,
              Colors.teal.shade200,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo and App Name
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: Icon(
                          Icons.laptop,
                          size: 50,
                          color: Colors.teal.shade700,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Start Vest",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40),

                  // Login Form
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade800,
                            ),
                          ),
                          SizedBox(height: 24),

                          // Username Field
                          TextFormField(
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return "Enter your username";
                              }
                              return null;
                            },
                            controller: username,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person, color: Colors.teal),
                              hintText: "Enter your username",
                              labelText: "Username",
                            ),
                            style: TextStyle(fontSize: 16),
                          ),

                          SizedBox(height: 16),

                          // Password Field
                          TextFormField(
                            validator: (value){
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }

                              if (value.length < 8) {
                                return 'Password must be at least 8 characters long';
                              }
                              return null;
                            },
                            controller: password,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock, color: Colors.teal),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.teal,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              hintText: "Enter your password",
                              labelText: "Password",
                            ),
                            style: TextStyle(fontSize: 16),
                          ),

                          SizedBox(height: 24),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                if(!formkey.currentState!.validate()){
                                  return;
                                }
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                var data = await http.post(
                                  Uri.parse("${prefs.getString("ip")}/flutter_login"),
                                  body: {
                                    "username": username.text,
                                    "password": password.text,
                                  },
                                );

                                var decodeData = json.decode(data.body);
                                print(decodeData);

                                if (decodeData['status'] == "ok") {
                                  if(decodeData['type'] == "startup"){
                                    var uid = decodeData['sid'];
                                    prefs.setString("sid", uid.toString());
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Login Success"),
                                        content: Text("Welcome Startup"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => StartupHome()),
                                              );
                                            },
                                            child: Text("OK"),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                  else if(decodeData['type'] == "investor"){
                                    var uid = decodeData['iid'];
                                    prefs.setString("iid", uid.toString());
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Login Success"),
                                        content: Text("Welcome Investor"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => InvestorHome()),
                                              );
                                            },
                                            child: Text("OK"),
                                          )
                                        ],
                                      ),
                                    );
                                  }

                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Login Failed"),
                                      content: Text("Invalid username or password"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("OK"),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 5,
                              ),
                              child: Text(
                                "LOGIN",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    String url =prefs.getString("ip")!;
                                    final Uri parsedUrl = Uri.parse(url);
                                    await launchUrl(parsedUrl);
                                  },
                                  icon: Icon(Icons.launch, size: 20),
                                  label: Text("Create Account"),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          )


                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),)
    );
  }
}