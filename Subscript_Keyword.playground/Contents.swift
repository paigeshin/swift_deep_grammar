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
