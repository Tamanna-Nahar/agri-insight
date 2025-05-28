import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project1/ui/constants.dart';
import 'package:project1/ui/screen/RootPage.dart';
import 'package:project1/ui/screen/signin.dart';

class profilepage extends StatelessWidget {
  const profilepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
        );
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: constants.p1,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>  RootPage()));

          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {

            },
            icon: Icon(isDark ? LineAwesomeIcons.moon : LineAwesomeIcons.sun),
          ),
        ],
      ),
      //backgroundColor: const Color(0xFFfef7ed),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: const Image(
                    image: AssetImage('assets/images/hello.jpeg'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                user.displayName ?? 'Username',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                user.email ?? 'user@example.com',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) =>  RootPage()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.black12),
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                'Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Privacy Settings'),
                onTap: () {
                  // Navigate to Privacy Settings Page
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notification Settings'),
                onTap: () {
                  // Navigate to Notification Settings Page
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language Settings'),
                onTap: () {
                  // Navigate to Language Settings Page
                },
              ),
              const Divider(),

              // Security
              const Text(
                'Security',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password'),
                onTap: () {
                  // Navigate to Change Password Page
                },
              ),
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Two-Factor Authentication'),
                onTap: () {
                  // Navigate to Two-Factor Authentication Page
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Security Questions'),
                onTap: () {
                  // Navigate to Security Questions Page
                },
              ),
              const Divider(),

              // Preferences
              const Text(
                'Preferences',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Theme'),
                onTap: () {
                  // Navigate to Theme Settings Page
                },
              ),
              ListTile(
                leading: const Icon(Icons.interests),
                title: const Text('Content Preferences'),
                onTap: () {
                  // Navigate to Content Preferences Page
                },
              ),
              const Divider(),

              // Support
              const Text(
                'Support',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: const Icon(Icons.help_center),
                title: const Text('Help Center'),
                onTap: () {
                  // Navigate to Help Center Page
                },
              ),
              ListTile(
                leading: const Icon(Icons.contact_support),
                title: const Text('Contact Support'),
                onTap: () {
                  // Navigate to Contact Support Page
                },
              ),
              const Divider(),

              // Logout
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignIn()),
                    );
                  },
                  child: const Text('Logout'),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
