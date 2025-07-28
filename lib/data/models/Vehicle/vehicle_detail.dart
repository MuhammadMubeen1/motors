import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:motors_app/data/models/Vehicle/vehicle.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class VehicleDetailScreen extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleDetailScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text(
          vehicle.title,
          style: const TextStyle(
            color: Colors.black, // Set title color to black
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black, // Set back icon color to black
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor:
            Colors.white, // Optional: Set app bar background to white
        elevation: 0, // Optional: Remove shadow
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Gallery
            SizedBox(
              height: 300,
              child: PageView.builder(
                itemCount: vehicle.gallery.length,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: vehicle.gallery[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  );
                },
              ),
            ),
            // Image indicator
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SmoothPageIndicator(
                  count: vehicle.gallery.length,
                  effect: const WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Colors.green,
                  ), controller: PageController(initialPage: 0)
                ),
              ),
            ),
            
            // Vehicle Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    vehicle.subTitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Price
                  Text(
                    vehicle.price,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Divider
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  // Specifications
                  const Text(
                    'Specifications',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Specification Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildSpecItem(Icons.speed, 'Mileage', vehicle.mileage),
                      _buildSpecItem(Icons.directions_car, 'Body Type', vehicle.bodyType),
                      _buildSpecItem(Icons.local_gas_station, 'Fuel Type', vehicle.fuelType),
                      _buildSpecItem(Icons.calendar_today, 'Year', '2021'), // You might need to add year to your model
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  // Contact Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16)),
                      onPressed: () {
                        // Handle contact action
                      },
                      child: const Text(
                        'Contact Seller',
                        style: TextStyle(fontSize: 18),
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

  Widget _buildSpecItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}