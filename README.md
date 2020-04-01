# swift_deep_grammar

# DispatchGroup vs Semaphore 

https://www.notion.so/DispatchGroup-f7d1aa2278a44ead8275b6c3ce6924b0
        
https://www.notion.so/Semaphore-64b0edff29514ccd9602ef8bec1ddf56
        
❗️DispatchGroup으로 Multi-threading을 돌리면서 shared resource에 접근하려하면 에러가 발생할 수 있다.

⇒ 그런 이유 때문에 `Semaphore` 를 사용한다.
❗️ 단 `Semaphore` 를 사용하려고해도, 접근하는 데이터가 많이 바꾸면 문제가 생길 수 있음.

#  DispatchGroup

- background task에 순서를 줄 수 있음.

            import UIKit
            
            class ViewController: UIViewController {
            
                var sharedResource = [String]()
                
                override func viewDidLoad() {
                    super.viewDidLoad()
                    
                    //DispatchGroup - Async Await 같은 개념
                    let dispatchGroup = DispatchGroup()
                    
                    dispatchGroup.enter()
                    
                    fetchImage { (image, error) in
                        print("Finished fetching image 1")
                        dispatchGroup.leave()
                    }
                    
                    
                    dispatchGroup.enter()
                    fetchImage { (image, error) in
                        print("Finished fetching image 2")
                        dispatchGroup.leave()
                    }
                    
                    
                    dispatchGroup.enter()
                    fetchImage { (image, error) in
                        print("Finished fetching image 3")
                        dispatchGroup.leave()
                    }
                    
                    //Notify, Async Await같은 개념
            
                    dispatchGroup.notify(queue: .main) {
                        print("Finished fetching images.")
                    }
                    
                    print("Wating for images to finish fetching...")
                    
                }
                
                func fetchImage(completion: @escaping(UIImage?, Error?) -> ()) {
                    
                    guard let url = URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQM5DnbpohOxyV70-6Pc_BW5DwdCiJi6t9ts0V3_3nObG2yitu0&usqp=CAU")
                        else { return }
                    
                    URLSession.shared.dataTask(with: url){(data, response, error) in
                        
                        completion(UIImage(data: data ?? Data()), nil)
                        
                    }.resume()
                    
                }

- 사용법
    1. DispatchGroup의 instance를 만든다.
    2. Background task가 실행되기 전의 코드에 `enter()` method를 호출
    3. Background task가 끝났을 때 `leave()` method를 호출
    4. 모든 Background task가 끝나는 부분에 `notify()` 를 호출한다.


# Semaphore

        let semaphore = DispatchSemaphore(value: 0)
        let dispatchQueue = DispatchQueue.global(qos: .background) //background에서 작업을 하도록 지시
        
        dispatchQueue.async {
            self.fetchImage { (image, error) in
                print("Finished fetching image 1")
                self.sharedResource.append("1")
                semaphore.signal()
            }
            semaphore.wait()
            self.fetchImage { (image, error) in
                print("Finished fetching image 2")
                self.sharedResource.append("2")
                semaphore.signal()
            }
            semaphore.wait()
            self.fetchImage { (image, error) in
                print("Finished fetching image 3")
                self.sharedResource.append("3")
                semaphore.signal()
            }
            semaphore.wait()
        }

- 사용법
    1. semaphore를 `0` 의 값을 주고 instance화 
    2. DispatchQueue에 `background`로 작업을 하도록 option 값을 제공하고 instance 화
    3. dispatchQueue.async 코드 블록을 만듬
    4. 각각의 background task가 끝나는 부분에 `signal()` 메소드 호출
    5. 새로운 background task가 시작하기 전에 `wait()` 메소드 호출



# Swift `where` keyword

https://www.notion.so/Swift-Where-Keyword-a22631558ee44cc3bafe46bf84be4372

`switch`

    enum Action {
        case createUser(age: Int)
        case createPost
        case logout
    }
    
    func printAction(action: Action){
        switch action {
            case .createUser(let age) where age < 21:
                print("Young and wild!")
            case .createUser:
                print("Older and wise!")
            case .createPost:
                print("Creating a post")
            case .logout:
                print("Log out")
        }
    }

`for loop`

    let numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
    for number in numbers where number % 2 == 0 {
            print(number)
    }

`extension` 

    extension Array where Element == Int {
        func printAverageAge()[
            let total = reduce(0, +)
            let average = total / count 
            print("Average age is \(average)")
        }
    }
    
    let ages = [20, 15, 45, 32, 67]
    ages.printAverageAge()

`Array.contains`

    let fruits = ["Banana", "Apple", "Kiwi"]
    let containsBanana = fruits.contains(where: {(fruit) in 
            return fruit == "Banana"
    })
    
    

# Swift Async Fuction 만들기

https://www.notion.so/Swift-Async-Await-da6f50269f774d5782d7f3c28bdfd7d5

    // async await fetch function
    func fetchSomethingAsyncAwait() throws -> Data? {
        guard let url = URL(string: "https://www.google.com") else { throw NetworkError.url }
        
        var data: Data?
        
        // Semaphore - initialization
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: url) { (d, r, e) in
            data = d
    
            semaphore.signal() //Semaphore - Stop waiting
        }.resume()
        
        //Semaphore - Wait until the condition is met
        _ = semaphore.wait(timeout: .distantFuture)
        
        return data
    }

