import 'package:lendme/models/request.dart';
import 'package:lendme/models/request_type.dart';
import 'package:lendme/models/user.dart';

class RequestHandlers {

  Future accept(Request request, User user) async {
    final type = request.type;
    if(type == RequestType.borrow) {
      await _acceptBorrow(request, user);
    } else if(type == RequestType.extend) {
      await _acceptExtend(request, user);
    } else if(type == RequestType.transfer) {
      await _acceptTransfer(request, user);
    }
  }

  Future reject(Request request, User user) async {
    // TODO: implement reject
    await _stubOperation("Reject");
  }

  Future _acceptBorrow(Request request, User user) async {
    // TODO: perform borrowing
    await _stubOperation("Accept borrow");
  }

  Future _acceptExtend(Request request, User user) async {
    // TODO: perform extending
    await _stubOperation("Accept extend");
  }

  Future _acceptTransfer(Request request, User user) async {
    // TODO: perform transferring
    await _stubOperation("Accept transfer");
  }

  Future _stubOperation(String operationName) async {
    print('Performing operation: $operationName');
    await Future.delayed(const Duration(seconds: 2));
  }

}
