import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/resource_model.dart';
import '../../services/resource_service.dart';
import 'admin_form_page.dart';

class AdminResourcePage extends StatefulWidget {
  const AdminResourcePage({super.key});

  @override
  State<AdminResourcePage> createState() => _AdminResourcePageState();
}

class _AdminResourcePageState extends State<AdminResourcePage> {
  final ResourceService _resourceService = ResourceService();
  List<ResourceModel> _resources = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResources();
  }

  Future<void> _loadResources() async {
    setState(() => _isLoading = true);
    try {
      final data = await _resourceService.getAllResources();
      setState(() {
        _resources = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: kErrorColor),
        );
      }
    }
  }

  Future<void> _deleteResource(ResourceModel resource) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kCardColor,
        title: const Text('Hapus Resource',
            style: TextStyle(color: kErrorColor, fontFamily: kFontFamily)),
        content: Text(
          'Hapus "${resource.name}"? Tindakan ini tidak bisa dibatalkan.',
          style: const TextStyle(color: kTextLight, fontFamily: kFontFamily),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal', style: TextStyle(color: kTextMuted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: kErrorColor),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final result = await _resourceService.deleteResource(resource.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: result['success'] ? kSuccessColor : kErrorColor,
          ),
        );
        if (result['success']) _loadResources();
      }
    }
  }

  String _formatPrice(double price) {
    final formatted = price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Resource'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: kAccentColor),
            onPressed: _loadResources,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AdminFormPage()),
          );
          _loadResources();
        },
        backgroundColor: kAccentColor,
        foregroundColor: kPrimaryColor,
        child: const Icon(Icons.add),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: kBackgroundGradient),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: kAccentColor))
            : _resources.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada resource. Tambah sekarang!',
                      style:
                          TextStyle(color: kTextMuted, fontFamily: kFontFamily),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _resources.length,
                    itemBuilder: (context, index) {
                      final resource = _resources[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Icon resource
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: kSecondaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: kAccentColor.withOpacity(0.3)),
                                ),
                                child: buildProductImageWidget(
                                  resource.name,
                                  resource.image.isEmpty
                                      ? null
                                      : resource.image,
                                  24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      resource.name,
                                      style: const TextStyle(
                                        color: kTextLight,
                                        fontFamily: kFontFamily,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      resource.type,
                                      style: const TextStyle(
                                          color: kAccentColor,
                                          fontSize: 11,
                                          fontFamily: kFontFamily),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          _formatPrice(resource.price),
                                          style: const TextStyle(
                                              color: kGoldColor,
                                              fontFamily: kFontFamily,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Stok: ${resource.stock}',
                                          style: TextStyle(
                                            color: resource.stock > 0
                                                ? kSuccessColor
                                                : kErrorColor,
                                            fontSize: 12,
                                            fontFamily: kFontFamily,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Action buttons
                              Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined,
                                        color: kAccentColor, size: 20),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AdminFormPage(
                                              resourceToEdit: resource),
                                        ),
                                      );
                                      _loadResources();
                                    },
                                    tooltip: 'Edit',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        color: kErrorColor, size: 20),
                                    onPressed: () => _deleteResource(resource),
                                    tooltip: 'Hapus',
                                  ),
                                ],
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
