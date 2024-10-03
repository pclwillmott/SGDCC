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
//     24/09/2024  Paul Willmott - Service Mode - Direct Mode packets added
//     25/09/2024  Paul Willmott - Service Mode - packets added for Address
//                                 Only, Paged Mode, and Physical Register
// -----------------------------------------------------------------------------

import Foundation

private let shortAddressPartition = UInt8(1)   ... UInt8(127)

private let longAddressPartition  = UInt8(192) ... UInt8(231)

public class SGDCCPacket : NSObject {
  
  // MARK: Constructors & Destructors
  
  private init(data:[UInt8], decoderMode:SGDCCDecoderMode = .operationsMode) {
    
    self.packet = data
    
    self.decoderMode = decoderMode
    
    self.packet.append(SGDCCPacket.checksum(self.packet))
    
    super.init()
    
  }
  
  public init?(packet:[UInt8], decoderMode:SGDCCDecoderMode = .operationsMode) {
    
    self.packet  = packet
    
    self.decoderMode = decoderMode
    
    super.init()
    
    guard packet.count > 1 && isChecksumOK else {
      return nil
    }
    
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
    switch decoderMode {
    case .operationsMode:
      guard !packet.isEmpty, shortAddressPartition ~= packet[0] else {
        return nil
      }
      return packet[0]
    case .serviceModePhysicalRegister:
      if (packet[0] & 0b00000111) == 0 {
        return packet[1]
      }
    case .serviceModeAddressOnly:
      return packet[1]
    default:
      break
    }
    return nil
  }
  
  public var longAddress : UInt16? {
    guard packet.count > 1, longAddressPartition ~= packet[0] else {
      return nil
    }
    return (UInt16(packet[0]) << 8 | UInt16(packet[1])) - 49152
  }

  public var functions : SGFunctionGroup? {
    
    var result = SGFunctionGroup()

    let byte = packet[packet.count - 2]

    func bits(_ range: ClosedRange<Int>) {
      var mask : UInt8 = 0b00000001
      for index in range {
        result.set(index: index, value: (byte & mask) != 0)
        mask <<= 1
      }
    }

    switch packetType {
    case .functionF0F4:
      result.set(index: 0, value: (byte & 0b00010000) != 0)
      bits(1...4)
    case .functionF5F8:
      bits(5...8)
    case .functionF9F12:
      bits(9...12)
    case .functionF13F20:
      bits(13...20)
    case .functionF21F28:
      bits(21...28)
    case .functionF29F36:
      bits(29...36)
    case .functionF37F44:
      bits(37...44)
    case .functionF45F52:
      bits(45...52)
    case .functionF53F60:
      bits(53...60)
    case .functionF61F68:
      bits(61...68)
    case .speedAndDirectionPacket:
      result.set(index: 0, value: (byte & 0b00010000) != 0)
    default:
      return nil
    }
    return result
  }
  
  // This property assumes that the decoder is a mobile digital decoder.
  public var cvNumber : UInt16? {
    
    switch packetType {
    case .directModeWriteBit, .directModeVerifyBit, .directModeWriteByte, .directModeVerifyByte:
      return ((UInt16(packet[0] & 0b00000011) << 8) | UInt16(packet[1])) + 1
    case .addressOnlyVerifyAddress, .addressOnlyWriteAddress:
      return 1
    case .physicalRegisterWriteByte, .physicalRegisterVerifyByte:
      switch physicalRegister {
      case 1:
        return 1
      case 2:
        return 2
      case 3:
        return 3
      case 4:
        return 4
      case 5:
        return 29
      case 7:
        return 7
      case 8:
        return 8
      default:
        break
      }
    default:
      break
    }
    return nil
  }
  
  public var physicalRegister : UInt8? {
    
    switch packetType {
    case .addressOnlyWriteAddress, .addressOnlyVerifyAddress:
      return 1
    case .physicalRegisterWriteByte, .physicalRegisterVerifyByte:
      return (packet[0] & 0x7) + 1
    default:
      return nil
    }
    
  }
  
