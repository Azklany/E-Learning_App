import 'package:e_learning_app/firebase_options.dart';
import 'package:e_learning_app/our_navigation_bar.dart';
import 'package:e_learning_app/providers/google_signin.dart';
import 'package:e_learning_app/shared/snackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';

ColorScheme myColorScheme =
ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 66, 67, 136));

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return GoogleSignInProvider();
        }),
      ],
      child: MaterialApp(
        theme: ThemeData().copyWith(
            brightness: Brightness.light,
            colorScheme: myColorScheme,
            appBarTheme: const AppBarTheme().copyWith(
                backgroundColor: myColorScheme.primary.withOpacity(.8),
                foregroundColor: Colors.white),
            iconTheme:
            const IconThemeData().copyWith(color: myColorScheme.onPrimary),
            scaffoldBackgroundColor: myColorScheme.primaryFixed),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ));
            } else if (snapshot.hasError) {
              return showSnackBar(context, "Something went wrong");
            } else if (snapshot.hasData) {
              return const OurNavigationbar();
            } else {
              return const Login();
            }
          },
        ),
      ),
    );
  }
}