import 'dart:ui';

import 'package:zos/utils/margin.dart';
import 'package:zos/utils/navigator.dart';
import 'package:zos/utils/theme.dart';
import 'package:zos/views/home.dart';
import 'package:zos/widget/spring_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Hero(
            tag:'bg',
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
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  width: context.screenWidth(0.19),
                  height: context.screenWidth(0.23),
                  color: Colors.white.withOpacity(0.7),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const YMargin(40),
                      SpringButton(
                        onTap: (){},
                                              child: CircleAvatar(
                          radius: 42,
                          backgroundImage:
                              ExactAssetImage('assets/images/chizi.png'),
                        ),
                      ),
                      const YMargin(20),
                      Text(
                        'Chiziaruhoma',
                        style: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: black),
                      ),
                      const YMargin(5),
                      Text(
                        'Change user',
                        style: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.w300,
                            fontSize: 11,
                            color: Colors.grey[600]),
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: white.withOpacity(0.6)),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          showCursor: false,
                          obscureText: true,
                          style: GoogleFonts.ubuntu(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: Colors.grey[600]),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: InputBorder.none,
                            hintStyle: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                color: Colors.grey[500]),
                            suffix: GestureDetector(
                              child: Icon(
                                FeatherIcons.arrowRight,
                                size: 12,
                              ),
                              onTap: () {
                                navigate(context, HomePage());
                              },
                            ),
                          ),
                        ),
                      ),
                      const YMargin(30),
                    ],
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
