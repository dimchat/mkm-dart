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


/// Interface for serializable data or file content that supports multiple transport formats.
///
/// This interface defines standardized formats for transporting resources (files/data)
/// across different systems, supporting both direct encoding and remote URL references.
///
/// Supported transport formats:
/// 0. Pure Base64 string: `"{BASE64_ENCODE}"`
/// 1. Data URI format: `"data:image/png;base64,{BASE64_ENCODE}"`
/// 2. Remote URL: `"https://..."` (download from remote server/CDN)
/// 3. Structured JSON object (supports encryption and metadata):
///
/// ```json
/// {
///   "data"     : "...",         // Base64-encoded file content
///   "filename" : "avatar.png",
///   "URL"      : "http://...",  // CDN download URL (alternative to inline data)
///   "key"      : {              // Symmetric encryption key (for encrypted content)
///     "algorithm" : "AES",      // Encryption algorithm (e.g., "AES", "DES")
///     "data"      : "{BASE64_ENCODE}"
///   }
/// }
/// ```
///
/// Format classification:
/// - TED (TransportableData): Formats 0 and 1 (encoded data only)
/// - PNF (TransportableFile): Formats 2 and 3 (file with metadata/URL)
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

  /// Serializes the resource into a transportable format.
  ///
  /// Returns:
  /// - String: For formats 0, 1, 2 (Base64 string, Data URI, or URL)
  /// - Map: For format 3 (structured JSON object as Map)
  Object serialize();

}


/// Transportable Encoded Data (TED) - encoded binary data for transport.
///
/// Represents binary data encoded as a string for easy transmission,
/// implementing [TransportableResource] for serialization.
///
/// Supported formats:
/// 0. Pure Base64 string: `"{BASE64_ENCODE}"`
/// 1. Data URI format: `"data:image/png;base64,{BASE64_ENCODE}"`
abstract interface class TransportableData implements Stringer, TransportableResource {

  /// encode algorithms
  // static const DEFAULT = 'base64';
  // static const BASE_64 = 'base64';
  // static const BASE_58 = 'base58';
  // static const HEX     = 'hex';

  /// Gets the encoding algorithm name (e.g., 'base64').
  String? get encoding;

  /// Gets the original raw binary data (plaintext) before encoding.
  Uint8List? get bytes;

  /// Gets the size of the raw binary data in bytes.
  int get lengthInBytes;

  /// Returns the encoded string representation of the data.
  ///
  /// Returns either:
  /// - Pure Base64 string: `"{BASE64_ENCODE}"`
  /// - Data URI string: `"data:image/png;base64,{BASE64_ENCODE}"`
  @override
  String toString();

  /// Serializes this TED to a transportable string (same as [toString]).
  ///
  /// Returns: Encoded string representation (format 0 or 1)
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


/// Factory interface for creating [TransportableData] (TED) instances.
abstract interface class TransportableDataFactory {

  /// Parses an encoded string into a [TransportableData] instance.
  ///
  /// [ted]: Encoded string in TED format (0 or 1)
  ///
  /// Returns: [TransportableData] instance, or null if parsing fails
  TransportableData? parseTransportableData(String ted);
}
