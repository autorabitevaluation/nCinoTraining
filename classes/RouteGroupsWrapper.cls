public class RouteGroupsWrapper
{
    public Boolean checked{ get; set; }
    public nFORCE__Route_Group__c rtgrp { get; set; }

    public RouteGroupsWrapper()
    {
        rtgrp = new nFORCE__Route_Group__c();
        checked = false;
    }
    
    public RouteGroupsWrapper(nFORCE__Route_Group__c rg)
    {
        rtgrp = rg;
        checked = false;
    }
}