//
//  WeatherViewController.swift
//  Smart Weather
//
//  Created by Игорь Силаев on 12/04/2020.
//  Copyright © 2020 Игорь Силаев. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit

class WeatherViewController: UIViewController , MKMapViewDelegate , WeatherDelegate  {
    
    var coordinate: CLLocationCoordinate2D! {
        didSet {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cityCountryLable: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    var weather : Client!
    var city: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        
        weather = Client(delegate: self)
        tempLabel.text = ""
        
        weather.getWeatherByCity(city: city!)
 
    }
    func didGetWeather(weather: WeatherAPI) {
        DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
            DispatchQueue.main.sync {
                self.tempLabel.text = "\(Int(weather.tempCelsius))°"
                guard let weatherIconID = weather.weatherIconID, let weatherDescription = weather.weatherDescription, let city = weather.city, let country = weather.country else { return }
                self.weatherImage.downloaded(from: "http://openweathermap.org/img/wn/\(weatherIconID)@2x.png")
                self.descriptionLabel.text = "\(weatherDescription)"
                self.cityCountryLable.text = "\(city), \(country)"
                
                self.coordinate = CLLocationCoordinate2D(latitude: weather.latitude!, longitude: weather.longitude!)
                
                if weather.weatherIconID?.last == "n"{
                    self.imageView.image = UIImage(named: "Night")
                    self.cityCountryLable.textColor = UIColor.white
                    self.descriptionLabel.textColor = UIColor.white
                    self.tempLabel.textColor = UIColor.white
                } else {
                    self.imageView.image = UIImage(named: "Light")
                }
            }
        }
    }
    
    func didNotGetWeather() {
        DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
            DispatchQueue.main.sync {
                let alert = UIAlertController(title: "Can't get the weather", message: "Unknown city", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            print("didNotGetWeather error")
        }
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

