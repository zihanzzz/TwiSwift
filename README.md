# Project 3 - *TwitterLite*

**TwitterLite** is a basic twitter app to read and compose tweets from the [Twitter API](https://apps.twitter.com/).

Time spent: **24+** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign in using OAuth login flow.
- [x] User can view last 20 tweets from their home timeline.
- [x] The current signed in user will be persisted across restarts.
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [x] User can pull to refresh.
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.

The following **optional** features are implemented:

- [x] When composing, you should have a countdown in the upper right for the tweet limit.
- [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] Retweeting and favoriting should increment the retweet and favorite count.
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [x] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

The following **additional** features are implemented:

- [x] 0. Use **Stack View** to implement the retweet related views at the top of each TweetCell which matches the real Twitter App behaviors.
- [x] 1. Improve user experience by adding **animation effects** (CGAffineTransform) on retweet and favorite button. Retweet and favorite button will change to green and red, respectively.
- [x] 2. The above mentioned color change will be dismissed in the event of a network failure. Buttons will **fall back** to their original color.
- [x] 3. **Customized images** on UINavigationItem and UIBarButtonItem
- [x] 4. Support **Force Touch "Peek and Pop"** on TweetCells.
    - [x] 4.1 3D Touch TweetCell and see a **preview** of the Tweet.
    - [x] 4.2 Swipe up for the following options:
        - [x] i. App switch to the real Twitter App and **deep-link** into the corresponding tweet author.
        - [x] ii. **Delete** the app in the event of seeing an own tweet by the current signed in user.
    - [x] 4.3 Keep going on Force Touch and eventually enter the Tweet's detail page.
- [x] 5. Users can see retweet and favorite count change **as** they perform the corresponding actions. "RETWEETS" and "FAVORITES" will be in their singular forms in the event of their counts being one (The real Twitter app actually does this).
- [x] 6. Tapping on retweet will show the user a prompt with message "Retweet". In the event of an already retweeted tweet, user will see "Undo Retweet".
- [x] 7. **Smooth** UI/UX on the new tweet composing page that highly matches the real Twitter App:
    - [x] 7.1 Current user's avatar on LeftBarButtonItem.
    - [x] 7.2 Displaying placeholder (implemented using a UILabel overlay).
    - [x] 7.3 Customized inputAccessoryView that displays:
        - [x] i. Real time remaining characters count with color changing to red when <= 20.
        - [x] ii. Real time adapting Tweet button that will only show blue when remaining count is within [0, 139].
- [x] 8. Upon finishing composing a new tweet or a new reply, tweet will immediately show without pulling to refresh.
- [x] 9. Upon finishing deleting a tweet, tweet will immediately disappear wihtout pulling to refresh.
- [x] 10.**Real app feeling** login screen:
    - [x] 10.1 UIPageControl implementation that allows the user to swipe and see the techonologies being used by this app.
    - [x] 10.2 Open a Safari page to the Twitter account creation page if the user does not already have a twitter account.
    - [x] 10.3 Display an alert in the event of OAuth authentication **failure** (the videos only talked about the happy flow).
- [x] 11. In the event of the user hitting Twitter's [Rate Limits](https://dev.twitter.com/rest/public/rate-limiting), user can sign out and re-authenticate to a **different** pair of **pre-loaded** consumer key and consumer secret.
- [x] 12. Real Twitter app icon.


Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. **Code Reuse**. I am using the same TweetCell class for my timeline and detail page. Not sure if this is best practice. I'm even using the same TweetCell for the third row of my detail page (just retweet, favorite and reply buttons). Not sure if this is best practice as well. However the good thing about it is that I don't need to re-write all the actions and animations of these buttons.
2. **Keychain Sharing**. For the entirety of this project I have been building it on my physical device. I did not use Keychain Sharing at all and everything just worked. For some post requests which I got 403 responses, I was able to see the details using Charles Proxy and found out the reason (same tweet text as the previous tweet).

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/link/to/your/gif/file.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

1. **Auto Layout**. I encountered a bug where I mistakenly used the built-in textView property of a UITableViewCell. It took me a couple of hours.
2. **Reuse Code**. The code base is still very messy. If I have more time I could have done a lot of more code refactorings.

## Open-Source Libraries
- [AFNetworking](https://github.com/AFNetworking/AFNetworking) A delightful networking framework for iOS, OS X, watchOS, and tvOS
- [Alamofire](https://github.com/Alamofire/Alamofire) Elegant HTTP Networking in Swift
- [BDBOAuth1Manager](https://github.com/bdbergeron/BDBOAuth1Manager) OAuth 1.0a library for AFNetworking 2.x
- [SwiftDate](http://malcommac.github.io/SwiftDate/) The best way to manage Dates and Timezones in Swift

## Acknowledgements
- [FLATICON](http://www.flaticon.com/) The largest database of free icons available in PNG, SVG, EPS, PSD and BASE 64 formats

## License

    Copyright [2016] [James Zhou]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.