import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:startvest_app/investor_home.dart';
import 'package:startvest_app/startup_home.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(startup_view_investors_card());
}

class startup_view_investors_card extends StatelessWidget {
  const startup_view_investors_card({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: startup_view_investors_cardsub());
  }
}

class startup_view_investors_cardsub extends StatefulWidget {
  const startup_view_investors_cardsub({Key? key}) : super(key: key);

  @override
  State<startup_view_investors_cardsub> createState() => _State();
}

class _State extends State<startup_view_investors_cardsub> {
  List<Startup> startups = [];
  int currentIndex = 0;
  bool isLoading = true;
  bool isProcessing = false;

  // Track status for current startup
  String currentLikeStatus = "";
  String currentSaveStatus = "";

  @override
  void initState() {
    super.initState();
    _loadStartups();
  }

  Future<void> _loadStartups() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var data = await http.post(
        Uri.parse(prefs.getString("ip").toString() + "/startup_view_inv_card"),
        body: {'sid': prefs.getString("sid")},
      );

      var jsonData = json.decode(data.body);
      List<Startup> loadedStartups = [];

      for (var startup in jsonData["data"]) {
        loadedStartups.add(Startup(
          startup["id"].toString(),
          startup["profile_image"].toString(),
          startup["company_name"].toString(),
          startup["industry"].toString(),
          startup["location"].toString(),
          startup["email"].toString(),
          startup["website"].toString(),
          startup["description"].toString(),
          startup["liked_stat"] ?? "",
          startup["saved_stat"] ?? "",
          startup["sim_score"] ?? "",
        ));
      }

