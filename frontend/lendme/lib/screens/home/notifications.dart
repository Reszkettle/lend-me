import 'package:flutter/material.dart';
import 'package:lendme/components/empty_state.dart';
import 'package:lendme/components/notification_tile.dart';
import 'package:lendme/models/request.dart';
import 'package:lendme/repositories/request_repository.dart';
import 'package:lendme/utils/enums.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<Request?>>(
          stream: RequestRepository().getStreamOfCurrentUserRequests(),
          builder: (context, requestSnapshots) {
            if (!requestSnapshots.hasData || requestSnapshots.data!.isEmpty) {
              return const EmptyState(
                  placement: EmptyStatePlacement.notifications);
            }
            return ListView.separated(
              padding: const EdgeInsets.all(9),
              itemBuilder: (context, index) {
                return NotificationTile(
                    request: requestSnapshots.data![index]!);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 9);
              },
              itemCount: requestSnapshots.data!.length,
            );
          }),
    );
  }
}
