import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:motors_app/presentation/screens/car_detail/car_detail_screen.dart'
    show CarDetailScreen;

class Browse  extends StatefulWidget {
  final makeName;

  const   Browse({Key? key, required this.makeName, }) : super(key: key);

  @override
  _BMWListScreenState createState() => _BMWListScreenState();
}

class _BMWListScreenState extends State<Browse> {
  List<dynamic> listings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBMWListings();
  }

  Future<void> fetchBMWListings() async {
    try {
      final response = await http.get(Uri.parse(
          'https://wheelers.pk/wp-json/stm-mra/v1/filtered-listings?body%5B0%5D=${widget.makeName}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          listings = data['listings'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load listings');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Browse by make',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // backgroundColor: Colors.white,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : listings.isEmpty
                ? const Center(child: Text('No cars found'))
                : ListView.builder(
                    itemCount: listings.length,
                    itemBuilder: (context, index) {
                      final car = listings[index];
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: Image.network(
                            car['imgUrl'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.car_repair),
                          ),
                          title: Text(car['grid']['title']),
                          subtitle: Text(car['price']),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CarDetailScreen(idCar: car['ID']),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
