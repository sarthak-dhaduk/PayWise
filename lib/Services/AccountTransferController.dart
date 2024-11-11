// AccountTransferController.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountTransferController {
  Future<Map<String, dynamic>> transferAmount({
    required String fromAccount,
    required String toAccount,
    required double amount,
  }) async {
    try {
      // Retrieve email from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email') ?? '';

      // Check if "from" and "to" accounts are the same
      if (fromAccount == toAccount) {
        return {
          'success': false,
          'message': 'Transfer failed: Source and destination accounts cannot be the same.'
        };
      }

      // Get documents for "from" and "to" accounts
      final fromAccountSnapshot = await FirebaseFirestore.instance
          .collection('accounts')
          .where('email', isEqualTo: email)
          .where('account_name', isEqualTo: fromAccount)
          .limit(1)
          .get();

      final toAccountSnapshot = await FirebaseFirestore.instance
          .collection('accounts')
          .where('email', isEqualTo: email)
          .where('account_name', isEqualTo: toAccount)
          .limit(1)
          .get();

      // Check if both accounts exist
      if (fromAccountSnapshot.docs.isEmpty || toAccountSnapshot.docs.isEmpty) {
        return {
          'success': false,
          'message': 'Transfer failed: One or both accounts do not exist.'
        };
      }

      // Extract and convert balances to double
      final fromAccountDoc = fromAccountSnapshot.docs.first;
      final toAccountDoc = toAccountSnapshot.docs.first;

      double fromBalance = _convertToDouble(fromAccountDoc['balance']);
      double toBalance = _convertToDouble(toAccountDoc['balance']);

      // Check if "from" account has sufficient funds
      if (fromBalance < amount) {
        return {
          'success': false,
          'message': 'Transfer failed: Insufficient balance in source account.'
        };
      }

      // Perform balance updates
      final newFromBalance = fromBalance - amount;
      final newToBalance = toBalance + amount;

      // Update both account documents
      await FirebaseFirestore.instance
          .collection('accounts')
          .doc(fromAccountDoc.id)
          .update({'balance': newFromBalance});

      await FirebaseFirestore.instance
          .collection('accounts')
          .doc(toAccountDoc.id)
          .update({'balance': newToBalance});

      // Return success
      return {
        'success': true,
        'message': 'Transfer successful.'
      };

    } catch (e) {
      print("Error in account transfer: $e");
      return {
        'success': false,
        'message': 'Transfer failed due to an unexpected error.'
      };
    }
  }

  // Helper function to safely convert balance to double
  double _convertToDouble(dynamic balance) {
    if (balance is double) {
      return balance;
    } else if (balance is int) {
      return balance.toDouble();
    } else if (balance is String) {
      return double.tryParse(balance) ?? 0.0;
    } else {
      throw Exception("Invalid balance type");
    }
  }
}
