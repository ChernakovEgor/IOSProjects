//
//  ViewController.swift
//  CapitalCities
//
//  Created by Egor Chernakov on 01.04.2021.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(changeMapType))
        title = "Capital Cities"
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }

        let identifier = "Capital"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView?.annotation = annotation
        }

        annotationView?.pinTintColor = UIColor.green
        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        let placeName = capital.title
//        let messege = capital.info

//        let ac = UIAlertController(title: placeName, message: messege, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
        showWiki(for: placeName)
    }
    
    @objc func changeMapType() {
        let ac = UIAlertController(title: "Change Map Type", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default) {[weak self] _ in
            self?.mapView.mapType = .hybrid
        })
        ac.addAction(UIAlertAction(title: "Hybrid Flyover", style: .default) {[weak self] _ in
            self?.mapView.mapType = .hybridFlyover
        })
        ac.addAction(UIAlertAction(title: "Muted Standard", style: .default) {[weak self] _ in
            self?.mapView.mapType = .mutedStandard
        })
        ac.addAction(UIAlertAction(title: "Satelite", style: .default) {[weak self] _ in
            self?.mapView.mapType = .satellite
        })
        ac.addAction(UIAlertAction(title: "Satelite Flyover", style: .default) {[weak self] _ in
            self?.mapView.mapType = .satelliteFlyover
        })
        ac.addAction(UIAlertAction(title: "Standard", style: .default) {[weak self] _ in
            self?.mapView.mapType = .standard
            
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func showWiki(for city: String?) {
        guard let name = city else { return }
        let vc = WikiViewController()
        vc.name = name
        navigationController?.pushViewController(vc, animated: true)
    }
}

