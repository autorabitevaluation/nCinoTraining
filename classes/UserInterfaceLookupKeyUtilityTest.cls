@isTest
private class UserInterfaceLookupKeyUtilityTest
{
    /**TEST METHODS**/
    
    @isTest
    static void lookupKeyTestDriver()
    {
        nFORCE__Group__c group1 = createGroup('Group A', 'group-a', 'group-001');
        nFORCE__Screen__c screen1 = createScreen('Screen A', 'screen-001');
        nFORCE__Screen__c screen2 = createScreen('Screen B', 'screen-002');
        nFORCE__Screen__c screen3 = createScreen('Screen C', 'screen-003');
        nFORCE__Screen__c screen4 = createScreen('Screen D', 'screen-004');
        nFORCE__Route__c route1 = createRoute('Route One', 'route-A', 'test-body1', screen1.Id, 'route-001');
        nFORCE__Route__c route2 = createRoute('Route One', 'route-B', 'test-body2', screen2.Id, 'route-002');  
        nFORCE__Route__c route3 = createRoute('Route C', 'action-route-c', 'test-body3', screen3.Id, 'route-003');
        nFORCE__Route__c route4 = createRoute('Route C', 'tool-route-c', 'test-body3', screen4.Id, 'route-004');
        nFORCE__Route_Group__c routegroup1 = createRouteGroup(group1.Id, route1.Id, null, 'routegroup-001');
        nFORCE__Route_Group__c routegroup2 = createRouteGroup(group1.Id, route2.Id, route2.Id, 'routegroup-002');
        nFORCE__Route_Group__c routegroup3 = createRouteGroup(group1.Id, route3.Id, null, 'routegroup-003');
        nFORCE__Route_Group__c routegroup4 = createRouteGroup(group1.Id, route4.Id, null, 'routegroup-004');  
        nFORCE__View__c view1 = createView('view-001');
        nFORCE__View__c view2 = createView('view-002');
        nFORCE__Screen_Section__c screensection1 = createScreenSection('ScreenSection1', 'LLC_BI__Loan__c', 'MappedSObjectHierarchyResource', screen1.Id, view1.Id, 'screensection-001');
        nFORCE__Screen_Section__c screensection2 = createScreenSection('ScreenSection2', 'LLC_BI__Loan__c', 'MappedSObjectHierarchyResource', screen2.Id, view2.Id, 'screensection-002');
        nFORCE__Screen_Section__c screensection3 = createScreenSection('ScreenSection3', 'LLC_BI__Loan__c', 'MappedSObjectHierarchyResource', screen2.Id, null, 'screensection-003');
        nFORCE__Layout__c layout1 = createLayout('NoLayout', 'Html.Layouts.NoLayout', 'layout-001');
        nFORCE__Layout__c layout2 = createLayout('NoLayout', 'Html.Layouts.NoLayout', 'layout-002');
        nFORCE__Layout__c layout3 = createLayout('TwoColumnGrid', 'Html.Layouts.TwoColumnGrid', 'layout-003');
        nFORCE__Layout__c layout4 = createLayout('NoLayout', 'Html.Layouts.NoLayout', 'layout-004');
        nFORCE__Layout__c layout5 = createLayout('TwoColumnGrid', 'Html.Layouts.TwoColumnGrid', 'layout-005');                                        
        nFORCE__Section_Configuration__c sectionconfig1 = createSectionConfiguration(screensection1.Id, null, layout1.Id, null, 'ABC937523872', 'LLC_BI__Loan__c', 1.01);
        nFORCE__Section_Configuration__c sectionconfig2 = createSectionConfiguration(screensection2.Id, null, layout2.Id, null, 'DEF283957235', 'LLC_BI__Loan__c', 1.01);
        nFORCE__Section_Configuration__c sectionconfig3 = createSectionConfiguration(screensection2.Id, sectionconfig2.Id, layout3.Id, 'LLC_BI__Collateral__r', 'GHI87346346', 'LLC_BI__Loan__c', 2.01);
        nFORCE__Section_Configuration__c sectionconfig4 = createSectionConfiguration(screensection3.Id, null, layout4.Id, null, 'JKL289357239', 'LLC_BI__Loan__c', 1.01);
        nFORCE__Section_Configuration__c sectionconfig5 = createSectionConfiguration(screensection3.Id, sectionconfig4.Id, layout5.Id, 'LLC_BI__Collateral__r', 'MNO984376487', 'LLC_BI__Loan__c', 2.01);
        nFORCE__Field_Configuration__c fieldconfig1 = createFieldConfiguration(route1.Id, screensection1.Id, 'Name', 'LLC_BI__Loan__c', 'fieldconfig-001');
        nFORCE__Field_Configuration__c fieldconfig2 = createFieldConfiguration(route2.Id, screensection2.Id, 'Name', 'LLC_BI__Loan__c', 'fieldconfig-002');
        
        Test.setCurrentPageReference(new PageReference('Page.UserInterfaceDeepClonePage'));
        System.currentPageReference().getParameters().put('id', group1.Id); //objectId
        
        UserInterfaceLookupKeyUtility lookupKeyContainer = new UserInterfaceLookupKeyUtility(); //for coverage of empty constructor
        //UserInterfaceDeepClone clone = new UserInterfaceDeepClone(new ApexPages.StandardController(group1));
        //clone.newGroupName ='Test New Group';
        lookupKeyContainer.analyzeKeys();
    }
    
