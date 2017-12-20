<cfcomponent output="true">
   <cffunction name="dataTable" access="remote" format="json">
      <cfset sTableName = "app.cf_mock_data" />
      <cfset listColumns = "first_name,last_name,ip_address,email,currency" />
      <cfset sIndexColumn = "email" />
      <!--- column name to query on from dropdown on UI.--->
      <cfset sQueryOnColumn = "currency" />
      <cfset coldfusionDatasource = "LocalDB"/>
      <cfparam name="url.sEcho" default="1" type="integer" />
      <cfparam name="url.iDisplayStart" default="0" type="integer" />
      <cfparam name="url.iDisplayLength" default="10" type="integer" />
      <cfparam name="url.sSearch" default="" type="string" />
      <cfparam name="url.iSortingCols" default="0" type="integer" />
      <cfparam name="url.selectdata" default="" type="string" />
      <!--- Data set after filtering --->
      <cfquery datasource="#coldfusionDatasource#" name="qFiltered">
         SELECT #listColumns#
         FROM #sTableName#
         <cfif len(trim(url.selectdata)) && #trim(url.selectdata)# neq "All">
         WHERE #sQueryOnColumn# =
         <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#trim(url.selectdata)#" />
         <cfelse>
         WHERE 1=1
         </cfif>
         <cfif len(trim(url.sSearch))>
         AND
         <cfloop list="#listColumns#" index="thisColumn">
            <cfif thisColumn neq listFirst(listColumns)> OR </cfif>
            #thisColumn# LIKE
            <cfif thisColumn is "version">
               <!--- special case --->
               <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#val(url.sSearch)#" />
               <cfelse>
               <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="%#trim(url.sSearch)#%" />
            </cfif>
         </cfloop>
         </cfif>
         <cfif url.iSortingCols gt 0>
            ORDER BY
            <cfloop from="0" to="#url.iSortingCols-1#" index="thisS">
               <cfif thisS is not 0>, </cfif>
               #listGetAt(listColumns,(url["iSortCol_"&thisS]+1))# <cfif listFindNoCase("asc,desc",url["sSortDir_"&thisS]) gt 0>#url["sSortDir_"&thisS]#
         </cfif>
         </cfloop>
         </cfif>
      </cfquery>
      <!--- Total data set length --->
      <cfquery datasource="#coldfusionDatasource#" name="qCount">
         SELECT COUNT(#sIndexColumn#) as total
         FROM   #sTableName#
      </cfquery>
      <!---
         Output
         --->
      <cfcontent reset="Yes" />
      {"sEcho":
      <cfoutput>#val(url.sEcho)#</cfoutput>
      ,
      "iTotalRecords":
      <cfoutput>#qCount.total#</cfoutput>
      ,
      "iTotalDisplayRecords":
      <cfoutput>#qFiltered.recordCount#</cfoutput>
      ,
      "aaData": [
      <cfoutput query="qFiltered" startrow="#val(url.iDisplayStart+1)#" maxrows="#val(url.iDisplayLength)#">
         <cfif currentRow gt (url.iDisplayStart+1)>,</cfif>
         [
         <cfloop list="#listColumns#" index="thisColumn">
            <cfif thisColumn neq listFirst(listColumns)>,</cfif>
            <cfif thisColumn is "version">
               <cfif version eq 0>
                  "-"
                  <cfelse>
                  "#replacenocase(jsStringFormat(version),"\'","'","all")#"
               </cfif>
               <cfelse>
               "#replacenocase(jsStringFormat(qFiltered[thisColumn][qFiltered.currentRow]),"\'","'","all")#"
            </cfif>
         </cfloop>
         ]
      </cfoutput>
      ] }
   </cffunction>
</cfcomponent>
