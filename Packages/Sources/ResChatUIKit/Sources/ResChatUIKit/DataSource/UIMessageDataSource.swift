//
//  UIMessageDataSource.swift
//
//
//  Created by Mihaela MJ on 02.09.2024..
//

import UIKit
import ResChatUICommon

class UIMessageDataSource: UITableViewDiffableDataSource<ChatSection, UIMessage> {
    
    init(tableView: UITableView,
         userMessageCellType: UserMessageCell.Type,
         botMessageCellType: ChatBotMessageCell.Type,
         loadingMessageCellType: LoadingTableViewCell.Type) {
        
        super.init(tableView: tableView) { (tableView, indexPath, message) -> UITableViewCell? in
            
            switch message.type {
            case .user, .placeholder(.forUser):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: userMessageCellType.identifier,
                    for: indexPath
                ) as? UserMessageCell else { return nil }
                cell.configure(with: message)
                return cell
                
            case .bot, .placeholder(.forBot):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: botMessageCellType.identifier,
                    for: indexPath
                ) as? ChatBotMessageCell else { return nil }
                cell.configure(with: message)
                return cell
                
            case .placeholder(.forLoading):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: loadingMessageCellType.identifier,
                    for: indexPath
                ) as? LoadingTableViewCell else { return nil }
                cell.configure(with: message)
                return cell
            }
        }
    }
}

// MARK: Demo Data -

extension UIMessageDataSource {
    
    func applyInitialSnapshot(messages: [UIMessage]) {
        var snapshot = UIMessageSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(messages, toSection: .main)
        apply(snapshot, animatingDifferences: true)
    }
    
}