    @isTest
    static void lookupKeyTestDriver2()
    {
        nFORCE__Group__c group1 = createGroup('Group A', 'group-a', '');
        nFORCE__Screen__c screen1 = createScreen('Screen A', '');
        nFORCE__Screen__c screen2 = createScreen('Screen B', '');
        nFORCE__Screen__c screen3 = createScreen('Screen C', '');
        nFORCE__Screen__c screen4 = createScreen('Screen D', '');
        nFORCE__Route__c route1 = createRoute('Route One', 'route-A', 'test-body1', screen1.Id, '');
        nFORCE__Route__c route2 = createRoute('Route One', 'route-B', 'test-body2', screen2.Id, '');  
        nFORCE__Route__c route3 = createRoute('Route C', 'action-route-c', 'test-body3', screen3.Id, '');
        nFORCE__Route__c route4 = createRoute('Route C', 'tool-route-c', 'test-body3', screen4.Id, '');
        nFORCE__Route_Group__c routegroup1 = createRouteGroup(group1.Id, route1.Id, null, '');
        nFORCE__Route_Group__c routegroup2 = createRouteGroup(group1.Id, route2.Id, route2.Id, '');
        nFORCE__Route_Group__c routegroup3 = createRouteGroup(group1.Id, route3.Id, null, '');
        nFORCE__Route_Group__c routegroup4 = createRouteGroup(group1.Id, route4.Id, null, '');  
        nFORCE__View__c view1 = createView('');
        nFORCE__View__c view2 = createView('');
        nFORCE__Screen_Section__c screensection1 = createScreenSection('ScreenSection1', 'LLC_BI__Loan__c', 'MappedSObjectHierarchyResource', screen1.Id, view1.Id, '');
        nFORCE__Screen_Section__c screensection2 = createScreenSection('ScreenSection2', 'LLC_BI__Loan__c', 'MappedSObjectHierarchyResource', screen2.Id, view2.Id, '');
        nFORCE__Screen_Section__c screensection3 = createScreenSection('ScreenSection3', 'LLC_BI__Loan__c', 'MappedSObjectHierarchyResource', screen2.Id, null, '');
        nFORCE__Layout__c layout1 = createLayout('NoLayout', 'Html.Layouts.NoLayout', '');
        nFORCE__Layout__c layout2 = createLayout('NoLayout', 'Html.Layouts.NoLayout', '');
        nFORCE__Layout__c layout3 = createLayout('TwoColumnGrid', 'Html.Layouts.TwoColumnGrid', '');
        nFORCE__Layout__c layout4 = createLayout('NoLayout', 'Html.Layouts.NoLayout', '');
        nFORCE__Layout__c layout5 = createLayout('TwoColumnGrid', 'Html.Layouts.TwoColumnGrid', '');                                        
        nFORCE__Section_Configuration__c sectionconfig1 = createSectionConfiguration(screensection1.Id, null, layout1.Id, null, 'sc001', 'LLC_BI__Loan__c', 1.01);
        nFORCE__Section_Configuration__c sectionconfig2 = createSectionConfiguration(screensection2.Id, null, layout2.Id, null, 'sc002', 'LLC_BI__Loan__c', 1.01);
        nFORCE__Section_Configuration__c sectionconfig3 = createSectionConfiguration(screensection2.Id, sectionconfig2.Id, layout3.Id, 'LLC_BI__Collateral__r', 'sc003', 'LLC_BI__Loan__c', 2.01);
        nFORCE__Section_Configuration__c sectionconfig4 = createSectionConfiguration(screensection3.Id, null, layout4.Id, null, 'sc004', 'LLC_BI__Loan__c', 1.01);
        nFORCE__Section_Configuration__c sectionconfig5 = createSectionConfiguration(screensection3.Id, sectionconfig4.Id, layout5.Id, 'LLC_BI__Collateral__r', 'sc005', 'LLC_BI__Loan__c', 2.01);
        nFORCE__Field_Configuration__c fieldconfig1 = createFieldConfiguration(route1.Id, screensection1.Id, 'Name', 'LLC_BI__Loan__c', '');
        nFORCE__Field_Configuration__c fieldconfig2 = createFieldConfiguration(route2.Id, screensection2.Id, 'Name', 'LLC_BI__Loan__c', '');
        
        Test.setCurrentPageReference(new PageReference('Page.UserInterfaceDeepClonePage'));
        System.currentPageReference().getParameters().put('id', group1.Id); //objectId
        
        UserInterfaceLookupKeyUtility lookupKeyContainer = new UserInterfaceLookupKeyUtility(); //for coverage of empty constructor
        //UserInterfaceDeepClone clone = new UserInterfaceDeepClone(new ApexPages.StandardController(group1));
        //clone.newGroupName ='Test New Group';
        lookupKeyContainer.analyzeKeys();
    }
    
