import 'package:flutter/cupertino.dart';

Size getArea(BuildContext context, {final Size offset = Size.zero}) {
  final Size size = MediaQuery.of(context).size;
  return Size(size.width - offset.width, size.height - offset.height);
}

Size getSafeArea(BuildContext context, {final Size offset = Size.zero}) {
  final MediaQueryData data = MediaQuery.of(context);
  return Size(
      data.size.width - offset.width,
      data.size.height -
          data.padding.top -
          data.padding.bottom -
          offset.height);
}
