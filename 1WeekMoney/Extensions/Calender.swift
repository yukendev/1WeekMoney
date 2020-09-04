//
//  Calender.swift
//  1WeekMoney
//
//  Created by 手塚友健 on 2020/08/30.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import Foundation

extension Calendar {

    //MARK: - Week operations

    func startOfWeek(for date:Date) -> Date {
        let comps = self.dateComponents([.weekOfYear, .yearForWeekOfYear], from: date)
        return self.date(from: comps)!
    }

    func endOfWeek(for date:Date) -> Date {
        return nextWeek(for: date)
    }

    func previousWeek(for date:Date) -> Date {
        return move(date, byWeeks: -1)
    }

    func nextWeek(for date:Date) -> Date {
        return move(date, byWeeks: 1)
    }

    //MARK: - Month operations

    func startOfMonth(for date:Date) -> Date {
        let comps = dateComponents([.month, .year], from: date)
        return self.date(from: comps)!
    }

    func endOfMonth(for date:Date) -> Date {
        return nextMonth(for: date)
    }

    func previousMonth(for date:Date) -> Date {
        return move(date, byMonths: -1)
    }

    func nextMonth(for date:Date) -> Date {
        return move(date, byMonths: 1)
    }

    //MARK: - Move operations
    
    func move(_ date:Date, byDays days:Int) -> Date {
        return self.date(byAdding: .day, value: days, to: startOfWeek(for: date))!
    }

    func move(_ date:Date, byWeeks weeks:Int) -> Date {
        return self.date(byAdding: .weekOfYear, value: weeks, to: startOfWeek(for: date))!
    }

    func move(_ date:Date, byMonths months:Int) -> Date {
        return self.date(byAdding: .month, value: months, to: startOfMonth(for: date))!
    }
}
