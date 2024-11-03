import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:naturub/Models/company.dart';
import 'package:naturub/Models/productionBoxModel.dart';
import 'package:naturub/Models/productionModel.dart';
import 'package:naturub/Models/requestDetailsSMS.dart';
import 'package:naturub/Models/sectionModel.dart';
import 'package:naturub/Models/sectionwiseuser.dart';
import 'package:naturub/Models/smsDispatchDetails.dart';
import 'package:naturub/Models/user.dart';
import 'package:naturub/Models/weightScaleModel.dart';
import 'package:naturub/sharedDate/appData.dart';

class HttpService {
  final String userapi =
      "http://192.168.1.253/NaturubWebAPITestDemo/api/Sample";
  final String testingAPI =
      "http://192.168.1.253/NaturubWebAPITestDemo/api/Production";
  final String localAPI =
      "http://192.168.1.253/NaturubWebAPITestDemo/api/Production";
  final String ReqAPI = "http://192.168.1.253/NaturubWebAPITestDemo/api/Budget";

  Future<dynamic> validLogin(String userName, String password, context) async {
    //ToastContext.init(context);
    final url = Uri.parse("$userapi/IsValidUser");
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {"UserName": userName, "PassWord": password};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    try {
      Response response = await post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      if (response.statusCode == 200) {
        dynamic responseBody = json.decode(response.body);

        if (responseBody is List) {
          // It's a list, so parse it as a list of User objects
          return responseBody.map((entry) => User.fromJson(entry)).toList();
        } else if (responseBody is Map && responseBody.containsKey('error')) {
          showToastWidget(
              const Text('Invalid username or password',
                  selectionColor: Colors.red),
              duration: Duration(seconds: 5),
              context: context);
          return 'User not found';
        } else {
          showToastWidget(
              const Text('Invalid username or password',
                  selectionColor: Colors.red),
              duration: Duration(seconds: 5),
              context: context);
          throw Exception('Unexpected response format');
        }
      } else {
        showToastWidget(
            const Text('Invalid username or password',
                selectionColor: Colors.red),
            duration: Duration(seconds: 5),
            context: context);

        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      showToastWidget(const Text('Invalid username or password'),
          context: context);
      throw Exception('Failed to load data. Error: $e');
    }
  }

  Future<List<RequestDetails>> mktDetailsByBarcode(String itemBarcode) async {
    final url = Uri.parse("$userapi/GetNotAcceptedJobByBarcode");
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {"ItemBarcode": itemBarcode};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    try {
      Response response = await post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((entry) => RequestDetails.fromJson(entry))
            .toList();
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data. Error: $e');
    }
  }

  Future<List<ProductionModel>> getMachineForActualStart() async {
    //ToastContext.init(context);
    final url = Uri.parse("$testingAPI/GetMCNoForAcutalStart");
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {"Company": 1};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    try {
      Response response = await post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((entry) => ProductionModel.fromJson(entry))
            .toList();
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data. Error: $e');
    }
  }

  Future<List<ProductionModel>> getMachineUsingSection(int SectionID) async {
    final url = Uri.parse("$testingAPI/GetProductionMachineUsingSection");
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {"SECTION_ID": SectionID};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    try {
      Response response = await post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((entry) => ProductionModel.fromJson(entry))
            .toList();
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data. Error: $e');
    }
  }

  Future<List<BoxModel>> getBoxDetails(String Barcode) async {
    //ToastContext.init(context);
    final url = Uri.parse("$testingAPI/GetBoxDetailsByBarcode");
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {"Barcode": Barcode};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    try {
      Response response = await post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((entry) => BoxModel.fromJson(entry)).toList();
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data. Error: $e');
    }
  }

  Future<List<ProductionModel>> getJobDetailsUsingBoxBarcode(
      String Barcode) async {
    //ToastContext.init(context);
    final url = Uri.parse("$testingAPI/GetJobDetailsForDispatch");
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {"Barcode": Barcode};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    try {
      Response response = await post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        print(response.body);
        return jsonResponse
            .map((entry) => ProductionModel.fromJson(entry))
            .toList();
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data. Error: $e');
    }
  }

  Future<List<Section>> getSection() async {
    //ToastContext.init(context);
    final url = Uri.parse("$testingAPI/GetProductionSection");
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {"Section": 1};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    try {
      Response response = await post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        print(response.body);
        return jsonResponse.map((entry) => Section.fromJson(entry)).toList();
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data. Error: $e');
    }
  }

  Future<List<Section>> getPackingSection() async {
    try {
      Response response = await get(Uri.parse("$testingAPI/GetPackingSection"));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        print(response.body);
        return jsonResponse.map((entry) => Section.fromJson(entry)).toList();
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data. Error: $e');
    }
  }

  Future<List<WeightMachine>> getWeightFromScale() async {
    //ToastContext.init(context);
    final url = Uri.parse("$testingAPI/GetWeightValue");
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {"Scale": 1};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    try {
      Response response = await post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        print(response.body);
        return jsonResponse
            .map((entry) => WeightMachine.fromJson(entry))
            .toList();
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data. Error: $e');
    }
  }

  Future<List<Company>> getCompany() async {
    try {
      Response response = await get(Uri.parse("$ReqAPI/GetCompanies"));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        print(response.body);
        return jsonResponse.map((entry) => Company.fromJson(entry)).toList();
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data. Error: $e');
    }
  }

  Future<List<ProductionModel>> getJobDetailsAcceptUsingBoxBarcode(
      String Barcode) async {
    //ToastContext.init(context);
    final url = Uri.parse("$testingAPI/GetJobDetailsForAccept");
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {"Barcode": Barcode};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    try {
      Response response = await post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((entry) => ProductionModel.fromJson(entry))
            .toList();
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data. Error: $e');
    }
  }

  Future<String> saveBoxAssign(List<BoxModel> boxList) async {
    final url = Uri.parse("$localAPI/SaveProductionBoxAssign");
    final headers = {'Content-Type': 'application/json'};

    List<Map<String, dynamic>> jsonList =
        boxList.map((box) => box.toJson()).toList();
    String jsonBody = json.encode(jsonList);

    final encoding = Encoding.getByName('utf-8');

    try {
      Response response = await post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Check if the response body is a raw string or JSON
        var responseBody = response.body;

        // If it's a raw string, return it directly
        if (responseBody.startsWith('{') || responseBody.startsWith('[')) {
          // If it looks like JSON (starts with '{' or '['), decode it
          var jsonResponse = json.decode(responseBody);

          // Check for a message field and return it
          if (jsonResponse is Map<String, dynamic> &&
              jsonResponse.containsKey('message')) {
            return jsonResponse['message']; // Return the success message
          } else {
            return 'Success, but no message field found';
          }
        } else {
          // If it's a plain string, return it directly
          return responseBody;
        }
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data. Error: $e');
    }
  }

  Future<String> saveDailyAccept(List<ProductionModel> boxList) async {
    final url = Uri.parse("$localAPI/SaveDailyProductionForAccept");
    final headers = {'Content-Type': 'application/json'};
    List<Map<String, dynamic>> jsonList =
        boxList.map((box) => box.toJson()).toList();
    String jsonBody = json.encode(jsonList);
    final encoding = Encoding.getByName('utf-8');
    try {
      Response response = await post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Check if the response body is a raw string or JSON
        var responseBody = response.body;

        // If it's a raw string, return it directly
        if (responseBody.startsWith('{') || responseBody.startsWith('[')) {
          // If it looks like JSON (starts with '{' or '['), decode it
          var jsonResponse = json.decode(responseBody);

          // Check for a message field and return it
          if (jsonResponse is Map<String, dynamic> &&
              jsonResponse.containsKey('message')) {
            return jsonResponse['message']; // Return the success message
          } else {
            return 'Success, but no message field found';
          }
        } else {
          // If it's a plain string, return it directly
          return responseBody;
        }
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data. Error: $e');
    }
  }

  Future<String> saveDailyDispatch(List<ProductionModel> boxList) async {
    final url = Uri.parse("$localAPI/SaveDailyProductionForDispatch");
    final headers = {'Content-Type': 'application/json'};

    List<Map<String, dynamic>> jsonList =
        boxList.map((box) => box.toJson()).toList();
    String jsonBody = json.encode(jsonList);

    final encoding = Encoding.getByName('utf-8');

    try {
      Response response = await post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Check if the response body is a raw string or JSON
        var responseBody = response.body;

        // If it's a raw string, return it directly
        if (responseBody.startsWith('{') || responseBody.startsWith('[')) {
          // If it looks like JSON (starts with '{' or '['), decode it
          var jsonResponse = json.decode(responseBody);

          // Check for a message field and return it
          if (jsonResponse is Map<String, dynamic> &&
              jsonResponse.containsKey('message')) {
            return jsonResponse['message']; // Return the success message
          } else {
            return 'Success, but no message field found';
          }
        } else {
          // If it's a plain string, return it directly
          return responseBody;
        }
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data. Error: $e');
    }
  }

  Future<List<ProductionModel>> getJobDetailsForActualStart(int JobID) async {
    //ToastContext.init(context);
    final url = Uri.parse("$testingAPI/GetJobDetailsByMCNo");
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "MachineBarcode": "123366452",
      "intJobID": JobID
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    try {
      Response response = await post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((entry) => ProductionModel.fromJson(entry))
            .toList();
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data. Error: $e');
    }
  }

  Future<List<ProductionModel>> getJobListStart(
      int Section, int intMCID) async {
    //ToastContext.init(context);
    final url = Uri.parse("$testingAPI/GetStartedJobByMCNo");
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {"intMCID": intMCID, "SectionID": Section};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    try {
      Response response = await post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((entry) => ProductionModel.fromJson(entry))
            .toList();
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data. Error: $e');
    }
  }

  Future<List<SmsDispacthDetails>> dispatchDetailsSection(
      String sampleCode) async {
    //ToastContext.init(context);
    final url = Uri.parse("$userapi/GetProcessAcceptDispatch");
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {"SampleCode": sampleCode};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    try {
      Response response = await post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((entry) => SmsDispacthDetails.fromJson(entry))
            .toList();
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data. Error: $e');
    }
  }

  Future<List<sectionwiseuser>> getSectionByUserID(int empID) async {
    List<sectionwiseuser> sectionwiseuserList = [];
    final url = Uri.parse("$userapi/GetUserWiseSection");
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {"EmpID": empID};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    try {
      Response response = await post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        sectionwiseuserList = jsonResponse
            .map((entry) => sectionwiseuser.fromJson(entry))
            .toList();

        // Save the data to SharedPreferences
        await AppData.setSectionUserWise(sectionwiseuserList);
        return sectionwiseuserList;
      } else {
        await AppData.setSectionUserWise(sectionwiseuserList);
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      await AppData.setSectionUserWise(sectionwiseuserList);
      throw Exception('Failed to load data. Error: $e');
    }
  }

  Future<bool> smsJobAccept(
      int sampleDispatchHeaderID,
      int empID,
      bool bIsSectionDispatchCompleted,
      int sampleDispatchDetailID,
      double decSampleDispatchQty,
      int dispatchMeasureUnitID) async {
    //ToastContext.init(context);
    final url = Uri.parse("$userapi/SaveAcceptedJobByBarcode");
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "SampleDispatchHeaderID": sampleDispatchHeaderID,
      "EmpID": empID,
      "bIsSectionDispatchCompleted": bIsSectionDispatchCompleted,
      "SampleDispatchDetailID": sampleDispatchDetailID,
      "decSampleDispatchQty": decSampleDispatchQty,
      "DispatchMeasureUnitID": dispatchMeasureUnitID
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    try {
      Response response = await post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      if (response.statusCode == 200) {
        bool jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data. Error: $e');
    }
  }

  Future<String> fetchBangladeshiTimeAndChittagongWeather() async {
    String formattedBangladeshiTime = "";
    try {
      // Fetch Bangladeshi Time using WorldTimeAPI
      final timeResponse =
          await get(Uri.parse('http://worldtimeapi.org/api/Asia/Dhaka'));

      if (timeResponse.statusCode == 200) {
        Map<String, dynamic> timeData = json.decode(timeResponse.body);
        String bangladeshiTime = timeData['datetime'];
        // Formatting Bangladeshi time
        DateTime dateTime = DateTime.parse(bangladeshiTime);
        formattedBangladeshiTime =
            DateFormat('HH:mm dd-MMM-yyyy EEEE').format(dateTime);
        print('Bangladeshi Time: $formattedBangladeshiTime');
      } else {
        print(
            'Failed to fetch time data. Status code: ${timeResponse.statusCode}');
      }

      // Fetch Chittagong Weather using OpenWeatherMap (replace 'YOUR_API_KEY' with your actual API key)
      final weatherResponse = await get(Uri.parse(
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
        String result =
            '$formattedTemperature $formattedBangladeshiTime $dayNightInfo';
        return result;
      } else {
        print(
            'Failed to fetch weather data. Status code: ${weatherResponse.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }

    // Return a default string in case of an error
    return 'Error fetching data';
  }
}
