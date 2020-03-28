import UIKit

func filterGreaterThanValue(value: Int, numbers: [Int]) -> [Int] {
    var filteredSetOfNumbers: [Int] = [Int]()
    for num in numbers {
        if num > value {
            filteredSetOfNumbers.append(num)
        }
    }
    return filteredSetOfNumbers
}

func filterWithPredicateClosure(closure: (Int) -> Bool, numbers: [Int]) -> [Int] {
    var numArray: [Int] = [Int]()
    for num in numbers {
        //perform some condition check here
        if closure(num) {
            numArray.append(num)
        }
    }
    return numArray
}

let filteredList = filterWithPredicateClosure(closure: {(num) -> Bool in
    return num < 5
}, numbers: [1, 2, 3, 4, 5,])

print(filteredList)


//2의 배수이면서 각각의 숫자를 모두 곱하는 closure
func multiplyValue(closure: () -> Int, numbers: [Int]) -> [Int] {
    var numArr: [Int] = [Int]()
    for num in numbers {
        if num % 2 == 0 {
            numArr.append(num * closure())
        }
    }
    return numArr
}

let multiplyFiltered = multiplyValue(closure: {() -> Int in
    return 3
} , numbers: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])

print(multiplyFiltered)

var completionhandler: [() -> Void] = []

func nonescaping(closure: @escaping(String) -> Void) {
    print("function start")
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        closure("closure called")
    }
    print("function end")
}

nonescaping{(value) in
    print(value)
}


