import 'dart:async';
import 'package:flutter/material.dart';
import '../models.dart';
import 'campaign_card.dart';

class FeaturedSlider extends StatefulWidget {
  final List<Campaign> campaigns;
  final Function(Campaign)? onCampaignTap;

  const FeaturedSlider({
    super.key,
    required this.campaigns,
    this.onCampaignTap,
  });

  @override
  State<FeaturedSlider> createState() => _FeaturedSliderState();
}

class _FeaturedSliderState extends State<FeaturedSlider> {
  final PageController _controller = PageController(viewportFraction: 0.85);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_controller.hasClients && widget.campaigns.isNotEmpty) {
        _currentPage = (_currentPage + 1) % widget.campaigns.length;
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Slider title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                '🔥 Featured Campaigns',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),

        // Slider with fixed height
        SizedBox(
          height: 225, // Fixed height to prevent overflow
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.campaigns.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final campaign = widget.campaigns[index];
              return AnimatedPadding(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.all(_currentPage == index ? 0 : 8),
                child: GestureDetector(
                  onTap: () => widget.onCampaignTap?.call(campaign),
                  child: CampaignCard(
                    campaign: campaign,
                    isFeatured: true,
                  ),
                ),
              );
            },
          ),
        ),

        // Dots indicator
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.campaigns.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 20 : 8,
              height: 5,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? const Color(0xFF00ADEF)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}