
import 'dart:io';
import 'package:chatone/controlers/chat_menssager.dart';
import 'package:chatone/textCompose.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';





class chatPage extends StatefulWidget {
  @override
  _chatPageState createState() => _chatPageState();

}

class _chatPageState extends State<chatPage> {

  final GoogleSignIn googleSignIn=GoogleSignIn();
  FirebaseUser _correntUser;
   bool isloading=false;
  final GlobalKey<ScaffoldState> _scarfoldKey=GlobalKey<ScaffoldState>();


  @override
  void initState() {
super.initState();

FirebaseAuth.instance.onAuthStateChanged.listen((user) {
 setState(() {
   _correntUser=user;
 });

});
  }

  Future<FirebaseUser> _getuser() async{
    if(_correntUser !=null)return _correntUser;
    try{

      final GoogleSignInAccount googleSignInAccount= await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication=await googleSignInAccount.authentication;
      final AuthCredential credential=GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,);
      final AuthResult authResult=await FirebaseAuth.instance.signInWithCredential(credential);
      final FirebaseUser user= authResult.user;
      return user;
    }catch (error){
      return null;

    }
  }


void Controls (String,dynamic)async{
    Firestore.instance.collection("user").document("$_correntUser");

}

  void _sendMessage({String text, File imgfile}) async{
    final FirebaseUser user = await _getuser();
    if(user ==null){
      _scarfoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Não foi possivel fazerr login"),
        backgroundColor: Colors.red,)
      );


    }
    Map<String, dynamic>data={
      "uid":user.uid,
      "senderName": user.displayName,
      "senderPhotoUrl":user.photoUrl,
      "time":Timestamp.now(),

    };


   if(imgfile !=null){
     StorageUploadTask task=FirebaseStorage.instance.ref().child("Img").child(data["uid"]).child(
       DateTime.now().microsecondsSinceEpoch.toString()
     ).putFile(imgfile);
     setState(() {
       isloading=true;
     });

     StorageTaskSnapshot taskSnapshot= await task.onComplete;
     String imgUrl= await taskSnapshot.ref.getDownloadURL();
     data['imgUrl']=imgUrl;


     setState(() {
       isloading=false;
     });
   }

if(text !=null) data['text']= text;
    Firestore.instance.collection("message").add(data);



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scarfoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xff5B5D66),
        title: Text(
          _correntUser !=null ? "Ola, ${_correntUser.displayName}" : "Chat App"
        ),

        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          _correntUser !=null? IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: (){
              FirebaseAuth.instance.signOut();
              googleSignIn.signOut();
              _scarfoldKey.currentState.showSnackBar(
                  SnackBar(content: Text("Voceê Saiu com Sucesso "),
                  )
                  );
            },
          ):Container(),
        ],
      ),

        body: Container(
          color: Color(0xffd3d3d3),
    child:Column(

            children: <Widget>[

              Expanded(

                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection("message").orderBy("time").snapshots(),
                  builder: (context, snapshot){
                    switch(snapshot.connectionState){
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                       List<DocumentSnapshot> documents=
                           snapshot.data.documents.reversed.toList();
                       return ListView.builder(
                         itemCount: documents.length,
                           reverse: true,
                           itemBuilder: (context, index){
                          return chatMessage(
                              documents[index].data,
                              documents[index].data["uid"]==_correntUser ?.uid
                          );
                           });

                    }
                  },
                ),
              ),

              isloading? LinearProgressIndicator() : Container(),
              Textcomposer( _sendMessage ),
            ],

        ),
    )
    );
  }
}
