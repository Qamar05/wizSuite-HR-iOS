//
//  LocationMang.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 08/10/23.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    typealias LocationHandler = (CLLocation?) -> ()
    
    private lazy var locationManager: CLLocationManager = {
        
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 1
        manager.delegate = self
        return manager
    }()
    
    private var status: CLAuthorizationStatus {
        
        get {
            return CLLocationManager.authorizationStatus()
        }
    }
    
    static var shared: LocationManager = LocationManager()
    
    private override init() {}
    
    private var locationHandlers: [LocationHandler?] = []
    
    class var locationEnabled: Bool {
        
        return CLLocationManager.locationServicesEnabled()
    }
    
    var hasGrantedPermissions: Bool {
        
        return (status == .authorizedAlways || status == .authorizedWhenInUse) && LocationManager.locationEnabled
    }


    
    // MARK: - Private
    
    private func getLocation(then locationHandler:LocationHandler?) {
        
        DispatchQueue.main.async {
            
            self.locationHandlers.append(locationHandler)
            self.locationManager.startUpdatingLocation()
        }
    }
    
    private func failedRequestingPermissions() {
        
        _ = self.locationHandlers.map {$0?(nil)}
        
        DispatchQueue.main.async {

            self.locationHandlers.removeAll(keepingCapacity: true)
        }
    }
    
    
    
    // MARK: - Init
    
    deinit {
        
        self.locationManager.stopUpdatingLocation()
        self.locationHandlers.removeAll(keepingCapacity: false)
    }
    
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        DispatchQueue.main.async {
            
            if let updatedLocation = locations.last {
                // Call the locationHandler
                let _ = self.locationHandlers.map { $0?(updatedLocation) }
                
            } else {
                _ = self.locationHandlers.map { $0?(nil) }
            }
            
            self.locationHandlers.removeAll(keepingCapacity: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        self.failedRequestingPermissions()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
}
