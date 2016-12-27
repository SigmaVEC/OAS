import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.sql.*;
import org.json.simple.*;
import org.json.simple.parser.*;
import java.util.Iterator;
public class coDetailsServlet extends HttpServlet{
    public void doGet(HttpServletRequest req,HttpServletResponse res) throws ServletException,IOException {
        res.setContentType("application/json");//setting the content type
        HttpSession session = req.getSession(true);
        PrintWriter out=res.getWriter();//get the stream to write the data
        String jsonData = req.getParameter("data");

        JSONObject jo = new JSONObject();
        JSONParser parser = new JSONParser();
        String msg = "done";
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/course","test","test");

            Object obj = parser.parse(jsonData);
            JSONObject jo1 = (JSONObject) obj;

            JSONArray list = (JSONArray) jo1.get("coDetails");
            String subjectCode = (String) jo1.get("subjectCode");
            //?data={"subjectCode":"cs6545","coDetails":[{"cono":"co1","description":"co1 inplace","threshold":80,"target":70},{"cono":"co2","description":"co2 inplace","threshold":82,"target":72}]}
            PreparedStatement stmt = con.prepareStatement("INSERT into CODetails(subjectCode, cono, description, threshold, target) values(?, ?, ?, ?, ?)");
            stmt.setString(1,subjectCode);
            JSONArray ar = new JSONArray();
            Iterator<JSONObject> iterator = list.iterator();
            while (iterator.hasNext()) {

                JSONObject t = iterator.next();
                JSONObject temp = new JSONObject();
                stmt.setString(2, (String)t.get("cono"));
                stmt.setString(3, (String)t.get("description"));
                stmt.setInt(4, ((Long)t.get("threshold")).intValue());
                stmt.setInt(5, ((Long)t.get("target")).intValue());
                stmt.executeUpdate();
            }

        }catch(Exception e){
            msg = "try again";
            jo.put("error",e.toString());
        }
        jo.put("message",msg);
        //writing html in the stream
        out.println(jo);

        out.close();//closing the stream
    }
}
