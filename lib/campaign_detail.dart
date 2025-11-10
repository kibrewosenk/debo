import 'package:flutter/material.dart';
import 'models.dart';
import 'donation_page.dart';
import 'widgets/progress_bar.dart';
import 'utils.dart';

class CampaignDetail extends StatelessWidget {
  final Campaign campaign;

  const CampaignDetail({super.key, required this.campaign});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(campaign.title),
        backgroundColor: const Color(0xFF00ADEF),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campaign Image
                  Stack(
                    children: [
                      Image.asset(
                        campaign.imageUrl,
                        fit: BoxFit.cover,
                        height: 250,
                        width: double.infinity,
                      ),
                      if (campaign.isFeatured)
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE38524),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '🔥 Featured',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Organizer
                        Text(
                          campaign.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.person_outline, size: 16, color: Colors.black54),
                            const SizedBox(width: 4),
                            Text(
                              'Organized by ${campaign.organizer}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Progress Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00ADEF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF00ADEF).withOpacity(0.2)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formatCurrency(campaign.raised),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF00ADEF),
                                    ),
                                  ),
                                  Text(
                                    campaign.progressPercentage,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ProgressBar(
                                progress: campaign.progress,
                                height: 12,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Raised of ${formatCurrency(campaign.target)}',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    '${campaign.donors} donors',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Story Section
                        const Text(
                          'Story',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          campaign.fullStory,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Campaign Details
                        const Text(
                          'Campaign Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildDetailItem('Organizer', campaign.organizer),
                        _buildDetailItem('Days Running', '${campaign.daysLeft} days'),
                        _buildDetailItem('Target Amount', formatCurrency(campaign.target)),
                        _buildDetailItem('Donors', '${campaign.donors} people'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Donate Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DonationPage(campaign: campaign),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00ADEF),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Donate Now',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}