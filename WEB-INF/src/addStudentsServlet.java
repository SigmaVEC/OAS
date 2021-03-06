import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.sql.*;
import org.json.simple.*;
import org.json.simple.parser.*;
import java.util.Iterator;
public class addStudentsServlet extends HttpServlet{
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

            JSONArray list = (JSONArray) jo1.get("data");
            //String section = (String) jo1.get("section");
            //String department = (String) jo1.get("department");
            //String year = (String) jo1.get("year");

            //changes to input only data needed
            //?data={"section":"A","department":"CSE","year":"III","data":[{"sid":"1","name":"name1"},{"sid":"2","name":"name2"}]}
            String department = (String)session.getAttribute("department");
            String section = (String)session.getAttribute("section");
            String year = (String)session.getAttribute("year");
            PreparedStatement stmt = con.prepareStatement("DELETE from students where section = ? and department = ?and year = ?");

            stmt.setString(1, section);
            stmt.setString(2, department);
            stmt.setString(3, year);
            stmt.executeUpdate();
            stmt = con.prepareStatement("INSERT into students(sid, name, section, department, year) values(?, ?, ?, ?, ?)");

            stmt.setString(3, section);
            stmt.setString(4, department);
            stmt.setString(5, year);


            Iterator<JSONObject> iterator = list.iterator();
            while (iterator.hasNext()) {
                JSONObject t = iterator.next();
                String sid = (String)t.get("sid");
                String name = (String)t.get("name");
                stmt.setString(1, sid);
                stmt.setString(2, name);
                if(sid != null && name != null)
                    stmt.executeUpdate();
            }

        }catch(Exception e){
            msg = "error";
            jo.put("error",e.toString());
        }
        //writing html in the stream
        jo.put("message",msg);
        out.println(jo);

        out.close();//closing the stream
    }
}
