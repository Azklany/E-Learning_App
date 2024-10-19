import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_app/drawer/mydrawer.dart';
import 'package:e_learning_app/shared/data_from_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' show basename;
import '../shared/color.dart';
import '../shared/snackBar.dart';
import '../shared/user_image_from_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final credential = FirebaseAuth.instance.currentUser;
  File? imgPath;
  String? imgName;
  String? url;
  int random = Random().nextInt(9999999);
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> uploadImage(ImageSource imageSource) async {
    try {
      final pickedImg = await ImagePicker().pickImage(source: imageSource);
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          imgName = basename(pickedImg.path);
          imgName = "$random$imgName";
        });

        // Upload image to Firebase Storage
        final storageRef = FirebaseStorage.instance.ref(imgName);
        await storageRef.putFile(imgPath!);

        // Get image URL and update Firestore
        url = await storageRef.getDownloadURL();
        await users.doc(credential!.uid).update({"imgLink": url});
        showSnackBar(context, "Image uploaded successfully!");
      } else {
        showSnackBar(context, "No image selected");
      }
    } catch (e) {
      showSnackBar(context, "Error uploading image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Profile Page'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileImageSection(),
              const SizedBox(height: 24),
              _buildAccountInfoSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 70,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: imgPath != null ? FileImage(imgPath!) : null,
            child: imgPath == null ? const ImgUser() : null,
          ),
          IconButton(
            icon: const Icon(Icons.add_a_photo, color: Colors.blueGrey),
            onPressed: () async {
              await uploadImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfoSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Account Info",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoTile("Email", credential?.email ?? "Not available"),
            _buildInfoTile(
              "Created Date",
              credential?.metadata.creationTime != null
                  ? DateFormat('MMMM d, y').format(credential!.metadata.creationTime!)
                  : "Not available",
            ),
            _buildInfoTile(
              "Last Signed In",
              credential?.metadata.lastSignInTime != null
                  ? DateFormat('MMMM d, y').format(credential!.metadata.lastSignInTime!)
                  : "Not available",
            ),
            const SizedBox(height: 16),
            GetDataFromFirestore(documentId: credential!.uid),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (credential != null) {
                    await credential!.delete();
                    await users.doc(credential!.uid).delete();
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Delete User'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
    );
  }
}
