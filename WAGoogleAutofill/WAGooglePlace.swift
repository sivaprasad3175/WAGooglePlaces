//
//  WAGooglePlace.swift
//  WAGoogleAutofill
//
//  Created by Siva on 02/08/19.
//  Copyright © 2019 Siva. All rights reserved.
//


import UIKit
import GoogleMaps
import GooglePlaces

public final class WAGooglePlaces: NSObject {
    
    static let sharedInstance = WAGooglePlaces()
    var googlePlacesClient : GMSPlacesClient?
    private override init() {
        googlePlacesClient = GMSPlacesClient()
    }
    
    func googlePlacesAutocomplete(address: String, token: GMSAutocompleteSessionToken, onAutocompleteCompletionHandler: @escaping (_ keys: [MyAddress]) -> Void) {
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        filter.country = "IN"
        var bounds: GMSCoordinateBounds? = nil
        let location1Bounds = CLLocationCoordinate2DMake(Double(17.3850), Double(78.4867))
        let location2Bounds = CLLocationCoordinate2DMake(Double(17.3850), Double(80.4867))
        bounds = GMSCoordinateBounds(coordinate: location1Bounds, coordinate: location2Bounds)
        googlePlacesClient?.findAutocompletePredictions(fromQuery: address, bounds: bounds, boundsMode: .bias, filter: filter, sessionToken: token, callback: { (autocompletePredictions, error) in
            var filteredPredictions:[MyAddress] = []
            if let autocompletePredictions = autocompletePredictions {
                for prediction in autocompletePredictions {
                    let newAddress = MyAddress(name:prediction.attributedPrimaryText.string,addrLine1:
                        prediction.attributedSecondaryText?.string ?? "", addrLin2: "", lat: "", long: "", placeId: prediction.placeID)
                    filteredPredictions.append(newAddress)
                }
            }
            onAutocompleteCompletionHandler(filteredPredictions)
        })
    }
    
    
    func getPlaceData(_ place_id : String, completion: @escaping (MyAddress?, Error?)->()){
        let placesClient = GMSPlacesClient.shared()
        // Specify the place data types to return.
        placesClient.lookUpPlaceID(place_id as String) { (place, error) in
            if error != nil {
                completion(nil, error)
                return
            }
            if let place = place {
                let newAddress = MyAddress(name: place.name ?? "", addrLine1: "", addrLin2: place.formattedAddress ?? "", lat: String(place.coordinate.latitude), long: String(place.coordinate.longitude), placeId: place.placeID ?? "");                completion(newAddress,nil)
            }
            else {
                NSLog("No place details for: \(place_id) ")
            }
        }
        
    }
}


struct MyAddress {
    var addressName: String
    var addressLine1 : String
    var addressLine2 :String
    var latitude :String;
    var longitude :String;
    var placeId :String
    init(name:String , addrLine1 :String, addrLin2:String,lat:String,long:String,placeId :String) {
        self.addressName = name;
        self.addressLine1 = addrLin2;
        self.addressLine2 = addrLin2;
        self.latitude = lat;
        self.longitude = long;
        self.placeId = placeId;
    }
}

