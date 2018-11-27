    <div class='event-popup' style="display:none">
		<div class='today-date'>2018-06-18</div>
		<div class='x-btn'></div>
		<div id='events'>
			<div class='inner-box' >
				<div class='popup-contents left'>Team</div>
				<div class='popup-contents right'>2018-06-28&nbsp;~&nbsp;2018-06-28</div>
				<div class='popup-contents right'>Contents</div>
			</div>
		</div>
	</div>
<script type="text/javascript" src="lib/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src='lib/jquery.cookie.js'></script>
<script type="text/javascript" src="lib/jquery-ui-1.10.4.custom.js"></script>
<script language="javascript">
	var arrEvent = new Array();
	var time_flag = false;
	var inputStart, inputEnd;
	$('.x-btn').off().on('click touchend', function()    {
		$('.event-popup').hide();
	})
	$(function()	{
		var year, month, day;
		if(document.searchform.syear)   year = document.searchform.syear.value
		else if(document.searchform.s_year)   year = document.searchform.s_year.value
		if(document.searchform.smonth)   month = document.searchform.smonth.value
		else if(document.searchform.s_month)   month = document.searchform.s_month.value
		if(document.searchform.sday)   day = document.searchform.sday.value
		else if(document.searchform.s_day)   day = document.searchform.s_day.value
		if(month.length<2)	{	month = '0' + month	}
		if(day.length<2)	{	day = '0' + day	}
		inputStart = year + '-' + month + '-' + day
		
		if(document.searchform.eyear)   year = document.searchform.eyear.value
		else if(document.searchform.e_year)   year = document.searchform.e_year.value
		if(document.searchform.emonth)   month = document.searchform.emonth.value
		else if(document.searchform.e_month)   month = document.searchform.e_month.value
		if(document.searchform.eday)   day = document.searchform.eday.value
		else if(document.searchform.e_day)   day = document.searchform.e_day.value
		else	time_flag = true;
		if(month.length<2)	{	month = '0' + month	}
		if(day.length<2)	{	day = '0' + day	}
		inputEnd = year + '-' + month + '-' + day

		inputStart += ' 00:00';
		inputEnd += ' 23:59';

		$.getJSON('/editEvent.asp?check=init', function(data)	{
			var i = 0;
			$.each(data, function(index, value)	{
				if(value.id==null)	return true;
				else	{
					var val_start = value.start;
					var val_end = value.end;
					if(val_start<inputStart)	val_start = inputStart;
					if(inputEnd<val_end)	val_end = inputEnd;
					if(val_start<=val_end && (value.tag=='D' || value.tag=='O'))	{						
						arrEvent[i] = new Object();
						arrEvent[i].title = value.title;
						arrEvent[i].start = value.start;
						arrEvent[i].end = value.end;
						arrEvent[i].team = value.team;
						arrEvent[i].tag = value.tag;
						i++;

						if(time_flag)	{	//Hourly(yyyy-mm-dd HH:mm)
							for(var j=val_start;j<=val_end;)	{
								$('td:contains("'+j.split(' ')[1]+'")').addClass("event");
								$('td:contains("'+j.split(' ')[1]+'")').css("background","#ffe9be");

								var today = new Date(j);
								var next = new Date(today.setTime(today.getTime() + 60000));
								var yyyy = next.getFullYear();
								var mm = next.getMonth() + 1;
								var dd = next.getDate();
								var HH = next.getHours();
								var MM = next.getMinutes();
								if(mm<10)	{	mm = '0' + mm	}
								if(dd<10)	{	dd = '0' + dd	}
								if(HH<10)	{	HH = '0' + HH	}
								if(MM<10)	{	MM = '0' + MM	}
								j= yyyy + '-' + mm + '-' + dd + ' ' + HH + ':' + MM;
								console.log(j);
							}
						}
						else	{	//Date (yyyy-mm-dd)
							val_start = val_start.split(' ')[0];
							val_end = val_end.split(' ')[0];
							for(var j=val_start;j<=val_end;)	{
								$('td:contains("'+j+'")').addClass("event");
								$('td:contains("'+j+'")').css("background","#ffe9be");

								var today = new Date(j);
								var next = new Date(today.setTime(today.getTime() + 86400000));
								var yyyy = next.getFullYear();
								var mm = next.getMonth() + 1;
								var dd = next.getDate()
								if(mm<10)	{	mm = '0' + mm	}
								if(dd<10)	{	dd = '0' + dd	}
								j= yyyy + '-' + mm + '-' + dd
							}
						}
					}
				}
			});
		});
	})
	$(document).on('click touchend', ".event", function () {
		showEventPopup($(this).text(),event.pageY);
    });
	function showEventPopup(date,pageY)	{
		if(time_flag)	{
			date = inputStart.split(' ')[0] + ' ' + date;
		}
		document.getElementsByClassName('today-date')[0].innerHTML = date;
        document.getElementById("events").innerHTML = "";
		for(var i=0;i<arrEvent.length;i++)	{
			if(time_flag)	{
				var val_start = arrEvent[i].start;
				var val_end = arrEvent[i].end;
			}
			else	{
				var val_start = arrEvent[i].start.split(' ')[0];
				var val_end = arrEvent[i].end.split(' ')[0];
			}
			if(val_start<=date && date<=val_end)	{
				var div_inner = document.createElement('div');
				var div_date = document.createElement('div');
				var div_category = document.createElement('div');
				var div_title = document.createElement('div');

				div_inner.className = 'inner-box';
				div_date.className = 'popup-contents';
				div_category.className = 'popup-contents';
				div_title.className = 'popup-contents title';
				
				var team, tag;
				if(arrEvent[i].team == 'pd')	team = 'production';
				else if(arrEvent[i].team == 'mkt')	team = 'marketing';
				if(arrEvent[i].tag == 'D')	tag = 'deploy';
				else if(arrEvent[i].tag == 'O')	tag = 'obstacle';
				
				div_category.innerHTML = '(' + tag + ')&nbsp;' + team;

				var set_start;
				var set_end;
				if(date==val_start)	{
					set_start = "On the day " + arrEvent[i].start.split(' ')[1];
				}
				else	set_start = arrEvent[i].start;
				if(date==val_end)	{
					set_end = "On the day " + arrEvent[i].end.split(' ')[1];
				}
				else	set_end = arrEvent[i].end;
				if(set_start == set_end)	div_date.innerHTML = set_start;
				else	div_date.innerHTML = set_start + ' ~ ' + set_end;
				div_title.innerHTML = arrEvent[i].title

				div_inner.appendChild(div_date);
				div_inner.appendChild(div_category);
				div_inner.appendChild(div_title);
                document.getElementById("events").appendChild(div_inner);
			}
		}
		$('.event-popup').css({
			left: 100,
			top: pageY-30,
			display: "none"
        }).fadeIn();
	}
</script>
<style>
.event-popup{position:absolute;z-index:4;width:333px;padding:5px 5px 5px 5px;border:1px solid rgba(0, 0, 0, 0.1);border-radius:0.5em;font-size:14px;background:rgba(245,245,245,1);box-shadow:2px 2px 5px 0 rgba(0, 0, 0, 0.26)}
.today-date{padding:0px 0px 5px 5px}
.x-btn{display:inline-block;position:absolute;top:6px;right:5px;width:18px;height:18px;background:url(../img/btn_x_popup.png) no-repeat 0 0}
.inner-box{height:auto;padding-top:2px;border-top:1px solid #ccc} 
.popup-contents{margin:6px;font-weight:bold}
.title{margin-left:20px;font-weight:lighter}
</style>