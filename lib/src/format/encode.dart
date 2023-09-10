/* license: https://mit-license.org
 *
 *  Ming-Ke-Ming : Decentralized User Identity Authentication
 *
 *                                Written in 2023 by Moky <albert.moky@gmail.com>
 *
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

import '../type/mapper.dart';

import 'manager.dart';


///  Transportable Data:
///
///     0. "{BASE64_ENCODE}"
///     1. "base64,{BASE64_ENCODE}"
///     2. "data:image/png;base64,{BASE64_ENCODE}"
///     3. {
///             algorithm : "base64",
///             data      : "...",      // base64_encode(data)
///             ...
///        }
abstract class TransportableData implements Mapper {

  static const kDefault = 'base64';
  static const kBASE_64 = 'base64';
  static const kBASE_58 = 'base58';
  static const kHEX     = 'hex';

  ///  Get encode algorithm
  ///
  /// @return "base64"
  String? get algorithm;

  ///  Get original data
  ///
  /// @return plaintext
  Uint8List? get data;

  // @override
  // String toString();  // "{BASE64_ENCODE}", or
  //                     // "base64,{BASE64_ENCODE}", or
  //                     // "data:image/png;base64,{BASE64_ENCODE}"
  ///  toJson()
  Object toObject();     // String, or Map

  //
  //  Conveniences
  //

  static Object encode(Uint8List data) {
    TransportableData ted = create(data);
    return ted.toObject();
  }

  static Uint8List? decode(Object encoded) {
    TransportableData? ted = parse(encoded);
    return ted?.data;
  }

  //
  //  Factory methods
  //

  static TransportableData create(Uint8List data, {String? algorithm}) {
    algorithm ??= kDefault;
    FormatFactoryManager man = FormatFactoryManager();
    return man.generalFactory.createTransportableData(algorithm, data);
  }

  static TransportableData? parse(Object? ted) {
    FormatFactoryManager man = FormatFactoryManager();
    return man.generalFactory.parseTransportableData(ted);
  }

  static TransportableDataFactory? getFactory(String algorithm) {
    FormatFactoryManager man = FormatFactoryManager();
    return man.generalFactory.getTransportableDataFactory(algorithm);
  }
  static void setFactory(String algorithm, TransportableDataFactory factory) {
    FormatFactoryManager man = FormatFactoryManager();
    man.generalFactory.setTransportableDataFactory(algorithm, factory);
  }
}


///  TED Factory
///  ~~~~~~~~~~~
abstract class TransportableDataFactory {

  ///  Create TED
  ///
  /// @param data - original data
  /// @return TED
  TransportableData createTransportableData(Uint8List data);

  ///  Parse map/string to TED
  ///
  /// @param ted  - String, or a dictionary
  /// @return TED
  TransportableData? parseTransportableData(Map ted);
}
