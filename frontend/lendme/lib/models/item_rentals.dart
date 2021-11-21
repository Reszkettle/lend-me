import 'package:lendme/models/item.dart';
import 'package:lendme/models/rental.dart';

class ItemRentals {
  final Item item;
  final List<Rental>? rentals;

  ItemRentals({required this.item, this.rentals});
}
