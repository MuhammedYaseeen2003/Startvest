import 'package:flutter/material.dart';
import 'package:startvest_app/startup_change%20password.dart';
import 'package:startvest_app/startup_view__liked_investors.dart';
import 'package:startvest_app/startup_view__saved_investors.dart';
import 'package:startvest_app/startup_view_interested_investors.dart';
import 'package:startvest_app/startup_view_investors.dart';
import 'package:startvest_app/startup_view_investors_card.dart';
import 'package:startvest_app/startup_view_profile.dart';
import 'login.dart';

void main() {
  runApp(StartupHome());
}

class StartupHome extends StatelessWidget {
  const StartupHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.green.shade50,
      ),
      home: const StartupHomesub(),
    );
  }
}

class StartupHomesub extends StatefulWidget {
  const StartupHomesub({Key? key}) : super(key: key);

  @override
  State<StartupHomesub> createState() => _State();
}

class _State extends State<StartupHomesub> {

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
                      "Startup Dashboard.",
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
                        MaterialPageRoute(builder: (context) => startup_viewprofile()),
                      );
                    },
                    child: _homeCard(Icons.person, "Profile"),
                  ),

                  // Profile Card
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => startup_changepassword()),
                      );
                    },
                    child: _homeCard(Icons.lock, "Change Password"),
                  ),

                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => startup_view_investors()),
                  //     );
                  //   },
                  //   child: _homeCard(Icons.monetization_on, "All Investors"),
                  // ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => startup_view_investors_card()),
                      );
                    },
                    child: _homeCard(Icons.monetization_on, "Explore Investors"),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => startup_view_liked_investors()),
                      );
                    },
                    child: _homeCard(Icons.thumb_up_sharp, "Liked Investors"),
                  ),


                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => startup_view_saved_investors()),
                      );
                    },
                    child: _homeCard(Icons.favorite, "Saved Investors"),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => startup_view_interested_investors()),
                      );
                    },
                    child: _homeCard(Icons.favorite_outline, "Interested Investors"),
                  ),

                  // History Card
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
                  MaterialPageRoute(builder: (context) => StartupHome()));
            }),

            _drawerItem("Profile", Icons.person, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => startup_viewprofile()));
            }),


            _drawerItem("Investors", Icons.house, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => startup_view_investors()));
            }),

            _drawerItem("Change Password", Icons.lock, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => startup_changepassword()));
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