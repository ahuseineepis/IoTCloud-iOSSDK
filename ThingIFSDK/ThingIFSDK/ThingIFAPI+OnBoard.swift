//
//  ThingIFAPI+OnBoard.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/13/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation
extension ThingIFAPI {

    // MARK: - Onboard methods

    /** Onboard IoT Cloud with the specified thing ID.
     Specified thing will be owned by owner who consumes this API.
     (Specified on creation of ThingIFAPI instance.)
     When you're sure that the onboard process has been done,
     this method is convenient.
     If you are using a gateway, you need to use
    `ThingIFAPI.onboard(pendingEndnode:endnodePassword:options:completionHandler:)`
    to onboard endnode instead.

     **Note**: You should not call onboard second time, after successfully onboarded. Otherwise, ThingIFError.ALREADY_ONBOARDED will be returned in completionHandler callback.

    - Parameter thingID: Thing ID given by IoT Cloud. Must be specified.
    - Parameter thingPassword: Thing Password given by vendor.
    Must be specified.
    - Parameter options: Optional parameters inside.
    - Parameter completionHandler: A closure to be executed once onboard has finished. The closure takes 2 arguments: an target, an ThingIFError
     */
    open func onboardWith(
        thingID:String,
        thingPassword:String,
        options:OnboardWithThingIDOptions? = nil,
        completionHandler: @escaping (Target?, ThingIFError?)-> Void
        ) ->Void
    {
        if self.onboarded {
            completionHandler(nil, ThingIFError.alreadyOnboarded)
            return
        }

        var requestBody: [String : Any] = [
            "thingID" : thingID,
            "thingPassword" : thingPassword,
            "owner" : self.owner.typedID.toString() ]
        requestBody += options?.makeJsonObject() ?? [ : ]

        onboard(
          .mediaTypeOnboardingWithThingIdByOwnerRequest,
          requestBody: requestBody,
          layoutPosition: options?.layoutPosition,
          completionHandler: completionHandler)
    }

    /** Onboard IoT Cloud with the specified vendor thing ID.
     Specified thing will be owned by owner who consumes this API.
     (Specified on creation of ThingIFAPI instance.)

     If you are using a gateway, you need to use
     `ThingIFAPI.onboard(pendingEndnode:endnodePassword:options:completionHandler:)`
    to onboard endnode instead.

     **Note**: You should not call onboard second time, after successfully onboarded. Otherwise, ThingIFError.ALREADY_ONBOARDED will be returned in completionHandler callback.

    - Parameter vendorThingID: Thing ID given by vendor. Must be specified.
    - Parameter thingPassword: Thing Password given by vendor. Must be specified.
    - Parameter options: Optional parameters inside.
    - Parameter completionHandler: A closure to be executed once onboard has finished. The closure takes 2 arguments: an target, an ThingIFError
    */
    open func onboardWith(
        vendorThingID:String,
        thingPassword:String,
        options:OnboardWithVendorThingIDOptions? = nil,
        completionHandler: @escaping (Target?, ThingIFError?)-> Void
        ) ->Void
    {
        if self.onboarded {
            completionHandler(nil, ThingIFError.alreadyOnboarded)
            return
        }

        var requestBody: [String : Any] = [
            "vendorThingID" : vendorThingID,
            "thingPassword" : thingPassword,
            "owner" : self.owner.typedID.toString() ]
        requestBody += options?.makeJsonObject() ?? [ : ]

        onboard(
          .mediaTypeOnboardingWithVendorThingIdByOwnerRequest,
          requestBody: requestBody,
          layoutPosition: options?.layoutPosition,
          completionHandler: completionHandler)
    }

    /** Endpoints execute onboarding for the thing and merge MQTT
     channel to the gateway. Thing act as Gateway is already
     registered and marked as Gateway.

     - Parameter pendingEndnode: Pending End Node
     - Parameter endnodePassword: Password of the End Node
     - Parameter completionHandler: A closure to be executed once on
       board has finished. The closure takes 2 arguments: an end node,
       an ThingIFError
     */
    open func onboard(
        _ pendingEndnode:PendingEndNode,
        endnodePassword:String,
        completionHandler: @escaping (EndNode?, ThingIFError?)-> Void
        ) ->Void
    {
        guard let gateway = self.target as? Gateway else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return
        }

        if endnodePassword.isEmpty {
            completionHandler(nil, ThingIFError.unsupportedError)
            return
        }

        onboard(
          MediaType.mediaTypeOnboardingEndnodeWithGatewayThingIdRequest,
          requestBody:
            [
              "gatewayThingID": gateway.typedID.id,
              "endNodePassword": endnodePassword,
              "owner": self.owner.typedID.toString()
            ] + pendingEndnode.makeJsonObject(),
          layoutPosition: .endnode,
          vendorThingID: pendingEndnode.vendorThingID) { (target, error) in
            completionHandler(target as? EndNode, error)
        }
    }

    private func onboard(
      _ mediaType: MediaType,
      requestBody: [String : Any],
      layoutPosition: LayoutPosition?,
      vendorThingID: String? = nil,
      completionHandler: @escaping (Target?, ThingIFError?) -> Void) -> Void
    {
        self.operationQueue.addHttpRequestOperation(
          .post,
          url: "\(self.baseURL)/thing-if/apps/\(self.appID)/onboardings",
          requestHeader:
            self.defaultHeader + ["Content-Type" : mediaType.rawValue],
          requestBody: requestBody,
          failureBeforeExecutionHandler: { completionHandler(nil, $0) }) {
            response, error in

            var target: Target?
            var error2 = error
            if error == nil {
                do {
                    /* TODO:
                     Idealy, server should send vendorThingID as
                     response of onboarding, and SDK should use
                     the received vendorThingID. However, current
                     server implementation does not send
                     vendorThingID. So we used IDString if it is
                     vendorThingID, otherwise we set it empty
                     string. This behavior should be fixed after
                     server fixed.
                     */
                    self.target = try makeTargetThing(
                      response!,
                      layoutPosition: layoutPosition ?? .standalone,
                      vendorThingID: vendorThingID)
                    self.saveToUserDefault()
                    target = self.target
                } catch (ThingIFError.jsonParseError) {
                    // This is unexpected case.
                    // If response body is not unexpected format,
                    // this error is thrown
                    kiiSevereLog("unexpected error")
                    error2 = ThingIFError.jsonParseError
                } catch {
                    // This case must not happen.
                    kiiSevereLog("must not happen")
                    error2 = ThingIFError.jsonParseError
                }
            }
            DispatchQueue.main.async { completionHandler(target, error2) }
        }
    }

}
