//Higher Order Function

let numbers = [1, 2, 3, 4, 3, 3]

//* filter *
// filter -> Boolean
let filteredArray: [Int] = numbers.filter({return $0 % 2 == 0})
print(filteredArray) //2, 4

//* map *
// map -> Transform
let transformedArray: [Int] = numbers.map({return $0 * 3})
print(transformedArray) //3, 6, 9, 12, 9, 9

//* reduce *
// sum -> reduce
// Initial Value, Next Value
let sum: Int = numbers.reduce(0, {sum, number in sum + number})
print(sum)

let sum2: Int = numbers.reduce(0) { (sum, number) -> Int in
    return sum + number
}
print(sum2)

let sum3: Int = numbers.reduce(0, {$0 + $1}) //$0 => result, $1 => next number
print(sum3)


//* foreach *
var sum4: Int = 0
numbers.forEach { (number) in
    sum4 += number
}
print(sum4)

var sum5: Int = 0
numbers.forEach{sum5 += $0}
print(sum5)


let strings: [String] = ["A", "sly", "fox", "jumps"]
let string: String = strings.reduce("",{$0 + $1 + " "})
print(string)
