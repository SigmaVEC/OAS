import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import org.json.simple.*;
public class getSelectionsServlet extends HttpServlet{
    public void doGet(HttpServletRequest req,HttpServletResponse res) throws ServletException,IOException {
        res.setContentType("application/json");//setting the content type
        HttpSession session = req.getSession(true);

        PrintWriter out=res.getWriter();//get the stream to write the data
        String ayear = (String)session.getAttribute("ayear");
        String year = (String)session.getAttribute("year");
        String department = (String)session.getAttribute("department");
        String section = (String)session.getAttribute("section");
        String assesment = (String)session.getAttribute("assesment");
        JSONObject jo = new JSONObject();
        try{
            jo.put("ayear",ayear);
            jo.put("year",year);
            jo.put("department",department);
            jo.put("section",section);
            jo.put("assesment",assesment);

            jo.put("message","done");
        }catch(Exception e){
            String s = e.toString();
            jo.put("message","error");
            jo.put("error",e.toString());
        }
        //writing html in the stream
        out.println(jo);

        out.close();//closing the stream
    }
}
