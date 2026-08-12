import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> addFavorite(String uid, String rideId, String name) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(rideId)
        .set({'rideName': name});
  }

  Future<void> removeFavorite(String uid, String rideId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(rideId)
        .delete();
  }

  Future<List<Map<String, dynamic>>> getAllFavorites(String uid) async {
    final query = await _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .get();
    final favoriteList = query.docs
        .map((doc) => {'rideId': doc.id, ...doc.data()})
        .toList();
    return favoriteList;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> favoritesStream(String uid) {
    return _db.collection('users').doc(uid).collection('favorites').snapshots();
  }

  Future<void> addAlert(
    String uid,
    String rideId,
    String name,
    int threshold,
  ) async {
    await _db.collection('users').doc(uid).collection('alerts').doc(rideId).set(
      {'rideName': name, 'alertThreshold': threshold},
    );
  }

  Future<void> removeAlert(String uid, String rideId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('alerts')
        .doc(rideId)
        .delete();
  }

  Future<List<Map<String, dynamic>>> getAllAlerts(String uid) async {
    final query = await _db
        .collection('users')
        .doc(uid)
        .collection('alerts')
        .get();
    final alertsList = query.docs
        .map((doc) => {'rideId': doc.id, ...doc.data()})
        .toList();
    return alertsList;
  }
}
