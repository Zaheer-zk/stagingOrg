public class FlowDebugLoggerForCollection {
    
    @InvocableMethod(label='Log Debug Message for collections' description='Outputs messages to the debug log for collections')
    public static void trace (List<List<String>> listofDebugMessages) {
        
        for(List<String> debugMessages : listofDebugMessages)
        	for (String debugMessage : debugMessages)
    			system.debug( '@@@@@' + debugMessage);
    }
}