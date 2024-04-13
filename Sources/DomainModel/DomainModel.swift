struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    let amount: Int
    let currency: String

    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }

    func convert(_ givenCurrency: String) -> Money {
        var usdConvert = amount
        // need to figure out rounding
        // converts to usd first, if already usd does not need to be converted at beginning
        if(currency == "GBP") {
            usdConvert *= 2
        } else if(currency == "EUR") {
            usdConvert *= 2
            usdConvert /= 3
        } else if(currency == "CAN") {
            usdConvert *= 4
            usdConvert /= 5
        }
        if(givenCurrency == "GBP") {
            usdConvert /= 2
        } else if(givenCurrency == "EUR") {
            usdConvert *= 3
            usdConvert /= 2
        } else if(givenCurrency == "CAN") {
            usdConvert *= 5
            usdConvert /= 4
        }
        return Money(amount: usdConvert, currency: givenCurrency)
    }

    // in the tests, the money that is passed in the parameter is the currency we need to convert to
    func add(_ secondMoney: Money) -> Money {
        let convertMoney = self.convert(secondMoney.currency)
        let totalMoney = convertMoney.amount + secondMoney.amount
        return Money(amount: totalMoney, currency: secondMoney.currency)
    }

    func subtract(_ secondMoney: Money) -> Money {
        let convertMoney = self.convert(secondMoney.currency)
        let totalMoney = convertMoney.amount - secondMoney.amount
        return Money(amount: totalMoney, currency: secondMoney.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    // hourly is double
    // salary is int

    let title: String
    var type: JobType

    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }

    // returns amount of money as int, that in one year this position makes
    // for salary, this is yearly amount, for hourly, this is * given hours worked
    func calculateIncome(_ hoursWorked: Int) -> Int {
        switch type {
            case .Hourly(let hourlyWage):
                return Int(hourlyWage) * hoursWorked
            case .Salary(let salary):
                return Int(salary)
        }
    }

    func raise(byAmount: Double) {
        // by hourly or salary (use switch and case)
        // calculate what the value would be with calculateIncome
        // assign the value to type
        switch type {
            case .Hourly(let hourlyWage):
                let calculatedWage = hourlyWage + byAmount
                type = JobType.Hourly(calculatedWage)
            case .Salary(let salary):
                let calculatedWage = Double(salary) + byAmount
                type = JobType.Salary(UInt(calculatedWage))
        }
    }

    func raise(byPercent: Double) {
        // by hourly or salary (use switch and case)
        // calculate what the value would be with calculateIncome
        // assign the value to type
        switch type {
            // to calculate: (amount * bypercent) + amount
            case .Hourly(let hourlyWage):
                let calculatedWage = hourlyWage * byPercent + hourlyWage
                type = JobType.Hourly(calculatedWage)
            case .Salary(let salary):
                let calculatedWage = Double(salary) * byPercent + Double(salary)
                type = JobType.Salary(UInt(calculatedWage))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    let firstName: String
    let lastName: String
    let age: Int
    // since these are not always present
    var job: Job?
    var spouse: Person?

    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }

    // get and set spouse, i assumed restriction was 16 as well
    var _spouse: Person? {
        get {
            return spouse
        } 
        set {
            if age >= 16 {
                // why am i not able to change the name of newValue? ask ta
                spouse = newValue
            } else {
                spouse = nil
            }
        }
    }

    // get and set job, restriction of 16
    var _job: Job? {
        get {
            return job
        }
        set {
            if age >= 16 {
                job = newValue
            } else {
                job = nil
            }
        }
    }

    func toString() -> String {
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(String(describing: job)) spouse:\(String(describing: spouse))]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    // collection of persons
    var members: [Person]
    // why do i have to add them as properties?
    let spouse1: Person
    let spouse2: Person

    init(spouse1: Person, spouse2: Person) {
        self.spouse1 = spouse2
        self.spouse2 = spouse1
        self.members = [spouse1, spouse2]
    }

    func householdIncome() -> Int {
        var totalIncome = 0
        // loop over everyone in family and add them to totalIncome, default income to 0 if no job
        for member in members {
            totalIncome += member.job?.calculateIncome(2000) ?? 0
        }
        return totalIncome
    }

    func haveChild(_ newMember : Person) -> Bool {
        if(spouse1.age < 21 && spouse2.age < 21) {
            return false
        } else {
            members.append(newMember)
            return true
        }
    }

}
