import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetDataFromFirestore extends StatefulWidget {
  final String documentId;

  const GetDataFromFirestore({super.key, required this.documentId});

  @override
  State<GetDataFromFirestore> createState() => _GetDataFromFirestoreState();
}

class _GetDataFromFirestoreState extends State<GetDataFromFirestore> {
  final credential = FirebaseAuth.instance.currentUser;
  final dialogUsernameController = TextEditingController();
  final dialogEmailController = TextEditingController();
  final dialogPasswordController = TextEditingController();
  final dialogAgeController = TextEditingController();
  final dialogTitleController = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  void _showEditBottomSheet(Map<String, dynamic> data) {
    // Populate controllers with current data, using default values if data is null
    dialogUsernameController.text = data['username'] ?? '';
    dialogEmailController.text = data['email'] ?? '';
    dialogPasswordController.text = data['password'] ?? '';
    dialogAgeController.text = (data['age'] ?? '').toString();
    dialogTitleController.text = data['title'] ?? '';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(dialogUsernameController, 'Username'),
              _buildTextField(dialogPasswordController, 'password'),
              _buildTextField(dialogAgeController, 'Age', isNumber: true),
              _buildTextField(dialogTitleController, 'Title'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _updateUserData();
                  });
                  Navigator.pop(context);
                },
                child: const Text('Confirm Changes'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  void _updateUserData() {
    users.doc(credential!.uid).update({
      'username': dialogUsernameController.text,
      'email': dialogEmailController.text,
      'password': dialogPasswordController.text,
      'age': int.tryParse(dialogAgeController.text) ?? 0,
      'title': dialogTitleController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
          snapshot.data!.data() as Map<String, dynamic>;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 9),
              _buildDataRow("Username", data['username'] ?? 'N/A'),
              _buildDataRow("Password" , data['password'] ?? 'N/A'),
             _buildDataRow("Age", "${data['age'] ?? 'N/A'} years old"),
              _buildDataRow("Title", data['title'] ?? 'N/A'),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () => _showEditBottomSheet(data),
                  child: const Text('Edit Data'),
                ),
              ),
            ],
          );
        }

        return const Text("Loading...");
      },
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }


}
