import CoreLocation
import UIKit

class LocationManager {
    
    private init() {}

    static var lastLocation: CLLocation?
    
    private static let locationManager = CLLocationManager()
    
    private static var callbacks = [(CLLocation) -> Void]()
    
    private static var lastTrackingUpdate: Int64 = 0
    
    static func registerCallback(_ call: @escaping (CLLocation) -> Void) {
        if let location = lastLocation {
            call(location)
        } else {
            callbacks.append(call)
        }
    }
    
    static func initialize(_ delegate: CLLocationManagerDelegate) {
        locationManager.delegate = delegate
        
        if let lastPoint = TrackingManager.trackingData.last {
            lastTrackingUpdate = lastPoint.tst
        }
    }
    
    static func requestLocationUpdates() {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined { // need to always check because of "Allow once" option
            requestAuthorization()
        } else if authStatus == .authorizedAlways || authStatus == .authorizedWhenInUse {
            startUpdatingLocation()
        }
    }
    
    static func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    static func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    static func updateAccuracy(foreground: Bool = true) {
        if foreground {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
    }
    
    static func updateLocation(_ location: CLLocation) {
        lastLocation = location
        
        LocationBordersManager.updateLocationBorders(location)
        
        callbacks.forEach { callback in callback(location) }
        callbacks.removeAll()
        
        if let rootViewController = RootViewController.instance {
            rootViewController.mapViewController.accuracyLabel.isHidden = false
            rootViewController.mapViewController.accuracyLabel.text = "Location accuracy: " +
            "\(Int(location.horizontalAccuracy)) meters"
        }
        
        let now = Date.timestamp()
        if now - lastTrackingUpdate > TrackingManager.trackingIntervalMs &&
            location.horizontalAccuracy > 0 && location.horizontalAccuracy < 30 {
            print("Updating tracking location")
            
            let point = TrackingPoint(location.coordinate)
            
            TrackingManager.addTrackingPoint(point)
            
            if let rootViewController = RootViewController.instance {
                rootViewController.mapViewController.updateUserTracks()
            }
            
            lastTrackingUpdate = now
            
            if UserStatusManager.sick() {
                TracksManager.uploadNewTracks()
            }
        }
    }
        
}
