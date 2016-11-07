# Project 4 - *TwitterLite*

**TwitterLite** is a basic twitter app to read and compose tweets from the [Twitter API](https://apps.twitter.com/).

This is a continuation of a previous work.
For details, please refer to **[here](README_previous.md)**.

Time spent: **20** hours spent in total (not including the first part of this assignment)

## User Stories

The following **required** functionality is completed:

- [x] Hamburger menu
   - [x] Dragging anywhere in the view should reveal the menu.
   - [x] The menu should include links to your profile, the home timeline, and the mentions view.
   - [x] The menu can look similar to the example or feel free to take liberty with the UI.
- [x] Profile page
   - [x] Contains the user header view
   - [x] Contains a section with the users basic stats: # tweets, # following, # followers
- [x] Home Timelines
   - [x] Tapping on a user image should bring up that user's profile page

The following **optional** features are implemented:

- [x] Profile Page
   - [ ] Implement the paging view for the user description.
   - [ ] As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
   - [x] Pulling down the profile page should blur and resize the header image.
- [x] Account switching
   - [ ] Long press on tab bar to bring up Account view with animation
   - [ ] Tap account to switch to
   - [ ] Include a plus button to Add an Account
   - [x] Swipe to delete an account

The following **additional** features are implemented:

- [x] 0. Hamburger menu UI/UX optimization.
  - [x] 0.1 While hamburger menu is open, the content view controller is disabled with the exception of being able to receive tap to close hamburger menu.
  - [x] 0.2 While hamburger menu is closed, user can swipe right and right only.
  - [x] 0.3 Tap on the hamburger icon to open and close hamburger menu.
  - [x] 0.4 Display app version and app bundle at the bottom of hamburger menu.
- [x] 1. Real Twitter app feel Profile page thanks to this **[post](http://developerdean.com/create-twitter-ios-app-user-interface/)**.
  - [x] 1.1 Set up scrolling between UI components using the code base mentioned above.
  - [x] 1.2 Add user description, user location, user url, # of tweets, # of following and # of followers (friendly counts like 1.5K or 8.2M).
  - [x] 1.3 Segmented control to switch between user tweets and user favorites.
  - [x] 1.4 Hide navigation bar upon entering Profile page and un-hide it upon leaving.
  - [x] 1.5 **Follow** and **Unfollow** user.
- [x] 2. Settings Page.
  - [x] 2.1 Show currently logged in user.
  - [x] 2.2 Swipe left to log out user.
  - [x] 2.3 Developer information.
  - [x] 2.4 One tap to log out of all authenticated users.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

  1. I am still not comfortable working with xib files to re-use UI components. Maybe next time I will start from xib instead of Storyboard. This time in order to avoid wasting time, I just copied and pasted my TweetCell from Storyboard to another ViewController, which is clearly not the best practice here.

  2. How to implement multiple Twitter users exactly?

  3. Learned how to set up Objectice-C bridging header files.


## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://github.com/zihanzzz/TwitterLite/blob/master/TwitterLiteDemo_2.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

1. **Code Reuse**. I could spend 6 hours just sitting here refactoring my entire code base which is really messy at this point.
2. **UIView dynamic height**. I was not able to dynamically adjust a UIView's height just like that of a UITableViewCell.

## Open-Source Libraries
- [AFNetworking](https://github.com/AFNetworking/AFNetworking) A delightful networking framework for iOS, OS X, watchOS, and tvOS
- [Alamofire](https://github.com/Alamofire/Alamofire) Elegant HTTP Networking in Swift
- [BDBOAuth1Manager](https://github.com/bdbergeron/BDBOAuth1Manager) OAuth 1.0a library for AFNetworking 2.x
- [SwiftDate](http://malcommac.github.io/SwiftDate/) The best way to manage Dates and Timezones in Swift
- [FXBlurView](https://github.com/nicklockwood/FXBlurView)

## Acknowledgements
- [FLATICON](http://www.flaticon.com/) The largest database of free icons available in PNG, SVG, EPS, PSD and BASE 64 formats
- [Blog post](http://developerdean.com/create-twitter-ios-app-user-interface/) A tutorial on how to implement the real Twitter app's Profile page.

## License

    Copyright [2016] [James Zhou](http://www.jameszzhou.com/)

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.