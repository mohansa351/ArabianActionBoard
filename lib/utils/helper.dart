import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'common_widgets.dart';


class NetworkHelper {
  NetworkHelper({
    required this.url,
  });
  final String url;

  Future postData(Map<String, String> bodyData) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll(bodyData);
      http.StreamedResponse response =
          await request.send().timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);
        return responseData;
      }
    } on SocketException {
      showToast("Network issue");
      return null;
    } on HttpException {
      return null;
    } on FormatException {
      showToast("Server error");
      return null;
    } on TimeoutException {
      showToast("Time out");
      return null;
    } on Exception {
      showToast("Something went wrong");
      return null;
    } catch (e) {
      showToast("Exception");
      return null;
    }
  }


Future getData() async {
  try {
    // Build the complete URL with query parameters
    var uri = Uri.parse(url);

    // Perform the GET request
    var response = await http
        .get(uri)
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      // Parse the response body
      var responseData = json.decode(response.body);
      return responseData;
    } else {
      showToast("Server error: ${response.statusCode}");
      return null;
    }
  } on SocketException {
    showToast("Network issue");
    return null;
  } on HttpException {
    showToast("HTTP error");
    return null;
  } on FormatException {
    showToast("Server response format error");
    return null;
  } on TimeoutException {
    showToast("Request timed out");
    return null;
  } on Exception {
    showToast("Something went wrong");
    return null;
  } catch (e) {
    showToast("Unexpected error: $e");
    return null;
  }
}



}
