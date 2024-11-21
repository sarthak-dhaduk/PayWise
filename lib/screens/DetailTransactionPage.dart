import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailTransactionPage extends StatefulWidget {
  final String transactionId;

  const DetailTransactionPage({Key? key, required this.transactionId})
      : super(key: key);

  @override
  _DetailTransactionPageState createState() => _DetailTransactionPageState();
}

class _DetailTransactionPageState extends State<DetailTransactionPage> {
  Map<String, dynamic>? transactionData;
  Color? transactionColor;

  @override
  void initState() {
    super.initState();
    fetchTransactionDetails(widget.transactionId);
  }

  Future<void> fetchTransactionDetails(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');

    if (email != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('email', isEqualTo: email)
          .where('transaction_id', isEqualTo: id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        setState(() {
          transactionData = data;
          transactionColor = _getTransactionColor(data['transaction_type']);
        });
      }
    }
  }

  Color _getTransactionColor(String transactionType) {
    switch (transactionType) {
      case 'Expense':
        return Color.fromRGBO(253, 60, 74, 1);
      case 'Income':
        return Color.fromRGBO(0, 168, 107, 1);
      case 'Transfer':
        return Color.fromRGBO(0, 119, 255, 1);
      default:
        return Colors.grey;
    }
  }

  Widget _buildTransactionProof(String proofUrl) {
    final isImage = proofUrl.endsWith('.jpg') ||
        proofUrl.endsWith('.jpeg') ||
        proofUrl.endsWith('.png');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attachment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 10),
        isImage
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  proofUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            : Center(
              child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      Uri url = Uri.parse(proofUrl);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      } else {
                        throw 'Could not launch $proofUrl';
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error opening document: $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: transactionColor,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  icon: Icon(Icons.open_in_new, color: Colors.white),
                  label: Text(
                    "Open Document",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (transactionData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Transaction Details"),
          backgroundColor: Colors.grey,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: transactionColor,
        centerTitle: true,
        title: Text(
          transactionData!['transaction_type'] ?? 'Transaction Details',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: transactionColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Text(
                      transactionData!['converted_amount'] ?? "N/A",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      transactionData!['category_name'] ?? "N/A",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      transactionData!['timestamp']
                              ?.toDate()
                              .toString()
                              .substring(0, 16) ??
                          "N/A",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TransactionDetailItem(
                    label: "Transaction Type",
                    value: transactionData!['transaction_type'] ?? "N/A",
                  ),
                  TransactionDetailItem(
                    label: "Currency",
                    value: transactionData!['currency_type'] ?? "N/A",
                  ),
                  TransactionDetailItem(
                    label: "Description",
                    value: transactionData!['description'] ?? "N/A",
                  ),
                  if (transactionData!['transaction_type'] == 'Transfer') ...[
                    TransactionDetailItem(
                      label: "From Account",
                      value: transactionData!['from_account'] ?? "N/A",
                    ),
                    TransactionDetailItem(
                      label: "To Account",
                      value: transactionData!['to_account'] ?? "N/A",
                    ),
                  ],
                  SizedBox(height: 20),
                  if (transactionData!['transaction_proof'] != null)
                    _buildTransactionProof(
                        transactionData!['transaction_proof']),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          final url =
                              transactionData!['transaction_proof'] ?? "";
                          final fileName = url.split('/').last;
                          await FileDownloader.downloadFile(
                            url: url,
                            name: fileName,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('File downloaded successfully!')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Failed to download file: $e')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        backgroundColor: transactionColor,
                      ),
                      child: Text(
                        'Download Proof',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionDetailItem extends StatelessWidget {
  final String label;
  final String value;

  const TransactionDetailItem(
      {Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
