import 'package:disneyapp/screens/ride_detail/ride_detail_screen.dart';
import 'package:disneyapp/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:disneyapp/models/ride.dart';
import 'package:disneyapp/services/themeparks_api.dart';
import 'package:disneyapp/utils/ride_sorting.dart';
import 'package:disneyapp/utils/time_format.dart';
import 'package:disneyapp/widgets/attribution_footer.dart';
import 'package:disneyapp/widgets/land_section_header.dart';
import 'package:disneyapp/widgets/ride_card.dart';
import 'package:disneyapp/widgets/status_message.dart';

enum WaitSortMode { byLand, shortestWait }

/// One row in the wait-times list: either a land header or a ride.
sealed class _DashboardEntry {
  const _DashboardEntry();
}

class _LandHeaderEntry extends _DashboardEntry {
  final String land;
  final int rideCount;
  const _LandHeaderEntry({required this.land, required this.rideCount});
}

class _RideEntry extends _DashboardEntry {
  final Ride ride;
  const _RideEntry(this.ride);
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardScreen> {
  final _api = ThemeParksApi();
  List<Ride> _rides = [];
  bool _isLoading = true;
  String? _errorText;
  WaitSortMode _sortMode = WaitSortMode.byLand;

  static const String _parkTitle = 'Disneyland';

  @override
  void initState() {
    super.initState();
    _loadRides();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _buildTitle()),
      body: _buildBody(),
    );
  }

  Widget _buildTitle() {
    final updated = latestUpdate(_rides);

    return Column(
      children: [
        const Text(_parkTitle),
        if (updated != null)
          Text(
            'Updated ${formatClockTime(updated)}',
            style: AppTextStyles.caption,
          ),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final errorText = _errorText;
    if (errorText != null) {
      return RefreshIndicator(
        onRefresh: _loadRides,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 96),
          children: [
            StatusMessage(
              icon: Icons.cloud_off,
              message: errorText,
              hint: 'Pull down to try again.',
              isError: true,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: _buildSortToggle(),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadRides,
            child: _buildRideList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSortToggle() {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<WaitSortMode>(
        segments: const [
          ButtonSegment(
            value: WaitSortMode.byLand,
            label: Text('By Land'),
            icon: Icon(Icons.map_outlined),
          ),
          ButtonSegment(
            value: WaitSortMode.shortestWait,
            label: Text('Shortest Wait'),
            icon: Icon(Icons.timer_outlined),
          ),
        ],
        selected: {_sortMode},
        onSelectionChanged: _handleSortChanged,
        showSelectedIcon: false,
      ),
    );
  }

  Widget _buildRideList() {
    final entries = _buildEntries();

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      itemCount: entries.length + 1,
      itemBuilder: (context, index) {
        if (index == entries.length) {
          return const AttributionFooter();
        }

        return switch (entries[index]) {
          _LandHeaderEntry(:final land, :final rideCount) => LandSectionHeader(
            land: land,
            rideCount: rideCount,
          ),
          _RideEntry(:final ride) => RideCard(
            ride: ride,
            isLandShown: _sortMode == WaitSortMode.shortestWait,
            onTap: () => _openRideDetail(ride),
          ),
        };
      },
    );
  }

  /// Flattens the rides into the rows the list shows for the current sort.
  List<_DashboardEntry> _buildEntries() {
    switch (_sortMode) {
      case WaitSortMode.byLand:
        return [
          for (final group in groupRidesByLand(_rides).entries) ...[
            _LandHeaderEntry(land: group.key, rideCount: group.value.length),
            for (final ride in group.value) _RideEntry(ride),
          ],
        ];
      case WaitSortMode.shortestWait:
        return [
          for (final ride in sortByShortestWait(_rides)) _RideEntry(ride),
        ];
    }
  }

  void _handleSortChanged(Set<WaitSortMode> selection) {
    setState(() => _sortMode = selection.first);
  }

  void _openRideDetail(Ride ride) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RideDetailScreen(ride: ride)),
    );
  }

  Future<void> _loadRides() async {
    try {
      final rideInfo = await _api.fetchRides();
      if (!mounted) return;
      setState(() {
        _rides = rideInfo
            .where((item) => item.hasQueue && item.isRide)
            .toList();
        _isLoading = false;
        _errorText = null;
      });
    } catch (e) {
      debugPrint("Error in _loadRides: $e");
      if (!mounted) return;
      setState(() {
        _errorText = "Couldn't load wait times.";
        _isLoading = false;
      });
    }
  }
}
