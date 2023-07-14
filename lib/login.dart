import 'package:flutter/material.dart';
import 'package:ui_final/registration.dart';
import 'package:ui_final/app_home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:video_player/video_player.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold( body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Icon(Icons.person,
                    size: 75,
                    color: Colors.blue,
                )),
            SizedBox(
              height: 40,
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),

                child: const Text(

                  'Sign in',
                  style: TextStyle(fontSize: 24,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text(
                'Forgot Password',
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () async {
                        try {

                        await FirebaseAuth.instance
                            .signInWithEmailAndPassword(email: nameController.text, password: passwordController.text);

                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('You are Logged in')));
                        Navigator.pushNamed(context, '/second');

                        } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No user Found with this Email')));
                        } else if (e.code == 'wrong-password') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Password did not match')));
                        }
                        };
                  },
                )),
            Row(
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'Sign up',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    //signup screen
                    Navigator.pushNamed(context, '/four');
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        )));

  }
}
