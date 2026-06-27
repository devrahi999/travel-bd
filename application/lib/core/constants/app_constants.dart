class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Travel BD';
  static const String appTagline = 'বাংলাদেশ আবিষ্কার করুন';

  // API
  static const String baseUrl = 'https://api.travelbd.com/api/v1';

  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 28.0;
  static const double spacing2xl = 32.0;
  static const double spacing3xl = 48.0;
  static const double pageHorizontalPadding = 20.0;

  // Border Radius
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radius2xl = 24.0;
  static const double radiusFull = 9999.0;

  // Card elevation / shadow
  static const double shadowBlur = 12.0;
  static const double shadowOpacity = 0.08;

  // Divisions of Bangladesh
  static const List<String> divisions = [
    'ঢাকা',
    'চট্টগ্রাম',
    'সিলেট',
    'রাজশাহী',
    'খুলনা',
    'বরিশাল',
    'রংপুর',
    'ময়মনসিংহ',
  ];

  // Place Categories
  static const List<String> placeCategories = [
    'সব',
    'সমুদ্র সৈকত',
    'পাহাড়',
    'বন',
    'ঐতিহাসিক',
    'জলপ্রপাত',
    'শহর',
    'দ্বীপ',
  ];

  // Cuisine Types
  static const List<String> cuisines = [
    'বাংলা',
    'চাইনিজ',
    'ইন্ডিয়ান',
    'সীফুড',
    'ফাস্ট ফুড',
  ];

  // Business Types
  static const List<String> businessTypes = [
    'হোটেল',
    'রেস্টুরেন্ট',
    'ট্যুর গাইড',
    'কার রেন্টাল',
    'ট্যুর কোম্পানি',
  ];

  // Popular Destinations
  static const List<Map<String, String>> popularDestinations = [
    {'name': "Cox's Bazar", 'division': 'চট্টগ্রাম', 'emoji': '🏖️'},
    {'name': 'সুন্দরবন', 'division': 'খুলনা', 'emoji': '🌿'},
    {'name': 'সাজেক ভ্যালি', 'division': 'রাঙামাটি', 'emoji': '⛰️'},
    {'name': 'বান্দরবান', 'division': 'চট্টগ্রাম', 'emoji': '🏔️'},
    {'name': "সেন্ট মার্টিন", 'division': 'কক্সবাজার', 'emoji': '🏝️'},
    {'name': 'সিলেট', 'division': 'সিলেট', 'emoji': '🍵'},
  ];

  // Placeholder image URLs (from CDN)
  static const String coxBazarImage =
      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800';
  static const String sajekImage =
      'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800';
  static const String sundarbanImage =
      'https://images.unsplash.com/photo-1606422285050-51a4cdb25c67?w=800';
  static const String bandarbanImage =
      'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=800';

  // Quick AI prompts
  static const List<Map<String, String>> aiQuickPrompts = [
    {'label': 'Weekend Trip', 'emoji': '🏖️'},
    {'label': 'Family Trip', 'emoji': '👨‍👩‍👧'},
    {'label': 'Budget Travel', 'emoji': '💰'},
    {'label': 'Solo Adventure', 'emoji': '🎒'},
    {'label': 'Honeymoon', 'emoji': '💑'},
    {'label': 'Group Tour', 'emoji': '👥'},
  ];
}