  public var cvValue : UInt8? {
    
    switch packetType {
    case .directModeWriteByte, .directModeVerifyByte:
      return packet[2]
    case .physicalRegisterWriteByte, .physicalRegisterVerifyByte:
      return packet[1]
    default:
      return nil
    }
    
  }
  
  public var cvBitNumber : Int? {
    
    switch packetType {
    case .directModeWriteBit, .directModeVerifyBit:
      return Int(packet[2] & 0b000000111)
    default:
      return nil
    }
    
  }

  public var cvBitValue : Int? {
    
    switch packetType {
    case .directModeWriteBit, .directModeVerifyBit:
      return Int(packet[2] & 0b000001000) >> 3
    default:
      return nil
    }
    
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
            _packetType = .functionF0F4
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
        case .serviceModeDirectMode:
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
          if packet.count == 3 {
            if packet == [0b01111101, 0b00000001, 0b01111100] {
              _packetType = .pagePresetInstruction
            }
            else if (packet[0] & serviceModeMask) == serviceModeMask && (packet[0] & 0b00000111) == 0 && (packet[1] & 0b10000000) == 0 {
              switch packet[0] & 0b00001000 {
              case 0b00001000:
                _packetType = .addressOnlyWriteAddress
              case 0b00000000:
                _packetType = .addressOnlyVerifyAddress
              default:
                break
              }
            }
          }
        case .serviceModePhysicalRegister:
          if packet.count == 3 {
            if packet == [0b01111101, 0b00000001, 0b01111100] {
              _packetType = .pagePresetInstruction
            }
            else if (packet[0] & serviceModeMask) == serviceModeMask {
              switch packet[0] & 0b00001000 {
              case 0b00001000:
                _packetType = .physicalRegisterWriteByte
              case 0b00000000:
                _packetType = .physicalRegisterVerifyByte
              default:
                break
              }
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
        
      }
      
      if _packetType == nil {
                
        if packet == [0, 0, 0] {
          _packetType = .digitalDecoderResetPacket
        }
        else if packet == [0xff, 0, 0xff] {
          _packetType = .digitalDecoderIdlePacket
        }
        else {
          _packetType = .unknown
        }

      }

    }
    
    return _packetType!
    
  }
  
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
  
  // MARK: Idle & Reset
  
  public static func digitalDecoderResetPacket() -> SGDCCPacket {
    return SGDCCPacket(data: [0x00, 0x00])
  }

  public static func digitalDecoderIdlePacket() -> SGDCCPacket {
    return SGDCCPacket(data: [0xff, 0x00])
  }

  public static func pagePresetInstruction(decoderMode:SGDCCDecoderMode = .serviceModePhysicalRegister) -> SGDCCPacket {
    return SGDCCPacket(data: [0b01111101, 0b00000001], decoderMode: decoderMode)
  }

  // MARK: Functions
  
  // Function Group One Instruction
  
  public static func f0f4Control(shortAddress address:UInt8, functions:SGFunctionGroup) -> SGDCCPacket? {
    
    guard shortAddressPartition ~= address else {
      return nil
    }
        
    var mask : UInt8 = 0b00000001
    
    var temp : UInt8 = 0
    for index in 1 ... 4 {
      temp |= functions.get(index: index) ? mask : 0
      mask <<= 1
    }

    return SGDCCPacket(data: [address, 0b10000000 | (functions.get(index: 0) ? 0b00010000 : 0) | temp])
    
  }
  
  public static func f0f4Control(longAddress address:UInt16, functions:SGFunctionGroup) -> SGDCCPacket? {
    
    let cv17 = SGDCCPacket.cv17(address: address)
    
    guard longAddressPartition ~= cv17 else {
      return nil
    }
        
    var mask : UInt8 = 0b00000001
    
    var temp : UInt8 = 0
    for index in 1 ... 4 {
      temp |= functions.get(index: index) ? mask : 0
      mask <<= 1
    }

    return SGDCCPacket(data: [cv17, SGDCCPacket.cv18(address: address), 0b10000000 | (functions.get(index: 0) ? 0b00010000 : 0) | temp])
    
  }

