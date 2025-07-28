import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/data/models/Vehicle/cardetails_model.dart';

class CarDetailsScreen extends StatelessWidget {
  final CarListings car;

  const CarDetailsScreen({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          car.grid.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
       
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Slider with Dots Indicator
            _buildImageSlider(),

            // Price and short info
            _buildHeaderSection(context),

            // Divider
            const Divider(height: 20, thickness: 1),

            // Main Details Card
            _buildDetailsCard(context),

            // Additional Features Section
            // if (car.list.features != null && car.list.features!.isNotEmpty)
            //   _buildFeaturesSection(),

            // Contact/Seller Info Section
            _buildContactSection(),

            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add contact action
        },
        icon: const Icon(Icons.phone),
        label: const Text('Contact Seller'),
        backgroundColor: Color(0xff3ec745),
      ),
    );
  }

  Widget _buildImageSlider() {
    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: car.gallery.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: car.gallery[index].url,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 50,
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                car.gallery.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            car.grid.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3ec745),
                ),
          ),
          const SizedBox(height: 4),
          Text(
            car.grid.subTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade100),
            ),
            child: Text(
              car.price,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(16.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.directions_car, color: Color(0xff3ec745)),
                const SizedBox(width: 8),
                Text(
                  'Vehicle Details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff3ec745),
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.model_training, 'Model', car.grid.title),
            _buildDetailRow(Icons.construction, 'Condition', car.grid.subTitle),
            if (car.list.infoOneTitle != null)
              _buildDetailRow(
                  Icons.info, car.list.infoOneTitle!, car.list.infoOneDesc!),
            if (car.list.infoTwoTitle != null)
              _buildDetailRow(
                  Icons.info, car.list.infoTwoTitle!, car.list.infoTwoDesc!),
            if (car.list.infoThreeTitle != null)
              _buildDetailRow(Icons.info, car.list.infoThreeTitle!,
                  car.list.infoThreeDesc!),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color:Color(0xff3ec745)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Features',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff3ec745),
            ),
          ),
          const SizedBox(height: 12),
          // Wrap(
          //   spacing: 8,
          //   runSpacing: 8,
          //   children: car.list.features!
          //       .map((feature) => Chip(
          //             label: Text(feature),
          //             backgroundColor: Colors.blue.shade50,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(8),
          //             ),
          //           ))
          //       .toList(),
          // ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(16.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child:const Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color:Color(0xff3ec745)),
                const SizedBox(width: 8),
                Text(
                  'Seller Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff3ec745),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // ListTile(
            //   leading: const Icon(Icons.location_on, color: Colors.blue),
            //   title: const Text('Location'),
            //   subtitle: Text(car.list. ?? 'Not specified'),
            // ),
            // ListTile(
            //   leading: const Icon(Icons.phone, color: Colors.blue),
            //   title: const Text('Contact Number'),
            //   subtitle: Text(car.list.phone ?? 'Not specified'),
            // ),
            // ListTile(
            //   leading: const Icon(Icons.email, color: Colors.blue),
            //   title: const Text('Email'),
            //   subtitle: Text(car.list.email ?? 'Not specified'),
            // ),
          ],

        ),
      ),
    );
  }
}
