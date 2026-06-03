import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/resource_model.dart';
import 'auth_service.dart';

class ResourceService {
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Ambil semua resource
  Future<List<ResourceModel>> getAllResources() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/resources'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data['data'];
      return list.map((item) => ResourceModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data resource');
    }
  }

  // Tambah resource baru
  Future<Map<String, dynamic>> addResource(Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/resources'),
      headers: headers,
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return {'success': true, 'message': data['message']};
    } else {
      return {'success': false, 'message': data['message']};
    }
  }

  // Update resource
  Future<Map<String, dynamic>> updateResource(int id, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/resources/$id'),
      headers: headers,
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return {'success': true, 'message': data['message']};
    } else {
      return {'success': false, 'message': data['message']};
    }
  }

  // Hapus resource
  Future<Map<String, dynamic>> deleteResource(int id) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/resources/$id'),
      headers: headers,
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return {'success': true, 'message': data['message']};
    } else {
      return {'success': false, 'message': data['message']};
    }
  }
}