  // Function Group Two Instructions
  
  public static func f5f8Control(shortAddress address:UInt8, functions:SGFunctionGroup) -> SGDCCPacket? {
    
    guard shortAddressPartition ~= address else {
      return nil
    }
        
    var mask : UInt8 = 0b00000001
    
    var temp : UInt8 = 0
    for index in 5 ... 8 {
      temp |= functions.get(index: index) ? mask : 0
      mask <<= 1
    }

    return SGDCCPacket(data: [address, 0b10110000 | temp])
    
  }

  public static func f5f8Control(longAddress address:UInt16, functions:SGFunctionGroup) -> SGDCCPacket? {
    
    let cv17 = SGDCCPacket.cv17(address: address)
    
    guard longAddressPartition ~= cv17 else {
      return nil
    }
        
    var mask : UInt8 = 0b00000001
    
    var temp : UInt8 = 0
    for index in 5 ... 8 {
      temp |= functions.get(index: index) ? mask : 0
      mask <<= 1
    }

    return SGDCCPacket(data: [cv17, SGDCCPacket.cv18(address: address), 0b10110000 | temp])
    
  }

  public static func f9f12Control(shortAddress address:UInt8, functions:SGFunctionGroup) -> SGDCCPacket? {
    
    guard shortAddressPartition ~= address else {
      return nil
    }
    
    var mask : UInt8 = 0b00000001
    
    var temp : UInt8 = 0
    for index in 9 ... 12 {
      temp |= functions.get(index: index) ? mask : 0
      mask <<= 1
    }

    return SGDCCPacket(data: [address, 0b10100000 | temp])
    
  }

  public static func f9f12Control(longAddress address:UInt16, functions:SGFunctionGroup) -> SGDCCPacket? {
    
    let cv17 = SGDCCPacket.cv17(address: address)
    
    guard longAddressPartition ~= cv17 else {
      return nil
    }
        
    var mask : UInt8 = 0b00000001
    
    var temp : UInt8 = 0
    for index in 9 ... 12 {
      temp |= functions.get(index: index) ? mask : 0
      mask <<= 1
    }

    return SGDCCPacket(data: [cv17, SGDCCPacket.cv18(address: address), 0b10100000 | temp])
    
  }
  
  // F13 to F20 Function Control
  
  public static func f13f20Control(shortAddress address:UInt8, functions:SGFunctionGroup) -> SGDCCPacket? {
    
    guard shortAddressPartition ~= address else {
      return nil
    }
        
    var mask : UInt8 = 0b00000001
    
    var temp : UInt8 = 0
    for index in 13 ... 20 {
      temp |= functions.get(index: index) ? mask : 0
      mask <<= 1
    }

    return SGDCCPacket(data: [address, 0b11011110, temp])
    
  }

  public static func f13f20Control(longAddress address:UInt16, functions:SGFunctionGroup) -> SGDCCPacket? {
    
    let cv17 = SGDCCPacket.cv17(address: address)
    
    guard longAddressPartition ~= cv17 else {
      return nil
    }
    
    var temp : UInt8 = 0
    
    var mask : UInt8 = 0b00000001
    
    for index in 13 ... 20 {
      temp |= functions.get(index: index) ? mask : 0
      mask <<= 1
    }

    return SGDCCPacket(data: [cv17, SGDCCPacket.cv18(address: address), 0b11011110, temp])
    
  }

  // F21 to F28 Function Control
  
  public static func f21f28Control(shortAddress address:UInt8, functions:SGFunctionGroup) -> SGDCCPacket? {
    
    guard shortAddressPartition ~= address else {
      return nil
    }
        
    var mask : UInt8 = 0b00000001
    
    var temp : UInt8 = 0
    for index in 21 ... 28 {
      temp |= functions.get(index: index) ? mask : 0
      mask <<= 1
    }

    return SGDCCPacket(data: [address, 0b11011111, temp])
    
  }

