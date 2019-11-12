//
//  ViewController.swift
//  Assignment5
//
//  Created by Markus Barrow on 12/11/2019.
//  Copyright © 2019 University of Southern Denmark. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet var stationaryLabel: UILabel!
    @IBOutlet weak var walkingLabel: UILabel!
    @IBOutlet weak var runningLabel: UILabel!
    @IBOutlet weak var automotiveLabel: UILabel!
    @IBOutlet weak var cyclingLabel: UILabel!
    @IBOutlet weak var unknownLabel: UILabel!
    @IBOutlet  var startDateLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    let motionActivityManager = CMMotionActivityManager()
    

    
    func writeToFile(text: String){
        do {
            // get the documents folder url
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                // create the destination url for the text file to be saved
                let fileURL = documentDirectory.appendingPathComponent("file.txt")
                // writing to disk
                // Note: if you set atomically to true it will overwrite the file if it exists without a warning
                if let fileUpdater = try? FileHandle(forUpdating: fileURL) {

                     // function which when called will cause all updates to start from end of the file
                     fileUpdater.seekToEndOfFile()

                    // which lets the caller move editing to any position within the file by supplying an offset
                   fileUpdater.write(text.data(using: .utf8)!)
                    print("demon")
                    

                    //Once we convert our new content to data and write it, we close the file and that’s it!
                   fileUpdater.closeFile()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("hi")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if CMMotionActivityManager.isActivityAvailable() { do {
            motionActivityManager.startActivityUpdates(to: OperationQueue.main) { (motion) in
                
                let date = dateFormatter.string(from: (motion?.startDate)!)
                
                self.startDateLabel.text = date
                
                if (motion!.stationary){
                                   Logger.log(date + ",Not moving")
                               }
                if (motion!.walking){
                                   Logger.log(date + ",Walking")
                               }
                if (motion!.cycling){
                                   Logger.log(date + ",Cycling")
                               }
                if (motion!.running){
                                   Logger.log(date + ",Running")
                               }
                if (motion!.automotive){
                                   Logger.log(date + ",Driving")
                               }
                if (motion!.unknown){
                    Logger.log(date + ",unknown")
                }
                
                
                self.stationaryLabel.text = (motion?.stationary)! ? "Stationary: True" : "Stationary: False"
                self.walkingLabel.text = (motion?.walking)! ? "Walking: True" : "Walking: False"
                self.runningLabel.text = (motion?.running)! ? "Running: True" : "Running: False"
                self.automotiveLabel.text = (motion?.automotive)! ? "Driving: True" : "Driving: False"
                self.cyclingLabel.text = (motion?.cycling)! ? "Cycling: True" : "Cycling: False"
                self.unknownLabel.text = (motion?.unknown)! ? "Unknown: True" : "Unknown: False"
                           
                           if motion?.confidence == CMMotionActivityConfidence.low {
                               self.confidenceLabel.text = "Low"
                           } else if motion?.confidence == CMMotionActivityConfidence.medium {
                               self.confidenceLabel.text = "Good"
                           } else if motion?.confidence == CMMotionActivityConfidence.high {
                               self.confidenceLabel.text = "High"
                           }
            }
            
        }
            print("hi2")
        
    }


}

}

class Logger {

    static var logFile: URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileName = "file.txt"
        return documentsDirectory.appendingPathComponent(fileName)
    }

    static func log(_ message: String) {
        guard let logFile = logFile else {
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let timestamp = formatter.string(from: Date())
        guard let data = (message + "\n").data(using: String.Encoding.utf8) else { return }

        if FileManager.default.fileExists(atPath: logFile.path) {
            if let fileHandle = try? FileHandle(forWritingTo: logFile) {
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
                print(logFile.path)
                print("done")
            }
        } else {
            try? data.write(to: logFile, options: .atomicWrite)
        }
    }
}
