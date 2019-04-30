# Tulo Engage Tracker - SDK iOS
Tulo Engage Tracker SDK for iOS is used for tracking events in Tulo Engage Data Platform.

![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat) ![Platform support](https://img.shields.io/badge/platform-ios-lightgrey.svg?style=flat-square)

## Installation
### Carthage

Add the following to your Cartfile:

```
github "adeprimo/tulo-engage-tracker-sdk-ios"
```

## Usage
### Setup
In order to be able to send tracking events you must import TuloEngageTracker and create an instance of it. You will need the organizationId, productId and the URL to the event service.

```Swift
let engageTracker = TuloEngageTracker(organizationId: "myorganisation", productId: "MYPRODUCT", eventUrl: URL(string: "http://user-event-service.com/api/v1/events")!)
```
Since this SDK doesn't provide an instance you can pass this instance around or add an extension to TuloEngageTracker and create a shared instance.
```Swift
extension TuloEngageTracker {
    static let shared: TuloEngageTracker = {
        let engageTracker = TuloEngageTracker(organizationId: "myorganisation", productId: "MYPRODUCT", eventUrl: URL(string: "http://user-event-service.com/api/v1/events")!)
        return engageTracker
    }()
}
```
### Logging
Tulo Engage Tracker logs errors and warnings by default. If you want to inspect what is being sent to the event service you can specify debug as the log level when setting up the script
```Swift
engageTracker.logger = DefaultLogger(minLevel: .debug)
```

### Session
A new session is started every time the app is started. If you want to start a new session, e.g. when the app enters foreground you can use the startSession function.
```Swift
func applicationWillEnterForeground(_ application: UIApplication) {
        // start a new session and track app open
        engageTracker.startSession()
        engageTracker.trackEvent(name: "app:open")
    }
```
### Opt Out
If the user of the app does not want to be tracked you can set optOut on Tulo Engage Tracker. If set, the tracker won't send any events.
```Swift
engageTracker.optOut = true
```

### Tracking
All tracking in Tulo Engage Tracker is done by sending different events. You can either use predefined or custom events. In addition to the data sent together with the event you can enrich the data by setting user and/or content data. The events are sent straight away and no queuing is implemented at the moment.

### Setting User Data
When set, the user data is always sent together with all events. User data contains the following properties: userId, paywayId, states, products, positionLon, positionLat, location. If you want to save and persist the user data properties in your app so it is available after restarting the app, you can do so by setting persist to true. To delete a property you can set it to null.
```Swift
// set user properties and save them in app
engageTracker.setData(userId: "123456", products: ["product1", "product2"], persist: true)

// delete a property and save it
engageTracker.setData(products: nil, persist: true)
```

### Setting Content Data
Content data is used to provide more data related to the article that triggers the event. When set, the content data is always sent together with all predefined events, except when sending a custom event. If you want to send content data with a custom event you can do so by using trackEventWithContentData.

It is important to always set the content data when the content changes, e.g. when an article is shown. The properties are: state, type, articleId, publishDate, title, section, keywords, authorId, articleLon, articleLat. To delete a property you can set it to null.
```Swift
// the article has loaded so set the content and send a pageview event
engageTracker.setContent(state: "open", type: "free", articleId: "123", title: "My first article", section: "News", keywords: ["news"], authorId: ["John Doe", "Jane Doe"])
engageTracker.trackPageView(url: "/news")
```
### Events
All events are prefixed with app: but if you for some reason want to specify a different prefix you can do so by setting the eventPrefix when sending the event.
#### Page Views
Tracks an app:pageview event. Input is url with optional referrer, referrerProtocol
```Swift
engageTracker.trackPageView(url: "/sports/football")
```
#### Article Events
Predefined article related events

Tracks an app:pageview event. Input is customData formatted as JSON
```Swift
engageTracker.trackArticleView(customData: "{\"category\": \"sports/football\"}")
```
Tracks an app:article.interaction of the specified type. Input type of interaction
```Swift
engageTracker.trackArticleInteraction(type: "open_image")
```
Tracks an app:article.purchase. Input is customData formatted as JSON
```Swift
engageTracker.trackArticlePurchase(customData: "{\"transaction\": {\"id\": \"abc123\",\"revenue\": \"99.90\"}}")
```
Tracks an app:activetime event. Input is startTime and endTime formatted as Date
```Swift
engageTracker.trackArticleActiveTime(startTime: Date(), endTime: Date().addingTimeInterval(TimeInterval(5.0 * 60.0)))
```
Tracks an app:article.read event. Input is customData formatted as JSON
```Swift
engageTracker.trackArticleRead(customData: "{\"category\": \"sports/football\"}")
```
#### Custom Events
Custom events can be used to track e.g. features or actions in the app

Tracks an event of type name. Input name and optional customData formatted as JSON
```Swift
engageTracker.trackEvent(name: "screenshot", customData: "{\"article\": \"123\"})
```
Tracks an event of type name and includes content data if set. Input name and optional customData formatted as JSON, url, referrer, referrerProtocol
```Swift
engageTracker.trackEventWithContentData(name: "screenshot",url: "/sports/football")
```
