import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateSpendAmount(double amount, String categoryName) async {
    try {
      // Retrieve email from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');

      if (email == null) {
        debugPrint("Email not found in shared preferences.");
        return; // Exit if email is not found
      }

      // Fetch the category document where email and name match
      QuerySnapshot snapshot = await _firestore
          .collection('categories')
          .where('email', isEqualTo: email)
          .where('name', isEqualTo: categoryName)
          .limit(1)
          .get();

      // Check if document exists
      if (snapshot.docs.isEmpty) {
        debugPrint("Category not found.");
        return; // Exit if the category does not exist
      }

      // Get the reference to the document
      DocumentReference categoryDoc = snapshot.docs.first.reference;

      // Retrieve document snapshot
      DocumentSnapshot categorySnapshot = await categoryDoc.get();
      var categoryData = categorySnapshot.data() as Map<String, dynamic>?;

      // Check if 'spend' field exists
      if (categoryData == null || !categoryData.containsKey('spend')) {
        debugPrint("Spend field not found in category.");
        return; // Exit if "spend" field is missing
      }

      // Retrieve and handle 'spend' as num to accommodate both int and double
      num currentSpend = categoryData['spend'];
      double updatedSpend = currentSpend.toDouble() + amount;

      // Update the spend field
      await categoryDoc.update({'spend': updatedSpend});

      debugPrint("Spend updated successfully.");

    } catch (e) {
      debugPrint("Error updating spend amount: $e");
    }
  }
}
