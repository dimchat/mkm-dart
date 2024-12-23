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

///  @enum MKMEntityType
///
///  @abstract A network ID to indicate what kind the entity is.
///
///  @discussion An address can identify a person, a group of people,
///      a team, even a thing.
///
///      MKMEntityType_User indicates this entity is a person's account.
///      An account should have a public key, which proved by meta data.
///
///      MKMEntityType_Group indicates this entity is a group of people,
///      which should have a founder (also the owner), and some members.
///
///      MKMEntityType_Station indicates this entity is a DIM network station.
///
///      MKMEntityType_ISP indicates this entity is a group for stations.
///
///      MKMEntityType_Bot indicates this entity is a bot user.
///
///      MKMEntityType_Company indicates a company for stations and/or bots.
///
///  Bits:
///      0000 0001 - group flag
///      0000 0010 - node flag
///      0000 0100 - bot flag
///      0000 1000 - CA flag
///      ...         (reserved)
///      0100 0000 - customized flag
///      1000 0000 - broadcast flag
///
///      (All above are just some advices to help choosing numbers :P)
class EntityType {
  // ignore_for_file: constant_identifier_names

  ///  Main: 0, 1
  static const int USER             = (0x00); // 0000 0000
  static const int GROUP            = (0x01); // 0000 0001 (User Group)

  ///  Network: 2, 3
  static const int STATION          = (0x02); // 0000 0010 (Server Node)
  static const int ISP              = (0x03); // 0000 0011 (Service Provider)
  // static const int STATION_GROUP = (0x03); // 0000 0011

  ///  Bot: 4, 5
  static const int BOT              = (0x04); // 0000 0100 (Business Node)
  static const int ICP              = (0x05); // 0000 0101 (Content Provider)
  // static const int BOT_GROUP     = (0x05); // 0000 0101

  ///  Management: 6, 7, 8
  static const int SUPERVISOR       = (0x06); // 0000 0110 (Company President)
  static const int COMPANY          = (0x07); // 0000 0111 (Super Group for ISP/ICP)
  // static const int CA            = (0x08); // 0000 1000 (Certification Authority)

  // ///  Customized: 64, 65
  // static const int APP_USER      = (0x40); // 0100 0000 (Application Customized User)
  // static const int APP_GROUP     = (0x41); // 0100 0001 (Application Customized Group)

  ///  Broadcast: 128, 129
  static const int ANY              = (0x80); // 1000 0000 (anyone@anywhere)
  static const int EVERY            = (0x81); // 1000 0001 (everyone@everywhere)


  static bool isUser(int network) {
    return network & GROUP == USER;
  }

  static bool isGroup(int network) {
    return network & GROUP == GROUP;
  }

  static bool isBroadcast(int network) {
    return network & ANY == ANY;
  }
}
