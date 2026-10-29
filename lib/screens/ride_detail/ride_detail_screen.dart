import 'package:disneyapp/models/ride.dart';
import 'package:disneyapp/services/auth_service.dart';
import 'package:disneyapp/services/firestore_service.dart';
import 'package:disneyapp/theme/app_theme.dart';
import 'package:disneyapp/widgets/stat_box.dart';
import 'package:flutter/material.dart';
import 'package:disneyapp/utils/ride_display.dart';

class RideDetailScreen extends StatefulWidget {
  final Ride ride;
  const RideDetailScreen({super.key, required this.ride});

  @override
  State<RideDetailScreen> createState() => _RideDetailScreenState();
}

class _RideDetailScreenState extends State<RideDetailScreen> {
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  bool _isFavorite = false;

  static const double _headerHeight = 180;
  static const double _headerIconSize = 72;
  static const String _parkName = 'Disneyland Park';
  static const String _lightningLaneLabel = 'Lightning Lane Return';

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  @override
  Widget build(BuildContext context) {
    final ride = widget.ride;
    final updated = ride.formattedLastUpdated;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ride.landColor,
        actions: [
          IconButton(
            onPressed: _toggleFavorite,
            tooltip: _isFavorite ? 'Remove favorite' : 'Add favorite',
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ride.name, style: AppTextStyles.displayMedium),
                  const SizedBox(height: 6),
                  Text(
                    '$_parkName · ${ride.land ?? 'Disneyland'}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildWaitStat()),
                      const SizedBox(width: 12),
                      Expanded(child: _buildLightningLaneStat()),
                    ],
                  ),
                  if (updated != null) ...[
                    const SizedBox(height: 24),
                    Text('Last updated $updated', style: AppTextStyles.caption),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Stands in for a ride photo (the API has none): a tall land-colored band.
  Widget _buildHeader() {
    final ride = widget.ride;

    return Container(
      height: _headerHeight,
      color: ride.landColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.attractions,
            size: _headerIconSize,
            color: AppColors.textPrimary.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 8),
          Text(
            (ride.land ?? _parkName).toUpperCase(),
            style: AppTextStyles.labelMedium.copyWith(letterSpacing: 1.2),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitStat() {
    final ride = widget.ride;
    final wait = ride.activeWait;

    return StatBox(
      label: 'Current Wait',
      color: ride.waitColor,
      value: wait != null ? '$wait' : ride.statusLabel,
      caption: wait != null ? 'min' : null,
    );
  }

  Widget _buildLightningLaneStat() {
    final ll = widget.ride.lightningLane;

    if (ll == null) {
      return const StatBox(
        label: _lightningLaneLabel,
        color: AppColors.waitClosed,
        value: 'Not available',
      );
    }

    final returnTime = ll.formattedTime;
    if (returnTime == null) {
      return const StatBox(
        label: _lightningLaneLabel,
        color: AppColors.waitClosed,
        value: 'Finished',
        caption: 'No returns left today',
      );
    }

    return StatBox(
      label: _lightningLaneLabel,
      color: AppColors.primaryLight,
      value: returnTime,
      caption: ll.price ?? 'Multi Pass',
    );
  }

  Future<void> _loadFavoriteStatus() async {
    final userId = _authService.currentUserId;
    if (userId == null) return;

    final listOfFavorite = await _firestoreService.getAllFavorites(userId);
    if (!mounted) return;
    final favorite = listOfFavorite.any(
      (fav) => fav['rideId'] == widget.ride.id,
    );

    setState(() {
      _isFavorite = favorite;
    });
  }

  Future<void> _toggleFavorite() async {
    final userId = _authService.currentUserId;
    if (userId == null) return;

    setState(() => _isFavorite = !_isFavorite);

    try {
      if (_isFavorite) {
        await _firestoreService.addFavorite(
          userId,
          widget.ride.id,
          widget.ride.name,
        );
      } else {
        await _firestoreService.removeFavorite(userId, widget.ride.id);
      }
    } catch (e) {
      debugPrint("Failed to update favorite: $e");
      if (!mounted) return;
      setState(() => _isFavorite = !_isFavorite);
    }
  }
}
