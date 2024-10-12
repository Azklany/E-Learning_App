// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_app/login.dart';
import 'package:e_learning_app/shared/color.dart';
import 'package:e_learning_app/shared/constant.dart';
import 'package:e_learning_app/shared/snackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show basename;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isVisible = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ageController = TextEditingController();
  final userNameController = TextEditingController();
  final titleController = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool isPassword8char = false;
  bool isPasswordHas1number = false;
  bool isPasswordHasUppercase = false;
  bool isPasswordHasLowercase = false;
  bool isPasswordHasSpecialCharacter = false;
  File? imgPath;
  String? imgName;
  int random = Random().nextInt(9999999);
  String? url;

  register() async {
    try {
      setState(() {
        isLoading = true;
      });
      final credintial =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Upload image to firebase storage
      final storageRef = FirebaseStorage.instance.ref(imgName);
      await storageRef.putFile(imgPath!);
      url = await storageRef.getDownloadURL();
      if (!mounted) return;
      //add firestore
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      users
          .doc(credintial.user!.uid)
          .set({
            'imgLink': url,
            'username': userNameController.text,
            'age': ageController.text,
            'title': titleController.text,
            'email': emailController.text,
            'password': passwordController.text,
          })
          .then(
            (value) => showSnackBar(context, "User Added"),
          )
          .catchError(
              (error) => showSnackBar(context, "Failed to add user: $error"));
      //end firestore
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, 'The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'The account already exits for this email');
      } else {
        showSnackBar(context, 'Error, please try again later!');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  onPasswordChanged(String password) {
    isPassword8char = false;
    isPasswordHas1number = false;
    isPasswordHasUppercase = false;
    isPasswordHasLowercase = false;
    isPasswordHasSpecialCharacter = false;
    setState(() {
      if (password.contains(RegExp(r'.{8,}'))) {
        isPassword8char = true;
      }
      if (password.contains(RegExp(r'[0-9]'))) {
        isPasswordHas1number = true;
      }
      if (password.contains(RegExp(r'[A-Z]'))) {
        isPasswordHasUppercase = true;
      }
      if (password.contains(RegExp(r'[a-z]'))) {
        isPasswordHasLowercase = true;
      }
      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        isPasswordHasSpecialCharacter = true;
      }
    });
  }

  uploadImage(ImageSource imageSource) async {
    final pickedImg = await ImagePicker().pickImage(source: imageSource);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          imgName = basename(pickedImg.path);
          imgName = "$random$imgName";
        });
      } else {
        showSnackBar(context, "NO img selected");
      }
    } catch (e) {
      showSnackBar(context, "Error => $e");
    }
  }

  showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(22),
          height: 175,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await uploadImage(ImageSource.camera);
                  if (!mounted) return;
                  Navigator.pop(context);
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.camera,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      'From Camera',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              GestureDetector(
                onTap: () async {
                  await uploadImage(ImageSource.gallery);
                  if (!mounted) return;
                  Navigator.pop(context);
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.photo_outlined,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      'From Gallery',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    ageController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Register',
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(33),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 78, 91, 110),
                  ),
                  child: Stack(
                    children: [
                      imgPath == null
                          ? const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 64,
                              backgroundImage:
                                  AssetImage('assets/images/avatar.png'),
                            )
                          : ClipOval(
                              child: Image.file(
                                imgPath!,
                                width: 145,
                                height: 145,
                                fit: BoxFit.cover,
                              ),
                            ),
                      Positioned(
                        bottom: -12,
                        left: 92,
                        child: IconButton(
                          onPressed: () {
                            showBottomSheet();
                          },
                          icon: const Icon(Icons.add_a_photo),
                          color: const Color.fromARGB(255, 94, 115, 128),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 33,
                ),
                // userName
                TextFormField(
                  controller: userNameController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: textFieldDecoration.copyWith(
                    hintText: 'Enter your username:',
                    suffixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(
                  height: 33,
                ),
                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  decoration: textFieldDecoration.copyWith(
                    hintText: 'Enter your age:',
                    suffixIcon: const Icon(Icons.pest_control_rodent),
                  ),
                ),
                const SizedBox(
                  height: 33,
                ),
                TextFormField(
                  controller: titleController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: textFieldDecoration.copyWith(
                    hintText: 'Enter your title:',
                    suffixIcon: const Icon(Icons.person_2_outlined),
                  ),
                ),
                const SizedBox(
                  height: 33,
                ),
                //Email
                TextFormField(
                  validator: (value) {
                    return !value!.contains(
                      RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"),
                    )
                        ? "Enter a valid email"
                        : null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  decoration: textFieldDecoration.copyWith(
                    hintText: 'Enter your email:',
                    suffixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(
                  height: 33,
                ),
                //password
                TextFormField(
                  onChanged: (value) {
                    onPasswordChanged(value);
                  },
                  validator: (value) {
                    return value!.length < 8
                        ? "Enter at least 8 characters"
                        : null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: isVisible ? true : false,
                  decoration: textFieldDecoration.copyWith(
                    hintText: 'Enter your password:',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: isVisible
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        border: isPassword8char
                            ? Border.all(color: Colors.green)
                            : Border.all(color: Colors.grey.shade400),
                        shape: BoxShape.circle,
                        color: isPassword8char ? Colors.green : Colors.white,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 11,
                    ),
                    const Text('At least 8 characters'),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        border: isPasswordHas1number
                            ? Border.all(color: Colors.green)
                            : Border.all(color: Colors.grey.shade400),
                        shape: BoxShape.circle,
                        color:
                            isPasswordHas1number ? Colors.green : Colors.white,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 11,
                    ),
                    const Text('At least 1 number'),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        border: isPasswordHasUppercase
                            ? Border.all(color: Colors.green)
                            : Border.all(color: Colors.grey.shade400),
                        shape: BoxShape.circle,
                        color: isPasswordHasUppercase
                            ? Colors.green
                            : Colors.white,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 11,
                    ),
                    const Text('Has Uppercase'),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        border: isPasswordHasLowercase
                            ? Border.all(color: Colors.green)
                            : Border.all(color: Colors.grey.shade400),
                        shape: BoxShape.circle,
                        color: isPasswordHasLowercase
                            ? Colors.green
                            : Colors.white,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 11,
                    ),
                    const Text('Has Lowercase'),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        border: isPasswordHasSpecialCharacter
                            ? Border.all(color: Colors.green)
                            : Border.all(color: Colors.grey.shade400),
                        shape: BoxShape.circle,
                        color: isPasswordHasSpecialCharacter
                            ? Colors.green
                            : Colors.white,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 11,
                    ),
                    const Text('Has special character '),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 33,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        imgName != null &&
                        imgPath != null) {
                      await register();
                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                      );
                    } else {
                      showSnackBar(context, 'Error');
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      btnGreen,
                    ),
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.all(14),
                    ),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                ),
                const SizedBox(
                  height: 33,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
