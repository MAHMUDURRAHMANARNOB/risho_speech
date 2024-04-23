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
  // static const String baseUrl_guru = 'https://api.risho.guru';

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
    required File? audioFile,
    required String discussionTopic,
    required String discussTitle,
    required String isFemale,
    required String userName,
  }) async {
    print("sessionId: $sessionId");
    try {
      var uri = Uri.parse('$baseUrl/doConversation/');
      var request = http.MultipartRequest('POST', uri)
        ..fields['userid'] = userId.toString()
        ..fields['conversationid'] = conversationId.toString()
        ..fields['sessionID'] = sessionId.toString()
        ..fields['discussionTopic'] = discussionTopic.toString()
        ..fields['discusTitle'] = discussTitle.toString()
        ..fields['isfemale'] = isFemale.toString()
        ..fields['userName'] = userName.toString();
      /*..files.add(
            await http.MultipartFile.fromPath('audioFile', audioFile!.path));*/
      if (audioFile != null) {
        request.files.add(
            await http.MultipartFile.fromPath('audioFile', audioFile.path));
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        // print(json.decode(responseBody));
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

  /*Guided Conversation Response*/
  Future<Map<String, dynamic>> doGuidedConversation({
    required int userId,
    required int conversationId,
    required String dialogId,
    required File? audioFile,
    required String discussionTopic,
    required String discussTitle,
    required String isFemale,
    required String userName,
    required int dialogSeqNo,
  }) async {
    print("sessionId: $dialogId");
    try {
      var uri = Uri.parse('$baseUrl/doGuidedConversation/');
      var request = http.MultipartRequest('POST', uri)
        ..fields['userid'] = userId.toString()
        ..fields['conversationid'] = conversationId.toString()
        ..fields['dialogId'] = dialogId.toString()
        ..fields['discussionTopic'] = discussionTopic.toString()
        ..fields['discusTitle'] = discussTitle.toString()
        ..fields['isfemale'] = isFemale.toString()
        ..fields['userName'] = userName.toString()
        ..fields['dialogSeqNo'] = dialogSeqNo.toString();
      /*..files.add(
            await http.MultipartFile.fromPath('audioFile', audioFile!.path));*/
      if (audioFile != null) {
        request.files.add(
            await http.MultipartFile.fromPath('audioFile', audioFile.path));
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var respon = json.decode(responseBody);
        print(respon);
        print("dialogId: ${respon['dialogId'].runtimeType}");
        print(respon['convid'].runtimeType);
        print(respon['seqNumber'].runtimeType);
        print(respon['accuracyScore'].runtimeType);
        print(respon['fluencyScore'].runtimeType);
        print(respon['completenessScore'].runtimeType);
        print(respon['prosodyScore'].runtimeType);
        // print(respon['dialogid'].runtimeType);
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

  /*Validate Spoken Sentence*/
  Future<Map<String, dynamic>> validateSentence({
    required String text,
  }) async {
    final url = '$baseUrl/validateSpokenSentence';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'text': text.toString(),
        },
      );
      print("Response  $response");
      if (response.statusCode == 200) {
        print("Response in api: ${json.decode(response.body)}");
        return json.decode(Utf8Decoder().convert(response.bodyBytes));
      } else {
        // Handle error
        return {'error': 'Failed to make API call'};
      }
    } catch (e) {
      // Handle exception
      return {'error': e.toString()};
    }
  }

  /*Spoken Lesson List*/
  Future<Map<String, dynamic>> getSpokenLessonList() async {
    final url = '$baseUrl/getSpokenLessonList';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'isGuided': "Y",
        },
      );
      print("Response  $response");
      if (response.statusCode == 200) {
        final lessonListResponse = json.decode(response.body);
        // print("Response in api: $lessonListResponse");
        return {'lessonList': lessonListResponse};
      } else {
        // Handle error
        return {'error': 'Failed to make API call'};
      }
    } catch (e) {
      // Handle exception
      return {'error': e.toString()};
    }
  }

  /*Suggest Answer*/
  Future<Map<String, dynamic>> suggestAnswer({
    required String text,
  }) async {
    final url = '$baseUrl/suggestanswer';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'text': text.toString(),
        },
      );
      print("Response  $response");
      if (response.statusCode == 200) {
        print("Response in api: ${json.decode(response.body)}");
        return json.decode(Utf8Decoder().convert(response.bodyBytes));
      } else {
        // Handle error
        return {'error': 'Failed to make API call'};
      }
    } catch (e) {
      // Handle exception
      return {'error': e.toString()};
    }
  }

  /*Next Conversation*/
  Future<Map<String, dynamic>> getNextConversation({
    required int userid,
    required int conversationid,
    required String sessionID,
    required String replyText,
    required String isfemale,
    required String userName,
  }) async {
    final url = '$baseUrl/getNextConversation/';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'userid': userid.toString(),
          'conversationid': conversationid.toString(),
          'sessionID': sessionID.toString(),
          'replyText': replyText.toString(),
          'isfemale': isfemale.toString(),
          'userName': userName.toString(),
        },
      );
      print("Response  $response");
      if (response.statusCode == 200) {
        print("Response in api: ${json.decode(response.body)}");
        return json.decode(Utf8Decoder().convert(response.bodyBytes));
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
