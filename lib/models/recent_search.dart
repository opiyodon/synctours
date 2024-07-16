import 'package:cloud_firestore/cloud_firestore.dart';

class RecentSearch {
  final String uid;
  final String query;
  final DateTime timestamp;

  RecentSearch({
    required this.uid,
    required this.query,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'query': query,
      'timestamp': timestamp,
    };
  }

  static RecentSearch fromMap(Map<String, dynamic> map) {
    return RecentSearch(
      uid: map['uid'],
      query: map['query'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
