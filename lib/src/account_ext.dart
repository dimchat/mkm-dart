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
import 'protocol/helpers.dart';
import 'protocol/identifier.dart';

// -----------------------------------------------------------------------------
//  General Account Helpers
// -----------------------------------------------------------------------------

/// General account helper interface for common account system utilities.
///
/// Combines utility methods for parsing account component metadata (type extraction,
/// ID resolution) and acts as a unified interface for core account helpers.
abstract interface class GeneralAccountHelper /*
    implements AddressHelper, IDHelper, MetaHelper, DocumentHelper */{

  //
  //  Algorithm Version
  //

  /// Extracts the metadata type from a raw Meta map.
  ///
  /// Retrieves the type identifier (e.g., "btc", "eth") from a raw Meta map
  /// with a fallback default value if the type field is missing.
  ///
  /// @param meta - Raw Meta map containing type metadata
  ///
  /// @param defaultValue - Fallback value if type is not found
  ///
  /// @return Extracted Meta type (or defaultValue if not present)
  String? getMetaType(Map meta, [String? defaultValue]);

  /// Extracts the document type from a raw Document map.
  ///
  /// Retrieves the type identifier (e.g., "visa", "bulletin") from a raw Document map
  /// with a fallback default value if the type field is missing.
  ///
  /// @param doc - Raw Document map containing type metadata
  ///
  /// @param defaultValue - Fallback value if type is not found
  ///
  /// @return Extracted Document type (or defaultValue if not present)
  String? getDocumentType(Map doc, [String? defaultValue]);

  /// Resolves the entity ID associated with a raw Document map.
  ///
  /// Extracts the ID of the entity that owns the document from the raw Document data,
  /// enabling association of documents with their respective accounts.
  ///
  /// @param doc - Raw Document map containing entity ID metadata
  ///
  /// @return Resolved entity ID (null if ID cannot be extracted)
  ID? getDocumentID(Map doc);

}


/// General Extensions
/// ~~~~~~~~~~~~~~~~~~

GeneralAccountHelper? _accountHelper;

extension GeneralAccountExtension on AccountExtensions {

  GeneralAccountHelper? get helper => _accountHelper;
  set helper(GeneralAccountHelper? ext) => _accountHelper = ext;

}
