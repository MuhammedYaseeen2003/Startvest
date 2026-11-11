import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:startvest_app/investor_home.dart';

import 'inv_chat.dart';

import 'package:url_launcher/url_launcher.dart';
void main() {
  runApp(inv_view_liked_startups());
}

class inv_view_liked_startups extends StatelessWidget {
  const inv_view_liked_startups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: inv_view_startupssub());
  }
}

class inv_view_startupssub extends StatefulWidget {
  const inv_view_startupssub({Key? key}) : super(key: key);

  @override
  State<inv_view_startupssub> createState() => _State();
}

class _State extends State<inv_view_startupssub> {
  List<Startup> startups = [];
  bool isLoading = true;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadStartups();
  }

  Future<void> _loadStartups() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var data = await http.post(
        Uri.parse(prefs.getString("ip").toString() + "/inv_view_liked_startups"),
        body: {'iid': prefs.getString("iid")},
      );

      var jsonData = json.decode(data.body);
      List<Startup> loadedStartups = [];

      for (var startup in jsonData["data"]) {
        loadedStartups.add(Startup(
          startup["id"].toString(),
          startup["sid"].toString(),
          startup["profile_image"].toString(),
          startup["company_name"].toString(),
          startup["industry"].toString(),
          startup["location"].toString(),
          startup["email"].toString(),
          startup["website"].toString(),
          startup["description"].toString(),
        ));
      }

      setState(() {
        startups = loadedStartups;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading startups: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to handle dislike action
  Future<void> _handleDislike(String startupId) async {
    if (isProcessing) return;

    setState(() {
      isProcessing = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await http.post(
        Uri.parse(prefs.getString("ip").toString() + "/inv_dislike_startup"),
        body: {
          'id': startupId,
        },
      );

      if (response.statusCode == 200) {
        var decodeData = json.decode(response.body);
        print(decodeData);

        if (decodeData['status'] == "ok") {


          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Startup removed from liked list!'),
              backgroundColor: Colors.red.shade300,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to dislike startup'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to dislike startup. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error disliking startup: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  // Function to handle dislike action
  Future<void> _handleChat(String startupId) async {
    if (isProcessing) return;

    setState(() {
      isProcessing = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("tosid",startupId);
      Navigator.push(context,MaterialPageRoute(builder: (context)=>InvChatApp()));

    } catch (e) {
      print("Error disliking startup: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liked Startups",
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
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ),
            SizedBox(height: 20),
            Text(
              "Loading liked startups...",
              style: TextStyle(
                color: Colors.teal.shade700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (startups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.teal.shade300,
            ),
            SizedBox(height: 20),
            Text(
              "No liked startups yet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Like some startups to see them here",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _loadStartups,
              icon: Icon(Icons.refresh),
              label: Text('Refresh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: startups.length,
      itemBuilder: (BuildContext context, int index) {
        final startup = startups[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Company Name and Logo
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                startup.company_name,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal.shade800,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.teal.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.business,
                                color: Colors.teal.shade700,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Industry Chip
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Chip(
                            label: Text(startup.industry),
                            backgroundColor: Colors.teal.shade50,
                            labelStyle: TextStyle(color: Colors.teal.shade700),
                          ),
                        ),
                        SizedBox(height: 24),

                        // Description
                        _buildSection("Description", startup.description),
                        SizedBox(height: 20),

                        // Location
                        _buildInfoRow(Icons.location_on, "Location", startup.location),
                        SizedBox(height: 15),

                        // Email
                        _buildInfoRow(Icons.email, "Email", startup.email),
                        SizedBox(height: 15),

                        // Website
                        _buildClickableRow(Icons.language, "Website", startup.website),
                        SizedBox(height: 30),

                        // Dislike Button
                        // Replace the single button with a row containing two buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left Button - Remove from Liked (Dislike)
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 8),
                                child: ElevatedButton.icon(
                                  onPressed: isProcessing
                                      ? null
                                      : () => _handleDislike(startup.id),
                                  icon: isProcessing
                                      ? SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                      : Icon(Icons.close, size: 20),
                                  label: Text(
                                    isProcessing ? 'Removing...' : 'Remove',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade400,
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

                            // Right Button - Visit Website
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 8),
                                child: ElevatedButton.icon(
                                  onPressed: () async => {
                                    _handleChat(startup.sid)
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
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Liked badge
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.pink.shade200, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.favorite, color: Colors.pink.shade600, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Liked',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.pink.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade700,
          ),
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            color: Colors.blueGrey.shade800,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal.shade600, size: 20),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey.shade800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildClickableRow(IconData icon, String label, String value, {String? url, VoidCallback? onTap}) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal.shade600, size: 20),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 2),
              // Check if this is a URL field (email, website, etc.) or has custom onTap
              if ((label.toLowerCase().contains('email') ||
                  label.toLowerCase().contains('website') ||
                  label.toLowerCase().contains('url') ||
                  url != null) &&
                  (value.isNotEmpty && value != 'null' && value != 'N/A'))
                GestureDetector(
                  onTap: onTap ?? () {
                    if (url != null) {
                      final Uri parsedUrl = Uri.parse(url);
                      launchUrl(parsedUrl);
                    } else {
                      // launchUrl(value);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue.shade700,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue.shade700,
                      ),
                    ),
                  ),
                )
              else
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class Startup {
  final String id;
  final String sid;
  final String profile_image;
  final String company_name;
  final String industry;
  final String location;
  final String email;
  final String website;
  final String description;

  Startup(
      this.id,
      this.sid,
      this.profile_image,
      this.company_name,
      this.industry,
      this.location,
      this.email,
      this.website,
      this.description,
      );
}