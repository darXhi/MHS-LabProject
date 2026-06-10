import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/resource_model.dart';
import '../../services/resource_service.dart';

class AdminFormPage extends StatefulWidget {
  final ResourceModel? resourceToEdit;

  const AdminFormPage({super.key, this.resourceToEdit});

  @override
  State<AdminFormPage> createState() => _AdminFormPageState();
}

class _AdminFormPageState extends State<AdminFormPage> {
  final _formKey = GlobalKey<FormState>();
  final ResourceService _resourceService = ResourceService();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageController = TextEditingController();
  final _priceController = TextEditingController();

  String _selectedType = 'Galactic Resource';
  final List<String> _typeOptions = ['Galactic Resource', 'Light Cone'];

  bool _isLoading = false;

  bool get _isEditing => widget.resourceToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final r = widget.resourceToEdit!;
      _nameController.text = r.name;
      _descriptionController.text = r.description;
      _stockController.text = r.stock.toString();
      _imageController.text = r.image;
      _priceController.text = r.price.toStringAsFixed(0);
      _selectedType = _typeOptions.contains(r.type) ? r.type : _typeOptions[0];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _stockController.dispose();
    _imageController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final body = {
      'name': _nameController.text.trim(),
      'type': _selectedType,
      'description': _descriptionController.text.trim(),
      'stock': int.parse(_stockController.text.trim()),
      'image': _imageController.text.trim(),
      'price': double.parse(_priceController.text.trim()),
    };

    Map<String, dynamic> result;

    if (_isEditing) {
      result = await _resourceService.updateResource(
          widget.resourceToEdit!.id, body);
    } else {
      result = await _resourceService.addResource(body);
    }

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: result['success'] ? kSuccessColor : kErrorColor,
        ),
      );
      if (result['success']) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Resource' : 'Tambah Resource'),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: kBackgroundGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: kTextLight),
                  decoration: const InputDecoration(
                    labelText: 'Nama Resource *',
                    prefixIcon: Icon(Icons.label_outline, color: kAccentColor),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Nama resource tidak boleh kosong';
                    }
                    if (val.trim().length < 3) {
                      return 'Nama minimal 3 karakter';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                DropdownButtonFormField<String>(
                  value: _selectedType,
                  dropdownColor: kCardColor,
                  style: const TextStyle(
                      color: kTextLight, fontFamily: kFontFamily),
                  decoration: const InputDecoration(
                    labelText: 'Tipe Resource *',
                    prefixIcon:
                        Icon(Icons.category_outlined, color: kAccentColor),
                  ),
                  items: _typeOptions.map((t) {
                    return DropdownMenuItem(value: t, child: Text(t));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedType = val);
                  },
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Tipe harus dipilih';
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                TextFormField(
                  controller: _descriptionController,
                  style: const TextStyle(color: kTextLight),
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    prefixIcon:
                        Icon(Icons.description_outlined, color: kAccentColor),
                    alignLabelWithHint: true,
                  ),
                ),

                const SizedBox(height: 14),

                TextFormField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: kTextLight),
                  decoration: const InputDecoration(
                    labelText: 'Stok *',
                    prefixIcon:
                        Icon(Icons.inventory_2_outlined, color: kAccentColor),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Stok tidak boleh kosong';
                    }
                    final parsed = int.tryParse(val.trim());
                    if (parsed == null) {
                      return 'Stok harus berupa angka';
                    }
                    if (parsed < 0) {
                      return 'Stok tidak boleh negatif';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                TextFormField(
                  controller: _imageController,
                  style: const TextStyle(color: kTextLight),
                  decoration: const InputDecoration(
                    labelText: 'Nama File Gambar',
                    hintText: 'contoh: stellar_jade.png',
                    prefixIcon: Icon(Icons.image_outlined, color: kAccentColor),
                  ),
                ),

                const SizedBox(height: 14),

                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: kTextLight),
                  decoration: const InputDecoration(
                    labelText: 'Harga (Rp) *',
                    prefixIcon:
                        Icon(Icons.payments_outlined, color: kAccentColor),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Harga tidak boleh kosong';
                    }
                    final parsed = double.tryParse(val.trim());
                    if (parsed == null) {
                      return 'Harga harus berupa angka';
                    }
                    if (parsed < 0) {
                      return 'Harga tidak boleh negatif';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: kPrimaryColor,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(_isEditing
                            ? 'Simpan Perubahan'
                            : 'Tambah Resource'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
