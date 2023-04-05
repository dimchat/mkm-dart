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
import '../factory.dart';
import '../type/stringer.dart';
import 'address.dart';
import 'meta.dart';

///  ID for entity (User/Group)
///
///      data format: "name@address[/terminal]"
///
///      fields:
///          name     - entity name, the seed of fingerprint to build address
///          address  - a string to identify an entity
///          terminal - entity login resource(device), OPTIONAL
abstract class ID implements Stringer {

  String? get name;
  Address get address;
  String? get germinal;

  ///  Get ID.type
  ///
  /// @return network type
  int get type;

  /// ID types
  bool get isBroadcast;
  bool get isUser;
  bool get isGroup;

  ///  ID for Broadcast
  static final ID kAnyone = Identifier('anyone@anywhere', name: 'anyone', address: Address.kAnywhere);
  static final ID kEveryone = Identifier('everyone@everywhere', name: 'everyone', address: Address.kEverywhere);
  ///  DIM Founder
  static final ID kFounder = Identifier('moky@anywhere', name: 'moky', address: Address.kAnywhere);

  static List<ID> convert(List members) {
    AccountFactoryManager man = AccountFactoryManager();
    return man.generalFactory.convertIdentifiers(members);
  }
  static List<String> revert(List<ID> members) {
    AccountFactoryManager man = AccountFactoryManager();
    return man.generalFactory.revertIdentifiers(members);
  }

  //
  //  Factory methods
  //

  static ID? parse(Object? identifier) {
    AccountFactoryManager man = AccountFactoryManager();
    return man.generalFactory.parseID(identifier);
  }

  static ID create({String? name, required Address address, String? terminal}) {
    AccountFactoryManager man = AccountFactoryManager();
    return man.generalFactory.createID(name: name, address: address, terminal: terminal);
  }

  static ID generate(Meta meta, int? network, {String? terminal}) {
    AccountFactoryManager man = AccountFactoryManager();
    return man.generalFactory.generateID(meta, network, terminal: terminal);
  }

  static IDFactory? getFactory() {
    AccountFactoryManager man = AccountFactoryManager();
    return man.generalFactory.getIDFactory();
  }
  static void setFactory(IDFactory? factory) {
    AccountFactoryManager man = AccountFactoryManager();
    man.generalFactory.setIDFactory(factory);
  }
}

///  ID Factory
///  ~~~~~~~~~~
abstract class IDFactory {

  ///  Generate ID
  ///
  /// @param meta     - meta info
  /// @param network  - ID.type
  /// @param terminal - ID.terminal
  /// @return ID
  ID generateID(Meta meta, int? network, {String? terminal});

  ///  Create ID
  ///
  /// @param name     - ID.name
  /// @param address  - ID.address
  /// @param terminal - ID.terminal
  /// @return ID
  ID createID({String? name, required Address address, String? terminal});

  ///  Parse string object to ID
  ///
  /// @param identifier - ID string
  /// @return ID
  ID? parseID(String identifier);
}

class Identifier extends ConstantString implements ID {
  Identifier(super.string, {String? name, required Address address, String? terminal})
      : _name = name, _address = address, _terminal = terminal;

  final String? _name;
  final Address _address;
  final String? _terminal;

  @override
  String? get name => _name;

  @override
  Address get address => _address;

  @override
  String? get germinal => _terminal;

  @override
  int get type => _address.type;

  @override
  bool get isBroadcast => _address.isBroadcast;

  @override
  bool get isUser => _address.isUser;

  @override
  bool get isGroup => _address.isGroup;
}
