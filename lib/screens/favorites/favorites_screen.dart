import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disneyapp/screens/ride_detail/ride_detail_screen.dart';
import 'package:disneyapp/services/auth_service.dart';
import 'package:disneyapp/services/themeparks_api.dart';
import 'package:disneyapp/theme/app_theme.dart';
import 'package:disneyapp/widgets/ride_card.dart';
import 'package:disneyapp/widgets/status_message.dart';
import 'package:flutter/material.dart';
import 'package:disneyapp/services/firestore_service.dart';
import 'package:disneyapp/models/ride.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  final _api = ThemeParksApi();
  final Map<String, Ride> _ridesById = {};
  // Created once so rebuilds don't re-subscribe to Firestore.
  Stream<QuerySnapshot<Map<String, dynamic>>>? _favoritesStream;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final userId = _authService.currentUserId;
    if (userId != null) {
      _favoritesStream = _firestoreService.favoritesStream(userId);
    }
    _loadRideWait();
  }

  @override
  Widget build(BuildContext context) {
    final stream = _favoritesStream;

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: stream == null
          ? const StatusMessage(
              icon: Icons.error_outline,
              message: "Couldn't load your favorites",
              hint: 'Try logging out and back in.',
              isError: true,
            )
          : StreamBuilder(stream: stream, builder: _buildBody),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
  ) {
    if (snapshot.hasError) {
      debugPrint("Favorites stream error: ${snapshot.error}");
      return const StatusMessage(
        icon: Icons.cloud_off,
        message: "Couldn't load your favorites",
        isError: true,
      );
    }

    final data = snapshot.data;
    if (data == null || _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final favoritesList = data.docs;
    if (favoritesList.isEmpty) {
      return const StatusMessage(
        icon: Icons.favorite_border,
        message: 'No favorites yet',
        hint: 'Tap ♡ on any ride to save it here.',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRideWait,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: favoritesList.length,
        itemBuilder: (context, index) {
          final document = favoritesList[index];
          final ride = _ridesById[document.id];
          if (ride == null) {
            final rideName =
                document.data()['rideName'] as String? ?? "Unknown Ride";
            return _buildMissingRideCard(rideName);
          }
          return RideCard(ride: ride, onTap: () => _openRideDetail(ride));
        },
      ),
    );
  }

  /// A favorite that isn't in today's API data (or the fetch failed).
  Widget _buildMissingRideCard(String rideName) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(rideName, style: AppTextStyles.headingMedium),
        subtitle: Text(
          "No wait data right now",
          style: AppTextStyles.bodySmall,
        ),
      ),
    );
  }

  void _openRideDetail(Ride ride) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RideDetailScreen(ride: ride)),
    );
  }

  Future<void> _loadRideWait() async {
    try {
      final rides = await _api.fetchRides();
      if (!mounted) return;
      setState(() {
        for (final ride in rides) {
          _ridesById[ride.id] = ride;
        }
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Failed to load wait times: $e");
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }
}
