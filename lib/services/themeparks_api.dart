import 'dart:convert';
import 'package:http/http.dart';
import 'package:disneyapp/models/ride.dart';
import 'package:disneyapp/models/show.dart';
import 'package:flutter/services.dart';

class ThemeParksApi {
  static const String _baseUrl = "https://api.themeparks.wiki/v1";
  static const String disneylandParkId = "7340550b-c14d-4def-80bb-acdb51d49a66";

  Future<List<dynamic>> _fetchData() async {
    final String url = "$_baseUrl/entity/$disneylandParkId/live";
    final Uri uri = Uri.parse(url);
    final Response response = await get(uri);

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch data");
    }

    final data = jsonDecode(response.body);
    final liveData = data['liveData'];

    return liveData;
  }

  Future<List<Ride>> fetchRides() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/ride_lands.json',
    );
    final landMap = jsonDecode(jsonString) as Map<String, dynamic>;
    final liveData = await _fetchData();

    final convertedLiveData = liveData
        .where((item) => item['entityType'] == "ATTRACTION")
        .map(
          (item) => Ride.fromJson(
            item,
            land: landMap[item['id']]?['land'] as String?,
            isRide: landMap[item['id']]?['isRide'] as bool?,
          ),
        )
        .toList();

    return convertedLiveData;
  }

  Future<List<Show>> fetchShows() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/ride_lands.json',
    );
    final landMap = jsonDecode(jsonString) as Map<String, dynamic>;
    final liveData = await _fetchData();
    final convertedLiveData = liveData
        .where((item) => item['entityType'] == "SHOW")
        .map((item) => Show.fromJson(item, land: landMap[item['id']]?['land']))
        .toList();

    return convertedLiveData;
  }
}
