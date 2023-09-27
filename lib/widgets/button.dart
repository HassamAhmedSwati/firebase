import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPress;
  final loading;
  const Button({Key?key,required this.text,required this.onPress,this.loading=false}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 44,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blueAccent)
        ),
        child: Center(child: loading?CircularProgressIndicator(strokeWidth: 2,color: Colors.blueAccent,): Text(text,style: TextStyle(fontSize: 18,color: Colors.black),)),
      ),
    );
  }
}
