import 'package:disneyapp/services/themeparks_api.dart';
import 'package:disneyapp/utils/show_sorting.dart';
import 'package:disneyapp/widgets/attribution_footer.dart';
import 'package:disneyapp/widgets/show_card.dart';
import 'package:disneyapp/widgets/status_message.dart';
import 'package:flutter/material.dart';
import 'package:disneyapp/models/show.dart';

class ShowtimeScreen extends StatefulWidget {
  const ShowtimeScreen({super.key});

  @override
  State<ShowtimeScreen> createState() => _ShowtimeState();
}

class _ShowtimeState extends State<ShowtimeScreen> {
  final _api = ThemeParksApi();
  List<Show> _shows = [];
  bool _isLoading = true;
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Showtimes")),
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
      return const Center(child: CircularProgressIndicator());
    }

    final errorText = _errorText;
    if (errorText != null) {
      return RefreshIndicator(
        onRefresh: _loadShows,
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

    return RefreshIndicator(
      onRefresh: _loadShows,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        itemCount: _shows.length + 1,
        itemBuilder: (context, index) {
          if (index == _shows.length) {
            return const AttributionFooter();
          }
          return ShowCard(show: _shows[index]);
        },
      ),
    );
  }

  Future<void> _loadShows() async {
    try {
      final showInfo = await _api.fetchShows();
      if (!mounted) return;
      setState(() {
        _shows = sortShowsForDisplay(showInfo);
        _isLoading = false;
        _errorText = null;
      });
    } catch (e) {
      debugPrint("Error in showtimes_screen: $e");
      if (!mounted) return;
      setState(() {
        _errorText = "Couldn't load showtimes.";
        _isLoading = false;
      });
    }
  }
}
