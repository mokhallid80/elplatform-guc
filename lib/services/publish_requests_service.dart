import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_swiss_knife/models/publish_request.dart';
import 'package:guc_swiss_knife/services/notifications_service.dart';

class PublishRequestsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<List<PublishRequest>> fetchPublishRequests() {
    Stream<List<PublishRequest>> fetchedRequests = _firestore
        .collection("publish_requests")
        .where('approved', isEqualTo: 0)
        .snapshots()
        .asyncMap((snapshot) async {
      List<PublishRequest> requests = [];
      for (var doc in snapshot.docs) {
        PublishRequest request = PublishRequest.fromMap(doc.data(), doc.id);
        requests.add(request);
      }
      return requests;
    });
    return fetchedRequests;
  }

  // approve publish request
  Future<void> approvePublishRequest(PublishRequest? publishRequest) async {
    await _firestore
        .collection("publish_requests")
        .doc(publishRequest!.id)
        .update({'approved': 1});
    _firestore.collection("users").doc(publishRequest.userId).update({
      'is_publisher': true,
      'is_pending': false,
    });
    NotificationService.sendPublishRequestResponseNotification(
        publishRequest, true);
  }

  Future<void> declinePublishRequest(PublishRequest? publishRequest) async {
    await _firestore
        .collection("publish_requests")
        .doc(publishRequest!.id)
        .update({'approved': 2});
    _firestore.collection("users").doc(publishRequest.userId).update({
      'is_publisher': false,
      'is_pending': false,
    });
    NotificationService.sendPublishRequestResponseNotification(
        publishRequest, false);
  }

  Future<void> addPublishRequest(PublishRequest publishRequest) async {
    await _firestore.collection("publish_requests").add(publishRequest.toMap());
    NotificationService.sendPublishRequestNotification(publishRequest);
  }
}
