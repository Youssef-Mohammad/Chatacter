import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chatacter/main.dart';
import 'package:chatacter/models/user_data.dart';
import 'package:chatacter/providers/user_data_provider.dart';
import 'package:provider/provider.dart';

Client client = Client()
    .setEndpoint('https://cloud.appwrite.io/v1')
    .setProject('667d37b30023f69f7f74')
    .setSelfSigned(status: true);

const String databaseId = '66803ce100323250c22e';
const String userCollectionId = '66803d2a002bb74a6bc7';
const String imagesBucketId = '6683247c00056fdd9ceb';

Account account = Account(client);
final Databases databases = Databases(client);
final Storage storage = Storage(client);

//save a phone number (while creating a new account)
Future<bool> savePhoneToDatabase(
    {required String phoneNumber, required String userId}) async {
  try {
    final response = await databases.createDocument(
        databaseId: databaseId,
        collectionId: userCollectionId,
        documentId: userId,
        data: {
          'id': userId,
          'phone_number': phoneNumber,
        });

    print(response);
    return true;
  } on AppwriteException catch (e) {
    print("Can't save to user database: $e");
    return false;
  }
}

// Check if phone number is exist in the database
Future<String> checkPhoneNumber({required String phoneNumbre}) async {
  try {
    final DocumentList matchUser = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: userCollectionId,
        queries: [Query.equal('phone_number', phoneNumbre)]);

    if (matchUser.total > 0) {
      final Document user = matchUser.documents[0];

      if (user.data['phone_number'] != null &&
          user.data['phone_number'] != '') {
        return user.data['id'];
      } else {
        print('User is not exist in the database');
        return 'user_not_exists';
      }
    } else {
      print('User is not exist in the database');
      return 'user_not_exists';
    }
  } on AppwriteException catch (e) {
    print('Error when reading database: $e');
    return 'user_not_exists';
  }
}

// create phone session, send OTP
Future<String> createPhoneNumberSession({required String phone}) async {
  try {
    final userId = await checkPhoneNumber(phoneNumbre: phone);

    if (userId == 'user_not_exists') {
      // Create a new account
      final Token data =
          await account.createPhoneToken(userId: ID.unique(), phone: phone);

      // Save user to collection
      savePhoneToDatabase(phoneNumber: phone, userId: data.userId);
      return data.userId;
    }
    // if user exists in the database
    else {
      // create phone token for existing user
      final Token data =
          await account.createPhoneToken(userId: userId, phone: phone);
      return data.userId;
    }
  } catch (e) {
    print('Error on creating phone session: $e');
    return 'Login Error';
  }
}

// Login with OTP

Future<bool> loginWithOtp({required String otp, required String userId}) async {
  try {
    // Check if a session already exists
    bool sessionExists = await checkSessions();
    if (sessionExists) {
      print('User already has an active session.');
      return true; // Return true if an active session exists
    } else {
      // If no active session, proceed with OTP login
      // Assuming `updatePhoneSession` is the method to use with OTP
      final Session session =
          await account.updatePhoneSession(userId: userId, secret: otp);
      print(session..userId);
      print(session.userId);
      return true;
    }
  } catch (e) {
    print('Error on login with otp: $e');
    return false;
  }
}

// Future<bool> loginWithOtp({required String otp, required String userId}) async {
//   try {
//     final Session session =
//         await account.updatePhoneSession(userId: userId, secret: otp);
//     print(session..userId);
//     print(session.userId);
//     return true;
//   } catch (e) {
//     print('Error on login with otp: $e');
//     return false;
//   }
// }

// Check if the session exist
Future<bool> checkSessions() async {
  try {
    final Session session = await account.getSession(sessionId: 'current');
    print('Session exists: ${session.$id}');
    return true;
  } catch (e) {
    print('Session is not exists: $e');
    return false;
  }
}

// Logout and delete session
Future logoutUser() async {
  await account.deleteSession(sessionId: 'current');
}

// Load user data
Future<UserData?> getUserDetails({required String userId}) async {
// Future<User?> getUserDetails({required String userId}) async {
  try {
    final response = await databases.getDocument(
        databaseId: databaseId,
        collectionId: userCollectionId,
        documentId: userId);
    print('Getting User Data...');
    print(response.data);
    // return User.toMap(response.data);
    return UserData.toMap(response.data);
  } catch (e) {
    print('Error in getting user data: $e');
    return null;
  }
}

// To update user data
Future<bool> updateUserDetails(String picture, String location,
    {required String id,
    required String name,
    required String lastName,
    required String birthday,
    required String gender}) async {
  try {
    final data = await databases.updateDocument(
        databaseId: databaseId,
        collectionId: userCollectionId,
        documentId: id,
        data: {
          'name': name,
          'profile_picture': picture,
          'location': location,
          'last_name': lastName,
          'birthday': birthday,
          'gender': gender
        });

    Provider.of<UserDataProvider>(navigatorKey.currentContext!, listen: false)
        .setUserName(name);
    Provider.of<UserDataProvider>(navigatorKey.currentContext!, listen: false)
        .setUserLastName(lastName);
    Provider.of<UserDataProvider>(navigatorKey.currentContext!, listen: false)
        .setUserProfilePicture(picture);
    Provider.of<UserDataProvider>(navigatorKey.currentContext!, listen: false)
        .setUserLocation(location);
    Provider.of<UserDataProvider>(navigatorKey.currentContext!, listen: false)
        .setUserBirthday(birthday);
    Provider.of<UserDataProvider>(navigatorKey.currentContext!, listen: false)
        .setUserGender(gender);

    print(data);
    return true;
  } on AppwriteException catch (e) {
    print('Can\'t save data to database: $e');
    return false;
  }
}

// Upload and save image to storage bucked
Future<String?> saveImageToBucket({required InputFile image}) async {
  try {
    final response = await storage.createFile(
        bucketId: imagesBucketId, fileId: ID.unique(), file: image);
    print('Response after saving to bucked: $response');
    return response.$id;
  } catch (e) {
    print('Error when saving an image to bucket: $e');
    return null;
  }
}

// updating an image in the bucket (deleting and creating a new one)
Future<String?> updateImageOnBucket(
    {required String oldImageId, required InputFile image}) async {
  try {
    //To delete the old image
    deleteImageFromBucket(oldImage: oldImageId);

    //To create a new image
    final newImage = saveImageToBucket(image: image);

    return newImage;
  } catch (e) {
    print('Cann\'t update / delete image: $e');
    return null;
  }
}

//To delete an image from the bucket
Future<bool> deleteImageFromBucket({required String oldImage}) async {
  try {
    await storage.deleteFile(bucketId: imagesBucketId, fileId: oldImage);
    return true;
  } catch (e) {
    print('Can\'t delete image: $e');
    return false;
  }
}
