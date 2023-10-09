//
//  GenericMethods.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 11/09/23.
//

import UIKit

class GenericMethods {
    
    
    @objc static func getAuthorisationToken() -> String {
        let authToken = "416A471A1A729D6D6E254C7528163"
        return authToken
        
    }
    
    @objc static func getToken() -> String{
        let token =  UserDefaults.standard.string(forKey:  "TOKEN")
        return token ?? ""
    }
    
    @objc static func getUsername() -> String{
        let userName = UserDefaults.standard.string(forKey:  "USERNAME")
        return userName ?? ""
    }
    
    @objc static func getDesignation() -> String{
        let userDesignation =  UserDefaults.standard.string(forKey:  "DESIGNATION")
        return userDesignation ?? ""
    }
    
    @objc static func getProfileUrl() -> String{
        let userProfileImg =  UserDefaults.standard.string(forKey:  "PROFILEPIC")
        return userProfileImg ?? ""
    }
    
    @objc static func getCheckInCheckOutCurrentDate() -> String{ //AttendanceDate
        let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let DateInFormat = dateFormatter.string(from: todaysDate)
        return DateInFormat
    }
    
    @objc func saveLeaveApplyDate(leaveApplyDate : String){
        let defaults = UserDefaults.standard
        defaults.set(leaveApplyDate, forKey: "LEAVEAPPLYDATE")
        defaults.synchronize()
    }
    
    @objc static func getLeaveApplyDate() -> String{
        let applyDate = UserDefaults.standard.string(forKey:  "LEAVEAPPLYDATE")
        return applyDate ?? ""
    }
    
    
    @objc static func getTotalWorkingHours() -> String? {
        let loginStatus = UserDefaults.standard.string(forKey:  "TOTAL_WORKING_HOURS")
        return loginStatus ?? ""
    }
    
    @objc static func getTodaysWorkingHours() -> String? {
        let loginStatus = UserDefaults.standard.string(forKey:  "TODAY_WORKING_HOURS")
        return loginStatus ?? ""
    }
    
    
    @objc static func getTotalWeekHours() -> String? {
        let loginStatus = UserDefaults.standard.string(forKey:  "WEEK_WORKING_HOURS")
        return loginStatus ?? ""
    }
    
    @objc static func getTotalMonthHours() -> String? {
        let loginStatus = UserDefaults.standard.string(forKey:  "MONTH_WORKING_HOURS")
        return loginStatus ?? ""
    }
    
    
    @objc static func saveCheckInCheckOutStatus(status: String) {
        
        UserDefaults.standard.set(status, forKey: "STATUS")
        UserDefaults.standard.synchronize()
    }

    
    @objc static func getCheckInCheckOutStatus() -> String {
        let status =  UserDefaults.standard.string(forKey:  "STATUS")
        return status ?? ""
    }
    
    
    @objc static func getUserID() -> String{
        let userId =  UserDefaults.standard.string(forKey:  "USERID")
        return userId ?? ""
        
    }
    
    @objc static func getLoginStatus() -> String {
        let loginStatus =  UserDefaults.standard.string(forKey:  "LOGINSTATUS") //Key from Server
        return loginStatus ?? ""
    }
    
    
    @objc static func saveCheckInLatitude(lat: Double) {
        UserDefaults.standard.set(lat, forKey: "CHECKIN_LAT")
        UserDefaults.standard.synchronize()
    }
    
    @objc static func saveCheckinLongitude(long: Double) {
        UserDefaults.standard.set(long, forKey: "CHECKIN_LONG")
        UserDefaults.standard.synchronize()
    }
    
    @objc static func saveCheckOutLatitude(lat: Double) {
        UserDefaults.standard.set(lat, forKey: "CHECKOUT_LAT")
        UserDefaults.standard.synchronize()
    }
    
    @objc static func saveCheckOutLongitude(long: Double) {
        UserDefaults.standard.set(long, forKey: "CHECKOUT_LONG")
        UserDefaults.standard.synchronize()
    }
    
    @objc static func saveLocationAddress(location: String) {
        UserDefaults.standard.set(location, forKey: "LOCATION")
        UserDefaults.standard.synchronize()
    }
    
    @objc static func getLocationAddress() -> String {
        let locationAddress =  UserDefaults.standard.string(forKey:  "LOCATION") //Key from Server
        return locationAddress ?? ""
    }
    
    @objc static func getCheckInLat() -> Double {
        let ChechInLat =  UserDefaults.standard.double(forKey:  "CHECKIN_LAT") //Key from Server
        return ChechInLat
    }
    
    @objc static func getCheckInLong() -> Double {
        let checkInLong =  UserDefaults.standard.double(forKey:  "CHECKIN_LONG") //Key from Server
        return checkInLong
        
    }
    
    @objc static func getCheckOutLat() -> Double {
        let checkOutLat =  UserDefaults.standard.double(forKey:  "CHECKOUT_LAT") //Key from Server
        return checkOutLat
    }
    
    @objc static func getCheckOutLong() -> Double {
               
        let checkOutLong =  UserDefaults.standard.double(forKey:  "CHECKOUT_LONG") //Key from Server
        return checkOutLong
        
    }
        
    
    @objc static func getCurrentHours() -> String { //For Checkout / checkin
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let result = formatter.string(from: date)
        print(result) // 2020–04–15 10:11 PM
        return result
    }
    
//    @objc static func getCurrentMins() -> String { //For Checkout / checkin
//        let todaysDate = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "mm"
//        let DateInFormat = dateFormatter.string(from: todaysDate)
//        return DateInFormat
//    }
//    
//    @objc static func getCurrentAMPM() -> String { //For Checkout / checkin
//        let todaysDate = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm"
//        dateFormatter.dateFormat = "a"
//        let DateInFormat = dateFormatter.string(from: todaysDate)
//        return DateInFormat
//    }
//    
    @objc static func getCurrentTime() -> String { //For Checkout / checkin
        let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
       // dateFormatter.dateFormat = "a"
        let DateInFormat = dateFormatter.string(from: todaysDate)
        return DateInFormat
    }
    
    @objc static func getCurrentAttendanceDate() -> String {
        
       // return "2023-10-7"
        
        let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let DateInFormat = dateFormatter.string(from: todaysDate)
        return DateInFormat
    }
   
    
    @objc static func changeDateFormat(dateString: String) -> String { //For Apply Leave Page
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE, MMM d, yyyy"

       // dateFormatter.dateFormat = "HH:mm:ss"
        
        let dateFromStr = dateFormatter.date(from: dateString) ?? Date()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let timeFromDate = dateFormatter.string(from: dateFromStr)
        print(timeFromDate)
        
        return timeFromDate
        
    }
    

    
}

extension Date {
    
    func isEqualTo(_ date: Date) -> Bool {
        return self == date
    }
    
    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }
    
    func isSmallerThan(_ date: Date) -> Bool {
        return self < date
    }
    
    
    
    
    
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
    
    static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: Date())
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    func hour() -> String{
        let hour = Calendar.current.component(.hour, from: Date())
        return String(hour)
        
    }
    
    
    func minute() -> String{
        let mins = Calendar.current.component(.minute, from: Date())
        return String(mins)
    }
    
    
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: "2015-04-01T11:42:00") // replace Date String
    }
    
    //"2023-10-3"
    
    
}


extension Calendar {
    
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
}

