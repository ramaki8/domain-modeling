//
//  main.swift
//  domain-modeling
//
//  Created by Rachel Kipps on 10/14/15.
//  Copyright © 2015 Rachel Kipps. All rights reserved.
//

import Foundation

struct Money {
    var amount: Double
    var currency: String
    mutating func convert(convertTo: String) {
        self.amount *= getRateToUSD(self.currency)
        self.amount *= (1.0 / getRateToUSD(convertTo))
        self.currency = convertTo
    }
    
    func getRateToUSD(c: String) -> Double {
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

//var currency1 = Money(amount: 4.0, currency: "GBP")
//print(currency1)
////currency1.convert("GBP")
////print(currency1)
//var currency2 = Money(amount: 4.0, currency: "USD")
//currency1.subtract(currency2)
//print(currency1)

class Job {
    var title : String
    var salary : (Double, String)
    
    init(title: String, salary: (Double, String)) {
        self.title = title
        self.salary = salary
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

//var job1 = Job(title: "Janitor", salary: (11.56, "per-hour"))
//print(job1.title)
//print(job1.salary)
//job1.raise(10.0)
//print(job1.salary)
//print(job1.calculateIncome(45.5))
//var job2 = Job(title: "Teacher", salary: (42000.00, "per-year"))
//print(job2.title)
//print(job2.salary)
//job2.raise(10.0)
//print(job2.salary)
//print(job2.calculateIncome(45.5))















