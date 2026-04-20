package proyectodsl;

import java_cup.runtime.Symbol;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;

%%

%public
%class AnalisisLexico
%cupsym Simbolo
%cup
%unicode
%line
%column

digito      = [0-9]
letra       = [a-zA-Z]
id          = ({letra}|_)(({letra}|_)|{digito})*
interfaz    = {letra}({letra}|{digito}|/)*
ip          = {digito}+"."{digito}+"."{digito}+"."{digito}+"/"{digito}+
espacio     = (" "|\r|\n|\t|\f)+

%{

ComplexSymbolFactory symbolFactory;

public void setSymbolFactory(ComplexSymbolFactory sf){
    symbolFactory = sf;
}

private Symbol symbol(String name, int sym){
    return symbolFactory.newSymbol(
        name,
        sym,
        new Location(yyline+1, yycolumn+1, yychar),
        new Location(yyline+1, yycolumn+yylength(), yychar+yylength())
    );
}

private Symbol symbol(String name, int sym, Object val){
    Location left = new Location(yyline+1, yycolumn+1, yychar);
    Location right = new Location(yyline+1, yycolumn+yylength(), yychar+yylength());

    return symbolFactory.newSymbol(name, sym, left, right, val);
}

private void error(String message){
    System.out.println(
        "Error léxico en línea " + (yyline+1) +
        ", columna " + (yycolumn+1) +
        ": " + message
    );
}

%}

%eofval{
return symbolFactory.newSymbol(
    "EOF",
    Simbolo.EOF,
    new Location(yyline+1, yycolumn+1, yychar),
    new Location(yyline+1, yycolumn+1, yychar+1)
);
%eofval}

%%

<YYINITIAL>{

    /* símbolos */
    ";"     { return symbol("PUNTO_COMA", Simbolo.PUNTO_COMA); }
    "{"     { return symbol("LLAVE_ABIERTA", Simbolo.LLAVE_ABIERTA); }
    "}"     { return symbol("LLAVE_CERRADA", Simbolo.LLAVE_CERRADA); }
    "."     { return symbol("PUNTO", Simbolo.PUNTO); }
    "->"    { return symbol("FLECHA", Simbolo.FLECHA); }

    /* palabras reservadas */
    "red"           { return symbol("RED", Simbolo.RED); }
    "router"        { return symbol("ROUTER", Simbolo.ROUTER); }
    "firewall"      { return symbol("FIREWALL", Simbolo.FIREWALL); }
    "switch"        { return symbol("SWITCH", Simbolo.SWITCH); }
    "switchL3"      { return symbol("SWITCHL3", Simbolo.SWITCHL3); }
    "server"        { return symbol("SERVER", Simbolo.SERVER); }
    "pc"            { return symbol("PC", Simbolo.PC); }
    "laptop"        { return symbol("LAPTOP", Simbolo.LAPTOP); }
    "mobile"        { return symbol("MOBILE", Simbolo.MOBILE); }
    "accesspoint"   { return symbol("ACCESSPOINT", Simbolo.ACCESSPOINT); }
    "internet"      { return symbol("INTERNET", Simbolo.INTERNET); }

    "interfaz"      { return symbol("INTERFAZ", Simbolo.INTERFAZ); }
    "ip"            { return symbol("IP", Simbolo.IP); }
    "tipo"          { return symbol("TIPO", Simbolo.TIPO); }
    "conectar"      { return symbol("CONECTAR", Simbolo.CONECTAR); }

    /* tokens especiales */
    {ip}            { return symbol("DIRECCION_IP", Simbolo.DIRECCION_IP, yytext()); }

    /* identificadores */
    {id}            { return symbol("ID", Simbolo.ID, yytext()); }

    /* interfaces */
    {interfaz}      { return symbol("NOMBRE_INTERFAZ", Simbolo.NOMBRE_INTERFAZ, yytext()); }

    /* cadenas opcionales */
    [\"] ~[\"] {
        String t = yytext();
        return symbol("CADENA", Simbolo.CADENA, t.substring(1, t.length()-1));
    }

    /* comentarios */
    "/*" ~"*/"      { }

    /* espacios */
    {espacio}       { }

    /* error */
    .               { error(yytext()); }

}