      setState(() {
        startups = loadedStartups;
        isLoading = false;
        if (startups.isNotEmpty) {
          currentLikeStatus = startups[0].likedStat;
          currentSaveStatus = startups[0].savedStat;
        }
      });
    } catch (e) {
      print("Error loading startups: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to handle like action
  Future<void> _handleLike(String invId) async {
    if (isProcessing) return;
    setState(() {
      isProcessing = true;
      currentLikeStatus = "Liked";
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await http.post(
        Uri.parse(prefs.getString("ip").toString() + "/startup_like_investor"),
        body: {
          'iid': invId,
          'startup_id': prefs.getString("sid"),
        },
      );

      if (response.statusCode == 200) {
        var decodeData = json.decode(response.body);
        print(decodeData);
        if (decodeData['type'] == "liked") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Investor liked successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        if (decodeData['type'] == "disliked") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Investor disliked successfully!'),
              backgroundColor: Colors.red.shade300,
            ),
          );
        }
      }
    } catch (e) {
      print("Error liking investor: $e");
    } finally {
      _showNextStartup();
    }
  }

  // Function to handle save profile action
  Future<void> _handleSaveProfile(String invId) async {
    if (isProcessing) return;
    setState(() {
      isProcessing = true;
      currentSaveStatus = "Saved";
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await http.post(
        Uri.parse(prefs.getString("ip").toString() + "/startup_save_inv_profile"),
        body: {
          'iid': invId,
          'startup_id': prefs.getString("sid"),
        },
      );

      if (response.statusCode == 200) {
        var decodeData = json.decode(response.body);
        print(decodeData);
        if (decodeData['type'] == "saved") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Investor saved successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        if (decodeData['type'] == "cancelled") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Investor removed successfully!'),
              backgroundColor: Colors.red.shade300,
            ),
          );
        }
      }
    } catch (e) {
      print("Error saving investor: $e");
    } finally {
      _showNextStartup();
    }
  }

  // Function to skip startup (ignore)
  Future<void> _handleSkip(String startupId) async {
    if (isProcessing) return;
    setState(() {
      isProcessing = true;
    });

    // Just show next startup without any action
    _showNextStartup();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Investor skipped'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showNextStartup() {
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          isProcessing = false;
          if (currentIndex < startups.length - 1) {
            currentIndex++;
            currentLikeStatus = startups[currentIndex].likedStat;
            currentSaveStatus = startups[currentIndex].savedStat;
          } else {
            // No more startups
            startups = [];
          }
        });
      }
    });
  }

  void _showPreviousStartup() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        currentLikeStatus = startups[currentIndex].likedStat;
        currentSaveStatus = startups[currentIndex].savedStat;
      });
    }
  }

  // Swipe gesture handling
  void _handleSwipe(DragUpdateDetails details) {
    // Left swipe - Like
    if (details.delta.dx < -10) {
      _handleLike(startups[currentIndex].id);
    }
    // Right swipe - Skip
    else if (details.delta.dx > 10) {
      _handleSkip(startups[currentIndex].id);
    }
    // Up swipe - Save
    else if (details.delta.dy < -10) {
      _handleSaveProfile(startups[currentIndex].id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Discover Investors",
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
        actions: [
          if (currentIndex > 0)
            IconButton(
              onPressed: _showPreviousStartup,
              icon: Icon(Icons.undo, color: Colors.white),
              tooltip: 'Undo',
            ),
        ],
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
              "Loading investors...",
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
              Icons.person_outline,
              size: 80,
              color: Colors.teal.shade300,
            ),
            SizedBox(height: 20),
            Text(
              "No more investors to show",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Check back later for new investors",
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

    final startup = startups[currentIndex];

    return Column(
      children: [
        // Progress indicator
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${currentIndex + 1} of ${startups.length}",
                style: TextStyle(
                  color: Colors.teal.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Swipe instructions

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: GestureDetector(
              onPanUpdate: _handleSwipe,
              child: Stack(
                children: [
                  // Startup Card
                  Container(
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
                      child: SingleChildScrollView(
                        child: Padding(
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

                              // Industry and Status Chips
                              Wrap(
                                spacing: 10,
                                children: [
                                  Chip(
                                    label: Text(startup.industry),
                                    backgroundColor: Colors.teal.shade50,
                                    labelStyle: TextStyle(color: Colors.teal.shade700),
                                  ),
                                  if (currentLikeStatus == "Liked")
                                    Chip(
                                      label: Text("Liked"),
                                      avatar: Icon(Icons.favorite, size: 16),
                                      backgroundColor: Colors.pink.shade50,
                                      labelStyle: TextStyle(color: Colors.pink.shade700),
                                    ),
                                  if (currentSaveStatus == "Saved")
                                    Chip(
                                      label: Text("Saved"),
                                      avatar: Icon(Icons.bookmark, size: 16),
                                      backgroundColor: Colors.blue.shade50,
                                      labelStyle: TextStyle(color: Colors.blue.shade700),
                                    ),
                                ],
                              ),
                              SizedBox(height: 24),

                              // Description
                              _buildSection("Bio", startup.description),
                              SizedBox(height: 20),

                              // Location
                              _buildInfoRow(Icons.location_on, "Preferred Location", startup.location),
                              SizedBox(height: 15),

                              // Email
                              _buildInfoRow(Icons.email, "Email", startup.email),
                              SizedBox(height: 15),

                              // Website
                              _buildClickableRow(Icons.language, "Website", startup.website),
                              SizedBox(height: 30),
                              // Similarity
                              _buildInfoRow(Icons.score, "Similarity", startup.sim_score),
                              SizedBox(height: 15),

                              // Action Buttons (Manual controls)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Skip Button
                                  _buildActionButton(
                                    Icons.close,
                                    "Skip",
                                    Colors.orange,
                                        () => _handleSkip(startup.id),
                                  ),

                                  // Like Button
                                  _buildActionButton(
                                    currentLikeStatus == "Liked"
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    "Like",
                                    Colors.pink,
                                        () => _handleLike(startup.id),
                                  ),

                                  // Save Button
                                  _buildActionButton(
                                    currentSaveStatus == "Saved"
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    "Save",
                                    Colors.blue,
                                        () => _handleSaveProfile(startup.id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Processing overlay
                  if (isProcessing)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.teal.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSwipeInstruction(Icons.arrow_back, "Swipe Left\nto Like", Colors.pink),
              _buildSwipeInstruction(Icons.arrow_upward, "Swipe Up\nto Save", Colors.blue),
              _buildSwipeInstruction(Icons.arrow_forward, "Swipe Right\nto Skip", Colors.orange),
            ],
          ),
        ),

      ],
    );
  }

  Widget _buildSwipeInstruction(IconData icon, String text, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        SizedBox(height: 4),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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
                      _launchUrl(url);
                    } else {
                      _launchUrl(value);
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

// Add this method to launch URLs
  Future<void> _launchUrl(String url) async {
    try {
      String urlToLaunch = url.trim();

      // Handle different types of URLs
      if (urlToLaunch.contains('@') && !urlToLaunch.contains('mailto:')) {
        // It's an email
        urlToLaunch = 'mailto:$urlToLaunch';
      } else if (urlToLaunch.contains('@') && urlToLaunch.contains('mailto:')) {
        // Already a mailto link
        // Do nothing
      } else if (!urlToLaunch.startsWith('http://') &&
          !urlToLaunch.startsWith('https://') &&
          !urlToLaunch.startsWith('tel:') &&
          !urlToLaunch.startsWith('mailto:')) {
        // Assume it's a website
        urlToLaunch = 'https://$urlToLaunch';
      }

      final Uri parsedUrl = Uri.parse(urlToLaunch);
      launchUrl(parsedUrl);
    } catch (e) {
      print('Error launching URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening URL: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: color,
            child: IconButton(
              icon: Icon(icon, color: Colors.white, size: 24),
              onPressed: onTap,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class Startup {
  final String id;
  final String profile_image;
  final String company_name;
  final String industry;
  final String location;
  final String email;
  final String website;
  final String description;
  final String likedStat;
  final String savedStat;
  final String sim_score;

  Startup(
      this.id,
      this.profile_image,
      this.company_name,
      this.industry,
      this.location,
      this.email,
      this.website,
      this.description,
      this.likedStat,
      this.savedStat,
      this.sim_score,
      );
}