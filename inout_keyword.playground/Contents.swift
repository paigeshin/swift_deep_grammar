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

