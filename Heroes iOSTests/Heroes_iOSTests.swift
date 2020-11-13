//
//  Heroes_iOSTests.swift
//  Heroes iOSTests
//
//  Created by TR64UV on 08/11/2020.
//

import XCTest
@testable import Heroes_iOS

class Heroes_iOSTests: XCTestCase {

    func testDataTransferService() {
        let expectition = self.expectation(description: "DataTransferService")
        let dataTransfer = DataTransferService()
        let endpoint = APIEndpoints.getCharacters(offset: 0)
        dataTransfer.request(with: endpoint) { result in
            switch result {
            case .success(let data):
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                    XCTFail("Error parsing json")
                    return
                }
                XCTAssertNotNil(json)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectition.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testHeroesSkillRepository() {
        let expectition = self.expectation(description: "HeroesSkillRepository")
        
        DefaultHeroesSkillRepository().fetchHeroesSkillsList(offset: 40){ result in
            switch result {
            case .success(let heroesList):
                XCTAssertEqual(heroesList.count, 40)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectition.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testHeroesSkillsListUseCase() {
        let expectition = self.expectation(description: "fetchHeroesSkillsListUseCase")
        let completion: ((Result<[HeroesModel], Error>) -> Void) = { result in
            switch result {
            case .success(let heroesPresentationList):
                XCTAssertNotNil(heroesPresentationList)
                expectition.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
        }
        FetchHeroesSkillsListUseCase().execute(completion: completion)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testHeroesViewModelFetchData() {
        let expectition = self.expectation(description: "fetchHeroesSkillsListUseCase")
        let viewModel = DefaultHeroesViewModel()
        viewModel.load()
        viewModel.heroesItems.observe(on: self) { items in
            guard items.count > 0 else {
                return
            }
            XCTAssertEqual(items.count, 40)
            expectition.fulfill()
        }
        
        viewModel.error.observe(on: self) { error in
            guard let error = error  else {
                return
            }
            XCTFail(error)
            expectition.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
