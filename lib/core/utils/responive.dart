import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../sidebar.dart';

class ResponsiveLayoutShell extends StatefulWidget {
  final Widget child;
  final String currentRoute;

  const ResponsiveLayoutShell({
    Key? key,
    required this.child,
    required this.currentRoute,
  }) : super(key: key);

  @override
  State<ResponsiveLayoutShell> createState() => _ResponsiveLayoutShellState();
}

class _ResponsiveLayoutShellState extends State<ResponsiveLayoutShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool get isDesktop => MediaQuery.of(context).size.width >= 900;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: !isDesktop
          ? Drawer(
              width: 260,
              child: SafeArea(
                child: SideBar(currentRoute: widget.currentRoute),
              ),
            )
          : null,
      appBar: !isDesktop
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 2,
              leading: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black87),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              title: const Text(
                'Product Dashboard',
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w600),
              ),
              centerTitle: true,
            )
          : null,
      body: Row(
        children: [
          if (isDesktop)
            SizedBox(
              width: 260,
              child: SideBar(currentRoute: widget.currentRoute),
            ),
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
