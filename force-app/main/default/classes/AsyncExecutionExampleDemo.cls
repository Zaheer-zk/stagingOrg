public class AsyncExecutionExampleDemo implements System.Queueable {
    public void execute(QueueableContext context) {
        Account a = new Account(Name='Zaheer',Phone='(000) 000-1212');
        insert a;
        system.debug('Currently im in AsyncExecutionExampleDemo');
    }
}