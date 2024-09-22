// -----------------------------------------------------------------------------
// SGDCCPacket.swift
//
// This Swift source file is a part of the SGDCC package
// by Paul C. L. Willmott.
//
// Copyright © 2024 Paul C. L. Willmott. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the “Software”), to deal 
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// copies of the Software, and to permit persons to whom the Software is 
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in 
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
// SOFTWARE.
// -----------------------------------------------------------------------------
//
// Revision History:
//
//     22/09/2024  Paul Willmott - SGDCCPacket.swift created
// -----------------------------------------------------------------------------

import Foundation

private let shortAddressPartition = UInt8(1)   ... UInt8(127)
private let longAddressPartition  = UInt8(192) ... UInt8(231)

public class SGDCCPacket : NSObject {
  
  // MARK: Constructors & Destructors
  
  private init?(data:[UInt8], decoderMode:SGDCCDecoderMode = .operationsMode) {
    
    self.packet = data
    
    self.decoderMode = decoderMode
    
    self.packet.append(SGDCCPacket.checksum(self.packet))
    
    super.init()
    
  }
  
  init?(packet:[UInt8], decoderMode:SGDCCDecoderMode = .operationsMode) {
    
    self.packet = packet
    
    self.decoderMode = decoderMode
    
    super.init()
    
    guard packet.count > 1 && isChecksumOK else {
      return nil
    }
    
  }
  
  // MARK: Functions
  
  // Function Group One Instruction
  
  init?(shortAddress:UInt8, f0toF4 functions:[Bool]) {
    
    guard shortAddressPartition ~= shortAddress && functions.count > 4 else {
      return nil
    }
    
    var temp : UInt8 = 0
    
    var mask : UInt8 = 0b00000001
    
    for index in 1 ... 4 {
      temp |= functions[index] ? mask : 0
      mask <<= 1
    }

    packet = [shortAddress, 0b10000000 | (functions[0] ? 0b00010000 : 0) | temp]

    packet.append(SGDCCPacket.checksum(packet))
    
    decoderMode = .operationsMode
    
    super.init()
    
  }
  
  init?(longAddress:UInt16, f0toF4 functions:[Bool]) {
    
    let cv17 = SGDCCPacket.cv17(address: longAddress)
    
    guard longAddressPartition ~= cv17 && functions.count > 4 else {
      return nil
    }
    
    var temp : UInt8 = 0
    
    var mask : UInt8 = 0b00000001
    
    for index in 1 ... 4 {
      temp |= functions[index] ? mask : 0
      mask <<= 1
    }

    packet = [cv17, SGDCCPacket.cv18(address: longAddress), 0b10000000 | (functions[0] ? 0b00010000 : 0) | temp]

    packet.append(SGDCCPacket.checksum(packet))
    
    decoderMode = .operationsMode
    
    super.init()
    
  }

  // Function Group Two Instructions
  
  init?(shortAddress:UInt8, f5toF8 functions:[Bool]) {
    
    guard shortAddressPartition ~= shortAddress && functions.count > 8 else {
      return nil
    }
    
    var temp : UInt8 = 0
    
    var mask : UInt8 = 0b00000001
    
    for index in 5 ... 8 {
      temp |= functions[index] ? mask : 0
      mask <<= 1
    }

    packet = [shortAddress, 0b10110000 | temp]

    packet.append(SGDCCPacket.checksum(packet))
    
    decoderMode = .operationsMode
    
    super.init()
    
  }

  init?(longAddress:UInt16, f5toF8 functions:[Bool]) {
    
    let cv17 = SGDCCPacket.cv17(address: longAddress)
    
    guard longAddressPartition ~= cv17 && functions.count > 8 else {
      return nil
    }
    
    var temp : UInt8 = 0
    
    var mask : UInt8 = 0b00000001
    
    for index in 5 ... 8 {
      temp |= functions[index] ? mask : 0
      mask <<= 1
    }

    packet = [cv17, SGDCCPacket.cv18(address: longAddress), 0b10110000 | temp]

    packet.append(SGDCCPacket.checksum(packet))
    
    decoderMode = .operationsMode
    
    super.init()
    
  }

