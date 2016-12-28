import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.sql.*;
import org.json.simple.*;
import org.json.simple.parser.*;
import java.util.Iterator;
public class timetableServlet extends HttpServlet{
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

            /*
            PreparedStatement stmt = con.prepareStatement("INSERT into timetable(section, department, year, subjectcode, facultyid) values(?, ?, ?, ?, ?)");
            stmt.setString(1,section);
            stmt.setString(2,department);
            stmt.setString(3,year);


            ResultSet rs=stmt.executeQuery();

            if(!rs.next()){
                message = "Try Again";
                session.invalidate();
            }else{

                name = rs.getString(1);
                String p = rs.getString(2);
                if(p.equals(pass)){
                    jo.put("name",name);
                    String role = rs.getString(3);
                    session.setAttribute("role",role);
                    session.setAttribute("userId",userId);
                    message = "Success";
                }else {
                    message = "Try Again";
                    session.invalidate();
                }
            }
            jo.put("message",message);
            stmt.close();
            con.close();
            */

            Object obj = parser.parse(jsonData);

            JSONObject jo1 = (JSONObject) obj;

            JSONArray list = (JSONArray) jo1.get("facultyAssignment");
            /*
            String section = (String) jo1.get("section");
            String department = (String) jo1.get("department");
            String year = (String) jo1.get("year");
            */

            String year = (String)session.getAttribute("year");
            String department = (String)session.getAttribute("department");
            String section = (String)session.getAttribute("section");

            //data={"section":"A","department":"CSE","year":"II","facultyAssignment":[{"courseCode":"cs6501","facultyId":"fc123"}]}
            PreparedStatement stmt2 = con.prepareStatement("delete from timetable where section = ? and department = ? and year =? and subjectcode = ?");
            PreparedStatement stmt = con.prepareStatement("INSERT into timetable(section, department, year, subjectcode, facultyid, courseName) values(?, ?, ?, ?, ?, ?)");
            stmt.setString(1,section);
            stmt.setString(2,department);
            stmt.setString(3,year);

            stmt2.setString(1,section);
            stmt2.setString(2,department);
            stmt2.setString(3,year);

            JSONArray ar = new JSONArray();
            Iterator<JSONObject> iterator = list.iterator();
            while (iterator.hasNext()) {

                JSONObject t = iterator.next();
                JSONObject temp = new JSONObject();
                stmt2.setString(4, (String)t.get("courseCode"));
                stmt2.executeUpdate();

                stmt.setString(4, (String)t.get("courseCode"));
                stmt.setString(5, (String)t.get("facultyId"));
                stmt.setString(6, (String)t.get("courseName"));
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
