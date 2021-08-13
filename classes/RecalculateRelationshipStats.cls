public class RecalculateRelationshipStats implements Schedulable{
    public void execute(SchedulableContext context){
            Database.executeBatch(new LLC_BI.RelationStatisticsBatchUpdater(null), 200);
        }
}