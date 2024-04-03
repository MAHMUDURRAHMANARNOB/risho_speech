import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
/*import 'package:risho_guru/api/responses/SubscribedCoursesResponse.dart';
import 'package:risho_guru/models/optResponseDataModel.dart';
import 'package:risho_guru/models/videoAskQuesDataModel.dart';
import '../models/askQuesDataModel.dart';
import '../models/course.dart';
import '../models/courseSubscriptionDataModel.dart';
import '../models/createUserDataModel.dart';
import '../models/getNonSubscribedCoursesDataModel.dart';
import '../models/homeworkHistoryListDataModel.dart';
import '../models/subscriptionStatusDataModel.dart';
import '../models/tools.dart';*/
import 'responses/login_response.dart';

class ApiService {
  // static const String baseUrl = 'https://testapi.risho.guru';
  static const String baseUrl = 'https://speech.risho.guru';

  /*LOGIN*/
  static Future<LoginResponse> loginApi(
      String username, String password) async {
    const apiUrl = '$baseUrl/loginuser/';

    /*for query type url*/
    final Uri uri = Uri.parse('$apiUrl?userid=$username&password=$password');
    /*Query type url*/
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    try {
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the response body
        return LoginResponse.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception or handle the error as needed
        // Handle specific HTTP error codes
        print("HTTP Error: ${response.statusCode}");
        print("Response Body: ${response.body}");
        throw Exception('Failed to login. HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other types of errors
      print("Error during loginApi: $error");
      throw Exception('Failed to login. Error: $error');
    }
  }

  /*CREATE USER*/
  static Future<bool> createUser(
      String userId,
      String username,
      String name,
      String email,
      String mobile,
      String password,
      String userType,
      String school,
      String address,
      String marketingSource) async {
    const apiUrl = '$baseUrl/creatuser/';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': userId.toString(),
          'username': username.toString(),
          'name': name.toString(),
          'email': email.toString(),
          'mobile': mobile.toString(),
          'password': password.toString(),
          'usertype': userType.toString(),
          'school': school.toString(),
          'address': address.toString(),
          'marketingSource': marketingSource.toString(),
        }),
      );

      if (response.statusCode == 200) {
        // Parse successful response
        final responseData = jsonDecode(response.body);
        if (responseData["errorcode"] == 200) {
          print("Success Response: ${response.body}");
          /*SuccessfulResponse.fromJson(jsonDecode(response.body));*/
          return true;
        } else if (responseData["errorcode"] == 400) {
          print("Failed to create user: ${responseData["message"]}");
          /*ErrorResponse.fromJson(jsonDecode(response.body));*/
          return false;
        } else {
          print("Failed to create user: ${response.body}");
          return false;
        }
      } else {
        // Parse error response
        print("Failed to create user: StatusCode ${response.statusCode}");
        return false;
      }
    } catch (e) {
      // Exception occurred
      print('Exception creating user: $e');
      return false;
    }
  }

  /*GET OTP*/
  static Future<Map<String, dynamic>> getOTP(String emailAddress) async {
    const apiUrl = '$baseUrl/getOTP/';
    final Uri uri = Uri.parse(apiUrl);

    try {
      final response = await http.post(
        uri,
        body: {'emailAddress': emailAddress.toString()},
      );
      final responseCheck = json.decode(response.body);
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        print("Response in getOTP " + response.body);
        return json.decode(response.body);
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /*FORGET PASS -> NEW PASSWORD*/
  static Future<Map<String, dynamic>> resetPassword(
      String emailAddress, String password) async {
    // const apiUrl = '$baseUrl/resetpassword/';
    final apiUrl =
        '$baseUrl/resetpassword/?userid=$emailAddress&newpassword=$password';
    final Uri uri = Uri.parse(apiUrl);

    try {
      final response = await http.post(
          /*uri,
        body: {
          'userid': emailAddress.toString(),
          'newpassword': password.toString(),
        },*/
          uri);
      final responseCheck = json.decode(response.body);
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        print("Response in resetPassword " + response.body);
        return responseCheck;
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('${response.body}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /*Conversation Response*/
  Future<Map<String, dynamic>> doConversation({
    required int userId,
    required int conversationId,
    required String sessionId,
    required File audioFile,
    required String discussionTopic,
    required String discussTitle,
    required String isFemale,
    required String userName,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl/doConversation/');
      var request = http.MultipartRequest('POST', uri)
        ..fields['userid'] = userId.toString()
        ..fields['conversationid'] = conversationId.toString()
        ..fields['sessionID'] = sessionId.toString()
        ..fields['discussionTopic'] = discussionTopic.toString()
        ..fields['discusTitle'] = discussTitle.toString()
        ..fields['isfemale'] = isFemale.toString()
        ..fields['userName'] = userName.toString()
        ..files.add(
            await http.MultipartFile.fromPath('audioFile', audioFile.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        print(json.decode(responseBody));
        return json.decode(responseBody);
      } else {
        // Handle error
        return {'error': 'Failed to make API call'};
      }
    } catch (e) {
      // Handle exception
      return {'error': e.toString()};
    }
  }
}
