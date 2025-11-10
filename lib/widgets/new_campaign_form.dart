import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models.dart';
import '../utils.dart'; // formatCurrency

class NewCampaignForm extends StatefulWidget {
  final Function(Campaign) onCreate;

  const NewCampaignForm({super.key, required this.onCreate});

  @override
  State<NewCampaignForm> createState() => _NewCampaignFormState();
}

class _NewCampaignFormState extends State<NewCampaignForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController shortStoryController = TextEditingController();
  final TextEditingController fullStoryController = TextEditingController();
  final TextEditingController targetController = TextEditingController();
  final TextEditingController organizerController = TextEditingController();

  File? pickedImage; // mobile
  Uint8List? webImageBytes; // web
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (image != null) {
        if (kIsWeb) {
          webImageBytes = await image.readAsBytes();
          pickedImage = null;
        } else {
          pickedImage = File(image.path);
          webImageBytes = null;
        }
        setState(() {});
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera, color: Colors.green),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1500));

      // Use default profile icon if no image selected
      String imageUrl;
      if (kIsWeb) {
        imageUrl = webImageBytes != null ? 'web_image_placeholder' : 'default_profile_icon';
      } else {
        imageUrl = pickedImage != null ? pickedImage!.path : 'default_profile_icon';
      }

      final newCampaign = Campaign(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text.trim(),
        shortStory: shortStoryController.text.trim(),
        fullStory: fullStoryController.text.trim(),
        imageUrl: imageUrl,
        target: double.parse(targetController.text),
        raised: 0,
        organizer: organizerController.text.trim(),
        createdDate: DateTime.now(),
        donors: 0,
        isFeatured: false,
      );

      widget.onCreate(newCampaign);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Campaign created successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      _showError('Failed to create campaign: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    setState(() {
      pickedImage = null;
      webImageBytes = null;
      titleController.clear();
      shortStoryController.clear();
      fullStoryController.clear();
      targetController.clear();
      organizerController.clear();
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    shortStoryController.dispose();
    fullStoryController.dispose();
    targetController.dispose();
    organizerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageUploadSection(),
                      const SizedBox(height: 20),
                      _buildTextField(titleController, 'Campaign Title *', Icons.title,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Please enter a campaign title';
                            if (v.trim().length < 5) return 'Title should be at least 5 characters';
                            return null;
                          }, maxLength: 60),
                      const SizedBox(height: 16),
                      _buildTextField(shortStoryController, 'Short Description *', Icons.description,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Please enter a short description';
                            if (v.trim().length < 10) return 'Description should be at least 10 characters';
                            return null;
                          }, maxLength: 120, maxLines: 2),
                      const SizedBox(height: 16),
                      _buildTextField(fullStoryController, 'Full Story', Icons.article,
                          maxLength: 500, maxLines: 4),
                      const SizedBox(height: 16),
                      _buildTextField(targetController, 'Target Amount *', Icons.attach_money,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Please enter target amount';
                            final amount = double.tryParse(v);
                            if (amount == null) return 'Please enter a valid number';
                            if (amount <= 0) return 'Amount must be greater than 0';
                            if (amount > 1000000) return 'Amount is too large';
                            return null;
                          }, suffixText: 'ETB'),
                      const SizedBox(height: 16),
                      _buildTextField(organizerController, 'Organizer Name *', Icons.person,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Please enter organizer name';
                            return null;
                          }),
                      if (targetController.text.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildPreviewSection(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.add_circle, color: Color(0xFF00ADEF), size: 24),
              SizedBox(width: 8),
              Text('Create New Campaign',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, size: 24),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {String? Function(String?)? validator,
        int? maxLength,
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
        String? suffixText}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixText: suffixText,
      ),
      maxLength: maxLength,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildImageUploadSection() {
    Widget child;
    if (kIsWeb && webImageBytes != null) {
      child = Image.memory(webImageBytes!, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
    } else if (!kIsWeb && pickedImage != null) {
      child = Image.file(pickedImage!, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
    } else {
      child = const Icon(Icons.account_circle, size: 64, color: Colors.grey);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Campaign Image *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _showImageSourceOptions,
          child: Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (pickedImage != null || webImageBytes != null) ? Colors.green : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Center(child: child),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewSection() {
    final target = double.tryParse(targetController.text) ?? 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.preview, size: 16, color: Colors.blue),
              SizedBox(width: 6),
              Text('Campaign Preview', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Text('• Target: ${formatCurrency(target)}', style: const TextStyle(fontSize: 13)),
          Text('• Progress: 0% (${formatCurrency(0)} raised)', style: const TextStyle(fontSize: 13)),
          Text('• Donors: 0', style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 0.5))),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isLoading ? null : _clearForm,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey,
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Clear Form', style: TextStyle(fontWeight: FontWeight.w500)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00ADEF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
              )
                  : const Text('Create Campaign', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
