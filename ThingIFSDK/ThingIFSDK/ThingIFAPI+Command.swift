//
//  ThingIFAPI+Command.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/13/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

extension ThingIFAPI {

    // MARK: - Command methods

    /** Post new command to IoT Cloud.

     Command will be delivered to specified target and result will be
     notified through push notification.

     **Note**: Please onboard first, or provide a target instance by
     calling copyWithTarget. Otherwise,
     KiiCloudError.TARGET_NOT_AVAILABLE will be return in
     completionHandler callback

    - Parameter commandForm: Command form of posting command.
    - Parameter completionHandler: A closure to be executed once
      finished. The closure takes 2 arguments: an instance of created
      command, an instance of ThingIFError when failed.
    */
    open func postNewCommand(
        _ commandForm: CommandForm,
        completionHandler:
          @escaping (Command?, ThingIFError?) -> Void) -> Void
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return
        }

        self.operationQueue.addHttpRequestOperation(
          .post,
          url: "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/commands",
          requestHeader:
            self.defaultHeader +
            ["Content-Type" : MediaType.mediaTypePostNewCommandTrait.rawValue],
          requestBody:
            commandForm.makeJsonObject() +
            ["issuer" : self.owner.typedID.toString()],
          failureBeforeExecutionHandler: { completionHandler(nil, $0) }) {
            response, error in
            if error != nil {
                DispatchQueue.main.async { completionHandler(nil, error) }
            } else {
                self.getCommand(response!["commandID"] as! String) {
                    completionHandler($0, $1)
                }
            }
        }

    }

    /** Get specified command

     **Note**: Please onboard first, or provide a target instance by
     calling copyWithTarget. Otherwise,
     KiiCloudError.TARGET_NOT_AVAILABLE will be return in
     completionHandler callback

     - Parameter commandID: ID of the Command to obtain.
     - Parameter completionHandler: A closure to be executed once
       finished. The closure takes 2 arguments: an instance of created
       command, an instance of ThingIFError when failed.
     */
    open func getCommand(
        _ commandID:String,
        completionHandler: @escaping (Command?, ThingIFError?)-> Void) -> Void
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return
        }

        self.operationQueue.addHttpRequestOperation(
          .get,
          url: "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/commands/\(commandID)",
          requestHeader: self.defaultHeader,
          failureBeforeExecutionHandler: { completionHandler(nil, $0) }) {
            response, error in
            let result: (Command?, ThingIFError?) =
              converSpecifiedItem(response, error)
            DispatchQueue.main.async { completionHandler(result.0, result.1) }
        }
    }
    
    func _listCommands(
        _ bestEffortLimit:Int?,
        paginationKey:String?,
        completionHandler: @escaping ([Command]?, String?, ThingIFError?)-> Void
        )
    {
        fatalError("TODO: implement me")
        /*
        guard let target = self.target else {
            completionHandler(nil, nil, ThingIFError.targetNotAvailable)
            return
        }

        var requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/commands"
        if paginationKey != nil && bestEffortLimit != nil{
            requestURL += "?paginationKey=\(paginationKey!)&bestEffortLimit=\(bestEffortLimit!)"
        }else if bestEffortLimit != nil {
            requestURL += "?bestEffortLimit=\(bestEffortLimit!)"
        }else if paginationKey != nil {
            requestURL += "?paginationKey=\(paginationKey!)"
        }
        
        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]
        
        let request = buildDefaultRequest(HTTPMethod.GET,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: nil, completionHandler: { (response, error) -> Void in
            var commands = [Command]()
            var nextPaginationKey: String?
            if response != nil {
                if let commandNSDicts = response!["commands"] as? [NSDictionary] {
                    for commandNSDict in commandNSDicts {
                        if let command = Command.commandWithNSDictionary(commandNSDict) {
                            commands.append(command)
                        }
                    }
                }
                nextPaginationKey = response!["nextPaginationKey"] as? String
            }
            DispatchQueue.main.async {
                completionHandler(commands, nextPaginationKey, error)
            }
        })
        
        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
        */
    }
}
