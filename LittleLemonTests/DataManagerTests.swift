//
//  DataManagerTests.swift
//  LittleLemonTests
//
//  Created by Quân Đinh on 14.08.25.
//

import Testing
import Foundation
@testable import LittleLemon

final class URLProtocolStub: URLProtocol {
  struct Stub {
    let data: Data
    let response: URLResponse
    let error: Error?
  }
  static var stub: Stub?
  
  override class func canInit(with request: URLRequest) -> Bool { true }
  override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
  
  override func startLoading() {
    guard let client = client else { return }
    guard let stub = Self.stub else {
      client.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
      return
    }
    if let error = stub.error {
      client.urlProtocol(self, didFailWithError: error)
    } else {
      client.urlProtocol(self, didReceive: stub.response, cacheStoragePolicy: .notAllowed)
      client.urlProtocol(self, didLoad: stub.data)
      client.urlProtocolDidFinishLoading(self)
    }
  }
  override func stopLoading() {}
}

@Suite("DataManager (URLProtocol) – unit, no network")
struct DataManagerTests {
  
  private let fakeURL = URL(string: "https://example.com/menu.json")!
  
  private func makeSessionStub(data: Data, status: Int = 200, url: URL) -> URLSession {
    let cfg = URLSessionConfiguration.ephemeral
    cfg.protocolClasses = [URLProtocolStub.self]
    let response = HTTPURLResponse(url: url, statusCode: status, httpVersion: nil, headerFields: nil)!
    URLProtocolStub.stub = .init(data: data, response: response, error: nil)
    return URLSession(configuration: cfg)
  }
  
  @Test("Decode success")
  func testSuccessDecode() async throws {
    // Given
    let json = """
        {"menu":[{"id":"1","title":"Greek Salad","description":"The famous greek salad of crispy lettuce, peppers, olives, our Chicago.","price":"10","image":"https://github.com/Meta-Mobile-Developer-PC/Working-With-Data-API/blob/main/images/greekSalad.jpg?raw=true","category":"starters"}]}
        """.data(using: .utf8)!
    let session = makeSessionStub(data: json, url: fakeURL)
    let sut = DataManager(session)
    
    // When
    let result: MenuList = try await sut.getMenuData()
    
    // Then
    #expect(result.menu.count == 1)
    #expect(result.menu.first?.title == "Greek Salad")
  }
  
  @Test("Decode fail")
  func testFailureDecode() async {
    let bad = Data(#"{"unexpected":"shape"}"#.utf8)
    let session = makeSessionStub(data: bad, url: fakeURL)
    let sut = DataManager(session)
    
    await #expect(throws: Error.self) {
      let _: MenuList = try await sut.getMenuData()
    }
  }
  
  @Test("Simulate network error")
  func testNetworkError() async {
    // Given
    let cfg = URLSessionConfiguration.ephemeral
    cfg.protocolClasses = [URLProtocolStub.self]
    let response = HTTPURLResponse(url: fakeURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
    URLProtocolStub.stub = .init(data: Data(), response: response, error: URLError(.timedOut))
    let session = URLSession(configuration: cfg)
    let sut = DataManager(session)
    
    // When / Then
    await #expect(throws: Error.self) {
      _ = try await sut.getMenuData()
    }
  }

}
