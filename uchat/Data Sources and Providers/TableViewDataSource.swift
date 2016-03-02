//
//  TableViewDataSource.swift
//  uchat
//
//  Created by Wojtek Materka on 01/03/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit


/// A boiler-plate wrapper for UITableViewDataSource that processes data updates to the table.
/// In our case the DataProvider is another wrapper: FetchedResultsDataProvider, but this
/// class can accept any Data as long as it adheres to DataProvider protocol and its DataSourceDelegate's data is compatible with DataProvider's
class TableViewDataSource<Delegate: DataSourceDelegate, Data: DataProvider, Cell: UITableViewCell where Delegate.Object == Data.Object, Cell: ConfigurableCell, Cell.DataSource == Data.Object>: NSObject, UITableViewDataSource {
    
    required init(tableView: UITableView, dataProvider: Data, delegate: Delegate) {
        self.tableView = tableView
        self.dataProvider = dataProvider
        self.delegate = delegate
        super.init()
        tableView.dataSource = self
        updateUI { self.tableView.reloadData() }
    }
    
    var selectedObject: Data.Object? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        return dataProvider.objectAtIndexPath(indexPath)
    }
    
    /// Processes updates passed from the TableViewController as the DataProviderDelegate of FetchedResultsDataProvider
    func processUpdates(updates: [DataProviderUpdate<Data.Object>]?) {
        guard let updates = updates else { return tableView.reloadData() }
        tableView.beginUpdates()
        for update in updates {
            switch update {
            case .Insert(let indexPath):
                print("inserting new object to table at \(indexPath)")
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            case .Update(let indexPath, let object):
                guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? Cell else { break }
                cell.configureForObject(object)
            case .Move(let indexPath, let newIndexPath):
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            case .Delete(let indexPath):
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        }
        tableView.endUpdates()
    }
    
    // MARK: Private
    
    private let tableView: UITableView
    private let dataProvider: Data
    private weak var delegate: Delegate!
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.numberOfItemsInSection(section)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = dataProvider.objectAtIndexPath(indexPath)
        let identifier = delegate.cellIdentifierForObject(object)
        guard let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? Cell else { fatalError("Unexpected cell type at \(indexPath)") }
        cell.configureForObject(object)
        return cell
    }
    
    
}
