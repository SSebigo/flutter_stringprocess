// Copyright (c) 2020, SSebigo. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'dart:math';

import 'package:markdown/markdown.dart' as md;
import 'package:html_unescape/html_unescape.dart';

/// @nodoc
const unixNewline = '\n';

/// @nodoc
const windowsNewline = '\r\n';

/// @nodoc
const carriageReturn = '\r';

///String Processor - that's the theory.
class StringProcessor {
  ///Trim the supplied [String].
  String trimText(String src) {
    return src.trim();
  }

  ///Returns a [String] with each line trimmed.
  String trimLines(String text) {
    final segments = getSegments(text);
    var out = '';

    for (var i = 0; i < segments.length; i++) {
      out += segments[i].trim();
      if (i < (segments.length - 1)) {
        out += unixNewline;
      }
    }
    return out;
  }

  ///Calculate the Word Count for the [String].
  int getWordCount(String text) {
    var workingText = text;
    workingText = workingText
      ..replaceAll(unixNewline, ' ')
      ..replaceAll('.', ' ')
      ..replaceAll(',', ' ')
      ..replaceAll(':', ' ')
      ..replaceAll(';', ' ')
      ..replaceAll('?', ' ');
    final words = workingText.split(' ')
      ..removeWhere((word) => word.isEmpty || word == ' ');
    return min(words.length, text.length);
  }

  ///Count the number of lines in the [String] text.
  int getLineCount(String text) {
    return unixNewline.allMatches(text).length;
  }

  ///Count the number of sentences in the [String] text.
  int getSentenceCount(String text) {
    final processedText =
        text.replaceAll('!', '.').replaceAll('?', '.').replaceAll('...', '.');
    final sentences = denumber(processedText).split('.');
    var sentenceCount = 0;
    for (var i = 0; i < sentences.length; i++) {
      if (sentences[i].trim().length > 1) sentenceCount++;
    }
    return sentenceCount;
  }

  ///Return [String] of supplied text repeated count times.
  String generateRepeatedString(String textToRepeat, num count,
      [bool newLine = false]) {
    count ??= 1;

    return newLine
        ? (textToRepeat + unixNewline) * count.toInt()
        : textToRepeat * count.toInt();
  }

  ///Returns a [String] made from content with all occurances of target
  ///replaced by replacement.
  String getReplaced(String content, String target, String replacement) {
    return content.replaceAll(target, replacement);
  }

  ///Returns a [String] alphabetically sorted.
  ///If multiline then split is by line.
  ///If single line then split is by space character.
  String sort(String text) {
    var delimiter = ' ';
    if (text.contains(unixNewline)) {
      delimiter = unixNewline;
    }

    return sortDelimiter(text, delimiter);
  }

  ///Returns a [String] sorted after being split by the supplied delimiter.
  String sortDelimiter(String text, String delimiter) {
    final segments = text.split(delimiter);
    var out = '';
    segments
      ..sort()
      ..forEach((line) => out += line + delimiter);
    return trimText(out);
  }

  ///Returns a [String] of the reverse of the supplied string.
  String reverse(String text) {
    final delimiter = text.contains(unixNewline) ? unixNewline : ' ';
    return reverseDelimiter(text, delimiter);
  }

  ///Returns a [String] reversed after being split by the supplied delimiter.
  String reverseDelimiter(String text, String delimiter) {
    final segments = text.split(delimiter);
    var out = '';

    for (final line in segments.reversed) {
      out += line + delimiter;
    }
    return trimText(out);
  }

  ///Returns a [String] with each line having a prefix added.
  String prefixLines(String text, String prefix) {
    final segments = getSegments(text);
    var out = '';
    for (var i = 0; i < segments.length; i++) {
      out += prefix + segments[i];
      if (i < (segments.length - 1)) {
        out += unixNewline;
      }
    }
    return out;
  }

  ///Returns a [String] with each line having a postfix added.
  String postfixLines(String text, String postfix) {
    final segments = getSegments(text);
    var out = '';

    for (var i = 0; i < segments.length; i++) {
      out += segments[i] + postfix;
      if (i < (segments.length - 1)) {
        out += unixNewline;
      }
    }
    return out;
  }

