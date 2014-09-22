//
//  MKSupPointAnnotation.swift
//  WhatsSUP1
//
//  Created by Tim Teece on 15/08/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

import Foundation

import UIKit
import CoreLocation
import MapKit


class MKSupPointAnnotation: MKPointAnnotation{
    var id:CKRecordID?=nil
    var isGroup=false
}
