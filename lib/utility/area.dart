import 'package:flutter/cupertino.dart';

Size getArea(BuildContext context,
    {final Size offset = Size.zero, final double scale = 1.0}) {
  final size = MediaQuery.of(context).size;
  return Size((size.width - offset.width) * scale,
      (size.height - offset.height) * scale);
}

Size getSafeArea(BuildContext context,
    {final Size offset = Size.zero, final double scale = 1.0}) {
  final data = MediaQuery.of(context);
  return Size(
      (data.size.width - offset.width) * scale,
      (data.size.height -
              data.padding.top -
              data.padding.bottom -
              offset.height) *
          scale);
}
