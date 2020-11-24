import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:health_plus/module/post.dart';
import 'package:health_plus/screens/login_screen.dart';

import '../../app.dart';

String image_attached, description, post_time, post_date, likes;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var doctorID = admin_id;

  List<Post> data = [];

  void getPosts() async {

    var result = await http_get({
      "action": "get_posts",
      "admin_id": doctorID
    });
    if(result.ok)
    {
      setState(() {
        data.clear();
        var jsonItems = result.data as List<dynamic>;
        jsonItems.forEach((post){
          this.data.add(Post(
              post['id'] as String,
              post['doctor_id'] as String,
              image_attached = post['image_attached'] as String,
              description    = post['description'] as String,
              post_time      = post['post_time'] as String,
              post_date      = post['name'] as String,
              likes          = post['id'] as String,

          ));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasImage;
    String image;
    setState(() {
      getPosts();
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, i){
           image = data[i].image_attached;
           if(image == ""){
             hasImage = false;
           }else{
             hasImage = true;
           }
           return Card(
             elevation: 1.0,
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 SizedBox(width: 10.0),
                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       SizedBox(height: 5.0),
                       hasImage
                           ? Column(
                         children: [
                           GestureDetector(
                             onTap: () {
                               showDialog(
                                   context: context,
                                   barrierDismissible: true,
                                   builder: (BuildContext context) {
                                     return AlertDialog(
                                       backgroundColor: Colors.black45,
                                       content: SingleChildScrollView(
                                         child: Column(
                                           children: [
                                             Card(
                                               child: Image.network(
                                                   "http://192.168.43.122/healthplus/${data[i].image_attached}"),
                                             ),
                                             Text(
                                               data[i].description,
                                               style: TextStyle(
                                                   fontFamily: 'Lato',
                                                   fontWeight:
                                                   FontWeight.w600,
                                                   color: Colors.white,
                                                   fontSize: 15.0),
                                             ),
                                             Divider(),
                                             Container(
                                               color: Colors.black87,
                                               padding: EdgeInsets.only(
                                                   top: 10.0,
                                                   bottom: 10.0
                                               ),
                                               child: Row(
                                                 children: [
                                                   Spacer(),
                                                   Icon(Icons.thumb_up,
                                                     size: 20.0, color: Colors.blueAccent,),
                                                   Text('Like',
                                                       style: TextStyle(
                                                           color:
                                                           Colors.white,
                                                           fontFamily:
                                                           'Lato',
                                                           fontWeight:
                                                           FontWeight
                                                               .w600,
                                                           fontSize: 10.0)),
                                                   Spacer(),
                                                   Icon(Icons.comment,
                                                     size: 20.0, color: Colors.white30,),
                                                   Text('Comment',
                                                       style: TextStyle(
                                                           fontFamily:
                                                           'Lato',
                                                           fontWeight:
                                                           FontWeight
                                                               .w600,
                                                           fontSize: 10.0, color: Colors.white)),
                                                   Spacer(),
                                                   Icon(
                                                     Icons.share,
                                                     size: 15.0,
                                                     color: Colors.lightBlue,
                                                   ),
                                                   Text('Share',
                                                       style: TextStyle(
                                                           fontFamily:
                                                           'Lato',
                                                           fontWeight:
                                                           FontWeight
                                                               .w600,
                                                           fontSize: 10.0, color: Colors.white)),
                                                   Spacer(),
                                                 ],
                                               ),
                                             ),
                                           ],
                                         ),
                                       ),
                                     );
                                   });
                             },
                             child: Card(
                               child: Image.network(
                                   "http://192.168.43.122/healthplus/${data[i].image_attached}"),
                             ),
                           ),
                           Column(
                             children: [
                               Text(
                                 data[i].description,
                                 style: TextStyle(
                                     fontFamily: 'Lato',
                                     fontWeight: FontWeight.w500,
                                     fontSize: 13.0),
                                 overflow: TextOverflow.ellipsis,
                               ),
                               SizedBox(height: 5.0),
                               Row(
                                 children: [
                                   SizedBox(width: 20.0),
                                   Icon(
                                     Icons.thumb_up,
                                     color: Colors.blue,
                                     size: 13,
                                   ),
                                   Text(
                                       'You and ${data[i].likes} people',
                                       style: TextStyle(
                                           fontFamily: 'Lato',
                                           fontWeight: FontWeight.w600,
                                           fontSize: 10.0)),
                                   Spacer(),
                                   Icon(
                                     Icons.comment,
                                     color: Colors.green,
                                     size: 15.0,
                                   ),
                                   Text('Comments',
                                       style: TextStyle(
                                           fontFamily: 'Lato',
                                           fontWeight: FontWeight.w600,
                                           fontSize: 10.0)),
                                   SizedBox(width: 20.0),
                                 ],
                               ),
                               Divider(),
                               Container(
                                 color: Colors.black12,
                                 height: 25.0,
                                 child: Row(
                                   children: [
                                     Spacer(),
                                     Icon(Icons.thumb_up, size: 15.0),
                                     Text('Like',
                                         style: TextStyle(
                                             fontFamily: 'Lato',
                                             fontWeight: FontWeight.w600,
                                             fontSize: 10.0)),
                                     Spacer(),
                                     Icon(Icons.comment, size: 15.0),
                                     Text('Comment',
                                         style: TextStyle(
                                             fontFamily: 'Lato',
                                             fontWeight: FontWeight.w600,
                                             fontSize: 10.0)),
                                     Spacer(),
                                     Icon(
                                       Icons.share,
                                       size: 15.0,
                                       color: Colors.lightBlue,
                                     ),
                                     Text('Share',
                                         style: TextStyle(
                                             fontFamily: 'Lato',
                                             fontWeight: FontWeight.w600,
                                             fontSize: 10.0)),
                                     Spacer(),
                                   ],
                                 ),
                               ),
                               Divider()
                             ],
                           )
                         ],
                       )
                           : Card(
                         child: Column(
                           children: [
                             Text(
                               data[i].description,
                               style: TextStyle(
                                   fontFamily: 'Lato',
                                   fontWeight: FontWeight.w400,
                                   fontSize: 15.0),
                             ),
                             SizedBox(height: 5.0),
                             Row(
                               children: [
                                 SizedBox(width: 20.0),
                                 Icon(
                                   Icons.thumb_up,
                                   color: Colors.blue,
                                   size: 13,
                                 ),
                                 Text('You and ${data[i].likes} people',
                                     style: TextStyle(
                                         fontFamily: 'Lato',
                                         fontWeight: FontWeight.w600,
                                         fontSize: 10.0)),
                                 Spacer(),
                                 Icon(
                                   Icons.comment,
                                   color: Colors.green,
                                   size: 15.0,
                                 ),
                                 Text('Comments',
                                     style: TextStyle(
                                         fontFamily: 'Lato',
                                         fontWeight: FontWeight.w600,
                                         fontSize: 10.0)),
                                 SizedBox(width: 20.0),
                               ],
                             ),
                             Divider(),
                             Row(
                               children: [
                                 Spacer(),
                                 Icon(Icons.thumb_up, size: 15.0),
                                 Text('Like',
                                     style: TextStyle(
                                         fontFamily: 'Lato',
                                         fontWeight: FontWeight.w600,
                                         fontSize: 10.0)),
                                 Spacer(),
                                 Icon(Icons.comment, size: 15.0),
                                 Text('Comment',
                                     style: TextStyle(
                                         fontFamily: 'Lato',
                                         fontWeight: FontWeight.w600,
                                         fontSize: 10.0)),
                                 Spacer(),
                                 Icon(
                                   Icons.share,
                                   size: 15.0,
                                   color: Colors.lightBlue,
                                 ),
                                 Text('Share',
                                     style: TextStyle(
                                         fontFamily: 'Lato',
                                         fontWeight: FontWeight.w600,
                                         fontSize: 10.0)),
                                 Spacer(),
                               ],
                             ),
                             Divider()
                           ],
                         ),
                       ),
                     ],
                   ),
                 )
               ],
             ),
           );
          }

        ),

    );
  }
}

