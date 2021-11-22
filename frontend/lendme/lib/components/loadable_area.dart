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
  LoadableArea(
      {
        this.controller,
        required this.child,
        this.initialState = LoadableAreaState.main,
      }
    ) : super(key: UniqueKey());

  final LoadableAreaController? controller;
  final Widget child;
  final LoadableAreaState initialState;

  @override
  _LoadableAreaState createState() => _LoadableAreaState();
}

class _LoadableAreaState extends State<LoadableArea> {

  late LoadableAreaState _state;

  @override
  void initState() {
    _state = widget.initialState;
    widget.controller?.addListener(_stateListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: _state == LoadableAreaState.main || _state == LoadableAreaState.pending,
          child: IgnorePointer(
            ignoring: _state == LoadableAreaState.pending,
            child: widget.child,
          ),
        ),
        Visibility(
          visible: _state == LoadableAreaState.pending,
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        Visibility(
          visible: _state == LoadableAreaState.loading || _state == LoadableAreaState.pending,
          child: const Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                strokeWidth: 10.0,
              ),
            ),
          ),
        ),
        Visibility(
          visible: _state == LoadableAreaState.failure,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.warning_rounded,
                  size: 200,
                ),
                Text("Error occurred")
              ],
            ),
          ),
        )
      ],
    );
  }

  void _stateListener() {
    setState(() {
      final controller = widget.controller;
      if(controller != null) {
        _state = controller._state;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.removeListener(_stateListener);
  }
}