  init?(shortAddress:UInt8, f9toF12 functions:[Bool]) {
    
    guard shortAddressPartition ~= shortAddress && functions.count > 12 else {
      return nil
    }
    
    var temp : UInt8 = 0
    
    var mask : UInt8 = 0b00000001
    
    for index in 9 ... 12 {
      temp |= functions[index] ? mask : 0
      mask <<= 1
    }

    packet = [shortAddress, 0b10100000 | temp]

    packet.append(SGDCCPacket.checksum(packet))
    
    decoderMode = .operationsMode
    
    super.init()
    
  }

  init?(longAddress:UInt16, f9toF12 functions:[Bool]) {
    
    let cv17 = SGDCCPacket.cv17(address: longAddress)
    
    guard longAddressPartition ~= cv17 && functions.count > 12 else {
      return nil
    }
    
    var temp : UInt8 = 0
    
    var mask : UInt8 = 0b00000001
    
    for index in 9 ... 12 {
      temp |= functions[index] ? mask : 0
      mask <<= 1
    }

    packet = [cv17, SGDCCPacket.cv18(address: longAddress), 0b10100000 | temp]

    packet.append(SGDCCPacket.checksum(packet))
    
    decoderMode = .operationsMode
    
    super.init()
    
  }
  
  // F13 to F20 Function Control
  
  init?(shortAddress:UInt8, f13toF20 functions:[Bool]) {
    
    guard shortAddressPartition ~= shortAddress && functions.count > 20 else {
      return nil
    }
    
    var temp : UInt8 = 0
    
    var mask : UInt8 = 0b00000001
    
    for index in 13 ... 20 {
      temp |= functions[index] ? mask : 0
      mask <<= 1
    }

    packet = [shortAddress, 0b11011110, temp]

    packet.append(SGDCCPacket.checksum(packet))
    
    decoderMode = .operationsMode
    
    super.init()
    
  }

  init?(longAddress:UInt16, f13toF20 functions:[Bool]) {
    
    let cv17 = SGDCCPacket.cv17(address: longAddress)
    
    guard longAddressPartition ~= cv17 && functions.count > 20 else {
      return nil
    }
    
    var temp : UInt8 = 0
    
    var mask : UInt8 = 0b00000001
    
    for index in 13 ... 20 {
      temp |= functions[index] ? mask : 0
      mask <<= 1
    }

    packet = [cv17, SGDCCPacket.cv18(address: longAddress), 0b11011110, temp]

    packet.append(SGDCCPacket.checksum(packet))
    
    decoderMode = .operationsMode
    
    super.init()
    
  }

  // F21 to F28 Function Control
  
  init?(shortAddress:UInt8, f21toF28 functions:[Bool]) {
    
    guard shortAddressPartition ~= shortAddress && functions.count > 28 else {
      return nil
    }
    
    var temp : UInt8 = 0
    
    var mask : UInt8 = 0b00000001
    
    for index in 21 ... 28 {
      temp |= functions[index] ? mask : 0
      mask <<= 1
    }

    packet = [shortAddress, 0b11011111, temp]

    packet.append(SGDCCPacket.checksum(packet))
    
    decoderMode = .operationsMode
    
    super.init()
    
  }

  init?(longAddress:UInt16, f21toF28 functions:[Bool]) {
    
    let cv17 = SGDCCPacket.cv17(address: longAddress)
    
    guard longAddressPartition ~= cv17 && functions.count > 28 else {
      return nil
    }
    
    var temp : UInt8 = 0
    
    var mask : UInt8 = 0b00000001
    
    for index in 21 ... 28 {
      temp |= functions[index] ? mask : 0
      mask <<= 1
    }

    packet = [cv17, SGDCCPacket.cv18(address: longAddress), 0b11011111, temp]

    packet.append(SGDCCPacket.checksum(packet))
    
    decoderMode = .operationsMode
    
    super.init()
    
  }
  
