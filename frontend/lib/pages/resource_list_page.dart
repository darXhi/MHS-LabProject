import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/resource_model.dart';
import '../models/user_model.dart';
import '../services/resource_service.dart';
import '../services/auth_service.dart';
import 'resource_detail_page.dart';

class ResourceListPage extends StatefulWidget {
  const ResourceListPage({super.key});

  @override
  State<ResourceListPage> createState() => _ResourceListPageState();
}

class _ResourceListPageState extends State<ResourceListPage> {
  final ResourceService _resourceService = ResourceService();
  final AuthService _authService = AuthService();

  List<ResourceModel> _allResources = [];
  List<ResourceModel> _filteredResources = [];
  bool _isLoading = true;
  String? _errorMsg;
  UserModel? _currentUser;

  // Dropdown filter type
  String _selectedType = 'Semua';
  final List<String> _typeOptions = ['Semua', 'Galactic Resource', 'Light Cone'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final user = await _authService.getCurrentUser();
      final resources = await _resourceService.getAllResources();
      setState(() {
        _currentUser = user;
        _allResources = resources;
        _filteredResources = resources;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMsg = 'Gagal memuat data: $e';
        _isLoading = false;
      });
    }
  }

  void _filterByType(String type) {
    setState(() {
      _selectedType = type;
      if (type == 'Semua') {
        _filteredResources = _allResources;
      } else {
        _filteredResources = _allResources.where((r) => r.type == type).toList();
      }
    });
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
        title: const Text('Honkai Star Retail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: kAccentColor),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kAccentColor))
          : _errorMsg != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: kErrorColor, size: 48),
                      const SizedBox(height: 12),
                      Text(_errorMsg!, style: const TextStyle(color: kErrorColor)),
                      const SizedBox(height: 16),
                      ElevatedButton(onPressed: _loadData, child: const Text('Coba Lagi')),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Header greeting
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                      color: kSecondaryColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat datang, ${_currentUser?.username ?? 'Trailblazer'}!',
                            style: const TextStyle(
                              color: kTextLight,
                              fontFamily: kFontFamily,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Dropdown filter
                          Row(
                            children: [
                              const Text('Filter: ', style: TextStyle(color: kTextMuted, fontSize: 13)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: kCardColor,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: kAccentColor.withOpacity(0.4)),
                                ),
                                child: DropdownButton<String>(
                                  value: _selectedType,
                                  dropdownColor: kCardColor,
                                  style: const TextStyle(color: kTextLight, fontFamily: kFontFamily, fontSize: 13),
                                  underline: const SizedBox(),
                                  isDense: true,
                                  items: _typeOptions.map((t) {
                                    return DropdownMenuItem(value: t, child: Text(t));
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) _filterByType(val);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Daftar resource
                    Expanded(
                      child: _filteredResources.isEmpty
                          ? const Center(
                              child: Text('Tidak ada resource', style: TextStyle(color: kTextMuted)),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: _filteredResources.length,
                              itemBuilder: (context, index) {
                                final resource = _filteredResources[index];
                                return _ResourceCard(
                                  resource: resource,
                                  formatPrice: _formatPrice,
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ResourceDetailPage(resource: resource),
                                      ),
                                    );
                                    _loadData();
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final ResourceModel resource;
  final String Function(double) formatPrice;
  final VoidCallback onTap;

  const _ResourceCard({
    required this.resource,
    required this.formatPrice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image placeholder
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: kAccentColor.withOpacity(0.3)),
                ),
                child: const Icon(Icons.auto_awesome, color: kAccentColor, size: 32),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource.name,
                      style: const TextStyle(
                        color: kTextLight,
                        fontFamily: kFontFamily,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: kAccentColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        resource.type,
                        style: const TextStyle(
                          color: kAccentColor,
                          fontFamily: kFontFamily,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatPrice(resource.price),
                          style: const TextStyle(
                            color: kGoldColor,
                            fontFamily: kFontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Stok: ${resource.stock}',
                          style: TextStyle(
                            color: resource.stock > 0 ? kSuccessColor : kErrorColor,
                            fontFamily: kFontFamily,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: kTextMuted),
            ],
          ),
        ),
      ),
    );
  }
}
