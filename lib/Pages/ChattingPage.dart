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
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  bool isDisplayStickers = false;
  bool isLoading = false;
  File imageFile;
  var imageUrl;
  String chatId = '';
  SharedPreferences preferences;
  String id;

  _ChatScreenState({
    @required this.receiverId,
    @required this.receiverPhotoUrl,
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    focusNode.addListener(onFocusNodeChange);
    readLocal();
  }

  readLocal() async {
    preferences = await SharedPreferences.getInstance();
    id = preferences.getString('id') ?? '';

    if (id.hashCode <= receiverId.hashCode) {
      chatId = '$id-$receiverId';
    } else {
      chatId = '$receiverId-$id';
    }

    Firestore.instance.collection('users').document(id).updateData({
      'chattingWith': receiverId,
    });

    setState(() {});
  }

  onFocusNodeChange() {
    if (focusNode.hasFocus) {
      setState(() {
        isDisplayStickers = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: [
          Column(
            children: [
              createListMessages(),
              isDisplayStickers ? createStickers() : Container(),
              createInput(),
            ],
          ),
          createLoading(),
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  Future<bool> onBackPress() async {
    if (isDisplayStickers) {
      setState(() {
        isDisplayStickers = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  createLoading() {
    return Positioned(
      child: isLoading ? circularProgress() : Container(),
    );
  }

  createStickers() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              FlatButton(
                onPressed: () => onSendMessage('mimi1', 2),
                child: Image.asset(
                  'images/mimi1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi2', 2),
                child: Image.asset(
                  'images/mimi2.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi3', 2),
                child: Image.asset(
                  'images/mimi3.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: [
              FlatButton(
                onPressed: () => onSendMessage('mimi4', 2),
                child: Image.asset(
                  'images/mimi4.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi5', 2),
                child: Image.asset(
                  'images/mimi5.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi6', 2),
                child: Image.asset(
                  'images/mimi6.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: [
              FlatButton(
                onPressed: () => onSendMessage('mimi7', 2),
                child: Image.asset(
                  'images/mimi7.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi8', 2),
                child: Image.asset(
                  'images/mimi8.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi9', 2),
                child: Image.asset(
                  'images/mimi9.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(5.0),
      // height: 100.0,
    );
  }

  createListMessages() {
    return Flexible(
        // child: chatId == '' ? ,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
          ),
        ),
        );
  }

  getStickers() {
    focusNode.unfocus();
    setState(() {
      isDisplayStickers = !isDisplayStickers;
    });
  }

  Future<void> getImageFromGallery() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
    }

    uploadImagefile();
  }

  Future<void> uploadImagefile() async {
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Chat images').child(fileName);

    StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;

    storageTaskSnapshot.ref.getDownloadURL().then(
        (value) => (downloadUrl) {
              imageUrl = downloadUrl;
              setState(() {
                isLoading = false;
                onSendMessage(imageUrl, 1);
              });
            }, onError: (errorMsg) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Error: ' + errorMsg.toString());
    });
  }

  onSendMessage(String contentMsg, int type) {
    // type = 0 => txt msg
    // type = 1 => image file
    // type = 2 => sticker file
    if (contentMsg != '') {
      messageTextEditingController.clear();

      var docRef = Firestore.instance
          .collection('messages')
          .document(chatId)
          .collection(chatId)
          .document(DateTime.now().microsecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          docRef,
          {
            'idFrom': id,
            'idTo': receiverId,
            'timestamp': DateTime.now().microsecondsSinceEpoch.toString(),
            'content': contentMsg,
            'type': type,
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {}
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
                onPressed: getImageFromGallery,
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
                onPressed: getStickers,
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
                onPressed: () =>
                    onSendMessage(messageTextEditingController.text, 0),
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
