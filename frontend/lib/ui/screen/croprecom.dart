import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CropRecommendationForm extends StatefulWidget {
  @override
  _CropRecommendationFormState createState() => _CropRecommendationFormState();
}

class _CropRecommendationFormState extends State<CropRecommendationForm> {
  final TextEditingController nController = TextEditingController();
  final TextEditingController pController = TextEditingController();
  final TextEditingController kController = TextEditingController();
  final TextEditingController temperatureController = TextEditingController();
  final TextEditingController humidityController = TextEditingController();
  final TextEditingController phController = TextEditingController();
  final TextEditingController rainfallController = TextEditingController();

  String _predictedCrop = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Recommendation', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal[700],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(nController, 'Nitrogen', 'Enter Nitrogen content', Icons.grain),
              _buildTextField(pController, 'Phosphorus', 'Enter Phosphorus content', Icons.grain),
              _buildTextField(kController, 'Potassium', 'Enter Potassium content', Icons.grain),
              _buildTextField(temperatureController, 'Temperature', 'Enter temperature', Icons.thermostat),
              _buildTextField(humidityController, 'Humidity', 'Enter humidity percentage', Icons.water_drop),
              _buildTextField(phController, 'pH Level', 'Enter soil pH', Icons.local_florist),
              _buildTextField(rainfallController, 'Rainfall', 'Enter rainfall amount', Icons.cloud),

              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _getRecommendation,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.teal[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Get Recommendation',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (_predictedCrop.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      'Predicted Crop: $_predictedCrop',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[700],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField(TextEditingController controller, String labelText, String hintText, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.teal[400]),
          labelStyle: TextStyle(color: Colors.teal[700], fontWeight: FontWeight.w600),
          prefixIcon: Icon(icon, color: Colors.teal),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal, width: 1.5),
          ),
        ),
      ),
    );
  }

  // Function to handle the recommendation logic
  void _getRecommendation() async {
    if (nController.text.isNotEmpty && pController.text.isNotEmpty &&
        kController.text.isNotEmpty && temperatureController.text.isNotEmpty &&
        humidityController.text.isNotEmpty && phController.text.isNotEmpty &&
        rainfallController.text.isNotEmpty) {

      setState(() {
        _isLoading = true;
      });

      var data = {
        'nitrogen': nController.text,
        'phosphorus': pController.text,
        'potassium': kController.text,
        'temperature': temperatureController.text,
        'humidity': humidityController.text,
        'ph': phController.text,
        'rainfall': rainfallController.text,
      };

      try {
        // Making the API call
        var response = await http.post(
          Uri.parse('http://127.0.0.1:5000/predict'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data),
        );

        print("Response Status: ${response.statusCode}"); // Debugging print

        if (response.statusCode == 200) {
          // If the server returns a valid response
          var responseData = json.decode(response.body);
          print("Response Data: $responseData");  // Debugging print
          setState(() {
            _predictedCrop = responseData['predicted_crop'];
            _isLoading = false;
          });
        } else {
          // Handle server errors
          setState(() {
            _isLoading = false;
            _predictedCrop = 'Error fetching recommendation';
          });
        }
      } catch (e) {
        // Catch any errors in the API call
        print("Error: $e"); // Debugging print
        setState(() {
          _isLoading = false;
          _predictedCrop = 'Failed to fetch data';
        });
      }
    } else {
      setState(() {
        _predictedCrop = 'Please fill all fields';
      });
    }
  }
}
