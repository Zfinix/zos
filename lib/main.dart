import 'dart:io';

import 'package:zos/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/providers.dart';
import 'drop_target.dart';
import 'views/login.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData(context),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class HomePage extends StatefulHookWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    controllerProvider.read(context).init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DropNotifier(
        child: StreamBuilder<List<File>>(
          stream: DropTarget.instance.dropped,
          initialData: [],
          builder: (context, snapshot) {
            return Container(
              height: 400,
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...snapshot.data.map((file) => Image.file(file, scale: 5)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class DropNotifier extends StatelessWidget {
  final Widget child;

  const DropNotifier({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: DropTarget.instance,
      builder: (context, value, child) {
        return Stack(
          children: [
            child,
            AnimatedContainer(
              duration: Duration(milliseconds: 250),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: value ? Colors.grey[300] : Colors.transparent,
                  width: 1,
                ),
              ),
            ),
          ],
        );
      },
      child: child,
    );
  }
}
