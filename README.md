# UserActivity
User Activity App

This is an assigment application for one of the companies. 
It was created accordingly to these requirements:

Your task is to write a simple app that’s going to show summary of sport activities performed bya user.

Requirements

User should be able to login and logout from the app. You can use standard Parse SDK controlsfor this.
After successful login, the user is presented with the main view of the app. The app shoulddisplay 
linear progress indicator while the data is being loaded and the core contents of theview should be 
eased into with a smooth transition. The main view should contain a donut­shaped chart (see URL) 
presenting a summary of activities, a user picture inside the chart and a list of activity entries
at the bottom of the view.

The chart summarises the total amount of time current user devoted to particular activities (e.g.
red is running, green is cycling etc.). The component should be written from scratch, without the 
use of external libraries.

Data on the backend is represented as startsAt, endsAt and type. Assume that data is correct ­without 
overlaps. For the backend use https://parse.com, but make the implementation generic with an assumption 
that the backend can change in the future. You can fill all data in Parse using a developer console 
(users and activity) – it’s very simple.

Whole app (maybe besides login view) should be presented on one screen, without any navigation or 
modal views. Use progress indicators where applicable.

Bonus points

● Allow for selecting a day or a date range from which the data should be shown.
● Animate the chart when a new data is loaded or, in the context of the above point, user changes the date.
● Add an activity type caption near each category shown in the chart.

Closing remarks

Remember: quality over quantity. We’re going to focus on your solutions, code quality and
readability more than on how polished the UI is (but it'll be nice if it’s not going to be very ugly).
Commit your code to a repository as often as you think is necessary.
If something is not clear, or you have any questions, feel free to ask. Good luck!
