//
//  ThingIFSDKTests.swift
//  ThingIFSDKTests
//
//  Created by 熊野 聡 on 2015/07/27.
//  Copyright (c) 2015年 Kii. All rights reserved.
//

import UIKit
import XCTest
@testable import ThingIFSDK

class ThingIFSDKTests: SmallTestBase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSavedInstanceWithInit(){
        let setting = TestSetting()
        let app = setting.app
        let owner = setting.owner

        // ThingIFAPI is not saved when ThingIFAPI is instantiation.
        let api = ThingIFAPIBuilder(app:app, owner:owner).build()
        do {
            try ThingIFAPI.loadWithStoredInstance()
            XCTFail("Should raise exception")
        } catch {
        }
        api.saveInstance()
        
        do {
            let temp = try ThingIFAPI.loadWithStoredInstance()
            XCTAssertEqual(api, temp , "should be equal")
        } catch {
            XCTFail("Should not raise exception ")
        }

    }
    func testRemoveAllStoredInstances() {
        let tags = ["tag1","tag2"]
        let setting = TestSetting()
        let app = setting.app
        let owner = setting.owner
        
        let api1 = ThingIFAPIBuilder(app:app, owner:owner).build()
        let api2 = ThingIFAPIBuilder(app:app, owner:owner, tag:tags[0]).build()
        let api3 = ThingIFAPIBuilder(app:app, owner:owner, tag:tags[1]).build()
        
        var expectation = self.expectation(description: "testSavedInstanceWithOnboard")
        setMockResponse4Onboard("access-token-00000001", thingID: "th.00000001", setting: setting)
        api1.onboard("vendor-0001", thingPassword: "password1", thingType: "smart-light", thingProperties: nil) { ( target, error) -> Void in
            if error != nil{
                XCTFail("should success")
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
        
        expectation = self.expectation(description: "testSavedInstanceWithOnboard")
        setMockResponse4Onboard("access-token-00000002", thingID: "th.00000002", setting: setting)
        api2.onboard("vendor-0002", thingPassword: "password2", thingType: "smart-light", thingProperties: nil) { ( target, error) -> Void in
            if error != nil{
                XCTFail("should success")
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
        
        expectation = self.expectation(description: "testSavedInstanceWithOnboard")
        setMockResponse4Onboard("access-token-00000003", thingID: "th.00000003", setting: setting)
        api3.onboard("vendor-0002", thingPassword: "password2", thingType: "smart-light", thingProperties: nil) { ( target, error) -> Void in
            if error != nil{
                XCTFail("should success")
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
        
        ThingIFAPI.removeAllStoredInstances()
        
        do {
            try ThingIFAPI.loadWithStoredInstance()
            XCTFail("Should raise exception")
        } catch {
        }
        do {
            try ThingIFAPI.loadWithStoredInstance(tags[0])
            XCTFail("Should raise exception")
        } catch {
        }
        do {
            try ThingIFAPI.loadWithStoredInstance(tags[1])
            XCTFail("Should raise exception")
        } catch {
        }
    }
    func testSavedInstanceWithOnboard(){
        let tags = ["tag1","tag2"]
        let setting = TestSetting()
        let app = setting.app
        let owner = setting.owner
        
        let api1 = ThingIFAPIBuilder(app:app, owner:owner).build()
        let api2 = ThingIFAPIBuilder(app:app, owner:owner, tag:tags[0]).build()
        let api3 = ThingIFAPIBuilder(app:app, owner:owner, tag:tags[1]).build()
        
        var expectation = self.expectation(description: "testSavedInstanceWithOnboard")
        setMockResponse4Onboard("access-token-00000001", thingID: "th.00000001", setting: setting)
        api1.onboard("vendor-0001", thingPassword: "password1", thingType: "smart-light", thingProperties: nil) { ( target, error) -> Void in
            if error != nil{
                XCTFail("should success")
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

        expectation = self.expectation(description: "testSavedInstanceWithOnboard")
        setMockResponse4Onboard("access-token-00000002", thingID: "th.00000002", setting: setting)
        api2.onboard("vendor-0002", thingPassword: "password2", thingType: "smart-light", thingProperties: nil) { ( target, error) -> Void in
            if error != nil{
                XCTFail("should success")
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

        expectation = self.expectation(description: "testSavedInstanceWithOnboard")
        setMockResponse4Onboard("access-token-00000003", thingID: "th.00000003", setting: setting)
        api3.onboard("vendor-0002", thingPassword: "password2", thingType: "smart-light", thingProperties: nil) { ( target, error) -> Void in
            if error != nil{
                XCTFail("should success")
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
        
        do {
            var temp = try ThingIFAPI.loadWithStoredInstance()
            XCTAssertEqual(api1, temp , "should be equal")
            temp = try ThingIFAPI.loadWithStoredInstance(tags[0])
            XCTAssertEqual(api2, temp , "should be equal")
            temp = try ThingIFAPI.loadWithStoredInstance(tags[1])
            XCTAssertEqual(api3, temp , "should be equal")
        } catch {
            XCTFail("Should not raise exception ")
        }
        
        do {
            ThingIFAPI.removeStoredInstances(nil)
            try ThingIFAPI.loadWithStoredInstance()
            XCTFail("Should raise exception")
        } catch {
        }
        do {
            ThingIFAPI.removeStoredInstances(tags[0])
            try ThingIFAPI.loadWithStoredInstance(tags[0])
            XCTFail("Should raise exception")
        } catch {
        }
        do {
            ThingIFAPI.removeAllStoredInstances()
            try ThingIFAPI.loadWithStoredInstance(tags[1])
            XCTFail("Should raise exception")
        } catch {
        }
    }
    func testOverwriteSavedInstanceWithOnboard(){
        let tag = "tag1"
        let setting = TestSetting()
        let app1 = App(appID: "app001", appKey: "appkey001", site: Site.jp)
        let app2 = App(appID: "app002", appKey: "appkey002", site: Site.us)
        let owner1 = Owner(typedID: TypedID(type: "user", id: "user001"), accessToken: "token001")
        let owner2 = Owner(typedID: TypedID(type: "user", id: "user002"), accessToken: "token002")
        
        let api1 = ThingIFAPIBuilder(app:app1, owner:owner1, tag: tag).build()
        
        var expectation = self.expectation(description: "testOverwriteSavedInstanceWithOnboard")
        setMockResponse4Onboard("access-token-00000001", thingID: "th.00000001", setting: setting)
        api1.onboard("vendor-0001", thingPassword: "password1", thingType: "smart-light", thingProperties: nil) { ( target, error) -> Void in
            if error != nil{
                XCTFail("should success")
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
        
        let api2 = ThingIFAPIBuilder(app:app2, owner:owner2, tag: tag).build()

        expectation = self.expectation(description: "testOverwriteSavedInstanceWithOnboard")
        setMockResponse4Onboard("access-token-00000002", thingID: "th.00000002", setting: setting)
        api2.onboard("vendor-0002", thingPassword: "password2", thingType: "smart-light", thingProperties: nil) { ( target, error) -> Void in
            if error != nil{
                XCTFail("should success")
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
  
        do {
            let temp = try ThingIFAPI.loadWithStoredInstance(tag)
            XCTAssertEqual(api2, temp , "should be equal")
        } catch {
            XCTFail("Should not raise exception ")
        }
    }
    
    
    func testOverwriteSavedInstanceWithOnboard222(){
        let setting = TestSetting()
        
        let api1 = ThingIFAPIBuilder(app:setting.app, owner:setting.owner, tag: "tag1").build()
        
        let expectation = self.expectation(description: "testOverwriteSavedInstanceWithOnboard")
        setMockResponse4Onboard("access-token-00000001", thingID: "th.00000001", setting: setting)
        api1.onboard("vendor-0001", thingPassword: "password1", thingType: "smart-light", thingProperties: nil) { ( target, error) -> Void in
            if error != nil{
                XCTFail("should success")
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
        
        do {
            try ThingIFAPI.loadWithStoredInstance("tag2")
            XCTFail("Should raise exception")
        } catch(let e as ThingIFError){
            switch e {
            case .api_NOT_STORED:
                break
            default:
                XCTFail("Exception should be API_NOT_STORED")
                break
            }
        } catch {
            XCTFail("Exception should be API_NOT_STORED")
        }
    }

    
    fileprivate func setMockResponse4Onboard(_ accessToken: String, thingID: String, setting:TestSetting) -> Void {
        let dict = ["accessToken":accessToken,"thingID":thingID]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string: setting.app.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            iotSession = MockSession.self
        } catch {
            //should never reach this
            XCTFail("exception happened")
            return;
        }
    }
    func testSavedInstanceWithInstallPush(){
        let tags = ["tag1","tag2"]
        let setting = TestSetting()
        let app = setting.app
        let owner = setting.owner
        
        let api1 = ThingIFAPIBuilder(app:app, owner:owner).build()
        let api2 = ThingIFAPIBuilder(app:app, owner:owner, tag:tags[0]).build()
        let api3 = ThingIFAPIBuilder(app:app, owner:owner, tag:tags[1]).build()
        
        var expectation = self.expectation(description: "testSavedInstanceWithInstallPush")
        setMockResponse4InstallPush("installationID-0001", setting: setting);
        api1.installPush("deviceToken-0001".data(using: String.Encoding.utf8)!, development: false) { (installID, error) -> Void in
            XCTAssertNil(error,"should not error")
            XCTAssertNotNil(installID,"Should not nil")
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
        
        expectation = self.expectation(description: "testSavedInstanceWithInstallPush")
        setMockResponse4InstallPush("installationID-0002", setting: setting);
        api2.installPush("deviceToken-0002".data(using: String.Encoding.utf8)!, development: false) { (installID, error) -> Void in
            XCTAssertNil(error,"should not error")
            XCTAssertNotNil(installID,"Should not nil")
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

        expectation = self.expectation(description: "testSavedInstanceWithInstallPush")
        setMockResponse4InstallPush("installationID-0003", setting: setting);
        api3.installPush("deviceToken-0003".data(using: String.Encoding.utf8)!, development: false) { (installID, error) -> Void in
            XCTAssertNil(error,"should not error")
            XCTAssertNotNil(installID,"Should not nil")
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

        do {
            var temp = try ThingIFAPI.loadWithStoredInstance()
            XCTAssertEqual(api1, temp , "should be equal")
            temp = try ThingIFAPI.loadWithStoredInstance(tags[0])
            XCTAssertEqual(api2, temp , "should be equal")
            temp = try ThingIFAPI.loadWithStoredInstance(tags[1])
            XCTAssertEqual(api3, temp , "should be equal")
        } catch {
            XCTFail("Should not raise exception ")
        }
        
        do {
            ThingIFAPI.removeStoredInstances(nil)
            try ThingIFAPI.loadWithStoredInstance()
            XCTFail("Should raise exception")
        } catch {
        }
        do {
            ThingIFAPI.removeStoredInstances(tags[0])
            try ThingIFAPI.loadWithStoredInstance(tags[0])
            XCTFail("Should raise exception")
        } catch {
        }
        
        do {
            ThingIFAPI.removeAllStoredInstances()
            try ThingIFAPI.loadWithStoredInstance(tags[1])
            XCTFail("Should raise exception")
        } catch {
        }
    }
    fileprivate func setMockResponse4InstallPush(_ installationID: String, setting:TestSetting) -> Void {
        let dict = ["installationID":installationID]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string: setting.app.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            iotSession = MockSession.self
        } catch {
            //should never reach this
            XCTFail("exception happened")
            return;
        }

    }
    func testSavedInstanceWithCopyWithTarget(){
        let tags = ["tag1","tag2"]
        let setting = TestSetting()
        let app = setting.app
        let owner = setting.owner
        
        let target1 = StandaloneThing(thingID: "user-00001", vendorThingID: "vendor-thing-id-001", accessToken: "token-00001")
        let target2 = StandaloneThing(thingID: "user-00002", vendorThingID: "vendor-thing-id-002", accessToken: "token-00002")
        let target3 = StandaloneThing(thingID: "user-00003", vendorThingID: "vendor-thing-id-003", accessToken: "token-00003")
        
        var api1 = ThingIFAPIBuilder(app:app, owner:owner).build()
        var api2 = ThingIFAPIBuilder(app:app, owner:owner, tag:tags[0]).build()
        var api3 = ThingIFAPIBuilder(app:app, owner:owner, tag:tags[1]).build()
        
        api1 = api1.copyWithTarget(target1)
        api2 = api2.copyWithTarget(target2, tag: tags[0])
        api3 = api3.copyWithTarget(target3, tag: tags[1])
        do {
            var temp = try ThingIFAPI.loadWithStoredInstance()
            XCTAssertEqual(api1, temp , "should be equal")
            temp = try ThingIFAPI.loadWithStoredInstance(tags[0])
            XCTAssertEqual(api2, temp , "should be equal")
            temp = try ThingIFAPI.loadWithStoredInstance(tags[1])
            XCTAssertEqual(api3, temp , "should be equal")
        } catch {
            XCTFail("Should not raise exception ")
        }
        
        do {
            ThingIFAPI.removeStoredInstances(nil)
            try ThingIFAPI.loadWithStoredInstance()
            XCTFail("Should raise exception")
        } catch {
        }
        do {
            ThingIFAPI.removeStoredInstances(tags[0])
            try ThingIFAPI.loadWithStoredInstance(tags[0])
            XCTFail("Should raise exception")
        } catch {
        }
        
        do {
            ThingIFAPI.removeAllStoredInstances()
            try ThingIFAPI.loadWithStoredInstance(tags[1])
            XCTFail("Should raise exception")
        } catch {
        }
    }
    func testInvalidSavedInstance(){

        let persistance = UserDefaults.standard
        let baseKey = "ThingIFAPI_INSTANCE"
        //clear
        persistance.removeObject(forKey: baseKey)
        persistance.synchronize()
        sleep(1)

        do {
            try ThingIFAPI.loadWithStoredInstance()
            XCTFail("Should raise exception")
        } catch(let e as ThingIFError) {
            switch e {
            case .api_NOT_STORED:
                break
            default:
                XCTFail("Exception should be API_NOT_STORED")
                break
            }

        } catch {
            XCTFail("Exception should be API_NOT_STORED")
        }

        //set invalid object to base key
        persistance.set(1, forKey: baseKey)
        persistance.synchronize()

        do {
            try ThingIFAPI.loadWithStoredInstance()
            XCTFail("Should raise exception")
        } catch(let e as ThingIFError){
            switch e {
            case .api_NOT_STORED:
                break
            default:
                XCTFail("Exception should be API_NOT_STORED")
                break
            }

        } catch {
            XCTFail("Exception should be API_NOT_STORED")
        }

        //set empty dict to base key
        persistance.set(NSDictionary(), forKey: baseKey)
        persistance.synchronize()

        do {
            try ThingIFAPI.loadWithStoredInstance()
            XCTFail("Should raise exception")
        } catch(let e as ThingIFError) {
            switch e {
            case .api_NOT_STORED:
                break
            default:
                XCTFail("Exception should be API_NOT_STORED")
                break
            }
        } catch {
            XCTFail("Exception should be API_NOT_STORED")
        }

        //set invalid object type to the persistance
        persistance.set(NSDictionary(dictionary: [baseKey:"a"]), forKey: baseKey)
        persistance.synchronize()
        
        do {
            try ThingIFAPI.loadWithStoredInstance()
            XCTFail("Should raise exception")
        } catch(let e as ThingIFError) {
            switch e {
            case .invalid_STORED_API:
                break
            default:
                XCTFail("Exception should be INVALID_STORED_API")
                break
            }
        } catch {
            XCTFail("Exception should be INVALID_STORED_API")
        }

        //set invalid object to the persistance
        persistance.set(NSDictionary(dictionary: [baseKey:NSKeyedArchiver.archivedData(withRootObject: "a")]), forKey: baseKey)
        persistance.synchronize()

        do {
            try ThingIFAPI.loadWithStoredInstance()
            XCTFail("Should raise exception")
        } catch(let e as ThingIFError) {
            switch e {
            case .invalid_STORED_API:
                break
            default:
                XCTFail("Exception should be INVALID_STORED_API")
                break
            }
        } catch {
            XCTFail("Exception should be INVALID_STORED_API")
        }
    }
    
}
