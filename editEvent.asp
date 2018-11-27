<!--#include file="include/func.asp"-->
<!--#include file="include/JSON_2.0.4.asp"-->
<%
      check = checkvalue(1,request("check"))
      If check = "init" Then
            dim arr()
            redim arr(-1)
            i = 0
            sql = "select * from calendar"
            Set Grs = rootdb.execute(sql)
            Do Until Grs.EOF
                  ReDim Preserve arr(UBound(arr) + 1)
                  set rows = jsObject()
                  rows("id") = Grs("id")
                  rows("title") = Grs("title")
                  rows("start") = Dateformat(Grs("start_date"),"D")
                  rows("end") = Dateformat(Grs("end_date"),"D")
                  rows("myid") = Grs("myid")
                  rows("team") = Grs("team")
                  rows("tag") = Grs("tag")
                  set arr(i) = rows
                  i = i + 1
                  Grs.movenext
            Loop
            Grs.close
            response.write toJSON(arr)
            response.end
			
      ElseIf check = "add" Then
            title = checkvalue(1,request("title"))
            start_date = checkvalue(1,request("start"))
            end_date = checkvalue(1,request("end"))
            myid = checkvalue(1,request("myid"))
            team = checkvalue(1,request("team"))
            tag = checkvalue(1,request("tag"))

            sql = "insert into calendar(title,start_date,end_date,myid,team,tag) values('" & title & "', '" & start_date & "', '" & end_date & "', '" & myid & "', '" & team & "', '" & tag & "')"
		rootdb.execute(sql)

      ElseIf check = "edit" Then
            id = CInt(checkvalue(1,request("id")))
            title = checkvalue(1,request("title"))
            start_date = checkvalue(1,request("start"))
            end_date = checkvalue(1,request("end"))
            team = checkvalue(1,request("team"))
            tag = checkvalue(1,request("tag"))

            sql = "update calendar set title='" & title & "', start_date='" & start_date & "', end_date='" & end_date & "', team='" & team & "', tag='" & tag & "' where id=" & id
            rootdb.execute(sql)

      ElseIf check = "del" Then
            id = CInt(checkvalue(1,request("id")))
          
            sql = "delete from calendar where id=" & id
            rootdb.execute(sql)

      End If
      
      response.write sql
      response.end
%>