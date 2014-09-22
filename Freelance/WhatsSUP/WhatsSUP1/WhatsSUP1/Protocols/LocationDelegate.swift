//
//  LocationDelegate.swift
//  WhatsSUP1
//
//  Created by Tim Teece on 08/08/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationDelegate{
    // standard callbacls for the navigation delegate methods
    func didUpdateHeading(newHeading:CLHeading);
    func didUpdateLocations(newLocation:CLLocation);
}