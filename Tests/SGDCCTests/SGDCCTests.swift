import Testing
@testable import SGDCC

@Test func testServiceMode() async throws {
  
  var packet = SGDCCPacket.writeCVByteDirectMode(cvNumber: 0, value: 0)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.writeCVByteDirectMode(cvNumber: 2048, value: 0)
  
  #expect(packet == nil)
  
  for cvNumber : UInt16 in 1 ... 1024 {

    for cvValue : UInt8 in 0 ... 255 {
      
      packet = SGDCCPacket.writeCVByteDirectMode(cvNumber: cvNumber, value: cvValue)
      
      #expect(packet != nil)
      
      #expect(packet?.cvNumber != nil)
      
      #expect(packet?.cvValue != nil)
      
      #expect(packet?.packetType == .directModeWriteByte)
      
      #expect(packet?.decoderMode == .serviceModeDirectMode)
      
      if let packet, let cv = packet.cvNumber, let value = packet.cvValue {
        
        #expect(cv == cvNumber)

        #expect(value == cvValue)

      }
      
    }
    
  }

  packet = SGDCCPacket.verifyCVByteDirectMode(cvNumber: 0, value: 0)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.verifyCVByteDirectMode(cvNumber: 2048, value: 0)
  
  #expect(packet == nil)
  
  for cvNumber : UInt16 in 1 ... 1024 {

    for cvValue : UInt8 in 0 ... 255 {
      
      packet = SGDCCPacket.verifyCVByteDirectMode(cvNumber: cvNumber, value: cvValue)
      
      #expect(packet != nil)
      
      #expect(packet?.cvNumber != nil)
      
      #expect(packet?.cvValue != nil)
      
      #expect(packet?.packetType == .directModeVerifyByte)
      
      #expect(packet?.decoderMode == .serviceModeDirectMode)
      
      if let packet, let cv = packet.cvNumber, let value = packet.cvValue {
        
        #expect(cv == cvNumber)

        #expect(value == cvValue)

      }
      
    }
    
  }

  packet = SGDCCPacket.verifyCVBitDirectMode(cvNumber: 0, bit: 0, value: 0)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.verifyCVBitDirectMode(cvNumber: 2048, bit: 0, value: 0)

  #expect(packet == nil)
  
  packet = SGDCCPacket.verifyCVBitDirectMode(cvNumber: 1, bit: 50, value: 0)

  #expect(packet == nil)
  
  packet = SGDCCPacket.verifyCVBitDirectMode(cvNumber: 1, bit: 7, value: 10)

  #expect(packet == nil)
  
  for cvNumber : UInt16 in 1 ... 1024 {

    for cvBit : UInt8 in 0 ... 7 {
      
      for cvValue : UInt8 in 0 ... 1 {
        
        packet = SGDCCPacket.verifyCVBitDirectMode(cvNumber: cvNumber, bit: cvBit, value: cvValue)

        #expect(packet != nil)
        
        #expect(packet?.cvNumber != nil)
        
        #expect(packet?.cvValue == nil)
        
        #expect(packet?.cvBitNumber != nil)
        
        #expect(packet?.cvBitValue != nil)
        
        #expect(packet?.packetType == .directModeVerifyBit)
        
        #expect(packet?.decoderMode == .serviceModeDirectMode)
        
        if let packet, let cv = packet.cvNumber, let value = packet.cvBitValue, let bit = packet.cvBitNumber {
          
          #expect(cv == cvNumber)
          
          #expect(value == cvValue)
          
          #expect(bit == cvBit)
          
        }
        
      }
      
    }
    
  }

  packet = SGDCCPacket.writeCVBitDirectMode(cvNumber: 0, bit: 0, value: 0)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.writeCVBitDirectMode(cvNumber: 2048, bit: 0, value: 0)

  #expect(packet == nil)
  
  packet = SGDCCPacket.writeCVBitDirectMode(cvNumber: 1, bit: 50, value: 0)

  #expect(packet == nil)
  
  packet = SGDCCPacket.writeCVBitDirectMode(cvNumber: 1, bit: 7, value: 10)

  #expect(packet == nil)
  
  for cvNumber : UInt16 in 1 ... 1024 {

    for cvBit : UInt8 in 0 ... 7 {
      
      for cvValue : UInt8 in 0 ... 1 {
        
        packet = SGDCCPacket.writeCVBitDirectMode(cvNumber: cvNumber, bit: cvBit, value: cvValue)

        #expect(packet != nil)
        
        #expect(packet?.cvNumber != nil)
        
        #expect(packet?.cvValue == nil)
        
        #expect(packet?.cvBitNumber != nil)
        
        #expect(packet?.cvBitValue != nil)
        
        #expect(packet?.packetType == .directModeWriteBit)
        
        #expect(packet?.decoderMode == .serviceModeDirectMode)
        
       if let packet, let cv = packet.cvNumber, let value = packet.cvBitValue, let bit = packet.cvBitNumber {
          
          #expect(cv == cvNumber)
          
          #expect(value == cvValue)
          
          #expect(bit == cvBit)
          
        }
        
      }
      
    }
    
  }

}

