import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class userimagepicker extends StatefulWidget {
userimagepicker(this.imagepickfn);

  final Function(File pickedimage) imagepickfn;


  @override
  State<userimagepicker> createState() => _userimagepickerState();
}

class _userimagepickerState extends State<userimagepicker> {
  File _pickedimage;
  void _pickImage()async{
    final picker=ImagePicker();
    final pickedimage=await picker.pickImage(source: ImageSource.gallery,imageQuality: 50,maxWidth: 150,);
    final pickedimagefile=File(pickedimage.path);
    setState(() {
      _pickedimage=pickedimagefile;
    });
    widget.imagepickfn(pickedimagefile);

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(radius: 40,
        backgroundColor: Colors.grey,
        backgroundImage:_pickedimage!=null? FileImage(_pickedimage):null ,
                 ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.pink,),
                        
                        onPressed:_pickImage,
                        icon: Icon(Icons.image),
                        label: Text('Add Image'),
                        ),

      ],

    );
  }
}