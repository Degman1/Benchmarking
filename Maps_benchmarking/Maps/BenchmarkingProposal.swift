//
//  BenchmarkingProposal.swift
//  Maps
//
//  Created by David Gerard on 11/4/18.
//  Copyright © 2018 David Gerard. All rights reserved.
//

import Foundation

//a proposal for a possible benchmarking class.
//none of this is meant to be functional code, it is only supposed to illustrate the concept

/*commented out so it doesn't run errors and interfere with testing
 class Benchmarker {
    var testResults_On: [Int: Double] = [:]; //stores results in format of n:time
    var testResults_LinearGet: [Int: Double] = [:];
    var testReults_LinearSet: [Int: Double] = [:];
    var testResults_Ologn: [Int: Double] = [:];
    var testReults_BinaryGet: [Int: Double] = [:];
    //etc
    
    func getTimeFor_On(n: Int) {
        //this performs a standard O(n) operation for a given n value and gives the time
        var whateverList: [Int] = []
        startTimer();
        for i in 0..<n {
            whateverList.append(1)
        }
        var time = getElapsedTime();
        testResults_On.append(n, time);
    }
    func performTest_On() {
        //get data points for O(n) time
        getTimeFor_On(1);
        getTimeFor_On(10);
        getTimeFor_On(100);
        getTimeFor_On(1000);
        getTimeFor_On(10000);
    }
    //same as above, but this time it actually tests
    //the linear map's get function instead of a dummy
    func getTimeFor_LinearGet(n: Int);
    func performTest_LinearGet();
    
    //repeat for all the other map methods, as well as a dummy O(c) and O(log(n)) to compare them with
    
    func compareDataBetweenSets(dataset1: [(Int, Double)], dataset2: [(Int, Double)]) {
        //get the quotient between times for matching n values in data sets.
        //If the quotients are consistent, the efficiency model is accurate.
        //If they vary wildly, the efficiency model is incorrect.
        //for example, if testResults_On[i]/testResults_LinearGet[i] returns
        //[.2, .201, .198, .189, .211], you know that linear get is almost exactly O(.2n), or O(n)
        //if it is [.2, .501, 9.198, 105.00189, 11913.3], linear get is probably not O(n) at all
    }
}*/
