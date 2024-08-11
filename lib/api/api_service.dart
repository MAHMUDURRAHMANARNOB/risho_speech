import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/subscriptionStatusDataModel.dart';
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

  /*SUBSCRIPTION STATUS*/
  static Future<SubscriptionStatusDataModel> fetchSubscriptionStatus(
      int userId) async {
    const apiUrl = '$baseUrl/getsubscriptionDetails/';
    final Uri uri = Uri.parse('$apiUrl');
    final response = await http.post(
      uri,
      body: {'userid': userId.toString()},
      /*headers: {'Content-Type': 'application/json'},*/
    );
    /*print("Response $response");*/

    if (response.statusCode == 200) {
      print(SubscriptionStatusDataModel.fromJson(jsonDecode(response.body)));
      return SubscriptionStatusDataModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Sub status');
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
        print("errorcode: ${respon['errorcode'].runtimeType}");
        print("dialogId: ${respon['dialogid '].runtimeType}");
        print("convid: ${respon['convid'].runtimeType}");
        print("actorName: ${respon['actorName'].runtimeType}");
        print("speechText: ${respon['speechText'].runtimeType}");
        /*print("convid: ${respon['convid'].runtimeType}");
        print("convid: ${respon['convid'].runtimeType}");
        print("convid: ${respon['convid'].runtimeType}");
        print("convid: ${respon['convid'].runtimeType}");*/
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

  /*Validate Coupon Code*/
  Future<Map<String, dynamic>> getCouponDiscount({
    required String couponcode,
    required double amount,
  }) async {
    final url = '$baseUrl/getCouponDiscount';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'couponcode': couponcode.toString(),
          'amount': amount.toString(),
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

  /*Calling Agent*/
  Future<Map<String, dynamic>> getCallingAgent() async {
    final url = '$baseUrl/getCallingAgentList/';
    try {
      final response = await http.post(
        Uri.parse(url),
      );
      print("Response  $response");
      if (response.statusCode == 200) {
        // return json.decode(response.body);
        final responseMap =
            json.decode(Utf8Decoder().convert(response.bodyBytes));
        print("Response in api: ${responseMap['agentlist']}");

        return responseMap;
      } else {
        // Handle error
        return {'error': 'Failed to make API call'};
      }
    } catch (e) {
      // Handle exception
      return {'error': e.toString()};
    }
  }

  /*Call and Conversation*/
  Future<Map<String, dynamic>> callConversation({
    required int userId,
    required int agentId,
    required String sessionId,
    required File? audioFile,
    required String userName,
  }) async {
    print("sessionId: $agentId");
    try {
      var uri = Uri.parse('$baseUrl/callAndDoConversation/');
      var request = http.MultipartRequest('POST', uri)
        ..fields['userid'] = userId.toString()
        ..fields['agentId'] = agentId.toString()
        ..fields['sessionID'] = sessionId.toString()
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
        var respon = json.decode(responseBody);
        print(respon);
        /*print("SessionID: ${respon['SessionID'].runtimeType}");
        print("errorcode: ${respon['errorcode'].runtimeType}");
        print("AIDialoag: ${respon['AIDialoag'].runtimeType}");
        print("AIDialoagAudio: ${respon['AIDialoagAudio'].runtimeType}");
        print("usertext: ${respon['usertext'].runtimeType}");
        print("usertextBn: ${respon['usertextBn'].runtimeType}");
        print("useraudio: ${respon['useraudio'].runtimeType}");
        print("accuracyScore: ${respon['accuracyScore'].runtimeType}");
        print("wordscore: ${respon['wordscore'].runtimeType}");*/
        // print("SessionID: ${respon['SessionID'].runtimeType}");

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

  /*Vocabulary Category*/
  Future<Map<String, dynamic>> getVocabularyCategoryList() async {
    final url = '$baseUrl/getVocabularyCategoryList/';
    try {
      final response = await http.post(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        // return json.decode(response.body);
        final responseMap =
            json.decode(Utf8Decoder().convert(response.bodyBytes));
        // print("Response in api: ${responseMap['agentlist']}");
        print("Response in api: $responseMap");

        return responseMap;
      } else {
        // Handle error
        return {'error': 'Failed to make API call'};
      }
    } catch (e) {
      // Handle exception
      return {'error': e.toString()};
    }
  }

  /*Vocabulary Practice List*/
  Future<Map<String, dynamic>> getVocabularyList({
    required int vocaCatId,
  }) async {
    final url = '$baseUrl/getVocabularyList/';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'vocaCatId': vocaCatId.toString(),
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

  /*Vocabulary Dialog List*/
  Future<Map<String, dynamic>> getVocabularyDialogList({
    required int vocaId,
  }) async {
    final url = '$baseUrl/getVocaDialogList/';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'vocaId': vocaId.toString(),
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

  /*Vocabulary Sentence List*/
  Future<Map<String, dynamic>> getVocabularySentenceList({
    required int vocaId,
  }) async {
    final url = '$baseUrl/getVocaSentenceList/';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'vocaId': vocaId.toString(),
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

  /*Vocabulary Word Pronunciation Checker*/
  Future<Map<String, dynamic>> getVocabularyPronunciation({
    required int userId,
    required String wordText,
    required File? audioFile,
    required String categoryName,
  }) async {
    print("wordText: $wordText");
    try {
      var uri = Uri.parse('$baseUrl/validateWordPronunciation/');
      var request = http.MultipartRequest('POST', uri)
        ..fields['userid'] = userId.toString()
        ..fields['wordText'] = wordText.toString()
        ..fields['categoryName'] = categoryName.toString();
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
        /*print("SessionID: ${respon['SessionID'].runtimeType}");
        print("errorcode: ${respon['errorcode'].runtimeType}");
        print("AIDialoag: ${respon['AIDialoag'].runtimeType}");
        print("AIDialoagAudio: ${respon['AIDialoagAudio'].runtimeType}");
        print("usertext: ${respon['usertext'].runtimeType}");
        print("usertextBn: ${respon['usertextBn'].runtimeType}");
        print("useraudio: ${respon['useraudio'].runtimeType}");
        print("accuracyScore: ${respon['accuracyScore'].runtimeType}");
        print("wordscore: ${respon['wordscore'].runtimeType}");*/
        // print("SessionID: ${respon['SessionID'].runtimeType}");

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

  /*Get Package List*/
  Future<Map<String, dynamic>> getPackagesList(int userid) async {
    final url = '$baseUrl/getPackageList/';
    print("Posting in api service $url, $userid");
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'userId': userid.toString(),
          'subscriptionType': "A",
        },
      );
      print("Response:   ${response.body}");
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Response in getPackagesList else" + response.body);
        throw Exception('Failed to load data in getPackagesList');
      }
    } catch (e) {
      print("Response in getPackagesList Catch" + e.toString());
      throw Exception("Failed getPackagesList $e");
    }
  }

  /*SurjoPay*/
  static Future<void> initiatePayment(
    int userId,
    int subscriptionid,
    String transactionid,
    double amount,
    double mainAmout,
    double couponDiscountAmt,
    int? CouponPartnerID,
  ) async {
    final url = '$baseUrl/initiatepayment';
    print("Posting in api service $url");
    try {
      /*final response = await http.post(
        Uri.parse(url),
        body: {
          'userid': userId.toString(),
          'subscriptionid': subscriptionid.toString(),
          'transactionid': transactionid.toString(),
          'amount': amount.toString(),
          'mainAmout': mainAmout.toString(),
          'couponDiscountAmt': couponDiscountAmt.toString(),
          'CouponPartnerID': CouponPartnerID.toString(),
        },
      );*/
      final Map<String, String> body = {
        'userid': userId.toString(),
        'subscriptionid': subscriptionid.toString(),
        'transactionid': transactionid,
        'amount': amount.toString(),
        'mainAmout': mainAmout.toString(),
        'couponDiscountAmt': couponDiscountAmt.toString(),
      };

      // Add CouponPartnerID only if it's not null
      if (CouponPartnerID != null) {
        body['CouponPartnerID'] = CouponPartnerID.toString();
      }

      final response = await http.post(
        Uri.parse(url),
        body: body,
      );

      print("Response:   ${response.statusCode}");
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Response in initiatePayment else" + response.body);
        throw Exception('Failed to load data in getPackagesList');
      }
    } catch (e) {
      print("Response in initiatePayment Catch" + e.toString());
      throw Exception("Failed getPackagesList $e");
    }
  }

  static Future<void> receivePayment(
    int userId,
    int subscriptionid,
    String transactionid,
    String transStatus,
    double amount,
    String storeamount,
    String cardno,
    String banktran_id,
    String currency,
    String card_issuer,
    String card_brand,
    String card_issuer_country,
    String risk_level,
    String risk_title,
  ) async {
    final url = '$baseUrl/receivepayment';
    print("Posting in api service $url");
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'userid': userId.toString(),
          'subscriptionid': subscriptionid.toString(),
          'paytransid': transactionid.toString(),
          'transStatus': transStatus.toString(),
          'amount': amount.toString(),
          'storeamount': storeamount.toString(),
          'cardno': cardno.toString(),
          'banktran_id': banktran_id.toString(),
          'currency': currency.toString(),
          'card_issuer': card_issuer.toString(),
          'card_brand': card_brand.toString(),
          'card_issuer_country': card_issuer_country.toString(),
          'risk_level': risk_level.toString(),
          'risk_title': risk_title.toString(),
        },
      );
      print("Response:   ${response.statusCode}");
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Response in receivePayment else" + response.body);
        throw Exception('Failed to load data in getPackagesList');
      }
    } catch (e) {
      print("Response in receivePayment Catch" + e.toString());
      throw Exception("Failed getPackagesList $e");
    }
  }

  /*IELTS Listening Practice*/
  /*Future<Map<String, dynamic>> getIeltsListeningExam({
    required int userId,
    required int listeningPart,
    required int tokenUsed,
    required String? ansJson,
    required int? examinationId,
  }) async {
    print(
        "listeningPart: $listeningPart, $userId, $tokenUsed, $ansJson, $examinationId");
    try {
      final url = '$baseUrl/startIELTSListeningExam/';

      final response = await http.post(
        Uri.parse(url),
        body: {
          'userId': userId.toString(),
          'listeningPart': listeningPart.toString(),
          'tokenused': tokenUsed.toString(),
          'anserJson': ansJson.toString(),
          'examinationId': examinationId.toString(),
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Response in startIELTSListeningExam else" + response.body);
        throw Exception('Failed to load data in startIELTSListeningExam');
      }
    } catch (e) {
      // Handle exception
      return {'error': e.toString()};
    }
  }*/
  Future<Map<String, dynamic>> getIeltsListeningExam({
    required int userId,
    required int listeningPart,
    required int tokenUsed,
    required String? ansJson,
    required int? examinationId,
  }) async {
    print(
        "listeningPart: $listeningPart, $userId, $tokenUsed, $ansJson, $examinationId");

    try {
      final url = '$baseUrl/startIELTSListeningExam/';

      // Build the request body dynamically
      final Map<String, String> body = {
        'userId': userId.toString(),
        'listeningPart': listeningPart.toString(),
        'tokenused': tokenUsed.toString(),
      };

      // Conditionally add parameters
      if (ansJson != null && ansJson.isNotEmpty) {
        body['anserJson'] = ansJson;
      }
      if (examinationId != null) {
        body['examinationId'] = examinationId.toString();
      }

      final response = await http.post(
        Uri.parse(url),
        body: body,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Response in startIELTSListeningExam else: ${response.body}");
        throw Exception('Failed to load data in startIELTSListeningExam');
      }
    } catch (e) {
      // Handle exception
      return {'error': e.toString()};
    }
  }
}
