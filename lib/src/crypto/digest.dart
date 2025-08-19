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

///  Message Digest
///  ~~~~~~~~~~~~~~
///  MD5, SHA1, SHA256, Keccak256, RipeMD160, ...
abstract interface class MessageDigester {

  Uint8List digest(Uint8List data);
}

class SHA256 {

  static Uint8List digest(Uint8List data) {
    return digester!.digest(data);
  }

  static MessageDigester? digester;
}

class KECCAK256 {

  static Uint8List digest(Uint8List data) {
    return digester!.digest(data);
  }

  static MessageDigester? digester;
}

class RIPEMD160 {

  static Uint8List digest(Uint8List data) {
    return digester!.digest(data);
  }

  static MessageDigester? digester;
}