  public static func f21f28Control(longAddress address:UInt16, functions:SGFunctionGroup) -> SGDCCPacket? {
    
    let cv17 = SGDCCPacket.cv17(address: address)
    
    guard longAddressPartition ~= cv17 else {
      return nil
    }
        
    var mask : UInt8 = 0b00000001
    
    var temp : UInt8 = 0
    for index in 21 ... 28 {
      temp |= functions.get(index: index) ? mask : 0
      mask <<= 1
    }

    return SGDCCPacket(data: [cv17, SGDCCPacket.cv18(address: address), 0b11011111, temp])
    
  }
  
  // F29 to F36 Function Control
  
  public static func f29f36Control(shortAddress address:UInt8, functions:SGFunctionGroup) -> SGDCCPacket? {
    
    guard shortAddressPartition ~= address else {
      return nil
    }
        
    var mask : UInt8 = 0b00000001
    
    var temp : UInt8 = 0
    for index in 29 ... 36 {
      temp |= functions.get(index: index) ? mask : 0
      mask <<= 1
    }

    return SGDCCPacket(data: [address, 0b11011000, temp])
    
  }

  public static func f29f36Control(longAddress address:UInt16, functions:SGFunctionGroup) -> SGDCCPacket? {
    
    let cv17 = SGDCCPacket.cv17(address: address)
    
    guard longAddressPartition ~= cv17 else {
      return nil
    }
        
    var mask : UInt8 = 0b00000001
    
    var temp : UInt8 = 0
    for index in 29 ... 36 {
      temp |= functions.get(index: index) ? mask : 0
      mask <<= 1
    }

    return SGDCCPacket(data: [cv17, SGDCCPacket.cv18(address: address), 0b11011000, temp])
    
  }
  
  // F37 to F44 Function Control
  
  public static func f37f44Control(shortAddress address:UInt8, functions:SGFunctionGroup) -> SGDCCPacket? {
    
    guard shortAddressPartition ~= address else {
      return nil
    }
        
    var mask : UInt8 = 0b00000001
    
    var temp : UInt8 = 0
    for index in 37 ... 44 {
      temp |= functions.get(index: index) ? mask : 0
      mask <<= 1
    }

    return SGDCCPacket(data: [address, 0b11011001, temp])
    
  }

  public static func f37f44Control(longAddress address :UInt16, functions:SGFunctionGroup) -> SGDCCPacket? {
    
    let cv17 = SGDCCPacket.cv17(address: address)
    
    guard longAddressPartition ~= cv17 else {
      return nil
    }
        
    var mask : UInt8 = 0b00000001
    
    var temp : UInt8 = 0
    for index in 37 ... 44 {
      temp |= functions.get(index: index) ? mask : 0
      mask <<= 1
    }

    return SGDCCPacket(data: [cv17, SGDCCPacket.cv18(address: address), 0b11011001, temp])
    
  }
  
  // F45 to F52 Function Control
  
  public static func f45f52Control(shortAddress address:UInt8, functions:SGFunctionGroup) -> SGDCCPacket? {
    
    guard shortAddressPartition ~= address else {
      return nil
    }
        
    var mask : UInt8 = 0b00000001
    
    var temp : UInt8 = 0
    for index in 45 ... 52 {
      temp |= functions.get(index: index) ? mask : 0
      mask <<= 1
    }

    return SGDCCPacket(data: [address, 0b11011010, temp])
    
  }

  public static func f45f52Control(longAddress address:UInt16, functions:SGFunctionGroup) -> SGDCCPacket? {
    
    let cv17 = SGDCCPacket.cv17(address: address)
    
    guard longAddressPartition ~= cv17 else {
      return nil
    }
        
    var mask : UInt8 = 0b00000001
    
    var temp : UInt8 = 0
    for index in 45 ... 52 {
      temp |= functions.get(index: index) ? mask : 0
      mask <<= 1
    }

    return SGDCCPacket(data: [cv17, SGDCCPacket.cv18(address: address), 0b11011010, temp])
    
  }
  
  // F53 to F60 Function Control
  
