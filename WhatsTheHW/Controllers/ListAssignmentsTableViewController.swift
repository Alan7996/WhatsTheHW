//
//  ListCoursesTableViewController.swift
//  WhatsTheHW
//
//  Created by 수현 on 7/13/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import Parse

class ListAssignmentsTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    let searchController = UISearchController(searchResultsController: nil)
    var filteredAssignments = [Assignment]()
    
    var course: Course?
    var assignments: [Assignment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("1")
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.dataSource = self
        
        let currentCourseAssignmentsQuery = PFQuery(className: "Assignment")
        
        currentCourseAssignmentsQuery.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError?) -> Void in
            for object in result! {
                if object["course"].objectId == ((self.course?.objectId)!) {
                    self.assignments.append(object as! Assignment)
                }
            }
            
            self.assignments.sortInPlace({ $0.dueDate!.compare($1.dueDate!) == NSComparisonResult.OrderedAscending})
            
            self.tableView.reloadData()
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredAssignments.count
        }
        
        return assignments.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listAssignmentsTableViewCell", forIndexPath: indexPath) as! ListAssignmentsTableViewCell
        
        let assignment: Assignment
        
        if searchController.active && searchController.searchBar.text != "" {
            assignment = filteredAssignments[indexPath.row]
        } else {
            assignment = assignments[indexPath.row]
        }
        
        cell.assignmentNameLabel.text = assignment.title

        cell.assignmentInstructionLabel.text = assignment.instruction
        
        cell.assignmentInstructionLabel.numberOfLines = 0
        
        cell.assignmentInstructionLabel.frame = CGRectMake(20, 20, 200, 800)
        
        cell.assignmentInstructionLabel.sizeToFit()
        
        cell.assignmentModificationTimeLabel.text = DateHelper.stringFromDate(assignment.updatedAt!)
        
        cell.assignmentDueDateLabel.text = DateHelper.stringFromDate(assignment.dueDate!)
        
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "addAssignment" {
                print("+ button tapped")
                let displayAssignmentViewController = segue.destinationViewController as! DisplayAssignmentViewController
                displayAssignmentViewController.course = course
                
            } else if identifier == "displayAssignment" {
                print("Table view cell tapped")
                let indexPath = tableView.indexPathForSelectedRow!
                let assignment = assignments[indexPath.row]
                let displayAssignmentViewController = segue.destinationViewController as! DisplayAssignmentViewController
                displayAssignmentViewController.assignment = assignment
                displayAssignmentViewController.course = course
                displayAssignmentViewController.objectID = assignment.objectId
            }
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete {
//            RealmHelper.deleteAssignment(assignments[indexPath.row])
//            assignments = RealmHelper.retrieveAssignments()
        }
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredAssignments = assignments.filter { assignment in
            return assignment.title!.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    @IBAction func unwindToListCoursesViewController(segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        
    }
}
extension ListAssignmentsTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}