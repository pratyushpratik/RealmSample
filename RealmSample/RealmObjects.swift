//
//  RealmObjects.swift
//  RealmSample
//
//  Created by Prince on 01/10/17.
//  Copyright © 2017 Prince. All rights reserved.
//

import Foundation
import RealmSwift

class Human: Object{
    
    dynamic var name = String()
    dynamic var age = Int()
    dynamic var race = String()
}