  ///Returns a [String] with each line duplicated.
  String dupeLines(String text) {
    final segments = getSegments(text);
    var out = '';

    for (var i = 0; i < segments.length; i++) {
      out += segments[i] * 2;
      if (i < (segments.length - 1)) {
        out += unixNewline;
      }
    }
    return out;
  }

  ///Returns a [String] with content with spaces instead of tabs.
  String convertTabsToSpace(String text, {int numberOfSpaces = 4}) {
    final spaces = ' ' * numberOfSpaces;
    return text.replaceAll('\t', spaces);
  }

  ///Returns a [String] with all content on a single line.
  String makeOneLine(String text) {
    return text.replaceAll(windowsNewline, '').replaceAll(unixNewline, '');
  }

  ///Returns a [String] with blank lines removed.
  String removeBlankLines(String text) {
    final segments = getSegments(text);
    var out = '';

    for (var i = 0; i < segments.length; i++) {
      if (segments[i].isNotEmpty) {
        out += segments[i];
        if (i < (segments.length - 1) && text.contains(unixNewline)) {
          out += unixNewline;
        }
      }
    }

    return out;
  }

  ///Returns a [String] with double blank lines reduced to single blank lines.
  String removeExtraBlankLines(String text) {
    while (text.contains('\n\n\n')) {
      text = text.replaceAll('\n\n\n', '\n\n');
    }

    return text;
  }

  ///Returns a [String] with lines double spaced.
  String doubleSpaceLines(String text) {
    return text.replaceAll(unixNewline, '\n\n');
  }

  ///Returns a [String] with lines in a random order.
  String randomiseLines(String text) {
    final segments = getSegments(text)..shuffle();
    var out = '';

    for (var i = 0; i < segments.length; i++) {
      if (segments[i].isNotEmpty) out += segments[i];
      if (i < (segments.length - 1)) {
        out += unixNewline;
      }
    }
    return out;
  }

  ///Returns a [String] of a sequence of numbers each on a new line.
  String generateSequenceString(
      num startIndex, num repeatCount, num increment) {
    var out = '';
    var current = startIndex;
    for (var i = 0; i < repeatCount; i++) {
      out += current.round().toString() + unixNewline;
      current += increment;
    }
    return out;
  }

  // ignore: lines_longer_than_80_chars
  ///Returns a [String] with the input lines containing a [target] string removed.
  String deleteLinesContaining(String text, String target) {
    final segments = getSegments(text);
    var out = '';

    for (var i = 0; i < segments.length; i++) {
      if (segments[i].isNotEmpty &&
          segments[i] != carriageReturn &&
          !segments[i].contains(target)) {
        out += segments[i];
        if (i < (segments.length - 1) && text.contains(unixNewline)) {
          out += unixNewline;
        }
      } else if (segments[i].isEmpty || segments[i] != carriageReturn) {
        out += windowsNewline;
      }
    }

    return out;
  }

  ///URI Encode a string.
  String uriEncode(String text) {
    return Uri.encodeFull(text);
  }

  ///URI Decode a string.
  String uriDecode(String text) {
    return Uri.decodeFull(text);
  }

  ///Return a [String] of the input text with each item (defined by the
  ///delimiter on new line).
  String split(String text, String delimiter) {
    var out = '';
    if (!text.contains(delimiter)) return text;

    text
        .split(delimiter)
        .forEach((String item) => out += '$item$windowsNewline');

    return out;
  }

  ///Return a [String] of Unescaped HTML.
  String htmlUnescape(String text) {
    return (HtmlUnescape()).convert(text);
  }

  ///Return a [String] of HTML converted from the input Markdown.
  String convertMarkdownToHtml(String content) {
    return md.markdownToHtml(content, extensionSet: md.ExtensionSet.commonMark);
  }

