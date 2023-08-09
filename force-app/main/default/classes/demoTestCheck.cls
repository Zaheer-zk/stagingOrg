public class demoTestCheck {
	
    public static void demoM() {
        Contact c = [Select Name,Email From Contact];
        System.debug('c' + c);
    }
}