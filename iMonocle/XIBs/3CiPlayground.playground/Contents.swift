//: Playground - noun: a place where people can play

import UIKit

func naturalNumbers(input: Int) -> Int {
    var numbers: [Int] = []
    var back: Int = 0
    for i in 1...input {
        if i % 3 == 0 || i % 5 == 0 {
            numbers.append(i)
        }
    }
    for i in numbers {
        back + i
    }
    return back
}



naturalNumbers(input: 10)


