import UIKit

//기본적으로 xCode는 두 개의 값이 같은지 틀린지 알 수가 없다.
//그래서 Equatable protocol을 가져와야 한다.
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