    @isTest
    static void lookupKeyTestDriver3()
    {
        nFORCE__Group__c group1 = createGroup('Group A', 'group-a', '');
        nFORCE__Screen__c screen1 = createScreen('Screen A', '');
        nFORCE__Screen__c screen2 = createScreen('Screen B', '');
        nFORCE__Screen__c screen3 = createScreen('Screen C', '');
        nFORCE__Screen__c screen4 = createScreen('Screen D', '');
        nFORCE__Route__c route1 = createRoute('Route One', 'route-A', 'test-body1', screen1.Id, '');
        nFORCE__Route__c route2 = createRoute('Route One', 'route-B', 'test-body2', screen2.Id, '');  
        nFORCE__Route__c route3 = createRoute('Route C', 'action-route-c', 'test-body3', screen3.Id, '');
        nFORCE__Route__c route4 = createRoute('Route C', 'tool-route-c', 'test-body3', screen4.Id, '');
        nFORCE__Route_Group__c routegroup1 = createRouteGroup(group1.Id, route1.Id, null, '');
        nFORCE__Route_Group__c routegroup2 = createRouteGroup(group1.Id, route2.Id, route2.Id, '');
        nFORCE__Route_Group__c routegroup3 = createRouteGroup(group1.Id, route3.Id, null, '');
        nFORCE__Route_Group__c routegroup4 = createRouteGroup(group1.Id, route4.Id, null, '');  
        nFORCE__View__c view1 = createView('');
        nFORCE__View__c view2 = createView('');
        nFORCE__Screen_Section__c screensection1 = createScreenSection('ScreenSection1', 'LLC_BI__Loan__c', 'MappedSObjectHierarchyResource', screen1.Id, view1.Id, '');
        nFORCE__Screen_Section__c screensection2 = createScreenSection('ScreenSection2', 'LLC_BI__Loan__c', 'MappedSObjectHierarchyResource', screen2.Id, view2.Id, '');
        nFORCE__Screen_Section__c screensection3 = createScreenSection('ScreenSection3', 'LLC_BI__Loan__c', 'MappedSObjectHierarchyResource', screen2.Id, null, '');
        nFORCE__Layout__c layout1 = createLayout('NoLayout', 'Html.Layouts.NoLayout', '');
        nFORCE__Layout__c layout2 = createLayout('NoLayout', 'Html.Layouts.NoLayout', '');
        nFORCE__Layout__c layout3 = createLayout('TwoColumnGrid', 'Html.Layouts.TwoColumnGrid', '');
        nFORCE__Layout__c layout4 = createLayout('NoLayout', 'Html.Layouts.NoLayout', '');
        nFORCE__Layout__c layout5 = createLayout('TwoColumnGrid', 'Html.Layouts.TwoColumnGrid', '');                                        
        nFORCE__Section_Configuration__c sectionconfig1 = createSectionConfiguration(screensection1.Id, null, layout1.Id, null, 'sc001', 'LLC_BI__Loan__c', 1.01);
        nFORCE__Section_Configuration__c sectionconfig2 = createSectionConfiguration(screensection2.Id, null, layout2.Id, null, 'sc002', 'LLC_BI__Loan__c', 1.01);
        nFORCE__Section_Configuration__c sectionconfig3 = createSectionConfiguration(screensection2.Id, sectionconfig2.Id, layout3.Id, 'LLC_BI__Collateral__r', 'sc003', 'LLC_BI__Loan__c', 2.01);
        nFORCE__Section_Configuration__c sectionconfig4 = createSectionConfiguration(screensection3.Id, null, layout4.Id, null, 'sc004', 'LLC_BI__Loan__c', 1.01);
        nFORCE__Section_Configuration__c sectionconfig5 = createSectionConfiguration(screensection3.Id, sectionconfig4.Id, layout5.Id, 'LLC_BI__Collateral__r', 'sc005', 'LLC_BI__Loan__c', 2.01);
        nFORCE__Field_Configuration__c fieldconfig1 = createFieldConfiguration(route1.Id, screensection1.Id, 'Name', 'LLC_BI__Loan__c', '');
        nFORCE__Field_Configuration__c fieldconfig2 = createFieldConfiguration(route2.Id, screensection2.Id, 'Name', 'LLC_BI__Loan__c', '');
        
        Test.setCurrentPageReference(new PageReference('Page.UserInterfaceDeepClonePage'));
        System.currentPageReference().getParameters().put('id', group1.Id); //objectId
        
        UserInterfaceLookupKeyUtility lookupKeyContainer = new UserInterfaceLookupKeyUtility(); //for coverage of empty constructor
        //UserInterfaceDeepClone clone = new UserInterfaceDeepClone(new ApexPages.StandardController(group1));
        //clone.newGroupName ='Test New Group';
        lookupKeyContainer.assignKeys();
    }

