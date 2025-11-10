import 'package:flutter/material.dart';
import 'models.dart';
import 'widgets/featured_slider.dart';
import 'widgets/campaign_card.dart';
import 'widgets/new_campaign_form.dart'; // <- new import
import 'campaign_detail.dart';
import 'donation_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Campaign> allCampaigns;

  @override
  void initState() {
    super.initState();
    allCampaigns = List.from(campaigns);
  }

  void _showCampaignDetail(Campaign campaign) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CampaignDetail(campaign: campaign),
      ),
    );
  }

  void _showDonationPage(Campaign campaign) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DonationPage(campaign: campaign),
      ),
    );
  }

  void _showNewCampaignForm() {
    showDialog(
      context: context,
      builder: (context) => NewCampaignForm(
        onCreate: (newCampaign) {
          setState(() {
            allCampaigns.add(newCampaign);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final featuredCampaigns =
    allCampaigns.where((c) => c.isFeatured).toList();
    final otherCampaigns =
    allCampaigns.where((c) => !c.isFeatured).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              'Debo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF00ADEF),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewCampaignForm,
        backgroundColor: const Color(0xFF00ADEF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: FeaturedSlider(
                campaigns: featuredCampaigns,
                onCampaignTap: _showCampaignDetail,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '📋 All Campaigns',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '${otherCampaigns.length} campaigns',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: otherCampaigns.length,
                itemBuilder: (context, index) {
                  final campaign = otherCampaigns[index];
                  return CampaignCard(
                    campaign: campaign,
                    isFeatured: false,
                    onTap: () => _showCampaignDetail(campaign),
                    onDonate: () => _showDonationPage(campaign),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
