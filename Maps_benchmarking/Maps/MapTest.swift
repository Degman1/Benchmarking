//
//  MapTest.swift
//  Maps
//
//  Created by David Gerard on 11/6/18.
//  Copyright © 2018 David Gerard. All rights reserved.
//

import Foundation

public class MapTest {
    var stringList = [String]()
    let chars = Array("abcdefghijklmnopqrstuvwxyz")
    
    let MAX_SIZE = 1000
    let NUMBER_PUTS = 1000
    func getRandomInt(range: Int)->Int{
        return Int(arc4random_uniform(UInt32(range)) )
    }
    func makeString(length: Int)->String{
        var s = ""
        let numberChars = chars.count
        for _ in 0..<length {
            s.append(chars[getRandomInt(range: numberChars)])
            
        }
        return s;
    }
    func makeStringList(size: Int) {
        stringList = [String]()
        for _ in 0..<size {
            stringList.append(makeString(length: 10))
        }
    }
    func testLinearMap()->Bool{
        var value = ""
        var key = ""
        let map = LinearMap<String, String>()
        for i in 0..<NUMBER_PUTS {
            map.set(stringList[i], v: stringList[i]);
        }
        
        for index in 0..<NUMBER_PUTS {
            key = stringList[index]
            value = map.get(key)!
            if (!(value == key)){
                return false;
            }
        }
        return true;
    }
    func testBinaryMap()->Bool{
        var value = ""
        var key = ""
        let map = BinaryMap<String, String>()
        for i in 0..<NUMBER_PUTS{
            map.set(stringList[i], v: stringList[i]);
        }
        
        
        for index in 0..<NUMBER_PUTS {
            key = stringList[index]
            value = map.get(key)!
            if (!(value == key)) {
                return false;
            }
            
        }
        return true;
        
        
    }
    func testHashMap()-> Bool {
        var value = ""
        var key = ""
        let map = HashMap<String, String>(initialArraySize: 2000)
        for i in 0..<NUMBER_PUTS {
            map.set(stringList[i], v: stringList[i]);
        }
        for index in 0..<NUMBER_PUTS {
            key = stringList[index]
            value = map.get(key)!
            if (!(value == key)) {
                return false;
            }
        }
        print("Collisions: \(map.getNumberCollisions())")
        return true;
    }
    func doTest(){
        makeStringList(size: MAX_SIZE)
        print("String List Complete")
        print("Linear: \(testLinearMap())")
        print("Binary: \(testBinaryMap())")
        print("Hash: \(testHashMap())")
        
    }
}
