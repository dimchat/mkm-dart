/* license: https://mit-license.org
 * =============================================================================
 * The MIT License (MIT)
 *
 * Copyright (c) 2023 Albert Moky
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 * =============================================================================
 */
import 'chars.dart';

abstract class Stringer implements Comparable<String>, Pattern, CharSequence {

  /*
  /// A hash code derived from the code units of the string.
  ///
  /// This is compatible with [operator ==]. Strings with the same sequence
  /// of code units have the same hash code.
  @override
  int get hashCode;

  /// Whether [other] is a `String` with the same sequence of code units.
  ///
  /// This method compares each individual code unit of the strings.
  /// It does not check for Unicode equivalence.
  /// For example, both the following strings represent the string 'Amélie',
  /// but due to their different encoding, are not equal:
  /// ```dart
  /// 'Am\xe9lie' == 'Ame\u{301}lie'; // false
  /// ```
  /// The first string encodes 'é' as a single unicode code unit (also
  /// a single rune), whereas the second string encodes it as 'e' with the
  /// combining accent character '◌́'.
  @override
  bool operator ==(Object other);

  /// A string representation of this object.
  ///
  /// Some classes have a default textual representation,
  /// often paired with a static `parse` function (like [int.parse]).
  /// These classes will provide the textual representation as
  /// their string representation.
  ///
  /// Other classes have no meaningful textual representation
  /// that a program will care about.
  /// Such classes will typically override `toString` to provide
  /// useful information when inspecting the object,
  /// mainly for debugging or logging.
  @override
  external String toString();
   */

  /// toString()
  String get string;

  /*
  /// The length of the string.
  ///
  /// Returns the number of UTF-16 code units in this string. The number
  /// of [runes] might be fewer if the string contains characters outside
  /// the Basic Multilingual Plane (plane 0):
  /// ```dart
  /// 'Dart'.length;          // 4
  /// 'Dart'.runes.length;    // 4
  ///
  /// var clef = '\u{1D11E}';
  /// clef.length;            // 2
  /// clef.runes.length;      // 1
  /// ```
  int get length;

  /// Whether this string is empty.
  bool get isEmpty;

  /// Whether this string is not empty.
  bool get isNotEmpty;
   */
}

class ConstantString implements Stringer {

  final String _str;

  ConstantString(Object string)
      : _str = string is Stringer ? string.string
      : string as String;

  @override
  String toString() => _str;

  @override
  String get string => _str;

  @override
  bool operator ==(Object other) {
    if (other is Stringer) {
      if (identical(this, other)) {
        // same object
        return true;
      }
      // compare with inner string
      other = other.string;
    }
    return other is String && other == _str;
  }

  @override
  int get hashCode => _str.hashCode;

  @override
  int get length => _str.length;

  @override
  bool get isEmpty => _str.isEmpty;

  @override
  bool get isNotEmpty => _str.isNotEmpty;

  @override
  int compareTo(String other) => _str.compareTo(other);

  //
  //  CharSequence
  //

  @override
  String operator [](int index) => _str[index];

  @override
  int codeUnitAt(int index) => _str.codeUnitAt(index);

  @override
  bool endsWith(String other) => _str.endsWith(other);

  @override
  bool startsWith(Pattern pattern, [int index = 0]) =>
      _str.startsWith(pattern, index);

  @override
  int indexOf(Pattern pattern, [int start = 0]) => _str.indexOf(pattern, start);

  @override
  int lastIndexOf(Pattern pattern, [int? start]) =>
      _str.lastIndexOf(pattern, start);

  @override
  String operator +(String other) => _str + other;

  @override
  String substring(int start, [int? end]) => _str.substring(start, end);

  @override
  String trim() => _str.trim();

  @override
  String trimLeft() => _str.trimLeft();

  @override
  String trimRight() => _str.trimRight();

  @override
  String operator *(int times) => _str * times;

  @override
  String padLeft(int width, [String padding = ' ']) =>
      _str.padLeft(width, padding);

  @override
  String padRight(int width, [String padding = ' ']) =>
      _str.padRight(width, padding);

  @override
  bool contains(Pattern other, [int startIndex = 0]) =>
      _str.contains(other, startIndex);

  @override
  String replaceFirst(Pattern from, String to, [int startIndex = 0]) =>
      _str.replaceFirst(from, to, startIndex);

  @override
  String replaceFirstMapped(Pattern from, String Function(Match match) replace,
      [int startIndex = 0]) =>
      _str.replaceFirstMapped(from, replace, startIndex);

  @override
  String replaceAll(Pattern from, String replace) =>
      _str.replaceAll(from, replace);

  @override
  String replaceAllMapped(Pattern from, String Function(Match match) replace) =>
      _str.replaceAllMapped(from, replace);

  @override
  String replaceRange(int start, int? end, String replacement) =>
      _str.replaceRange(start, end, replacement);

  @override
  List<String> split(Pattern pattern) => _str.split(pattern);

  @override
  String splitMapJoin(Pattern pattern,
      {String Function(Match)? onMatch, String Function(String)? onNonMatch}) =>
      _str.splitMapJoin(pattern, onMatch: onMatch, onNonMatch: onNonMatch);

  @override
  List<int> get codeUnits => _str.codeUnits;

  @override
  Runes get runes => _str.runes;

  @override
  String toLowerCase() => _str.toLowerCase();

  @override
  String toUpperCase() => _str.toUpperCase();

  //
  //  Pattern
  //

  @override
  Iterable<Match> allMatches(String string, [int start = 0]) =>
      _str.allMatches(string, start);

  @override
  Match? matchAsPrefix(String string, [int start = 0]) =>
      _str.matchAsPrefix(string, start);
}
