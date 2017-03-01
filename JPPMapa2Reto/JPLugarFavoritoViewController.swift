//
//  JPLugarFavoritoViewController.swift
//  JPPMapa2Reto
//
//  Created by cice on 20/2/17.
//  Copyright © 2017 empresa. All rights reserved.
//

import UIKit
import MapKit
class JPLugarFavoritoViewController: UIViewController {

    
    //MARK: - Valiables locales
    var locationManager = CLLocationManager()
    
    let taskManager = APITaskManager.shared
    
    //MARK:- IBOutlets
    @IBOutlet weak var lugarFavorito: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if customLugarSeleccionado == -1{
            //location manager
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }else{
            //let customLat = NSString(string: customLugares[customLugarSeleccionado]["lat"]!).doubleValue
            let customLat = NSString(string: taskManager.latitud[customLugarSeleccionado]["latitud"]!).doubleValue
            //let customLong = NSString(string: customLugares[customLugarSeleccionado]["long"]!).doubleValue
            let customLong = NSString(string: taskManager.longitud[customLugarSeleccionado]["longitud"]!).doubleValue
         
            let location = CLLocationCoordinate2D(latitude: customLat, longitude: customLong)
            
            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            lugarFavorito.setRegion(region, animated: true)
            
            let customAnotation = MKPointAnnotation()
            customAnotation.coordinate = location
            customAnotation.title = customLugares[customLugarSeleccionado]["name"]
            lugarFavorito.addAnnotation(customAnotation)
            
        }
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.creaChincheta(_:)))
        gesture.minimumPressDuration = 2
        lugarFavorito.addGestureRecognizer(gesture)
        
        // Do any additional setup after loading the view.
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

    
    //MARK:- Utils
    func creaChincheta(_ gesture : UIGestureRecognizer){
        
        if gesture.state == UIGestureRecognizerState.began{
        
            let puntoTocado = gesture.location(in: lugarFavorito)
            let nuevaCoordenada = lugarFavorito.convert(puntoTocado, toCoordinateFrom: lugarFavorito)
        
            let customLocation = CLLocation(latitude: nuevaCoordenada.latitude, longitude: nuevaCoordenada.longitude)
        
            CLGeocoder().reverseGeocodeLocation(customLocation) { (placemarks, error) in
            
                var calle = ""
                var numero = ""
                var customTitulo = ""
                
                if let customPlacemarks = placemarks?[0]{
                
                    if customPlacemarks.thoroughfare != nil{
                    calle = customPlacemarks.thoroughfare!
                    }
                
                    if customPlacemarks.subThoroughfare != nil{
                    numero = customPlacemarks.subThoroughfare!
                    }
                    customTitulo = "\(calle) \(numero)"
                }
            
                if customTitulo == ""{
                customTitulo = "Punto añadido el \(Date())"
                }
            
            
                //Creamos la anotacion
                let annotation = MKPointAnnotation()
                annotation.coordinate = nuevaCoordenada
                annotation.title = customTitulo
                self.lugarFavorito.addAnnotation(annotation)
                
                
                //Guardamos en nuestro array de diccionarios
                customLugares.append(["name": customTitulo, "lat": "\(nuevaCoordenada.latitude)", "long": "\(nuevaCoordenada.longitude)"])
                
                //guardamos los datos en el sharedpreferences
                APITaskManager.shared.latitud.append(["latitud" : String(nuevaCoordenada.latitude)])
                APITaskManager.shared.longitud.append(["longitud" : String(nuevaCoordenada.longitude)])
                APITaskManager.shared.salvarDatos()
                
                
            }
        }
        
    }
    
    
}


extension JPLugarFavoritoViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitud = userLocation.coordinate.longitude
        
        let locationData = CLLocationCoordinate2D(latitude: latitude, longitude: longitud)
        
        let region = MKCoordinateRegion(center: locationData, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        lugarFavorito.setRegion(region, animated: true)
        
    }
    
    
}
