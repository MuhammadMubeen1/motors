import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:motors_app/core/env.dart';
import 'package:motors_app/data/models/Vehicle/cardetails_model.dart';
import 'package:motors_app/data/models/Vehicle/vehicle.dart';
import 'package:motors_app/data/models/Vehicle/vehicle_detail.dart';
import 'package:motors_app/presentation/screens/car_detail/car_detail_screen.dart';
import 'package:motors_app/presentation/screens/home/all_bodies.dart';
import 'package:motors_app/presentation/screens/home/brows_body.dart';
import 'package:motors_app/presentation/screens/home/browsbybody.dart';
import 'package:motors_app/presentation/screens/home/makes_details.dart';
import 'package:motors_app/presentation/screens/home/widgets/bmw_car.dart';
import 'package:motors_app/presentation/screens/home/widgets/cardetails.dart';
import 'package:motors_app/presentation/screens/search/screens/search_result_screen.dart';
import 'package:motors_app/presentation/widgets/loader_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MotorsHomeScreenState();
}

class _MotorsHomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final PageController _bannerController = PageController();
  final PageController _offRoadCarsController = PageController();
  late TabController _tabController;
  int _currentCarouselIndex = 0;

  // Enhanced Color Scheme
  final Color primaryColor = const Color(0xff3ec745);
  final Color secondaryColor = const Color(0xff3ec745);
  final Color backgroundColor = const Color(0xFFF8F9FA);
  final Color cardColor = Colors.white;
  final Color textColor = const Color(0xFF2D3748);
  final Color accentColor = const Color(0xFFFF6B00);
  final Color successColor = const Color(0xff3ec745);

  // State variables for API data
  List<dynamic> _makes = [];
  List<dynamic> _bodyTypes = [];
  Map<String, dynamic>? _mainPageData;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Explicitly type the futures list
      final List<Future<dynamic>> futures = [
        _fetchMakes(),
        _fetchBodyTypes(),
        _fetchMainPageData(),
      ];

      // Use type casting when getting results
      final results = await Future.wait(futures);

      setState(() {
        _makes = results[0] as List<dynamic>;
        _bodyTypes = results[1] as List<dynamic>;
        _mainPageData = results[2] as Map<String, dynamic>;
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<dynamic>> _fetchMakes() async {
    final response = await http.get(
      Uri.parse('https://wheelers.pk/wp-json/stm-mra/v1/filter'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['make'] ?? [];
    }
    throw Exception('Failed to load makes');
  }

  Future<List<dynamic>> _fetchBodyTypes() async {
    final response = await http.get(
      Uri.parse('https://wheelers.pk/wp-json/stm-mra/v1/add-car'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['step_two']['body'] ?? [];
    }
    throw Exception('Failed to load body types');
  }

  Future<Map<String, dynamic>> _fetchMainPageData() async {
    final response = await http.get(
      Uri.parse('https://wheelers.pk/wp-json/stm-mra/v1/main-page'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load main page data');
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _offRoadCarsController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
       backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Image(
            image: AssetImage('assets/images/logo_dark.png'),
            width: 190,
            height: 150,
            fit: BoxFit.contain,
          ),
        ),
      ),
          
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildBannerSlider(),
                  const SizedBox(height: 30),

                  // Browse by Make
                  _buildSectionTitle('Browse by Make',
                      seeAll: true, seeAllLabel: 'Show all Makes'),
                  const SizedBox(height: 18),

                  _isLoading && _makes.isEmpty
                      ? const Center(child: CircularProgressIndicator(
                              color: Color(0xff3ec745)))
                      : _hasError
                          ? _buildErrorWidget('Failed to load makes')
                          : _buildMakeGrid(),
                  const SizedBox(height: 20),

                  // Browse by Body
                  _buildSectionbody('Browse by Body',
                      seeAll: true, seeAllLabel: 'Show all Bodies'),
                  const SizedBox(height: 18),

                  _isLoading && _bodyTypes.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : _hasError
                          ? _buildErrorWidget('Failed to load body types')
                          : _buildBodyTypeGrid(),

                  const SizedBox(height: 30),

                  // Tabbed sections
                  _buildTabBar(),
                  const SizedBox(height: 15),

                  SizedBox(
                    height: 320,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _isLoading && _mainPageData == null
                            ? const Center(child: CircularProgressIndicator())
                            : _hasError
                                ? _buildErrorWidget(
                                    'Failed to load recent cars')
                                : _buildRecentCars(),
                        _isLoading && _mainPageData == null
                            ? const Center(child: CircularProgressIndicator())
                            : _hasError
                                ? _buildErrorWidget(
                                    'Failed to load featured cars')
                                : _buildFeaturedCars(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildValueMyCarSection(),
                  const SizedBox(height: 30),

                  _buildSectionTitle('New Cars', seeAll: false),
                  const SizedBox(height: 15),
                  _buildOffRoadCarsSlider(),
                  const SizedBox(height: 24),

                  _buildSectionTitle('News & Reviews', seeAll: false),
                  const SizedBox(height: 15),
                  _buildNewsCard(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      height: 180,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 10),
          Text(message, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _loadAllData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerSlider() {
    final banners = [
      'https://wheelers.pk/wp-content/uploads/2025/07/slider_2.jpg',
      'https://wheelers.pk/wp-content/uploads/2025/07/slider_1.jpg',
    ];

    return SizedBox(
      height: 200,
      width: 180,
      child: Stack(
        children: [
          PageView.builder(
            controller: _bannerController,
            itemCount: banners.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CachedNetworkImage(
                    imageUrl: banners[index],
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.error, color: Colors.grey),
                    ),
                  ),
                ),
              );
            },
          ),

          // Left arrow
          Positioned(
            top: 0,
            bottom: 0,
            left: 8,
            child: Center(
              child: InkWell(
                onTap: () {
                  final prev = _bannerController.page!.round() - 1;
                  if (prev >= 0)
                    _bannerController.animateToPage(prev,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                },
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black45,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 20),
                ),
              ),
            ),
          ),

          // Right arrow
          Positioned(
            top: 0,
            bottom: 0,
            right: 8,
            child: Center(
              child: InkWell(
                onTap: () {
                  final next = _bannerController.page!.round() + 1;
                  if (next < banners.length)
                    _bannerController.animateToPage(next,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                },
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black45,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.arrow_forward_ios,
                      color: Colors.white, size: 20),
                ),
              ),
            ),
          ),

          // SmoothPageIndicator
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _bannerController,
                count: banners.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 6,
                  dotWidth: 6,
                  activeDotColor: primaryColor,
                  dotColor: Colors.white.withOpacity(0.6),
                  spacing: 6,
                  expansionFactor: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title,
      {required bool seeAll, String? seeAllLabel}) {
    final words = title.trim().split(RegExp(r'\s+'));
    String firstPart = '';
    String lastWord = '';

    if (words.length > 1) {
      lastWord = words.removeLast();
      firstPart = words.join(' ');
    } else if (words.length == 1) {
      lastWord = words[0];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                if (firstPart.isNotEmpty)
                  TextSpan(
                    text: '$firstPart ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                TextSpan(
                  text: lastWord,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          if (seeAll) ...[
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MakesGridScreen()),
                );
              },
              child: Text(
                seeAllLabel ?? 'See All',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionbody(String title,
      {required bool seeAll, String? seeAllLabel}) {
    final words = title.trim().split(RegExp(r'\s+'));
    String firstPart = '';
    String lastWord = '';

    if (words.length > 1) {
      lastWord = words.removeLast();
      firstPart = words.join(' ');
    } else if (words.length == 1) {
      lastWord = words[0];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                if (firstPart.isNotEmpty)
                  TextSpan(
                    text: '$firstPart ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                TextSpan(
                  text: lastWord,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          if (seeAll) ...[
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CarBodyTypesScreen()),
                );
              },
              child: Text(
                seeAllLabel ?? 'See All',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMakeGrid() {
    return SizedBox(
      height: 200,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate((_makes.length / 2).ceil(), (groupIndex) {
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                children: [
                  _buildMakeGridItem(_makes[groupIndex * 2]),
                  const SizedBox(height: 12),
                  if (groupIndex * 2 + 1 < _makes.length)
                    _buildMakeGridItem(_makes[groupIndex * 2 + 1])
                  else
                    const SizedBox(height: 90),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildMakeGridItem(Map<String, dynamic> make) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BMWListScreen(
              makeName: make['label'] ?? '',
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 80,
            height: 65,
            padding: const EdgeInsets.all(5 ),
            child: CachedNetworkImage(
              imageUrl: make['logo'] ?? 'https://via.placeholder.com/150',
              fit: BoxFit.contain,
              placeholder: (context, url) =>
                  const Icon(Icons.directions_car, size: 32),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.directions_car, size: 32),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            make['label'] ?? 'Make',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBodyTypeGrid() {
    return SizedBox(
      height: 200,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate((_bodyTypes.length / 2).ceil(), (groupIndex) {
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                children: [
                  _buildBodyGridItem(_bodyTypes[groupIndex * 2]),
                  const SizedBox(height: 12),
                  if (groupIndex * 2 + 1 < _bodyTypes.length)
                    _buildBodyGridItem(_bodyTypes[groupIndex * 2 + 1])
                  else
                    const SizedBox(height: 90),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBodyGridItem(Map<String, dynamic> bodyType) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BrowseByBody(
              makeName: bodyType['slug'] ?? '',
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 80,
            height: 65,
            padding: const EdgeInsets.all(5),
           
            child: CachedNetworkImage(
              imageUrl: bodyType['logo'] ?? 'https://via.placeholder.com/150',
              fit: BoxFit.contain,
              placeholder: (context, url) =>
                  const Icon(Icons.directions_car, size: 32),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.directions_car, size: 32),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            bodyType['label'] ?? 'Body Type',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: textColor.withOpacity(0.6),
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: primaryColor,
            boxShadow: [
              BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ],
          ),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          tabs: const [
            Tab(text: 'Recently items'),
            Tab(text: 'Featured items'),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentCars() {
    final recentCars = _mainPageData?['recent'] as List? ?? [];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: recentCars.length,
      itemBuilder: (context, index) {
        final car = recentCars[index];
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: _buildCarCard(
            car['grid']['title'] ?? 'No title',
            car['price'] ?? 'Price not available',
            car['imgUrl'] ?? 'https://via.placeholder.com/150',
            car['list']['infoOneDesc'] ?? 'Mileage not available',
            '', // location not in API
            4.5, // default rating
            car['ID'] ?? '', // Pass the car ID
          ),
        );
      },
    );
  }

  Widget _buildFeaturedCars() {
    final featuredCars = _mainPageData?['featured'] as List? ?? [];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: featuredCars.length,
      itemBuilder: (context, index) {
        final car = featuredCars[index];
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: _buildFeaturedCarCard(
            car['title'] ?? 'No title',
            car['price'] ?? 'Price not available',
            car['img'] ?? 'https://via.placeholder.com/150',
            '', // miles not in API
            '', // location not in API
            4.5, // default rating
            car['discountPrice'] != null
                ? '${car['price']} → ${car['discountPrice']}'
                : 'Special Offer',
            car['ID'] ?? '', // Pass the car ID here
          ),
        );
      },
    );
  }

  Widget _buildCarCard(String name, String price, String imageUrl, String miles,
      String location, double rating, id) {
    return SizedBox(
      width: 260,
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image with favorite button
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.error, color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.speed_outlined,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        miles,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    price,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarDetailScreen(
                          idCar: id,
                        ),
                      ),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'View Details',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
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

  Widget _buildFeaturedCarCard(
    String name,
    String price,
    String imageUrl,
    String miles,
    String location,
    double rating,
    String discount,
    id,
  ) {
    return SizedBox(
      width: 260,
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image with favorite button and discount badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.error, color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: successColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      discount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.speed_outlined,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        miles,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        'Special Offer',
                        style: TextStyle(
                          fontSize: 10, 
                          color: successColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarDetailScreen(idCar: id),
                      ),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'View Details',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
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

  Widget _buildValueMyCarSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildCardSection(
            imageAsset:
                'assets/images/Value my Car.jpg', // Replace with your actual asset path
          ),
          const SizedBox(height: 16),
          _buildCardSection(
            imageAsset:
                'assets/images/Biker Section.jpg', // Replace with your actual asset path
          ),
          const SizedBox(height: 16),
          _buildCardSection(
            imageAsset:
                'assets/images/Auto Parts.jpg', // Replace with your actual asset path
          ),
          
        ],
      ),
    );
  }

  Widget _buildCardSection({
    required String imageAsset,
  }) {
    return Container(
      height: 120, // Fixed height for the card
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Stack(
        children: [
          // Background image that covers the whole card
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imageAsset,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          // Gradient overlay for better text visibility

          // Content
         const  Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOffRoadCarsSlider() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BrowseByBody(
                    makeName: 'byd', // Static body type slug for BYD
                  ),
                ),
              );
            },
            child: CarouselSlider(
              options: CarouselOptions(
                height: 180,
                autoPlay: true,
                aspectRatio: 16 / 9,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentCarouselIndex = index;
                  });
                },
              ),
              items: [
                'assets/images/newcars.jpg', // Only 1 image
              ].map((imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildNewsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/News & Reviews.jpg', // your local asset image
              height: 150,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          // Overlay elements
          Positioned(
            top: 120,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xff3ec745),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'TREND',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 12,
            child: ElevatedButton.icon(
              onPressed: () {
                // Add your onPressed action here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff3ec745),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text(
                'Read Articles',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
