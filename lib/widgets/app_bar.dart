import 'package:flutter/material.dart';
import 'package:plants/utils/shift_color.dart';

const double headerHeight = 106;
const double bottomHeight = 32.0 * 2 + 3;

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController _searchController = TextEditingController();
  final Color color;

  MainAppBar({
    Key key,
    this.color = const Color(0xFF326544),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(bottomHeight),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: color),
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      fillColor: color,
                      hintText: 'Поиск',
                      hintStyle: TextStyle(color: shiftColorLuminance(color, 50)),
                      icon: Icon(
                        Icons.search,
                        color: color,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _searchController.clear,
                  child: Icon(
                    Icons.close,
                    color: color,
                  ),
                )
              ],
            ),
            Row(),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(headerHeight + bottomHeight);
}
