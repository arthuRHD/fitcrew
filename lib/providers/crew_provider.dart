import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/crew.dart';
import 'auth_provider.dart';
import 'firestore_provider.dart';

final crewServiceProvider = Provider<CrewService>((ref) {
  return CrewService(
    firestore: ref.watch(firestoreProvider),
    getCurrentUserId: () => ref.read(authProvider).currentUser?.uid,
  );
});

final createCrewProvider = FutureProvider.autoDispose.family<void, CreateCrewParams>((ref, params) async {
  return ref.read(crewServiceProvider).createCrew(
    name: params.name,
    description: params.description,
  );
});

class CreateCrewParams {
  final String name;
  final String? description;

  CreateCrewParams({required this.name, this.description});
}

class CrewService {
  final FirebaseFirestore firestore;
  final String? Function() getCurrentUserId;

  CrewService({required this.firestore, required this.getCurrentUserId});

  Future<void> createCrew({
    required String name,
    String? description,
  }) async {
    final userId = getCurrentUserId();
    if (userId == null) throw Exception('User not authenticated');

    final crew = Crew(
      id: firestore.collection('crews').doc().id,
      name: name,
      ownerId: userId,
      memberIds: [userId],
      description: description,
    );

    await firestore.collection('crews').doc(crew.id).set(crew.toJson());
  }
} 