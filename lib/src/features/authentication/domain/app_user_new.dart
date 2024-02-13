import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/constants/firestore_constants.dart';
import 'package:naytto/src/features/authentication/data/firebase_auth_repository.dart';

typedef HousingCooperativeName = String;

final housingCooperativeNameProvider =
    AutoDisposeFutureProvider<HousingCooperativeName>((ref) async {
  final uid = ref.watch(firebaseAuthProvider).currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final response =
      await _firestore.collection(FirestoreCollections.users).doc(uid).get();

  final data = response.data();

  final HousingCooperativeName cooperative =
      data![FirestoreFields.usersHousingCooperative];
  return cooperative;
});

class AppUserNew {
  const AppUserNew({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.apartmentId,
    required this.tel,
    required this.email,
  });

  final String uid;
  final String firstName;
  final String lastName;
  final String apartmentId;
  final String tel;
  final String email;

  factory AppUserNew.fromJson(Map<String, dynamic> json, String id) {
    return AppUserNew(
        firstName: json[FirestoreFields.residentFirstName] as String,
        lastName: json[FirestoreFields.residentLastName] as String,
        apartmentId: json[FirestoreFields.residentApartmentNumber] as String,
        tel: json[FirestoreFields.residentTel] as String,
        email: json[FirestoreFields.residentEmail] as String,
        uid: id);
  }
}

// turn this shit into an asyncnotifier tomorrow jesus
class AppUserNewNotifier extends AutoDisposeAsyncNotifier<AppUserNew> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<AppUserNew> build() async {
    final uid = ref.watch(firebaseAuthProvider).currentUser!.uid;
    final housingCooperativeName =
        await ref.watch(housingCooperativeNameProvider.future);
    return _fetchUser(uid, housingCooperativeName);
  }

  Future<AppUserNew> _fetchUser(
      String uid, String housingCooperativeName) async {
    final snapshot = await _firestore
        .collection(FirestoreCollections.housingCooperative)
        .doc(housingCooperativeName)
        .collection(FirestoreCollections.residents)
        .doc(uid)
        .get();

    if (!snapshot.exists) {
      throw Exception('User document not found');
    }

    final userData = snapshot.data();

    if (userData == null) {
      throw Exception('User data is null');
    }

    final user = AppUserNew.fromJson(userData, snapshot.id);
    return user;
  }
}

final appUserNewProvider =
    AsyncNotifierProvider.autoDispose<AppUserNewNotifier, AppUserNew>(() {
  return AppUserNewNotifier();
});
