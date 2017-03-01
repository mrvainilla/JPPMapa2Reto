//
//  ViewController.swift
//  JPPMapa2Reto
//
//  Created by cice on 20/2/17.
//  Copyright © 2017 empresa. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController {
    
    
    //MARK: - Variables locales
    var locationManager = CLLocationManager() //Objeto para operaciones de ubicacion
    
    //IBOutlets
    @IBOutlet weak var mapaMV: MKMapView!
    @IBOutlet weak var localizacionLb: UILabel!
    @IBOutlet weak var tipoMapaSc: UISegmentedControl!
    
    
    //IBAction
    @IBAction func muestraLocalizacion(_ sender: Any) {
        
        let coordenada = CLLocationCoordinate2D(latitude: 40.441929, longitude: -3.673151)
        
        //Donde lo queremos situar
        let region = MKCoordinateRegion(center: coordenada,
                                        span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        
        //Asignamos la region al mapa
        mapaMV.setRegion(region, animated: true)
        
        //pintamos la coordenada en el mapa
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordenada
        annotation.title = "punto definido en el mapa"
        annotation.subtitle = "Hogar"
        mapaMV.addAnnotation(annotation)

        
        
    }
    
    @IBAction func tipoMapa(_ sender: Any) {
        
        let tipoMapa = tipoMapaSc.selectedSegmentIndex
        
        switch tipoMapa {
            case 0:
                mapaMV.mapType = .standard
            case 1:
                mapaMV.mapType = .hybrid
            case 2:
                mapaMV.mapType = .satellite
            default:
                mapaMV.mapType = .standard
                break
        }

        
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Se pone el gestor de acciones sobre el mapa
        //gesto de reconocimiento de presionado de dos segundos para pintar una chincheta
        let pulsadoLargo = UILongPressGestureRecognizer(target: self, action: #selector(self.actionGestureRecognizer(_:)))
        pulsadoLargo.minimumPressDuration = 2
        mapaMV.addGestureRecognizer(pulsadoLargo)
        
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
    
    func actionGestureRecognizer(_ gesture : UIGestureRecognizer){
        
        if gesture.state == UIGestureRecognizerState.began{//Con esto se evita que se creen muchas chinchetas al pinchar y arrastrar
            
            let puntoToquePantalla = gesture.location(in: mapaMV)
            let nuevaCoordenada = mapaMV.convert(puntoToquePantalla, toCoordinateFrom: mapaMV)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = nuevaCoordenada
            annotation.title = "nuevo punto en el mapa"
            annotation.subtitle = "seguimos"
            mapaMV.addAnnotation(annotation)
        }
        
    }
}


extension ViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations.first! //La localizacion es una pila donde la primera es la mas actualizada
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        
        mapaMV.setRegion(region, animated: true)
        
        localizacionLb.text = "\(userLocation)"
        
        let anotacion = MKPointAnnotation()
        anotacion.title = "titulo por defecto"
        anotacion.coordinate = userLocation.coordinate
        anotacion.subtitle = "Localizacion"
        mapaMV.addAnnotation(anotacion)
        
        
    }
    
    
}

