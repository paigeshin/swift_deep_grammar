let regularVariable: Int = 1

//Tuple Form 1
let person: (String, String, String) = ("Billy", "Bob", "Johnson")
print(person.0, person.1, person.2)

//Tuple Form 2
let person2 = (firstName: "Billy", middleName: "Bob", lastName: "Johnson")
print(person2.firstName)
print(person2.middleName)
print(person2.lastName)

//Basic Function
func multiply(x: Int, y: Int) -> Int {
    return x * y
}

multiply(x: 4, y: 3)

//Function With Tuple, will use a tuple as a return value
func divide(x: Int, y: Int) -> (Int, Int) {
    let quotient: Int = x / y
    let remainder: Int = x % y
    return (quotient, remainder)
}

let result:(Int, Int) = divide(x: 7, y: 2)
print(result.0)

//Lets try to use optionals inside of tuples somehow
func topTwoLongestNames(names: [String]) -> (String, String?) {
    //Lets sort first
    let sortedList = names.sorted { (first, second) -> Bool in
        return first.count > second.count //count가 큰 쪽부터 앞쪽으로 정렬
    }
    
    if sortedList.count == 1 {
        return (sortedList[0], nil)
    }

    return (sortedList[0], sortedList[1])
}

let result2: (String, String?) = topTwoLongestNames(names: ["Mike", "bill", "Steve", "Samantha"])
print("last tuple")
print(result2.0)
print(result2.1 ?? "No Value")



/*

 보통 관계가 있는 값을 지정할 때 사용한다.
 
 Tuple 정리
 
 let tuple: (?, ? ,?) = ( ? , ? , ?)
 
 데이터 Access
 
 tuple.0, tuple.1, tuple.2
 
 
 key-value 값 지정
 let tuple: (firstName: String, secondName: String) = (firstName: "A", secondName: "B")
 tuple.firstName
 tuple.secondName

 */
