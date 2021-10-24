import 'package:flutter/material.dart';

GlobalKey globalKey = GlobalKey();

void main() => runApp(
      MaterialApp(
        home: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ScrollController controller = ScrollController();

  bool _shouldPinned = true;

  GlobalKey _key = GlobalKey();
  double dy = 500;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      checkNeedPinned();
    });
  }

  void checkNeedPinned() {
    BuildContext currentContext;
    if (_key.currentContext == null) {
      return;
    } else {
      currentContext = _key.currentContext!;
    }
    RenderBox renderBox = currentContext.findRenderObject() as RenderBox;
    // offset.dx , offset.dy 就是控件的左上角坐标
    var offset = renderBox.localToGlobal(Offset.zero);
    double offsetY = offset.dy;
    if (_shouldPinned == true && offsetY <= 147) {
      setState(() {
        _shouldPinned = false;
      });
    } else if (_shouldPinned == false && offsetY > 147) {
      setState(() {
        _shouldPinned = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('商品详情'),),
      body: CustomScrollView(
        controller: controller,
        slivers: [
          SliverToBoxAdapter(
              child: Container(
            color: Colors.redAccent,
            height: 470,
            child: const Center(
              child: Text('基本信息'),
            ),
          )),
          _shouldPinned
              ? SliverPersistentHeader(
                delegate: _Header(),
                pinned: _shouldPinned,
              )
              : SliverToBoxAdapter(child: Container()),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                color: Colors.blue,
                height: 500,
                child: const Center(child: Text('相关商品列表'),),
              ),
              !_shouldPinned
                  ? _getHeadRow()
                  : Container(),
              Container(
                key: _key,
                color: Colors.teal,
                height: 500,
                child: const Center(child: Text('商品更多信息'),),
              ),
              Container(
                color: Colors.orange,
                height: 500,
                child: const Center(child: Text('评论列表'),),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _Header extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _getHeadRow();
  }

  @override
  double get maxExtent => 44;

  @override
  double get minExtent => 44;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

Widget _getHeadRow() {
  return Container(
    height: 44,
    color: const Color.fromRGBO(250, 250, 250, 1),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: const [
        Text(
          '相关商品',
          style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1), fontSize: 18),
        ),
      ],
    ),
  );
}
