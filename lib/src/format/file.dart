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

import 'encode.dart';
import 'helpers.dart';


///  Transportable File
///  ~~~~~~~~~~~~~~~~~~
///  PNF - Portable Network File
///
///     0. "{URL}"
///     1. "base64,{BASE64_ENCODE}"
///     2. "data:image/png;base64,{BASE64_ENCODE}"
///     3. {
///             data     : "...",        // base64_encode(fileContent)
///             filename : "avatar.png",
///
///             URL      : "http://...", // download from CDN
///             // before fileContent uploaded to a public CDN,
///             // it can be encrypted by a symmetric key
///             key      : {             // symmetric key to decrypt file content
///                 algorithm : "AES",   // "DES", ...
///                 data      : "{BASE64_ENCODE}",
///                 ...
///             }
///        }
abstract interface class PortableNetworkFile implements Mapper {

  /// When file data is too big, don't set it in this dictionary,
  /// but upload it to a CDN and set the download URL instead.
  Uint8List? get data;
  set data(Uint8List? fileData);

  String? get filename;
  set filename(String? name);

  /// Download URL
  Uri? get url;
  set url(Uri? location);

  /// Password for decrypting the downloaded data from CDN,
  /// default is a plain key, which just return the same data when decrypting.
  DecryptKey? get password;
  set password(DecryptKey? key);

  ///  Get encoded string
  ///
  /// @return "URL", or
  ///         "base64,{BASE64_ENCODE}", or
  ///         "data:image/png;base64,{BASE64_ENCODE}", or
  ///         "{...}"
  @override
  String toString();

  ///  toJson()
  ///
  /// @return String, or Map
  Object toObject();

  //
  //  Factory methods
  //

  /// Create from remote URL
  static PortableNetworkFile createFromURL(Uri url, DecryptKey? password) {
    return create(null, null, url, password);
  }
  /// Create from file data
  static PortableNetworkFile createFromData(Uint8List data, String? filename) {
    TransportableData ted = TransportableData.create(data);
    return create(ted, filename, null, null);
  }

  static PortableNetworkFile create(TransportableData? data, String? filename,
                                    Uri? url, DecryptKey? password) {
    var holder = FormatHolder();
    return holder.pnfHelper!.createPortableNetworkFile(data, filename, url, password);
  }

  static PortableNetworkFile? parse(Object? pnf) {
    var holder = FormatHolder();
    return holder.pnfHelper!.parsePortableNetworkFile(pnf);
  }

  static PortableNetworkFileFactory? getFactory() {
    var holder = FormatHolder();
    return holder.pnfHelper!.getPortableNetworkFileFactory();
  }
  static void setFactory(PortableNetworkFileFactory factory) {
    var holder = FormatHolder();
    holder.pnfHelper!.setPortableNetworkFileFactory(factory);
  }
}


///  PNF Factory
///  ~~~~~~~~~~~
abstract interface class PortableNetworkFileFactory {

  ///  Create PNF
  ///
  /// @param data     - file data (not encrypted)
  /// @param filename - file name
  /// @param url      - download URL
  /// @param password - decrypt key for downloaded data
  /// @return PNF object
  PortableNetworkFile createPortableNetworkFile(TransportableData? data, String? filename,
                                                Uri? url, DecryptKey? password);

  ///  Parse map object to PNF
  ///
  /// @param pnf      - PNF info
  /// @return PNF object
  PortableNetworkFile? parsePortableNetworkFile(Map pnf);
}
