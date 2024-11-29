import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kaamsay/models/job_rating.dart';
import 'package:kaamsay/models/task_ad.dart';
import 'package:kaamsay/models/task_category.dart';

import '../models/chatroom.dart';
import '../models/message.dart';
import '/constants/strings.dart';
import '/models/user_model.dart';
import '../models/job.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final CollectionReference _userCollection =
      firestore.collection(USERS_COLLECTION);
  static final CollectionReference _serviceCollection =
      firestore.collection(TASKADS_COLLECTION);
  static final CollectionReference _jobCollection =
      firestore.collection(TASKRECORD_COLLECTION);
  static final CollectionReference _taskCategoriesCollection =
      firestore.collection(TASKCATEGORIES_COLLECTION);
  static final CollectionReference _ratingsCollection =
      firestore.collection(JOBRATINGS_COLLECTION);
  static final CollectionReference _bugReportsCollection =
      firestore.collection(BUGREPORTS_COLLECTION);
  static final CollectionReference _chatRoomCollection =
      firestore.collection(CHATROOM_COLLECTION);

  final Reference _storageReference = FirebaseStorage.instance.ref();

  User? getCurrentUser() => _auth.currentUser;

  Future<User?> signUp(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential.user;
  }

  Future<void> saveUserDataToFirestore(UserModel userModel) async {
    await _userCollection.doc(userModel.uid).set(userModel.toMap(userModel));
  }

  Future<User?> login(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential.user;
  }

  Future<UserModel> getUserDetails(String? uid) async {
    DocumentSnapshot documentSnapshot = await _userCollection.doc(uid).get();
    UserModel userModel =
        UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    return userModel;
  }

  Future<bool> userExists(String uid) async {
    return (await _userCollection.doc(uid).get()).exists;
  }

  Future<void> updateLocation(String uid, Position pos) async {
    await _userCollection.doc(uid).update({
      // 'latitude': pos.latitude,
      // 'longitude': pos.longitude,
      'position': pos.toJson(),
    });
  }

  Future<Position?> getLocation(String uid) async {
    DocumentSnapshot documentSnapshot = await _userCollection.doc(uid).get();
    Position pos;
    try {
      // print('HERE');
      pos = Position.fromMap(
          (documentSnapshot.data() as Map)['position'] as Map<String, dynamic>);
    } catch (e) {
      print(e);
      return null;
    }
    return pos;
  }

  Future<void> sendResetPasswordLink(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> uploadProfileImage(
      {required File imageFile, required String uid}) async {
    await _storageReference
        .child('profile_images')
        .child(uid)
        .putFile(imageFile);
    String downloadURL =
        await _storageReference.child('profile_images/$uid').getDownloadURL();
    return downloadURL;
  }

  Future<String> uploadCNICImage(
      {required File imageFile, required String uid}) async {
    await _storageReference.child('cnic_images').child(uid).putFile(imageFile);
    String downloadURL =
        await _storageReference.child('cnic_images/$uid').getDownloadURL();
    return downloadURL;
  }

  Future<String> uploadthumbnail({required File imageFile}) async {
    String randomId = '${DateTime.now().millisecondsSinceEpoch}';
    await _storageReference
        .child('task_thumbnails')
        .child(randomId)
        .putFile(imageFile);
    String downloadURL = await _storageReference
        .child('task_thumbnails/$randomId')
        .getDownloadURL();
    return downloadURL;
  }

  Future<DocumentReference<Object?>> saveTaskToFirestore(TaskAd task) async {
    return await _serviceCollection.add(task.toMap(task));
  }

  Stream<QuerySnapshot> getLabourerTasks(String? uid) {
    return _serviceCollection.where('labourer_id', isEqualTo: uid).snapshots();
  }

  Stream<QuerySnapshot> getAllTasks() {
    return _serviceCollection.snapshots();
  }

  Stream<QuerySnapshot> getTasksByCategory(String category) {
    print(category);
    if (category == 'FJa7QreyDmwUsWvd0n9m' ||
        category.toLowerCase() == 'other') {
      return _serviceCollection.snapshots();
    }
    return _serviceCollection
        .where('category', isEqualTo: category)
        .snapshots();
  }

  Future<void> updateTask(TaskAd task) async {
    await _serviceCollection.doc(task.taskId).set(task.toMap(task));
  }

  Future<void> deleteTask(String? taskId) async {
    await _serviceCollection.doc(taskId).delete();
  }

  Future<List<TaskAd>> fetchAllTasks() async {
    List<TaskAd> taskList = [];

    QuerySnapshot querySnapshot = await _serviceCollection.get();

    for (var taskDocument in querySnapshot.docs) {
      taskList.add(TaskAd.fromMap(taskDocument.data() as Map<String, dynamic>));
    }

    return taskList;
  }

  Future<List<TaskAd>> fetchLabourerTasks(String? uid) async {
    List<TaskAd> taskList = [];

    QuerySnapshot querySnapshot =
        await _serviceCollection.where('labourer_id', isEqualTo: uid).get();

    for (var taskDocument in querySnapshot.docs) {
      taskList.add(TaskAd.fromMap(taskDocument.data() as Map<String, dynamic>));
    }

    return taskList;
  }

  Future<void> addTaskToLabourerSide(Job job) async {
    await _jobCollection
        .doc(job.labourerId)
        .collection(LABOURER_taskRecord_COLLECTION)
        .doc(job.jobId)
        .set(job.toMap(job) as Map<String, dynamic>);
  }

  Future<void> addTaskToHirerSide(Job job) async {
    await _jobCollection
        .doc(job.hirerId)
        .collection(HIRER_taskRecord_COLLECTION)
        .doc(job.jobId)
        .set(job.toMap(job) as Map<String, dynamic>);
  }

  Stream<QuerySnapshot> getLabourerTaskRecord(String? uid) {
    return _jobCollection
        .doc(uid)
        .collection(LABOURER_taskRecord_COLLECTION)
        .snapshots();
  }

  Stream<QuerySnapshot> getHirerTaskRecord(String? uid) {
    return _jobCollection
        .doc(uid)
        .collection(HIRER_taskRecord_COLLECTION)
        .snapshots();
  }

  Future<void> updatetaskRecordtate(Job job, String state) async {
    await _jobCollection
        .doc(job.labourerId)
        .collection(LABOURER_taskRecord_COLLECTION)
        .doc(job.jobId)
        .update({'state': state});

    await _jobCollection
        .doc(job.hirerId)
        .collection(HIRER_taskRecord_COLLECTION)
        .doc(job.jobId)
        .update({'state': state});
  }

  Future<void> updateDeviceToken(String uid, String? deviceToken) async {
    await _userCollection.doc(uid).update({'device_token': deviceToken});
  }

  Future<String?> getDeviceToken(String uid) async {
    var snap = await _userCollection.doc(uid).get();
    return snap.get('device_token');
  }

  Future<List<TaskCategory>> getAllTaskCategories() async {
    List<TaskCategory> taskCategories = [];
    for (var element in (await _taskCategoriesCollection.get()).docs) {
      var data = element.data() as Map<String, dynamic>;
      taskCategories.add(TaskCategory(
        element.id,
        data['name'],
        data['thumbnail'],
      ));
    }
    return taskCategories;
  }

  Future<DocumentReference> addJobRating(JobRating rating) async {
    var ref = await _ratingsCollection.add(rating.toMap());
    await _ratingsCollection.doc(ref.id).update({'ratingId': ref.id});
    return ref;
  }

  Future<void> updateJobRating(JobRating rating) async {
    await _ratingsCollection.doc(rating.ratingId).update(rating.toMap());
  }

  Future<void> addLabourerRatingByHirer(
      String jobId,
      String taskId,
      String hirerId,
      String labourerId,
      double rating,
      String? feedback) async {
    String ratingId = '';
    var refs = await _ratingsCollection.where('jobId', isEqualTo: jobId).get();
    if (refs.size == 0) {
      ratingId = (await addJobRating(
        JobRating(
          ratingId: '',
          jobId: jobId,
          taskId: taskId,
          hirerId: hirerId,
          labourerId: labourerId,
          ratingForLabourer: rating,
          feedbackForLabourer: feedback ?? '',
        ),
      ))
          .id;
    } else {
      ratingId = refs.docs.first.id;
    }

    await _ratingsCollection.doc(ratingId).set({
      'jobId': jobId,
      'taskId': taskId,
      'labourerId': labourerId,
      'hirerId': hirerId,
      'ratingForLabourer': rating,
      'feedbackForLabourer': feedback ?? '',
    }, SetOptions(merge: true));
  }

  Future<void> addHirerRatingByLabourer(
      String jobId,
      String taskId,
      String hirerId,
      String labourerId,
      double rating,
      String? feedback) async {
    String ratingId = '';
    var refs = await _ratingsCollection.where('jobId', isEqualTo: jobId).get();
    if (refs.size == 0) {
      ratingId = (await addJobRating(
        JobRating(
          ratingId: '',
          jobId: jobId,
          taskId: taskId,
          hirerId: hirerId,
          labourerId: labourerId,
          ratingForHirer: rating,
          feedbackForHirer: feedback ?? '',
        ),
      ))
          .id;
    } else {
      ratingId = refs.docs.first.id;
    }

    await _ratingsCollection.doc(ratingId).set({
      'jobId': jobId,
      'taskId': taskId,
      'labourerId': labourerId,
      'hirerId': hirerId,
      'ratingForHirer': rating,
      'feedbackForHirer': feedback ?? '',
    }, SetOptions(merge: true));
  }

  Future<QuerySnapshot> getAllJobRatings(taskId) async {
    return await _ratingsCollection.where('taskId', isEqualTo: taskId).get();
  }

  Future<QuerySnapshot> getJobRatings(jobId) async {
    return await _ratingsCollection.where('jobId', isEqualTo: jobId).get();
  }

  Future<void> reportBug(String description, String? reportedBy) async {
    await _bugReportsCollection.add({
      'bug': description,
      'reportedBy': reportedBy ?? 'Unknown',
    });
  }

  Stream<List<Message>> getMessages(String chatId) {
    return _chatRoomCollection
        .doc(chatId)
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => Message.fromMap(e.data())).toList());
  }

  Future<ChatRoom> createChatRoom(String currentUid, String targetUid) async {
    //creating unique id that stays same when either of users start the convo
    String chatId;
    List<String> memberIds;

    if (currentUid.compareTo(targetUid) > 0) {
      chatId = currentUid + targetUid;
      memberIds = [currentUid, targetUid];
    } else {
      chatId = targetUid + currentUid;
      memberIds = [targetUid, currentUid];
    }

    ChatRoom newRoom = ChatRoom(chatRoomId: chatId, memberIds: memberIds);

    await _chatRoomCollection.doc(chatId).set(
      {
        'chatId': chatId,
        'memberIds': memberIds,
      },
      SetOptions(merge: true),
    );

    return newRoom;
  }

  // needs indexing for proper ordering
  Stream<List<ChatRoom>> getChatRooms(String uid) {
    return _chatRoomCollection
        .where('memberIds', arrayContains: uid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => ChatRoom.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> uploadMessage(String chatId, Message message) async {
    _chatRoomCollection.doc(chatId).collection('messages').add(message.toMap());

    _chatRoomCollection.doc(chatId).update({
      'lastMessage': message.toMap(),
      'lastMessageTime': message.toMap()['time']
    });
  }

  Future<void> markMessagesRead(
    String chatId,
    String uid,
    Message lastMessage,
  ) async {
    _chatRoomCollection
        .doc(chatId)
        .collection('messages')
        .where('senderId', isEqualTo: uid)
        .get()
        .then((value) => value.docs.forEach((element) {
              element.reference.update({'unread': false});
            }));

    if (lastMessage.sender!.uid != uid) return;
    var mapData = lastMessage.toMap();
    mapData['unread'] = false;
    _chatRoomCollection.doc(chatId).update({'lastMessage': mapData});
  }
}
