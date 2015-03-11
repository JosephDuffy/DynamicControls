Dynamic Controls
===

Dynamic Controls is a collection of iOS classes written in Swift to enable support for Dynamic Type (user-adjustable font size) and Auto Layout in various areas of iOS, focusing on `UITableView`s. Any custom controls also take in to account VoiceOver by ensuring the classes are correctly setup for accessibility.

## Dynamic Type

By default, not all UIKit controls support Dynamic Type, and this project aims to create subclasses to these core UIKit controls to support Dynamic Type. Although some classes within UIKit have gained Dynamic Type support (e.g., `UITaleViewCell` since iOS 8), Dynamic Controls aims to add support back to iOS 7, and includes some extra classes not yet supported in iOS (as of iOS 8), such as `UISegmentedControl`.

Dynamic Controls has built some of the core classes within UIKit to support Dynamic Type, including:

* `UILabel`
* `UITextField`
* `UISegmentedControl`
* `UITableViewCell`

## Auto Layout UITableView

`UITableView`s do not fully support auto layout in some aspects, the most notable of which is `UITableViewCell`. This is less of a problem with iOS 8, but the creation of a custom `UITableViewCell` itself can be tricky. Included is a solution to add support for Auto Layout within `UITableViewCell`s, ensuring the correct height is used and calculated efficiently.

Dynamic Controls includes some example `UITableViewCell`s, including:

* A `UITableViewCell` containing a `UISwitch`
* A `UITableViewCell` acting as a `UIButton`
* A `UITableViewCell` containing a `UITextField` for user input

## Installation

Dynamic Controls can be installed in many ways. 2 are described below for your convenience:

### Carthage

First, [install and setup Carthage](https://github.com/Carthage/Carthage#installing-carthage), then add `github YetiiNet/DynamicControls` to your Cartfile. The rest is left up to you.

### Git Submodule

First, add Dynamic Controls as a submodule. The directory you place it in is up to you, but I like to put them in a `frameworks` subfolder:

`git submodule add -f https://github.com/YetiiNet/DynamicControls.git frameworks/DynamicControls`

After, drag all the `.swift` files in the `frameworks/DynamicControls/DynamicControls` (or equivalent) directory.

## Implementation

A full implementation of Dynamic Controls can be found in the [Dynamic Controls Example App](https://github.com/YetiiNet/DynamicControlsExampleApp), but for your reference a setup guide is provided:

The first step to implementing the `UITableViewController` aspect of Dynamic Controller is to subclass `DynamicTableViewController`, rather than `UITableViewController`. On its own this won't do much, so you'll need to make a couple of other alterations.

First, implement to `cellReuseIdentifierForIndexPath:` method:

```
override func cellReuseIdentifierForIndexPath(indexPath: NSIndexPath) -> String? {
    // Logic based on section and row
    if indexPath.section == 0 {
        return "CellReuseIdentifier"
    } else {
        // Returning nil will tell Dynamic Controls you don't want it to do anything for this index path
        return nil
    }
}
```
    
Next, you'll want the cell to have some content (based on your data). For this, implement the `configureCell:forIndexPath:` method. This method may be called multiple times for the same cell. This is to calculate the height for the cell prior to drawing it on the screen. If you return `nil` from the `cellReuseIdentifierForIndexPath:` method, this method will not be called for that cell. An example implementation would be:

```
override func configureCell(cell: UITableViewCell, forIndexPath indexPath: NSIndexPath) {
    cell.textLabel?.text = "Row for section \(indexPath.section + 1) row \(indexPath.row + 1)"
}
```

That's it! Although you can do more with Dynamic Controls,