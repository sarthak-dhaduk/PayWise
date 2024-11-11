// TransferPage.dart


import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/physics.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:paywise/Services/AccountTransferController.dart';
import 'package:paywise/screens/DetailTransactionPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class TransferPage extends StatefulWidget {
  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage>
    with SingleTickerProviderStateMixin {
  String? selectedAccountFrom;
  String? selectedAccountTo;
  XFile? _imageFile;
  String? _documentPath;

  List<String> wallets = [];

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _editDescription = TextEditingController();

  double topContainerHeight = 400;
  double bottomContainerHeight = 400;
  double maxHeight = 650;
  double minHeight = 100;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    fetchAccounts();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150), // Faster response time
    );
    _animation =
        Tween<double>(begin: bottomContainerHeight, end: bottomContainerHeight)
            .animate(_controller);
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

  Future<void> _handleContinue() async {
    try {
      // Retrieve email from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email') ?? '';

      // Check if all required fields are filled
      if (selectedAccountFrom == null ||
          selectedAccountTo == null ||
          _amountController.text.isEmpty ||
          _editDescription.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please fill out all required fields.")));
        return;
      }

      // Parse amount
      final amount = double.tryParse(_amountController.text) ?? 0.0;

      // Initialize AccountTransferController
      final transferController = AccountTransferController();

      // Attempt to transfer funds using the controller
      final transferResult = await transferController.transferAmount(
        fromAccount: selectedAccountFrom!,
        toAccount: selectedAccountTo!,
        amount: amount,
      );

      // Check if the transfer was successful
      if (!transferResult['success']) {
        // Display the message from the controller if transfer failed
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(transferResult['message'])));
        return;
      }

      // Generate a unique transaction ID
      String transactionId = _generateTransactionID();

      // Upload proof if available
      String? transactionProofUrl;
      if (_imageFile != null) {
        transactionProofUrl = await _uploadAttachment(_imageFile);
      } else if (_documentPath != null) {
        transactionProofUrl = await _uploadAttachment(_documentPath);
      }

      // Prepare transaction data
      final transactionData = {
        'email': email,
        'from_account': selectedAccountFrom,
        'to_account': selectedAccountTo,
        'amount': amount,
        'description': _editDescription.text,
        'timestamp': Timestamp.now(),
        'transaction_id': transactionId,
        'transaction_type': 'Transfer',
        'transaction_proof': transactionProofUrl,
      };

      // Save transaction data to Firestore
      await FirebaseFirestore.instance
          .collection('transactions')
          .add(transactionData);

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => DetailTransactionPage()));

      // Display a success message
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Transaction added successfully.")));
    } catch (e) {
      print("Error storing transaction: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to add transaction.")));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _amountController.dispose();
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
        backgroundColor: Color.fromRGBO(0, 119, 255, 1),
        centerTitle: true,
        title: Text('Transfer', style: TextStyle(color: Colors.white)),
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
            child: Container(
              color: Color.fromRGBO(0, 119, 255, 1),
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
                  TextField(
                    controller: _amountController,
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Container(
                        margin: EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.currency_rupee_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
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
                              Stack(
                                children: [
                                  Row(
                                    children: [
                                      // TextField for Amount Input
                                      Expanded(
                                        flex: 2,
                                        child: DropdownButtonFormField2<String>(
                                          decoration: InputDecoration(
                                            labelText: "From",
                                            labelStyle: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 72, 72, 72),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 15),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16)),
                                              borderSide: BorderSide(
                                                color: const Color.fromARGB(
                                                    255, 0, 0, 0),
                                                width:
                                                    0.5, // Reduced thickness for enabled border
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16)),
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    127, 61, 255, 1),
                                                width:
                                                    0.5, // Reduced thickness for focused border
                                              ),
                                            ),
                                          ),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                          iconStyleData: const IconStyleData(
                                            icon: Icon(Icons
                                                .keyboard_arrow_down_rounded),
                                            iconSize: 0,
                                          ),
                                          dropdownStyleData:
                                              const DropdownStyleData(
                                            width: 200,
                                            maxHeight: 200,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16)),
                                            ),
                                          ),
                                          items: wallets.map((String item) {
                                            return DropdownMenuItem<String>(
                                              alignment: AlignmentDirectional
                                                  .centerStart,
                                              value: item,
                                              child: Text(item),
                                            );
                                          }).toList(),
                                          value: selectedAccountFrom,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedAccountFrom = value;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      // Dropdown for Currency Selection
                                      Expanded(
                                        flex: 2,
                                        child: DropdownButtonFormField2<String>(
                                          decoration: InputDecoration(
                                            labelText: "To",
                                            labelStyle: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 72, 72, 72),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 15),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16)),
                                              borderSide: BorderSide(
                                                color: const Color.fromARGB(
                                                    255, 0, 0, 0),
                                                width:
                                                    0.5, // Reduced thickness for enabled border
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16)),
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    127, 61, 255, 1),
                                                width:
                                                    0.5, // Reduced thickness for focused border
                                              ),
                                            ),
                                          ),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                          iconStyleData: const IconStyleData(
                                            icon: Icon(Icons
                                                .keyboard_arrow_down_rounded),
                                            iconSize:
                                                0, // Reduced the icon size
                                            iconEnabledColor:
                                                Color.fromRGBO(0, 0, 0, 1),
                                          ),
                                          dropdownStyleData:
                                              const DropdownStyleData(
                                            width: 200,
                                            maxHeight: 200,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16)),
                                            ),
                                          ),
                                          items: wallets.map((String item) {
                                            return DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(item),
                                            );
                                          }).toList(),
                                          value: selectedAccountTo,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedAccountTo = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top:
                                        10, // Adjust based on the icon position
                                    left:
                                        MediaQuery.of(context).size.width / 2 -
                                            40,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                49, 0, 0, 0),
                                            blurRadius: 10,
                                            offset: Offset(0, 0),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SvgPicture.asset(
                                            'assets/icons/Transaction.svg'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
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
                                    borderSide: BorderSide(width: 0.1),
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
