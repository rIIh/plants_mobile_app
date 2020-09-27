import 'package:flutter/material.dart';
import 'package:plants/utils/disposable_cubit.dart';
import 'package:plants/utils/dispose_bag.dart';
import 'package:rxdart/rxdart.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget title;

  const SearchAppBar({Key key, this.title}) : super(key: key);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends DisposableState<SearchAppBar> with SingleTickerProviderStateMixin, DisposeBagMixin {
  AnimationController _controller;
  bool expanded = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          expanded = false;
        });
      }
    });
    super.initState();
  }

  void expand() {
    setState(() {
      expanded = true;
    });
    _controller.forward();
    Rx.timer(null, Duration(seconds: 2)).listen((event) {
      dismiss();
    });
  }

  void dismiss() {
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          AppBar(
            title: widget.title,
            backgroundColor: Colors.white,
            textTheme: Theme.of(context).textTheme,
            iconTheme: Theme.of(context).iconTheme,
            elevation: 0,
            actions: [
              Builder(
                builder: (context) => Opacity(
                  opacity: expanded ? 0 : 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Center(
                      child: GestureDetector(
                        onTap: expand,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          PositionedTransition(
            rect: RelativeRectTween(
              begin: RelativeRect.fromLTRB(constraints.maxWidth - 56, constraints.maxHeight - kToolbarHeight, 0, 0),
              end: RelativeRect.fromLTRB(0, constraints.maxHeight - kToolbarHeight, 0, 0),
            ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutCirc)),
            child: IgnorePointer(
              ignoring: expanded == false,
              child: Opacity(
                opacity: expanded ? 1 : 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.search),
                        ),
                        Expanded(
                          child: TextField(
                            decoration: null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
