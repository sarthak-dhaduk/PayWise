import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paywise/screens/ProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class ProfileUpdatePage extends StatefulWidget {
  @override
  _ProfileUpdatePageState createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  File? _imageFile;
  String? _name;
  String? _email;
  String? _password;
  String? _profileImgUrl;

  final picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');

    if (email != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('authentication')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        setState(() {
          _name = userDoc.get('name') ?? '';
          _email = email;
          _password = userDoc.get('password') ?? '';
          _profileImgUrl = userDoc.data().containsKey('profile_img')
              ? userDoc.get('profile_img')
              : 'https://raw.githubusercontent.com/sarthak-dhaduk/PayWise/refs/heads/master/assets/images/av1.png';
        });
      } else {
        print('User document does not exist');
      }
    }
  }

  Future<void> _updateUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');

    if (email != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('authentication')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;

        // Build a map for fields to update based on changes
        Map<String, dynamic> updates = {
          if (_name != null && _name!.isNotEmpty) 'name': _name,
          if (_profileImgUrl != null && _profileImgUrl!.isNotEmpty)
            'profile_img': _profileImgUrl,
          if (_password != null && _password!.isNotEmpty) 'password': _password,
        };

        await FirebaseFirestore.instance
            .collection('authentication')
            .doc(docId)
            .update(updates);
      } else {
        print('User document not found');
      }
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      try {
        String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.png';
        await storage.ref(fileName).putFile(_imageFile!);
        String downloadURL = await storage.ref(fileName).getDownloadURL();

        setState(() {
          _profileImgUrl = downloadURL;
        });

        await _updateUserDetails(); // Save new image URL to Firestore
        print("Image uploaded. Download URL: $downloadURL");
      } catch (e) {
        print("Error uploading image: $e");
      }
    } else {
      print("No image selected for upload.");
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: screenHeight * 0.3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange[100]!, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 0),
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    centerTitle: true,
                    title: Text(
                      'Update Profile',
                      style: TextStyle(
                          color: Colors.black, fontSize: screenHeight * 0.024),
                    ),
                  ),
                ),
                Container(
                  height: screenHeight * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _imageFile == null
                          ? GestureDetector(
                              onTap: () => _pickAttachment(context),
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(_profileImgUrl ??
                                        'https://raw.githubusercontent.com/sarthak-dhaduk/PayWise/refs/heads/master/assets/images/av1.png'),
                                    backgroundColor: Colors.white,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.grey[200],
                                      child: Icon(Icons.edit,
                                          color: Colors.black, size: 18),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : _buildAttachmentPreview(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onChanged: (value) {
                          _name = value;
                        },
                        controller: TextEditingController(text: _name),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextField(
                        readOnly: true, // Make email read-only
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        controller: TextEditingController(text: _email),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Text(
                        "Change Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextField(
                        obscureText: !_isOldPasswordVisible,
                        decoration: InputDecoration(
                          labelText: "Old Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isOldPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isOldPasswordVisible = !_isOldPasswordVisible;
                              });
                            },
                          ),
                        ),
                        controller: TextEditingController(text: _password),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // New Password Field
                      TextField(
                        obscureText: !_isNewPasswordVisible,
                        decoration: InputDecoration(
                          labelText: "New Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isNewPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isNewPasswordVisible = !_isNewPasswordVisible;
                              });
                            },
                          ),
                        ),
                        onChanged: (value) {
                          _password = value;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      ElevatedButton(
                        onPressed: () async {
                          if (_imageFile != null) {
                            await _uploadImage(); // Upload image only if a new one is selected
                          }
                          await _updateUserDetails();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(127, 61, 255, 1),
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          "Continue",
                          style: TextStyle(
                              fontSize: screenHeight * 0.025,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                          final pickedFile = await picker.pickImage(
                            source: ImageSource.camera,
                            imageQuality: 80,
                          );
                          if (pickedFile != null) {
                            setState(() {
                              _imageFile = File(pickedFile.path);
                            });
                            await _uploadImage();
                          }
                        },
                      ),
                      Text('Camera'),
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
                          Icons.image,
                          color: Color.fromRGBO(127, 61, 255, 1),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          final pickedFile = await picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 80,
                          );
                          if (pickedFile != null) {
                            setState(() {
                              _imageFile = File(pickedFile.path);
                            });
                            await _uploadImage();
                          }
                        },
                      ),
                      Text('Gallery'),
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
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                        image: FileImage(File(_imageFile!.path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                        image: NetworkImage(
                          _profileImgUrl ??
                              'https://raw.githubusercontent.com/sarthak-dhaduk/PayWise/refs/heads/master/assets/images/av1.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ],
        ),
        // Close button to remove attachments
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            icon: Icon(
              Icons.close,
              color: const Color.fromARGB(255, 255, 61, 61),
            ),
            onPressed: () {
              setState(() {
                _imageFile = null;
              });
            },
          ),
        ),
      ],
    );
  }
}
