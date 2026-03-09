package Message;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Element;
import java.io.File;
import java.util.HashMap;

public class DisplayMessage {
    public static String getMessageData(String messageCode, String[] param) {
    	String messageText = "isMsg";
        try {
        	File file = new File("Message.xml");
            DocumentBuilder dBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
            Document doc = dBuilder.parse(file);
            doc.getDocumentElement().normalize();

            NodeList nList = doc.getElementsByTagName("Message");

            for (int i = 0; i < nList.getLength(); i++) {
                Element e = (Element) nList.item(i);
                
                if (e.getAttribute("code").equals(messageCode)) {
                	messageText = e.getAttribute("text");
                	break;
                }
            }
            
            if (param != null) {
            	messageText.replace("[NAME]", param[0]);
            	messageText.replace("[YEAR]", param[1]);
            	messageText.replace("[MONTH]", param[2]);
            	messageText.replace("[AMOUNT]", param[3]);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return messageText;
    }
}