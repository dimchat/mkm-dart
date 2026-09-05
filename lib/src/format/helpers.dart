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

import '../type/mapping.dart';

import 'ted.dart';

// -----------------------------------------------------------------------------
//  Format Helpers
// -----------------------------------------------------------------------------

/// Helper interface for processing TransportableData (TED) objects.
///
/// Provides core functionality for managing TransportableData factories and
/// parsing raw data objects into strongly-typed [TransportableData] instances.
///
/// TransportableData is used to encapsulate serializable binary/data content
/// in message payloads.
abstract interface class TransportableDataHelper {

  /// Set the TransportableData factory.
  void setTransportableDataFactory(TransportableDataFactory factory);

  /// Get the TransportableData factory.
  TransportableDataFactory? getTransportableDataFactory();

  /// Parse a raw object into a [TransportableData] instance.
  ///
  /// Converts arbitrary raw data (e.g., string, map) into a standardized
  /// TransportableData object for consistent handling in message payloads.
  /// Returns null if parsing fails.
  TransportableData? parseTransportableData(Object? ted);

  /// Create a [TransportableData] instance from raw data.
  ///
  /// [data] is the raw binary data.
  /// [encoding] is the encoding algorithm name ("base64", "base58", "hex", ...).
  /// [mimeType] is the optional content-type ("image/jpeg", ...).
  /// [parameters] carries the optional extra info (charset, filename, ...).
  TransportableData createTransportableData(Uint8List data, {
    String? encoding,
    String? mimeType,
    Mapping<String, String>? parameters,
  });

}

// -----------------------------------------------------------------------------
//  Format Extension Manager
// -----------------------------------------------------------------------------

/// Core extension manager for message format handling.
///
/// Singleton class that manages format-related extensions (e.g., TransportableData)
/// to provide consistent message formatting/parsing across the application.
final sharedFormatExtensions = FormatExtensions();

/// Singleton extension class for message format operations.
///
/// Centralizes access to format helpers (like [TransportableDataHelper])
/// using Dart extensions for clean, modular access.
final class FormatExtensions {
  factory FormatExtensions() => _instance;
  static final FormatExtensions _instance = FormatExtensions._internal();
  FormatExtensions._internal();

  //...
}

/// TED extension
TransportableDataHelper? _tedHelper;

extension TransportableDataExtension on FormatExtensions {

  /// Get the TED helper (null before set).
  TransportableDataHelper? get tedHelper => _tedHelper;

  /// Set the TED helper.
  set tedHelper(TransportableDataHelper? ext) => _tedHelper = ext;

}
