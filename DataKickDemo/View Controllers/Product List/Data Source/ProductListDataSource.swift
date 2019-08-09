import UIKit

class ProductListDataSource: NSObject {
    
    private let tableView: UITableView
    private let onProductSelected: (Product) -> ()
    private var products: [Product] = []
    
    init(for tableView: UITableView, onProductSelected: @escaping (Product) -> ()) {
        self.tableView = tableView
        self.onProductSelected = onProductSelected
        tableView.register(ProductListCell.self)
    }
    
    func update(with products: [Product]) {
        self.products = products
        tableView.reloadData()
    }
}

extension ProductListDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductListCell = tableView.dequeueReusableCell(for: indexPath)
        let product = products[indexPath.row]
        let viewModel = ProductViewModel(product: product)
        cell.viewModel = viewModel
        return cell
    }
}

extension ProductListDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        onProductSelected(product)
    }
}
