import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> processTransaction({
    required double amount,  // Pass amount as a double
    required String accountName,
    required String transactionType,
  }) async {
    try {
      // Retrieve email from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');
      if (email == null) {
        return {
          'success': false,
          'message': "User email not found in preferences.",
        };
      }

      // Execute Firestore transaction to ensure atomicity
      await _firestore.runTransaction((transaction) async {
        // Reference to the account document
        QuerySnapshot accountSnapshot = await _firestore
            .collection('accounts')
            .where('email', isEqualTo: email)
            .where('account_name', isEqualTo: accountName)
            .limit(1)
            .get();

        if (accountSnapshot.docs.isEmpty) {
          throw Exception("Account not found.");
        }

        DocumentReference accountRef = accountSnapshot.docs.first.reference;

        // Get current balance and ensure it's a double
        var currentBalance = accountSnapshot.docs.first['balance'];

        // Ensure currentBalance is a double (parse if it's a String)
        double currentBalanceDouble = currentBalance is double
            ? currentBalance
            : double.tryParse(currentBalance.toString()) ?? 0.0;

        // Calculate new balance based on transaction type
        double updatedBalance;
        if (transactionType == "Expense") {
          updatedBalance = currentBalanceDouble - amount;
          if (updatedBalance < 0) {
            throw Exception("Insufficient funds in the account.");
          }
        } else if (transactionType == "Income") {
          updatedBalance = currentBalanceDouble + amount;
        } else {
          throw Exception("Invalid transaction type.");
        }

        // Update the balance field in Firestore
        transaction.update(accountRef, {'balance': updatedBalance});
      });

      // Return success with a confirmation message
      return {
        'success': true,
        'message': "Transaction completed successfully.",
      };
    } catch (e) {
      // Return failure with an error message
      return {
        'success': false,
        'message': "Transaction failed: ${e.toString()}",
      };
    }
  }
}