@Test func testTitles() async throws {
  
  for item in SGDCCPacketType.allCases {
    #expect(item == .unknown || item.title != SGDCCPacketType.unknown.title)
  }

}

@Test func testFunctions() async throws {
  
  #expect(SGDCCPacket.highestFunction == 68)
  
  var functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  var packet = SGDCCPacket.f0f4Control(shortAddress: 0, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f0f4Control(shortAddress: 255, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f0f4Control(shortAddress: 1, functions: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f0f4Control(shortAddress: 1, functions: functions)
  
  #expect(packet != nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 0 ... 4 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket.f0f4Control(shortAddress: shortAddress, functions: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF0F4)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket.f5f8Control(shortAddress: 0, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f5f8Control(shortAddress: 255, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f5f8Control(shortAddress: 1, functions: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f5f8Control(shortAddress: 1, functions: functions)
  
  #expect(packet != nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 5 ... 8 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket.f5f8Control(shortAddress: shortAddress, functions: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF5F8)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket.f9f12Control(shortAddress: 0, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f9f12Control(shortAddress: 255, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f9f12Control(shortAddress: 1, functions: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f9f12Control(shortAddress: 1, functions: functions)
  
  #expect(packet != nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 9 ... 12 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket.f9f12Control(shortAddress: shortAddress, functions: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF9F12)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket.f13f20Control(shortAddress: 0, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f13f20Control(shortAddress: 255, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f13f20Control(shortAddress: 1, functions: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f13f20Control(shortAddress: 1, functions: functions)
  
  #expect(packet != nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 13 ... 20 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket.f13f20Control(shortAddress: shortAddress, functions: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF13F20)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket.f21f28Control(shortAddress: 0, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f21f28Control(shortAddress: 255, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f21f28Control(shortAddress: 1, functions: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f21f28Control(shortAddress: 1, functions: functions)
  
  #expect(packet != nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 21 ... 28 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket.f21f28Control(shortAddress: shortAddress, functions: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF21F28)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket.f29f36Control(shortAddress: 0, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f29f36Control(shortAddress: 255, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f29f36Control(shortAddress: 1, functions: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f29f36Control(shortAddress: 1, functions: functions)
  
  #expect(packet != nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 29 ... 36 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket.f29f36Control(shortAddress: shortAddress, functions: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF29F36)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket.f37f44Control(shortAddress: 0, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f37f44Control(shortAddress: 255, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f37f44Control(shortAddress: 1, functions: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f37f44Control(shortAddress: 1, functions: functions)
  
  #expect(packet != nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 37 ... 44 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket.f37f44Control(shortAddress: shortAddress, functions: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF37F44)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket.f45f52Control(shortAddress: 0, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f45f52Control(shortAddress: 255, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f45f52Control(shortAddress: 1, functions: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f45f52Control(shortAddress: 1, functions: functions)
  
  #expect(packet != nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 45 ... 52 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket.f45f52Control(shortAddress: shortAddress, functions: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF45F52)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket.f53f60Control(shortAddress: 0, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f53f60Control(shortAddress: 255, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f53f60Control(shortAddress: 1, functions: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f53f60Control(shortAddress: 1, functions: functions)
  
  #expect(packet != nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 53 ... 60 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket.f53f60Control(shortAddress: shortAddress, functions: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF53F60)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket.f61f68Control(shortAddress: 0, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f61f68Control(shortAddress: 255, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f61f68Control(shortAddress: 1, functions: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f61f68Control(shortAddress: 1, functions: functions)
  
  #expect(packet != nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 61 ... 68 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket.f61f68Control(shortAddress: shortAddress, functions: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF61F68)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  // Long Address
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket.f0f4Control(longAddress: 0, functions: functions)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket.f0f4Control(longAddress: 10240, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f0f4Control(longAddress: 1, functions: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f0f4Control(longAddress: 10239, functions: functions)
  
  #expect(packet != nil)
  
  for _ in 1 ... 127 {
    
    let longAddress = UInt16.random(in: 0 ... 10239)
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 0 ... 4 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket.f0f4Control(longAddress: longAddress, functions: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF0F4)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket.f5f8Control(longAddress: 0, functions: functions)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket.f5f8Control(longAddress: 10240, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f5f8Control(longAddress: 1, functions: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f5f8Control(longAddress: 10239, functions: functions)
  
  #expect(packet != nil)
  
  for _ in 1 ... 127 {
    
    let longAddress = UInt16.random(in: 0 ... 10239)
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 5 ... 8 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket.f5f8Control(longAddress: longAddress, functions: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF5F8)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket.f9f12Control(longAddress: 0, functions: functions)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket.f9f12Control(longAddress: 10240, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f9f12Control(longAddress: 1, functions: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f9f12Control(longAddress: 10239, functions: functions)
  
  #expect(packet != nil)
  
  for _ in 1 ... 127 {
    
    let longAddress = UInt16.random(in: 0 ... 10239)
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 9 ... 12 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket.f9f12Control(longAddress: longAddress, functions: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF9F12)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket.f13f20Control(longAddress: 0, functions: functions)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket.f13f20Control(longAddress: 10240, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f13f20Control(longAddress: 1, functions: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f13f20Control(longAddress: 10239, functions: functions)
  
  #expect(packet != nil)
  
  for _ in 1 ... 127 {
    
    let longAddress = UInt16.random(in: 0 ... 10239)
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 13 ... 20 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket.f13f20Control(longAddress: longAddress, functions: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF13F20)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket.f21f28Control(longAddress: 0, functions: functions)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket.f21f28Control(longAddress: 10240, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f21f28Control(longAddress: 1, functions: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f21f28Control(longAddress: 10239, functions: functions)
  
  #expect(packet != nil)
  
  for _ in 1 ... 127 {
    
    let longAddress = UInt16.random(in: 0 ... 10239)
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 21 ... 28 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket.f21f28Control(longAddress: longAddress, functions: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF21F28)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }

  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket.f29f36Control(longAddress: 0, functions: functions)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket.f29f36Control(longAddress: 10240, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f29f36Control(longAddress: 1, functions: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f29f36Control(longAddress: 10239, functions: functions)
  
  #expect(packet != nil)
  
  for _ in 1 ... 127 {
    
    let longAddress = UInt16.random(in: 0 ... 10239)
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 29 ... 36 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket.f29f36Control(longAddress: longAddress, functions: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF29F36)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }

  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket.f37f44Control(longAddress: 0, functions: functions)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket.f37f44Control(longAddress: 10240, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f37f44Control(longAddress: 1, functions: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f37f44Control(longAddress: 10239, functions: functions)
  
  #expect(packet != nil)
  
  for _ in 1 ... 127 {
    
    let longAddress = UInt16.random(in: 0 ... 10239)
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 37 ... 44 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket.f37f44Control(longAddress: longAddress, functions: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF37F44)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }

  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket.f45f52Control(longAddress: 0, functions: functions)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket.f45f52Control(longAddress: 10240, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f45f52Control(longAddress: 1, functions: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f45f52Control(longAddress: 10239, functions: functions)
  
  #expect(packet != nil)
  
  for _ in 1 ... 127 {
    
    let longAddress = UInt16.random(in: 0 ... 10239)
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 45 ... 52 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket.f45f52Control(longAddress: longAddress, functions: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF45F52)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }

  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket.f53f60Control(longAddress: 0, functions: functions)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket.f53f60Control(longAddress: 10240, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f53f60Control(longAddress: 1, functions: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f53f60Control(longAddress: 10239, functions: functions)
  
  #expect(packet != nil)
  
  for _ in 1 ... 127 {
    
    let longAddress = UInt16.random(in: 0 ... 10239)
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 53 ... 60 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket.f53f60Control(longAddress: longAddress, functions: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF53F60)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }

  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket.f61f68Control(longAddress: 0, functions: functions)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket.f61f68Control(longAddress: 10240, functions: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f61f68Control(longAddress: 1, functions: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.f61f68Control(longAddress: 10239, functions: functions)
  
  #expect(packet != nil)
  
  for _ in 1 ... 127 {
    
    let longAddress = UInt16.random(in: 0 ... 10239)
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 61 ... 68 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket.f61f68Control(longAddress: longAddress, functions: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF61F68)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }

}

@Test func testResetAndIdle() async throws {
  
  var packet = SGDCCPacket.digitalDecoderResetPacket()
  
  #expect(packet.packet == [0x00, 0x00, 0x00])
  
  #expect(packet.packetType == .digitalDecoderResetPacket)
  
  #expect(packet.isChecksumOK)
  
  packet = SGDCCPacket.digitalDecoderIdlePacket()
  
  #expect(packet.packet == [0xff, 0, 0xff])
  
  #expect(packet.packetType == .digitalDecoderIdlePacket)
  
  #expect(packet.isChecksumOK)

}

@Test func testSpeedAndDirection() async throws {
  
  var packet : SGDCCPacket? = SGDCCPacket.speedAndDirection(longAddress: 0, speed28steps: 0, direction: .forward)
  
  #expect(packet != nil)
  
  #expect(packet?.longAddress == 0)
  
  #expect(packet?.speed == 0)
  
  #expect(packet?.direction == .forward)
  
  packet = SGDCCPacket.speedAndDirection(longAddress: 10240, speed28steps: 0, direction: .forward)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.speedAndDirection(longAddress: 10239, speed28steps: 0, direction: .reverse)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket.speedAndDirection(longAddress: 10239, speed28steps: 255, direction: .forward)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.speedAndDirection(longAddress: 10239, speed28steps: 32, direction: .forward)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.speedAndDirection(longAddress: 10239, speed28steps: 31, direction: .forward)
  
  #expect(packet != nil)
  
  for longAddress : UInt16 in 0 ... 10239 {
    
    packet = SGDCCPacket.speedAndDirection(longAddress: longAddress, speed28steps: 0, direction: .forward)
    
    #expect(packet != nil)
    
    if let packet {
      
      #expect(packet.longAddress == longAddress)
      
      #expect(packet.speed == 0)
      
      #expect(packet.direction == .forward)
      
      #expect(packet.packetType == .speedAndDirectionPacket)
      
      #expect(packet.isChecksumOK)
      
    }
    
  }
  
  for speed : UInt8 in 0 ... 31 {
    
    packet = SGDCCPacket.speedAndDirection(longAddress: 0, speed28steps: speed, direction: .forward)
    
    #expect(packet != nil)
    
    if let packet {
      
      #expect(packet.longAddress == 0)
      
      #expect(packet.speed == speed)
      
      #expect(packet.direction == .forward)
      
      #expect(packet.packetType == .speedAndDirectionPacket)
      
      #expect(packet.isChecksumOK)
      
    }
  }
  
  for direction in SGDCCLocomotiveDirection.allCases {
    
    packet = SGDCCPacket.speedAndDirection(longAddress: 0, speed28steps: 0, direction: direction)
    
    #expect(packet != nil)
    
    if let packet {
      
      #expect(packet.longAddress == 0)
      
      #expect(packet.speed == 0)
      
      #expect(packet.direction == direction)
      
      #expect(packet.packetType == .speedAndDirectionPacket)
      
      #expect(packet.isChecksumOK)

    }
    
  }
  
  // 14 Speed Steps, Long Address
  
  packet = SGDCCPacket.speedAndDirection(longAddress: 0, speed14Steps: 0, direction: .forward, functions:[])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.speedAndDirection(longAddress: 10240, speed14Steps: 0, direction: .forward, functions:[true])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.speedAndDirection(longAddress: 10239, speed14Steps: 255, direction: .forward, functions:[true])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.speedAndDirection(longAddress: 0, speed14Steps: 0, direction: .forward, functions:[true])
  
  #expect(packet != nil)
  
  if let packet {
    
    #expect(packet.longAddress == 0)
    
    #expect(packet.speed14Steps == 0)
    
    #expect(packet.direction == .forward)
    
    #expect(packet.functions != nil && packet.functions![0] == true)
    
    #expect(packet.packetType == .speedAndDirectionPacket)
    
    #expect(packet.isChecksumOK)
    
  }
  
  for longAddress : UInt16 in 0 ... 10239 {
    
    for direction in SGDCCLocomotiveDirection.allCases {
      
      for speed : UInt8 in 0 ... 0xf {
        
        packet = SGDCCPacket.speedAndDirection(longAddress: longAddress, speed14Steps: speed, direction: direction, functions:[true])
        
        #expect(packet != nil)
        
        if let packet {
          
          #expect(packet.longAddress == longAddress)
          
          #expect(packet.speed14Steps == speed)
          
          #expect(packet.direction == direction)
          
          #expect(packet.functions != nil && packet.functions![0] == true)
          
          #expect(packet.packetType == .speedAndDirectionPacket)
          
          #expect(packet.isChecksumOK)

        }
        
        packet = SGDCCPacket.speedAndDirection(longAddress: longAddress, speed14Steps: speed, direction: direction, functions:[false])
        
        #expect(packet != nil)
        
        if let packet {
          
          #expect(packet.longAddress == longAddress)
          
          #expect(packet.speed14Steps == speed)
          
          #expect(packet.direction == direction)
          
          #expect(packet.functions != nil && packet.functions![0] == false)
          
          #expect(packet.packetType == .speedAndDirectionPacket)
          
          #expect(packet.isChecksumOK)
          
        }
        
      }
      
    }
    
  }
  
  // 126 Steps, Long Address
  
  packet = SGDCCPacket.speedAndDirection(longAddress: 0, speed126Steps: 0, direction: .forward)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket.speedAndDirection(longAddress: 10240, speed126Steps: 0, direction: .forward)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.speedAndDirection(longAddress: 10239, speed126Steps: 255, direction: .forward)
  
  #expect(packet == nil)
  
  for speed : UInt8 in 0 ... 127 {
    
    packet = SGDCCPacket.speedAndDirection(longAddress: 0, speed126Steps: speed, direction: .forward)
    
    #expect(packet != nil)
    
    if let packet {
      
      #expect(packet.longAddress == 0)
      
      #expect(packet.speed == speed)
      
      #expect(packet.direction == .forward)
      
      #expect(packet.packetType == .speedStepControl128)
      
      #expect(packet.isChecksumOK)
      
    }
    
  }
  
  // 28 Steps, Short Address
  
  packet = SGDCCPacket.speedAndDirection(shortAddress: 0, speed28Steps: 0, direction: .forward)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.speedAndDirection(shortAddress: 255, speed28Steps: 0, direction: .forward)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.speedAndDirection(shortAddress: 0, speed28Steps: 255, direction: .forward)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.speedAndDirection(shortAddress: 1, speed28Steps: 31, direction: .forward)
  
  #expect(packet != nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for speed : UInt8 in 0 ... 31 {
      
      for direction in SGDCCLocomotiveDirection.allCases {
        
        packet = SGDCCPacket.speedAndDirection(shortAddress: shortAddress, speed28Steps: speed, direction: direction)
        
        #expect(packet != nil)
        
        if let packet {
          
          #expect(packet.shortAddress == shortAddress)
          
          #expect(packet.speed == speed)
          
          #expect(packet.direction == direction)
          
          #expect(packet.packetType == .speedAndDirectionPacket)
          
          #expect(packet.isChecksumOK)
          
        }
        
      }
      
    }
    
  }
  
  // 14 Steps, Short Address
  
  packet = SGDCCPacket.speedAndDirection(shortAddress: 0, speed14Steps: 0, direction: .forward, functions: [true])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.speedAndDirection(shortAddress: 255, speed14Steps: 0, direction: .forward, functions: [true])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.speedAndDirection(shortAddress: 1, speed14Steps: 255, direction: .forward, functions: [true])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket.speedAndDirection(shortAddress: 0, speed14Steps: 0, direction: .forward, functions: [])
 
  #expect(packet == nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for speed : UInt8 in 0 ... 15 {
      
      for direction in SGDCCLocomotiveDirection.allCases {
        
        packet = SGDCCPacket.speedAndDirection(shortAddress: shortAddress, speed14Steps: speed, direction: direction, functions: [true])

        #expect(packet != nil)
        
        if let packet {
          
          #expect(packet.shortAddress == shortAddress)
          
          #expect(packet.speed14Steps == speed)
          
          #expect(packet.direction == direction)
          
          #expect(packet.packetType == .speedAndDirectionPacket)
          
          #expect(packet.isChecksumOK)
          
        }
        
      }
      
    }
    
  }
  
  packet = SGDCCPacket.speedAndDirection(shortAddress: 0, speed126Steps: 0, direction: .forward)

  #expect(packet == nil)

  packet = SGDCCPacket.speedAndDirection(shortAddress: 255, speed126Steps: 0, direction: .forward)

  #expect(packet == nil)

  packet = SGDCCPacket.speedAndDirection(shortAddress: 1, speed126Steps: 255, direction: .forward)

  #expect(packet == nil)

  packet = SGDCCPacket.speedAndDirection(shortAddress: 0, speed126Steps: 128, direction: .forward)

  #expect(packet == nil)

  for shortAddress : UInt8 in 1 ... 127 {
    
    for speed : UInt8 in 0 ... 127 {
      
      for direction in SGDCCLocomotiveDirection.allCases {
        
        packet = SGDCCPacket.speedAndDirection(shortAddress: shortAddress, speed126Steps: speed, direction: direction)

        #expect(packet != nil)
        
        if let packet {
          
          #expect(packet.shortAddress == shortAddress)
          
          #expect(packet.speed == speed)
          
          #expect(packet.direction == direction)
          
          #expect(packet.packetType == .speedStepControl128)
          
          #expect(packet.isChecksumOK)
          
        }
        
      }
      
    }
    
  }

}

