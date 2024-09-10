import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:paywise/screens/HomeScreen.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:paywise/widgets/CurrencyConverter.dart';

class AddExpensePage extends StatefulWidget {
  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  String? selectedCategory;
  String? selectedWallet;
  XFile? _imageFile;
  String? _documentPath;

  final List<String> categories = ['Subscription', 'Food', 'Transport'];
  final List<String> wallets = ['PayPal', 'Credit Card', 'Cash'];

  double topContainerHeight = 420;
  double bottomContainerHeight = 380;
  double maxHeight = 650;
  double minHeight = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(253, 60, 74, 1),
        centerTitle: true,
        title: Text('Expense', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
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
              color: Color.fromRGBO(253, 60, 74, 1),
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
                  CurrencyConverter(color: Color.fromRGBO(253, 60, 74, 1)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  bottomContainerHeight -= details.delta.dy;
                  if (bottomContainerHeight > maxHeight)
                    bottomContainerHeight = maxHeight;
                  if (bottomContainerHeight < minHeight)
                    bottomContainerHeight = minHeight;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: bottomContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
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
                            fillColor: const Color.fromARGB(0, 255, 255, 255),
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
                            fillColor: const Color.fromARGB(0, 255, 255, 255),
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
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 255, 255, 255),
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
                                    color:
                                        const Color.fromARGB(0, 238, 238, 238),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.attach_file_rounded,
                                            color: Colors.grey),
                                        SizedBox(width: 8),
                                        Text('Add attachment',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ))
                            : _buildAttachmentPreview(),
                        SizedBox(height: 16),
                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text('Continue',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(127, 61, 255, 1),
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
              ),
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
