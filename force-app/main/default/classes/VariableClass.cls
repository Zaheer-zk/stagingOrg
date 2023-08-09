public with sharing class VariableClass {
    Integer i3 = 20; // global variable
    public VariableClass() {
        final Integer i;
        i = 10;
        Integer i2 = 20;
        System.debug(i2);
        i2 += 10;
        System.debug(i2);
    } 
    public static void changeInVariable() {
        // i = 20 cannot be change
        // i2 = 30; // it can change but have to be global
        Integer i3 = 30; // it can change
        System.debug(i3);
    }
    }