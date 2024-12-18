import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_44/main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String email = '';
  String gender = '';
  String status = '';
  int age = 0;
  bool receiveNotifications = false;
  String notes = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email') ?? 'Not available';
      gender = prefs.getString('gender') ?? 'Not available';
      status = prefs.getString('status') ?? 'Not available';
      age = prefs.getInt('age') ?? 0;
      receiveNotifications = prefs.getBool('receiveNotifications') ?? false;
      notes = prefs.getString('notes') ?? 'No notes';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Menu'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName:
                  Text(email.isNotEmpty ? email : 'No email available'),
              accountEmail: Text('Gender: $gender'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  email.isNotEmpty
                      ? email[0].toUpperCase()
                      : 'N', // Default to 'N' if email is empty
                ),
              ),
            ),
            ListTile(
              title: Text('Status: $status'),
            ),
            ListTile(
              title: Text('Age: $age'),
            ),
            ListTile(
              title: Text(
                  'Receive Notifications: ${receiveNotifications ? "Yes" : "No"}'),
            ),
            ListTile(
              title: Text('Notes: $notes'),
            ),
            Divider(),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                SharedPreferences.getInstance().then((prefs) {
                  prefs.clear(); // Clear stored data
                  Get.to(() => SignInPage()); // Navigate back to SignInPage
                });
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: List.generate(6, (index) {
            return FoodCard(index: index);
          }),
        ),
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final int index;

  FoodCard({required this.index});

  @override
  Widget build(BuildContext context) {
    List<String> foodNames = [
      'Pizza',
      'Burger',
      'Sushi',
      'Pasta',
      'Salad',
      'Ice Cream'
    ];

    List<String> foodImages = [
      'assets/images/piza.jpg',
      'assets/images/brgr.jpg',
      'assets/images/sushi.jpg',
      'assets/images/piza.jpg',
      'assets/images/brgr.jpg',
      'assets/images/sushi.jpg',
    ];

    return GestureDetector(
      onTap: () {
        // Navigate to the food description page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailPage(
              foodName: foodNames[index],
              foodImage: foodImages[index],
              foodDescription:
                  'Description of ${foodNames[index]}', // You can add more detailed descriptions here
            ),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.asset(
                  foodImages[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                foodNames[index],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodDetailPage extends StatelessWidget {
  final String foodName;
  final String foodImage;
  final String foodDescription;

  FoodDetailPage({
    required this.foodName,
    required this.foodImage,
    required this.foodDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(foodName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              foodImage,
              fit: BoxFit.cover,
              height: 250,
              width: double.infinity,
            ),
            SizedBox(height: 20),
            Text(
              foodName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              foodDescription,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
