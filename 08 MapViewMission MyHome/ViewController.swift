//
//  ViewController.swift
//  08 MapViewMission MyHome
//
//  Created by Gukhwa Jeon on 04.05.20.
//  Copyright © 2020 G-Kay. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var myMap: MKMapView!
    @IBOutlet var lblLocationInfo1: UILabel!
    @IBOutlet var lblLocationInfo2: UILabel!
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblLocationInfo1.text = ""
        lblLocationInfo2.text = ""
        
        // CLLocationManagerDelegate 가 필요
        // 사용자 현재 나라 지도 보여줌
        locationManager.delegate = self // CLLocationManagerDelegate?
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // CLLocationAccuracy
        locationManager.requestWhenInUseAuthorization() // 위치 데이터를 추적하기 위해 사용자에게 승인을 요구
        locationManager.startUpdatingLocation() // 사용자 현재위치 업데이트를 시작
        myMap.showsUserLocation = true // 위치보기 값을 true로 설정, 스위스 지도
    }
    
    @IBAction func sgChangeLocation(_ sender: UISegmentedControl) {
          
          if sender.selectedSegmentIndex == 0 {
              locationManager.startUpdatingLocation()
          } else if sender.selectedSegmentIndex == 1 {
              setAnnotation(latitudeValue: 46.718837, longitudeValue: 7.707390, delta: 0.1, title: "SigrisWil", subTitle: "Raftstrasse 31-33, 3655 Sigriswil")
              self.lblLocationInfo1.text = "You are looking at: "
              self.lblLocationInfo2.text = "SigrisWil"
          } else if sender.selectedSegmentIndex == 2 {
              setAnnotation(latitudeValue: 46.711987, longitudeValue: 7.962519, delta: 0.1, title: "Iselwalt", subTitle: "Lake Brienz, Switzerland")
              self.lblLocationInfo1.text = "You are looking at: "
              self.lblLocationInfo2.text = "Iselwalt"
          } else if sender.selectedSegmentIndex == 3 {
              setAnnotation(latitudeValue: 47.513912, longitudeValue: 8.527852, delta: 0.1, title: "My Home", subTitle: "Kasernenstrasse, Bülach, Switzerland")
              self.lblLocationInfo1.text = "You are looking at: "
              self.lblLocationInfo2.text = "My Home"
          }
      }
    
    // CLLocationManagerDelegate 프로토콜의 함수
    // 위치가 업데이트 되었을 때 지도에 위치를 나타내기 위한 함수
    // 마지막 현재 위치 정보에서 국가, 지역, 도로를 추출하여 레이블에 표시
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation: CLLocation? = locations.last
        let pLocation: CLLocationCoordinate2D? = lastLocation?.coordinate
        setRegionfromLocationCoordinate(pLocation: pLocation!, delta: 0.05) // delta = 1 이 확대 없음. 0.01은 백배확대
        
        // 위도 경도로 위치정보 겟
        CLGeocoder().reverseGeocodeLocation(lastLocation!, completionHandler: {
            (placemarks, error) -> Void in
            
            let pm = placemarks!.first
            var address: String = ""

            if pm!.thoroughfare != nil {
                address += pm!.thoroughfare!
            }
            if pm!.postalCode != nil {
                address += "\n" + pm!.postalCode!
            }
            if pm!.locality != nil {
                address += " " + pm!.locality!
            }
            if pm!.country != nil {
                address += "\n" + pm!.country!
            }

            self.lblLocationInfo1.text = "My Location Now"
            self.lblLocationInfo2.text = address
        })
        
        locationManager.stopUpdatingLocation() // 꼭 있어야 함. 아니면 다음에 업데이트 시작을 안함
    }
      
    // 빨간 핀
    func setAnnotation(latitudeValue: CLLocationDegrees,
                       longitudeValue: CLLocationDegrees,
                       delta span: Double,
                       title strTitle: String,
                       subTitle strSubtitle: String) {
        
        let annotation: MKPointAnnotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        annotation.title = strTitle
        annotation.subtitle = strSubtitle
        myMap.addAnnotation(annotation)
        // 맵 뷰에 핀으로 지도 이동
        setRegionfromLocationCoordinate(pLocation: annotation.coordinate, delta: span)
    }
    
    // 위치 좌표(CLLocationCoordinate2D)와 span값으로 원하는 위치 보여주기
    func setRegionfromLocationCoordinate(pLocation: CLLocationCoordinate2D,
                                         delta span: Double) {
        let spanValue: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion: MKCoordinateRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        myMap.setRegion(pRegion, animated: true)
    }
}

