/**
 * Created by JJ93 on 13.09.2020.
 */

public with sharing class SchedulerPractice implements Schedulable {
    public void execute(SchedulableContext context) {
        Database.executeBatch(new BatchIterablePractice());
        Database.executeBatch(new BatchQueryLocatorPractice());
    }


}