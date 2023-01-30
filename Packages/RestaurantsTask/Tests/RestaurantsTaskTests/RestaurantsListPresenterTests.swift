import XCTest
@testable import RestaurantsTask

final class RestaurantsListPresenterTests: XCTestCase {
    var presenter: RestaurantsListPresenter!
    var serviceMock: HttpServiceMock!
    
    override func setUpWithError() throws {
        serviceMock = HttpServiceMock()
        presenter = DefaultRestaurantsListPresenter(service: serviceMock)
    }
    
    override func tearDownWithError() throws {
        serviceMock = nil
        presenter = nil
    }
    
    func testFetchRestaurants_inCaseOfSuccess() async throws {
        //Given
        serviceMock.setResult(.success([Restaurant.mock(), Restaurant.mock()]))
        
        //When
        await presenter.viewDidLoad()
        
        //Then
        if case let .loaded(restaurantsViewModels) = presenter.state {
            XCTAssertTrue(restaurantsViewModels.count == 2)
        } else {
            XCTFail("Expected presenter state to be loaded with restaurantsViewModels count = 2")
        }
    }
    
    func testFetchRestaurants_inCaseOfFailure() async throws {
        //Given
        serviceMock.setResult(Result<[Restaurant], Error>.failure(MockError()))
        
        //When
        await presenter.viewDidLoad()
        
        //Then
        if case let .error(model) = presenter.state {
            XCTAssertFalse(model.description.isEmpty)
        } else {
            XCTFail("Expect errorDesc is not empty")
        }
    }
    
    func testDidSelectSegmentAtIndex_defaultCase() async throws {
        //Given
        let selectedIndex = 0 // Default
        serviceMock.setResult(.success([Restaurant.mock(name: "Papa johns", rating: 3), Restaurant.mock(name: "KFC", rating: 4)]))
        
        //When
        await presenter.viewDidLoad()
        presenter.didSelectSegmentAtIndex(selectedIndex)
        
        //Then
        if case let .loaded(restaurantsViewModels) = presenter.state {
            XCTAssertTrue(restaurantsViewModels[0].name == "Papa johns")
            XCTAssertTrue(restaurantsViewModels[1].name == "KFC")
        } else {
            XCTFail("Expected presenter state to be loaded")
        }
    }
    
    func testDidSelectSegmentAtIndex_distanceCase() async throws {
        //Given
        let selectedIndex = 1 // distance
        serviceMock.setResult(.success([Restaurant.mock(name: "Papa johns", distance: 1000), Restaurant.mock(name: "KFC", distance: 800)]))
        
        //When
        await presenter.viewDidLoad()
        presenter.didSelectSegmentAtIndex(selectedIndex)
        
        //Then
        if case let .loaded(restaurantsViewModels) = presenter.state {
            XCTAssertTrue(restaurantsViewModels[0].name == "KFC")
            XCTAssertTrue(restaurantsViewModels[1].name == "Papa johns")
        } else {
            XCTFail("Expected presenter state to be loaded")
        }
    }
    
    func testDidSelectSegmentAtIndex_ratingCase() async throws {
        //Given
        let selectedIndex = 2 // rating
        serviceMock.setResult(.success([Restaurant.mock(name: "Papa johns", rating: 4), Restaurant.mock(name: "KFC", rating: 5)]))
        
        //When
        await presenter.viewDidLoad()
        presenter.didSelectSegmentAtIndex(selectedIndex)
        
        //Then
        if case let .loaded(restaurantsViewModels) = presenter.state {
            XCTAssertTrue(restaurantsViewModels[0].name == "KFC")
            XCTAssertTrue(restaurantsViewModels[1].name == "Papa johns")
        } else {
            XCTFail("Expected presenter state to be loaded")
        }
    }
}
