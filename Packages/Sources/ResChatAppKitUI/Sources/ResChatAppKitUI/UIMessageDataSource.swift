//
//  File.swift
//  ResChatAppKitUI
//
//  Created by Mihaela MJ on 09.12.2024..
//
#if os(macOS)
import AppKit
import ResChatUICommon

class UIMessageDataSource: NSObject, NSTableViewDataSource {
    
    private let tableView: NSTableView
    private let userMessageCellType: UserMessageCell.Type
    private let botMessageCellType: ChatBotMessageCell.Type
    private let loadingMessageCellType: LoadingTableViewCell.Type
    
    private var snapshot = NSDiffableDataSourceSnapshot<ChatSection, UIMessage>()
    
    init(tableView: NSTableView,
         userMessageCellType: UserMessageCell.Type,
         botMessageCellType: ChatBotMessageCell.Type,
         loadingMessageCellType: LoadingTableViewCell.Type) {
        
        self.tableView = tableView
        self.userMessageCellType = userMessageCellType
        self.botMessageCellType = botMessageCellType
        self.loadingMessageCellType = loadingMessageCellType
        
        super.init()
        
        tableView.dataSource = self
    }
    
    func applySnapshot(_ snapshot: NSDiffableDataSourceSnapshot<ChatSection, UIMessage>, animatingDifferences: Bool = true) {
        self.snapshot = snapshot
        if animatingDifferences {
            tableView.reloadData()
        } else {
            NSAnimationContext.runAnimationGroup { context in
                context.allowsImplicitAnimation = false
                tableView.reloadData()
            }
        }
    }
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        snapshot.numberOfItems
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard row < snapshot.itemIdentifiers.count else { return nil }
        let message = snapshot.itemIdentifiers[row]

        // Determine the cell type and identifier based on the message type
        let identifier: NSUserInterfaceItemIdentifier
        let cell: NSTableCellView

        switch message.type {
        case .user, .placeholder(.forUser):
            identifier = NSUserInterfaceItemIdentifier(userMessageCellType.identifier)
            cell = tableView.makeView(withIdentifier: identifier, owner: nil) as? UserMessageCell ?? UserMessageCell(frame: .zero)

        case .bot, .placeholder(.forBot):
            identifier = NSUserInterfaceItemIdentifier(botMessageCellType.identifier)
            cell = tableView.makeView(withIdentifier: identifier, owner: nil) as? ChatBotMessageCell ?? ChatBotMessageCell(frame: .zero)

        case .placeholder(.forLoading):
            identifier = NSUserInterfaceItemIdentifier(loadingMessageCellType.identifier)
            cell = tableView.makeView(withIdentifier: identifier, owner: nil) as? LoadingTableViewCell ?? LoadingTableViewCell(frame: .zero)
        }

        // Assign the identifier if the cell was created programmatically
        if cell.identifier == nil {
            cell.identifier = identifier
        }

        // Configure the cell if it conforms to `ConfigurableMessageCell`
        if let configurableCell = cell as? ConfigurableMessageCell {
            configurableCell.configure(with: message)
        }

        return cell
    }
}
#endif
