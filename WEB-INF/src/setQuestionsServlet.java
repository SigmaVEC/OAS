import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.sql.*;
import org.json.simple.*;
import org.json.simple.parser.*;
public class setQuestionsServlet extends HttpServlet{
    public void doGet(HttpServletRequest req,HttpServletResponse res) throws ServletException,IOException {
        res.setContentType("application/json");//setting the content type
        HttpSession session = req.getSession(true);
        PrintWriter out=res.getWriter();//get the stream to write the data
        String jsonData = req.getParameter("data");

        JSONObject jo = new JSONObject();
        JSONParser parser = new JSONParser();
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/course","test","test");

            Object obj = parser.parse(jsonData);
            JSONObject jo1 = (JSONObject) obj;

            JSONArray list = (JSONArray) jo1.get("questions");
            String subjectCode = (String) jo1.get("subjectCode");
            String section = (String) jo1.get("section");
            String department = (String) jo1.get("department");
            String year = (String) jo1.get("year");
            //?data={"subjectCode":"cs6545","section":"A","department":"CSE","year":"III","questions":[{"qno":"1","co":"co2","mark":16}]}
            PreparedStatement stmt = con.prepareStatement("INSERT into questions(subjectCode, section, department, year, questions) values(?, ?, ?, ?, ?)");
            stmt.setString(1, subjectCode);
            stmt.setString(2, section);
            stmt.setString(3, department);
            stmt.setString(4, year);

            JSONObject q = new JSONObject();
            q.put("questions", list);

            stmt.setString(5, q.toString());

            stmt.executeUpdate();

        }catch(Exception e){
            jo.put("error",e.toString());
        }
        //writing html in the stream
        out.println(jo);

        out.close();//closing the stream
    }
}