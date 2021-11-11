import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirestoreController {
  static final FirestoreController _fsController = FirestoreController._internal();

  static const String IMAGE_URL = "image_url";

  FirebaseStorage _fileStorage;
  FirebaseFirestore _db;

  factory FirestoreController(){
    return _fsController;
  }

  FirestoreController._internal()
      : _db = FirebaseFirestore.instance,
        _fileStorage = FirebaseStorage.instance {}

  Future<void> uploadFile(File image, Map<String, dynamic> refData) async {
    var storageRef =
    _fileStorage.ref().child('${Timestamp.now().hashCode}.jpg');
    UploadTask uploadTask = storageRef.putFile(image);
    await uploadTask;
    refData[IMAGE_URL] = await storageRef.getDownloadURL();
  }

  Future<void> addEntryToDatabase(String collection, Map<String, dynamic> data) async {
    _db.collection(collection).add(
        data
    );
  }

  Stream readDatabaseEntryList(String collection){
    return _db.collection(collection).snapshots();
  }

  Stream readDatabaseEntry(String collection, String doc){
    return _db.collection(collection).doc(doc).snapshots();
  }


}