  // F29 to F36 Function Control
  
  init?(shortAddress:UInt8, f29toF36 functions:[Bool]) {
    
    guard shortAddressPartition ~= shortAddress && functions.count > 36 else {
      return nil
    }
    
    var temp : UInt8 = 0
    
    var mask : UInt8 = 0b00000001
    
    for index in 29 ... 36 {
      temp |= functions[index] ? mask : 0
      mask <<= 1
    }

    packet = [shortAddress, 0b11011000, temp]

    packet.append(SGDCCPacket.checksum(packet))
    
    decoderMode = .operationsMode
    
    super.init()
    
  }

  init?(longAddress:UInt16, f29toF36 functions:[Bool]) {
    
    let cv17 = SGDCCPacket.cv17(address: longAddress)
    
    guard longAddressPartition ~= cv17 && functions.count > 36 else {
      return nil
    }
    
    var temp : UInt8 = 0
    
    var mask : UInt8 = 0b00000001
    
    for index in 29 ... 36 {
      temp |= functions[index] ? mask : 0
      mask <<= 1
    }

    packet = [cv17, SGDCCPacket.cv18(address: longAddress), 0b11011000, temp]

    packet.append(SGDCCPacket.checksum(packet))
    
    decoderMode = .operationsMode
    
    super.init()
    
  }
  
  // F37 to F44 Function Control
  
  init?(shortAddress:UInt8, f37toF44 functions:[Bool]) {
    
    guard shortAddressPartition ~= shortAddress && functions.count > 44 else {
      return nil
    }
    
    var temp : UInt8 = 0
    
    var mask : UInt8 = 0b00000001
    
    for index in 37 ... 44 {
      temp |= functions[index] ? mask : 0
      mask <<= 1
    }

    packet = [shortAddress, 0b11011001, temp]

    packet.append(SGDCCPacket.checksum(packet))
    
    decoderMode = .operationsMode
    
    super.init()
    
  }

  init?(longAddress:UInt16, f37toF44 functions:[Bool]) {
    
    let cv17 = SGDCCPacket.cv17(address: longAddress)
    
    guard longAddressPartition ~= cv17 && functions.count > 44 else {
      return nil
    }
    
    var temp : UInt8 = 0
    
    var mask : UInt8 = 0b00000001
    
    for index in 37 ... 44 {
      temp |= functions[index] ? mask : 0
      mask <<= 1
    }

    packet = [cv17, SGDCCPacket.cv18(address: longAddress), 0b11011001, temp]

    packet.append(SGDCCPacket.checksum(packet))
    
    decoderMode = .operationsMode
    
    super.init()
    
  }
  
  // F45 to F52 Function Control
  
  init?(shortAddress:UInt8, f45toF52 functions:[Bool]) {
    
    guard shortAddressPartition ~= shortAddress && functions.count > 52 else {
      return nil
    }
    
    var temp : UInt8 = 0
    
    var mask : UInt8 = 0b00000001
    
    for index in 45 ... 52 {
      temp |= functions[index] ? mask : 0
      mask <<= 1
    }

    packet = [shortAddress, 0b11011010, temp]

    packet.append(SGDCCPacket.checksum(packet))
    
    decoderMode = .operationsMode
    
    super.init()
    
  }

  init?(longAddress:UInt16, f45toF52 functions:[Bool]) {
    
    let cv17 = SGDCCPacket.cv17(address: longAddress)
    
    guard longAddressPartition ~= cv17 && functions.count > 52 else {
      return nil
    }
    
    var temp : UInt8 = 0
    
    var mask : UInt8 = 0b00000001
    
    for index in 45 ... 52 {
      temp |= functions[index] ? mask : 0
      mask <<= 1
    }

    packet = [cv17, SGDCCPacket.cv18(address: longAddress), 0b11011010, temp]

    packet.append(SGDCCPacket.checksum(packet))
    
    decoderMode = .operationsMode
    
    super.init()
    
  }
  
