import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:startvest_app/inv_chat.dart';
import 'package:startvest_app/investor_home.dart';
import 'package:startvest_app/startup_chat.dart';
import 'package:startvest_app/startup_home.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(inv_view_interested_startups());
}

class inv_view_interested_startups extends StatelessWidget {
  const inv_view_interested_startups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: inv_view_interested_startupssub());
  }
}

class inv_view_interested_startupssub extends StatefulWidget {
  const inv_view_interested_startupssub({Key? key}) : super(key: key);

  @override
  State<inv_view_interested_startupssub> createState() => _State();
}

class _State extends State<inv_view_interested_startupssub> {
  // Function to handle dislike action
  Future<void> _handleChat(String startupId) async {

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("tosid",startupId);
      Navigator.push(context,MaterialPageRoute(builder: (context)=>InvChatApp()));

    } catch (e) {
      print("Error loading startup: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  Future<List<Joke>> _getJokes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = await http.post(
        Uri.parse(prefs.getString("ip").toString() + "/inv_view_interested_startups"),
        body: {'iid': prefs.getString("iid")});

    var jsonData = json.decode(data.body);
    print("Hiiii");
    print(jsonData);
    List<Joke> jokes = [];
    for (var joke in jsonData["data"]) {
      print(joke);
      Joke newJoke = Joke(
        joke["id"].toString(),
        joke["iid"].toString(),
        joke["profile_image"].toString(),
        joke["investor_name"].toString(),
        joke["industry"].toString(),
        joke["email"].toString(),
        joke["website"].toString(),
        joke["bio"].toString(),
      );
      jokes.add(newJoke);
    }
    return jokes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Interested Startups",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (CONTEXT) => InvestorHome()));
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
                      "Loading interested startups...",
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
                      "No interested startups found",
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
                                    snapshot.data[index].investor_name.toString(),
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
                                  "Industry", snapshot.data[index].industry.toString()),
                              _buildStyledRow(
                                  "Description", snapshot.data[index].bio.toString()),
                              _buildStyledRow(
                                  "Email", snapshot.data[index].email.toString()),
                              _buildStyledRow(
                                  "Website", snapshot.data[index].website.toString()),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 8),
                                  child: ElevatedButton.icon(
                                    onPressed: () async => {
                                      _handleChat(snapshot.data[index].iid.toString())
                                    },
                                    icon: Icon(Icons.launch, size: 20),
                                    label: Text(
                                      'Chat',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade500,
                                      foregroundColor: Colors.white,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                              ),
                              ]
                          )
// Right Button - Visit Website
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
  final String iid;
  final String profile_image;
  final String investor_name;
  final String industry;
  final String email;
  final String website;
  final String bio;

  Joke(this.id, this.iid, this.profile_image, this.investor_name, this.industry,this.email,
      this.website, this.bio);
}