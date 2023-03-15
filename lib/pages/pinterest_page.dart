import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../widgets/pinterest_nav_bar.dart';

class PinterestPage extends StatelessWidget {
  const PinterestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider(
        create: (_) => _MenuModel(),
        child: Scaffold(
            body: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: PinterestGrid(),
            ),
            _NavBar(),
          ],
        )),
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final show = Provider.of<_MenuModel>(context).show;
    return Positioned(
      bottom: 30,
      child: SizedBox(
        width: width,
        child: Align(
          child: PinterestNavBar(
            show: show,
            items: [
              PinterestButton(
                  onPressed: () => debugPrint("Icon pie_chart"),
                  icon: Icons.pie_chart),
              PinterestButton(
                  onPressed: () => debugPrint("Icon search"),
                  icon: Icons.search),
              PinterestButton(
                  onPressed: () => debugPrint("Icon notifications"),
                  icon: Icons.notifications),
              PinterestButton(
                  onPressed: () => debugPrint("Icon supervise_user_circle"),
                  icon: Icons.supervised_user_circle),
            ],
          ),
        ),
      ),
    );
  }
}

class PinterestGrid extends StatefulWidget {
  const PinterestGrid({super.key});

  @override
  State<PinterestGrid> createState() => _PinterestGridState();
}

class _PinterestGridState extends State<PinterestGrid> {
  final List items = List.generate(200, (index) => index);
  final ScrollController scrollController = ScrollController();
  double previousScroll = 0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.offset > previousScroll) {
        Provider.of<_MenuModel>(context, listen: false).show = false;
      } else {
        Provider.of<_MenuModel>(context, listen: false).show = true;
      }

      previousScroll = scrollController.offset;
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      padding: const EdgeInsets.only(top: 5.0),
      controller: scrollController,
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _PinterestItem(
          index,
        );
      },
      staggeredTileBuilder: (int index) {
        return StaggeredTile.count(2, index.isEven ? 2 : 3);
      },
    );
  }
}

// ignore: must_be_immutable
class _PinterestItem extends StatelessWidget {
  final int index;

  const _PinterestItem(
    this.index,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text('$index'),
        ),
      ),
    );
  }
}

class _MenuModel with ChangeNotifier {
  bool _show = true;

  bool get show => _show;
  set show(value) {
    _show = value;
    notifyListeners();
  }
}