    /**OBJECT CREATION METHODS**/

    private static nFORCE__Group__c createGroup(String n, String app, String lky)
    {
        nFORCE__Group__c newGroup = new nFORCE__Group__c(Name = n, nFORCE__App__c = app, nFORCE__lookupKey__c = lky);
        insert newGroup;
        return newGroup;
    }
    
    private static nFORCE__Route__c createRoute(String n, String app, String body, Id screen, String lky)
    {
        nFORCE__Route__c newRoute = new nFORCE__Route__c(Name = n, nFORCE__App__c = app, nFORCE__Body__c = body, nFORCE__Screen__c = screen, nFORCE__lookupKey__c = lky);
        insert newRoute;
        return newRoute;
    }
    
    private static nFORCE__Route_Group__c createRouteGroup(Id grp, Id route, Id route_group, String lky)
    {
        nFORCE__Route_Group__c newRouteGroup = new nFORCE__Route_Group__c(nFORCE__Group__c = grp, nFORCE__Route__c = route, nFORCE__Parent_Route__c = route_group, nFORCE__lookupKey__c = lky);
        insert newRouteGroup;
        return newRouteGroup;
    }
    
    private static nFORCE__Screen__c createScreen(String n, String lky)
    {
        nFORCE__Screen__c newScreen = new nFORCE__Screen__c(Name = n, nFORCE__lookupKey__c = lky);
        insert newScreen;
        return newScreen;
    }
    
    private static nFORCE__Screen_Section__c createScreenSection(String n, String sobj, String resource, Id screen, Id view, String lky)
    {
        nFORCE__Screen_Section__c newScreenSection = new nFORCE__Screen_Section__c(Name = n, nFORCE__sObject_Type__c = sobj, 
            nFORCE__Section_Resource__c = resource, nFORCE__Screen__c = screen, nFORCE__Screen_View__c = view, nFORCE__lookupKey__c = lky);
        insert newScreenSection;
        return newScreenSection;
    }
    
    private static nFORCE__View__c createView(String lky)
    {
        nFORCE__View__c newView = new nFORCE__View__c(nFORCE__lookupKey__c = lky);
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
    
    private static nFORCE__Layout__c createLayout(String nm, String genclass, String lky)
    {
        nFORCE__Layout__c newLayout = new nFORCE__Layout__c(Name = nm, nFORCE__Generator_Class__c = genclass, nFORCE__lookupKey__c = lky);
        insert newLayout;
        return newLayout;
    }
    
    private static nFORCE__Field_Configuration__c createFieldConfiguration(Id route, Id ssection, String fname, String oname, String lky)
    {
        nFORCE__Field_Configuration__c newFieldConfig = new nFORCE__Field_Configuration__c(nFORCE__Route__c = route, nFORCE__Screen_Section__c = ssection, 
            nFORCE__Field_Name__c = fname, nFORCE__sObject_Name__c = oname, nFORCE__lookupKey__c = lky);
        insert newFieldConfig;
        return newFieldConfig;
    }  
}