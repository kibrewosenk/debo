import 'package:flutter/material.dart';
import '../models.dart';
import 'progress_bar.dart';
import '../utils.dart';

class CampaignCard extends StatelessWidget {
  final Campaign campaign;
  final bool isFeatured;
  final VoidCallback? onTap;
  final VoidCallback? onDonate;

  const CampaignCard({
    super.key,
    required this.campaign,
    this.isFeatured = false,
    this.onTap,
    this.onDonate,
  });

  @override
  Widget build(BuildContext context) {
    return isFeatured ? _buildFeaturedCard() : _buildListCard();
  }

  Widget _buildFeaturedCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Container(
        height: 240, // Fixed height
        child: Stack(
          children: [
            // Background content with InkWell for taps outside the button
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 100,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: Image.asset(
                            campaign.imageUrl,
                            fit: BoxFit.cover,
                            height: 100,
                            width: 400, // Square image
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE38524),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '🔥 Featured',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Content area
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title - Single line
                          Text(
                            campaign.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),

                          // Short story - Single line
                          Text(
                            campaign.shortStory,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1),

                          // Progress section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Raised: ${formatCurrency(campaign.raised)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Color(0xFF00ADEF),
                                    ),
                                  ),
                                  Text(
                                    campaign.progressPercentage,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              ProgressBar(progress: campaign.progress, height: 6),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Target: ${formatCurrency(campaign.target)}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    '${campaign.donors} donors',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Donate button positioned at bottom
            Positioned(
              bottom: 12,
              left: 120,
              right: 120,
              child: SizedBox(
                height: 26,
                child: ElevatedButton(
                  onPressed: onDonate,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(const Color(0xFF00ADEF)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    overlayColor: MaterialStateProperty.all(const Color(0xFF00ADEF)), // keeps pressed color same
                    shadowColor: MaterialStateProperty.all(Colors.transparent), // optional: removes elevation shadow
                  ),
                  child: const Text(
                    'Donate Now',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Square image on most left
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  campaign.imageUrl,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and progress
                    Text(
                      campaign.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Short story
                    Text(
                      campaign.shortStory,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),

                    // Progress bar
                    ProgressBar(
                      progress: campaign.progress,
                      height: 4,
                    ),
                    const SizedBox(height: 4),

                    // Progress info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${formatCurrency(campaign.raised)}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF00ADEF),
                          ),
                        ),
                        Text(
                          campaign.progressPercentage,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),

                    // Donate button below progress info
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 26,
                      child: ElevatedButton(
                        onPressed: onDonate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00ADEF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: const Text(
                          'Donate',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Like icon and count on right side
              Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00ADEF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: onDonate,
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 16,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${campaign.donors}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}