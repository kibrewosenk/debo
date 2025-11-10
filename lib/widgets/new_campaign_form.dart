import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models.dart';
import '../utils.dart'; // Assuming you have formatCurrency here

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
  File? pickedImage;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  // Pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          pickedImage = File(image.path);
        });
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  // Show image source options
  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
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
    if (pickedImage == null) {
      _showError('Please select a campaign image');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1500));

      final newCampaign = Campaign(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text.trim(),
        shortStory: shortStoryController.text.trim(),
        fullStory: fullStoryController.text.trim(),
        imageUrl: pickedImage!.path,
        target: double.parse(targetController.text),
        raised: 0,
        organizer: organizerController.text.trim(),
        createdDate: DateTime.now(),
        donors: 0,
        isFeatured: false,
        // category: 'General',
      );

      widget.onCreate(newCampaign);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Campaign created successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      _showError('Failed to create campaign: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
        width: MediaQuery.of(context).size.width * 0.9, // Increased width
        constraints: const BoxConstraints(maxWidth: 600), // Max width for large screens
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with X close icon
            Container(
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
                      Text(
                        'Create New Campaign',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
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
            ),

            // Form content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image upload section
                      _buildImageUploadSection(),
                      const SizedBox(height: 20),

                      // Campaign title
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: 'Campaign Title *',
                          prefixIcon: const Icon(Icons.title, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        maxLength: 60,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a campaign title';
                          }
                          if (value.trim().length < 5) {
                            return 'Title should be at least 5 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Short story
                      TextFormField(
                        controller: shortStoryController,
                        decoration: InputDecoration(
                          labelText: 'Short Description *',
                          prefixIcon: const Icon(Icons.description, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        maxLines: 2,
                        maxLength: 120,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a short description';
                          }
                          if (value.trim().length < 10) {
                            return 'Description should be at least 10 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Full story
                      TextFormField(
                        controller: fullStoryController,
                        decoration: InputDecoration(
                          labelText: 'Full Story',
                          prefixIcon: const Icon(Icons.article, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        maxLines: 4,
                        maxLength: 500,
                      ),
                      const SizedBox(height: 16),

                      // Target amount
                      TextFormField(
                        controller: targetController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Target Amount *',
                          prefixIcon: const Icon(Icons.attach_money, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixText: 'ETB',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter target amount';
                          }
                          final amount = double.tryParse(value);
                          if (amount == null) {
                            return 'Please enter a valid number';
                          }
                          if (amount <= 0) {
                            return 'Amount must be greater than 0';
                          }
                          if (amount > 1000000) {
                            return 'Amount is too large';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Organizer
                      TextFormField(
                        controller: organizerController,
                        decoration: InputDecoration(
                          labelText: 'Organizer Name *',
                          prefixIcon: const Icon(Icons.person, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter organizer name';
                          }
                          return null;
                        },
                      ),

                      // Preview section
                      if (targetController.text.isNotEmpty)
                        _buildPreviewSection(),
                    ],
                  ),
                ),
              ),
            ),

            // Action buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _clearForm,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Clear Form',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00ADEF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : const Text(
                        'Create Campaign',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
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

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Campaign Image *',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _showImageSourceOptions,
          child: Container(
            height: 160, // Slightly larger for better visibility
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: pickedImage != null ? Colors.green : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: pickedImage != null
                ? Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    pickedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap to add campaign image',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Recommended: Square image (1:1 ratio)',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
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
              Text(
                'Campaign Preview',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• Target: ${formatCurrency(target)}',
            style: const TextStyle(fontSize: 13),
          ),
          Text(
            '• Progress: 0% (${formatCurrency(0)} raised)',
            style: const TextStyle(fontSize: 13),
          ),
          Text(
            '• Donors: 0',
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}