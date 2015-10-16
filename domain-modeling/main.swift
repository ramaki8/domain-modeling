//
//  main.swift
//  domain-modeling
//
//  Created by Rachel Kipps on 10/14/15.
//  Copyright © 2015 Rachel Kipps. All rights reserved.
//

import Foundation


//////////////////////////////
// Part 1: Money value type //
//////////////////////////////

struct Money {
    var amount: Double
    var currency: String
    
    mutating func convert(convertTo: String) {
        self.amount *= getRateToUSD(self.currency)
        self.amount *= (1.0 / getRateToUSD(convertTo))
        self.currency = convertTo
    }
    
    private func getRateToUSD(c: String) -> Double {
        switch c {
        case "GBP":
            return 2.0
        case "EUR":
            return (2.0/3.0)
        case "CAN":
            return (4.0/5.0)
        case "USD":
            return 1.0
        default:
            return 0.0
        }
    }
    
    mutating func add(var m: Money) {
        let type = self.currency
        self.convert("USD")
        m.convert("USD")
        self.amount += m.amount
        self.convert(type)
    }
    
    mutating func subtract(var m: Money) {
        let type = self.currency
        self.convert("USD")
        m.convert("USD")
        self.amount = self.amount - m.amount
        self.convert(type)
    }
    
    func isValidType(c: Money) -> Bool {
        switch c.currency {
        case "USD", "GBP", "EUR", "CAN":
            return true
        default:
            return false
        }
    }
}




///////////////////////
// Part 2: Job class //
///////////////////////

class Job {
    var title : String
    var salary : (Double, String)
    
    init(title: String, salary: (Double, String)) {
        self.title = title
        self.salary = salary
    }
    
    init() {
        self.title = ""
        self.salary = (0.0, "")
    }
    
    func calculateIncome(hours: Double) -> Double {
        var yearlyIncome = self.salary.0
        if (self.salary.1 == "per-hour") {
            yearlyIncome *= hours
        }
        return yearlyIncome
    }
    
    func raise(percent: Double) {
        let decimal = percent/100.0
        self.salary.0 += decimal * self.salary.0
        self.salary.0 = round(100 * self.salary.0) / 100
        
    }
}




//////////////////////////
// Part 3: Person class //
//////////////////////////

class Person {
    var firstName : String
    var lastName : String
    var age : Int
    var job : Job?
    var spouse : Person?
    
    init(first: String, last: String, age: Int, job: Job, spouse: Person) {
        self.firstName = first
        self.lastName = last
        self.age = age
        if (age >= 16) {
            self.job = job
        }
        if (age >= 18) {
            self.spouse = spouse
        }
    }
    
    init(first: String, last: String, age: Int) {
        self.firstName = first
        self.lastName = last
        self.age = age
    }
    
    init() {
        self.firstName = ""
        self.lastName = ""
        self.age = 0
    }
    
    
    func toString() -> String {
        var str = "\(self.firstName) \(self.lastName), age \(self.age)"
        if ((self.job?.title) != "" && self.job?.title != nil) {
            str += ", \(self.job!.title)"
        }
        if ((self.spouse?.firstName) != "" && self.spouse?.firstName != nil) {
            str += ", married to \(self.spouse!.firstName) \(self.spouse!.lastName)"
        }
        return str
    }
}





//////////////////////////
// Part 4: Family class //
//////////////////////////

class Family {
    var members : [Person]
    
    init(family: [Person]) {
        var isOver21 = false
        for member in family {
            if member.age > 21 {
                isOver21 = true
            }
        }
        if(isOver21) {
            self.members = family
        } else {
            self.members = []
        }
    }
    
    func householdIncome() -> Double {
        var totalIncome = 0.0
        for member in self.members {
            if(member.job != nil) {
                let personalIncome = member.job!.calculateIncome(2000)
                totalIncome += personalIncome
            }
        }
        return totalIncome
    }
    
    func haveChild(first: String, last: String) {
        members.append(Person(first: first, last: last, age: 0))
    }
    
}


/////////////////////
// Part 5: Testing //
/////////////////////

