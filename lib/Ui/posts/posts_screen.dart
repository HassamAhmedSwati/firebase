import 'package:firebase/Ui/Authentication/add_post_text.dart';
import 'package:firebase/Ui/Authentication/login.dart';
import 'package:firebase/utility/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchFilterController = TextEditingController();
  final editController = TextEditingController();

  Future<void> showMyDialog(String title, String id)async{
    editController.text=title;
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('Update'),
        content: Container(
          child: TextField(
            controller: editController,
            decoration: InputDecoration(
              hintText: 'Edit',
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          },
              child: Text('Cancel')),
          TextButton(onPressed: (){
            Navigator.pop(context);
            ref.child(id).update({
              'title' : editController.text.toLowerCase()
            }).then((value){
              Utility().TostMessage('Post Updated');
            }).onError((error, stackTrace){
              Utility().TostMessage(error.toString());
            });
          },
              child: Text('Update')),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios),
        title: Text('Posts Screen'),

        actions: [
          IconButton(onPressed: (){
            auth.signOut().then((value){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
            }).onError((error, stackTrace){
              Utility().TostMessage(error.toString());
            });
          }, icon: Icon(Icons.login_outlined)),
          SizedBox(width: 10,),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 10,),
            TextFormField(
              controller: searchFilterController,
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (String value){
                setState(() {

                });
              },
            ),
            Expanded(
              child: FirebaseAnimatedList(
                  query: ref,
                  itemBuilder: (context,snapshot,animation,index){
                    final title = snapshot.child('title').value.toString();
                    if(searchFilterController.text.isEmpty)
                    {
                      return ListTile(
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(snapshot.child('id').value.toString()),
                        trailing: PopupMenuButton(
                          icon: Icon(Icons.more_vert_outlined),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value:1,
                                child: ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('Edit'),
                                  onTap: (){
                                    Navigator.pop(context);
                                    showMyDialog(title,snapshot.child('id').value.toString());
                                  },
                                ),
                            ),
                            PopupMenuItem(
                              value:1,
                              child: ListTile(
                                leading: Icon(Icons.delete),
                                title: Text('delete'),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    else if(title.toLowerCase().contains(searchFilterController.text.toLowerCase().toString()))
                    {
                      return ListTile(
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(snapshot.child('id').value.toString()),
                      );
                    }
                    else
                      {
                        return Container();
                      }
                  }),
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPostScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}



//
// Expanded(child: StreamBuilder(
// stream: ref.onValue,
// builder: (context,AsyncSnapshot<DatabaseEvent> snapshot){
//
// if(!snapshot.hasData)
// {
// return CircularProgressIndicator();
// }
// else
// {
// Map<dynamic,dynamic> map = snapshot.data!.snapshot.value as dynamic;
// List<dynamic> list =[];
// list.clear();
// list = map.values.toList();
// return ListView.builder(
// itemCount: snapshot.data!.snapshot.children.length,
// itemBuilder: (context,index){
// return ListTile(
// title: Text(list[index]['title']),
// subtitle: Text(list[index]['id']),
// );
// },
//
// );
// }
// }),
// ),