package proyectodsl;
import java.util.HashMap;

public class ListaVariables {
    public HashMap<String,Variable> var = new HashMap<String,Variable>();
    public ListaVariables(){}
    public Variable buscar(String nombre){
        return var.get(nombre);
    }

    public void agregar(Variable v){
        var.put(v.nombre, v);
    }
    
}
