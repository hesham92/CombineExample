import XCTest
@testable import InterviewTask2023

final class UsersListViewModelTests: XCTestCase {
    var presenter: RestaurantsListPresenter!
    private var restaurantRequest: RestaurantsListPresenter.RestaurantRequest!
    
    override func setUpWithError() throws {
        presenter = RestaurantsListPresenter(restaurantRequest: { [unowned self] in self.restaurantRequest($0, $1, $2) })
    }
    
    override func tearDownWithError() throws {
        presenter = nil
    }
    
    func testFetchUsers_success() {
        //given
        let expectedUsersList = [Restaurant.mock()]
        
        restaurantRequest = { _, _, completionHandler in
            completionHandler(.success([Restaurant.mock()]))
        }
        
      
        //when
        presenter?.viewDidLoad()
        
        //then
       // XCTAssertTrue(presenter.res .value.count > 0)
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
//
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
