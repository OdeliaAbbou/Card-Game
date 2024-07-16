import UIKit
import CoreLocation

class DataManager: UIViewController, CLLocationManagerDelegate {
    var utilisatorName: String?
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    
    @IBOutlet weak var Main_BTN_Start: UIButton!
    @IBOutlet weak var Main_TxtF_EnterN: UITextField!
    @IBOutlet weak var Main_LBL_HiName: UILabel!
    @IBOutlet weak var Main_BTN_Enetr: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedName = UserDefaults.standard.string(forKey: "utilisatorName") {
            utilisatorName = savedName
            Main_LBL_HiName.text = "Hi \(utilisatorName!)"
            Main_TxtF_EnterN.isHidden = true
            Main_BTN_Enetr.isHidden = true
            Main_BTN_Start.isHidden = false
        } else {
            Main_LBL_HiName.text = "WELCOME"
            Main_TxtF_EnterN.placeholder = "Enter a name"
            Main_BTN_Start.isHidden = true
        }
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        DispatchQueue.global(qos: .background).async {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func EnterClicked(_ sender: UIButton) {
        if let name = Main_TxtF_EnterN.text, !name.isEmpty {
            utilisatorName = name
            UserDefaults.standard.set(name, forKey: "utilisatorName") 
            Main_LBL_HiName.text = "Hi \(utilisatorName!)"
            Main_TxtF_EnterN.isHidden = true
            Main_BTN_Enetr.isHidden = true
            Main_BTN_Start.isHidden = false
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enter a name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func StartClicked(_ sender: UIButton) {
        checkLocationAuthorizationStatus()
    }
    
    func checkLocationAuthorizationStatus() {
        let authorizationStatus = locationManager.authorizationStatus
        
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            performSegue(withIdentifier: "Game", sender: self)
        } else {
            let alert = UIAlertController(title: "Location Access Needed", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Game" {
            if let destinationVC = segue.destination as? GameController {
                destinationVC.utilisatorName = utilisatorName
                destinationVC.userLocation = currentLocation
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            DispatchQueue.main.async {
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
