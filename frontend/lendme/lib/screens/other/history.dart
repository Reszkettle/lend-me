import 'package:flutter/material.dart';
import 'package:lendme/components/empty_state.dart';
import 'package:lendme/components/rental_tile.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/models/rental.dart';
import 'package:lendme/repositories/rental_repository.dart';
import 'package:lendme/utils/enums.dart';


class History extends StatefulWidget {
  const History({required this.item, Key? key}) : super(key: key);

  final Item item;

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {


  @override
  Widget build(BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                  title: Text('History'),
                  elevation: 0.0
              ),
              body:  Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<List<Rental?>>(
                    stream: RentalRepository().getStreamOfRentals(widget.item.id.toString()),
                    builder: (context, rentalSnapshots) {
                      if (!rentalSnapshots.hasData || rentalSnapshots.data!.isEmpty) {
                        return const EmptyState(
                            placement: EmptyStatePlacement.history);
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.all(9),
                        itemBuilder: (context, index) {
                          return RentalTile(
                              rental: rentalSnapshots.data![index]!, item: widget.item);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 9);
                        },
                        itemCount: rentalSnapshots.data!.length,
                      );
                    }),
              ),
            );

  }
}


