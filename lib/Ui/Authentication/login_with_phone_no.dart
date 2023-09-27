import 'package:firebase/Ui/Authentication/verify_code.dart';
import 'package:firebase/utility/utilities.dart';
import 'package:firebase/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPhoneNumber extends StatefulWidget {
  const LoginPhoneNumber({super.key});

  @override
  State<LoginPhoneNumber> createState() => _LoginPhoneNumberState();
}

class _LoginPhoneNumberState extends State<LoginPhoneNumber> {
  bool loading = false;
  final phoneNumberController=TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        leading: Icon(Icons.arrow_back_ios),
      ),
      body: Column(
        children: [
          SizedBox(height: 100,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '+92 3105552303',
              ),
            ),
          ),
          SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Button(text: 'Login',loading: loading, onPress: (){
              setState(() {
                loading=true;
              });
              auth.verifyPhoneNumber(
                phoneNumber: phoneNumberController.text,
                  verificationCompleted: (_){
                    setState(() {
                      loading=false;
                    });
                  },
                  verificationFailed: (e){
                    setState(() {
                      loading=false;
                    });
                    Utility().TostMessage(e.toString());
                  },
                  codeSent: (String verificationId, int? toeken){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyCode(verificationId: verificationId)));
                  setState(() {
                    loading=false;
                  });
                  },
                  codeAutoRetrievalTimeout: (e){
                    setState(() {
                      loading=false;
                    });
                    Utility().TostMessage(e.toString());
                  });
            }),
          )
        ],
      ),
    );
  }
}