  // F53 to F60 Function Control
  
  init?(shortAddress:UInt8, f53toF60 functions:[Bool]) {
    
    guard shortAddressPartition ~= shortAddress && functions.count > 60 else {
      return nil
    }
    
    var temp : UInt8 = 0
    
    var mask : UInt8 = 0b00000001
    
    for index in 53 ... 60 {
      temp |= functions[index] ? mask : 0
      mask <<= 1
    }

    packet = [shortAddress, 0b11011011, temp]

    packet.append(SGDCCPacket.checksum(packet))
    
    decoderMode = .operationsMode
    
    super.init()
    
  }

  init?(longAddress:UInt16, f53toF60 functions:[Bool]) {
    
    let cv17 = SGDCCPacket.cv17(address: longAddress)
    
    guard longAddressPartition ~= cv17 && functions.count > 60 else {
      return nil
    }
    
    var temp : UInt8 = 0
    
    var mask : UInt8 = 0b00000001
    
    for index in 53 ... 60 {
      temp |= functions[index] ? mask : 0
      mask <<= 1
    }

    packet = [cv17, SGDCCPacket.cv18(address: longAddress), 0b11011011, temp]

    packet.append(SGDCCPacket.checksum(packet))
    
    decoderMode = .operationsMode
    
    super.init()
    
  }
  
  // F61 to F68 Function Control
  
  init?(shortAddress:UInt8, f61toF68 functions:[Bool]) {
    
    guard shortAddressPartition ~= shortAddress && functions.count > 68 else {
      return nil
    }
    
    var temp : UInt8 = 0
    
    var mask : UInt8 = 0b00000001
    
    for index in 61 ... 68 {
      temp |= functions[index] ? mask : 0
      mask <<= 1
    }

    packet = [shortAddress, 0b11011100, temp]

    packet.append(SGDCCPacket.checksum(packet))
    
    decoderMode = .operationsMode
    
    super.init()
    
  }

  init?(longAddress:UInt16, f61toF68 functions:[Bool]) {
    
    let cv17 = SGDCCPacket.cv17(address: longAddress)
    
    guard longAddressPartition ~= cv17 && functions.count > 68 else {
      return nil
    }
    
    var temp : UInt8 = 0
    
    var mask : UInt8 = 0b00000001
    
    for index in 61 ... 68 {
      temp |= functions[index] ? mask : 0
      mask <<= 1
    }

    packet = [cv17, SGDCCPacket.cv18(address: longAddress), 0b11011100, temp]

    packet.append(SGDCCPacket.checksum(packet))
    
    decoderMode = .operationsMode
    
    super.init()
    
  }
  // MARK: Speed and Direction
  
  // Speed and Direction Packet - 14 Speed Steps + 2 stops, Short Address

  init?(shortAddress:UInt8, speed14Steps speed:UInt8, direction:SGDCCLocomotiveDirection, functions:[Bool]) {
    
    guard shortAddressPartition ~= shortAddress && speed < 0b00010000 && functions.count > 0 else {
      return nil
    }
    
    decoderMode = .operationsMode
    
    let command : UInt8 = 0b01000000 | (functions[0] ? 0b00010000 : 0) | (speed) | (direction == .forward ? 0b00100000 : 0)
    
    packet = [shortAddress, command]
    
    packet.append(SGDCCPacket.checksum(packet))
    
    super.init()
    
  }
  
  // Speed and Direction Packet - 28 Speed Steps + 4 stops, Short Address

  init?(shortAddress:UInt8, speed28Steps speed:UInt8, direction:SGDCCLocomotiveDirection) {
    
    guard shortAddressPartition ~= shortAddress && speed < 0b00100000 else {
      return nil
    }
    
    self.decoderMode = .operationsMode
    
    let command : UInt8 = 0b01000000 | ((speed & 0b00000001) != 0 ? 0b00010000 : 0) | (speed >> 1) | (direction == .forward ? 0b00100000 : 0)
    
    packet = [shortAddress, command]
    
    packet.append(SGDCCPacket.checksum(packet))
    
    super.init()
    
  }

