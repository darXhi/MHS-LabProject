import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/resource_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/transaction_service.dart';

class ResourceDetailPage extends StatefulWidget {
  final ResourceModel resource;

  const ResourceDetailPage({super.key, required this.resource});

  @override
  State<ResourceDetailPage> createState() => _ResourceDetailPageState();
}

class _ResourceDetailPageState extends State<ResourceDetailPage> {
  final TransactionService _transactionService = TransactionService();
  final AuthService _authService = AuthService();
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _authService.getCurrentUser();
    setState(() => _currentUser = user);
  }

  String _formatPrice(double price) {
    final formatted = price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp $formatted';
  }

  void _showBuyDialog() {
    final qtyController = TextEditingController(text: '1');
    final resource = widget.resource;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: kCardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: kAccentColor.withOpacity(0.3)),
              ),
              title: Text(
                'Beli ${resource.name}',
                style: const TextStyle(
                  color: kAccentColor,
                  fontFamily: kFontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Harga satuan: ${_formatPrice(resource.price)}',
                    style: const TextStyle(color: kTextLight, fontFamily: kFontFamily),
                  ),
                  Text(
                    'Stok tersedia: ${resource.stock}',
                    style: const TextStyle(color: kTextMuted, fontFamily: kFontFamily, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: kTextLight),
                    decoration: const InputDecoration(
                      labelText: 'Jumlah',
                      prefixIcon: Icon(Icons.shopping_cart_outlined, color: kAccentColor),
                    ),
                    onChanged: (_) => setDialogState(() {}),
                  ),
                  const SizedBox(height: 12),
                  // Tampilkan total harga
                  Builder(builder: (_) {
                    final qty = int.tryParse(qtyController.text) ?? 0;
                    final total = resource.price * qty;
                    return Text(
                      'Total: ${_formatPrice(total)}',
                      style: const TextStyle(
                        color: kGoldColor,
                        fontFamily: kFontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  }),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Batal', style: TextStyle(color: kTextMuted)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final qty = int.tryParse(qtyController.text);

                    // Validasi quantity
                    if (qty == null || qty <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Jumlah harus lebih dari 0'),
                          backgroundColor: kErrorColor,
                        ),
                      );
                      return;
                    }
                    if (qty > resource.stock) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Stok tidak cukup. Maksimal: ${resource.stock}'),
                          backgroundColor: kErrorColor,
                        ),
                      );
                      return;
                    }

                    Navigator.pop(ctx);

                    final result = await _transactionService.buyResource(resource.id, qty);

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result['message']),
                          backgroundColor: result['success'] ? kSuccessColor : kErrorColor,
                        ),
                      );
                      if (result['success']) {
                        Navigator.pop(context); // kembali ke list
                      }
                    }
                  },
                  child: const Text('Beli Sekarang'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final resource = widget.resource;

    return Scaffold(
      appBar: AppBar(
        title: Text(resource.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar / banner resource
            Container(
              width: double.infinity,
              height: 220,
              color: kSecondaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome, color: kAccentColor, size: 80),
                  const SizedBox(height: 8),
                  Text(
                    resource.image.isNotEmpty ? resource.image : 'No Image',
                    style: const TextStyle(color: kTextMuted, fontSize: 12),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge type
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: kAccentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: kAccentColor.withOpacity(0.4)),
                    ),
                    child: Text(
                      resource.type,
                      style: const TextStyle(
                        color: kAccentColor,
                        fontFamily: kFontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Nama resource
                  Text(
                    resource.name,
                    style: const TextStyle(
                      color: kTextLight,
                      fontFamily: kFontFamily,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Harga
                  Text(
                    _formatPrice(resource.price),
                    style: const TextStyle(
                      color: kGoldColor,
                      fontFamily: kFontFamily,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Stok
                  Row(
                    children: [
                      Icon(
                        resource.stock > 0 ? Icons.check_circle_outline : Icons.cancel_outlined,
                        color: resource.stock > 0 ? kSuccessColor : kErrorColor,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        resource.stock > 0 ? 'Stok tersedia: ${resource.stock}' : 'Stok habis',
                        style: TextStyle(
                          color: resource.stock > 0 ? kSuccessColor : kErrorColor,
                          fontFamily: kFontFamily,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Divider(color: kAccentColor.withOpacity(0.2)),
                  const SizedBox(height: 12),

                  // Deskripsi
                  const Text(
                    'Deskripsi',
                    style: TextStyle(
                      color: kAccentColor,
                      fontFamily: kFontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    resource.description.isNotEmpty ? resource.description : 'Tidak ada deskripsi.',
                    style: const TextStyle(
                      color: kTextLight,
                      fontFamily: kFontFamily,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Tombol Beli (hanya tampil untuk role user)
                  if (_currentUser != null && !_currentUser!.isAdmin)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: resource.stock > 0 ? _showBuyDialog : null,
                        icon: const Icon(Icons.shopping_cart),
                        label: Text(resource.stock > 0 ? 'Beli Sekarang' : 'Stok Habis'),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
