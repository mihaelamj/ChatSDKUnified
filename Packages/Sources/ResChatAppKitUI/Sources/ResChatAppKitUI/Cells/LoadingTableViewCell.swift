//
//  LoadingTableViewCell.swift
//  ResChatAppKitUI
//
//  Created by Mihaela MJ on 09.12.2024..
//

import AppKit
import ResChatUICommon

open class LoadingTableViewCell: ProvidingTableViewCell {
    override open class var identifier: String { "LoadingTableViewCell" }
    
    private let loadingIndicator = NSProgressIndicator()

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Configure the cell's background
        wantsLayer = true
        layer?.backgroundColor = Self.colorProvider.backgroundColor.cgColor
        
        // Configure the loading indicator
        loadingIndicator.style = .spinning
        loadingIndicator.isIndeterminate = true
        loadingIndicator.controlTint = .defaultControlTint
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.startAnimation(nil)
        
        addSubview(loadingIndicator)
        
        // Add constraints
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            loadingIndicator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    public func configure(with message: UIMessage) {
        loadingIndicator.startAnimation(nil)
    }
}
