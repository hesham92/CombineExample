import XCTest
@testable import RestaurantsTask

final class RestaurantsListViewModelTests: XCTestCase {
    var viewModel: RestaurantsListViewModel!
    var serviceMock: HttpServiceMock!
    
    override func setUp()  {
        serviceMock = HttpServiceMock()
        viewModel = RestaurantsListViewModel(service: serviceMock)
    }
    
    override func tearDown() {
        serviceMock = nil
        viewModel = nil
    }
    
    func testFetchRestaurants_inCaseOfSuccess() async {
        //Given
        serviceMock.setResult(.success([Restaurant.mock(name: "Papa johns", rating: 3), Restaurant.mock(name: "KFC", rating: 4)]))
        
        //When
        await viewModel.viewDidLoad()
        
        //Then
        if case let .loaded(restaurants) = viewModel.state {
            XCTAssertTrue(restaurants.count == 2)
            XCTAssertTrue(restaurants[0].name == "Papa johns")
            XCTAssertTrue(restaurants[1].name == "KFC")
            XCTAssertTrue(restaurants[0].rating == 3)
            XCTAssertTrue(restaurants[1].rating == 4)
        } else {
            XCTFail("Expected state to be loaded with restaurants count = 2")
        }
    }
    
    func testFetchRestaurants_inCaseOfFailure() async {
        //Given
        serviceMock.setResult(Result<[Restaurant], Error>.failure(MockError()))
        
        //When
        await viewModel.viewDidLoad()
        
        //Then
        if case let .error(model) = viewModel.state {
            XCTAssertFalse(model.description.isEmpty)
        } else {
            XCTFail("Expect errorDesc is not empty")
        }
    }
    
    func testDidSelectSegmentAtIndex_defaultCase() async {
        //Given
        let selectedIndex = 0 // Default
        serviceMock.setResult(.success([Restaurant.mock(name: "Papa johns", rating: 3), Restaurant.mock(name: "KFC", rating: 4)]))
        
        //When
        await viewModel.viewDidLoad()
        viewModel.didSelectSegmentAtIndex = selectedIndex
        
        //Then
        if case let .loaded(restaurants) = viewModel.state {
            XCTAssertTrue(restaurants[0].name == "Papa johns")
            XCTAssertTrue(restaurants[1].name == "KFC")
        } else {
            XCTFail("Expected state to be loaded")
        }
    }
    
    func testDidSelectSegmentAtIndex_distanceCase() async {
        //Given
        let selectedIndex = 1 // distance
        serviceMock.setResult(.success([Restaurant.mock(name: "Papa johns", distance: 1000), Restaurant.mock(name: "KFC", distance: 800)]))
        
        //When
        await viewModel.viewDidLoad()
        viewModel.didSelectSegmentAtIndex = selectedIndex
        
        //Then
        if case let .loaded(restaurants) = viewModel.state {
            XCTAssertTrue(restaurants[0].name == "KFC")
            XCTAssertTrue(restaurants[1].name == "Papa johns")
        } else {
            XCTFail("Expected state to be loaded")
        }
    }
    
    func testDidSelectSegmentAtIndex_ratingCase() async {
        //Given
        let selectedIndex = 2 // rating
        serviceMock.setResult(.success([Restaurant.mock(name: "Papa johns", rating: 4), Restaurant.mock(name: "KFC", rating: 5)]))
        
        //When
        await viewModel.viewDidLoad()
        viewModel.didSelectSegmentAtIndex = selectedIndex
        
        //Then
        if case let .loaded(restaurants) = viewModel.state {
            XCTAssertTrue(restaurants[0].name == "KFC")
            XCTAssertTrue(restaurants[1].name == "Papa johns")
        } else {
            XCTFail("Expected state to be loaded")
        }
    }
    
    func testDidSelectRestaurantAtIndex() async {
        //Given
        let selectedIndex = 1
        serviceMock.setResult(.success([Restaurant.mock(name: "Papa johns", rating: 4), Restaurant.mock(name: "KFC", rating: 5)]))
        
        //When
        await viewModel.viewDidLoad()
        viewModel.didSelectRestaurantAtIndex = selectedIndex
        
        //Then
        XCTAssertTrue(viewModel.navigateToRestaurantDetails?.name == "KFC")
    }
}
