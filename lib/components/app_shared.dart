import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';

// class AppScalingText extends StatelessWidget {

//   final String text;

//   const AppScalingText(this.text, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ScalingText(
//       text,
//       style: kProgressTextStyle,
//     );
//   }
// }

class AppActivityIndicator extends StatelessWidget {

  const AppActivityIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoActivityIndicator(
      color: kPrimaryColor,
    );
  }
}

class AppLoadMoreIndicator extends StatelessWidget {

  const AppLoadMoreIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(
        color: kPrimaryColor,
      ),
    );
  }
}

class AppElevatedButton extends StatelessWidget {

  final void Function()? onPressed;
  final String text;

  const AppElevatedButton({
    super.key,
    this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      ),
      child: Text(
        text,
        style: kTextStyle1.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class AppOutlinedButton extends StatelessWidget {

  final void Function()? onPressed;
  final String text;

  const AppOutlinedButton({
    super.key,
    this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: kTextColor2,
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        side: const BorderSide(
          color: Color(0xFFDBDBDB),
        ),
      ),
      child: Text(
        text,
        style: kTextStyle1.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class AppOutlinedButtonSm extends StatelessWidget {

  final void Function()? onPressed;
  final String text;

  const AppOutlinedButtonSm({
    super.key,
    this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: kTextColor2,
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 32.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        side: const BorderSide(
          color: Color(0xFFDBDBDB),
        ),
      ),
      child: Text(
        text,
        style: kTextStyle1.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}