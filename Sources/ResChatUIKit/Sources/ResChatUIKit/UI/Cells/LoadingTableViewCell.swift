//
//  LoadingTableViewCell.swift
//  
//
//  Created by Mihaela MJ on 30.08.2024..
//
#if os(iOS)
import UIKit
import ResChatUICommon

open class LoadingTableViewCell: ProvidingTableViewCell {
    override open class var identifier: String { "LoadingTableViewCell" }
    
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = Self.colorProvider.backgroundColor
        loadingIndicator.tintColor = Self.colorProvider.chatBotButtonBackground
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.startAnimating()
        contentView.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            loadingIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    public func configure(with message: UIMessage) {
        loadingIndicator.startAnimating()
        configureForDebugging(with: message.type)
    }
}
#endif