  // ignore: lines_longer_than_80_chars
  ///Returns a [String] with the input lines containing a [target] string removed.
  String deleteLinesNotContaining(String text, String target) {
    final segments = getSegments(text);
    var out = '';

    for (var i = 0; i < segments.length; i++) {
      if (segments[i].isNotEmpty &&
          segments[i] != carriageReturn &&
          segments[i].contains(target)) {
        out += segments[i];
        if (i < (segments.length - 1) && text.contains(unixNewline)) {
          out += unixNewline;
        }
      } else if (segments[i].isEmpty || segments[i] != '\r') {
        out += windowsNewline;
      }
    }

    return out;
  }

  ///Returns a [String] with the input lines with content numbered.
  String addNumbering(String text) {
    if (text.isEmpty) {
      return '';
    }
    final segments = getSegments(text);
    var out = '';
    var numberingIndex = 1;
    for (var i = 0; i < segments.length; i++) {
      if (segments[i].isNotEmpty) {
        out += '${'$numberingIndex. '}${segments[i]}$unixNewline';
        numberingIndex++;
      } else if (i + 1 != segments.length) {
        out += segments[i] + unixNewline;
      }
    }

    return out;
  }

  ///Break [String] into segements by line separator.
  List<String> getSegments(String text) {
    return text.split(unixNewline);
  }

  ///Returns a [String] with [leftTrim] characters removed for the left
  ///and [rightTrim] for the right.
  String splice(String text, int leftTrim, [int rightTrim = 0]) {
    var out = '';
    final segments = getSegments(text);

    for (var i = 0; i < segments.length; i++) {
      final line = segments[i];
      final currentLength = line.length;
      if (currentLength <= leftTrim || (line.length - rightTrim) < 1) {
        out += unixNewline;
      } else if (rightTrim > 0) {
        if ((line.length - rightTrim) >= leftTrim)
          out += line.substring(leftTrim, line.length - rightTrim);
        else
          out += unixNewline;
      } else {
        out += line.substring(leftTrim);
      }
      if (text.contains(unixNewline)) {
        out += unixNewline;
      }
    }
    return out;
  }

  ///Returns a [String] with the input multiple spaces all reduced to 1 space.
  String trimAllSpaces(String text) {
    var out = '';
    final segments = getSegments(text);

    for (var i = 0; i < segments.length; i++) {
      var line = '';
      final innerSegments = segments[i].split(' ');
      for (var j = 0; j < innerSegments.length; j++) {
        if (innerSegments[j].trim().isNotEmpty) {
          line += '${innerSegments[j].trim()} ';
        }
      }
      out += line.trim();

      if (i < (segments.length - 1)) {
        out += unixNewline;
      }
    }

    return out;
  }

  ///Returns a [String] with the input lines sorted by length (ascending).
  String sortByLength(String text) {
    var out = '';
    final segments = getSegments(text)
      ..sort((a, b) => a.length.compareTo(b.length));
    for (var i = 0; i < segments.length; i++) {
      out += segments[i] + unixNewline;
    }
    return out;
  }

  ///Returns a [String] with input having 0123456789 removed.
  String denumber(String text) {
    for (var i = 0; i < 10; i++) text = text.replaceAll('$i', '');
    return text;
  }

  ///Returns a [String] with the line that incorporates the index at position
  ///duplicated.
  String duplicateLine(String text, int position) {
    if (position >= text.length) {
      position = text.length - 1;
    }
    if (text.lastIndexOf(unixNewline) == -1 ||
        text[text.length - 1] != unixNewline) {
      text = text + unixNewline;
    }
    var start = max(text.lastIndexOf(unixNewline, position), 0);
    final end = text.indexOf(unixNewline, position);

    if (start == end && position > 0) {
      start = max(text.lastIndexOf(unixNewline, position - 1), 0);
    }

    if (start + 1 < end) {
      final dupe = text.substring(start == 0 ? 0 : start + 1, end);
      text = text.substring(0, start) +
          (start == 0 ? '' : unixNewline) +
          dupe +
          unixNewline +
          dupe +
          text.substring(end);
    }
    return text;
  }
}
