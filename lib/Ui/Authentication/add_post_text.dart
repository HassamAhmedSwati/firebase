import 'package:firebase/utility/utilities.dart';
import 'package:firebase/widgets/button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final postController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
        leading: Icon(Icons.arrow_back_ios),
      ),
      body: Column(
        children: [
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              maxLines: 4,
              controller: postController,
              decoration: InputDecoration(
                hintText: 'What is your mind',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Button(text: 'Add',
                loading: loading,
                onPress: (){
              setState(() {
                loading=true;
              });
              String id = DateTime.now().microsecondsSinceEpoch.toString();
              databaseRef.child(id).set({
                'title':postController.text.toString(),
                'id':id
              }).then((value){
                setState(() {
                  loading=false;
                });
                Utility().TostMessage('Post add');
              }).onError((error, stackTrace){
                setState(() {
                  loading=false;
                });
                Utility().TostMessage(error.toString());
              });
            }),
          )
        ],
      ),
    );
  }
}
