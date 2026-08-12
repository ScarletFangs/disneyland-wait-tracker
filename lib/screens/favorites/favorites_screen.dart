import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disneyapp/services/auth_service.dart';
import 'package:disneyapp/services/themeparks_api.dart';
import 'package:disneyapp/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:disneyapp/services/firestore_service.dart';
import 'package:disneyapp/models/ride.dart';
import 'package:disneyapp/utils/ride_display.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final Map<String, Ride> _ridesById = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRideWait();
  }

  @override
  Widget build(BuildContext context) {
    String? userId = AuthService().currentUserId;

    if (userId == null) {
      return Text("User failed to load");
    }

    return Scaffold(
      appBar: AppBar(title: Text("Favorites")),
      body: StreamBuilder(
        stream: FirestoreService().favoritesStream(userId),
        builder: _buildBody,
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
  ) {
    if (snapshot.hasError) {
      return Text("Error loading favorites");
    }

    if (!snapshot.hasData) {
      return Center(child: CircularProgressIndicator());
    }

    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final favoritesList = snapshot.data!.docs;

    //no favorites yet
    if (favoritesList.isEmpty) {
      return Text("No favorites yet, tap the heart icon on any rides!");
    } else {
      return RefreshIndicator(
        onRefresh: _loadRideWait,
        child: ListView.builder(
          itemCount: favoritesList.length,
          itemBuilder: (context, index) {
            final document = favoritesList[index];
            final rideName =
                document.data()['rideName'] as String? ?? "Unknown Ride";
            final ride = _ridesById[document.id];
            return ListTile(
              title: Text(rideName),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite, color: AppColors.secondary),
                  Text(ride?.waitLabel ?? '-'),
                ],
              ),
            );
          },
        ),
      );
    }
  }

  Future<void> _loadRideWait() async {
    try {
      final favoriteInfos = await ThemeParksApi().fetchRides();
      setState(() {
        for (int i = 0; i < favoriteInfos.length; i++) {
          _ridesById[favoriteInfos[i].id] = favoriteInfos[i];
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        debugPrint("Failed to load wait times: $e");
        _isLoading = false;
      });
    }
  }
}
