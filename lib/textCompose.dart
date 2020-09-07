import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



class Textcomposer extends StatefulWidget {
Textcomposer(this.sendMenssage);
  final Function({String text, File imgfile}) sendMenssage;

  @override
  _TextcomposerState createState() => _TextcomposerState();
}

class _TextcomposerState extends State<Textcomposer> {
  bool _isComposed =false;
  final TextEditingController _controller1= TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () async{
              final File imgfile=await ImagePicker.pickImage(source: ImageSource.gallery);
              if(imgfile ==null)return;
              widget.sendMenssage(imgfile:imgfile);


            },
          ),
          Expanded(child: TextField(
            controller: _controller1,
            decoration: InputDecoration.collapsed(
              hintText: "Enviar Mensagem"
          ),
          onChanged: (text){

              setState(() {
                _isComposed= text.isNotEmpty;
              });
          },
            onSubmitted: (text){
              widget.sendMenssage(text: text);
              reset();


            },
          )
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isComposed ? (){
              widget.sendMenssage(text:_controller1.text);
              reset();


            }:null,
          ),
        ],
      ),
    );
  }
  void reset(){
    _controller1.clear();
    setState(() {
      _isComposed=false;
    });
  }
}
