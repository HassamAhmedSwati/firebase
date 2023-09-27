import 'package:firebase/Ui/posts/posts_screen.dart';
import 'package:firebase/utility/utilities.dart';
import 'package:firebase/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyCode extends StatefulWidget {
  String verificationId;
  VerifyCode({super.key, required this.verificationId});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  bool loading = false;
  final verificationController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify'),
        leading: Icon(Icons.arrow_back_ios),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PinCodeTextField(
              controller: verificationController,
              appContext: context,
              length: 6,
              keyboardType: TextInputType.number,
              obscuringCharacter: '*',
              obscureText: true,
              showCursor: false,
              pinTheme: PinTheme(
                  inactiveColor: Colors.grey,
                  activeColor: Colors.grey,
                  selectedColor: Colors.grey),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Button(
              text: 'Verify',
              onPress: () async {
                setState(() {
                  loading = true;
                });
                final credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: verificationController.text.toString());
                try {
                  await auth.signInWithCredential(credential);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PostScreen()));
                } catch (e) {
                  setState(() {
                    loading = false;
                  });
                  Utility().TostMessage(e.toString());
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
