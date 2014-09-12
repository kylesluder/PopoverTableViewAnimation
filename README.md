UITableView should disable implicit animations when adding cells and resizing
===

In our apps, we frequently present popovers with navigation controllers that contain UITableViews. We resize those popovers to fit the table views. If this causes the table view's frame to grow, it might need to dequeue and add more cells.

It apparently doesn't disable animations while doing this, which results in the contents of cells animating in very weird ways as they perform their initial layout pass while the table view resizes to reveal them. (The same thing also applies to the vertical scroller.)


Steps to Reproduce 
---

1. Build and run the attached demo app.

2. Tap the button to show a popover.

3. Tap the table view row to push on a new view controller.


Expected Results
---

Rows in the table view are revealed without bad animations.


Actual Results
---

The vertical scroller and the second row's disclosure indicator get zooming animations applied to them.


Configuration
---

Built with Xcode 5.1.1 against the iOS 7 SDK, running on iPad 4


Version & Build
---

iOS 8.0 GM (12A365)


Additional Notes
---

Investigation reveals that the animations are added in an Auto Layout call stack ultimately triggered by -setFrame:. Ideally the cells would be laid out without animation prior to being revealed by the table view's own frame animation.

My current workaround involves overriding -setFrame: to wrap the call to super in a +[UIView performWithoutAnimations:] block, but that results in the table view's frame not being animated. Lesser of two evils.