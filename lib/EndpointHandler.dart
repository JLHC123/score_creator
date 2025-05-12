import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:io';

class EndpointHandler{

  // Helper function to switch between Web and Emulator
  String getBaseUrl() {
    if (kIsWeb) {
      return 'https://localhost:7240'; // Edge which uses computer's localhost
    } else {
      return 'https://10.0.2.2:7240'; // Android Emulator which uses it's own Ip
    }
  }

  Future<List<dynamic>> fetchScores() async {
    http.Client client;

    if (kReleaseMode || kIsWeb) {
      client = http.Client();
    } else {
      final ioc = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      client = IOClient(ioc);
    }

    try {
      final response = await client.get(
        Uri.parse('${getBaseUrl()}/GetScoresSorted'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load scores: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching scores: $e');
    } finally {
      client.close();
    }
  }

  Future<String> loginUser(String username, String password) async
  {
    http.Client client;

    if (kReleaseMode || kIsWeb) {
      client = http.Client();
    } else {
      final ioc = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      client = IOClient(ioc);
    }

    try {
      final response = await client.post(
        Uri.parse('${getBaseUrl()}/Auth/Login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    } finally {
      client.close();
    }

  }
}
