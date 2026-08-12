import 'package:disneyapp/services/themeparks_api.dart';
import 'package:disneyapp/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:disneyapp/models/show.dart';

class ShowtimeScreen extends StatefulWidget {
  const ShowtimeScreen({super.key});

  @override
  State<ShowtimeScreen> createState() => _ShowtimeState();
}

class _ShowtimeState extends State<ShowtimeScreen> {
  List<Show> _shows = [];
  bool _isLoading = true;
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Show Times")),
      body: _buildBody(),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadShows();
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (_errorText != null) {
      return RefreshIndicator(
        onRefresh: _loadShows,
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            Text(_errorText!, style: TextStyle(color: AppColors.error)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadShows,
      child: ListView.builder(
        itemCount: _shows.length + 1,
        itemBuilder: (context, index) {
          if (index == _shows.length) {
            return Center(child: Text("Data from ThemeParks.wiki"));
          }
          final show = _shows[index];
          return ListTile(
            title: Text(show.name),
            subtitle: show.showTimes.isEmpty
                ? Text(
                    "No Shows Today",
                    style: TextStyle(color: AppColors.error),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: show.showTimes.map((showTime) {
                      return Chip(label: Text(showTime.formattedTime));
                    }).toList(),
                  ),
          );
        },
      ),
    );
  }

  Future<void> _loadShows() async {
    try {
      final showInfo = await ThemeParksApi().fetchShows();
      setState(() {
        _shows = showInfo;
        _isLoading = false;
        _errorText = null;
      });
    } catch (e) {
      debugPrint("Error in showtimes_screen: $e");
      setState(() {
        _errorText = "Failed to load show data. Pull down to try again.";
        _isLoading = false;
      });
    }
  }
}
