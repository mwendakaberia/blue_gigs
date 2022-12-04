import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginShapeClipper extends CustomClipper <Path>{
  @override
  Path getClip(Size size) {

    final Path path=Path();

    path.lineTo(0.0, size.height*.5);
    
    final firstendcoord=Offset(size.width*.33, size.height*.66);
    final firstcontrolcoord=Offset(size.width*.165, size.height*.74);
    path.quadraticBezierTo(firstcontrolcoord.dx, firstcontrolcoord.dy, firstendcoord.dx, firstendcoord.dy);
    
    final secondendcoord=Offset(size.width*.66, size.height*.82);
    final secondcontrolcoord=Offset(size.width*.495, size.height*.58);
    path.quadraticBezierTo(secondcontrolcoord.dx, secondcontrolcoord.dy, secondendcoord.dx, secondendcoord.dy);
    
    final thirdendcoord=Offset(size.width, size.height*.92);
    final thirdcontrolcoord=Offset(size.width*.825, size.height);
    path.quadraticBezierTo(thirdcontrolcoord.dx, thirdcontrolcoord.dy, thirdendcoord.dx, thirdendcoord.dy);

    path.lineTo(size.width, 0.0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;

}