import 'package:flutter/material.dart';
import 'package:new_mshwar_app_customer/core/app/app_initializer.dart';
import 'package:new_mshwar_app_customer/core/app/app_runner.dart';
import 'package:new_mshwar_app_customer/core/app/env.dart';

void main() async {
  await AppInitializer.init(env: Environment.dev);
  runApp(const AppRunner());
}
