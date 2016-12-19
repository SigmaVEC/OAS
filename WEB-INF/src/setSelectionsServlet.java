import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import org.json.simple.*;
public class setSelectionsServlet extends HttpServlet{
    public void doGet(HttpServletRequest req,HttpServletResponse res) throws ServletException,IOException {
        res.setContentType("application/json");//setting the content type
        HttpSession session = req.getSession(true);
        PrintWriter out=res.getWriter();//get the stream to write the data
        String ayear = req.getParameter("ayear");
        String year = req.getParameter("year");
        String department = req.getParameter("department");
        String section = req.getParameter("section");
        String assesment = req.getParameter("assesment");
        JSONObject jo = new JSONObject();
        try{
            session.setAttribute("ayear",ayear);
            session.setAttribute("year",year);
            session.setAttribute("department",department);
            session.setAttribute("section", section);
            session.setAttribute("assesment", assesment);
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
