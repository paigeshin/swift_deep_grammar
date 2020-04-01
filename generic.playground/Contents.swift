import UIKit

//* Function Generic *
//Generic은 보통 T로 표기하지만 어떤 문자가 와도 상관이 없음
func exchange<T>(a: inout T, b: inout T){
    let temp = a
    a = b
    b = temp
}

var num1 = 100
var num2 = 200

//& Ampersand는 inout을 의미한다.
//print("Numbers before swapping: \(num1), \(num2)")   // 100, 200
//exchange(a: &num1, b: &num2)
//print("Numbers before swapping: \(num1), \(num2)")   // 200, 100



//* Struct Generic *
struct TOS<T> {
    var items = [T]()
    mutating func push(item: T){
        items.append(item)
    }
    mutating func pop() -> T {
        return items.removeLast()
    }
}

var tos = TOS<String>()
tos.push(item: "Swift 4")
print(tos.items)

tos.push(item: "Generics")
print(tos.items)

tos.push(item: "Type Parameters")
print(tos.items)

tos.push(item: "Naming Type Parameters")
print(tos.items)

//extension
extension TOS {
    var last: T? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}


//* Protocol Generic *
// Protocol Generic은 `associatedtype` 이란 keyword를 이용해서 만든다.
protocol Container {
    associatedtype ItemType
    mutating func append(item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
}

