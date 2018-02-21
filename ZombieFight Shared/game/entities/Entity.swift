//
//  Entity.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/20/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import Foundation

protocol Entity {
    func getName() -> String
    func update(time:GameTime)
    func physicsUpdate(time:GameTime)
}