  public static func f53f60Control(shortAddress address:UInt8, functions:SGFunctionGroup) -> SGDCCPacket? {
    
    guard shortAddressPartition ~= address else {
      return nil
    }
        
    var mask : UInt8 = 0b00000001
    
    var temp : UInt8 = 0
    for index in 53 ... 60 {
      temp |= functions.get(index: index) ? mask : 0
      mask <<= 1
    }

    return SGDCCPacket(data: [address, 0b11011011, temp])
    
  }

  public static func f53f60Control(longAddress address:UInt16, functions:SGFunctionGroup) -> SGDCCPacket? {
    
    let cv17 = SGDCCPacket.cv17(address: address)
    
    guard longAddressPartition ~= cv17 else {
      return nil
    }
        
    var mask : UInt8 = 0b00000001
    
    var temp : UInt8 = 0
    for index in 53 ... 60 {
      temp |= functions.get(index: index) ? mask : 0
      mask <<= 1
    }

    return SGDCCPacket(data: [cv17, SGDCCPacket.cv18(address: address), 0b11011011, temp])
    
  }
  
  // F61 to F68 Function Control
  
  public static func f61f68Control(shortAddress address:UInt8, functions:SGFunctionGroup) -> SGDCCPacket? {
    
    guard shortAddressPartition ~= address else {
      return nil
    }
        
    var mask : UInt8 = 0b00000001
    
    var temp : UInt8 = 0
    for index in 61 ... 68 {
      temp |= functions.get(index: index) ? mask : 0
      mask <<= 1
    }

    return SGDCCPacket(data: [address, 0b11011100, temp])
    
  }

  public static func f61f68Control(longAddress address:UInt16, functions:SGFunctionGroup) -> SGDCCPacket? {
    
    let cv17 = SGDCCPacket.cv17(address: address)
    
    guard longAddressPartition ~= cv17 else {
      return nil
    }
        
    var mask : UInt8 = 0b00000001
    
    var temp : UInt8 = 0
    for index in 61 ... 68 {
      temp |= functions.get(index: index) ? mask : 0
      mask <<= 1
    }

    return SGDCCPacket(data: [cv17, SGDCCPacket.cv18(address: address), 0b11011100, temp])
    
  }

  // MARK: Speed and Direction
  
  // Speed and Direction Packet - 14 Speed Steps + 2 stops, Short Address

  public static func speedAndDirection(shortAddress address:UInt8, speed14Steps speed:UInt8, direction:SGDCCLocomotiveDirection, functions:SGFunctionGroup) -> SGDCCPacket? {
    
    guard shortAddressPartition ~= address && speed < 0b00010000 else {
      return nil
    }
    
    let command : UInt8 = 0b01000000 | (functions.get(index: 0) ? 0b00010000 : 0) | (speed) | (direction == .forward ? 0b00100000 : 0)
    
    return SGDCCPacket(data: [address, command])
    
  }
  
  // Speed and Direction Packet - 14 Speed Steps + 2 stops, Long Address

  public static func speedAndDirection(longAddress address:UInt16, speed14Steps speed:UInt8, direction:SGDCCLocomotiveDirection, functions:SGFunctionGroup) -> SGDCCPacket? {
    
    let cv17 = SGDCCPacket.cv17(address: address)
    
    guard longAddressPartition ~= cv17 && speed < 0b00010000 else {
      return nil
    }
    
    let command : UInt8 = 0b01000000 | (functions.get(index: 0) ? 0b00010000 : 0) | (speed) | (direction == .forward ? 0b00100000 : 0)
    
    return SGDCCPacket(data: [cv17, SGDCCPacket.cv18(address: address), command])
    
  }
  
  // Speed and Direction Packet - 28 Speed Steps + 4 stops, Short Address

  public static func speedAndDirection(shortAddress address:UInt8, speed28Steps speed:UInt8, direction:SGDCCLocomotiveDirection) -> SGDCCPacket? {
    
    guard shortAddressPartition ~= address && speed < 0b00100000 else {
      return nil
    }
    
    let command : UInt8 = 0b01000000 | ((speed & 0b00000001) != 0 ? 0b00010000 : 0) | (speed >> 1) | (direction == .forward ? 0b00100000 : 0)
    
    return SGDCCPacket(data: [address, command])
    
  }

