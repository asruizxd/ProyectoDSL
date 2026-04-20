package proyectodsl;


import java.util.ArrayList;
import java.util.List;

public class Nodo {
      public String valor;
    public List<Nodo> hijos;
    
    public Nodo(String valor) {
        this.valor = valor;
        this.hijos = new ArrayList<>();
    }
    
    // Constructor alternativo para crear nodos con hijos directamente
    public Nodo(String valor, Nodo... hijos) {
        this.valor = valor;
        this.hijos = new ArrayList<>();
        for (Nodo hijo : hijos) {
            this.hijos.add(hijo);
        }
    }
}
