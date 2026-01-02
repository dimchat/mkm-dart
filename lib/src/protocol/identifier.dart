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
import '../type/stringer.dart';

import 'address.dart';
import 'entity.dart';
import 'helpers.dart';
import 'meta.dart';

///  ID for entity (User/Group)
///
///      data format: "name@address[/terminal]"
///
///      fields:
///          name     - entity name, the seed of fingerprint (for building address)
///          address  - a string to identify an entity
///          terminal - location (device), RESERVED
abstract interface class ID implements Stringer {

  String? get name;
  Address get address;
  String? get terminal;

  ///  Get ID.type
  ///
  /// @return network id of address
  int get type;

  /// ID types
  bool get isBroadcast;
  bool get isUser;
  bool get isGroup;

  /// ID for Broadcast
  static final ID ANYONE = Identifier.create(name: 'anyone', address: Address.ANYWHERE);
  static final ID EVERYONE = Identifier.create(name: 'everyone', address: Address.EVERYWHERE);
  //  DIM Founder
  static final ID FOUNDER = Identifier.create(name: 'moky', address: Address.ANYWHERE);
  // ignore_for_file: non_constant_identifier_names

  //
  //  Conveniences
  //

  static List<ID> convert(Iterable array) {
    List<ID> members = [];
    ID? did;
    for (var item in array) {
      did = parse(item);
      if (did == null) {
        continue;
      }
      members.add(did);
    }
    return members;
  }
  static List<String> revert(Iterable<ID> identifiers) {
    List<String> array = [];
    for (ID did in identifiers) {
      array.add(did.toString());
    }
    return array;
  }

  //
  //  Factory methods
  //

  static ID? parse(Object? identifier) {
    var ext = AccountExtensions();
    return ext.idHelper!.parseID(identifier);
  }

  static ID create({String? name, required Address address, String? terminal}) {
    var ext = AccountExtensions();
    return ext.idHelper!.createID(name: name, address: address, terminal: terminal);
  }

  static ID generate(Meta meta, int? network, {String? terminal}) {
    var ext = AccountExtensions();
    return ext.idHelper!.generateID(meta, network, terminal: terminal);
  }

  static IDFactory? getFactory() {
    var ext = AccountExtensions();
    return ext.idHelper!.getIDFactory();
  }
  static void setFactory(IDFactory factory) {
    var ext = AccountExtensions();
    ext.idHelper!.setIDFactory(factory);
  }
}

///  ID Factory
///  ~~~~~~~~~~
abstract interface class IDFactory {

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
  Identifier(super.string, {
    String? name, required Address address, String? terminal
  }) : _name = name, _address = address, _terminal = terminal;

  final String? _name;
  final Address _address;
  final String? _terminal;

  @override
  String? get name => _name;

  @override
  Address get address => _address;

  @override
  String? get terminal => _terminal;

  @override
  int get type => _address.network;

  @override
  bool get isBroadcast => EntityType.isBroadcast(type);

  @override
  bool get isUser => EntityType.isUser(type);

  @override
  bool get isGroup => EntityType.isGroup(type);

  //
  //  Factory
  //

  static ID create({String? name, required Address address, String? terminal}) {
    String string = concat(name: name, address: address, terminal: terminal);
    return Identifier(string, name: name, address: address, terminal: terminal);
  }

  static String concat({String? name, required Address address, String? terminal}) {
    String string = address.toString();
    if (name != null && name.isNotEmpty) {
      string = '$name@$string';
    }
    if (terminal != null && terminal.isNotEmpty) {
      string = '$string/$terminal';
    }
    return string;
  }

}
