import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final theme=StateProvider((ref)=>ThemeMode.light).state;

var advert_state_provider = StateProvider.autoDispose((ref) => 0).state;

