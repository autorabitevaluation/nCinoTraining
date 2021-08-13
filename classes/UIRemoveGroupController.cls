public with sharing class UIRemoveGroupController
{
    public String RecordId {get; set;}
    transient Savepoint sp;

    public nFORCE__Group__c starting_group;
    
    public UIRemoveGroupController(ApexPages.StandardController stdController)
    {
        RecordId = stdController.getId();
    }
    
    public void removeGroupItems()
    {
        /*
            Removal of all items associated to a Group in the following order.
            Screen Sections (Section Configs by default)
            Screen Views
            Screens
            Route Groups
            Routes
            Field Configs
        */
    
        nFORCE__Group__c theGroup = [SELECT ID, Name FROM nFORCE__Group__c WHERE Id = :RecordId];
        starting_group = theGroup;
        
        List<nFORCE__Route_Group__c> routeGroups = new List<nFORCE__Route_Group__c>();
        routeGroups = [SELECT ID, nFORCE__Route__c FROM nFORCE__Route_Group__c WHERE nFORCE__Group__c = :theGroup.Id];
        List<Id> routeGroupIds = new List<Id>();
        for (nFORCE__Route_Group__c r : routeGroups)
        {
            routeGroupIds.add(r.nFORCE__Route__c);
        }
        
        List<nFORCE__Route__c> allRoutes = new List<nFORCE__Route__c>();
        allRoutes = [SELECT ID, nFORCE__Screen__c FROM nFORCE__Route__c WHERE Id IN :routeGroupIds];
        
        //Getting Route Groups from other Groups
        List<nFORCE__Route_Group__c> additionalRouteGroups = [SELECT Id, nFORCE__Route__c, nFORCE__Group__c FROM nFORCE__Route_Group__c WHERE nFORCE__Route__c IN :routeGroupIds];
        List<nFORCE__Route__c> routes = new List<nFORCE__Route__c>();
        for (nFORCE__Route__c r : allRoutes)
        {
            Boolean doDelete = true;
            for(nFORCE__Route_Group__c rg : additionalRouteGroups)
            {
                if(rg.nFORCE__Group__c != theGroup.Id)
                {
                    //the Route Group is attached to a different Group, so we cannot delete the associated Route
                    doDelete = false; 
                }    
            }
            
            if (doDelete)
            {
                routes.add(r);
            }
        }
        
        Set<Id> routeIDs = new Set<Id>();
        for(nFORCE__Route__c rt : routes)
        {
            routeIDs.add(rt.Id);
        }
        
        //first Field Config list for those that are Route-only
        List<nFORCE__Field_Configuration__c> fieldConfigs = [SELECT ID FROM nFORCE__Field_Configuration__c WHERE nFORCE__Route__c IN :routeIDs AND nFORCE__Screen_Section__c = null];
           
        List<Id> screenIds = new List<Id>();
        for (nFORCE__Route__c r : routes)
        {
            screenIds.add(r.nFORCE__Screen__c);
        }
        
        List<nFORCE__Screen__c> screens = new List<nFORCE__Screen__c>();
        screens = [SELECT ID FROM nFORCE__Screen__c WHERE Id IN :screenIds];
        
        List<nFORCE__Screen_Section__c> screenSections = new List<nFORCE__Screen_Section__c>();
        screenSections = [SELECT ID, nFORCE__Screen__c, nFORCE__Screen_View__c FROM nFORCE__Screen_Section__c WHERE nFORCE__Screen__c IN :screenIds];
        List<Id> screenSectionIds = new List<Id>();
        for (nFORCE__Screen_Section__c ss : screenSections)
        {
            screenSectionIds.add(ss.Id);
        }
        
        //getting children Screen Sections that would not be found in the above Id list, then combining into original list
        List<nFORCE__Screen_Section__c> childScreenSections = new List<nFORCE__Screen_Section__c>();
        childScreenSections = [SELECT ID, nFORCE__Screen__c, nFORCE__Screen_View__c FROM nFORCE__Screen_Section__c WHERE nFORCE__Parent_Screen_Section__c IN :screenSectionIds];
        screenSections.addAll(childScreenSections);
        
        Set<Id> parentScreenIds = new Set<Id>();
        for(nFORCE__Screen_Section__c ss : childScreenSections)
        {
            if(!screenIds.contains(ss.nFORCE__Screen__c))
            {
                parentScreenIds.add(ss.nFORCE__Screen__c);
            }
        }
        
        //getting parent Screens that would not be found in the above Id list, then combining into original list
        List<nFORCE__Screen__c> parentScreens = new List<nFORCE__Screen__c>();
        parentScreens = [SELECT ID FROM nFORCE__Screen__c WHERE Id IN :parentScreenIds];
        screens.addAll(parentScreens);
        
        List<nFORCE__Section_Configuration__c> sectionConfigurations = new List<nFORCE__Section_Configuration__c>();
        sectionConfigurations = [SELECT ID, nFORCE__Layout__c FROM nFORCE__Section_Configuration__c WHERE nFORCE__Screen_Section__c IN: screenSectionIds];
        
        //separate Field Config list for those that are SS-only, then combine lists
        List<nFORCE__Field_Configuration__c> ssFieldConfigs = [SELECT ID FROM nFORCE__Field_Configuration__c WHERE nFORCE__Screen_Section__c IN :screenSectionIds AND nFORCE__Route__c = null];
        fieldConfigs.addAll(ssFieldConfigs);
                
        List<Id> screenViewIds = new List<Id>();
        for (nFORCE__Screen_Section__c ss : screenSections)
        {
            screenViewIds.add(ss.nFORCE__Screen_View__c);
        }
        
        List<nFORCE__View__c> screenViews = new List<nFORCE__View__c>();
        screenViews = [SELECT ID FROM nFORCE__View__c WHERE Id IN :screenViewIds];
        
        Set<Id> layoutIDs = new Set<Id>();
        List<nFORCE__Layout__c> layouts = new List<nFORCE__Layout__c>();
        for (nFORCE__Section_Configuration__c sc : sectionConfigurations )
        {
            layoutIDs.add(sc.nFORCE__Layout__c);
        }
        layouts = [SELECT ID FROM nFORCE__Layout__c WHERE Id IN: layoutIDs];
        
        Integer numberOfItems = screenSections.size() + screenViews.size() + screens.size() + routeGroups.size() + routes.size() + layouts.size() + fieldConfigs.size();
        
        sp = Database.setSavepoint();
        System.debug('Number of Items to Delete ::: ' + numberOfItems );
        delete layouts;
        delete screenSections;
        delete screenViews;
        delete screens;
        delete routeGroups;
        delete routes;
        delete fieldConfigs;
    }
    
    public PageReference groupRedirect()
    {
        try
        {
            removeGroupItems();
            
            PageReference group_page = new ApexPages.StandardController(starting_group).view();
            group_page.setRedirect(true);   
            return group_page;            
        }
        catch(Exception e) { Database.rollback(sp); ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Deletion error:  ' + e));  return null;
        }
    }           

}