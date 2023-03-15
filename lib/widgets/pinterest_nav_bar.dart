import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PinterestButton {
  final Function() onPressed;
  final IconData icon;

  PinterestButton({
    required this.onPressed,
    required this.icon,
  });
}

class PinterestButtonDecoration {
  final Color backgroundColor; // Background color of the button.
  final Color activeColor; // active color of the button.
  final Color inactiveColor; // inactive color of the button.

  PinterestButtonDecoration(
      {required this.backgroundColor,
      required this.activeColor,
      required this.inactiveColor});
}

// ignore: must_be_immutable
class PinterestNavBar extends StatelessWidget {
  final bool show;
  final List<PinterestButton> items;

  // final List<PinterestButton> items = [
  //   PinterestButton(
  //       onPressed: () => debugPrint("Icon pie_chart"), icon: Icons.pie_chart),
  //   PinterestButton(
  //       onPressed: () => debugPrint("Icon search"), icon: Icons.search),
  //   PinterestButton(
  //       onPressed: () => debugPrint("Icon notifications"),
  //       icon: Icons.notifications),
  //   PinterestButton(
  //       onPressed: () => debugPrint("Icon supervise_user_circle"),
  //       icon: Icons.supervised_user_circle),
  // ];

  late PinterestButtonDecoration decoration;

  PinterestNavBar({
    super.key,
    required this.items,
    this.show = true,
    Color backgroundColor = Colors.white,
    Color activeColor = Colors.black,
    Color inactiveColor = Colors.blueGrey,
  }) {
    decoration = PinterestButtonDecoration(
        backgroundColor: backgroundColor,
        activeColor: activeColor,
        inactiveColor: inactiveColor);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => _MenuModel(),
        child: Builder(builder: (context) {
          Provider.of<_MenuModel>(context, listen: false).decoration =
              decoration;
          return _PinterestMenuBackground(items: items, show: show);
        }));
  }
}

class _PinterestMenuBackground extends StatelessWidget {
  final List<PinterestButton> items;
  final bool show;

  const _PinterestMenuBackground({required this.items, required this.show});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Provider.of<_MenuModel>(context, listen: false)
        .decoration
        .backgroundColor;

    return AnimatedOpacity(
      opacity: show ? 1 : 0,
      duration: const Duration(milliseconds: 250),
      child: Container(
        width: 250,
        height: 60,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(100),
            boxShadow: const <BoxShadow>[
              BoxShadow(color: Colors.black38, blurRadius: 10, spreadRadius: -5)
            ]),
        child: _MenuItems(items),
      ),
    );
  }
}

class _MenuItems extends StatelessWidget {
  final List<PinterestButton> menuItems;

  const _MenuItems(this.menuItems);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(menuItems.length,
          (index) => _PinterestMenuButton(index, menuItems[index])),
    );
  }
}

class _PinterestMenuButton extends StatelessWidget {
  final PinterestButton item;
  final int index;

  const _PinterestMenuButton(this.index, this.item);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<_MenuModel>(context);
    final selectedItem = provider.selectedItem;
    final decoration = provider.decoration;

    return GestureDetector(
        onTap: () {
          provider.selectedItem = index;
          item.onPressed();
        },
        behavior: HitTestBehavior.translucent,
        child: Icon(item.icon,
            size: selectedItem == index ? 35 : 25,
            color: selectedItem == index
                ? decoration.activeColor
                : decoration.inactiveColor));
  }
}

class _MenuModel with ChangeNotifier {
  int _selectedItem = 0;
  late PinterestButtonDecoration decoration;

  int get selectedItem => _selectedItem;

  set selectedItem(int index) {
    _selectedItem = index;
    notifyListeners();
  }
}
