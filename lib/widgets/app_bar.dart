import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plants/utils/insert_between.dart';
import 'package:plants/utils/shift_color.dart';
import 'package:plants/widgets/scaled_animated_widget.dart';

const double _plHeaderHeight = 106;
const double _plBottomHeight = 38.0 * 2 + 3;
const double plHorizontalSpacing = 10;
const plPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 6);

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color color;
  final Widget title;
  final List<Widget> Function(BuildContext context) actions;
  final void Function(String text) onQueryChanged;

  MainAppBar({
    Key key,
    this.color,
    this.title,
    this.actions,
    this.onQueryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = this.color ?? Theme.of(context).primaryColor;
    return DefaultTextStyle(
      style: TextStyle(color: color),
      child: IconTheme(
        data: IconThemeData(color: color, size: 20),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: plHorizontalSpacing,
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints.loose(Size.fromHeight(_plHeaderHeight)),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: plPadding,
                    child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(height: 27),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          DefaultTextStyle.merge(
                            style: TextStyle(
                              fontFamily: 'Playfair',
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                            child: title,
                          ),
                          Spacer(),
                          ...actions(context)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              DefaultTextStyle.merge(
                style: GoogleFonts.raleway(),
                child: PreferredSize(
                  preferredSize: Size.fromHeight(_plBottomHeight),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.loose(Size.fromHeight(_plBottomHeight)),
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        shape: Border.symmetric(
                          vertical: BorderSide(
                            style: BorderStyle.solid,
                            color: color,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: plPadding.horizontal / 2),
                              child: SearchBar(
                                onQueryChanged: onQueryChanged,
                                color: color,
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: color,
                          ),
                          Expanded(
                            child: FilterBar(
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(_plHeaderHeight + _plBottomHeight);
}

class SearchBar extends StatefulWidget {
  final void Function(String text) onQueryChanged;
  final Color color;

  const SearchBar({
    Key key,
    this.onQueryChanged,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _searchController;
  bool hasText = false;

  _SearchBarState() {
    _searchController = TextEditingController()
      ..addListener(() {
        _handleChange(_searchController.text);
      });
  }

  void _handleChange(String text) {
    setState(() {
      hasText = text.isNotEmpty;
      print(hasText);
    });
    widget.onQueryChanged?.call(text);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = DefaultTextStyle.of(context);
    return Row(
      children: [
        Icon(
          Icons.search,
        ),
        SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: TextField(
            controller: _searchController,
            style: textTheme.style.merge(TextStyle(color: widget.color)),
            cursorColor: widget.color,
            decoration: InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              fillColor: widget.color,
//              hintText: 'Поиск',
              hintStyle: TextStyle(color: shiftColorLuminance(widget.color, 50)),
            ),
          ),
        ),
        GestureDetector(
          onTap: _searchController.clear,
          child: hasText
              ? ScaledAnimatedWidget(
                  child: Icon(
                    Icons.close,
                  ),
                )
              : ScaledAnimatedWidget(
                  inversed: true,
                  child: Icon(
                    Icons.close,
                  ),
                ),
        )
      ],
    );
  }
}

class FilterBar extends StatefulWidget {
  final Color color;

  const FilterBar({
    Key key,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  List<String> filters = ['Библиотека'];
  int selected = 0;

  select(int target) {
    setState(() {
      selected = target;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                ),
                child: IntrinsicWidth(
                  child: Row(
                    children: insertBetween(
                      VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: widget.color,
                      ),
                      filters
                          .asMap()
                          .entries
                          .map(
                            (entry) => Expanded(
                              child: GestureDetector(
                                onTap: () => select(entry.key),
                                child: Container(
                                  color:
                                      selected == entry.key && filters.length != 1 ? widget.color : Colors.transparent,
                                  padding: EdgeInsets.symmetric(horizontal: plPadding.left),
                                  child: Center(
                                    child: Text(
                                      entry.value.toLowerCase(),
                                      style: TextStyle(
                                          color: selected == entry.key && filters.length != 1
                                              ? Colors.white
                                              : widget.color),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (true || filters.length > 1)
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: widget.color,
          ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: plHorizontalSpacing),
          child: Icon(
            Icons.tune,
            color: widget.color,
          ),
        ),
      ],
    );
  }
}
