//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Annette Undheim on 12/05/15.
//  Copyright (c) 2015 Annette Undheim. All rights reserved.
//

import Foundation

/*
    RecordedAudio class
    Model class for recorded audio
*/
class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title:String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}