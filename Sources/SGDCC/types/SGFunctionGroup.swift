// -----------------------------------------------------------------------------
// SGFunctionGroup.swift
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
//     03/10/2024  Paul Willmott - SGFunctionGroup.swift created
// -----------------------------------------------------------------------------

import Foundation

public struct SGFunctionGroup {
  
  // MARK: Private Properties
  
  private var values : [UInt64] = [0, 0]
  
  // MARK: Public Methods
  
  public mutating func set(index:Int, value:Bool) {
    let byte = index / 64
    guard byte < values.count else {
      return
    }
    let mask : UInt64 = 1 << (index % 64)
    values[byte] = (values[byte] & ~mask) | (value ? mask : 0)
  }
  
  public func get(index:Int) -> Bool {
    let byte = index / 64
    guard byte < values.count else {
      return false
    }
    return (values[byte] & (1 << (index % 64))) != 0
  }
  
  // MARK: Public Static Methods
  
  public static func ==(lhs: SGFunctionGroup, rhs: SGFunctionGroup) -> Bool {
    return lhs.values == rhs.values
  }

  public static func !=(lhs: SGFunctionGroup, rhs: SGFunctionGroup) -> Bool {
    return lhs.values != rhs.values
  }

}
