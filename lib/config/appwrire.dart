import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

Client client = Client()
    .setEndpoint('https://cloud.appwrite.io/v1')
    .setProject('667d37b30023f69f7f74')
    .setSelfSigned(status: true);

const String databaseId = '66803ce100323250c22e';
const String userCollectionId = '66803d2a002bb74a6bc7';

Account account = Account(client);
final Databases databases = Databases(client);

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
    final Session session =
        await account.updatePhoneSession(userId: userId, secret: otp);
    print(session..userId);
    print(session.userId);
    return true;
  } catch (e) {
    print('Error on login with otp: $e');
    return false;
  }
}

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
