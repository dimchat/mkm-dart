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
import 'entity.dart';
import 'meta.dart';

///  Address for MKM ID
///  ~~~~~~~~~~~~~~~~~~
///  This class is used to build address for ID
abstract interface class Address implements Stringer {

  ///  Get address type
  ///
  /// @return network type
  int get type;

  /// address types
  bool get isBroadcast;
  bool get isUser;
  bool get isGroup;

  ///  Address for broadcast
  static final Address kAnywhere = _BroadcastAddress('anywhere', EntityType.kAny);
  static final Address kEverywhere = _BroadcastAddress('everywhere', EntityType.kEvery);

  //
  //  Factory methods
  //

  static Address? parse(Object? address) {
    AccountFactoryManager man = AccountFactoryManager();
    return man.generalFactory.parseAddress(address);
  }

  static Address? create(String address) {
    AccountFactoryManager man = AccountFactoryManager();
    return man.generalFactory.createAddress(address);
  }

  static Address generate(Meta meta, int? network) {
    AccountFactoryManager man = AccountFactoryManager();
    return man.generalFactory.generateAddress(meta, network);
  }

  static AddressFactory? getFactory() {
    AccountFactoryManager man = AccountFactoryManager();
    return man.generalFactory.getAddressFactory();
  }

  static void setFactory(AddressFactory factory) {
    AccountFactoryManager man = AccountFactoryManager();
    man.generalFactory.setAddressFactory(factory);
  }
}

///  Address Factory
///  ~~~~~~~~~~~~~~~
abstract interface class AddressFactory {

  ///  Generate address with meta & type
  ///
  /// @param meta - meta info
  /// @param network - address type
  /// @return Address
  Address generateAddress(Meta meta, int? network);

  ///  Create address from string
  ///
  /// @param address - address string
  /// @return Address
  Address? createAddress(String address);

  ///  Parse string object to address
  ///
  /// @param address - address string
  /// @return Address
  Address? parseAddress(String address);
}

class _BroadcastAddress extends ConstantString implements Address {
  _BroadcastAddress(super.string, int network) : _type = network;

  final int _type;

  @override
  int get type => _type;

  @override
  bool get isBroadcast => true;

  @override
  bool get isUser => _type == EntityType.kAny;

  @override
  bool get isGroup => _type == EntityType.kEvery;
}
