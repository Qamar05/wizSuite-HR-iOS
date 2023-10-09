//
//  SwiftConstants.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 11/09/23.
//

import UIKit

struct NetworkConstant {
    
    static let loginBaseUrl = "https://fmcg.xaapps.com/attendence/newattendencelogin.php"
    
    static let checkInUrl = "https://fmcg.xaapps.com/attendence/startDuty.php"
    
    static let checkOutUrl = "https://fmcg.xaapps.com/attendence/endDuty.php"
    
    static let getWorkingHoursUrl = "https://fmcg.xaapps.com/attendence/gethours.php"
    
    static let forgotPasswordUrl = "https://fmcg.xaapps.com/api/forgotPassword.php"
    
    static let holidayListUrl = "https://fmcg.xaapps.com/attendence/newholiday.php"
    
    static let leavesHistoryUrl = "https://fmcg.xaapps.com/api/newleaveHistory.php"
    
    
    static let applyLeaveUrl = "https://fmcg.xaapps.com/api/leave.php"
    
    static let leavesCancelUrl = "https://fmcg.xaapps.com/api/leaveCancel.php"
    
    static let attendanceRegularisationUrl = "https://fmcg.xaapps.com/attendence/forgotapi.php"
    
    static let regulariseDayCountUrl  = "https://fmcg.xaapps.com/attendence/regularise.php"
    
    //ATTENDANCE DETAIL URL
    static let getUserMonthDetailUrl  = "https://fmcg.xaapps.com/attendence/usermonthdetail.php"

    static let getBirthdayListUrl  = "https://fmcg.xaapps.com/attendence/newbirthday.php"
    
    static let myProfileUrl = "https://fmcg.xaapps.com/attendence/getprofiledetail.php"
    
    static let editProfileUrl = "https://fmcg.xaapps.com/attendence/editphoto.php"
    
    static let getNotificationUrl = "https://fmcg.xaapps.com/attendence/getnotification.php"
    
    static let getSupportUrl = "https://fmcg.xaapps.com/attendence/devsupport.php"
    
    static let changePwUrl = "https://fmcg.xaapps.com/attendence/changepassword.php"

    static let sendOTPUrl =  "https://fmcg.xaapps.com/attendence/emailotp.php"
    
    static let verifyOTPUrl =  "https://fmcg.xaapps.com/attendence/verifyOTP.php"
    
    static let todayWorkingHoursUrl =  "https://fmcg.xaapps.com/attendence/gethours.php"
    
    //get Today Week Month Hours
    static let getUserDetailUrl  = "https://fmcg.xaapps.com/attendence/getuserdetail.php"



}

    
//rgb(225, 135, 135)

//status bar #327524
//golden #F0AF08 //Attendance Regularisation
//red #BF3743    // Absent, cancle button on leave
//blue #2041B6    // Remaining Leaves
//purple #C004A7    // Worked Remotely and Leave Title


struct GenericColours {
    
    
    static let navigationGreenColor = UIColor(red: 89/255, green: 190/255, blue: 69/255, alpha: 1.0)
    static let myCustomGreen = UIColor(red: 89/255, green: 190/255, blue: 69/255, alpha: 1.0)
    static let lightGrayColor = UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1.0)
    static let redColor = UIColor(red: 191/255, green: 55/255, blue: 67/255, alpha: 1.0)
    static let yellowColor = UIColor(red: 254/255, green: 201/255, blue: 76/255, alpha: 1.0)
    static let blueColour = UIColor(red: 32/255, green: 65/255, blue: 182/255, alpha: 1.0)
    static let purpleColour = UIColor(red: 192/255, green: 4/255, blue: 167/255, alpha: 1.0)

    
    
//    blue #2041B6    // Remaining Leaves
//    purple #C004A7    // Worked Remotely and Leave Title

}
    

