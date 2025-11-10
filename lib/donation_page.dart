import 'package:flutter/material.dart';
import 'models.dart';
import 'utils.dart';
import 'dart:js' as js;

class DonationPage extends StatefulWidget {
  final Campaign campaign;
  const DonationPage({super.key, required this.campaign});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  bool anonymous = false;
  String? selectedAmount;

  final List<String> quickAmounts = ['10', '50', '100', '500'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make a Donation'),
        backgroundColor: const Color(0xFF00ADEF),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campaign Info
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          widget.campaign.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.campaign.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'by ${widget.campaign.organizer}',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Amount Section
              const Text(
                'Donation Amount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Quick Amount Buttons
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: quickAmounts.map((amount) {
                  final isSelected = selectedAmount == amount;
                  return ChoiceChip(
                    label: Text('\ETB$amount'),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedAmount = selected ? amount : null;
                        amountController.text = amount;
                      });
                    },
                    selectedColor: const Color(0xFF00ADEF),
                    backgroundColor: Colors.grey.shade100,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Custom Amount Field
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Custom Amount (required)',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00ADEF)),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      selectedAmount = null;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),

              // Comment Section
              const Text(
                'Add a Comment (Optional)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: commentController,
                decoration: const InputDecoration(
                  labelText: 'Share words of encouragement...',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00ADEF)),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Anonymous Donation
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.visibility_off, color: Color(0xFF00ADEF)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Donate Anonymously',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Your name won\'t be shown publicly',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: anonymous,
                        onChanged: (value) => setState(() => anonymous = value),
                        activeColor: const Color(0xFF00ADEF),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),

              // Donate Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final amount = amountController.text.trim();
                      final description = commentController.text.trim().isNotEmpty
                          ? commentController.text.trim()
                          : 'Donation to ${widget.campaign.organizer}';

                      final jsCode = '''
      const fromAccount = ''; // empty
      const toAccount = '${Uri.encodeComponent(widget.campaign.organizer)}';
      const amount = '${Uri.encodeComponent(amount)}';
      const description = '${Uri.encodeComponent(description)}';

      window.location.hash =
        'action=confirmpayment&from=' + fromAccount +
        '&to=' + toAccount +
        '&amount=' + amount +
        '&desc=' + description;
    ''';

                      // Trigger the action
                      js.context.callMethod('eval', [jsCode]);

                      // Close donation page if needed
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00ADEF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Complete Donation',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    commentController.dispose();
    super.dispose();
  }
}