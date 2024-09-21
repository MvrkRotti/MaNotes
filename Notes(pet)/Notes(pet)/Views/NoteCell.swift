//
//  NoteCell.swift
//  Notes(pet)
//
//  Created by Danil Pestov on 20.09.2024.
//

import UIKit

final class NoteCell: UITableViewCell {
    
    static let identifier  = "NoteCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorResources.lightGray
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupShadows()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupShadows()
    }
    
    func configureCell(with title: String, content: String) {
        titleLabel.text = title
        contentLabel.text = content
    }
}

private extension NoteCell {
    func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(contentLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(10)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.left.equalToSuperview().offset(10)
        }
    }
    
    func setupShadows() {
        layer.shadowColor = ColorResources.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        backgroundColor = .clear
    }
}
