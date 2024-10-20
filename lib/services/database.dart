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

// Function to retrieve the Firestore ID based on API ID
/*Future<String?> getFirestoreIdByApiId(String apiId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .where("apiId", isEqualTo: apiId) // Adjust field name as needed
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id; // Return the document ID
      }
    } catch (e) {
      print("Error retrieving Firestore ID: $e");
    }
    return null; // Return null if not found or an error occurs
  }*/

// Function to delete a user from Firestore
/*Future<void> deleteUser(String userId) async {
    try {
      // Delete the document for the given userId
      await FirebaseFirestore.instance.collection("Users").doc(userId).delete();
      print("User with ID $userId deleted successfully.");
    } catch (e) {
      print("Error deleting user: $e");
    }
  }*/
}
