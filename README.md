# stringprocess

A string library for common string operations and general text helper functions.

## Disclaimer

This package is a fork of **stringprocess** by Davy Mitchell @daftspaniel that you can find [here](https://gitlab.com/daftspaniel/stringprocess).

This fork is meant to be actively maintained and updated with the latest stable release of the dependencies used in this package.

## Usage

A simple usage example:

    import 'package:flutter_stringprocess/flutter_stringprocess.dart';

    main() {
      // A few simple examples.
      StringProcessor tps = new StringProcessor();

      // Print the numbers 1 to 10.
      print(tps.getSequenceString(1, 10, 1));

      // Repeat Something!
      print(tps.getRepeatedString("Mine!", 42));

      // Word count.
      print(tps.getWordCount("Dart is Awesome and cool!"));

      // Line count.
      print(tps.getLineCount("hello\ngood\nevening\nwelcome!\n"));
    }

## Unit Testing

  + pub run test

## Check source code formatting:
  + dartfmt -n .

## Acknowledgements
This package makes use of the following Dart packages:

  + html_unescape
  + markdown

## Features and bugs

Please file feature requests and bugs!
