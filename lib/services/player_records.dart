//this file is used for CRUD operations on player records as the game is played

//importing the required utilites
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

//creating a function to save the player name
Future<void> savePlayerName(String name) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  
  //making sure each player only pairs to one uid
  final playerDoc = FirebaseFirestore.instance.collection('players').doc(user.uid);

  //setting default values besides the id and name
  await playerDoc.set({
    'playerID': user.uid,
    'playerName': name,
    'highestScore': 0,
    'points': 0,
    'ownedSkins': [],
  });
}

//creating a function to update the players scores and points
Future<void> updateScore(int newScore, int pointsEarned) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final playerDoc = FirebaseFirestore.instance.collection('players').doc(user.uid);
  final playerData = await playerDoc.get();

  if (playerData.exists) {
    int currentScore = playerData['highestScore'] ?? 0;
    int updatedPoints = (playerData['points'] ?? 0) + pointsEarned;

    await playerDoc.update({
      'highestScore': newScore > currentScore ? newScore : currentScore,
      'points': updatedPoints,
    });

    if (newScore > currentScore) {
      await FirebaseFirestore.instance.collection('scores').doc(user.uid).set({
        'playerID': user.uid,
        'playerName': playerData['playerName'],
        'highestScore': newScore,
      });
    }
  }
}

//Creating a function to pull data from the database to display the leaderboard
Future<Map<String, dynamic>> getLeaderboard() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return {};

  final topScoresSnapshot = await FirebaseFirestore.instance
      .collection('scores')
      .orderBy('highestScore', descending: true)
      .limit(5)
      .get();

  final playerScoreSnapshot = await FirebaseFirestore.instance
      .collection('players')
      .doc(user.uid)
      .get();

  return {
    'topScores': topScoresSnapshot.docs.map((doc) => doc.data()).toList(),
    'playerRank': playerScoreSnapshot.exists ? playerScoreSnapshot.data() : null,
  };
}

//creating a function to fetch available skins and allow the purchase of unowned skins
Future<List<Map<String, dynamic>>> getAvailableSkins() async {
  final skinsSnapshot = await FirebaseFirestore.instance.collection('skins').get();
  return skinsSnapshot.docs.map((doc) => doc.data()).toList();
}

Future<void> purchaseSkin(String skinID, int cost) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final playerDoc = FirebaseFirestore.instance.collection('players').doc(user.uid);
  final playerData = await playerDoc.get();

  if (playerData.exists) {
    int currentPoints = playerData['points'] ?? 0;
    List ownedSkins = List.from(playerData['ownedSkins'] ?? []);

    if (currentPoints >= cost && !ownedSkins.contains(skinID)) {
      ownedSkins.add(skinID);

      await playerDoc.update({
        'points': currentPoints - cost,
        'ownedSkins': ownedSkins,
      });
    } else {
      debugPrint('Not enough points or skin already owned.');
    }
  }
}