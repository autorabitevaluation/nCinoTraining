public with sharing class UserInterfaceLookupKeyUtility
{
    /*** vars***/
    private Id objectId { get; set; }
    public String RecordId {get; set;}
    transient Savepoint sp;
    nFORCE__Group__c starting_group;
    
    public Decimal missingKeysScreens { get; set; }
    public Decimal missingKeysScreenSections { get; set; }
    public Decimal missingKeysSectionConfigs { get; set; }
    public Decimal missingKeysScreenViews { get; set; }
    public Decimal missingKeysLayouts { get; set; }
    public Decimal missingKeysGroups { get; set; }
    public Decimal missingKeysRoutes { get; set; }
    public Decimal missingKeysRouteGroups { get; set; }
    public Decimal missingKeysFieldConfigs { get; set; }
    
    public Decimal totalNumberScreens { get; set; }
    public Decimal totalNumberScreenSections { get; set; }
    public Decimal totalNumberKeysSectionConfigs { get; set; }
    public Decimal totalNumberScreenViews { get; set; }
    public Decimal totalNumberLayouts { get; set; }
    public Decimal totalNumberGroups { get; set; }
    public Decimal totalNumberRoutes { get; set; }
    public Decimal totalNumberRouteGroups { get; set; }
    public Decimal totalNumberFieldConfigs { get; set; }
    
    public Boolean showRequiredObjects { get; set; }
    public Boolean showOptionalObjects { get; set; }
    public Boolean missingKeys { get; set; }

    /*** constructors ***/
    public UserInterfaceLookupKeyUtility() 
    {
        Map<String, String> params = ApexPages.currentPage().getParameters();
        this.objectId = ID.valueOf(params.get(ID_FIELD));
        this.RecordId = params.get(ID_FIELD);
        
        showRequiredObjects = false;
        showOptionalObjects = false;
        missingKeys = false;
    }
    
    /*** methods ***/    
    //get group records method
    public void retrieveUIRecords(String context)
    {
        String source_group_query = getCreatableFieldsSOQL('nFORCE__Group__c', 'Id = \'' + RecordId + '\'');
        nFORCE__Group__c source_group = Database.query(source_group_query);
        starting_group = source_group;

        String source_route_groups_query = getCreatableFieldsSOQL('nFORCE__Route_Group__c', 'nFORCE__Group__c = \'' + RecordId + '\'');
        List<nFORCE__Route_Group__c> source_route_groups = Database.query(source_route_groups_query);

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
            source_parentScreenIDs.add(css.nFORCE__Screen__c);
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
        
        setLookupKeyResults(source_screens, source_screen_sections, source_section_configs, source_views, source_layouts, source_group, source_route_groups, source_routes, source_field_configs, context);
    }
    
    public void setLookupKeyResults(List<nFORCE__Screen__c> source_screens, List<nFORCE__Screen_Section__c> source_screen_sections, List<nFORCE__Section_Configuration__c> source_section_configs,
        List<nFORCE__View__c> source_views, List<nFORCE__Layout__c> source_layouts, nFORCE__Group__c source_group, List<nFORCE__Route_Group__c> source_route_groups, List<nFORCE__Route__c> source_routes,
        List<nFORCE__Field_Configuration__c> source_field_configs, String context)
    {
        List<nFORCE__Screen__c> incomplete_screens = new List<nFORCE__Screen__c>();
        List<nFORCE__Screen_Section__c> incomplete_screen_sections = new List<nFORCE__Screen_Section__c>();
        List<nFORCE__Section_Configuration__c> incomplete_sections_configs = new List<nFORCE__Section_Configuration__c>();
        List<nFORCE__View__c> incomplete_views = new List<nFORCE__View__c>();
        List<nFORCE__Layout__c> incomplete_layouts = new List<nFORCE__Layout__c>();
        List<nFORCE__Group__c> incomplete_groups = new List<nFORCE__Group__c>();
        List<nFORCE__Route_Group__c> incomplete_route_groups = new List<nFORCE__Route_Group__c>();
        List<nFORCE__Route__c> incomplete_routes =  new List<nFORCE__Route__c>();
        List<nFORCE__Field_Configuration__c> incomplete_field_configs = new List<nFORCE__Field_Configuration__c>();
    
        missingKeysScreens = 0;
        totalNumberScreens = source_screens.size();
        for(nFORCE__Screen__c s : source_screens)
        {
            if(s.nFORCE__lookupKey__c == '' || s.nFORCE__lookupKey__c == null)
            {
                missingKeysScreens++;
                incomplete_screens.add(s);
            }
        }
        
        missingKeysScreenSections = 0;
        totalNumberScreenSections = source_screen_sections.size();
        for(nFORCE__Screen_Section__c ss : source_screen_sections)
        {
            if(ss.nFORCE__lookupKey__c == '' || ss.nFORCE__lookupKey__c == null)
            {
                missingKeysScreenSections++;
                incomplete_screen_sections.add(ss);
            }
        }
        
        missingKeysSectionConfigs = 0;
        totalNumberKeysSectionConfigs = source_section_configs.size();
        for(nFORCE__Section_Configuration__c sc : source_section_configs)
        {
            if(sc.nFORCE__lookupKey__c == '' || sc.nFORCE__lookupKey__c == null)
            {
                missingKeysSectionConfigs++;
                incomplete_sections_configs.add(sc);
            }
        }
        
        missingKeysScreenViews = 0;
        totalNumberScreenViews = source_views.size();
        for(nFORCE__View__c v : source_views)
        {
            if(v.nFORCE__lookupKey__c == '' || v.nFORCE__lookupKey__c == null)
            {
                missingKeysScreenViews++;
                incomplete_views.add(v);
            }
        }
        
        missingKeysLayouts = 0;
        totalNumberLayouts = source_layouts.size();
        for(nFORCE__Layout__c l : source_layouts)
        {
            if(l.nFORCE__lookupKey__c == '' || l.nFORCE__lookupKey__c == null)
            {
                missingKeysLayouts++;
                incomplete_layouts.add(l);
            }
        }
        
        missingKeysGroups = 0;
        totalNumberGroups = 1;
        if(source_group.nFORCE__lookupKey__c == '' || source_group.nFORCE__lookupKey__c == null)
        {
            missingKeysGroups++;
            incomplete_groups.add(source_group);
        }
        
        missingKeysRouteGroups = 0;
        totalNumberRoutes = source_route_groups.size();
        for(nFORCE__Route_Group__c rg : source_route_groups)
        {
            if(rg.nFORCE__lookupKey__c == '' || rg.nFORCE__lookupKey__c == null)
            {
                missingKeysRouteGroups++;
                incomplete_route_groups.add(rg);
            }
        }
        
        missingKeysRoutes = 0;
        totalNumberRouteGroups = source_routes.size();
        for(nFORCE__Route__c r : source_routes)
        {
            if(r.nFORCE__lookupKey__c == '' || r.nFORCE__lookupKey__c == null)
            {
                missingKeysRoutes++;
                incomplete_routes.add(r);
            }
        }
        
        missingKeysFieldConfigs = 0;
        totalNumberFieldConfigs = source_field_configs.size();
        for(nFORCE__Field_Configuration__c fc : source_field_configs)
        {
            if(fc.nFORCE__lookupKey__c == '' || fc.nFORCE__lookupKey__c == null)
            {
                missingKeysFieldConfigs++;
                incomplete_field_configs.add(fc);
            }
        }
        
        if(context == 'analyze')
        {
            //Just check to see if any missing lookupkeys were found and show the results and a message
            if(missingKeysScreens > 0 || missingKeysScreenSections > 0 || missingKeysSectionConfigs > 0 || missingKeysScreenViews > 0 || missingKeysLayouts > 0
                || missingKeysGroups > 0 || missingKeysRouteGroups > 0 || missingKeysRoutes > 0 || missingKeysFieldConfigs > 0)
            {
                showRequiredObjects = true;
                showOptionalObjects = true;
                missingKeys = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Missing lookupKeys were found.  Please refer to the analysis.'));  
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'None of the records in this Group are missing lookupKeys.  Please proceed with the cloning operation.'));  
            }        
        }
        
        if(context == 'assign')
        {
            //proceed with actually assigning lookupkeys, hide results and display message
            if(incomplete_screens.size() > 0)
            {
                for(nFORCE__Screen__c s : incomplete_screens)
                {
                    s.nFORCE__lookupKey__c = generateRandomString(4);
                }
                update incomplete_screens;
            }
            
            if(incomplete_screen_sections.size() > 0)
            {
                for(nFORCE__Screen_Section__c s : incomplete_screen_sections)
                {
                    s.nFORCE__lookupKey__c = generateRandomString(4);
                }
                update incomplete_screen_sections;
            }
            
            if(incomplete_sections_configs.size() > 0)
            {
                for(nFORCE__Section_Configuration__c s : incomplete_sections_configs)
                {
                    s.nFORCE__lookupKey__c = generateRandomString(4);
                }
                update incomplete_sections_configs;
            }
            
            if(incomplete_views.size() > 0)
            {
                for(nFORCE__View__c s : incomplete_views)
                {
                    s.nFORCE__lookupKey__c = generateRandomString(4);
                }
                update incomplete_views;
            }
            
            if(incomplete_layouts.size() > 0)
            {
                for(nFORCE__Layout__c s : incomplete_layouts)
                {
                    s.nFORCE__lookupKey__c = generateRandomString(4);
                }
                update incomplete_layouts;
            }
            
            if(incomplete_groups.size() > 0)
            {
                for(nFORCE__Group__c s : incomplete_groups)
                {
                    s.nFORCE__lookupKey__c = generateRandomString(4);
                }
                update incomplete_groups;
            }
            
            if(incomplete_route_groups.size() > 0)
            {
                for(nFORCE__Route_Group__c s : incomplete_route_groups)
                {
                    s.nFORCE__lookupKey__c = generateRandomString(4);
                }
                update incomplete_route_groups;
            }
            
            if(incomplete_routes.size() > 0)
            {
                for(nFORCE__Route__c s : incomplete_routes)
                {
                    s.nFORCE__lookupKey__c = generateRandomString(4);
                }
                update incomplete_routes;
            }
            
            if(incomplete_field_configs.size() > 0)
            {
                for(nFORCE__Field_Configuration__c s : incomplete_field_configs)
                {
                    s.nFORCE__lookupKey__c = generateRandomString(4);
                }
                update incomplete_field_configs;
            }
            
            showRequiredObjects = false;
            showOptionalObjects = false;
            missingKeys = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Missing lookupKeys have been assigned successfully.'));  
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
    
    /*** Paring down source_routes to exclude unique, single-use/single-App routes that can only appear once in the Org. ***/
    /*** The Route Groups for these routes will still be created, and will point to the original route. ***/
    private List<nFORCE__Route__c> parseRoutesByApp(List<nFORCE__Route__c> source_routes)
    {
        List<nFORCE__Route__c> new_source_routes = new List<nFORCE__Route__c>();
        List<String> unique_apps = new List<String>{'loan-auto-decision-history', 'loan-auto-decision-detail', 'doc-prep', 'doc-prep-status', 'doc-prep-closing',
            'doc-prep-review', 'rate-structure', 'payment-structure', 'tool-docman', 'unidoc'};
        
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
    
    //redirect methods    
    public PageReference analyzeKeys()
    {
        //Assuming these are false, before actually analyzing
        showRequiredObjects = false;
        showOptionalObjects = false;
        missingKeys = false;
    
        try
        {
            sp = Database.setSavepoint();
            retrieveUIRecords('analyze');
            return null; //same page
        }
        catch(exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: ' + e));
            return null; 
        }
    }
    
    public PageReference assignKeys()
    {        
        try
        {
            sp = Database.setSavepoint();
            retrieveUIRecords('assign');
            return null; //same page
        }
        catch(exception e)
        {
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: ' + e));
            return null; 
        }
    }

    /*** statics ***/
    transient private static final String ID_FIELD = 'id';
}