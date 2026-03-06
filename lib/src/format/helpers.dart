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

  void setTransportableDataFactory(TransportableDataFactory factory);
  TransportableDataFactory? getTransportableDataFactory();

  /// Parses a raw object into a [TransportableData] instance.
  ///
  /// Converts arbitrary raw data (e.g., string, map) into a standardized
  /// TransportableData object for consistent handling in message payloads.
  ///
  /// @param ted - Raw data object to parse
  ///
  /// @return Parsed TransportableData instance (null if parsing fails)
  TransportableData? parseTransportableData(Object? ted);

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
class FormatExtensions {
  factory FormatExtensions() => _instance;
  static final FormatExtensions _instance = FormatExtensions._internal();
  FormatExtensions._internal();

  //...
}

/// TED extension
TransportableDataHelper? _tedHelper;

extension TransportableDataExtension on FormatExtensions {

  TransportableDataHelper? get tedHelper => _tedHelper;
  set tedHelper(TransportableDataHelper? ext) => _tedHelper = ext;

}
