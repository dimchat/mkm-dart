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

import 'entity.dart';
import 'helpers.dart';
import 'meta.dart';

///  Address for MKM ID
///  ~~~~~~~~~~~~~~~~~~
///  This class is used to build address for ID
abstract interface class Address implements Stringer {

  ///  Get address type
  ///
  /// @return network id
  int get network;

  ///  Address for broadcast
  static final Address ANYWHERE = _BroadcastAddress('anywhere', EntityType.ANY);
  static final Address EVERYWHERE = _BroadcastAddress('everywhere', EntityType.EVERY);
  // ignore_for_file: non_constant_identifier_names

  //
  //  Factory methods
  //

  static Address? parse(Object? address) {
    var ext = AccountExtensions();
    return ext.addressHelper!.parseAddress(address);
  }

  static Address generate(Meta meta, int? network) {
    var ext = AccountExtensions();
    return ext.addressHelper!.generateAddress(meta, network);
  }

  static AddressFactory? getFactory() {
    var ext = AccountExtensions();
    return ext.addressHelper!.getAddressFactory();
  }

  static void setFactory(AddressFactory factory) {
    var ext = AccountExtensions();
    ext.addressHelper!.setAddressFactory(factory);
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

  ///  Parse string object to address
  ///
  /// @param address - address string
  /// @return Address
  Address? parseAddress(String address);
}


class _BroadcastAddress extends ConstantString implements Address {
  _BroadcastAddress(super.string, this.type);

  // private
  final int type;

  @override
  int get network => type;

}
