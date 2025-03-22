import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'calender.dart';
import 'eventscreen.dart';
import 'newspage.dart';
import 'notifications.dart';
import 'profile_page.dart';
import 'weather.dart';
import 'croprecom.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  String weather = 'Fetching...';
  String temperature = '0°C';
  String location = 'Unknown';
  String humidity = '0%';
  String precipitation = '0 mm';
  String pressure = '0 hPa';
  String wind = '0 km/h';
  String weatherIcon = '';
  List newsArticles = [];

  LatLng _currentLocation = const LatLng(28.500533, 77.409783); // Default coordinates
  String userName = "User"; // Default user name

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Fetch current location
    _fetchNews();

    // Fetch the logged-in user's display name from Firebase
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userName = user.displayName ?? "User";
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
      _fetchWeather();
    } catch (e) {
      setState(() {
        location = 'Unable to get location';
        weather = 'Error';
      });
    }
  }

  Future<void> _fetchWeather() async {
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=${_currentLocation.latitude}&lon=${_currentLocation.longitude}&appid=d9ad5815389189f0612e3f3d7a31aa25&units=metric'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        weather = data['weather'][0]['description'];
        temperature = '${data['main']['temp']}°C';
        location = data['name'];
        humidity = '${data['main']['humidity']}%';
        pressure = '${data['main']['pressure']} hPa';
        wind = '${data['wind']['speed']} km/h';
        weatherIcon = 'https://openweathermap.org/img/wn/${data['weather'][0]['icon']}.png';
      });
    } else {
      setState(() {
        weather = 'Error';
        temperature = '0°C';
        location = 'Unknown';
        humidity = '0%';
        pressure = '0 hPa';
        wind = '0 km/h';
        weatherIcon = '';
      });
    }
  }

  Future<void> _fetchNews() async {
    final response = await http.get(Uri.parse('https://newsapi.org/v2/everything?q=agriculture&apiKey=927a4244a6af4b3abc1c71b38568d169'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        newsArticles = data['articles'];
      });
    } else {
      setState(() {
        newsArticles = [];
      });
    }
  }

  void _openGoogleMaps() async {
    final url = 'https://www.google.com/maps/search/?api=1&query=${_currentLocation.latitude},${_currentLocation.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open Google Maps';
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.person, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const profilepage()));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const notification()));
            },
          ),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildGreeting(),
              _buildWeatherCard(),
              _buildHorizontalCardSection(),
              _buildMapCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        '${_getGreeting()}, $userName!',
        style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black
        ),
      ),
    );
  }

  Widget _buildWeatherCard() {
    return Container(

      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weather in $location',
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (weatherIcon.isNotEmpty)
                Image.network(weatherIcon, width: 50),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weather,
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  Text(
                    temperature,
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          _buildWeatherDetailRow('Humidity', humidity),
          _buildWeatherDetailRow('Precipitation', precipitation),
          _buildWeatherDetailRow('Pressure', pressure),
          _buildWeatherDetailRow('Wind', wind),
        ],
      ),
    );
  }

  Widget _buildWeatherDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 14)),
          Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildHorizontalCardSection() {
    return Container(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildSectionCard('Farming News', Icons.newspaper, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const NewsScreen()));
          }),
          _buildSectionCard('Weather', Icons.sunny_snowing, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const WeatherScreen()));
          }),
          _buildSectionCard('Market Rates', Icons.attach_money, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => EventScreen()));
          }),
          _buildSectionCard('Crop Recommendations', Icons.agriculture, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => CropRecommendationForm()));
          }),
          _buildSectionCard('Farming Calendar', Icons.calendar_month, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => CalendarScreen()));
          }),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapCard() {
    return GestureDetector(
      onTap: _openGoogleMaps,
      child: Container(
        height: 300,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _currentLocation,
            zoom: 14.0,
          ),
          onMapCreated: (GoogleMapController controller) {
            // Add map initialization logic if needed
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
      ),
    );
  }
}
