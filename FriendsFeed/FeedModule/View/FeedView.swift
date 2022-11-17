import UIKit
import SnapKit

protocol FeedViewDelegateProtocol: AnyObject {
    func refreshDataDidLaunch()
}

class FeedView: UIView {
    // MARK: - UI elements
    private(set) lazy var feedTableView: UITableView = {
        let view = UITableView()
        
        view.register(FeedTableViewCell.self, forCellReuseIdentifier: ItemsIdentifier.feedCell.rawValue)
        view.register(FeedSectionView.self, forHeaderFooterViewReuseIdentifier: ItemsIdentifier.feedSectionHeader.rawValue)
       
        view.refreshControl = UIRefreshControl()
        view.refreshControl?.attributedTitle = NSAttributedString(string: "Загружаю новые посты....")
        view.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        view.refreshControl?.tintColor = .label
        
        return view
    }()
    weak var delegate: FeedViewDelegateProtocol?
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        addSubview(feedTableView)
        setSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Sub methods
    private func setSubviewsLayout() {
        feedTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    @objc private func refreshData() {
        delegate?.refreshDataDidLaunch()
    }
}
