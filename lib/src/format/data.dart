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

///  Data Coder
///  ~~~~~~~~~~
///  Hex, Base58, Base64, ...
///
///  1. encode binary data to string;
///  2. decode string to binary data.
abstract interface class DataCoder {

  ///  Encode binary data to local string
  ///
  /// @param data - binary data
  /// @return local string
  String encode(Uint8List data);

  ///  Decode local string to binary data
  ///
  /// @param string - local string
  /// @return binary data
  Uint8List? decode(String string);
}

class Hex {

  static String encode(Uint8List data) {
    return coder!.encode(data);
  }

  static Uint8List? decode(String string) {
    return coder!.decode(string);
  }

  static DataCoder? coder;
}

class Base58 {

  static String encode(Uint8List data) {
    return coder!.encode(data);
  }

  static Uint8List? decode(String string) {
    return coder!.decode(string);
  }

  static DataCoder? coder;
}

class Base64 {

  static String encode(Uint8List data) {
    return coder!.encode(data);
  }

  static Uint8List? decode(String string) {
    return coder!.decode(string);
  }

  static DataCoder? coder;
}
