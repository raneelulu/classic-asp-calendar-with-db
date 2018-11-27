# Calendar application with Database in classic ASP

#### based on fullcalendar(javascript): https://fullcalendar.io/
---
## The way application works

### calendar page (calendar.asp)

![image](https://user-images.githubusercontent.com/39694718/49067826-74820a00-f268-11e8-9de6-86ca4df3be82.png)

#### calendar page's flow chart 

![1](https://user-images.githubusercontent.com/39694718/49065812-7d6fdd00-f262-11e8-8620-fb00e8b3afd3.jpg)
---



### embedded page (calendar_event.asp)

calendar_event.asp is used with base page that include calendar_event.asp

Base page must have start date notified as syear, smonth, sday and end date notified as eyear, emonth, eday.

>base page (example)
``` html
<!--#include file="calendar_event.asp-->
    <form id="searchform" name="searchform" method="get">
        <input type="number" name="syear">
        <input type="number" name="smonth">
        <input type="number" name="sday">		
        <input type="number" name="eyear">
        <input type="number" name="emonth">
        <input type="number" name="eday">
    </form>
```
The calendar.asp file reads the base page's start date and end date.
Every event stored in database between this time period is collected and stored in object array. If the base page has datetime contents that match events' datetime, all of them is marked orange by javascript. Also, if you click on these marked datetime, you will get a popup content like below.

<img width="308" alt="2018-11-27 5 06 29" src="https://user-images.githubusercontent.com/39694718/49067387-4cde7200-f267-11e8-8110-2bbc02c11145.png">

#### calendar_event.asp file's flow chart 
![2](https://user-images.githubusercontent.com/39694718/49065821-86f94500-f262-11e8-9afc-29f91c25da9b.jpg)

