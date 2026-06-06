import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/transaction_model.dart';
import 'auth_service.dart';

class TransactionService {
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Ambil riwayat transaksi user
  Future<List<TransactionModel>> getMyTransactions() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/transactions'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data['data'];
      return list.map((item) => TransactionModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data transaksi');
    }
  }

  // Beli resource
  Future<Map<String, dynamic>> buyResource(int resourceId, int quantity) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/transactions/buy'),
      headers: headers,
      body: jsonEncode({
        'resource_id': resourceId,
        'quantity': quantity,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return {'success': true, 'message': data['message'], 'data': data['transaction']};
    } else {
      return {'success': false, 'message': data['message']};
    }
  }
}
