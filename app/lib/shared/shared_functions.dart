import 'package:flutter/material.dart';

List<GlobalKey<RefreshIndicatorState>> generateGlobalKeys(int amount) => List.generate(amount, (index) => GlobalKey<RefreshIndicatorState>());

void recordError(error,StackTrace stack) {

}