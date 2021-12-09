import 'package:lendme/models/item.dart';
import 'package:lendme/models/request.dart';
import 'package:lendme/models/user.dart';

class DetailedRequest {
  final Request request;
  final User issuer;
  final Item item;

  DetailedRequest(
      {required this.request, required this.issuer, required this.item});
}
