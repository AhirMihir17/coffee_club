import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../coffee/models/coffee_item.dart';

class FirestoreService {
  final FirebaseFirestore? _customFirestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _customFirestore = firestore;

  bool get isFirebaseAvailable {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  FirebaseFirestore? get _firestore {
    if (_customFirestore != null) return _customFirestore;
    if (!isFirebaseAvailable) return null;
    try {
      return FirebaseFirestore.instance;
    } catch (_) {
      return null;
    }
  }

  CollectionReference<Map<String, dynamic>>? get _coffeesRef =>
      _firestore?.collection('coffees');

  /// Real-time stream of all coffees in Cloud Firestore
  Stream<List<CoffeeItem>> getCoffeesStream() {
    final ref = _coffeesRef;
    if (ref == null) {
      return const Stream.empty();
    }
    return ref.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CoffeeItem.fromFirestore(doc);
      }).toList();
    });
  }

  /// One-time fetch of all coffees from Cloud Firestore
  Future<List<CoffeeItem>> getCoffees() async {
    final ref = _coffeesRef;
    if (ref == null) {
      return CoffeeRepository.sampleCoffees;
    }
    try {
      final snapshot = await ref.get();
      if (snapshot.docs.isEmpty) {
        dev.log('Firestore coffees collection is empty. Auto-seeding initial items...');
        await seedInitialCoffees();
        final refreshedSnapshot = await ref.get();
        return refreshedSnapshot.docs
            .map((doc) => CoffeeItem.fromFirestore(doc))
            .toList();
      }
      return snapshot.docs
          .map((doc) => CoffeeItem.fromFirestore(doc))
          .toList();
    } catch (e) {
      dev.log('Error fetching coffees from Firestore: $e');
      return CoffeeRepository.sampleCoffees;
    }
  }

  /// Get single coffee by ID
  Future<CoffeeItem?> getCoffeeById(String id) async {
    final ref = _coffeesRef;
    if (ref == null) return null;
    try {
      final doc = await ref.doc(id).get();
      if (doc.exists) {
        return CoffeeItem.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      dev.log('Error getting coffee by ID: $e');
      return null;
    }
  }

  /// Add or update a coffee item in Cloud Firestore
  /// Storing String, double, int, bool, List, and Map
  Future<void> saveCoffee(CoffeeItem item) async {
    final ref = _coffeesRef;
    if (ref == null) {
      throw Exception('Firebase is not initialized');
    }
    try {
      final docId = item.id.trim().isNotEmpty
          ? item.id.trim()
          : ref.doc().id;
      final itemToSave =
          item.id.trim().isNotEmpty ? item : item.copyWith(id: docId);

      await ref.doc(docId).set(
            itemToSave.toMap(),
            SetOptions(merge: true),
          );
      dev.log('Successfully saved coffee ${itemToSave.name} (ID: $docId) to Firestore');
    } catch (e) {
      dev.log('Error saving coffee to Firestore: $e');
      rethrow;
    }
  }

  /// Delete a coffee document by ID
  Future<void> deleteCoffee(String id) async {
    final ref = _coffeesRef;
    if (ref == null) {
      throw Exception('Firebase is not initialized');
    }
    try {
      await ref.doc(id).delete();
      dev.log('Successfully deleted coffee (ID: $id) from Firestore');
    } catch (e) {
      dev.log('Error deleting coffee: $e');
      rethrow;
    }
  }

  /// Seed/Sync sample coffees to Cloud Firestore default database
  Future<void> seedInitialCoffees() async {
    final db = _firestore;
    final ref = _coffeesRef;
    if (db == null || ref == null) {
      throw Exception('Firebase is not initialized');
    }
    try {
      final batch = db.batch();
      for (final coffee in CoffeeRepository.sampleCoffees) {
        final docRef = ref.doc(coffee.id);
        batch.set(docRef, coffee.toMap(), SetOptions(merge: true));
      }
      await batch.commit();
      dev.log('Sample coffees successfully seeded to Cloud Firestore!');
    } catch (e) {
      dev.log('Error seeding coffees: $e');
      rethrow;
    }
  }
}
