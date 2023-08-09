public class TestClassLoop {
    public void myMethod() {
        List<integer> lAns = new List<integer>();
        integer n = 5;
        boolean flag = true;
        for(integer i=0;i<n;i++) {
            for(integer j=0;j<i;j++) {
                if(flag==true) {
                    lAns.add(1);
                    flag = false;
                }
                else {
                    lAns.add(0);
                    flag = true;
                }
            }   
            system.debug(lAns);
        }
    }
}