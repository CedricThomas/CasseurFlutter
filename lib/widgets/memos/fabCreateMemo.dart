import 'package:casseurflutter/blocs/memos/memos.dart';
import 'package:casseurflutter/views/CreateMemo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FabCreateMemo extends StatefulWidget {
  const FabCreateMemo();

  @override
  _FabCreateMemo createState() => _FabCreateMemo();
}

class _FabCreateMemo extends State<FabCreateMemo> {
  final GlobalKey _fabKey = GlobalKey();
  bool _fabVisible = true;

  final Duration duration = const Duration(milliseconds: 300);

  void _onFabTap(BuildContext context) {
    setState(() => _fabVisible = false);

    final RenderBox fabRenderBox =
        _fabKey.currentContext.findRenderObject() as RenderBox;
    final Size fabSize = fabRenderBox.size;
    final Offset fabOffset = fabRenderBox.localToGlobal(Offset.zero);
    final MemosBloc memosBloc = BlocProvider.of<MemosBloc>(context);

    Navigator.of(context)
        .push(
          PageRouteBuilder<CreateMemo>(
            transitionDuration: duration,
            pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                CreateMemo(),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                _buildTransition(child, animation, fabSize, fabOffset),
          ),
        )
        .then(
          (CreateMemo value) => <void>{
            setState(
              () {
                _fabVisible = true;
                memosBloc.add(FetchMemos());
              },
            )
          },
        );
  }

  Widget _buildTransition(
    Widget page,
    Animation<double> animation,
    Size fabSize,
    Offset fabOffset,
  ) {
    if (animation.value == 1) {
      return page;
    }

    final BorderRadiusTween borderTween = BorderRadiusTween(
      begin: BorderRadius.circular(fabSize.width / 2),
      end: BorderRadius.circular(0.0),
    );
    final SizeTween sizeTween = SizeTween(
      begin: fabSize,
      end: MediaQuery.of(context).size,
    );
    final Tween<Offset> offsetTween = Tween<Offset>(
      begin: fabOffset,
      end: Offset.zero,
    );

    final CurvedAnimation easeInAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeIn,
    );
    final CurvedAnimation easeAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    );

    final BorderRadius radius = borderTween.evaluate(easeInAnimation);
    final Offset offset = offsetTween.evaluate(animation);
    final Size size = sizeTween.evaluate(easeInAnimation);

    final Widget transitionFab = Opacity(
      opacity: 1 - easeAnimation.value,
      child: _buildFab(context),
    );

    Widget positionedClippedChild(Widget child) => Positioned(
        width: size.width,
        height: size.height,
        left: offset.dx,
        top: offset.dy,
        child: ClipRRect(
          borderRadius: radius,
          child: child,
        ));

    return Stack(
      children: <Widget>[
        positionedClippedChild(page),
        positionedClippedChild(transitionFab),
      ],
    );
  }

  Widget _buildFab(BuildContext context, {Key key}) => FloatingActionButton(
        key: key,
        onPressed: () {
          _onFabTap(context);
        },
        child: const Icon(Icons.add),
      );

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _fabVisible,
      child: _buildFab(context, key: _fabKey),
    );
  }
}
