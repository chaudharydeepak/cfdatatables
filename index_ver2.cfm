<!DOCTYPE html>
<html>
   <head>
      <title></title>
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <meta http-equiv="x-ua-compatible" content="ie=edge">
      <link rel="stylesheet" type="text/css" href="assets/css/bootstrap.min.css">
      <link rel="stylesheet" type="text/css" href="assets/css/dataTables.bootstrap4.min.css">
      <script type="text/javascript" src="assets/js/jquery-3.2.1.min.js"></script>
   </head>
   <cfparam name="responsible_area" default="All">
   <body>
      <cfquery datasource="LocalDB" name="getCurrency">
         SELECT  * FROM app.cf_currency_table
      </cfquery>
      <div class="container">
         <div class="row">
            <div class="col-md-12">
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
            </div>
            <div class="col-md-12">
               <table class="table table-striped table-bordered table-hovered" id="displayData">
               </table>
            </div>
         </div>
      </div>
      <script type="text/javascript">
         $(function(){

           var globalVars = {
               tableConfigs: null,
               tableId:$('table#displayData')
           }

           var main = {
               register: function(){
                 main.UI.register.apply();
                 main.EVENTS.register.apply();
               },
               UI: {
                 register: function(){
                   main.UI.buildTable.apply();
                 },
                 buildTable: function(){
                   globalVars.tableConfigs = globalVars.tableId.dataTable( {
                       "bProcessing": true,
                       "bServerSide": true,
                       "sAjaxSource": 'cfc/a.cfc?method=dataTable&selectdata='+$("#responsible_area").val(),
                       columns:
                               [   { title:'First Name',name:"first_name" },
                                   { title:'Last Name',name:"last_name" },
                                   { title:'IP Address',name:"ip_address" },
                                   { title:'Email Address',name:"email" },
                                   { title:'Currency',name:"currency" },
                                   {
                                         title: "Action",
                                         orderable: false,
                                         data: null,
                                         class: "dt-head-center",
                                         defaultContent: [
                                             "<center>",
                                             "<div class=\"btn-group\">",
                                             "<button title=\"Select Detail Data\" type=\"button\" data-tag=\"pilih\" class=\"btn btn-info btn-sm\">&nbsp<i class='glyphicon glyphicon-ok'></i></button>",
                                             "</div>",
                                             "</center>"
                                         ].join(""),
                                         width: "150px"
                                     }
                               ]
                   });
                 }
               },
               ROUTINES: {
                 register: function(){
                   main.ROUTINES.getSelectedRow.apply();
                 },
                 getSelectedRow: function(obj){
                   return {
                             index : $(obj).closest('tr').index(),
                             data: globalVars.tableId.dataTable().fnGetData($(obj).closest('tr').index())
                           }
                 }
               },
               EVENTS: {
                 register: function(){
                   main.EVENTS.eventButtonRow.apply();
                 },
                 eventButtonRow: function(){
                   globalVars.tableId
                           .on('preXhr.dt', function(e, setting, data) {
                             console.log(data);
                           })
                           .on('xhr.dt', function(e, setting, data) {
                           })
                           .on('draw.dt', function() {
                               main.EVENTS.gridBtnTable.apply();
                           });
                 },
                 gridBtnTable: function(){
                   var oBtn = $('button[data-tag="pilih"]');
                       oBtn.unbind().bind('click',function(){
                         var that = $(this).attr('data-tag');
                           if(that=='pilih'){
                             var data = main.ROUTINES.getSelectedRow($(this));
                             console.log(data); //GET POSITION ID DATA AND ALL DATA
                             console.log(data.data[1]); //SEPCIFIK DATA YOU CHICE
                           }
                       });
                 }
               }
           } //END MAIN

           main.register.apply();
         });
      </script>
      <script type="text/javascript" src="assets/js/bootstrap.min.js"></script>
      <script type="text/javascript" src="assets/js/jquery.dataTables.min.js"></script>
      <script type="text/javascript" src="assets/js/dataTables.bootstrap4.min.js"></script>
   </body>
</html>
