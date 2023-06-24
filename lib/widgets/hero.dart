import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class HeroLogo extends StatelessWidget {
  const HeroLogo({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: const Alignment(0, 0),
      children: [
        Lottie.asset(
          'assets/lottie/welcome.json',
        ),
        //! Cannot import svg files using Image.asset(). Needs flutter_svg package
        SvgPicture.asset(
          'assets/icons/logo_white.svg',
          height: 125,
          width: 125,
        )
      ],
    );
  }
}
