<!--#include file="include/func.asp"-->
<!--#include file="include/top.asp"-->

	<link rel='stylesheet' href='css/fullcalendar.css' />
	<link rel="stylesheet" type="text/css" href="css/mycalendar.css">
	<link rel="stylesheet" type="text/css" href="css/bootstrap_custom.css">
	<script src='lib/jquery.min.js'></script>
	<script src='lib/moment.min.js'></script>
	<link rel="stylesheet" type="text/css" media="screen" href="http://tarruda.github.com/bootstrap-datetimepicker/assets/css/bootstrap-datetimepicker.min.css">
	<script src='js/fullcalendar.js'></script>
	
	<div id="mask"></div>
	<div id='fullcalendar'></div>
	<div class='calendar-popup'>
		<div class='popup-title'><span class='title-text'>Title</span></div>
		<div class='x-btn'></div>
		<div class='inner-box'>
			<div class='menu-row calendar-window' id='menu-row-date'>
				<div class='clock'></div>
				<div id='datetimepicker1' class='input-append date'>
					<input type="text" class="text-input date-start date-day-input add-on">
				</div>
				<div id='datetimepicker2' class='input-append date'>
					<input type="text" class="text-input date-end date-day-input add-on">
				</div>
			</div>
			<div class='menu-row'>
				<textarea class="text-input" id="add-calendar-title" wrap="hard" placeholder="Event"></textarea>
			</div>
			<div class='menu-row team-color' id='team-select'>
				<div class='team-title'><span class='menu-text'>Team</span></div>
				<select class='team'>
					<option value="">Team Select</option>
					<option value="mkt">marketing</option>
					<option value="pd">production</option>
				</select>
				<input type="hidden" class='myid' value='<%=MYID%>'>
			</div>
			<div class='menu-row tag'>
				<div class='tag-title'><span class='menu-text'>Tag</span></div>
				<select class='tag-select'>
					<option value="none">No Tag</option>
					<option value="D">Deploy</option>
					<option value="O">Obstacle</option>
					<option value="S">Scheduled</option>
					<option value="E">Etc</option>
				</select>
			</div>
		</div>
		<div class='button-box'>
			<button class='left-button'>left</button>
			<button class='right-button'>right</button>
		</div>
	</div>
<script src="js/mycalendar.js"></script>
<script type="text/javascript" src="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.2.2/js/bootstrap.min.js"></script>
<script type="text/javascript" src="http://tarruda.github.com/bootstrap-datetimepicker/assets/js/bootstrap-datetimepicker.min.js"></script>
</body>
</html>