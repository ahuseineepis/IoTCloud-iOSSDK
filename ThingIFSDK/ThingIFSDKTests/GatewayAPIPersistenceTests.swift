//
//  GatewayAPIPersistenceTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/13.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class GatewayAPIPersistenceTests: GatewayAPITestBase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    func testLoadFromStoredInstance() throws {
        let expectation = self.expectation(
          description: "testLoadFromStoredInstanceWithTag")
        let setting = TestSetting()

        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: ["accessToken": ACCESSTOKEN],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        let api = GatewayAPI(
          setting.app,
          gatewayAddress: URL(string: setting.app.baseURL)!,
          tag: nil)
        api.login("dummy", password: "dummy") { error -> Void in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        XCTAssertNil(api.tag)

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }

        XCTAssertEqual(api, try GatewayAPI.loadWithStoredInstance())
    }

    func testLoadFromStoredInstanceWithTag() throws {
        let expectation = self.expectation(
          description: "testLoadFromStoredInstanceWithTag")
        let setting = TestSetting()
        let tag = "dummyTag"

        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: ["accessToken": ACCESSTOKEN],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        let api = GatewayAPI(
          setting.app,
          gatewayAddress: URL(string: setting.app.baseURL)!,
          tag: tag)
        api.login("dummy", password: "dummy") { error -> Void in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        XCTAssertEqual(tag, api.tag)

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }

        XCTAssertEqual(api, try GatewayAPI.loadWithStoredInstance(tag))
    }

    func testLoadFromStoredInstanceNoSDKVersion() throws {
        let expectation = self.expectation(
          description: "testLoadFromStoredInstanceNoSDKVersion")
        let setting = TestSetting()


        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: ["accessToken": ACCESSTOKEN],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        let api = GatewayAPI(
          setting.app,
          gatewayAddress: URL(string: setting.app.baseURL)!,
          tag: nil)
        api.login("dummy", password: "dummy") { error -> Void in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        XCTAssertNil(api.tag)

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }

        let baseKey = "GatewayAPI_INSTANCE"
        if var dict = UserDefaults.standard.dictionary(forKey: baseKey) {
            dict["GatewayAPI_VERSION"] = nil
            UserDefaults.standard.set(dict, forKey: baseKey)
            UserDefaults.standard.synchronize()
        }

        XCTAssertThrowsError(try GatewayAPI.loadWithStoredInstance()) { error in
            XCTAssertEqual(
              ThingIFError.apiUnloadable(
                tag: nil,
                storedVersion: nil,
                minimumVersion: "1.0.0"),
              error as? ThingIFError)
        }
    }

}
