public with sharing class UserInterfaceDeepClone
{
    private Id objectId { get; set; }
    public String RecordId {get; set;}
    public String newGroupName{get;set;}
    public String appsToExclude {get; set;}
    private Boolean hasLookupKeys = false;
    private String lookupKeyMissingObject = '';

    transient Savepoint sp;
    nFORCE__Group__c new_group;
    nFORCE__Group__c starting_group;

    /* The results from the Route Group query */
    public List<RouteGroupsWrapper> searchResults {get; set;}  //2019-4-23

    public UserInterfaceDeepClone() 
    {
        Map<String, String> params = ApexPages.currentPage().getParameters();
        this.objectId = ID.valueOf(params.get(ID_FIELD));
        this.RecordId = params.get(ID_FIELD);
        Id grID = this.RecordId;
        search(); //2019-4-23
    }
    
    /***
    public UserInterfaceDeepClone(ApexPages.StandardController stdController)
    {
        RecordId = stdController.getId();
    }
    ***/
    
    /* The Route Groups that were checked (selected) */
    public List<RouteGroupsWrapper> selectedRouteGroups
    {
        get
        {
            if (selectedRouteGroups == null) selectedRouteGroups = new List<RouteGroupsWrapper>();
            return selectedRouteGroups;
        }
        set;
    }
    
    public PageReference search()
    {
        if (searchResults == null)
        {
            searchResults = new List<RouteGroupsWrapper>();
        }
        else
        {
            searchResults.clear();
        }
        
        String qry = 'SELECT Id, Name, nFORCE__Route__r.Name, nFORCE__Route__r.nFORCE__App__c, nFORCE__Order__c, nFORCE__Parent_Route__r.Name, ' +
            'nFORCE__Is_Default_Context_Child__c, nFORCE__Is_Hidden__c FROM nFORCE__Route_Group__c ' +
            'WHERE nFORCE__Group__c = ' + '\'' + RecordId + '\'' + 
            ' ORDER BY Name ASC';
        
        for(nFORCE__Route_Group__c rg : Database.query(qry))
        {
            RouteGroupsWrapper rgw = new RouteGroupsWrapper(rg);
            searchResults.add(rgw);
        }
        return null;
    }

    public void doUserInterfaceDeepClone()
    {
        /*** RETRIEVE SOURCE RECORDS ***/
        
        String source_group_query = getCreatableFieldsSOQL('nFORCE__Group__c', 'Id = \'' + RecordId + '\'');
        nFORCE__Group__c source_group = Database.query(source_group_query);
        starting_group = source_group;
        
        for (RouteGroupsWrapper cw : searchResults)
        {
            if (cw.checked)
                selectedRouteGroups.add(new RouteGroupsWrapper(cw.rtgrp));
        }
        
        String source_route_groups_query = '';
        List<nFORCE__Route_Group__c> source_route_groups = null;
        if (selectedRouteGroups.size() > 0) //Was at least 1 Route Group manually selected from the list?
        {
            Set<Id> selected_RouteGroupIDs = new Set<Id>();
            for (RouteGroupsWrapper rg : selectedRouteGroups) //Loop through Route Groups that were checked on the VF Page
            {
                selected_RouteGroupIDs.add(rg.rtgrp.Id);
            }
            
            source_route_groups_query = getCreatableFieldsSOQL('nFORCE__Route_Group__c', 'Id IN : selected_RouteGroupIDs');
            source_route_groups = Database.query(source_route_groups_query); 
        }
        else //None manually selected - just clone ALL Route Groups
        {
            source_route_groups_query = getCreatableFieldsSOQL('nFORCE__Route_Group__c', 'nFORCE__Group__c = \'' + RecordId + '\'');
            source_route_groups = Database.query(source_route_groups_query);        
        }

        Set<Id> source_routeIDs = new Set<Id>();
        for(nFORCE__Route_Group__c rg : source_route_groups)
        {
            source_routeIDs.add(rg.nFORCE__Route__c);
        }

        String source_routes_query = getCreatableFieldsSOQL('nFORCE__Route__c', 'Id IN : source_routeIDs');
        List<nFORCE__Route__c> source_routes = Database.query(source_routes_query);
        
        source_routes = parseRoutesByApp(source_routes);
        
        //getting Field Config records that only have a Route reference
        String source_field_configs_query = getCreatableFieldsSOQL('nFORCE__Field_Configuration__c', 'nFORCE__Route__c IN : source_routeIDs AND nFORCE__Screen_Section__c = null');
        List<nFORCE__Field_Configuration__c> source_field_configs = Database.query(source_field_configs_query);
        
        Set<Id> source_screenIDs = new Set<Id>();
        for(nFORCE__Route__c rt : source_routes)
        {
            source_screenIDs.add(rt.nFORCE__Screen__c);
        }

        String source_screens_query = getCreatableFieldsSOQL('nFORCE__Screen__c', 'Id IN : source_screenIDs');
        List<nFORCE__Screen__c> source_screens = Database.query(source_screens_query); 

        String source_screen_sections_query = getCreatableFieldsSOQL('nFORCE__Screen_Section__c', 'nFORCE__Screen__c IN : source_screenIDs');
        List<nFORCE__Screen_Section__c> source_screen_sections = Database.query(source_screen_sections_query);
    
        Set<Id> source_viewIDs = new Set<Id>();
        Set<Id> source_screenSectionIDs = new Set<Id>();
        for (nFORCE__Screen_Section__c ss : source_screen_sections)
        {
            source_viewIDs.add(ss.nFORCE__Screen_View__c);
            source_screenSectionIDs.add(ss.Id);
        }
        
        //for cloning over conditional Screen Sections
        String source_child_screen_sections_query = getCreatableFieldsSOQL('nFORCE__Screen_Section__c', 'nFORCE__Parent_Screen_Section__c IN : source_screenSectionIDs');
        List<nFORCE__Screen_Section__c> source_child_screen_sections = Database.query(source_child_screen_sections_query);

        for(nFORCE__Screen_Section__c ss : source_child_screen_sections)
        {
            source_screenSectionIDs.add(ss.Id); //adding the SS IDs to the list for later use
        }
        source_screen_sections.addAll(source_child_screen_sections);
        
        Set<Id> source_parentScreenIDs = new Set<Id>();
        for(nFORCE__Screen_Section__c css : source_child_screen_sections)
        {
            if(!source_screenIDs.contains(css.nFORCE__Screen__c))
            {
                source_parentScreenIDs.add(css.nFORCE__Screen__c);
            }
        }
        
        String source_parent_screens_query = getCreatableFieldsSOQL('nFORCE__Screen__c', 'Id IN : source_parentScreenIDs');
        List<nFORCE__Screen__c> source_parent_screens = Database.query(source_parent_screens_query);
        source_screens.addAll(source_parent_screens);
        source_ScreenIDs.addAll(source_parentScreenIDs);
        //end setup for cloning over conditional Screen Sections
    
        String source_views_query = getCreatableFieldsSOQL('nFORCE__View__c', 'Id IN : source_viewIDs');
        List<nFORCE__View__c> source_views = Database.query(source_views_query);
        
        String source_section_configs_query = getCreatableFieldsSOQL('nFORCE__Section_Configuration__c', 'nFORCE__Screen_Section__c IN : source_screenSectionIDs');
        List<nFORCE__Section_Configuration__c> source_section_configs = Database.query(source_section_configs_query);
        
        //getting Field Config records that only have a Screen Section reference, combining with other FC list
        String source_ss_field_configs_query = getCreatableFieldsSOQL('nFORCE__Field_Configuration__c', 'nFORCE__Screen_Section__c IN : source_screen_sections AND nFORCE__Route__c = null');
        List<nFORCE__Field_Configuration__c> source_ss_field_configs = Database.query(source_ss_field_configs_query);
        source_field_configs.addAll(source_ss_field_configs);

        Set<Id> source_layoutIDs = new Set<Id>();
        for (nFORCE__Section_Configuration__c sc : source_section_configs)
        {
            source_layoutIDs.add(sc.nFORCE__Layout__c);
        }
        
        System.debug('***1***');
        String source_layouts_query = getCreatableFieldsSOQL('nFORCE__Layout__c', 'Id IN : source_layoutIDs');
        List<nFORCE__Layout__c> source_layouts = Database.query(source_layouts_query);    
        System.debug('***2***');
        
        hasLookupKeys = checkLookupkeys(source_group, source_route_groups, source_routes, source_field_configs, source_screens, source_screen_sections, source_views, source_section_configs, source_layouts);
    
        /*** CLONING OPERATIONS ***/
        
        if(hasLookupKeys)
        {
            sp = Database.setSavepoint();
            
            new_group = source_group.clone(false, false, false, false);
            new_group.Name = newGroupName;
            new_group.nFORCE__App__c = simplifyName(newGroupName);
            new_group.nFORCE__lookupKey__c = generateRandomString(4); //12-10-2018
            System.debug('***A***');
            insert new_group;
            
            List<nFORCE__Route_Group__c> new_route_groups = new List<nFORCE__Route_Group__c>();
            nFORCE__Route_Group__c temp_route_group;
            for(nFORCE__Route_Group__c rg : source_route_groups)
            {
                temp_route_group = rg.clone(false, false, false, false);
                temp_route_group.nFORCE__Group__c = new_group.Id;
                temp_route_group.nFORCE__lookupKey__c = generateRandomString(4); //12-10-2018
                new_route_groups.add(temp_route_group);
            }
            System.debug('***B***');        
            insert new_route_groups; //These route groups are still pointing to original routes, for now
            
            Map<Id, String> route_apps_map = new Map<Id, String>(); //to compare source routes to new routes
            List<nFORCE__Route__c> new_routes = new List<nFORCE__Route__c>();
            List<nFORCE__Route__c> all_routes = [SELECT Id, nFORCE__App__c FROM nFORCE__Route__c];
            Set<String> app_set = new Set<String>();
            for(nFORCE__Route__c r : all_routes)
            {
                app_set.add(r.nFORCE__App__c);
            }
            
            for(String s : app_set)
            {
                System.debug('***LOOP APP VALUE: ' + s);
            }   
            
            nFORCE__Route__c temp_route;
            for(nFORCE__Route__c r : source_routes)
            {
                String appValue = '';
                temp_route = r.clone(false, false, false, false);
                
                if(temp_route.nFORCE__App__c.startsWithIgnoreCase('action-'))
                {
                    temp_route.nFORCE__App__c = 'action-' + simplifyName(new_group.Name) + '-' + simplifyName(r.Name);
                    appValue = 'action-' + simplifyName(new_group.Name) + '-' + simplifyName(r.Name);
                }
                else if(temp_route.nFORCE__App__c.startsWithIgnoreCase('tool-'))
                {
                    temp_route.nFORCE__App__c = 'tool-' + simplifyName(new_group.Name) + '-' + simplifyName(r.Name);
                    appValue = 'tool-' + simplifyName(new_group.Name) + '-' + simplifyName(r.Name);
                }
                else
                {
                    temp_route.nFORCE__App__c = simplifyName(new_group.Name) + '-' + simplifyName(r.Name);
                    appValue = temp_route.nFORCE__App__c = simplifyName(new_group.Name) + '-' + simplifyName(r.Name);
                }
                
                Integer count = 2;
                System.debug('***route appValue: ' + appValue);
                while(app_set.contains(appValue)) //attempting to work around duplicate App values by appending a numeric value
                {
                    System.debug('***route appValue dupe: ' + appValue);
                    appValue += String.valueOf(count);
                    temp_route.nFORCE__App__c = appValue;
                    System.debug('***route appValue adjusted: ' + temp_route.nFORCE__App__c);
                    count++;
                }
                
                app_set.add(appValue);
                
                //leaving original screen, for now
                temp_route.nFORCE__lookupKey__c = generateRandomString(4); //12-10-2018
                new_routes.add(temp_route);
                
                route_apps_map.put(r.Id, appValue);
            }
            System.debug('***C***');  
            insert new_routes;
            
            for(nFORCE__Route_Group__c rg : new_route_groups) //correcting the route groups, so they point to new routes...
            {
                for(Id route_id : route_apps_map.keySet())
                {
                    if (rg.nFORCE__Route__c == route_id)
                    {
                        System.debug('**level3a**');
                        for(nFORCE__Route__c nr : new_routes)
                        {
                            //get new App value related to source route record Id
                            if(nr.nFORCE__App__c == route_apps_map.get(route_id))
                            {
                                rg.nFORCE__Route__c = nr.Id;
                            }
                        }
                    }
                
                    if (rg.nFORCE__Parent_Route__c == route_Id)
                    {
                        for(nFORCE__Route__c nr : new_routes)
                        {
                            //get new App value related to source route record Id
                            if(nr.nFORCE__App__c == route_apps_map.get(route_id))
                            {
                                rg.nFORCE__Parent_Route__c = nr.Id;
                            }
                        }                    
                    }
                
                }
            }
            System.debug('***D***');            
            update new_route_groups;                      
            
            Map<Id, String> screen_map = new Map<Id, String>();
            List<nFORCE__Screen__c> new_screens = new List<nFORCE__Screen__c>();
            nFORCE__Screen__c temp_screen;
            for(nFORCE__Screen__c s : source_screens)
            {
                temp_screen = s.clone(false, false, false, false);
                temp_screen.nFORCE__lookupKey__c = generateRandomString(4);
                new_screens.add(temp_screen);
                
                screen_map.put(s.Id, temp_screen.nFORCE__lookupKey__c);
            }
            System.debug('***E***');        
            insert new_screens; 
            
            for(nFORCE__Route__c r : new_routes) //update Routes to use correct new Screen
            {
                for(Id screen_id : screen_map.keySet())
                {
                    if(r.nFORCE__Screen__c == screen_id)
                    {
                        for(nFORCE__Screen__c s : new_screens)
                        {
                            if(s.nFORCE__lookupKey__c == screen_map.get(screen_id))
                            {
                                r.nFORCE__Screen__c = s.Id;
                            }
                        }
                    }
                }
            }
            System.debug('***F***');        
            update new_routes;      
            
            Map<Id, String> screen_section_map = new Map<Id, String>();
            List<nFORCE__Screen_Section__c> new_screen_sections = new List<nFORCE__Screen_Section__c>();
            nFORCE__Screen_Section__c temp_screen_section;
            for(nFORCE__Screen_Section__c ss : source_screen_sections)
            {
                temp_screen_section = ss.clone(false, false, false, false);
                temp_screen_section.nFORCE__lookupKey__c = generateRandomString(4);
                new_screen_sections.add(temp_screen_section);
                
                //populate map, will later be used for section configs
                screen_section_map.put(ss.Id, temp_screen_section.nFORCE__lookupKey__c);
            }
            System.debug('***G***');        
            insert new_screen_sections;
            
            Map<Id, String> view_map = new Map<Id, String>();
            List<nFORCE__View__c> new_views = new List<nFORCE__View__c>();
            nFORCE__View__c temp_view;
            for(nFORCE__View__c sv : source_views)
            {
                temp_view = sv.clone(false, false, false, false);
                temp_view.nFORCE__lookupKey__c = generateRandomString(4);
                new_views.add(temp_view);
                
                view_map.put(sv.Id, temp_view.nFORCE__lookupKey__c);
            }
            System.debug('***H***');        
            insert new_views;
            
            for(nFORCE__Screen_Section__c ss : new_screen_sections) //set correct Screen on Screen Section
            {
                for(Id screen_id : screen_map.keySet())
                {
                    if(ss.nFORCE__Screen__c == screen_id)
                    {
                        for(nFORCE__Screen__c s : new_screens)
                        {
                            if(s.nFORCE__lookupKey__c == screen_map.get(screen_id))
                            {
                                ss.nFORCE__Screen__c = s.Id;
                            }
                        }
                    }
                }
            }
            
            for(nFORCE__Screen_Section__c ss : new_screen_sections) //set correct View on Screen Section
            {
                for(Id view_id : view_map.keySet())
                {
                    if(ss.nFORCE__Screen_View__c == view_id)
                    {
                        for(nFORCE__View__c v : new_views)
                        {
                            if(v.nFORCE__lookupKey__c == view_map.get(view_id))
                            {
                                ss.nFORCE__Screen_View__c = v.Id;
                            }
                        }
                    }
                }
            }
            
            for(nFORCE__Screen_Section__c ssn : new_screen_sections) //set correct Parent Screen Section on Screen Section
            {
                for(Id screen_section_id : screen_section_map.keySet())
                {
                    if(ssn.nFORCE__Parent_Screen_Section__c == screen_section_id)
                    {
                        for(nFORCE__Screen_Section__c ssn2 : new_screen_sections)
                        {
                            if(ssn2.nFORCE__lookupKey__c == screen_section_map.get(screen_section_id))
                            {
                                ssn.nFORCE__Parent_Screen_Section__c = ssn2.Id;
                            }
                        }
                    }
                }
            }     
            
            System.debug('***I***');
            update new_screen_sections;
    
            /* Adding Field Configs */
            List<nFORCE__Field_Configuration__c> new_field_configs = new List<nFORCE__Field_Configuration__c>();
            nFORCE__Field_Configuration__c temp_field_config;
            for(nFORCE__Field_Configuration__c fc : source_field_configs)
            {
                temp_field_config = fc.clone(false, false, false, false);
                temp_field_config.nFORCE__lookupKey__c = generateRandomString(4);
                new_field_configs.add(temp_field_config);
            }
            System.debug('***J***');        
            insert new_field_configs; //These Field Configs are still pointing to original routes and screen sections, for now
            
            for(nFORCE__Field_Configuration__c fc : new_field_configs) 
            {
                for(Id route_id : route_apps_map.keySet()) //correcting the Field Configs, so they point to new routes...
                {
                    if (fc.nFORCE__Route__c == route_id)
                    {
                        for(nFORCE__Route__c nr : new_routes)
                        {
                            //get new App value related to source route record Id
                            if(nr.nFORCE__App__c == route_apps_map.get(route_id))
                            {
                                fc.nFORCE__Route__c = nr.Id;
                            }
                        }
                    }          
                }
                
                for(Id screen_section_id : screen_section_map.keySet()) //set correct Screen Section on Field Configs
                {
                    if(fc.nFORCE__Screen_Section__c == screen_section_id)
                    {
                        for(nFORCE__Screen_Section__c ss : new_screen_sections)
                        {
                            if(ss.nFORCE__lookupKey__c == screen_section_map.get(screen_section_id))
                            {
                                fc.nFORCE__Screen_Section__c = ss.Id;
                            }
                        }
                    }
                }           
            }       
            System.debug('***K***');
            update new_field_configs;       
            /* End Field Configs */     
            
            //using screen_section_map that was populated above when new screen sections were originally created
            
            Map<Id, String> section_config_map = new Map<Id, String>();
            List<nFORCE__Section_Configuration__c> new_section_configs = new List<nFORCE__Section_Configuration__c>();
            nFORCE__Section_Configuration__c temp_section_config;
            for(nFORCE__Section_Configuration__c sc : source_section_configs)
            {
                temp_section_config = sc.clone(false, false, false, false);
                temp_section_config.nFORCE__lookupKey__c = generateRandomString(4);
                new_section_configs.add(temp_section_config);
                
                //screen section map?
                section_config_map.put(sc.Id, temp_section_config.nFORCE__lookupKey__c);         
            }
            
            for(nFORCE__Section_Configuration__c sc : new_section_configs) //set correct Screen Section on section config
            {
                for(Id screen_section_id : screen_section_map.keySet())
                {
                    if(sc.nFORCE__Screen_Section__c == screen_section_id)
                    {
                        for(nFORCE__Screen_Section__c ss : new_screen_sections)
                        {
                            if(ss.nFORCE__lookupKey__c == screen_section_map.get(screen_section_id))
                            {
                                sc.nFORCE__Screen_Section__c = ss.Id;
                            }
                        }
                    }
                }
            }
            System.debug('***L***');
            insert new_section_configs;               
    
            //update section configs to use correct hierarchy + layouts
            for(nFORCE__Section_Configuration__c sc : new_section_configs)
            {
                for(Id section_config_id : section_config_map.keySet())
                {
                    if(sc.nFORCE__Parent_Configuration__c == section_config_id)
                    {
                        for(nFORCE__Section_Configuration__c sc2 : new_section_configs)
                        {
                            if(sc2.nFORCE__lookupKey__c == section_config_map.get(section_config_id))
                            {
                                sc.nFORCE__Parent_Configuration__c = sc2.Id;                        
                            }                    
                        }                
                    }            
                }
            }
            
            //insert layouts in preparation to attach to new section configs
            Map<Id, String> layout_map = new Map<Id, String>();
            List<nFORCE__Layout__c> new_layouts = new List<nFORCE__Layout__c>();
            nFORCE__Layout__c temp_layout;
            for(nFORCE__Layout__c ly : source_layouts)
            {
                temp_layout = ly.clone(false, false, false, false);
                temp_layout.nFORCE__lookupKey__c = generateRandomString(4);
                new_layouts.add(temp_layout);
                
                layout_map.put(ly.Id, temp_layout.nFORCE__lookupKey__c);
            }
            System.debug('***M***');        
            insert new_layouts;         
            
            for(nFORCE__Section_Configuration__c sc : new_section_configs) //update Routes to use correct new Screen
            {
                for(Id layout_id : layout_map.keySet())
                {
                    if(sc.nFORCE__Layout__c == layout_id)
                    {
                        for(nFORCE__Layout__c ly : new_layouts)
                        {
                            if(ly.nFORCE__lookupKey__c == layout_map.get(layout_id))
                            {
                                sc.nFORCE__Layout__c = ly.Id;
                            }
                        }
                    }
                }
            }
            System.debug('***N***');        
            update new_section_configs;
        }
    }    

    //Returns a dynamic SOQL statement for the whole object
    public static string getCreatableFieldsSOQL(String objectName, String whereClause)
    {      
        String selects = '';   
        if (whereClause == null || whereClause == ''){ return null; }
         
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
         
        if (fMap != null)
        {
            for (Schema.SObjectField ft : fMap.values())
            { // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                //if (fd.isCreateable()){ // field is creatable
                selectFields.add(fd.getName());
                //}
            }
        }
         
        if (!selectFields.isEmpty())
        {
            for (string s:selectFields)
            {
                selects += s + ',';
            }
            if (selects.endsWith(','))
            {
                selects = selects.substring(0,selects.lastIndexOf(','));
            }             
        }
         
        system.debug('**the query** : ' + 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause);
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;        
    }
    
    /*** Paring down source_routes to exclude unique, single-use/single-App routes that can only appear once in the Org. ***/
    /*** The Route Groups for these routes will still be created, and will point to the original route. ***/
    private List<nFORCE__Route__c> parseRoutesByApp(List<nFORCE__Route__c> source_routes)
    {
        List<nFORCE__Route__c> new_source_routes = new List<nFORCE__Route__c>();
        List<String> unique_apps = new List<String>{'loan-auto-decision-history', 'loan-auto-decision-detail', 'doc-prep', 'doc-prep-status', 'doc-prep-closing',
            'doc-prep-review', 'rate-structure', 'payment-structure', 'tool-docman', 'unidoc'};
            
        if(appsToExclude != '' && appsToExclude != null)
        {
            List<String> user_defined_apps = parseUserDefinedRoutes(appsToExclude);
            unique_apps.addAll(user_defined_apps);
        }
        
        for(nFORCE__Route__c sr : source_routes)
        {
            if(unique_apps.contains(sr.nFORCE__App__c))
            {
                //do nothing - want to avoid creating a duplicate route if it has a unique/one-only apps
            }
            else
            {
                new_source_routes.add(sr);
            }
        }
        
        return new_source_routes;
    }
    
    //PARSE COMMA-SEPARATED STRINGS INTO SEPARATE ITEMS 
    public List<String> parseUserDefinedRoutes(String target)
    {
        List<String> temp_string_list = new List<String>();
        temp_string_list = target.split(',', target.CountMatches(',') + 1); //looking for commas to separate strings
        return temp_string_list;
    }
    
    /*** CHECK LOOKUPKEYS ***/
    public Boolean checkLookupkeys(nFORCE__Group__c grp, List<nFORCE__Route_Group__c> rtgrps, List<nFORCE__Route__c> rts, List<nFORCE__Field_Configuration__c> fldcfgs,
        List<nFORCE__Screen__c> scrns, List<nFORCE__Screen_Section__c> scrnsctns, List<nFORCE__View__c> vws, List<nFORCE__Section_Configuration__c> scncfgs,
        List<nFORCE__Layout__c> lyts)
    {
        Boolean keyMissing = false;
        if(grp.nFORCE__lookupKey__c == '' || grp.nFORCE__lookupKey__c == null)
        {
            lookupKeyMissingObject = 'nFORCE__Group__c';
            keyMissing = true;
        }
        for(nFORCE__Route_Group__c rtgrp : rtgrps)
        {
            if(rtgrp.nFORCE__lookupKey__c == '' || rtgrp.nFORCE__lookupKey__c == null)
            {
                lookupKeyMissingObject = 'nFORCE__Route_Group__c';
                keyMissing = true;
            }
        }
        for(nFORCE__Route__c rt : rts)
        {
            if(rt.nFORCE__lookupKey__c == '' || rt.nFORCE__lookupKey__c == null)
            {
                lookupKeyMissingObject = 'nFORCE__Route__c';
                keyMissing = true;
            }
        }
        for(nFORCE__Field_Configuration__c fldcfg : fldcfgs)
        {
            if(fldcfg.nFORCE__lookupKey__c == '' || fldcfg.nFORCE__lookupKey__c == null)
            {
                lookupKeyMissingObject = 'nFORCE__Field_Configuration__c';
                keyMissing = true;
            }
        }
        for(nFORCE__Screen__c scrn : scrns)
        {
            if(scrn.nFORCE__lookupKey__c == '' || scrn.nFORCE__lookupKey__c == null)
            {
                lookupKeyMissingObject = 'nFORCE__Screen__c';
                keyMissing = true;
            }
        }
        for(nFORCE__Screen_Section__c scrnsct : scrnsctns)
        {
            if(scrnsct.nFORCE__lookupKey__c == '' || scrnsct.nFORCE__lookupKey__c == null)
            {
                lookupKeyMissingObject = 'nFORCE__Screen_Section__c';
                keyMissing = true;
            }
        }
        for(nFORCE__View__c vw : vws)
        {
            if(vw.nFORCE__lookupKey__c == '' || vw.nFORCE__lookupKey__c == null)
            {
                lookupKeyMissingObject = 'nFORCE__View__c';
                keyMissing = true;
            }
        }
        /*
        for(nFORCE__Section_Configuration__c scncfg : scncfgs)
        {
            if(scncfg.nFORCE__lookupKey__c == '' || scncfg.nFORCE__lookupKey__c == null)
            {
                lookupKeyMissingObject = 'nFORCE__Section_Configuration__c';
                keyMissing = true;
            }
        }
        */
        for(nFORCE__Layout__c lyt : lyts)
        {
            if(lyt.nFORCE__lookupKey__c == '' || lyt.nFORCE__lookupKey__c == null)
            {
                lookupKeyMissingObject = 'nFORCE__Layout__c';
                keyMissing = true;
            }
        }
        
        if(keyMissing)
        {
            return false;
        }
        else
        {
            return true;    
        }
    }
    
    /*** METHOD TO SIMPLIFY A STRING -- LOWERCASE AND NO SPACES ***/
    public String simplifyName(String target)
    {
        String newName = target.toLowerCase();
        newName = newName.replace(' ', '-');
        newName = newName.replaceAll('[^a-zA-Z0-9\\s+]', '-');
        return newName;
    }
    
    /*** METHOD TO GENERATE A RANDOM STRING TO SERVE AS LOOKUPKEYS ***/
    public static String generateRandomString(Integer len)
    {
        final String chars = '0123456789';
        String randStr = '';
        while (randStr.length() < len) 
        {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        randStr = randStr + Datetime.now().getTime();
        return randStr; 
    }

    public PageReference prRedirect()
    {
        try
        {
            String testInput = newGroupName.deleteWhiteSpace();
            
            if (testInput.length() > 0)
            {
                sp = Database.setSavepoint();
                doUserInterfaceDeepClone();
                
                if(hasLookupKeys)
                {
                    PageReference group_page = new ApexPages.StandardController(new_group).view();
                    group_page.setRedirect(true);
                    System.debug('**REDIRECT_TEST**: ' + group_page);
                    return group_page;
                }
                else
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Missing lookupKeys found on the following object: ' + lookupKeyMissingObject));  
                    return null;  
                }
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a new Group Name.'));  
                return null;            
            }           
        }
        catch(Exception e)
        {
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Clone error:  ' + e));  
            return null;
        }        
    }
    
    transient private static final String ID_FIELD = 'id';
}