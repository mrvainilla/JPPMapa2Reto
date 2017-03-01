//
//  JPPMiGPSViewController.swift
//  JPPMapa2Reto
//
//  Created by cice on 20/2/17.
//  Copyright © 2017 empresa. All rights reserved.
//

import UIKit
import MapKit

class JPPMiGPSViewController: UIViewController {

    
    //MARK: - Variables locales
    var locationManager = CLLocationManager() //Objeto para operaciones de ubicacion
    
    //IBOutlets
    @IBOutlet weak var latitudLb: UILabel!
    @IBOutlet weak var longitudLb: UILabel!
    @IBOutlet weak var rumboLb: UILabel!
    @IBOutlet weak var velocidadLb: UILabel!
    @IBOutlet weak var altitudLb: UILabel!
    @IBOutlet weak var datosLb: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Objeto GPS le ponemos las propiedades
        //Fase de precision del GPS -> CoreLocation
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //Precision
        locationManager.delegate = self //Es delegado
        locationManager.requestWhenInUseAuthorization() //Solamente cuando se tenga autorizacion y no este en segundo plano la aplicacion
        locationManager.startUpdatingLocation() //Empieza a localizar y a ejecutar la funcion del delegado
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension JPPMiGPSViewController : CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.first{
            //Actualizamos nuestra localizacion
            latitudLb.text = "\(userLocation.coordinate.latitude)"
            longitudLb.text = "\(userLocation.coordinate.longitude)"
            rumboLb.text = "\(userLocation.course)"
            velocidadLb.text = "\(userLocation.speed)"
            altitudLb.text = "\(userLocation.altitude)"
            
            //grupo de geolocalizacion inversa
            CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) in
                if error == nil{
                    if let placemarkData = placemarks?[0]{
                        var direccion = ""
                        direccion += self.addInfoIfExits(placemarkData.thoroughfare)
                        direccion += self.addInfoIfExits(placemarkData.subThoroughfare)
                        direccion += self.addInfoIfExits(placemarkData.subLocality)
                        direccion += self.addInfoIfExits(placemarkData.subAdministrativeArea)
                        direccion += self.addInfoIfExits(placemarkData.postalCode)
                        direccion += self.addInfoIfExits(placemarkData.country)
                        direccion += self.addInfoIfExits(placemarkData.locality)
                        
                        self.datosLb.text = direccion
                        
                        //let direccion = "\(placemarkData.country!) \n \(placemarkData.thoroughfare!)"
                        //self.myDatosLocLb.text = direccion
                    }
                }else{
                    //print(error?.localizedDescription as Any)
                }
            })
            
        }
    }
    
    
    //Creamos una funcion para trabajar la gestion de datos
    func addInfoIfExits(_ info : String?) -> String {
        //
        if info != nil{
            return "\(info!) \n"
        }else{
            return ""
        }
    }
    
    
}
