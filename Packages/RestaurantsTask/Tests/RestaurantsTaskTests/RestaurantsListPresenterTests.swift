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
    
    func testFetchRestaurants_InCaseOfSuccess() async throws {
        //given
        serviceMock.setResult(.success([Restaurant.mock(), Restaurant.mock()]))
        
        //when
        await presenter.viewDidLoad()
        
        //then
        
        if case let .loaded(restaurants) = self.presenter.state {
            XCTAssertTrue(restaurants.count == 2)
        } else {
            XCTFail("Expected presenter state to be loaded with restaurants count = 2")
        }
    }
    
    func testFetchRestaurants_InCaseOffailure() async throws {
        //given
        serviceMock.setResult(Result<[Restaurant], Error>.failure(MockError()))
        
        //when
        await presenter.viewDidLoad()
        
        //then
        
        if case let .error(errorDesc) = self.presenter.state {
            XCTAssertFalse(errorDesc.isEmpty)
        } else {
            XCTFail("Expect errorDesc is not empty")
        }
    }
}