  // Speed and Direction Packet - 28 Speed Steps + 4 stops, Long Address

  public static func speedAndDirection(longAddress address:UInt16, speed28steps speed:UInt8, direction:SGDCCLocomotiveDirection) -> SGDCCPacket? {
    
    let cv17 = SGDCCPacket.cv17(address: address)

    guard longAddressPartition ~= cv17 && speed < 0b00100000 else {
      return nil
    }
    
    let command : UInt8 = 0b01000000 | ((speed & 0b00000001) != 0 ? 0b00010000 : 0) | (speed >> 1) | (direction == .forward ? 0b00100000 : 0)
    
    return SGDCCPacket(data: [cv17, SGDCCPacket.cv18(address: address), command])
    
  }
    
  // Speed and Direction Packet - 126 Speed Steps + 2 stops, Short Address

  public static func speedAndDirection(shortAddress address:UInt8, speed126Steps speed:UInt8, direction:SGDCCLocomotiveDirection) -> SGDCCPacket? {
    
    guard shortAddressPartition ~= address && speed < 128 else {
      return nil
    }
    
    return SGDCCPacket(data: [address, 0b00111111, speed | (direction == .forward ? 0b10000000 : 0)])
    
  }

  // Speed and Direction Packet - 126 Speed Steps + 2 stops, Long Address

  public static func speedAndDirection(longAddress address:UInt16, speed126Steps speed:UInt8, direction:SGDCCLocomotiveDirection) -> SGDCCPacket? {
    
    let cv17 = SGDCCPacket.cv17(address: address)
    
    guard longAddressPartition ~= cv17 && speed < 128 else {
      return nil
    }
    
    return SGDCCPacket(data: [cv17, SGDCCPacket.cv18(address: address), 0b00111111, speed | (direction == .forward ? 0b10000000 : 0)])
    
  }
  
  // MARK: Service Mode, Direct Mode
  
  // Write CV Byte
  
  public static func writeCVByteDirectMode(cvNumber:UInt16, value:UInt8) -> SGDCCPacket? {
    
    guard (1 ... 1024) ~= cvNumber else {
      return nil
    }
    
    let temp = cvNumber - 1
    
    return SGDCCPacket(data: [0b01111100 | UInt8(temp >> 8), UInt8(temp & 0xff), value], decoderMode: .serviceModeDirectMode)

  }

  // Verify CV Byte
  
  public static func verifyCVByteDirectMode(cvNumber:UInt16, value:UInt8) -> SGDCCPacket? {
    
    guard (1 ... 1024) ~= cvNumber else {
      return nil
    }
    
    let temp = cvNumber - 1
    
    return SGDCCPacket(data: [0b01110100 | UInt8(temp >> 8), UInt8(temp & 0xff), value], decoderMode: .serviceModeDirectMode)

  }

  // Write CV Bit
  
  public static func writeCVBitDirectMode(cvNumber:UInt16, bit:UInt8, value:UInt8) -> SGDCCPacket? {
    
    guard (1 ... 1024) ~= cvNumber && (0 ... 7) ~= bit && (0 ... 1) ~= value else {
      return nil
    }
    
    let temp = cvNumber - 1
    
    return SGDCCPacket(data: [0b01111000 | UInt8(temp >> 8), UInt8(temp & 0xff), 0b11110000 | (value << 3) | bit], decoderMode: .serviceModeDirectMode)

  }

  // Verify CV Bit
  
  public static func verifyCVBitDirectMode(cvNumber:UInt16, bit:UInt8, value:UInt8) -> SGDCCPacket? {
    
    guard (1 ... 1024) ~= cvNumber && (0 ... 7) ~= bit && (0 ... 1) ~= value else {
      return nil
    }
    
    let temp = cvNumber - 1
    
    return SGDCCPacket(data: [0b01111000 | UInt8(temp >> 8), UInt8(temp & 0xff), 0b11100000 | (value << 3) | bit], decoderMode: .serviceModeDirectMode)

  }
  
