import 'package:flutter/material.dart';
import 'package:ui_final/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:email_auth/email_auth.dart';



class Registration extends StatefulWidget {
  const Registration({super.key});
  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           const  Icon(
              Icons.person,
              size: 75,
              color: Colors.blue,
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Create User',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey,
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
          const SizedBox(
            height: 40,
          ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Sign up'),
                  onPressed: () async
                  {
                    // print(nameController.text);
                    // print(passwordController.text);
                    // final userCredential = FirebaseAuth.instance.createUserWithEmailAndPassword(email: nameController.text, password: passwordController.text);

                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                          email: nameController.text,
                          password: passwordController.text);
                      await FirebaseAuth.instance.currentUser!.updateEmail(
                          nameController.text);

                      // await FirestoreServices.saveUser( nameController.text, userCredential.user!.uid);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                          SnackBar(content: Text('Registration Successful')));

                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(
                                'Password Provided is too weak')));
                      } else if (e.code == 'email-already-in-use') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(
                                'Email Provided already Exists')));
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }


                    var acs = ActionCodeSettings(
                      // URL you want to redirect back to. The domain (www.example.com) for this
                      // URL must be whitelisted in the Firebase Console.
                        url: '/',
                        // This must be true
                        handleCodeInApp: true,
                        // iOSBundleId: 'com.example.ios',
                        androidPackageName: 'com.example.ui_final',
                        // installIfNotAvailable
                        androidInstallApp: true,
                        // minimumVersion
                        androidMinimumVersion: '7');


                    var emailAuth = nameController.text;
                    FirebaseAuth.instance.sendSignInLinkToEmail(
                        email: emailAuth, actionCodeSettings: acs)
                        .catchError((onError) =>
                        print('Error sending email verification $onError'))
                        .then((value) =>
                        print('Successfully sent email verification'));
                    Navigator.pushReplacementNamed(context, '/five');
                  },

                ),
            ),
          ],
        ),
      ),
    );
  }
}
