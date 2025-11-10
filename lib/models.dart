class Campaign {
  final String id;
  final String title;
  final String shortStory;
  final String fullStory;
  final String imageUrl;
  final double target;
  final double raised;
  final String organizer;
  final DateTime createdDate;
  final int donors;
  final bool isFeatured;

  Campaign({
    required this.id,
    required this.title,
    required this.shortStory,
    required this.fullStory,
    required this.imageUrl,
    required this.target,
    required this.raised,
    required this.organizer,
    required this.createdDate,
    required this.donors,
    this.isFeatured = false,
  });

  double get progress => target > 0 ? (raised / target).clamp(0.0, 1.0) : 0.0;
  String get progressPercentage => '${(progress * 100).toStringAsFixed(1)}%';
  int get daysLeft => DateTime.now().difference(createdDate).inDays;
}

// Enhanced dummy data with realistic content
final List<Campaign> campaigns = [
  Campaign(
    id: '1',
    title: 'School Building Project',
    shortStory: 'Help build classrooms for rural children',
    fullStory: 'We aim to build a proper school building with classrooms, furniture, and learning materials for 200 children who currently study under trees. Your donation will help provide quality education and a better future.',
    imageUrl: 'assets/images/school.png',
    target: 10000,
    raised: 4200,
    organizer: 'Education for All Foundation',
    createdDate: DateTime.now().subtract(const Duration(days: 45)),
    donors: 124,
    isFeatured: true,
  ),
  Campaign(
    id: '2',
    title: 'Medical Treatment for Hana',
    shortStory: 'Help Hana get life-saving heart surgery',
    fullStory: 'Hana, a 7-year-old girl, needs urgent heart surgery to survive. Her family cannot afford the medical expenses. Your support can save her life and give her a chance at a normal childhood.',
    imageUrl: 'assets/images/medical.png',
    target: 8000,
    raised: 3500,
    organizer: 'Hana\'s Family',
    createdDate: DateTime.now().subtract(const Duration(days: 30)),
    donors: 89,
    isFeatured: true,
  ),
  Campaign(
    id: '3',
    title: 'Food Support for Families',
    shortStory: 'Provide food for 50 families monthly',
    fullStory: 'Many families in our community are facing food insecurity. We aim to provide monthly food packages containing rice, grains, oil, and essential items to 50 families for 3 months.',
    imageUrl: 'assets/images/food.png',
    target: 5000,
    raised: 2300,
    organizer: 'Community Help Organization',
    createdDate: DateTime.now().subtract(const Duration(days: 60)),
    donors: 67,
    isFeatured: true,
  ),
  Campaign(
    id: '4',
    title: 'Rebuild Fire-Damaged Homes',
    shortStory: 'Help families rebuild after fire',
    fullStory: 'A recent fire destroyed 15 homes in our neighborhood. Families have lost everything. We need your help to rebuild their homes and replace essential household items.',
    imageUrl: 'assets/images/home.png',
    target: 7000,
    raised: 1200,
    organizer: 'Neighborhood Recovery Team',
    createdDate: DateTime.now().subtract(const Duration(days: 15)),
    donors: 23,
  ),
  Campaign(
    id: '4',
    title: 'Rebuild Fire-Damaged Homes',
    shortStory: 'Help families rebuild after fire',
    fullStory: 'A recent fire destroyed 15 homes in our neighborhood. Families have lost everything. We need your help to rebuild their homes and replace essential household items.',
    imageUrl: 'assets/images/home.png',
    target: 7000,
    raised: 1200,
    organizer: 'Neighborhood Recovery Team',
    createdDate: DateTime.now().subtract(const Duration(days: 15)),
    donors: 23,
  ),
];
