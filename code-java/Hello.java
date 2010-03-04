public class Hello {
	public static void main(String[] args) {
		Bicycle b1 = new Bicycle(80,10,1);
		Bicycle b2 = new Bicycle(70,0,1);
		System.out.println(b1.getID());
		System.out.println(b2.getID());
		//System.out.println(Bicycle.numberOfBicycles);
	}
}