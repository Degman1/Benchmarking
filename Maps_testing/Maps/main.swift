//
//  main.swift
//  Maps
//
//  Created by David Gerard on 9/30/18.
//  Copyright © 2018 David Gerard. All rights reserved.
//

import Foundation

print("Hello, World!")

public class MapTest {
    var stringList = [String]()
    let chars = Array("abcdefghijklmnopqrstuvwxyz".characters)
    
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
        var map = LinearMap<String, String>()
        for i in 0..<NUMBER_PUTS {
            map.set(stringList[i], stringList[i]);
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
        var map = BinaryMap<String, String>()
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
    func testHashMap()->Bool{
        var value = ""
        var key = ""
        var map = HashMap<String, String>(initialArraySize: 2000)
        for i in 0..<NUMBER_PUTS {
            map.set(stringList[i], stringList[i]);
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

let mt = MapTest()
mt.doTest()



/*var lm = LinearMap<String, Int>()
lm["fred"] = 72
lm["phil"] = 47
lm["kate"] = 91
lm["ann"] = 68
lm["frodo"] = 92
lm["odorf"] = 100
print(lm)
lm["frodo"] = 400
print("frodo is...\(lm["frodo"])")
print("ann is...\(lm["ann"])")
print("odorf is...\(lm["odorf"])")
print("dog is...\(lm["dog"])")
print(lm.count)

print()
var bm = BinaryMap<String, Int>()
bm["fred"] = 72
bm["phil"] = 47
bm["kate"] = 91
bm["ann"] = 68
bm["frodo"] = 92
bm["odorf"] = 100
print(bm)
bm["frodo"] = 5000
print("frodo is...\(bm["frodo"])")
print("ann is...\(bm["ann"])")
print("odorf is...\(bm["odorf"])")
print("dog is...\(bm["dog"])")
print(bm.count)

print()
print(abs("a".hashValue % 5))
print(abs("b".hashValue % 5))
print(abs("c".hashValue % 5))
print(abs("d".hashValue % 5))
print(abs("e".hashValue % 5))
print(abs("f".hashValue % 5))
var hm = HashMap<String, Int>(initialArraySize: 5)
hm["a"] = 1
hm["b"] = 2
hm["c"] = 3
hm["d"] = 4
hm["e"] = 5
hm["f"] = 6
print(hm)
print(hm.linearMap)
hm["a"] = 200
hm["d"] = 300
hm["e"] = 400
hm["f"] = 500
print("a is...\(hm["a"])")
print("b is...\(hm["b"])")
print("c is...\(hm["c"])")
print("d is...\(hm["d"])")
print("e is...\(hm["e"])")
print("f is...\(hm["f"])")
print("g is...\(hm["g"])")
print(hm.count)
print(hm.getNumberCollisions())*/

/*
 Expected Output:
 
 [fred: 72, phil: 47, kate: 91, ann: 68, frodo: 92]
 frodo is...Optional(92)
 ann is...Optional(68)
 [fred: 72, phil: 47, kate: 91, ann: 68, frodo: 92]
 5
 */
