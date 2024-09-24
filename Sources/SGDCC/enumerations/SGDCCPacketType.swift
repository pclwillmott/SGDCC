// -----------------------------------------------------------------------------
// SGDCCPacketType.swift
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
//     22/09/2024  Paul Willmott - SGDCCPacketType.swift created
// -----------------------------------------------------------------------------

import Foundation

public enum SGDCCPacketType : CaseIterable, Sendable {
  
  // MARK: Enumeration
  
  case directModeWriteBit
  case directModeVerifyBit
  case directModeWriteByte
  case directModeVerifyByte
  case addressOnlyVerifyAddress
  case addressOnlyWriteAddress
  case physicalRegisterVerifyByte
  case physicalRegisterWriteByte
  case pagedModeVerifyByte
  case pagedModeWriteByte
  case pagePresetInstruction
  case digitalDecoderResetPacket
  case digitalDecoderIdlePacket
  case speedAndDirectionPacket
  case speedStepControl128
  case analogFunctionGroup
  case functionF0F4
  case functionF5F8
  case functionF9F12
  case binaryStateControlLongForm
  case timeAndDateCommand
  case systemTime
  case binaryStateControlShortForm
  case functionF13F20
  case functionF21F28
  case functionF29F36
  case functionF37F44
  case functionF45F52
  case functionF53F60
  case functionF61F68
  case cvAccessAccelerationAdjustment
  case cvAccessDeclerationAdjustment
  case cvAccessLongAddress
  case cvAccessIndexedCVs
  case cvAccessVerifyByte
  case cvAccessWriteByte
  case cvAccessVerifyBit
  case cvAccessWriteBit
  case unknown
  
  // MARK: Public Properties
  
  public var title : String {
    return SGDCCPacketType.titles[self] ?? SGDCCPacketType.unknown.title
  }
  
  // MARK: Private Class Properties
  
  private static let titles : [SGDCCPacketType:String] = [
    .directModeWriteBit             : String(localized: "Direct Mode Write Bit"),
    .directModeVerifyBit            : String(localized: "Direct Mode Verify Bit"),
    .directModeWriteByte            : String(localized: "Direct Mode Write Byte"),
    .directModeVerifyByte           : String(localized: "Direct Mode Verify Byte"),
    .addressOnlyVerifyAddress       : String(localized: "Address Only Verify Address"),
    .addressOnlyWriteAddress        : String(localized: "Address Only Write Address"),
    .physicalRegisterVerifyByte     : String(localized: "Physical Register Verify Byte"),
    .physicalRegisterWriteByte      : String(localized: "Physical Register Write Byte"),
    .pagedModeVerifyByte            : String(localized: "Paged Mode Verify Byte"),
    .pagedModeWriteByte             : String(localized: "Paged Mode Write Byte"),
    .pagePresetInstruction          : String(localized: "Page Preset Instruction"),
    .digitalDecoderResetPacket      : String(localized: "Digital Decoder Reset Packet"),
    .digitalDecoderIdlePacket       : String(localized: "Digital Decoder Idle Packet"),
    .speedAndDirectionPacket        : String(localized: "Speed and Direction Packet"),
    .speedStepControl128            : String(localized: "Speed Step Control 128"),
    .analogFunctionGroup            : String(localized: "Analog Function Group"),
    .functionF0F4                   : String(localized: "Functions F0 to F4"),
    .functionF5F8                   : String(localized: "Functions F5 to F8"),
    .functionF9F12                  : String(localized: "Functions F9 to F12"),
    .binaryStateControlLongForm     : String(localized: "Binary State Control Long Form"),
    .timeAndDateCommand             : String(localized: "Time and Date Command"),
    .systemTime                     : String(localized: "System Time"),
    .binaryStateControlShortForm    : String(localized: "Binary State Control Short Form"),
    .functionF13F20                 : String(localized: "Functions F13 to F20"),
    .functionF21F28                 : String(localized: "Functions F21 to F28"),
    .functionF29F36                 : String(localized: "Functions F29 to F36"),
    .functionF37F44                 : String(localized: "Functions F37 to F44"),
    .functionF45F52                 : String(localized: "Functions F45 to F52"),
    .functionF53F60                 : String(localized: "Functions F53 to F60"),
    .functionF61F68                 : String(localized: "Functions F61 to F68"),
    .cvAccessAccelerationAdjustment : String(localized: "CV Access Acceleration Adjustment"),
    .cvAccessDeclerationAdjustment  : String(localized: "CV Access Decleration Adjustment"),
    .cvAccessLongAddress            : String(localized: "CV Access Long Address"),
    .cvAccessIndexedCVs             : String(localized: "CV Access Indexed CVs"),
    .cvAccessVerifyByte             : String(localized: "CV Access Verify Byte"),
    .cvAccessWriteByte              : String(localized: "CV Access Write Byte"),
    .cvAccessVerifyBit              : String(localized: "CV Access Verify Bit"),
    .cvAccessWriteBit               : String(localized: "CV Access Write Bit"),
    .unknown                        : String(localized: "Unknown"),
  ]
  
}
