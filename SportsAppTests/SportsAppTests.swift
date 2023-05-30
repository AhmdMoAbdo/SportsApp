//
//  SportsAppTests.swift
//  SportsAppTests
//
//  Created by Ahmed on 25/05/2023.
//

import XCTest
@testable import SportsApp

final class SportsAppTests: XCTestCase {
    
    var network:ApiHandler!
    var viewModel:ViewModelProtocol!
    var fakeNetwork:FakeNetwork!
    var favViewModel:FavoritesViewModelProtocol!
    var leagueDetailsViewModel:LeagueDetailsViewModelProtocol!
    var db:FakeDB = FakeDB()

    override func setUpWithError() throws {
        network = ApiHandler()
        viewModel = ViewModel(api: network)
        fakeNetwork = FakeNetwork(shouldReturnError: false)
        favViewModel = FavoritesViewModel(db: db)
        leagueDetailsViewModel = LeagueDetailsViewModel(api: network, db: db)
    }

    override func tearDownWithError() throws {
        network = nil
    }

    func testLoadDataFromURL(){
        let myEexpectaion = expectation(description: "Waiting for Api Response")
        var parameters:Dictionary<String,Any> = ["met": "Countries"]
        network.getData(parameters: &parameters, sport: "football") { (result:Responce<Country>?) in
            guard let response = result else{
                XCTFail("")
                return
            }
            XCTAssertNotNil(response,"Network responded with nil")
            XCTAssertTrue(response.result.count>0)
            XCTAssertFalse(response.success != 1)
            myEexpectaion.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testViewModel(){
        let myEexpectaion = expectation(description: "Waiting for Api Response")
        var parameters:Dictionary<String,Any> = ["met": "Countries"]
        viewModel.getItems(parameters: &parameters, sport: "football") { (result:[Country]) in
            XCTAssertNotNil(result,"Country array is nil")
            XCTAssertTrue(result.count>0)
            myEexpectaion.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testUsingMock(){
        var parameters:Dictionary<String,Any> = ["met": "Countries"]
        fakeNetwork.getData(parameters: &parameters, sport: "football") { result in
            guard let response = result else{
                XCTFail("")
                return
            }
            XCTAssertNotNil(response,"Network responded with nil")
        }
    }
    
    func testFetchingDBThroughFavViewModel(){
        var league = League(league_key: 1)
        db.insertToCoreData(leagueObj: league, sport: "")
        var result = favViewModel.getFavorites(sport: "")
        XCTAssertNotNil(result)
        XCTAssertEqual(league.league_key, result[0].league_key)
        favViewModel.deleteFromFavourites(league: league, sport: "")
        result = favViewModel.getFavorites(sport: "")
        XCTAssert(result.isEmpty)
    }

    func testInsertingIntoDBThroughleagueDetailsVM(){
        XCTAssert(db.fetchFromCoreData(sport: "").isEmpty)
        var league = League(league_key: 1)
        leagueDetailsViewModel.insertIntoDB(league: league, sport: "")
        XCTAssert(!db.fetchFromCoreData(sport: "").isEmpty)
        XCTAssertEqual(db.fetchFromCoreData(sport: "")[0].league_key, league.league_key)
    }

    func testDeletingFromDBThroughleagueDetailsVM(){
        XCTAssert(db.fetchFromCoreData(sport: "").isEmpty)
        var league = League(league_key: 1)
        leagueDetailsViewModel.insertIntoDB(league: league, sport: "")
        XCTAssertEqual(db.fetchFromCoreData(sport: "")[0].league_key, league.league_key)
        leagueDetailsViewModel.deleteFromDB(league: league, sport: "")
        XCTAssert(db.fetchFromCoreData(sport: "").isEmpty)
    }

    func testIsFavouriteThroughleagueDetailsVM(){
        var league = League(league_key: 1)
        leagueDetailsViewModel.insertIntoDB(league: league, sport: "")
        XCTAssertTrue(leagueDetailsViewModel.isFavourite(league: league, sport: ""))
    }

    func testGettingURLDataThroughLeagueDetailsViewModel(){
        let myEexpectaion = expectation(description: "Waiting for Api Response")
        var parameters:Dictionary<String,Any> = [
            "met": "Fixtures",
            "leagueId":"5",
            "from":"2022-05-25",
            "to":"2023-05-25"
        ]
        leagueDetailsViewModel.getItems(parameters: &parameters, sport: "football") { (result:[Event]) in
            XCTAssertNotNil(result,"leagues array is nil")
            XCTAssertTrue(result.count>0)
            myEexpectaion.fulfill()
        }
        waitForExpectations(timeout: 5)
    }

}