  // Speed and Direction Packet - 14 Speed Steps + 2 stops, Long Address

  init?(longAddress:UInt16, speed14Steps speed:UInt8, direction:SGDCCLocomotiveDirection, functions:[Bool]) {
    
    let cv17 = SGDCCPacket.cv17(address: longAddress)
    
    guard longAddressPartition ~= cv17 && speed < 0b00010000 && functions.count > 0 else {
      return nil
    }
    
    self.decoderMode = .operationsMode
    
    let command : UInt8 = 0b01000000 | (functions[0] ? 0b00010000 : 0) | (speed) | (direction == .forward ? 0b00100000 : 0)
    
    packet = [cv17, SGDCCPacket.cv18(address: longAddress), command]
    
    packet.append(SGDCCPacket.checksum(packet))
    
    super.init()
    
  }
  
  // Speed and Direction Packet - 28 Speed Steps + 4 stops, Long Address

  init?(longAddress:UInt16, speed28steps speed:UInt8, direction:SGDCCLocomotiveDirection) {
    
    let cv17 = SGDCCPacket.cv17(address: longAddress)

    guard longAddressPartition ~= cv17 && speed < 0b00100000 else {
      return nil
    }
    
    self.decoderMode = .operationsMode
    
    let command : UInt8 = 0b01000000 | ((speed & 0b00000001) != 0 ? 0b00010000 : 0) | (speed >> 1) | (direction == .forward ? 0b00100000 : 0)
    
    packet = [cv17, SGDCCPacket.cv18(address: longAddress), command]
    
    packet.append(SGDCCPacket.checksum(packet))
    
    super.init()
    
  }
  
  // Speed and Direction Packet - 126 Speed Steps + 2 stops, Short Address

  init?(shortAddress:UInt8, speed126Steps speed:UInt8, direction:SGDCCLocomotiveDirection) {
    
    guard shortAddressPartition ~= shortAddress && speed < 128 else {
      return nil
    }
    
    self.decoderMode = .operationsMode
    
    let data : UInt8 = speed | (direction == .forward ? 0b10000000 : 0)
    
    packet = [shortAddress, 0b00111111, data]

    packet.append(SGDCCPacket.checksum(packet))
    
    super.init()
    
  }

  // Speed and Direction Packet - 126 Speed Steps + 2 stops, Long Address

  init?(longAddress:UInt16, speed126Steps speed:UInt8, direction:SGDCCLocomotiveDirection) {
    
    let cv17 = SGDCCPacket.cv17(address: longAddress)
    
    guard longAddressPartition ~= cv17 && speed < 128 else {
      return nil
    }
    
    self.decoderMode = .operationsMode
    
    let data : UInt8 = speed | (direction == .forward ? 0b10000000 : 0)
    
    packet = [cv17, SGDCCPacket.cv18(address: longAddress), 0b00111111, data]
    
    packet.append(SGDCCPacket.checksum(packet))
    
    super.init()
    
  }
  
  // MARK: Private Properties
  
  private var _packetType : SGDCCPacketType?
  
  // MARK: Public Properties
  
  public var packet : [UInt8]
  
  public var decoderMode : SGDCCDecoderMode
  
  public var isChecksumOK : Bool {
    var checksum = packet[0]
    for index in 1 ... packet.count - 1 {
      checksum ^= packet[index]
    }
    return checksum == 0
  }
  
  // This function only works with 28/126 speed steps
  public var speed : UInt8? {
    switch packetType {
    case .speedAndDirectionPacket:
      let byte = packet[packet.count - 2] & 0b00011111
      return ((byte & 0b000001111) << 1) | ((byte & 0b00010000 != 0) ? 1 : 0)
    case .speedStepControl128:
      return packet[packet.count - 2] & 0x7f
    default:
      return nil
    }
  }

