let calendarEvent =     {
    calendarRender : function(calendarList, viewType)   {
        $('#fullcalendar')
        .fullCalendar({
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month, listMonth'
            },
            buttonText:  {
                today: 'Today',
                month: 'Calendar',
                listMonth: 'List'
            },
            fixedWeekCount: false,
            defaultView: viewType,
            defaultDate: new Date(),
            editable: false,
            eventLimit: true,
            timeFormat: 'H:mm',
            displayEventTime: true,
            shorttime: true,
            firstDay: 0, //start day [Monday : 1]
            dayNames: ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'],
            dayNamesShort: ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'],
            listDayFormat: 'YYYY.MM.DD',
            views:  {
                month:  {
                    titleFormat: 'YYYY.MM',
                    eventLimit: 4
                }
            },
            eventClick: function(calEvent, jsEvent, view)  {
                jsEvent.preventDefault();
                wrapWindowByMask();        
                calendarEvent.calendarEdit(calEvent);
            },
            dayClick:   function(date, jsEvent, view)   {
                jsEvent.preventDefault();
                wrapWindowByMask();
                calendarEvent.calendarAdd(date["_d"]);
            },
            events: function (start, end, timezone, callback) {
                var params = 'check=init'
                $.ajax({
                    url: '/editEvent.asp',
                    type: 'get',
                    data: params,
                    success: function(response) {  
                        var doc = JSON.parse(response);
                        var events = [];
                        var color = '#ffffff';
                        if (doc != undefined && doc.length > 0) {
                            $(doc).each(function (key, Obj) {
                                if(Obj.id==null)  return true;
                                if(Obj.team=="pd")   {
                                    color = '#1387dc';
                                }
                                else if(Obj.team="mkt") {
                                    color = '#8713dc';
                                }
                                events.push({
                                    id: Obj.id, 
                                    title: Obj.title.replace(/<br>/gi, "\n"),
                                    start: Obj.start,
                                    end: Obj.end,
                                    myid: Obj.myid,
                                    team: Obj.team,
                                    tag: Obj.tag,
                                    className: Obj.tag,
                                    backgroundColor: color
                                });
                            });
                        }
                        callback(events);
                    },
                    error: function (err) {
                        alert('Error in fetching data');
                        console.log(err);
                    }
                });
            },
        })
    },
    calendarAdd: function (date)  {
        makingBox(date, null, "add");
    },
    calendarEdit:   function(calEvent)    {
        makingBox(null, calEvent, "edit")
    },
    calendarAddField:   function(date)    {
        $('.title-text').html("Add event");
        $('.left-button').removeClass("delete");
        $('#add-calendar-title').val("");
        $(".team option").prop("selected", false);
        $(".tag-select option").prop("selected", false);
        $(".team option[value='']").prop("selected", true);
        $(".tag-select option[value='none']").prop("selected", true);
        let month;
        let day;
        if (date.getMonth() < 9) {
            month = '0' + (date.getMonth()+1);
        }
        else {
            month = date.getMonth() + 1;
        }
        if (date.getDate() <= 9) {
            day = '0' + date.getDate();
        }
        else {
            day= date.getDate();
        }
        setTimeout(function() {
            $('#datetimepicker1').datetimepicker({  
                format: 'yyyy-MM-dd hh:mm',
                maskInput: true,
                pickSeconds: false
            });
            $('.date-start').val(date.getFullYear() + "-" + month + "-" + day + " 00:00");  
            let picker1 = $('#datetimepicker1').data('datetimepicker');
            picker1.setLocalDate(new Date($('.date-start').val()));  

            $('#datetimepicker2').datetimepicker({  
                format: 'yyyy-MM-dd hh:mm',
                maskInput: true,
                pickSeconds: false
            });
            $('.date-end').val(date.getFullYear() + "-" + month + "-" + day + " 23:59");
            let picker2 = $('#datetimepicker2').data('datetimepicker');
            picker2.setLocalDate(new Date($('.date-end').val()));  
        },50);
        $('.left-button')
            .html("Cancel")
            .off().on('click', function()  {
                $('.calendar-popup').hide();
                $('#mask').hide();  
            })
        $('.right-button')
            .html("Add")
            .off().on('click', function()  {
                let inputTitle = $('#add-calendar-title').val().replace(/\n/gi,"<br>");
                let inputStart = $('.date-start').val();
                let inputEnd = $('.date-end').val();
                var myid = $('.myid').val();
                var team = $(".team option:selected").val();
                var tag = $(".tag-select option:selected").val();
                if(inputTitle=="")  {
                    alert("Please write your event");
                    return;
                }
                else if(inputStart > inputEnd) {
                    alert("Please check the start and end dates");
                    return;
                }
                else if(team=="") {
                    alert("Please select your team");
                    return;
                }
                else {
                    params = "check=add&title=" + inputTitle + "&start=" +inputStart + "&end=" + inputEnd  + "&myid=" + myid + "&team=" + team + "&tag=" + tag 
                    $.ajax({
                        url: '/editEvent.asp',
                        type: 'get',
                        data: params,
                        success: function(response) {                            
                            setTimeout(function()  {
                                $('#fullcalendar').fullCalendar( 'refetchEvents' );
                            }, 700);                            
                            console.log(response);
                            alert("Event Added");
                        },
                        error:function(err)   {
                            console.log(err);
                            alert("Error");
                        }
                    })
                }
                $('.calendar-popup').hide();
                $('#mask').hide();  
            })
    },
    calendarEditField : function(calEvent) {
        $('.title-text').html("Edit event");
        $('.left-button').addClass("delete");
        $('#add-calendar-title').val(calEvent.title);
        $(".team option").prop("selected", false);
        $(".tag-select option").prop("selected", false);
        $(".team option[value="+calEvent.team+"]").prop("selected", true);
        $(".tag-select option[value="+calEvent.tag+"]").prop("selected", true);
        setTimeout(function() {
            $('#datetimepicker1').datetimepicker({  
                format: 'yyyy-MM-dd hh:mm',
                maskInput: true,
                pickSeconds: false
            });
            $('.date-start').val(calEvent.start["_i"]);      
            let picker1 = $('#datetimepicker1').data('datetimepicker');
            picker1.setLocalDate(new Date($('.date-start').val()));  
              
            $('#datetimepicker2').datetimepicker({  
                format: 'yyyy-MM-dd hh:mm',
                maskInput: true,
                pickSeconds: false
            });
            $('.date-end').val(calEvent.end?calEvent.end["_i"]:calEvent.start["_i"]);
            let picker2 = $('#datetimepicker2').data('datetimepicker');
            picker2.setLocalDate(new Date($('.date-end').val()));
        },50);
        $('.left-button')
            .html("Delete")
            .off().on('click', function()  {
                var myid = $('.myid').val();
                if(calEvent.myid == myid)   {
                    var tid = calEvent.id;
                    params = "check=del&id=" + tid
                    $.ajax({
                        url: '/editEvent.asp',
                        type: 'get',
                        data: params,
                        success: function(response) {
                            setTimeout(function()  {
                                $('#fullcalendar').fullCalendar( 'refetchEvents' );
                            }, 700);                        
                            console.log(response);
                            alert("Event deleted");
                        },
                        error: function(err)    {
                            console.log(err);
                            alert("Error");
                        }
                    })
                    $('.calendar-popup').hide();
                    $('#mask').hide();  
                }
                else    {
                    alert("You can delete your own schedule");
                    $('.calendar-popup').hide();
                    $('#mask').hide();  
                }
            })
        $('.right-button')
            .html("Edit")
            .off().on('click', function()  {
                let inputTitle = $('#add-calendar-title').val().replace(/\n/gi,"<br>");
                let inputStart = $('.date-start').val();
                let inputEnd = $('.date-end').val();
                var tid = calEvent.id;
                var myid = $('.myid').val();
                var team = $(".team option:selected").val();
                var tag = $(".tag-select option:selected").val();
                if(calEvent.myid != myid)    {
                    alert("You can edit your own schedule");
                    $('.calendar-popup').hide();
                    $('#mask').hide();  
                    return;
                }
                else if(inputTitle=="")  {
                    alert("Please write your event");
                    return;
                }
                else if(inputStart > inputEnd) {
                    alert("Please check the start and end dates");
                    return;
                }
                else if(team=="") {
                    alert("Please select your team");
                    return;
                }
                else {
                    params = "check=edit&id=" + tid + "&title=" + inputTitle + "&start=" +inputStart + "&end=" + inputEnd  + "&team=" + team  + "&tag=" + tag
                    $.ajax({
                        url: '/editEvent.asp',
                        type: 'get',
                        data: params,
                        success: function(response) {
                            setTimeout(function()  {
                                $('#fullcalendar').fullCalendar( 'refetchEvents' );
                            }, 700);
                            console.log(response);
                            alert("Event edited");
                        },
                        error:function(err)   {
                            alert("Error");
                            console.log(err);
                        }
                    })
                }
                $('.calendar-popup').hide();
                $('#mask').hide();  
            })
    }
}
calendarEvent.calendarRender(null, 'month');
let makingBox = function(date, calEvent, target)  {
    if(target=="add")   {
        calendarEvent.calendarAddField(date);
    }
    else if(target=="edit") {
        calendarEvent.calendarEditField(calEvent);
    }
    $('.calendar-popup').css({
        display: "none"
    }).fadeIn();
}
$('.x-btn').off().on('click', function()    {
    $('.calendar-popup').hide();
    $('#mask').hide();  
})
function wrapWindowByMask(){
    var maskHeight = $(document).height();  
    var maskWidth = $(window).width();  
    $('#mask').css({'width':maskWidth,'height':maskHeight});  
    $('#mask').fadeIn(200);      
    $('#mask').fadeTo("slow",0.8);    
}
$(document).ready(function(){
    $('#mask').click(function () {
        $(this).hide();  
        $('.calendar-popup').hide();  
    });      
    $('#mask').one('touchstart', function () {  
        $(this).unbind('click');
    });
});