/* license: https://mit-license.org
 *
 *  Ming-Ke-Ming : Decentralized User Identity Authentication
 *
 *                                Written in 2023 by Moky <albert.moky@gmail.com>
 *
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

import '../crypto/keys.dart';
import '../type/converter.dart';
import '../type/mapper.dart';

import 'encode.dart';
import 'file.dart';
import 'object.dart';

/// Format FactoryManager
/// ~~~~~~~~~~~~~~~~~~~~~
class FormatFactoryManager {
  factory FormatFactoryManager() => _instance;
  static final FormatFactoryManager _instance = FormatFactoryManager._internal();
  FormatFactoryManager._internal();

  FormatGeneralFactory generalFactory = FormatGeneralFactory();
}

/// Format GeneralFactory
/// ~~~~~~~~~~~~~~~~~~~~~
class FormatGeneralFactory {

  final Map<String, TransportableDataFactory> _tedFactories = {};

  PortableNetworkFileFactory? _pnfFactory;

  /// split text string to array: ["{TEXT}", "{algorithm}"]
  List<String> split(String text) {
    // "{TEXT}", or
    // "base64,{BASE64_ENCODE}", or
    // "data:image/png;base64,{BASE64_ENCODE}"
    int pos1 = text.indexOf('://');
    if (pos1 > 0) {
      // [URL]
      return [text];
    }
    pos1 = text.indexOf(';') + 1;
    int pos2 = text.indexOf(',', pos1);
    if (pos2 > pos1) {
      // [data, algorithm]
      return [
        text.substring(pos2 + 1),
        text.substring(pos1, pos2)
      ];
    }
    // [data]
    if (pos1 > 0) {
      text = text.substring(pos1);
    }
    return [text];
  }

  Map? decode(Object data, {required String defaultKey}) {
    if (data is Mapper) {
      return data.toMap();
    } else if (data is Map) {
      return data;
    }
    String text = data is String ? data : data.toString();
    if (text.isEmpty) {
      return null;
    } else if (text.startsWith('{') && text.endsWith('}')) {
      return JSONMap.decode(text);
    }
    List<String> array = split(text);
    if (array.length == 1) {
      return {
        defaultKey: array[0],
      };
    }
    assert(array.length == 2, 'split error: $text => $array');
    return {
      'algorithm': array[1],
      'data': array[0],
    };
  }

  ///
  ///   TED - Transportable Encoded Data
  ///

  String? getDataAlgorithm(Map ted, String? defaultValue) {
    return Converter.getString(ted['algorithm'], defaultValue);
  }

  void setTransportableDataFactory(String algorithm, TransportableDataFactory factory) {
    _tedFactories[algorithm] = factory;
  }
  TransportableDataFactory? getTransportableDataFactory(String algorithm) {
    return _tedFactories[algorithm];
  }

  TransportableData createTransportableData(String algorithm, Uint8List data) {
    TransportableDataFactory? factory = getTransportableDataFactory(algorithm);
    assert(factory != null, 'TED algorithm not support: $algorithm');
    return factory!.createTransportableData(data);
  }

  TransportableData? parseTransportableData(Object? ted) {
    if (ted == null) {
      return null;
    } else if (ted is TransportableData) {
      return ted;
    }
    // unwrap
    Map? info = decode(ted, defaultKey: 'data');
    if (info == null) {
      // assert(false, 'TED error: $ted');
      return null;
    }
    String algorithm = getDataAlgorithm(info, '*')!;
    TransportableDataFactory? factory = getTransportableDataFactory(algorithm);
    if (factory == null) {
      assert(algorithm != '*', 'TED factory not ready: $ted');
      factory = getTransportableDataFactory('*');  // unknown
      assert(factory != null, 'default TED factory not found');
    }
    return factory?.parseTransportableData(info);
  }

  ///
  ///   PNF - Portable Network File
  ///

  void setPortableNetworkFileFactory(PortableNetworkFileFactory factory) {
    _pnfFactory = factory;
  }
  PortableNetworkFileFactory? getPortableNetworkFileFactory() {
    return _pnfFactory;
  }

  PortableNetworkFile createPortableNetworkFile(TransportableData? data, String? filename,
                                                Uri? url, DecryptKey? password) {
    PortableNetworkFileFactory? factory = getPortableNetworkFileFactory();
    assert(factory != null, 'PNF factory not ready');
    return factory!.createPortableNetworkFile(data, filename, url, password);
  }

  PortableNetworkFile? parsePortableNetworkFile(Object? pnf) {
    if (pnf == null) {
      return null;
    } else if (pnf is PortableNetworkFile) {
      return pnf;
    }
    // unwrap
    Map? info = decode(pnf, defaultKey: 'URL');
    if (info == null) {
      // assert(false, 'PNF error: $pnf');
      return null;
    }
    PortableNetworkFileFactory? factory = getPortableNetworkFileFactory();
    assert(factory != null, 'PNF factory not ready');
    return factory?.parsePortableNetworkFile(info);
  }

}
