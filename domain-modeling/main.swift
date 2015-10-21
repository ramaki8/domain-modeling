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

struct Money : CustomStringConvertible, Mathematics {
    var amount: Double
    var currency: String
    var description: String {
        return "\(self.currency)\(self.amount)"
    }
    
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

}


///////////////////////
// Part 2: Job class //
///////////////////////

class Job : CustomStringConvertible {
    var title : String
    var salary : (Double, String)
    var description : String {
        return "\(self.title): $\(self.salary.0) \(self.salary.1)"
    }
    
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

class Person : CustomStringConvertible {
    var firstName : String
    var lastName : String
    var age : Int
    var job : Job?
    var spouse : Person?
    var description : String {
        return self.toString()
    }
    
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

class Family : CustomStringConvertible {
    var members : [Person]
    var description : String {
        return self.toString()
    }
    
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
    
    func toString() -> String {
        var str = "\(members[0].description)"
        for var i = 1; i < members.count; i++ {
            str += "; \(members[i].description)"
        }
        return str
    }
    
}


///////////////////////
// Domain Modeling 2 //
///////////////////////

protocol CustomStringConvertible {
    var description: String { get }
}

protocol Mathematics {
    mutating func add(m1: Money)
    mutating func subtract(m1: Money)
}

extension Double {
    var USD : Money { return Money(amount: self, currency: "USD") }
    var EUR : Money { return Money(amount: self, currency: "EUR") }
    var GBP : Money { return Money(amount: self, currency: "GBP") }
    var CAN : Money { return Money(amount: self, currency: "CAN") }
}


/////////////
// Testing //
/////////////

func stringConvertibleTest() {
    print("Testing CustomStringConvertible...")
    let c1 = Money(amount: 22.0, currency: "EUR")
    let c2 = Money(amount: 101.55, currency: "GBP")
    print("\nMoney:")
    print("\t\(c1.description)")
    print("\t\(c2.description)")

    let j1 = Job(title: "Professor", salary: (70000, "per-year"))
    let j2 = Job(title: "Postal Worker", salary: (19.50, "per-hour"))
    print("\nJob:")
    print("\t\(j1.description)")
    print("\t\(j2.description)")

    let p1 = Person(first: "Joffrey", last: "Baratheon", age: 19, job: Job(title: "King", salary: (500000, "per-year")), spouse: Person(first: "Margaery", last: "Tyrell", age: 20))
    let p2 = Person(first: "Arya", last: "Stark", age: 16)
    print("\nPerson:")
    print("\t\(p1.description)")
    print("\t\(p2.description)")

    let bob = Person(first: "Bob", last: "Belcher", age: 44, job: Job(title: "Frycook", salary: (6.50, "per-hour")), spouse: Person())
    let linda = Person(first: "Linda", last: "Belcher", age: 42, job: Job(title: "Bookkeeper", salary: (6.50, "per-hour")), spouse: bob)
    bob.spouse = linda
    let tina = Person(first: "Tina", last: "Belcher", age: 13, job: Job(title: "Waitress", salary: (2.00, "per-hour")), spouse: Person())
    let gene = Person(first: "Gene", last: "Belcher", age: 11)
    let louise = Person(first: "Louise", last: "Belcher", age: 9)
    var belchers = [Person]()
    belchers.append(bob)
    belchers.append(linda)
    belchers.append(tina)
    belchers.append(gene)
    belchers.append(louise)
    let f1 = Family(family: belchers)
    print("\nFamily:")
    print("\t\(f1.description)")
}

func mathTest() {
    print("\n\nTesting Mathematics...")
    var c3 = Money(amount: 25.0, currency: "USD")
    let c4 = Money(amount: 18.5, currency: "GBP")
    print("\t\(c3.description) + \(c4.description)")
    c3.add(c4)
    print("\t= \(c3.description)")
    var c5 = Money(amount: 20.0, currency: "CAN")
    let c6 = Money(amount: 10.0, currency: "USD")
    print("\t\(c5.description) - \(c6.description)")
    c5.subtract(c6)
    print("\t= \(c5.description)")
}

func doubleTest() {
    print("\n\nTesting Double...")

    let d1 = 34.0
    print("\tConverting Double \(d1) to a CAN Money object:")
    let d1Curr = d1.CAN
    print("\t\(d1Curr.description)")
    let d2 = 13.2
    print("\tConverting Double \(d2) to a EUR Money object:")
    let d2Curr = d2.EUR
    print("\t\(d2Curr.description)")
}

stringConvertibleTest()
mathTest()
doubleTest()