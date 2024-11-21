import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/physics.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:paywise/Services/BudgetModificationController.dart';
import 'package:paywise/Services/TransactionController.dart';
import 'package:paywise/screens/DetailTransactionPage.dart';
import 'package:paywise/widgets/custom_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:paywise/widgets/CurrencyConverter.dart';

class AddIncomePage extends StatefulWidget {
  @override
  _AddIncomePageState createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage>
    with SingleTickerProviderStateMixin {
  String? selectedCategory;
  String? selectedWallet;
  XFile? _imageFile;
  String? _documentPath;

  List<String> categories = [];
  List<String> wallets = [];

  final TextEditingController _editDescription = TextEditingController();

  String _fromCurrency = '';
  String _toCurrency = '';
  double _originalAmount = 0;
  String _convertedAmount = '';

  String? transactionProofUrl = "";

  double topContainerHeight = 420;
  double bottomContainerHeight = 380;
  double maxHeight = 650;
  double minHeight = 100;

  late AnimationController _controller;
  late Animation<double> _animation;

  // Method to handle conversion data and capture the conversion results
  void _handleConversionData(
      String fromCurrency, String toCurrency, double amount, String result) {
    setState(() {
      // Update the fields in the parent widget or page
      _fromCurrency = fromCurrency;
      _toCurrency = toCurrency;
      _originalAmount = amount;
      _convertedAmount = result;
    });
  }

  Future<String?> _uploadAttachment(dynamic file) async {
    if (file == null) return null;

    try {
      final storageRef = FirebaseStorage.instance.ref().child(
          'transaction_proofs/${file is String ? file.split('/').last : file.name}');
      final uploadTask =
          storageRef.putFile(File(file is String ? file : file.path));
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Failed to upload file: $e");
      return null;
    }
  }

  // Generate a random transaction ID
  String _generateTransactionID() {
    return Random().nextInt(999999999).toString();
  }

  String tId = "";

  // Method to handle storing transaction data when 'Continue' is clicked
  Future<void> _handleContinue() async {
    await CustomLoader.showLoaderForTask(
        context: context,
        task: () async {
          //Code
          try {
            // Retrieve email from SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            final email = prefs.getString('email') ?? '';

            // Check user type and transaction limit
            final authSnapshot = await FirebaseFirestore.instance
                .collection('authentication')
                .where('email', isEqualTo: email)
                .limit(1)
                .get();

            if (authSnapshot.docs.isNotEmpty) {
              final userType = authSnapshot.docs.first['user_type'];

              // Check if user type is "basic user" and limit transactions to 15 per day
              if (userType == "basic user") {
                final today = DateTime.now();
                final startOfDay = DateTime(today.year, today.month, today.day);

                // Count today's transactions for the user
                final transactionCount = await FirebaseFirestore.instance
                    .collection('transactions')
                    .where('email', isEqualTo: email)
                    .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
                    .get()
                    .then((snapshot) => snapshot.docs.length);

                if (transactionCount >= 15) {
                  // Show message and return if limit is reached
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "You have reached your transaction limit for today.")));
                  return;
                }
              }
            }

            // Proceed with the transaction if conditions are met
            if (selectedCategory != null &&
                _editDescription.text != "" &&
                (_imageFile != null || _documentPath != null)) {
              // Call the TransactionController to process the transaction
              TransactionController transactionController =
                  TransactionController();
              final result = await transactionController.processTransaction(
                amount: _originalAmount, // Directly pass as double
                accountName: selectedWallet ?? 'Unknown Account',
                transactionType: "Income",
              );

              if (result['success'] == true) {
                // Upload attachment and get the URL
                if (_imageFile == null && _documentPath != null) {
                  transactionProofUrl = await _uploadAttachment(_documentPath);
                } else if (_imageFile != null) {
                  transactionProofUrl = await _uploadAttachment(_imageFile);
                }

                tId = _generateTransactionID();

                // Prepare transaction data
                final transactionData = {
                  'account_name': selectedWallet,
                  'amount': _originalAmount,
                  'category_name': selectedCategory,
                  'converted_amount': _convertedAmount,
                  'currency_type': '$_fromCurrency-$_toCurrency',
                  'description': _editDescription.text,
                  'email': email,
                  'timestamp': Timestamp.now(),
                  'transaction_id': tId,
                  'transaction_proof': transactionProofUrl,
                  'transaction_type': 'Income',
                };

                // Save transaction data to Firestore
                await FirebaseFirestore.instance
                    .collection('transactions')
                    .add(transactionData);

                // Display a success message
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Transaction added successfully.")));

                // Navigate to the DetailTransactionPage with transaction data
                if (tId != "") {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailTransactionPage(transactionId: tId)));
                }
              } else {
                // Abort if transaction failed and display the error message from controller
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(result['message'] ?? "Transaction failed.")));
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Please fill out all required fields.")));
              return;
            }
          } catch (e) {
            print("Error storing transaction: $e");
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Failed to add transaction.")));
          }
        });
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchAccounts();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150), // Faster response time
    );
    _animation =
        Tween<double>(begin: bottomContainerHeight, end: bottomContainerHeight)
            .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _editDescription.dispose();
    super.dispose();
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      // Increase sensitivity to make scrolling faster
      bottomContainerHeight -=
          details.delta.dy * 1.7; // Increase scroll sensitivity
      if (bottomContainerHeight > maxHeight) bottomContainerHeight = maxHeight;
      if (bottomContainerHeight < minHeight) bottomContainerHeight = minHeight;
    });
  }

  void onVerticalDragEnd(DragEndDetails details) {
    // Adjust spring physics for a faster snap back and reaction
    final velocity = details.primaryVelocity ?? 0;
    final spring = SpringDescription(
      mass: 1,
      stiffness: 2000, // Increased stiffness for faster spring action
      damping: 7, // Further lowered damping for quicker response
    );

    final simulation = SpringSimulation(
        spring, bottomContainerHeight, bottomContainerHeight, velocity / 1000);

    _controller.animateWith(simulation);
  }

  Future<void> fetchCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';

    // Query Firestore for categories that match the user's email
    final snapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where('email', isEqualTo: email)
        .get();

    setState(() {
      categories = snapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  Future<void> fetchAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';

    final snapshot = await FirebaseFirestore.instance
        .collection('accounts')
        .where('email', isEqualTo: email)
        .get();

    setState(() {
      wallets =
          snapshot.docs.map((doc) => doc['account_name'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(0, 168, 107, 1),
        centerTitle: true,
        title: Text('Income', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            // onVerticalDragUpdate: (details) {
            //   setState(() {
            //     bottomContainerHeight -= details.delta.dy;
            //     if (bottomContainerHeight > maxHeight)
            //       bottomContainerHeight = maxHeight;
            //     if (bottomContainerHeight < minHeight)
            //       bottomContainerHeight = minHeight;
            //   });
            // },
            child: Container(
              color: Color.fromRGBO(0, 168, 107, 1),
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'How Much?',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.64),
                      fontSize: 18,
                    ),
                  ),
                  CurrencyConverter(
                    color: Color.fromRGBO(0, 168, 107, 1),
                    onConvert: _handleConversionData,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: GestureDetector(
              onVerticalDragUpdate: onVerticalDragUpdate,
              onVerticalDragEnd: onVerticalDragEnd,
              child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: bottomContainerHeight,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              Container(
                                width: 40,
                                height: 5,
                                margin: EdgeInsets.only(top: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              SizedBox(height: 16),
                              DropdownButtonFormField2<String>(
                                decoration: InputDecoration(
                                  focusColor: Color.fromRGBO(127, 61, 255, 1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(0, 255, 255, 255),
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                  ),
                                  iconSize: 30,
                                  iconEnabledColor: Color.fromRGBO(0, 0, 0, 1),
                                  iconDisabledColor:
                                      Color.fromARGB(255, 255, 255, 255),
                                ),
                                items: categories.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                                value: selectedCategory,
                                onChanged: (value) {
                                  setState(() {
                                    selectedCategory = value;
                                  });
                                },
                                hint: Text('Category'),
                              ),
                              SizedBox(height: 12),
                              DropdownButtonFormField2<String>(
                                decoration: InputDecoration(
                                  focusColor: Color.fromRGBO(127, 61, 255, 1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(0, 255, 255, 255),
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                  ),
                                  iconSize: 30,
                                  iconEnabledColor: Color.fromRGBO(0, 0, 0, 1),
                                  iconDisabledColor:
                                      Color.fromARGB(255, 255, 255, 255),
                                ),
                                items: wallets.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                                value: selectedWallet,
                                onChanged: (value) {
                                  setState(() {
                                    selectedWallet = value;
                                  });
                                },
                                hint: Text('Wallet'),
                              ),
                              SizedBox(height: 12),
                              TextFormField(
                                controller: _editDescription,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  labelStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              SizedBox(height: 16),
                              _imageFile == null && _documentPath == null
                                  ? GestureDetector(
                                      onTap: () => _pickAttachment(context),
                                      child: DottedBorder(
                                        color: Colors.grey,
                                        borderType: BorderType.RRect,
                                        radius: Radius.circular(12),
                                        dashPattern: [6, 3],
                                        strokeWidth: 1.5,
                                        child: Container(
                                          width: double.infinity,
                                          height: 70,
                                          color: const Color.fromARGB(
                                              0, 238, 238, 238),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.attach_file_rounded,
                                                  color: Colors.grey),
                                              SizedBox(width: 8),
                                              Text('Add attachment',
                                                  style: TextStyle(
                                                      color: Colors.grey)),
                                            ],
                                          ),
                                        ),
                                      ))
                                  : _buildAttachmentPreview(),
                              SizedBox(height: 16),
                              SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _handleContinue();
                                  },
                                  child: Text('Continue',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromRGBO(127, 61, 255, 1),
                                    minimumSize: Size(double.infinity, 48),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAttachment(BuildContext context) async {
    await WoltModalSheet.show(
      context: context,
      pageListBuilder: (BuildContext context) => [
        WoltModalSheetPage(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(238, 229, 255, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt_rounded,
                          color: Color.fromRGBO(127, 61, 255, 1),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          final pickedFile = await ImagePicker()
                              .pickImage(source: ImageSource.camera);
                          setState(() {
                            _imageFile = pickedFile;
                          });
                        },
                      ),
                      Text(
                        'Camera',
                        style: TextStyle(
                            color: Color.fromRGBO(127, 61, 255, 1),
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(238, 229, 255, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.image_rounded,
                          color: Color.fromRGBO(127, 61, 255, 1),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          final pickedFile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          setState(() {
                            _imageFile = pickedFile;
                          });
                        },
                      ),
                      Text(
                        'Images',
                        style: TextStyle(
                            color: Color.fromRGBO(127, 61, 255, 1),
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(238, 229, 255, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.insert_drive_file,
                            color: Color.fromRGBO(127, 61, 255, 1)),
                        onPressed: () async {
                          Navigator.pop(context);
                          final result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf', 'docx']);
                          if (result != null &&
                              result.files.single.path != null) {
                            setState(() {
                              _documentPath = result.files.single.path;
                            });
                          }
                        },
                      ),
                      Text(
                        'Documents',
                        style: TextStyle(
                            color: Color.fromRGBO(127, 61, 255, 1),
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentPreview() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Preview
            _imageFile != null
                ? Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: FileImage(File(_imageFile!.path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : SizedBox.shrink(),

            // Document Preview
            _documentPath != null
                ? Container(
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(238, 229, 255, 1),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Document: ${_documentPath!.split('/').last}',
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
        // Close button to remove attachments
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            icon:
                Icon(Icons.close, color: const Color.fromRGBO(127, 61, 255, 1)),
            onPressed: () {
              setState(() {
                _imageFile = null;
                _documentPath = null;
              });
            },
          ),
        ),
      ],
    );
  }
}
