//
//  Site.swift
//  IoTCloudSDK
//
//  Created by Yongping on 9/17/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

/**
* This enum represents KiiCloud server location.
*/
public enum Site {
    /** Use cloud in US. */
    case US
    /** Use cloud in Japan. */
    case JP
    /** Use cloud in China. */
    case CN
    /** Use cloud in Singapore. */
    case SG
    /** Use cloud with custome baseURL. */
    case BaseURL(String)

    /** Get base url of Site
    - Returns: Base URL string of Site.
    */
    public func getBaseUrl() -> String{
        switch self {
        case .US:
            return "https://api.kii.com"
        case .JP:
            return "https://api-jp.kii.com"
        case .CN:
            return "https://api-cn3.kii.com"
        case .SG:
            return "https://api-sg.kii.com"
        case .BaseURL(let baseURL):
            return baseURL
        }
    }

}