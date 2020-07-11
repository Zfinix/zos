import 'dart:io';
import 'dart:ui';

import 'package:zos/core/providers.dart';
import 'package:zos/core/viewmodels/controller_vm.dart';
import 'package:zos/utils/margin.dart';
import 'package:zos/utils/theme.dart';
import 'package:zos/widget/spring_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;

import '../drop_target.dart';
import '../main.dart';

class HomePage extends StatefulHookWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    controllerProvider.read(context).listenToDrop();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onSecondaryTapDown: (v) {
          showDialog(
            barrierDismissible: true,
            context: context,
            barrierColor: Colors.white.withOpacity(0.0),
            builder: (BuildContext context) {
              return Transform(
                transform: Matrix4.translationValues(
                  v.globalPosition.dx - 520,
                  v.globalPosition.dy - 240,
                  0.0,
                ),
                child: Dialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                          child: Container(
                            width: context.screenWidth(0.06),
                            height: context.screenWidth(0.235),
                            color: Colors.white.withOpacity(0.6),
                            padding: EdgeInsets.all(25),
                            child: Column(
                              children: <Widget>[
                                MenuButton(
                                  title: 'New Folder',
                                  icon: FeatherIcons.folder,
                                ),
                                const YMargin(25),
                                MenuButton(
                                  title: 'Properties',
                                  icon: FeatherIcons.settings,
                                ),
                                const YMargin(15),
                                Divider(),
                                const YMargin(10),
                                MenuButton(
                                  title: 'Import',
                                  icon: FeatherIcons.downloadCloud,
                                ),
                                const YMargin(10),
                                Divider(),
                                const YMargin(15),
                                MenuButton(
                                  title: 'Insert',
                                  icon: FeatherIcons.clipboard,
                                ),
                                const YMargin(25),
                                MenuButton(
                                  title: 'Copy',
                                  icon: FeatherIcons.copy,
                                ),
                                const YMargin(25),
                                MenuButton(
                                  title: 'Sort',
                                  icon: FeatherIcons.filter,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Stack(
          children: [
            Hero(
              tag: 'bg',
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: ExactAssetImage('assets/images/chizi.jpeg'),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            BottomBar()
          ],
        ),
      ),
    );
  }
}

class BottomBar extends HookWidget {
  const BottomBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var prov = useProvider(controllerProvider);
    return Column(
      children: [
        Spacer(),
        Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTapDown: (v) {
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    barrierColor: Colors.white.withOpacity(0.0),
                    builder: (BuildContext context) {
                      return SystemMenu();
                    },
                  );
                },
                child: SvgPicture.asset(
                  'assets/images/windows.svg',
                  height: 24,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const XMargin(25),
              Container(
                height: 25,
                width: 1,
                color: Colors.white24,
              ),
              const XMargin(25),
              SpringButton(
                onTap: () {
                  prov.open('/Applications/Safari.app');
                },
                child: Image.file(
                  File('./apps/Safari.app.png'),
                  height: 76,
                ),
              ),
              const XMargin(25),
              SpringButton(
                onTap: () {
                  prov.open('/Applications/InVisionStudio.app');
                },
                child: Image.file(
                  File('./apps/InVisionStudio.app.png'),
                  height: 37,
                ),
              ),
              const XMargin(25),
              SpringButton(
                onTap: () {
                  prov.open('/Applications/zoom.us.app');
                },
                child: Image.file(
                  File('./apps/zoom.us.app.png'),
                  height: 37,
                ),
              ),
              Spacer(),
              SpringButton(
                onTap: () {},
                child: SvgPicture.asset(
                  'assets/images/battery.svg',
                  height: 20,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const XMargin(25),
              Text(
                'Sat 11, 1:52',
                style: GoogleFonts.ubuntu(
                    fontWeight: FontWeight.w300, fontSize: 11, color: white),
              ),
            ],
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black12,
                  Colors.black,
                ],
                stops: [
                  0.19,
                  1
                ]),
          ),
        )
      ],
    );
  }
}

class SystemMenu extends HookWidget {
  const SystemMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var prov = useProvider(controllerProvider);

    return Stack(
      children: [
        Positioned(
          left: 0,
          bottom: 40,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                child: Container(
                  width: context.screenWidth(0.6),
                  height: context.screenWidth(0.4),
                  color: Colors.white.withOpacity(0.7),
                  padding: EdgeInsets.fromLTRB(35, 35, 35, 0),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Applications',
                                  style: GoogleFonts.ubuntu(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: black,
                                  ),
                                ),
                              ],
                            ),
                            const YMargin(20),
                            buildApps(prov),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 35),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.white.withOpacity(0.9),
                              padding: EdgeInsets.all(30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'System',
                                    style: GoogleFonts.ubuntu(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: black,
                                    ),
                                  ),
                                  const YMargin(55),
                                  MenuButton(
                                    title: 'Settings',
                                    icon: FeatherIcons.settings,
                                  ),
                                  const YMargin(25),
                                  MenuButton(
                                    title: 'Appearance',
                                    icon: FeatherIcons.edit,
                                  ),
                                  const YMargin(25),
                                  MenuButton(
                                    title: 'Software',
                                    icon: FeatherIcons.box,
                                  ),
                                  const YMargin(25),
                                  MenuButton(
                                    title: 'Logout',
                                    icon: FeatherIcons.logOut,
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      SpringButton(
                                        onTap: () {},
                                        child: CircleAvatar(
                                          radius: 19,
                                          backgroundImage: ExactAssetImage(
                                              'assets/images/chizi.png'),
                                        ),
                                      ),
                                      const XMargin(15),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Chiziaruhoma',
                                            style: GoogleFonts.ubuntu(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                                color: black),
                                          ),
                                          const YMargin(3),
                                          Text(
                                            'Chiziaruhoma@gmail.com',
                                            style: GoogleFonts.ubuntu(
                                                fontWeight: FontWeight.w200,
                                                fontSize: 9,
                                                color: Colors.grey[400]),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
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
            ),
          ),
        ),
      ],
    );
  }

  buildApps(ControllerVM prov) {
    return Expanded(
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 35, top: 10),
            child: DropNotifier(
              child: StreamBuilder<List<File>>(
                stream: DropTarget.instance.dropped,
                initialData: [],
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 6.0,
                          mainAxisSpacing: 6,
                        ),
                        itemCount: prov?.appPathList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return AppItems(prov?.appPathList[index]);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const YMargin(30)
        ],
      ),
    );
  }
}

class AppItems extends HookWidget {
  final String app;

  const AppItems(this.app);
  @override
  Widget build(BuildContext context) {
    var prov = useProvider(controllerProvider);
    var path = p.join('./apps', p.basename(app)).replaceAll(' ', '') + '.png';
    return SpringButton(
      onTap: () {
        prov.open(app);
      },
      child: Material(
        color: Colors.transparent,
        child: Container(
          alignment: Alignment.center,
          child: Column(children: [
            if (File(path).existsSync())
              Image.file(
                File(path),
                height: 60,
              ),
            const YMargin(5),
            Text(
              p.basename(app).replaceAll('.app', ''),
              textAlign: TextAlign.center,
              style: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.w500,
                  fontSize: 9,
                  color: Colors.grey[900]),
            ),
          ]),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({
    Key key,
    @required this.icon,
    @required this.title,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final Function onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SpringButton(
      onTap: onTap ?? () {},
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
          ),
          const XMargin(15),
          Text(
            title ?? '',
            style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.w400, fontSize: 12, color: black),
          ),
        ],
      ),
    );
  }
}
