import 'package:flutter/material.dart';

enum LoadableAreaState {
  loading, pending, main, failure
}

class LoadableAreaController extends ChangeNotifier {

  LoadableAreaState _state = LoadableAreaState.main;

  void setState(LoadableAreaState state) {
    _state = state;
    notifyListeners();
  }
}

class LoadableArea extends StatefulWidget {
  const LoadableArea(
      {
        required this.controller,
        required this.child,
        this.initialState = LoadableAreaState.main,
        Key? key
      }
    ) : super(key: key);

  final LoadableAreaController controller;
  final Widget child;
  final LoadableAreaState initialState;

  @override
  _LoadableAreaState createState() => _LoadableAreaState();
}

class _LoadableAreaState extends State<LoadableArea> {

  late LoadableAreaState _state;
  late Map<LoadableAreaState, Widget> _views;

  @override
  void initState() {
    _state = widget.initialState;

    _views = {
      LoadableAreaState.main: widget.child,
      LoadableAreaState.loading: const _LoadingView(),
      LoadableAreaState.pending: const _PendingView(),
      LoadableAreaState.failure: const _FailureView(),
    };

    widget.controller.addListener(() {
      setState(() {
        _state = widget.controller._state;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _views[_state]!;
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 200,
      height: 200,
      child: CircularProgressIndicator(
        strokeWidth: 10.0,
      ),
    );
  }
}

class _PendingView extends StatelessWidget {
  const _PendingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Pending"),
    );
  }
}

class _FailureView extends StatelessWidget {
  const _FailureView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Failure"),
    );
  }
}