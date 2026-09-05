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


/// Interface for unique identifiers (ID) of network entities (users/groups).
///
/// The ID follows a standardized format for entity identification:
/// ```
///   "name@address[/terminal]"
/// ```
///
/// Format breakdown:
/// - **name**     : Entity name (seed for fingerprint used to generate address)
/// - **address**  : Core identifier for the entity (unique on the network)
/// - **terminal** : Optional device/location (RESERVED for future use)
///
/// Implements [Stringer] for consistent string representation of the full ID.
abstract interface class ID implements Stringer {

  /// Entity name (seed for fingerprint used to generate address).
  String? get name;

  /// Core address component, unique on the network.
  Address get address;

  /// Optional terminal (device/location).
  String? get terminal;

  /// Network type (ID type) derived from the address.
  ///
  /// Returns the network ID integer from [address.network].
  int get type;

  /// ID types
  bool get isBroadcast;
  bool get isUser;
  bool get isGroup;

  //
  //  Comparison
  //

  /// Check Naked ID
  bool isSameAs(Object? other);

  /// Naked ID: name@address
  ID withoutTerminal();

  /// Dressed ID: name@address/terminal
  ID withTerminal(String newTerminal);

  /// ID for Broadcast
  static final ID ANYONE = Identifier.create(name: 'anyone', address: Address.ANYWHERE);
  static final ID EVERYONE = Identifier.create(name: 'everyone', address: Address.EVERYWHERE);
  //  DIM Founder
  static final ID FOUNDER = Identifier.create(name: 'moky', address: Address.ANYWHERE);
  // ignore_for_file: non_constant_identifier_names

  //
  //  Conveniences
  //

  /// Convert raw items to ID list (invalid items are ignored).
  static List<ID> convert(Iterable array) {
    List<ID> members = [];
    ID? did;
    for (final item in array) {
      did = parse(item);
      if (did == null) {
        continue;
      }
      members.add(did);
    }
    return members;
  }

  /// Revert ID list to string list.
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

  /// Parse an [ID] instance from raw data.
  static ID? parse(Object? identifier) {
    final helper = sharedAccountExtensions.idHelper;
    return helper!.parseID(identifier);
  }

  /// Create an [ID] instance with the given components.
  ///
  /// [name] is the entity name (optional).
  /// [address] is the core address component (required).
  /// [terminal] is the terminal identifier (optional).
  ///
  /// Returns a new [ID] instance.
  static ID create({String? name, required Address address, String? terminal}) {
    final helper = sharedAccountExtensions.idHelper;
    return helper!.createID(name: name, address: address, terminal: terminal);
  }

  /// Get the ID factory.
  static IDFactory? getFactory() {
    final helper = sharedAccountExtensions.idHelper;
    return helper!.getIDFactory();
  }

  /// Set the ID factory.
  static void setFactory(IDFactory factory) {
    final helper = sharedAccountExtensions.idHelper;
    helper!.setIDFactory(factory);
  }
}

/// Factory interface for creating and parsing [ID] instances.
///
/// Provides methods to create and parse entity IDs from raw components and
/// string representations.
abstract interface class IDFactory {

  /// Creates an [ID] from explicit component values.
  ///
  /// [name] is the entity name (optional).
  /// [address] is the required core address component (cannot be null).
  /// [terminal] is the optional terminal/location (RESERVED).
  ///
  /// Returns a new [ID] instance with the specified components.
  ID createID({String? name, required Address address, String? terminal});

  /// Parses a string representation into an [ID] instance.
  ///
  /// [identifier] is the string in "name@address[/terminal]" format.
  ///
  /// Returns an [ID] instance if parsing succeeds, null otherwise.
  ID? parseID(String identifier);
}


/// Concrete implementation of [ID] (wraps a constant string).
final class Identifier extends ConstantString implements ID {
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
  int get type => address.network;

  @override
  bool get isBroadcast => EntityType.isBroadcast(type);

  @override
  bool get isUser => EntityType.isUser(type);

  @override
  bool get isGroup => EntityType.isGroup(type);

  @override
  bool isSameAs(Object? other) {
    ID? did  = ID.parse(other);
    if (did == null) {
      // should not happen
      return false;
    } else if (identical(did, this)) {
      // same object
      return true;
    }
    //
    //  1. check address
    //
    if (address != did.address) {
      // addresses not equal,
      // sure not the same entity
      return false;
    }
    //
    //  2. check name
    //
    String thisName = name ?? '';
    String thatName = did.name ?? '';
    return thisName == thatName;
  }

  @override
  ID withoutTerminal() {
    // check old terminal (device)
    String? device = terminal;
    if (device == null/* || device.isEmpty*/) {
      // nothing changed
      return this;
    }
    // create new ID without terminal
    return ID.create(name: name, address: address);
  }

  @override
  ID withTerminal(String newTerminal) {
    // check old terminal (device)
    String oldTerminal = terminal ?? '';
    if (newTerminal.isEmpty) {
      // should not happen
      return oldTerminal.isEmpty ? this : ID.create(name: name, address: address);
    }
    // new terminal not empty (normally),
    // try to add/replace terminal
    if (newTerminal == oldTerminal) {
      // old terminal equals to the new terminal,
      // nothing changed
      return this;
    }
    // create new ID with terminal
    return ID.create(name: name, address: address, terminal: newTerminal);
  }

  //
  //  Factory
  //

  /// Create an ID with the given components directly.
  static ID create({String? name, required Address address, String? terminal}) {
    String string = concat(name: name, address: address, terminal: terminal);
    return Identifier(string, name: name, address: address, terminal: terminal);
  }

  /// Concat the given components to a string: "[name@]address[/terminal]".
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
