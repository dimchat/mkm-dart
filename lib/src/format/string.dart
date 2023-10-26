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
import 'dart:typed_data';

///  String Coder
///  ~~~~~~~~~~~~
///  UTF-8, UTF-16, GBK, GB2312, ...
///
///  1. encode string to binary data;
///  2. decode binary data to string.
abstract interface class StringCoder {

  ///  Encode local string to binary data
  ///
  /// @param string - local string
  /// @return binary data
  Uint8List encode(String string);

  ///  Decode binary data to local string
  ///
  /// @param data - binary data
  /// @return local string
  String? decode(Uint8List data);
}

class UTF8 {

  static Uint8List encode(String string) {
    return coder!.encode(string);
  }

  static String? decode(Uint8List utf8) {
    return coder!.decode(utf8);
  }

  static StringCoder? coder;
}
