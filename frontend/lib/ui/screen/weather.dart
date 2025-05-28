import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project1/ui/screen/RootPage.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _controller = TextEditingController();
  late Position _currentPosition;
  String _currentCity = '';
  List<dynamic> _forecast = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _errorMessage = 'Location services are disabled.';
        _isLoading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _errorMessage =
        'Location permissions are permanently denied, we cannot request permissions.';
        _isLoading = false;
      });
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _errorMessage = 'Location permissions are denied.';
          _isLoading = false;
        });
        return;
      }
    }

    _currentPosition = await Geolocator.getCurrentPosition();
    _fetchLocationName();
    _fetchWeather();
  }

  Future<void> _fetchLocationName() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      setState(() {
        _currentCity = placemarks[0].locality ?? '';
      });
    } catch (e) {
      //print('Error fetching location: $e');
      setState(() {
        _currentCity = 'Unknown';
      });
    }
  }

  Future<void> _fetchWeather() async {
    final apiKey = 'YOUR_API_KEY';
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?lat=${_currentPosition.latitude}&lon=${_currentPosition.longitude}&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _forecast = data['list'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load weather data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Unable to fetch weather data';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchWeatherByCity(String cityName) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final apiKey = 'ur api';
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _forecast = data['list'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load weather data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Unable to fetch weather data';
        _isLoading = false;
      });
    }
  }

  String _getWeatherIcon(String icon) {
    return 'https://openweathermap.org/img/wn/$icon@2x.png';
  }

  Widget _buildForecastItem(dynamic item) {
    final dateTime = DateTime.parse(item['dt_txt']);
    final temp = item['main']['temp'];
    final description = item['weather'][0]['description'];
    final icon = item['weather'][0]['icon'];

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 5.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${dateTime.day}/${dateTime.month} ${dateTime.hour}:00',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Image.network(_getWeatherIcon(icon)),
            Text('${temp.toString()}°C'),
            Text(description),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) =>  RootPage()),
          ),
        ),
        title: const Text('Weather Forecast'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Search City',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        _fetchWeatherByCity(_controller.text);
                      },
                    ),
                  ),
                  onSubmitted: (String value) {
                    _fetchWeatherByCity(value);
                  },
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? Center(
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              )
                  : _forecast.isEmpty
                  ? Center(
                child: Text('No weather data available.'),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Current Location: $_currentCity',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _forecast.length,
                      itemBuilder: (context, index) {
                        return _buildForecastItem(_forecast[index]);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
