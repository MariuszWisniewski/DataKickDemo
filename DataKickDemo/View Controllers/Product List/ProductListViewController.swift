import UIKit
import ViewModelOwners

class ProductListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var dataSource: ProductListDataSource = {
        let dataSource = ProductListDataSource(for: tableView, onProductSelected: { [weak self] product in
            self?.showDetails(for: product)
        })
        return dataSource
    }()
    
    private lazy var searchDataSource: ProductListDataSource = {
        let dataSource = ProductListDataSource(for: tableView, onProductSelected: { [weak self] product in
            self?.showDetails(for: product)
        })
        return dataSource
    }()
    
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var searchBarIsEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: animated)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        configureSearchController()
        tableView.refreshControl = refreshControl
        tableView.reloadData()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshData()
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search products"
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.height)
    }
    
    @objc private func refreshData() {
        refreshControl.beginRefreshing()
        viewModel.downloadItems(onSuccess: { [weak self] products in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.dataSource.update(with: products)
                self.refreshControl.endRefreshing()
            }
            }, onFailure: { [weak self] error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
        })
    }
    
    private func downloadItems(query: String) {
        refreshControl.beginRefreshing()
        viewModel.downloadItems(query: query, onSuccess: { [weak self] products in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.searchDataSource.update(with: products)
                self.refreshControl.endRefreshing()
            }
            }, onFailure: { [weak self] error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
        })
    }
    
    private func showDetails(for product: Product) {
        viewModel.displayProduct(product)
    }

}

extension ProductListViewController: NonReusableViewModelOwner {
    func didSetViewModel(_ vm: ProductListViewModelProtocol, disposeBag: ViewModelOwnerDisposeBag) {
        title = vm.title
    }
}

extension ProductListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let isSearching = searchController.isActive && !searchBarIsEmpty
        tableView.dataSource = isSearching ? searchDataSource : dataSource
        tableView.delegate = isSearching ? searchDataSource : dataSource
        tableView.reloadData()
        
        if let searchedText = searchController.searchBar.text, !searchedText.isEmpty {
            searchDataSource.update(with: [])
            downloadItems(query: searchedText)
        }
    }
}
