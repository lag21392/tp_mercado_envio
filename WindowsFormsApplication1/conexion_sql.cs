using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Net.NetworkInformation;
using System.Windows.Forms;

namespace mercado_envio.Conexion
{

    class BaseDatos
    {
        string cadenaConexion = ConfigurationSettings.AppSettings["cadena_conexion"];


        public DataSet realizar_consulta(string consulta)
        {
            DataSet ds = new DataSet();
            SqlConnection conexion = new SqlConnection(cadenaConexion);
            try
            {
                conexion.Open();
                SqlCommand comando = new SqlCommand(consulta, conexion);

                SqlDataAdapter da = new SqlDataAdapter(comando);

                if (ds.Tables[0].Rows.Count == 0) return null;

                da.Fill(ds);


            }
            catch
            {
                ds = null;
            }
            finally
            {
                conexion.Close();
            }
            return ds;

        }
        public DataSet consultar(string consulta)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conexion = new SqlConnection(cadenaConexion))
            {
                try
                {
                    conexion.Open();
                    SqlCommand comando = new SqlCommand(consulta, conexion);
                    SqlDataAdapter da = new SqlDataAdapter(comando);

                    da.Fill(ds);
                    if (ds.Tables[0].Rows.Count == 0) { conexion.Close(); return null; }
                }
                catch
                {
                    ds = null;
                    conexion.Close();
                }
                finally
                {
                    conexion.Close();
                }
                return ds;
            }
        }



        public bool insertar(string consulta)
        {
            DataSet dataset = new DataSet();
            System.Data.SqlClient.SqlConnection conexion = new SqlConnection(cadenaConexion);
            try
            {
                SqlCommand comando = new SqlCommand();
                comando.CommandType = System.Data.CommandType.Text;
                comando.CommandText = consulta;
                comando.Connection = conexion;
                conexion.Open();
                comando.ExecuteNonQuery();
            }
            catch
            {
                conexion.Close();
                MessageBox.Show("error en la carga del registro o los campos cargados son incorrectos, intente de nuevo");
                return false;
            }
            finally
            {
                conexion.Close();

            }
            return true;
        }



    }
    public class Sql_comandos
    {
        string string_conexion;


        public SqlConnection establecer_conexion()
        {
            System.Data.SqlClient.SqlConnection conexion_sql = new System.Data.SqlClient.SqlConnection(string_conexion);
            try
            {
                conexion_sql.Open();
            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message);
            }

            return conexion_sql;
        }

        // metodos con conexion 
        // devuelve un dataread. cuando hace un select y devuelve mas de una valor
        public SqlDataReader consultar(string comando)
        {

            SqlConnection conn = establecer_conexion();
            SqlDataReader dr = null;
            try
            {
                SqlCommand cmd = new SqlCommand(comando, conn);
                dr = cmd.ExecuteReader();
                //int resultado = Convert.ToInt32(dr[0]);
            }

            catch (Exception error)
            {
                conn.Close();
                MessageBox.Show(error.Message);

            }
            finally
            {
                conn.Close();

            }
            return dr;
        }
        // borra y devuelve las filas afectadas
        public int borrar(string comando)
        {

            SqlConnection conn = establecer_conexion();
            int resultado = 0;
            try
            {
                SqlCommand cmd = new SqlCommand(comando, conn);
                resultado = cmd.ExecuteNonQuery();
            }

            catch (Exception error)
            {
                conn.Close();
                MessageBox.Show(error.Message);

            }
            finally
            {
                conn.Close();
            }
            return resultado;


        }

        // metodos que no devuelve ningun dato, puede ser insert, update, borrar
        public SqlDataReader ejecutar_comando(string comando)
        {

            SqlConnection conn = establecer_conexion();
            SqlDataReader dr = null;
            try
            {
                SqlCommand cmd = new SqlCommand(comando, conn);
                cmd.ExecuteNonQuery();
                //int resultado = Convert.ToInt32(dr[0]);
            }

            catch (Exception error)
            {
                conn.Close();
                MessageBox.Show(error.Message);

            }
            finally
            {
                conn.Close();

            }
            return dr;
        }


        /*

        // ejecutar un stored procedure
        public bool ejecutar_strp_no_query(string nombre_stored, string nombre_parametro, string valor)
        {
            SqlConnection conn = establecer_conexion();
            try
            {
                SqlCommand cmd = new SqlCommand(nombre_stored, conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue(nombre_parametro, valor);
                cmd.ExecuteNonQuery();// cuando no devuelve ningun valor
            }

            catch (Exception error)
            {
                conn.Close();
                MessageBox.Show(error.Message);
                return false;
            }
            finally
            {

                conn.Close();

            }
            return true;
        }

        // -----------------------------------------metodos que funcionan sin  conexion
        // -----------------------------------------metodo para consultar y devuelde un dataset
        public DataSet consultar(string comando)
        {
            SqlConnection conn = establecer_conexion();
            SqlCommand cmd = new SqlCommand(comando, conn);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();

            try
            {

                da.Fill(ds, "nombre de la tabla");
                // mostrar la informacion obtenida
                /* dataGridView1.dataSource = ds;
           
                */
          /*  }
            catch (Exception error)
            {
                MessageBox.Show(error.Message);
                return null;

            }
            conn.Close();
            return ds;
        }*/

        public bool actualizar(string query, DataSet ds)
        {
            SqlConnection conn = establecer_conexion();
            SqlCommand cmd = new SqlCommand(query, conn);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            SqlCommandBuilder cb = new SqlCommandBuilder(da);

            try
            {
                //DataSet ds = (DataGridView.DataSource as DataSet);
                da.Update(ds, "nombre de la tabla");

            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message);
                return false;
            }

            finally
            {
                conn.Close();
            }
            return true;
        }

    }



}
