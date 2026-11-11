import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:startvest_app/startup_home.dart';

void main() {
  runApp(startup_viewprofile());
}

class startup_viewprofile extends StatelessWidget {
  const startup_viewprofile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: startup_viewprofilesub());
  }
}

class startup_viewprofilesub extends StatefulWidget {
  const startup_viewprofilesub({Key? key}) : super(key: key);

  @override
  State<startup_viewprofilesub> createState() => _State();
}

class _State extends State<startup_viewprofilesub> {
  Future<List<Joke>> _getJokes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = await http.post(
        Uri.parse(prefs.getString("ip").toString() + "/view_profile_startup"),
        body: {'sid': prefs.getString("sid")});

    var jsonData = json.decode(data.body);
    print(jsonData);
    List<Joke> jokes = [];
    for (var joke in jsonData["data"]) {
      print(joke);
      Joke newJoke = Joke(
        joke["id"].toString(),
        joke["profile_image"].toString(),
        joke["company_name"].toString(),
        joke["industry"].toString(),
        joke["location"].toString(),
        joke["email"].toString(),
        joke["website"].toString(),
        joke["description"].toString(),
      );
      jokes.add(newJoke);
    }
    return jokes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile",
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
        child: FutureBuilder(
          future: _getJokes(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Loading your profile...",
                      style: TextStyle(
                        color: Colors.teal.shade700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.data.length == 0) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 80,
                      color: Colors.teal.shade300,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "No profile found",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade700,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Profile Details",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal.shade800,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.shade50,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.teal.shade700,
                                      size: 28,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Divider(
                                color: Colors.teal.shade100,
                                thickness: 1,
                              ),
                              SizedBox(height: 16),
                              _buildStyledRow(
                                  "Company Name", snapshot.data[index].company_name.toString()),
                              _buildStyledRow(
                                  "Industry Type", snapshot.data[index].industry.toString()),
                              _buildStyledRow(
                                  "Description", snapshot.data[index].description.toString()),
                              _buildStyledRow(
                                  "Location", snapshot.data[index].location.toString()),
                              _buildStyledRow(
                                  "Email", snapshot.data[index].email.toString()),
                              _buildStyledRow(
                                  "Website", snapshot.data[index].website.toString()),

                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildStyledRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.teal.shade700,
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.blueGrey.shade800,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Joke {
  final String id;
  final String profile_image;
  final String company_name;
  final String industry;
  final String location;
  final String email;
  final String website;
  final String description;

  Joke(this.id, this.profile_image, this.company_name, this.industry, this.location, this.email,
      this.website, this.description);
}