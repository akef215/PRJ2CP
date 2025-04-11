// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
//
// class ApiService {
//   static const String baseUrl = "http://192.168.1.3:8000";
//
//   static Future<bool> sendFeedback(String feedback) async {
//     final url = Uri.parse('$baseUrl/feedback/').replace(queryParameters: {
//       'description': feedback,
//       'groupe': '1CP1',
//       'module': 'ALG1'
//     });
//
//
//     print("🚀 Envoi à : $url"); // Vérifier l'URL envoyée
//
//     try {
//       final response = await http.post(url);
//
//       print("📡 Statut : ${response.statusCode}");
//       print("📩 Réponse : ${response.body}");
//
//       return response.statusCode == 200;
//     } catch (e) {
//       print("❌ Erreur : $e");
//       return false;
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.1.3:8000";

  static Future<bool> sendFeedback(String feedback) async {
    final url = Uri.parse('$baseUrl/feedback/');

    print("🚀 Envoi à : $url"); // Vérifier l'URL envoyée

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "description": feedback,
          "groupe": "1CP1",
          "module": "ALG1"
        }),
      );

      print("📡 Statut : ${response.statusCode}");
      print("📩 Réponse : ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("❌ Erreur : $e");
      return false;
    }
  }
}
