import 'package:flutter/material.dart';

abstract class IWidgetNotification {
  Widget build(BuildContext context, dynamic parameter);
  call(dynamic parameter);
}
