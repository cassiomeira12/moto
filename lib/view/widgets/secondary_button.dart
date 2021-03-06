import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final Widget child;
  final VoidCallback onPressed;

  const SecondaryButton({
    this.text,
    this.child,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: RaisedButton(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          //side: BorderSide(color: Colors.white),
        ),
        color: Theme.of(context).backgroundColor,
        child: child == null ?
          Text(
            text,
            style: Theme.of(context).textTheme.body2,
          ) :
          child,
        onPressed: onPressed,
      ),
    );
  }

}