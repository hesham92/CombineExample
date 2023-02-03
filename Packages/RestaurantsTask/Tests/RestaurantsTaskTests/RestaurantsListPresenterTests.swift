import XCTest
@testable import RestaurantsTask

final class RestaurantsListPresenterTests: XCTestCase {
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
        serviceMock.setResult(.success([Restaurant.mock(), Restaurant.mock()]))
        
        //When
        await viewModel.viewDidLoad()
        
        //Then
        if case let .loaded(restaurantsViewModels) = viewModel.state {
            XCTAssertTrue(restaurantsViewModels.count == 2)
        } else {
            XCTFail("Expected presenter state to be loaded with restaurantsViewModels count = 2")
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
        if case let .loaded(restaurantsViewModels) = viewModel.state {
            XCTAssertTrue(restaurantsViewModels[0].name == "Papa johns")
            XCTAssertTrue(restaurantsViewModels[1].name == "KFC")
        } else {
            XCTFail("Expected presenter state to be loaded")
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
        if case let .loaded(restaurantsViewModels) = viewModel.state {
            XCTAssertTrue(restaurantsViewModels[0].name == "KFC")
            XCTAssertTrue(restaurantsViewModels[1].name == "Papa johns")
        } else {
            XCTFail("Expected presenter state to be loaded")
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
        if case let .loaded(restaurantsViewModels) = viewModel.state {
            XCTAssertTrue(restaurantsViewModels[0].name == "KFC")
            XCTAssertTrue(restaurantsViewModels[1].name == "Papa johns")
        } else {
            XCTFail("Expected presenter state to be loaded")
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
