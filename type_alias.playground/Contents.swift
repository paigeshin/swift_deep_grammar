import UIKit

//Reference
//https://medium.com/@ahmadfayyas/swift-quick-elegant-code-typealias-8e6d59f07f32


//* Type Alias *

//-basic type alias example
typealias studentName = String
let name: studentName = "Paige"
typealias Employees = Array<String>
typealias GridPoint = (Int, Int)
typealias CompletionHandler = (String) -> Void
typealias CustomDictionary = Dictionary<String, Int>
let phoneNumbers: CustomDictionary

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


//- Combining Protocols
typealias CommonDataSource = UICollectionViewDataSource & UITableViewDataSource

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




