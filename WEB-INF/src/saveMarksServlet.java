import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.sql.*;
import org.json.simple.*;
public class saveMarksServlet extends HttpServlet{
    public void doGet(HttpServletRequest req,HttpServletResponse res) throws ServletException,IOException {
        res.setContentType("application/json");//setting the content type
        PrintWriter out=res.getWriter();//get the stream to write the data


        String excelData = req.getParameter("excelData");
        String coData = req.getParameter("coData");
        String subjectCode = req.getParameter("subjectCode");

        JSONObject jo = new JSONObject();
        HttpSession session = req.getSession(true);
        String ayear = (String)session.getAttribute("ayear");
        String year = (String)session.getAttribute("year");
        String department = (String)session.getAttribute("department");
        String section = (String)session.getAttribute("section");
        String assesment = (String)session.getAttribute("assesment");
        String userRole = (String)session.getAttribute("role");
        String msg = "done";
        if (userRole == null)
            userRole = "";
        if(userRole.equalsIgnoreCase("admin")){
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/course","test","test");
                //here sonoo is database name, root is username and password

                PreparedStatement stmt = con.prepareStatement("select excelData, coData from marks where subjectCode = ? and assesment = ? and section = ? and department = ? and year = ?");

                stmt.setString(1,subjectCode);
                stmt.setString(2,assesment);
                stmt.setString(3,section);
                stmt.setString(4,department);
                stmt.setString(5,year);

                ResultSet rs=stmt.executeQuery();

                if(!rs.next()){
                    stmt = con.prepareStatement("INSERT INTO marks(excelData, coData, subjectCode, assesment, section, department, year) VALUES(?, ?, ?, ?, ?, ?, ?)");
                }else{
                    stmt = con.prepareStatement("UPDATE marks set excelData = ? , coData = ? where subjectCode = ? and assesment = ? and section = ? and department = ? and year = ?");
                }

                stmt.setString(1,excelData);
                stmt.setString(2,coData);
                stmt.setString(3,subjectCode);
                stmt.setString(4,assesment);
                stmt.setString(5,section);
                stmt.setString(6,department);
                stmt.setString(7,year);


                int c = stmt.executeUpdate();
                jo.put("row changed", c);

                stmt.close();
                con.close();
            }catch(Exception e){
                msg = "error";
                jo.put("error", e.toString());
            }
        } else {
            msg = "error";
            jo.put("error","not authenticated");
        }
        jo.put("message",msg);
        out.println(jo);
        out.close();//closing the stream
    }
}
