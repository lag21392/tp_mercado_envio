using System;
using System.Collections.Generic;
using System.Windows.Forms;
using System.Linq;
using System.Text;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Drawing;
using mercado_envio.Conexion;

namespace mercado_envio.Login
{

    public struct Persona
    {

        public string nombre, estado, apellido, id_cliente, id_user, id_estado;

        public Persona(string p1, string p2, string p3, string p4, string p5, string p6)
        {
            id_user = p1;
            nombre = p2;
            apellido = p3;
            estado = p4;
            id_cliente = p5;
            id_estado = p6;
        }
        public bool esAdministrador()
        {
            return !(this.id_cliente.Length > 0);
        }
    }
    
    

    public class Pass
    {

        public string encriptar_SHA256(string texto)
        {
            SHA256 sha256 = SHA256CryptoServiceProvider.Create();
            byte[] textOriginal = ASCIIEncoding.Default.GetBytes(texto);
            byte[] hash = sha256.ComputeHash(textOriginal);
            StringBuilder cadena = new StringBuilder();
            foreach (byte i in hash)
            {
                cadena.AppendFormat("{0:x2}", i);
            }
            return cadena.ToString();
        }

        public DataSet validar_contraseña(string usuario, string contraseña)
        {
            DataSet ds;
            //Pass obj_contraseña = new Pass();
            BaseDatos con = new BaseDatos();
            string consulta;


            consulta = String.Format("SELECT Usuario_Usuario,Usuario_Contraseña,Usuario_Estado FROM THE_AVENGERS.Usuario WHERE (Usuario_Usuario ='{0}')", usuario);
            ds = con.realizar_consulta(consulta);

            if (ds != null)
            {  // agregar la parte del campo i

                if ((ds.Tables[0].Rows[0][1].ToString() == usuario) & (ds.Tables[0].Rows[0][2].ToString() == this.encriptar_SHA256(contraseña))) return (ds);
                else return null;

            }
            return ds;
        }
    }


    class Usuario
    {


        string id_cliente = null;
        string id_usuario = null;

        public string usuario()
        {

            return id_usuario;
        }

        public string cliente()
        {

            return id_cliente;
        }
        public string incrementar(string valor1)
        {
            if (valor1 != "") return ((Convert.ToInt32(valor1) + 1).ToString());//Convert.ToString(resultado);
            else return valor1;
        }
        public Persona inicializar()
        {
            Persona cliente;
            cliente.id_user = "";
            cliente.nombre = "";
            cliente.estado = "";
            cliente.apellido = "";
            cliente.id_cliente = "";
            cliente.id_estado = "";
            return cliente;

        }
        public Persona validar_usuario(string usuario, string pass)
        {
            DataSet ds;
            BaseDatos consulta = new BaseDatos();
            Pass obj_contraseña = new Pass();
            Persona cliente = this.inicializar();
            string aux;

            string query;
            query = "SELECT                                                 " +
                    "        Usuario_Contraseña,                            " +
                    "        Usuario_Usuario,                               " +
                    "        Usuario_Estado,                                " +
                    "        isnull((SELECT top 1 isnull(numero_intento,0)  " +
                    "            FROM THE_AVENGERS.Ingresos                 " +
                    "            WHERE Usuario_Usuario = '" + usuario + "'  " +
                    "            ORDER BY numero_ingreso DESC               " +
                    "        ) ,0) ro                                       " +
                    "FROM THE_AVENGERS.Usuario                               " +
                    "WHERE Usuario_Usuario = '"+ usuario +"'               ";

            ds = consulta.consultar(query);
            if (ds != null && usuario == ds.Tables[0].Rows[0][1].ToString() && ds.Tables[0].Rows[0][2].ToString() == "1")
            {
                 
                if (ds.Tables[0].Rows[0][0].ToString() == obj_contraseña.encriptar_SHA256(pass))
                {// aca se resetea los contadores de intentos
                    consulta.insertar("INSERT INTO THE_AVENGERS.Ingresos " +
                                       "(fecha,Usuario_Usuario,numero_intento,sesion_correcta) " +
                                       "VALUES (CONVERT(date,GETDATE()),'" + usuario + "','0','c')");
                    cliente.id_user = ds.Tables[0].Rows[0][1].ToString();
                   
                    return cliente;
                }
                else
                {


                    if (Convert.ToInt32(ds.Tables[0].Rows[0][3].ToString()) >= 2)
                    {
                        consulta.insertar("UPDATE THE_AVENGERS.Usuario SET Usuario_Estado =3 where Usuario_Usuario ='" + usuario + "'");
                        MessageBox.Show("La cuenta se ha deshabilitado, se superaron la cantidad de reintentos permitodos\nSolo un administrador puede rehabilitar la cuenta", "Login", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                    else
                    {
                        MessageBox.Show("contraseña no valida");
                    }

                    aux = this.incrementar(ds.Tables[0].Rows[0][3].ToString());
                    // se pregunta que intento fue si tiena mas de 2 se desabilita el usuario
                    consulta.insertar("INSERT INTO THE_AVENGERS.Ingresos " +
                                       "(fecha,Usuario_Usuario,numero_intento,sesion_correcta) " +
                                       "VALUES (CONVERT(date,GETDATE()),'" + usuario + "','" + aux + "','f')");
                    return cliente;
                }// contraseña no valida 
            }
            else { MessageBox.Show("usuario no valido o deshabilitado"); return cliente; }// usuario no valido, aca no se cuenta en la tabla auditoria
        }
    }
}

