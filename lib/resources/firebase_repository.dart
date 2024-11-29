import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kaamsay/models/task_category.dart';
import 'package:kaamsay/models/job_rating.dart';

import '../models/chatroom.dart';
import '../models/job.dart';
import '../models/message.dart';
import '../models/task_ad.dart';
import '/models/user_model.dart';
import '/resources/firebase_methods.dart';

class FirebaseRepository {
  final FirebaseMethods _firebaseMethods = FirebaseMethods();

  User? getCurrentUser() => _firebaseMethods.getCurrentUser();

  Future<User?> signUp(String email, String password) =>
      _firebaseMethods.signUp(email, password);

  Future<void> saveUserDataToFirestore(UserModel userModel) =>
      _firebaseMethods.saveUserDataToFirestore(userModel);

  Future<User?> login(String email, String password) =>
      _firebaseMethods.login(email, password);

  Future<UserModel> getUserDetails(String? uid) =>
      _firebaseMethods.getUserDetails(uid);

  Future<bool> userExists(String uid) async =>
      await _firebaseMethods.userExists(uid);

  Future<void> updateLocation(String uid, Position pos) async =>
      await _firebaseMethods.updateLocation(uid, pos);

  Future<Position?> getLocation(String uid) async =>
      await _firebaseMethods.getLocation(uid);

  Future<void> sendResetPasswordLink(String email) =>
      _firebaseMethods.sendResetPasswordLink(email);

  Future<void> signOut() => _firebaseMethods.signOut();

  Future<String> uploadProfileImage(
          {required File imageFile, required String uid}) =>
      _firebaseMethods.uploadProfileImage(imageFile: imageFile, uid: uid);

  Future<String> uploadCNICImage(
          {required File imageFile, required String uid}) =>
      _firebaseMethods.uploadCNICImage(imageFile: imageFile, uid: uid);

  Future<String> uploadthumbnail({required File imageFile}) =>
      _firebaseMethods.uploadthumbnail(imageFile: imageFile);

  Future<DocumentReference<Object?>> saveTaskToFirestore(TaskAd task) =>
      _firebaseMethods.saveTaskToFirestore(task);

  Stream<QuerySnapshot> getLabourerTasks(String? uid) =>
      _firebaseMethods.getLabourerTasks(uid);

  Stream<QuerySnapshot> getAllTasks() => _firebaseMethods.getAllTasks();

  Stream<QuerySnapshot> getTasksByCategory(String category) =>
      _firebaseMethods.getTasksByCategory(category);

  Future<void> updateTask(TaskAd task) => _firebaseMethods.updateTask(task);

  Future<void> deleteTask(String? taskId) =>
      _firebaseMethods.deleteTask(taskId);

  Future<List<TaskAd>> fetchAllTasks() => _firebaseMethods.fetchAllTasks();

  Future<List<TaskAd>> fetchLabourerTasks(String? uid) =>
      _firebaseMethods.fetchLabourerTasks(uid);

  Future<void> addTaskToHirerSide(Job job) =>
      _firebaseMethods.addTaskToHirerSide(job);

  Future<void> addTaskToLabourerSide(Job job) =>
      _firebaseMethods.addTaskToLabourerSide(job);

  Stream<QuerySnapshot> getLabourerTaskRecord(String? uid) =>
      _firebaseMethods.getLabourerTaskRecord(uid);

  Stream<QuerySnapshot> getHirerTaskRecord(String? uid) =>
      _firebaseMethods.getHirerTaskRecord(uid);

  Future<void> updatetaskRecordtate(Job job, String state) =>
      _firebaseMethods.updatetaskRecordtate(job, state);

  Future<void> updateDeviceToken(String uid, String? deviceToken) =>
      _firebaseMethods.updateDeviceToken(uid, deviceToken);

  Future<String?> getDeviceToken(String uid) =>
      _firebaseMethods.getDeviceToken(uid);

  Future<List<TaskCategory>> getAllTaskCategories() =>
      _firebaseMethods.getAllTaskCategories();

  Future<DocumentReference> addJobRating(JobRating rating) =>
      _firebaseMethods.addJobRating(rating);

  Future<void> updateJobRating(JobRating rating) =>
      _firebaseMethods.updateJobRating(rating);

  Future<void> addLabourerRatingByHirer(String jobId, String taskId,
          String hirerId, String labourerId, double rating, String? feedback) =>
      _firebaseMethods.addLabourerRatingByHirer(
          jobId, taskId, hirerId, labourerId, rating, feedback);

  Future<void> addHirerRatingByLabourer(String jobId, String taskId,
          String hirerId, String labourerId, double rating, String? feedback) =>
      _firebaseMethods.addHirerRatingByLabourer(
          jobId, taskId, hirerId, labourerId, rating, feedback);

  Future<QuerySnapshot> getAllJobRatings(taskId) =>
      _firebaseMethods.getAllJobRatings(taskId);

  Future<QuerySnapshot> getJobRatings(jobId) async =>
      _firebaseMethods.getJobRatings(jobId);

  Future<void> reportBug(String description, String? reportedBy) async =>
      _firebaseMethods.reportBug(description, reportedBy);

  Stream<List<Message>> getChatRoomMessages(String chatId) =>
      _firebaseMethods.getMessages(chatId);

  Stream<List<ChatRoom>> getChatRooms(String uid) =>
      _firebaseMethods.getChatRooms(uid);

  Future<ChatRoom> createChatRoom(String currentUid, String targetUid) =>
      _firebaseMethods.createChatRoom(currentUid, targetUid);

  Future<void> uploadMessageToChatRoom(String chatId, Message message) =>
      _firebaseMethods.uploadMessage(chatId, message);

  Future<void> markUserMessagesRead(
          String chatId, String uid, Message lastMessage) =>
      _firebaseMethods.markMessagesRead(chatId, uid, lastMessage);
}
