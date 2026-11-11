import 'package:flutter/material.dart';
import 'inv_change password.dart';
import 'inv_view__liked_startups.dart';
import 'inv_view__saved_startups.dart';
import 'inv_view_interested_startups.dart';
import 'inv_view_profile.dart';
import 'inv_view_startups.dart';
import 'login.dart';

void main() {
  runApp(InvestorHome());
}

class InvestorHome extends StatelessWidget {
  const InvestorHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.green.shade50,
      ),
      home: const UserHomesub(),
    );
  }
}

class UserHomesub extends StatefulWidget {
  const UserHomesub({Key? key}) : super(key: key);

  @override
  State<UserHomesub> createState() => _State();
}

class _State extends State<UserHomesub> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Start Vest"),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: Colors.green.shade100,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: const [
                    Icon(Icons.laptop, size: 80, color: Colors.green),
                    SizedBox(height: 10),
                    Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Investor Dashboard.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [


                  // Profile Card
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => inv_viewprofile()),
                      );
                    },
                    child: _homeCard(Icons.person, "Profile"),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => inv_changepassword()),
                      );
                    },
                    child: _homeCard(Icons.lock, "Change Password"),
                  ),

                  // History Card
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => inv_view_startups()),
                      );
                    },
                    child: _homeCard(Icons.build, "Startups"),
                  ),
                  // History Card
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => inv_view_liked_startups()),
                      );
                    },
                    child: _homeCard(Icons.favorite_rounded, "Liked Startups"),
                  ),
                  // History Card
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => inv_view_saved_startups()),
                      );
                    },
                    child: _homeCard(Icons.bookmark_rounded, "Saved Startups"),
                  ),
                  // History Card
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => inv_view_interested_startups()),
                      );
                    },
                    child: _homeCard(Icons.favorite_border, "Interested Startups"),
                  ),

                  // Waste Entry Card
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => login()),
                      );
                    },
                    child: _homeCard(Icons.logout, "Logout"),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),

      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green.shade700,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(Icons.laptop, size: 50, color: Colors.white),
                  SizedBox(height: 10, width: double.infinity,),
                  Text(
                    "Start Vest",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                ],
              ),
            ),

            _drawerItem("Home", Icons.home, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InvestorHome()));
            }),

            _drawerItem("Profile", Icons.person, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => inv_viewprofile()));
            }),

            _drawerItem("Startups", Icons.list, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => inv_view_startups()));
            }),

            _drawerItem("Liked Startups", Icons.favorite_rounded, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => inv_view_liked_startups()));
            }),

            _drawerItem("Saved Startups", Icons.bookmark_rounded, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => inv_view_saved_startups()));
            }),

            _drawerItem("Change Password", Icons.lock, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => inv_changepassword()));
            }),

            const Divider(),

            _drawerItem("Logout", Icons.logout, () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => login()));
            }),

          ],
        ),
      ),
    );
  }

  Widget _drawerItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _homeCard(IconData icon, String title) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.green.shade700),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }

}