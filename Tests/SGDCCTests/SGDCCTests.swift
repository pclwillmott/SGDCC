import Testing
@testable import SGDCC

@Test func testTitles() async throws {
  
  for item in SGDCCPacketType.allCases {
    #expect(item == .unknown || item.title != SGDCCPacketType.unknown.title)
  }

}

@Test func testFunctions() async throws {
  
  #expect(SGDCCPacket.highestFunction == 68)
  
  var functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  var packet = SGDCCPacket(shortAddress: 0, f0toF4: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 255, f0toF4: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 1, f0toF4: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 1, f0toF4: functions)
  
  #expect(packet != nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 0 ... 4 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket(shortAddress: shortAddress, f0toF4: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionFLF1F4)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket(shortAddress: 0, f5toF8: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 255, f5toF8: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 1, f5toF8: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 1, f5toF8: functions)
  
  #expect(packet != nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 5 ... 8 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket(shortAddress: shortAddress, f5toF8: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF5F8)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket(shortAddress: 0, f9toF12: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 255, f9toF12: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 1, f9toF12: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 1, f9toF12: functions)
  
  #expect(packet != nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 9 ... 12 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket(shortAddress: shortAddress, f9toF12: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF9F12)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket(shortAddress: 0, f13toF20: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 255, f13toF20: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 1, f13toF20: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 1, f13toF20: functions)
  
  #expect(packet != nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 13 ... 20 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket(shortAddress: shortAddress, f13toF20: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF13F20)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket(shortAddress: 0, f21toF28: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 255, f21toF28: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 1, f21toF28: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 1, f21toF28: functions)
  
  #expect(packet != nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 21 ... 28 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket(shortAddress: shortAddress, f21toF28: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF21F28)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket(shortAddress: 0, f29toF36: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 255, f29toF36: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 1, f29toF36: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 1, f29toF36: functions)
  
  #expect(packet != nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 29 ... 36 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket(shortAddress: shortAddress, f29toF36: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF29F36)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket(shortAddress: 0, f37toF44: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 255, f37toF44: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 1, f37toF44: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 1, f37toF44: functions)
  
  #expect(packet != nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 37 ... 44 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket(shortAddress: shortAddress, f37toF44: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF37F44)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket(shortAddress: 0, f45toF52: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 255, f45toF52: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 1, f45toF52: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 1, f45toF52: functions)
  
  #expect(packet != nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 45 ... 52 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket(shortAddress: shortAddress, f45toF52: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF45F52)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket(shortAddress: 0, f53toF60: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 255, f53toF60: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 1, f53toF60: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 1, f53toF60: functions)
  
  #expect(packet != nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 53 ... 60 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket(shortAddress: shortAddress, f53toF60: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF53F60)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket(shortAddress: 0, f61toF68: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 255, f61toF68: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 1, f61toF68: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 1, f61toF68: functions)
  
  #expect(packet != nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 61 ... 68 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket(shortAddress: shortAddress, f61toF68: functions)
      
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
  
  packet = SGDCCPacket(longAddress: 0, f0toF4: functions)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket(longAddress: 10240, f0toF4: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 1, f0toF4: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 10239, f0toF4: functions)
  
  #expect(packet != nil)
  
  for _ in 1 ... 127 {
    
    let longAddress = UInt16.random(in: 0 ... 10239)
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 0 ... 4 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket(longAddress: longAddress, f0toF4: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionFLF1F4)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket(longAddress: 0, f5toF8: functions)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket(longAddress: 10240, f5toF8: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 1, f5toF8: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 10239, f5toF8: functions)
  
  #expect(packet != nil)
  
  for _ in 1 ... 127 {
    
    let longAddress = UInt16.random(in: 0 ... 10239)
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 5 ... 8 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket(longAddress: longAddress, f5toF8: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF5F8)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket(longAddress: 0, f9toF12: functions)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket(longAddress: 10240, f9toF12: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 1, f9toF12: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 10239, f9toF12: functions)
  
  #expect(packet != nil)
  
  for _ in 1 ... 127 {
    
    let longAddress = UInt16.random(in: 0 ... 10239)
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 9 ... 12 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket(longAddress: longAddress, f9toF12: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF9F12)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket(longAddress: 0, f13toF20: functions)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket(longAddress: 10240, f13toF20: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 1, f13toF20: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 10239, f13toF20: functions)
  
  #expect(packet != nil)
  
  for _ in 1 ... 127 {
    
    let longAddress = UInt16.random(in: 0 ... 10239)
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 13 ... 20 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket(longAddress: longAddress, f13toF20: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF13F20)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }
  
  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket(longAddress: 0, f21toF28: functions)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket(longAddress: 10240, f21toF28: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 1, f21toF28: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 10239, f21toF28: functions)
  
  #expect(packet != nil)
  
  for _ in 1 ... 127 {
    
    let longAddress = UInt16.random(in: 0 ... 10239)
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 21 ... 28 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket(longAddress: longAddress, f21toF28: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF21F28)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }

  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket(longAddress: 0, f29toF36: functions)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket(longAddress: 10240, f29toF36: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 1, f29toF36: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 10239, f29toF36: functions)
  
  #expect(packet != nil)
  
  for _ in 1 ... 127 {
    
    let longAddress = UInt16.random(in: 0 ... 10239)
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 29 ... 36 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket(longAddress: longAddress, f29toF36: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF29F36)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }

  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket(longAddress: 0, f37toF44: functions)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket(longAddress: 10240, f37toF44: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 1, f37toF44: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 10239, f37toF44: functions)
  
  #expect(packet != nil)
  
  for _ in 1 ... 127 {
    
    let longAddress = UInt16.random(in: 0 ... 10239)
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 37 ... 44 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket(longAddress: longAddress, f37toF44: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF37F44)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }

  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket(longAddress: 0, f45toF52: functions)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket(longAddress: 10240, f45toF52: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 1, f45toF52: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 10239, f45toF52: functions)
  
  #expect(packet != nil)
  
  for _ in 1 ... 127 {
    
    let longAddress = UInt16.random(in: 0 ... 10239)
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 45 ... 52 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket(longAddress: longAddress, f45toF52: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF45F52)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }

  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket(longAddress: 0, f53toF60: functions)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket(longAddress: 10240, f53toF60: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 1, f53toF60: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 10239, f53toF60: functions)
  
  #expect(packet != nil)
  
  for _ in 1 ... 127 {
    
    let longAddress = UInt16.random(in: 0 ... 10239)
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 53 ... 60 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket(longAddress: longAddress, f53toF60: functions)
      
      #expect(packet != nil)
      
      if let packet {
        
        #expect(packet.functions == functions)
        
        #expect(packet.packetType == .functionF53F60)
        
        #expect(packet.isChecksumOK)
        
      }
      
    }
    
  }

  functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
  
  packet = SGDCCPacket(longAddress: 0, f61toF68: functions)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket(longAddress: 10240, f61toF68: functions)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 1, f61toF68: [])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 10239, f61toF68: functions)
  
  #expect(packet != nil)
  
  for _ in 1 ... 127 {
    
    let longAddress = UInt16.random(in: 0 ... 10239)
    
    for _ in 0 ... 255 {
      
      functions = [Bool](repeating: false, count: SGDCCPacket.highestFunction + 1)
      
      for function in 61 ... 68 {
        functions[function] = UInt8.random(in: 0 ... 255) % 2 == 0
      }
      
      packet = SGDCCPacket(longAddress: longAddress, f61toF68: functions)
      
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
  
  var packet : SGDCCPacket? = SGDCCPacket(longAddress: 0, speed28steps: 0, direction: .forward)
  
  #expect(packet != nil)
  
  #expect(packet?.longAddress == 0)
  
  #expect(packet?.speed == 0)
  
  #expect(packet?.direction == .forward)
  
  packet = SGDCCPacket(longAddress: 10240, speed28steps: 0, direction: .forward)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 10239, speed28steps: 0, direction: .reverse)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket(longAddress: 10239, speed28steps: 255, direction: .forward)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 10239, speed28steps: 32, direction: .forward)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 10239, speed28steps: 31, direction: .forward)
  
  #expect(packet != nil)
  
  for longAddress : UInt16 in 0 ... 10239 {
    
    packet = SGDCCPacket(longAddress: longAddress, speed28steps: 0, direction: .forward)
    
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
    
    packet = SGDCCPacket(longAddress: 0, speed28steps: speed, direction: .forward)
    
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
    
    packet = SGDCCPacket(longAddress: 0, speed28steps: 0, direction: direction)
    
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
  
  packet = SGDCCPacket(longAddress: 0, speed14Steps: 0, direction: .forward, functions:[])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 10240, speed14Steps: 0, direction: .forward, functions:[true])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 10239, speed14Steps: 255, direction: .forward, functions:[true])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 0, speed14Steps: 0, direction: .forward, functions:[true])
  
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
        
        packet = SGDCCPacket(longAddress: longAddress, speed14Steps: speed, direction: direction, functions:[true])
        
        #expect(packet != nil)
        
        if let packet {
          
          #expect(packet.longAddress == longAddress)
          
          #expect(packet.speed14Steps == speed)
          
          #expect(packet.direction == direction)
          
          #expect(packet.functions != nil && packet.functions![0] == true)
          
          #expect(packet.packetType == .speedAndDirectionPacket)
          
          #expect(packet.isChecksumOK)

        }
        
        packet = SGDCCPacket(longAddress: longAddress, speed14Steps: speed, direction: direction, functions:[false])
        
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
  
  packet = SGDCCPacket(longAddress: 0, speed126Steps: 0, direction: .forward)
  
  #expect(packet != nil)
  
  packet = SGDCCPacket(longAddress: 10240, speed126Steps: 0, direction: .forward)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(longAddress: 10239, speed126Steps: 255, direction: .forward)
  
  #expect(packet == nil)
  
  for speed : UInt8 in 0 ... 127 {
    
    packet = SGDCCPacket(longAddress: 0, speed126Steps: speed, direction: .forward)
    
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
  
  packet = SGDCCPacket(shortAddress: 0, speed28Steps: 0, direction: .forward)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 255, speed28Steps: 0, direction: .forward)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 0, speed28Steps: 255, direction: .forward)
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 1, speed28Steps: 31, direction: .forward)
  
  #expect(packet != nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for speed : UInt8 in 0 ... 31 {
      
      for direction in SGDCCLocomotiveDirection.allCases {
        
        packet = SGDCCPacket(shortAddress: shortAddress, speed28Steps: speed, direction: direction)
        
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
  
  packet = SGDCCPacket(shortAddress: 0, speed14Steps: 0, direction: .forward, functions: [true])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 255, speed14Steps: 0, direction: .forward, functions: [true])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 1, speed14Steps: 255, direction: .forward, functions: [true])
  
  #expect(packet == nil)
  
  packet = SGDCCPacket(shortAddress: 0, speed14Steps: 0, direction: .forward, functions: [])
 
  #expect(packet == nil)
  
  for shortAddress : UInt8 in 1 ... 127 {
    
    for speed : UInt8 in 0 ... 15 {
      
      for direction in SGDCCLocomotiveDirection.allCases {
        
        packet = SGDCCPacket(shortAddress: shortAddress, speed14Steps: speed, direction: direction, functions: [true])

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
  
  packet = SGDCCPacket(shortAddress: 0, speed126Steps: 0, direction: .forward)

  #expect(packet == nil)

  packet = SGDCCPacket(shortAddress: 255, speed126Steps: 0, direction: .forward)

  #expect(packet == nil)

  packet = SGDCCPacket(shortAddress: 1, speed126Steps: 255, direction: .forward)

  #expect(packet == nil)

  packet = SGDCCPacket(shortAddress: 0, speed126Steps: 128, direction: .forward)

  #expect(packet == nil)

  for shortAddress : UInt8 in 1 ... 127 {
    
    for speed : UInt8 in 0 ... 127 {
      
      for direction in SGDCCLocomotiveDirection.allCases {
        
        packet = SGDCCPacket(shortAddress: shortAddress, speed126Steps: speed, direction: direction)

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

