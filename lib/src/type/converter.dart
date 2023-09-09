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

  static String? getString(Object? value, String? defaultValue) {
    if (value == null) {
      return defaultValue;
    } else if (value is String) {
      // exactly
      return value;
    } else {
      // assert(false, 'not a string value: $value');
      return value.toString();
    }
  }

  /// assume value can be a config string:
  ///     'true', 'false', 'yes', 'no', 'on', 'off', '1', '0', ...
  static bool? getBool(Object? value, bool? defaultValue) {
    if (value == null) {
      return defaultValue;
    } else if (value is bool) {
      // exactly
      return value;
    } else if (value is num) {
      assert(value == 1 || value == 0, 'bool value error: $value');
      return value != 0;
    }
    // get lower string
    String lower;
    if (value is String) {
      lower = value;
    } else {
      lower = value.toString();
    }
    if (lower.isEmpty) {
      return false;
    } else {
      lower = lower.toLowerCase();
    }
    // check false values
    if (lower == '0' || lower == 'false' || lower == 'no' || lower == 'off' ||
        lower == 'null' || lower == 'undefined') {
      return false;
    }
    assert(lower == '1' || lower == 'true' || lower == 'yes' || lower == 'on',
    'bool value error: $value');
    return true;
  }

  static int? getInt(Object? value, int? defaultValue) {
    if (value == null) {
      return defaultValue;
    } else if (value is int) {
      // exactly
      return value;
    } else if (value is num) {  // double
      // assert(false, 'not an int value: $value');
      return value.toInt();
    } else if (value is bool) {
      return value ? 1 : 0;
    }
    String str = value is String? value : value.toString();
    return int.parse(str);
  }

  static double? getDouble(Object? value, double? defaultValue) {
    if (value == null) {
      return defaultValue;
    } else if (value is double) {
      // exactly
      return value;
    } else if (value is num) {  // int
      // assert(false, 'not a double value: $value');
      return value.toDouble();
    } else if (value is bool) {
      return value ? 1.0 : 0.0;
    }
    String str = value is String? value : value.toString();
    return double.parse(str);
  }

  /// assume value can be a timestamp (seconds from 1970-01-01 00:00:00)
  static DateTime? getDateTime(Object? value, DateTime? defaultValue) {
    if (value == null) {
      return defaultValue;
    } else if (value is DateTime) {
      // exactly
      return value;
    }
    double seconds = getDouble(value, 0)!;
    double millis = seconds * 1000;
    return DateTime.fromMillisecondsSinceEpoch(millis.toInt());
  }

}
