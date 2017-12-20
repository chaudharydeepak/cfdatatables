<cfparam name="responsible_area" default="All">
<cfquery datasource="LocalDB" name="getCurrency">
   SELECT  *
   FROM app.cf_currency_table
</cfquery>
<cfquery datasource="LocalDB" name="getUserData">
   SELECT  * from app.cf_mock_data
   <cfif responsible_area neq 'All'>
      where "currency" =
      <cfqueryparam  cfsqltype="CF_SQL_VARCHAR" value="#responsible_area#" />
   </cfif>
</cfquery>
<cfif structKeyExists(FORM, "submit")>
<cfset selectedName = "#getCurrency.currency#">
</cfif>
<!DOCTYPE html>
<html>
   <head>
      <title>DataTable from DB</title>
      <meta charset="UTF-8">
      <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
      <meta http-equiv="Content-type" content="text/html; charset=utf-8">
      <meta name="viewport" content="width=device-width,initial-scale=1">
      <script type="text/javascript" language="javascript" src="assets/js/jquery-3.2.1.min.js"></script>
      <script type="text/javascript" language="javascript" src="assets/js/jquery.dataTables.min.js"></script>
      <link rel="stylesheet" type="text/css" href="assets/css/jquery.dataTables.min.css">
      <script type="text/javascript" class="init">
         $(document).ready(function() {
           $('#example').DataTable( {
           "paging": true,
               "order": [[ 0, "asc" ]],
               "aLengthMenu": [[10,25, 50, 75,100, -1], [10,25, 50, 75,100, "All"]],
               "bPaginate": false, //hide pagination
           //"bFilter": t, //hide Search bar
           "bInfo": false, // hide showing entries
           "pageLength": 100,
           "pagingType": "full_numbers"
         } );
         } );
      </script>
      <style>
         th { font-size: 12px; font-family:Arial;}
         td { font-size: 12px; font-family:Arial; }
         html *
         {
         font-family: Arial !important;
         }
         .name-label2 { margin-left:14px;
         font-family: Arial;
         font-size: 14px;
         }
         .dataTables_info {
         clear: both;
         float: left;
         padding-top: 0.755em;
         }
         .dataTables_paginate {
         float: right;
         text-align: right;
         padding-top: 0.25em;
         }
         .error {
         color:red;
         font-style:italic;
         }
      </style>
   </head>
   <body class="wide comments example dt-example-jqueryui">
      <br>
      <div class="container" >
         <cfoutput>
            <h5>Total Records: #getUserData.RecordCount# </h5>
         </cfoutput>
         <hr/>
         <cfoutput>
            <form method="post" class="form-horizontal" action="#cgi.script_name#" id="ExceptionForm">
               <div class="form-group">
                  <label class="control-label col-sm-2 formLeft" for="responsible_area">Currencies:</label>
                  <div class="col-sm-3">
                     <select name="responsible_area" class="form-control" id="responsible_area" data-error="##errNm1">
                        <option
                        <cfif responsible_area eq 'All'>selected="selected"</cfif>
                        >All</option>
                        <cfloop query="getCurrency">
                           <option value="#currency#" <cfif #responsible_area# eq '#Currency#'>selected="selected"</cfif> >#Currency#</option>
                        </cfloop>
                     </select>
                  </div>
                  <div class="col-sm-1">
                     <input type="submit" name="submitButton" class="btn btn-info  btn-md" id="validate" value="Submit" />
                  </div>
               </div>
            </form>
         </cfoutput>
         <hr/>
         <table id="example" class="display" cellspacing="1" width="100%">
            <thead>
               <tr>
                  <th>id#</th>
                  <th>First Name</th>
                  <th>Last Name</th>
                  <th>ip address</th>
                  <th>email</th>
                  <th>currency</th>
               </tr>
            </thead>
            <tbody>
               <cfoutput query="getUserData" >
                  <tr>
                     <td>#id#</td>
                     <td>#first_name#</td>
                     <td>#last_name#</td>
                     <td>#ip_address#</td>
                     <td>#email#</td>
                     <td>#currency#</td>
                  </tr>
               </cfoutput>
            </tbody>
         </table>
      </div>
   </body>
</html>
