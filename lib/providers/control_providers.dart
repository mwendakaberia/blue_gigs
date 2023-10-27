import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final theme=StateProvider((ref)=>ThemeMode.light).state;

var profile_provider = StateProvider((ref) => 0).state;

var role_provider = StateProvider.autoDispose((ref) => "").state;

