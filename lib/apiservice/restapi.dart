import 'dart:io';
import 'package:http/http.dart' as http;

class Url {
  static const String baseUrl = 'http://portal.prospectatech.com/maintenanceApp/api';
  // static const String baseUrl = 'https://billspayeadmin.in/maintenanceApp/api';
}

class ApiService {
  static Future get(
      url,
      ) async {
    try {
      final response =
      await http.get(Uri.parse('${Url.baseUrl}/$url'), headers: {
        'Authorization': 'b8416f2680eb194d61b33f9909f94b9d',
        'Content-Type': 'application/json'
      });
      print(HttpHeaders.requestHeaders);
      print('${Url.baseUrl}/$url');
      print(response.statusCode);
      return response;
    } catch (e) {
      return e;
    }
  }

  static Future post(url, body) async {
    try {
      final response = await http.post(Uri.parse('${Url.baseUrl}/$url'),
          headers: {
            'Authorization': 'b8416f2680eb194d61b33f9909f94b9d',
            'Content-Type': 'application/json'
          },
          body: body);
      print(HttpHeaders.requestHeaders);
      print('${Url.baseUrl}/$url');
      print(response.statusCode);
      return response;
    } catch (e) {
      return e;
    }
  }

  static Future<String> saveProfile(
      String url,
      String firstName,
      String lastName,
      String emailID,
      String mobNum,
      String stateID,
      String cityID,
      String pinCode,
      String userID,
      String profileFilepath,
      ) async {
    var postUri = Uri.parse('${Url.baseUrl}/$url');

    http.MultipartRequest request = http.MultipartRequest("POST", postUri);

    Map<String, String> headers = {
      'Authorization': 'b8416f2680eb194d61b33f9909f94b9d',
      "Content-Type": "multipart/form-data",
    };
    http.MultipartFile multipartFile =
    await http.MultipartFile.fromPath('profile_pic', profileFilepath);

    request.files.add(multipartFile);
    request.headers.addAll(headers);

    request.fields["first_name"] = firstName;
    request.fields["last_name"] = lastName;
    request.fields["email"] = emailID;
    request.fields["mobile_number"] = mobNum;
    request.fields["state_id"] = stateID;
    request.fields["city_id"] = cityID;
    request.fields["pincode"] = pinCode;
    request.fields["user_id"] = userID;

    http.StreamedResponse response = await request.send();

    return response.stream.bytesToString();
  }
}
