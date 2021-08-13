@isTest
private class UIRemoveGroupControllerTest
{  
    @isTest
    static void groupRedirectSuccess1()
    {
        nFORCE__Screen__c testScreen = createScreen();
        nFORCE__Group__c testGroup = createGroup();
        nFORCE__Route__c testRoute = createRoute(testScreen.Id);
        nFORCE__Route_Group__c testRouteGroup = createRouteGroup(testGroup.Id, testRoute.Id);
        nFORCE__View__c testScreenView = createView();
        nFORCE__Screen_Section__c testScreenSection = createScreenSection(testScreen.Id, testScreenView.Id);
        nFORCE__Layout__c layout1 = createLayout('NoLayout', 'Html.Layouts.NoLayout');
        nFORCE__Layout__c layout2 = createLayout('TwoColumnGrid', 'Html.Layouts.TwoColumnGrid');      
        
        nFORCE__Section_Configuration__c sectionconfig1 = createSectionConfiguration(testScreenSection.Id, null, layout1.Id, null, 'DEF283957235', 'LLC_BI__Loan__c', 1.01);
        nFORCE__Section_Configuration__c sectionconfig2 = createSectionConfiguration(testScreenSection.Id, sectionconfig1.Id, layout2.Id, 'LLC_BI__Collateral__r', 'GHI87346346', 'LLC_BI__Loan__c', 2.01);        
        
        UIRemoveGroupController remove = new UIRemoveGroupController(new ApexPages.StandardController(new nFORCE__Group__c()));
        
        //Inserting Related List Screen Sections
        Test.startTest();
        remove.RecordId = testGroup.Id;
        remove.groupRedirect();
        Test.stopTest();
    }

    private static nFORCE__Group__c  createGroup()
    {
        nFORCE__Group__c newGroup = new nFORCE__Group__c(Name = 'TestGroup');
        insert newGroup;
        return newGroup;
    }

    private static nFORCE__Route__c createRoute(Id screen)
    {
        nFORCE__Route__c newRoute = new nFORCE__Route__c(nFORCE__Screen__c = screen, Name = 'GenRoute1');
        insert newRoute;
        return newRoute;
    }
    
    private static nFORCE__Route_Group__c createRouteGroup(Id groupId, Id routeId)
    {
        nFORCE__Route_Group__c newRouteGroup = new nFORCE__Route_Group__c(nFORCE__Group__c = groupId, nFORCE__Route__c = routeId);
        insert newRouteGroup;
        return newRouteGroup;
    }
    
    private static nFORCE__Screen__c createScreen()
    {
        nFORCE__Screen__c newScreen = new nFORCE__Screen__c(Name = 'TestScreen');
        insert newScreen;
        return newScreen;
    }
    
    private static nFORCE__Screen_Section__c createScreenSection(Id screenId, Id view)
    {
        nFORCE__Screen_Section__c newScreenSection = new nFORCE__Screen_Section__c(nFORCE__Section_Resource__c = 'SObjectScreenResource',
            nFORCE__Screen__c = screenId, nFORCE__Screen_View__c = view);
        insert newScreenSection;
        return newScreenSection;
    }
    
    private static nFORCE__View__c createView()
    {
        nFORCE__View__c newView = new nFORCE__View__c();
        insert newView;
        return newView;
    }
    
    private static nFORCE__Section_Configuration__c createSectionConfiguration(Id screensection, Id parent_config, Id layout, String parent_name, String lky, String sotype, Decimal order)
    {
        nFORCE__Section_Configuration__c newSectionConfig = new nFORCE__Section_Configuration__c(nFORCE__Screen_Section__c = screensection, 
            nFORCE__Parent_Configuration__c = parent_config, nFORCE__Parent_Relationship_Name__c = parent_name, nFORCE__lookupKey__c = lky,
            nFORCE__sObject_Type__c = sotype, nFORCE__Display_Order__c = order, nFORCE__Layout__c = layout);
        insert newSectionConfig;
        return newSectionConfig;
    }    
    
    private static nFORCE__Layout__c createLayout(String nm, String genclass)
    {
        nFORCE__Layout__c newLayout = new nFORCE__Layout__c(Name = nm, nFORCE__Generator_Class__c = genclass);
        insert newLayout;
        return newLayout;
    }
}