- `closure` 을 사용하지 않는다.
- `semaphore` 를 사용.

# inout keyword

https://www.notion.so/Swift-inout-c5bf9b489a994872a5673f9d13cd692b


    import UIKit
        
        class Employee {
            var name: String
            var age: Int
            init(name: String, age: Int) {
                self.name = name
                self.age = age
            }
        }
        
        //Swift에서 기본적으로 parameter로 들어오는 값은 `let` constant 이다. 그래서 값을 바꿀 수 없다.
        //아래 코드는 error가 발생하는 코드.
        /*
        func changeEmployeeData(emp: Employee){
            emp = Employee(name: "Suneet", age: 25)
        }
        */
        
        func changeEmployeeData(emp: inout Employee){
            emp = Employee(name: "Charles", age: 15)
        }
        
        var employee1 = Employee(name: "Brian", age: 24)

1. 기본적으로 swift에서 function의 parameter 값은 `let` 으로 선언 되어 있음
2. parameter로 들어온 값을 변경하려면 `inout` keyword를 사용한다.


# Subscribe

https://www.notion.so/swift-subscript-keyword-a801e4aa9d8e4ce5986e05dd9f1c359b

    import UIKit
        
        //Subscript는 기본적으로 `private` value에 접근할 수 있게 하는 통로임.
        //보통 Array나 Dictionary가 private으로 선언되어있으면 외부에 값을 가져오거나 정해주게 할 수 있음.
        class DaysOfaWeek {
            private var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
            subscript(index: Int) -> String {
                get {
                    return days[index]
                }
                set(newValue) {
                    self.days[index] = newValue
                }
            }
        }
        
        var day = DaysOfaWeek()
        
        print(day[0])
        
        //set이 정의되있지 않으면 값을 바꿀 수 없다.
        day[0] = "happy day"
        print(day[0])

- Subscript는 `private` 으로 선언된 `array` 나 `dictionary` 에 값을 가져오거나 값을 새로 지정해 줄 수 있다.


#Swift Generic


https://www.notion.so/Swift-Generic-350fe6558bab4dc7a57c15f0bb164ad5

참고문서:

