//
//  UrlProtocolMock.swift
//  RecipleaseTests
//
//  Created by Birkyboy on 19/09/2021.
//

import Foundation
import XCTest

class MockURLProtocol: URLProtocol {

    // To check if this protocol can handle the given request.
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    // Here you return the canonical version of the request but most of the time you pass the orignal one.
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
            // Send received data to the client.
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            // Notify request has been finished.
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            // Notify received error.
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    // This is called if the request gets canceled or completed.
    override func stopLoading() {}
}
