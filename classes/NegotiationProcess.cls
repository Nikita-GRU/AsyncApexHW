/**
 * Created by JJ93 on 11.09.2020.
 */

public class NegotiationProcess {
    @InvocableMethod(Label='New Task to new Account')
    public static void newTaskToNewAccount(List<AccountToTask> accounts) {
        for (AccountToTask accountToTask : accounts) {
            if (isTaskCountLessThanThree(accountToTask)) {
                insert generateNewTask(accountToTask);
            } else {
                reassignTasks(accountToTask, getRandomUserId());
            }

        }
    }

    private static Id getRandomUserId() {
        List<User> activeUsers = [SELECT Id FROM User WHERE IsActive = TRUE];
        Integer randomUserIndex = Math.round(Math.random()*(activeUsers.size()-1));
        return activeUsers[randomUserIndex].Id;
    }

    private static void reassignTasks(AccountToTask accountToTask, Id newOwnerId) {
        Id accountId = accountToTask.accountId;
        List<Task> tasksToReassign = [SELECT Id FROM Task WHERE WhatId = :accountId];
        for (Task task : tasksToReassign) {
            task.OwnerId = newOwnerId;
        }
        update tasksToReassign;

    }

    private static Boolean isTaskCountLessThanThree(AccountToTask accountToTask) {
        Id accountId = accountToTask.accountId;
        if ([SELECT COUNT() FROM Task WHERE WhatId = :accountId] >= 3) {
            return false;
        } else {
            return true;
        }

    }

    private static Task generateNewTask(AccountToTask accountToTask) {
        Task newTask = new Task();
        newTask.WhatId = accountToTask.accountId;
        newTask.Subject = 'Negotiations with ' + accountToTask.accountName;
        return newTask;

    }
    public class AccountToTask {
        @InvocableVariable(Label='Account ID' Required=true)
        public Id accountId;
        @InvocableVariable(Label='Account Name' Required=true)
        public String accountName;
    }
}