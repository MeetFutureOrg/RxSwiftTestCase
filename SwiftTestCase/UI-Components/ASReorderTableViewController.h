
//  ASReorderTableViewController.h
//
//  Created by Daniel Shusta on 11/28/10.
//  Copyright 2010 Acacia Tree Software. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//
//  THIS SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//	INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
//	PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//	OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


/*

	Interface Overview:

		ASReorderTableViewController is a UITableViewController subclass
		that incorporates a press-and-drag-to-reorder functionality into the
		tableView.

		Because it subclasses from UITableViewController, you can use existing
		classes that subclass from UITableViewController and subclass from
		ASReorderTableViewController instead. You only need to make a few
		changes (listed below).

        ASReorderTableViewControllerDelegate notifies upon change in
		dragging state. This could be useful if the destination or source of the
		reorder	could change the content of the cell.

        ASReorderTableViewControllerDraggableIndicators defines how to
		customize the dragged cell to make it appear more "draggable". By
		default this indicatorDelegate is self and the default implementation
		adds shadows above and below the cell.

		Requires iOS 4.0 or greater.


	Steps for use:

		0. If you aren't already, link against the QuartzCore framework.
		In Xcode 3.2, right-click the group tree (sidebar thingy),
		Add -> Existing Frameworks… -> QuartzCore.framework
		In Xcode 4.0, go to the project file -> Build Phases and add to
		Link Binary With Libraries.

		1. Subclass from this instead of UITableViewController

		2. UITableViewDataSource (almost certainly your subclass) should
 		implement -tableView:moveRowAtIndexPath:toIndexPath:


	Other recommendations:

		It is recommended that the tableView's dataSource -setReorderingEnabled:
		to NO if there is only one row.

		Rotation while dragging a cell is screwy and it's not clear to me how to
		handle that situation. For now, recommendation is to not allow rotations
		while dragging, maybe not at all.


	Assumptions made by this code:

		Subclass doesn't conform to UIGestureRecognizerDelegate. If it does,
		you're going to have to figure out how to orchastrate it all. It's
		likely not that difficult.

		self.tableView is of type UITableViewStylePlain. It will technically
		work with UITableViewStyleGrouped but it'll look ugly.

		This code totally ignores self.tableView.delegate's
		-tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:
		I have no idea what I would do with that.

		The tableview's contents won't change while dragging. I'm pretty sure if
		you do this, it will crash.

 */


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ASReorderTableViewController;

@protocol ASReorderTableViewControllerDelegate<NSObject>
@optional

- (void)dragTableViewController:(ASReorderTableViewController *)dragTableViewController didBeginDraggingAtRow:(NSIndexPath *)dragRow;
- (void)dragTableViewController:(ASReorderTableViewController *)dragTableViewController willEndDraggingToRow:(NSIndexPath *)destinationIndexPath;
- (void)dragTableViewController:(ASReorderTableViewController *)dragTableViewController didEndDraggingToRow:(NSIndexPath *)destinationIndexPath;
- (BOOL)dragTableViewController:(ASReorderTableViewController *)dragTableViewController shouldHideDraggableIndicatorForDraggingToRow:(NSIndexPath *)destinationIndexPath;

@end


@protocol ASReorderTableViewControllerDraggableIndicators<NSObject>
@optional
// hate this, required to fix an iOS 6 bug where cell is hidden when going through normal paths to get a cell
// you must make a new cell to return this (use reuseIdent == nil), do not use dequeueResable
- (UITableViewCell *)cellIdenticalToCellAtIndexPath:(NSIndexPath *)indexPath forDragTableViewController:(ASReorderTableViewController *)dragTableViewController;

@required
/*******
 *
 *	-addDraggableIndicatorsToCell:forIndexPath and -removeDraggableIndicatorsFromCell: are guaranteed to be called.
 *	-hideDraggableIndicatorsOfCell: is usually called, but might not be.
 *
 *	These work in tandem, so if your subclass overrides any of them it should override the others as well.
 *
 *******/

//	Customize cell to appear draggable. Will be called inside an animation block.
//	Cell will have highlighted set to YES, animated NO. (changes are to the selectedBackgroundView if it exists)
- (void)dragTableViewController:(ASReorderTableViewController *)dragTableViewController addDraggableIndicatorsToCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
//	You should set alpha of adjustments to 0 and similar. Will be called inside an animation block.
//	This should make the cell look like a normal cell, but is not expected to actually be one.
- (void)dragTableViewController:(ASReorderTableViewController *)dragTableViewController hideDraggableIndicatorsOfCell:(UITableViewCell *)cell;
//	Removes all adjustments to prepare cell for reuse. Will not be animated.
//	-hideDraggableIndicatorsOfCell: will probably be called before this, but not necessarily.
- (void)dragTableViewController:(ASReorderTableViewController *)dragTableViewController removeDraggableIndicatorsFromCell:(UITableViewCell *)cell;

@end


@interface ASReorderTableViewController : UITableViewController <UIGestureRecognizerDelegate, ASReorderTableViewControllerDraggableIndicators>  {
@protected
	UIPanGestureRecognizer *dragGestureRecognizer;
	UILongPressGestureRecognizer *longPressGestureRecognizer;
}

// default is YES. Removes or adds gesture recognizers to self.tableView.
@property (nonatomic, assign, getter=isReorderingEnabled) BOOL reorderingEnabled;

- (BOOL)isDraggingCell;

@property (nonatomic, weak) id<ASReorderTableViewControllerDelegate> dragDelegate; // nil by default
@property (nonatomic, weak) id<ASReorderTableViewControllerDraggableIndicators> indicatorDelegate; // self by default

@end

NS_ASSUME_NONNULL_END
