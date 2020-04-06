import 'package:flutter/material.dart';

class RoundedShape extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const RoundedShape({
    this.padding,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding == null ? EdgeInsets.fromLTRB(0, 0, 0, 0) : padding,
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          border: Border.all(
            width: 1,
            color: Theme.of(context).hintColor,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          )
      ),
      child: child,
    );
//    return SizedBox(
//      width: double.infinity,
//      height: 50.0,
//      child: RaisedButton(
//        elevation: 5,
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(10.0),
//          //side: BorderSide(color: Colors.white),
//        ),
//        color: Theme.of(context).backgroundColor,
//        child: child == null ?
//        Text(
//          text,
//          style: Theme.of(context).textTheme.body2,
//        ) :
//        child,
//        onPressed: onPressed,
//      ),
//    );
  }

}