@isTest
private class RecalculateRelationshipStatsTest
{
    @isTest
    static void driver()
    {
        String cronExpr = '0 0 0 15 3 ? 2022';
        
        Test.startTest();
        RecalculateRelationshipStats rrs = new RecalculateRelationshipStats();
        String jobId = System.schedule('LLC_BI.RelationStatisticsBatchUpdater', cronExpr, rrs);
        rrs.execute(null);
        Test.stopTest();
    }
}