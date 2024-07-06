import 'package:flutter/material.dart';

class PetDetailScreen extends StatelessWidget {
  final Map<String, dynamic> pet;

  PetDetailScreen({required this.pet});

  bool _isValidUrl(String? url) {
    if (url == null || url.isEmpty) {
      return false;
    }
    Uri? uri = Uri.tryParse(url);
    return uri != null &&
        uri.hasAbsolutePath &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _isValidUrl(pet['photo']) ? pet['photo'] : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(pet['name'] ?? 'Pet Detail'),
        backgroundColor: Colors.green, // AppBarの色を緑に設定
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 80.0,
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl)
                    : AssetImage('assets/default_image.jpg') as ImageProvider,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              '名前: ${pet['name'] ?? 'Unknown'}',
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800]),
            ),
            SizedBox(height: 10.0),
            Text(
              '種別: ${pet['species'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 18.0, color: Colors.green[600]),
            ),
            SizedBox(height: 10.0),
            Text(
              '誕生日: ${pet['birthday']?.toString() ?? 'Unknown'}',
              style: TextStyle(fontSize: 18.0, color: Colors.green[600]),
            ),
            SizedBox(height: 10.0),
            Text(
              '性別: ${pet['gender'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 18.0, color: Colors.green[600]),
            ),
            SizedBox(height: 10.0),
            Text(
              '体重: ${pet['weight'] ?? 'Unknown'} kg',
              style: TextStyle(fontSize: 18.0, color: Colors.green[600]),
            ),
            SizedBox(height: 10.0),
            Text(
              '身長: ${pet['height'] ?? 'Unknown'} cm',
              style: TextStyle(fontSize: 18.0, color: Colors.green[600]),
            ),
          ],
        ),
      ),
    );
  }
}
