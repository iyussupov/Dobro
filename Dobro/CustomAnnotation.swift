//
//  CustomAnnotation.swift
//  Dobro
//
//  Created by Dev1 on 1/6/16.
//  Copyright © 2016 FXofficeApp. All rights reserved.
//

import MapKit
import AddressBook

class CustomAnnotation: NSObject, MKAnnotation
{
    private var _identifier : String?
    private var _title: String?
    private var _subtitle: String?
    private var _coordinate: CLLocationCoordinate2D
    private var _color: MKPinAnnotationColor?
    
    var identifier : String? {
        return _identifier
    }
    
    var title: String? {
        return _title
    }
    
    var subtitle: String? {
        return _subtitle    }
    
    var coordinate: CLLocationCoordinate2D {
        return _coordinate
    }
    
    var color: MKPinAnnotationColor? {
        return _color
    }
    
    init(identifier: String, title: String, subtitle: String, coordinate: CLLocationCoordinate2D, color: MKPinAnnotationColor)
    {
        self._identifier = identifier
        self._title = title
        self._subtitle = subtitle
        self._coordinate = coordinate
        self._color = color
        
        super.init()
    }
    /*
    func mapItem() -> MKMapItem
    {
        let addressDictionary = [String(kABPersonAddressStreetKey): subtitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
*/
}
