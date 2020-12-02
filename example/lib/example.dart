// Copyright (c) 2020, SSebigo. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'package:flutter_stringprocess/flutter_stringprocess.dart';

void main() {
  // A few simple examples.
  final tps = StringProcessor();

  // Print the numbers 1 to 10.
  print(tps.generateSequenceString(1, 10, 1));

  // Repeat Something!
  print(tps.generateRepeatedString('Mine!', 42));

  // Word count.
  print(tps.getWordCount('Dart is Awesome and cool!'));

  // Line count.
  print(tps.getLineCount('hello\ngood\nevening\nwelcome!\n'));
}