[https://www.tutorialspoint.com/swift/swift_generics.htm](https://www.tutorialspoint.com/swift/swift_generics.htm) 

[https://docs.swift.org/swift-book/LanguageGuide/Generics.html#ID192](https://docs.swift.org/swift-book/LanguageGuide/Generics.html#ID192)

- Swift enables us to create generic types, protocols, and functions, that aren’t tied to any specific concrete type
- Both `Array` and `Dictionary` are generics

### 🔵 Basic Example

    struct Container<Value> {
        var value: Value 
        var date: Date
    }
    
    let stringContainer = Container(value: "Message", date: Date())
    let intContainer = Container(value: 7, date: Date())

### 🔵 Function Generic

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

### 🔵 Struct Generic

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

### 🔵 Protocol Generic

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

### 🔵 Protocol Generic using `where` clause

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


# typealias

https://www.notion.so/TypeAlias-swift-aa12225d4ccf4eec810e5eb7b2c36201
https://medium.com/@ahmadfayyas/swift-quick-elegant-code-typealias-8e6d59f07f32

### Type Alias basic examples

        typealias studentName = String
        let name: studentName = "Paige"
        typealias Employees = Array<String>
        typealias GridPoint = (Int, Int)
        typealias CompletionHandler = (String) -> Void
        typealias CustomDictionary = Dictionary<String, Int>
        let phoneNumbers: CustomDictionary

### Real Life Example

        //-Real Life example
        class MyManager {
            
            func foo(success: (_ data: Data, _ message: String, _ status: Int, _ isEnabled: Bool) -> (),
                     failure: (_ error: Error, _ message: String, _ workaround: AnyObject) -> ())
            {
                
            }
            
            func bar(success: (_ data: Data, _ message: String, _ status: Int, _ isEnabled: Bool) -> (),
                     failure: (_ error: Error, _ message: String, _ workaround: AnyObject) -> ())
            {
                    
            }

            
        }

        //info - Codable is a typealias for both Decodable and Encodable protocols.
        class RefactoredMyManager {
            
            typealias Success = (_ data: Data, _ message: String, _ status: Int, _ isEnabled: Bool) -> ()
            typealias Failure = (_ error: Error, _ message: String, _ workaround: AnyObject) -> ()
            
            func foo(success: Success, failure: Failure){
                

                
            }
            
        }

        var refactoredManager = RefactoredMyManager()
        refactoredManager.foo(success: { (data, string, int, bool) in
            
        }) { (error, string, anyobject) in
            
        }
        
### Combining Protocols

        typealias CommonDataSource = UICollectionViewDataSource & UITableViewDataSource
        
### Closure Type Alias
    

        //- closure type alias
        // Closure Type Alias를 사용할 때는 return 값이 없는 함수가 사용하기 편하다.
        typealias NewCompletionHandler = (Int, Int) -> Void
        typealias NewCompletionHandlerWithReturnValue = (Int, Int) -> Int  //=> 간단한 함수 protocol을 정의하는 느낌으로 받아들이면 쓸만할 듯.

        func method(handler: NewCompletionHandler){
            handler(15, 15)
        }

        let newFunctionWithReturn: NewCompletionHandlerWithReturnValue = { (_ value1: Int, _ value2: Int) in
            return value1 + value2
        }

        let result = newFunctionWithReturn(15, 30)
        print("result: \(result)")


        func myMethod(sumHandler: NewCompletionHandlerWithReturnValue) -> Int {
            return sumHandler(15, 20)
        }

        let result2 = myMethod(sumHandler: newFunctionWithReturn)
        print(result2)

# Swift Equatable

https://www.notion.so/Swift-Equatable-1d4593157f2c4ef2b530f1f5e77878c5

- 기본적으로 xCode는 두 가지 값이 같은 것인지 틀린 것인지 알 수가 없다.
- 그래서 Equatable Protocol을 채택해야 한다.


        class A: Equatable {
            
            var num: Int
            
            init(num: Int){
                self.num = num
            }
            
            static func == (lhs: A, rhs: A) -> Bool {
                return lhs.num == rhs.num
            }
            
        }

        class B: Equatable {
            
            var num: Int
            
            init(num: Int){
                self.num = num
            }
            
            static func == (lhs: B, rhs: B) -> Bool {
                return lhs.num == rhs.num
            }
            
        }


        if A(num: 1) == A(num: 2) {
            print("same")
        } else {
            print("different")
        }

