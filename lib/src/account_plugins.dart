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

///  Account GeneralFactory
///  ~~~~~~~~~~~~~~~~~~~~~~
abstract interface class GeneralAccountHelper /*
    implements AddressHelper, IdentifierHelper, MetaHelper, DocumentHelper */{

  //
  //  Algorithm Version
  //

  String? getMetaType(Map meta, String? defaultValue);

  String? getDocumentType(Map doc, String? defaultValue);

}


/// Account FactoryManager
/// ~~~~~~~~~~~~~~~~~~~~~~
class SharedAccountHolder {
  factory SharedAccountHolder() => _instance;
  static final SharedAccountHolder _instance = SharedAccountHolder._internal();
  SharedAccountHolder._internal();

  /// Address
  AddressHelper? get addressHelper =>
      AccountHolder().addressHelper;

  set tedHelper(AddressHelper? helper) =>
      AccountHolder().addressHelper = helper;

  /// ID
  IdentifierHelper? get idHelper =>
      AccountHolder().idHelper;

  set idHelper(IdentifierHelper? helper) =>
      AccountHolder().idHelper = helper;

  /// Meta
  MetaHelper? get metaHelper =>
      AccountHolder().metaHelper;

  set metaHelper(MetaHelper? helper) =>
      AccountHolder().metaHelper = helper;

  /// Document
  DocumentHelper? get docHelper =>
      AccountHolder().docHelper;

  set docHelper(DocumentHelper? helper) =>
      AccountHolder().docHelper = helper;

  /// General Helper
  GeneralAccountHelper? helper;

}
