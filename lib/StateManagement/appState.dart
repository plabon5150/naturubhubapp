import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class WeatherData extends ChangeNotifier {
  String _formattedWeatherData = 'Loading...';
  String formattedBangladeshiTime = '';
  String get formattedWeatherData => _formattedWeatherData;

  Future<void> fetchAndSetData() async {
    try {
      // Fetch Bangladeshi Time using WorldTimeAPI
      final timeResponse =
          await http.get(Uri.parse('http://worldtimeapi.org/api/Asia/Dhaka'));

      if (timeResponse.statusCode == 200) {
        Map<String, dynamic> timeData = json.decode(timeResponse.body);
        String bangladeshiTime = timeData['datetime'];

        // Formatting Bangladeshi time
        DateTime dateTime = DateTime.parse(bangladeshiTime);
        String formattedBangladeshiTime =
            DateFormat('HH:mm dd-MMM-yyyy EEEE').format(dateTime);
        print('Bangladeshi Time: $formattedBangladeshiTime');
      } else {
        print(
            'Failed to fetch time data. Status code: ${timeResponse.statusCode}');
      }

      // Fetch Chittagong Weather using OpenWeatherMap (replace 'YOUR_API_KEY' with your actual API key)
      final weatherResponse = await http.get(Uri.parse(
          'http://api.openweathermap.org/data/2.5/weather?q=Chittagong&appid=4a47bb758c709ec752caa22f5d41fd4c'));

      if (weatherResponse.statusCode == 200) {
        Map<String, dynamic> weatherData = json.decode(weatherResponse.body);
        double temperature = weatherData['main']['temp'];

        // Formatting Chittagong temperature
        String formattedTemperature = '$temperature \u2103';

        // You can further extract day/night information from 'weatherData' based on your requirements.
        // For simplicity, let's assume day/night information is in the 'weather' array.
        List<dynamic> weatherList = weatherData['weather'];
        String dayNightInfo =
            weatherList.isNotEmpty ? weatherList[0]['description'] : '';

        // Combining all information into a single string
        _formattedWeatherData =
            '$formattedTemperature $formattedBangladeshiTime $dayNightInfo';

        // Notify listeners that the data has changed
        notifyListeners();
      } else {
        print(
            'Failed to fetch weather data. Status code: ${weatherResponse.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