  // This function only works with 14 speed steps
  public var speed14Steps : UInt8? {
    switch packetType {
    case .speedAndDirectionPacket:
      return packet[packet.count - 2] & 0b00001111
    default:
      return nil
    }
  }

  public var direction : SGDCCLocomotiveDirection? {
    switch packetType {
    case .speedAndDirectionPacket:
      return (packet[packet.count - 2] & 0b00100000) != 0 ? .forward : .reverse
    case .speedStepControl128:
      return (packet[packet.count - 2] & 0b10000000) != 0 ? .forward : .reverse
    default:
      return nil
    }
  }
  public var shortAddress : UInt8? {
    guard !packet.isEmpty, shortAddressPartition ~= packet[0] else {
      return nil
    }
    return packet[0]
  }
  
  public var longAddress : UInt16? {
    guard packet.count > 1, longAddressPartition ~= packet[0] else {
      return nil
    }
    return (UInt16(packet[0]) << 8 | UInt16(packet[1])) - 49152
  }

  public var functions : [Bool]? {
    var result = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
    switch packetType {
    case .functionFLF1F4:
      let byte = packet[packet.count - 2]
      result[0] = (byte & 0b00010000) != 0
      var mask : UInt8 = 0b00000001
      for index in 1 ... 4 {
        result[index] = (byte & mask) != 0
        mask <<= 1
      }
    case .functionF5F8:
      let byte = packet[packet.count - 2]
      var mask : UInt8 = 0b00000001
      for index in 5 ... 8 {
        result[index] = (byte & mask) != 0
        mask <<= 1
      }
    case .functionF9F12:
      let byte = packet[packet.count - 2]
      var mask : UInt8 = 0b00000001
      for index in 9 ... 12 {
        result[index] = (byte & mask) != 0
        mask <<= 1
      }
    case .functionF13F20:
      let byte = packet[packet.count - 2]
      var mask : UInt8 = 0b00000001
      for index in 13 ... 20 {
        result[index] = (byte & mask) != 0
        mask <<= 1
      }
    case .functionF21F28:
      let byte = packet[packet.count - 2]
      var mask : UInt8 = 0b00000001
      for index in 21 ... 28 {
        result[index] = (byte & mask) != 0
        mask <<= 1
      }
    case .functionF29F36:
      let byte = packet[packet.count - 2]
      var mask : UInt8 = 0b00000001
      for index in 29 ... 36 {
        result[index] = (byte & mask) != 0
        mask <<= 1
      }
    case .functionF37F44:
      let byte = packet[packet.count - 2]
      var mask : UInt8 = 0b00000001
      for index in 37 ... 44 {
        result[index] = (byte & mask) != 0
        mask <<= 1
      }
    case .functionF45F52:
      let byte = packet[packet.count - 2]
      var mask : UInt8 = 0b00000001
      for index in 45 ... 52 {
        result[index] = (byte & mask) != 0
        mask <<= 1
      }
    case .functionF53F60:
      let byte = packet[packet.count - 2]
      var mask : UInt8 = 0b00000001
      for index in 53 ... 60 {
        result[index] = (byte & mask) != 0
        mask <<= 1
      }
    case .functionF61F68:
      let byte = packet[packet.count - 2]
      var mask : UInt8 = 0b00000001
      for index in 61 ... 68 {
        result[index] = (byte & mask) != 0
        mask <<= 1
      }
    case .speedAndDirectionPacket:
      result[0] = (packet[packet.count - 2] & 0b00010000) != 0
    default:
      return nil
    }
    return result
  }
  
  public var cvNumber : UInt16? {
    
    guard validDirectModeCVPackets.contains(packetType) else {
      return nil
    }
    
    return ((UInt16(packet[0] & 0b00000011) << 8) | UInt16(packet[1])) + 1
    
  }
  
  public var cvBitNumber : Int? {
    
    guard validDirectModeCVPackets.contains(packetType) && (packet[0] & 0b00001100) == 0b00001000 else {
      return nil
    }
    
    return Int(packet[2] & 0b000000111)
    
  }

