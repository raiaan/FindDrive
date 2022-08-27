//
//  SelectionEntity.swift
//  FindDriver
//
//  Created by Rain Moustfa on 27/08/2022.
//

import Foundation
struct SelectionService{
    let icon:String
    let data:[String]
    let rightText:String
}
func getDemoEntities()->[SelectionService]{
    return [
        SelectionService(icon: "car", data: ["italians","Burgers","Pizza","bealthy"], rightText: "5.00EGP"),
        SelectionService(icon: "dollarsign.square", data: ["cash","online"], rightText: "Coupons")
    ]
}
