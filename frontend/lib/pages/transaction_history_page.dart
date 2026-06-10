import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final TransactionService _transactionService = TransactionService();
  List<TransactionModel> _transactions = [];
  bool _isLoading = true;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    try {
      final data = await _transactionService.getMyTransactions();
      setState(() {
        _transactions = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMsg = 'Gagal memuat riwayat: $e';
        _isLoading = false;
      });
    }
  }

  String _formatPrice(double price) {
    final formatted = price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return 'Rp $formatted';
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pembelian'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: kAccentColor),
            onPressed: _loadTransactions,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: kBackgroundGradient),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: kAccentColor))
            : _errorMsg != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            color: kErrorColor, size: 48),
                        const SizedBox(height: 12),
                        Text(_errorMsg!,
                            style: const TextStyle(color: kErrorColor)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                            onPressed: _loadTransactions,
                            child: const Text('Coba Lagi')),
                      ],
                    ),
                  )
                : _transactions.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long,
                                color: kTextMuted, size: 64),
                            SizedBox(height: 16),
                            Text(
                              'Belum ada transaksi',
                              style: TextStyle(
                                  color: kTextMuted,
                                  fontFamily: kFontFamily,
                                  fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Yuk beli resource favoritmu!',
                              style: TextStyle(
                                  color: kTextMuted,
                                  fontFamily: kFontFamily,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _transactions.length,
                        itemBuilder: (context, index) {
                          final trx = _transactions[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: kSecondaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: kAccentColor.withOpacity(0.3)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: trx.resourceImage.isNotEmpty ? Image.asset(
                                        'assets/images/${trx.resourceImage}',
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const Icon(Icons.auto_awesome, color: kAccentColor, size: 24),
                                      )
                                      : const Icon(Icons.auto_awesome, color: kAccentColor, size: 24),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          trx.resourceName,
                                          style: const TextStyle(
                                            color: kTextLight,
                                            fontFamily: kFontFamily,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'x${trx.quantity} item',
                                          style: const TextStyle(
                                              color: kTextMuted,
                                              fontSize: 12,
                                              fontFamily: kFontFamily),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          _formatDate(trx.createdAt),
                                          style: const TextStyle(
                                              color: kTextMuted, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    _formatPrice(trx.totalPrice),
                                    style: const TextStyle(
                                      color: kGoldColor,
                                      fontFamily: kFontFamily,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
