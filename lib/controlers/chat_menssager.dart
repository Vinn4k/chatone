import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
class chatMessage extends StatelessWidget {


  chatMessage(this.data, this.mine, );
  final Map<String, dynamic> data;
  final bool mine;



  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: <Widget>[
          !mine ?

         Padding(
           padding: EdgeInsets.only(right: 16),
           child:  CircleAvatar(
             backgroundImage: CachedNetworkImageProvider(data["senderPhotoUrl"]  ),

           ),
         ):Container(),
          Expanded(

              child:Column(
                crossAxisAlignment: mine ? CrossAxisAlignment.end:CrossAxisAlignment.start,
                children: <Widget>[
                  data['imgUrl'] !=null ?
                      Image.network(data["imgUrl"],width: 250,)
                  :

                  Text(data['senderName'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
             Padding(
               padding: EdgeInsets.all(2.0),
               child:   Container(



                child: Card(
                   shadowColor: Colors.red,
                   color: mine ?Color(0xffD0D1D6):Color(0xff5B5D66),
                   child:   Text(data["text"],
                     textAlign: mine ?TextAlign.center :TextAlign.start,
                     style: TextStyle(
                        fontStyle:FontStyle.italic ,
                         fontSize: 16,
                         fontWeight: FontWeight.w300,
                         color: Colors.white
                     ),
                   ),
                 ),
               )
             )
                ],
              )
          ),
          mine ?

          Padding(
            padding: EdgeInsets.only(left: 16),
            child:  CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(data["senderPhotoUrl"]  ),

            ),
          ):Container(),
        ],

      ),

    );
  }
}
