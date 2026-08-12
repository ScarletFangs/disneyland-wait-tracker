import 'package:disneyapp/models/ride.dart';
import 'package:disneyapp/services/auth_service.dart';
import 'package:disneyapp/services/firestore_service.dart';
import 'package:disneyapp/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:disneyapp/utils/ride_display.dart';

class RideDetailScreen extends StatefulWidget {
  final Ride ride;
  const RideDetailScreen({super.key, required this.ride});

  @override
  State<RideDetailScreen> createState() => _RideDetailScreenState();
}

class _RideDetailScreenState extends State<RideDetailScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.ride.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 60, color: AppColors.primary),
            Text(widget.ride.waitLabel),
            Text(
              widget.ride.standbyWait == null
                  ? '-'
                  : "${widget.ride.standbyWait} min",
            ),
            _buildLightningLane(),
            IconButton(
              onPressed: _toggleFavorite,
              icon: _isFavorite
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLightningLane() {
    final ll = widget.ride.lightningLane;

    if (ll == null) {
      return const Text("Lightning Lane: Not Available");
    } else if (ll.returnStart == null) {
      return const Text("Lightning Lane: Finished");
    }

    final priceText = ll.price != null
        ? "${ll.price}"
        : "included with Multi Pass";

    return Text("Lightning Lane: ${ll.formattedTime} · $priceText");
  }

  Future<void> _loadFavoriteStatus() async {
    final userId = AuthService().currentUserId;
    if (userId == null) return;

    final listOfFavorite = await FirestoreService().getAllFavorites(userId);
    if (!mounted) return;
    final favorite = listOfFavorite.any(
      (fav) => fav['rideId'] == widget.ride.id,
    );

    setState(() {
      _isFavorite = favorite;
    });
  }

  Future<void> _toggleFavorite() async {
    final userId = AuthService().currentUserId;
    if (userId == null) return;

    setState(() => _isFavorite = !_isFavorite);

    try {
      if (_isFavorite) {
        await FirestoreService().addFavorite(
          userId,
          widget.ride.id,
          widget.ride.name,
        );
      } else {
        await FirestoreService().removeFavorite(userId, widget.ride.id);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isFavorite = !_isFavorite);
    }
  }
}
