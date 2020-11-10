import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:telegramchatapp/Widgets/FullImageWidget.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatelessWidget {
  final receiverId;
  final receiverPhotoUrl;
  final receiverNickname;

  Chat({
    @required this.receiverId,
    @required this.receiverPhotoUrl,
    @required this.receiverNickname,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              backgroundImage: CachedNetworkImageProvider(receiverPhotoUrl),
            ),
          )
        ],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.lightBlue,
        title: Text(
          receiverNickname,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ChatScreen(
        receiverId: receiverId,
        receiverPhotoUrl: receiverPhotoUrl,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final receiverId;
  final receiverPhotoUrl;

  ChatScreen({
    @required this.receiverId,
    @required this.receiverPhotoUrl,
  });

  @override
  State createState() => _ChatScreenState(
        receiverId: receiverId,
        receiverPhotoUrl: receiverPhotoUrl,
      );
}

class _ChatScreenState extends State<ChatScreen> {
  final receiverId;
  final receiverPhotoUrl;
  final TextEditingController messageTextEditingController =
      TextEditingController();
  final FocusNode focusNode = FocusNode();

  _ChatScreenState({
    @required this.receiverId,
    @required this.receiverPhotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: [
          Column(
            children: [
              createListMessages(),
              createInput(),
            ],
          ),
        ],
      ),
    );
  }

  createListMessages() {
    return Flexible(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
        ),
      ),
    );
  }

  createInput() {
    return Container(
      child: Row(
        children: [
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 1.0,
              ),
              child: IconButton(
                  icon: Icon(
                    Icons.image,
                    color: Colors.lightBlueAccent,
                  ),
                  onPressed: () {} // getImageFromGallery,
                  ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 1.0,
              ),
              child: IconButton(
                  icon: Icon(
                    Icons.face,
                    color: Colors.lightBlueAccent,
                  ),
                  onPressed: () {} // getImageFromGallery,
                  ),
            ),
            color: Colors.white,
          ),
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Colors.black, fontSize: 15.0),
                controller: messageTextEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Write here...',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                focusNode: focusNode,
              ),
            ),
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.lightBlueAccent,
                ),
                onPressed: () {},
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        color: Colors.white,
      ),
    );
  }
}
