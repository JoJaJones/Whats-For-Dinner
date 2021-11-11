import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class FirestoreController {
  static final FirestoreController _fsController = FirestoreController._internal();

  static const String IMAGE_URL = "image_url";
  static String? userId;

  FirebaseStorage _fileStorage;
  FirebaseFirestore _db;

  factory FirestoreController(){
    return _fsController;
  }

  FirestoreController._internal()
      : _db = FirebaseFirestore.instance,
        _fileStorage = FirebaseStorage.instance {
    _initUser();
  }

  Future<void> uploadFile(File image, Map<String, dynamic> refData) async {
    _initUser();
    var storageRef =
    _fileStorage.ref().child('${Timestamp.now().hashCode}.jpg');
    UploadTask uploadTask = storageRef.putFile(image);
    await uploadTask;
    refData[IMAGE_URL] = await storageRef.getDownloadURL();
  }

  Future<void> addEntryToCollection(String collection, Map<String, dynamic> data) async {
    _initUser();
    _db.collection(collection).add(
        data
    );
  }

  Future<void> addEntryToUserCollection(String collection, Map<String, dynamic> data) async {
    _initUser();
    if(userId != null) {
      _db.collection("$userId-$collection").add(
          data
      );
    }
  }

  Future<void> addEntryToDoc(String collection, String document, Map<String, dynamic> data, [bool isUpdate = false]) async {
    _initUser();
    var curDoc = _db.collection(collection).doc(document);
    if(!isUpdate) {
      curDoc.set(
          data
      );
    } else {
      curDoc.update(
          data
      );
    }
  }

  Future<void> addEntryToUserDoc(String collection, String document, Map<String, dynamic> data, [bool isUpdate = false]) async {
    _initUser();
    if(userId != null) {
      var curDoc = _db.collection("$userId-$collection").doc(document);
      if(!isUpdate) {
        curDoc.set(
            data
        );
      } else {
        curDoc.update(
            data
        );
      }
    }
  }

  Stream readDatabaseEntryList(String collection){
    _initUser();
    return _db.collection(collection).snapshots();
  }

  Stream readDatabaseEntry(String collection, String document){
    _initUser();
    return _db.collection(collection).doc(document).snapshots();
  }


  Stream readUserDatabaseEntryList(String collection){
    _initUser();
    if(userId != null) {
      return _db.collection("$userId-$collection").snapshots();
    }

    return Stream.empty();
  }

  Stream readUserDatabaseEntry(String collection, String document){
    _initUser();
    if(userId != null) {
      return _db.collection("$userId-$collection").doc(document).snapshots();
    }

    return Stream.empty();
  }

  void _initUser(){
    if(userId == null){
      userId = FirebaseAuth.instance.currentUser?.uid;
    }
  }

  String? get userid => userId;

}