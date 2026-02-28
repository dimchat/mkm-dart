/* license: https://mit-license.org
 * ==============================================================================
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
 * ==============================================================================
 */
import 'dart:typed_data';

import '../type/stringer.dart';

import 'helpers.dart';


///  Serializable Data or File Content
///
///  0. "{BASE64_ENCODE}"
///  1. "data:image/png;base64,{BASE64_ENCODE}"
///  2. "https://..."
///  3. mapping:
///
/// ```json
///    {
///        "data"     : "...",        // base64_encode(fileContent)
///        "filename" : "avatar.png",
///
///        "URL"      : "http://...", // download from CDN
///        // before fileContent uploaded to a public CDN,
///        // it can be encrypted by a symmetric key
///        "key"      : {             // symmetric key to decrypt file data
///            "algorithm" : "AES",   // "DES", ...
///            "data"      : "{BASE64_ENCODE}"
///        }
///    }
/// ```
abstract interface class TransportableResource {

  /*  Format
   *  ~~~~~~
   *
   *      TED - TransportableData
   *          0. "{BASE64_ENCODE}"
   *          1. "data:image/png;base64,{BASE64_ENCODE}"
   *
   *      PNF - TransportableFile
   *          2. "https://..."
   *          3. {...}
   */

  ///  Encode data
  ///
  /// @return String or Map
  Object serialize();

}


///  Transportable Data
///
///  TED - Transportable Encoded Data
///
///  0. "{BASE64_ENCODE}"
///  1. "data:image/png;base64,{BASE64_ENCODE}"
abstract interface class TransportableData implements Stringer, TransportableResource {

  /// encode algorithm
  // static const DEFAULT = 'base64';
  // static const BASE_64 = 'base64';
  // static const BASE_58 = 'base58';
  // static const HEX     = 'hex';

  ///  Get data encode algorithm
  ///
  /// @return "base64"
  String? get encoding;

  ///  Get original data
  ///
  /// @return plaintext
  Uint8List? get bytes;

  ///  Get data size
  ///
  /// @return the length of this view, in bytes.
  int get lengthInBytes;

  ///  Get encoded string
  ///
  /// @return "{BASE64_ENCODE}}", or
  ///         "data:image/png;base64,{BASE64_ENCODE}"
  @override
  String toString();

  ///  toString()
  ///
  /// @return String
  @override
  Object serialize();

  //
  //  Factory methods
  //

  static TransportableData? parse(Object? ted) {
    var ext = FormatExtensions();
    return ext.tedHelper!.parseTransportableData(ted);
  }

  static TransportableDataFactory? getFactory(String algorithm) {
    var ext = FormatExtensions();
    return ext.tedHelper!.getTransportableDataFactory(algorithm);
  }
  static void setFactory(String algorithm, TransportableDataFactory factory) {
    var ext = FormatExtensions();
    ext.tedHelper!.setTransportableDataFactory(algorithm, factory);
  }
}


///  TED Factory
abstract interface class TransportableDataFactory {

  ///  Parse map object to TED
  ///
  /// @param ted  - TED info
  /// @return TED object
  TransportableData? parseTransportableData(String ted);
}
