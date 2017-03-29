//
//  ThingIFAPI+Push.swift
//  ThingIFSDK
//
//  Created by Syah Riza on 8/13/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation


extension ThingIFAPI {

    // MARK: - Push notification methods

    /** Install push notification to receive notification from IoT Cloud.
     IoT Cloud will send notification when the Target replies to the Command.
     Application can receive the notification and check the result of Command
     fired by Application or registered Trigger.
     After installation is done Installation ID is managed in this class.

     - Parameter deviceToken: NSData instance of device token for APNS.
     - Parameter development: Bool flag indicate whether the cert is development or
     production. This is optional, the default is false (production).
     - Parameter completionHandler: A closure to be executed once on board has finished.
     */
    open func installPush(
        _ deviceToken:Data,
        development:Bool?=false,
        completionHandler: @escaping (String?, ThingIFError?)-> Void
        )
    {

        let requestURL = "\(baseURL)/api/apps/\(appID)/installations"

        var requestBody : [String:Any] = [:]
        requestBody["installationRegistrationID"] = deviceToken.hexString()
        requestBody["deviceType"] = "IOS"
        requestBody["development"] = NSNumber(value: development! as Bool)

        self.operationQueue.addHttpRequestOperation(
            .post,
            url: requestURL,
            requestHeader:
            self.defaultHeader + ["Content-Type" : MediaType.mediaTypeThingPushInstallationRequest.rawValue],
            requestBody: requestBody,
            failureBeforeExecutionHandler: { completionHandler(nil, $0) }) {
                response, error in

                if let installationID = response?["installationID"] as? String{
                    self.installationID = installationID
                }
                self.saveToUserDefault()
                DispatchQueue.main.async {
                    completionHandler(self.installationID, error)
                }
        }
    }

    func _uninstallPush(
        _ installationID:String?,
        completionHandler: @escaping (ThingIFError?)-> Void
        )
    {
        let idParam = installationID != nil ? installationID : self.installationID
        let requestURL = "\(baseURL)/api/apps/\(appID)/installations/\(idParam!)"
        
        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)"]
        
        let request = buildDefaultRequest(.DELETE,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: nil, completionHandler: { (response, error) -> Void in
            
            if error == nil{
                self.installationID = nil
            }
            self.saveToUserDefault()
            DispatchQueue.main.async {
                completionHandler( error)
            }
        })
        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)

    }
}
