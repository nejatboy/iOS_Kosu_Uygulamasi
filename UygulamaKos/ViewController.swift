

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var labelHiz: UILabel!
    @IBOutlet weak var labelSure: UILabel!
    @IBOutlet weak var labelMesafe: UILabel!
    @IBOutlet weak var buttonKosmayaBasla: UIButton!
    
    let locationManager = CLLocationManager()
    var kosuyor = false
    var ilkKonum:CLLocation?
    var sonKonum:CLLocation?
    var kosulanMesafe = 0.0
    var maxHiz = 0.0
    var gecenSure = 0
    var timer = Timer()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .fitness
        
        konumIzniKontrolu()
        
        //Deneme
        
        //Deneme 2
        
        //Deneme 3
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    
    func konumIzniKontrolu() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //locationManager.startUpdatingLocation()
            
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    
    
    @objc func zaman () {
        labelSure.text = "Süre: \(gecenSure)"
        gecenSure += 1
    }
    
    
    
    
    func zamanlayiciBaslat () {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(zaman), userInfo: nil, repeats: true)
    }

    
    
    
    @IBAction func buttonKosmayaBasla(_ sender: Any) {
        if kosuyor {
            locationManager.stopUpdatingLocation()
            kosuyor = false
            buttonKosmayaBasla.setTitle("Koşmaya Başla", for: UIControl.State.normal)
            
        } else {
            zamanlayiciBaslat()
            locationManager.startUpdatingLocation()
            kosuyor = true
            buttonKosmayaBasla.setTitle("Koşmayı Bitir", for: UIControl.State.normal)
            //pinEkle(title: "İlk konumum", subtitle: "Buradan başladım", location: ilkKonum!)
        }
        
    }
    
    
    
    
    func pinEkle(title:String, subtitle:String, location:CLLocation) {
        let pin = MKPointAnnotation()
        pin.title = title
        pin.subtitle = subtitle
        pin.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        mapView.addAnnotation(pin)
    }
    
    
    
}








extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if ilkKonum == nil {
            ilkKonum = locations.last
            
        } else if let konum = locations.last {
            sonKonum = konum
            
            kosulanMesafe += (konum.distance(from: ilkKonum!)) / 100000
            let stringMesafe = String(format: "%.3f", kosulanMesafe)
            labelMesafe.text = "Mesafe: \(stringMesafe) km"
            
            let hiz = konum.speed
            labelHiz.text = "Hız: \(konum.speed)"
            if Double(hiz) > maxHiz {
                maxHiz = Double(hiz)
            }
            
            konumuHaritadaGoster(konum: konum)
        }
        
        
       
        
    }
    
    
    
    
    func konumuHaritadaGoster(konum:CLLocation) {
        let merkez = CLLocationCoordinate2D(latitude: konum.coordinate.latitude, longitude: konum.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: merkez, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
}

