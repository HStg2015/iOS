//
//  KAMapTableViewCell.swift
//  bitspls
//
//  Created by Leonard Mehlig on 07/11/15.
//  Copyright © 2015 bitspls. All rights reserved.
//

import UIKit
import MapKit

class KAMapTableViewCell: UITableViewCell, MKMapViewDelegate {

    @IBOutlet weak var mapImageView: UIImageView!
 
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
            
        }
    }

    var coordiante: CLLocationCoordinate2D? {
        didSet {
            guard let coo = coordiante else { return }
            let region = MKCoordinateRegionMakeWithDistance(coo, 10_000, 10_000)
            mapView.region = MKCoordinateRegion(center: coo, span: region.span)
            let circle = MKCircle(centerCoordinate: coo, radius: 2500)
            mapView.addOverlay(circle)
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.bitsplsOrangeDark()
        circleRenderer.fillColor = UIColor.bitsplsOrangeBright().colorWithAlphaComponent(0.4)
        return circleRenderer
    }
}
