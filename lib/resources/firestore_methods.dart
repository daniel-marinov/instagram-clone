import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_app/model/post.dart';
import 'package:task_app/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
  ) async {
    String res = 'some error ocurred';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );

      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
