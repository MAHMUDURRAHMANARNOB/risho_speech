import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUser(String userId, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .set(userInfoMap);
  }

  // Function to check if user exists in Firestore
  Future<bool> checkIfUserExists(String userId) async {
    try {
      // Query the Users collection for the document with the given userId
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(userId)
          .get();

      // Return true if the document exists, false otherwise
      return documentSnapshot.exists;
    } catch (e) {
      print("Error checking if user exists: $e");
      return false; // Return false in case of an error
    }
  }
}
