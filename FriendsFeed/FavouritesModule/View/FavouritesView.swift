import UIKit

class FavouritesView: UIView {
    //MARK: UI properties
    private(set) lazy var favouritesTableView: UITableView = {
        let view = UITableView()
        view.register(FeedTableViewCell.self,
                      forCellReuseIdentifier: ItemsIdentifier.favouritesPostCell.rawValue)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        addSubview(favouritesTableView)
        setSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubviewsLayout() {
        favouritesTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
