import XCTest
@testable import RestaurantsTask

final class UsersListViewModelTests: XCTestCase {
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
    
    func testFetchUsers_success() async throws {
        //given

        serviceMock.setResult(.success([Restaurant.mock()]))
        
    
        //when
        await presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(presenter.restaurants.count > 0)
//        XCTAssertTrue(viewModel.isLoading.value == false)
//        XCTAssertTrue(viewModel.errorMessage.value == "")
    }
    
//    func testFetchUsers_failure() {
//        //given
//        serviceMock.fetchUsersCallBlock = { completion in
//            completion(.failure(MockError()))
//        }
//
//        //when
//        presenter?.viewDidLoad()
//
//        //then
////        XCTAssertTrue(viewModel.users.value.count == 0)
////        XCTAssertTrue(viewModel.isLoading.value == false)
////        XCTAssertTrue(viewModel.errorMessage.value != "")
//    }
    
//    func testDidSelectUserAtIndex() {
//        //given
//        viewModel.users.value = [User.mock(username: "Test1", avatarUrl: "Https://Test/image.png", numberOfFollowers: nil, numberOfPublicRepos: nil), User.mock(username: "Test2", avatarUrl: "Https://Test/image.png", numberOfFollowers: nil, numberOfPublicRepos: nil)]
//
//        //when
//        viewModel?.didSelectUserAtIndex(index: 1)
//
//        //then
//        XCTAssertEqual(viewModel.naviagteToReposScreen.value, "Test2")
//    }
}
