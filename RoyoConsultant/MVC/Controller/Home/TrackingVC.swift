//
//  TrackingVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 10/11/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//


import UIKit
import GoogleMaps

class TrackingVC: BaseVC {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblETA: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var statusView: UIView! {
        didSet {
            statusView.roundCorners(with: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 24)
        }
    }
    @IBOutlet weak var btnCall: UIButton!
    
    public var request: Requests?
    public var didStatusChanged: ((_ status: RequestStatus) -> Void)?
    private var previousOtherPersonLocation: CLLocationCoordinate2D?

    var polyPath : GMSMutablePath?
    var polyline : GMSPolyline?
    var demoPolyline = GMSPolyline()
    
    var timer: Timer!
    var i: UInt = 0
    var animationPath = GMSMutablePath()
    var animationPolyline = GMSPolyline()
    
    var drawPath: Bool?
    
    private lazy var startLocationMarker = GMSMarker()
    private lazy var currentLocationMarker = GMSMarker()
    private lazy var destinationLocationMarker  = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SocketIOManager.shared.connect(nil)
        updateCurrentLocation(LocationManager.shared.locationData)
        initialSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        cleanPath()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        dismissVC()
    }
    
    @IBAction func btnCallAction(_ sender: UIButton) {
        guard let number = URL(string: "tel://" + /request?.to_user?.country_code + "-\(/request?.to_user?.phone)") else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
}
//MARK:- VCFuncs
extension TrackingVC {
    
    private func initialSetup() {
        imgView.setImageNuke(/request?.to_user?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
        lblUsername.text =  "\(/request?.to_user?.profile?.title) \(/request?.to_user?.name)"
        guard let status = request?.status else { return }
        btnCall.isHidden = /request?.to_user?.phone == ""

        lblETA.text = String.init(format: VCLiteral.ESTIMATE_TIME.localized, "Calculating...")
        
        switch status {
        
        case .reached:
            lblETA.text = ""
            lblStatus.text = "Status: \(VCLiteral.REACHED.localized)"
        default:
            break
        }
        
   
        
        SocketIOManager.shared.didReceiveLocation = { [weak self] (location) in
            
            if /location.request_id == /self?.request?.id {
                let currentLocation = LocationManager.shared.locationData
                let newLocation = CLLocationCoordinate2D.init(latitude: /Double(/location.lat), longitude: /Double(/location.long))
                let myLocation = CLLocationCoordinate2D.init(latitude: /currentLocation.latitude, longitude: /currentLocation.longitude)
                if /self?.distance(from: self?.previousOtherPersonLocation ?? CLLocationCoordinate2D(), to: newLocation) >= 100.0 {
                    self?.fetchRoute(from: myLocation, to: newLocation)
                    self?.previousOtherPersonLocation = newLocation
                }
                self?.updateLocation(location)
            }
        }
    }
    
    func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
    
    private func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        
        let session = URLSession.shared
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=\(Configuration.getValue(for: .PROJECT_GOOGLE_PLACES_KEY))")!
        
        let task = session.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else {
                print("error in JSONSerialization")
                return
            }
            
            guard let routes = jsonResult["routes"] as? [Any] else {
                return
            }
            
            guard let route = routes.first as? [String: Any] else {
                return
            }
            
            guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                return
            }
            
            if let duration = ((route["legs"] as? [Any])?.first as?  [String :Any])?["duration"] as? [String: Any] {
                DispatchQueue.main.async {
                    self?.lblETA.text = String.init(format: VCLiteral.ESTIMATE_TIME.localized, /(duration["text"] as? String))
                }
            }
            
            guard let polyLineString = overview_polyline["points"] as? String else {
                return
            }
            
            //Call this method to draw path on map
            self?.drawPath(from: polyLineString)
            DispatchQueue.main.async {
                self?.addMarkers(from: source, to: destination)
            }
        })
        task.resume()
    }

    private func addMarkers(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        startLocationMarker.icon = #imageLiteral(resourceName: "ic_start_point")
        startLocationMarker.icon?.withTintColor(ColorAsset.appTint.color, renderingMode: .alwaysTemplate)
        startLocationMarker.position = source
        startLocationMarker.map = mapView
        
        currentLocationMarker.icon = #imageLiteral(resourceName: "ic_start_point")
        currentLocationMarker.icon?.withTintColor(ColorAsset.appTint.color, renderingMode: .alwaysTemplate)
        currentLocationMarker.position = source
        currentLocationMarker.map = mapView
        currentLocationMarker.title = "Current Location"
        
        destinationLocationMarker.icon = #imageLiteral(resourceName: "ic_end_point")
        destinationLocationMarker.icon?.withTintColor(ColorAsset.appTint.color, renderingMode: .alwaysTemplate)
        destinationLocationMarker.position = destination
        destinationLocationMarker.map = mapView
        destinationLocationMarker.title = /request?.extra_detail?.service_address
        
    }
    
    private func drawPath(from polyString: String){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.2)
            
            guard let path = GMSMutablePath(fromEncodedPath: /polyString) else { return }
            let bounds = GMSCoordinateBounds(path: path)
            self.mapView?.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
            CATransaction.commit()
            
            
            // let path = GMSMutablePath(fromEncodedPath: polyStr) // Path
            self.polyPath = path
            self.polyline = GMSPolyline(path: path)
            self.polyline?.geodesic = true
            self.polyline?.strokeWidth = 3
            
            self.polyline?.strokeColor = ColorAsset.appTint.color
            self.polyline?.map = self.mapView
            
            self.cleanPath()
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.animatePolylinePath), userInfo: nil, repeats: true)
        }
    }
    
    private func cleanPath() {
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
    }
    
    @objc private func animatePolylinePath() {
        guard let path = polyPath else { return }
        
        if (self.i < path.count()) {
            self.animationPath.add(path.coordinate(at: self.i))
            self.animationPolyline.path = self.animationPath
            
            self.animationPolyline.strokeColor = .lightGray
            self.animationPolyline.strokeWidth = 3
            self.animationPolyline.map = self.mapView
            self.i += 1
        }
        else {
            self.i = 0
            self.animationPath = GMSMutablePath()
            self.animationPolyline.map = nil
        }
    }
    
    private func updateLocation(_ location: LocationModel) {
        
        guard location.lat != nil else {
            return
        }
        let camera = GMSCameraPosition.camera(withLatitude: /Double(/location.lat),
                                              longitude: /Double(/location.long),
                                              zoom: 15)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        currentLocationMarker.position = CLLocationCoordinate2D.init(latitude: /Double(/location.lat), longitude: /Double(/location.long))
        
    }
    
    private func updateCurrentLocation(_ location: LocationManagerData) {
        
        if location.latitude == 0 {
            return
        }
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude,
                                              longitude: location.longitude,
                                              zoom: 15)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        currentLocationMarker.position = CLLocationCoordinate2D.init(latitude: location.latitude, longitude: location.longitude)
        previousOtherPersonLocation = CLLocationCoordinate2D.init(latitude: /Double(/request?.extra_detail?.lat), longitude: /Double(/request?.extra_detail?.long))
        fetchRoute(from: CLLocationCoordinate2D.init(latitude: location.latitude, longitude: location.longitude), to: previousOtherPersonLocation ?? CLLocationCoordinate2D.init())
    }
}
