import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fitcrew/providers/crew_provider.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseFirestore>(),
  MockSpec<CollectionReference<Map<String, dynamic>>>(
    as: #MockCrewCollection,
    unsupportedMembers: {#snapshots, #withConverter},
  ),
  MockSpec<DocumentReference<Map<String, dynamic>>>(
    as: #MockCrewDocument, 
    unsupportedMembers: {#snapshots, #withConverter},
  ),
])
import 'crew_provider_test.mocks.dart';

void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockCrewCollection mockCollection;
  late MockCrewDocument mockDocument;
  late CrewService crewService;
  const testUserId = 'test-user-id';

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCrewCollection();
    mockDocument = MockCrewDocument();

    when(mockFirestore.collection('crews')).thenReturn(mockCollection as CollectionReference<Map<String, dynamic>>);
    when(mockCollection.doc(any)).thenReturn(mockDocument);
    when(mockDocument.id).thenReturn('test-crew-id');

    crewService = CrewService(
      firestore: mockFirestore,
      getCurrentUserId: () => testUserId,
    );
  });

  group('CrewService', () {
    test('createCrew creates crew with correct data', () async {
      when(mockDocument.set(any)).thenAnswer((_) async => {});

      await crewService.createCrew(
        name: 'Test Crew',
        description: 'Test Description',
      );

      verify(mockDocument.set({
        'id': 'test-crew-id',
        'name': 'Test Crew',
        'ownerId': testUserId,
        'memberIds': [testUserId],
        'maxMembers': 7,
        'description': 'Test Description',
      })).called(1);
    });

    test('createCrew throws when user not authenticated', () async {
      crewService = CrewService(
        firestore: mockFirestore,
        getCurrentUserId: () => null,
      );

      expect(
        () => crewService.createCrew(name: 'Test Crew'),
        throwsA(isA<Exception>()),
      );
    });
  });
} 