  // MARK: Service Mode, Address-Only Mode
  
  public static func verifyCVByteAddressOnlyMode(shortAddress address:UInt8) -> SGDCCPacket? {
    
    guard (1 ... 127) ~= address else {
      return nil
    }
    
    return SGDCCPacket(data: [0b01110000, address], decoderMode: .serviceModeAddressOnly)

  }

  public static func writeCVByteAddressOnlyMode(shortAddress address:UInt8) -> SGDCCPacket? {
    
    guard (1 ... 127) ~= address else {
      return nil
    }
    
    return SGDCCPacket(data: [0b01111000, address], decoderMode: .serviceModeAddressOnly)

  }
  
  // MARK: Service Mode, Physical Register Addressing
  
  public static func verifyCVBytePhysicalRegister(physicalRegister:UInt8, value:UInt8) -> SGDCCPacket? {
    
    guard (1 ... 8) ~= physicalRegister && (physicalRegister != 1 || (1 ... 127) ~= value) else {
      return nil
    }
    
    return SGDCCPacket(data: [0b01110000 | (physicalRegister - 1), value], decoderMode: .serviceModePhysicalRegister)

  }

  public static func writeCVBytePhysicalRegister(physicalRegister:UInt8, value:UInt8) -> SGDCCPacket? {
    
    guard (1 ... 8) ~= physicalRegister && (physicalRegister != 1 || (1 ... 127) ~= value) else {
      return nil
    }
    
    return SGDCCPacket(data: [0b01111000 | (physicalRegister - 1), value], decoderMode: .serviceModePhysicalRegister)

  }

  // MARK: Service Mode, Paged Mode Addressing
  // TODO: Add tests for these methods
  
  public static func verifyRegisterBytePagedMode(physicalRegister:UInt8, value:UInt8) -> SGDCCPacket? {
    
    guard (1 ... 6) ~= physicalRegister else {
      return nil
    }
    
    return SGDCCPacket(data: [0b01110000 | (physicalRegister - 1), value], decoderMode: .serviceModePagedAddressing)

  }

  public static func writeRegisterBytePagedMode(physicalRegister:UInt8, value:UInt8) -> SGDCCPacket? {
    
    guard (1 ... 6) ~= physicalRegister else {
      return nil
    }
    
    return SGDCCPacket(data: [0b01111000 | (physicalRegister - 1), value], decoderMode: .serviceModePagedAddressing)

  }
  
  public static func pagingRegisterValue(cvNumber:UInt16) -> UInt8? {
    guard (1 ... 1024) ~= cvNumber else {
      return nil
    }
    return UInt8((((cvNumber - 1) >> 2) + 1) & 0xff)
  }

  public static func dataRegister(cvNumber:UInt16) -> UInt8? {
    guard (1 ... 1024) ~= cvNumber else {
      return nil
    }
    return UInt8((cvNumber - 1) % 4) + 1
  }
  
  public static func verifyCVBytePagedMode(cvNumber:UInt16, value:UInt8) -> SGDCCPacket? {
    
    guard let dataRegister = dataRegister(cvNumber: cvNumber) else {
      return nil
    }
    
    return verifyRegisterBytePagedMode(physicalRegister: dataRegister, value: value)

  }

  public static func writeCVBytePagedMode(cvNumber:UInt16, value:UInt8) -> SGDCCPacket? {
    
    guard let dataRegister = dataRegister(cvNumber: cvNumber) else {
      return nil
    }

    return writeRegisterBytePagedMode(physicalRegister: dataRegister, value: value)

  }
  
  public static func writePagingRegister(cvNumber:UInt16) -> SGDCCPacket? {
    
    guard let pagingRegisterValue = pagingRegisterValue(cvNumber: cvNumber) else {
      return nil
    }
    
    return writeRegisterBytePagedMode(physicalRegister: 6, value: pagingRegisterValue)

  }

}