  public var cvBitValue : Int? {
    
    guard validDirectModeCVPackets.contains(packetType) && (packet[0] & 0b00001100) == 0b00001000 else {
      return nil
    }
    
    return Int(packet[2] & 0b000001000) >> 3
    
  }

  public var cvValue : UInt8? {
    
    guard packetType == .directModeWriteByte || packetType == .directModeVerifyByte else {
      return nil
    }
    
    return packet[2]
    
  }
  
  public var packetType : SGDCCPacketType {
    
    if _packetType == nil {
      
      let serviceModeMask : UInt8 = 0b01110000
      
      if decoderMode == .operationsMode {
        
        var isMultiFunctionDecoder = false
        var isShortAddress : Bool?
        
        switch packet[0] {
        case 0:                  // Broadcast address
          break
        case shortAddressPartition:          // Multi-function decoders with short addresses
          isMultiFunctionDecoder = true
          isShortAddress = true
        case 128 ... 191:        // Basic accessory decoders
          break
        case longAddressPartition:        // Multi-function decoders with long addresses
          isMultiFunctionDecoder = true
          isShortAddress = false
        case 232 ... 252:        // Reserved for future use
          break
        case 253 ... 254:        // Advanced extended packet formats
          break
        case 255: // Idle packet
          break
        default:
          break
        }
        
        if isMultiFunctionDecoder, let isShortAddress {
          
          let index = isShortAddress ? 1 : 2
          
          switch packet[index] & 0b11100000 {
          case 0b00000000: // Decoder & Consist Control
            break
          case 0b00100000: // Advanced Operations Instructions
            switch packet[index] & 0b00011111 {
            case 0b00011111:
              _packetType = .speedStepControl128
            case 0b00011101:
              _packetType = .analogFunctionGroup
            default:
              break
            }
          case 0b01000000, 0b01100000:
            _packetType = .speedAndDirectionPacket
          case 0b10000000: // Function Group One Instruction
            _packetType = .functionFLF1F4
          case 0b10100000: // Function Group Two Instruction
            switch packet[index] & 0b00010000 {
            case 0b00000000:
              _packetType = .functionF9F12
            case 0b00010000:
              _packetType = .functionF5F8
            default:
              break
            }
          case 0b11000000: // Feature Expansion
            switch packet[index] & 0b00011111 {
            case 0b00000000:
              _packetType = .binaryStateControlLongForm
            case 0b00000001:
              _packetType = .timeAndDateCommand
            case 0b00000010:
              _packetType = .systemTime
            case 0b00011101:
              _packetType = .binaryStateControlShortForm
            case 0b00011110:
              _packetType = .functionF13F20
            case 0b00011111:
              _packetType = .functionF21F28
            case 0b00011000:
              _packetType = .functionF29F36
            case 0b00011001:
              _packetType = .functionF37F44
            case 0b00011010:
              _packetType = .functionF45F52
            case 0b00011011:
              _packetType = .functionF53F60
            case 0b00011100:
              _packetType = .functionF61F68
            default:
              break
            }
          case 0b11100000: // CV Access Instruction
            switch packet[index] & 0b00010000 {
            case 0b00000000:
              switch packet[index] & 0b00001100 {
              case 0b00000100:
                _packetType = .cvAccessVerifyByte
              case 0b00001100:
                _packetType = .cvAccessWriteByte
              case 0b00001000:
                switch packet[index + 2] & 0b11110000 {
                case 0b11100000:
                  _packetType = .cvAccessVerifyBit
                case 0b11110000:
                  _packetType = .cvAccessWriteBit
                default:
                  break
                }
              default:
                break
              }
            case 0b00010000:
              switch packet[index] & 0b00001111 {
              case 0b00000010:
                _packetType = .cvAccessAccelerationAdjustment
              case 0b00000011:
                _packetType = .cvAccessDeclerationAdjustment
              case 0b00000100:
                _packetType = .cvAccessLongAddress
              case 0b00000101:
                _packetType = .cvAccessIndexedCVs
              default:
                break
              }
            default:
              break
            }
          default:
            break
          }

        }
        
      }
      else {
        
        switch decoderMode {
        case .serviceModeDirectAddressing:
          if packet.count == 4 && (packet[0] & serviceModeMask) == serviceModeMask {
            switch packet[0] & 0b00001100 {
            case 0b00000100:
              _packetType = .directModeVerifyByte
            case 0b00001100:
              _packetType = .directModeWriteByte
            case 0b00001000:
              if (packet[2] & 0b11100000) == 0xe0 {
                switch packet[2] & 0b00010000 {
                case 0b00000000:
                  _packetType = .directModeVerifyBit
                case 0b00010000:
                  _packetType = .directModeWriteBit
                default:
                  break
                }
              }
            default:
              break
            }
          }
        case .serviceModeAddressOnly:
          if packet.count == 3 && (packet[0] & serviceModeMask) == serviceModeMask && (packet[0] & 0b00000111) == 0 && (packet[1] & 0b10000000) == 0 {
            switch packet[0] & 0b00001000 {
            case 0b00001000:
              _packetType = .addressOnlyWriteAddress
            case 0b00000000:
              _packetType = .addressOnlyVerifyAddress
            default:
              break
            }
          }
        case .serviceModePhysicalRegister:
          if packet.count == 3 && (packet[0] & serviceModeMask) == serviceModeMask {
            switch packet[0] & 0b00001000 {
            case 0b00001000:
              _packetType = .physicalRegisterWriteByte
            case 0b00000000:
              _packetType = .physicalRegisterVerifyByte
            default:
              break
            }
          }
        case .serviceModePagedAddressing:
          if packet.count == 3 && (packet[0] & serviceModeMask) == serviceModeMask {
            switch packet[0] & 0b00001000 {
            case 0b00001000:
              _packetType = .pagedModeWriteByte
            case 0b00000000:
              _packetType = .pagedModeVerifyByte
            default:
              break
            }
          }
        default:
          break
        }
        
        if _packetType == nil {
          
          if packet.count == 3 {
            if packet[0] == 0b01111101 && packet[1] == 0b00000001 && packet[2] == 0b01111100 {
              _packetType = .pagePresetInstruction
            }
            
          }
        }
        
      }
      
      if _packetType == nil {
                
        if packet[0] == 0 && packet[1] == 0 && packet[2] == 0 {
          _packetType = .digitalDecoderResetPacket
        }
        else if packet[0] == 0xff && packet[1] == 0 && packet[2] == 0xff {
          _packetType = .digitalDecoderIdlePacket
        }
        else {
          _packetType = .unknown
        }

      }

    }
    
    return _packetType!
    
  }
  
  // MARK: Private Class Properties
  
  private let validDirectModeCVPackets : Set<SGDCCPacketType> = [
    .directModeWriteBit,
    .directModeVerifyBit,
    .directModeWriteByte,
    .directModeVerifyByte,
  ]
  
  // MARK: Public Class Properties
  
  public static let highestFunction = 68
  
  // MARK: Public Class Methods
  
  public static func checksum(_ packet:[UInt8]) -> UInt8 {
    var checksum = packet[0]
    for index in 1 ... packet.count - 1 {
      checksum ^= packet[index]
    }
    return checksum
  }

  public static func cv17(address: UInt16) -> UInt8 {
    return UInt8((address + 49152) >> 8)
  }
  
  public static func cv18(address: UInt16) -> UInt8 {
    return UInt8((address + 49152) & 0xff)
  }
  
  public static func digitalDecoderResetPacket() -> SGDCCPacket {
    return SGDCCPacket(data: [0x00, 0x00])!
  }

  public static func digitalDecoderIdlePacket() -> SGDCCPacket {
    return SGDCCPacket(data: [0xff, 0x00])!
  }

}
