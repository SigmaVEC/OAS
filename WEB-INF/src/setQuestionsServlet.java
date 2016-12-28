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
        String msg = "done";
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/course","test","test");

            Object obj = parser.parse(jsonData);
            JSONObject jo1 = (JSONObject) obj;

            JSONArray list = (JSONArray) jo1.get("questions");
            String subjectCode = (String) jo1.get("subjectCode");
            /*String section = (String) jo1.get("section");
            String department = (String) jo1.get("department");
            String year = (String) jo1.get("year");
            String assesment = (String) jo1.get("assesment");*/
            String year = (String)session.getAttribute("year");
            String department = (String)session.getAttribute("department");
            String section = (String)session.getAttribute("section");
            String assesment = (String)session.getAttribute("assesment");
            //?data={"subjectCode":"cs6545","assesment":"CT1","section":"A","department":"CSE","year":"III","questions":[{"qno":"1","co":"co2","mark":16}]}
            PreparedStatement stmt = con.prepareStatement("select * from questions where subjectCode = ? and assesment = ? and section = ? and department = ? and year = ?");
            stmt.setString(1, subjectCode);
            stmt.setString(2, assesment);
            stmt.setString(3, section);
            stmt.setString(4, department);
            stmt.setString(5, year);

            ResultSet rs=stmt.executeQuery();
            if(rs.next()){
                stmt = con.prepareStatement("DELETE from questions where subjectCode = ? and assesment = ? and section = ? and department = ? and year = ?");
                stmt.setString(1, subjectCode);
                stmt.setString(2, assesment);
                stmt.setString(3, section);
                stmt.setString(4, department);
                stmt.setString(5, year);

                stmt.executeUpdate();
            }

            stmt = con.prepareStatement("INSERT into questions(subjectCode, assesment, section, department, year, questions) values(?, ?, ?, ?, ?, ?)");
            stmt.setString(1, subjectCode);
            stmt.setString(2, assesment);
            stmt.setString(3, section);
            stmt.setString(4, department);
            stmt.setString(5, year);

            JSONObject q = new JSONObject();
            q.put("questions", list);

            stmt.setString(6, q.toString());

            stmt.executeUpdate();

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