func testMoney() {
    print("Testing Money:")
    var currency1 = Money(amount: 100.0, currency: "USD")
    print("First currency: $\(currency1.amount) \(currency1.currency)")
    print("Converted to:")
    currency1.convert("GBP")
    print("\tGBP: $\(currency1.amount) \(currency1.currency)")
    currency1.convert("EUR")
    print("\tEUR: $\(currency1.amount) \(currency1.currency)")
    currency1.convert("CAN")
    print("\tCAN: $\(currency1.amount) \(currency1.currency)")
    currency1.convert("USD")
    
    let currency2 = Money(amount: 57.50, currency: "CAN")
    print("Second currency: $\(currency2.amount) \(currency2.currency)")
    print("Addition and subtraction:")
    print("\t$\(currency1.amount) \(currency1.currency) + $\(currency2.amount) \(currency2.currency) =")
    currency1.add(currency2)
    print("\t$\(currency1.amount) \(currency1.currency)")
    
    print("\t$\(currency1.amount) \(currency1.currency) - $\(currency2.amount) \(currency2.currency) =")
    currency1.subtract(currency2)
    print("\t$\(currency1.amount) \(currency1.currency)")


}

func testJob() {
    print("\n\nTesting Job:")
    let job1 = Job(title: "Janitor", salary: (11.56, "per-hour"))
    print("Job 1: \(job1.title): $\(job1.salary.0) \(job1.salary.1)")
    print("Adding a raise:")
    job1.raise(5.0)
    print("\t 5%:  $\(job1.salary.0)")
    job1.salary.0 = 11.56
    job1.raise(10.0)
    print("\t10%:  $\(job1.salary.0)")
    print("Calculating yearly income:")
    job1.salary.0 = 11.56
    let job1Income = job1.calculateIncome(2000)
    print("\t2000 hours worked: $\(job1Income) per year")
    
    let job2 = Job(title: "CEO", salary: (11000000, "per-year"))
    print("\nJob 2: \(job2.title): $\(job2.salary.0) \(job2.salary.1)")
    print("Adding a raise:")
    job2.raise(5.0)
    print("\t 5%:  $\(job2.salary.0)")
    job2.salary.0 = 11000000
    job2.raise(10.0)
    print("\t10%:  $\(job2.salary.0)")
    print("Calculating yearly income:")
    job2.salary.0 = 11000000
    let job2Income = job2.calculateIncome(2000)
    print("\t2000 hours worked: $\(job2Income) per year")
}

func testPerson() {
    print("\n\nTesting Person:")
    let squidward = Person(first: "Squidward", last: "Tentacles", age: 30, job: Job(title: "cashier", salary: (10.50, "per-hour")), spouse: Person())
    print("\tPerson 1: \(squidward.toString())")
    let spongebob = Person(first: "Spongebob", last: "Squarepants", age: 15, job: Job(title: "frycook", salary: (6.50, "per-hour")), spouse: Person())
    print("\tPerson 2: \(spongebob.toString())")
    let krabs = Person(first: "Eugene", last: "Krabs", age: 50, job: Job(title: "business owner", salary: (50000, "per-year")), spouse: Person(first: "Mrs", last: "Krabs", age: 46))
    print("\tPerson 3: \(krabs.toString())")
    let patrick = Person(first: "Patrick", last: "Star", age: 17, job: Job(), spouse: Person())
    print("\tPerson 4: \(patrick.toString())")
}

func testFamily() {
    print("\n\nTesting Family:")
    let homer = Person(first: "Homer", last: "Simpson", age: 40, job: Job(title: "Safety Inspector", salary: (25000, "per-year")), spouse: Person())
    let marge = Person(first: "Marge", last: "Simpson", age: 36, job: Job(title: "Baker", salary: (10.50, "per-hour")), spouse: homer)
    homer.spouse = marge
    let bart = Person(first: "Bart", last: "Simpson", age: 10)
    let lisa = Person(first: "Lisa", last: "Simpson", age: 8)
    var simpsons = [Person]()
    simpsons.append(homer)
    simpsons.append(marge)
    simpsons.append(bart)
    simpsons.append(lisa)
    let simpsonsFam = Family(family: simpsons)
    for member in simpsonsFam.members {
        print("\tMember: \(member.toString())")
    }
    print("They had a  baby!")
    simpsonsFam.haveChild("Maggie", last: "Simpson")
    for member in simpsonsFam.members {
        print("\tMember: \(member.toString())")
    }
    print("Total family income:")
    print("\t$\(simpsonsFam.householdIncome()) per year")



}

testMoney()
testJob()
testPerson()
testFamily()
