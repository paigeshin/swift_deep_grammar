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

struct Stack<T>: Container {
    
    var items = [T]()
    
    mutating func push(item: T) {
        items.append(item)
    }
    
    mutating func pop() -> T {
        return items.removeLast()
    }
    
    // conformance to the Container protocol
    mutating func append(item: T) {
        self.push(item: item)
    }
    
    var count: Int {
        return items.count
    }
    
    subscript(i: Int) -> T {
        return items[i]
    }
    
}

func allItemsMatch<C1: Container, C2: Container>
    (_ someContainer: C1, _ anotherContainer: C2) -> Bool
    where C1.ItemType == C2.ItemType, C1.ItemType: Equatable { //C1.ItemType == C2.ItemType 이 부분이 데이터 타입을 채킹하는 부분임, 만약 두 개의 다른 데이터 타입을 담은 generic array를 주면 compile하지 않는다.
        
        //Check that both containers contain the same number of items.
        if someContainer.count != anotherContainer.count {
            return false
        }
        
        //Check two container index by index
        for i in 0..<someContainer.count {
            if someContainer[i] != anotherContainer[i] {
                return false
            }
        }
        
        // All items match, so return true.
        return true
}


//* Protocol Generic using `where` clause
protocol MyProtocol {
    associatedtype AType
    func foo()
}

class MyClassInt: NSObject, MyProtocol {
    typealias AType = Int
    
    func foo(){
        print(type(of: self)) //데이터타입 채킹
    }
    
}

class MyClassString: NSObject, MyProtocol {
    typealias AType = String
    
    func foo(){
        print("I'm not implemented")
    }
}



