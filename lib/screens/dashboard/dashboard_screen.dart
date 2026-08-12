import 'package:disneyapp/screens/ride_detail/ride_detail_screen.dart';
import 'package:disneyapp/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:disneyapp/models/ride.dart';
import 'package:disneyapp/services/themeparks_api.dart';
import 'package:disneyapp/utils/ride_display.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardScreen> {
  List<Ride> _rides = [];
  bool _isLoading = true;
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wait Times")),
      body: _buildBody(),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadRides();
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (_errorText != null) {
      return RefreshIndicator(
        onRefresh: _loadRides,
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            Text(_errorText!, style: TextStyle(color: AppColors.error)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRides,
      child: ListView.builder(
        itemCount: _rides.length + 1,
        itemBuilder: (context, index) {
          if (index == _rides.length) {
            return Center(child: Text("Data from ThemeParks.wiki"));
          }
          final ride = _rides[index];
          return ListTile(
            title: Text(ride.name),
            subtitle: Text(ride.land ?? "---"),
            trailing: Text(
              ride.waitLabel,
              style: TextStyle(color: ride.waitColor),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RideDetailScreen(ride: ride),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _loadRides() async {
    try {
      final rideInfo = await ThemeParksApi().fetchRides();
      setState(() {
        _rides = rideInfo
            .where((item) => item.hasQueue && item.isRide)
            .toList();
        _isLoading = false;
        _errorText = null;
      });
    } catch (e) {
      debugPrint("Error in _loadRides: $e");
      setState(() {
        _errorText = "Failed to load ride data. Pull down to try again.";
        _isLoading = false;
      });
    }
  }
}
