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

abstract class Converter {

  static String? getString(Object? value) {
    if (value == null) {
      return null;
    } else if (value is String) {
      // exactly
      return value;
    } else {
      assert(false, 'not a string value: $value');
      return value.toString();
    }
  }

  /// assume value can be a config string:
  ///     'true', 'false', 'yes', 'no', 'on', 'off', '1', '0', ...
  static bool? getBool(Object? value) {
    if (value == null) {
      return null;
    } else if (value is bool) {
      // exactly
      return value;
    } else if (value is int) {
      assert(value == 1 || value == 0, 'bool value error: $value');
      return value != 0;
    } else if (value is double) {
      assert(false, 'not a bool value: $value');
      return value != 0.0;
    } else if (value is String) {
      if (value.isEmpty) {
        return false;
      }
      String lower = value.toLowerCase();
      if (lower == 'false' || lower == 'no' || lower == 'off' || lower == '0'
          || lower == 'null' || lower == 'undefined') {
        return false;
      }
      assert(lower == 'true' || lower == 'yes' || lower == 'on' || lower == '1',
      'bool value error: $value');
      return true;
    } else {
      assert(false, 'unknown bool value: $value');
      return true;
    }
  }

  static int? getInt(Object? value) {
    if (value == null) {
      return null;
    } else if (value is int) {
      // exactly
      return value;
    } else if (value is num) {  // double
      // assert(false, 'not an int value: $value');
      return value.toInt();
    } else if (value is String) {
      return int.parse(value);
    } else {
      assert(false, 'unknown int value: $value');
      return 0;
    }
  }

  static double? getDouble(Object? value) {
    if (value == null) {
      return null;
    } else if (value is double) {
      // exactly
      return value;
    } else if (value is num) {  // int
      // assert(false, 'not a double value: $value');
      return value.toDouble();
    } else if (value is String) {
      return double.parse(value);
    } else {
      assert(false, 'unknown double value: $value');
      return 0.0;
    }
  }

  /// assume value can be a timestamp (seconds from 1970-01-01 00:00:00)
  static DateTime? getTime(Object? value) {
    double? seconds;
    if (value == null) {
      return null;
    } else if (value is DateTime) {
      // exactly
      return value;
    } else if (value is double) {
      seconds = value;
    } else if (value is num) {  // int
      // assert(false, 'not a double value: $value');
      seconds = value.toDouble();
    } else if (value is String) {
      seconds = double.parse(value);
    } else {
      assert(false, 'unknown time value: $value');
      return null;
    }
    double millis = seconds * 1000;
    return DateTime.fromMillisecondsSinceEpoch(millis.toInt());
  }

}
