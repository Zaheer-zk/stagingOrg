public class PatternPrinting {
    public static void printPattern(){
        //System.debug('Pattern ='+pattern);
        for(integer i=1;i<5;++i){
            String pattern='';
            for (integer j = 1; j <= i; ++j) {
                pattern+=j; 
            }
            pattern+='\n';   
            System.debug(pattern);
        }
    }
}