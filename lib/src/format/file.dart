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

import '../crypto/keys.dart';
import '../type/mapper.dart';

import 'manager.dart';


///  Transportable File:
///
///     0. "{URL}"
///     1. "base64,{BASE64_ENCODE}"
///     2. "data:image/png;base64,{BASE64_ENCODE}"
///     3. {
///             URL      : "http://...", // download from CDN
///             data     : "...",        // base64_encode(fileContent)
///             filename : "avatar.png",
///             // before fileContent uploaded to a public CDN,
///             // it can be encrypted by a symmetric key
///             key      : {             // symmetric key to decrypt file content
///                 algorithm : "AES",   // "DES", ...
///                 data      : "{BASE64_ENCODE}",
///                 ...
///             }
///        }
abstract class PortableNetworkFile implements Mapper {

  /// download URL
  String? get url;
  set url(String? location);

  /// when file data is too big, don't set it in this dictionary,
  /// but upload it to a CDN and set the download URL instead.
  Uint8List? get data;
  set data(Uint8List? fileData);

  String? get filename;
  set filename(String? name);

  /// password for decrypting the downloaded data from CDN,
  /// default is a plain key, which just return the same data when decrypting.
  DecryptKey? get password;
  set password(DecryptKey? key);

  // @override
  // String toString();  // URL, or
  //                     // "base64,{BASE64_ENCODE}", or
  //                     // "data:image/png;base64,{BASE64_ENCODE}"
  ///  toJson()
  Object toObject();     // String, or Map

  //
  //  Factory methods
  //

  static PortableNetworkFile create(String? url, DecryptKey? key, {Uint8List? data, String? filename}) {
    FormatFactoryManager man = FormatFactoryManager();
    return man.generalFactory.createPortableNetworkFile(url, key, data: data, filename: filename);
  }

  static PortableNetworkFile? parse(Object? pnf) {
    FormatFactoryManager man = FormatFactoryManager();
    return man.generalFactory.parsePortableNetworkFile(pnf);
  }

  static PortableNetworkFileFactory? getFactory() {
    FormatFactoryManager man = FormatFactoryManager();
    return man.generalFactory.getPortableNetworkFileFactory();
  }
  static void setFactory(PortableNetworkFileFactory factory) {
    FormatFactoryManager man = FormatFactoryManager();
    man.generalFactory.setPortableNetworkFileFactory(factory);
  }
}


///  PNF Factory
///  ~~~~~~~~~~~
abstract class PortableNetworkFileFactory {

  ///  Create PNF
  ///
  /// @param url      - download URL
  /// @param data     - file data (not encrypted)
  /// @param filename - filename
  /// @param key      - encrypt key
  /// @return PNF
  PortableNetworkFile createPortableNetworkFile(String? url, DecryptKey? key, {Uint8List? data, String? filename});

  ///  Parse map/string to PNF
  ///
  /// @param pnf      - URL, or a dictionary
  /// @return PNF
  PortableNetworkFile? parsePortableNetworkFile(Object? pnf);
}
