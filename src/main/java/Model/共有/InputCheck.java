package Model.共有;

public class InputCheck {
	public boolean checkLength(String input, boolean isName) {
		if (isName) {
			return input.length() >= 3 && input.length() <= 6;
		} else {
			return input.length() >= 3 && input.length() <= 6;
		}
	}
	
	public boolean checkAlnum(String input) {
		return input.matches("^[0-9A-Za-z\\s-]+$");
	}
	
	public boolean compareString(String input1, String input2) {
		return input1.equals(input2);
	}
}
