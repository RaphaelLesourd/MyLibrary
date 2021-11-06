//
//  UrlProtocolMock.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 30/10/2021.
//

import Foundation
import XCTest

class MockURLProtocol: URLProtocol {

    // To check if this protocol can handle the given request.
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    // Handler to test the request and return mock response.
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }
        do {
            // Call handler with received request and capture the tuple of response and data.
            let (response, data) = try handler(request)
            // Send received response to the client.
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    // Called if the request gets canceled or completed.
    override func stopLoading() {}
}
